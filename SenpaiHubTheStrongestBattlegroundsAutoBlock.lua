local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local gui = Instance.new("ScreenGui", PlayerGui)
gui.Name = "SenpaiHubGui"
gui.ResetOnSpawn = false

-- UI Setup
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 150)
mainFrame.Position = UDim2.new(0.5, -110, 0.5, -75)
mainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50) -- Darker background
mainFrame.BorderColor3 = Color3.fromRGB(80, 80, 80)
mainFrame.BorderSizePixel = 2
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = true
mainFrame.Parent = gui

local cornerRadius = 8 -- Increased corner radius for a softer look
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, cornerRadius)
corner.Parent = mainFrame

-- Toggle Button
local toggleDetect = Instance.new("TextButton", mainFrame)
toggleDetect.Size = UDim2.new(0.7, 0, 0, 30)
toggleDetect.Position = UDim2.new(0, 0, 0, 0)
toggleDetect.Text = "Auto Block: OFF"
toggleDetect.BackgroundColor3 = Color3.fromRGB(70, 70, 70) -- Slightly lighter button
toggleDetect.TextColor3 = Color3.new(1, 1, 1)
toggleDetect.Font = Enum.Font.SourceSansBold
toggleDetect.TextScaled = true
local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, cornerRadius)
toggleCorner.Parent = toggleDetect

-- Open Button
local openBtn = Instance.new("TextButton", mainFrame)
openBtn.Size = UDim2.new(0.3, 0, 0, 30)
openBtn.Position = UDim2.new(0.7, 0, 0, 0)
openBtn.Text = ">"
openBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
openBtn.TextColor3 = Color3.new(1, 1, 1)
openBtn.Font = Enum.Font.SourceSansBold
openBtn.TextScaled = true
local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(0, cornerRadius)
openCorner.Parent = openBtn

-- Settings Frame
local settingFrame = Instance.new("Frame", mainFrame)
settingFrame.Size = UDim2.new(1, 0, 0, 140)
settingFrame.Position = UDim2.new(0, 0, 0, 30)
settingFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60) -- Settings frame background
settingFrame.Visible = false
local settingCorner = Instance.new("UICorner")
settingCorner.CornerRadius = UDim.new(0, cornerRadius)
settingCorner.Parent = settingFrame

-- Senpai Hub Title
local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, -35)
title.BackgroundColor3 = Color3.new(0, 0, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextScaled = true
title.Text = "Senpai Hub"
title.Parent = mainFrame

openBtn.MouseButton1Click:Connect(function()
	settingFrame.Visible = not settingFrame.Visible
	openBtn.Text = settingFrame.Visible and "<" or ">"
end)

-- Bubble Button
local bubble = Instance.new("TextButton", gui)
bubble.Size = UDim2.new(0, 32, 0, 32)
bubble.Position = UDim2.new(0, 5, 0.5, -40)
bubble.Text = "⚙️"
bubble.BackgroundColor3 = Color3.fromRGB(70, 70, 70) -- Bubble button background
bubble.TextColor3 = Color3.new(1, 1, 1)
bubble.Font = Enum.Font.SourceSansBold
bubble.TextScaled = true
bubble.Active = true
bubble.Draggable = true
local bubbleCorner = Instance.new("UICorner")
bubbleCorner.CornerRadius = UDim.new(0, cornerRadius)
bubbleCorner.Parent = bubble

bubble.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
end)

-- Text Box Function
local function makeBox(size, pos, placeholder)
	local box = Instance.new("TextBox")
	box.Size = size
	box.Position = pos
	box.PlaceholderText = placeholder
	box.Text = ""
	box.BackgroundColor3 = Color3.fromRGB(70, 70, 70) -- Text box background
	box.TextColor3 = Color3.new(1, 1, 1)
	box.Font = Enum.Font.SourceSans
	box.TextScaled = true
	local boxCorner = Instance.new("UICorner")
	boxCorner.CornerRadius = UDim.new(0, cornerRadius)
	boxCorner.Parent = box
	return box
end

-- Creating Text Boxes
local normalBox = makeBox(UDim2.new(0.45, 0, 0, 25), UDim2.new(0.05, 0, 0, 0), "M1")
local specialBox = makeBox(UDim2.new(0.45, 0, 0, 25), UDim2.new(0.5, 0, 0, 0), "Dash Q")
local skillBox = makeBox(UDim2.new(0.45, 0, 0, 25), UDim2.new(0.05, 0, 0, 30), "Skill")
local skillDelayBox = makeBox(UDim2.new(0.45, 0, 0, 25), UDim2.new(0.5, 0, 0, 30), "Hold Skill")

normalBox.Parent = settingFrame
specialBox.Parent = settingFrame
skillBox.Parent = settingFrame
skillDelayBox.Parent = settingFrame

-- Toggle Button Function
local function createSquareToggle(name, defaultText, posY)
	local label = Instance.new("TextLabel", mainFrame)
	label.Text = name
	label.Size = UDim2.new(0.7, 0, 0, 20)
	label.Position = UDim2.new(0.05, 0, 0, posY)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.SourceSans
	label.TextColor3 = Color3.new(1, 1, 1)
	label.TextScaled = true

	local button = Instance.new("TextButton", mainFrame)
	button.Size = UDim2.new(0, 25, 0, 25)
	button.Position = UDim2.new(1, -30, 0, posY)
	button.Text = "OFF"
	button.BackgroundColor3 = Color3.fromRGB(70, 70, 70) -- Toggle button color
	button.TextColor3 = Color3.new(1, 1, 1)
	button.Font = Enum.Font.SourceSansBold
	button.TextScaled = true
	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, cornerRadius)
	btnCorner.Parent = button

	return button
end

-- Creating Toggle Buttons
local m1AfterBtn = createSquareToggle("M1 After Block",  "OFF", 80)
local m1CatchBtn = createSquareToggle("M1 Catch", "OFF", 110)

-- Backend Variables
local normalRange, specialRange, skillRange = 30, 50, 50
local skillDelay = 1.2

-- Toggle Variables
local m1AfterEnabled = false
local m1CatchEnabled = false

-- Text box Functionality
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

-- Toggle button Functionality
m1AfterBtn.MouseButton1Click:Connect(function()
	m1AfterEnabled = not m1AfterEnabled
	m1AfterBtn.Text = m1AfterEnabled and "ON" or "OFF"
end)

m1CatchBtn.MouseButton1Click:Connect(function()
	m1CatchEnabled = not m1CatchEnabled
	m1CatchBtn.Text = m1CatchEnabled and "ON" or "OFF"
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

local detectActive = false
toggleDetect.MouseButton1Click:Connect(function()
	detectActive = not detectActive
	toggleDetect.Text = detectActive and "Auto Block: ON" or "Auto Block: OFF"
	toggleDetect.BackgroundColor3 = detectActive and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(60, 60, 60)
end)

RunService.Heartbeat:Connect(function()
	if detectActive then
		pcall(checkAnims)
		pcall(checkM1Catch)
	end
end)
