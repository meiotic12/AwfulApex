local Unlocks, awful, apex = ...

if (GetSpecialization() ~= 3 and awful.player.class2 == "WARRIOR") or (awful.player.class2 ~= "WARRIOR") then return end

local protection = apex.warrior.protection

local player, target, focus = awful.player, awful.target, awful.focus

awful.Populate({
    warriorautoAttack = awful.Spell(6603),

    avatar = awful.Spell(401150, { ignoreGCD = true }),
    championsSpear = awful.Spell(376079, { targeted = false }),
    demoralizingShout = awful.Spell(1160, { targeted = false }),
    execute = awful.Spell(163201),
    ignorePain = awful.Spell(190456, { ignoreGCD = true }),
    impendingVictory = awful.Spell(202168),
    lastStand = awful.Spell(12975, { ignoreGCD = true }),
    pummel = awful.Spell(6552, { ignoreGCD = true }),
    rallyingCry = awful.Spell(97462),
    ravager = awful.Spell(228920),
    revenge = awful.Spell(6572, { targeted = false }),
    shieldBlock = awful.Spell(2565, { ignoreGCD = true, ignoreFacing = true }),
    shieldCharge = awful.Spell(385952),
    shieldSlam = awful.Spell(23922),
    spellBlock = awful.Spell(392966, { ignoreGCD = true, ignoreFacing = true }),
    spellReflection = awful.Spell(23920, { targeted = false, ignoreGCD = true, ignoreFacing = true }),
    stormBolt = awful.Spell(107570),
    thunderClap = awful.Spell(6343),
    thunderousRoar = awful.Spell(384318, { targeted = false })
}, protection, getfenv(1))

print("Protection Warrior Loaded")

protection.enemiesAround = 0

-- Disruption --

protection.stormBolt:Callback("stormbolt_pve", function(spell, unit)
    if not unit.casting then return end

    for _, value in ipairs(protection.pve_Stuns) do
        if unit.casting == value then
            if (unit.castRemains <= 0.5 or unit.castRemains <= player.gcdRemains) then
                return spell:Cast(unit)
            end
        end
    end
end)

protection.pummel:Callback("pummel_optimal", function(spell, unit)
    if unit.castRemains > .5 then return end
    if unit.distance > spell.range then return end

    local canBeKicked = false

    for _, spellName in ipairs(protection.pve_Kicks) do
        if unit.casting == spellName then
            canBeKicked = true
            break
        end
    end

    if canBeKicked then
        return spell:Cast(unit)
    end
end)

protection.spellReflection:Callback("spellReflection_optimal", function(spell, unit)
    if unit.casting 
    and unit.castTarget.isUnit(player) 
    and unit.castRemains <= 0.5 then

        local canBeKicked = false

        if pummel.cd == 0 and pummel.range < unit.distance then
            for _, spellName in ipairs(protection.pve_Kicks) do
                if unit.casting == spellName then
                    canBeKicked = true
                    break
                end
            end

        end

        local canBeReflected = false

        if not canBeKicked then
            for _, spellName in ipairs(protection.pve_SpellReflect) do
                if unit.casting == spellName then
                    canBeReflected = true
                    break
                end
            end
        end

        if not canBeKicked and canBeReflected then
            return spell:Cast()
        end
    end
end)

protection.spellBlock:Callback("spellBlock_optimal", function(spell, unit)
    if unit.casting 
    and unit.castRemains <= 0.5 then

        local canBeKicked = false

        if pummel.cd == 0 and pummel.range < unit.distance then
            for _, spellName in ipairs(protection.pve_Kicks) do
                if unit.casting == spellName then
                    canBeKicked = true
                    break
                end
            end
        end

        local canBeReflected = false

        if not canBeKicked
        and (player.buff(23920) or spellReflection.cd == 0)
        and unit.castTarget.isUnit(player)  then
            for _, spellName in ipairs(protection.pve_SpellReflect) do
                if unit.casting == spellName then
                    canBeReflected = true
                    break
                end
            end
        end

        local canBeBlocked = false

        if not canBeKicked
        and not canBeReflected then
            for _, spellName in ipairs(protection.pve_SpellBlock) do
                if unit.casting == spellName then
                    canBeBlocked = true
                    break
                end
            end
        end

        if not isInKickList 
        and not canBeReflected 
        and canBeBlocked then
            return spell:Cast()
        end
    end
end)

-- End Disruption --

-- Generic --

protection.warriorautoAttack:Callback("warriorautoAttack", function(spell, unit)
    if C_Spell.IsCurrentSpell(6603) then return end

    return spell:Cast()
end)

protection.impendingVictory:Callback("impendingVictory", function(spell, unit)
    if player.hp <= 25 then 
        return spell:Cast(unit)
    end
end)

protection.ignorePain:Callback("ignorePain", function(spell, unit)
    local powerDeficit = player.maxRage - player.rage
    local shieldSlamCD = shieldSlam.cd
    local shieldChargeCD = shieldCharge.cd
    local demoralizingShoutCD = demoralizingShout.cd
    local avatarCD = avatar.cd
    local hasChampionsBulwark = player.hasTalent("champion's bulwark")
    local hasBoomingVoice = player.hasTalent("booming voice")
    local hasUnnervingFocus = player.hasTalent("unnerving focus")
    local hasHeavyRepercussions = player.hasTalent("heavy repercussions")
    local hasImpenetrableWall = player.hasTalent("impenetrable wall")
    local hasLastStandBuff = player.buff("last stand")
    local hasViolentOutburstBuff = player.buff("violent outburst")
    local hasSeeingRedBuff = player.buff("seeing red")
    local seeingRedStacks = hasSeeingRedBuff and player.buffStacks("seeing red") or 0
    local shieldBlockRemains = player.buffRemains("shield block")
    local tier31_2pc = true -- 2 piece set bonus

    -- if unit.hp >= 20 then
        if (powerDeficit <= 15 and shieldSlamCD == 0)
        or (powerDeficit <= 40 and shieldChargeCD == 0 and hasChampionsBulwark)
        or (powerDeficit <= 20 and shieldChargeCD == 0)
        or (powerDeficit <= 30 and demoralizingShoutCD == 0 and hasBoomingVoice)
        or (powerDeficit <= 20 and avatarCD == 0)
        or (powerDeficit <= 45 and demoralizingShoutCD == 0 and hasBoomingVoice and hasLastStandBuff and hasUnnervingFocus)
        or (powerDeficit <= 30 and avatarCD == 0 and hasLastStandBuff and hasUnnervingFocus)
        or (powerDeficit <= 20)
        or (powerDeficit <= 40 and shieldSlamCD == 0 and hasViolentOutburstBuff and hasHeavyRepercussions and hasImpenetrableWall)
        or (powerDeficit <= 55 and shieldSlamCD == 0 and hasViolentOutburstBuff and hasLastStandBuff and hasUnnervingFocus and hasHeavyRepercussions and hasImpenetrableWall)
        or (powerDeficit <= 17 and shieldSlamCD == 0 and hasHeavyRepercussions)
        or (powerDeficit <= 18 and shieldSlamCD == 0 and hasImpenetrableWall)
        or ((player.rage >= 70 or (hasSeeingRedBuff and seeingRedStacks == 7 and player.rage >= 35)) and shieldSlamCD <= 1 and shieldBlockRemains >= 4 and tier31_2pc) then
            return spell:Cast()
        end
    -- end
end)

protection.lastStand:Callback("lastStand", function(spell, unit)
    if player.hp <= 30 then 
        return spell:Cast()
    end
end)

protection.avatar:Callback("avatar", function(spell, unit)
    if not (IsShiftKeyDown() or IsAltKeyDown()) then return end

    if not player.buff("thunder blast")
    or player.buffStacks("thunder blast") <= 2 then
        return spell:Cast()
    end
end)

protection.ravager:Callback("ravager", function(spell, unit)
    if not (IsShiftKeyDown() or IsAltKeyDown()) then return end

    local x,y,z = ObjectRawPosition(unit.pointer)

    local wasLooking = IsMouselooking()

    if wasLooking then
        MouselookStop()
    end

    CastSpellByName(spell.name, {x, y, z})
    Click(x, y, z)

    if wasLooking then
        MouselookStart()
    end
end)

protection.demoralizingShout:Callback("demoralizingShout", function(spell, unit)
    if not (IsShiftKeyDown() or IsAltKeyDown()) then return end

    if player.hasTalent("booming voice") then
        return spell:Cast()
    end
end)

protection.championsSpear:Callback("championsSpear", function(spell, unit)
    if not (IsShiftKeyDown() or IsAltKeyDown()) then return end
    if not player.hasTalent("champion's spear") then return end

    local x,y,z = ObjectRawPosition(unit.pointer)

    local wasLooking = IsMouselooking()

    if wasLooking then
        MouselookStop()
    end

    CastSpellByName(spell.name, {x, y, z})
    Click(x, y, z)

    if wasLooking then
        MouselookStart()
    end
end)

protection.thunderousRoar:Callback("thunderousRoar", function(spell, unit)
    if not (IsShiftKeyDown() or IsAltKeyDown()) then return end
    if not player.hasTalent("thunderous roar") then return end
    return spell:Cast()
end)

protection.shieldCharge:Callback("shieldCharge", function(spell, unit)
    if not (IsShiftKeyDown() or IsAltKeyDown()) then return end

    return spell:Cast(unit)
end)

protection.shieldBlock:Callback("shieldBlock", function(spell, unit)
    if player.buffRemains("shield block") <= 10 then
        return spell:Cast()
    end
end)

protection.thunderClap:Callback("thunderblast_base", function(spell, unit)
    if protection.enemiesAround >= 2
    and player.buffStacks("thunder blast") == 2 then
        return spell:Cast()
    end
end)

-- End Generic --

-- AOE --

protection.thunderClap:Callback("thunderblast_aoe1", function(spell, unit)
    if player.buff("thunder blast")
    and unit.debuffRemains("rend") <= 1 then
        return spell:Cast()
    end
end)

protection.thunderClap:Callback("thunderclap_aoe1", function(spell, unit)
    if target.debuffRemains("rend") <= 1 then
        return spell:Cast()
    end
end)

protection.thunderClap:Callback("thunderblast_aoe2", function(spell, unit)
    if player.buff("thunder blast")
    and player.buff("violent outburst")
    and protection.enemiesAround >= 2
    and player.buff("avatar")
    and player.hasTalent("unstoppable force") then
        return spell:Cast()
    end
end)

protection.thunderClap:Callback("thunderclap_aoe2", function(spell, unit)
    if player.buff("violent outburst")
    and protection.enemiesAround >= 4
    and player.buff("avatar")
    and player.hasTalent("unstoppable force")
    and player.hasTalent("crashing thunder") then
        return spell:Cast()
    end

    if player.buff("violent outburst")
    and protection.enemiesAround > 6
    and player.buff("avatar")
    and player.hasTalent("unstoppable force") then
        return spell:Cast()
    end
end)

protection.revenge:Callback("revenge_aoe1", function(spell, unit)
    if player.rage >= 70
    and player.hasTalent("seismic reverberation")
    and protection.enemiesAround >= 3 then
        return spell:Cast()
    end
end)

protection.shieldSlam:Callback("shieldSlam_aoe", function(spell, unit)
    if player.rage <= 60
    or (player.buff("violent outburst")
    and protection.enemiesAround <= 4
    and player.hasTalent("crashing thunder")) then
        return spell:Cast(unit)
    end
end)

protection.thunderClap:Callback("thunderblast_aoe3", function(spell, unit)
    if player.buff("thunder blast") then
        return spell:Cast()
    end
end)

protection.thunderClap:Callback("thunderclap_aoe3", function(spell, unit)
    return spell:Cast()
end)

protection.revenge:Callback("revenge_aoe2", function(spell, unit)
    if player.rage >= 30
    or (player.rage >= 40
    and player.hasTalent("barbaric training")) then
        return spell:Cast()
    end
end)

-- End AOE --

-- Generic --

protection.thunderClap:Callback("thunderblast_generic1", function(spell, unit)
    if player.buffStacks("thunder blast") == 2
    and player.buffStacks("burst of power") <= 1
    and player.buff("avatar")
    and player.hasTalent("unstoppable force") then
        return spell:Cast()
    end
end)

protection.shieldSlam:Callback("shieldSlam_generic1", function(spell, unit)
    if (player.buffStacks("burst of power") == 2 and player.buffStacks("thunder blast") <= 1)
    or player.buff("violent outburst")
    or (player.rage <= 70 and player.hasTalent("demolish")) then
        return spell:Cast(unit)
    end
end)

protection.execute:Callback("execute_generic1", function(spell, unit)
    if player.rage >= 70
    or (player.rage >= 40 and shieldSlam.cd > 0 and player.hasTalent("demolish"))
    or (player.rage >= 50 and shieldSlam.cd > 0)
    or (player.buff("sudden death") and player.hasTalent("sudden death")) then
        return spell:Cast(unit)
    end
end)

protection.shieldSlam:Callback("shieldSlam_generic2", function(spell, unit)
    return spell:Cast(unit)
end)

protection.thunderClap:Callback("thunderblast_generic2", function(spell, unit)
    if player.buff("thunder blast")
    and player.debuffRemains("rend") <= 2
    and not player.buff("violent outburst") then
        return spell:Cast()
    end
end)

protection.thunderClap:Callback("thunderclap_generic1", function(spell, unit)
    if player.debuffRemains("rend") <= 2
    and not player.buff("violent outburst") then
        return spell:Cast()
    end
end)

protection.thunderClap:Callback("thunderblast_generic3", function(spell, unit)
    if player.buff("thunder blast")
    and protection.enemiesAround > 1
    or (shieldSlam.cd > 0 and not player.buff("violent outburst")) then
        return spell:Cast()
    end
end)

protection.thunderClap:Callback("thunderclap_generic2", function(spell, unit)
    if protection.enemiesAround > 1
    or (shieldSlam.cd > 0 and not player.buff("violent outburst")) then
        return spell:Cast()
    end
end)

protection.revenge:Callback("revenge_generic", function(spell, unit)
    local rage = player.rage
    local targetHealthPct = unit.hp
    local shieldSlamCD = shieldSlam.cd
    local hasRevengeBuff = player.buff("revenge")
    local hasMassacreTalent = player.hasTalent("massacre")

    if (rage >= 80 and targetHealthPct > 20)
    or (hasRevengeBuff and targetHealthPct <= 20 and rage <= 18 and shieldSlamCD > 0)
    or (hasRevengeBuff and targetHealthPct > 20)
    or (rage >= 80 and targetHealthPct > 35 and hasMassacreTalent)
    or (hasRevengeBuff and targetHealthPct <= 35 and rage <= 18 and shieldSlamCD > 0 and hasMassacreTalent)
    or (hasRevengeBuff and targetHealthPct > 35 and hasMassacreTalent) then
        return spell:Cast()
    end
end)

protection.execute:Callback("execute_generic2", function(spell, unit)
    return spell:Cast(unit)
end)

protection.revenge:Callback("revenge_generic2", function(spell, unit)
    return spell:Cast()
end)

protection.thunderClap:Callback("thunderblast_generic4", function(spell, unit)
    if player.buff("thunder blast")
    and protection.enemiesAround >= 1
    or (shieldSlam.cd > 0 and player.buff("violent outburst")) then
        return spell:Cast()
    end
end)

protection.thunderClap:Callback("thunderclap_generic3", function(spell, unit)
    if protection.enemiesAround >= 1
    or (shieldSlam.cd > 0 and player.buff("violent outburst")) then
        return spell:Cast()
    end
end)

-- End Generic --

protection:Init(function()

    if player.mounted then return end

    protection.enemiesAround = awful.enemies.around(player, 8)

    protection.castingEnemies = awful.enemies.filter(function(unit) return unit.casting and unit.los end)

    if IsKeyDown("E") or IsKeyDown("Q") or IsKeyDown("8") then return end

    if player.combat then
        if focus.exists then
            protection.pummel("pummel_optimal", focus)
        end

        protection.castingEnemies.loop(function(unit)
            protection.spellReflection("spellReflection_optimal", unit)
            if not focus.exists then
                protection.pummel("pummel_optimal", unit)
            end
            protection.spellBlock("spellBlock_optimal", unit)
        end)
    end

    if protection.enemiesAround > 0 then
 
        if not awful.target.exists then return end

        protection.warriorautoAttack("warriorautoAttack")

        protection.avatar("avatar", target)
        protection.ignorePain("ignorePain", target)
        protection.ravager("ravager", target)
        protection.demoralizingShout("demoralizingShout", target)
        protection.championsSpear("championsSpear", target)
        protection.thunderClap("thunderblast_base", target)
        protection.thunderousRoar("thunderousRoar", target)
        protection.shieldCharge("shieldCharge", target)
        protection.shieldBlock("shieldBlock", target)

        if protection.enemiesAround > 2 then
            protection.thunderClap("thunderblast_aoe1", target)
            protection.thunderClap("thunderclap_aoe1", target)
            protection.thunderClap("thunderblast_aoe2", target)
            protection.thunderClap("thunderclap_aoe2", target)
            protection.revenge("revenge_aoe1", target)
            protection.shieldSlam("shieldSlam_aoe", target)
            protection.thunderClap("thunderblast_aoe3", target)
            protection.thunderClap("thunderclap_aoe3", target)
            protection.revenge("revenge_aoe2", target)
        end

        protection.thunderClap("thunderblast_generic1", target)
        protection.shieldSlam("shieldSlam_generic1", target)
        protection.execute("execute_generic1", target)
        protection.shieldSlam("shieldSlam_generic2", target)
        protection.thunderClap("thunderblast_generic2", target)
        protection.thunderClap("thunderclap_generic1", target)
        protection.thunderClap("thunderblast_generic3", target)
        protection.thunderClap("thunderclap_generic2", target)
        protection.revenge("revenge_generic", target)
        protection.execute("execute_generic2", target)
        protection.revenge("revenge_generic2", target)
        protection.thunderClap("thunderblast_generic4", target)
        protection.thunderClap("thunderclap_generic3", target)
    end

end, .2)