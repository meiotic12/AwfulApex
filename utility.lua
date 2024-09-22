local Unlocker, awful, apex = ...

print("Utility Loaded")

awful.onEvent(function(info, event, source, dest)
    if source ~= player then return end

    if event == "SPELL_CAST_SUCCESS" then
        awful.alert({
            message = info[13] .. " has been casted!",
            texture = info[12]
        })
    end
end)