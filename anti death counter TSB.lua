--============================================================
-- NANDA × ZORX - AUTO KILL DEATH
-- TSB - AUTO TRIGGER DCRecent
--============================================================

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")

--============================================================
-- CONFIGURATION
--============================================================

local teleportPosition = Vector3.new(
    240.31468200683594,
    -491.9150390625,
    -183.96755981445312
)

local platformSize = Vector3.new(10, 1, 10)

local loopDuration = 5
local teleportInterval = 0.05

--============================================================
-- VARIABLES
--============================================================

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local camera = Workspace.CurrentCamera

local savedPosition = nil
local looping = false

local watchedCharacters = {}

--============================================================
-- CHARACTER UPDATE
--============================================================

local function updateCharacter(char)
    if char then
        character = char
    end
end

player.CharacterAdded:Connect(function(char)
    character = char

    task.wait(0.5)

    pcall(function()
        camera = Workspace.CurrentCamera
    end)
end)

--============================================================
-- CREATE PLATFORM
--============================================================

local function createPlatform(position)

    local platform = Instance.new("Part")

    platform.Name = "TemporaryPlatform"

    platform.Size = platformSize

    platform.Position = position

    platform.Anchored = true

    platform.CanCollide = true

    platform.CanTouch = false

    platform.CanQuery = false

    platform.Color = Color3.new(1, 0, 0)

    platform.Transparency = 0

    platform.Parent = Workspace

    return platform
end

--============================================================
-- RESET CAMERA
--============================================================

local function resetCamera()

    local currentCharacter = player.Character

    if not currentCharacter then
        return
    end

    local humanoid =
        currentCharacter:FindFirstChildOfClass("Humanoid")

    if humanoid then

        pcall(function()

            camera.CameraSubject = humanoid

            camera.CameraType = Enum.CameraType.Custom

        end)

    end
end

--============================================================
-- KILL DEATH TELEPORT
--============================================================

local function loopTeleport()

    if looping then
        return
    end

    local currentCharacter = player.Character

    if not currentCharacter then
        return
    end

    local rootPart =
        currentCharacter:FindFirstChild("HumanoidRootPart")

    if not rootPart then
        return
    end

    -- Simpan posisi sebelum teleport
    savedPosition = rootPart.CFrame

    looping = true

    -- Buat platform
    local platform = createPlatform(
        teleportPosition + Vector3.new(0, -3, 0)
    )

    local startTime = tick()

    --========================================================
    -- LOOP TELEPORT
    --========================================================

    while
        tick() - startTime < loopDuration
        and looping
    do

        if not rootPart.Parent then
            break
        end

        rootPart.CFrame = CFrame.new(teleportPosition)

        task.wait(teleportInterval)

    end

    --========================================================
    -- CLEANUP
    --========================================================

    if platform and platform.Parent then
        platform:Destroy()
    end

    -- Kembali ke posisi awal
    if savedPosition and rootPart.Parent then

        rootPart.CFrame = savedPosition

    end

    savedPosition = nil

    looping = false

    resetCamera()
end

--============================================================
-- DETECT DCRecent
--============================================================

local function watchCharacter(targetCharacter)

    if not targetCharacter then
        return
    end

    -- Jangan scan karakter sendiri
    if targetCharacter == player.Character then
        return
    end

    if watchedCharacters[targetCharacter] then
        return
    end

    watchedCharacters[targetCharacter] = true

    --========================================================
    -- CEK OBJECT YANG SUDAH ADA
    --========================================================

    for _, obj in ipairs(targetCharacter:GetChildren()) do

        if obj.Name == "DCRecent" then

            warn(
                "[AUTO KILL DEATH]",
                targetCharacter.Name,
                "DCRecent ALREADY ACTIVE"
            )

            task.spawn(loopTeleport)

        end

    end

    --========================================================
    -- DETECT OBJECT BARU
    --========================================================

    targetCharacter.ChildAdded:Connect(function(obj)

        if obj.Name == "DCRecent" then

            warn(
                "[AUTO KILL DEATH]",
                targetCharacter.Name,
                "DCRecent DETECTED"
            )

            -- Jalankan otomatis
            task.spawn(loopTeleport)

        end

    end)

    --========================================================
    -- CHARACTER RESET
    --========================================================

    targetCharacter.AncestryChanged:Connect(function(_, parent)

        if not parent then
            watchedCharacters[targetCharacter] = nil
        end

    end)

end

--============================================================
-- WORKSPACE.LIVE
--============================================================

local Live = Workspace:FindFirstChild("Live")

if not Live then

    Live = Workspace:WaitForChild("Live", 10)

end

if Live then

    -- Character yang sudah ada
    for _, targetCharacter in ipairs(Live:GetChildren()) do

        if targetCharacter:IsA("Model") then

            watchCharacter(targetCharacter)

        end

    end

    -- Character baru
    Live.ChildAdded:Connect(function(targetCharacter)

        if targetCharacter:IsA("Model") then

            task.wait(0.1)

            watchCharacter(targetCharacter)

        end

    end)

end

--============================================================
-- NOTIFICATION
--============================================================

pcall(function()

    StarterGui:SetCore(
        "SendNotification",
        {
            Title = "Auto Kill Death",
            Text = "DCRecent detector aktif",
            Duration = 5
        }
    )

end)

--============================================================
-- CONSOLE
--============================================================

warn("============================================")
warn(" NANDA × ZORX AUTO KILL DEATH")
warn("============================================")
warn("Detector : DCRecent")
warn("Mode     : AUTO")
warn("Teleport : ENABLED")
warn("Duration : " .. tostring(loopDuration) .. " seconds")
warn("Interval : " .. tostring(teleportInterval))
warn("============================================")