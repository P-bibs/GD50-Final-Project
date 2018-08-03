DashIdleState = Class {__includes = EntityIdleState}

function DashIdleState:enter(def)
    self.entity:changeAnimation('idle')
    self.rotation = def == nil and 0 or def.rotation
    self.waitTimer = 2
end

function DashIdleState:processAI(params, dt)
    print('idle' .. #self.entity.currentAnimation.frames)

    self.waitTimer = self.waitTimer - dt

    if self.waitTimer < 0 then
        self.rotation = 180
        print('changed')
        self.entity:changeState('move')
    end
end

function DashIdleState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x - self.entity.offsetX), math.floor(self.entity.y - self.entity.offsetY),
        self.rotation
    )
    
end