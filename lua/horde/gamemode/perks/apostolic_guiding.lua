PERK.PrintName = "Apostolic Guiding"
PERK.Description = "Healing reduces all debuff buildups.\n{2} increased Global damage resistance per missing health, up to {1}. \n Doubles buff / debuff strength and {3} longer duration / range."
PERK.Icon = "materials/perks/reverend/apostolic_guiding.png"
PERK.Params = {
[1] = {value = 0.25, percent = true},
[2] = {value = 0.01, percent = true},
[3] = {value = 0.5, percent = true},
}

PERK.Hooks = {}
PERK.Hooks.Horde_OnPlayerDamageTaken = function (ply, dmg, bonus)
    if not ply:Horde_GetPerk("apostolic_guiding") then return end
    bonus.resistance = bonus.resistance + math.min(0.25, (1 * (math.max(0, 1 - ply:Health() / ply:GetMaxHealth()))))
end


PERK.Hooks.Horde_PostOnPlayerHeal = function(ply, healinfo)
    local healer = healinfo:GetHealer()
    if healer:IsPlayer() and healer:Horde_GetPerk("apostolic_guiding") then
        for debuff, buildup in pairs(ply.Horde_Debuff_Buildup) do
            if debuff == HORDE.Status_Bleeding or debuff == HORDE.Status_Break or debuff == HORDE.Status_Necrosis or debuff == HORDE.Status_Ignite or debuff == HORDE.Status_Frostbite or debuff == HORDE.Status_Shock then
                ply:Horde_ReduceDebuffBuildup(debuff, healinfo:GetHealAmount() * 2)
            end
        end
    end
end

PERK.Hooks.Horde_OnSetPerk = function(ply, perk)
    if SERVER and perk == "apostolic_guiding" then
        ply:Horde_SetApplyBuffMore(1)
        ply:Horde_SetApplyBuffDuration(ply:Horde_GetApplyBuffDuration() * 1.5)
		ply:Horde_SetEnableWardenAuraBuffBonus(true)
        ply:Horde_SetWardenAuraRadius(ply:Horde_GetWardenAuraRadius() * 1.5)
    end
end

PERK.Hooks.Horde_OnUnsetPerk = function(ply, perk)
    if SERVER and perk == "apostolic_guiding" then
        ply:Horde_SetApplyBuffMore(0)
        ply:Horde_SetApplyBuffDuration(ply:Horde_GetApplyBuffDuration() / 1.5)
		ply:Horde_SetEnableWardenAuraBuffBonus(nil)
        ply:Horde_SetWardenAuraRadius(ply:Horde_GetWardenAuraRadius() / 1.5)
        if ply:Horde_GetPerk("sin_crusher") then
            ply:Horde_AddWardenAura()
        else
            ply:Horde_RemoveWardenAura()
        end
    end
end
