--[[
    GD50
    Super Mario Bros. Remake

    -- StartState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

StartState = Class{__includes = BaseState}

function StartState:init()
    self.map = LevelFiller.generate(100, 10)
    self.background = math.random(3)
    self.currentMenu = 'primary'
    self.selected = 1

    self.allowInput = true
    self.rectOpacity = 0
end

function StartState:update(dt)
    --action to take when the user presses enter on their currently selected item
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') and self.allowInput then
        gSounds['menu-select']:play()
        --if the currently selected item's action is quit, quit the game
        if MENU_DEFS[self.currentMenu].options[self.selected].action == 'quit' then
            love.event.quit()
        --if the currently selected item's action is play, play the game, passing a specific level
        elseif MENU_DEFS[self.currentMenu].options[self.selected].action == 'play' then
            self.allowInput = false
            Timer.tween(1, {
                [self] = {rectOpacity = 255}
            }):finish(function()
                gStateMachine:change('begin', MENU_DEFS[self.currentMenu].options[self.selected].param['level'])
            end)
        else
        --if the currently selected item's action is any other string, change to that menu
            self.currentMenu = MENU_DEFS[self.currentMenu].options[self.selected].action
            self.selected = 1
        end
    end
    --change currently selected menu item up
    if love.keyboard.wasPressed(KEY_MOVE_UP) or love.keyboard.wasPressed(KEY_ATTACK_UP) and self.allowInput then
        self.selected = self.selected  - 1
        if self.selected == 0 then
            self.selected = #MENU_DEFS[self.currentMenu].options
        end
    end
    --change currently selected menu item down
    if love.keyboard.wasPressed(KEY_MOVE_DOWN) or love.keyboard.wasPressed(KEY_ATTACK_DOWN) and self.allowInput then
        self.selected = self.selected + 1
        if self.selected == #MENU_DEFS[self.currentMenu].options + 1 then
            self.selected = 1
        end
    end
end

function StartState:render()
    --draw background first
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(gTextures['background'], 0, -100)

    --set font for this menu's text. If its indicated this is a title, use a bigger font. If this is a paragraph of information, use a smaller text
    if MENU_DEFS[self.currentMenu].type == 'title' then love.graphics.setFont(gFonts['title'])
    elseif MENU_DEFS[self.currentMenu].type == 'paragraph' then love.graphics.setFont(gFonts['medium']) end

    love.graphics.setColor(255, 255, 255, 255)

    --Draw actual text of this submenu. Draw centered in the upper third of this screen if a title, otherwise use up full upper part of screen with 50 pixel margin on either side
    if MENU_DEFS[self.currentMenu].type == 'title' then love.graphics.printf(MENU_DEFS[self.currentMenu].text, 0, VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH, 'center')
    elseif MENU_DEFS[self.currentMenu].type == 'paragraph' then love.graphics.printf(MENU_DEFS[self.currentMenu].text, 50, 10, VIRTUAL_WIDTH - 100, 'center') end

    love.graphics.setFont(gFonts['large'])

    for i = 1, #MENU_DEFS[self.currentMenu].options do
        --draw drop shadow
        love.graphics.setColor(0, 0, 0, 255)
        love.graphics.printf(MENU_DEFS[self.currentMenu].options[i].text,
        3,
        (VIRTUAL_HEIGHT * 3 / 5) + ((i - 1) / (#MENU_DEFS[self.currentMenu].options)) * (VIRTUAL_HEIGHT / 3 - 10) + 3,
        VIRTUAL_WIDTH, 'center'
        )
        
        --print text white, or yellow if currently selected
        love.graphics.setColor(255, 255, self.selected == i and 0 or 255, 255)
        love.graphics.printf(MENU_DEFS[self.currentMenu].options[i].text,
        0,
        (VIRTUAL_HEIGHT * 3 / 5) + ((i - 1) / (#MENU_DEFS[self.currentMenu].options)) * (VIRTUAL_HEIGHT / 3 - 10),
        VIRTUAL_WIDTH, 'center'
        )
    end

    --rectangle for transition
    love.graphics.setColor(255, 255, 255, self.rectOpacity)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end