BossFireballState = Class {__includes = BossIdleState}

function BossFireballState:enter(def)
    self.entity = def.entity
    self.entity:changeAnimation('idle')

    self.angle = PI
    self.initialAngle = 0

    self.entity.vx = 0
    self.entity.ax = 0
    self.entity.vy = 0
    self.entity.ay = 0

    --Every five seconds, shoot a fireball. Starting horizontal, then angling down
    self.fireballTimer = Timer.every(.5, function()
        --open the mouth when the boss shoots, and then close it shortly after
        self.entity:changeAnimation('mouth-open')
        self.mouthCloseTimer = Timer.after(.4, function()
            self.entity:changeAnimation('idle')
        end)

        --use hardcoded values to pinpoint location of monsters mouth. This is where the fireball is spawned
        local x, y
        if self.entity.direction == 'left' then 
            x = self.entity.x + 30
        else
            x = self.entity.x + self.entity.width - 40
        end
        y = self.entity.y + 85

        --create fireball
        table.insert(self.entity.effects, GameObject(
            GAME_OBJECT_DEFS['fireball'], x, y
        ))
        --use trig to set velocities, flipping x if the boss is facing right
        self.entity.effects[#self.entity.effects].vx = math.cos(self.angle) * GAME_OBJECT_DEFS['fireball'].speed * (self.entity.direction == 'right' and -1 or 1)
        self.entity.effects[#self.entity.effects].vy = math.sin(self.angle) * GAME_OBJECT_DEFS['fireball'].speed
        --increment angle
        self.angle = self.angle + PI / (NUMBER_FIREBALLS * 2)
    end)
    --only shoot a certain number of fireballs
    :limit(NUMBER_FIREBALLS) 
    --once done, transition back to walking
    :finish(function()
        self.entity.stateMachine:change('move', {entity = self.entity})
    end)
end

function BossFireballState:processAI(dt)

end

function BossFireballState:exit()
    self.fireballTimer:remove()
    self.mouthCloseTimer:remove()
end