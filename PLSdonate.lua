-- =======================================
-- FAKE ROBUX BUY UI (FINAL FIXED)
-- =======================================
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local pendingAmount = 0
local totalEarned = 0 --

-- =======================================
-- 🔥 UI KANAN ATAS (COUNTER)
-- =======================================
local counterGui = Instance.new("ScreenGui", CoreGui)
counterGui.Name = "TopCounter"

local frameCounter = Instance.new("Frame", counterGui)
frameCounter.AnchorPoint = Vector2.new(1, 0)
frameCounter.Position = UDim2.new(1, -20, 0, -39)
frameCounter.Size = UDim2.new(0, 95, 0, 44)
frameCounter.BackgroundColor3 = Color3.fromRGB(255,255,255)
frameCounter.BorderSizePixel = 0
Instance.new("UICorner", frameCounter).CornerRadius = UDim.new(1,0)

local iconBg = Instance.new("Frame", frameCounter)
iconBg.Size = UDim2.new(0, 30, 0, 30)
iconBg.Position = UDim2.new(0, 7, 0.5, -15)
iconBg.BackgroundColor3 = Color3.fromRGB(255, 0, 120)
iconBg.BorderSizePixel = 0
Instance.new("UICorner", iconBg).CornerRadius = UDim.new(1,0)

local icon = Instance.new("ImageLabel", iconBg)
icon.Size = UDim2.new(1,0,1,0)
icon.BackgroundTransparency = 1
icon.Image = "rbxassetid://83381326989495"
icon.ScaleType = Enum.ScaleType.Fit

local amount = Instance.new("TextLabel", frameCounter)
amount.Text = "0"
amount.Size = UDim2.new(0, 35, 1, 0)
amount.Position = UDim2.new(0, 40, 0, 0)
amount.BackgroundTransparency = 1
amount.TextSize = 20
amount.TextColor3 = Color3.fromRGB(255, 0, 120)
amount.TextScaled = false
amount.Font = Enum.Font.GothamBlack
amount.TextXAlignment = Enum.TextXAlignment.Left
amount.TextYAlignment = Enum.TextYAlignment.Center

-- FORMAT ANGKA TANPA TITIK
local function formatCounterNumber(num)
    return tostring(num)
end

local maxWidth = 140 -- maksimal lebar counter

function updateCounter(value)
    totalEarned += value
    amount.Text = formatCounterNumber(totalEarned)

    local padding = 15
    local textWidth = amount.TextBounds.X
    local newWidth = math.min(textWidth + padding + 40, maxWidth) -- 40 = space untuk icon

    -- update ukuran amount
    amount.Size = UDim2.new(0, textWidth + padding, amount.Size.Y.Scale, amount.Size.Y.Offset)

    -- update ukuran frameCounter biar ikut memanjang
    frameCounter.Size = UDim2.new(0, newWidth, frameCounter.Size.Y.Scale, frameCounter.Size.Y.Offset)
end

-- =======================================
-- FORMAT ANGKA
-- =======================================
-- 1️⃣ Untuk Counter Kanan Atas (Tanpa titik)
local function formatCounterNumber(num)
    return tostring(num)
end

local function formatNumber(num)
	local str = tostring(num)
	local formatted = str:reverse():gsub("(%d%d%d)", "%1."):reverse()
	formatted = formatted:gsub("^%.", "")
	return formatted
end

function updateCounter(value)
    totalEarned += value
    amount.Text = formatCounterNumber(totalEarned)  -- Counter pakai tanpa titik
end

-- =======================================
-- UPDATE ROBUX DISPLAY
-- =======================================
local playerRobux = 9000

-- =======================================
-- 1️⃣ Popup Gift
-- =======================================
local gui
local isPlaying = false

local function playGiftSound(parent)
	local main = Instance.new("Sound", parent)
	main.SoundId = "rbxassetid://9118823105"
	main.Volume = 1.5

	local coins = Instance.new("Sound", parent)
	coins.SoundId = "rbxassetid://6026984224"
	coins.Volume = 1.2
	coins.PlaybackSpeed = 1.15

	main:Play()
	task.delay(0.08, function()
		coins:Play()
	end)
end

local function showPopup()
	if isPlaying then return end
	isPlaying = true

	if gui then gui:Destroy() end
	gui = Instance.new("ScreenGui", CoreGui)

	local frame = Instance.new("Frame", gui)
	frame.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.Position = UDim2.new(0.5, 0, 0.7, 0)
	frame.Size = UDim2.new(0, 0, 0, 0)
	frame.BackgroundTransparency = 1

	local image = Instance.new("ImageLabel", frame)
	image.Size = UDim2.new(1, 0, 1, 0)
	image.BackgroundTransparency = 1
	image.Image = "rbxassetid://87399120113037"
	image.ScaleType = Enum.ScaleType.Fit
	image.ResampleMode = Enum.ResamplerMode.Default

	playGiftSound(gui)

	local tweenIn = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, 320, 0, 320)
	})
	tweenIn:Play()
	tweenIn.Completed:Wait()

	task.delay(1, function()
		local tweenOut = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			Size = UDim2.new(0, 0, 0, 0)
		})
		tweenOut:Play()
		tweenOut.Completed:Wait()
		gui:Destroy()
		gui = nil
		isPlaying = false
	end)
end

-- =======================================
-- CLEAR UI
-- =======================================
local function clear()
	if CoreGui:FindFirstChild("FakeRobloxBuy") then
		CoreGui.FakeRobloxBuy:Destroy()
	end
end

-- =======================================
-- 2️⃣ SUCCESS UI
-- =======================================
local function showSuccessUI(targetPlayerName)
	clear()

	local gui = Instance.new("ScreenGui")
	gui.Name = "FakeRobloxBuy"
	gui.Parent = CoreGui

	local frame = Instance.new("Frame")
	frame.Parent = gui
	frame.Size = UDim2.new(0, 620, 0, 270)
	frame.Position = UDim2.new(0.5, -310, 0.5, -135)
	frame.BackgroundColor3 = Color3.fromRGB(24, 24, 28) -- abu gelap kayak foto
	frame.BorderSizePixel = 0

 local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0, 64, 0, 64)
close.Position = UDim2.new(1, -65, 0, -8)
close.Text = "×"
close.Font = Enum.Font.SourceSans -- tipis
close.BackgroundTransparency = 1
close.TextColor3 = Color3.fromRGB(255,255,255)
close.TextScaled = true
close.BorderSizePixel = 0
close.AnchorPoint = Vector2.new(0,0)

close.MouseButton1Click:Connect(function()
    frame.Parent:Destroy() -- nutup UI
end)

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 18)
	corner.Parent = frame

	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 1
	stroke.Color = Color3.fromRGB(50, 50, 56)
	stroke.Transparency = 0.35
	stroke.Parent = frame

	local title = Instance.new("TextLabel")
	title.Parent = frame
	title.Size = UDim2.new(1, -60, 0, 30)
	title.Position = UDim2.new(0, 18, 0, 10)
	title.Text = "Purchase completed"
	title.TextColor3 = Color3.new(1,1,1)
	title.BackgroundTransparency = 1
	title.TextScaled = true
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Font = Enum.Font.SourceSansSemibold

	local checkIcon = Instance.new("ImageLabel")
	checkIcon.Parent = frame
	checkIcon.Size = UDim2.new(0, 90, 0, 90)
	checkIcon.Position = UDim2.new(0.5, -45, 0.33, -45)
	checkIcon.BackgroundTransparency = 1
	checkIcon.Image = "rbxassetid://89612208213589"

	local successText = Instance.new("TextLabel")
	successText.Parent = frame
	successText.Size = UDim2.new(0.9, 0, 0, 25)
	successText.Position = UDim2.new(0.05, 0, 0.58, 0)
	successText.BackgroundTransparency = 1
	successText.Text = "You have successfully bought " .. (targetPlayerName or "Player")
	successText.TextColor3 = Color3.new(1,1,1)
	successText.TextScaled = true
	successText.Font = Enum.Font.SourceSans
	successText.TextXAlignment = Enum.TextXAlignment.Center
	successText.TextSize = 18

	local btn = Instance.new("TextButton")
	btn.Parent = frame
	btn.Size = UDim2.new(0.9, 0, 0, 55)
	btn.Position = UDim2.new(0.05, 0, 1, -75)
	btn.BackgroundColor3 = Color3.fromRGB(40, 62, 165)
	btn.Text = ""
	btn.BorderSizePixel = 0
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

	local txt = Instance.new("TextLabel")
	txt.Parent = btn
	txt.Size = UDim2.new(1,0,1,0)
	txt.BackgroundTransparency = 1
	txt.Text = "Okay"
	txt.TextColor3 = Color3.new(1,1,1)
	txt.TextSize = 22
	txt.Font = Enum.Font.SourceSans

	local sound = Instance.new("Sound", btn)
	sound.SoundId = "rbxassetid://9118823150"
	sound.Volume = 1.5

	btn.MouseButton1Click:Connect(function()
		sound:Play()

		if pendingAmount > 0 then
			updateCounter(pendingAmount)
			pendingAmount = 0
		end

		gui:Destroy()
		task.delay(1, function()
			showPopup()
		end)
	end)
end

-- =======================================
-- 3️⃣ MAIN BUY UI
-- =======================================
local function showUI(id, isGamepass)
	clear()

	local gui = Instance.new("ScreenGui", CoreGui)
	gui.Name = "FakeRobloxBuy"

	local frame = Instance.new("Frame", gui)
	frame.Size = UDim2.new(0, 620, 0, 270)
	frame.Position = UDim2.new(0.5, -310, 0.5, -135)
	frame.BackgroundColor3 = Color3.fromRGB(24, 24, 28) -- abu kehitaman kayak foto
	frame.BorderSizePixel = 0

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 18)
	corner.Parent = frame

	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 1
	stroke.Color = Color3.fromRGB(50, 50, 56)
	stroke.Transparency = 0.35
	stroke.Parent = frame

	-- TITLE
	local title = Instance.new("TextLabel", frame)
	title.Size = UDim2.new(1, -180, 0, 35)
	title.Position = UDim2.new(0, 18, 0, 10)
	title.Text = "Buy item"
	title.TextColor3 = Color3.new(1,1,1)
	title.BackgroundTransparency = 1
	title.TextScaled = true
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Font = Enum.Font.SourceSansSemibold

	-- ROBUX DISPLAY FINAL KE KIRI
local robuxIcon = Instance.new("ImageLabel", frame)
robuxIcon.AnchorPoint = Vector2.new(0, 0.5) -- vertical center
robuxIcon.Size = UDim2.new(0, 24, 0, 24)
robuxIcon.Position = UDim2.new(1, -160, 0, 24)

robuxIcon.BackgroundTransparency = 1
robuxIcon.Image = "rbxassetid://124421116974657"
robuxIcon.ScaleType = Enum.ScaleType.Fit

local robuxText = Instance.new("TextLabel", frame)
robuxText.AnchorPoint = Vector2.new(0, 0.5)
robuxText.Size = UDim2.new(0, 140, 0, 32) -- dibesarin
robuxText.Position = UDim2.new(1, -130, 0, 24)
robuxText.BackgroundTransparency = 1
robuxText.Text = formatNumber(playerRobux)
robuxText.TextColor3 = Color3.fromRGB(255,255,255) -- putih
robuxText.TextScaled = true
robuxText.Font = Enum.Font.SourceSansSemibold
robuxText.TextXAlignment = Enum.TextXAlignment.Left 

	local function updateRobux()
		robuxText.Text = formatNumber(playerRobux)
	end

	-- TOMBOL CLOSE
local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0, 64, 0, 64)
close.Position = UDim2.new(1, -65, 0, -8)
close.Text = "×"
close.Font = Enum.Font.SourceSans -- tipis
close.BackgroundTransparency = 1
close.TextColor3 = Color3.fromRGB(255,255,255)
close.TextScaled = true
close.BorderSizePixel = 0
close.AnchorPoint = Vector2.new(0,0)

close.MouseButton1Click:Connect(function()
    frame.Parent:Destroy()
end)

	-- ITEM INFO
	local imageLabel = Instance.new("ImageLabel", frame)
	imageLabel.Size = UDim2.new(0, 100, 0, 100)
	imageLabel.Position = UDim2.new(0, 20, 0, 78)
	imageLabel.BackgroundColor3 = Color3.fromRGB(18,18,22)
	imageLabel.BorderSizePixel = 0
	imageLabel.ScaleType = Enum.ScaleType.Crop
	Instance.new("UICorner", imageLabel).CornerRadius = UDim.new(0, 8)

	local itemName = Instance.new("TextLabel", frame)
	itemName.Size = UDim2.new(0, 320, 0, 32)
	itemName.Position = UDim2.new(0, 140, 0, 88)
	itemName.Text = "Loading..."
	itemName.TextColor3 = Color3.new(1,1,1)
	itemName.BackgroundTransparency = 1
	itemName.TextScaled = true
	itemName.TextXAlignment = Enum.TextXAlignment.Left
	itemName.Font = Enum.Font.SourceSansSemibold

	local priceIcon = Instance.new("ImageLabel", frame)
	priceIcon.Size = UDim2.new(0, 18, 0, 18)
	priceIcon.Position = UDim2.new(0, 142, 0, 130)
	priceIcon.BackgroundTransparency = 1
	priceIcon.Image = "rbxassetid://124421116974657"
	priceIcon.ScaleType = Enum.ScaleType.Fit

	local price = Instance.new("TextLabel", frame)
	price.Size = UDim2.new(0, 120, 0, 22)
	price.Position = UDim2.new(0, 164, 0, 127)
	price.Text = "..."
	price.TextColor3 = Color3.fromRGB(230,230,230)
	price.BackgroundTransparency = 1
	price.TextScaled = true
	price.TextXAlignment = Enum.TextXAlignment.Left
	price.Font = Enum.Font.SourceSansSemibold

	-- BUY BUTTON
	local MAIN_BLUE = Color3.fromRGB(40, 62, 165) -- jadiin biru tua
local DARK_BLUE = Color3.fromRGB(30, 50, 140) -- sedikit lebih gelap buat anim

	local buy = Instance.new("TextButton", frame)
	buy.Size = UDim2.new(0.9, 0, 0, 55)
	buy.Position = UDim2.new(0.05, 0, 1, -75)
	buy.BackgroundColor3 = MAIN_BLUE
	buy.Text = ""
	buy.ZIndex = 1
	buy.BorderSizePixel = 0
	Instance.new("UICorner", buy).CornerRadius = UDim.new(0, 10)

	local buyText = Instance.new("TextLabel", frame)
	buyText.Size = buy.Size
	buyText.Position = buy.Position
	buyText.BackgroundTransparency = 1
	buyText.Text = "Buy"
	buyText.TextColor3 = Color3.new(1,1,1)
	buyText.TextSize = 24
	buyText.Font = Enum.Font.SourceSans
	buyText.ZIndex = 5

	buy:GetPropertyChangedSignal("Position"):Connect(function()
		buyText.Position = buy.Position
	end)

	local itemPrice = 0
	local targetName = "Player"

	task.spawn(function()
		local success, info = pcall(function()
			return MarketplaceService:GetProductInfo(
				id,
				isGamepass and Enum.InfoType.GamePass or Enum.InfoType.Product
			)
		end)

		if success and info then
			itemName.Text = info.Name or "Item"
			itemPrice = info.PriceInRobux or info.Price or 0
			price.Text = tostring(itemPrice)
			imageLabel.Image = info.IconImageAssetId and ("rbxassetid://" .. info.IconImageAssetId) or ""
			if info.Creator and info.Creator.Name then
				targetName = info.Creator.Name
			end
		else
			itemName.Text = "Item"
			price.Text = "0"
		end
	end)

	task.spawn(function()
		buy.BackgroundColor3 = DARK_BLUE
		local wipe = Instance.new("Frame", buy)
		wipe.Size = UDim2.new(0,0,1,0)
		wipe.BackgroundColor3 = Color3.fromRGB(50, 85, 200)
		wipe.ZIndex = 2
		wipe.BorderSizePixel = 0
		Instance.new("UICorner", wipe).CornerRadius = UDim.new(0, 10)

		local tween = TweenService:Create(wipe, TweenInfo.new(6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(1,0,1,0)
		})
		tween:Play()
		tween.Completed:Wait()
		wipe:Destroy()
		buy.BackgroundColor3 = MAIN_BLUE
		buyText.Text = "Buy"
	end)

	buy.MouseButton1Click:Connect(function()
		playerRobux -= itemPrice
		updateRobux()

		local earned = math.floor(itemPrice * 0.7)
		pendingAmount += earned

		local originalPos = frame.Position
		local turun = TweenService:Create(frame, TweenInfo.new(0.3), {
			Position = originalPos + UDim2.new(0,0,0,100)
		})
		turun:Play()
		turun.Completed:Wait()

		local naik = TweenService:Create(frame, TweenInfo.new(0.35, Enum.EasingStyle.Back), {
			Position = originalPos
		})
		naik:Play()
		naik.Completed:Wait()

		showSuccessUI(targetName)
	end)
end

MarketplaceService.PromptGamePassPurchaseRequested:Connect(function(player, gamepassId)
	showUI(gamepassId, true)
end)

MarketplaceService.PromptProductPurchaseRequested:Connect(function(player, productId)
	showUI(productId, false)
end)