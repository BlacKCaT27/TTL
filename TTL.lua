local addonName, addonNamespace = ...
TTL = addonNamespace

--- used for registering event handlers on a per-event basis
local events = {}

local currentTarget = nil

--- EVENT HANDLERS

function events:PLAYER_TARGET_CHANGED(...)
    if not UnitExists("target") or not UnitIsEnemy("player", "target") or not UnitCanAttack("player", "target") then
        currentTarget = nil
        TTLFrameRoot:Hide()
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

--- END EVENT HANDLERS

local function FormatOutput(timeToLive)
    if timeToLive == "..." or timeToLive == "Dead!" then
        TTLFrameText:SetText("TTL: " .. timeToLive)
    else
        --- add 0.5 to both so that floor() acts like round() would if it existed.
        minutes = math.floor((timeToLive / 60) + 0.5)
        seconds = math.floor((timeToLive % 60) + 0.5)

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

local function reset()
    dps = 0
    previousDps = {}
    averageDps = 0
    timeToLive = "..."
end

local function update()
    if currentTarget == nil or not UnitCanAttack("player", "target") then
        reset()
        return 
    end

    if UnitIsDead("target") then
        reset()
        FormatOutput("Dead!")
        return
    end
    
    currentTarget.targetCurrentHealth = UnitHealth("target")
    newDps = currentTarget.lastUpdateHealth - currentTarget.targetCurrentHealth

    previousDps[table.getn(previousDps) + 1] = newDps
    
    local sum = 0
    for i,v in ipairs(previousDps) do
        sum = sum + v
    end
    
    averageDps = sum / table.getn(previousDps)

    if averageDps == 0 then
        timeToLive = "..."
    else
        timeToLive = currentTarget.targetCurrentHealth / averageDps
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
        TTLFrameRoot:RegisterEvent(k)
    end

    TTLFrameRoot:SetScript("OnUpdate", onUpdate)
    TTLFrameRoot:Hide()
end

