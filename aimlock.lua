-- ============================================
-- 🎯 NANDA×ZORX AIMLOCK (TSB FINAL — TIDAK SENTUH SKILL/ULTIMATE)
-- + STOP FUNCTION (bisa di-OFF dari UI ZORX HUB)
-- ============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- ===== STATE =====
_G.ZorxAimlockRunning = true
_G.ZorxAimlockOn = true
_G.ZorxAimlockLocked = false
_G.ZorxAimlockTarget = nil

local aimlockOn = false
local lockTarget = nil
local bodyOutline = nil
local lastTP = 0
local TP_COOLDOWN = 0.8
local TP_DISTANCE = 3.5
local DEBUG = true

local renderConn = nil
local connections = {}

-- ===== OUTLINE =====
local function removeOutline()
    if bodyOutline then
        bodyOutline:Destroy()
        bodyOutline = nil
    end
end

local function applyOutline(character)
    if not character then return end
    if bodyOutline and bodyOutline.Adornee == character then return end
    if bodyOutline then bodyOutline:Destroy() end

    local hl = Instance.new("Highlight")
    hl.Name = "ZorxOutline"
    hl.Adornee = character
    hl.FillTransparency = 1
    hl.OutlineColor = Color3.fromRGB(255, 0, 0)
    hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent = character

    bodyOutline = hl
end

-- ===== DETEKSI BLOCK ASLI — TIDAK SENTUH SKILL/ULTIMATE =====
local function checkRealBlock(character)
    if not character then return false, "no-char" end

    local hum = character:FindFirstChildOfClass("Humanoid")
    if not hum then return false, "no-hum" end

    local BLOCK_ATTRS = {
        "Blocking",
        "IsBlocking",
        "Blocked",
        "IsBlocked",
        "IsGuarding",
        "GuardActive"
    }
    for _, attr in ipairs(BLOCK_ATTRS) do
        local ok, val = pcall(function() return hum:GetAttribute(attr) end)
        if ok and val == true then return true, "HumAttr:"..attr end
        
        local ok2, val2 = pcall(function() return character:GetAttribute(attr) end)
        if ok2 and val2 == true then return true, "CharAttr:"..attr end
    end

    local function scanBool(parent, tag)
        if not parent then return nil end
        for _, child in ipairs(parent:GetChildren()) do
            if child:IsA("BoolValue") and child.Value == true then
                local n = child.Name
                if n == "Blocking" or n == "IsBlocking" or n == "Blocked"
                    or n == "IsBlocked" or n == "IsGuarding"
                    or n == "GuardActive" then
                    return tag..":"..n
                end
            end
        end
        return nil
    end

    local r1 = scanBool(character, "BoolChar")
    if r1 then return true, r1 end
    local r2 = scanBool(hum, "BoolHum")
    if r2 then return true, r2 end

    local hasForceField = character:FindFirstChildOfClass("ForceField") 
                        or hum:FindFirstChildOfClass("ForceField")
    
    if hasForceField then
        local hasBlockAttr = false
        for _, attr in ipairs(BLOCK_ATTRS) do
            local ok, val = pcall(function() return hum:GetAttribute(attr) end)
            if ok and val == true then hasBlockAttr = true break end
            local ok2, val2 = pcall(function() return character:GetAttribute(attr) end)
            if ok2 and val2 == true then hasBlockAttr = true break end
        end
        if hasBlockAttr then
            return true, "ForceField+Attr"
        end
        return false, "Skill-FF-Ignored"
    end

    return false, "none"
end

-- ===== TELEPORT KE BELAKANG =====
local function teleportBehind(targetChar)
    local myChar = player.Character
    if not myChar then return end

    local myHRP = myChar:FindFirstChild("HumanoidRootPart")
    local tgtHRP = targetChar:FindFirstChild("HumanoidRootPart")
    if not myHRP or not tgtHRP then return end

    local targetLook = tgtHRP.CFrame.LookVector
    local behindPos = tgtHRP.Position - targetLook * TP_DISTANCE
    behindPos = Vector3.new(behindPos.X, tgtHRP.Position.Y, behindPos.Z)

    local newCF = CFrame.lookAt(behindPos, tgtHRP.Position)

    pcall(function()
        myHRP.AssemblyLinearVelocity = Vector3.zero
        myHRP.AssemblyAngularVelocity = Vector3.zero
        myHRP.Velocity = Vector3.zero
    end)

    pcall(function()
        myChar:PivotTo(newCF)
    end)

    pcall(function()
        myHRP.AssemblyLinearVelocity = Vector3.zero
        myHRP.AssemblyAngularVelocity = Vector3.zero
    end)
end

-- ===== CARI TARGET =====
local function getTargetUnderCursor()
    local closest = nil
    local shortest = math.huge
    local center = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= player and v.Character then
            local hrp = v.Character:FindFirstChild("HumanoidRootPart")
            local hum = v.Character:FindFirstChild("Humanoid")
            if hrp and hum and hum.Health > 0 then
                local pos, visible = camera:WorldToViewportPoint(hrp.Position)
                if visible and pos.Z > 0 then
                    local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if dist < shortest then
                        shortest = dist
                        closest = hrp
                    end
                end
            end
        end
    end
    return closest
end

-- ===== GUI =====
local aimGui = Instance.new("ScreenGui")
aimGui.Name = "NzkAimlock"
aimGui.ResetOnSpawn = false
aimGui.Parent = game.CoreGui

local aimContainer = Instance.new("Frame", aimGui)
aimContainer.Size = UDim2.new(0, 140, 0, 45)
aimContainer.Position = UDim2.new(1, -150, 0, 15)
aimContainer.BackgroundTransparency = 1

local aimlockBtn = Instance.new("TextButton", aimContainer)
aimlockBtn.Size = UDim2.new(0, 100, 1, 0)
aimlockBtn.Text = "AIM: OFF"
aimlockBtn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
aimlockBtn.TextColor3 = Color3.new(1, 1, 1)
aimlockBtn.Font = Enum.Font.GothamBold
aimlockBtn.TextSize = 14
Instance.new("UICorner", aimlockBtn)
Instance.new("UIStroke", aimlockBtn).Color = Color3.fromRGB(200, 0, 0)

local aimToggle = Instance.new("TextButton", aimContainer)
aimToggle.Size = UDim2.new(0, 35, 0, 35)
aimToggle.Position = UDim2.new(0, 105, 0, 5)
aimToggle.Text = "▢"
aimToggle.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
aimToggle.TextColor3 = Color3.new(1, 1, 1)
aimToggle.Font = Enum.Font.GothamBold
Instance.new("UICorner", aimToggle)
Instance.new("UIStroke", aimToggle).Color = Color3.fromRGB(200, 0, 0)

local toggleConn = aimToggle.MouseButton1Click:Connect(function()
    aimlockBtn.Visible = not aimlockBtn.Visible
    aimToggle.Text = aimlockBtn.Visible and "▢" or "_"
end)
table.insert(connections, toggleConn)

-- ===== LOCK BUTTON =====
local lockBtnConn = aimlockBtn.MouseButton1Click:Connect(function()
    if not _G.ZorxAimlockRunning then return end

    aimlockOn = not aimlockOn

    if aimlockOn then
        lockTarget = getTargetUnderCursor()
        if lockTarget then
            aimlockBtn.Text = "LOCKED"
            aimlockBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
            applyOutline(lockTarget.Parent)
            _G.ZorxAimlockLocked = true
            _G.ZorxAimlockTarget = lockTarget
        else
            aimlockOn = false
            aimlockBtn.Text = "AIM: OFF"
            aimlockBtn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
        end
    else
        lockTarget = nil
        aimlockBtn.Text = "AIM: OFF"
        aimlockBtn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
        removeOutline()
        _G.ZorxAimlockLocked = false
        _G.ZorxAimlockTarget = nil
    end
end)
table.insert(connections, lockBtnConn)

-- ===== LOOP (RENDER STEPPED) =====
renderConn = RunService.RenderStepped:Connect(function()
    -- 🔥 KUNCI FIX: CEK FLAG STOP
    if not _G.ZorxAimlockRunning then
        if renderConn then
            renderConn:Disconnect()
            renderConn = nil
        end
        return
    end

    if not aimlockOn then return end

    local valid = lockTarget
        and lockTarget.Parent
        and lockTarget.Parent:FindFirstChild("Humanoid")
        and lockTarget.Parent.Humanoid.Health > 0

    if not valid then
        lockTarget = getTargetUnderCursor()
        if lockTarget then
            applyOutline(lockTarget.Parent)
            _G.ZorxAimlockTarget = lockTarget
        else
            removeOutline()
            return
        end
    end

    if not lockTarget then return end

    applyOutline(lockTarget.Parent)
    camera.CFrame = CFrame.new(camera.CFrame.Position, lockTarget.Position)

    -- TP ke belakang hanya kalau block ASLI
    local blocking, reason = checkRealBlock(lockTarget.Parent)
    if blocking then
        local now = tick()
        if now - lastTP >= TP_COOLDOWN then
            lastTP = now
            if DEBUG then
                print("[ZORX] TP karena:", reason)
            end
            teleportBehind(lockTarget.Parent)
        end
    end
end)
table.insert(connections, renderConn)

-- ===== CLEANUP FUNCTION (DIPANGGIL DARI UI ZORX HUB) =====
local function cleanupAll()
    -- 🔥 SET FLAG STOP - loop bakal break sendiri
    _G.ZorxAimlockRunning = false
    _G.ZorxAimlockOn = false
    _G.ZorxAimlockLocked = false
    _G.ZorxAimlockTarget = nil

    -- Disconnect semua connection
    for _, conn in ipairs(connections) do
        pcall(function() conn:Disconnect() end)
    end
    connections = {}

    if renderConn then
        pcall(function() renderConn:Disconnect() end)
        renderConn = nil
    end

    -- Reset variable internal
    aimlockOn = false
    lockTarget = nil
    lastTP = 0

    -- Hapus outline
    removeOutline()

    -- Hapus GUI
    if aimGui and aimGui.Parent then
        pcall(function() aimGui:Destroy() end)
    end

    -- Reset camera
    pcall(function()
        local cam = workspace.CurrentCamera
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if cam then
            cam.CameraType = Enum.CameraType.Custom
            if hum then
                cam.CameraSubject = hum
            end
        end
    end)

    print("[ZORX AIMLOCK] Cleanup - Semua di-stop dan di-reset")
end

-- Expose ke global biar bisa dipanggil dari UI ZORX HUB
_G.ZorxAimlockOff = cleanupAll

-- ===== CLEANUP PLAYER KELUAR =====
local playerRemovingConn = Players.PlayerRemoving:Connect(function(plr)
    if lockTarget and lockTarget.Parent == plr.Character then
        lockTarget = nil
        aimlockOn = false
        aimlockBtn.Text = "AIM: OFF"
        aimlockBtn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
        removeOutline()
        _G.ZorxAimlockLocked = false
        _G.ZorxAimlockTarget = nil
    end
end)
table.insert(connections, playerRemovingConn)

print("🎯 ZORX AIMLOCK TSB LOADED — _G.ZorxAimlockOff() tersedia untuk stop")