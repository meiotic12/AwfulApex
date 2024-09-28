local Unlocker, awful, apex = ...

local player = awful.player

print("Utility Loaded")

apex.WasCasting = { }
apex.WasCastingCheck = function()
    local time = awful.time
    if player.casting then
        apex.WasCasting[player.castID] = time
    end
    for spell, when in pairs(apex.WasCasting) do
        if time - when > 0.100+awful.latency then
            apex.WasCasting[spell] = nil
        end
    end
end
awful.onUpdate(apex.WasCastingCheck)

-- awful.onEvent(function(info, event, source, dest)
--     if source ~= player then return end

--     if event == "SPELL_CAST_SUCCESS" then
--         awful.alert({
--             message = info[13] .. " has been casted!",
--             texture = info[12]
--         })
--     end
-- end)