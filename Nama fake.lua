-- SETTINGS
local customName = "Olix"
local tagText = "Penggemar"
local heightOffset = 3.15

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
    bill.Size = UDim2.new(0, 150, 0, 55)
    bill.StudsOffset = Vector3.new(0, heightOffset, 0)
    bill.AlwaysOnTop = true
    bill.Parent = head

    -- CONTAINER
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 26)
    container.Position = UDim2.new(0, 0, 0, 2)
    container.BackgroundTransparency = 1
    container.Parent = bill

    -- 🔥 IMAGE (NAIK DIKIT LAGI)
    local tag = Instance.new("ImageLabel")
    tag.AnchorPoint = Vector2.new(0.5, 0)
    tag.Position = UDim2.new(0.5, 0, 0, -35) -- 🔥 naik lagi dikit
    tag.Size = UDim2.new(0, 420, 0, 80)
    tag.BackgroundTransparency = 1
    tag.Image = "rbxassetid://138326242471860"
    tag.ScaleType = Enum.ScaleType.Fit
    tag.Parent = container

    -- 🔥 NAMA (DIBESARIN DIKIT)
    local name = Instance.new("TextLabel")
    name.Size = UDim2.new(1, 0, 0, 20)
    name.Position = UDim2.new(0, 0, 0, 22)
    name.BackgroundTransparency = 1

    name.Text = customName
    name.TextColor3 = Color3.fromRGB(255, 255, 255)

    name.Font = Enum.Font.Gotham
    name.TextSize = 15 -- 🔥 dari 13 jadi 15 (dikit aja)
    name.TextScaled = false
    name.TextStrokeTransparency = 0.7

    name.Parent = bill
end

if player.Character then
    createNameTag(player.Character)
end

player.CharacterAdded:Connect(function(char)
    createNameTag(char)
end)