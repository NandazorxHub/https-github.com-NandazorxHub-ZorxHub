-- SETTINGS
local customName = "Olix"
local tagText = "Penggemar"
local heightOffset = 2.8

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function createNameTag(character)
    local head = character:WaitForChild("Head")

    if head:FindFirstChild("CustomNameTag") then
        head.CustomNameTag:Destroy()
    end

    -- BILLBOARD
    local bill = Instance.new("BillboardGui")
    bill.Name = "CustomNameTag"
    bill.Adornee = head
    bill.Size = UDim2.new(0, 240, 0, 80)
    bill.StudsOffset = Vector3.new(0, heightOffset, 0)
    bill.AlwaysOnTop = true
    bill.ClipsDescendants = false
    bill.Parent = head

    -- CONTAINER
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.Parent = bill

    -- FOTO 1
    local tag = Instance.new("ImageLabel")
    tag.AnchorPoint = Vector2.new(0.5, 0)
    tag.Position = UDim2.new(0.5, -15, 0, -25)
    tag.Size = UDim2.new(0, 190, 0, 80)
    tag.BackgroundTransparency = 1
    tag.Image = "rbxassetid://138326242471860"
    tag.ScaleType = Enum.ScaleType.Fit
    tag.Parent = container

    -- FOTO 2
    local tag2 = Instance.new("ImageLabel")
    tag2.AnchorPoint = Vector2.new(0.5, 0)
    tag2.Position = UDim2.new(0.5, 60, 0, -25)
    tag2.Size = UDim2.new(0, 65, 0, 80)
    tag2.BackgroundTransparency = 1
    tag2.Image = "rbxassetid://128130814365379"
    tag2.ScaleType = Enum.ScaleType.Fit
    tag2.Parent = container

    -- NAMA + IKON FIX
    local fixedContainer = Instance.new("Frame")
    fixedContainer.Size = UDim2.new(0, 100, 0, 25)
    fixedContainer.Position = UDim2.new(0.5, -50, 0, 52)
    fixedContainer.BackgroundTransparency = 1
    fixedContainer.Parent = container

    -- IKON (tetap menempel ke huruf O)
    local leftIcon = Instance.new("ImageLabel")
    leftIcon.Size = UDim2.new(0, 35, 0, 35)
    leftIcon.Position = UDim2.new(0, 12, 0, -5)
    leftIcon.BackgroundTransparency = 1
    leftIcon.Image = "rbxassetid://96208190156330"
    leftIcon.ScaleType = Enum.ScaleType.Fit
    leftIcon.Parent = fixedContainer

    -- TEXT NAMA (geser sedikit lagi ke kanan)
    local name = Instance.new("TextLabel")
    name.Size = UDim2.new(1, -35, 1, 0)
    name.Position = UDim2.new(0, 24, 0, 0) -- 🔥 geser sedikit lagi ke kanan
    name.BackgroundTransparency = 1
    name.Text = customName
    name.TextColor3 = Color3.fromRGB(255, 255, 255)
    name.Font = Enum.Font.Gotham
    name.TextSize = 15
    name.TextScaled = false
    name.TextStrokeTransparency = 0.7
    name.Parent = fixedContainer
end

if player.Character then
    createNameTag(player.Character)
end

player.CharacterAdded:Connect(function(char)
    createNameTag(char)
end)