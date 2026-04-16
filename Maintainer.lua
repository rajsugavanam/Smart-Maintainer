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

-- Clean up potential unspecified priorities and batch mode specifiers
for _, group in ipairs(items) do
    if group.priority == nil then
        group.priority = 0
    end
    if group.batchMode == nil then
        group.batchMode = false
    end
end

if priorityMode then
    -- Sort based on priority.
    table.sort(items, function (groupA, groupB)
        return groupA.priority > groupB.priority
    end)
end

while true do
    local itemsCrafting = ae2.checkIfCrafting()

    -- randomize recipe groups
    if (not priorityMode) and recipeGroupsRandomized and shuffleLists then
        logInfo(">> Group order randomized!")
        randomizeTable(idxTable)
    end

    for _, randomIdx in ipairs(idxTable) do
        local groupTbl = items[randomIdx]
        local itemKeys = getKeys(groupTbl.entries)
        if shuffleLists then -- stays false if randomization is disabled.
            logInfo(">> Scheduling order shuffled for group " .. randomIdx .. "!")
            itemKeys = randomizeKeys(groupTbl.entries)
            items[randomIdx] = groupTbl
        end

        if groupTbl.batchMode == true then
            local batchReady = ae2.batchReady(groupTbl.entries, itemsCrafting)
            if (not batchReady) then
                logInfo("Group " .. randomIdx .. " has batch mode enabled but items still crafting!")
                goto continue
            end
        end

        for _, item in ipairs(itemKeys) do
            local config = groupTbl.entries[item]
            if itemsCrafting[item] == true then
                logInfo(item .. " is already being crafted, skipping...")
            else
                local success, answer = ae2.requestItem(item, config[1], config[2], config[3])
                logInfo(answer)
            end
        end

        ::continue::
    end

    if recipeGroupsRandomized then
        shuffleLists = (shuffleCounter == 0)
        shuffleCounter = (shuffleCounter + 1) % randomizeFrequency
    end

    os.sleep(sleepInterval)
end
