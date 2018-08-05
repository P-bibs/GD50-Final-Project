--[[
    GD50
    Super Mario Bros. Remake

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    -- Dependencies --

    A file to organize all of the global dependencies for our project, as
    well as the assets for our game, rather than pollute our main.lua file.
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

-- entity states
require 'src/states/entity/PlayerAirState'
require 'src/states/entity/PlayerGroundState'
require 'src/states/entity/EntityMoveState'
require 'src/states/entity/EntityIdleState'
require 'src/states/entity/BugEnemy/BugIdleState'
require 'src/states/entity/BugEnemy/BugMoveState'
require 'src/states/entity/DashEnemy/DashIdleState'
require 'src/states/entity/DashEnemy/DashMoveState'
require 'src/states/entity/BossEnemy/BossMoveState'
require 'src/states/entity/BossEnemy/BossIdleState'

-- general
require 'src/Animation'
require 'src/Entity'
require 'src/GameObject'
require 'src/Effect'
require 'src/GameLevel'
require 'src/LevelFiller'
require 'src/Player'
require 'src/Hitbox'
require 'src/Boss'

require 'src/Tile'
require 'src/TileMap'
require 'src/entity_defs'
require 'src/game-objects'

gSounds = {
    ['jump'] = love.audio.newSource('sounds/jump.wav'),
    ['death'] = love.audio.newSource('sounds/death.wav'),
    ['music'] = love.audio.newSource('sounds/music.wav'),
    ['pickup'] = love.audio.newSource('sounds/pickup.wav'),
    ['kill'] = love.audio.newSource('sounds/kill.wav'),
    ['kill2'] = love.audio.newSource('sounds/kill2.wav')
}

gTextures = {
    ['tiles'] = love.graphics.newImage('graphics/tiles.png'),
    ['hell-tiles'] = love.graphics.newImage('graphics/HellTiles.png'), --https://www.deviantart.com/neoz7/art/FREE-16x16-Tileset-511915116
    ['toppers'] = love.graphics.newImage('graphics/tile_tops.png'),
    ['bushes'] = love.graphics.newImage('graphics/bushes_and_cacti.png'),
    ['backgrounds'] = love.graphics.newImage('graphics/backgrounds.png'),
    ['character-walk'] = love.graphics.newImage('graphics/CharacterWalk.png'),
    ['character-idle'] = love.graphics.newImage('graphics/CharacterIdle.png'),
    ['character-slide'] = love.graphics.newImage('graphics/CharacterSlide.png'),
    ['character-attack-horizontal'] = love.graphics.newImage('graphics/CharacterAttackHorizontal.png'),
    ['character-attack-vertical'] = love.graphics.newImage('graphics/CharacterAttackVertical.png'),
    ['hit01'] = love.graphics.newImage('graphics/hit01.png'),
    ['hit03'] = love.graphics.newImage('graphics/hit03.png'),
    ['bug'] = love.graphics.newImage('graphics/Bug.png'),
    ['dash-enemy'] = love.graphics.newImage('graphics/DashEnemy.png'),
    ['boss-walk'] = love.graphics.newImage('graphics/BossEnemy.png'),
    ['dust'] = love.graphics.newImage('graphics/Dust.png'),
    ['error'] = love.graphics.newImage('graphics/Error.png'),
    ['background'] = love.graphics.newImage('graphics/HellBackground.png') --https://forums.terraria.org/index.php?threads/terraria-desktop-wallpapers.12644/page-4
    
}

gFrames = {
    ['tiles'] = GenerateQuads(gTextures['tiles'], TILE_SIZE, TILE_SIZE),
    ['hell-tiles'] = GenerateQuads(gTextures['hell-tiles'], TILE_SIZE, TILE_SIZE),
    
    ['toppers'] = GenerateQuads(gTextures['toppers'], TILE_SIZE, TILE_SIZE),
    
    ['bushes'] = GenerateQuads(gTextures['bushes'], 16, 16),
    ['backgrounds'] = GenerateQuads(gTextures['backgrounds'], 256, 128),
    ['character-walk'] = GenerateQuads(gTextures['character-walk'], 16, 16),
    ['character-idle'] = GenerateQuads(gTextures['character-idle'], 16, 16),
    ['character-slide'] = GenerateQuads(gTextures['character-slide'], 16, 16),
    ['character-attack-horizontal'] = GenerateQuads(gTextures['character-attack-horizontal'], 32, 16),
    ['character-attack-vertical'] = GenerateQuads(gTextures['character-attack-vertical'], 16, 32),
    ['hit01'] = GenerateQuads(gTextures['hit01'], 16, 16),
    ['hit03'] = GenerateQuads(gTextures['hit03'], 64, 64),
    ['bug'] = GenerateQuads(gTextures['bug'], 24, 20),
    ['dash-enemy'] = GenerateQuads(gTextures['dash-enemy'], 24, 24),
    ['boss-walk'] = GenerateQuads(gTextures['boss-walk'], 256, 256),
    ['dust'] = GenerateQuads(gTextures['dust'], 16, 16),
    ['error'] = GenerateQuads(gTextures['error'], 16, 16)
    
}

-- these need to be added after gFrames is initialized because they refer to gFrames from within
gFrames['tilesets'] = GenerateTileSets(gFrames['tiles'], 
    TILE_SETS_WIDE, TILE_SETS_TALL, TILE_SET_WIDTH, TILE_SET_HEIGHT)

gFrames['toppersets'] = GenerateTileSets(gFrames['toppers'], 
    TOPPER_SETS_WIDE, TOPPER_SETS_TALL, TILE_SET_WIDTH, TILE_SET_HEIGHT)

gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32),
    ['title'] = love.graphics.newFont('fonts/ArcadeAlternate.ttf', 32)
}