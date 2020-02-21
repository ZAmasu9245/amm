SWEP.ViewModelFlip 			= false
SWEP.UseHands				= true
SWEP.ViewModel 				= "models/medicmod/syringe/v_syringe.mdl"
SWEP.WorldModel 			= "models/medicmod/syringe/w_syringe.mdl"
SWEP.Author					= "Venatuss"
SWEP.Instructions			= "Click to attack"

SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.Primary.Damage         = 2
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Delay 			= 2

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.Delay 			= 2

SWEP.Category 				= "Medic Mod"
SWEP.PrintName				= "Antidote"
SWEP.Slot					= 1
SWEP.SlotPos				= 1
SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= true



function SWEP:SecondaryAttack()

	self.Weapon:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
	
	local ply = self.Owner
	
	if not IsValid( ply ) or not ply:IsPoisoned() then return end
	
	self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
	
	if SERVER then
		ply:SetPoisoned( false )
		ply:MedicNotif( ConfigurationMedicMod.Sentences["You have stopped your poisoning"][ConfigurationMedicMod.Language], 5 )
		timer.Simple(1, function() if not IsValid(self) then return end self:Remove() end)
	end
	
end

function SWEP:ShouldDropOnDie()
	return false
end

function SWEP:Reload()
end 

function SWEP:PrimaryAttack()
	
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
	local ent = self.Owner:GetEyeTrace().Entity
	
	if not IsValid( self.Owner ) then return end
	
	if not IsValid(ent) or ent:GetPos():Distance( self.Owner:GetPos() ) > 200 then return end
	
	if ent:IsPlayer() && ent:IsPoisoned() then

		self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )

		if SERVER then
			self.Owner:SetAnimation( PLAYER_ATTACK1 )

			ent:SetPoisoned( false )
			self.Owner:MedicNotif( ConfigurationMedicMod.Sentences["You have stopped the poisoning of someone"][ConfigurationMedicMod.Language], 5 )
			ent:MedicNotif( ConfigurationMedicMod.Sentences["Someone stopped your poisoning"][ConfigurationMedicMod.Language], 5 )
			timer.Simple(1, function() if not IsValid(self) then return end self:Remove() end)
		end
		
	elseif ent:IsDeathRagdoll() && ent:GetOwner():IsPoisoned() then
		
		self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
		
		if SERVER then
			self.Owner:SetAnimation( PLAYER_ATTACK1 )
			local ply = ent:GetOwner()
			
			ply:SetPoisoned( false )
			ply:Stabilize( self.Owner )
			
			self.Owner:MedicNotif( ConfigurationMedicMod.Sentences["You have stopped the poisoning of someone"][ConfigurationMedicMod.Language], 5 )
			ply:MedicNotif( ConfigurationMedicMod.Sentences["Someone stopped your poisoning"][ConfigurationMedicMod.Language], 5 )
			
			timer.Simple(1, function() if not IsValid(self) then return end self:Remove() end)
		end
		
	elseif IsValid(ent.ragdoll) && ent.ragdoll:IsDeathRagdoll() && ent.ragdoll:GetOwner():IsPoisoned() then
		
		self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )

		if SERVER then
			self.Owner:SetAnimation( PLAYER_ATTACK1 )
			local ply = ent.ragdoll:GetOwner() 
			
			ply:SetPoisoned( false )
			ply:Stabilize( self.Owner )
			
			self.Owner:MedicNotif( ConfigurationMedicMod.Sentences["You have stopped the poisoning of someone"][ConfigurationMedicMod.Language], 5 )
			ply:MedicNotif( ConfigurationMedicMod.Sentences["Someone stopped your poisoning"][ConfigurationMedicMod.Language], 5 )
			
			timer.Simple(1, function() if not IsValid(self) then return end self:Remove() end)
		end
	end
	
end

function SWEP:Deploy()
   return true
end
function SWEP:Initialize()
	self:SetHoldType( "pistol" )
end

function SWEP:Holster()
	return true
end
