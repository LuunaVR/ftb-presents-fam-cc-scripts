-- TurtleController.lua
local TurtleController = {}
TurtleController.__index = TurtleController

-- Create a new instance of TurtleController
function TurtleController.new()
    local controller = {
        x = 0,
        y = 0,
        z = 0,
        direction = "north"
    }
    setmetatable(controller, TurtleController)
    return controller
end

-- Update the direction the turtle is facing
local function update_direction(controller, turn)
    local directions = {"north", "east", "south", "west"}
    local idx = 1
    for i, dir in ipairs(directions) do
        if dir == controller.direction then
            idx = i
            break
        end
    end

    if turn == "left" then
        idx = (idx - 2) % 4 + 1
    elseif turn == "right" then
        idx = idx % 4 + 1
    end

    controller.direction = directions[idx]
end

-- Update the coordinates based on the movement direction
local function update_coordinates(controller, movement)
    if movement == "forward" then
        if controller.direction == "north" then
            controller.z = controller.z - 1
        elseif controller.direction == "east" then
            controller.x = controller.x + 1
        elseif controller.direction == "south" then
            controller.z = controller.z + 1
        elseif controller.direction == "west" then
            controller.x = controller.x - 1
        end
    end
end

-- Move the turtle forward, up, down, or turn left/right
function TurtleController.move(controller, movement)
    if movement == "forward" then
        while turtle.detect() do
            turtle.dig()
        end
        if turtle.forward() then
            update_coordinates(controller, "forward")
            return true
        end
    elseif movement == "up" then
        while turtle.detectUp() do
            turtle.digUp()
        end
        if turtle.up() then
            controller.y = controller.y + 1
            return true
        end
    elseif movement == "down" then
        while turtle.detectDown() do
            turtle.digDown()
        end
        if turtle.down() then
            controller.y = controller.y - 1
            return true
        end
    elseif movement == "left" then
        if turtle.turnLeft() then
            update_direction(controller, "left")
            return true
        end
    elseif movement == "right" then
        if turtle.turnRight() then
            update_direction(controller, "right")
            return true
        end
    end
    return false
end

-- Get the current position of the turtle
function TurtleController.getPosition(controller)
    return {x = controller.x, y = controller.y, z = controller.z}
end

-- Get the current direction the turtle is facing
function TurtleController.getDirection(controller)
    return controller.direction
end

-- Move the turtle in the specified direction by the given amount
function TurtleController.go(controller, direction, amount)
    direction = direction:lower()
    local success = true

    if direction == "n" or direction == "north" then
        while controller.direction ~= "north" do success = TurtleController.move(controller, "left") and success end
        for i = 1, amount do success = TurtleController.move(controller, "forward") and success end
    elseif direction == "s" or direction == "south" then
        while controller.direction ~= "south" do success = TurtleController.move(controller, "left") and success end
        for i = 1, amount do success = TurtleController.move(controller, "forward") and success end
    elseif direction == "e" or direction == "east" then
        while controller.direction ~= "east" do success = TurtleController.move(controller, "right") and success end
        for i = 1, amount do success = TurtleController.move(controller, "forward") and success end
    elseif direction == "w" or direction == "west" then
        while controller.direction ~= "west" do success = TurtleController.move(controller, "right") and success end
        for i = 1, amount do success = TurtleController.move(controller, "forward") and success end
    elseif direction == "up" then
        for i = 1, amount do success = TurtleController.move(controller, "up") and success end
    elseif direction == "down" then
        for i = 1, amount do success = TurtleController.move(controller, "down") and success end
    else
        success = false
        print("Invalid direction")
    end

    return success
end

-- Move the turtle to the specified coordinates (x, y, z)
function TurtleController.goTo(controller, targetX, targetY, targetZ)
    local success = true
    local deltaX = targetX - controller.x
    local deltaY = targetY - controller.y
    local deltaZ = targetZ - controller.z

    if deltaY > 0 then
        success = TurtleController.go(controller, "up", deltaY) and success
    elseif deltaY < 0 then
        success = TurtleController.go(controller, "down", -deltaY) and success
    end

    if deltaX > 0 then
        success = TurtleController.go(controller, "east", deltaX) and success
    elseif deltaX < 0 then
        success = TurtleController.go(controller, "west", -deltaX) and success
    end

    if deltaZ > 0 then
        success = TurtleController.go(controller, "south", deltaZ) and success
    elseif deltaZ < 0 then
        success = TurtleController.go(controller, "north", -deltaZ) and success
    end

    return success
end

return TurtleController
