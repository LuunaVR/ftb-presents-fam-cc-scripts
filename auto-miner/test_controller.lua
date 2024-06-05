local TurtleController = require("TurtleController")
local turtle = TurtleController.new()

print("Moving turtle to a specific coordinate...")
turtle.goTo(turtle, 5, 3, -2)

local position = turtle.getPosition(turtle)
print("Position after goTo: x=" .. position.x .. ", y=" .. position.y .. ", z=" .. position.z)
print("Current Direction: " .. turtle.getDirection(turtle))

print("Testing additional movements...")
turtle.move(turtle, "forward")
turtle.move(turtle, "up")
turtle.move(turtle, "right")
turtle.move(turtle, "forward")

position = turtle.getPosition(turtle)
print("Position after further movement: x=" .. position.x .. ", y=" .. position.y .. ", z=" .. position.z)
print("Direction after movements: " .. turtle.getDirection(turtle))

print("Returning to start...")
turtle.returnToStart(turtle)

position = turtle.getPosition(turtle)
print("Position after return to start: x=" .. position.x .. ", y=" .. position.y .. ", z=" .. position.z)
print("Direction after return: " .. turtle.getDirection(turtle))
