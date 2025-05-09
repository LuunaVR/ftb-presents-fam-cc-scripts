local chatBox = peripheral.find("chatBox")  -- Automatically finds the Chat Box peripheral

-- Player list to send to when sending to all
local players = {"foeslayerx","lunabear01","luunavr","mystic271","perolith","tantebouster"}

-- Confirm to send
term.write("Send prank message? Y/N: ")
local confirm = string.lower(read())
print("")

if confirm == "y" then
  term.write("Send to all? Y/N: ")
  local all = string.lower(read())
  print("")

  -- Construct the formatted message
  local message = {
    { text = "Click " },
    {
      text = "H",
      color = "blue",
      bold = true,
      clickEvent = {
        action = "run_command",
        value = "me bark"
      }
    },
    { text = " to receive 4 diamonds " },
    {
      text = "diamond",
      color = "light_blue",
      italic = true,
      hoverEvent = {
        action = "show_item",
        contents = {
          id = "minecraft:diamond",
          count = 1
        }
      }
    }
  }

  local json = textutils.serializeJSON(message)

  if all == "y" then
    for _, name in ipairs(players) do
      chatBox.sendFormattedMessageToPlayer(json, name)
    end
    print("Message sent to all players.")
  else
    term.write("Enter player name: ")
    local name = read()
    print("")
    chatBox.sendFormattedMessageToPlayer(json, name)
    print("Message sent to " .. name)
  end
else
  print("Cancelled.")
end
