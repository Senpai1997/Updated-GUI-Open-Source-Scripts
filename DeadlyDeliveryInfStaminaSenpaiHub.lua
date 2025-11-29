local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- Creating the Window with the header "Senpai Hub"
local Window = OrionLib:MakeWindow({
    Name = "Senpai Hub", 
    HidePremium = false, 
    SaveConfig = true, 
    ConfigFolder = "SenpaiHub"
})

-- Creating a Main Tab
local Tab = Window:MakeTab({
	Name = "Main",
	Icon = "rbxassetid://448345528",
	PremiumOnly = false
})

-- The Function to handle the stamina logic
local function ToggleStamina(bool)
    local rns = game:GetService("RunService")
    
    -- Check if getconnections exists (Executor supported)
    if not getconnections then 
        OrionLib:MakeNotification({
            Name = "Error",
            Content = "Your executor does not support getconnections!",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
        return 
    end

    for _, cnx in pairs(getconnections(rns.PreRender)) do
        local func = cnx.Function
        if func then
            local src = debug.info(func, "s")
            if src and src:find("Stamina") then
                if bool then
                    -- Switch is ON: Disable stamina drain
                    cnx:Disable()
                else
                    -- Switch is OFF: Enable stamina drain back to normal
                    cnx:Enable()
                end
            end
        end
    end
end

-- Creating the Toggle Switch
Tab:AddToggle({
	Name = "Infinite Sprint",
	Default = false,
	Callback = function(Value)
		ToggleStamina(Value)
	end    
})

-- Initializing the UI
OrionLib:Init()
