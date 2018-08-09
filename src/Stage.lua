--[[
    
]]

Stage = Class{}

function Stage:init(entities, tilemap, height)
    self.entities = entities
    self.tileMap = tilemap
    self.height = height
end

--[[
    Remove all nil references from tables in case they've set themselves to nil.
]]
function Stage:clear()
    for i = #self.entities, 1, -1 do
        if not self.entities[i] then
            table.remove(self.entities, i)
        end
    end
end

function Stage:update(dt)
    --check for collisions with enemies
    if self.player.hitbox then
        for k, entity in pairs(self.entities) do
            if entity:collides(self.player.hitbox) then
                if entity.hurtbox:collides(self.player.hitbox) then
                    gSounds['enemy-hurt']:play()

                    --update variables
                    self.player.jumps = PLAYER_MAX_JUMPS

                    --freeze entities and animations temporarily
                    entity.currentAnimation:freeze(FREEZE_DURATION)
                    self.player.currentAnimation:freeze(FREEZE_DURATION)
                    entity:freeze(FREEZE_DURATION)
                    self.player:freeze(FREEZE_DURATION)
                    --create hit animation
                    table.insert(self.player.effects, Effect(GAME_OBJECT_DEFS['hit-effect'],
                        entity.hurtbox.x + entity.hurtbox.width / 2 - GAME_OBJECT_DEFS['hit-effect'].width / 2,
                        entity.hurtbox.y + entity.hurtbox.height / 2 - GAME_OBJECT_DEFS['hit-effect'].height / 2))

                    --knockback entity
                    if entity.entityType ~= 'boss' then
                        if self.player.hitbox.direction == 'up' then entity.vy = KNOCKBACK 
                        elseif self.player.hitbox.direction == 'down' then entity.vy = -KNOCKBACK 
                        elseif self.player.hitbox.direction == 'right' then entity.vx = KNOCKBACK 
                        elseif self.player.hitbox.direction == 'left' then entity.vx = -KNOCKBACK end
                    end

                    --knockback player
                    if self.player.hitbox.direction == 'down' then self.player.vy = KNOCKBACK end

                    if entity.entityType == 'dash' then
                        entity:changeState('idle', {entity = entity})
                    end

                    --update attacked entity
                    entity:damage(1)
                    if entity.dead then
                        table.remove(self.entities, k)
                        self.player.score = self.player.score + 10
                    end  
                    
                    self.player.hitbox = nil
                    break
                else
                    gSounds['failed-hit']:play()
                    self.player.hitbox = nil
                    break
                end
            end
        end
    end

    --Reflect fireballs back if hit by player
    if self.player.hitbox then
        if self.entities[1].entityType == 'boss' then
            for i = 1, #self.entities[1].effects do
                local fireball = self.entities[1].effects[i] --alias fireball
                if self.player.hitbox:collides(fireball) then
                    --update variables
                    self.player.jumps = PLAYER_MAX_JUMPS
                    fireball.reflected = true

                    --freeze entities and animations temporarily
                    fireball.currentAnimation:freeze(FREEZE_DURATION)
                    self.player.currentAnimation:freeze(FREEZE_DURATION)
                    fireball:freeze(FREEZE_DURATION)
                    self.player:freeze(FREEZE_DURATION)

                    --alias each entity's center coordinates
                    local playerX, playerY = fireball.x + fireball.width / 2, fireball.y + fireball.height / 2
                    local entityX, entityY = self.entities[1].x + 50, self.entities[1].y + 85

                    --using trigonometry, determine the angle between the boss and the player
                    local a = -(playerY - entityY )
                    local b = (playerX - entityX)
                    local rotation = math.atan(a / b)

                    --Because the range of the inverse tangent function is only -π<y<π, add π radians to the rotation if the player is left of the enemy
                    --if playerX < entityX then rotation = rotation + PI end

                    --figure out component velocities using trig. The fireball will now be directed back at the boss
                    fireball.vx = (GAME_OBJECT_DEFS['fireball'].speed * 2) * math.cos(rotation)
                    fireball.vy = (GAME_OBJECT_DEFS['fireball'].speed * 2) * math.sin(rotation)
                    
                    self.player.hitbox = nil
                    break
                    --TODO add parry sound effect
                end
                if self.player:collides(self.entities[1].effects[i]) then
                    --TODO damage player on fireball collision
                end
            end
        end
    end

    --determine if a reflected fireball hits boss. If so, stun the boss
    for i = 1, #self.entities[1].effects do
        local fireball = self.entities[1].effects[i]
        if fireball:collides(self.entities[1].collisionBox) and fireball.reflected then
            self.entities[1]:changeState('stun', {entity = self.entities[1]})
            table.remove(self.entities[1].effects, i)
            break
        end
    end

    --if player collides with an entity, flash a red vignett around the screen to indicate taking damage
    for k, entity in pairs(self.entities) do
        if self.player:collides(entity.collisionBox) then
            --TODO add an event handler here that calls a function in the play state to flash the vignette. Can't be done here since
            --the stage is translated when it is drawn
            --self.vignetteOpacity = 255
            --Timer.tween(.3, {
            --    [self] = {vignetteOpacity = 0}
            --})

            --if the player collides with the boss, apply a large knockback
            if entity.entityType == 'boss' then
                if self.player.x + self.player.width / 2 > entity.collisionBox.x + entity.collisionBox.width / 2 then
                    self.player.vx = 400
                    self.player.vy = 150
                else
                    self.player.vx = -400
                    self.player.vy = 150
                end
            end
        end
    end

    --TODO implement with event.on()
    -- if self.player.y < -self.height then
    --     Timer.tween(1, {
    --         [self] = {rectangleOpacity = 255}
    --     })
    --     :finish(function()
    --         gStateMachine:change('begin', self.stage.levelNumber + 1)
    --     end)
    -- end

    self.tileMap:update(dt)

    for k, entity in pairs(self.entities) do
        entity:update(dt)
    end

    self:clear()

    self.player:update(dt)
end

function Stage:render()
    self.tileMap:render()

    --draw finish line for this stage
    love.graphics.setColor(255, 0, 0, 255)
    love.graphics.rectangle('fill', 0, -self.height, self.tileMap.width * TILE_SIZE, 20)

    love.graphics.setColor(255, 255, 255, 255)
    for k, entity in pairs(self.entities) do
        entity:render()
    end
end