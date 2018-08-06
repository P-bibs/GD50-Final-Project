--[[
    GD50
    Super Mario Bros. Remake

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerJumpState = Class{__includes = BaseState}

function PlayerJumpState:init(player, gravity)
    self.player = player
    self.gravity = gravity
    self.animation = Animation {
        frames = {3},
        interval = 1
    }
    self.player:changeAnimation('idle')
end

function PlayerJumpState:enter(params)

end

function PlayerJumpState:update(dt)
    self.player.currentAnimation:update(dt)

    -- go into the falling state when y velocity is positive
    if self.player.vy <= 0 then
        self.player:changeState('air')
    end

    -- look at two tiles above our head and check for collisions; 3 pixels of leeway for getting through gaps
    local tileLeft = self.player.map:pointToTile(self.player.x + 3, self.player.y)
    local tileRight = self.player.map:pointToTile(self.player.x + self.player.width - 3, self.player.y)

    -- if we get a collision up top, go into the falling state immediately
    if (tileLeft and tileRight) and (tileLeft:collidable() or tileRight:collidable()) then
        self.player.dy = 0
        self.player:changeState('falling')

    -- else test our sides for blocks
    elseif love.keyboard.isDown('left') then
        self.player.direction = 'left'
        self.player:checkLeftCollisions(dt)
    elseif love.keyboard.isDown('right') then
        self.player.direction = 'right'
        self.player:checkRightCollisions(dt)
    end

    -- check if we've collided with any collidable game objects
    for k, object in pairs(self.player.level.objects) do
        if object:collides(self.player) then
            if object.solid then
                object.onCollide(object, self.player)

                self.player.y = object.y + object.height
                self.player.dy = 0
                self.player:changeState('falling')
            elseif object.consumable then
                object.onConsume(self.player)
                table.remove(self.player.level.objects, k)
            end
        end
    end


end