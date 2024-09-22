local Unlocker, awful, apex = ...

if (GetSpecialization() ~= 2 and awful.player.class2 == "WARRIOR") or (awful.player.class2 ~= "WARRIOR") then return end
    
print("Fury Loaded")

local fury = apex.warrior.fury
local player, target, focus = awful.player, awful.target, awful.focus

awful.Populate({
    avatar = awful.Spell(107574),
    berserkerRage = awful.Spell(18499, {targeted = false}),
    bladestorm = awful.Spell(227847, {targeted = false}),
    bloodthirst = awful.Spell(23881),
    championsSpear = awful.Spell(376079, { targeted = false }),
    enragedRegeneration = awful.Spell(184364, {targeted = false}),
    execute = awful.Spell(5308),
    impendingVictory = awful.Spell(202168),
    odynsFury = awful.Spell(385059, {targeted = false}),
    onslaught = awful.Spell(315720),
    pummel = awful.Spell(6552, { ignoreGCD = true }),
    ragingBlow = awful.Spell(85288),
    rampage = awful.Spell(184367),
    recklessness = awful.Spell(1719, {targeted = false}),
    slam = awful.Spell(1464),
    thunderousRoar = awful.Spell(384318, { targeted = false }),
    whirlwind = awful.Spell(190411),
    warriorautoAttack = awful.Spell(6603),
}, fury, getfenv(1))

enemiesAround = 0

-- Generic --

warriorautoAttack:Callback("warriorautoAttack", function(spell, unit)
    if C_Spell.IsCurrentSpell(6603) then return end

    return spell:Cast()
end)

-- End Generic --

-- Utility --

pummel:Callback("pummel_pve", function(spell, unit)
    if unit.casting
    and unit.castRemains <= .5 then
        return spell:Cast(unit)
    end
end)

-- End Utility --


-- Test --

recklessness:Callback("recklessness_slayer_st_1", function(spell, unit)
    if not IsShiftKeyDown() then return end
    
    if (not player.hasTalent("anger management") and avatar.cd < 1 and player.hasTalent("titan's torment"))
    or player.hasTalent("anger management")
    or not player.hasTalent("titan's torment") then
        return spell:Cast()
    end
end)

avatar:Callback("avatar_slayer_st_2", function(spell, unit)
    if not IsShiftKeyDown() then return end

    local hasTitanTorment = player.hasTalent("titan's torment")
    local hasTitanicRage = player.hasTalent("titanic rage")
    local hasChampionMight = player.hasTalent("champion's might")
    local enrageBuff = player.buff("enrage")
    local championSpearDebuff = unit.debuff("champion's spear")

    if (hasTitanTorment and (enrageBuff or hasTitanicRage) and (championSpearDebuff or not hasChampionMight))
    or not hasTitanTorment then
        return spell:Cast()
    end
end)

thunderousRoar:Callback("thunderousRoar_slayer_st_3", function(spell, unit)
    if not IsShiftKeyDown() then return end

    if player.buff("enrage") then
        return spell:Cast()
    end
end)

championsSpear:Callback("championsSpear_slayer_st_4", function(spell, unit)
    if not IsShiftKeyDown() then return end

    if player.buff("enrage") and (player.hasTalent("titan's torment") and avatar.cd < player.gcdRemains or not player.hasTalent("titan's torment")) then
        return spell:AoECast(unit)
    end
end)

odynsFury:Callback("odynsFury_slayer_st_5", function(spell, unit)
    if not (IsShiftKeyDown() or IsAltKeyDown()) then return end

    if unit.debuffRemains("odyn's fury") < 1 and (player.buff("enrage") or player.hasTalent("titanic rage")) and avatar.cd then
        return spell:Cast()
    end
end)

execute:Callback("execute_slayer_st_6", function(spell, unit)
    if unit.debuffStacks("marked for execution") == 3 or (player.hasTalent("ashen juggernaut") and player.buffRemains("ashen juggernaut") <= player.gcdRemains and player.buff("enrage")) then
        return spell:Cast()
    end
end)

rampage:Callback("rampage_slayer_st_7", function(spell, unit)
    if player.hasTalent("bladestorm") and bladestorm.cd <= player.gcdRemains and not unit.debuff("champion's might") then
        return spell:Cast()
    end
end)

bladestorm:Callback("bladestorm_slayer_st_8", function(spell, unit)
    if not (IsShiftKeyDown() or IsAltKeyDown()) then return end

    if player.buff("enrage") and avatar.cd >= 9 then
        return spell:Cast()
    end
end)

onslaught:Callback("onslaught_slayer_st_9", function(spell, unit)
    if player.hasTalent("tenderize") and player.buff("brutal finish") then
        return spell:Cast()
    end
end)

rampage:Callback("rampage_slayer_st_10", function(spell, unit)
    if player.hasTalent("anger management") then
        return spell:Cast()
    end
end)

ragingBlow:Callback("ragingBlow_slayer_st_11", function(spell, unit)
    if player.buff("crushing blow") then
        return spell:Cast()
    end
end)

onslaught:Callback("onslaught_slayer_st_12", function(spell, unit)
    if player.hasTalent("tenderize") then
        return spell:Cast()
    end
end)

bloodthirst:Callback("bloodthirst_slayer_st_13", function(spell, unit)
    if player.buff("bloodbath") and player.rage < 100 or (unit.hp < 35 and player.hasTalent("vicious contempt")) then
        return spell:Cast()
    end
end)

ragingBlow:Callback("ragingBlow_slayer_st_14", function(spell, unit)
    if player.rage < 100 and not player.buff("opportunist") then
        return spell:Cast()
    end
end)

rampage:Callback("rampage_slayer_st_15", function(spell, unit)
    if player.hasTalent("reckless abandon") then
        return spell:Cast()
    end
end)

execute:Callback("execute_slayer_st_16", function(spell, unit)
    if player.buff("enrage") and unit.debuff("marked for execution") then
        return spell:Cast()
    end
end)

bloodthirst:Callback("bloodthirst_slayer_st_17", function(spell, unit)
    if not player.hasTalent("reckless abandon") and player.buff("enrage") then
        return spell:Cast()
    end
end)

ragingBlow:Callback("ragingBlow_slayer_st_18", function(spell, unit)
    return spell:Cast()
end)

onslaught:Callback("onslaught_slayer_st_19", function(spell, unit)
    return spell:Cast()
end)

execute:Callback("execute_slayer_st_20", function(spell, unit)
    return spell:Cast()
end)

bloodthirst:Callback("bloodthirst_slayer_st_21", function(spell, unit)
    return spell:Cast()
end)

whirlwind:Callback("whirlwind_slayer_st_22", function(spell, unit)
    if player.hasTalent("meat cleaver") then
        return spell:Cast()
    end
end)

slam:Callback("slam_slayer_st_23", function(spell, unit)
    return spell:Cast()
end)

-- Aoe --

recklessness:Callback("recklessness_slayer_mt_1", function(spell, unit)
    if not IsShiftKeyDown() then return end

    if (not player.hasTalent("anger management") and avatar.cd < 1 and player.hasTalent("titan's torment"))
    or player.hasTalent("anger management")
    or not player.hasTalent("titan's torment") then
        return spell:Cast()
    end
end)

avatar:Callback("avatar_slayer_mt_2", function(spell, unit)
    if not IsShiftKeyDown() then return end

    local hasTitanTorment = player.hasTalent("titan's torment")
    local hasTitanicRage = player.hasTalent("titanic rage")
    local hasChampionMight = player.hasTalent("champion's might")
    local enrageBuff = player.buff("enrage")
    local championSpearDebuff = unit.debuff("champion's spear")

    if (hasTitanTorment and (enrageBuff or hasTitanicRage) and (championSpearDebuff or not hasChampionMight))
    or not hasTitanTorment then
        return spell:Cast()
    end
end)

thunderousRoar:Callback("thunderousRoar_slayer_mt_3", function(spell, unit)
    if not IsShiftKeyDown() then return end

    if player.buff("enrage") then
        return spell:Cast()
    end
end)

championsSpear:Callback("championsSpear_slayer_mt_4", function(spell, unit)
    if not IsShiftKeyDown() then return end

    if player.buff("enrage") and (player.hasTalent("titan's torment") and avatar.cd < player.gcdRemains or not player.hasTalent("titan's torment")) then
        return spell:AoECast(unit)
    end
end)

odynsFury:Callback("odynsFury_slayer_mt_5", function(spell, unit)
    if not (IsShiftKeyDown() or IsAltKeyDown()) then return end
    if unit.debuffRemains("odyn's fury") < 1 and (player.buff("enrage") or player.hasTalent("titanic rage")) and avatar.cd then
        return spell:Cast()
    end
end)

whirlwind:Callback("whirlwind_slayer_mt_6", function(spell, unit)
    if player.buffStacks("whirlwind") == 0 and player.hasTalent("meat cleaver") then
        return spell:Cast()
    end
end)

execute:Callback("execute_slayer_mt_7", function(spell, unit)
    if player.hasTalent("ashen juggernaut") and player.buffRemains("ashen juggernaut") <= player.gcdRemains and player.buff("enrage") then
        return spell:Cast()
    end
end)

rampage:Callback("rampage_slayer_mt_8", function(spell, unit)
    if player.hasTalent("bladestorm") and bladestorm.cd <= player.gcdRemains and not unit.debuff("champion's might") then
        return spell:Cast()
    end
end)

bladestorm:Callback("bladestorm_slayer_mt_9", function(spell, unit)
    if not (IsShiftKeyDown() or IsAltKeyDown()) then return end

    if player.buff("enrage") and avatar.cd >= 9 then
        return spell:Cast()
    end
end)

onslaught:Callback("onslaught_slayer_mt_10", function(spell, unit)
    if player.hasTalent("tenderize") and player.buff("brutal finish") then
        return spell:Cast()
    end
end)

rampage:Callback("rampage_slayer_mt_11", function(spell, unit)
    if player.hasTalent("anger management") then
        return spell:Cast()
    end
end)

ragingBlow:Callback("ragingBlow_slayer_mt_12", function(spell, unit)
    if player.buff("crushing blow") then
        return spell:Cast()
    end
end)

onslaught:Callback("onslaught_slayer_mt_13", function(spell, unit)
    if player.hasTalent("tenderize") then
        return spell:Cast()
    end
end)

bloodthirst:Callback("bloodthirst_slayer_mt_14", function(spell, unit)
    if player.buff("bloodbath") and player.buff("enrage") then
        return spell:Cast()
    end
end)

rampage:Callback("rampage_slayer_mt_15", function(spell, unit)
    if player.hasTalent("reckless abandon") then
        return spell:Cast()
    end
end)

execute:Callback("execute_slayer_mt_16", function(spell, unit)
    if player.buff("enrage") and unit.debuff("marked for execution") then
        return spell:Cast()
    end
end)

bloodthirst:Callback("bloodthirst_slayer_mt_17", function(spell, unit)
    if player.buff("bloodbath") then
        return spell:Cast()
    end
end)

ragingBlow:Callback("ragingBlow_slayer_mt_18", function(spell, unit)
    if player.hasTalent("slaughtering strikes") then
        return spell:Cast()
    end
end)

onslaught:Callback("onslaught_slayer_mt_19", function(spell, unit)
    return spell:Cast()
end)

execute:Callback("execute_slayer_mt_20", function(spell, unit)
    return spell:Cast()
end)

bloodthirst:Callback("bloodthirst_slayer_mt_21", function(spell, unit)
    return spell:Cast()
end)

ragingBlow:Callback("ragingBlow_slayer_mt_22", function(spell, unit)
    return spell:Cast()
end)

whirlwind:Callback("whirlwind_slayer_mt_23", function(spell, unit)
    return spell:Cast()
end)

-- Callbacks invocation in the correct order
fury:Init(function()
    if player.mounted then return end
    if player.dead then return end

    enemiesAround = awful.enemies.around(player, 8)

    if enemiesAround > 0 then
        fury.castingEnemies = awful.enemies.filter(function(unit) return unit.casting and unit.los end)

        if focus.exists then
            fury.pummel("pummel_pve", focus)
        end

        fury.castingEnemies.loop(function(unit)
            if not focus.exists then
                fury.pummel("pummel_pve", unit)
            end
        end)

        warriorautoAttack("warriorautoAttack", target)

        if enemiesAround == 1 then
            recklessness("recklessness_slayer_st_1", target)
            avatar("avatar_slayer_st_2", target)
            thunderousRoar("thunderousRoar_slayer_st_3", target)
            championsSpear("championsSpear_slayer_st_4", target)
            odynsFury("odynsFury_slayer_st_5", target)
            execute("execute_slayer_st_6", target)
            rampage("rampage_slayer_st_7", target)
            bladestorm("bladestorm_slayer_st_8", target)
            onslaught("onslaught_slayer_st_9", target)
            rampage("rampage_slayer_st_10", target)
            ragingBlow("ragingBlow_slayer_st_11", target)
            onslaught("onslaught_slayer_st_12", target)
            bloodthirst("bloodthirst_slayer_st_13", target)
            ragingBlow("ragingBlow_slayer_st_14", target)
            rampage("rampage_slayer_st_15", target)
            execute("execute_slayer_st_16", target)
            bloodthirst("bloodthirst_slayer_st_17", target)
            ragingBlow("ragingBlow_slayer_st_18", target)
            onslaught("onslaught_slayer_st_19", target)
            execute("execute_slayer_st_20", target)
            bloodthirst("bloodthirst_slayer_st_21", target)
            whirlwind("whirlwind_slayer_st_22", target)
            slam("slam_slayer_st_23", target)
        else
            recklessness("recklessness_slayer_mt_1", target)
            avatar("avatar_slayer_mt_2", target)
            thunderousRoar("thunderousRoar_slayer_mt_3", target)
            championsSpear("championsSpear_slayer_mt_4", target)
            odynsFury("odynsFury_slayer_mt_5", target)
            whirlwind("whirlwind_slayer_mt_6", target)
            execute("execute_slayer_mt_7", target)
            rampage("rampage_slayer_mt_8", target)
            bladestorm("bladestorm_slayer_mt_9", target)
            onslaught("onslaught_slayer_mt_10", target)
            rampage("rampage_slayer_mt_11", target)
            ragingBlow("ragingBlow_slayer_mt_12", target)
            onslaught("onslaught_slayer_mt_13", target)
            bloodthirst("bloodthirst_slayer_mt_14", target)
            rampage("rampage_slayer_mt_15", target)
            execute("execute_slayer_mt_16", target)
            bloodthirst("bloodthirst_slayer_mt_17", target)
            ragingBlow("ragingBlow_slayer_mt_18", target)
            onslaught("onslaught_slayer_mt_19", target)
            execute("execute_slayer_mt_20", target)
            bloodthirst("bloodthirst_slayer_mt_21", target)
            ragingBlow("ragingBlow_slayer_mt_22", target)
            whirlwind("whirlwind_slayer_mt_23", target)
        end
    end
end, .05)
