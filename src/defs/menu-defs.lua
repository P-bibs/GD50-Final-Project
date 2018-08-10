--[[
    table of data for the main menu items
    data driven system allows easy additions to menu
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
                action = 'how-to-1'
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
    ['how-to-1'] = {
        text = HOW_TO_TEXT1,
        type = 'paragraph',
        options = {
            {
                text = 'Next',
                action = 'how-to-2'
            },
            {
                text = 'Go Back',
                action = 'primary'
            }
        }
    },
    ['how-to-2'] = {
        text = HOW_TO_TEXT2,
        type = 'paragraph',
        options = {
            {
                text = 'Previous',
                action = 'how-to-1'
            },
            {
                text = 'Go Back',
                action = 'primary'
            }
        }
    },
    ['level-select'] = {
        text = 'Select a level to play\n(Press k to unlock all levels)',
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