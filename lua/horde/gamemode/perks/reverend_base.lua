PERK.PrintName = "Reverend Base"
PERK.Description = [[
The Reverend subclass is a hybrid subclass that can provide support for teammates or utilize high damage skills.
Complexity: MEDIUM

{1} increased healing. ({2} + {3} per level, up to {4})
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
}

PERK.Hooks = {}

-- This is a required function if you are planning to use bonuses based on levels.
PERK.Hooks.Horde_PrecomputePerkLevelBonus = function (ply)
    if SERVER then
        ply:Horde_SetPerkLevelBonus("reverend_base", 0 + math.min(0.25, 0.01 * ply:Horde_GetLevel("Reverend")))
    end
end

-- Apply the dammage bonus.
PERK.Hooks = {}
PERK.Hooks.Horde_OnPlayerHeal = function(ply, healinfo)
    local healer = healinfo:GetHealer()
    if healer:IsPlayer() and healer:Horde_GetPerk("reverend_base") then
        healinfo:SetHealAmount(healinfo:GetHealAmount() * ply:Horde_GetPerkLevelBonus("Reverend"))
    end
end

PERK.Hooks.Horde_OnNPCKilled = function(victim, killer, wpn)
    if not killer:Horde_GetPerk("reverend_base")  then return end
    HORDE:SelfHeal(killer, killer:GetMaxHealth() * 0.02)
end

PERK.Hooks.Horde_OnPlayerHeal = function(ply, healinfo)
    local healer = healinfo:GetHealer()
    if healer:IsPlayer() and healer:Horde_GetPerk("reverend_base") then
        healinfo:SetOverHealPercentage(ply:Horde_GetPerkLevelBonus("Reverend"))
    end
end

PERK.Hooks.Horde_OnNPCKilled = function(victim, killer, wpn)
    if not killer:Horde_GetPerk("reverend_base") then return end

    for _, ent in pairs(ents.FindInSphere(killer:GetPos(), 250)) do
        if ent:IsPlayer() then
            local healinfo = HealInfo:New({amount=2, healer=killer})
            HORDE:OnPlayerHeal(ent, healinfo)
        end
    end
end