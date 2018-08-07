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

    -- --if player collides with an entity, flash a red vignett around the screen to indicate taking damage
    -- for k, entity in pairs(self.entities) do
    --     if self.player:collides(entity) then
    --         --TODO add an event handler here that calls a function in the play state to flash the vignette. Can't be done here since
    --         --the stage is translated when it is drawn
    --         self.vignetteOpacity = 255
    --         Timer.tween(.3, {
    --             [self] = {vignetteOpacity = 0}
    --         })
    --     end
    -- end

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