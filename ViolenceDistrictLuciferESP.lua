local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local ESP = {
    players = {}
}
local SHOW_DISTANCE = true
local SHOW_NAMES = true
local SHOW_BOXES = true
local SHOW_TRACERS = true
local MAX_DISTANCE = 500
local previousPositions = {}
function ESP:CreateDrawing(type, properties)
    local drawing = Drawing.new(type)
    for prop, value in pairs(properties) do
        drawing[prop] = value
    end
    return drawing
end
function ESP:Add(player)
    if player == LocalPlayer then return end
    
    local drawings = {
        boxTL = self:CreateDrawing("Line", {Thickness = 1}), 
        boxTR = self:CreateDrawing("Line", {Thickness = 1}),
        boxBL = self:CreateDrawing("Line", {Thickness = 1}), 
        boxBR = self:CreateDrawing("Line", {Thickness = 1}), 
        boxTLv = self:CreateDrawing("Line", {Thickness = 1}), 
        boxTRv = self:CreateDrawing("Line", {Thickness = 1}), 
        boxBLv = self:CreateDrawing("Line", {Thickness = 1}),
        boxBRv = self:CreateDrawing("Line", {Thickness = 1}), 
        tracer = self:CreateDrawing("Line", {Thickness = 1}),
        name = self:CreateDrawing("Text", {
            Size = 13,
            Center = true,
            Outline = false, 
            Font = 2 
        })
    }
    
    self.players[player] = drawings
end

function ESP:Remove(player)
    local drawings = self.players[player]
    if drawings then
        for _, drawing in pairs(drawings) do
            drawing:Remove()
        end
        self.players[player] = nil
    end
    previousPositions[tostring(player.UserId)] = nil
end

function ESP:GetTeamInfo(player)
    local isTeammate = false
    local teamName = "Enemy"
    local color = Color3.fromRGB(255, 50, 50)
    
    if player.Team then
        if player.Team == LocalPlayer.Team and not player.Neutral then
            isTeammate = true
            teamName = "Teammate"
            color = Color3.fromRGB(50, 255, 50)
        else
            teamName = player.Team.Name or "Enemy"
        end
    end
    
    if string.lower(player.Name) == "killer" or string.find(string.lower(player.Name), "killer") then
        teamName = "Killer"
        color = Color3.fromRGB(255, 0, 0)
    elseif string.find(string.lower(player.Name), "survivor") then
        teamName = "Survivor" 
        color = Color3.fromRGB(0, 255, 0)
    end
    
    return isTeammate, teamName, color
end

function ESP:GetCharacterBounds(character)
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local head = character:FindFirstChild("Head")
    
    if not rootPart or not head then
        return 20, 45 
    end
    
    local minX, maxX, minY, maxY, minZ, maxZ = rootPart.Position.X, rootPart.Position.X, rootPart.Position.Y, rootPart.Position.Y, rootPart.Position.Z, rootPart.Position.Z
    
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            local partPos = part.Position
            local partSize = part.Size
            minX = math.min(minX, partPos.X - partSize.X/2)
            maxX = math.max(maxX, partPos.X + partSize.X/2)
            minY = math.min(minY, partPos.Y - partSize.Y/2)
            maxY = math.max(maxY, partPos.Y + partSize.Y/2)
        end
    end
    
    local width = (maxX - minX) * 2
    local height = (maxY - minY) * 1.5
    
    width = math.clamp(width, 15, 35)
    height = math.clamp(height, 40, 60)
    
    return width, height
end

function ESP:Update()
    for player, drawings in pairs(self.players) do
        local character = player.Character
        if not character then
            for _, drawing in pairs(drawings) do
                drawing.Visible = false
            end
            continue
        end
        
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local head = character:FindFirstChild("Head")
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        
        if not humanoid or not head or not rootPart or humanoid.Health <= 0 then
            for _, drawing in pairs(drawings) do
                drawing.Visible = false
            end
            continue
        end
        
        local currentPos = rootPart.Position
        local playerKey = tostring(player.UserId)
        
        if not previousPositions[playerKey] then
            previousPositions[playerKey] = currentPos
        end
        
        local smoothFactor = 0.2
        local smoothedPos = previousPositions[playerKey] + (currentPos - previousPositions[playerKey]) * smoothFactor
        previousPositions[playerKey] = smoothedPos
        
        local headPos, headVisible = Camera:WorldToViewportPoint(head.Position)
        local rootPos, rootVisible = Camera:WorldToViewportPoint(smoothedPos)
        
        if not headVisible or not rootVisible then
            for _, drawing in pairs(drawings) do
                drawing.Visible = false
            end
            continue
        end
        
        local distance = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) 
            and (LocalPlayer.Character.HumanoidRootPart.Position - smoothedPos).Magnitude 
            or 0
        
        if distance > MAX_DISTANCE then
            for _, drawing in pairs(drawings) do
                drawing.Visible = false
            end
            continue
        end
        
        local isTeammate, teamName, color = self:GetTeamInfo(player)
        local boxWidth, boxHeight = self:GetCharacterBounds(character)
        local distanceScale = math.clamp(50 / (distance / 10), 0.8, 1.2)
        boxWidth = boxWidth * distanceScale
        boxHeight = boxHeight * distanceScale
        boxWidth = math.max(boxWidth, 18)
        boxHeight = math.max(boxHeight, 42)
        local boxPos = Vector2.new(rootPos.X, rootPos.Y - boxHeight / 3)
        local cornerLength = math.clamp(boxWidth * 0.3, 6, 10)
        if SHOW_BOXES then
            drawings.boxTL.From = Vector2.new(boxPos.X - boxWidth/2, boxPos.Y - boxHeight/2)
            drawings.boxTL.To = Vector2.new(boxPos.X - boxWidth/2 + cornerLength, boxPos.Y - boxHeight/2)
            drawings.boxTL.Color = color
            drawings.boxTL.Visible = true
            
            drawings.boxTLv.From = Vector2.new(boxPos.X - boxWidth/2, boxPos.Y - boxHeight/2)
            drawings.boxTLv.To = Vector2.new(boxPos.X - boxWidth/2, boxPos.Y - boxHeight/2 + cornerLength)
            drawings.boxTLv.Color = color
            drawings.boxTLv.Visible = true
            
            drawings.boxTR.From = Vector2.new(boxPos.X + boxWidth/2, boxPos.Y - boxHeight/2)
            drawings.boxTR.To = Vector2.new(boxPos.X + boxWidth/2 - cornerLength, boxPos.Y - boxHeight/2)
            drawings.boxTR.Color = color
            drawings.boxTR.Visible = true
            
            drawings.boxTRv.From = Vector2.new(boxPos.X + boxWidth/2, boxPos.Y - boxHeight/2)
            drawings.boxTRv.To = Vector2.new(boxPos.X + boxWidth/2, boxPos.Y - boxHeight/2 + cornerLength)
            drawings.boxTRv.Color = color
            drawings.boxTRv.Visible = true
            
            drawings.boxBL.From = Vector2.new(boxPos.X - boxWidth/2, boxPos.Y + boxHeight/2)
            drawings.boxBL.To = Vector2.new(boxPos.X - boxWidth/2 + cornerLength, boxPos.Y + boxHeight/2)
            drawings.boxBL.Color = color
            drawings.boxBL.Visible = true
            
            drawings.boxBLv.From = Vector2.new(boxPos.X - boxWidth/2, boxPos.Y + boxHeight/2)
            drawings.boxBLv.To = Vector2.new(boxPos.X - boxWidth/2, boxPos.Y + boxHeight/2 - cornerLength)
            drawings.boxBLv.Color = color
            drawings.boxBLv.Visible = true
            
            drawings.boxBR.From = Vector2.new(boxPos.X + boxWidth/2, boxPos.Y + boxHeight/2)
            drawings.boxBR.To = Vector2.new(boxPos.X + boxWidth/2 - cornerLength, boxPos.Y + boxHeight/2)
            drawings.boxBR.Color = color
            drawings.boxBR.Visible = true
            
            drawings.boxBRv.From = Vector2.new(boxPos.X + boxWidth/2, boxPos.Y + boxHeight/2)
            drawings.boxBRv.To = Vector2.new(boxPos.X + boxWidth/2, boxPos.Y + boxHeight/2 - cornerLength)
            drawings.boxBRv.Color = color
            drawings.boxBRv.Visible = true
        end
        
        if SHOW_TRACERS then
            drawings.tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
            drawings.tracer.To = Vector2.new(boxPos.X, boxPos.Y + boxHeight/2)
            drawings.tracer.Color = color
            drawings.tracer.Visible = true
        end
        
        if SHOW_NAMES then
            local displayText = player.Name
            if SHOW_DISTANCE then
                displayText = string.format("%s [%d]", player.Name, math.floor(distance))
            end
            displayText = displayText .. "\n" .. teamName
            
            drawings.name.Position = Vector2.new(boxPos.X, boxPos.Y - boxHeight/2 - 20)
            drawings.name.Text = displayText
            drawings.name.Color = Color3.fromRGB(255, 255, 255) 
            drawings.name.Visible = true
        end
    end
end

function ESP:Init()
    self.players = {}
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            self:Add(player)
        end
    end
    
    Players.PlayerAdded:Connect(function(player)
        if player ~= LocalPlayer then
            self:Add(player)
        end
    end)
    
    Players.PlayerRemoving:Connect(function(player)
        self:Remove(player)
    end)
    
    local frameCount = 0
    RunService.RenderStepped:Connect(function()
        frameCount = frameCount + 1
        if frameCount % 2 == 0 then 
            self:Update()
        end
    end)
end
ESP:Init()
print("  [~] Created by Lucifer")
print("  [~] Experiencing Issues contact me on my discord")
