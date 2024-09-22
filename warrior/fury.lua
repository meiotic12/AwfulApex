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

-- Cooldowns --

recklessness:Callback("recklessness_slayer", function(spell, unit)
    if not IsShiftKeyDown() then return end

    if (not player.hasTalent("anger management") and avatar.cd < 1 and player.hasTalent("titan's torment"))
    or player.hasTalent("anger management")
    or not player.hasTalent("titan's torment") then
    
        return spell:Cast()
    end
end)

avatar:Callback("avatar_slayer", function(spell, unit)
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

thunderousRoar:Callback("thunderousRoar_slayer", function(spell, unit)
    if IsShiftKeyDown() and player.buff("enrage") then
        return spell:Cast()
    end
end)

championsSpear:Callback("championsSpear_slayer", function(spell, unit)
    if not IsShiftKeyDown() then return end

    if player.buff("enrage") then
        return spell:AoECast(unit)
    end
end)

odynsFury:Callback("odynsFury_slayer", function(spell, unit)
    if not (IsShiftKeyDown() or IsAltKeyDown()) then return end

    if unit.debuffRemains("odyn's fury") < 1 
    and (player.buff("enrage") or player.hasTalent("titanic rage")) then
        return spell:Cast()
    end
end)

bladestorm:Callback("bladestorm_slayer", function(spell, unit)
    if not (IsShiftKeyDown() or IsAltKeyDown()) then return end

    if IsShiftKeyDown() then
        if avatar.cd < 9 then return end
    end

    if player.buff("enrage") then 
        return spell:Cast()
    end
end)

-- End Cooldowns --

-- Rotation --

onslaught:Callback("onslaught", function(spell, unit)
    return spell:Cast(unit)
end)

onslaught:Callback("onslaught_slayer_buff", function(spell, unit)
    if player.hasTalent("tenderize") and player.buff("brutal finish") then
        return spell:Cast(unit)
    end
end)

onslaught:Callback("onslaught_slayer_talent", function(spell, unit)
    if player.hasTalent("tenderize") then
        return spell:Cast(unit)
    end
end)

rampage:Callback("rampage_slayer_preBladestorm", function(spell, unit)
    if player.hasTalent("bladestorm")
    and bladestorm.cd <= player.gcdRemains
    and not unit.debuff("champion's might") then

        return spell:Cast(unit)
    end
end)

rampage:Callback("rampage_slayer_ra", function(spell, unit)
     if player.hasTalent("reckless abandon") then
        return spell:Cast(unit)
    end
end)

rampage:Callback("rampage_slayer_angerManagement", function(spell, unit)
    if player.hasTalent("anger management") then
        return spell:Cast(unit)
    end
end)

execute:Callback("execute", function(spell, unit)
    return spell:Cast(unit)
end)

execute:Callback("execute_slayer_aj", function(spell, unit)
    if unit.debuffStacks("marked for execution") == 3
    or (player.hasTalent("ashen juggernaut")
    and player.buffRemains("ashen juggernaut") < (player.gcd + .2)
    and player.buff("enrage")) then
        return spell:Cast(unit)
    end
end)

execute:Callback("execute_slayer_enrage", function(spell, unit)
    if unit.debuff("marked for execution")
    and player.buff("enrage") then
        return spell:Cast(unit)
    end
end)

ragingBlow:Callback("ragingBlow", function(spell, unit)
    return spell:Cast(unit)
end)

ragingBlow:Callback("crushingBlow", function(spell, unit)
    if not player.buff("crushing blow") then return end
    
    return spell:Cast(unit)
end)

ragingBlow:Callback("ragingBlow_slayer_talent", function(spell, unit)
    if not player.hasTalent("slaughtering strikes") then 
        return spell:Cast(unit)
    end
end)

ragingBlow:Callback("ragingBlow_slayer_builder", function(spell, unit)
    if player.rage < 100 
    and not player.buff("opportunist") then
        return spell:Cast(unit)
    end
end)

bloodthirst:Callback("bloodbath_slayer_enrage", function(spell, unit)
    if player.rage < 100 
    or (unit.hp < 35 and player.hasTalent("viscious_contempt")) then
        return spell:Cast(unit)
    end
end)

bloodthirst:Callback("bloodbath", function(spell, unit)
    if player.buff("bloodbath") then
        return spell:Cast(unit)
    end
end)

bloodthirst:Callback("bloodthirst", function(spell, unit)
    return spell:Cast(unit)
end)

whirlwind:Callback("whirlwind", function(spell, unit)
    return spell:Cast()
end)

whirlwind:Callback("whirlwind_meatcleaver_noStacks", function(spell, unit)
    if not player.hasTalent("improved whirlwind") then return end
    if player.buffStacks("whirlwind") > 0 then return end
    
    return spell:Cast()
end)

whirlwind:Callback("whirlwind_meatcleaver", function(spell, unit)
    if not player.hasTalent("meat cleaver") then return end
    
    return spell:Cast()
end)

slam:Callback("slam", function(spell, unit)
    return spell:Cast(unit)
end)

-- End Rotation --

fury:Init(function()

    if player.mounted then return end
    if player.dead then return end

    enemiesAround = awful.enemies.around(player, 8)
    
    if enemiesAround > 0 then

        warriorautoAttack("warriorautoAttack", target) 

        if enemiesAround == 1 then
            recklessness("recklessness_slayer", target) 
            avatar("avatar_slayer", target) 
            thunderousRoar("thunderousRoar_slayer", target) 
            championsSpear("championsSpear_slayer", target) 
            odynsFury("odynsFury_slayer", target) 
            execute("execute_slayer_aj",target) 
            rampage("rampage_slayer_preBladestorm", target) 
            bladestorm("bladestorm_slayer", target) 
            onslaught("onslaught_slayer_buff", target) 
            rampage("rampage_slayer_angerManagement", target) 
            ragingBlow("crushingBlow", target) 
            onslaught("onslaught_slayer_talent", target) 
            bloodthirst("bloodbath_slayer_enrage", target) 
            ragingBlow("ragingBlow_slayer_builder", target) 
            execute("execute_slayer_enrage",target) 
            rampage("rampage_slayer_ra", target) 
            ragingBlow("ragingBlow", target) 
            onslaught("onslaught", target) 
            execute("execute",target) 
            bloodthirst("bloodthirst", target) 
            whirlwind("whirlwind_meatcleaver", target) 
            slam("slam", target) 
        end

        if enemiesAround > 1 then
            warriorautoAttack("warriorautoAttack", target) 
            recklessness("recklessness_slayer", target) 
            avatar("avatar_slayer", target) 
            thunderousRoar("thunderousRoar_slayer", target) 
            championsSpear("championsSpear_slayer", target) 
            odynsFury("odynsFury_slayer", target) 
            whirlwind("whirlwind_meatcleaver_noStacks", target)  
            execute("execute_slayer_aj",target) 
            rampage("rampage_slayer_preBladestorm", target) 
            bladestorm("bladestorm_slayer", target) 
            onslaught("onslaught_slayer_buff", target) 
            rampage("rampage_slayer_angerManagement", target) 
            ragingBlow("crushingBlow", target) 
            onslaught("onslaught_slayer_talent", target) 
            bloodthirst("bloodbath_slayer_enrage", target) 
            rampage("rampage_slayer_ra", target) 
            execute("execute_slayer_enrage",target) 
            bloodthirst("bloodbath", target) 
            ragingBlow("ragingBlow_slayer_talent", target) 
            onslaught("onslaught", target) 
            execute("execute",target) 
            bloodthirst("bloodthirst", target) 
            ragingBlow("ragingBlow", target) 
            whirlwind("whirlwind", target) 
        end
    end

end, .05)