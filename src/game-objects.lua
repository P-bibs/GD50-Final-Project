--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GAME_OBJECT_DEFS = {
    ['dust'] = {
        width = 16,
        height = 16,
        solid = false,
        collidable = false,
        consumable = false,
        onCollide = function() end,
        onConsume = function() end,
        hit = false,
        animations = {
            ['0'] = {
                frames = {1, 2, 3, 4, 5},
                interval = 0.155,
                texture = 'dust',
                looping = false
            },
            ['1'] = {
                frames = {6, 7, 8, 9, 10},
                interval = 0.15,
                texture = 'dust',
                looping = false
            }
        }
    },
    ['character-attack-right'] = { --Effect
        width = 32,
        height = 16,
        animations = {
            ['default'] = {
                frames = {1, 2, 3, 4, 5},
                interval = 0.1,
                texture = 'character-attack-horizontal',
                looping = false
            }
        }
    },
    ['character-attack-left'] = { --Effect
        width = 32,
        height = 16,
        animations = {
            ['default'] = {
                frames = {6, 7, 8, 9, 10},
                interval = 0.1,
                texture = 'character-attack-horizontal',
                looping = false
            }
        }
    },
    ['character-attack-up'] = { --Effect
        width = 16,
        height = 32,
        animations = {
            ['default'] = {
                frames = {1, 2, 3, 4, 5},
                interval = 0.1,
                texture = 'character-attack-vertical',
                looping = false
            }
        }
    },
    ['character-attack-down'] = { --Effect
        width = 16,
        height = 32,
        animations = {
            ['default'] = {
                frames = {6, 7, 8, 9, 10},
                interval = 0.1,
                texture = 'character-attack-vertical',
                looping = false
            }
        }
    },
    bush = {
        width = 16,
        height = 16,
        
        -- select random frame from bush_ids whitelist, then random row for variance
        frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
        collidable = false
    }
}
