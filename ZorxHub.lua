-- [[ NANDA×ZORX HUB × STAFF EDITION: RED BLACK THEME - FULL LOADING SEQUENCE ]] --

local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local player = game.Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")

-- ===== MASUK UI UTAMA ZORXHUB =====
-- Contoh gabungkan script UI utama:
-- createFixedLogo()
-- zorxNotif("Welcome Back ZORXHUB😈")
local TextChatService = game:GetService("TextChatService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local camera = workspace.CurrentCamera

local flying = false
local flyInf = false
local aimlockOn = false
local lockTarget = nil 
local vDir = 0
local flySpeed = 85
local stickTarget = nil
local killMusicOn = false
local killCooldown = false
local killSoundId = "rbxassetid://117909139728666"
local fixLagOn = false
local speedOn = false
local speedValue = 16
local speedForce 

-- AIMLOCK TARGET HIGHLIGHT
local highlight

local function applyHighlight(target)
    if highlight then highlight:Destroy() end

    highlight = Instance.new("Highlight")
    highlight.Adornee = target.Parent
    highlight.FillColor = Color3.fromRGB(255,0,0)
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Color3.fromRGB(255,0,0)
    highlight.OutlineTransparency = 0
    highlight.Parent = game.CoreGui
end

local function removeHighlight()
    if highlight then
        highlight:Destroy()
        highlight = nil
    end
end

local function getTargetUnderCursor()
    local closest = nil
    local shortest = math.huge

    for _,v in pairs(game.Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            
            local hum = v.Character:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 then

                local pos, visible = camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)

                if visible then
                    local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)).Magnitude

                    if dist < shortest then
                        shortest = dist
                        closest = v.Character.HumanoidRootPart
                    end
                end
            end
        end
    end

    return closest
end

-- ===== 3. UI SETUP =====
local mainGui = Instance.new("ScreenGui")
mainGui.Name = "NzkRedBlack"
mainGui.ResetOnSpawn = false
mainGui.Parent = game.CoreGui

-- FPS + WIFI MONITOR
local statsGui = Instance.new("ScreenGui", game.CoreGui)
statsGui.Name = "NZStats"

local statsText = Instance.new("TextLabel", statsGui)
statsText.Size = UDim2.new(0,120,0,40)
statsText.Position = UDim2.new(0,10,0,5) -- pojok kiri atas
statsText.BackgroundTransparency = 1
statsText.TextColor3 = Color3.fromRGB(255,255,255)
statsText.TextScaled = true
statsText.Font = Enum.Font.GothamBold
statsText.TextXAlignment = Enum.TextXAlignment.Left

local Stats = game:GetService("Stats")
local last = tick()

RunService.RenderStepped:Connect(function()
    local now = tick()
    local fps = math.floor(1/(now-last))
    last = now

    local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())

    statsText.Text = "FPS: "..fps.."\nWifi: "..ping
end)

-- FRAME INDUK UI (nyatuin ketiga frame)
local uiContainer = Instance.new("Frame", mainGui)
uiContainer.Size = UDim2.new(0, 660, 0, 320) -- 220*3 lebar frame UI
uiContainer.Position = UDim2.new(0.5, -330, 0.5, -150) -- tengah layar
uiContainer.BackgroundTransparency = 1
local bg = Instance.new("ImageLabel", uiContainer)
bg.Size = UDim2.new(1,0,1,0)
bg.Position = UDim2.new(0,0,0,0)
bg.BackgroundTransparency = 1
bg.Image = "rbxassetid://92711712804896"
bg.ScaleType = Enum.ScaleType.Stretch
bg.ZIndex = -1

-- BACKGROUND IMAGE FULS --
local function createWindow(title, pos, isMain)
    local f = Instance.new("Frame", uiContainer)
    f.Size = UDim2.new(0, 220, 0, 320)
    f.Position = pos
    f.BackgroundColor3 = Color3.fromRGB(0,0,0)
    f.BackgroundTransparency = 1

    local sT = Instance.new("UIStroke", f); sT.Color = Color3.fromRGB(200, 0, 0); sT.Thickness = 1
    local t = Instance.new("TextLabel", f); t.Size = UDim2.new(1,0,0,35); t.Text = title; t.TextColor3 = Color3.new(1,1,1); t.BackgroundColor3 = Color3.fromRGB(0,0,0); t.BackgroundTransparency = 1

    if isMain then

    local profileFrame = Instance.new("Frame", f)
    profileFrame.Size = UDim2.new(1, -10, 0, 60)
    profileFrame.Position = UDim2.new(0, 5, 0, 40)
    profileFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
    Instance.new("UICorner", profileFrame)
local stroke = Instance.new("UIStroke", profileFrame)
stroke.Color = Color3.fromRGB(255,0,0)
stroke.Thickness = 1.5
stroke.Transparency = 0.3

    -- FOTO PROFILE
    local avatar = Instance.new("ImageLabel", profileFrame)
    local avatarCorner = Instance.new("UICorner", avatar)
    avatarCorner.CornerRadius = UDim.new(1,0)
    avatar.Size = UDim2.new(0,50,0,50)
    avatar.Position = UDim2.new(0,10,0.5,-25)
    avatar.BackgroundTransparency = 1

    local userId = player.UserId
    avatar.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="
        ..userId.."&width=420&height=420&format=png"

-- HALO MERAH FIX (PAS BULAT)
local halo = Instance.new("Frame", profileFrame)
halo.Size = avatar.Size -- sama persis avatar
halo.Position = avatar.Position -- tepat nempel
halo.BackgroundTransparency = 1
halo.ZIndex = avatar.ZIndex + 1

local haloCorner = Instance.new("UICorner", halo)
haloCorner.CornerRadius = UDim.new(1,0)

local haloStroke = Instance.new("UIStroke", halo)
haloStroke.Color = Color3.fromRGB(255,0,0)
haloStroke.Thickness = 2
haloStroke.Transparency = 0.3

-- ROTASI HALUS
task.spawn(function()
    local rot = 0
    while halo.Parent do
        rot += 2
        halo.Rotation = rot
        task.wait()
    end
end)
task.spawn(function()
    while halo.Parent do
        haloStroke.Transparency = 0.1
        task.wait(0.5)
        haloStroke.Transparency = 0.5
        task.wait(0.5)
    end
end)

    -- NAMA PLAYER
    local nameLabel = Instance.new("TextLabel", profileFrame)
    nameLabel.Size = UDim2.new(1,-70,0.5,0)
    nameLabel.Position = UDim2.new(0,80,0,5)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.DisplayName
    nameLabel.TextColor3 = Color3.new(1,1,1)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 14
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- USERNAME
    local userLabel = Instance.new("TextLabel", profileFrame)
    userLabel.Size = UDim2.new(1,-70,0.5,0)
    userLabel.Position = UDim2.new(0,80,0.5,-5)
    userLabel.BackgroundTransparency = 1
    userLabel.Text = "@"..player.Name
    userLabel.TextColor3 = Color3.fromRGB(180,180,180)
    userLabel.Font = Enum.Font.Gotham
    userLabel.TextSize = 12
    userLabel.TextXAlignment = Enum.TextXAlignment.Left
    local logo = Instance.new("ImageLabel", profileFrame)
logo.Size = UDim2.new(0,40,0,40)
logo.Position = UDim2.new(1,-50,0.5,-20)
logo.BackgroundTransparency = 1
logo.Image = "rbxassetid://71597722112744"
logo.ZIndex = 10


end
    
    local s = Instance.new("ScrollingFrame", f); s.Size = UDim2.new(1,-10,1,-110); s.Position = UDim2.new(0,5,0,105); s.BackgroundTransparency = 1; s.CanvasSize = UDim2.new(0,0,3.5,0); s.ScrollBarThickness = 2
    if not isMain then s.Size = UDim2.new(1,-10,1,-50); s.Position = UDim2.new(0,5,0,40) end
    Instance.new("UIListLayout", s).Padding = UDim.new(0,5); return f, s
end

local zorxFrame, zorxScroll = createWindow("ZorxHUB", UDim2.new(0,0,0,0), true)
local emoFrame, emoScroll = createWindow("Emoticon", UDim2.new(0,220,0,0), false)
local staffFrame, staffScroll = createWindow("Tols", UDim2.new(0,440,0,0), false)

zorxFrame.BackgroundColor3 = Color3.fromRGB(40, 0, 40)
emoFrame.BackgroundColor3  = Color3.fromRGB(0, 40, 40)
staffFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 0)

local function addBtn(txt, parent, cb)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0.95,0,0,45)
    b.Text = txt
    b.BackgroundColor3 = Color3.fromRGB(25,25,25)
    b.BackgroundTransparency = 0.4
    b.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", b)
    Instance.new("UIStroke", b).Color = Color3.fromRGB(100,0,0)

    b.MouseButton1Click:Connect(cb)
    return b
end

-- UI 1 FEATURES
addBtn("🚀 FLY MODE", zorxScroll, function() 
    flying = not flying

    stickTarget = nil 

    _G.UpBtn.Visible = flying
    _G.DownBtn.Visible = flying
    if not flying and player.Character then 
        for _,v in pairs(player.Character.HumanoidRootPart:GetChildren()) do
            if v:IsA("BodyVelocity") or v:IsA("BodyGyro") then
                v:Destroy()
            end
        end
        player.Character.Humanoid.PlatformStand = false 
    end

    zorxNotif("Fly "..(flying and "ON" or "OFF"))
end)

-- MUSIC KILL BUTTON (letakkan setelah Fly Mode selesai)
addBtn("🎵 MUSIC KILL", zorxScroll, function()
    killMusicOn = not killMusicOn
    zorxNotif("Music Kill "..(killMusicOn and "ON" or "OFF"))
end)

local nameBox = Instance.new("TextBox", zorxScroll); nameBox.Size = UDim2.new(0.95,0,0,40); nameBox.PlaceholderText = "ZorxHUB"; nameBox.BackgroundColor3 = Color3.fromRGB(30,30,30); nameBox.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", nameBox)

addBtn("📍 Stick to Player", zorxScroll, function()
    local tName = nameBox.Text:lower()
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= player and (v.Name:lower():find(tName) or v.DisplayName:lower():find(tName)) then 
            if v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                stickTarget = v
                player.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3.5)
                zorxNotif("Instant Teleport to: " .. v.DisplayName)
            end
            break 
        end
    end
end)

addBtn("🎲 Teleport Random", zorxScroll, function()
    local allPlayers = game.Players:GetPlayers()
    local otherPlayers = {}

    for _, p in pairs(allPlayers) do
        if p ~= player 
        and p.Character 
        and p.Character:FindFirstChild("HumanoidRootPart") 
        and p.Character.Humanoid.Health > 0 then
            table.insert(otherPlayers, p)
        end
    end

    if #otherPlayers > 0 then
        local target = otherPlayers[math.random(1, #otherPlayers)]

        stickTarget = target -- 🔥 penting biar langsung nempel

        local root = player.Character.HumanoidRootPart
        local tRoot = target.Character.HumanoidRootPart

        root.CFrame = tRoot.CFrame * CFrame.new(0,0,3.5)
        player.Character.Humanoid.PlatformStand = true

        zorxNotif("Random Stick: " .. target.DisplayName)
    else
        zorxNotif("No target found!")
    end
end)

-- ===== [NEW] LEPAS TELEPORT FEATURE =====
addBtn("❌ Lepas Teleport", zorxScroll, function()
    if stickTarget then
        stickTarget = nil
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.PlatformStand = false
        end
        zorxNotif("Teleport Released!")
    else
        zorxNotif("Not sticking to anyone!")
    end
end)

-- UI 2 & 3 FEATURES (TETAP SAMA)
addBtn("🕺 Dance Emotes", emoScroll, function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Silly-Hacks/Emote-Gui/main/Main.lua"))() end)
addBtn("🧐Sus Emotes", emoScroll, function() loadstring(game:HttpGet("https://pastefy.app/wa3v2Vgm/raw"))() end)
addBtn("✈️ FLY INF (FOLLOW CAM)", staffScroll, function() flyInf = not flyInf; zorxNotif("Fly INF "..(flyInf and "ON" or "OFF")) end)
local dotContainer = Instance.new("Frame", staffScroll); dotContainer.Size = UDim2.new(1, 0, 0, 90); dotContainer.BackgroundTransparency = 1; dotContainer.Visible = false; Instance.new("UIListLayout", dotContainer).Padding = UDim.new(0,5)
addBtn("📂 BUKA/TUTUP FITUR •", staffScroll, function() dotContainer.Visible = not dotContainer.Visible end)
addBtn("•invisfling", dotContainer, function() setclipboard("invisfling"); zorxNotif("Copied") end)
addBtn("•Bang Name", dotContainer, function() setclipboard("Bang Name"); zorxNotif("Copied") end)
addBtn("📢 SEND STAFF MSG", staffScroll, function() SendStaffChat() end)
addBtn("🛠️ INF YIELD", staffScroll, function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end)
addBtn("🗑️ TONG SAMPAH", staffScroll, function() loadstring(game:HttpGet("https://raw.githubusercontent.com/yes1nt/yes/refs/heads/main/Trashcan%20Man", true))() end)

-- CONTAINER SPEED UI
local speedFrame = Instance.new("Frame", staffScroll)
speedFrame.Size = UDim2.new(0.95,0,0,140)
speedFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
speedFrame.BackgroundTransparency = 0.3
Instance.new("UICorner", speedFrame)

-- TEXTBOX SPEED
local speedBox = Instance.new("TextBox", speedFrame)
speedBox.Size = UDim2.new(1,-10,0,35)
speedBox.Position = UDim2.new(0,5,0,5)
speedBox.PlaceholderText = "Set Speed (16 - 2000)"
speedBox.BackgroundColor3 = Color3.fromRGB(30,30,30)
speedBox.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", speedBox)

-- PILIHAN CEPAT (PRESET)
local presetFrame = Instance.new("Frame", speedFrame)
presetFrame.Size = UDim2.new(1,-10,0,35)
presetFrame.Position = UDim2.new(0,5,0,45)
presetFrame.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", presetFrame)
layout.FillDirection = Enum.FillDirection.Horizontal
layout.Padding = UDim.new(0,5)

local presets = {50, 100, 200, 500}

for _,v in pairs(presets) do
    local btn = Instance.new("TextButton", presetFrame)
    btn.Size = UDim2.new(0.23,0,1,0)
    btn.Text = tostring(v)
    btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
    btn.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function()
        speedBox.Text = tostring(v)
    end)
end

-- BUTTON ENTER (APPLY)
local enterBtn = Instance.new("TextButton", speedFrame)
enterBtn.Size = UDim2.new(0.48,0,0,35)
enterBtn.Position = UDim2.new(0.02,0,1,-40)
enterBtn.Text = "ENTER"
enterBtn.BackgroundColor3 = Color3.fromRGB(40,0,0)
enterBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", enterBtn)

-- BUTTON STOP (RESET)
local stopBtn = Instance.new("TextButton", speedFrame)
stopBtn.Size = UDim2.new(0.48,0,0,35)
stopBtn.Position = UDim2.new(0.5,0,1,-40)
stopBtn.Text = "STOP"
stopBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
stopBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", stopBtn)

-- APPLY SPEED
enterBtn.MouseButton1Click:Connect(function()
    local val = tonumber(speedBox.Text)

    if val then
        if val > 2000 then val = 2000 end
        if val < 16 then val = 16 end

        speedValue = val
        speedOn = true

        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = speedValue
        end

        zorxNotif("Speed: "..speedValue)
    else
        zorxNotif("Invalid Number!")
    end
end)

-- STOP SPEED
stopBtn.MouseButton1Click:Connect(function()
    speedOn = false

    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = 16
    end

    zorxNotif("Speed Reset!")
end)

addBtn("⚡ FIX LAG", staffScroll, function()
    fixLagOn = not fixLagOn

    zorxNotif("Fix Lag "..(fixLagOn and "ON" or "OFF"))

    -- APPLY BERULANG (INI KUNCI NYA)
    task.spawn(function()
    for i = 1,5 do
        applyFixLag(fixLagOn)
        task.wait(0.3)
    end
end)

end)

-- FIX LAG SUPER EXTREME (PALING NGARUH)
local connectionFix

local function safeDestroy(obj)
    if obj then
        pcall(function()
            obj:Destroy()
        end)
    end
end

local function applyFixLag(state)

    if connectionFix then
        connectionFix:Disconnect()
        connectionFix = nil
    end

    if state then
        -- 🔥 PAKSA ENGINE JADI RINGAN BANGET
        pcall(function()
            sethiddenproperty(Lighting, "Technology", Enum.Technology.Compatibility)
        end)

        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01

        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Lighting.Brightness = 0.5

        -- 🔥 MATIIN SEMUA EFFECT
        for _,v in pairs(Lighting:GetChildren()) do
            if v:IsA("PostEffect") then
                v.Enabled = false
            end
        end

        -- 🔥 AIR JADI RINGAN
        if workspace:FindFirstChildOfClass("Terrain") then
            local t = workspace.Terrain
            t.WaterWaveSize = 0
            t.WaterWaveSpeed = 0
            t.WaterReflectance = 0
            t.WaterTransparency = 1
        end

        -- 🔥 BERSIHIN MAP TOTAL
        for _,v in pairs(workspace:GetDescendants()) do

            if v:IsA("BasePart") then
                v.Material = Enum.Material.SmoothPlastic
                v.Reflectance = 0
                v.CastShadow = false
            end

            if v:IsA("Decal") or v:IsA("Texture") then
                safeDestroy(v)
            end

            if v:IsA("ParticleEmitter")
            or v:IsA("Trail")
            or v:IsA("Smoke")
            or v:IsA("Fire")
            or v:IsA("Sparkles") then
                safeDestroy(v)
            end

            -- 🌲 HAPUS POHON + RUMPUT
            if v:IsA("MeshPart") or v:IsA("UnionOperation") then
                local name = v.Name:lower()

                if name:find("tree")
                or name:find("leaf")
                or name:find("bush")
                or name:find("grass")
                or name:find("plant") then
                    safeDestroy(v)
                end
            end

            if v:IsA("Model") then
                local name = v.Name:lower()

                if name:find("tree")
                or name:find("bush")
                or name:find("plant") then
                    safeDestroy(v)
                end
            end
        end

        -- 🔥 AUTO HANDLE OBJECT BARU
        connectionFix = workspace.DescendantAdded:Connect(function(v)

            if v:IsA("BasePart") then
                v.Material = Enum.Material.SmoothPlastic
                v.Reflectance = 0
                v.CastShadow = false
            end

            if v:IsA("Decal") or v:IsA("Texture") then
                v:Destroy()
            end

            if v:IsA("ParticleEmitter")
            or v:IsA("Trail")
            or v:IsA("Smoke")
            or v:IsA("Fire")
            or v:IsA("Sparkles") then
                v:Destroy()
            end

            -- 🌲 AUTO DELETE POHON
            if v:IsA("MeshPart") or v:IsA("UnionOperation") then
                local name = v.Name:lower()

                if name:find("tree")
                or name:find("leaf")
                or name:find("bush")
                or name:find("grass")
                or name:find("plant") then
                    v:Destroy()
                end
            end

            if v:IsA("Model") then
                local name = v.Name:lower()

                if name:find("tree")
                or name:find("bush")
                or name:find("plant") then
                    v:Destroy()
                end
            end

        end)

    else
        -- 🔄 BALIK NORMAL
        settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic

        Lighting.GlobalShadows = true
        Lighting.Brightness = 2

        for _,v in pairs(Lighting:GetChildren()) do
            if v:IsA("PostEffect") then
                v.Enabled = true
            end
        end

        if connectionFix then
            connectionFix:Disconnect()
            connectionFix = nil
        end
    end
end

-- AIMLOCK UI
local aimContainer = Instance.new("Frame", mainGui) aimContainer.Size = UDim2.new(0, 140, 0, 45); aimContainer.Position = UDim2.new(1, -150, 0, 15); aimContainer.BackgroundTransparency = 1
local aimlockBtn = Instance.new("TextButton", aimContainer); aimlockBtn.Size = UDim2.new(0, 100, 1, 0); aimlockBtn.Text = "AIM: OFF"; aimlockBtn.BackgroundColor3 = Color3.fromRGB(50, 0, 0); aimlockBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", aimlockBtn); Instance.new("UIStroke", aimlockBtn).Color = Color3.fromRGB(200,0,0)
local aimToggle = Instance.new("TextButton", aimContainer); aimToggle.Size = UDim2.new(0, 35, 0, 35); aimToggle.Position = UDim2.new(0, 105, 0, 5); aimToggle.Text = "▢"; aimToggle.BackgroundColor3 = Color3.fromRGB(10, 10, 10); aimToggle.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", aimToggle); Instance.new("UIStroke", aimToggle).Color = Color3.fromRGB(200,0,0)

-- FLY BUTTONS
local upBtn = Instance.new("TextButton", mainGui)
upBtn.Size = UDim2.new(0,60,0,60)
upBtn.Position = UDim2.new(1,-80, 0.4, 0)
upBtn.Text = "UP"
upBtn.Visible = false
upBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
upBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", upBtn)
Instance.new("UIStroke", upBtn).Color = Color3.fromRGB(255,0,0)

local downBtn = Instance.new("TextButton", mainGui)
downBtn.Size = UDim2.new(0,60,0,60)
downBtn.Position = UDim2.new(1,-80, 0.52, 0)
downBtn.Text = "DOWN"
downBtn.Visible = false
downBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
downBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", downBtn)
Instance.new("UIStroke", downBtn).Color = Color3.fromRGB(255,0,0)
_G.UpBtn, _G.DownBtn = upBtn, downBtn

-- ===== 4. ENGINE =====
player.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid")

    if speedOn then
        hum.WalkSpeed = speedValue
    end
end)

local function playKillSound(enemyRoot)
	if killCooldown then return end
	killCooldown = true

	local soundPart = Instance.new("Part")
	soundPart.Anchored = true
	soundPart.CanCollide = false
	soundPart.Transparency = 1
	soundPart.Position = enemyRoot.Position -- posisi di musuh
	soundPart.Parent = workspace

	local sound = Instance.new("Sound")
	sound.SoundId = killSoundId
	sound.Volume = 3
sound.RollOffMode = Enum.RollOffMode.Inverse
sound.MaxDistance = 200
sound.EmitterSize = 80
	sound.Parent = soundPart

	sound:Play()
	game.Debris:AddItem(soundPart,5)

	task.wait(0.3)
	killCooldown = false
end
aimToggle.MouseButton1Click:Connect(function() aimlockBtn.Visible = not aimlockBtn.Visible; aimToggle.Text = aimlockBtn.Visible and "▢" or "_" end)
aimlockBtn.MouseButton1Click:Connect(function()

    aimlockOn = not aimlockOn

    if aimlockOn then

        lockTarget = getTargetUnderCursor()

        if lockTarget then
            aimlockBtn.Text = "LOCKED"
            aimlockBtn.BackgroundColor3 = Color3.fromRGB(150,0,0)

            zorxNotif("Locked: "..lockTarget.Parent.Name)

            applyHighlight(lockTarget)

        else
            aimlockOn = false
            zorxNotif("No Target!")
        end

    else

        lockTarget = nil
        aimlockBtn.Text = "AIM: OFF"
        aimlockBtn.BackgroundColor3 = Color3.fromRGB(50,0,0)

        removeHighlight()

    end

end)
upBtn.MouseButton1Down:Connect(function() vDir = flySpeed end); upBtn.MouseButton1Up:Connect(function() vDir = 0 end)
downBtn.MouseButton1Down:Connect(function() vDir = -flySpeed end); downBtn.MouseButton1Up:Connect(function() vDir = 0 end)
-- NEW KILL MUSIC SYSTEM FIX

for _, plr in pairs(game.Players:GetPlayers()) do
    if plr ~= player then

        plr.CharacterAdded:Connect(function(char)

            local hum = char:WaitForChild("Humanoid")

            hum.Died:Connect(function()

                if not killMusicOn then return end

                local enemyRoot = char:FindFirstChild("HumanoidRootPart")
                local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")

                if enemyRoot and myRoot then
                    local dist = (enemyRoot.Position - myRoot.Position).Magnitude

                    if dist < 60 then
                        playKillSound(enemyRoot)
                    end
                end

            end)

        end)

    end
end
    -- ===== ANTI KELUAR MAP =====
    RunService.RenderStepped:Connect(function()

    local char = player.Character
    if not char then return end

    local hum = char:FindFirstChild("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return end


    -- ===== ANTI KELUAR MAP =====
    if root.Position.Y < -50 then
        local spawn = workspace:FindFirstChildWhichIsA("SpawnLocation")
        if spawn then
            root.CFrame = spawn.CFrame + Vector3.new(0,5,0)
        else
            root.CFrame = CFrame.new(0,100,0)
        end
        zorxNotif("Map Protection Activated!")
    end


    -- ===== FLY MODE =====
    if flying then
        local bv = root:FindFirstChild("FlyVel") or Instance.new("BodyVelocity", root)
        bv.Name = "FlyVel"

        local bg = root:FindFirstChild("FlyGyro") or Instance.new("BodyGyro", root)
        bg.Name = "FlyGyro"

        bv.MaxForce = Vector3.new(9e9,9e9,9e9)
        bg.MaxTorque = Vector3.new(9e9,9e9,9e9)

        bg.CFrame = camera.CFrame
        bv.Velocity = (hum.MoveDirection * flySpeed) + Vector3.new(0, vDir, 0)

        hum.PlatformStand = true
        root.AssemblyLinearVelocity = Vector3.zero
    end

-- 🔥 AUTO RELEASE SAAT FLY INF (WAJIB)
if flyInf and stickTarget then
    stickTarget = nil
    hum.PlatformStand = false
    zorxNotif("Stick Released (Fly INF)")
end

-- ===== FLY INF =====
if flyInf then
    root.AssemblyLinearVelocity =
        camera.CFrame.LookVector *
        (hum.MoveDirection.Magnitude > 0 and 150 or 0)
        + Vector3.new(0,1.5,0)
end

-- ===== STICK PLAYER (SUPER STABLE FIX) =====
if stickTarget and stickTarget.Character and stickTarget.Character:FindFirstChild("HumanoidRootPart") then

    local tRoot = stickTarget.Character.HumanoidRootPart
    local distance = (root.Position - tRoot.Position).Magnitude

    if stickTarget.Character.Humanoid.Health <= 0 then
        stickTarget = nil
        hum.PlatformStand = false
        zorxNotif("Target Down!")

    elseif distance > 80 then
        -- 🔥 TARIK BALIK (ANTI LEPAS)
        root.CFrame = tRoot.CFrame * CFrame.new(0,0,3.5)

    else
        local targetCFrame = tRoot.CFrame * CFrame.new(0,0,3.5)

        -- 🔥 SMOOTH BIAR GAK KAKU
        root.CFrame = root.CFrame:Lerp(targetCFrame, 0.6)

        -- 🔥 MATIIN FISIKA
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        root.Velocity = Vector3.zero

        hum.PlatformStand = true
    end

end

end)
RunService.RenderStepped:Connect(function()

    if aimlockOn then

        if not lockTarget
        or not lockTarget.Parent
        or not lockTarget.Parent:FindFirstChild("Humanoid")
        or lockTarget.Parent.Humanoid.Health <= 0 then

            lockTarget = getTargetUnderCursor()

            if lockTarget then
                applyHighlight(lockTarget)
            else
                removeHighlight()
            end

        end

        if lockTarget then
            camera.CFrame = CFrame.new(camera.CFrame.Position, lockTarget.Position)
        end

    end

end)

-- 🔥 SPEED SYSTEM REALTIME (FIX CLEAN)
local lockY = nil

RunService.RenderStepped:Connect(function()
    if not speedOn then 
        if speedForce then
            speedForce:Destroy()
            speedForce = nil
        end
        lockY = nil
        return 
    end

    local char = player.Character
    if not char then return end

    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not root or not hum then return end

    if not speedForce then
        speedForce = Instance.new("BodyVelocity")
        speedForce.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        speedForce.Parent = root
    end

    -- 🔒 SIMPAN KETINGGIAN AWAL
    if not lockY then
        lockY = root.Position.Y
    end

    local moveDir = hum.MoveDirection

    if moveDir.Magnitude > 0 then
        speedForce.Velocity = (moveDir * speedValue)
    else
        speedForce.Velocity = Vector3.zero
    end

    -- 🔥 KUNCI Y (ANTI JATUH & ANTI NEMBUS)
    root.Velocity = Vector3.new(root.Velocity.X, 0, root.Velocity.Z)
    root.CFrame = CFrame.new(root.Position.X, lockY, root.Position.Z)
end)

-- ===== LOGO PERMANEN FIX DI KIRI =====
local logoVisible = true
local logoGui

local function createFixedLogo()
    if game.CoreGui:FindFirstChild("ZorxLogoGui") then
        logoGui = game.CoreGui:FindFirstChild("ZorxLogoGui")
        return
    end

    logoGui = Instance.new("ScreenGui")
    logoGui.Name = "ZorxLogoGui"
    logoGui.Parent = game.CoreGui
    logoGui.ResetOnSpawn = false

    local logo = Instance.new("ImageButton")
    logo.Parent = logoGui
    logo.Size = UDim2.new(0,50,0,50)
    logo.Position = UDim2.new(0,10,0.5,-25) 
    logo.BackgroundTransparency = 1
    logo.Image = "rbxassetid://107066160608098"
    logo.ZIndex = 999
     
    local corner = Instance.new("UICorner", logo)
    corner.CornerRadius = UDim.new(0, 12) 

    -- Klik logo untuk toggle guiContainer
    logo.MouseButton1Click:Connect(function()
    logoVisible = not logoVisible
    
    uiContainer.Visible = logoVisible
    
    -- statsGui tetap muncul, tidak ikut ke-hide
end)

end

createFixedLogo()

-- 🔥 FORCE FIX LAG SAAT GAME BARU MASUK
task.spawn(function()
    while task.wait(5) do
        if fixLagOn then
            applyFixLag(true)
        end
    end
end)

zorxNotif("Welcome Back ZorxHUBVIP3 😈", 8)
zorxNotif("TRIAL: 2 hari 2 jam 30 menit ⏳", 7)
zorxNotif("VIP5K ORDER ADMIN 🔥", 7)
zorxNotif("Have Fun and Enjoy VIP Features 🎉", 7)
zorxNotif("Check Out New Updates 🔥", 7)