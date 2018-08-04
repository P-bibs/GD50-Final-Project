DashMoveState = Class {__includes = EntityMoveState}

function DashMoveState:enter(def)
    self.entity = def.entity
    self.entity:changeAnimation('dash')

    --alias each entity's center coordinates
    local playerX, playerY = self.entity.player.x + self.entity.player.width / 2, self.entity.player.y + self.entity.player.height / 2
    local entityX, entityY = self.entity.x + self.entity.width / 2, self.entity.y + self.entity.height / 2

    --using trigonometry, determine the angle between the enemy and the player
    local a = -(playerY - entityY )
    local b = (playerX - entityX)
    self.rotation = math.atan(a / b)

    --Because the range of the inverse tangent function is only -π<y<π, add π radians to the rotation if the player is left of the enemy
    if playerX < entityX then self.rotation = self.rotation + PI end

    --figure out component velocities using trig
    self.entity.vx = self.entity.speed * math.cos(self.rotation)
    self.entity.vy = self.entity.speed * math.sin(self.rotation)
end

function DashMoveState:processAI(params, dt)
    self.entity.vx = self.entity.vx * .97
    self.entity.vy = self.entity.vy * .97

    if self.entity.vx > -0.5 and self.entity.vx < 0.5 then
        self.entity.vx = 0
    end
    if self.entity.vy > -0.5 and self.entity.vy < 0.5 then
        self.entity.vy = 0
    end

    --change back to idle when velocity is 0
    if self.entity.vx == 0 and self.entity.vy == 0 then
        self.entity:changeState('idle', {entity = self.entity})
    end
end

function DashMoveState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x + self.entity.width / 2), math.floor(self.entity.y + self.entity.height / 2),
        -self.rotation + PI/2, 1, 1, self.entity.width / 2, self.entity.height / 2
    )
    
    --debug
    --love.graphics.rectangle('line', self.entity.player.x + self.entity.player.width / 2, self.entity.player.y + self.entity.player.height / 2, 30, 30)
    --love.graphics.rectangle('line', self.entity.x, self.entity.y , self.entity.width, self.entity.height)
    
end