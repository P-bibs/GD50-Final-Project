--[[
    Represents object and effects in game
]]

GameObject = Class{}

function GameObject:init(def, x, y)
    self.x = x
    self.y = y

    --most gameobjects don't move. Only have velocity if explicitly set
    self.vx = 0
    self.vy = 0


    self.width = def.width
    self.height = def.height

    --this flag only used for fireballs
    self.reflected = false

    --flag used to see if gameobject should be removed
    self.dead = false

    self.animations = def.animations == nil and self:createAnimations(ERROR_ANIM) or self:createAnimations(def.animations)

    self.frozen = false
end

function GameObject:createAnimations(animations)
    local animationsReturned = {}

    for k, animationDef in pairs(animations) do
        animationsReturned[k] = Animation {
            texture = animationDef.texture,
            frames = animationDef.frames,
            interval = animationDef.interval,
            looping = animationDef.looping
        }
        self.currentAnimation = animationsReturned[k]
    end

    return animationsReturned
end

function GameObject:collides(target)
    return not (target.x > self.x + self.width or self.x > target.x + target.width or
            target.y > self.y + self.height or self.y > target.y + target.height)
end

function GameObject:update(dt)
    --update position
    if not self.frozen then
        self.x = self.x + self.vx * dt
        self.y = self.y - self.vy * dt
    end

    if self.currentAnimation then
        self.currentAnimation:update(dt)
    end

    if self.currentAnimation.looping == false and self.currentAnimation.timesPlayed > 0 then
        self.dead = true
    end
end

function GameObject:changeAnimation(name)
    self.currentAnimation = self.animations[name]
end

--temporarily freeze position of game object
function GameObject:freeze(duration)
    self.frozen = true
    Timer.after(duration, function() self.frozen = false end)
end

function GameObject:render()
    if self.currentAnimation then
        love.graphics.draw(gTextures[self.currentAnimation.texture], gFrames[self.currentAnimation.texture][self.currentAnimation:getCurrentFrame()],
            self.x, self.y)
    end
end