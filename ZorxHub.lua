-- [[ NANDA×ZORX HUB × STAFF EDITION: RED BLACK THEME - FULL LOADING SEQUENCE ]] --

local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local player = game.Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")

-- ===== FUNCTION: DISPLAY IMAGE (OPTIONAL LOGO) =====
local function showImage(imageId, duration, showLogo)
    local blur = Instance.new("BlurEffect")
    blur.Size = 0
    blur.Parent = Lighting

    local intro = Instance.new("ScreenGui")
    intro.Name = "ZorxIntro"
    intro.Parent = gui
    intro.IgnoreGuiInset = true

    local bg = Instance.new("ImageLabel")
    bg.Parent = intro
    bg.Size = UDim2.new(1,0,1,0)
    bg.Position = UDim2.new(0,0,0,0)
    bg.BackgroundTransparency = 1
    bg.Image = "rbxassetid://"..imageId
    bg.ScaleType = Enum.ScaleType.Stretch

    local logo
    local bar
    if showLogo then
        -- Logo Text
        logo = Instance.new("TextLabel")
        logo.Parent = bg
        logo.Text = "ZORXHUB"
        logo.Font = Enum.Font.GothamBlack
        logo.TextScaled = true
        logo.Size = UDim2.new(0,360,0,90)
        logo.Position = UDim2.new(0.5,0,0.45,0)
        logo.AnchorPoint = Vector2.new(0.5,0.5)
        logo.BackgroundTransparency = 1
        logo.TextTransparency = 1
        logo.TextColor3 = Color3.fromRGB(255,255,255)
        logo.TextStrokeColor3 = Color3.fromRGB(0,0,0)
        logo.TextStrokeTransparency = 0.3

        -- Loading Bar Background
        local barBG = Instance.new("Frame")
        barBG.Parent = bg
        barBG.Size = UDim2.new(0.3,0,0,6)
        barBG.Position = UDim2.new(0.5,0,0.55,0)
        barBG.AnchorPoint = Vector2.new(0.5,0.5)
        barBG.BackgroundColor3 = Color3.fromRGB(40,40,40)
        barBG.BorderSizePixel = 0
        local stroke = Instance.new("UIStroke")
        stroke.Parent = barBG
        stroke.Color = Color3.fromRGB(0,0,0)
        stroke.Thickness = 2

        -- Loading Bar
        bar = Instance.new("Frame")
        bar.Parent = barBG
        bar.Size = UDim2.new(0,0,1,0)
        bar.BackgroundColor3 = Color3.fromRGB(255,255,255)
        bar.BorderSizePixel = 0
    end

    -- ===== ANIMASI MASUK =====
    TweenService:Create(blur, TweenInfo.new(0.4), {Size = 20}):Play()
    if logo then
        TweenService:Create(logo, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
    end
    task.wait(0.2)

    if bar then
        TweenService:Create(bar, TweenInfo.new(duration), {Size = UDim2.new(1,0,1,0)}):Play()
    end
    task.wait(duration + 0.1)

    -- ===== ANIMASI KELUAR =====
    TweenService:Create(bg, TweenInfo.new(0.6), {ImageTransparency = 1}):Play()
    if logo then
        TweenService:Create(logo, TweenInfo.new(0.6), {TextTransparency = 1}):Play()
    end
    TweenService:Create(blur, TweenInfo.new(0.6), {Size = 0}):Play()
    task.wait(0.8)

    blur:Destroy()
    intro:Destroy()
end

-- ===== TAMPILKAN BERURUTAN =====
showImage("130831939013376", 1, false) -- Pertama cepat, tanpa logo
showImage("75074794440403", 1, false)  -- Kedua cepat, tanpa logo
showImage("114660803799468", 2, true)  -- Ketiga ZORXHUB loading screen

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

-- ===== 1. STAFF SYSTEM (TAG & MSG) =====
TextChatService.OnIncomingMessage = function(message)
    local properties = Instance.new("TextChatMessageProperties")
    if message.Text:sub(1, 7) == "[STAFF]" then
        properties.PrefixText = "<font color='#FF0000'>[STAFF]</font> " .. message.PrefixText
        properties.Text = message.Text:sub(8)
    end
    return properties
end

local function SendStaffChat()
    local staffTexts = {"Server monitoring active.", "Checking for unusual activity.", "Staff monitoring: Clear."}
    local msg = staffTexts[math.random(1, #staffTexts)]
    local channel = TextChatService:FindFirstChild("TextChannels") and TextChatService.TextChannels:FindFirstChild("RBXGeneral")
    if channel then channel:SendAsync("[STAFF]" .. msg) end
end

-- ===== 2. NOTIFICATION SYSTEM =====
local function zorxNotif(msg)
    local fullText = msg .. " | NZ HUB"
    local notifGui = Instance.new("ScreenGui", player.PlayerGui)
    
    local frame = Instance.new("Frame", notifGui)
    frame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    frame.Position = UDim2.new(0.5, 0, 0.2, 0)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.BorderSizePixel = 0
    
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Color3.fromRGB(255, 0, 0)
    stroke.Thickness = 2
    
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 6)
    
    local label = Instance.new("TextLabel", frame)
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Text = fullText
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.Font = Enum.Font.GothamBold
    
    local textSize = game:GetService("TextService"):GetTextSize(fullText, 14, Enum.Font.GothamBold, Vector2.new(600, 100))
    frame.Size = UDim2.new(0, textSize.X + 40, 0, 40)
    
    frame.BackgroundTransparency = 1
    label.TextTransparency = 1
    stroke.Transparency = 1
    game:GetService("TweenService"):Create(frame, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
    game:GetService("TweenService"):Create(label, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    game:GetService("TweenService"):Create(stroke, TweenInfo.new(0.3), {Transparency = 0}):Play()
    
    task.delay(2.5, function()
        if notifGui then notifGui:Destroy() end
    end)
end

local function getTargetUnderCursor()
    local shortestDist = math.huge
    local target = nil
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character.Humanoid.Health > 0 then
            local pos, onScreen = camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
            if onScreen then
                local cursorDist = (Vector2.new(pos.X, pos.Y) - Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)).Magnitude
                if cursorDist < shortestDist and cursorDist < 120 then
                    shortestDist = cursorDist; target = v.Character.HumanoidRootPart
                end
            end
        end
    end
    return target
end

-- ===== 3. UI SETUP =====
local gui = Instance.new("ScreenGui")
gui.Name = "NzkRedBlack"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

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
local uiContainer = Instance.new("Frame", gui)
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
        local discFrame = Instance.new("Frame", f); discFrame.Size = UDim2.new(1, -10, 0, 45); discFrame.Position = UDim2.new(0, 5, 0, 40); discFrame.BackgroundColor3 = Color3.fromRGB(40, 60, 160); Instance.new("UICorner", discFrame)
        local discStroke = Instance.new("UIStroke", discFrame); discStroke.Color = Color3.fromRGB(114, 137, 218); discStroke.Thickness = 1
        local discLink = Instance.new("TextButton", discFrame); discLink.Size = UDim2.new(1, 0, 1, 0); discLink.Text = "Support Discord:\ndiscord.gg/SrWXXsNaE"; discLink.TextColor3 = Color3.fromRGB(255, 255, 255); discLink.TextSize = 10; discLink.BackgroundTransparency = 1; discLink.Font = Enum.Font.GothamBold
        discLink.MouseButton1Click:Connect(function() setclipboard("https://discord.gg/SrWXXsNaE"); zorxNotif("Discord Copied!") end)
    end
    
    local s = Instance.new("ScrollingFrame", f); s.Size = UDim2.new(1,-10,1,-110); s.Position = UDim2.new(0,5,0,105); s.BackgroundTransparency = 1; s.CanvasSize = UDim2.new(0,0,3.5,0); s.ScrollBarThickness = 2
    if not isMain then s.Size = UDim2.new(1,-10,1,-50); s.Position = UDim2.new(0,5,0,40) end
    Instance.new("UIListLayout", s).Padding = UDim.new(0,5); return f, s
end

local zorxFrame, zorxScroll = createWindow("ZorxHUB", UDim2.new(0,0,0,0), true)
local emoFrame, emoScroll = createWindow("Emoticon", UDim2.new(0,220,0,0), false)
local staffFrame, staffScroll = createWindow("STAFF TOOLS", UDim2.new(0,440,0,0), false)

zorxFrame.BackgroundColor3 = Color3.fromRGB(40, 0, 40)
emoFrame.BackgroundColor3  = Color3.fromRGB(0, 40, 40)
staffFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 0)

-- NOTE FRAME
local noteFrame = Instance.new("Frame", gui)
noteFrame.Size = UDim2.new(0, 220, 0, 50)
noteFrame.Position = UDim2.new(0.5, 120, 0.5, -205)
noteFrame.BackgroundTransparency = 1
noteFrame.Visible = true
Instance.new("UICorner", noteFrame)

-- ===== UI NOTE DI ATAS STAFF TOOLS =====
local noteStroke = Instance.new("UIStroke", noteFrame); noteStroke.Color = Color3.fromRGB(255, 0, 0); noteStroke.Thickness = 1

local noteImage = Instance.new("ImageLabel", noteFrame)
noteImage.Size = UDim2.new(1,0,1,0)
noteImage.Position = UDim2.new(0,0,0,0)
noteImage.BackgroundTransparency = 1
noteImage.Image = "rbxassetid://85462255439341"
noteImage.ScaleType = Enum.ScaleType.Stretch
noteImage.ZIndex = 5

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
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            table.insert(otherPlayers, p)
        end
    end
    if #otherPlayers > 0 then
        local target = otherPlayers[math.random(1, #otherPlayers)]
        stickTarget = target
        player.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3.5)
        zorxNotif("Random TP to: " .. target.DisplayName)
    else zorxNotif("No target found!") end
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
addBtn("⚡ FIX LAG", staffScroll, function()

    -- Turunkan grafik
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01

    -- Hapus efek berat
    for _,v in pairs(game:GetDescendants()) do
        if v:IsA("ParticleEmitter")
        or v:IsA("Trail")
        or v:IsA("Smoke")
        or v:IsA("Fire")
        or v:IsA("Sparkles") then
            v.Enabled = false
        end
    end

    -- Kurangi texture
    for _,v in pairs(game:GetDescendants()) do
        if v:IsA("Texture") or v:IsA("Decal") then
            v.Transparency = 1
        end
    end

    -- Matikan bayangan
    game.Lighting.GlobalShadows = false
    game.Lighting.FogEnd = 9e9
    game.Lighting.Brightness = 1

    zorxNotif("Fix Lag Aktif!")

end)

-- AIMLOCK UI
local aimContainer = Instance.new("Frame", gui); aimContainer.Size = UDim2.new(0, 140, 0, 45); aimContainer.Position = UDim2.new(1, -150, 0, 15); aimContainer.BackgroundTransparency = 1
local aimlockBtn = Instance.new("TextButton", aimContainer); aimlockBtn.Size = UDim2.new(0, 100, 1, 0); aimlockBtn.Text = "AIM: OFF"; aimlockBtn.BackgroundColor3 = Color3.fromRGB(50, 0, 0); aimlockBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", aimlockBtn); Instance.new("UIStroke", aimlockBtn).Color = Color3.fromRGB(200,0,0)
local aimToggle = Instance.new("TextButton", aimContainer); aimToggle.Size = UDim2.new(0, 35, 0, 35); aimToggle.Position = UDim2.new(0, 105, 0, 5); aimToggle.Text = "▢"; aimToggle.BackgroundColor3 = Color3.fromRGB(10, 10, 10); aimToggle.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", aimToggle); Instance.new("UIStroke", aimToggle).Color = Color3.fromRGB(200,0,0)

-- FLY BUTTONS
local upBtn = Instance.new("TextButton", gui); upBtn.Size = UDim2.new(0,60,0,60); upBtn.Position = UDim2.new(1,-80, 0.4, 0); upBtn.Text = "UP"; upBtn.Visible = false; upBtn.BackgroundColor3 = Color3.fromRGB(20,20,20); upBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", upBtn); Instance.new("UIStroke", upBtn).Color = Color3.fromRGB(255,0,0)
local downBtn = Instance.new("TextButton", gui); downBtn.Size = UDim2.new(0,60,0,60); downBtn.Position = UDim2.new(1,-80, 0.52, 0); downBtn.Text = "DOWN"; downBtn.Visible = false; downBtn.BackgroundColor3 = Color3.fromRGB(20,20,20); downBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", downBtn); Instance.new("UIStroke", downBtn).Color = Color3.fromRGB(255,0,0)
_G.UpBtn, _G.DownBtn = upBtn, downBtn

-- ===== 4. ENGINE =====
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


    -- ===== FLY INF =====
    if flyInf then
        root.AssemblyLinearVelocity =
            camera.CFrame.LookVector *
            (hum.MoveDirection.Magnitude > 0 and 150 or 0)
            + Vector3.new(0,1.5,0)
    end


    -- ===== STICK PLAYER =====
    if stickTarget and stickTarget.Character and stickTarget.Character:FindFirstChild("HumanoidRootPart") then

        local tRoot = stickTarget.Character.HumanoidRootPart

        if (root.Position - tRoot.Position).Magnitude > 20
        or stickTarget.Character.Humanoid.Health <= 0 then

            stickTarget = nil
            hum.PlatformStand = false
            zorxNotif("Auto-Release!")

        else
            root.CFrame = tRoot.CFrame * CFrame.new(0,0,3.5)
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
-- ===== LOGO PERMANEN FIX DI KIRI =====
local function createFixedLogo()

    if game.CoreGui:FindFirstChild("ZorxLogoGui") then return end

    local logoGui = Instance.new("ScreenGui")
    logoGui.Name = "ZorxLogoGui"
    logoGui.Parent = game.CoreGui
    logoGui.ResetOnSpawn = false

    local logo = Instance.new("ImageButton")
    logo.Parent = logoGui
    logo.Size = UDim2.new(0,50,0,50)
    logo.Position = UDim2.new(0,10,0.5,-25)
    logo.BackgroundTransparency = 1
    logo.Image = "rbxassetid://120640380150905"
    logo.ZIndex = 999

    logo.MouseButton1Click:Connect(function()

    if uiContainer and uiContainer.Parent then
        uiContainer.Visible = not uiContainer.Visible
    end

    if noteFrame and noteFrame.Parent then
        noteFrame.Visible = not noteFrame.Visible
    end

end)

end -- tutup function createFixedLogo

createFixedLogo()
player.CharacterAdded:Connect(function(char)
    flying = false
    flyInf = false
    stickTarget = nil
    -- lockTarget biarkan tetap sama
    if _G.UpBtn then _G.UpBtn.Visible = false end
    if _G.DownBtn then _G.DownBtn.Visible = false end
    zorxNotif("Respawn detected, aimlock tetap aktif!")
end)

zorxNotif("Welcome Back ZORXHUB😈")

