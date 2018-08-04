--[[
    GD50
    Super Mario Bros. Remake

    -- Entity Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Entity = Class{}

function Entity:init(def, x, y)
    -- position
    self.x = x
    self.vx = 0
    self.ax = 0

    self.y = y
    self.vy = 0
    self.ay = 0

    -- dimensions
    self.width = def.width
    self.height = def.height

    self.speed = def.speed

    self.stateMachine = def.stateMachine

    self.entityType = def.entityType
    print(self.entityType)

    self.direction = 'left'

    self.health = def.health

    -- reference to tile map so we can check collisions
    self.map = def.map

    self.player = def.player

    self.level = def.level

    self.effects = {}

    self.animations = self:createAnimations(def.animations)

    self.dead = false
    
    self.frozen = false
end

function Entity:createAnimations(animations)
    local animationsReturned = {}

    for k, animationDef in pairs(animations) do
        animationsReturned[k] = Animation {
            texture = animationDef.texture,
            frames = animationDef.frames,
            interval = animationDef.interval
        }
        self.currentAnimation = animationsReturned[k]
    end

    return animationsReturned
end

function Entity:changeState(state, params)
    self.stateMachine:change(state, params)
end

function Entity:changeAnimation(name)
    self.currentAnimation = self.animations[name]
end

function Entity:update(dt)
    for i = 1, #self.effects do
        self.effects[i]:update(dt)
    end

    self.stateMachine:update(dt)

    self.vx = self.vx + self.ax
    self.vy = self.vy + self.ay

    if not self.frozen then 
        self.x = self.x + self.vx * dt
        self.y = self.y - self.vy * dt
    end

    if self.currentAnimation then
        self.currentAnimation:update(dt)
    end
end

function Entity:collides(entity)
    return not (self.x > entity.x + entity.width or entity.x > self.x + self.width or
                self.y > entity.y + entity.height or entity.y > self.y + self.height)
end

function Entity:damage(amount)
    self.health = self.health - amount

    if self.health < 1 then
        self.dead = true
    end
end

function Entity:render()
    for i = 1, #self.effects do
        self.effects[i]:render()
    end

    self.stateMachine:render()

    --DEBUG for velocy/acceleration values
    --love.graphics.print('ax: ' .. math.floor(self.ax), self.x, self.y + 10)
    --love.graphics.print('vx: ' .. math.floor(self.vx), self.x, self.y + 23)
    --love.graphics.print('ay: ' .. math.floor(self.ay), self.x, self.y + 36)
    --love.graphics.print('vy: ' .. math.floor(self.vy), self.x, self.y + 49)
    love.graphics.print('health: ' .. self.health, self.x, self.y + 62)
end

function Entity:freeze(duration)
    self.frozen = true
    Timer.after(duration, function() self.frozen = false end)
end