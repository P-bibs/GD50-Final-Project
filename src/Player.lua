--[[
    GD50
    Super Mario Bros. Remake

    -- Player Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Player = Class{__includes = Entity}

function Player:init(def, score)
    Entity.init(self, def)
    self.score = score
    self.hasKey = false

    self.vx = 0
    self.ax = 0

    self.vy = 0
    self.ay = 0

    self.jumps = 6
end

function Player:update(dt)
    Entity.update(self, dt)

    if love.keyboard.wasPressed(KEY_ATTACK_RIGHT) then
        table.insert(self.effects, Effect(
            GAME_OBJECT_DEFS['character-attack-right'], 
            self.x + self.width,
            self.y
        ))
    end

    if love.keyboard.wasPressed(KEY_ATTACK_LEFT) then
        table.insert(self.effects, Effect(
            GAME_OBJECT_DEFS['character-attack-left'], 
            self.x - 4 - GAME_OBJECT_DEFS['character-attack-left'].width,
            self.y
        ))
    end

    if love.keyboard.wasPressed(KEY_ATTACK_UP) then
        table.insert(self.effects, Effect(
            GAME_OBJECT_DEFS['character-attack-up'], 
            self.x,
            self.y - GAME_OBJECT_DEFS['character-attack-down'].height
        ))
    end

    if love.keyboard.wasPressed(KEY_ATTACK_DOWN) then
        table.insert(self.effects, Effect(
            GAME_OBJECT_DEFS['character-attack-down'], 
            self.x,
            self.y + self.height
        ))
    end

    self.ay = -7
    self.ax = 0

    -- if we've gone below the map limit, set DY to 0
    if self.y > ((7 - 1) * TILE_SIZE) - self.height then
        self.y = ((7 - 1) * TILE_SIZE) - self.height
        self.ay = 0
        self.vy = 0
        self.jumps = 6
    end

    --jump
    if love.keyboard.wasPressed(KEY_JUMP) and self.jumps > 0 then
        self.vy = PLAYER_JUMP_VELOCITY
        self.jumps = self.jumps - 1
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
    self.x = self.x + self.vx * dt

    self.vy = self.vy + self.ay
    self.y = self.y - self.vy * dt

    for i = 1, #self.effects do
        self.effects[i]:update(dt)
    end
end

function Player:checkLeftCollisions(dt)
    -- check for left two tiles collision
    local tileTopLeft = self.map:pointToTile(self.x + 1, self.y + 1)
    local tileBottomLeft = self.map:pointToTile(self.x + 1, self.y + self.height - 1)

    -- place player outside the X bounds on one of the tiles to reset any overlap
    if (tileTopLeft and tileBottomLeft) and (tileTopLeft:collidable() or tileBottomLeft:collidable()) then
        self.x = (tileTopLeft.x - 1) * TILE_SIZE + tileTopLeft.width - 1
    else
        
        -- allow us to walk atop solid objects even if we collide with them
        self.y = self.y - 1
        local collidedObjects = self:checkObjectCollisions()
        self.y = self.y + 1

        -- reset X if new collided object
        if #collidedObjects > 0 then
            self.x = self.x + PLAYER_WALK_SPEED * dt
        end
    end
end

function Player:checkRightCollisions(dt)
    -- check for right two tiles collision
    local tileTopRight = self.map:pointToTile(self.x + self.width - 1, self.y + 1)
    local tileBottomRight = self.map:pointToTile(self.x + self.width - 1, self.y + self.height - 1)

    -- place player outside the X bounds on one of the tiles to reset any overlap
    if (tileTopRight and tileBottomRight) and (tileTopRight:collidable() or tileBottomRight:collidable()) then
        self.x = (tileTopRight.x - 1) * TILE_SIZE - self.width
    else
        
        -- allow us to walk atop solid objects even if we collide with them
        self.y = self.y - 1
        local collidedObjects = self:checkObjectCollisions()
        self.y = self.y + 1

        -- reset X if new collided object
        if #collidedObjects > 0 then
            self.x = self.x - PLAYER_WALK_SPEED * dt
        end
    end
end

function Player:checkObjectCollisions()
    local collidedObjects = {}

    for k, object in pairs(self.level.objects) do
        if object:collides(self) then
            if object.solid then
                table.insert(collidedObjects, object)
            elseif object.consumable then
                object.onConsume(self)
                table.remove(self.level.objects, k)
            end
        end
    end

    return collidedObjects
end

function Player:render()
    --love.graphics.draw(gTextures[self.currentAnimation.texture], gFrames[self.currentAnimation.texture][self.currentAnimation:getCurrentFrame()],
    --    math.floor(self.x) + 8, math.floor(self.y) + 10, 0, self.direction == 'right' and 1 or -1, 1, 8, 10)

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
end
