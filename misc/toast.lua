local chatBox = peripheral.wrap("right")

-- Get message
print("Enter your message: ")
local input = read()
print("")

-- Ask if should send to all
print("Send to all? Y/N: ")
local sendToAll = read()
print("")

-- Format toast
local title = {
  { text = "Alert", color = "red", bold = true }
}
local message = {
  { text = input, color = "light_purple" }
}

local titleJson = textutils.serializeJSON(title)
local messageJson = textutils.serializeJSON(message)

-- Convert input to lowercase
sendToAll = string.lower(sendToAll)

if sendToAll == "y" then
  local players = chatBox.getOnlinePlayers()
  for _, player in ipairs(players) do
    chatBox.sendFormattedToastToPlayer(messageJson, titleJson, player)
  end
  print("Toast sent to all players.")
else
  -- Ask for single player
  print("Enter target player: ")
  local player = read()
  print("")
  chatBox.sendFormattedToastToPlayer(messageJson, titleJson, player)
  print("Toast sent to " .. player .. ".")
end
