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

-- player acceleration speed
PLAYER_WALK_SPEED = 10

-- player jumping velocity
PLAYER_JUMP_VELOCITY = 200

--
-- tile IDs
--
TILE_ID_EMPTY = 40
TILE_ID_GROUND = 362
TILE_ID_TOP = 326

--texture used if an object is instantiated with a nil texture
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

--how close the player has to get to a bug enemy before they will leave idle state
BUG_ALERT_DISTANCE = 200

--how long enemies and the player freeze when hit
FREEZE_DURATION = 0.1

--the max number of jumps the player can have at once
PLAYER_MAX_JUMPS = 6

KNOCKBACK = 100

HOW_TO_TEXT1 = [[Welcome to Super Beat Up! You are trapped at the bottom of a hellish land, and the only tool you have to escape is your considerable jumping ability and a feisty punch.
To progress, you must advance upward, but you're 6 jumps will only get you so far. To make real progress, you'll have to vanquish baddies, which will refill you jump meter and allow you to continue. Be careful though, missed swings will cost you a jump as well. If you are overcome by one of the many monsters you wil encounter, your number of jumps will be limited. Get a combo of hits to repair your jumping ability to full form!]]

HOW_TO_TEXT2 = [[Attempt to make youre way through 2 challenging levels of ascent through harrowing pits, and then pit yourself against a new foe in level 3. To best him, you will have to be creative in your fighting tactics. (Maybe there is a way to stun him?). Once you have completed every level, try to do them again, but faster! You're fastest times are recorded on the leaderboard. Now go! Adventure!]]

--Number of fireballs the boss shoots
NUMBER_FIREBALLS = 8