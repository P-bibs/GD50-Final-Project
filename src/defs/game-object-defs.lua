--[[
    data driven table of Game objects and effects
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
    ['character-attack-right'] = {
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
    ['character-attack-left'] = {
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
    ['character-attack-up'] = {
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
    ['character-attack-down'] = {
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
    ['hit-effect'] = {
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
    },
    ['fireball'] = {
        width = 16,
        height = 16,
        speed = 120,
        animations = {
            ['red'] = {
                frames = {1, 2, 3, 4},
                interval = 0.1,
                texture = 'fireballs',
                looping = true
            },
            ['blue'] = {
                frames = {13 ,14, 15, 16},
                interval = 0.1,
                texture = 'fireballs',
                looping = true
            }
        }
    }
}
