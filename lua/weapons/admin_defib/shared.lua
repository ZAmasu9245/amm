SWEP.ViewModelFlip 			= false
SWEP.UseHands				= true
SWEP.ViewModel 				= "models/medicmod/defib/v_defib.mdl"
SWEP.WorldModel 			= "models/medicmod/defib/w_defib.mdl"
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

SWEP.Category 				= "Medic Mod"
SWEP.PrintName				= "Admin Defibrillator"
SWEP.Slot					= 1
SWEP.SlotPos				= 1
SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= true



function SWEP:SecondaryAttack()
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
	
	if ent:IsPlayer() then
		
		self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )

		if SERVER then
			ent:MedicalRespawn()
		end
		
	elseif ent:IsDeathRagdoll() then
		
		self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
		
		if SERVER then
			ent:GetOwner():MedicalRespawn()			
		end
		
	elseif IsValid(ent.ragdoll) && ent.ragdoll:IsDeathRagdoll() then
		
		self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
		
		if SERVER then
			
			ent.ragdoll:GetOwner():MedicalRespawn()
			
		end
	
	end
	
end

function SWEP:Deploy()
   return true
end
function SWEP:Initialize()
	self:SetHoldType( "" )
end

function SWEP:Holster()
	return true
end
