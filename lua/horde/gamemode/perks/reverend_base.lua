PERK.PrintName = "Reverend Base"
PERK.Description = [[
The Reverend subclass is a hybrid subclass that can basic provide support for teammates or utilize high damage skills.
Complexity: MEDIUM

{1} of healing reduces debuff buildup. ({2} base, {3} per level, up to {4})
Kills will heal you and nearby players for {5} of their max health. ]]

-- These are used to fill out the {1}, {2}, {3}, {4} above.
-- Mainly useful for translation, it is optional.
PERK.Params = {
    [1] = {percent = true, base = 0.25, level = 0.03, max = 1, classname = "Reverend"},
    [2] = {value = 0.25, percent = true},
    [3] = {value = 0.03, percent = true},
    [4] = {value = 1, percent = true},
	[5] = {value = 2},
	[6] = {percent = true, base = 0, level = 0.04, max = 1, classname = "Reverend"},
	[7] = {value = 0.04, percent = true},
	[8] = {value = 1, percent = true},
}

PERK.Hooks = {}

-- This is a required function if you are planning to use bonuses based on levels.
PERK.Hooks.Horde_PrecomputePerkLevelBonus = function (ply)
    if SERVER then
        ply:Horde_SetPerkLevelBonus("reverend_base", math.min(0.25, 0.01 * ply:Horde_GetLevel("Reverend")))
    end
end

-- Apply the healing bonus.

PERK.Hooks.Horde_PostOnPlayerHeal = function(ply, healinfo)
    local healer = healinfo:GetHealer()
    if healer:IsPlayer() and healer:Horde_GetPerk("reverend_base") then
	local r = healer:Horde_GetPerkLevelBonus("reverend_base")
        for debuff, buildup in pairs(ply.Horde_Debuff_Buildup) do
            if debuff == HORDE.Status_Bleeding or debuff == HORDE.Status_Break or debuff == HORDE.Status_Necrosis or debuff == HORDE.Status_Ignite or debuff == HORDE.Status_Frostbite or debuff == HORDE.Status_Shock then
                ply:Horde_ReduceDebuffBuildup(debuff, healinfo:GetHealAmount() * (0.25 + ( r * 3)))
            end
        end
    end
end

-- Apply the passive ability.

PERK.Hooks.Horde_OnEnemyKilled = function(victim, killer, wpn)
    if not killer:Horde_GetPerk("reverend_base")  then return end
   -- HORDE:SelfHeal(killer, killer:GetMaxHealth() * 0.02)
	for _, ent in pairs(ents.FindInSphere(killer:GetPos(), 250)) do
        if ent:IsPlayer() then
            local healinfo = HealInfo:New({amount=ent:GetMaxHealth() * 0.02, healer=killer})
            HORDE:OnPlayerHeal(ent, healinfo)
		end
	end
end



--PERK.Hooks.Horde_OnNPCKilled = function(victim, killer, wpn)
   -- if not killer:Horde_GetPerk("reverend_base") then return end

  --  for _, ent in pairs(ents.FindInSphere(killer:GetPos(), 250)) do
   --     if ent:IsPlayer() then
    --        local healinfo = HealInfo:New({amount=2, healer=killer})
    --        HORDE:OnPlayerHeal(ent, healinfo)
    --    end
   -- end
--end