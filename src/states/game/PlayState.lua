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
    self.level = LevelFiller.generate(100, 20)
    self.tileMap = self.level.tileMap
    self.background = math.random(3)
    self.backgroundX = 0

    self.gravityOn = true
    self.gravityAmount = 6

    self.player = Player({
        width = ENTITY_DEFS['player'].width,
        height = ENTITY_DEFS['player'].height,
        animations = ENTITY_DEFS['player'].animations,
        level = self.level,
        stateMachine = StateMachine {
            ['ground'] = function() return PlayerGroundState(self.player) end,
            ['air'] = function() return PlayerAirState(self.player, self.gravityAmount) end
        },
        map = self.tileMap,
        level = self.level},
        0, 0
        )

    --give each entity a reference to the player
    for i = 1, #self.level.entities do
        self.level.entities[i].player = self.player
    end

    self.player.level = self.level

    self.player:changeState('air')

    self.cameraX = 0
    self.cameraVX = 0
    self.cameraAX = 0
    self.cameraY = 0
    self.cameraVY = 0
    self.cameraAY = 0
    self.K = 2.5
    self.damping = 50

    Timer.every(4, function()
        local enemyType = math.random(2) == 1 and 'bug' or 'dash'
        index = #self.level.entities + 1
        table.insert(self.level.entities, Entity({
            entityType = enemyType,
            animations = ENTITY_DEFS[enemyType].animations,
            speed = ENTITY_DEFS[enemyType].speed,
            health = ENTITY_DEFS[enemyType].health,
            width = ENTITY_DEFS[enemyType].width,
            height = ENTITY_DEFS[enemyType].height,
            player = self.player,

            stateMachine = enemyType == 'bug' and 
                StateMachine {
                    ['move'] = function() return BugMoveState() end,
                    ['idle'] = function() return BugIdleState() end
                }
                or
                StateMachine {
                    ['move'] = function() return DashMoveState() end,
                    ['idle'] = function() return DashIdleState() end
                }
        },
        math.random(self.player.x - 100, self.player.x + 100), 
        math.random(self.player.y - 100, self.player.y + 100)
        )
        )

        self.level.entities[index]:changeState('idle', {entity = self.level.entities[index]})
    end
    )
end

function PlayState:update(dt)
    if love.keyboard.wasPressed('g') then
        local enemyType = 'boss'
        table.insert(self.level.entities, Boss({
            entityType = enemyType,
            animations = ENTITY_DEFS[enemyType].animations,
            speed = ENTITY_DEFS[enemyType].speed,
            health = ENTITY_DEFS[enemyType].health,
            width = ENTITY_DEFS[enemyType].width,
            height = ENTITY_DEFS[enemyType].height,
            player = self.player,

            stateMachine = 
                StateMachine {
                    ['move'] = function() return BossMoveState() end,
                    ['idle'] = function() return BossIdleState() end
                }
        },
        VIRTUAL_WIDTH / 2,
        -200
        )
        )

        self.level.entities[#self.level.entities]:changeState('move', {entity = self.level.entities[#self.level.entities]})
    end

    Timer.update(dt)

    -- remove any nils from pickups, etc.
    self.level:clear()

    -- update player and level
    self.player:update(dt)
    self.level:update(dt)
    self:updateCamera(dt)

    -- constrain player X no matter which state
    if self.player.x <= 0 then
        self.player.x = 0
    elseif self.player.x > TILE_SIZE * self.tileMap.width - self.player.width then
        self.player.x = TILE_SIZE * self.tileMap.width - self.player.width
    end
end

function PlayState:render()
    --draw the parallax background
    love.graphics.draw(gTextures['background'],
        -(self.player.x / 1584) *  (1584 - VIRTUAL_WIDTH),
        (1 - (-self.player.y / 3000)) * (VIRTUAL_HEIGHT - 630)
        )

    love.graphics.push()

    -- translate the entire view of the scene to emulate a camera
    love.graphics.translate(-math.floor(self.cameraX), -math.floor(self.cameraY))
    
    self.level:render()

    self.player:render()
    love.graphics.pop()
    
    -- render score
    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.print(tostring(-math.min(0, math.floor(self.player.y))), 5, 5)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print(tostring(-math.min(0, math.floor(self.player.y))), 4, 4)

    -- love.graphics.print(tostring(self.player.ax), 5, 20)
    -- love.graphics.print(tostring(self.player.vx), 5, 35)
    -- love.graphics.print(tostring(0), 5, 50)
    -- love.graphics.print(tostring(0), 5, 65)

end

function PlayState:updateCamera(dt)
    -- clamp movement of the camera's X between 0 and the map bounds - virtual width,
    -- setting it half the screen to the left of the player so they are in the center
    self.camX = math.max(0,
        math.min(TILE_SIZE * self.tileMap.width - VIRTUAL_WIDTH,
        self.player.x - (VIRTUAL_WIDTH / 2 - 8)))

    -- adjust background X to move a third the rate of the camera for parallax
    self.backgroundX = (self.camX / 3) % 256

    self.cameraXEquilibrium = self.player.x - (VIRTUAL_WIDTH / 2) + (self.player.width / 2)
    self.cameraXEquilibrium = math.max(0,
        math.min(TILE_SIZE * self.tileMap.width - VIRTUAL_WIDTH,
        self.player.x - (VIRTUAL_WIDTH / 2 - 8)))
    self.cameraAX = ((self.K * (self.cameraXEquilibrium - self.cameraX)) - (self.damping * self.cameraVX)) * dt
    self.cameraVX = self.cameraVX + self.cameraAX
    self.cameraX = self.cameraX + self.cameraVX 
    self.cameraX = math.max(0, self.cameraX)

    self.cameraYEquilibrium = self.player.y - (VIRTUAL_HEIGHT / 2) + (self.player.height / 2)
    self.cameraAY = ((self.K*2 * (self.cameraYEquilibrium - self.cameraY)) - (self.damping * self.cameraVY)) * dt
    self.cameraVY = self.cameraVY + self.cameraAY
    self.cameraY = self.cameraY + self.cameraVY 
end