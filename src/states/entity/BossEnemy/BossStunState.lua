--[[
    State used after the boss has been hit by a fireball.
    Automatically transitions back to move state after 4 seconds
]]

BossStunState = Class {__includes = BossIdleState}

function BossStunState:enter(def)
    self.entity = def.entity
    
    --boss is immobile in this state
    self.entity.vx = 0
    self.entity.ax = 0
    self.entity.vy = 0
    self.entity.ay = 0

    self.entity:changeAnimation('stun')
    
    Timer.after(4, function()
        self.entity.stateMachine:change('move', {entity = self.entity})
    end)
end