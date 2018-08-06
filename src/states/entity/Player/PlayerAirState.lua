--[[
    GD50
    Super Mario Bros. Remake

    -- PlayerAirState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerAirState = Class{__includes = BaseState}

function PlayerAirState:init(player, gravity)
    self.player = player
    self.player:changeAnimation('idle')
end

function PlayerAirState:update(dt)
    self.player.currentAnimation:update(dt)

    if love.keyboard.isDown(KEY_MOVE_LEFT) then
        self.player:changeAnimation('slide-left')
    elseif love.keyboard.isDown(KEY_MOVE_RIGHT) then
        self.player:changeAnimation('slide-right')
    else
        self.player:changeAnimation('idle')
    end

    -- if we get a collision beneath us, go into ground state
    if self.player.y + self.player.height > 0 then
        self.player:changeState('ground')
    end
end