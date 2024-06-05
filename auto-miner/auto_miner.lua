local TurtleController = require("TurtleController")

local scanRadius = 8
local ignoreOres = {
    "bedrock", "deepslate", "dirt", "grass_block", "stone", "tuff", "turtle_advanced"
}

local controller = TurtleController.new()
local scanner = peripheral.find("geoScanner")

if not scanner then
    error("No geo scanner found. Please attach a geo scanner.")
end

local function isIgnored(oreName)
    for _, v in ipairs(ignoreOres) do
        if oreName:find(v) then
            return true
        end
    end
    return false
end

local function mineOres()
    local ores = scanner.scan(scanRadius)
  
    for _, ore in ipairs(ores) do
        local oreName = ore.name:match("([^:]+)$") -- Extract the name after the colon
        if not isIgnored(oreName) then
            print("Mining " .. oreName .. " at (" .. ore.x .. ", " .. ore.y .. ", " .. ore.z .. ")")
            if controller.goTo(controller, ore.x, ore.y, ore.z) then
                turtle.dig()
            else
                print("Failed to move to " .. oreName .. " at (" .. ore.x .. ", " .. ore.y .. ", " .. ore.z .. ")")
            end
        end
    end

    -- Return to start position
    controller.returnToStart(controller)
end

mineOres()
-- Run the mining operation continuously
--while true do
--    mineOres()
--    os.sleep(5) -- Sleep for 5 seconds before the next cycle
--end
