-- SETTINGS
local customName = "Olix"
local heightOffset = 3

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function createNameTag(character)
    local head = character:WaitForChild("Head")

    if head:FindFirstChild("CustomNameTag") then
        head.CustomNameTag:Destroy()
    end

    local bill = Instance.new("BillboardGui")
    bill.Name = "CustomNameTag"
    bill.Adornee = head
    bill.Size = UDim2.new(0, 140, 0, 30) -- sedikit dibesarin
    bill.StudsOffset = Vector3.new(0, heightOffset, 0)
    bill.AlwaysOnTop = true
    bill.Parent = head

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = customName
    text.TextColor3 = Color3.fromRGB(255, 255, 255)

    text.TextScaled = false -- tetap biar gak ikut zoom
    text.TextSize = 18 -- dibesarin dikit (dari 14 → 18)

    text.Font = Enum.Font.SourceSans
    text.TextStrokeTransparency = 0.6
    text.Parent = bill
end

if player.Character then
    createNameTag(player.Character)
end

player.CharacterAdded:Connect(function(char)
    createNameTag(char)
end)