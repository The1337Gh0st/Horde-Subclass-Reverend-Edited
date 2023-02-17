PERK.PrintName = "Apostolic Guiding"
PERK.Description = "Gain {1} healing amplification per missing health, up to {2}. \nPress Shift + E to release a healing pulse \nthat heals nearby players for {3} of their max health. {4} second cooldown."
PERK.Icon = "materials/perks/reverend/apostolic_guiding.png"
PERK.Params = {
[1] = {value = 0.01, percent = true},
[2] = {value = 1, percent = true},
[3] = {value = 10, percent = true},
[4] = {value = 10},
}

PERK.Hooks = {}
--PERK.Hooks.Horde_OnPlayerDamageTaken = function (ply, dmg, bonus)
  --  if not ply:Horde_GetPerk("apostolic_guiding") then return end
  --  bonus.resistance = bonus.resistance + math.min(0.25, (1 * (math.max(0, 1 - ply:Health() / ply:GetMaxHealth()))))
--end


PERK.Hooks.Horde_OnPlayerHeal = function(ply, healinfo)
    local healer = healinfo:GetHealer()
    if healer:IsPlayer() and healer:Horde_GetPerk("apostolic_guiding") then
        healinfo:SetHealAmount(healinfo:GetHealAmount() * (1 + (math.min(1, (math.max(0, 1 - (ply:Health() / ply:GetMaxHealth() ) ) ) ) ) ) )
    end
end

PERK.Hooks.Horde_OnSetPerk = function(ply, perk)
    if SERVER and perk == "apostolic_guiding" then
            ply:Horde_SetPerkCooldown(10)

        net.Start("Horde_SyncActivePerk")
            net.WriteUInt(HORDE.Status_Smokescreen, 8)
            net.WriteUInt(1, 3)
        net.Send(ply)
    end
end

PERK.Hooks.Horde_OnUnsetPerk = function(ply, perk)
    if SERVER and perk == "apostolic_guiding" then
        net.Start("Horde_SyncActivePerk")
            net.WriteUInt(HORDE.Status_Smokescreen, 8)
            net.WriteUInt(0, 3)
        net.Send(ply)
    end
end

PERK.Hooks.Horde_UseActivePerk = function (ply)

if not ply:Horde_GetPerk("apostolic_guiding") then return end

 local effectdata = EffectData()
    effectdata:SetOrigin(ply:GetPos())
    effectdata:SetRadius(225)
    util.Effect("horde_life_diffuser", effectdata)
    ply:EmitSound("horde/player/life_diffuser.ogg", 100, 100, 1, CHAN_AUTO)

    for _, ent in pairs(ents.FindInSphere(ply:GetPos(), 200)) do
        if ent:IsPlayer() then
            local healinfo = HealInfo:New({amount=ent:GetMaxHealth() * 0.1, healer=ply})
            HORDE:OnPlayerHeal(ent, healinfo)
        elseif ent:GetClass() == "npc_vj_horde_antlion" then
            local healinfo = HealInfo:New({amount=10, healer=ply})
            HORDE:OnAntlionHeal(ent, healinfo)
        elseif ent:IsNPC() then
            local dmg = DamageInfo()
            dmg:SetDamage(65)
            dmg:SetDamageType(DMG_NERVEGAS)
            dmg:SetAttacker(ply)
            dmg:SetInflictor(ply)
            dmg:SetDamagePosition(ply:GetPos())
            ent:TakeDamageInfo(dmg)
        end
    end

end
