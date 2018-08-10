--[[
    Base state for entities idling
]]

EntityIdleState = Class{__includes = BaseState}

function EntityIdleState:init(entity)
    self.entity = entity
end

function EntityIdleState:update(dt)
    self:processAI(nil, dt)
end

--[[
    We can call this function if we want to use this state on an agent in our game; otherwise,
    we can use this same state in our Player class and have it not take action.
]]
function EntityIdleState:processAI(params, dt)

end

function EntityIdleState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x), math.floor(self.entity.y))
    
    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.entity.x, self.entity.y, self.entity.width, self.entity.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end