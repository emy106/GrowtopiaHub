--[[
    GROWTOPIA PREMIUM HUB V1
    Delta Executor Android
    UI ONLY - No game manipulation
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer

local ENV = (getgenv and getgenv()) or _G
ENV.GrowtopiaSettings = ENV.GrowtopiaSettings or {}

local Settings = ENV.GrowtopiaSettings

local KEY = "GROW2026"

local function save(name, value)
    Settings[name] = value
end

local function get(name, default)
    if Settings[name] == nil then
        Settings[name] = default
    end
    return Settings[name]
end

-- GUI ROOT
local GUI = Instance.new("ScreenGui")
GUI.Name = "GrowtopiaPremiumHub"
GUI.ResetOnSpawn = false

pcall(function()
    GUI.Parent = game:GetService("CoreGui")
end)

if not GUI.Parent then
    GUI.Parent = Player:WaitForChild("PlayerGui")
end

local function corner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = obj
end

local function stroke(obj)
    local s = Instance.new("UIStroke")
    s.Color = Color3.fromRGB(75, 105, 180)
    s.Thickness = 1
    s.Transparency = 0.3
    s.Parent = obj
end

local function tween(obj, properties)
    TweenService:Create(
        obj,
        TweenInfo.new(0.25, Enum.EasingStyle.Quart),
        properties
    ):Play()
end

-- REOPEN BUTTON
local Reopen = Instance.new("TextButton")
Reopen.Size = UDim2.fromOffset(55, 55)
Reopen.Position = UDim2.new(0, 15, 0.5, 0)
Reopen.Text = "G"
Reopen.TextSize = 25
Reopen.TextColor3 = Color3.new(1,1,1)
Reopen.BackgroundColor3 = Color3.fromRGB(30, 90, 190)
Reopen.Visible = false
Reopen.Parent = GUI
corner(Reopen, 50)

-- MAIN WINDOW
local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(370, 430)
Main.Position = UDim2.new(0.5, -185, 0.5, -215)
Main.BackgroundColor3 = Color3.fromRGB(15, 18, 29)
Main.Parent = GUI
corner(Main, 12)
stroke(Main)

-- HEADER
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 65)
Header.BackgroundColor3 = Color3.fromRGB(24, 31, 51)
Header.Parent = Main
corner(Header, 12)

local Logo = Instance.new("TextLabel")
Logo.Size = UDim2.new(1, -100, 0, 30)
Logo.Position = UDim2.fromOffset(15, 5)
Logo.BackgroundTransparency = 1
Logo.Text = "GROWTOPIA HUB"
Logo.TextColor3 = Color3.fromRGB(90, 170, 255)
Logo.TextSize = 20
Logo.Font = Enum.Font.GothamBold
Logo.TextXAlignment = Enum.TextXAlignment.Left
Logo.Parent = Header

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, -100, 0, 20)
Subtitle.Position = UDim2.fromOffset(16, 35)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "PREMIUM MOBILE EDITION"
Subtitle.TextColor3 = Color3.fromRGB(150, 155, 175)
Subtitle.TextSize = 10
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = Header

-- HEADER BUTTONS
local function headerButton(text, position)
    local b = Instance.new("TextButton")
    b.Size = UDim2.fromOffset(30, 30)
    b.Position = position
    b.Text = text
    b.TextSize = 17
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = Color3.fromRGB(45, 55, 80)
    b.Parent = Header
    corner(b, 7)
    return b
end

local Minimize = headerButton("-", UDim2.new(1, -75, 0, 15))
local Close = headerButton("X", UDim2.new(1, -38, 0, 15))

-- DRAGGABLE UI
local dragging = false
local dragStart
local startPos

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then

        local delta = input.Position - dragStart

        Main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- CONTENT
local Body = Instance.new("Frame")
Body.Size = UDim2.new(1, -20, 1, -145)
Body.Position = UDim2.fromOffset(10, 125)
Body.BackgroundTransparency = 1
Body.Parent = Main

local Tabs = Instance.new("Frame")
Tabs.Size = UDim2.new(1, -20, 0, 45)
Tabs.Position = UDim2.fromOffset(10, 70)
Tabs.BackgroundTransparency = 1
Tabs.Parent = Main

local TabNames = {"Home", "Farm", "ESP", "Settings"}

local Pages = {}
local CurrentPage

for i, name in ipairs(TabNames) do
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.24, 0, 1, 0)
    button.Position = UDim2.new((i-1)*0.25, 0, 0, 0)
    button.Text = name
    button.TextSize = 12
    button.Font = Enum.Font.GothamBold
    button.TextColor3 = Color3.new(1,1,1)
    button.BackgroundColor3 = Color3.fromRGB(32, 43, 68)
    button.Parent = Tabs
    corner(button, 7)

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.Visible = false
    page.Parent = Body

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.Parent = page

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(
            0, 0, 0,
            layout.AbsoluteContentSize.Y + 10
        )
    end)

    Pages[name] = page

    button.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do
            p.Visible = false
        end

        page.Visible = true
        CurrentPage = name

        tween(button, {
            BackgroundColor3 = Color3.fromRGB(35, 105, 205)
        })

        for _, child in pairs(Tabs:GetChildren()) do
            if child:IsA("TextButton") and child ~= button then
                child.BackgroundColor3 = Color3.fromRGB(32, 43, 68)
            end
        end
    end)
end

local function label(page, text)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -5, 0, 35)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = Color3.fromRGB(100, 175, 255)
    l.TextSize = 14
    l.Font = Enum.Font.GothamBold
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = page
end

local function toggle(page, name, default)
    local state = get(name, default)

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -5, 0, 45)
    button.BackgroundColor3 = Color3.fromRGB(28, 35, 53)
    button.Text = ""
    button.Parent = page
    corner(button, 8)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0.7, 0, 1, 0)
    title.Position = UDim2.fromOffset(12, 0)
    title.BackgroundTransparency = 1
    title.Text = name
    title.TextColor3 = Color3.new(1,1,1)
    title.TextSize = 12
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = button

    local status = Instance.new("TextLabel")
    status.Size = UDim2.fromOffset(65, 25)
    status.Position = UDim2.new(1, -75, 0.5, -12)
    status.TextSize = 11
    status.Font = Enum.Font.GothamBold
    status.TextColor3 = Color3.new(1,1,1)
    status.Parent = button
    corner(status, 6)

    local function update()
        status.Text = state and "ON" or "OFF"
        status.BackgroundColor3 = state
            and Color3.fromRGB(25, 160, 100)
            or Color3.fromRGB(90, 90, 100)

        save(name, state)
    end

    update()

    button.MouseButton1Click:Connect(function()
        state = not state
        update()
    end)
end

-- HOME TAB
label(Pages.Home, "WELCOME TO PREMIUM HUB")

label(Pages.Home, "Dashboard")

local info = Instance.new("TextLabel")
info.Size = UDim2.new(1, -5, 0, 75)
info.BackgroundColor3 = Color3.fromRGB(28, 35, 53)
info.Text = "Growtopia Premium Hub\nVersion: 1.0\nPlatform: Mobile"
info.TextColor3 = Color3.new(1,1,1)
info.TextSize = 13
info.Font = Enum.Font.Gotham
info.Parent = Pages.Home
corner(info, 8)

-- FARM TAB
label(Pages.Farm, "AUTO FARM CONTROLS")

toggle(Pages.Farm, "Auto Farm", false)
toggle(Pages.Farm, "Auto Break", false)
toggle(Pages.Farm, "Auto Plant", false)
toggle(Pages.Farm, "Auto Collect", false)

-- SPEED
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, -5, 0, 35)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.new(1,1,1)
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextSize = 13
speedLabel.Parent = Pages.Farm

local speed = get("Farming Speed", 5)

local speedButton = Instance.new("TextButton")
speedButton.Size = UDim2.new(1, -5, 0, 40)
speedButton.BackgroundColor3 = Color3.fromRGB(35, 75, 130)
speedButton.TextColor3 = Color3.new(1,1,1)
speedButton.Font = Enum.Font.GothamBold
speedButton.Parent = Pages.Farm
corner(speedButton, 8)

local function updateSpeed()
    speedLabel.Text = "Farming Speed: " .. speed
    speedButton.Text = "CHANGE SPEED  +"
    save("Farming Speed", speed)
end

speedButton.MouseButton1Click:Connect(function()
    speed = speed + 1

    if speed > 10 then
        speed = 1
    end

    updateSpeed()
end)

updateSpeed()

-- ESP TAB
label(Pages.ESP, "ESP SETTINGS")

toggle(Pages.ESP, "Item ESP", false)
toggle(Pages.ESP, "Tree ESP", false)
toggle(Pages.ESP, "Player ESP", false)
toggle(Pages.ESP, "Distance ESP", false)

-- SETTINGS TAB
label(Pages.Settings, "GENERAL SETTINGS")

toggle(Pages.Settings, "Show Status", true)

local reset = Instance.new("TextButton")
reset.Size = UDim2.new(1, -5, 0, 40)
reset.Text = "RESET UI SETTINGS"
reset.TextColor3 = Color3.new(1,1,1)
reset.TextSize = 12
reset.Font = Enum.Font.GothamBold
reset.BackgroundColor3 = Color3.fromRGB(150, 55, 65)
reset.Parent = Pages.Settings
corner(reset, 8)

reset.MouseButton1Click:Connect(function()
    for k in pairs(Settings) do
        Settings[k] = nil
    end
    GUI:Destroy()
end)

-- MINIMIZE / CLOSE
local minimized = false

Minimize.MouseButton1Click:Connect(function()
    minimized = not minimized

    Body.Visible = not minimized
    Tabs.Visible = not minimized

    Main.Size = minimized
        and UDim2.fromOffset(370, 65)
        or UDim2.fromOffset(370, 430)
end)

Close.MouseButton1Click:Connect(function()
    Main.Visible = false
    Reopen.Visible = true
end)

Reopen.MouseButton1Click:Connect(function()
    Main.Visible = true
    Reopen.Visible = false
end)

-- KEY SYSTEM
Main.Visible = false

local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.fromOffset(320, 190)
KeyFrame.Position = UDim2.new(0.5, -160, 0.5, -95)
KeyFrame.BackgroundColor3 = Color3.fromRGB(18, 23, 38)
KeyFrame.Parent = GUI
corner(KeyFrame, 12)
stroke(KeyFrame)

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1, 0, 0, 45)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = "GROWTOPIA KEY SYSTEM"
KeyTitle.TextColor3 = Color3.fromRGB(90, 170, 255)
KeyTitle.TextSize = 17
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.Parent = KeyFrame

local Input = Instance.new("TextBox")
Input.Size = UDim2.new(1, -30, 0, 40)
Input.Position = UDim2.fromOffset(15, 60)
Input.PlaceholderText = "Enter your key..."
Input.Text = ""
Input.TextColor3 = Color3.new(1,1,1)
Input.PlaceholderColor3 = Color3.fromRGB(140,140,140)
Input.BackgroundColor3 = Color3.fromRGB(35, 42, 62)
Input.TextSize = 13
Input.Font = Enum.Font.Gotham
Input.Parent = KeyFrame
corner(Input, 7)

local Verify = Instance.new("TextButton")
Verify.Size = UDim2.new(1, -30, 0, 38)
Verify.Position = UDim2.fromOffset(15, 115)
Verify.Text = "VERIFY KEY"
Verify.TextColor3 = Color3.new(1,1,1)
Verify.BackgroundColor3 = Color3.fromRGB(35, 105, 205)
Verify.Font = Enum.Font.GothamBold
Verify.TextSize = 13
Verify.Parent = KeyFrame
corner(Verify, 7)

local Message = Instance.new("TextLabel")
Message.Size = UDim2.new(1, 0, 0, 25)
Message.Position = UDim2.fromOffset(0, 158)
Message.BackgroundTransparency = 1
Message.Text = "Enter key to continue"
Message.TextColor3 = Color3.fromRGB(160,160,175)
Message.TextSize = 11
Message.Parent = KeyFrame

Verify.MouseButton1Click:Connect(function()
    if Input.Text == KEY then
        Message.Text = "KEY VERIFIED!"
        Message.TextColor3 = Color3.fromRGB(50,220,130)

        task.wait(0.5)

        KeyFrame.Visible = false
        Main.Visible = true

        Pages.Home.Visible = true
    else
        Message.Text = "INVALID KEY!"
        Message.TextColor3 = Color3.fromRGB(255,70,70)
    end
end)

print("Growtopia Premium Hub loaded!")
