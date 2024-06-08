local amount = read()
for i = 1, amount do
  turtle.drop()
  turtle.suck()
  print(turtle.getFuelLevel())
end
