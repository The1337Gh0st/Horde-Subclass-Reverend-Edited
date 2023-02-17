PERK.PrintName = "Sin Crusher"
PERK.Description = "Gain immunity to poison damage and Bleeding. \nKilling Elites will heal nearby players for {1} of their max health, \nalong with cleansing all debuffs."
PERK.Icon = "materials/perks/reverend/sin_crusher.png"
PERK.Params = {
    [1] = {value = 0.05, percent = true},
	[2] = {value = 2},
	[3] = {value = 5},
}

PERK.Hooks = {}

PERK.Hooks.Horde_OnPlayerDamageTaken = function (ply, dmginfo, bonus)
    if not ply:Horde_GetPerk("sin_crusher") then return end
    if HORDE:IsPoisonDamage(dmginfo) then
        bonus.resistance = bonus.resistance + 1.0
    end
end

PERK.Hooks.Horde_OnNPCKilled = function(victim, killer, wpn)
    if not killer:Horde_GetPerk("sin_crusher") then return end
	if not victim:GetVar("is_elite") then return end


    for _, ent in pairs(ents.FindInSphere(killer:GetPos(), 250)) do
        if ent:IsPlayer() then
		for debuff, buildup in pairs(ent.Horde_Debuff_Buildup) do
		ent:Horde_RemoveDebuff(debuff)
        ent:Horde_ReduceDebuffBuildup(debuff, buildup)
		end
		local healinfo = HealInfo:New({amount=ent:GetMaxHealth() * 0.05, healer=killer})
            HORDE:OnPlayerHeal(ent, healinfo)
        end
    end

end



PERK.Hooks.Horde_OnPlayerDebuffApply = function (ply, debuff, bonus)
    if ply:Horde_GetPerk("sin_crusher") and debuff == HORDE.Status_Break then
        bonus.apply = 0
        return true
    end
	
	if ply:Horde_GetPerk("sin_crusher") and debuff == HORDE.Status_Bleeding then
        bonus.apply = 0
        return true
    end
end

