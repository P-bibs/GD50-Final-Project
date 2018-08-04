DashIdleState = Class {__includes = EntityIdleState}

function DashIdleState:enter(def)
    self.entity = def.entity
    self.entity:changeAnimation('idle')
    self.rotation = def == nil and 0 or def.rotation
    self.waitTimer = math.random(20, 50) / 10 --random idle time between 2.0 and 5.0
end

function DashIdleState:processAI(params, dt)
    self.entity.vx = self.entity.vx * .98
    self.entity.vy = self.entity.vy * .98

    self.waitTimer = self.waitTimer - dt

    if self.waitTimer < 0 then
        self.entity:changeState('move', {entity = self.entity})
    end
end

function DashIdleState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x + self.entity.width / 2), math.floor(self.entity.y + self.entity.height / 2),
        self.rotation, 1, 1, self.entity.width / 2, self.entity.height / 2
    )

    --debug
    --love.graphics.rectangle('line', self.entity.x, self.entity.y , self.entity.width, self.entity.height)
end