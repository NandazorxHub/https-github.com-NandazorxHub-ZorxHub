-- ============================================
-- 🎯 NANDA×ZORX AIMLOCK — LITE VERSION (HP KENTANG)
-- Outline + Lock + TP belakang HANYA saat block ASLI
-- TIDAK mendeteksi skill / ultimate / efek apapun sebagai block
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
local lastScan = 0
local TP_COOLDOWN = 0.8
local TP_DISTANCE = 3.5
local SCAN_INTERVAL = 0.1  -- ⚡ scan tiap 0.1 detik (bukan tiap frame)

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
	removeOutline()

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

-- ===== DETEKSI BLOCK ASLI =====
local BLOCK_ATTRS = {"Blocking","IsBlocking","Blocked","IsBlocked","IsGuarding","GuardActive"}

local function checkRealBlock(character)
	if not character then return false end

	local hum = character:FindFirstChildOfClass("Humanoid")
	if not hum then return false end

	for _, attr in ipairs(BLOCK_ATTRS) do
		local ok, val = pcall(function() return hum:GetAttribute(attr) end)
		if ok and val == true then return true end
		local ok2, val2 = pcall(function() return character:GetAttribute(attr) end)
		if ok2 and val2 == true then return true end
	end

	-- cek BoolValue
	for _, child in ipairs(character:GetChildren()) do
		if child:IsA("BoolValue") and child.Value then
			local n = child.Name
			if n == "Blocking" or n == "IsBlocking" or n == "Blocked"
				or n == "IsBlocked" or n == "IsGuarding" or n == "GuardActive" then
				return true
			end
		end
	end
	for _, child in ipairs(hum:GetChildren()) do
		if child:IsA("BoolValue") and child.Value then
			local n = child.Name
			if n == "Blocking" or n == "IsBlocking" or n == "Blocked"
				or n == "IsBlocked" or n == "IsGuarding" or n == "GuardActive" then
				return true
			end
		end
	end

	return false
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

	pcall(function()
		myChar:PivotTo(CFrame.lookAt(behindPos, tgtHRP.Position))
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

-- ===== LOOP RINGAN (pakai Heartbeat + throttle) =====
RunService.Heartbeat:Connect(function()
	if not aimlockOn then return end

	local now = tick()
	if now - lastScan < SCAN_INTERVAL then return end  -- ⚡ throttle 0.1s
	lastScan = now

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

	if checkRealBlock(lockTarget.Parent) then
		if now - lastTP >= TP_COOLDOWN then
			lastTP = now
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

print("🎯 ZORX AIMLOCK LITE — HP Kentang Ready ✅")

-- ============================================
-- 🔌 BRIDGE UNTUK UI ZORX (TAMBAHAN)
-- ============================================
_G.ZorxAimlockOn = function()
	aimlockOn = true
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
	return aimlockOn
end

_G.ZorxAimlockOff = function()
	aimlockOn = false
	lockTarget = nil
	aimlockBtn.Text = "AIM: OFF"
	aimlockBtn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
	removeOutline()
	return aimlockOn
end

_G.ZorxAimlockStatus = function()
	return aimlockOn
end

print("🔌 Bridge ready ✅")