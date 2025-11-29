-- Services
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Script Logic Dependencies
-- We load these early to make sure they exist
local TEvent
local success, err = pcall(function()
    TEvent = require(ReplicatedStorage.Shared.Core.TEvent)
end)

if not success then
    warn("Senpai Hub: Could not find TEvent module. This script might be for a different game.")
end

local plr = Players.LocalPlayer
local chr = plr.Character or plr.CharacterAdded:Wait()
local hrp = chr:WaitForChild("HumanoidRootPart")

-- 1. CLEANUP PREVIOUS UI
if CoreGui:FindFirstChild("SenpaiHubInteract") then
    CoreGui.SenpaiHubInteract:Destroy()
end

-- 2. CREATE UI ELEMENTS
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SenpaiHubInteract"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 250, 0, 130)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, 80) -- Offset slightly down so it doesn't overlap the other one
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Header
local Header = Instance.new("TextLabel")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 40)
Header.Position = UDim2.new(0, 0, 0, 0)
Header.BackgroundTransparency = 1
Header.Text = "Senpai Hub"
Header.TextColor3 = Color3.fromRGB(255, 255, 255)
Header.TextSize = 20
Header.Font = Enum.Font.GothamBold
Header.Parent = MainFrame

-- Toggle Button
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "InteractToggle"
ToggleButton.Size = UDim2.new(0, 200, 0, 50)
ToggleButton.Position = UDim2.new(0.5, -100, 0.5, 10)
ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- Red initially
ToggleButton.Text = "Auto Interact: OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 18
ToggleButton.Font = Enum.Font.Gotham
ToggleButton.Parent = MainFrame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 8)
BtnCorner.Parent = ToggleButton

-- 3. DRAGGABLE LOGIC
local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then update(input) end
end)

-- 4. TOGGLE & SCRIPT LOGIC
local isRunning = false

ToggleButton.MouseButton1Click:Connect(function()
    isRunning = not isRunning
    
    if isRunning then
        ToggleButton.Text = "Auto Interact: ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 200, 100) -- Green
    else
        ToggleButton.Text = "Auto Interact: OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- Red
    end
end)

-- Your logic wrapped in the Heartbeat loop
RunService.Heartbeat:Connect(function()
    if not isRunning then return end -- Don't run if toggle is OFF
    if not TEvent then return end -- Safety check
    
    -- Update character reference just in case of respawn
    if not chr or not chr.Parent then
        chr = plr.Character or plr.CharacterAdded:Wait()
        hrp = chr:WaitForChild("HumanoidRootPart")
    end
    
    -- Your Loop
    for _, obj in workspace:GetDescendants() do
        if obj:HasTag("Interactable") and obj:GetAttribute("en") then
            local dst = obj:GetAttribute("sz") or 20
            
            -- Determine the part to check distance from
            local prt = nil
            if obj:IsA("Model") then
                prt = obj.PrimaryPart
            elseif obj:IsA("BasePart") then
                prt = obj
            end
            
            if prt and (hrp.Position - prt.Position).Magnitude <= dst then
                TEvent.FireRemote("Interactable", obj)
            end
        end
    end
end)
