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
if CoreGui:FindFirstChild("RobloxPlusPopup") then CoreGui.RobloxPlusPopup:Destroy() end

-- KONSTANTA WARNA
local LIGHT_BLUE = Color3.fromRGB(65, 115, 255)  -- Warna loading bar (biru terang)
local DARK_BLUE = Color3.fromRGB(33, 56, 122)    -- BIRU TUA (tombol Beli & OK)
local CLICK_BLUE = Color3.fromRGB(22, 38, 85)    -- Efek klik

-- Variabel Global
local mainFrame
local currentBuyUI -- Untuk menyimpan referensi tampilan Beli Item agar bisa kembali

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
    if CoreGui:FindFirstChild("RobloxPlusPopup") then
        CoreGui.RobloxPlusPopup:Destroy()
    end
end

-- =======================================
-- POPUP ROBLOX PLUS (DARI SUB-SCRIPT)
-- =======================================
local function showRobloxPlusPopup()
    if CoreGui:FindFirstChild("RobloxPlusPopup") then CoreGui.RobloxPlusPopup:Destroy() end
    
    local gui = Instance.new("ScreenGui")
    gui.Name = "RobloxPlusPopup"
    gui.Parent = CoreGui
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 100 -- Agar selalu di atas
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 440, 0, 420)
    frame.Position = UDim2.new(0.5, -220, 0.5, -210)
    frame.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
    frame.BorderSizePixel = 0
    frame.Parent = gui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)
    
    local stroke = Instance.new("UIStroke", frame)
    stroke.Thickness = 1
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Transparency = 0.85
    
    -- ========== HEADER ==========
    -- TOMBOL KEMBALI: Kembali ke tampilan BELI ITEM
    local backBtn = Instance.new("TextButton", frame)
    backBtn.Size = UDim2.new(0, 40, 0, 40)
    backBtn.Position = UDim2.new(0, 12, 0, 10)
    backBtn.Text = "‹"
    backBtn.Font = Enum.Font.SourceSans
    backBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    backBtn.TextSize = 32
    backBtn.BackgroundTransparency = 1
    backBtn.AutoButtonColor = false
    backBtn.ZIndex = 10
    backBtn.MouseButton1Click:Connect(function() 
        gui:Destroy() -- Tutup halaman diskon ini
        if currentBuyUI then 
            currentBuyUI.Enabled = true -- MUNCULKAN KEMBALI HALAMAN BELI ITEM
        end
    end)
    
    local plusIcon = Instance.new("ImageLabel", frame)
    plusIcon.Size = UDim2.new(0, 24, 0, 24)
    plusIcon.Position = UDim2.new(0, 56, 0, 18)
    plusIcon.Image = "rbxassetid://98331174346812"
    plusIcon.BackgroundTransparency = 1
    plusIcon.ZIndex = 5
    
    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(0, 220, 0, 40)
    title.Position = UDim2.new(0, 88, 0, 12)
    title.Text = "Dapatkan Roblox Plus"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.BackgroundTransparency = 1
    title.ZIndex = 5
    
    -- TOMBOL TUTUP: HANYA TUTUP JENDELA INI SAJA, TIDAK KEMBALI KE MENU UTAMA
    local closeBtn = Instance.new("TextButton", frame)
    closeBtn.Size = UDim2.new(0, 40, 0, 40)
    closeBtn.Position = UDim2.new(1, -52, 0, 10)
    closeBtn.Text = "×"
    closeBtn.Font = Enum.Font.SourceSans
    closeBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    closeBtn.TextSize = 28
    closeBtn.BackgroundTransparency = 1
    closeBtn.AutoButtonColor = false
    closeBtn.ZIndex = 10
    closeBtn.MouseButton1Click:Connect(function() 
        gui:Destroy()
        -- TIDAK ADA KODE UNTUK MEMUNCULKAN MENU UTAMA DI SINI
    end)
    
    -- ========== HARGA ==========
    local priceLabel = Instance.new("TextLabel", frame)
    priceLabel.Size = UDim2.new(1, -48, 0, 30)
    priceLabel.Position = UDim2.new(0, 24, 0, 60)
    priceLabel.Text = "Rp90.000,00/bulan"
    priceLabel.Font = Enum.Font.SourceSansBold
    priceLabel.TextSize = 18
    priceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    priceLabel.TextXAlignment = Enum.TextXAlignment.Left
    priceLabel.BackgroundTransparency = 1
    priceLabel.ZIndex = 5
    
    -- ========== LIST BENEFIT ==========
    local benefits = {
        {text = "Diskon 10% untuk item dalam game, avatar, dan banyak lagi", icon = "rbxassetid://116213303539702"},
        {text = "Diskon 20% untuk item ini setelah 2 bulan", icon = "rbxassetid://116213303539702"},
        {text = "Server privat gratis dan tanpa batas", icon = "rbxassetid://116213303539702"},
        {text = "Kirim Robux secara gratis", icon = "rbxassetid://124421116974657"}
    }
    
    for i, benefit in ipairs(benefits) do
        local yPos = 105 + ((i-1) * 38)
        
        local icon = Instance.new("ImageLabel", frame)
        icon.Size = UDim2.new(0, 20, 0, 20)
        icon.Position = UDim2.new(0, 24, 0, yPos)
        icon.Image = benefit.icon
        icon.BackgroundTransparency = 1
        icon.ZIndex = 5
        
        local textLabel = Instance.new("TextLabel", frame)
        textLabel.Size = UDim2.new(1, -60, 0, 24)
        textLabel.Position = UDim2.new(0, 56, 0, yPos - 2)
        textLabel.Text = benefit.text
        textLabel.Font = Enum.Font.SourceSans
        textLabel.TextSize = 14
        textLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        textLabel.TextXAlignment = Enum.TextXAlignment.Left
        textLabel.BackgroundTransparency = 1
        textLabel.ZIndex = 5
    end
    
    -- ========== TOMBOL SUBSCRIBE ==========
    local subscribeBtn = Instance.new("TextButton", frame)
    subscribeBtn.Size = UDim2.new(0, 392, 0, 48)
    subscribeBtn.Position = UDim2.new(0, 24, 0, 270)
    subscribeBtn.BackgroundColor3 = Color3.fromRGB(40, 93, 233)
    subscribeBtn.Text = ""
    subscribeBtn.BorderSizePixel = 0
    subscribeBtn.AutoButtonColor = false
    subscribeBtn.ZIndex = 10
    Instance.new("UICorner", subscribeBtn).CornerRadius = UDim.new(0, 10)
    
    -- TEKS SUBSCRIBE
    local btnText = Instance.new("TextLabel", subscribeBtn)
    btnText.Size = UDim2.new(1, 0, 1, 0)
    btnText.BackgroundTransparency = 1
    btnText.Text = "Subscribe"
    btnText.TextColor3 = Color3.fromRGB(255, 255, 255)
    btnText.TextSize = 18
    btnText.Font = Enum.Font.SourceSansSemibold
    btnText.ZIndex = 5
    
    -- LOADING SPINNER (8 TITIK DIAM)
    local spinner = Instance.new("Frame", subscribeBtn)
    spinner.Size = UDim2.new(0, 32, 0, 32)
    spinner.Position = UDim2.new(0.5, -16, 0.5, -16)
    spinner.BackgroundTransparency = 1
    spinner.Visible = false
    spinner.ZIndex = 5
    
    local dots = {}
    local centerX, centerY = 16, 16
    local radius = 12
    
    for i = 1, 8 do
        local angle = (i - 1) * 45
        local rad = math.rad(angle)
        local x = centerX + radius * math.cos(rad)
        local y = centerY + radius * math.sin(rad)
        
        local dot = Instance.new("Frame", spinner)
        dot.Size = UDim2.new(0, 5, 0, 5)
        dot.Position = UDim2.new(0, x - 2.5, 0, y - 2.5)
        dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        dot.BackgroundTransparency = 0.7
        dot.BorderSizePixel = 0
        dot.ZIndex = 5
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
        dots[i] = dot
    end
    
    local spinConnection = nil
    local function startSpinner()
        spinner.Visible = true
        btnText.Visible = false
        subscribeBtn.BackgroundColor3 = Color3.fromRGB(30, 70, 180)
        
        local startTime = tick()
        spinConnection = RunService.RenderStepped:Connect(function()
            local elapsed = (tick() - startTime) % 1
            local activeIndex = math.floor(elapsed * 8) + 1
            for i = 1, 8 do
                if i == activeIndex then
                    dots[i].BackgroundTransparency = 0
                    dots[i].Size = UDim2.new(0, 6, 0, 6)
                    dots[i].Position = UDim2.new(0, dots[i].Position.X.Offset - 0.5, 0, dots[i].Position.Y.Offset - 0.5)
                else
                    dots[i].BackgroundTransparency = 0.7
                    dots[i].Size = UDim2.new(0, 5, 0, 5)
                    dots[i].Position = UDim2.new(0, dots[i].Position.X.Offset + 0.5, 0, dots[i].Position.Y.Offset + 0.5)
                end
            end
        end)
    end
    
    local function stopSpinner()
        if spinConnection then spinConnection:Disconnect() end
        spinner.Visible = false
        btnText.Visible = true
        subscribeBtn.BackgroundColor3 = Color3.fromRGB(40, 93, 233)
    end
    
    subscribeBtn.MouseButton1Click:Connect(function()
        startSpinner()
        task.wait(2)
        stopSpinner()
        gui:Destroy()
        if currentBuyUI then currentBuyUI:Destroy() end
    end)
    
    -- ========== SYARAT & KETENTUAN ==========
    local legalText = Instance.new("TextLabel", frame)
    legalText.Size = UDim2.new(0, 392, 0, 50)
    legalText.Position = UDim2.new(0, 24, 0, 330)
    legalText.Text = "Dengan mengklik \"Subscribe\", kamu menyetujui Ketentuan Subscription Roblox. Biaya akan otomatis dibebankan setiap bulan hingga kamu membatalkan."
    legalText.Font = Enum.Font.SourceSans
    legalText.TextSize = 12
    legalText.TextColor3 = Color3.fromRGB(140, 140, 140)
    legalText.TextWrapped = true
    legalText.TextXAlignment = Enum.TextXAlignment.Left
    legalText.TextYAlignment = Enum.TextYAlignment.Top
    legalText.BackgroundTransparency = 1
    legalText.ZIndex = 5
    
    frame.BackgroundTransparency = 0.2
    TweenService:Create(frame, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
end

-- =======================================
-- BAR ROBLOX PLUS (CONNECTED TO POPUP)
-- =======================================
local function createRobloxPlusBar(parentFrame)
    local infoBar = Instance.new("Frame", parentFrame)
    infoBar.Size = UDim2.new(0, 432, 0, 38) 
    infoBar.Position = UDim2.new(0, 24, 0, 198)
    infoBar.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    infoBar.BorderSizePixel = 0
    infoBar.ZIndex = 5
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
    premiumIcon.ZIndex = 5

    -- Teks yang bisa diklik untuk membuka halaman diskon
    local infoText = Instance.new("TextButton", infoBar)
    infoText.Size = UDim2.new(0, 280, 1, 0)
    infoText.Position = UDim2.new(0, 36, 0, 0)
    infoText.BackgroundTransparency = 1
    infoText.Text = "Dapatkan diskon 10% dengan Roblox Plus"
    infoText.TextColor3 = Color3.fromRGB(190, 190, 190)
    infoText.TextSize = 13
    infoText.Font = Enum.Font.SourceSans
    infoText.TextXAlignment = Enum.TextXAlignment.Left
    infoText.AutoButtonColor = false
    infoText.ZIndex = 10
    infoText.MouseButton1Click:Connect(function()
        if currentBuyUI then currentBuyUI.Enabled = false end -- Sembunyikan halaman beli sementara
        showRobloxPlusPopup()
    end)

    local subButton = Instance.new("TextButton", infoBar)
    subButton.Size = UDim2.new(0, 70, 0, 22)
    subButton.Position = UDim2.new(1, -82, 0.5, -11)
    subButton.BackgroundTransparency = 1
    subButton.Text = "Subscribe"
    subButton.TextColor3 = Color3.fromRGB(220, 220, 220)
    subButton.TextSize = 13
    subButton.Font = Enum.Font.SourceSans
    subButton.TextXAlignment = Enum.TextXAlignment.Right
    subButton.AutoButtonColor = false
    subButton.ZIndex = 10
    subButton.MouseButton1Click:Connect(function()
        if currentBuyUI then currentBuyUI.Enabled = false end -- Sembunyikan halaman beli sementara
        showRobloxPlusPopup()
    end)

    local subLine = Instance.new("Frame", infoBar)
    subLine.Size = UDim2.new(0, 48, 0, 1)
    subLine.Position = UDim2.new(1, -60, 0.5, 6)
    subLine.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    subLine.BackgroundTransparency = 0.4
    subLine.BorderSizePixel = 0
    subLine.ZIndex = 5
end

-- =======================================
-- SUCCESS UI
-- =======================================
local function showSuccessUI(targetPlayerName)
    clearFakeBuy()

    local gui = Instance.new("ScreenGui", CoreGui)
    gui.Name = "FakeRobloxBuy"
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 90

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

    -- TOMBOL TUTUP: HANYA TUTUP JENDELA INI SAJA
    local close = Instance.new("TextButton", frame)
    close.Size = UDim2.new(0, 55, 0, 55)
    close.Position = UDim2.new(1, -56, 0, -1)
    close.Text = "×"
    close.Font = Enum.Font.SourceSans
    close.BackgroundTransparency = 1
    close.TextColor3 = Color3.fromRGB(255, 255, 255)
    close.TextScaled = true
    close.AutoButtonColor = false
    close.ZIndex = 10
    close.MouseButton1Click:Connect(function() 
        gui:Destroy() 
        -- TIDAK KEMBALI KE MENU UTAMA
    end)

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, -60, 0, 35)
    title.Position = UDim2.new(0, 22, 0, 12)
    title.Text = "Purchase completed"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.BackgroundTransparency = 1
    title.TextSize = 20
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Font = Enum.Font.GothamBold
    title.ZIndex = 5

    local checkIcon = Instance.new("ImageLabel", frame)
    checkIcon.Size = UDim2.new(0, 60, 0, 60)
    checkIcon.Position = UDim2.new(0.5, -30, 0, 50)
    checkIcon.BackgroundTransparency = 1
    checkIcon.Image = "rbxassetid://89612208213589"
    checkIcon.ZIndex = 5

    local successText = Instance.new("TextLabel", frame)
    successText.Size = UDim2.new(0.9, 0, 0, 25)
    successText.Position = UDim2.new(0.05, 0, 0, 115)
    successText.BackgroundTransparency = 1
    successText.Text = "You have successfully bought " .. (targetPlayerName or "Player")
    successText.TextColor3 = Color3.fromRGB(210, 210, 210)
    successText.TextSize = 16
    successText.Font = Enum.Font.SourceSans
    successText.TextXAlignment = Enum.TextXAlignment.Center
    successText.ZIndex = 5

    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 432, 0, 44)
    btn.Position = UDim2.new(0, 24, 0, 145)
    btn.BackgroundColor3 = DARK_BLUE
    btn.Text = "OK"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 18
    btn.Font = Enum.Font.SourceSansSemibold
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.ZIndex = 10
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

    local sound = Instance.new("Sound", btn)
    sound.SoundId = "rbxassetid://9118823150"
    sound.Volume = 1.5

    btn.MouseButton1Click:Connect(function()
        btn.BackgroundColor3 = CLICK_BLUE
        sound:Play()
        gui:Destroy()
        -- TIDAK KEMBALI KE MENU UTAMA
    end)
    
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
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 80
    currentBuyUI = gui -- Simpan referensi agar bisa dipanggil kembali

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

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(0, 150, 0, 35)
    title.Position = UDim2.new(0, 22, 0, 12)
    title.Text = "Beli item"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.BackgroundTransparency = 1
    title.TextSize = 20
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Font = Enum.Font.GothamBold
    title.ZIndex = 5

    -- TOMBOL TUTUP: HANYA TUTUP JENDELA INI SAJA
    local close = Instance.new("TextButton", frame)
    close.Size = UDim2.new(0, 55, 0, 55)
    close.Position = UDim2.new(1, -56, 0, -1)
    close.Text = "×"
    close.Font = Enum.Font.SourceSans
    close.BackgroundTransparency = 1
    close.TextColor3 = Color3.fromRGB(255, 255, 255)
    close.TextScaled = true
    close.AutoButtonColor = false
    close.ZIndex = 10
    close.MouseButton1Click:Connect(function() 
        gui:Destroy() 
        -- TIDAK KEMBALI KE MENU UTAMA
    end)

    local robuxContainer = Instance.new("Frame", frame)
    robuxContainer.Size = UDim2.new(0, 220, 0, 55)
    robuxContainer.Position = UDim2.new(1, -280, 0, -1)
    robuxContainer.BackgroundTransparency = 1
    robuxContainer.ZIndex = 5

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
    robuxText.ZIndex = 5

    local robuxIcon = Instance.new("ImageLabel", robuxContainer)
    robuxIcon.Size = UDim2.new(0, 19, 0, 19)
    robuxIcon.BackgroundTransparency = 1
    robuxIcon.Image = "rbxassetid://124421116974657"
    robuxIcon.ZIndex = 5

    updateRobux = function()
        robuxText.Text = formatNumber(playerRobux)
    end

    local imageLabel = Instance.new("ImageLabel", frame)
    imageLabel.Size = UDim2.new(0, 76, 0, 76)
    imageLabel.Position = UDim2.new(0, 24, 0, 55)
    imageLabel.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    imageLabel.BorderSizePixel = 0
    imageLabel.ZIndex = 5
    Instance.new("UICorner", imageLabel).CornerRadius = UDim.new(0, 8)

    local itemName = Instance.new("TextLabel", frame)
    itemName.Size = UDim2.new(0, 280, 0, 25)
    itemName.Position = UDim2.new(0, 115, 0, 60)
    itemName.BackgroundTransparency = 1
    itemName.TextColor3 = Color3.new(1, 1, 1)
    itemName.TextSize = 18
    itemName.TextXAlignment = Enum.TextXAlignment.Left
    itemName.Font = Enum.Font.SourceSansSemibold
    itemName.ZIndex = 5

    local priceContainer = Instance.new("Frame", frame)
    priceContainer.Size = UDim2.new(0, 240, 0, 22)
    priceContainer.Position = UDim2.new(0, 115, 0, 86)
    priceContainer.BackgroundTransparency = 1
    priceContainer.ZIndex = 5

    local priceIcon = Instance.new("ImageLabel", priceContainer)
    priceIcon.Size = UDim2.new(0, 16, 0, 16)
    priceIcon.Position = UDim2.new(0, 0, 0, 2)
    priceIcon.BackgroundTransparency = 1
    priceIcon.Image = "rbxassetid://124421116974657"
    priceIcon.ZIndex = 5

    local price = Instance.new("TextLabel", priceContainer)
    price.Size = UDim2.new(0, 140, 0, 22)
    price.Position = UDim2.new(0, 22, 0, 0)
    price.Text = "..."
    price.TextColor3 = Color3.fromRGB(230, 230, 230)
    price.BackgroundTransparency = 1
    price.TextSize = 16
    price.TextXAlignment = Enum.TextXAlignment.Left
    price.Font = Enum.Font.SourceSansSemibold
    price.ZIndex = 5

    local buy = Instance.new("TextButton", frame)
    buy.Size = UDim2.new(0, 432, 0, 44)
    buy.Position = UDim2.new(0, 24, 0, 145)
    buy.BackgroundColor3 = DARK_BLUE
    buy.Text = ""
    buy.ZIndex = 10
    buy.AutoButtonColor = false
    Instance.new("UICorner", buy).CornerRadius = UDim.new(0, 10)

    local wipe = Instance.new("Frame", buy)
    wipe.Size = UDim2.new(0, 0, 1, 0)
    wipe.BackgroundColor3 = LIGHT_BLUE
    wipe.ZIndex = 8
    wipe.BorderSizePixel = 0
    Instance.new("UICorner", wipe).CornerRadius = UDim.new(0, 10)

    local buyTextLabel = Instance.new("TextLabel", buy)
    buyTextLabel.Size = UDim2.new(1, 0, 1, 0)
    buyTextLabel.BackgroundTransparency = 1
    buyTextLabel.Text = "Beli"
    buyTextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    buyTextLabel.TextSize = 18
    buyTextLabel.Font = Enum.Font.SourceSansSemibold
    buyTextLabel.ZIndex = 9

    createRobloxPlusBar(frame)

    local isReady = false
    local itemPrice = 0
    local targetName = "Player"

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

    task.spawn(function()
        local tween = TweenService:Create(wipe, TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
            Size = UDim2.new(1, 0, 1, 0)
        })
        tween:Play()
        tween.Completed:Wait()
        task.wait(0.5)
        wipe:Destroy()
        isReady = true
    end)

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
-- ZORXHUB MAIN PANEL (DIPERBAIKI)
-- =======================================
local mainGui = Instance.new("ScreenGui", CoreGui)
mainGui.Name = "SimpleUI"
mainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
mainGui.DisplayOrder = 10

mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 260)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -90)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = mainGui
mainFrame.ZIndex = 5

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

local mainTitle = Instance.new("TextButton", mainFrame)
mainTitle.Size = UDim2.new(1, 0, 0, 40)
mainTitle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
mainTitle.Text = "ZorxHUB"
mainTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
mainTitle.Font = Enum.Font.GothamBold
mainTitle.TextSize = 18
mainTitle.AutoButtonColor = false
mainTitle.ZIndex = 10
Instance.new("UICorner", mainTitle).CornerRadius = UDim.new(0, 8)

-- Fungsi Geser Menu Utama
local dragging, dragInput, dragStart, startPos
mainTitle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then 
                dragging = false 
            end
        end)
    end
end)
mainTitle.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then 
        dragInput = input 
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- KOMPONEN MENU UTAMA (DIPERBAIKI AGAR BISA DIKLIK)
local textbox = Instance.new("TextBox", mainFrame)
textbox.Size = UDim2.new(0.9, 0, 0, 40)
textbox.Position = UDim2.new(0.05, 0, 0, 50)
textbox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
textbox.TextColor3 = Color3.fromRGB(255, 255, 255)
textbox.PlaceholderText = "Inject Robux"
textbox.Text = ""
textbox.ClearTextOnFocus = false
textbox.ZIndex = 10
textbox.Font = Enum.Font.SourceSans
textbox.TextSize = 16
Instance.new("UICorner", textbox).CornerRadius = UDim.new(0, 6)

local deleteBtn = Instance.new("TextButton", mainFrame)
deleteBtn.Size = UDim2.new(0.42, 0, 0, 35)
deleteBtn.Position = UDim2.new(0.05, 0, 0, 100)
deleteBtn.BackgroundColor3 = Color3.fromRGB(170, 50, 50)
deleteBtn.Text = "Hapus"
deleteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
deleteBtn.Font = Enum.Font.SourceSansBold
deleteBtn.TextSize = 15
deleteBtn.AutoButtonColor = false
deleteBtn.ZIndex = 10
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
enterBtn.Font = Enum.Font.SourceSansBold
enterBtn.TextSize = 15
enterBtn.AutoButtonColor = false
enterBtn.ZIndex = 10
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
lineBottom.ZIndex = 5

local avaBtn = Instance.new("TextButton", mainFrame)
avaBtn.Size = UDim2.new(0.9, 0, 0, 35)
avaBtn.Position = UDim2.new(0.05, 0, 0, 160)
avaBtn.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
avaBtn.Text = "Ava Visual"
avaBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
avaBtn.Font = Enum.Font.SourceSansBold
avaBtn.TextSize = 15
avaBtn.AutoButtonColor = false
avaBtn.ZIndex = 10
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
nameBox.ZIndex = 10
nameBox.Font = Enum.Font.SourceSans
nameBox.TextSize = 15
Instance.new("UICorner", nameBox).CornerRadius = UDim.new(0, 6)

-- =======================================
-- TOMBOL TOGGLE KIRI (BISA DIGESER)
-- =======================================
local toggleGui = Instance.new("ScreenGui", CoreGui)
toggleGui.Name = "ToggleUI"
toggleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
toggleGui.DisplayOrder = 20 -- Agar di atas menu lain

local toggleBtn = Instance.new("TextButton", toggleGui)
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Position = UDim2.new(0, 20, 0.5, -25)
toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 200)
toggleBtn.Text = "≡"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextScaled = true
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.AutoButtonColor = false
toggleBtn.ZIndex = 10
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 12)

-- Logika Geser Tombol Toggle
local toggleDrag, toggleInput, toggleStart, togglePos
toggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        toggleDrag = true
        toggleStart = input.Position
        togglePos = toggleBtn.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then toggleDrag = false end
        end)
    end
end)
toggleBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        toggleInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == toggleInput and toggleDrag then
        local delta = input.Position - toggleStart
        toggleBtn.Position = UDim2.new(togglePos.X.Scale, togglePos.X.Offset + delta.X, togglePos.Y.Scale, togglePos.Y.Offset + delta.Y)
    end
end)

-- Logika Tampil/Sembunyi Menu
local visible = true
toggleBtn.MouseButton1Click:Connect(function()
    visible = not visible
    mainFrame.Visible = visible
end)

-- Tombol Pintasan K
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.K then
        visible = not visible
        mainFrame.Visible = visible
    end
end)

-- =======================================
-- ANTI BENTROK & CLEANER UI (DIPERBAIKI)
-- =======================================
pcall(function()
    game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.PurchasePrompt, false)
end)

local function cleanGameUI()
    local allowed = {SimpleUI = true, FakeRobloxBuy = true, ToggleUI = true, RobloxPlusPopup = true}
    for _, obj in pairs(CoreGui:GetChildren()) do
        if obj:IsA("ScreenGui") and not allowed[obj.Name] then
            pcall(function() 
                if obj and obj.Parent then obj:Destroy() end 
            end)
        end
    end
end
-- Jalankan pembersihan lebih jarang agar tidak mengganggu klik
RunService.Heartbeat:Connect(cleanGameUI)
