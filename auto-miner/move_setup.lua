print("Enter distance: ")
local distance = read()

turtle.dig()
turtle.turnLeft()
for i = 1, distance do
  turtle.forward()
end

turtle.turnRight()
turtle.place()
