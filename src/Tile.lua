--[[
    
]]

Tile = Class{}

function Tile:init(x, y, id)
    self.x = x
    self.y = y

    self.width = TILE_SIZE
    self.height = TILE_SIZE

    self.id = id
end

function Tile:render()
    love.graphics.draw(gTextures['hell-tiles'], gFrames['hell-tiles'][self.id],
        (self.x - 1) * TILE_SIZE, (self.y - 1) * TILE_SIZE)
end