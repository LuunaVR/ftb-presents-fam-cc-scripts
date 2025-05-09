local chatBox = peripheral.find("chatBox")

-- Player list
local players = {"foeslayerx","lunabear01","luunavr","mystic271","perolith","tantebouster"}

-- Prompt user
term.write("Send prank message? Y/N: ")
local confirm = string.lower(read())
print("")

if confirm == "y" then
  term.write("Send to all? Y/N: ")
  local all = string.lower(read())
  print("")

  -- Message content
  local message = {
    { text = "Click ", color = "white" },
    {
      text = "[here]",
      color = "aqua",
      underlined = true,
      clickEvent = {
        action = "run_command",
        value = "/me has donated their soul to Luuna"
      }
    },
    {
      text = " for a ",
      color = "white"
    },
    {
      text = "diamond",
      color = "blue",
      italic = true,
      hoverEvent = {
        action = "show_item",
        contents = {
          id = "minecraft:diamond",
          count = 1
        }
      }
    },
    {
      text = "!",
      color = "white"
    }
  }

  local json = textutils.serializeJSON(message)

  if all == "y" then
    for _, name in ipairs(players) do
      chatBox.sendFormattedMessageToPlayer(json, name)
    end
    print("Sent to all.")
  else
    term.write("Enter player name: ")
    local name = read()
    print("")
    chatBox.sendFormattedMessageToPlayer(json, name)
    print("Sent to " .. name)
  end
else
  print("Cancelled.")
end
