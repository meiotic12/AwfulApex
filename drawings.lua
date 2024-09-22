local Unlocker, awful, apex = ...

local player = awful.player
local Draw = awful.Draw

Draw(function(draw)
    local x,y,z = player.position()

    draw:Circle(x, y, z, 8) -- Draw a circle at xyz with a radius and steps, steps being how many lines are used to draw the circle
end)