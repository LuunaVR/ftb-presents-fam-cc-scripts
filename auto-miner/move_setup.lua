print("Enter distance (default 16): ")
local distance = read()

if distance == "" then
  distance = 16
end

turtle.dig()
turtle.turnLeft()
for i = 1, distance do
  turtle.forward()
end

turtle.turnRight()
turtle.place()

shell.run("auto_miner")
