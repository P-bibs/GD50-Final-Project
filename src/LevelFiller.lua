--[[
    
]]

LevelFiller = Class{}

--generate a level by filling a table with integers that specify what to generate later
function LevelFiller.generate(width, height, boss)
    local tiles = {}
    local entities = {}

    --tables of integers to keep track of what type of terrain should be generated
    local groundMap = {} --1 is normal, 2 is pillar, 3 is empty

    -- whether we should draw our tiles with toppers
    local topper = true
    local tileset = math.random(20)
    local topperset = math.random(20)

    -- insert blank tables into tiles for later access
    for x = 1, height do
        table.insert(tiles, {})
    end

    --spawn a boss if this is the third level. Boss will always be the first index in the entities array until it is killed
    if boss then
        local enemyType = 'boss'
        table.insert(entities, Boss({
            entityType = enemyType,
            animations = ENTITY_DEFS[enemyType].animations,
            speed = ENTITY_DEFS[enemyType].speed,
            health = ENTITY_DEFS[enemyType].health,
            width = ENTITY_DEFS[enemyType].width,
            height = ENTITY_DEFS[enemyType].height,

            stateMachine = 
                StateMachine {
                    ['move'] = function() return BossMoveState() end,
                    ['idle'] = function() return BossIdleState() end
                }
        },
        VIRTUAL_WIDTH / 2,
        -200
        )
        )

        entities[#entities]:changeState('move', {entity = entities[#entities]})
    end

    for y = -100, -3000, -200 do
        for x = 100, 1500, 200 do
            local enemyType = math.random(3) == 1 and 'dash' or 'bug'
            index = #entities + 1
            table.insert(entities, Entity({
                entityType = enemyType,
                animations = ENTITY_DEFS[enemyType].animations,
                speed = ENTITY_DEFS[enemyType].speed,
                health = ENTITY_DEFS[enemyType].health,
                width = ENTITY_DEFS[enemyType].width,
                height = ENTITY_DEFS[enemyType].height,

                stateMachine = enemyType == 'bug' and 
                    StateMachine {
                        ['move'] = function() return BugMoveState() end,
                        ['idle'] = function() return BugIdleState() end
                    }
                    or
                    StateMachine {
                        ['move'] = function() return DashMoveState() end,
                        ['idle'] = function() return DashIdleState() end
                    }
            },
            math.random(x - 100, x),
            math.random(y + 100, y)
            )
            )

            entities[index]:changeState('idle', {entity = entities[index]})
        end
    end

    for x = 1, width do  
        --draw normal ground
        for y = 1, height do
            tiles[y][x] = Tile(x, y, 
            y > 6 and TILE_ID_GROUND or TILE_ID_EMPTY,
            y == 7,  
            tileset, 
            topperset)
        end
        blockHeight = 4
    end

    local map = TileMap(width, height)
    map.tiles = tiles
    
    return GameLevel(entities, map)
end
