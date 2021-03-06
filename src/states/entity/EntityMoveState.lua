--[[
    Base state for entities moving
]]

EntityMoveState = Class{__includes = BaseState}

function EntityMoveState:init(entity)
    self.entity = entity

    -- used for AI control
    self.moveDuration = 0
    self.movementTimer = 0

end

function EntityMoveState:update(dt)
    self:processAI(nil, dt)
end

function EntityMoveState:processAI(params, dt)
    
end

function EntityMoveState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x), math.floor(self.entity.y))
    
    --debug code
    --love.graphics.setColor(255, 0, 255, 255)
    --love.graphics.rectangle('line', self.entity.x, self.entity.y, self.entity.width, self.entity.height)
    --love.graphics.setColor(255, 255, 255, 255)
end