--[[
    GD50
    Super Mario Bros. Remake

    -- PlayState Class --
]]

PlayState = Class{__includes = BaseState}

function PlayState:enter(def)
    self.camX = 0
    self.camY = 0
    --set width based on what level you are on
    self.level = LevelMaker.generate(100 + (def and def[1] or 0) * 10, 10)
    self.tileMap = self.level.tileMap
    self.background = math.random(3)
    self.backgroundX = 0

    self.gravityOn = true
    self.gravityAmount = 6

    self.player = Player({
        x = 0, y = 0,
        width = 16, height = 15,
        stateMachine = StateMachine {
            --['idle'] = function() return PlayerIdleState(self.player) end,
            ['ground'] = function() return PlayerGroundState(self.player) end,
            --['walking'] = function() return PlayerWalkingState(self.player) end,
            --['jump'] = function() return PlayerJumpState(self.player, self.gravityAmount) end,
            ['air'] = function() return PlayerAirState(self.player, self.gravityAmount) end
        },
        animations = ENTITY_DEFS['player'].animations,
        
        map = self.tileMap,
        level = self.level
    },
    --pass the score from the previous level
    def and def[2] or 0)

    self.player.level = self.level
    
    self.player.hasKey = false

    self.player:changeState('air')

    self.cameraX = 0
    self.cameraVX = 0
    self.cameraAX = 0
    self.cameraY = 0
    self.cameraVY = 0
    self.cameraAY = 0
    self.K = 2.5
    self.damping = 50
end

function PlayState:update(dt)
    Timer.update(dt)

    -- remove any nils from pickups, etc.
    self.level:clear()

    -- update player and level
    self.player:update(dt)
    self.level:update(dt)
    self:updateCamera()

    -- constrain player X no matter which state
    if self.player.x <= 0 then
        self.player.x = 0
    elseif self.player.x > TILE_SIZE * self.tileMap.width - self.player.width then
        self.player.x = TILE_SIZE * self.tileMap.width - self.player.width
    end

    self.cameraXEquilibrium = self.player.x - (VIRTUAL_WIDTH / 2) + (self.player.width / 2)
    self.cameraXEquilibrium = math.max(0,
        math.min(TILE_SIZE * self.tileMap.width - VIRTUAL_WIDTH,
        self.player.x - (VIRTUAL_WIDTH / 2 - 8)))
    self.cameraAX = ((self.K * (self.cameraXEquilibrium - self.cameraX)) - (self.damping * self.cameraVX)) * dt
    self.cameraVX = self.cameraVX + self.cameraAX
    self.cameraX = self.cameraX + self.cameraVX 
    self.cameraX = math.max(0, self.cameraX)

    self.cameraYEquilibrium = self.player.y - (VIRTUAL_HEIGHT / 2) + (self.player.height / 2)
    --self.cameraYEquilibrium = math.max(0,
    --    math.min(TILE_SIZE * self.tileMap.height - VIRTUAL_HEIGHT,
    --    self.player.y - (VIRTUAL_HEIGHT / 2 - 8)))
    self.cameraAY = ((self.K*2 * (self.cameraYEquilibrium - self.cameraY)) - (self.damping * self.cameraVY)) * dt
    self.cameraVY = self.cameraVY + self.cameraAY
    self.cameraY = self.cameraY + self.cameraVY 
    --self.cameraY = math.max(0, self.cameraY)
end

function PlayState:render()
    love.graphics.push()
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], math.floor(-self.backgroundX), 0)
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], math.floor(-self.backgroundX),
        gTextures['backgrounds']:getHeight() / 3 * 2, 0, 1, -1)
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], math.floor(-self.backgroundX + 256), 0)
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], math.floor(-self.backgroundX + 256),
        gTextures['backgrounds']:getHeight() / 3 * 2, 0, 1, -1)
    
    -- translate the entire view of the scene to emulate a camera
    love.graphics.translate(-math.floor(self.cameraX), -math.floor(self.cameraY))
    
    self.level:render()

    self.player:render()
    love.graphics.pop()
    
    -- render score
    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.print(tostring(self.player.score), 5, 5)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print(tostring(self.player.score), 4, 4)

    love.graphics.print(tostring(self.player.ax), 5, 20)
    love.graphics.print(tostring(self.player.vx), 5, 35)
    love.graphics.print(tostring(0), 5, 50)
    love.graphics.print(tostring(0), 5, 65)

    --render key info
    if self.player.hasKey then
        love.graphics.setColor(0, 0, 0, 255)
        love.graphics.print('key', 45, 5)
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.print('key', 44, 4)
    end
end

function PlayState:updateCamera()

    -- clamp movement of the camera's X between 0 and the map bounds - virtual width,
    -- setting it half the screen to the left of the player so they are in the center
    self.camX = math.max(0,
        math.min(TILE_SIZE * self.tileMap.width - VIRTUAL_WIDTH,
        self.player.x - (VIRTUAL_WIDTH / 2 - 8)))

    -- adjust background X to move a third the rate of the camera for parallax
    self.backgroundX = (self.camX / 3) % 256
end