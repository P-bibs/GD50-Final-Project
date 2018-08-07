BossStunState = Class {__includes = BossIdleState}

function BossStunState:enter(def)
    self.entity = def.entity
    self.entity:changeAnimation('stun')
    Timer.after(4, function()
        self.entity.stateMachine:change('move', {entity = self.entity})
    end)
end

function BossStunState:processAI(dt)

end