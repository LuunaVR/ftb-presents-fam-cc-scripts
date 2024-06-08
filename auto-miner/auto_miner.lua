local TurtleController = require("turtle_controller")
local NearestNodeLib = require ("nearest_node_lib")

local ignoreSet, depth;
local scanRadius = 8
local minimumSpaceAfterCleanup = 2
local ignoreBlocks = {
  "bedrock", "cobblestone", "cobbled_deepslate", "deepslate", "dirt", "grass_block", "stone", "tuff", "turtle_advanced"
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
  table.insert(filteredScanResults, {x = 0, y = 0, z = 0}) -- Make turtle location the first node
  for _, block in ipairs(scanResults) do
    local blockName = block.name:match("([^:]+)$")
    if not ignoreSet[blockName] then
      table.insert(filteredScanResults, {x = block.x, y = block.y, z = block.z})
    end
  end

  local path, distance = NearestNodeLib.sortAndCalculateDistance(filteredScanResults)

  turtle.select(1)

  for _, ore in ipairs(path) do
    depositIfInsuffientSpace()
    print("Mining at (" .. ore.x .. ", " .. ore.y .. ", " .. ore.z .. ")")
    if not controller.goTo(controller, ore.x, ore.y, ore.z) then
      -- TODO: can this even happen?
      print("Failed to move to " .. ore.x .. ", " .. ore.y .. ", " .. ore.z .. ")")
    end

  end

  -- Return to start position
  controller.returnToStart(controller)
end

function cleanupInventory()
  for i = 1, 16 do
    local itemDetail = turtle.getItemDetail(i)
    if itemDetail and ignoreSet[itemDetail.name:match("([^:]+)$")] then
      turtle.select(i)
      turtle.dropDown()
    end
  end

  local writeIndex = 1
  for readIndex = 1, 16 do
    if turtle.getItemDetail(readIndex) then
      if readIndex ~= writeIndex then
        turtle.select(readIndex)
        turtle.transferTo(writeIndex)
      end
      writeIndex = writeIndex + 1
    end
  end

  turtle.select(1)
end

function foundChestInFront()
  local success, data = turtle.inspect()
  return success and string.find(data.name, "chest")
end

function depositItems()
  if not foundChestInFront() then
    return false
  end

  for slot = 1, 16 do
    if turtle.getItemCount(slot) > 0 then
      turtle.select(slot)
      if not turtle.drop() then
        return false
      end
    end
  end

  return true
end

function handleDeposit()
  if not depositItems() then
    local attempts = 0
    while attempts < 3 do -- rotate up to 3 times
      turtle.turnRight()
      attempts = attempts + 1
      if depositItems() then
        return
      end
    end
    error("Failed to deposit items after rotating 3 times.")
  end
end

function depositIfInsuffientSpace()
  if not hasEnoughSpace() then
    controller.returnToStart(controller)
    cleanupInventory()
    for i = 1, depth do
      turtle.up()
    end

    controller.rotateToDirection(controller, "north")
    handleDeposit()

    for i = 1, depth do
      turtle.down()
    end 
  end
end

function hasEnoughSpace()
  cleanupInventory()

  return turtle.getItemCount(16 - minimumSpaceAfterCleanup + 1) == 0
end

function main()
  initializeScanner()
  depth = 0
  local reachedBottom = false

  for i = 1, scanRadius + 1 do
    turtle.digDown()
    if turtle.down() then
      depth = depth + 1
    else
      reachedBottom = true
      print("Possible bedrock encountered or cannot move down further.")
      break
    end
  end
  
  while not reachedBottom do
    mineOres()  -- Mine initially before attempting to move down

    for i = 1, (scanRadius * 2) + 1 do  -- Attempt to move down defaultRadius * 2 times
      turtle.digDown()
      if turtle.down() then
        depth = depth + 1
      else
        reachedBottom = true
        print("Possible bedrock encountered or cannot move down further.")
        break
      end
    end

    if reachedBottom then
      mineOres()  -- Perform last mining operation at the bottom
      print("Performing final mining operation before returning to top.")
      break
    end
  end

  -- Return to the surface
  cleanupInventory()
  for y = 1, depth do
    turtle.up()
  end
  handleDeposit()
end

main()



-- Run the mining operation continuously
--while true do
--    mineOres()
--    os.sleep(5) -- Sleep for 5 seconds before the next cycle
--end
