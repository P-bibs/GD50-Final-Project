--[[
    GD50
    Super Mario Bros. Remake

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerIdleState = Class{__includes = BaseState}

function PlayerIdleState:init(player)
    self.player = player

    self.player:changeAnimation('idle')

end

function PlayerIdleState:update(dt)
    if self.player.vx ~= 0 then
        self.player:changeState('walking')
    end

    if love.keyboard.wasPressed('space') then
        self.player:changeState('jump')
    end

    if love.keyboard.isDown('left') then
        self.player.direction = 'left'
        self.player:checkLeftCollisions(dt)
        self.player:changeAnimation('walk-left')
    elseif love.keyboard.isDown('right') then
        self.player.direction = 'right'
        self.player:checkRightCollisions(dt)
        self.player:changeAnimation('walk-right')
    end
end