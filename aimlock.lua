--============================================================
-- AIMLOCK - ZORX HUB EDITION (WITH STOP FUNCTION)
--============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local mouse = player:GetMouse()

--============================================================
-- STATE
--============================================================
_G.ZorxAimlockRunning = true
_G.ZorxAimlockLocked = false
_G.ZorxAimlockTarget = nil
_G.ZorxAimlockOn = true

local Connections = {}
local Highlights = {}

--============================================================
-- CLEANUP FUNCTION (DIPANGGIL DARI LUAR)
--============================================================
local function cleanupAll()
	_G.ZorxAimlockRunning = false
	_G.ZorxAimlockLocked = false
	_G.ZorxAimlockTarget = nil
	_G.ZorxAimlockOn = false

	-- Disconnect semua connection
	for _, conn in ipairs(Connections) do
		pcall(function() conn:Disconnect() end)
	end
	Connections = {}

	-- Hapus semua highlight
	for _, h in ipairs(Highlights) do
		pcall(function() h:Destroy() end)
	end
	Highlights = {}

	-- Hapus GUI aimlock
	for _, obj in ipairs(game.CoreGui:GetChildren()) do
		if obj:IsA("ScreenGui") and (obj.Name:lower():find("aim") or obj.Name:lower():find("nzk")) then
			pcall(function() obj:Destroy() end)
		end
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

	print("[AIMLOCK] Cleanup - Semua di-stop dan di-reset")
end

-- Expose ke global biar bisa dipanggil dari UI
_G.ZorxAimlockOff = cleanupAll

--============================================================
-- GUI AIMLOCK (tombol Lock/Unlock di pojok kanan atas)
--============================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NzkAimlock"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "Main"
MainFrame.Size = UDim2.new(0, 160, 0, 90)
MainFrame.Position = UDim2.new(1, -170, 0, 20)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(180, 0, 0)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 24)
Title.BackgroundTransparency = 1
Title.Text = "🎯 AIMLOCK"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12
Title.Parent = MainFrame

local LockBtn = Instance.new("TextButton")
LockBtn.Name = "LockBtn"
LockBtn.Size = UDim2.new(1, -20, 0, 24)
LockBtn.Position = UDim2.new(0, 10, 0, 30)
LockBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
LockBtn.Text = "🔓 UNLOCKED"
LockBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LockBtn.Font = Enum.Font.GothamBold
LockBtn.TextSize = 11
LockBtn.AutoButtonColor = false
LockBtn.Parent = MainFrame

local LockCorner = Instance.new("UICorner")
LockCorner.CornerRadius = UDim.new(0, 5)
LockCorner.Parent = LockBtn

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -20, 0, 20)
StatusLabel.Position = UDim2.new(0, 10, 0, 60)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: IDLE"
StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 10
StatusLabel.Parent = MainFrame

--============================================================
-- FUNCTION: CLEAR HIGHLIGHT
--============================================================
local function clearHighlight()
	for _, h in ipairs(Highlights) do
		pcall(function() h:Destroy() end)
	end
	Highlights = {}
end

--============================================================
-- FUNCTION: APPLY HIGHLIGHT KE TARGET
--============================================================
local function applyHighlight(targetChar)
	clearHighlight()
	if not targetChar then return end

	local hl = Instance.new("Highlight")
	hl.Adornee = targetChar
	hl.FillColor = Color3.fromRGB(255, 0, 0)
	hl.FillTransparency = 0.5
	hl.OutlineColor = Color3.fromRGB(255, 0, 0)
	hl.OutlineTransparency = 0
	hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	hl.Parent = targetChar

	table.insert(Highlights, hl)
end

--============================================================
-- FUNCTION: CARI TARGET TERDEKAT DENGAN MOUSE
--============================================================
local function getTargetUnderMouse()
	local closest = nil
	local shortest = math.huge
	local mousePos = UserInputService:GetMouseLocation()

	for _, p in pairs(Players:GetPlayers()) do
		if p ~= player and p.Character then
			local hum = p.Character:FindFirstChildOfClass("Humanoid")
			local root = p.Character:FindFirstChild("HumanoidRootPart")
			if hum and root and hum.Health > 0 then
				local screenPos, onScreen = camera:WorldToViewportPoint(root.Position)
				if onScreen then
					local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
					if dist < shortest and dist < 300 then
						shortest = dist
						closest = p.Character
					end
				end
			end
		end
	end

	return closest
end

--============================================================
-- LOCK / UNLOCK
--============================================================
LockBtn.MouseButton1Click:Connect(function()
	if not _G.ZorxAimlockRunning then return end

	if _G.ZorxAimlockLocked then
		-- UNLOCK
		_G.ZorxAimlockLocked = false
		_G.ZorxAimlockTarget = nil
		clearHighlight()
		LockBtn.Text = "🔓 UNLOCKED"
		LockBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
		StatusLabel.Text = "Status: UNLOCKED"
		StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
	else
		-- LOCK
		local target = getTargetUnderMouse()
		if target then
			_G.ZorxAimlockLocked = true
			_G.ZorxAimlockTarget = target
			applyHighlight(target)
			LockBtn.Text = "🔒 LOCKED"
			LockBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
			StatusLabel.Text = "Target: " .. target.Name
			StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
		else
			StatusLabel.Text = "Target: Tidak ada"
			StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
		end
	end
end)

--============================================================
-- LOOP: UPDATE CAMERA SETIAP FRAME (kalau LOCKED)
--============================================================
local cameraConn = RunService.RenderStepped:Connect(function()
	-- 🔥 CEK FLAG STop — kalau false, langsung break
	if not _G.ZorxAimlockRunning then
		cameraConn:Disconnect()
		return
	end

	if not _G.ZorxAimlockLocked then return end

	local target = _G.ZorxAimlockTarget
	if not target or not target.Parent then
		_G.ZorxAimlockLocked = false
		_G.ZorxAimlockTarget = nil
		clearHighlight()
		LockBtn.Text = "🔓 UNLOCKED"
		LockBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
		StatusLabel.Text = "Status: Target hilang"
		return
	end

	local targetHead = target:FindFirstChild("Head") or target:FindFirstChild("HumanoidRootPart")
	local hum = target:FindFirstChildOfClass("Humanoid")

	if not targetHead or not hum or hum.Health <= 0 then
		_G.ZorxAimlockLocked = false
		_G.ZorxAimlockTarget = nil
		clearHighlight()
		LockBtn.Text = "🔓 UNLOCKED"
		LockBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
		StatusLabel.Text = "Status: Target mati"
		return
	end

	-- 🔥 FIX CAMERA: paksa kamera lihat ke target
	local cam = workspace.CurrentCamera
	if cam then
		cam.CFrame = CFrame.new(cam.CFrame.Position, targetHead.Position)
	end
end)

table.insert(Connections, cameraConn)

--============================================================
-- AUTO CLEANUP kalau script di-reload
--============================================================
if _G._ZorxAimlockPreviousCleanup then
	pcall(_G._ZorxAimlockPreviousCleanup)
end
_G._ZorxAimlockPreviousCleanup = cleanupAll

--============================================================
-- NOTIFIKASI
--============================================================
pcall(function()
	game.StarterGui:SetCore("SendNotification", {
		Title = "🎯 Aimlock Loaded",
		Text = "Tekan tombol LOCK untuk kunci target",
		Duration = 3
	})
end)

print("[AIMLOCK] Loaded - _G.ZorxAimlockOff() untuk stop")