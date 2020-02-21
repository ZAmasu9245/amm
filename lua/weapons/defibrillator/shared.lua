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
SWEP.PrintName				= "Defibrillator"
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

local percentageChance = math.Clamp( ConfigurationMedicMod.DefibrillatorShockChance,1,100)

function SWEP:PrimaryAttack()

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

	local ent = self.Owner:GetEyeTrace().Entity
	
	if not IsValid( self.Owner ) then return end
	
	if not IsValid(ent) or ent:GetPos():Distance( self.Owner:GetPos() ) > 200 then return end
	
	if ent:IsPlayer() && ent:GetHeartAttack() then
		
		self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )

		if SERVER then
			self.Owner:SetAnimation( PLAYER_ATTACK1 )
			
			local randChance = math.random( 1, 100 )
			if randChance <= percentageChance then self.Owner:MedicNotif(ConfigurationMedicMod.Sentences["The shock did not work. Try again"][ConfigurationMedicMod.Language]) return end
			
			ent:SetHeartAttack( false )
			self.Owner:MedicNotif( ConfigurationMedicMod.Sentences["The heart of the wounded man began to beat again"][ConfigurationMedicMod.Language], 5 )
			ent:MedicNotif( ConfigurationMedicMod.Sentences["Your heart started to beat again"][ConfigurationMedicMod.Language], 5 )
		end
		
	elseif ent:IsDeathRagdoll() && ent:GetOwner():GetHeartAttack() then
		
		self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
		
		if SERVER then
			self.Owner:SetAnimation( PLAYER_ATTACK1 )
			
			local randChance = math.random( 1, 100 )
			if randChance <= percentageChance then self.Owner:MedicNotif(ConfigurationMedicMod.Sentences["The shock did not work. Try again"][ConfigurationMedicMod.Language]) return end
			
			local ply = ent:GetOwner()
			
			ply:SetHeartAttack( false )
			ply:Stabilize( self.Owner )
			
			self.Owner:MedicNotif( ConfigurationMedicMod.Sentences["The heart of the wounded man began to beat again"][ConfigurationMedicMod.Language], 5 )
			ply:MedicNotif( ConfigurationMedicMod.Sentences["Your heart started to beat again"][ConfigurationMedicMod.Language], 5 )
			
		end
		
	elseif IsValid(ent.ragdoll) && ent.ragdoll:IsDeathRagdoll() && ent.ragdoll:GetOwner():GetHeartAttack() then
		
		self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
		
		if SERVER then
			self.Owner:SetAnimation( PLAYER_ATTACK1 )
			
			local randChance = math.random( 1, 100 )
			if randChance <= percentageChance then self.Owner:MedicNotif(ConfigurationMedicMod.Sentences["The shock did not work. Try again"][ConfigurationMedicMod.Language]) return end
			
			local ply = ent.ragdoll:GetOwner() 
			
			ply:SetHeartAttack( false )
			ply:Stabilize( self.Owner )
			
			self.Owner:MedicNotif( ConfigurationMedicMod.Sentences["The heart of the wounded man began to beat again"][ConfigurationMedicMod.Language], 5 )
			ply:MedicNotif( ConfigurationMedicMod.Sentences["Your heart started to beat again"][ConfigurationMedicMod.Language], 5 )
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
