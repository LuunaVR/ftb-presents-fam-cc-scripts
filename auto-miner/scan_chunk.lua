-- Scan chunks for blocks matching the given keywords

-- Configurations
local REFRESH_INTERVAL = 5

local geoScanner = peripheral.find("geo_scanner")
if not geoScanner then
  print("GeoScanner not found")
  return
end

-- Ask user for target keywords, comma-seperated
print("Enter keywords:")
local input = read()
local TARGET_KEYWORDS = {}
for keyword in string.gmatch(input, "[^,%s]+") do
  table.insert(TARGET_KEYWORDS, keyword)
end

print("Scanning every " .. REFRESH_INTERVAL .. "s for:")
for _, keyword in ipairs(TARGET_KEYWORDS) do
  print(" - " .. keyword)
end

while true do
  term.clear()
  term.setCursorPos(1, 1)

  local results = geoScanner.chunkAnalyze()
  local matched = {}

  for fullName, count in pairs(results) do
    local name = fullName:match(":(.+)$") or fullName  -- Strip mod prefix

    for _, keyword in ipairs(TARGET_KEYWORDS) do
      if string.find(name, keyword) then
        matched[name] = (matched[name] or 0) + count
        break
      end
    end
  end

  print("Scan Results:")
  for name, count in pairs(matched) do
    print(count .. " " .. name)
  end

  sleep(REFRESH_INTERVAL)
end
