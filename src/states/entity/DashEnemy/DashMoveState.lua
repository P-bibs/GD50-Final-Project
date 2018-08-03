DashMoveState = Class {__includes = EntityMoveState}

function DashMoveState:enter(def)
    self.entity:changeAnimation('dash')

    self.rotation = math.atan(self.entity.x - self.entity.player.x / self.entity.y - self.entity.player.y)
    self.entity.vx = self.entity.speed * math.cos(self.rotation)
    self.entity.vy = self.entity.speed * math.sin(self.rotation)
    self.entity.vx = 100
    self.entity.vy = 100

end

function DashMoveState:processAI(params, dt)
    print('move' .. #self.entity.currentAnimation.frames)

    self.entity.vx = self.entity.vx * .95
    self.entity.vy = self.entity.vy * .95
    print('first' .. self.entity.vx)
    if self.entity.vx > -0.5 and self.entity.vx < 0.5 then
        self.entity.vx = 0
    end
    if self.entity.vy > -0.5 and self.entity.vy < 0.5 then
        self.entity.vy = 0
    end
    print('second' .. self.entity.vx)
    if self.entity.vx == 0 and self.entity.vy == 0 then
        print('idled')
        self.entity:changeState('idle')
    end
end

function DashMoveState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x - self.entity.offsetX), math.floor(self.entity.y - self.entity.offsetY), 
        self.rotation
    )
    
end