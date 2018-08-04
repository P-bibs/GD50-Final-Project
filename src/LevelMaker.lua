--[[
    GD50
    Super Mario Bros. Remake

    -- LevelMaker Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

LevelMaker = Class{}

--generate a level by filling a table with integers that specify what to generate later
function LevelMaker.generate(width, height)
    local tiles = {}
    local entities = {}
    local objects = {}

    --tables of integers to keep track of what type of terrain and objects should be generated
    local groundMap = {} --1 is normal, 2 is pillar, 3 is empty
    local objectMap = {} --1 is nothing, 2 is bushes, 3 is jump blocks, 4 is key, 5 is lock

    -- whether we should draw our tiles with toppers
    local topper = true
    local tileset = math.random(20)
    local topperset = math.random(20)

    -- insert blank tables into tiles for later access
    for x = 1, height do
        table.insert(tiles, {})
    end

    --fill with random ints, weighted so it is mostly normal ground
    for x = 1, width do
        groundMap[x] = 1
    end

    --fill with random ints to represent objects
    for x = 1, width do
        objectMap[x] = math.random(6) < 5 and 1 or 2 --spawn random object if not a special x coord
        if objectMap[x] == 2 and groundMap[x] == 3 then --if the ground is empty at this x, don't spawn an object
            objectMap [x] = 1 
        end
    end

    -- once the tables are filled to determine where the objects are and what type of ground to use, go through each x coord and actuall add the ground and objects
    for x = 1, width do  
        -- lay out the empty space
        for y = 1, 6 do
            table.insert(tiles[y],
                Tile(x, y, TILE_ID_EMPTY, nil, tileset, topperset))
        end
        --draw normal ground
        if groundMap[x] == 1 then 
            for y = 1, height do
                tiles[y][x] = Tile(x, y, 
                y > 6 and TILE_ID_GROUND or TILE_ID_EMPTY,
                y == 7 and topper or nil,  
                tileset, 
                topperset)
            end
            blockHeight = 4
        --spawn pillars
        elseif groundMap[x] == 2 then
            for y = 1, height do
                tiles[y][x] = Tile(x, y, 
                y > 4 and TILE_ID_GROUND or TILE_ID_EMPTY,
                y == 5 and topper or nil,  
                tileset, 
                topperset)
            end
            blockHeight = 2
        --spawn void
        elseif groundMap[x] == 3 then
            for y = 1, height do
                tiles[y][x] = Tile(x, y, 
                TILE_ID_EMPTY,
                nil,  
                tileset, 
                topperset)
            end
            blockHeight = 4
        end
        if objectMap[x] == 1 then
            --do nothing
        end
    end

    local map = TileMap(width, height)
    map.tiles = tiles
    
    return GameLevel(entities, objects, map)
end
