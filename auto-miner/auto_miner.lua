local TurtleController = require("turtle_controller")
local NearestNodeLib = require ("nearest_node_lib")

local ignoreSet, depth;
local scanRadius = 8
local ignoreBlocks = {
    "bedrock", "deepslate", "dirt", "grass_block", "stone", "tuff", "turtle_advanced"
}

local controller = TurtleController.new()
local scanner = peripheral.find("geoScanner")

function initializeScanner()
    term.setCursorPos(1, 1)
    print(string.rep(" ", term.getSize()))  -- Clear the line where cursor is positioned

    depth = 0;
    
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

function mineOres()
    local scanResults = scanner.scan(scanRadius)

    local filteredScanResults = {}
    for _, block in ipairs(scanResults) do
        local blockName = block.name:match("([^:]+)$")
        if not ignoreSet[blockName] then
            table.insert(filteredScanResults, {x = block.x, y = block.y, z = block.z})
        end
    end

    local path, distance = NearestNodeLib.sortAndCalculateDistance(filteredScanResults)
    
    for _, ore in ipairs(path) do
        print("Mining at (" .. ore.x .. ", " .. ore.y .. ", " .. ore.z .. ")")
        if controller.goTo(controller, ore.x, ore.y, ore.z) then
            turtle.dig()
        else
            print("Failed to move to " .. ore.x .. ", " .. ore.y .. ", " .. ore.z .. ")")
        end

    end

    -- Return to start position
    controller.returnToStart(controller)
end

function main()
    initializeScanner()
    mineOres()

    local reachedBottom = false
    while not reachedBottom do
        mineOres()
        for i=1, scanRadius + scanRadius do
            if not turtle.digDown() then
                reachedBottom = true
                break
            end
            turtle.down()
            depth = depth + 1
        end
    end

    controller.returnToStart(controller)
    for i=1, depth do
        turtle.up()
    end

end


-- Run the mining operation continuously
--while true do
--    mineOres()
--    os.sleep(5) -- Sleep for 5 seconds before the next cycle
--end
