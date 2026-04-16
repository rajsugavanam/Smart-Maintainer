local ae2 = require("src.AE2")
local cfg = require("config")
local util = require("src.Utility") 

local items = cfg.items
local sleepInterval = cfg.sleep
local randomizeFrequency = cfg.randomizeFrequency
local priorityMode = cfg.priorityMode

local shuffleCounter = 0
local shuffleLists = false
local recipeGroupsRandomized = randomizeFrequency ~= 0

local idxTable = {}
for i=1, #items do
    idxTable[i] = i
end

if priorityMode then

    -- Clean up potential unspecified priorities
    for _, group in ipairs(items) do
        if group.priority == nil then
            group.priority = 0
        end
    end

    -- Sort based on priority.
    table.sort(items, function (groupA, groupB)
        return groupA.priority > groupB.priority
    end)
end

while true do
    local itemsCrafting = ae2.checkIfCrafting()

    -- randomize recipe groups
    if (not priorityMode) and recipeGroupsRandomized and shuffleLists then
        randomizeTable(idxTable)
    end

    for _, randomIdx in ipairs(idxTable) do
        local groupTbl = items[randomIdx]
        if shuffleLists then -- stays false if randomization is disabled.
            randomizeTable(groupTbl)
            items[randomIdx] = groupTbl
        end

        for item, config in pairs(groupTbl) do
            if itemsCrafting[item] == true then
                logInfo(item .. " is already being crafted, skipping...")
            else
                local success, answer = ae2.requestItem(item, config[1], config[2], config[3])
                logInfo(answer)
            end
    
        end
    end

    if recipeGroupsRandomized then
        shuffleLists = (shuffleCounter == 0)
        shuffleCounter = (shuffleCounter + 1) % randomizeFrequency
    end

    os.sleep(sleepInterval)
end
