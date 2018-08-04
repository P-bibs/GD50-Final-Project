ProjectileIdleState = Class {__includes = EntityIdleState}

function ProjectileIdleState:enter(def)
    self.entity = def.entity
end

function ProjectileIdleState:processAI(dt)
    --slowly wind down velocity when bug is idling, so it doesn't immediately come to a stop but doesn't drift too far
    if self.entity.ax ~= 0 then self.entity.ax = 0 end
    if self.entity.ay ~= 0 then self.entity.ay = 0 end
    self.entity.vx = self.entity.vx * .95
    self.entity.vy = self.entity.vy * .95

end

function ProjectileIdleState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x), math.floor(self.entity.y))
    
    --debug
    --love.graphics.setColor(255, 0, 255, 255)
    --love.graphics.rectangle('line', self.entity.x, self.entity.y, self.entity.width, self.entity.height)
    --love.graphics.setColor(255, 255, 255, 255)
end