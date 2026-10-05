--============================================================
-- ZORX HUB - TSB EDITION (ALL IN ONE)
-- FLY + FIX LAG + AIMLOCK + ANTI DEATH PUNCH + AWAKEN HIGHLIGHT
--============================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

local Colors = {
	Background   = Color3.fromRGB(15, 15, 18),
	Sidebar      = Color3.fromRGB(18, 18, 22),
	Panel        = Color3.fromRGB(22, 22, 27),
	Slot         = Color3.fromRGB(28, 28, 34),
	SlotHover    = Color3.fromRGB(38, 38, 46),
	Text         = Color3.fromRGB(240, 240, 240),
	SubText      = Color3.fromRGB(140, 140, 150),
	ToggleOn     = Color3.fromRGB(255, 255, 255),
	ToggleOff    = Color3.fromRGB(60, 60, 70),
	Stroke       = Color3.fromRGB(45, 45, 55),
}

local State = {
	FlyMode = false,
	TeleportPlayer = false,
	TeleportRandom = false,
	SelectedTarget = nil,
	AutoFarm = false,
	AimLock = false,
	AntiDeathPunch = false,
	AutoBlock = false,
	FixLag = false,
}

--============================================================
-- FIX LAG SYSTEM
--============================================================
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")

local fixLagConn = nil
local fixLagRemoved = 0
local fixLagActive = false

local savedLighting = {}
local savedRendering = {}

local LAG_KEYWORDS = {
    "tree", "trees", "leaf", "leaves", "bush", "grass", "plant",
    "flower", "rock", "stone", "cactus", "fern", "moss",
    "vine", "branch", "trunk", "foliage", "shrub",
    "decoration", "decor", "prop", "fence", "lamp"
}

local function isLagName(name)
    local n = name:lower()
    for _, kw in ipairs(LAG_KEYWORDS) do
        if n:find(kw) then return true end
    end
    return false
end

local function safeDestroy(obj)
    if obj and obj.Parent then
        pcall(function() obj:Destroy() end)
        return true
    end
    return false
end

local function processFixLagObject(obj)
    if not obj or not obj.Parent then return end

    if obj:IsA("BasePart") or obj:IsA("Model") then
        if isLagName(obj.Name) then
            if safeDestroy(obj) then fixLagRemoved = fixLagRemoved + 1 end
            return
        end
        if obj:IsA("BasePart") then
            pcall(function()
                obj.Material = Enum.Material.SmoothPlastic
                obj.Reflectance = 0
                obj.CastShadow = false
            end)
        end
    elseif obj:IsA("ParticleEmitter")
        or obj:IsA("Trail")
        or obj:IsA("Smoke")
        or obj:IsA("Fire")
        or obj:IsA("Sparkles")
    then
        if safeDestroy(obj) then fixLagRemoved = fixLagRemoved + 1 end
    elseif obj:IsA("Decal") or obj:IsA("Texture") then
        if safeDestroy(obj) then fixLagRemoved = fixLagRemoved + 1 end
    elseif obj:IsA("Beam") then
        pcall(function() obj.Enabled = false end)
        fixLagRemoved = fixLagRemoved + 1
    end
end

local function fixLagStart()
    if fixLagActive then return end
    fixLagActive = true
    fixLagRemoved = 0

    pcall(function()
        if setfpscap then setfpscap(240) end
    end)

    savedLighting.GlobalShadows = Lighting.GlobalShadows
    savedLighting.FogEnd = Lighting.FogEnd
    savedLighting.Brightness = Lighting.Brightness
    savedLighting.EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale
    savedLighting.EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale

    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Lighting.Brightness = 1
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0
    end)

    savedLighting.PostEffects = {}
    for _, v in ipairs(Lighting:GetChildren()) do
        if v:IsA("PostEffect") then
            table.insert(savedLighting.PostEffects, {obj = v, enabled = v.Enabled})
            pcall(function() v.Enabled = false end)
        end
    end

    pcall(function()
        savedRendering.QualityLevel = settings().Rendering.QualityLevel
        savedRendering.MeshPartDetailLevel = settings().Rendering.MeshPartDetailLevel

        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
    end)

    savedLighting.Terrain = nil
    pcall(function()
        local terrain = Workspace:FindFirstChildOfClass("Terrain")
        if terrain then
            savedLighting.Terrain = {
                obj = terrain,
                WaterWaveSize = terrain.WaterWaveSize,
                WaterWaveSpeed = terrain.WaterWaveSpeed,
                WaterReflectance = terrain.WaterReflectance,
                WaterTransparency = terrain.WaterTransparency,
                Decoration = terrain.Decoration
            }
            terrain.WaterWaveSize = 0
            terrain.WaterWaveSpeed = 0
            terrain.WaterReflectance = 0
            terrain.WaterTransparency = 1
            terrain.Decoration = false
        end
    end)

    for _, obj in ipairs(Workspace:GetDescendants()) do
        processFixLagObject(obj)
    end

    fixLagConn = Workspace.DescendantAdded:Connect(function(obj)
        task.defer(function()
            if obj and obj.Parent and fixLagActive then
                processFixLagObject(obj)
            end
        end)
    end)

    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "⚡ ZORX Fix Lag",
            Text = fixLagRemoved .. " object dihapus | ON",
            Duration = 4
        })
    end)

    print("[ZORX Fix Lag] ON - " .. fixLagRemoved .. " object dihapus")
end

local function fixLagStop()
    if not fixLagActive then return end
    fixLagActive = false

    if fixLagConn then
        fixLagConn:Disconnect()
        fixLagConn = nil
    end

    pcall(function()
        Lighting.GlobalShadows = savedLighting.GlobalShadows
        Lighting.FogEnd = savedLighting.FogEnd
        Lighting.Brightness = savedLighting.Brightness
        Lighting.EnvironmentDiffuseScale = savedLighting.EnvironmentDiffuseScale
        Lighting.EnvironmentSpecularScale = savedLighting.EnvironmentSpecularScale
    end)

    if savedLighting.PostEffects then
        for _, data in ipairs(savedLighting.PostEffects) do
            if data.obj and data.obj.Parent then
                pcall(function() data.obj.Enabled = data.enabled end)
            end
        end
        savedLighting.PostEffects = nil
    end

    pcall(function()
        if savedRendering.QualityLevel then
            settings().Rendering.QualityLevel = savedRendering.QualityLevel
        end
        if savedRendering.MeshPartDetailLevel then
            settings().Rendering.MeshPartDetailLevel = savedRendering.MeshPartDetailLevel
        end
    end)

    if savedLighting.Terrain and savedLighting.Terrain.obj then
        local t = savedLighting.Terrain
        pcall(function()
            t.obj.WaterWaveSize = t.WaterWaveSize
            t.obj.WaterWaveSpeed = t.WaterWaveSpeed
            t.obj.WaterReflectance = t.WaterReflectance
            t.obj.WaterTransparency = t.WaterTransparency
            t.obj.Decoration = t.Decoration
        end)
        savedLighting.Terrain = nil
    end

    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "⚡ ZORX Fix Lag",
            Text = "OFF - Setting di-restore",
            Duration = 3
        })
    end)

    print("[ZORX Fix Lag] OFF")
end

--============================================================
-- FLY SYSTEM
--============================================================
local flyConnection
local flyLinearVel, flyAlignOri, flyAttachPos, flyAttachOri
local flyV = 0
local flySpeed = 85
local flyActive = false

local function flyCleanup()
	if flyConnection then flyConnection:Disconnect() flyConnection = nil end
	if flyLinearVel then flyLinearVel:Destroy() flyLinearVel = nil end
	if flyAlignOri then flyAlignOri:Destroy() flyAlignOri = nil end
	if flyAttachPos then flyAttachPos:Destroy() flyAttachPos = nil end
	if flyAttachOri then flyAttachOri:Destroy() flyAttachOri = nil end

	local char = player.Character
	if char then
		local hum = char:FindFirstChild("Humanoid")
		if hum then
			hum.PlatformStand = false
		end
	end
end

local function flyStart()
	if flyActive then return end
	flyActive = true

	flyConnection = RunService.Heartbeat:Connect(function()
		if not flyActive then return end

		local char = player.Character
		if not char then return end

		local hum = char:FindFirstChild("Humanoid")
		local root = char:FindFirstChild("HumanoidRootPart")
		if not hum or not root or hum.Health <= 0 then return end

		hum.PlatformStand = true

		if not flyAttachPos or flyAttachPos.Parent ~= root then
			if flyAttachPos then flyAttachPos:Destroy() end
			flyAttachPos = Instance.new("Attachment")
			flyAttachPos.Name = "FlyA1"
			flyAttachPos.Parent = root
		end
		if not flyAttachOri or flyAttachOri.Parent ~= root then
			if flyAttachOri then flyAttachOri:Destroy() end
			flyAttachOri = Instance.new("Attachment")
			flyAttachOri.Name = "FlyA2"
			flyAttachOri.Parent = root
		end

		if not flyLinearVel or flyLinearVel.Parent ~= root then
			if flyLinearVel then flyLinearVel:Destroy() end
			flyLinearVel = Instance.new("LinearVelocity")
			flyLinearVel.Attachment0 = flyAttachPos
			flyLinearVel.MaxForce = 50000
			flyLinearVel.RelativeTo = Enum.ActuatorRelativeTo.World
			flyLinearVel.Parent = root
		end

		if not flyAlignOri or flyAlignOri.Parent ~= root then
			if flyAlignOri then flyAlignOri:Destroy() end
			flyAlignOri = Instance.new("AlignOrientation")
			flyAlignOri.Attachment0 = flyAttachOri
			flyAlignOri.Mode = Enum.OrientationAlignmentMode.OneAttachment
			flyAlignOri.MaxTorque = 50000
			flyAlignOri.Responsiveness = 30
			flyAlignOri.Parent = root
		end

		flyAlignOri.CFrame = camera.CFrame

		local move = hum.MoveDirection
		local targetVel = (move * flySpeed) + Vector3.new(0, flyV, 0)
		if flyV == 0 then
			targetVel = Vector3.new(targetVel.X, 0, targetVel.Z)
		end

		flyLinearVel.VectorVelocity = targetVel
	end)
end

local function flyStop()
	if not flyActive and not flyConnection then
		flyCleanup()
		return
	end

	flyActive = false
	flyV = 0
	flyCleanup()

	local char = player.Character
	if char then
		local hum = char:FindFirstChild("Humanoid")
		local root = char:FindFirstChild("HumanoidRootPart")
		if hum then
			hum.PlatformStand = false
			hum.WalkSpeed = 16
			hum.JumpPower = 50
		end
		if root then
			root.AssemblyLinearVelocity = Vector3.zero
			root.AssemblyAngularVelocity = Vector3.zero
		end
	end

	pcall(function()
		local hum = char and char:FindFirstChild("Humanoid")
		if camera and hum then
			camera.CameraSubject = hum
			camera.CameraType = Enum.CameraType.Custom
		end
	end)
end

local flyControlGui = Instance.new("ScreenGui")
flyControlGui.Name = "ZorxFlyControls"
flyControlGui.ResetOnSpawn = false
flyControlGui.Parent = playerGui
flyControlGui.Enabled = false

local flyContainer = Instance.new("Frame", flyControlGui)
flyContainer.AnchorPoint = Vector2.new(0.5, 0.5)
flyContainer.Size = UDim2.new(0, 65, 0, 140)
flyContainer.Position = UDim2.new(1, -55, 0.5, 0)
flyContainer.BackgroundTransparency = 1

local flyLayout = Instance.new("UIListLayout", flyContainer)
flyLayout.FillDirection = Enum.FillDirection.Vertical
flyLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
flyLayout.VerticalAlignment = Enum.VerticalAlignment.Center
flyLayout.Padding = UDim.new(0, 15)

local flyUpBtn = Instance.new("TextButton", flyContainer)
flyUpBtn.Size = UDim2.new(0, 60, 0, 60)
flyUpBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
flyUpBtn.Text = "↑"
flyUpBtn.TextColor3 = Color3.fromRGB(255, 60, 60)
flyUpBtn.Font = Enum.Font.GothamBlack
flyUpBtn.TextSize = 34
flyUpBtn.AutoButtonColor = false
flyUpBtn.BorderSizePixel = 0
Instance.new("UICorner", flyUpBtn).CornerRadius = UDim.new(0, 12)
local flyUpStroke = Instance.new("UIStroke", flyUpBtn)
flyUpStroke.Color = Color3.fromRGB(255, 0, 0)
flyUpStroke.Thickness = 1.5
flyUpStroke.Transparency = 0.2

local flyDownBtn = Instance.new("TextButton", flyContainer)
flyDownBtn.Size = UDim2.new(0, 60, 0, 60)
flyDownBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
flyDownBtn.Text = "↓"
flyDownBtn.TextColor3 = Color3.fromRGB(255, 60, 60)
flyDownBtn.Font = Enum.Font.GothamBlack
flyDownBtn.TextSize = 34
flyDownBtn.AutoButtonColor = false
flyDownBtn.BorderSizePixel = 0
Instance.new("UICorner", flyDownBtn).CornerRadius = UDim.new(0, 12)
local flyDownStroke = Instance.new("UIStroke", flyDownBtn)
flyDownStroke.Color = Color3.fromRGB(255, 0, 0)
flyDownStroke.Thickness = 1.5
flyDownStroke.Transparency = 0.2

local function flyTouchEffect(btn, stroke, active)
	if active then
		TweenService:Create(btn, TweenInfo.new(0.15), {
			BackgroundColor3 = Color3.fromRGB(120, 0, 0),
			Size = UDim2.new(0, 68, 0, 68)
		}):Play()
		TweenService:Create(stroke, TweenInfo.new(0.15), {
			Transparency = 0, Thickness = 2.5
		}):Play()
	else
		TweenService:Create(btn, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.fromRGB(20, 20, 20),
			Size = UDim2.new(0, 60, 0, 60)
		}):Play()
		TweenService:Create(stroke, TweenInfo.new(0.2), {
			Transparency = 0.2, Thickness = 1.5
		}):Play()
	end
end

flyUpBtn.MouseButton1Down:Connect(function()
	flyV = flySpeed
	flyTouchEffect(flyUpBtn, flyUpStroke, true)
end)
flyUpBtn.MouseButton1Up:Connect(function()
	flyV = 0
	flyTouchEffect(flyUpBtn, flyUpStroke, false)
end)
flyUpBtn.MouseLeave:Connect(function()
	flyV = 0
	flyTouchEffect(flyUpBtn, flyUpStroke, false)
end)

flyDownBtn.MouseButton1Down:Connect(function()
	flyV = -flySpeed
	flyTouchEffect(flyDownBtn, flyDownStroke, true)
end)
flyDownBtn.MouseButton1Up:Connect(function()
	flyV = 0
	flyTouchEffect(flyDownBtn, flyDownStroke, false)
end)
flyDownBtn.MouseLeave:Connect(function()
	flyV = 0
	flyTouchEffect(flyDownBtn, flyDownStroke, false)
end)

player.CharacterAdded:Connect(function()
	task.wait(0.5)
	if flyActive then
		flyCleanup()
		flyActive = false
		task.wait(0.1)
		flyStart()
	end
end)

--============================================================
-- AIMLOCK SYSTEM
--============================================================
local aimlockOn = false
local lockTarget = nil
local bodyOutline = nil
local lastTP = 0
local TP_COOLDOWN = 0.8
local TP_DISTANCE = 3.5

local aimlockConnections = {}
local aimlockRenderConn = nil

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

local function checkRealBlock(character)
    if not character then return false, "no-char" end

    local hum = character:FindFirstChildOfClass("Humanoid")
    if not hum then return false, "no-hum" end

    local BLOCK_ATTRS = {
        "Blocking", "IsBlocking", "Blocked", "IsBlocked",
        "IsGuarding", "GuardActive"
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

-- AIMLOCK GUI
local aimGui = Instance.new("ScreenGui")
aimGui.Name = "NzkAimlock"
aimGui.ResetOnSpawn = false
aimGui.Parent = game.CoreGui
aimGui.Enabled = false

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
aimlockBtn.AutoButtonColor = false
Instance.new("UICorner", aimlockBtn)
Instance.new("UIStroke", aimlockBtn).Color = Color3.fromRGB(200, 0, 0)

local aimToggle = Instance.new("TextButton", aimContainer)
aimToggle.Size = UDim2.new(0, 35, 0, 35)
aimToggle.Position = UDim2.new(0, 105, 0, 5)
aimToggle.Text = "▢"
aimToggle.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
aimToggle.TextColor3 = Color3.new(1, 1, 1)
aimToggle.Font = Enum.Font.GothamBold
aimToggle.AutoButtonColor = false
Instance.new("UICorner", aimToggle)
Instance.new("UIStroke", aimToggle).Color = Color3.fromRGB(200, 0, 0)

local toggleConn = aimToggle.MouseButton1Click:Connect(function()
    aimlockBtn.Visible = not aimlockBtn.Visible
    aimToggle.Text = aimlockBtn.Visible and "▢" or "_"
end)
table.insert(aimlockConnections, toggleConn)

local lockBtnConn = aimlockBtn.MouseButton1Click:Connect(function()
    if not State.AimLock then return end

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
table.insert(aimlockConnections, lockBtnConn)

local function aimlockStart()
    aimlockOn = false
    lockTarget = nil
    removeOutline()

    aimlockBtn.Text = "AIM: OFF"
    aimlockBtn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
    aimlockBtn.Visible = true
    aimToggle.Text = "▢"
    aimGui.Enabled = true

    if aimlockRenderConn then
        pcall(function() aimlockRenderConn:Disconnect() end)
        aimlockRenderConn = nil
    end

    aimlockRenderConn = RunService.RenderStepped:Connect(function()
        if not State.AimLock then return end
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

        local blocking = checkRealBlock(lockTarget.Parent)
        if blocking then
            local now = tick()
            if now - lastTP >= TP_COOLDOWN then
                lastTP = now
                teleportBehind(lockTarget.Parent)
            end
        end
    end)

    print("[AIMLOCK] ON")
end

local function aimlockForceStop()
    aimlockOn = false
    lockTarget = nil
    lastTP = 0

    if aimlockRenderConn then
        pcall(function() aimlockRenderConn:Disconnect() end)
        aimlockRenderConn = nil
    end

    aimGui.Enabled = false
    aimlockBtn.Text = "AIM: OFF"
    aimlockBtn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
    aimlockBtn.Visible = true
    aimToggle.Text = "▢"

    removeOutline()

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

    print("[AIMLOCK] OFF - Reset total")
end

--============================================================
-- AWAKENING HIGHLIGHT (TSB) - DETECT "Ulted" attribute
--============================================================
local awakenTracked = {}
local awakenActive = false
local awakenConn = nil
local awakenHeartbeat = nil

local AWAKEN_ATTRS = {
    "Ulted", "UsedUltimate", "JustUlted",
    "Awakening", "Awakened", "UltimateActive",
    "IsUltimate", "Mode", "FinalForm"
}

local function awakenApplyHighlight(character)
    if not character then return end

    local data = awakenTracked[character]
    if data and data.highlight and data.highlight.Parent then return end

    for _, child in ipairs(character:GetChildren()) do
        if child:IsA("Highlight") and child.Name == "ZorxAwakenHL" then
            child:Destroy()
        end
    end

    local hl = Instance.new("Highlight")
    hl.Name = "ZorxAwakenHL"
    hl.Adornee = character
    hl.FillTransparency = 1
    hl.OutlineColor = Color3.fromRGB(255, 0, 0)
    hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent = character

    if data then data.highlight = hl end
end

local function awakenRemoveHighlight(character)
    if not character then return end
    for _, child in ipairs(character:GetChildren()) do
        if child:IsA("Highlight") and child.Name == "ZorxAwakenHL" then
            pcall(function() child:Destroy() end)
        end
    end
    local data = awakenTracked[character]
    if data then data.highlight = nil end
end

local function awakenIsAwakening(character)
    if not character then return false end
    local hum = character:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return false end

    local ok, val = pcall(function() return character:GetAttribute("Ulted") end)
    if ok and val == true then return true end

    local ok2, val2 = pcall(function() return hum:GetAttribute("Ulted") end)
    if ok2 and val2 == true then return true end

    for _, attr in ipairs(AWAKEN_ATTRS) do
        if attr ~= "Ulted" then
            local okA, valA = pcall(function() return character:GetAttribute(attr) end)
            if okA and valA == true then return true end
        end
    end

    return false
end

local function awakenCheckCharacter(character)
    if not character then return end
    if character == player.Character then return end

    local hum = character:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    if not awakenTracked[character] then
        awakenTracked[character] = { isAwaken = false, highlight = nil }
    end
    local data = awakenTracked[character]

    local isAwake = awakenIsAwakening(character)

    if isAwake and not data.isAwaken then
        data.isAwaken = true
        awakenApplyHighlight(character)
    end

    if not isAwake and data.isAwaken then
        data.isAwaken = false
        awakenRemoveHighlight(character)
    end

    if isAwake then
        awakenApplyHighlight(character)
    end
end

local awakenLastScan = 0

local function awakenStart()
    if awakenActive then return end
    awakenActive = true

    awakenHeartbeat = RunService.Heartbeat:Connect(function()
        if not awakenActive then return end
        if tick() - awakenLastScan < 0.2 then return end
        awakenLastScan = tick()

        local Live = Workspace:FindFirstChild("Live")
        if not Live then return end

        for _, obj in ipairs(Live:GetChildren()) do
            if obj:IsA("Model") then
                awakenCheckCharacter(obj)
            end
        end
    end)

    task.spawn(function()
        local Live = Workspace:FindFirstChild("Live") or Workspace:WaitForChild("Live", 15)
        if not Live then return end

        Live.ChildAdded:Connect(function(obj)
            if obj:IsA("Model") then
                task.wait(0.2)
                awakenCheckCharacter(obj)
            end
        end)

        Live.ChildRemoved:Connect(function(obj)
            if obj:IsA("Model") then
                awakenTracked[obj] = nil
                awakenRemoveHighlight(obj)
            end
        end)
    end)

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            plr.Character.AttributeChanged:Connect(function(attr)
                if attr == "Ulted" or attr == "UsedUltimate" or attr == "JustUlted" then
                    local val = plr.Character:GetAttribute(attr)
                    if val == true then
                        awakenCheckCharacter(plr.Character)
                    end
                end
            end)
        end
    end

    print("[ZORX] Awakening Highlight ON")
end

local function awakenStop()
    if not awakenActive then return end
    awakenActive = false

    if awakenHeartbeat then
        pcall(function() awakenHeartbeat:Disconnect() end)
        awakenHeartbeat = nil
    end

    for char, _ in pairs(awakenTracked) do
        awakenRemoveHighlight(char)
    end
    awakenTracked = {}

    print("[ZORX] Awakening Highlight OFF")
end

--============================================================
-- ANTI DEATH PUNCH - RESPAWN PROOF (VERSI LAMA / ASLI)
-- + Auto nyalain/matiin Awakening Highlight
-- ============================================================

local AntiDeathPunchConnections = {}
local AntiDeathPunchActive = false

local function startAntiDeathPunch()
    if AntiDeathPunchActive then return end
    AntiDeathPunchActive = true

    local ADP_Players = game:GetService("Players")
    local ADP_RunService = game:GetService("RunService")
    local ADP_Workspace = game:GetService("Workspace")

    local teleportPosition = Vector3.new(
        240.31468200683594,
        -491.9150390625,
        -183.96755981445312
    )

    local holdDuration = 10
    local teleportInterval = 0.03
    local destroyRange = 25

    local ADP_player = ADP_Players.LocalPlayer
    local looping = false
    local cameraLocked = false
    local freezeActive = false
    local watchedCharacters = {}
    local savedCFrame = nil

    local function getChar()
        return ADP_player.Character
    end

    local function getRoot()
        local char = getChar()
        if not char then return nil end
        return char:FindFirstChild("HumanoidRootPart")
    end

    local function getHumanoid()
        local char = getChar()
        if not char then return nil end
        return char:FindFirstChildOfClass("Humanoid")
    end

    local function destroyConstraints(char)
        if not char then return 0 end
        local count = 0

        for _, obj in ipairs(char:GetDescendants()) do
            local shouldDestroy = false

            if obj:IsA("AlignPosition")
            or obj:IsA("AlignOrientation")
            or obj:IsA("BodyPosition")
            or obj:IsA("BodyGyro")
            or obj:IsA("BodyVelocity")
            or obj:IsA("BodyForce")
            or obj:IsA("LinearVelocity")
            or obj:IsA("AngularVelocity")
            or obj:IsA("VectorForce")
            or obj:IsA("RopeConstraint")
            or obj:IsA("RodConstraint")
            or obj:IsA("SpringConstraint")
            or obj:IsA("BallSocketConstraint")
            or obj:IsA("HingeConstraint")
            or obj:IsA("PrismaticConstraint")
            or obj:IsA("UniversalConstraint")
            or obj:IsA("CylindricalConstraint")
            or obj:IsA("PlaneConstraint")
            or obj:IsA("WeldConstraint")
            then
                shouldDestroy = true
            end

            if obj:IsA("Weld") then
                local parent = obj.Parent
                if parent then
                    local pName = parent.Name:lower()
                    if pName:match("torso") or pName:match("head")
                    or pName:match("arm") or pName:match("leg")
                    or pName:match("hand") or pName:match("foot")
                    or pName == "humanoidrootpart" then
                        shouldDestroy = false
                    else
                        shouldDestroy = true
                    end
                end
            end

            if shouldDestroy then
                pcall(function()
                    obj:Destroy()
                    count = count + 1
                end)
            end
        end

        return count
    end

    local function destroyNearbyEnemyConstraints()
        local char = getChar()
        if not char then return 0 end

        local myRoot = getRoot()
        if not myRoot then return 0 end

        local Live = ADP_Workspace:FindFirstChild("Live")
        if not Live then return 0 end

        local count = 0

        for _, otherChar in ipairs(Live:GetChildren()) do
            if otherChar:IsA("Model") and otherChar ~= char then
                local otherRoot = otherChar:FindFirstChild("HumanoidRootPart")
                if otherRoot then
                    local dist = (otherRoot.Position - myRoot.Position).Magnitude
                    if dist < destroyRange then
                        count = count + destroyConstraints(otherChar)
                    end
                end
            end
        end

        return count
    end

    local renderConn
    renderConn = ADP_RunService.RenderStepped:Connect(function()
        if not freezeActive then return end

        local root = getRoot()
        if not root then return end

        root.CFrame = CFrame.new(teleportPosition)
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero

        if cameraLocked then
            local cam = ADP_Workspace.CurrentCamera
            if cam then
                pcall(function()
                    cam.CameraType = Enum.CameraType.Scriptable
                    cam.CFrame = CFrame.new(
                        teleportPosition + Vector3.new(0, 20, 30),
                        teleportPosition
                    )
                end)
            end
        end
    end)

    local function createPlatform(position)
        local platform = Instance.new("Part")
        platform.Name = "TemporaryPlatform"
        platform.Size = Vector3.new(12, 1, 12)
        platform.Position = position
        platform.Anchored = true
        platform.CanCollide = true
        platform.CanTouch = false
        platform.CanQuery = false
        platform.Color = Color3.new(1, 0, 0)
        platform.Transparency = 0.3
        platform.Parent = ADP_Workspace
        return platform
    end

    local function loopTeleport()
        if looping then return end
        looping = true

        local char = getChar()
        if not char then looping = false return end

        local rootPart = getRoot()
        if not rootPart then looping = false return end

        savedCFrame = rootPart.CFrame

        destroyConstraints(char)
        destroyNearbyEnemyConstraints()

        cameraLocked = true

        local platform = createPlatform(
            teleportPosition + Vector3.new(0, -3, 0)
        )

        freezeActive = true

        local startTime = tick()

        while tick() - startTime < holdDuration and looping do
            local currentChar = getChar()
            if currentChar ~= char then break end

            local currentRoot = getRoot()
            if not currentRoot then break end

            currentRoot.CFrame = CFrame.new(teleportPosition)
            currentRoot.AssemblyLinearVelocity = Vector3.zero
            currentRoot.AssemblyAngularVelocity = Vector3.zero

            if math.floor((tick() - startTime) * 2) % 2 == 0 then
                destroyConstraints(currentChar)
                destroyNearbyEnemyConstraints()
            end

            task.wait(teleportInterval)
        end

        freezeActive = false
        cameraLocked = false

        if platform and platform.Parent then
            platform:Destroy()
        end

        local finalChar = getChar()
        if savedCFrame and finalChar == char then
            local finalRoot = getRoot()
            if finalRoot then
                finalRoot.CFrame = savedCFrame
                finalRoot.AssemblyLinearVelocity = Vector3.zero
                finalRoot.AssemblyAngularVelocity = Vector3.zero
            end
        end

        savedCFrame = nil
        looping = false

        task.wait(0.2)
        pcall(function()
            local cam = ADP_Workspace.CurrentCamera
            local hum = getHumanoid()
            if cam and hum then
                cam.CameraSubject = hum
                cam.CameraType = Enum.CameraType.Custom
            end
        end)
    end

    local function watchCharacter(targetCharacter)
        if not targetCharacter then return end
        if targetCharacter == ADP_player.Character then return end
        if watchedCharacters[targetCharacter] then return end

        watchedCharacters[targetCharacter] = true

        for _, obj in ipairs(targetCharacter:GetChildren()) do
            if obj.Name == "DCRecent" then
                task.spawn(loopTeleport)
            end
        end

        local connChild
        connChild = targetCharacter.ChildAdded:Connect(function(obj)
            if obj.Name == "DCRecent" then
                task.spawn(loopTeleport)
            end
        end)

        local connAnc
        connAnc = targetCharacter.AncestryChanged:Connect(function(_, parent)
            if not parent then
                watchedCharacters[targetCharacter] = nil
                if connChild then connChild:Disconnect() end
                if connAnc then connAnc:Disconnect() end
            end
        end)

        table.insert(AntiDeathPunchConnections, connChild)
        table.insert(AntiDeathPunchConnections, connAnc)
    end

    local function setupLive()
        local Live = ADP_Workspace:FindFirstChild("Live")
        if not Live then
            Live = ADP_Workspace:WaitForChild("Live", 10)
        end
        if not Live then return end

        for _, targetCharacter in ipairs(Live:GetChildren()) do
            if targetCharacter:IsA("Model") then
                watchCharacter(targetCharacter)
            end
        end

        local connLive
        connLive = Live.ChildAdded:Connect(function(targetCharacter)
            if targetCharacter:IsA("Model") then
                task.wait(0.1)
                watchCharacter(targetCharacter)
            end
        end)

        table.insert(AntiDeathPunchConnections, connLive)
    end

    local connRespawn
    connRespawn = ADP_player.CharacterAdded:Connect(function(newChar)
        looping = false
        cameraLocked = false
        freezeActive = false
        savedCFrame = nil

        for _, obj in ipairs(ADP_Workspace:GetChildren()) do
            if obj.Name == "TemporaryPlatform" then
                obj:Destroy()
            end
        end

        newChar:WaitForChild("HumanoidRootPart", 5)
        newChar:WaitForChild("Humanoid", 5)
        task.wait(2)

        pcall(function()
            local cam = ADP_Workspace.CurrentCamera
            local hum = newChar:FindFirstChildOfClass("Humanoid")
            if cam and hum then
                cam.CameraSubject = hum
                cam.CameraType = Enum.CameraType.Custom
            end
        end)

        watchedCharacters = {}
        task.spawn(setupLive)
    end)

    table.insert(AntiDeathPunchConnections, connRespawn)
    table.insert(AntiDeathPunchConnections, renderConn)

    task.spawn(setupLive)

    _G._AntiDeathPunch_Cleanup = function()
        for _, conn in ipairs(AntiDeathPunchConnections) do
            pcall(function() conn:Disconnect() end)
        end
        AntiDeathPunchConnections = {}

        looping = false
        cameraLocked = false
        freezeActive = false
        savedCFrame = nil
        watchedCharacters = {}

        for _, obj in ipairs(ADP_Workspace:GetChildren()) do
            if obj.Name == "TemporaryPlatform" then
                obj:Destroy()
            end
        end

        pcall(function()
            local cam = ADP_Workspace.CurrentCamera
            local hum = getHumanoid()
            if cam and hum then
                cam.CameraSubject = hum
                cam.CameraType = Enum.CameraType.Custom
            end
        end)
    end

    -- 🔥 Auto nyalain Awakening Highlight bareng ADP
    if awakenStart then awakenStart() end

    pcall(function()
        game.StarterGui:SetCore("SendNotification", {
            Title = "zorX anti Puch",
            Text = "ON + Awakening Highlight",
            Duration = 5
        })
    end)
end

local function stopAntiDeathPunch()
    if not AntiDeathPunchActive then return end
    AntiDeathPunchActive = false

    if _G._AntiDeathPunch_Cleanup then
        pcall(_G._AntiDeathPunch_Cleanup)
        _G._AntiDeathPunch_Cleanup = nil
    end

    -- 🔥 Auto matiin Awakening Highlight bareng ADP
    if awakenStop then awakenStop() end

    pcall(function()
        game.StarterGui:SetCore("SendNotification", {
            Title = "ZorX anti Puch",
            Text = "OFF + Awakening Highlight",
            Duration = 3
        })
    end)
end

--============================================================
-- UI CODE
--============================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZorXHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = playerGui

local PopupLayer = Instance.new("Frame")
PopupLayer.Name = "PopupLayer"
PopupLayer.Size = UDim2.new(1, 0, 1, 0)
PopupLayer.BackgroundTransparency = 1
PopupLayer.ZIndex = 50
PopupLayer.Parent = ScreenGui

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 500, 0, 320)
Main.Position = UDim2.new(0.5, -250, 0.5, -160)
Main.BackgroundColor3 = Colors.Background
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Colors.Stroke
MainStroke.Thickness = 1
MainStroke.Parent = Main

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BackgroundColor3 = Colors.Background
TopBar.BorderSizePixel = 0
TopBar.Parent = Main

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 8)
TopBarCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0, 250, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "zorX  |  Tsb"
Title.TextColor3 = Colors.Text
Title.Font = Enum.Font.GothamMedium
Title.TextSize = 12
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -30, 0.5, -13)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 12
CloseBtn.AutoButtonColor = false
CloseBtn.Active = true
CloseBtn.ZIndex = 5
CloseBtn.Parent = TopBar

CloseBtn.MouseEnter:Connect(function()
	TweenService:Create(CloseBtn, TweenInfo.new(0.15), {
		TextColor3 = Color3.fromRGB(255, 80, 80)
	}):Play()
end)
CloseBtn.MouseLeave:Connect(function()
	TweenService:Create(CloseBtn, TweenInfo.new(0.15), {
		TextColor3 = Color3.fromRGB(200, 200, 200)
	}):Play()
end)

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Size = UDim2.new(0, 45, 0, 45)
MinimizeBtn.Position = UDim2.new(0.5, -22, 0.5, -22)
MinimizeBtn.BackgroundColor3 = Colors.Background
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.Text = "Z"
MinimizeBtn.TextColor3 = Colors.Text
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 26
MinimizeBtn.AutoButtonColor = false
MinimizeBtn.ZIndex = 60
MinimizeBtn.Visible = false
MinimizeBtn.Active = true
MinimizeBtn.Draggable = true
MinimizeBtn.Parent = ScreenGui

local MinimizeStroke = Instance.new("UIStroke")
MinimizeStroke.Color = Colors.Stroke
MinimizeStroke.Thickness = 1
MinimizeStroke.Parent = MinimizeBtn

MinimizeBtn.MouseEnter:Connect(function()
	TweenService:Create(MinimizeBtn, TweenInfo.new(0.15), {
		BackgroundColor3 = Colors.SlotHover
	}):Play()
end)
MinimizeBtn.MouseLeave:Connect(function()
	TweenService:Create(MinimizeBtn, TweenInfo.new(0.15), {
		BackgroundColor3 = Colors.Background
	}):Play()
end)

local function setUIOpen(open)
	Main.Visible = open
	PopupLayer.Visible = open
	MinimizeBtn.Visible = not open
end

CloseBtn.MouseButton1Click:Connect(function()
	setUIOpen(false)
end)

MinimizeBtn.MouseButton1Click:Connect(function()
	setUIOpen(true)
end)

local TopDivider = Instance.new("Frame")
TopDivider.Name = "TopDivider"
TopDivider.Size = UDim2.new(1, 0, 0, 1)
TopDivider.Position = UDim2.new(0, 0, 0, 30)
TopDivider.BackgroundColor3 = Colors.Stroke
TopDivider.BorderSizePixel = 0
TopDivider.Parent = Main

local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 120, 1, -31)
Sidebar.Position = UDim2.new(0, 0, 0, 31)
Sidebar.BackgroundColor3 = Colors.Sidebar
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

local SidebarList = Instance.new("UIListLayout")
SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
SidebarList.Padding = UDim.new(0, 2)
SidebarList.Parent = Sidebar

local SidebarPad = Instance.new("UIPadding")
SidebarPad.PaddingTop = UDim.new(0, 8)
SidebarPad.PaddingLeft = UDim.new(0, 6)
SidebarPad.PaddingRight = UDim.new(0, 6)
SidebarPad.Parent = Sidebar

local SidebarDivider = Instance.new("Frame")
SidebarDivider.Name = "SidebarDivider"
SidebarDivider.Size = UDim2.new(0, 1, 1, -31)
SidebarDivider.Position = UDim2.new(0, 120, 0, 31)
SidebarDivider.BackgroundColor3 = Colors.Stroke
SidebarDivider.BorderSizePixel = 0
SidebarDivider.Parent = Main

local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -121, 1, -31)
Content.Position = UDim2.new(0, 121, 0, 31)
Content.BackgroundColor3 = Colors.Panel
Content.BorderSizePixel = 0
Content.Parent = Main

local Scroll = Instance.new("ScrollingFrame")
Scroll.Name = "Scroll"
Scroll.Size = UDim2.new(1, -16, 1, -16)
Scroll.Position = UDim2.new(0, 8, 0, 8)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 4
Scroll.ScrollBarImageColor3 = Colors.Stroke
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.Parent = Content

local ScrollPad = Instance.new("UIPadding")
ScrollPad.PaddingRight = UDim.new(0, 6)
ScrollPad.Parent = Scroll

local ScrollList = Instance.new("UIListLayout")
ScrollList.SortOrder = Enum.SortOrder.LayoutOrder
ScrollList.Padding = UDim.new(0, 8)
ScrollList.Parent = Scroll

local function createSectionHeader(text, order)
	local header = Instance.new("TextLabel")
	header.Name = "Header_" .. text
	header.Size = UDim2.new(1, 0, 0, 16)
	header.BackgroundTransparency = 1
	header.Text = text
	header.TextColor3 = Colors.SubText
	header.Font = Enum.Font.GothamBold
	header.TextSize = 10
	header.TextXAlignment = Enum.TextXAlignment.Left
	header.LayoutOrder = order
	header.Parent = Scroll
	return header
end

local function createToggle(titleText, descText, order, callback, initialState)
	local row = Instance.new("Frame")
	row.Name = "Toggle_" .. titleText
	row.Size = UDim2.new(1, 0, 0, 42)
	row.BackgroundColor3 = Colors.Slot
	row.BorderSizePixel = 0
	row.LayoutOrder = order
	row.Parent = Scroll

	local rowCorner = Instance.new("UICorner")
	rowCorner.CornerRadius = UDim.new(0, 6)
	rowCorner.Parent = row

	local rowStroke = Instance.new("UIStroke")
	rowStroke.Color = Colors.Stroke
	rowStroke.Thickness = 1
	rowStroke.Parent = row

	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(1, -70, 0, 16)
	title.Position = UDim2.new(0, 10, 0, 6)
	title.BackgroundTransparency = 1
	title.Text = titleText
	title.TextColor3 = Colors.Text
	title.Font = Enum.Font.GothamMedium
	title.TextSize = 11
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = row

	local desc = Instance.new("TextLabel")
	desc.Name = "Desc"
	desc.Size = UDim2.new(1, -70, 0, 12)
	desc.Position = UDim2.new(0, 10, 0, 22)
	desc.BackgroundTransparency = 1
	desc.Text = descText
	desc.TextColor3 = Colors.SubText
	desc.Font = Enum.Font.Gotham
	desc.TextSize = 9
	desc.TextXAlignment = Enum.TextXAlignment.Left
	desc.Parent = row

	local toggleBg = Instance.new("TextButton")
	toggleBg.Name = "Toggle"
	toggleBg.Size = UDim2.new(0, 34, 0, 18)
	toggleBg.Position = UDim2.new(1, -44, 0.5, -9)
	toggleBg.BackgroundColor3 = Colors.ToggleOff
	toggleBg.BorderSizePixel = 0
	toggleBg.Text = ""
	toggleBg.AutoButtonColor = false
	toggleBg.Parent = row

	local toggleCorner = Instance.new("UICorner")
	toggleCorner.CornerRadius = UDim.new(1, 0)
	toggleCorner.Parent = toggleBg

	local knob = Instance.new("Frame")
	knob.Name = "Knob"
	knob.Size = UDim2.new(0, 14, 0, 14)
	knob.Position = UDim2.new(0, 2, 0.5, -7)
	knob.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
	knob.BorderSizePixel = 0
	knob.Parent = toggleBg

	local knobCorner = Instance.new("UICorner")
	knobCorner.CornerRadius = UDim.new(1, 0)
	knobCorner.Parent = knob

	local isOn = initialState or false
	if isOn then
		toggleBg.BackgroundColor3 = Colors.ToggleOn
		knob.Position = UDim2.new(1, -16, 0.5, -7)
		knob.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
	end

	toggleBg.MouseButton1Click:Connect(function()
		isOn = not isOn
		if isOn then
			TweenService:Create(toggleBg, TweenInfo.new(0.2), {
				BackgroundColor3 = Colors.ToggleOn
			}):Play()
			TweenService:Create(knob, TweenInfo.new(0.2), {
				Position = UDim2.new(1, -16, 0.5, -7),
				BackgroundColor3 = Color3.fromRGB(30, 30, 40)
			}):Play()
		else
			TweenService:Create(toggleBg, TweenInfo.new(0.2), {
				BackgroundColor3 = Colors.ToggleOff
			}):Play()
			TweenService:Create(knob, TweenInfo.new(0.2), {
				Position = UDim2.new(0, 2, 0.5, -7),
				BackgroundColor3 = Color3.fromRGB(180, 180, 190)
			}):Play()
		end
		if callback then callback(isOn) end
	end)

	return row, toggleBg
end

local function createDropdown(titleText, descText, order, callback, initialState)
	local row = Instance.new("Frame")
	row.Name = "Dropdown_" .. titleText
	row.Size = UDim2.new(1, 0, 0, 42)
	row.BackgroundColor3 = Colors.Slot
	row.BorderSizePixel = 0
	row.LayoutOrder = order
	row.Parent = Scroll

	local rowCorner = Instance.new("UICorner")
	rowCorner.CornerRadius = UDim.new(0, 6)
	rowCorner.Parent = row

	local rowStroke = Instance.new("UIStroke")
	rowStroke.Color = Colors.Stroke
	rowStroke.Thickness = 1
	rowStroke.Parent = row

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -130, 0, 16)
	title.Position = UDim2.new(0, 10, 0, 6)
	title.BackgroundTransparency = 1
	title.Text = titleText
	title.TextColor3 = Colors.Text
	title.Font = Enum.Font.GothamMedium
	title.TextSize = 11
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = row

	local desc = Instance.new("TextLabel")
	desc.Size = UDim2.new(1, -130, 0, 12)
	desc.Position = UDim2.new(0, 10, 0, 22)
	desc.BackgroundTransparency = 1
	desc.Text = descText
	desc.TextColor3 = Colors.SubText
	desc.Font = Enum.Font.Gotham
	desc.TextSize = 9
	desc.TextXAlignment = Enum.TextXAlignment.Left
	desc.Parent = row

	local dropBox = Instance.new("TextButton")
	dropBox.Name = "DropBox"
	dropBox.Size = UDim2.new(0, 110, 0, 24)
	dropBox.Position = UDim2.new(1, -120, 0.5, -12)
	dropBox.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
	dropBox.BorderSizePixel = 0
	dropBox.Text = initialState or "Pilih Player..."
	dropBox.TextColor3 = Colors.Text
	dropBox.Font = Enum.Font.Gotham
	dropBox.TextSize = 10
	dropBox.AutoButtonColor = false
	dropBox.Parent = row

	local dbCorner = Instance.new("UICorner")
	dbCorner.CornerRadius = UDim.new(0, 5)
	dbCorner.Parent = dropBox

	local popup = Instance.new("Frame")
	popup.Name = "Popup_" .. titleText
	popup.Size = UDim2.new(0, 0, 0, 0)
	popup.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
	popup.BorderSizePixel = 0
	popup.Visible = false
	popup.ZIndex = 100
	popup.ClipsDescendants = true
	popup.Parent = PopupLayer

	local popupCorner = Instance.new("UICorner")
	popupCorner.CornerRadius = UDim.new(0, 5)
	popupCorner.Parent = popup

	local popupStroke = Instance.new("UIStroke")
	popupStroke.Color = Colors.Stroke
	popupStroke.Thickness = 1
	popupStroke.Parent = popup

	local popupScroll = Instance.new("ScrollingFrame")
	popupScroll.Size = UDim2.new(1, 0, 1, 0)
	popupScroll.BackgroundTransparency = 1
	popupScroll.BorderSizePixel = 0
	popupScroll.ScrollBarThickness = 3
	popupScroll.ScrollBarImageColor3 = Colors.Stroke
	popupScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	popupScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	popupScroll.Parent = popup

	local popupList = Instance.new("UIListLayout")
	popupList.SortOrder = Enum.SortOrder.LayoutOrder
	popupList.Padding = UDim.new(0, 2)
	popupList.Parent = popupScroll

	local popupPad = Instance.new("UIPadding")
	popupPad.PaddingTop = UDim.new(0, 4)
	popupPad.PaddingBottom = UDim.new(0, 4)
	popupPad.PaddingLeft = UDim.new(0, 4)
	popupPad.PaddingRight = UDim.new(0, 4)
	popupPad.Parent = popupScroll

	local isOpen = false

	local function refreshPopup()
		for _, child in pairs(popupScroll:GetChildren()) do
			if child:IsA("TextButton") or child:IsA("TextLabel") then
				child:Destroy()
			end
		end

		local count = 0
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= player then
				count += 1
				local item = Instance.new("TextButton")
				item.Name = "Player_" .. p.Name
				item.Size = UDim2.new(1, -6, 0, 22)
				item.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
				item.BackgroundTransparency = 1
				item.BorderSizePixel = 0
				item.Text = p.Name
				item.TextColor3 = Colors.Text
				item.Font = Enum.Font.Gotham
				item.TextSize = 10
				item.TextXAlignment = Enum.TextXAlignment.Left
				item.AutoButtonColor = false
				item.LayoutOrder = count
				item.Parent = popupScroll

				local itemCorner = Instance.new("UICorner")
				itemCorner.CornerRadius = UDim.new(0, 4)
				itemCorner.Parent = item

				local itemPad = Instance.new("UIPadding")
				itemPad.PaddingLeft = UDim.new(0, 6)
				itemPad.Parent = item

				item.MouseEnter:Connect(function()
					TweenService:Create(item, TweenInfo.new(0.15), {
						BackgroundTransparency = 0.5,
						BackgroundColor3 = Colors.SlotHover
					}):Play()
				end)

				item.MouseLeave:Connect(function()
					TweenService:Create(item, TweenInfo.new(0.15), {
						BackgroundTransparency = 1
					}):Play()
				end)

				item.MouseButton1Click:Connect(function()
					dropBox.Text = p.Name
					State.SelectedTarget = p.Name
					isOpen = false
					TweenService:Create(popup, TweenInfo.new(0.15), {
						Size = UDim2.new(0, 110, 0, 0)
					}):Play()
					task.wait(0.15)
					popup.Visible = false
					if callback then callback(p.Name) end
				end)
			end
		end

		if count == 0 then
			local empty = Instance.new("TextLabel")
			empty.Size = UDim2.new(1, -6, 0, 22)
			empty.BackgroundTransparency = 1
			empty.Text = "Tidak ada player"
			empty.TextColor3 = Colors.SubText
			empty.Font = Enum.Font.Gotham
			empty.TextSize = 10
			empty.Parent = popupScroll
		end

		return count
	end

	dropBox.MouseButton1Click:Connect(function()
		isOpen = not isOpen
		if isOpen then
			local count = refreshPopup()
			local absPos = dropBox.AbsolutePosition
			local absSize = dropBox.AbsoluteSize
			popup.Position = UDim2.new(0, absPos.X - 3, 0, absPos.Y + absSize.Y + 2)
			popup.Visible = true
			local h = math.max(math.min(count, 5) * 24 + 8, 30)
			TweenService:Create(popup, TweenInfo.new(0.15), {
				Size = UDim2.new(0, 110, 0, h)
			}):Play()
		else
			TweenService:Create(popup, TweenInfo.new(0.15), {
				Size = UDim2.new(0, 110, 0, 0)
			}):Play()
			task.wait(0.15)
			popup.Visible = false
		end
	end)

	Players.PlayerAdded:Connect(function()
		if isOpen then refreshPopup() end
	end)
	Players.PlayerRemoving:Connect(function()
		if isOpen then refreshPopup() end
	end)

	return row, dropBox
end

local sidebarButtons = {}
local activeTab = nil

local function createSidebarButton(text, order, onClick)
	local btn = Instance.new("TextButton")
	btn.Name = text
	btn.Size = UDim2.new(1, 0, 0, 26)
	btn.BackgroundColor3 = Colors.Sidebar
	btn.BackgroundTransparency = 1
	btn.BorderSizePixel = 0
	btn.Text = ""
	btn.AutoButtonColor = false
	btn.LayoutOrder = order
	btn.Parent = Sidebar

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 5)
	btnCorner.Parent = btn

	local textLabel = Instance.new("TextLabel")
	textLabel.Name = "Label"
	textLabel.Size = UDim2.new(1, -16, 1, 0)
	textLabel.Position = UDim2.new(0, 8, 0, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = text
	textLabel.TextColor3 = Colors.SubText
	textLabel.Font = Enum.Font.GothamMedium
	textLabel.TextSize = 11
	textLabel.TextXAlignment = Enum.TextXAlignment.Left
	textLabel.Parent = btn

	btn.MouseEnter:Connect(function()
		if activeTab ~= btn then
			TweenService:Create(btn, TweenInfo.new(0.15), {
				BackgroundTransparency = 0.7,
				BackgroundColor3 = Colors.SlotHover
			}):Play()
			TweenService:Create(textLabel, TweenInfo.new(0.15), {
				TextColor3 = Colors.Text
			}):Play()
		end
	end)

	btn.MouseLeave:Connect(function()
		if activeTab ~= btn then
			TweenService:Create(btn, TweenInfo.new(0.15), {
				BackgroundTransparency = 1
			}):Play()
			TweenService:Create(textLabel, TweenInfo.new(0.15), {
				TextColor3 = Colors.SubText
			}):Play()
		end
	end)

	btn.MouseButton1Click:Connect(function()
		for _, b in pairs(sidebarButtons) do
			TweenService:Create(b, TweenInfo.new(0.15), {
				BackgroundTransparency = 1
			}):Play()
			local lbl = b:FindFirstChild("Label")
			if lbl then
				TweenService:Create(lbl, TweenInfo.new(0.15), {
					TextColor3 = Colors.SubText
				}):Play()
			end
		end
		activeTab = btn
		TweenService:Create(btn, TweenInfo.new(0.15), {
			BackgroundTransparency = 0.5,
			BackgroundColor3 = Colors.SlotHover
		}):Play()
		TweenService:Create(textLabel, TweenInfo.new(0.15), {
			TextColor3 = Colors.Text
		}):Play()

		if onClick then onClick() end
	end)

	table.insert(sidebarButtons, btn)
	return btn
end

local function clearContent()
	for _, child in pairs(Scroll:GetChildren()) do
		if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
			child:Destroy()
		end
	end

	for _, child in pairs(PopupLayer:GetChildren()) do
		child.Visible = false
	end
end

local function loadFarmPanel()
	clearContent()
	local order = 1

	createSectionHeader("COMBAT", order); order += 1

	createToggle("Auto Farm", "Otomatis farming terus menerus", order, function(state)
		State.AutoFarm = state
	end, State.AutoFarm); order += 1

	createToggle("Auto Block", "Otomatis block serangan", order, function(state)
		State.AutoBlock = state
	end, State.AutoBlock); order += 1
end

local function loadMiscPanel()
	clearContent()
	local order = 1

	createSectionHeader("MOVEMENT", order); order += 1

	createToggle("Fly Mode", "Terbang bebas di udara", order, function(state)
		State.FlyMode = state

		if state then
			flyStart()
			flyControlGui.Enabled = true
		else
			flyStop()
			flyControlGui.Enabled = false
		end
	end, State.FlyMode); order += 1

	createToggle("Aim Lock", "Kunci arah ke target otomatis", order, function(state)
		State.AimLock = state

		if state then
			aimlockStart()
		else
			aimlockForceStop()
		end
	end, State.AimLock); order += 1

	createToggle("Anti Death Punch", "Punch tanpa mati + Awakening Highlight", order, function(state)
		State.AntiDeathPunch = state

		if state then
			startAntiDeathPunch()
		else
			stopAntiDeathPunch()
		end
	end, State.AntiDeathPunch); order += 1

	createSectionHeader("TELEPORT", order); order += 1

	createDropdown("Target Player", "Pilih player target", order, function(value)
		State.SelectedTarget = value
	end, State.SelectedTarget); order += 1

	createToggle("Teleport Player", "Teleport ke player yang dipilih", order, function(state)
		State.TeleportPlayer = state
	end, State.TeleportPlayer); order += 1

	createToggle("Teleport Random", "Teleport terus ke player acak", order, function(state)
		State.TeleportRandom = state
	end, State.TeleportRandom); order += 1
end

local function loadSettingsPanel()
	clearContent()
	local order = 1

	createSectionHeader("PERFORMANCE", order); order += 1

	createToggle("Fix Lag", "Boost FPS + hapus object lag", order, function(state)
		State.FixLag = state

		if state then
			fixLagStart()
		else
			fixLagStop()
		end
	end, State.FixLag); order += 1
end

local function loadHomePanel()
	clearContent()
	local order = 1
	createSectionHeader("HOME", order); order += 1
	createToggle("Placeholder", "Coming soon...", order, function() end); order += 1
end

createSidebarButton("Home", 1, loadHomePanel)
createSidebarButton("Farm", 2, loadFarmPanel)
createSidebarButton("Misc", 3, loadMiscPanel)
createSidebarButton("Settings", 4, loadSettingsPanel)

task.wait(0.1)
if sidebarButtons[2] then
	sidebarButtons[2].MouseButton1Click:Fire()
end

print("zorX | Tsb - ALL IN ONE Loaded!")