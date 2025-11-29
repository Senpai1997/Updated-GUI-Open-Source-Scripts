local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Window = OrionLib:MakeWindow({
    Name = "Senpai Hub", 
    HidePremium = false, 
    SaveConfig = true, 
    ConfigFolder = "SenpaiHubConfig"
})

-- Create a Tab
local MainTab = Window:MakeTab({
	Name = "Main",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

-- Variable to store the connections so we can re-enable them later
local disabledConnections = {}

-- The Toggle
MainTab:AddToggle({
	Name = "Infinite Sprint (No Stamina Drain)",
	Default = false,
	Callback = function(Value)
		local rns = game:GetService("RunService")
        
        if Value then
            -- SWITCH ON: Disable the stamina mechanism
            -- We loop through connections to find the stamina one
            for _, cnx in pairs(getconnections(rns.PreRender)) do
                local success, src = pcall(function() return debug.info(cnx.Function, "s") end)
                
                -- Check if debug info was found and if it matches "Stamina"
                if success and src and src:find("Stamina") then
                    cnx:Disable()
                    table.insert(disabledConnections, cnx) -- Save it to the list
                end
            end
            
            OrionLib:MakeNotification({
                Name = "Senpai Hub",
                Content = "Infinite Sprint Enabled!",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
            
        else
            -- SWITCH OFF: Re-enable the stamina mechanism
            for i, cnx in pairs(disabledConnections) do
                cnx:Enable()
            end
            disabledConnections = {} -- Clear the list
            
            OrionLib:MakeNotification({
                Name = "Senpai Hub",
                Content = "Sprint mechanism restored.",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end
	end    
})

-- Initialize the Library
OrionLib:Init()
