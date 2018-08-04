--[[
    Extension of game object for animations that are attached to an entity and are non collidable

]]

Effect = Class{__includes = GameObject}

function Effect:init(def, x, y)
    GameObject.init(self, def, x, y)
    self.solid = false
    self.collidable = false
    self.consumable = false
    self.onCollide = function() end
    self.onConsume = function() end
    self.hit = false
end