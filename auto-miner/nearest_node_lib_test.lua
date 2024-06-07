-- Include the nearest node library
local NearestNodeLib = require 'nearest_node_lib'

-- Define a list of test nodes (30 blocks across 8 clusters)
local testNodes = {
    {x=4, y=2, z=3}, {x=4, y=3, z=3}, {x=5, y=2, z=3},  -- Cluster 1
    {x=-2, y=2, z=-2}, {x=-3, y=2, z=-2}, {x=-2, y=1, z=-2},  -- Cluster 2
    {x=10, y=10, z=10}, {x=10, y=11, z=10},  -- Cluster 3
    {x=-5, y=-5, z=-5}, {x=-5, y=-6, z=-5},  -- Cluster 4
    {x=20, y=20, z=20}, {x=21, y=21, z=21}, {x=22, y=22, z=22},  -- Cluster 5
    {x=-15, y=-15, z=-15}, {x=-16, y=-15, z=-15},  -- Cluster 6
    {x=30, y=30, z=30}, {x=31, y=31, z=31}, {x=32, y=32, z=32},  -- Cluster 7
    {x=-20, y=-20, z=-20}, {x=-21, y=-21, z=-21},  -- Cluster 8
    {x=0, y=0, z=0}, {x=1, y=0, z=0}, {x=0, y=1, z=0}, {x=1, y=1, z=0},  -- Additional nodes
    {x=40, y=40, z=40}, {x=40, y=41, z=40}, {x=41, y=40, z=40}, {x=41, y=41, z=40},  -- More nodes
    {x=-30, y=-30, z=-30}, {x=-30, y=-31, z=-30}, {x=-31, y=-30, z=-30}  -- More nodes
}

-- Test sequential distance calculation
local sequentialDistance = NearestNodeLib.sequentialDistance(testNodes)
print("Total Sequential Distance: " .. sequentialStraightDistance)

-- Test optimized distance calculation
local _, optimizedDistance = NearestNodeLib.sortAndCalculateDistance(testNodes)
print("Total Optimized Distance: " .. optimizedDistance)
