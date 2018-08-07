Boss = Class {__includes = Entity}

function Boss:init(def, x, y)
    Entity.init(self, def, x, y)

    self.hurtbox = Hitbox(self.x + 172, self.y + 212, 84, 39, nil)
    self.healthbar = Healthbar(ENTITY_DEFS['boss'].health)

end

function Boss:update(dt)
    Entity.update(self, dt)
    if self.direction == 'left' then
        self.hurtbox = Hitbox(self.x + 172, self.y + 212, 84, 39, nil)
    else
        self.hurtbox = Hitbox(self.x, self.y + 212, 84, 39, nil)
    end

end

--function Boss:update()
--    Entity.render(self)
--end