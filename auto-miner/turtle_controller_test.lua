local TurtleControllerLib = require("turtle_controller")
local turtleController = TurtleControllerLib.new()

print("Moving turtle to a specific coordinate...")
turtleController.goTo(turtleController, 5, 3, -2)
turtleController.goTo(turtleController, -3, -2, 4)
turtleController.goTo(turtleController, 7, 9, -1)

local position = turtleController.getPosition(turtleController)
print("Position after goTo: x=" .. position.x .. ", y=" .. position.y .. ", z=" .. position.z)
print("Current Direction: " .. turtleController.getDirection(turtleController))

print("Testing additional movements...")
turtleController.move(turtleController, "forward")
turtleController.move(turtleController, "up")
turtleController.move(turtleController, "right")
turtleController.move(turtleController, "forward")

position = turtleController.getPosition(turtleController)
print("Position after further movement: x=" .. position.x .. ", y=" .. position.y .. ", z=" .. position.z)
print("Direction after movements: " .. turtleController.getDirection(turtleController))

print("Returning to start...")
turtleController.returnToStart(turtleController)

position = turtleController.getPosition(turtleController)
print("Position after return to start: x=" .. position.x .. ", y=" .. position.y .. ", z=" .. position.z)
print("Direction after return: " .. turtleController.getDirection(turtleController))
