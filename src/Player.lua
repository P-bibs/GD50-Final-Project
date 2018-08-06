--[[
    GD50
    Super Mario Bros. Remake

    -- Player Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Player = Class{__includes = Entity}

function Player:init(def, x, y)
    Entity.init(self, def, x, y)

    self.jumps = 6

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
        self.jumps = self.jumps - 1
    end

    if love.keyboard.wasPressed(KEY_ATTACK_LEFT) then
        self.attackAnim = GameObject(
            GAME_OBJECT_DEFS['character-attack-left'], 
            self.x - 4 - GAME_OBJECT_DEFS['character-attack-left'].width,
            self.y
        )
        self.hitbox = Hitbox(self.x - 4 - GAME_OBJECT_DEFS['character-attack-left'].width, self.y, 32, 16, 'left')
        self.jumps = self.jumps - 1
    end

    if love.keyboard.wasPressed(KEY_ATTACK_UP) then
        self.attackAnim = GameObject(
            GAME_OBJECT_DEFS['character-attack-up'], 
            self.x,
            self.y - GAME_OBJECT_DEFS['character-attack-down'].height
        )
        self.hitbox = Hitbox(self.x, self.y - GAME_OBJECT_DEFS['character-attack-down'].height, 16, 32, 'up')
        self.jumps = self.jumps - 1
    end

    if love.keyboard.wasPressed(KEY_ATTACK_DOWN) then
        self.attackAnim = GameObject(
            GAME_OBJECT_DEFS['character-attack-down'], 
            self.x,
            self.y + self.height
        )
        self.hitbox = Hitbox(self.x, self.y + self.height, 16, 32, 'down')
        self.jumps = self.jumps - 1
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

    --check for collisions with enemies
    if self.hitbox then
        for k, entity in pairs(self.level.entities) do
            if entity:collides(self.hitbox) then
                if entity.hurtbox:collides(self.hitbox) then
                    gSounds['enemy-hurt']:play()

                    --update variables
                    self.jumps = 6
                    self.score = self.score + 10

                    --freeze entities and animations temporarily
                    entity.currentAnimation:freeze(FREEZE_DURATION)
                    self.currentAnimation:freeze(FREEZE_DURATION)
                    entity:freeze(FREEZE_DURATION)
                    self:freeze(FREEZE_DURATION)
                    --create hit animation
                    table.insert(self.effects, Effect(GAME_OBJECT_DEFS['hit-effect'],
                        entity.hurtbox.x + entity.hurtbox.width / 2 - GAME_OBJECT_DEFS['hit-effect'].width / 2,
                        entity.hurtbox.y + entity.hurtbox.height / 2 - GAME_OBJECT_DEFS['hit-effect'].height / 2))

                    --knockback entity
                    if self.hitbox.direction == 'up' then entity.vy = KNOCKBACK 
                    elseif self.hitbox.direction == 'down' then entity.vy = -KNOCKBACK 
                    elseif self.hitbox.direction == 'right' then entity.vx = KNOCKBACK 
                    elseif self.hitbox.direction == 'left' then entity.vx = -KNOCKBACK end

                    --knockback player
                    if self.hitbox.direction == 'down' then self.vy = KNOCKBACK end

                    --update attacked entity
                    entity:damage(1)
                    if entity.dead then
                        table.remove(self.level.entities, k)
                    end

                    if entity.entityType == 'dash' then
                        entity:changeState('idle', {entity = entity})
                    end
                    
                    self.hitbox = nil
                    break
                else
                    gSounds['failed-hit']:play()
                    self.hitbox = nil
                    break
                end
            end
        end
    end

    --set initial acceleration values
    self.ay = -7
    self.ax = 0

    -- if we've gone below the map limit, set DY to 0
    if self.y > 0 - self.height then
        self.y = 0 - self.height
        self.ay = 0
        self.vy = 0
        self.jumps = 6
    end

    --jump
    if love.keyboard.wasPressed(KEY_JUMP) and self.jumps > 0 then
        self.vy = PLAYER_JUMP_VELOCITY
        self.jumps = self.jumps - 1
        gSounds['player-jump']:play()
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


function Player:render()
    --debug to show area around player in which bug enemies will be alerted
    --love.graphics.setColor(255, 255, 255, 100)
    --love.graphics.circle('fill', self.x + self.width, self.y + self.height, BUG_ALERT_DISTANCE)
    --love.graphics.setColor(255, 255, 255, 255)

    love.graphics.draw(gTextures[self.currentAnimation.texture], gFrames[self.currentAnimation.texture][self.currentAnimation:getCurrentFrame()],
        math.floor(self.x) + 8, math.floor(self.y) + 10, 0, 1, 1, 8, 10)

    for i = 1, 6 do
        if i <= self.jumps then
            love.graphics.circle('fill', math.floor(self.x  - 3 + 3 * i), math.floor(self.y), 1)
        end
    end

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
