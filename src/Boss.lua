--[[
    the Boss has to be a seperate class that inherits from entity because it has specific hitbox locations
]]
Boss = Class {__includes = Entity}

function Boss:init(def, x, y)
    Entity.init(self, def, x, y)

    self.hurtbox = Hitbox(self.x + 172, self.y + 212, 84, 39, nil)
    self.healthbar = Healthbar(ENTITY_DEFS['boss'].health, ENTITY_DEFS['boss'].name)
    self.collisionBox = Hitbox(self.x + 21, self.y + 67, 149, 189, nil)

end

function Boss:update(dt)
    Entity.update(self, dt)
    if self.direction == 'left' then
        self.hurtbox = Hitbox(self.x + 172, self.y + 212, 84, 39, nil)
        self.collisionBox = Hitbox(self.x + 21, self.y + 67, 149, 189, nil)
    else
        self.hurtbox = Hitbox(self.x, self.y + 212, 84, 39, nil)
        self.collisionBox = Hitbox(self.x + 85, self.y + 67, 151, 189, nil)
    end

end
