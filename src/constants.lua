--[[
    
]]

-- size of our actual window
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- size we're trying to emulate with push
VIRTUAL_WIDTH = 640
VIRTUAL_HEIGHT = 360

-- global standard tile size
TILE_SIZE = 16

-- width and height of screen in tiles
SCREEN_TILE_WIDTH = VIRTUAL_WIDTH / TILE_SIZE
SCREEN_TILE_HEIGHT = VIRTUAL_HEIGHT / TILE_SIZE

-- camera scrolling speed
CAMERA_SPEED = 100

-- player walking speed
PLAYER_WALK_SPEED = 10

-- player jumping velocity
PLAYER_JUMP_VELOCITY = 500

--
-- tile IDs
--
TILE_ID_EMPTY = 40
TILE_ID_GROUND = 362

TILE_ID_TOP = 326

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

BUG_ALERT_DISTANCE = 200

FREEZE_DURATION = 0.1

KNOCKBACK = 100

HOW_TO_TEXT = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam molestie, tellus eget eleifend volutpat, lacus sapien porttitor velit, ut fermentum urna tortor vel tellus. Nullam in bibendum felis. Morbi vel arcu vel turpis convallis imperdiet auctor vitae odio. Donec interdum mi risus, sed tempus odio laoreet sed. Nunc ultricies odio massa, aliquam lobortis nulla vehicula at. Etiam sem neque, semper ac mi pretium, viverra bibendum lorem. Curabitur et fermentum dolor, et molestie nisl. Sed luctus sagittis ipsum sit amet pellentesque. Quisque viverra felis a imperdiet dapibus. Morbi malesuada iaculis nulla, quis finibus elit laoreet vitae. In eu urna porttitor, dapibus.'

PLAYER_MAX_JUMPS = 100

LEVEL_DEFS = {
    [1] = {
        height = 1500,
        boss = false
    },
    [2] = {
        height = 3000,
        boss = false
    },
    [3] = {
        height = 6000,
        boss = true
    }

}