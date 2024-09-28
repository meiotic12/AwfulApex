local Unlocks, awful, apex = ...

if (GetSpecialization() ~= 1 and awful.player.class2 == "WARLOCK") or (awful.player.class2 ~= "WARLOCK") then return end

local affliction = apex.warlock.affliction

local player, target, focus, pet = awful.player, awful.target, awful.focus, awful.pet

awful.Populate({
    -- Pet --
    summonFelHunter = awful.Spell(691),
    -- Buffs --
    grimoireOfSacrifice = awful.Spell(108503),
    summonDarkglare = awful.Spell(205180),
    -- Damage --
    seedOfCorruption = awful.Spell(27243, {radius = 10}),
    haunt = awful.Spell(48181),
    agony = awful.Spell(980),
    unstableAffliction = awful.Spell(31117),
    corruption = awful.Spell(172),
    drainSoul = awful.Spell(47897),
    shadowBolt = awful.Spell(686),
    drainSoul = awful.Spell(198590),
    maleficRapture = awful.Spell(324536),
    -- Cooldowns --
    vileTaint = awful.Spell(278350, {radius = 10}),
    phantomSingularity = awful.Spell(205179),
    soulRot = awful.Spell(386997),
}, affliction, getfenv(1))

local GRIMOIRE_OF_SACRIFICE_BUFF_ID = 196099

print("Affliction Warlock Loaded")

-- Pre Combat --
summonFelHunter:Callback("precombat", function(spell)
    if player.combat then return end
    if pet.exists then return end
    if player.buff(GRIMOIRE_OF_SACRIFICE_BUFF_ID) then return end
    if apex.WasCasting[summonFelHunter.id] then return end

    return spell:Cast()
end)

grimoireOfSacrifice:Callback("precombat", function(spell)
    if player.combat then return end
    if not pet.exists then return end

    return spell:Cast()
end)

function DotActive(spell)
    awful.enemies.loop(function(enemy)
        if enemy.debuff(spell.id, player) then
            return true
        end
    end)
    return false
end

function DarkglareActive()
    local found = false
    awful.units.loop(function(unit)
        if unit.distance > 100 then return end
        if unit.name == "Darkglare" then
            local guid =  ObjectCreator(unit.pointer)
            if tostring(guid) == tostring(player.guid) then 
                found = true
            end
        end
    end)
    return found
end

seedOfCorruption:Callback("aoe", function(spell, target)
    if not IsAltKeyDown() then return end
    if apex.WasCasting[spell.id] then return end

    return spell:Cast(target)
end)

unstableAffliction:Callback("aoe", function(spell, target)
    if target.debuffRemains("unstable affliction") > 6 then return end
    if apex.WasCasting[spell.id] then return end

    return spell:Cast(target)
end)

haunt:Callback("aoe", function(spell, target)
    if target.debuffRemains("haunt") > 5 then return end

    return spell:Cast(target)
end)

vileTaint:Callback("aoe", function(spell, target)
    if not IsShiftKeyDown() then return end
    if apex.WasCasting[spell.id] then return end

    return spell:SmartAoE(target)
end)

drainSoul:Callback("aoe", function(spell, target)
    if apex.WasCasting[spell.id] then return end
    if target.debuffStacks("shadow embrace") >= 4 then return end

    return spell:Cast(target)
end)

soulRot:Callback("aoe", function(spell, target)
    if not IsShiftKeyDown() then return end
    if apex.WasCasting[spell.id] then return end

    return spell:Cast(target)
end)

summonDarkglare:Callback("aoe", function(spell, target)
    if not target.debuff("soul rot") then return end
    if not target.debuff("vile taint") then return end
    if apex.WasCasting[spell.id] then return end

    return spell:Cast()
end)

maleficRapture:Callback("aoe", function(spell, target)

    if apex.WasCasting[spell.id] then return end

    return spell:Cast()
end)

function AgonyCounter()
    local count = 0
    awful.enemies.loop(function(enemy)
        if enemy.debuff("agony") then
            count = count + 1
        end
    end)
    return count
end

agony:Callback("aoe", function(spell, target)
    if AgonyCounter() >= 8 then return end
    if vileTaint.cd < 5 then return end

    awful.enemies.loop(function(enemy)
        if enemy.debuffRemains("agony") < 5 then
            return spell:Cast(enemy)
        end
    end)
end)

haunt:Callback("st", function(spell, target)
    if target.debuffRemains("haunt") > 5 then return end

    return spell:Cast(target)
end)

unstableAffliction:Callback("st", function(spell, target)
    if target.debuffRemains("unstable affliction") > 6.3 then return end

    return spell:Cast(target)
end)

agony:Callback("st", function(spell, target)
    if target.debuffRemains("agony") > 4.5 then return end

    return spell:Cast(target)
end)


corruption:Callback("st", function(spell, target)
    if target.debuff("corruption") then return end

    return spell:Cast(target)
end)

drainSoul:Callback("st", function(spell, target)
    if apex.WasCasting[spell.id] then return end
    if target.debuffStacks("shadow embrace") >= 4 then return end

    return spell:Cast(target)
end)

soulRot:Callback("st", function(spell, target)
    if not IsShiftKeyDown() then return end

    return spell:Cast(target)
end)

phantomSingularity:Callback("st", function(spell, target)
    if not target.debuff("soul rot") then return end

    return spell:Cast(target)
end)

summonDarkglare:Callback("st", function(spell, target)
    if not target.debuff("soul rot") then return end

    return spell:Cast()
end)

maleficRapture:Callback("st", function(spell, target)
    if target.debuff("soul rot") then 
        return spell:Cast()
    elseif player.buff("tormented crescendo") then
        return spell:Cast()
    else
        if player.soulShards >= 5 then
            return spell:Cast()
        end
    end
end)



drainSoul:Callback("st2", function(spell, target)
    return spell:Cast(target)
end)

affliction.enemiesAroundTarget = 0

affliction:Init(function()
    summonFelHunter("precombat")
    grimoireOfSacrifice("precombat")

    if not target.exists then return end

    affliction.enemiesAroundTarget = awful.enemies.around(target, 10) + 1

    if affliction.enemiesAroundTarget > 0 then

        haunt("st", target)
        unstableAffliction("st", target)
        agony("st", target)
        corruption("st", target)
        drainSoul("st", target)
        soulRot("st", target)
        phantomSingularity("st", target)
        summonDarkglare("st", target)
        maleficRapture("st", target)
        drainSoul("st2", target)

        -- if affliction.enemiesAroundTarget > 2 then
        --     seedOfCorruption("aoe", target)
        --     unstableAffliction("aoe", target)
        --     haunt("aoe", target)
        --     vileTaint("aoe", target)
        --     soulRot("aoe", target)
        --     summonDarkglare("aoe", target)
        --     maleficRapture("aoe", target)
        --     agony("aoe", target)
        -- end


    end

end, .2)