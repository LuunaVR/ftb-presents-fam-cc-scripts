local TurtleController = require("turtle_controller")
local NearestNodeLib = require ("nearest_node_lib")

local ignoreSet;
local scanRadius = 8
local ignoreBlocks = {
    "bedrock", "deepslate", "dirt", "grass_block", "stone", "tuff", "turtle_advanced"
}

local controller = TurtleController.new()
local scanner = peripheral.find("geoScanner")

function initializeScanner()
    term.setCursorPos(1, 1)
    print(string.rep(" ", term.getSize()))  -- Clear the line where cursor is positioned
 
    scanner = peripheral.find("geoScanner")
    if not scanner then
        print("No geo scanner found. Please attach a geo scanner.")
        return false
    end
 
    ignoreSet = {}
    for _, blockName in ipairs(ignoreBlocks) do
        ignoreSet[blockName] = true
    end
 
    return true
end

local function mineOres()
    local scanResults = scanner.scan(scanRadius)

    local filteredScanResults = {}
    for _, block in ipairs(scanResults) do
        local blockName = block.name:match("([^:]+)$")
        if not ignoreSet[blockName] then
            table.insert(filteredScanResults, {x = block.x, y = block.y, z = block.z})
        end
    end

    local path, distance = NearestNodeLib.sortAndCalculateDistance(filteredBlocks)
    
    for _, ore in ipairs(path) do
        local oreName = ore.name:match("([^:]+)$") -- Extract the name after the colon
        print("Mining " .. oreName .. " at (" .. ore.x .. ", " .. ore.y .. ", " .. ore.z .. ")")
        if controller.goTo(controller, ore.x, ore.y, ore.z) then
            turtle.dig()
        else
            print("Failed to move to " .. oreName .. " at (" .. ore.x .. ", " .. ore.y .. ", " .. ore.z .. ")")
        end

    end

    -- Return to start position
    controller.returnToStart(controller)
end

initializeScanner()
mineOres()
-- Run the mining operation continuously
--while true do
--    mineOres()
--    os.sleep(5) -- Sleep for 5 seconds before the next cycle
--end
