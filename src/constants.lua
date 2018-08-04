--[[
    GD50
    Super Mario Bros. Remake

    -- constants --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Some global constants for our application.
]]

-- size of our actual window
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- size we're trying to emulate with push
VIRTUAL_WIDTH = 320
VIRTUAL_HEIGHT = 180

-- global standard tile size
TILE_SIZE = 16

-- width and height of screen in tiles
SCREEN_TILE_WIDTH = VIRTUAL_WIDTH / TILE_SIZE
SCREEN_TILE_HEIGHT = VIRTUAL_HEIGHT / TILE_SIZE

-- camera scrolling speed
CAMERA_SPEED = 100

-- speed of scrolling background
BACKGROUND_SCROLL_SPEED = 10

-- number of tiles in each tile set
TILE_SET_WIDTH = 5
TILE_SET_HEIGHT = 4

-- number of tile sets in sheet
TILE_SETS_WIDE = 6
TILE_SETS_TALL = 10

-- number of topper sets in sheet
TOPPER_SETS_WIDE = 6
TOPPER_SETS_TALL = 18

-- total number of topper and tile sets
TOPPER_SETS = TOPPER_SETS_WIDE * TOPPER_SETS_TALL
TILE_SETS = TILE_SETS_WIDE * TILE_SETS_TALL

-- player walking speed
PLAYER_WALK_SPEED = 10

-- player jumping velocity
PLAYER_JUMP_VELOCITY = 200

--
-- tile IDs
--
TILE_ID_EMPTY = 5
TILE_ID_GROUND = 3

-- table of tiles that should trigger a collision
COLLIDABLE_TILES = {
    TILE_ID_GROUND
}

--
-- game object IDs
--
BUSH_IDS = {
    1, 2, 5, 6, 7
}

COIN_IDS = {
    1, 2, 3
}

GEMS = {
    1, 2, 3, 4, 5, 6, 7, 8
}

POLES = {
    1, 2, 3, 4, 5, 6
}

ERROR_ANIM = {
    ['error'] = {
    frames = {1},
    interval = 1,
    texture = 'error'
    }
}

--Keybinds

KEY_MOVE_LEFT = 'a'
KEY_MOVE_RIGHT = 'd'
KEY_JUMP = 'w'
KEY_ATTACK_RIGHT = 'right' 
KEY_ATTACK_LEFT = 'left'
KEY_ATTACK_UP = 'up'
KEY_ATTACK_DOWN = 'down'

PI = math.pi