--[[
    Simple class to represent a box for testing collision
]]

Hitbox = Class{}

function Hitbox:init(x, y, width, height, direction)
    self.direction = direction
    self.x = x
    self.y = y
    self.width = width
    self.height = height
end

function Hitbox:collides(target)
    return not (self.x > target.x + target.width or target.x > self.x + self.width or
                self.y > target.y + target.height or target.y > self.y + self.height)
end

--for debug purposes
function Hitbox:render()
    love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
end