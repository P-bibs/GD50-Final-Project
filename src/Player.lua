--[[
    
]]

Player = Class{__includes = Entity}

function Player:init(def, x, y)
    Entity.init(self, def, x, y)

    self.jumps = {}
    for i = 1, PLAYER_MAX_JUMPS do
        table.insert(self.jumps, {
            status = 'ready'
        })
    end

    self.jumps[#self.jumps].status = 'broken'

    self.hitbox = nil
    self.attackAnim = nil

    self.score = 0

end

function Player:update(dt)
    self.stateMachine:update(dt)

    if love.keyboard.wasPressed(KEY_ATTACK_RIGHT) then
        self.attackAnim = GameObject(
            GAME_OBJECT_DEFS['character-attack-right'], 
            self.x + self.width,
            self.y
        )
        self.hitbox = Hitbox(self.x + self.width, self.y, 32, 16, 'right')
        self:alterJumps(-1)
    end

    if love.keyboard.wasPressed(KEY_ATTACK_LEFT) then
        self.attackAnim = GameObject(
            GAME_OBJECT_DEFS['character-attack-left'], 
            self.x - 4 - GAME_OBJECT_DEFS['character-attack-left'].width,
            self.y
        )
        self.hitbox = Hitbox(self.x - 4 - GAME_OBJECT_DEFS['character-attack-left'].width, self.y, 32, 16, 'left')
        self:alterJumps(-1)
    end

    if love.keyboard.wasPressed(KEY_ATTACK_UP) then
        self.attackAnim = GameObject(
            GAME_OBJECT_DEFS['character-attack-up'], 
            self.x,
            self.y - GAME_OBJECT_DEFS['character-attack-down'].height
        )
        self.hitbox = Hitbox(self.x, self.y - GAME_OBJECT_DEFS['character-attack-down'].height, 16, 32, 'up')
        self:alterJumps(-1)
    end

    if love.keyboard.wasPressed(KEY_ATTACK_DOWN) then
        self.attackAnim = GameObject(
            GAME_OBJECT_DEFS['character-attack-down'], 
            self.x,
            self.y + self.height
        )
        self.hitbox = Hitbox(self.x, self.y + self.height, 16, 32, 'down')
        self:alterJumps(-1)
    end

    --update effects
    for i = #self.effects, 1, -1 do
        self.effects[i]:update(dt)
        if self.effects[i].dead then table.remove(self.effects, i) end
    end

    --update attack animation
    if self.attackAnim then 
        self.attackAnim:update(dt)
        if self.attackAnim.dead then self.attackAnim = nil end
    else
        self.hitbox = nil --if the animation has expired, destroy the hitbox
    end

    --set initial acceleration values
    self.ay = -7
    self.ax = 0

    -- if we've gone below the map limit, set DY to 0
    if self.y > 0 - self.height then
        self.y = 0 - self.height
        self.ay = 0
        self.vy = 0
        self:alterJumps(PLAYER_MAX_JUMPS)
    end

    --jump
    if love.keyboard.wasPressed(KEY_JUMP) and self:getJumps() > 0 then
        self.vy = PLAYER_JUMP_VELOCITY
        self:alterJumps(-1)
        gSounds['player-jump']:play()
        self.stateMachine:change('air')
    end

    --input
    if love.keyboard.isDown(KEY_MOVE_LEFT) then
        self.ax = -5
    end
    if love.keyboard.isDown(KEY_MOVE_RIGHT) then
        self.ax = 5
    end

    --friction
    if self.vx > 0 then 
        self.ax = self.ax - 2
    end
    if self.vx < 0 then
        self.ax = self.ax + 2
    end

    --if x velocity is approximately 0, set to 0
    if self.vx > -2 and self.vx < 2 then
        self.vx = 0
    end

    --calculations
    if self.vx >= 0 then self.vx = math.min(240, self.vx + self.ax) end
    if self.vx < 0 then self.vx = math.max(-240, self.vx + self.ax) end
    self.vy = self.vy + self.ay

    if not self.frozen then
        self.x = self.x + self.vx * dt
        self.y = self.y - self.vy * dt
    end

    --update animation
    if self.currentAnimation then
        self.currentAnimation:update(dt)
    end
end

--function that alters the number of jumps the player has remaining, either adding or subtracting based on sign
--this has to be done intelligently because jump slots can become temporarily unusable
function Player:alterJumps(amount)
    --figure out the current highest jump slot thats ready (not broken or used)
    local currentIndex = 0
    for i = 1, #self.jumps do
        if self.jumps[i].status == 'ready' then
            currentIndex = i
        end
    end

    --if the funciton call was to subtract jumps, start at the index calculated above and remove it as well as
    --those below it depending on the amount passed in
    if amount < 0 then
        for i = currentIndex, math.max(1, currentIndex + amount + 1), -1 do
            self.jumps[i].status = 'used'
        end
    else 
    --if the funciton call was positive, start at the index above the current index and set it to ready,
    --unless it is broken
        for i = currentIndex + 1, math.min(PLAYER_MAX_JUMPS, currentIndex + amount), 1 do
            if self.jumps[i].status ~= 'broken' then 
                self.jumps[i].status = 'ready'
            end
        end
    end
end

--get current number of usable jumps
function Player:getJumps()
    for i = 1, #self.jumps do
        if self.jumps[i].status ~= 'ready' then
            return i - 1
        end
    end
    return #self.jumps
end

function Player:render()
    --debug to show area around player in which bug enemies will be alerted
    --love.graphics.setColor(255, 255, 255, 100)
    --love.graphics.circle('fill', self.x + self.width, self.y + self.height, BUG_ALERT_DISTANCE)
    --love.graphics.setColor(255, 255, 255, 255)

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(gTextures[self.currentAnimation.texture], gFrames[self.currentAnimation.texture][self.currentAnimation:getCurrentFrame()],
        math.floor(self.x) + 8, math.floor(self.y) + 10, 0, 1, 1, 8, 10)

    for i = 1, #self.jumps do
        if self.jumps[i].status == 'ready' then
            love.graphics.setColor(255, 255, 255, 255)
            love.graphics.circle('fill', math.floor(self.x  - 3 + 3 * i), math.floor(self.y), 1)
        end
        if self.jumps[i].status == 'used' then
            love.graphics.setColor(100, 100, 100, 100)
            love.graphics.circle('fill', math.floor(self.x  - 3 + 3 * i), math.floor(self.y), 1)
        end
        --if i <= self.jumps then
        if self.jumps[i].status == 'broken' then
            love.graphics.setColor(255, 0, 0, 255)
            love.graphics.circle('fill', math.floor(self.x  - 3 + 3 * i), math.floor(self.y), 1)
        end
    end

    love.graphics.setColor(255, 255, 255, 255)

    for i = 1, #self.effects do
        if not self.effects[i].dead then self.effects[i]:render() end
    end

    if self.attackAnim then
        self.attackAnim:render()
    end

    --if self.hitbox then
    --    love.graphics.rectangle('line', self.hitbox.x, self.hitbox.y, self.hitbox.width, self.hitbox.height)
    --end
end
