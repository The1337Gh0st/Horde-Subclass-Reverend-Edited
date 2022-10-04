PERK.PrintName = "Executor"
PERK.Description = "Enemies you hit with Ballistic damage are inflicted with Weakened, \ntaking {1} more physical damage. \nDeal {2} more ballistic damage against Elites."
PERK.Icon = "materials/perks/reverend/executor.png"
PERK.Params = {
    [1] = {value = 0.15, percent = true},
	[2] = {value = 0.25, percent = true},
}

PERK.Hooks = {}
PERK.Hooks.Horde_OnPlayerDamage = function(ply, npc, bonus, hitgroup, dmg)
    if not ply:Horde_GetPerk("executor") then return end
    if HORDE:IsBallisticDamage(dmg) then
        npc:Horde_AddWeaken(ply:Horde_GetApplyDebuffDuration(), ply:Horde_GetApplyDebuffMore())
		if npc:GetVar("is_elite") then
            bonus.increase = bonus.increase + 0.25
        end
    end
end
