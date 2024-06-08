print("Enter amount (in buckets): ")
local amount = read()
for i = 1, amount do
  turtle.drop()
  turtle.suck()
  turtle.refuel()
  print(turtle.getFuelLevel())
end
