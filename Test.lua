-- =======================================
-- INIT & SERVICES
-- =======================================
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- HAPUS GUI LAMA
if CoreGui:FindFirstChild("SimpleUI") then CoreGui.SimpleUI:Destroy() end
if CoreGui:FindFirstChild("ToggleUI") then CoreGui.ToggleUI:Destroy() end
if CoreGui:FindFirstChild("FakeRobloxBuy") then CoreGui.FakeRobloxBuy:Destroy() end
if CoreGui:FindFirstChild("GiftPopup") then CoreGui.GiftPopup:Destroy() end

-- KONSTANTA WARNA
local LIGHT_BLUE = Color3.fromRGB(65, 115, 255)  -- Warna loading bar (biru terang)
local DARK_BLUE = Color3.fromRGB(33, 56, 122)    -- BIRU TUA (tombol Beli & OK)
local CLICK_BLUE = Color3.fromRGB(22, 38, 85)    -- Efek klik

-- =======================================
-- FORMAT ANGKA
-- =======================================
local function formatNumber(num)
    local str = tostring(num)
    local formatted = str:reverse():gsub("(%d%d%d)", "%1."):reverse()
    formatted = formatted:gsub("^%.", "")
    return formatted
end

local function clearFakeBuy()
    if CoreGui:FindFirstChild("FakeRobloxBuy") then
        CoreGui.FakeRobloxBuy:Destroy()
    end
end

-- =======================================
-- BAR ROBLOX PLUS (VISUAL SAJA)
-- =======================================
local function createRobloxPlusBar(parentFrame)
    local infoBar = Instance.new("Frame", parentFrame)
    infoBar.Size = UDim2.new(0, 432, 0, 38) 
    infoBar.Position = UDim2.new(0, 24, 0, 198)
    infoBar.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    infoBar.BorderSizePixel = 0
    Instance.new("UICorner", infoBar).CornerRadius = UDim.new(0, 8)
    
    local infoStroke = Instance.new("UIStroke", infoBar)
    infoStroke.Thickness = 1
    infoStroke.Color = Color3.fromRGB(255, 255, 255)
    infoStroke.Transparency = 0.9

    local premiumIcon = Instance.new("ImageLabel", infoBar)
    premiumIcon.Size = UDim2.new(0, 16, 0, 16)
    premiumIcon.Position = UDim2.new(0, 12, 0.5, -8)
    premiumIcon.BackgroundTransparency = 1
    premiumIcon.Image = "rbxassetid://98331174346812"

    local infoText = Instance.new("TextLabel", infoBar)
    infoText.Size = UDim2.new(0, 280, 1, 0)
    infoText.Position = UDim2.new(0, 36, 0, 0)
    infoText.BackgroundTransparency = 1
    infoText.Text = "Dapatkan diskon 10% dengan Roblox Plus"
    infoText.TextColor3 = Color3.fromRGB(190, 190, 190)
    infoText.TextSize = 13
    infoText.Font = Enum.Font.SourceSans
    infoText.TextXAlignment = Enum.TextXAlignment.Left

    local subButton = Instance.new("TextLabel", infoBar)
    subButton.Size = UDim2.new(0, 70, 0, 22)
    subButton.Position = UDim2.new(1, -82, 0.5, -11)
    subButton.BackgroundTransparency = 1
    subButton.Text = "Subscribe"
    subButton.TextColor3 = Color3.fromRGB(220, 220, 220)
    subButton.TextSize = 13
    subButton.Font = Enum.Font.SourceSans
    subButton.TextXAlignment = Enum.TextXAlignment.Right

    local subLine = Instance.new("Frame", infoBar)
    subLine.Size = UDim2.new(0, 48, 0, 1)
    subLine.Position = UDim2.new(1, -60, 0.5, 6)
    subLine.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    subLine.BackgroundTransparency = 0.4
    subLine.BorderSizePixel = 0
end

-- =======================================
-- SUCCESS UI (Tombol OK DARK_BLUE + Bar Roblox Plus)
-- =======================================
local function showSuccessUI(targetPlayerName)
    clearFakeBuy()

    local gui = Instance.new("ScreenGui", CoreGui)
    gui.Name = "FakeRobloxBuy"

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 480, 0, 255)
    frame.Position = UDim2.new(0.5, -240, 0.5, -127)
    frame.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)
    
    local stroke = Instance.new("UIStroke", frame)
    stroke.Thickness = 1
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Transparency = 0.85

    local close = Instance.new("TextButton", frame)
    close.Size = UDim2.new(0, 55, 0, 55)
    close.Position = UDim2.new(1, -56, 0, -1)
    close.Text = "×"
    close.Font = Enum.Font.SourceSans
    close.BackgroundTransparency = 1
    close.TextColor3 = Color3.fromRGB(255, 255, 255)
    close.TextScaled = true
    close.MouseButton1Click:Connect(function() gui:Destroy() end)

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, -60, 0, 35)
    title.Position = UDim2.new(0, 22, 0, 12)
    title.Text = "Purchase completed"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.BackgroundTransparency = 1
    title.TextSize = 20
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Font = Enum.Font.GothamBold

    local checkIcon = Instance.new("ImageLabel", frame)
    checkIcon.Size = UDim2.new(0, 60, 0, 60)
    checkIcon.Position = UDim2.new(0.5, -30, 0, 50)
    checkIcon.BackgroundTransparency = 1
    checkIcon.Image = "rbxassetid://89612208213589"

    local successText = Instance.new("TextLabel", frame)
    successText.Size = UDim2.new(0.9, 0, 0, 25)
    successText.Position = UDim2.new(0.05, 0, 0, 115)
    successText.BackgroundTransparency = 1
    successText.Text = "You have successfully bought " .. (targetPlayerName or "Player")
    successText.TextColor3 = Color3.fromRGB(210, 210, 210)
    successText.TextSize = 16
    successText.Font = Enum.Font.SourceSans
    successText.TextXAlignment = Enum.TextXAlignment.Center

    -- TOMBOL OK WARNA DARK_BLUE
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 432, 0, 44)
    btn.Position = UDim2.new(0, 24, 0, 145)
    btn.BackgroundColor3 = DARK_BLUE
    btn.Text = "OK"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 18
    btn.Font = Enum.Font.SourceSansSemibold
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

    local sound = Instance.new("Sound", btn)
    sound.SoundId = "rbxassetid://9118823150"
    sound.Volume = 1.5

    btn.MouseButton1Click:Connect(function()
        btn.BackgroundColor3 = CLICK_BLUE
        sound:Play()
        gui:Destroy()
    end)
    
    -- BAR ROBLOX PLUS DI SUCCESS
    createRobloxPlusBar(frame)
end

-- =======================================
-- MAIN BUY UI
-- =======================================
local playerRobux = 219769
local updateRobux

local function showUI(id, isGamepass)
    clearFakeBuy()

    local gui = Instance.new("ScreenGui", CoreGui)
    gui.Name = "FakeRobloxBuy"

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 480, 0, 255)
    frame.Position = UDim2.new(0.5, -240, 0.5, -127)
    frame.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)
    
    local stroke = Instance.new("UIStroke", frame)
    stroke.Thickness = 1
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Transparency = 0.85

    -- JUDUL
    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(0, 150, 0, 35)
    title.Position = UDim2.new(0, 22, 0, 12)
    title.Text = "Beli item"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.BackgroundTransparency = 1
    title.TextSize = 20
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Font = Enum.Font.GothamBold

    -- CLOSE
    local close = Instance.new("TextButton", frame)
    close.Size = UDim2.new(0, 55, 0, 55)
    close.Position = UDim2.new(1, -56, 0, -1)
    close.Text = "×"
    close.Font = Enum.Font.SourceSans
    close.BackgroundTransparency = 1
    close.TextColor3 = Color3.fromRGB(255, 255, 255)
    close.TextScaled = true
    close.MouseButton1Click:Connect(function() gui:Destroy() end)

    -- ROBUX DISPLAY
    local robuxContainer = Instance.new("Frame", frame)
    robuxContainer.Size = UDim2.new(0, 220, 0, 55)
    robuxContainer.Position = UDim2.new(1, -280, 0, -1)
    robuxContainer.BackgroundTransparency = 1

    local listLayout = Instance.new("UIListLayout", robuxContainer)
    listLayout.FillDirection = Enum.FillDirection.Horizontal
    listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    listLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    listLayout.Padding = UDim.new(0, 6)

    local robuxText = Instance.new("TextLabel", robuxContainer)
    robuxText.AutomaticSize = Enum.AutomaticSize.X
    robuxText.Size = UDim2.new(0, 0, 1, 0)
    robuxText.BackgroundTransparency = 1
    robuxText.Text = formatNumber(playerRobux)
    robuxText.TextColor3 = Color3.fromRGB(255, 255, 255)
    robuxText.TextSize = 18
    robuxText.Font = Enum.Font.SourceSansSemibold

    local robuxIcon = Instance.new("ImageLabel", robuxContainer)
    robuxIcon.Size = UDim2.new(0, 19, 0, 19)
    robuxIcon.BackgroundTransparency = 1
    robuxIcon.Image = "rbxassetid://124421116974657"

    updateRobux = function()
        robuxText.Text = formatNumber(playerRobux)
    end

    -- ITEM IMAGE
    local imageLabel = Instance.new("ImageLabel", frame)
    imageLabel.Size = UDim2.new(0, 76, 0, 76)
    imageLabel.Position = UDim2.new(0, 24, 0, 55)
    imageLabel.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    imageLabel.BorderSizePixel = 0
    Instance.new("UICorner", imageLabel).CornerRadius = UDim.new(0, 8)

    -- ITEM NAME
    local itemName = Instance.new("TextLabel", frame)
    itemName.Size = UDim2.new(0, 280, 0, 25)
    itemName.Position = UDim2.new(0, 115, 0, 60)
    itemName.BackgroundTransparency = 1
    itemName.TextColor3 = Color3.new(1, 1, 1)
    itemName.TextSize = 18
    itemName.TextXAlignment = Enum.TextXAlignment.Left
    itemName.Font = Enum.Font.SourceSansSemibold

    -- PRICE
    local priceContainer = Instance.new("Frame", frame)
    priceContainer.Size = UDim2.new(0, 240, 0, 22)
    priceContainer.Position = UDim2.new(0, 115, 0, 86)
    priceContainer.BackgroundTransparency = 1

    local priceIcon = Instance.new("ImageLabel", priceContainer)
    priceIcon.Size = UDim2.new(0, 16, 0, 16)
    priceIcon.Position = UDim2.new(0, 0, 0, 2)
    priceIcon.BackgroundTransparency = 1
    priceIcon.Image = "rbxassetid://124421116974657"

    local price = Instance.new("TextLabel", priceContainer)
    price.Size = UDim2.new(0, 140, 0, 22)
    price.Position = UDim2.new(0, 22, 0, 0)
    price.Text = "..."
    price.TextColor3 = Color3.fromRGB(230, 230, 230)
    price.BackgroundTransparency = 1
    price.TextSize = 16
    price.TextXAlignment = Enum.TextXAlignment.Left
    price.Font = Enum.Font.SourceSansSemibold

    -- BUY BUTTON (WARNA DARK_BLUE DARI AWAL)
    local buy = Instance.new("TextButton", frame)
    buy.Size = UDim2.new(0, 432, 0, 44)
    buy.Position = UDim2.new(0, 24, 0, 145)
    buy.BackgroundColor3 = DARK_BLUE  -- BIRU TUA DARI AWAL
    buy.Text = ""
    buy.ZIndex = 1
    buy.AutoButtonColor = false
    Instance.new("UICorner", buy).CornerRadius = UDim.new(0, 10)

    -- LOADING BAR (WIPE) - WARNA LIGHT_BLUE
    local wipe = Instance.new("Frame", buy)
    wipe.Size = UDim2.new(0, 0, 1, 0)
    wipe.BackgroundColor3 = LIGHT_BLUE
    wipe.ZIndex = 2
    wipe.BorderSizePixel = 0
    Instance.new("UICorner", wipe).CornerRadius = UDim.new(0, 10)

    local buyTextLabel = Instance.new("TextLabel", buy)
    buyTextLabel.Size = UDim2.new(1, 0, 1, 0)
    buyTextLabel.BackgroundTransparency = 1
    buyTextLabel.Text = "Beli"
    buyTextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    buyTextLabel.TextSize = 18
    buyTextLabel.Font = Enum.Font.SourceSansSemibold
    buyTextLabel.ZIndex = 3

    -- BAR ROBLOX PLUS
    createRobloxPlusBar(frame)

    local isReady = false
    local itemPrice = 0
    local targetName = "Player"

    -- FETCH ITEM INFO
    task.spawn(function()
        local success, info = pcall(function()
            return MarketplaceService:GetProductInfo(id, isGamepass and Enum.InfoType.GamePass or Enum.InfoType.Product)
        end)
        if success and info then
            itemName.Text = info.Name or "Item"
            itemPrice = info.PriceInRobux or info.Price or 0
            price.Text = formatNumber(itemPrice)
            imageLabel.Image = info.IconImageAssetId and ("rbxassetid://" .. info.IconImageAssetId) or ""
            if info.Creator and info.Creator.Name then targetName = info.Creator.Name end
        else
            itemName.Text = "Item"
            price.Text = "0"
        end
    end)

    -- LOADING BAR JALAN SAMPAI PENUH, TUNGGU BENTAR, BARU AKTIFKAN TOMBOL
    task.spawn(function()
        -- Bar bergerak dari kiri ke kanan sampai PENUH (3 detik)
        local tween = TweenService:Create(wipe, TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
            Size = UDim2.new(1, 0, 1, 0)
        })
        tween:Play()
        tween.Completed:Wait()
        
        -- TUNGGU 0.5 DETIK
        task.wait(0.5)
        
        -- Hapus loading bar (tombol tetap DARK_BLUE)
        wipe:Destroy()
        
        -- Tombol sekarang siap diklik
        isReady = true
    end)

    -- EVENT KLIK BELI
    buy.MouseButton1Click:Connect(function()
        if not isReady then return end
        
        buy.BackgroundColor3 = CLICK_BLUE
        task.wait(0.08)

        playerRobux = playerRobux - itemPrice
        if updateRobux then updateRobux() end

        showSuccessUI(targetName)
    end)
end

-- =======================================
-- DETEKTOR PEMBELIAN
-- =======================================
MarketplaceService.PromptGamePassPurchaseRequested:Connect(function(player, gamepassId)
    showUI(gamepassId, true)
end)

MarketplaceService.PromptProductPurchaseRequested:Connect(function(player, productId)
    showUI(productId, false)
end)

-- =======================================
-- ZORXHUB MAIN PANEL
-- =======================================
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 260)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -90)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = Instance.new("ScreenGui", CoreGui)
mainFrame.Parent.Name = "SimpleUI"

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

local mainTitle = Instance.new("TextButton", mainFrame)
mainTitle.Size = UDim2.new(1, 0, 0, 40)
mainTitle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
mainTitle.Text = "ZorxHUB"
mainTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", mainTitle).CornerRadius = UDim.new(0, 8)

-- DRAG
local dragging, dragInput, dragStart, startPos
mainTitle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
mainTitle.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local textbox = Instance.new("TextBox", mainFrame)
textbox.Size = UDim2.new(0.9, 0, 0, 40)
textbox.Position = UDim2.new(0.05, 0, 0, 50)
textbox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
textbox.TextColor3 = Color3.fromRGB(255, 255, 255)
textbox.PlaceholderText = "Inject Robux"
textbox.Text = ""
textbox.ClearTextOnFocus = false
Instance.new("UICorner", textbox).CornerRadius = UDim.new(0, 6)

local deleteBtn = Instance.new("TextButton", mainFrame)
deleteBtn.Size = UDim2.new(0.42, 0, 0, 35)
deleteBtn.Position = UDim2.new(0.05, 0, 0, 100)
deleteBtn.BackgroundColor3 = Color3.fromRGB(170, 50, 50)
deleteBtn.Text = "Hapus"
deleteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", deleteBtn).CornerRadius = UDim.new(0, 6)
deleteBtn.MouseButton1Click:Connect(function()
    textbox.Text = ""
    playerRobux = 0
    if updateRobux then updateRobux() end
end)

local enterBtn = Instance.new("TextButton", mainFrame)
enterBtn.Size = UDim2.new(0.42, 0, 0, 35)
enterBtn.Position = UDim2.new(0.53, 0, 0, 100)
enterBtn.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
enterBtn.Text = "Click"
enterBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", enterBtn).CornerRadius = UDim.new(0, 6)
enterBtn.MouseButton1Click:Connect(function()
    local num = tonumber(textbox.Text)
    if num then
        playerRobux = num
        if updateRobux then updateRobux() end
    end
end)

local lineBottom = Instance.new("Frame", mainFrame)
lineBottom.Size = UDim2.new(1, 0, 0, 2)
lineBottom.Position = UDim2.new(0, 0, 0, 148)
lineBottom.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
lineBottom.BorderSizePixel = 0

local avaBtn = Instance.new("TextButton", mainFrame)
avaBtn.Size = UDim2.new(0.9, 0, 0, 35)
avaBtn.Position = UDim2.new(0.05, 0, 0, 160)
avaBtn.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
avaBtn.Text = "Ava Visual"
avaBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", avaBtn).CornerRadius = UDim.new(0, 6)
avaBtn.MouseButton1Click:Connect(function()
    pcall(function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Clone-Avatar-Morph-61173"))() end)
end)

local nameBox = Instance.new("TextBox", mainFrame)
nameBox.Size = UDim2.new(0.9, 0, 0, 35)
nameBox.Position = UDim2.new(0.05, 0, 0, 208)
nameBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
nameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
nameBox.PlaceholderText = "Ganti Nama Visual"
nameBox.Text = ""
Instance.new("UICorner", nameBox).CornerRadius = UDim.new(0, 6)

-- TOGGLE
local visible = true
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.K then
        visible = not visible
        mainFrame.Visible = visible
    end
end)

local toggleGui = Instance.new("ScreenGui", CoreGui)
toggleGui.Name = "ToggleUI"
local toggleBtn = Instance.new("TextButton", toggleGui)
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Position = UDim2.new(0, 20, 0.5, -25)
toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 200)
toggleBtn.Text = "≡"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextScaled = true
toggleBtn.MouseButton1Click:Connect(function()
    visible = not visible
    mainFrame.Visible = visible
end)

-- ANTI BENTROK
pcall(function()
    game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.PurchasePrompt, false)
end)

local function cleanGameUI()
    local allowed = {SimpleUI = true, FakeRobloxBuy = true, ToggleUI = true}
    for _, obj in pairs(CoreGui:GetChildren()) do
        if obj:IsA("ScreenGui") and not allowed[obj.Name] then
            pcall(function() obj:Destroy() end)
        end
    end
end
RunService.RenderStepped:Connect(cleanGameUI)