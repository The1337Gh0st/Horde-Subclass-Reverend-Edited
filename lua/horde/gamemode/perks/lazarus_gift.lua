PERK.PrintName = "Lazarus Gift"
PERK.Description = "Ballistic damage headshots leech {2} of your max health. \nGain {1} speed while at full health."
PERK.Icon = "materials/perks/reverend/lazarus_gift.png"
PERK.Params = {
    [1] = {value = 0.25, percent = true},
    [2] = {value = 0.01, percent = true},
	[3] = {value = 10},
	[4] = {value = 5},
}

PERK.Hooks = {}

--PERK.Hooks.Horde_OnSetPerk = function(ply, perk)
   -- if SERVER and perk == "lazarus_gift" then
    --    ply:Horde_SetArmorRegenEnabled(true)
	--	ply:Horde_SetArmorRegenMax(10)
   -- end
--end

--PERK.Hooks.Horde_OnUnsetPerk = function(ply, perk)
   -- if SERVER and perk == "lazarus_gift" then
   --     ply:Horde_SetArmorRegenEnabled(nil)
	--	ply:Horde_SetArmorRegenMax(0)
  --  end
--end


PERK.Hooks.Horde_OnPlayerDamagePost = function (ply, npc, bonus, hitgroup, dmginfo)
    if ply:Horde_GetPerk("lazarus_gift") and HORDE:IsBallisticDamage(dmginfo) and hitgroup == HITGROUP_HEAD then
        local leech = math.min(1, dmginfo:GetDamage() * 1)
        HORDE:SelfHeal(ply, ply:GetMaxHealth() * 0.01)
		end
    end

PERK.Hooks.Horde_PlayerMoveBonus = function(ply, bonus_walk, bonus_run)
    if not ply:Horde_GetPerk("lazarus_gift") then return end
	if ply:Health() >= ply:GetMaxHealth() then
    bonus_walk.increase = bonus_walk.increase + 0.25
    bonus_run.increase = bonus_run.increase + 0.25
	end
end
	
