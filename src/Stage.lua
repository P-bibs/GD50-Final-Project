--[[
    
]]

Stage = Class{}

function Stage:init(entities, tilemap)
    self.entities = entities
    self.tileMap = tilemap
end

--[[
    Remove all nil references from tables in case they've set themselves to nil.
]]
function Stage:clear()
    for i = #self.entities, 1, -1 do
        if not self.entities[i] then
            table.remove(self.entities, i)
        end
    end
end

function Stage:update(dt)
    self.tileMap:update(dt)

    for k, entity in pairs(self.entities) do
        entity:update(dt)
        
    end
end

function Stage:render()
    self.tileMap:render()

    for k, entity in pairs(self.entities) do
        entity:render()
    end
end