function moveTo(x, y, z)
    -- Move vertically (Y-axis)
    if y > 0 then
        for i = 1, y do turtle.up() end
    elseif y < 0 then
        for i = 1, -y do turtle.down() end
    end

    -- Move horizontally (X-axis)
    if x ~= 0 then
        if x > 0 then
            turtle.turnRight()
            for i = 1, x do turtle.forward() end
        else
            turtle.turnLeft()
            for i = 1, -x do turtle.forward() end
        end
        -- Only rotate back if Z movement is required right after
        if z == 0 then
            if x > 0 then
                turtle.turnLeft() -- Reset orientation only if no immediate Z movement
            else
                turtle.turnRight() -- Reset orientation only if no immediate Z movement
            end
        end
    end

    -- Move along the Z-axis
    if z ~= 0 then
        if x ~= 0 then -- Adjust orientation if coming from X-axis movement
            if x > 0 then
                turtle.turnLeft()
            else
                turtle.turnRight()
            end
        end
        if z > 0 then
            for i = 1, z do turtle.forward() end
        else
            turtle.turnLeft()
            turtle.turnLeft() -- Turn around
            for i = 1, -z do turtle.forward() end
            turtle.turnLeft()
            turtle.turnLeft() -- Reorient to original direction
        end
    end

    -- Final reorientation if needed
    if x ~= 0 and z ~= 0 then
        if z < 0 or (z == 0 and x < 0) then
            turtle.turnRight() -- Always finish facing the original direction (positive Z)
        elseif z < 0 or (z == 0 and x > 0) then
            turtle.turnLeft()
        end
    end
end

-- Coordinates list
local offsets = {
    {1, 0, 1},
    {-2, -1, 4},
    {3, 2, 1}
}

-- Move to each set of coordinates
for _, offset in ipairs(offsets) do
    moveTo(unpack(offset))
end

-- Return to origin
for i = #offsets, 1, -1 do
    local offset = offsets[i]
    moveTo(-offset[1], -offset[2], -offset[3])
end
