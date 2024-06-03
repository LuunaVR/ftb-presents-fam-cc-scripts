function move(direction, steps)
    if steps < 0 then
        if direction == "x" or direction == "z" then
            turtle.turnLeft()
            turtle.turnLeft()
        end
        steps = -steps
    end
    
    for i=1, steps do
        if direction == "y" then
            if steps > 0 then
                turtle.up()
            else
                turtle.down()
            end
        else
            turtle.forward()
        end
    end
    
    if direction == "x" or direction == "z" then
        turtle.turnLeft()
        turtle.turnLeft() -- Reset to original direction after reversing
    end
end

function goToOffset(x, y, z)
    -- Handle movement in the Z, X, and Y directions
    move("z", z)
    move("x", x)
    move("y", y)
end

-- Coordinates list
local coords = {
    {1, 0, 1},
    {-2, -1, 4},
    {3, 2, 1}
}

-- Move to each set of coordinates
for _, coord in ipairs(coords) do
    goToOffset(unpack(coord))
end

-- Return to origin by moving in the opposite direction
for i = #coords, 1, -1 do
    local coord = coords[i]
    goToOffset(-coord[1], -coord[2], -coord[3])
end
