local addonName, addonNamespace = ...
TTL = addonNamespace

--- used for registering event handlers on a per-event basis
local events = {}

local currentTarget = nil

--- EVENT HANDLERS

function events:PLAYER_TARGET_CHANGED(...)
    if not UnitExists("target") then
        currentTarget = nil
        TTLFrameRoot:Hide()
        print("Have no target.")
    else
        if currentTarget == nil then
            currentTarget = {}
        end

        TTLFrameRoot:Show()

        currentTarget.targetName, currentTarget.targetRealm= UnitName("target")
        currentTarget.targetCurrentHealth = UnitHealth("target")
        currentTarget.targetMaxHealth = UnitHealthMax("target")
        currentTarget.lastUpdateHealth = currentTarget.targetCurrentHealth
    end
end

local function FormatOutput(timeToLive)
    if timeToLive == "..." then
        TTLFrameText:SetText("TTL: " .. timeToLive)
    else
        
        minutes = math.floor(timeToLive / 60)
        seconds = math.floor(timeToLive % 60)

        minutesOutput = ""
        if minutes > 0 then
            minutesOutput = tostring(minutes) .. "m:"
        end
        TTLFrameText:SetText("TTL: " .. minutesOutput .. tostring(seconds) .. "s")
    end
end

local dps = 0
local previousDps = {}
local averageDps = 0
local timeToLive = "..."
local averageDpsTempStorage = 0

local function update()
    if currentTarget == nil or not UnitCanAttack("player", "target") then
        dps = 0
        previousDps = {}
        averageDps = 0
        timeToLive = "..."
        averageDpsTempStorage = 0
        return 
    end
    
    currentTarget.targetCurrentHealth = UnitHealth("target")
    newDps = currentTarget.targetCurrentHealth - currentTarget.lastUpdateHealth

    table.insert(previousDps, newDps)
    
    for i,v in ipairs(previousDps) do
        averageDpsTempStorage = averageDpsTempStorage + v
    end
    
    averageDps = averageDpsTempStorage / table.getn(previousDps)

    if averageDps == 0 then
        timeToLive = "..."
    else
        timeToLive = -1 * currentTarget.targetMaxHealth / averageDps
    end

    FormatOutput(timeToLive)

    currentTarget.lastUpdateHealth = currentTarget.targetCurrentHealth
end

--- Update loop runs once a second
local total = 0
local timeBetweenUpdates = 1
local function onUpdate(self, elapsed)
    total = total + elapsed
    if total >= timeBetweenUpdates then
        update()
        total = 0
    end
end

--- ONLOAD
function TTL:Init(self)
    print("Time To Live loaded.")

    --- EVENT REGISTRATION
    TTLFrameRoot:SetScript("OnEvent", function(self, event, ...)
        events[event](self, ...)
    end);

    for k, v in pairs(events) do
        print("Registering for event: " .. k)
        TTLFrameRoot:RegisterEvent(k)
    end

    TTLFrameRoot:SetScript("OnUpdate", onUpdate)
    TTLFrameRoot:Hide()
end

