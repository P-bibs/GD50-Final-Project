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

    if love.keyboard.isDown('left') then
        self.player:changeAnimation('slide-left')
    elseif love.keyboard.isDown('right') then
        self.player:changeAnimation('slide-right')
    else
        self.player:changeAnimation('idle')
    end


    -- look at two tiles below our feet and check for collisions
    local tileBottomLeft = self.player.map:pointToTile(self.player.x + 1, self.player.y + self.player.height)
    local tileBottomRight = self.player.map:pointToTile(self.player.x + self.player.width - 1, self.player.y + self.player.height)

    -- if we get a collision beneath us, go into either walking or idle
    if (tileBottomLeft and tileBottomRight) and (tileBottomLeft:collidable() or tileBottomRight:collidable()) then
        self.player.dy = 0


        self.player:changeState('ground')



        -- set the player to be walking or idle on landing depending on input
        -- if love.keyboard.isDown('left') or love.keyboard.isDown('right') then
        --     self.player:changeState('walking')
        -- else
        --     self.player:changeState('idle')
        -- end

        self.player.y = (tileBottomLeft.y - 1) * TILE_SIZE - self.player.height
    end
end