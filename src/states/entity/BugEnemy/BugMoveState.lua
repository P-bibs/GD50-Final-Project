BugMoveState = Class {__includes = EntityMoveState}

function BugMoveState:processAI(dt)
    if self.entity.x > self.entity.player.x then
        self.entity.vx = -self.entity.speed
    elseif self.entity.x < self.entity.player.x then
        self.entity.vx = self.entity.speed
    end

    if self.entity.y > self.entity.player.y then
        self.entity.vy = self.entity.speed * .5
    elseif self.entity.y < self.entity.player.y then
        self.entity.vy = -self.entity.speed * .5
    end
end