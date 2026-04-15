-- =======================================
-- INIT (SAVE DATA FIXED)
-- =======================================
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

-- HAPUS GUI LAMA
if CoreGui:FindFirstChild("TopCounter") then
CoreGui.TopCounter:Destroy()
end

-- BUAT GUI BARU
local counterGui = Instance.new("ScreenGui")
counterGui.Name = "TopCounter"
counterGui.Parent = CoreGui

-- DATA
local pendingAmount = 0
local totalEarned = 0

-- 🔥 LOAD DATA AMAN (ANTI RESET)
local function loadData()
if readfile and isfile and isfile("counter.txt") then
local success, data = pcall(function()
return readfile("counter.txt")
end)

if success and data and data ~= "" then  
        local num = tonumber(data)  
        if num then  
            totalEarned = num  
        else  
            totalEarned = 0  
        end  
    else  
        totalEarned = 0  
    end  
else  
    totalEarned = 0  
end

end

-- 🔥 SAVE DATA AMAN
local function saveData()
if writefile then
pcall(function()
writefile("counter.txt", tostring(totalEarned))
end)
end
end

-- LOAD SAAT START
loadData()

-- =========================
-- 🔥 COUNTER KANAN ATAS (FIX ICON POSITION)
-- =========================
local frameCounter = Instance.new("Frame", counterGui)
frameCounter.AnchorPoint = Vector2.new(1, 0)
frameCounter.Position = UDim2.new(1, -20, 0, -39)
frameCounter.BackgroundColor3 = Color3.fromRGB(255,255,255)
frameCounter.BorderSizePixel = 0
frameCounter.AutomaticSize = Enum.AutomaticSize.X
frameCounter.Size = UDim2.new(0, 0, 0, 48)

Instance.new("UICorner", frameCounter).CornerRadius = UDim.new(1,0)

local padding = Instance.new("UIPadding", frameCounter)
padding.PaddingTop = UDim.new(0, 6)
padding.PaddingBottom = UDim.new(0, 6)
padding.PaddingLeft = UDim.new(0, 6)
padding.PaddingRight = UDim.new(0, 6)

local layout = Instance.new("UIListLayout", frameCounter)
layout.FillDirection = Enum.FillDirection.Horizontal
layout.VerticalAlignment = Enum.VerticalAlignment.Center
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.Padding = UDim.new(0, 6)
layout.SortOrder = Enum.SortOrder.LayoutOrder

local padding2 = Instance.new("UIPadding", frameCounter)
padding2.PaddingRight = UDim.new(0, 6)

-- 🔥 WRAPPER ICON (INI YANG BIKIN BISA OFFSET)
local iconWrapper = Instance.new("Frame", frameCounter)
iconWrapper.BackgroundTransparency = 1
iconWrapper.Size = UDim2.new(0, 34, 0, 34)
iconWrapper.LayoutOrder = 1

local iconLeft = Instance.new("ImageLabel", iconWrapper)
iconLeft.Size = UDim2.new(1, 0, 1, 0)
iconLeft.BackgroundTransparency = 1
iconLeft.Image = "rbxassetid://91943377323917"
iconLeft.ScaleType = Enum.ScaleType.Fit

-- 🔥 TURUNIN ICON DI SINI
iconLeft.Position = UDim2.new(0, 4, 0, 2)

-- ANGKA
local amount = Instance.new("TextLabel", frameCounter)
amount.AutomaticSize = Enum.AutomaticSize.X
amount.Size = UDim2.new(0, 0, 1, 0)
amount.BackgroundTransparency = 1
amount.Text = tostring(totalEarned)
amount.TextColor3 = Color3.fromRGB(255, 0, 120)
amount.TextScaled = false
amount.TextSize = 20
amount.Font = Enum.Font.GothamBlack
amount.LayoutOrder = 2

local iconRightWrapper = Instance.new("Frame", frameCounter)
iconRightWrapper.BackgroundTransparency = 1
iconRightWrapper.Size = UDim2.new(0, 30, 0, 30)
iconRightWrapper.LayoutOrder = 3

local iconRight = Instance.new("ImageLabel", iconRightWrapper)
iconRight.Size = UDim2.new(1, 0, 1, 0)
iconRight.BackgroundTransparency = 1
iconRight.Image = "rbxassetid://77113635080207"
iconRight.ScaleType = Enum.ScaleType.Fit

iconRight.Position = UDim2.new(0, -4, 0, 0) -- 👈 tambah ini

-- =========================
-- 🔥 COUNTER KIRI BAWAH (FIX ICON POSITION)
-- =========================
local frameCounter2 = Instance.new("Frame", counterGui)
frameCounter2.AnchorPoint = Vector2.new(0, 1)
frameCounter2.Position = UDim2.new(0, 22, 1, -20)
frameCounter2.BackgroundColor3 = Color3.fromRGB(255,255,255)
frameCounter2.BorderSizePixel = 0
frameCounter2.AutomaticSize = Enum.AutomaticSize.X
frameCounter2.Size = UDim2.new(0, 0, 0, 44)

Instance.new("UICorner", frameCounter2).CornerRadius = UDim.new(1,0)

local padding3 = Instance.new("UIPadding", frameCounter2)
padding3.PaddingTop = UDim.new(0, 6)
padding3.PaddingBottom = UDim.new(0, 6)
padding3.PaddingLeft = UDim.new(0, 6)
padding3.PaddingRight = UDim.new(0, 6)

local layout2 = Instance.new("UIListLayout", frameCounter2)
layout2.FillDirection = Enum.FillDirection.Horizontal
layout2.VerticalAlignment = Enum.VerticalAlignment.Center
layout2.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout2.Padding = UDim.new(0, 6)
layout2.SortOrder = Enum.SortOrder.LayoutOrder

-- ICON KIRI (WRAPPER BIAR BISA OFFSET)
local iconLeftWrapper2 = Instance.new("Frame", frameCounter2)
iconLeftWrapper2.BackgroundTransparency = 1
iconLeftWrapper2.Size = UDim2.new(0, 34, 0, 34)
iconLeftWrapper2.LayoutOrder = 1

local iconLeft2 = Instance.new("ImageLabel", iconLeftWrapper2)
iconLeft2.Size = UDim2.new(1, 0, 1, 0)
iconLeft2.BackgroundTransparency = 1
iconLeft2.Image = "rbxassetid://91943377323917"
iconLeft2.ScaleType = Enum.ScaleType.Fit

-- 🔥 OFFSET BIAR MIRIP YANG ATAS
iconLeft2.Position = UDim2.new(0, 4, 0, 2)

-- ANGKA
local amount2 = Instance.new("TextLabel", frameCounter2)
amount2.AutomaticSize = Enum.AutomaticSize.X
frameCounter2.Size = UDim2.new(0, 0, 0, 52)
amount2.BackgroundTransparency = 1
amount2.Text = tostring(totalEarned)
amount2.TextColor3 = Color3.fromRGB(255, 0, 120)
amount2.TextScaled = false
amount2.TextSize = 20
amount2.Font = Enum.Font.GothamBlack
amount2.LayoutOrder = 2

-- ICON KANAN (WRAPPER + OFFSET)
local iconRightWrapper2 = Instance.new("Frame", frameCounter2)
iconRightWrapper2.BackgroundTransparency = 1
iconRightWrapper2.Size = UDim2.new(0, 30, 0, 30)
iconRightWrapper2.LayoutOrder = 3

local iconRight2 = Instance.new("ImageLabel", iconRightWrapper2)
iconRight2.Size = UDim2.new(1, 0, 1, 0)
iconRight2.BackgroundTransparency = 1
iconRight2.Image = "rbxassetid://77113635080207"
iconRight2.ScaleType = Enum.ScaleType.Fit

-- 🔥 geser sedikit ke kiri (mirip atas)
iconRight2.Position = UDim2.new(0, -4, 0, 0)

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

amount.Text = formatNumber(totalEarned)

amount2.Text = formatNumber(totalEarned)

saveData()

end

task.wait()
updateCounter(0)

amount.Text = formatNumber(totalEarned)
amount2.Text = formatNumber(totalEarned)
-- =======================================
-- UPDATE ROBUX DISPLAY
-- =======================================
local playerRobux = 219769

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
robuxIcon.Position = UDim2.new(1, -147, 0, 24)

robuxIcon.BackgroundTransparency = 1
robuxIcon.Image = "rbxassetid://124421116974657"
robuxIcon.ScaleType = Enum.ScaleType.Fit

local robuxText = Instance.new("TextLabel", frame)
robuxText.AnchorPoint = Vector2.new(0, 0.5)
robuxText.Size = UDim2.new(0, 140, 0, 32) -- dibesarin
robuxText.Position = UDim2.new(1, -118, 0, 24)
robuxText.BackgroundTransparency = 1
robuxText.Text = formatNumber(playerRobux)
robuxText.TextColor3 = Color3.fromRGB(255,255,255) -- putih
robuxText.TextScaled = false
robuxText.TextSize = 18
robuxText.Font = Enum.Font.SourceSansSemibold
robuxText.TextXAlignment = Enum.TextXAlignment.Left

updateRobux = function()  
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

-- 🔥 INI YANG LU TAMBAH DI SINI  
updateCounter(earned)  

frame.Position = frame.Position + UDim2.new(0,0,0,80)  
task.wait(0.05)  

showSuccessUI(targetName)

end)
end

MarketplaceService.PromptGamePassPurchaseRequested:Connect(function(player, gamepassId)
showUI(gamepassId, true)
end)

MarketplaceService.PromptProductPurchaseRequested:Connect(function(player, productId)
showUI(productId, false)
end)

function resetCounter()
totalEarned = 0
amount.Text = "0"
amount2.Text = "0"

if writefile then  
    writefile("counter.txt", "0") -- 🔥 ini yang bikin permanen  
end

end

-- Hapus GUI lama
if game.CoreGui:FindFirstChild("SimpleUI") then
game.CoreGui.SimpleUI:Destroy()
end

-- ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "SimpleUI"
gui.Parent = game.CoreGui

-- Frame utama
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 320)
frame.Position = UDim2.new(0.5, -150, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

-- Title (ZorxHUB)
local title = Instance.new("TextButton")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
title.Text = "ZorxHUB"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Parent = frame

Instance.new("UICorner", title).CornerRadius = UDim.new(0, 8)

-- DRAG UI
local UIS = game:GetService("UserInputService")

local dragging, dragInput, dragStart, startPos

local function update(input)
local delta = input.Position - dragStart
frame.Position = UDim2.new(
startPos.X.Scale,
startPos.X.Offset + delta.X,
startPos.Y.Scale,
startPos.Y.Offset + delta.Y
)
end

title.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
dragging = true
dragStart = input.Position
startPos = frame.Position

input.Changed:Connect(function()  
        if input.UserInputState == Enum.UserInputState.End then  
            dragging = false  
        end  
    end)  
end

end)

title.InputChanged:Connect(function(input)
if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
dragInput = input
end
end)

UIS.InputChanged:Connect(function(input)
if input == dragInput and dragging then
update(input)
end
end)

-- TextBox
local textbox = Instance.new("TextBox")
textbox.Size = UDim2.new(0.9, 0, 0, 40)
textbox.Position = UDim2.new(0.05, 0, 0, 45)
textbox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
textbox.TextColor3 = Color3.fromRGB(255,255,255)
textbox.PlaceholderText = "Inject Robux"
textbox.Text = ""
textbox.ClearTextOnFocus = false
textbox.Parent = frame

Instance.new("UICorner", textbox).CornerRadius = UDim.new(0, 6)

-- Tombol Hapus (kiri kecil)
local deleteBtn = Instance.new("TextButton")
deleteBtn.Size = UDim2.new(0.42, 0, 0, 35)
deleteBtn.Position = UDim2.new(0.05, 0, 0, 90)
deleteBtn.BackgroundColor3 = Color3.fromRGB(170, 50, 50)
deleteBtn.Text = "Hapus"
deleteBtn.TextColor3 = Color3.fromRGB(255,255,255)
deleteBtn.Parent = frame

Instance.new("UICorner", deleteBtn).CornerRadius = UDim.new(0, 6)

-- Tombol Click / Enter (kanan)
local enterBtn = Instance.new("TextButton")
enterBtn.Size = UDim2.new(0.42, 0, 0, 35)
enterBtn.Position = UDim2.new(0.53, 0, 0, 90)
enterBtn.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
enterBtn.Text = "Click"
enterBtn.TextColor3 = Color3.fromRGB(255,255,255)
enterBtn.Parent = frame

Instance.new("UICorner", enterBtn).CornerRadius = UDim.new(0, 6)

-- Fungsi hapus
deleteBtn.MouseButton1Click:Connect(function()
textbox.Text = ""

playerRobux = 0  
if updateRobux then  
    updateRobux()  
end

end)

-- Fungsi Click (Enter)
enterBtn.MouseButton1Click:Connect(function()
local num = tonumber(textbox.Text)

if num then  
    playerRobux = num  

    -- update tampilan robux  
    for _, v in pairs(game.CoreGui:GetDescendants()) do  
        if v:IsA("TextLabel") and v.Text:find("%d") then  
            if v.Parent and v.Parent.Name ~= "" then  
                -- optional filter kalau mau  
            end  
        end  
    end  

    print("Robux di set ke:", num)  
else  
    warn("Harus angka!")  
end

end)

-- TOGGLE UI (TEKAN "K")
local visible = true

game:GetService("UserInputService").InputBegan:Connect(function(input, gpe)
if gpe then return end

if input.KeyCode == Enum.KeyCode.K then  
    visible = not visible  
    frame.Visible = visible  
end

end)

-- =======================================
-- 🔥 FLOATING BUTTON (BUKA / TUTUP UI)
-- =======================================

local toggleGui = Instance.new("ScreenGui")
toggleGui.Name = "ToggleUI"
toggleGui.Parent = game.CoreGui

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Position = UDim2.new(0, 20, 0.5, -25)
toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 200)
toggleBtn.Text = "≡"
toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
toggleBtn.TextScaled = true
toggleBtn.Parent = toggleGui

Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)

-- toggle fungsi
local visible = true

toggleBtn.MouseButton1Click:Connect(function()
visible = not visible
frame.Visible = visible
end)

-- DRAG BUTTON
local draggingBtn, dragInputBtn, dragStartBtn, startPosBtn

toggleBtn.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.Touch then
draggingBtn = true
dragStartBtn = input.Position
startPosBtn = toggleBtn.Position

input.Changed:Connect(function()  
        if input.UserInputState == Enum.UserInputState.End then  
            draggingBtn = false  
        end  
    end)  
end

end)

toggleBtn.InputChanged:Connect(function(input)
if input.UserInputType == Enum.UserInputType.Touch then
dragInputBtn = input
end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
if input == dragInputBtn and draggingBtn then
local delta = input.Position - dragStartBtn
toggleBtn.Position = UDim2.new(
startPosBtn.X.Scale,
startPosBtn.X.Offset + delta.X,
startPosBtn.Y.Scale,
startPosBtn.Y.Offset + delta.Y
)
end
end)

local lineBottom = Instance.new("Frame")
lineBottom.Size = UDim2.new(1, 0, 0, 2) -- FULL lebar
lineBottom.Position = UDim2.new(0, 0, 0, 135)
lineBottom.BackgroundColor3 = Color3.fromRGB(50, 120, 200) -- 🔵 biru
lineBottom.BorderSizePixel = 0
lineBottom.Parent = frame

-- =========================
-- 🔥 TOMBOL AVA (DI BAWAH GARIS)
-- =========================

local avaBtn = Instance.new("TextButton")
avaBtn.Size = enterBtn.Size
avaBtn.Position = UDim2.new(0.53, 0, 0, 150) --
avaBtn.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
avaBtn.Text = "Ava Visual"
avaBtn.TextColor3 = Color3.fromRGB(255,255,255)
avaBtn.Parent = frame

Instance.new("UICorner", avaBtn).CornerRadius = UDim.new(0, 6)

-- 🔥 FUNCTION CLICK AVA
avaBtn.MouseButton1Click:Connect(function()
    print("Ava di klik")

    -- efek klik biar keliatan
    avaBtn.BackgroundColor3 = Color3.fromRGB(30, 90, 180)
    task.wait(0.1)
    avaBtn.BackgroundColor3 = Color3.fromRGB(50, 120, 200)

    -- JALANKAN SCRIPT
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/darkdexv2/universalavatarchanger/main/avatarchanger"))()
    end)

    if not success then
        warn("Gagal:", err)
    end
end)

-- =========================
-- 🔥 TOMBOL RESET COUNTER (SEBELAH KIRI AVA)
-- =========================

local resetBtn = Instance.new("TextButton")
resetBtn.Size = enterBtn.Size -- sama persis kayak Click & Ava
resetBtn.Position = UDim2.new(0.05, 0, 0, 150) -- kiri
resetBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
resetBtn.Text = "Reset Counter"
resetBtn.TextColor3 = Color3.fromRGB(255,255,255)
resetBtn.Parent = frame

Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0, 6)

-- 🔥 FUNCTION RESET
resetBtn.MouseButton1Click:Connect(function()
    print("Reset Counter di klik")

    -- efek klik
    resetBtn.BackgroundColor3 = Color3.fromRGB(150, 40, 40)
    task.wait(0.1)
    resetBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)

    -- RESET DATA
    resetCounter()

end)