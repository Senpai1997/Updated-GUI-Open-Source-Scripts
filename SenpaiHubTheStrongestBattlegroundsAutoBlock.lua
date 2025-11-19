local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local gui = Instance.new("ScreenGui", PlayerGui)
gui.Name = "SenpaiHubGui"
gui.ResetOnSpawn = false

--================================================================================--
--// UI Library
--================================================================================--

local SenpaiHub = {}

function SenpaiHub:CreateWindow()
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 350, 0, 250)
    mainFrame.Position = UDim2.new(0.5, -175, 0.5, -125)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    mainFrame.BorderColor3 = Color3.fromRGB(80, 80, 80)
    mainFrame.BorderSizePixel = 1
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Visible = true
    mainFrame.Parent = gui

    local corner = Instance.new("UICorner", mainFrame)
    corner.CornerRadius = UDim.new(0, 8)

    local header = Instance.new("Frame", mainFrame)
    header.Size = UDim2.new(1, 0, 0, 40)
    header.BackgroundColor3 = Color3.fromRGB(35, 35, 35)

    local headerCorner = Instance.new("UICorner", header)
    headerCorner.CornerRadius = UDim.new(0, 8)

    local title = Instance.new("TextLabel", header)
    title.Size = UDim2.new(1, -80, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.Text = "Senpai Hub"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 20
    title.TextXAlignment = Enum.TextXAlignment.Left

    local closeButton = Instance.new("TextButton", header)
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0.5, -15)
    closeButton.Text = "X"
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.Font = Enum.Font.SourceSansBold
    closeButton.TextSize = 18
    local closeCorner = Instance.new("UICorner", closeButton)
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeButton.MouseButton1Click:Connect(function()
        mainFrame.Visible = false
    end)

    local contentFrame = Instance.new("Frame", mainFrame)
    contentFrame.Size = UDim2.new(1, -20, 1, -50)
    contentFrame.Position = UDim2.new(0, 10, 0, 40)
    contentFrame.BackgroundTransparency = 1

    return contentFrame
end

function SenpaiHub:CreateToggle(parent, text, callback)
    local button = Instance.new("TextButton", parent)
    button.Size = UDim2.new(1, 0, 0, 35)
    button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    button.TextColor3 = Color3.fromRGB(220, 220, 220)
    button.Font = Enum.Font.SourceSansSemibold
    button.TextSize = 16
    button.Text = text .. ": OFF"
    local corner = Instance.new("UICorner", button)
    corner.CornerRadius = UDim.new(0, 6)

    local enabled = false
    button.MouseButton1Click:Connect(function()
        enabled = not enabled
        button.Text = text .. ": " .. (enabled and "ON" or "OFF")
        button.BackgroundColor3 = enabled and Color3.fromRGB(70, 170, 70) or Color3.fromRGB(45, 45, 45)
        if callback then
            callback(enabled)
        end
    end)

    return button
end

function SenpaiHub:CreateTextBox(parent, placeholder)
    local box = Instance.new("TextBox", parent)
    box.Size = UDim2.new(0.48, 0, 0, 30)
    box.PlaceholderText = placeholder
    box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.Font = Enum.Font.SourceSans
    box.TextSize = 14
    local corner = Instance.new("UICorner", box)
    corner.CornerRadius = UDim.new(0, 6)
    return box
end

function SenpaiHub:CreateToggleSwitch(parent, text, callback)
    local container = Instance.new("Frame", parent)
    container.Size = UDim2.new(1, 0, 0, 30)
    container.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", container)
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left

    local switch = Instance.new("TextButton", container)
    switch.Size = UDim2.new(0.2, 0, 1, 0)
    switch.Position = UDim2.new(0.8, 0, 0, 0)
    switch.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    switch.Text = ""
    local corner = Instance.new("UICorner", switch)
    corner.CornerRadius = UDim.new(0, 8)

    local knob = Instance.new("Frame", switch)
    knob.Size = UDim2.new(0.4, 0, 0.8, 0)
    knob.Position = UDim2.new(0.1, 0, 0.1, 0)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    local knobCorner = Instance.new("UICorner", knob)
    knobCorner.CornerRadius = UDim.new(0, 6)

    local enabled = false
    switch.MouseButton1Click:Connect(function()
        enabled = not enabled
        switch.BackgroundColor3 = enabled and Color3.fromRGB(70, 170, 70) or Color3.fromRGB(180, 50, 50)
        knob:TweenPosition(
            enabled and UDim2.new(0.5, 0, 0.1, 0) or UDim2.new(0.1, 0, 0.1, 0),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quad,
            0.2,
            true
        )
        if callback then
            callback(enabled)
        end
    end)
    
    return container
end

--================================================================================--
--// Main Code
--================================================================================--

local content = SenpaiHub:CreateWindow()

local listLayout = Instance.new("UIListLayout", content)
listLayout.Padding = UDim.new(0, 10)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder

local detectActive = false
local toggleDetect = SenpaiHub:CreateToggle(content, "Auto Block", function(enabled)
    detectActive = enabled
end)
toggleDetect.LayoutOrder = 1

local settingsContainer = Instance.new("Frame", content)
settingsContainer.Size = UDim2.new(1, 0, 0, 140)
settingsContainer.BackgroundTransparency = 1
settingsContainer.LayoutOrder = 2

local gridLayout = Instance.new("UIGridLayout", settingsContainer)
gridLayout.CellSize = UDim2.new(0.48, 0, 0, 30)
gridLayout.CellPadding = UDim2.new(0.04, 0, 0.1, 0)

local normalBox = SenpaiHub:CreateTextBox(settingsContainer, "M1 Range")
local specialBox = SenpaiHub:CreateTextBox(settingsContainer, "Dash Q Range")
local skillBox = SenpaiHub:CreateTextBox(settingsContainer, "Skill Range")
local skillDelayBox = SenpaiHub:CreateTextBox(settingsContainer, "Skill Hold Time")

local m1AfterEnabled = false
local m1AfterToggle = SenpaiHub:CreateToggleSwitch(content, "M1 After Block", function(enabled)
    m1AfterEnabled = enabled
end)
m1AfterToggle.LayoutOrder = 3

local m1CatchEnabled = false
local m1CatchToggle = SenpaiHub:CreateToggleSwitch(content, "M1 Catch", function(enabled)
    m1CatchEnabled = enabled
end)
m1CatchToggle.LayoutOrder = 4

--================================================================================--
--// Backend Functionality (No changes from original)
--================================================================================--

local normalRange, specialRange, skillRange = 30, 50, 50
local skillDelay = 1.2
skillDelayBox.Text = tostring(skillDelay)

normalBox.FocusLost:Connect(function()
	local v = tonumber(normalBox.Text)
	if v then normalRange = v end
end)
specialBox.FocusLost:Connect(function()
	local v = tonumber(specialBox.Text)
	if v then specialRange = v end
end)
skillBox.FocusLost:Connect(function()
	local v = tonumber(skillBox.Text)
	if v then skillRange = v end
end)
skillDelayBox.FocusLost:Connect(function()
	local v = tonumber(skillDelayBox.Text)
	if v and v > 0 then skillDelay = v end
end)

local function fireRemote(goal, mobile)
	local args = {{
		Goal = goal,
		Key = (goal == "KeyPress" or goal == "KeyRelease") and Enum.KeyCode.F or nil,
		Mobile = mobile or nil
	}}
	LocalPlayer.Character:WaitForChild("Communicate"):FireServer(unpack(args))
end

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

local lastCatch = 0

local comboIDs = {10480793962, 10480796021}
local allIDs = {
	Saitama = {
		10469493270, 10469630950, 10469639222, 10469643643,
		special = 10479335397
	},
	Garou = {
		13532562418, 13532600125, 13532604085, 13294471966,
		special = 10479335397
	},
	Cyborg = {
		13491635433, 13296577783, 13295919399, 13295936866,
		special = 10479335397
	},
	Sonic = {
		13370310513, 13390230973, 13378751717, 13378708199,
		special = 13380255751
	},
	Metal = {
		14004222985, 13997092940, 14001963401, 14136436157,
		special = 13380255751
	},
	Blade = {
		15259161390, 15240216931, 15240176873, 15162694192,
		special = 13380255751
	},
	Tatsumaki = {
		16515503507, 16515520431, 16515448089, 16552234590,
		special = 10479335397
	},
	Dragon = {
		17889458563, 17889461810, 17889471098, 17889290569,
		special = 10479335397
	},
	Tech = {
		123005629431309, 100059874351664, 104895379416342, 134775406437626,
		special = 10479335397
	}
}
local skillIDs = {
	[10468665991] = true, [10466974800] = true, [10471336737] = true, [12510170988] = true,
	[12272894215] = true, [12296882427] = true, [12307656616] = true,
	[101588604872680] = true, [105442749844047] = true, [109617620932970] = true,
	[131820095363270] = true, [135289891173395] = true, [125955606488863] = true,
	[12534735382] = true, [12502664044] = true, [12509505723] = true, [12618271998] = true, [12684390285] = true,
	[13376869471] = true, [13294790250] = true, [13376962659] = true, [13501296372] = true, [13556985475] = true,
	[145162735010] = true, [14046756619] = true, [14299135500] = true, [14351441234] = true,
	[15290930205] = true, [15145462680] = true, [15295895753] = true, [15295336270] = true,
	[16139108718] = true, [16515850153] = true, [16431491215] = true, [16597322398] = true, [16597912086] = true,
	[17799224866] = true, [17838006839] = true, [17857788598] = true, [18179181663] = true,
	[113166426814229] = true, [116753755471636] = true, [116153572280464] = true, [114095570398448] = true, [77509627104305] = true
}

local function checkAnims()
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character.Parent == workspace:FindFirstChild("Live") then
			local char = player.Character
			local hrp = char:FindFirstChild("HumanoidRootPart")
			local hum = char:FindFirstChildWhichIsA("Humanoid")
			local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
			if hrp and hum and myHRP then
				local dist = (hrp.Position - myHRP.Position).Magnitude
				local animator = hum:FindFirstChildOfClass("Animator")
				if animator then
					local anims = {}
					for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
						local id = tonumber(track.Animation.AnimationId:match("%d+"))
						if id then anims[id] = true end
					end

					local comboCount = 0
					for _, id in ipairs(comboIDs) do
						if anims[id] then comboCount += 1 end
					end

					for _, group in pairs(allIDs) do
						local normalHits, special = 0, anims[group.special]
						for i = 1, 4 do
							if anims[group[i]] then normalHits += 1 end
						end

						if comboCount == 2 and normalHits >= 2 and dist <= specialRange then
							fireRemote("KeyPress") task.wait(0.7)
							fireRemote("KeyRelease")
							break
						elseif normalHits > 0 and dist <= normalRange then
							fireRemote("KeyPress") task.wait(0.15)
							fireRemote("KeyRelease")
							doAfterBlock(hrp)
							break
						elseif special and dist <= specialRange and not m1CatchEnabled then
							fireRemote("KeyPress")
							task.delay(1, function()
								fireRemote("KeyRelease")
							end)
							break
						end
					end

					for animId in pairs(anims) do
						if skillIDs[animId] and dist <= skillRange then
							fireRemote("KeyPress")
							task.delay(skillDelay, function()
								fireRemote("KeyRelease")
							end)
							break
						end
					end
				end
			end
		end
	end
end

local function checkM1Catch()
	if not m1CatchEnabled then return end

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character.Parent == workspace:FindFirstChild("Live") then
			local char = player.Character
			local hrp = char:FindFirstChild("HumanoidRootPart")
			local hum = char:FindFirstChildWhichIsA("Humanoid")
			local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
			if hrp and hum and myHRP then
				local dist1 = (hrp.Position - myHRP.Position).Magnitude
				if dist1 <= 30 then
					local animator = hum:FindFirstChildOfClass("Animator")
					if animator then
						for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
							local id = tonumber(track.Animation.AnimationId:match("%d+"))
							if id == 10479335397 then
								task.delay(0.1, function()
									local dist2 = (hrp.Position - myHRP.Position).Magnitude
									if dist2 < dist1 - 0.5 and tick() - lastCatch >= 5 then
										lastCatch = tick()
										fireRemote("LeftClick", true)
										task.delay(0.2, function()
											fireRemote("LeftClickRelease", true)
										end)
										VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.D, false, game)
										VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Q, false, game)
										task.delay(1, function()
											VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Q, false, game)
											VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.D, false, game)
										end)
									end
								end)
								return
							end
						end
					end
				end
			end
		end
	end
end

RunService.Heartbeat:Connect(function()
	if detectActive then
		pcall(checkAnims)
		pcall(checkM1Catch)
	end
end)
