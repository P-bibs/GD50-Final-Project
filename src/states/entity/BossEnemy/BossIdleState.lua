BossIdleState = Class {__includes = EntityIdleState}

function BossIdleState:enter(def)
    self.entity = def.entity
end

function BossIdleState:processAI(dt)

end

function BossIdleState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x), math.floor(self.entity.y),
        0, self.entity.direction == 'right' and -1 or 1, 1,
        self.entity.direction == 'right' and self.entity.width or 0
        )
    
    --debug
    --love.graphics.setColor(255, 0, 255, 255)
    --love.graphics.rectangle('line', self.entity.x, self.entity.y, self.entity.width, self.entity.height)
    --love.graphics.setColor(255, 255, 255, 255)
end