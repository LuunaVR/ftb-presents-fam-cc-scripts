local chatBox = peripheral.find("chatBox")

-- Player list
local players = {"foeslayerx","lunabear01","luunavr","mystic271","perolith","tantebouster"}

-- Input message
term.write("Enter your toast message: ")
local msg = read()
print("")

-- Ask if it should go to all
term.write("Send to all? Y/N: ")
local sendToAll = string.lower(read())
print("")

-- Toast content
local title = {
  { text = "Alert", color = "red", bold = true }
}
local message = {
  { text = msg, color = "white" }
}
local titleJson = textutils.serializeJSON(title)
local messageJson = textutils.serializeJSON(message)

-- Send
if sendToAll == "y" then
  for _, name in ipairs(players) do
    chatBox.sendFormattedToastToPlayer(messageJson, titleJson, name)
  end
  print("Toast sent to all players.")
else
  term.write("Enter player name: ")
  local name = read()
  print("")
  chatBox.sendFormattedToastToPlayer(messageJson, titleJson, name)
  print("Toast sent to " .. name .. ".")
end
