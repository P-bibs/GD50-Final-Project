--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

EntityChaseState = Class{__includes = BaseState}

function EntityChaseState:init(entity)
    self.entity = entity
    self.entity:changeAnimation('idle')

    -- used for AI control
    self.moveDuration = 0
    self.movementTimer = 0

    -- keeps track of whether we just hit a wall
    self.bumped = false
end

function EntityChaseState:update(dt)
    if self.entity.x > self.entity.player.x then
        self.entity.vx = -self.entity.speed
    elseif self.entity.x < self.entity.player.x then
        self.entity.vx = self.entity.speed
    end

    if self.entity.y > self.entity.player.y then
        self.entity.vy = self.entity.speed * .5
    elseif self.entity.y < self.entity.player.y then
        self.entity.vy = -self.entity.speed * .5
    end


    self.entity.vx = self.entity.vx + self.entity.ax
    self.entity.x = self.entity.x + self.entity.vx * dt

    self.entity.vy = self.entity.vy + self.entity.ay
    self.entity.y = self.entity.y - self.entity.vy * dt
end

function EntityChaseState:processAI(params, dt)
    local room = params.room
    local directions = {'left', 'right', 'up', 'down'}

    if self.moveDuration == 0 or self.bumped then
        
        -- set an initial move duration and direction
        self.moveDuration = math.random(5)
        self.entity.direction = directions[math.random(#directions)]
        self.entity:changeAnimation('walk-' .. tostring(self.entity.direction))
    elseif self.movementTimer > self.moveDuration then
        self.movementTimer = 0

        -- chance to go idle
        if math.random(3) == 1 then
            self.entity:changeState('idle')
        else
            self.moveDuration = math.random(5)
            self.entity.direction = directions[math.random(#directions)]
            self.entity:changeAnimation('walk-' .. tostring(self.entity.direction))
        end
    end

    self.movementTimer = self.movementTimer + dt
end

function EntityChaseState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x - self.entity.offsetX), math.floor(self.entity.y - self.entity.offsetY))
    
    -- debug code
    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.entity.x, self.entity.y, self.entity.width, self.entity.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end