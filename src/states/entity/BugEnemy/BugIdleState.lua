BugIdleState = Class {__includes = EntityIdleState}

function BugIdleState:enter(def)
    self.entity = def.entity
end

function BugIdleState:processAI(dt)
    --slowly wind down velocity when bug is idling, so it doesn't immediately come to a stop but doesn't drift too far
    if self.entity.ax ~= 0 then self.entity.ax = 0 end
    if self.entity.ay ~= 0 then self.entity.ay = 0 end
    self.entity.vx = self.entity.vx * .95
    self.entity.vy = self.entity.vy * .95

    --If the bug is near the player, change to move state (uses pythagorean theorum for distance)
    local a = self.entity.x - self.entity.player.x
    local b = self.entity.y - self.entity.player.y
    local distance = math.sqrt(math.pow(a, 2) + math.pow(b, 2))
    if distance < BUG_ALERT_DISTANCE then
        self.entity:changeState('move', {entity = self.entity})
    end
end

function BugIdleState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x), math.floor(self.entity.y))
    
    --debug
    --love.graphics.setColor(255, 0, 255, 255)
    --love.graphics.rectangle('line', self.entity.x, self.entity.y, self.entity.width, self.entity.height)
    --love.graphics.setColor(255, 255, 255, 255)
end