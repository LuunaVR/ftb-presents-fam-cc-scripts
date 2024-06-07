local NearestNodeLib = {}

-- Function to calculate the Manhattan distance between two points in 3D
local function manhattanDistance(p1, p2)
    return math.abs(p1.x - p2.x) + math.abs(p1.y - p2.y) + math.abs(p1.z - p2.z)
end

-- Function to find the nearest unvisited node
local function findNearestNode(currentNode, nodes, visited)
    local minDistance = math.huge
    local nearestNodeIndex = nil
    for i, node in ipairs(nodes) do
        if not visited[i] then
            local distance = manhattanDistance(currentNode, node)
            if distance < minDistance then
                minDistance = distance
                nearestNodeIndex = i
            end
        end
    end
    return nearestNodeIndex, minDistance
end

-- Function to perform the nearest node sort and calculate the total travel distance
function NearestNodeLib.sortAndCalculateDistance(nodes)
    local totalDistance = 0
    local visited = {}
    local currentNodeIndex = 1
    local path = {nodes[currentNodeIndex]}
    visited[currentNodeIndex] = true

    for _ = 1, #nodes - 1 do
        local nextNodeIndex, distance = findNearestNode(nodes[currentNodeIndex], nodes, visited)
        if nextNodeIndex then
            visited[nextNodeIndex] = true
            currentNodeIndex = nextNodeIndex
            table.insert(path, nodes[currentNodeIndex])
            totalDistance = totalDistance + distance
        else
            break
        end
    end
    return path, totalDistance
end

-- Function to perform the first-to-last sequential traversal for a list of nodes without optimizing
function NearestNodeLib.sequentialDistance(nodes)
    local totalDistance = 0
    for i = 1, #nodes - 1 do
        totalDistance = totalDistance + manhattanDistance(nodes[i], nodes[i+1])
    end
    return totalDistance
end

return NearestNodeLib
