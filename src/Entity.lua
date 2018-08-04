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

    self.direction = 'left'

    -- reference to tile map so we can check collisions
    self.map = def.map

    self.player = def.player

    self.level = def.level

    self.effects = {}

    self.animations = self:createAnimations(def.animations)
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

    if self.currentAnimation then
        self.currentAnimation:update(dt)
    end
end

function Entity:collides(entity)
    return not (self.x > entity.x + entity.width or entity.x > self.x + self.width or
                self.y > entity.y + entity.height or entity.y > self.y + self.height)
end

function Entity:render()
    for i = 1, #self.effects do
        self.effects[i]:render()
    end

    self.stateMachine:render()

    --love.graphics.draw(gTextures[self.currentAnimation.texture], gFrames[self.currentAnimation.texture][self.currentAnimation:getCurrentFrame()],
    --    math.floor(self.x) + 8, math.floor(self.y) + 10, 0, 1, 1, 8, 10)
end