PERK.PrintName = "Iron Faith"
PERK.Description = "+{3} armor on kill, up to {4}. \nImmune to Fire and Blast damage while you have at least {1} armor. \nHealing gives Fortify for {1} seconds, decreasing damage taken by {2}."
PERK.Icon = "materials/perks/reverend/iron_faith.png"
PERK.Params = {
    [1] = {value = 5},
    [2] = {value = 0.20, percent = true},
	[3] = {value = 2},
	[4] = {value = 10},
}

PERK.Hooks = {}

PERK.Hooks.Horde_OnNPCKilled = function(victim, killer, wpn)
 if not killer:Horde_GetPerk("iron_faith") then return end
	killer:SetArmor(math.min(10,killer:Armor()+2))
end

PERK.Hooks.Horde_OnPlayerDamageTaken = function (ply, dmginfo, bonus)
    if not ply:Horde_GetPerk("iron_faith") then return end
    if ply:Armor() >= 5 and (HORDE:IsFireDamage(dmginfo) or HORDE:IsBlastDamage(dmginfo)) then
        bonus.resistance = bonus.resistance + 1.0
    end
end

PERK.Hooks.Horde_OnPlayerDebuffApply = function (ply, debuff, bonus)
    if ply:Horde_GetPerk("iron_faith") and ply:Armor() >= 5 and debuff == HORDE.Status_Ignite then
        bonus.apply = 0
        return true
    end
end

PERK.Hooks.Horde_OnPlayerHeal = function(ply, healinfo)
    local healer = healinfo:GetHealer()
    if healer:IsPlayer() and healer:Horde_GetPerk("iron_faith") then
        ply:Horde_AddFortify(healer:Horde_GetApplyBuffDuration())
    end
end