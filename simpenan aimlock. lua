-- ============================================
-- 🎯 NANDA×ZORX AIMLOCK (TSB FINAL — TIDAK SENTUH SKILL/ULTIMATE)
-- Outline + Lock + TP belakang HANYA saat block ASLI
-- PENTING: TIDAK mendeteksi skill / ultimate / efek apapun sebagai block
-- Khusus The Strongest Battlegrounds — TIDAK UBAH BAGIAN LAIN
-- ============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- ===== STATE =====
local aimlockOn = false
local lockTarget = nil
local bodyOutline = nil
local lastTP = 0
local TP_COOLDOWN = 0.8
local TP_DISTANCE = 3.5
local DEBUG = true

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
-- HANYA mendeteksi block RESMI TSB. SEMUA efek skill/ultra DIABAIKAN.
local function checkRealBlock(character)
    if not character then return false, "no-char" end

    -- ==== DAFTAR NAMA ANAK SKILL/ULTIMATE TSB — DIABAIKAN SEPENUHNYA ====
    local SKILL_EFFECTS_TO_IGNORE = {
        "ForceField" -- ⚠️ Khusus TSB: ForceField sering muncul di skill/ultra — JANGAN pakai ini sebagai satu-satunya penanda!
    }

    local hum = character:FindFirstChildOfClass("Humanoid")
    if not hum then return false, "no-hum" end

    -- ✅ Cek Attribute RESMI Block TSB saja
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

    -- ✅ Cek BoolValue dengan nama PERSIS
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

    -- ✅ ForceField HANYA dihitung jika TIDAK ada tanda skill berjalan
    -- Ini mencegah deteksi saat orang pakai ultimate/skill pelindung
    local hasForceField = character:FindFirstChildOfClass("ForceField") 
                        or hum:FindFirstChildOfClass("ForceField")
    
    if hasForceField then
        -- Cek: apakah ada attribute block BERSAMA ForceField? Baru dianggap block asli
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
        -- Kalau cuma ForceField sendirian = kemungkinan skill/ultra → DIABAIKAN
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

aimToggle.MouseButton1Click:Connect(function()
    aimlockBtn.Visible = not aimlockBtn.Visible
    aimToggle.Text = aimlockBtn.Visible and "▢" or "_"
end)

aimlockBtn.MouseButton1Click:Connect(function()
    aimlockOn = not aimlockOn

    if aimlockOn then
        lockTarget = getTargetUnderCursor()
        if lockTarget then
            aimlockBtn.Text = "LOCKED"
            aimlockBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
            applyOutline(lockTarget.Parent)
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
    end
end)

-- ===== LOOP =====
RunService.RenderStepped:Connect(function()
    if not aimlockOn then return end

    local valid = lockTarget
        and lockTarget.Parent
        and lockTarget.Parent:FindFirstChild("Humanoid")
        and lockTarget.Parent.Humanoid.Health > 0

    if not valid then
        lockTarget = getTargetUnderCursor()
        if lockTarget then
            applyOutline(lockTarget.Parent)
        else
            removeOutline()
            return
        end
    end

    if not lockTarget then return end

    applyOutline(lockTarget.Parent)
    camera.CFrame = CFrame.new(camera.CFrame.Position, lockTarget.Position)

    -- HANYA TP kalau BENAR-BENAR block ASLI — skill/ultra TIDAK memicu
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

-- ===== CLEANUP =====
Players.PlayerRemoving:Connect(function(plr)
    if lockTarget and lockTarget.Parent == plr.Character then
        lockTarget = nil
        aimlockOn = false
        aimlockBtn.Text = "AIM: OFF"
        aimlockBtn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
        removeOutline()
    end
end)

print("🎯 ZORX AIMLOCK TSB LOADED — Skill/Ultimate TIDAK terdeteksi sebagai block ✅")
