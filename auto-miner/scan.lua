local function main() --for loop
local defaultRadius = 8
local ignoreList = {
  "bedrock",
  "deepslate",
  "dirt",
  "grass_block",
  "stone",
  "tuff",
  "turtle_advanced"
}
local filterList = {
  "iron_ore"
}
 
local argRadius = tonumber(arg[1])
local scanRadius = argRadius or defaultRadius
 
term.clear()
term.setCursorPos(1, 1)
 
local scanner = peripheral.find("geo_scanner")
if not scanner then
  print("No geo scanner found. Please attach a geo scanner.")
  return
end
 
local ignoreSet = {}
for _, blockName in ipairs(ignoreList) do
  ignoreSet[blockName] = true
end
 
local filterSet = {}
for _, blockName in ipairs(filterList) do
  filterSet[blockName] = true
end
 
local scanResults = scanner.scan(scanRadius)
if not scanResults then
  print("Scan failed or returned no results.")
  return
end
 
local blockCounts = {}
local filteredCounts = {}
 
for _, block in ipairs(scanResults) do
  local blockName = block.name:match("([^:]+)$")
  if not ignoreSet[blockName] then
    if blockCounts[blockName] then
      blockCounts[blockName] = blockCounts[blockName] + 1
    else
      blockCounts[blockName] = 1
    end
    if filterSet[blockName] then
      if filteredCounts[blockName] then
        filteredCounts[blockName] = filteredCounts[blockName] + 1
      else
        filteredCounts[blockName] = 1
      end
    end
  end
end
 
-- Sorting the results by block name
local sortedKeys = {}
for blockName in pairs(blockCounts) do
  table.insert(sortedKeys, blockName)
end
table.sort(sortedKeys)
 
local sortedFilteredKeys = {}
for blockName in pairs(filteredCounts) do
  table.insert(sortedFilteredKeys, blockName)
end
table.sort(sortedFilteredKeys)
 
-- Printing the sorted results
print("Scan Results:")
for _, blockName in ipairs(sortedKeys) do
  print(blockCounts[blockName] .. " " .. blockName)
end
 
if next(sortedFilteredKeys) then
  print("--< FILTERED >--")
  for _, blockName in ipairs(sortedFilteredKeys) do
    print(filteredCounts[blockName] .. " " .. blockName)  
  end
end
end 
 
while true do
  main()
  sleep(3)
end 
