local scanner = peripheral.find("geoScanner")
local NearestNodeLib = require 'nearest_node_lib'
 
local ignoreSet
local ignoreList = {"bedrock", "cobbled_deepslate", "deepslate", "dirt", "grass_block", "stone", "tuff", "turtle_advanced"}
 
function init()
  ignoreSet = {}
  for _,blockName in ipairs(ignoreList) do
    ignoreSet[blockName] = true
  end
end

function printTable(tbl, indent)
    if not indent then indent = 0 end
    for k, v in pairs(tbl) do
        local formatting = string.rep("  ", indent) .. k .. ":"
        if type(v) == "table" then
            print(formatting)
            printTable(v, indent+1)
        else
            print(formatting .. tostring(v))
        end
    end
end

function main()
    init()
    local scanResults = scanner.scan(7)
    if not scanResults then
        print("Scan failed or returned no results.")
    end
    
    local filteredBlocks = {}
    table.insert(filteredBlocks, {x = 0, y = 0, z = 0}) 
    for _, block in ipairs(scanResults) do
        local blockName = block.name:match("([^:]+)$")
        if not ignoreSet[blockName] then
            table.insert(filteredBlocks, {x = block.x, y = block.y, z = block.z})   
        end
    end
      
    local sequentialDistance = NearestNodeLib.sequentialDistance(filteredBlocks)
    print("Total Sequential Distance: " .. sequentialDistance)
    
 
    local path, optimizedDistance = NearestNodeLib.sortAndCalculateDistance(filteredBlocks)                                        
    print("Total Optimized Distance: " .. optimizedDistance)

    for _, block in pairs(path) do
        print("x:" .. block.x ..", y:" .. block.y ..", z:" .. block.z) 
    end
    --printTable(path)
end
 
main()
