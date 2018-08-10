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
                param = {level = 1}
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
                text = 'Leaderboard',
                action = 'leaderboard'
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
        type = 'title',
        options = {
            {
                text = '1 - Easy',
                action = 'play',
                param = {level = 1}
            },
            {
                text = '????????',
                action = ''
            },
            {
                text = '????????',
                action = ''
            },
            {
                text = 'Go Back',
                action = 'primary'
            }
        }
    },
    ['leaderboard'] = {
        text = 'Top Times for Levels 1, 2 & 3',
        type = 'title',
        options = {
            {
                text = 'Level 1 - Not Yet Set',
                action = ''
            },
            {
                text = 'Level 2 - Not Yet Set',
                action = ''
            },
            {
                text = 'Level 3 - Not Yet Set',
                action = ''
            },
            {
                text = 'Go Back',
                action = 'primary'
            }
        }
    }
}
--list of all numbers. These are loaded into the main table as they are unlocked
LEVELS = {
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