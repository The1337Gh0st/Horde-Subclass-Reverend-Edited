PERK.PrintName = "Sin Crusher"
PERK.Description = "Killing Elites releases a healing cloud at your feet. Healing gives Berserk. \nBerserk increases your damage by {1}. \nGain Warden Aura, giving you and nearby players +{2} damage block."
PERK.Icon = "materials/perks/reverend/sin_crusher.png"
PERK.Params = {
    [1] = {value = 0.2, percent = true},
	[2] = {value = 2},
}

PERK.Hooks = {}

PERK.Hooks.Horde_OnSetPerk = function(ply, perk)
    if SERVER and perk == "sin_crusher" then
        ply:Horde_AddWardenAura()
    end
end

PERK.Hooks.Horde_OnUnsetPerk = function(ply, perk)
    if SERVER and perk == "sin_crusher" then
        ply:Horde_RemoveWardenAura()
    end
end

PERK.Hooks.Horde_OnNPCKilled = function(victim, killer, inflictor)
    if not killer:Horde_GetPerk("sin_crusher") then return end
    if inflictor:IsNPC() then return end -- Prevent infinite chains
    if victim:GetVar("is_elite") then
        local ent = ents.Create("arccw_thr_medicgrenade")
        ent:SetPos(killer:GetPos())
        ent:SetOwner(killer)
        ent.Owner = killer
        ent.Inflictor = victim
        ent:Spawn()
        ent:Activate()
        timer.Simple(0, function()
            if ent:IsValid() then
                ent:Detonate() ent:SetArmed(true)
            end
        end)
        if ent:GetPhysicsObject():IsValid() then
            ent:GetPhysicsObject():EnableMotion(false)
        end
        timer.Simple(3, function() if ent:IsValid() then ent:Remove() end end)
    end
end

PERK.Hooks.Horde_OnPlayerHeal = function(ply, healinfo)
    local healer = healinfo:GetHealer()
    if healer:IsPlayer() and healer:Horde_GetPerk("sin_crusher") then
        ply:Horde_AddBerserk(healer:Horde_GetApplyBuffDuration())
    end
end

