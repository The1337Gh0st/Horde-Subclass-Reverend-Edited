PERK.PrintName = "Apostolic Guiding"
PERK.Description = "Healing reduces all debuff buildups.\n{1} increased Global damage resistance. \n Doubles buff / debuff strength and {2} longer duration."
PERK.Icon = "materials/perks/reverend/apostolic_guiding.png"
PERK.Params = {
[1] = {value = 0.25, percent = true},
[2] = {value = 0.5, percent = true}
}

PERK.Hooks = {}
PERK.Hooks.Horde_OnPlayerDamageTaken = function (ply, dmg, bonus)
    if not ply:Horde_GetPerk("apostolic_guiding") then return end
    bonus.resistance = bonus.resistance + 0.25
end

--PERK.Hooks.Horde_OnNPCKilled = function(victim, killer, wpn)
   -- if not killer:Horde_GetPerk("apostolic_guiding") then return end

  --  for _, ent in pairs(ents.FindInSphere(killer:GetPos(), 250)) do
    --    if ent:IsPlayer() then
	--	for debuff, buildup in pairs(ply.Horde_Debuff_Buildup) do
	--		if debuff == HORDE.Status_Bleeding or debuff == HORDE.Status_Break or debuff == HORDE.Status_Necrosis or debuff == HORDE.Status_Ignite or debuff == HORDE.Status_Frostbite or debuff == HORDE.Status_Shock then
         --   			ent:Horde_ReduceDebuffBuildup(debuff, 20)
		--	end
		--end
     --   end
    --end
--end

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
    end
end

PERK.Hooks.Horde_OnUnsetPerk = function(ply, perk)
    if SERVER and perk == "apostolic_guiding" then
        ply:Horde_SetApplyBuffMore(0)
        ply:Horde_SetApplyBuffDuration(ply:Horde_GetApplyBuffDuration() / 1.5)
    end
end
