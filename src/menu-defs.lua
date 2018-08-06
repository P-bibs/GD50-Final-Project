--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

MENU_DEFS = {
    ['primary'] = {
        text = 'Super Beat Up',
        type = 'title',
        options = {
            {
                text = 'Play',
                action = 'play',
                param = {1}
            },
            {
                text = 'Level Select',
                action = 'level-select'
            },
            {
                text = 'How to Play',
                action = 'how-to'
            },
            {
                text = 'Quit Game',
                action = 'quit'
            }
        }
    },
    ['how-to'] = {
        text = HOW_TO_TEXT,
        type = 'paragraph',
        options = {
            {
                text = 'Go Back',
                action = 'primary'
            }
        }
    },
    ['level-select'] = {
        text = 'Select a level to play',
        type = 'Title',
        options = {
            {
                text = '1 - Easy',
                action = 'play',
                param = {level = 1}
            },
            {
                text = '2 - Harder',
                action = 'play',
                param = {level = 2}
            },
            {
                text = '3 - Boss',
                action = 'play',
                param = {level = 3}
            }
        }
    }
}