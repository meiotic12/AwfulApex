local Unlocker, awful, apex = ...

apex.movementKeybinds = {}

apex.getMovementKeybinds = function()
    local defaultKeybinds = {
        ["MOVEFORWARD"] = "w",
        ["MOVEBACKWARD"] = "s",
        ["TURNLEFT"] = "a",
        ["TURNRIGHT"] = "d",
        ["STRAFELEFT"] = "a",
        ["STRAFERIGHT"] = "d",
        ["JUMP"] = "spacebar",
    }

    for action, defaultKeybind in pairs(defaultKeybinds) do
        local keybind = GetBindingKey(action)
        local lowercaseAction = string.lower(action)

        if keybind then
            apex.movementKeybinds[keybind] = lowercaseAction
        end
    end
end

apex.getMovementKeybinds()

apex.modifierKeybinds = {
    ["LSHIFT"] = IsLeftShiftKeyDown,
    ["RSHIFT"] = IsRightShiftKeyDown,
    ["LCTRL"] = IsLeftControlKeyDown,
    ["RCTRL"] = IsRightControlKeyDown,
    ["LALT"] = IsLeftAltKeyDown,
    ["RALT"] = IsRightAltKeyDown,
    ["LMETA"] = IsLeftMetaKeyDown,
    ["RMETA"] = IsRightMetaKeyDown,
}

local function onKeyDown(self, key)
    if apex.movementKeybinds[key] then return end
    if apex.modifierKeybinds[key] then return end

    for modifierKey, modifier in pairs(apex.modifierKeybinds) do
        if apex.modifierKeybinds[modifierKey] then
            if modifier() then
                key = modifierKey .. "-" .. key
            end
        end
    end

    binding = GetBindingByKey(key)
    RunBinding(binding, "up")
end

local SmartPause = CreateFrame("Frame")
SmartPause:SetScript("OnKeyDown", onKeyDown)
SmartPause:SetPropagateKeyboardInput(true)