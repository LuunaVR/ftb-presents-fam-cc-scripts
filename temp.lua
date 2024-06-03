local blockLocations = {
    {name = "diamond_ore", x=2, y=1, z=3},
    {name = "diamond_ore", x=1, y=1, z=3},
    {name = "iron_ore", x=-3, y=-3, z=0},
    {name = "iron_ore", x=-3, y=-4, z=-1},
}

-- Function to calculate the Manhattan distance between two points
local function calculateDistance(x1, y1, z1, x2, y2, z2)
    return math.abs(x2 - x1) + math.abs(y2 - y1) + math.abs(z2 - z1)
end

-- Function to turn the turtle to a specific direction
local function turnTo(targetDirection, currentDirection)
    local diff = (targetDirection - currentDirection) % 4
    if diff == 1 then
        turtle.turnRight()
    elseif diff == 2 then
        turtle.turnRight()
        turtle.turnRight()
    elseif diff == 3 then
        turtle.turnLeft()
    end
    return targetDirection
end

-- Function to move the turtle to the next block
local function moveTo(nextX, nextY, nextZ, currentX, currentY, currentZ, currentDirection)
    -- Calculate x and z differences
    local dx = nextX - currentX
    local dz = nextZ - currentZ

    -- Move in the x-direction
    if dx > 0 then
        currentDirection = turnTo(1, currentDirection) -- East
        for i = 1, dx do turtle.forward() end
    elseif dx < 0 then
        currentDirection = turnTo(3, currentDirection) -- West
        for i = 1, -dx do turtle.forward() end
    end

    -- Move in the z-direction
    if dz > 0 then
        currentDirection = turnTo(2, currentDirection) -- South
        for i = 1, dz do turtle.forward() end
    elseif dz < 0 then
        currentDirection = turnTo(0, currentDirection) -- North
        for i = 1, -dz do turtle.forward() end
    end

    -- Adjust the y-coordinate to y-1 of the block's y position
    local targetY = nextY - 1
    local dy = targetY - currentY
    if dy > 0 then
        for i = 1, dy do turtle.up() end
    elseif dy < 0 then
        for i = 1, -dy do turtle.down() end
    end

    -- Perform the digging action upwards
    turtle.digUp()

    return nextX, nextY, nextZ, currentDirection
end

-- Nearest Neighbor Algorithm with turtle movement
local function navigateTurtle(locations)
    local currentX, currentY, currentZ = 0, 0, 0 -- Starting at origin
    local currentDirection = 0 -- 0: North, 1: East, 2: South, 3: West
    local n = #locations
    local visited = {}
    local order = {}
    local totalDistance = 0

    local currentLocationIndex = 1  -- Starting from the first block in the list
    table.insert(order, currentLocationIndex)
    visited[currentLocationIndex] = true

    -- Initial movement and action
    currentX, currentY, currentZ, currentDirection = moveTo(locations[currentLocationIndex].x, locations[currentLocationIndex].y, locations[currentLocationIndex].z, currentX, currentY, currentZ, currentDirection)

    -- Iterate over all locations to find the path
    for _ = 1, n - 1 do
        local minDist = math.huge
        local nextIndex = currentLocationIndex
        for i = 1, n do
            if not visited[i] then
                local dist = calculateDistance(locations[currentLocationIndex].x, locations[currentLocationIndex].y, locations[currentLocationIndex].z, locations[i].x, locations[i].y, locations[i].z)
                if dist < minDist then
                    minDist = dist
                    nextIndex = i
                end
            end
        end
        if nextIndex ~= currentLocationIndex then
            visited[nextIndex] = true
            table.insert(order, nextIndex)
            currentX, currentY, currentZ, currentDirection = moveTo(locations[nextIndex].x, locations[nextIndex].y, locations[nextIndex].z, currentX, currentY, currentZ, currentDirection)
            totalDistance = totalDistance + minDist
            currentLocationIndex = nextIndex
        end
    end

    -- Return to the starting location (0, 0, 0)
    moveTo(0, 0, 0, currentX, currentY, currentZ, currentDirection)

    return totalDistance, order
end

-- Execute the navigation function
local totalDistance, pathOrder = navigateTurtle(blockLocations)
print("Total Distance: ", totalDistance)
print("Path Order:")
for i, index in ipairs(pathOrder) do
    local loc = blockLocations[index]
    print(i, loc.name, "at", loc.x, loc.y, loc.z)
end
