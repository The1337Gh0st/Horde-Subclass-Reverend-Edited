PERK.PrintName = "Enforcer"
PERK.Description = "{1} increased headshot damage. \n{1} additional headshot damage if at full health."
PERK.Icon = "materials/perks/reverend/enforcer.png"
PERK.Params = {
    [1] = {value = 0.10, percent = true},
}
PERK.Hooks = {}

PERK.Hooks.Horde_OnPlayerDamage = function (ply, npc, bonus, hitgroup)
    if not ply:Horde_GetPerk("enforcer") then return end   
   if not hitgroup == HITGROUP_HEAD then return end
     bonus.increase = bonus.increase + 0.1
	
	 if ply:Health() >= ply:GetMaxHealth() then
        bonus.increase = bonus.increase + 0.1
    end
	
end

--PERK.Hooks.Horde_OnPlayerDamage = function (ply, npc, bonus, hitgroup)
  --  if not hitgroup == HITGROUP_HEAD then return end
  --  if not ply:Horde_GetPerk("enforcer")  then return end
  --  if ply:Health() >= ply:GetMaxHealth() then
   --     bonus.increase = bonus.increase + 0.1
  --  end
--end