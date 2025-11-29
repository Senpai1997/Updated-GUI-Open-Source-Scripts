-- Services
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- 1. CLEANUP PREVIOUS UI
if CoreGui:FindFirstChild("SenpaiHubUI") then
    CoreGui.SenpaiHubUI:Destroy()
end

-- 2. CREATE UI ELEMENTS
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SenpaiHubUI"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 250, 0, 130)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -65) -- Centered
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

-- Rounded Corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Header: "Senpai Hub"
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

-- The Toggle Button
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "SprintToggle"
ToggleButton.Size = UDim2.new(0, 200, 0, 50)
ToggleButton.Position = UDim2.new(0.5, -100, 0.5, 10)
ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- Red initially
ToggleButton.Text = "Sprint: OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 18
ToggleButton.Font = Enum.Font.Gotham
ToggleButton.Parent = MainFrame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 8)
BtnCorner.Parent = ToggleButton

-- 3. MAKE UI DRAGGABLE
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
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- 4. SCRIPT LOGIC
local isOn = false
local savedConnections = {} -- We store the connections here so we can re-enable them

ToggleButton.MouseButton1Click:Connect(function()
    isOn = not isOn -- Flip state
    
    if isOn then
        -- TURN ON
        ToggleButton.Text = "Sprint: ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 200, 100) -- Green
        
        -- Disable Stamina
        for _, cnx in pairs(getconnections(RunService.PreRender)) do
            -- Safety pcall to avoid errors if debug info is locked
            local success, src = pcall(function() return debug.info(cnx.Function, "s") end)
            
            if success and src and src:find("Stamina") then
                cnx:Disable()
                table.insert(savedConnections, cnx) -- Save connection to list
            end
        end
        
    else
        -- TURN OFF
        ToggleButton.Text = "Sprint: OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- Red
        
        -- Re-enable Stamina
        for _, cnx in pairs(savedConnections) do
            cnx:Enable()
        end
        savedConnections = {} -- Clear the list
    end
end)
