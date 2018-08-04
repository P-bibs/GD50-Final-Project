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
                interval = 0.05,
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
                interval = 0.05,
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
                interval = 0.05,
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
                interval = 0.05,
                texture = 'character-attack-vertical',
                looping = false
            }
        }
    },
    ['hit-effect'] = { --Effect
        width = 16,
        height = 16,
        animations = {
            ['hit03'] = {
                frames = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10},
                interval = 0.05,
                texture = 'hit03',
                looping = false
            },
            ['hit01'] = {
                frames = {1, 2, 3, 4, 5},
                interval = 0.05,
                texture = 'hit01',
                looping = false
            }
        }
    }
}
