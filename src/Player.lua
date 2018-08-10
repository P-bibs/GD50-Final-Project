--[[
    Class that represents the player.
    The player is controlled by acceleration, not velocity, so is very floaty
]]

Player = Class{__includes = Entity}

function Player:init(def, x, y)
    Entity.init(self, def, x, y)

    self.jumps = PLAYER_MAX_JUMPS
    self.brokenJumps = 0

    self.invulnerable = false

    self.hitbox = nil
    self.attackAnim = nil

    self.score = 0

    self.comboTracker = ComboTracker(COMBO_TIMEOUT, VIRTUAL_WIDTH - 80, 60, 
        --callback function that is called each time the combo is incremented
        function(hits)
            --if the combo is a multiple of 3, repair all the player's jumps
            if hits % 3 == 0 then 
                if self.brokenJumps ~= 0 then
                    gSounds['heal']:play()
                end
                self.brokenJumps = 0
                self:alterJumps(PLAYER_MAX_JUMPS)
            end
        end)

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

    --[[ All below is movemt calculations ]]
    if not self.dead then
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
        if love.keyboard.wasPressed(KEY_JUMP) and self.jumps > 0 then
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
    --continue player's trajectory, but dont allow input if dead
    else
        self:changeAnimation('dead')
        --set initial acceleration values
        self.ay = -7
        self.ax = 0

        -- if we've gone below the map limit, set DY to 0
        if self.y > 0 - self.height then
            self.y = 0 - self.height
            self.ay = 0
            self.vy = 0
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

    end

    --[[ End movement logic ]]

    --update animation
    if self.currentAnimation then
        self.currentAnimation:update(dt)
    end

    --update combo
    self.comboTracker:update(dt)

    --update hurtbox and collisionbox so they track entity
    self.hurtbox = Hitbox(self.x, self.y, self.width, self.height, self.direction)
    self.collisionBox = Hitbox(self.x, self.y, self.width, self.height, self.direction)
end

function Player:alterJumps(amount)
    --if altering by a positive amount, add the amount, not going above max jumps, and ten subtract any broken jumps
    if amount > 0 then
        self.jumps = math.min(PLAYER_MAX_JUMPS, self.jumps + amount)
        self.jumps = math.min(self.jumps, self.jumps - self.brokenJumps)
    --if subtracting jumps, make sure jumps is never less than 0
    elseif amount < 0 then
        self.jumps = math.max(0, self.jumps + amount)
    end
end

function Player:makeInvulnerable()
    self.invulnerable = true
    Timer.every(.1, function()
        --flash the player so he appears invulnerable
        self.playerInvisible = not self.playerInvisible
    end)
    :limit(20)
    :finish(function()
        self.invulnerable = false
    end)
end



function Player:render()
    --debug to show area around player in which bug enemies will be alerted
    --love.graphics.setColor(255, 255, 255, 100)
    --love.graphics.circle('fill', self.x + self.width, self.y + self.height, BUG_ALERT_DISTANCE)
    --love.graphics.setColor(255, 255, 255, 255)

    love.graphics.setColor(255, 255, 255, self.playerInvisible and 0 or 255)
    love.graphics.draw(gTextures[self.currentAnimation.texture], gFrames[self.currentAnimation.texture][self.currentAnimation:getCurrentFrame()],
        math.floor(self.x) + 8, math.floor(self.y) + 10, 0, 1, 1, 8, 10)

    --draw jumps indicator
    for i = 1, PLAYER_MAX_JUMPS do
        if i <= self.jumps then
            love.graphics.setColor(255, 255, 255, 255)
            love.graphics.circle('fill', math.floor(self.x  - 3 + 3 * i), math.floor(self.y), 1)
        elseif i > PLAYER_MAX_JUMPS - self.brokenJumps then
            love.graphics.setColor(255, 0, 0, 255)
            love.graphics.circle('fill', math.floor(self.x  - 3 + 3 * i), math.floor(self.y), 1)
        else
            love.graphics.setColor(100, 100, 100, 100)
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

    --DEBUG: hitbox
    --if self.hitbox then
    --    love.graphics.rectangle('line', self.hitbox.x, self.hitbox.y, self.hitbox.width, self.hitbox.height)
    --end

    --DEBUG: hurtbox
    --self.collisionBox:render()
end
