BugMoveState = Class {__includes = EntityMoveState}

function BugMoveState:enter(def)
    self.entity = def.entity
end

function BugMoveState:processAI(dt)
    --If the bug is too far from the player, change to idle state (uses pythagorean theorum for distance)
    local a = self.entity.x - self.entity.player.x
    local b = self.entity.y - self.entity.player.y
    local distance = math.sqrt(math.pow(a, 2) + math.pow(b, 2))
    if distance > BUG_ALERT_DISTANCE then
        self.entity.ax = 0
        self.entity.ay = 0
        self.entity:changeState('idle', {entity = self.entity})
    end

    --Bugs track the player using acceleration instead of velocity. The closer they are, the smaller the force applied
    if self.entity.x > self.entity.player.x then
        self.entity.ax = -self.entity.speed * (distance / 100)
    elseif self.entity.x < self.entity.player.x then
        self.entity.ax = self.entity.speed * (distance / 100)
    end

    if self.entity.y > self.entity.player.y then
        self.entity.ay = self.entity.speed * .5 * (distance / 100)
    elseif self.entity.y < self.entity.player.y then
        self.entity.ay = -self.entity.speed * .5 * (distance / 100)
    end
end