--[[
    State for when the player wins
]]
GameOverState = Class {__includes = BaseState}

function GameOverState:enter(def) 
    self.time = def.time

    --tween transition rect
    self.rectangleOpacity = 255
    Timer.tween(.5, {
        [self] = {rectangleOpacity = 0}
    })
end

function GameOverState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('start')
    end
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function GameOverState:render()
    --draw nice background
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(gTextures['win-background'], 0, 0)

    --draw a bunch of text with 3 pixel drop shadow
    love.graphics.setColor(100, 100, 100, 255)
    love.graphics.printf('Congratulations', 3, VIRTUAL_HEIGHT / 5 + 3, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setFont(gFonts['title'])
    love.graphics.printf('Congratulations', 0, VIRTUAL_HEIGHT / 5, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(100, 100, 100, 255)
    love.graphics.printf('You beat the boss in ' .. self.time .. ' seconds!', 3, VIRTUAL_HEIGHT * 2 / 5 + 3, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setFont(gFonts['title'])
    love.graphics.printf('You beat the boss in ' .. self.time .. ' seconds!', 0, VIRTUAL_HEIGHT * 2 / 5, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(100, 100, 100, 255)
    love.graphics.printf('Press enter to go back to the menu and see your best times or play levels again', 3, VIRTUAL_HEIGHT * 3 / 5 + 3, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setFont(gFonts['title'])
    love.graphics.printf('Press enter to go back to the menu and see your best times or play levels again', 0, VIRTUAL_HEIGHT * 3 / 5, VIRTUAL_WIDTH, 'center')

    --rectangle for transition
    love.graphics.setColor(255, 255, 255, self.rectangleOpacity)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end