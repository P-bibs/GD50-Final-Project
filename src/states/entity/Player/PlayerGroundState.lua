--[[
    GD50
    Super Mario Bros. Remake

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerGroundState = Class{__includes = BaseState}

function PlayerGroundState:init(player)
    self.player = player
end

function PlayerGroundState:update(dt)
    self.player.currentAnimation:update(dt)

    if self.player.vx == 0 then
        self.player:changeAnimation('idle')
    end

    if ((love.keyboard.isDown(KEY_MOVE_RIGHT) and self.player.vx < 0) or (love.keyboard.isDown(KEY_MOVE_LEFT) and self.player.vx > 0 )) and math.random(7) == 1 then
        table.insert(self.player.effects,
                GameObject(GAME_OBJECT_DEFS['dust'], self.player.x, self.player.y)
            )
            self.player.effects[#self.player.effects]:changeAnimation(tostring(math.random(0, 1)))
    end

    local tileBottomLeft = self.player.map:pointToTile(self.player.x + 1, self.player.y + self.player.height)
    local tileBottomRight = self.player.map:pointToTile(self.player.x + self.player.width - 1, self.player.y + self.player.height)

    -- temporarily shift player down a pixel to test for game objects beneath
    self.player.y = self.player.y + 1


    self.player.y = self.player.y - 1

    if love.keyboard.isDown(KEY_MOVE_LEFT) then
        self.player.direction = 'left'
        if self.player.vx < 0 then
            self.player:changeAnimation('walk-left')
        else
            self.player:changeAnimation('slide-left')
        end
    elseif love.keyboard.isDown(KEY_MOVE_RIGHT) then
        self.player.direction = 'right'
        if self.player.vx > 0 then
            self.player:changeAnimation('walk-right')
        else
            self.player:changeAnimation('slide-right')
        end
    end

end