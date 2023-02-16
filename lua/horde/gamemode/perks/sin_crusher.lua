PERK.PrintName = "Sin Crusher"
PERK.Description = "Gain immunity to poison damage and Bleeding. \nReceiving poison damage will heal you for {1} of the amount."
PERK.Icon = "materials/perks/reverend/sin_crusher.png"
PERK.Params = {
    [1] = {value = 0.1, percent = true},
	[2] = {value = 2},
	[3] = {value = 5},
}

PERK.Hooks = {}

PERK.Hooks.Horde_OnPlayerDamageTaken = function (ply, dmginfo, bonus)
    if not ply:Horde_GetPerk("sin_crusher") then return end
    if HORDE:IsPoisonDamage(dmginfo) then
        bonus.resistance = bonus.resistance + 1.0
		
		 if dmginfo:GetDamage() > 0 and dmginfo:GetDamage() * 0.06 then
            HORDE:OnPlayerHeal(ply, HealInfo:New({amount=math.max(1,dmginfo:GetDamage() * 0.1), healer=ply}))
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

