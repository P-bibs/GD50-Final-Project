--[[
    Class that represents a set of frames for an animation
]]

Animation = Class{}

function Animation:init(def)
    self.frames = def.frames
    self.interval = def.interval
    self.texture = def.texture
    self.looping = def.looping == nil and true or def.looping

    self.timer = 0
    self.currentFrame = 1

    self.timesPlayed = 0

    self.frozen = false
end

function Animation:refresh()
    self.timer = 0
    self.currentFrame = 1
    self.timesPlayed = 0
end

function Animation:update(dt)
    -- if not a looping animation and we've played at least once, exit
    if not self.looping and self.timesPlayed > 0 then
        return
    end

    -- no need to update if animation is only one frame
    if #self.frames > 1 then
        --only update timer if animatio not frozen
        if not self.frozen then
            self.timer = self.timer + dt 
        end

        if self.timer > self.interval then
            self.timer = self.timer % self.interval

            self.currentFrame = math.max(1, (self.currentFrame + 1) % (#self.frames + 1))

            -- if we've looped back to the beginning, record
            if self.currentFrame == 1 then
                self.timesPlayed = self.timesPlayed + 1
            end
        end
    end
end

function Animation:getCurrentFrame()
    return self.frames[self.currentFrame]
end

--function to temporarily freeze animation
function Animation:freeze(duration)
    self.frozen = true
    Timer.after(duration, function() self.frozen = false end)
end