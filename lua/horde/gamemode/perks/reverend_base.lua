PERK.PrintName = "Reverend Base"
PERK.Description = [[
The Reverend subclass is a hybrid subclass that can provide support for teammates or utilize high damage skills.
Complexity: MEDIUM

{6} healing amplification. ({2} + {7} per level, up to {8})
{1} increased overheal. ({2} + {3} per level, up to {4})
Kills will heal you and nearby players for {5} health. ]]

-- These are used to fill out the {1}, {2}, {3}, {4} above.
-- Mainly useful for translation, it is optional.
PERK.Params = {
    [1] = {percent = true, base = 0, level = 0.01, max = 0.25, classname = "Reverend"},
    [2] = {value = 0, percent = true},
    [3] = {value = 0.01, percent = true},
    [4] = {value = 0.25, percent = true},
	[5] = {value = 2},
	[6] = {percent = true, base = 0, level = 0.06, max = 1.5, classname = "Reverend"},
	[7] = {value = 0.06, percent = true},
	[8] = {value = 1.5, percent = true},
}

PERK.Hooks = {}

-- This is a required function if you are planning to use bonuses based on levels.
PERK.Hooks.Horde_PrecomputePerkLevelBonus = function (ply)
    if SERVER then
        ply:Horde_SetPerkLevelBonus("reverend_base", math.min(0.25, 0.01 * ply:Horde_GetLevel("Reverend")))
    end
end



-- Apply the healing bonus.

PERK.Hooks.Horde_OnPlayerHeal = function(ply, healinfo)
    local healer = healinfo:GetHealer()
	local r = healer:Horde_GetPerkLevelBonus("reverend_base")
    if healer:IsPlayer() and healer:Horde_GetPerk("reverend_base") then
        healinfo:SetHealAmount(healinfo:GetHealAmount() * ((r * 6) + 1))
		healinfo:SetOverHealPercentage(r)
    end
end


--PERK.Hooks.Horde_OnPlayerHeal = function(ply, healinfo)
  --  local healer = healinfo:GetHealer()
  --  if healer:IsPlayer() and healer:Horde_GetPerk("reverend_base") then
   --     healinfo:SetOverHealPercentage(ply:Horde_GetPerkLevelBonus("Reverend"))
  --  end
--end

-- Apply the passive ability.

PERK.Hooks.Horde_OnNPCKilled = function(victim, killer, wpn)
    if not killer:Horde_GetPerk("reverend_base")  then return end
   -- HORDE:SelfHeal(killer, killer:GetMaxHealth() * 0.02)
	for _, ent in pairs(ents.FindInSphere(killer:GetPos(), 250)) do
        if ent:IsPlayer() then
            local healinfo = HealInfo:New({amount=2, healer=killer})
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