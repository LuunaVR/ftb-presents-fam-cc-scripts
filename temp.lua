-- TurtleController.lua
local TurtleController = {}
TurtleController.__index = TurtleController

function TurtleController.new()
    local self = setmetatable({}, TurtleController)
    self.x = 0
    self.y = 0
    self.z = 0
    self.direction = "north"
    return self
end

local directions = {"north", "east", "south", "west"}
local direction_indices = {north = 1, east = 2, south = 3, west = 4}

local function update_direction(self, turn)
    local idx = direction_indices[self.direction]
    if turn == "left" then
        idx = (idx - 2) % 4 + 1
    elseif turn == "right" then
        idx = idx % 4 + 1
    end
    self.direction = directions[idx]
end

local function update_coordinates(self, movement)
    if movement == "forward" then
        if self.direction == "north" then
            self.z = self.z - 1
        elseif self.direction == "east" then
            self.x = self.x + 1
        elseif self.direction == "south" then
            self.z = self.z + 1
        elseif self.direction == "west" then
            self.x = self.x - 1
        end
    end
end

function TurtleController:move(movement)
    if movement == "forward" then
        while turtle.detect() do
            turtle.dig()
        end
        if turtle.forward() then
            update_coordinates(self, "forward")
            return true
        end
    elseif movement == "up" then
        while turtle.detectUp() do
            turtle.digUp()
        end
        if turtle.up() then
            self.y = self.y + 1
            return true
        end
    elseif movement == "down" then
        while turtle.detectDown() do
            turtle.digDown()
        end
        if turtle.down() then
            self.y = self.y - 1
            return true
        end
    elseif movement == "left" and turtle.turnLeft() then
        update_direction(self, "left")
        return true
    elseif movement == "right" and turtle.turnRight() then
        update_direction(self, "right")
        return true
    end
    return false
end

function TurtleController:getPosition()
    return {x = self.x, y = self.y, z = self.z}
end

function TurtleController:getDirection()
    return self.direction
end

function TurtleController:go(direction, amount)
    direction = direction:lower()
    local success = true

    if direction == "n" or direction == "north" then
        while self.direction ~= "north" do success = self:move("left") and success end
        for i = 1, amount do success = self:move("forward") and success end
    elseif direction == "s" or direction == "south" then
        while self.direction ~= "south" do success = self:move("left") and success end
        for i = 1, amount do success = self:move("forward") and success end
    elseif direction == "e" or direction == "east" then
        while self.direction ~= "east" do success = self:move("right") and success end
        for i = 1, amount do success = self:move("forward") and success end
    elseif direction == "w" or direction == "west" then
        while self.direction ~= "west" do success = self:move("right") and success end
        for i = 1, amount do success = self:move("forward") and success end
    elseif direction == "up" then
        for i = 1, amount do success = self:move("up") and success end
    elseif direction == "down" then
        for i = 1, amount do success = self:move("down") and success end
    else
        success = false
        print("Invalid direction")
    end

    return success
end

function TurtleController:goTo(targetX, targetY, targetZ)
    local success = true
    local deltaX = targetX - self.x
    local deltaY = targetY - self.y
    local deltaZ = targetZ - self.z

    if deltaY > 0 then
        success = self:go("up", deltaY) and success
    elseif deltaY < 0 then
        success = self:go("down", -deltaY) and success
    end

    if deltaX > 0 then
        success = self:go("east", deltaX) and success
    elseif deltaX < 0 then
        success = self:go("west", -deltaX) and success
    end

    if deltaZ > 0 then
        success = self:go("south", deltaZ) and success
    elseif deltaZ < 0 then
        success = self:go("north", -deltaZ) and success
    end

    return success
end

return TurtleController
