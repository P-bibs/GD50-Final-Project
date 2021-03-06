--[[
    Static class that creates levels and fills them with entities
    Also draws finish line at top of level
]]

LevelFiller = Class{}

--generate a level by filling a table with integers that specify what to generate later
function LevelFiller.generate(width, height, boss)
    local tiles = {}
    local entities = {}

    -- insert blank tables into tiles for later access
    for y = 1, 20 do
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
                    ['idle'] = function() return BossIdleState() end,
                    ['fireball'] = function() return BossFireballState() end,
                    ['stun'] = function() return BossStunState() end
                }
        },
        --spawn boss on the ground on the right side of the screen
        width * TILE_SIZE - ENTITY_DEFS[enemyType].width,
        -ENTITY_DEFS[enemyType].height
        )
        )

        entities[#entities]:changeState('move', {entity = entities[#entities]})
    end

    --spawn one enemy per 200 * 200 box
    for y = -100, -height, -200 do
        for x = 100, width * TILE_SIZE, 200 do
            if x ~= 900 then --don't spawn an enemy where the player spawns
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
    end

    for x = 1, width do  
        --fill ground
        for y = 1, 20 do
            tiles[y][x] = Tile(x, y, 
            y == 1 and TILE_ID_TOP or TILE_ID_GROUND
            )
        end
    end

    local map = TileMap(width, 20)
    map.tiles = tiles
    
    return Stage(entities, map, height)
end
