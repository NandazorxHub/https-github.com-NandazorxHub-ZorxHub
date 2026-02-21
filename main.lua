-- [[ NANDA×ZORX HUB🤡✌🏼: INSTANT TELEPORT & AUTO-RELEASE ]] --
local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local camera = workspace.CurrentCamera

-- Variables State
local flying = false
local aimlockOn = false
local lockTarget = nil
local vDir = 0
local flySpeed = 85
local stickTarget = nil

-- ===== 1. CORE UTILS =====
local function showCopyNotif(txt)
    local notifGui = Instance.new("ScreenGui", player.PlayerGui); notifGui.DisplayOrder = 1000
    local notif = Instance.new("TextLabel", notifGui)
    notif.Size = UDim2.new(0, 180, 0, 50); notif.Position = UDim2.new(0.5, -90, 0.3, 0)
    notif.Text = txt; notif.TextColor3 = Color3.new(1,1,1); notif.BackgroundColor3 = Color3.fromRGB(20,20,20)
    notif.TextSize = 16; Instance.new("UICorner", notif)
    task.wait(1.5); notifGui:Destroy()
end

local function makeDraggable(obj)
    local dragging, input, startPos, startInput
    obj.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true; startInput = i.Position; startPos = obj.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local delta = i.Position - startInput
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    obj.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
end

local function getClosest()
    local dist = math.huge
    local target = nil
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character.Humanoid.Health > 0 then
            local pos, onScreen = camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
            if onScreen then
                local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)).Magnitude
                if mag < dist then dist = mag; target = v.Character.HumanoidRootPart end
            end
        end
    end
    return target
end

-- ===== 2. UI SETUP =====
local gui = Instance.new("ScreenGui", player.PlayerGui); gui.Name = "NzkMasterFixFinal"; gui.ResetOnSpawn = false

-- AIMLOCK CONTAINER
local aimContainer = Instance.new("Frame", gui)
aimContainer.Size = UDim2.new(0, 140, 0, 45); aimContainer.Position = UDim2.new(1, -150, 0, 15); aimContainer.BackgroundTransparency = 1

local aimlockBtn = Instance.new("TextButton", aimContainer)
aimlockBtn.Size = UDim2.new(0, 100, 1, 0); aimlockBtn.Text = "AIM: OFF"; aimlockBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50); aimlockBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", aimlockBtn)

local aimToggle = Instance.new("TextButton", aimContainer)
aimToggle.Size = UDim2.new(0, 35, 0, 35); aimToggle.Position = UDim2.new(0, 105, 0, 5); aimToggle.Text = "_"; aimToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40); aimToggle.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", aimToggle)

-- FLY BUTTONS
local upBtn = Instance.new("TextButton", gui); upBtn.Size = UDim2.new(0,60,0,60); upBtn.Position = UDim2.new(1,-80, 0.4, 0); upBtn.Text = "UP"; upBtn.Visible = false; upBtn.BackgroundColor3 = Color3.fromRGB(40,40,40); upBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", upBtn)
local downBtn = Instance.new("TextButton", gui); downBtn.Size = UDim2.new(0,60,0,60); downBtn.Position = UDim2.new(1,-80, 0.52, 0); downBtn.Text = "DOWN"; downBtn.Visible = false; downBtn.BackgroundColor3 = Color3.fromRGB(40,40,40); downBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", downBtn)

-- LOGO NZK
local vBtn = Instance.new("TextButton", gui)
vBtn.Size = UDim2.new(0, 50, 0, 50); vBtn.Position = UDim2.new(0, 15, 0.5, 0); vBtn.Text = "Nzk"
vBtn.BackgroundColor3 = Color3.fromRGB(30,30,30); vBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", vBtn).CornerRadius = UDim.new(1,0); makeDraggable(vBtn)

local function createWindow(title, pos)
    local f = Instance.new("Frame", gui); f.Size = UDim2.new(0, 220, 0, 320); f.Position = pos; f.BackgroundColor3 = Color3.fromRGB(15,15,15); f.Visible = false; Instance.new("UICorner", f)
    local t = Instance.new("TextLabel", f); t.Size = UDim2.new(1,0,0,35); t.Text = title; t.TextColor3 = Color3.new(1,1,1); t.BackgroundColor3 = Color3.fromRGB(40,0,0)
    local s = Instance.new("ScrollingFrame", f); s.Size = UDim2.new(1,-10,1,-45); s.Position = UDim2.new(0,5,0,40); s.BackgroundTransparency = 1; s.CanvasSize = UDim2.new(0,0,3,0)
    Instance.new("UIListLayout", s).Padding = UDim.new(0,5); return f, s
end

local zorxFrame, zorxScroll = createWindow("Nanda×Zorx Hub (Main)", UDim2.new(0.5, -340, 0.5, -150))
local rusuhFrame, rusuhScroll = createWindow("Buat Rusuh playermu🤫", UDim2.new(0.5, -110, 0.5, -150))
local nandaFrame, nandaScroll = createWindow("NANDA×ZORX (🛠️)", UDim2.new(0.5, 120, 0.5, -150))

local function addBtn(txt, parent, cb)
    local b = Instance.new("TextButton", parent); b.Size = UDim2.new(0.95,0,0,45); b.Text = txt; b.BackgroundColor3 = Color3.fromRGB(30,30,30); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(cb); return b
end

-- ===== 3. FEATURES =====

-- RUSUH (NOTE & DOT MENU AT TOP)
local note = Instance.new("TextLabel", rusuhScroll)
note.Size = UDim2.new(0.95, 0, 0, 45); note.Text = "NOTE: SEBELUM PAKAI INF PAKAI FLY DULU😈"; note.TextColor3 = Color3.new(1, 0.2, 0.2); note.BackgroundTransparency = 1; note.TextWrapped = true; note.TextSize = 11

local dotContainer = Instance.new("Frame", rusuhScroll); dotContainer.Size = UDim2.new(1, 0, 0, 100); dotContainer.BackgroundTransparency = 1; dotContainer.Visible = false
Instance.new("UIListLayout", dotContainer).Padding = UDim.new(0,5)

addBtn("📂 BUKA/TUTUP FITUR •", rusuhScroll, function() dotContainer.Visible = not dotContainer.Visible end)
addBtn("•invisfling", dotContainer, function() setclipboard("invisfling"); showCopyNotif("invisfling Copied!") end)
addBtn("•Bang Name", dotContainer, function() setclipboard("Bang Name"); showCopyNotif("Bang Name Copied!") end)

addBtn("🕺 Dance Emotes", rusuhScroll, function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Silly-Hacks/Emote-Gui/main/Main.lua"))() end)
addBtn("🕷️ Spider Emote", rusuhScroll, function() loadstring(game:HttpGet("https://pastefy.app/wa3v2Vgm/raw"))() end)

-- MAIN
addBtn("🚀 FLY MODE", zorxScroll, function()
    flying = not flying; upBtn.Visible = flying; downBtn.Visible = flying
    if not flying then 
        local root = player.Character:FindFirstChild("HumanoidRootPart")
        if root then
            if root:FindFirstChild("FlyVel") then root.FlyVel:Destroy() end
            if root:FindFirstChild("FlyGyro") then root.FlyGyro:Destroy() end
        end
        player.Character.Humanoid.PlatformStand = false 
    end
end)

local nameBox = Instance.new("TextBox", zorxScroll); nameBox.Size = UDim2.new(0.95,0,0,40); nameBox.PlaceholderText = "Nama Player..."; nameBox.BackgroundColor3 = Color3.fromRGB(40,40,40); nameBox.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", nameBox)

addBtn("📍 Stick to Player", zorxScroll, function()
    local tName = nameBox.Text:lower()
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= player and (v.Name:lower():find(tName) or v.DisplayName:lower():find(tName)) then 
            if v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                stickTarget = v
                -- Instant Teleport ke lokasi saat dipencet
                player.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,3.5)
                showCopyNotif("Instant Teleport to: " .. v.DisplayName)
            end
            break 
        end
    end
end)

addBtn("🛠️ INF YIELD", nandaScroll, function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end)
addBtn("🗑️ TONG SAMPAH", nandaScroll, function() loadstring(game:HttpGet("https://raw.githubusercontent.com/yes1nt/yes/refs/heads/main/Trashcan%20Man", true))() end)

-- ===== 4. ENGINE =====
vBtn.MouseButton1Click:Connect(function() 
    local s = not zorxFrame.Visible; zorxFrame.Visible = s; rusuhFrame.Visible = s; nandaFrame.Visible = s
end)

aimlockBtn.MouseButton1Click:Connect(function()
    aimlockOn = not aimlockOn; aimlockBtn.Text = aimlockOn and "AIM: ON" or "AIM: OFF"
    aimlockBtn.BackgroundColor3 = aimlockOn and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    if not aimlockOn then lockTarget = nil end
end)

aimToggle.MouseButton1Click:Connect(function() aimlockBtn.Visible = not aimlockBtn.Visible; aimToggle.Text = aimlockBtn.Visible and "_" or "▢" end)

upBtn.MouseButton1Down:Connect(function() vDir = flySpeed end); upBtn.MouseButton1Up:Connect(function() vDir = 0 end)
downBtn.MouseButton1Down:Connect(function() vDir = -flySpeed end); downBtn.MouseButton1Up:Connect(function() vDir = 0 end)

RunService.Heartbeat:Connect(function()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart

    -- FLY
    if flying then
        local bv = root:FindFirstChild("FlyVel") or Instance.new("BodyVelocity", root); bv.Name = "FlyVel"
        local bg = root:FindFirstChild("FlyGyro") or Instance.new("BodyGyro", root); bg.Name = "FlyGyro"
        bv.MaxForce = Vector3.new(9e9,9e9,9e9); bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
        bg.CFrame = camera.CFrame
        bv.Velocity = Vector3.new(char.Humanoid.MoveDirection.X * flySpeed, vDir, char.Humanoid.MoveDirection.Z * flySpeed)
        char.Humanoid.PlatformStand = true
    end

    -- STICK ENGINE (AUTO-RELEASE IF TARGET FLINGED)
    if stickTarget and stickTarget.Character and stickTarget.Character:FindFirstChild("HumanoidRootPart") then
        local tRoot = stickTarget.Character.HumanoidRootPart
        local dist = (root.Position - tRoot.Position).Magnitude
        
        -- JIKA TERLALU JAUH (>20) BERARTI TARGET KEPENTAL, MATIKAN OTOMATIS
        if dist > 20 or stickTarget.Character.Humanoid.Health <= 0 then
            stickTarget = nil
            char.Humanoid.PlatformStand = false
            showCopyNotif("Auto-Release: Target Terpental!")
        else
            root.CFrame = tRoot.CFrame * CFrame.new(0, 0, 3.5)
            char.Humanoid.PlatformStand = true
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if aimlockOn then
        if not lockTarget or not lockTarget.Parent or lockTarget.Parent:FindFirstChild("Humanoid").Health <= 0 then lockTarget = getClosest() end
        if lockTarget then camera.CFrame = CFrame.new(camera.CFrame.Position, lockTarget.Position) end
    end
end)
