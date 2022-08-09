PERK.PrintName = "Lazarus Gift"
PERK.Description = "+{2} armor on kill. \nHeadshots leech up to {2} health. \nHealing gives Haste, increasing speed by {1}."
PERK.Icon = "materials/perks/reverend/lazarus_gift.png"
PERK.Params = {
    [1] = {value = 0.15, percent = true},
    [2] = {value = 2}
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

PERK.Hooks.Horde_OnNPCKilled = function(victim, killer, wpn)
    if not killer:Horde_GetPerk("lazarus_gift")  then return end
    killer:SetArmor(killer:Armor() + 2)
    
	if killer:Armor() >= killer:GetMaxArmor() then
	killer:SetArmor(killer:GetMaxArmor())
	end
end


PERK.Hooks.Horde_OnPlayerDamagePost = function (ply, npc, bonus, hitgroup, dmginfo)
    if ply:Horde_GetPerk("lazarus_gift") and (HORDE:IsBallisticDamage(dmginfo)) and hitgroup == HITGROUP_HEAD then
        local leech = math.min(2, dmginfo:GetDamage() * 1)
        HORDE:SelfHeal(ply, leech)
		end

    end

	
	PERK.Hooks.Horde_OnPlayerHeal = function(ply, healinfo)
    local healer = healinfo:GetHealer()
    if healer:IsPlayer() and healer:Horde_GetPerk("lazarus_gift") then
        ply:Horde_AddHaste(healer:Horde_GetApplyBuffDuration())
    end
end