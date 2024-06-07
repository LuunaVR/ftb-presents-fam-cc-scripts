local scanner = peripheral.find("geoScanner")
local NearestNodeLib = require 'nearest_node_lib'
 
local ignoreSet
local ignoreList = {"bedrock", "deepslate", "dirt", "grass_block", "stone", "tuff", "turtle_advanced"}
 
function init()
  ignoreSet = {}
  for _,blockName in ipairs(ignoreList) do
    ignoreSet[blockName] = true
  end
end

function main()
    init()
    local scanResults = scanner.scan(7)
    if not scanResults then
        print("Scan failed or returned no results.")
    end
    
    local filteredBlocks = {}
    for _, block in ipairs(scanResults) do
        local blockName = block.name:match("([^:]+)$")
        if not ignoreSet[blockName] then
            table.insert(filteredBlocks, {x = block.x, y = block.y, z = block.z})   
        end
    end  
    
    print(filteredBlocks[1].x)
      
    local sequentialDistance = NearestNodeLib.sequentialDistance(filteredBlocks)
    print("Total Sequential Distance: " .. sequentialDistance)
    
 
    local _, optimizedDistance = NearestNodeLib.sortAndCalculateDistance(filteredBlocks)                                        
    print("Total Optimized Distance: " .. optimizedDistance)
end
 
main()
