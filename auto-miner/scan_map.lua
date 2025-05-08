-- Configuration outside the function
local defaultRadius = 10
local showUnknown = false
local size = (defaultRadius * 2) + 1  -- Calculate size based on radius
local backgroundColor = colors.gray
local centerChar = "+"
local center = math.floor(size / 2) + 1  -- Dynamically calculate the center based on size
local refresh = 2
 
-- Color and label hashmap for blocks
local blockColors = {
    ancient_debris = {color = colors.brown, label = "R"},
    diamond_ore = {color = colors.lightBlue, label = "D"}
}
--    coal_ore = {color = colors.black, label = "C"},
--    gold_ore = {color = colors.orange, label = "G"},
--    iron_ore = {color = colors.lightGray, label = "I"},
--    lapis_ore = {color = colors.blue, label = "L"},
--    redstone_ore = {color = colors.red, label = "R"}
--}
 
-- Initialize global variables
local scanner, ignoreSet, filterSet
local ignoreList = {"bedrock", "deepslate", "cobbled_deepslate", "dirt", "grass_block", "stone", "tuff", "turtle_advanced"}
local filterList = {"diamond_ore"}
 
function initializeScanner()
    term.setCursorPos(1, 1)
    print(string.rep(" ", term.getSize()))  -- Clear the line where cursor is positioned
 
    scanner = peripheral.find("geoScanner")
    if not scanner then
        print("No geo scanner found. Please attach a geo scanner.")
        return false
    end
 
    ignoreSet = {}
    for _, blockName in ipairs(ignoreList) do
        ignoreSet[blockName] = true
    end
 
    filterSet = {}
    for _, blockName in ipairs(filterList) do
        filterSet[blockName] = true
    end
 
    return true
end
 
-- Function to display a map with specific blocks based on their offsets
function displayMapBackground(blocksForMap)
    term.setCursorPos(1, 1)
    for y = 1, size do
        for x = 1, size do
            term.setCursorPos(x, y)
            term.setBackgroundColor(backgroundColor)
            write(" ")  -- Clear each cell by writing a space with background color
        end
    end
 
    -- Place the center character
    term.setCursorPos(center, center)
    write(centerChar)
 
    -- Apply blocks' offsets to the map
    for _, block in pairs(blocksForMap) do
        local posX = center + block.x
        local posZ = center + block.z
        if posX >= 1 and posX <= size and posZ >= 1 and posZ <= size then
            term.setCursorPos(posX, posZ)
            local found = false
            for key, value in pairs(blockColors) do
                if string.find(block.name, key) then
                    term.setBackgroundColor(value.color)
                    write(value.label)
                    found = true
                    break
                end
            end
            if showUnknown and not found then
                term.setBackgroundColor(backgroundColor)
                write("?") 
            end
        end
    end
end
 
function main()
    local scanResults = scanner.scan(defaultRadius)
    if not scanResults then
        print("Scan failed or returned no results.")
        return
    end
 
    local blocksForMap = {}
 
    -- Collecting blocks' relative positions
    for _, block in ipairs(scanResults) do
        local blockName = block.name:match("([^:]+)$")  -- Removes mod name from block name
        if not ignoreSet[blockName] then
            table.insert(blocksForMap, {name = blockName, x = block.x, z = block.z})
        end
    end
 
    -- Display the map with collected blocks
    displayMapBackground(blocksForMap)
end
 
term.clear()
if initializeScanner() then
    while true do
        main()
        sleep(refresh)
    end
else
    print("Initialization failed. Exiting.")
end
