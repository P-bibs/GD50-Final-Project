--[[
    
]]

--
-- libraries
--
Class = require 'lib/class'
push = require 'lib/push'
Timer = require 'lib/knife.timer'
Event = require 'lib/knife.event'

--
-- our own code
--

-- utility
require 'src/constants'
require 'src/StateMachine'
require 'src/Util'

-- game states
require 'src/states/BaseState'
require 'src/states/game/PlayState'
require 'src/states/game/StartState'
require 'src/states/game/GameOverState'
require 'src/states/game/BeginStageState'
require 'src/states/game/GameLoseState'

-- entity states
require 'src/states/entity/EntityMoveState'
require 'src/states/entity/EntityIdleState'
require 'src/states/entity/Player/PlayerAirState'
require 'src/states/entity/Player/PlayerGroundState'
require 'src/states/entity/BugEnemy/BugIdleState'
require 'src/states/entity/BugEnemy/BugMoveState'
require 'src/states/entity/DashEnemy/DashIdleState'
require 'src/states/entity/DashEnemy/DashMoveState'
require 'src/states/entity/BossEnemy/BossMoveState'
require 'src/states/entity/BossEnemy/BossIdleState'
require 'src/states/entity/BossEnemy/BossFireballState'
require 'src/states/entity/BossEnemy/BossStunState'

-- general
require 'src/Entity'
require 'src/Boss'
require 'src/Animation'
require 'src/Player'
require 'src/Hitbox'
require 'src/Healthbar'
require 'src/ComboTracker'

require 'src/GameObject'
require 'src/Effect'

require 'src/Stage'
require 'src/LevelFiller'
require 'src/Tile'
require 'src/TileMap'

require 'src/defs/entity_defs'
require 'src/defs/game-object-defs'
require 'src/defs/menu-defs'
require 'src/defs/level-defs'

--created using bfxr
gSounds = {
    ['player-jump'] = love.audio.newSource('sounds/PlayerJump.wav'),
    ['player-damaged'] = love.audio.newSource('sounds/PlayerHurt.wav'),
    ['menu-select'] = love.audio.newSource('sounds/MenuSelect.wav'),
    ['failed-hit'] = love.audio.newSource('sounds/FailedHit.wav'),
    ['enemy-hurt'] = love.audio.newSource('sounds/EnemyHurt.wav'),
    ['music'] = love.audio.newSource('sounds/music.wav'),
    ['boss-stun'] = love.audio.newSource('sounds/Boss-Stun.wav'),
    ['heal'] = love.audio.newSource('sounds/heal.wav')
}

--all textures not otherwise credited created by me using Piskel
gTextures = {
    ['hell-tiles'] = love.graphics.newImage('graphics/HellTiles.png'), --https://www.deviantart.com/neoz7/art/FREE-16x16-Tileset-511915116
    ['character-walk'] = love.graphics.newImage('graphics/CharacterWalk.png'),
    ['character-idle'] = love.graphics.newImage('graphics/CharacterIdle.png'),
    ['character-slide'] = love.graphics.newImage('graphics/CharacterSlide.png'),
    ['character-attack-horizontal'] = love.graphics.newImage('graphics/CharacterAttackHorizontal.png'),
    ['character-attack-vertical'] = love.graphics.newImage('graphics/CharacterAttackVertical.png'),
    ['character-dead'] = love.graphics.newImage('graphics/CharacterDead.png'),
    ['hit01'] = love.graphics.newImage('graphics/hit01.png'),
    ['fireballs'] = love.graphics.newImage('graphics/Fireballs.png'),
    ['bug'] = love.graphics.newImage('graphics/Bug.png'),
    ['dash-enemy'] = love.graphics.newImage('graphics/DashEnemy.png'),
    ['boss-walk'] = love.graphics.newImage('graphics/BossEnemy.png'),
    ['boss-mouth-open'] = love.graphics.newImage('graphics/BossMouthOpen.png'),
    ['boss-stun'] = love.graphics.newImage('graphics/BossStun.png'),
    ['dust'] = love.graphics.newImage('graphics/Dust.png'),
    ['error'] = love.graphics.newImage('graphics/Error.png'),
    ['background'] = love.graphics.newImage('graphics/HellBackground.png'), --https://forums.terraria.org/index.php?threads/terraria-desktop-wallpapers.12644/page-4
    ['win-background'] = love.graphics.newImage('graphics/WinBackground.png'), --https://opengameart.org/content/background-scene
    ['hurt-vignette'] = love.graphics.newImage('graphics/HurtVignette.png')
}

gFrames = {
    ['hell-tiles'] = GenerateQuads(gTextures['hell-tiles'], TILE_SIZE, TILE_SIZE),

    ['character-walk'] = GenerateQuads(gTextures['character-walk'], 16, 16),
    ['character-idle'] = GenerateQuads(gTextures['character-idle'], 16, 16),
    ['character-slide'] = GenerateQuads(gTextures['character-slide'], 16, 16),
    ['character-attack-horizontal'] = GenerateQuads(gTextures['character-attack-horizontal'], 32, 16),
    ['character-attack-vertical'] = GenerateQuads(gTextures['character-attack-vertical'], 16, 32),
    ['character-dead'] = GenerateQuads(gTextures['character-dead'], 16, 16),
    ['hit01'] = GenerateQuads(gTextures['hit01'], 16, 16),
    ['fireballs'] = GenerateQuads(gTextures['fireballs'], 16, 16),
    ['bug'] = GenerateQuads(gTextures['bug'], 24, 20),
    ['dash-enemy'] = GenerateQuads(gTextures['dash-enemy'], 24, 24),
    ['boss-walk'] = GenerateQuads(gTextures['boss-walk'], 256, 256),
    ['boss-mouth-open'] = GenerateQuads(gTextures['boss-mouth-open'], 256, 256),
    ['boss-stun'] = GenerateQuads(gTextures['boss-stun'], 256, 256),
    ['dust'] = GenerateQuads(gTextures['dust'], 16, 16),
    ['error'] = GenerateQuads(gTextures['error'], 16, 16)
    
}

gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32),
    ['title'] = love.graphics.newFont('fonts/ArcadeAlternate.ttf', 32)
}