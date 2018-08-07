--[[
    
]]

--
-- libraries
--
Class = require 'lib/class'
push = require 'lib/push'
Timer = require 'lib/knife.timer'

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

-- general
require 'src/Entity'
require 'src/Boss'
require 'src/Animation'
require 'src/Player'
require 'src/Hitbox'
require 'src/Healthbar'

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
    ['player-hurt'] = love.audio.newSource('sounds/PlayerHurt.wav'),
    ['menu-select'] = love.audio.newSource('sounds/MenuSelect.wav'),
    ['failed-hit'] = love.audio.newSource('sounds/FailedHit.wav'),
    ['enemy-hurt'] = love.audio.newSource('sounds/EnemyHurt.wav'),
    ['music'] = love.audio.newSource('sounds/music.wav')
}

--all textures not otherwise credited created by me using Piskel
gTextures = {
    ['hell-tiles'] = love.graphics.newImage('graphics/HellTiles.png'), --https://www.deviantart.com/neoz7/art/FREE-16x16-Tileset-511915116
    ['character-walk'] = love.graphics.newImage('graphics/CharacterWalk.png'),
    ['character-idle'] = love.graphics.newImage('graphics/CharacterIdle.png'),
    ['character-slide'] = love.graphics.newImage('graphics/CharacterSlide.png'),
    ['character-attack-horizontal'] = love.graphics.newImage('graphics/CharacterAttackHorizontal.png'),
    ['character-attack-vertical'] = love.graphics.newImage('graphics/CharacterAttackVertical.png'),
    ['hit01'] = love.graphics.newImage('graphics/hit01.png'),
    ['bug'] = love.graphics.newImage('graphics/Bug.png'),
    ['dash-enemy'] = love.graphics.newImage('graphics/DashEnemy.png'),
    ['boss-walk'] = love.graphics.newImage('graphics/BossEnemy.png'),
    ['dust'] = love.graphics.newImage('graphics/Dust.png'),
    ['error'] = love.graphics.newImage('graphics/Error.png'),
    ['background'] = love.graphics.newImage('graphics/HellBackground.png'), --https://forums.terraria.org/index.php?threads/terraria-desktop-wallpapers.12644/page-4
    ['hurt-vignette'] = love.graphics.newImage('graphics/HurtVignette.png')
}

gFrames = {
    ['hell-tiles'] = GenerateQuads(gTextures['hell-tiles'], TILE_SIZE, TILE_SIZE),

    ['character-walk'] = GenerateQuads(gTextures['character-walk'], 16, 16),
    ['character-idle'] = GenerateQuads(gTextures['character-idle'], 16, 16),
    ['character-slide'] = GenerateQuads(gTextures['character-slide'], 16, 16),
    ['character-attack-horizontal'] = GenerateQuads(gTextures['character-attack-horizontal'], 32, 16),
    ['character-attack-vertical'] = GenerateQuads(gTextures['character-attack-vertical'], 16, 32),
    ['hit01'] = GenerateQuads(gTextures['hit01'], 16, 16),
    ['bug'] = GenerateQuads(gTextures['bug'], 24, 20),
    ['dash-enemy'] = GenerateQuads(gTextures['dash-enemy'], 24, 24),
    ['boss-walk'] = GenerateQuads(gTextures['boss-walk'], 256, 256),
    ['dust'] = GenerateQuads(gTextures['dust'], 16, 16),
    ['error'] = GenerateQuads(gTextures['error'], 16, 16)
    
}

gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32),
    ['title'] = love.graphics.newFont('fonts/ArcadeAlternate.ttf', 32)
}