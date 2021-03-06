--[[
    data driven table of entities in the game
]]

ENTITY_DEFS = {
    ['player'] = {
        speed = PLAYER_WALK_SPEED,
        width = 16,
        height = 16,
        animations = {
            ['walk-right'] = {
                frames = {1, 2, 3, 4},
                interval = 0.155,
                texture = 'character-walk'
            },
            ['walk-left'] = {
                frames = {5, 6, 7, 8},
                interval = 0.15,
                texture = 'character-walk'
            },
            ['idle'] = {
                frames = {1, 2},
                interval = 0.3,
                texture = 'character-idle'
            },
            ['slide-right'] = {
                frames = {1},
                interval = 0.3,
                texture = 'character-slide'
            },
            ['slide-left'] = {
                frames = {2},
                interval = 0.3,
                texture = 'character-slide'
            },
            ['dead'] = {
                frames = {1},
                interval = 1,
                texture = 'character-dead'
            }
        }
    },
    ['bug'] = {
        speed = 5,
        height = 20,
        width = 24,
        health = 2,
        animations = {
            ['idle'] = {
                frames = {1, 2, 3, 4, 5, 6, 7},
                interval = 0.1,
                texture = 'bug'
            }
        }
    },
    ['dash'] = {
        speed = 350,
        height = 24,
        width = 24,
        health = 2,
        animations = {
            ['idle'] = {
                frames = {1, 2, 3, 4, 5, 6, 7, 8, 9},
                interval = 0.1,
                texture = 'dash-enemy'
            },
            ['dash'] = {
                frames = {10},
                interval = 0.1,
                texture = 'dash-enemy'
            }
        }
    },
    ['boss'] = {
        speed = 60,
        height = 256,
        width = 256,
        health = 20,
        name = 'Marauder of the Deep',
        animations = {
            ['idle'] = {
                frames = {1, 2},
                interval = 1,
                texture = 'boss-walk'
            },
            ['walk'] = {
                frames = {1, 2, 3, 4, 5, 6, 7, 8},
                interval = 0.1,
                texture = 'boss-walk'
            },
            ['stun'] = {
                frames = {1, 2, 3, 4, 5, 6},
                interval = 0.1,
                texture = 'boss-stun'
            },
            ['mouth-open'] = {
                frames = {1, 2},
                interval = 0.1,
                texture = 'boss-mouth-open'
            }
        }
    }
}