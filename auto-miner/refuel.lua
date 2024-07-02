local amount
 
function init()
  print("Enter amount or hit enter for max")
  amount = read()
  if amount == "" then
    amount = math.huge
  elseif tonumber(amount) < 0 then
    error("Negative numbers not allowed")
  end
end
 
function main()
  init()
  for i = 1, amount do
    if turtle.getFuelLevel() == turtle.getFuelLimit() then
      print("Fuel reached limit")
      return
    end
    turtle.drop()
    turtle.suck()
    turtle.refuel()
    print("Fuel: " .. turtle.getFuelLevel())
  end  
end
 
main()
