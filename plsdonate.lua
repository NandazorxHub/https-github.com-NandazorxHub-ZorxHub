-- =======================================
-- FAKE ROBUX BUY UI (POPUP AGAK BESAR SETELAH KLIK OKAY, ROBUX POSISI RAPIH)
-- =======================================
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local pendingAmount = 0

-- =======================================
-- 🔥 UI KIRI BAWAH (COUNTER TERPISAH - SEDIKIT LEBIH BESAR)
-- =======================================
local CoreGui = game:GetService("CoreGui")

local counterGuiLeft = Instance.new("ScreenGui", CoreGui)
counterGuiLeft.Name = "BottomLeftCounter"

local frameCounterLeft = Instance.new("Frame", counterGuiLeft)
frameCounterLeft.AnchorPoint = Vector2.new(0, 1)
frameCounterLeft.Position = UDim2.new(0, 20, 1, -24)  -- kiri bawah
frameCounterLeft.Size = UDim2.new(0, 180, 0, 54)  -- sedikit lebih besar
frameCounterLeft.BackgroundColor3 = Color3.fromRGB(255,255,255)
frameCounterLeft.BorderSizePixel = 0
Instance.new("UICorner", frameCounterLeft).CornerRadius = UDim.new(1,0)

-- ICON $
local iconBgLeft = Instance.new("Frame", frameCounterLeft)
iconBgLeft.Size = UDim2.new(0, 36, 0, 36)
iconBgLeft.Position = UDim2.new(0, 10, 0.5, -18)
iconBgLeft.BackgroundColor3 = Color3.fromRGB(255, 0, 120)
Instance.new("UICorner", iconBgLeft).CornerRadius = UDim.new(1,0)

local iconLeft = Instance.new("TextLabel", iconBgLeft)
iconLeft.Size = UDim2.new(1,1,1,1)
iconLeft.BackgroundTransparency = 1
iconLeft.Text = "$"
iconLeft.TextColor3 = Color3.new(1,1,1)
iconLeft.TextScaled = true
iconLeft.Font = Enum.Font.GothamBold

-- ANGKA
local amountLeft = Instance.new("TextLabel", frameCounterLeft)
amountLeft.Size = UDim2.new(0, 90, 1, 0)
amountLeft.Position = UDim2.new(0.5, -45, 0, 0)
amountLeft.BackgroundTransparency = 1
amountLeft.Text = "0"
amountLeft.TextColor3 = Color3.fromRGB(255, 0, 120)
amountLeft.TextScaled = true
amountLeft.Font = Enum.Font.GothamBlack
amountLeft.TextXAlignment = Enum.TextXAlignment.Center
amountLeft.TextYAlignment = Enum.TextYAlignment.Center

-- PLUS
local plusBgLeft = Instance.new("Frame", frameCounterLeft)
plusBgLeft.Size = UDim2.new(0, 36, 0, 36)
plusBgLeft.Position = UDim2.new(1, -46, 0.5, -18)
plusBgLeft.BackgroundColor3 = Color3.fromRGB(255, 0, 120)
Instance.new("UICorner", plusBgLeft).CornerRadius = UDim.new(1,0)

local plusLeft = Instance.new("TextLabel", plusBgLeft)
plusLeft.Size = UDim2.new(1,1,1,1)
plusLeft.BackgroundTransparency = 1
plusLeft.Text = "+"
plusLeft.TextColor3 = Color3.new(1,1,1)
plusLeft.TextScaled = true
plusLeft.Font = Enum.Font.GothamBold

-- FORMAT ANGKA
local function formatLeft(num)
	return tostring(num):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
end

-- FUNCTION UNTUK UPDATE COUNTER KIRI BAWAH
local totalLeft = 0
function updateCounterLeft(value)
	totalLeft += value
	amountLeft.Text = formatLeft(totalLeft)
end

-- =======================================
-- 🔥 UI KANAN ATAS (COUNTER)
-- =======================================
local totalEarned = 0

local counterGui = Instance.new("ScreenGui", CoreGui)
counterGui.Name = "TopCounter"

local frameCounter = Instance.new("Frame", counterGui)
frameCounter.AnchorPoint = Vector2.new(1, 0)
frameCounter.Position = UDim2.new(1, -20, 0, -39)  -- lebih tinggi
frameCounter.Size = UDim2.new(0, 150, 0, 44)
frameCounter.BackgroundColor3 = Color3.fromRGB(255,255,255)
frameCounter.BorderSizePixel = 0
Instance.new("UICorner", frameCounter).CornerRadius = UDim.new(1,0)

-- ICON $
local iconBg = Instance.new("Frame", frameCounter)
iconBg.Size = UDim2.new(0, 30, 0, 30)
iconBg.Position = UDim2.new(0, 7, 0.5, -15)
iconBg.BackgroundColor3 = Color3.fromRGB(255, 0, 120)
Instance.new("UICorner", iconBg).CornerRadius = UDim.new(1,0)

local icon = Instance.new("TextLabel", iconBg)
icon.Size = UDim2.new(1,1,1,1)
icon.BackgroundTransparency = 1
icon.Text = "$"
icon.TextColor3 = Color3.new(1,1,1)
icon.TextScaled = true
icon.Font = Enum.Font.GothamBold

-- ANGKA
local amount = Instance.new("TextLabel", frameCounter)
amount.Size = UDim2.new(0, 70, 1, 0)
amount.Position = UDim2.new(0.5, -35, 0, 0)  -- posisinya agak ke tengah frame
amount.BackgroundTransparency = 1
amount.Text = "0"
amount.TextColor3 = Color3.fromRGB(255, 0, 120)
amount.TextScaled = true
amount.Font = Enum.Font.GothamBlack  -- ini lebih bold daripada GothamBold
amount.TextXAlignment = Enum.TextXAlignment.Center
amount.TextYAlignment = Enum.TextYAlignment.Center

-- PLUS
local plusBg = Instance.new("Frame", frameCounter)
plusBg.Size = UDim2.new(0, 30, 0, 30)
plusBg.Position = UDim2.new(1, -37, 0.5, -15)
plusBg.BackgroundColor3 = Color3.fromRGB(255, 0, 120)
Instance.new("UICorner", plusBg).CornerRadius = UDim.new(1,0)

local plus = Instance.new("TextLabel", plusBg)
plus.Size = UDim2.new(1,1,1,1)
plus.BackgroundTransparency = 1
plus.Text = "+"
plus.TextColor3 = Color3.new(1,1,1)
plus.TextScaled = true
plus.Font = Enum.Font.GothamBold

-- FORMAT
local function format(num)
	return tostring(num):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
end

-- UPDATE FUNCTION
function updateCounter(value)
	totalEarned += value
	amount.Text = format(totalEarned)
end

local playerRobux = 7000 -- Ubah Robux di sini

-- =======================================
-- 1️⃣ Popup Gift (lebih besar tapi tidak fullscreen)
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

	-- MASUK popup (agak besar, tapi nyaman)
	local tweenIn = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, 320, 0, 320) -- diperbesar tapi tidak fullscreen
	})
	tweenIn:Play()
	tweenIn.Completed:Wait()

	-- Tahan popup 1 detik sebelum keluar
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
-- 2️⃣ SUCCESS UI (Klik Okay memanggil popup besar)
-- =======================================
local function clear()
	if CoreGui:FindFirstChild("FakeRobloxBuy") then
		CoreGui.FakeRobloxBuy:Destroy()
	end
end

local function showSuccessUI(targetPlayerName)
	clear()

	local gui = Instance.new("ScreenGui")
	gui.Name = "FakeRobloxBuy"
	gui.Parent = CoreGui

	local frame = Instance.new("Frame")
	frame.Parent = gui
	frame.Size = UDim2.new(0, 520, 0, 280)
	frame.Position = UDim2.new(0.5, -260, 0.3, 0)
	frame.BackgroundColor3 = Color3.fromRGB(32,32,32)
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

	local title = Instance.new("TextLabel")
	title.Parent = frame
	title.Size = UDim2.new(1, -60, 0, 30)
	title.Position = UDim2.new(0, 10, 0, 5)
	title.Text = "Purchase completed"
	title.TextColor3 = Color3.new(1,1,1)
	title.BackgroundTransparency = 1
	title.TextScaled = true
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Font = Enum.Font.SourceSansSemibold

	local checkIcon = Instance.new("ImageLabel")
	checkIcon.Parent = frame
	checkIcon.Size = UDim2.new(0, 90, 0, 90)
	checkIcon.Position = UDim2.new(0.5, -45, 0.35, -45)
	checkIcon.BackgroundTransparency = 1
	checkIcon.Image = "rbxassetid://89612208213589"

	local successText = Instance.new("TextLabel")
	successText.Parent = frame
	successText.Size = UDim2.new(0.9, 0, 0, 25)
	successText.Position = UDim2.new(0.05, 0, 0.6, 0)
	successText.BackgroundTransparency = 1
	successText.Text = "You have successfully bought " .. (targetPlayerName or "Player")
	successText.TextColor3 = Color3.new(1,1,1)
	successText.TextScaled = true
	successText.Font = Enum.Font.SourceSans
	successText.TextXAlignment = Enum.TextXAlignment.Center
	successText.TextSize = 18

	-- BUTTON OK
	local btn = Instance.new("TextButton")
	btn.Parent = frame
	btn.Size = UDim2.new(0.9, 0, 0, 55)
	btn.Position = UDim2.new(0.05, 0, 1, -75)
	btn.BackgroundColor3 = Color3.fromRGB(0,70,180)
	btn.Text = ""
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

	local txt = Instance.new("TextLabel")
	txt.Parent = btn
	txt.Size = UDim2.new(1,0,1,0)
	txt.BackgroundTransparency = 1
	txt.Text = "Okay"
	txt.TextColor3 = Color3.new(1,1,1)
	txt.TextSize = 22
	txt.Font = Enum.Font.SourceSans

	-- PLAY GIFT SOUND ON CLICK
	local sound = Instance.new("Sound", btn)
	sound.SoundId = "rbxassetid://9118823150"
	sound.Volume = 1.5

 btn.MouseButton1Click:Connect(function()
    sound:Play()

    -- 🔥 MASUKIN KE COUNTER DI SINI
    if pendingAmount > 0 then
        updateCounter(pendingAmount)       -- kanan atas
        updateCounterLeft(pendingAmount)   -- kiri bawah (tambahkan baris ini)
        pendingAmount = 0
    end

    gui:Destroy()
    task.delay(1, function()
        showPopup()
    end)
end)
end

-- =======================================
-- 3️⃣ MAIN BUY UI (Wipe & Smooth)
-- =======================================
local function showUI(id, isGamepass)
	clear()

	local gui = Instance.new("ScreenGui", CoreGui)
	gui.Name = "FakeRobloxBuy"

	local frame = Instance.new("Frame", gui)
	frame.Size = UDim2.new(0, 520, 0, 280)
	frame.Position = UDim2.new(0.5, -260, 0.3, 0)
	frame.BackgroundColor3 = Color3.fromRGB(32,32,32)
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

	-- TITLE & CLOSE
	local title = Instance.new("TextLabel", frame)
	title.Size = UDim2.new(1, -60, 0, 35)
	title.Position = UDim2.new(0, 10, 0, 5)
	title.Text = "Buy item"
	title.TextColor3 = Color3.new(1,1,1)
	title.BackgroundTransparency = 1
	title.TextScaled = true
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Font = Enum.Font.SourceSansSemibold

	local close = Instance.new("TextButton", frame)
	close.Size = UDim2.new(0, 30, 0, 30)
	close.Position = UDim2.new(1, -35, 0, 5)
	close.Text = "X"
	close.BackgroundTransparency = 1
	close.TextColor3 = Color3.new(1,1,1)
	close.MouseButton1Click:Connect(function() gui:Destroy() end)

	-- ROBUX DISPLAY (POSISI LEBIH RAPIH)
	local function formatNumber(num)
		return tostring(num):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
	end

	local robuxIcon = Instance.new("ImageLabel", frame)
	robuxIcon.Size = UDim2.new(0, 24, 0, 24)
	robuxIcon.Position = UDim2.new(1, -120, 0, 8) -- geser lebih ke kanan
	robuxIcon.BackgroundTransparency = 1
	robuxIcon.Image = "rbxassetid://124421116974657"

	local robuxText = Instance.new("TextLabel", frame)
	robuxText.Size = UDim2.new(0, 90, 0, 30)
	robuxText.Position = UDim2.new(1, -90, 0, 5) -- geser lebih ke kanan
	robuxText.BackgroundTransparency = 1
	robuxText.Text = formatNumber(playerRobux) -- misal 7000
	robuxText.TextColor3 = Color3.new(1,1,1)
	robuxText.TextScaled = true
	robuxText.Font = Enum.Font.SourceSansSemibold
	robuxText.TextXAlignment = Enum.TextXAlignment.Left

	local function updateRobux()
		robuxText.Text = formatNumber(playerRobux)
	end

 -- ITEM INFO
local imageLabel = Instance.new("ImageLabel", frame)
imageLabel.Size = UDim2.new(0, 100, 0, 100) -- diperbesar
imageLabel.Position = UDim2.new(0, 20, 0, 70) -- naik sedikit dari sebelumnya
imageLabel.BackgroundColor3 = Color3.fromRGB(20,20,20)
Instance.new("UICorner", imageLabel).CornerRadius = UDim.new(0, 8)

-- Nama item (agak ke atas sejajar image)
local itemName = Instance.new("TextLabel", frame)
itemName.Size = UDim2.new(0.6, 0, 0, 28)
itemName.Position = UDim2.new(0, 130, 0, 70) -- sejajar atas image
itemName.Text = "Loading..."
itemName.TextColor3 = Color3.new(1,1,1)
itemName.BackgroundTransparency = 1
itemName.TextScaled = true
itemName.TextXAlignment = Enum.TextXAlignment.Left
itemName.Font = Enum.Font.SourceSansSemibold

-- Creator / game pass name (di bawah itemName)
local creatorName = Instance.new("TextLabel", frame)
creatorName.Size = UDim2.new(0.6, 0, 0, 22)
creatorName.Position = UDim2.new(0, 130, 0, 100) -- jarak 30 px dari itemName
creatorName.Text = "Game Pass"
creatorName.TextColor3 = Color3.fromRGB(180,180,180)
creatorName.BackgroundTransparency = 1
creatorName.TextScaled = true
creatorName.TextXAlignment = Enum.TextXAlignment.Left
creatorName.Font = Enum.Font.SourceSansSemibold
 
-- Harga item dengan ikon Robux sedikit diperbesar
local priceIcon = Instance.new("ImageLabel", frame)
priceIcon.Size = UDim2.new(0, 26, 0, 26) -- diperbesar sedikit
priceIcon.Position = UDim2.new(0, 130, 0, 130) -- disesuaikan agar sejajar vertikal
priceIcon.BackgroundTransparency = 1
priceIcon.Image = "rbxassetid://124421116974657"
priceIcon.ScaleType = Enum.ScaleType.Fit

local price = Instance.new("TextLabel", frame)
price.Size = UDim2.new(0, 120, 0, 26) -- angka ikut diperbesar
price.Position = UDim2.new(0, 160, 0, 130) -- kanan icon, tetap sejajar
price.Text = "..."
price.TextColor3 = Color3.fromRGB(200,200,200)
price.BackgroundTransparency = 1
price.TextScaled = true
price.TextXAlignment = Enum.TextXAlignment.Left
price.Font = Enum.Font.SourceSansSemibold

	local MAIN_BLUE = Color3.fromRGB(0,120,255)
	local DARK_BLUE = Color3.fromRGB(0,80,180)

	local buy = Instance.new("TextButton", frame)
	buy.Size = UDim2.new(0.9, 0, 0, 55)
	buy.Position = UDim2.new(0.05, 0, 1, -75)
	buy.BackgroundColor3 = MAIN_BLUE
	buy.Text = ""
	buy.ZIndex = 1
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
			imageLabel.Image = info.IconImageAssetId and ("rbxassetid://"..info.IconImageAssetId) or ""
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
		wipe.BackgroundColor3 = MAIN_BLUE
		wipe.ZIndex = 2
		Instance.new("UICorner", wipe).CornerRadius = UDim.new(0, 10)

		local tween = TweenService:Create(wipe, TweenInfo.new(6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1,0,1,0)})
		tween:Play()
		tween.Completed:Wait()
		wipe:Destroy()
		buy.BackgroundColor3 = MAIN_BLUE
		buyText.Text = "Buy"
	end)

	buy.MouseButton1Click:Connect(function()
	playerRobux -= itemPrice
	updateRobux()

	-- 🔥 HITUNG YANG DIDAPAT
	local earned = math.floor(itemPrice * 0.7)

	-- simpan ke pending
	pendingAmount += earned

	local originalPos = frame.Position
	local turun = TweenService:Create(frame, TweenInfo.new(0.3), {Position = originalPos + UDim2.new(0,0,0,100)})
	turun:Play()
	turun.Completed:Wait()

	local naik = TweenService:Create(frame, TweenInfo.new(0.35, Enum.EasingStyle.Back), {Position = originalPos})
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