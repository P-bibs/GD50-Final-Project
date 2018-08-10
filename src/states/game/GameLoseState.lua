--[[
    State for when the player loses
]]
GameLoseState = Class {__includes = BaseState}

function GameLoseState:enter(def) 
    --tween transition rect
    self.rectangleOpacity = 255
    Timer.tween(.5, {
        [self] = {rectangleOpacity = 0}
    })
end

function GameLoseState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('start')
    end
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function GameLoseState:render()
    --draw background
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(gTextures['background'], 0, -100)

    --draw a bunch of text with 3 pixel drop shadow
    love.graphics.setColor(100, 100, 100, 255)
    love.graphics.printf('Oh No!', 3, VIRTUAL_HEIGHT / 5 + 3, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setFont(gFonts['title'])
    love.graphics.printf('Oh No!', 0, VIRTUAL_HEIGHT / 5, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(100, 100, 100, 255)
    love.graphics.printf('You were overcome by the monsters', 3, VIRTUAL_HEIGHT * 2 / 5 + 3, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setFont(gFonts['title'])
    love.graphics.printf('You were overcome by the monsters', 0, VIRTUAL_HEIGHT * 2 / 5, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(100, 100, 100, 255)
    love.graphics.printf('Press enter to go back to the menu and try again\nYou can select specific unlocked levels from level select', 3, VIRTUAL_HEIGHT * 3 / 5 + 3, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setFont(gFonts['title'])
    love.graphics.printf('Press enter to go back to the menu and try again\nYou can select specific unlocked levels from level select', 0, VIRTUAL_HEIGHT * 3 / 5, VIRTUAL_WIDTH, 'center')

    --rectangle for transition
    love.graphics.setColor(255, 255, 255, self.rectangleOpacity)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end