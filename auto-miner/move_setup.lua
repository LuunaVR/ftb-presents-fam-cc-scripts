local defaultDistance = 16
local waitTime = 5

local timer = os.startTimer(waitTime)
parallel.waitForAny(
    function()
        distance = read()
    end,
    function()
        while true do
            local event, id = os.pullEvent("timer")
            if id == timer then break end
        end
    end
)

if not distance then
    distance = defaultDistance
    print("No input received, using default value: " .. tostring(defaultDistance))
else
    print("User input received: " .. tostring(distance))
end

turtle.dig()
turtle.turnLeft()
for i = 1, distance do
  turtle.forward()
end

turtle.turnRight()
turtle.place()
