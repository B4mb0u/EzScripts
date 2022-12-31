repeat
    task.wait(0.1)
until 
    game:IsLoaded()

-----------------------

local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function color3ToTable(Color3)
    return {
        R = Color3.R,
        G = Color3.G,
        B = Color3.B
   }
end

local function tableToColor3(Table)
    return Color3.new(
        Table.R,
        Table.G,
        Table.B
    )
end

local function shallowCopy(table)
    local tableCopy

    if type(table) == "table" then
        tableCopy = {}
        for i, v in pairs(table) do
            if typeof(v) == "table" then
                tableCopy[i] = shallowCopy(v)
            else
                tableCopy[i] = v
            end
        end
    else
        tableCopy = table
    end

    return tableCopy
end

local function convert(table, mode)
    if mode == "write" then
        for i, v in pairs(table) do
            if typeof(v) == "Color3" then
                table[i] = color3ToTable(v)
            elseif typeof(v) == "EnumItem" then
                table[i] = split(tostring(v), ".")
            elseif typeof(v) == "table" then
                convert(table[i], "write")
            end
        end
    elseif mode == "read" then
        for i, v in pairs(table) do
            if typeof(v) == "table" and (v.R and v.G and v.B) then
                table[i] = tableToColor3(v)
            elseif typeof(v) == "table" and v[1] == "Enum" then
                table[i] = Enum[v[2]][v[3]]
            elseif typeof(v) == "table" then
                convert(table[i], "read")
            end
        end
    end
end

local function compare(tableN, default)
    for i, v in pairs(default) do
        if tableN[i] == nil then
            tableN[i] = v
        elseif typeof(tableN[i]) == "table" and typeof(v) == "table" then
            compare(tableN[i], v)
        end
    end
    for i, v in pairs(tableN) do
        if default[i] == nil then
            tableN[i] = nil
        elseif typeof(default[i]) == "table" and typeof(v) == "table" then
            compare(default[i], v)
        end
    end
end

local function saveSettings(table, location)
    if writefile then
        local tableCopy = shallowCopy(table)

        convert(tableCopy, "write")

        writefile(location, HttpService:JSONEncode(tableCopy))
    end
end

local function readSettings(location, default)
    if readfile then
        local table = HttpService:JSONDecode(readfile(location))

        compare(table, default)
        convert(table, "read")

        return table
    end
end

local function readSettingsNoCompare(location)
    if readfile then
        local table = HttpService:JSONDecode(readfile(location))

        convert(table, "read")

        return table
    end
end

LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

local defaultConfig = {
    enabled = false,
    enemy = {
        enabled = false,
        boxEnabled = false,
        boxColor = {Color3.new(1,0,0), 1},
        boxOutline = true,
        boxOutlineColor = {Color3.new(), 1},
        boxFill = false,
        boxFillColor = {Color3.new(1,0,0), 0.5},
        healthBar = false,
        healthyColor = Color3.new(0,1,0),
        dyingColor = Color3.new(1,0,0),
        healthBarOutline = true,
        healthBarOutlineColor = {Color3.new(), 1},
        healthText = false,
        healthTextColor = {Color3.new(1,1,1), 1},
        healthTextOutline = true,
        healthTextOutlineColor = Color3.new(),
        name = false,
        nameColor = {Color3.new(1,1,1), 1},
        nameOutline = true,
        nameOutlineColor = Color3.new(),
        weapon = false,
        weaponColor = {Color3.new(1,1,1), 1},
        weaponOutline = true,
        weaponOutlineColor = Color3.new(),
        distance = false,
        distanceColor = {Color3.new(1,1,1), 1},
        distanceOutline = true,
        distanceOutlineColor = Color3.new(),
        tracer = false,
        tracerOrigin = "Bottom",
        tracerColor = {Color3.new(1,0,0), 1},
        tracerOutline = true,
        tracerOutlineColor = {Color3.new(), 1},
        offScreenArrow = false,
        offScreenArrowColor = {Color3.new(1,1,1), 1},
        offScreenArrowSize = 15,
        offScreenArrowRadius = 150,
        offScreenArrowOutline = true,
        offScreenArrowOutlineColor = {Color3.new(), 1},
        chams = false,
        chamsVisibleOnly = false,
        chamsFillColor = {Color3.new(0.2, 0.2, 0.2), 0.5},
        chamsOutlineColor = {Color3.new(1,0,0), 0}
    },
    friendly = {
        enabled = false,
        boxEnabled = false,
        boxColor = {Color3.new(0,1,0), 1},
        boxOutline = true,
        boxOutlineColor = {Color3.new(), 1},
        boxFill = false,
        boxFillColor = {Color3.new(0,1,0), 0.5},
        healthBar = false,
        healthyColor = Color3.new(0,1,0),
        dyingColor = Color3.new(1,0,0),
        healthBarOutline = true,
        healthBarOutlineColor = {Color3.new(), 1},
        healthText = false,
        healthTextColor = {Color3.new(1,1,1), 1},
        healthTextOutline = true,
        healthTextOutlineColor = Color3.new(),
        name = false,
        nameColor = {Color3.new(1,1,1), 1},
        nameOutline = true,
        nameOutlineColor = Color3.new(),
        weapon = false,
        weaponColor = {Color3.new(1,1,1), 1},
        weaponOutline = true,
        weaponOutlineColor = Color3.new(),
        distance = false,
        distanceColor = {Color3.new(1,1,1), 1},
        distanceOutline = true,
        distanceOutlineColor = Color3.new(),
        tracer = false,
        tracerOrigin = "Bottom",
        tracerColor = {Color3.new(0,1,0), 1},
        tracerOutline = true,
        tracerOutlineColor = {Color3.new(), 1},
        offScreenArrow = false,
        offScreenArrowColor = {Color3.new(1,1,1), 1},
        offScreenArrowSize = 15,
        offScreenArrowRadius = 150,
        offScreenArrowOutline = true,
        offScreenArrowOutlineColor = {Color3.new(), 1},
        chams = false,
        chamsVisibleOnly = false,
        chamsFillColor = {Color3.new(0.2, 0.2, 0.2), 0.5},
        chamsOutlineColor = {Color3.new(0,1,0), 0}
    }
}

if isfile and not isfile("EzESP.win") then
    saveSettings(defaultConfig, "EzESP.win")
end

if readfile then
    getgenv().settingsNoCompare = readSettingsNoCompare("EzESP.win")
    getgenv().settings = readSettings("EzESP.win", defaultConfig)
else
    getgenv().settings = defaultConfig
end

-----------------------

local sense = loadstring(game:HttpGet("https://raw.githubusercontent.com/B4mb0u/EzScripts/main/sense.lua"))()
local rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/B4mb0u/EzScripts/main/rayfield.lua"))()

local window = rayfield:CreateWindow({
	Name = "EzESP - v1.0",
	LoadingTitle = "~ EzESP ~",
	LoadingSubtitle = "by Bambou",
	ConfigurationSaving = {
		Enabled = false,
		FolderName = "EzESP.win",
		FileName = "EzScripts"
	},
    Discord = {
        Enabled = true,
        Invite = "TqWBhmgWHt",
        RememberJoins = true
    },
	KeySystem = false, -- Set this to true to use our key system
	KeySettings = {
		Title = "EzScripts.win",
		Subtitle = "Key System",
		Note = "Join the discord (discord.gg/TqWBhmgWHt)",
		FileName = "EzScriptsKey",
		SaveKey = true,
		GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
		Key = "Hello"
	}
})

local homeTab = window:CreateTab("Home", 4483362458)

local espToggle = homeTab:CreateToggle({
    Name = "ESP",
    CurrentValue = getgenv().settings["enabled"],
    Flag = setting,
    Callback = function(value)
        getgenv().settings["enabled"] = value

        saveSettings(getgenv().settings, "EzESP.win")

        if value then
            sense.Load()
        else
            if sense.hasLoaded then
                sense.Unload()
            end
        end
    end
})

local enemyTab = window:CreateTab("Enemy", 4483362458)

for setting in pairs(getgenv().settings["enemy"]) do
    if typeof(getgenv().settings["enemy"][setting]) == "boolean" then
        local settingToggle = enemyTab:CreateToggle({
            Name = setting,
            CurrentValue = getgenv().settings["enemy"][setting],
            Flag = setting,
            Callback = function(value)
                getgenv().settings["enemy"][setting] = value
                saveSettings(getgenv().settings, "EzESP.win")

                sense.teamSettings["Enemy"][setting] = value

                if getgenv().settings["enabled"] then
                    if sense.hasLoaded then
                        sense.Unload()
                    end

                    sense.Load()
                end
            end
        })
    end
end

local friendlyTab = window:CreateTab("Friendly", 4483362458)

for setting in pairs(getgenv().settings["friendly"]) do
    if typeof(getgenv().settings["friendly"][setting]) == "boolean" then
        local settingToggle = friendlyTab:CreateToggle({
            Name = setting,
            CurrentValue = getgenv().settings["friendly"][setting],
            Flag = setting,
            Callback = function(value)
                getgenv().settings["friendly"][setting] = value
                saveSettings(getgenv().settings, "EzESP.win")

                sense.teamSettings["Friendly"][setting] = value

                if getgenv().settings["enabled"] then
                    if sense.hasLoaded then
                        sense.Unload()
                    end

                    sense.Load()
                end
            end
        })
    end
end