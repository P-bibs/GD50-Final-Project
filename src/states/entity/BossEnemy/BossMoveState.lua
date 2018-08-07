BossMoveState = Class {__includes = EntityMoveState}

function BossMoveState:enter(def)
    self.entity = def.entity
    self.entity:changeAnimation('walk')
    --walk for a bit, then shoot fireballs, giving the player a chance to attack
    Timer.after(4, function()
        self.entity.stateMachine:change('fireball', {entity = self.entity})
    end)
end

function BossMoveState:processAI(params, dt)
    if self.entity.x + self.entity.width / 3 > self.entity.player.x then
        self.entity.vx = -self.entity.speed
        self.entity.direction = 'left'
    elseif self.entity.x + self.entity.width * 2 / 3 < self.entity.player.x then
        self.entity.vx = self.entity.speed
        self.entity.direction = 'right'
    end

    --set initial acceleration values
    self.entity.ay = -7
    self.entity.ax = 0

    -- if we've gone below the map limit, set DY to 0
    if self.entity.y + self.entity.height > 0 then
        self.entity.y = 0 - self.entity.height
        self.entity.ay = 0
        self.entity.vy = 0
    end

    --calculations
    self.entity.vx = self.entity.vx + self.entity.ax
    self.entity.vy = self.entity.vy + self.entity.ay

    self.entity.x = self.entity.x + self.entity.vx * dt
    self.entity.y = self.entity.y - self.entity.vy * dt
end

function BossMoveState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x), math.floor(self.entity.y),
        0, self.entity.direction == 'right' and -1 or 1, 1,
        self.entity.direction == 'right' and self.entity.width or 0
        )
end