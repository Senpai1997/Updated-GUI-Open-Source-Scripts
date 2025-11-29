local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/turtle"))()
local Win = Lib:Window("Senpai Hub | UMA Racing")

local FVelocity = Vector3.new(0, 0, 0)
local ECSetting = false
local ISSetting = false
local VMSetting = 1

Win:Toggle("Easy Control", false, function(Bool)
    ECSetting = Bool
end)

Win:Toggle("Infinity Stamina", false, function(Bool)
    ISSetting = Bool
end)

Win:Slider("Velocity Multiplier", 1, 4, 1, function(Value)
    VMSetting = Value
end)

local oldindex;oldindex = hookmetamethod(game, "__index", function(v1, v2)
    if ECSetting and v2 == "Velocity" and getnamecallmethod() == "ToOrientation" then
        return FVelocity
    end
    return oldindex(v1, v2)
end)

local oldnewindex;oldnewindex = hookmetamethod(game, "__newindex", function(v1, v2, v3)
    if v2 == "AssemblyLinearVelocity" then
        if math.abs((v3 * VMSetting).Magnitude) < 700 then
            return oldnewindex(v1, v2, v3 * VMSetting)
        end
        return oldnewindex(v1, v2, FVelocity)
    end
    return oldnewindex(v1, v2, v3)
end)

local oldnamecall;oldnamecall = hookmetamethod(game, "__namecall", function(v1, v2, ...)
    if ISSetting and getnamecallmethod() == "FireServer" and v2 == "SpeedTarget" then
        return oldnamecall(v1, v2, 0)
    end
    return oldnamecall(v1, v2, ...)
end)
