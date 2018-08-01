--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

ENTITY_DEFS = {
    ['player'] = {
        walkSpeed = PLAYER_WALK_SPEED,
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
            }
        }
    }
}