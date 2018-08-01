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

    if ((love.keyboard.isDown('right') and self.player.vx < 0) or (love.keyboard.isDown('left') and self.player.vx > 0 )) and math.random(7) == 1 then
        table.insert(self.player.level.objects,
                GameObject(GAME_OBJECT_DEFS['dust'], self.player.x, self.player.y)
            )
            self.player.level.objects[#self.player.level.objects]:changeAnimation(tostring(math.random(0, 1)))
    end

    local tileBottomLeft = self.player.map:pointToTile(self.player.x + 1, self.player.y + self.player.height)
    local tileBottomRight = self.player.map:pointToTile(self.player.x + self.player.width - 1, self.player.y + self.player.height)

    -- temporarily shift player down a pixel to test for game objects beneath
    self.player.y = self.player.y + 1

    local collidedObjects = self.player:checkObjectCollisions()

    self.player.y = self.player.y - 1

    -- check to see whether there are any tiles beneath us
    if #collidedObjects == 0 and (tileBottomLeft and tileBottomRight) and (not tileBottomLeft:collidable() and not tileBottomRight:collidable()) then
        self.player.dy = 0
        self.player:changeState('air')
    elseif love.keyboard.isDown('left') then
        self.player.direction = 'left'
        self.player:checkLeftCollisions(dt)
        if self.player.vx < 0 then
            self.player:changeAnimation('walk-left')
        else
            self.player:changeAnimation('slide-left')
        end
    elseif love.keyboard.isDown('right') then
        self.player.direction = 'right'
        self.player:checkRightCollisions(dt)
        if self.player.vx > 0 then
            self.player:changeAnimation('walk-right')
        else
            self.player:changeAnimation('slide-right')
        end
    end

end