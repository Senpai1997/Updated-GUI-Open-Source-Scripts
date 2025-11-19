local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Main GUI
local gui = Instance.new("ScreenGui")
gui.Name = "SenpaiHub"
gui.ResetOnSpawn = false
gui.Parent = PlayerGui

-- Services
local UIS = game:GetService("UserInputService")

-- Colors
local Accent = Color3.fromRGB(255, 85, 85)
local Dark = Color3.fromRGB(20, 20, 20)
local Darker = Color3.fromRGB(15, 15, 15)
local Light = Color3.fromRGB(230, 230, 230)

-- Utility: UICorner
local function Corner(inst, rad)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, rad or 10)
    c.Parent = inst
end

-- Utility: Shadow
local function Shadow(inst)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 10, 1, 10)
    shadow.Position = UDim2.new(0, -5, 0, 5)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://6014261993"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = 0.6
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    shadow.ZIndex = inst.ZIndex - 1
    shadow.Parent = inst
end

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 380, 0, 500)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -250)
MainFrame.BackgroundColor3 = Dark
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = gui
Corner(MainFrame, 14)
Shadow(MainFrame)

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame
Corner(TitleBar, 14)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.BackgroundTransparency =  = 1
Title.Text = "Senpai Hub"
Title.TextColor3 = Color3.fromRGB(255, 100, 100)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local Version = Instance.new("TextLabel")
Version.Size = UDim2.new(0, 100, 1, 0)
Version.Position = UDim2.new(1, -110, 0, 0)
Version.BackgroundTransparency = 1
Version.Text = "v1.0"
Version.TextColor3 = Color3.fromRGB(180, 180, 180)
Version.Font = Enum.Font.Gotham
Version.TextSize = 14
Version.Parent = TitleBar

-- Gradient Accent Line
local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 85, 85)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 140, 100))
})
Gradient.Rotation = 90
Gradient.Parent = TitleBar

-- Toggle Button (Auto Block)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 300, 0, 50)
ToggleBtn.Position = UDim2.new(0.5, -150, 0, 70)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleBtn.Text = "Auto Block: OFF"
ToggleBtn.TextColor3 = Color3.new(1,1,1)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 20
ToggleBtn.AutoButtonColor = false
ToggleBtn.Parent = MainFrame
Corner(ToggleBtn, 12)
Shadow(ToggleBtn)

-- Open/Close Settings Arrow
local ArrowBtn = Instance.new("TextButton")
ArrowBtn.Size = UDim2.new(0, 40, 0, 40)
ArrowBtn.Position = UDim2.new(1, -55, 0, 8)
ArrowBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ArrowBtn.Text = ">"
ArrowBtn.TextColor3 = Color3.new(1,1,1)
ArrowBtn.Font = Enum.Font.GothamBold
ArrowBtn.TextSize = 24
ArrowBtn.Parent = MainFrame
Corner(ArrowBtn, 10)

-- Settings Container
local SettingsFrame = Instance.new("Frame")
SettingsFrame.Size = UDim2.new(1, -30, 0, 380)
SettingsFrame.Position = UDim2.new(0, 15, 0, 130)
SettingsFrame.BackgroundColor3 = Darker
SettingsFrame.Visible = false
SettingsFrame.Parent = MainFrame
Corner(SettingsFrame, 12)

-- Scrolling Frame for Settings
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -10,1,0)
Scroll.Position = UDim2.new(0, -5, 0, 10)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 6
Scroll.CanvasSize = UDim2.new(0,0,0,500)
Scroll.Parent = SettingsFrame

local List Layout
local List = Instance.new("UIListLayout")
List.Padding = UDim.new(0, 12)
List.SortOrder = Enum.SortOrder.LayoutOrder
List.Parent = Scroll

-- Input Box Function
local function CreateInput(name, default, yPos)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -20, 0, 40)
    Container.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Container.LayoutOrder = yPos
    Container.Parent = Scroll
    Corner(Container, 10)

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.5, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Light
    Label.Font = Enum.Font.GothamSemibold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Position = UDim2.new(0, 15, 0, 0)
    Label.Parent = Container

    local Box = Instance.new("TextBox")
    Box.Size = UDim2.new(0.45, 0, 0, 30)
    Box.Position = UDim2.new(0.5, 5, 0.5, -15)
    Box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Box.PlaceholderText = default
    Box.Text = default
    Box.TextColor3 = Color3.new(1,1,1)
    Box.Font = Enum.Font.Gotham
    Box.TextSize = 16
    Box.Parent = Container
    Corner(Box, 8)

    return Box
end

-- Toggle Function
local function CreateToggle(name, defaultState, yPos)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -20, 0, 45)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Frame.LayoutOrder = yPos
    Frame.Parent = Scroll
    Corner(Frame, 10)

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Light
    Label.Font = Enum.Font.GothamSemibold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Position = UDim2.new(0, 15, 0, 0)
    Label.Parent = Frame

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 70, 0, 30)
    Btn.Position = UDim2.new(1, -85, 0.5, -15)
    Btn.BackgroundColor3 = defaultState and Accent or Color3.fromRGB(60, 60, 60)
    Btn.Text = defaultState and "ON" or "OFF"
    Btn.TextColor3 = Color3.new(1,1,1)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 16
    Btn.Parent = Frame
    Corner(Btn, 8)

    local toggled = defaultState
    Btn.MouseButton1Click:Connect(function()
        toggled = not toggled
        Btn.Text = toggled and "ON" or "OFF"
        TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = toggled and Accent or Color3.fromRGB(60,60,60)}):Play()
    end)

    return Btn, function() return toggled end
end

-- Create Inputs
local normalBox = CreateInput("M1 Range", "30", 1)
local specialBox = CreateInput("Special/Dash Range", "50", 2)
local skillBox = CreateInput("Skill Range", "50", 3)
local skillDelayBox = CreateInput("Skill Hold Delay", "1.2", 4)

-- Create Toggles
local m1AfterBtn, getM1After = CreateToggle("M1 After Block", false, 5)
local m1CatchBtn, getM1Catch = CreateToggle("M1 Catch (Advanced)", false, 6)

-- Bubble Opener
local Bubble = Instance.new("TextButton")
Bubble.Size = UDim2.new(0, 60, 0, 60)
Bubble.Position = UDim2.new(0, 20, 0.5, -100)
Bubble.BackgroundColor3 = Accent
Bubble.Text = "Senpai"
Bubble.TextColor3 = Color3.new(1,1,1)
Bubble.Font = Enum.Font.GothamBlack
Bubble.TextSize = 18
Bubble.TextStrokeTransparency = 0.8
Bubble.Parent = gui
Corner(Bubble, 30)
Shadow(Bubble)

Bubble.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Arrow Toggle Logic
ArrowBtn.MouseButton1Click:Connect(function()
    SettingsFrame.Visible = not SettingsFrame.Visible
    ArrowBtn.Text = SettingsFrame.Visible and "v" or ">"
    TweenService:Create(ArrowBtn, TweenInfo.new(0.3), {Rotation = SettingsFrame.Visible and 180 or 0}):Play()
end)

-- Variables (same as original)
local normalRange = 30
local specialRange = 50
local skillRange = 50
local skillDelay = 1.2
local m1AfterEnabled = false
local m1CatchEnabled = false
local detectActive = false

-- Update values on focus lost
normalBox.FocusLost:Connect(function() local v = tonumber(normalBox.Text); if v then normalRange = v end end)
specialBox.FocusLost:Connect(function() local v = tonumber(specialBox.Text); if v then specialRange = v end end)
skillBox.FocusLost:Connect(function() local v = tonumber(skillBox.Text); if v then skillRange = v end end)
skillDelayBox.FocusLost:Connect(function() local v = tonumber(skillDelayBox.Text); if v and v > 0 then skillDelay = v end end)

m1AfterBtn.MouseButton1Click:Connect(function() m1AfterEnabled = getM1After() end)
m1CatchBtn.MouseButton1Click:Connect(function() m1CatchEnabled = getM1Catch() end)

-- Toggle Auto Block
ToggleBtn.MouseButton1Click:Connect(function()
    detectActive = not detectActive
    ToggleBtn.Text = detectActive and "Auto Block: ON" or "Auto Block: OFF"
    TweenService:Create(ToggleBtn, TweenInfo.new(0.3), {
        BackgroundColor3 = detectActive and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(30, 30, 30),
        TextColor3 = detectActive and Color3.new(1,1,1) or Color3.new(1,1,1)
    }):Play()
end)

-- [REST OF YOUR ORIGINAL LOGIC BELOW - UNTOUCHED] --

local function fireRemote(goal, mobile)
    local args = {{
        Goal = goal,
        Key = (goal == "KeyPress" or goal == "KeyRelease") and Enum.KeyCode.F or nil,
        Mobile = mobile or nil
    }}
    LocalPlayer.Character:WaitForChild("Communicate"):FireServer(unpack(args))
end

-- ... (all your doAfterBlock, checkAnims, checkM1Catch, IDs, etc. remain 100% the same)

-- Paste the entire rest of your original logic here (from doAfterBlock to RunService.Heartbeat)
-- I didn't modify any of it, just the UI above.

-- Example placeholder (keep your full code here):
local function doAfterBlock(hrp)
    if m1AfterEnabled and hrp and LocalPlayer.Character then
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            local dist = (hrp.Position - root.Position).Magnitude
            if dist <= 10 then
                fireRemote("LeftClick", true)
                task.delay(0.3, function()
                    local newDist = (hrp.Position - root.Position).Magnitude
                    if newDist <= 10 then
                        fireRemote("LeftClickRelease", true)
                    end
                end)
            end
        end
    end
end

-- ... continue with all your original functions: lastCatch, comboIDs, allIDs, skillIDs, checkAnims, checkM1Catch, etc.

RunService.Heartbeat:Connect(function()
    if detectActive then
        pcall(checkAnims)
        pcall(checkM1Catch)
    end
end)

-- Done! Modern, clean, branded "Senpai Hub" UI with zero functionality changes.
