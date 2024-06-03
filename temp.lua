-- Function to move the turtle based on offset coordinates
function moveTo(offsetX, offsetY, offsetZ)
    -- Move up or down
    if offsetY > 0 then
        for i=1, offsetY do
            turtle.up()
        end
    elseif offsetY < 0 then
        for i=1, -offsetY do
            turtle.down()
        end
    end

    -- Move forward or backward
    for i=1, math.abs(offsetX) do
        if offsetX > 0 then
            turtle.forward()
        else
            turtle.back()
        end
    end

    -- Move right or left
    for i=1, math.abs(offsetZ) do
        if offsetZ > 0 then
            turtle.turnRight()
            turtle.forward()
            turtle.turnLeft()
        else
            turtle.turnLeft()
            turtle.forward()
            turtle.turnRight()
        end
    end
end

-- Coordinates list
local coords = {
    {1, 0, 1},
    {-2, -1, 4},
    {3, 2, 1}
}

-- Move to each set of coordinates
for i, coord in ipairs(coords) do
    moveTo(coord[1], coord[2], coord[3])
end

-- Return to origin by moving in the opposite direction
for i = #coords, 1, -1 do
    local coord = coords[i]
    moveTo(-coord[1], -coord[2], -coord[3])
end
