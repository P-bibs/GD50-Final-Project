--[[
    Info that appears when beginning a level. Includes a countdown timer
    and an indication of which levle is about to start
    Also sets up player and stage and other variables necessary for playState
]]

BeginStageState = Class{__includes = BaseState}

function BeginStageState:init() --init is used here to set up tweens and related variables
    self.rectOpacity = 255

    self.levelLabelY = -50

    self.timer = 3

    --set up a countdown to the begin of play
    Timer.every(1, function() 
        self.timer = self.timer - 1
    end)

    -- Fade in from white
    Timer.tween(1, {
        [self] = {rectOpacity = 0}
    })
    
    -- once finished, bring level indicator down from off screen
    :finish(function()
        Timer.tween(0.3, {
            [self] = {levelLabelY = VIRTUAL_HEIGHT / 5}
        })
        
        --pause for one second
        :finish(function()
            Timer.after(1, function()
                
                -- send the level indicator away off the top of the screen
                Timer.tween(.3, {
                    [self] = {levelLabelY = -50}
                })
            end)
        end)
    end)
end

function BeginStageState:enter(level) --enter is used here to take care of initating objects that will be needed in PlayState
    self.levelNumber = level

    --set width based on what level you are on
    self.stage = LevelFiller.generate(100, LEVEL_DEFS[self.levelNumber].height,  LEVEL_DEFS[self.levelNumber].boss)
    self.stage.levelNumber = self.levelNumber
    self.tileMap = self.stage.tileMap

    self.player = Player({
        width = ENTITY_DEFS['player'].width,
        height = ENTITY_DEFS['player'].height,
        animations = ENTITY_DEFS['player'].animations,
        stage = self.stage,
        stateMachine = StateMachine {
            ['ground'] = function() return PlayerGroundState(self.player) end,
            ['air'] = function() return PlayerAirState(self.player, self.gravityAmount) end
        },
        map = self.tileMap,
        stage = self.stage},
        50 * TILE_SIZE, -TILE_SIZE
        )


    self.player.stage = self.stage
    self.stage.player = self.player

    self.player:changeState('ground')
end

function BeginStageState:update(dt)
    --if the timer has counted down to 0, change to PlayState
    if self.timer <= 0 then
        gStateMachine:change('play', {
            stage = self.stage,
            player = self.player
        })
    end

    if love.keyboard.wasPressed('escape') then
        gStateMachine:change('start')
    end
end

function BeginStageState:render()
    love.graphics.setColor(255, 255, 255, 255)

    --draw the parallax background
    love.graphics.draw(gTextures['background'],
    -(self.player.x / 1584) *  (1584 - VIRTUAL_WIDTH),
    (1 - (-self.player.y / 3000)) * (VIRTUAL_HEIGHT - 630)
    )

    love.graphics.push()
    -- translate the entire view of the scene to emulate a camera
    love.graphics.translate(-math.floor(50 * TILE_SIZE - VIRTUAL_WIDTH / 2), -math.floor(-VIRTUAL_HEIGHT / 2 - TILE_SIZE))
    
    self.stage:render()

    self.player:render()
    
    love.graphics.pop()

    --Countdown to stage begin
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf(self.timer, 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')

    --level number indicator
    love.graphics.setFont(gFonts['title'])
    love.graphics.printf('Level: ' .. self.levelNumber, 0, self.levelLabelY, VIRTUAL_WIDTH, 'center')

    --rectangle for transition
    love.graphics.setColor(255, 255, 255, self.rectOpacity)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end