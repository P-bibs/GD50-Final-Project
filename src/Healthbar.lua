Healthbar = Class {}

function Healthbar:init(max)
    self.value = max
    self.maxValue = max
    self.secondaryValue = max

    self.damageTimer = Timer.every(1, function() end)
end

function Healthbar:update(dt)

end

function Healthbar:damage(amount)
    self.damageTimer:remove()
    self.value = self.value - amount

    self.damageTimer = Timer.after(1, function()
       Timer.tween(.5, {
           [self] = {secondaryValue = self.value}
       }) 
    end)
end

function Healthbar:render(x, y, width, height)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setFont(gFonts['medium'])
    love.graphics.print('Marauder of the Deep', x, y - 15)

    love.graphics.setColor(81, 78, 10, 255)
    love.graphics.rectangle('fill', x, y, (self.secondaryValue / self.maxValue) * (width), height)

    love.graphics.setColor(37, 5, 6, 255)
    love.graphics.rectangle('fill', x, y, (self.value / self.maxValue) * (width), height)

    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.rectangle('line', x, y, width, height)

    for i = 1, 40 do
        if i % 4 == 0 then
            love.graphics.line(math.floor((width / 40) * i), math.floor(y + height), math.floor((width / 40) * i), math.floor(y + height / 3))
        else
            love.graphics.line(math.floor((width / 40) * i), math.floor(y + height), math.floor((width / 40) * i), math.floor(y + height  * 2 / 3))
        end
    end
    
end