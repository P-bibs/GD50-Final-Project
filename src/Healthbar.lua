Healthbar = Class {}

function Healthbar:init(max, text)
    self.value = max
    self.maxValue = max
    self.secondaryValue = max

    self.text = text

    --initialize an empty value so later references dont cause nil errors
    self.damageTimer = Timer.every(1, function() end)
end

function Healthbar:update(dt)

end

--Damaging the entity causes a red healthbar to decrease instantly, followed by 
--a yellow health bar behind tweening down once the player hasn't damaged
--the entity for a period
function Healthbar:damage(amount)
    --reset the timer for removing the yellow section
    self.damageTimer:remove()

    --inflict damage
    self.value = self.value - amount

    --set a timer. If the player doesn't damage this entity for 1 second, 
    --decrease the yellow healthbar
    self.damageTimer = Timer.after(1, function()
       Timer.tween(.5, {
           [self] = {secondaryValue = self.value}
       }) 
    end)
end

function Healthbar:render(x, y, width, height)
    --draw label
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setFont(gFonts['medium'])
    love.graphics.print(self.text, x, y - 15)

    --draw yellow healthbar behind
    love.graphics.setColor(81, 78, 10, 255)
    love.graphics.rectangle('fill', x, y, (self.secondaryValue / self.maxValue) * (width), height)

    --draw red healthbar above
    love.graphics.setColor(37, 5, 6, 255)
    love.graphics.rectangle('fill', x, y, (self.value / self.maxValue) * (width), height)

    --draw border on top
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.rectangle('line', x, y, width, height)

    --draw vertical lines on healthbar to show increments, if its a multiple of 4 make it larger
    for i = 1, 40 do
        if i % 4 == 0 then
            love.graphics.line(math.floor((width / 40) * i), math.floor(y + height), math.floor((width / 40) * i), math.floor(y + height / 3))
        else
            love.graphics.line(math.floor((width / 40) * i), math.floor(y + height), math.floor((width / 40) * i), math.floor(y + height  * 2 / 3))
        end
    end
    
end