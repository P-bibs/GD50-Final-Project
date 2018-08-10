--[[
    Object that keeps track of combos and draws them to the screen
]]

ComboTracker = Class {}

function ComboTracker:init(timeout, x, y, addHitCallback)
    --time before combo expires
    self.timeout = timeout

    --length of combo
    self.hits = 0

    --current time left in combo, refreshed on hit
    self.timer = 0

    --used to enlarge the hit number when an enemy is hit
    self.scale = 1

    --location to draw
    self.x = x
    self.y = y

    self.hitCallback = addHitCallback
end

function ComboTracker:update(dt)
    --update timer and reset hit count if timer expires
    if self.hits > 0 then
        self.timer = self.timer - dt
    end
    if self.timer <= 0 then
        self.hits = 0
    end
end

--Add a new hit
function ComboTracker:addHit()
    --scale size of hit count and tween it back to normal
    self.scale = 2
    Timer.tween(.2, {
        [self] = {scale = 1}
    })

    --update hit count
    self.hits = self.hits + 1
    
    --reset hit count
    self.timer = self.timeout

    --call a function in the player class that is passed in the combotracker's contructor
    self.hitCallback(self.hits)
end

--clear the combo if the player gets hit
function ComboTracker:clear()
    self.hits = 0
    self.timer = 0
end

function ComboTracker:render()
    --draw timeout bar. Fades from green to red as time expires
    love.graphics.setColor(
        (self.timeout - self.timer / self.timeout) * 255,
        (self.timer / self.timeout) * 255,
        0, 255)
    love.graphics.rectangle('fill', self.x, self.y, (self.timer / self.timeout) * 64, 8)

    --draw timeout bar outline
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.rectangle('line', self.x, self.y, 64, 8)

    --new layer of rendering so the hit count can be scaled
    love.graphics.push()

    love.graphics.translate(self.x, self.y + 20)
    love.graphics.scale(self.scale)

    love.graphics.setFont(gFonts['title'])
    love.graphics.printf(self.hits, 0, 0, 64, 'left')

    love.graphics.pop()

    --draw string 'hits' after the hit count
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('hits', self.x, self.y + 20, 64, 'right')
end