--[[
   Play State
   main state used to check overarching logic (ie: is the level beat)
   Renders stage, as well as HUD items that need to be rendered seperate of any camera translation
]]

PlayState = Class{__includes = BaseState}

function PlayState:enter(def)
    --set up the stage and player based on what was passed from BeginStageState
    self.stage = def.stage
    self.player = def.player

    --create a timer to see how fast the player makes it through this level
    self.levelTimer = 0
    self.timerIncrementer = Timer.every(1, function()
        self.levelTimer = self.levelTimer + 1
    end)

    self.tileMap = self.stage.tileMap

    --give each entity a reference to the player
    for i = 1, #self.stage.entities do
        self.stage.entities[i].player = self.player
    end

    --initialize camera values to focus on the center of the stage where the player spawns
    self.cameraX = 50 * TILE_SIZE - VIRTUAL_WIDTH / 2
    self.cameraVX = 0
    self.cameraAX = 0
    self.cameraY = -VIRTUAL_HEIGHT / 2 - TILE_SIZE
    self.cameraVY = 0
    self.cameraAY = 0
    self.K = 2.5
    self.damping = 50

    self.vignetteOpacity = 0
    self.rectangleOpacity = 0
end

function PlayState:update(dt)
    --handle player being damaged
    Event.on('player-damaged', function()
        if not self.player.invulnerable then
            --damage the player by removing a jump
            self.player.brokenJumps = math.min(self.player.brokenJumps + 1, PLAYER_MAX_JUMPS)

            --sound cue
            gSounds['player-damaged']:play()

            --make player tmeporarily invulnerable
            self.player:makeInvulnerable()

            --Clear combo
            self.player.comboTracker:clear()

            --red vignette
            self.vignetteOpacity = 255
            Timer.tween(.3, {
                [self] = {vignetteOpacity = 0}
            })

            --transition to lose state if player dies
            if self.player.brokenJumps == PLAYER_MAX_JUMPS then
                Timer.tween(1, {
                    [self] = {rectangleOpacity = 255}
                })
                :finish(function()
                    gStateMachine:change('lose')
                end)
            end
        end
    end)

    --change to next level if player has climbed high enough
    if self.player.y < -self.stage.height then
        Timer.tween(1, {
            [self] = {rectangleOpacity = 255}
        })
        :finish(function()
            gStateMachine:change('begin', self.stage.levelNumber + 1)
        end)

        --unlock the next level
        if self.stage.levelNumber + 1 <= #LEVELS then
            MENU_DEFS['level-select'].options[self.stage.levelNumber + 1] = LEVELS[self.stage.levelNumber + 1]
        end

        --end the timer and update leaderboard with the new time if lower than the current time
        self.timerIncrementer:remove()
        if pcall(function()
            --set the leaderboard to the lesser of the current record and the current attempt
            MENU_DEFS['leaderboard'].options[self.stage.levelNumber].text = math.min(self.levelTimer,  MENU_DEFS['leaderboard'].options[self.stage.levelNumber].text)
        end) then
            --do nothing if pcall returns true (no errors)
        else
            --The leaderboard starts as a string,  not an int, which means the above errors when initially setting a value
            --In that case, just set the leaderboard to the current attempt, as it is the first attempt
            MENU_DEFS['leaderboard'].options[self.stage.levelNumber].text = self.levelTimer
        end
    end

    --change to game over if a boss is defeated
    if LEVEL_DEFS[self.stage.levelNumber].boss and self.stage.entities[1].entityType ~= 'boss' then
        Timer.tween(1, {
            [self] = {rectangleOpacity = 255}
        })
        :finish(function()
            gStateMachine:change('game-over', {time = self.levelTimer})
        end)

        --update leaderboard, see above for documentation/explanation
        self.timerIncrementer:remove()
        if pcall(function()
            MENU_DEFS['leaderboard'].options[self.stage.levelNumber].text = math.min(self.levelTimer,  MENU_DEFS['leaderboard'].options[self.stage.levelNumber].text)
        end) then
        else
            MENU_DEFS['leaderboard'].options[self.stage.levelNumber].text = self.levelTimer
        end
    end

    -- update stage
    self.stage:update(dt)
    self:updateCamera(dt)

    -- constrain player X no matter which state
    if self.player.x <= 0 then
        self.player.x = 0
    elseif self.player.x > TILE_SIZE * self.tileMap.width - self.player.width then
        self.player.x = TILE_SIZE * self.tileMap.width - self.player.width
    end

    if love.keyboard.wasPressed('escape') then
        gStateMachine:change('start')
    end
end

--update camera based on player position. Camera translation values are based on a spring equation with some damping
--Camera follows player, but lags slightly behind
function PlayState:updateCamera(dt)
    --equilibrium position. The place where hte camera is perfectly centerd on the player. Clamped
    self.cameraXEquilibrium = self.player.x - (VIRTUAL_WIDTH / 2) + (self.player.width / 2)
    self.cameraXEquilibrium = math.max(0,
        math.min(TILE_SIZE * self.tileMap.width - VIRTUAL_WIDTH,
        self.player.x - (VIRTUAL_WIDTH / 2 - 8)))

    --Set the acceleration on the camera based on a spring equation with damping
    --(spring constant) * (currentX - equilibrumX) - (damping constant)*(velocity)
    self.cameraAX = ((self.K * (self.cameraXEquilibrium - self.cameraX)) - (self.damping * self.cameraVX)) * dt
    
    --update velocity and position based on acceleration
    self.cameraVX = self.cameraVX + self.cameraAX
    self.cameraX = self.cameraX + self.cameraVX 
    self.cameraX = math.max(0, self.cameraX)

    --see above
    self.cameraYEquilibrium = self.player.y - (VIRTUAL_HEIGHT / 2) + (self.player.height / 2)
    self.cameraAY = ((self.K*2 * (self.cameraYEquilibrium - self.cameraY)) - (self.damping * self.cameraVY)) * dt
    self.cameraVY = self.cameraVY + self.cameraAY
    self.cameraY = self.cameraY + self.cameraVY 
end

function PlayState:render()
    love.graphics.setColor(255, 255, 255, 255)
    --draw the parallax background
    love.graphics.draw(gTextures['background'],
        -(self.player.x / 1584) *  (1584 - VIRTUAL_WIDTH),
        (1 - (-self.player.y / 3000)) * (VIRTUAL_HEIGHT - 630)
        )

    love.graphics.push()

    -- translate the entire view of the scene to emulate a camera
    love.graphics.translate(-math.floor(self.cameraX), -math.floor(self.cameraY))
    
    self.stage:render()

    self.player:render()
    love.graphics.pop()
    
    -- render score
    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.print(tostring(-math.min(0, math.floor(self.player.y + self.player.height))), 5, 5)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print(tostring(-math.min(0, math.floor(self.player.y  + self.player.height))), 4, 4)

    --render player combo
    self.player.comboTracker:render()

    --draw vignette caused by getting hurt
    love.graphics.setColor(255, 255, 255, self.vignetteOpacity)
    love.graphics.draw(gTextures['hurt-vignette'], 0, 0)

    --render bosses healthbar if a boss exists
    love.graphics.setColor(255, 255, 255, 255)
    if self.stage.entities[1].entityType == 'boss' then
        self.stage.entities[1].healthbar:render(30, VIRTUAL_HEIGHT - 40, VIRTUAL_WIDTH - 60, 7)
    end

    --draw timer
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.printf('Timer: ' .. self.levelTimer,  0, 10, VIRTUAL_WIDTH - 10, 'right')

    --rectangle for transition
    love.graphics.setColor(255, 255, 255, self.rectangleOpacity)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

    -- love.graphics.print(tostring(self.player.ax), 5, 20)
    -- love.graphics.print(tostring(self.player.vx), 5, 35)
    -- love.graphics.print(tostring(0), 5, 50)
    -- love.graphics.print(tostring(0), 5, 65)

end