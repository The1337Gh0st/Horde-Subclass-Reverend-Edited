PERK.PrintName = "Iron Faith"
PERK.Description = "While you have at least {1} armor: \nImmune to Fire and Blast damage. \nHealing gives Fortify for {1} seconds, decreasing damage taken by {2}."
PERK.Icon = "materials/perks/reverend/iron_faith.png"
PERK.Params = {
    [1] = {value = 5},
    [2] = {value = 0.20, percent = true},
}

PERK.Hooks = {}
PERK.Hooks.Horde_OnPlayerDamageTaken = function (ply, dmginfo, bonus)
    if not ply:Horde_GetPerk("iron_faith") then return end
    if ply:Armor() >= 5 and (HORDE:IsFireDamage(dmginfo) or HORDE:IsBlastDamage(dmginfo)) then
        bonus.resistance = bonus.resistance + 1.0
    end
end

PERK.Hooks.Horde_OnPlayerHeal = function(ply, healinfo)
    local healer = healinfo:GetHealer()
    if healer:IsPlayer() and healer:Horde_GetPerk("iron_faith") then
        ply:Horde_AddFortify(healer:Horde_GetApplyBuffDuration())
    end
end