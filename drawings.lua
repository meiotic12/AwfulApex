local Unlocker, awful, apex = ...

local player = awful.player
local Draw = awful.Draw

print("Drawings Loaded")

local danger_circles = {
    ["Pulverizing Pounce"] = { radius = 5 },
}

local frontals = {
    ["Web Spray"] = {},
    ["Impale"] = {},
    ["Earthshatter"] = {},
    ["Terrorize"] = {},
    ["Null Slam"] = {},
    ["Earthshatter"] = {},
    ["Shade Slash"] = {},
    ["Umbral Slash"] = {},
    ["Ice Sickles"] = {},
    ["Earthshatter"] = {},
    ["Awakening Calling"] = {},
    ["Black Edge"] = {},
    ["Dark Orb"] = {},
    ["Seismic Wave"] = { length = 30, arc = 45},
    ["Lava Cannon"] = {},
    ["Shield Stampede"] = {},
    ["Unbridled Void"] = {},
    ["Bewildering Pollen"] = {},
    ["Radiant Breath"] = {},
    ["Tongue Lashing"] = {},
    ["Dodge Ball"] = {},
    ["Heaving Retch"] = {},
    ["Gruesome Cleave"] = {},
    ["Necrotic Breath"] = {},
    ["Gutslice"] = {},
    ["Slobber Knocker"] = {},
    ["Heavy Slash"] = {},
    ["Broadside"] = {},
    ["Clear the Deck"] = {},
    ["Crashing Tide"] = {},
    ["Blazing Shadowflame"] = {},
    ["Fiery Cleave"] = {},
    ["Shadowflame Blast"] = {},
    ["Devouring Flame"] = {}
}

local castingEnemies = {}

awful.onEvent(function(info, event, source, dest)
    if source.enemy then
        if event == "SPELL_CAST_START" or event == "SPELL_CHANNEL_START" then
            castingEnemies[source.guid] = source
        elseif event == "SPELL_CAST_SUCCESS" or event == "SPELL_CAST_FAILED" or event == "SPELL_INTERRUPT" or event == "SPELL_CHANNEL_STOP" or event == "UNIT_DIED" then
            castingEnemies[source.guid] = nil
        end
    end
end)

awful.onEvent(function(info, event)
    if event == "LOADING_SCREEN_ENABLED" then
        castingEnemies = {}
        print("Load screen detected, castingEnemies cleared")
    end
end)

Draw(function(draw)
    local x,y,z = player.position()
    local rotation = player.rotation

    -- awful.triggers.loop(function(trigger)
    --     local tx, ty, tz = trigger.position()
    --     draw:SetColor(255,0,0,120)
    --     draw:FilledCircle(tx, ty, tz, 10)
    -- end)

    -- awful.missiles.loop(function(missile)
    --     local mx, my, mz = missile.tx, missile.ty, missile.tz
    --     draw:SetColor(255,0,0,120)
    --     draw:FilledCircle(mx, my, mz, 10)
    -- end)

    for guid, enemy in pairs(castingEnemies) do
        if (frontals[enemy.casting]) or (frontals[enemy.channeling]) then
            local ex, ey, ez = enemy.position()
            draw:SetColor(255,0,0,120)
            draw:Arc(ex, ey, ez, frontals[enemy.casting]['length'], frontals[enemy.casting]['arc'], enemy.rotation)
            draw:FilledArc(ex, ey, ez, frontals[enemy.casting]['length'] * (enemy.castPct / 100), frontals[enemy.casting]['arc'], enemy.rotation)
        end

        if (danger_circles[enemy.casting]) or (danger_circles[enemy.channeling]) then
            print(enemy.casting)
            local ex, ey, ez = enemy.castTarget.position()
            print(ex)
            
            draw:SetColor(255,0,0,120)
            draw:FilledCircle(ex, ey, ez, danger_circles[enemy.casting]['radius'])
            print(enemy.castTarget.position())
        end
    end
end)