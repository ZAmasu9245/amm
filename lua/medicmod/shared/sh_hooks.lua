local sentences =ConfigurationMedicMod.Sentences
local lang = ConfigurationMedicMod.Language
 
-- Play animations
hook.Add("CalcMainActivity", "CalcMainActivity.MedicMod", function(ply, vel)
   
    if ply:GetMedicAnimation() == 1 then
        local seqid = ply:LookupSequence( "medic_custom1" )
        ply:SetSequence( seqid )
       
        return -1, seqid   
    end
    if ply:GetMedicAnimation() == 2 then
       
        -- stop the animation if the ragdoll isn't near the player
        if not ply:GetEyeTrace().Entity:IsDeathRagdoll() or ply:GetEyeTrace().Entity:GetPos():Distance(ply:GetPos()) > 100 then
            if SERVER then
                if IsValid( ply.RagdollHeartMassage ) && IsValid( ply.RagdollHeartMassage:GetOwner() ) then
                ply.RagdollHeartMassage:GetOwner().NextSpawnTime = CurTime() +  ply.RagdollHeartMassage:GetOwner().AddToSpawnTime
                ply.RagdollHeartMassage.IsHeartMassage = false
				net.Start("MedicMod.Respawn")
					net.WriteInt(ply.RagdollHeartMassage:GetOwner().NextSpawnTime,32)
				net.Send(ply)
            end
                ply:StripWeapon("heart_massage")
            end
            if SERVER then StopMedicAnimation( ply ) end
            return
        end
       
        local seqid = ply:LookupSequence( "medic_custom2" )
        ply:SetSequence( seqid )
       
        return -1, seqid   
    end
           
end)

hook.Add("PlayerButtonUp", "PlayerButtonUp.MedicMod", function( ply, but )

	if table.HasValue( ConfigurationMedicMod.TeamsCantPracticeCPR, ply:Team() ) then return end
   
    if but != ConfigurationMedicMod.CPRKey or not ConfigurationMedicMod.CanCPR then return end
   
    if ply.blocAnim && ply.blocAnim >= CurTime() then return end
   
    -- if the player press the configured key, then stop his animation
    if ply:GetMedicAnimation() != 0 then
        if SERVER then
		-- add condition pour si le mec n'a plus d'arrêt cardiaque
            if IsValid( ply.RagdollHeartMassage ) && IsValid( ply.RagdollHeartMassage:GetOwner() ) then
                ply.RagdollHeartMassage:GetOwner().NextSpawnTime = CurTime() +  ply.RagdollHeartMassage:GetOwner().AddToSpawnTime
                ply.RagdollHeartMassage.IsHeartMassage = false
				net.Start("MedicMod.Respawn")
					net.WriteInt(ply.RagdollHeartMassage:GetOwner().NextSpawnTime,32)
				net.Send(ply.RagdollHeartMassage:GetOwner())
            end
            ply:StripWeapon("heart_massage")
        end
        ply.blocAnim = CurTime() + 2
        if SERVER then StopMedicAnimation( ply ) end
        return
    end
   
    local trace = ply:GetEyeTrace()
    local ent = trace.Entity
   
    if not IsValid(ent) then return end
   
    if ent.IsHeartMassage then return end
   
    if not ent:IsDeathRagdoll() or ent:GetClass() == "prop_physics" or trace.HitPos:Distance(ply:GetPos()) > 100 then return end
	
	if table.HasValue( ConfigurationMedicMod.TeamsCantReceiveCPR, ent:GetOwner():Team() ) then return end
	
    if ent:GetOwner().NextSpawnTime == -1 then return end
   
    ply.RagdollHeartMassage = ent
   
    ent.IsHeartMassage = true
   
    if SERVER then StartMedicAnimation( ply, 1 ) end
    ply.blocAnim = CurTime() + 5
   
    timer.Simple(2.7, function()
   
        if SERVER then
            ply:Give("heart_massage")
            ply:SelectWeapon("heart_massage")
            ply:MedicNotif( sentences["You are starting CPR"][lang], 10)
            ent:GetOwner():MedicNotif( sentences["Someone is giving you CPR"][lang], 10)
        end
       
		if SERVER then 
			StopMedicAnimation( ply )
			StartMedicAnimation( ply, 2 )
		end
		
    end)
   
    if SERVER then
        if not ent:GetOwner():GetHeartAttack() then ent:GetOwner().AddToSpawnTime = 0 return end
       
        if not ent:GetOwner():IsPoisoned() and not ent:GetOwner():IsBleeding() then
            ent:GetOwner().AddToSpawnTime = ent:GetOwner().NextSpawnTime - CurTime()
            ent:GetOwner().NextSpawnTime = -1
            net.Start("MedicMod.Respawn")
                net.WriteInt(-1,32)
            net.Send(ent:GetOwner())
        else
            ent:GetOwner().AddToSpawnTime = 0
        end
    end
end)
