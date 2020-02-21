SWEP.ViewModelFlip 			= false
SWEP.UseHands				= true
SWEP.WorldModel 			= ""
SWEP.ViewModel				= "models/medicmod/heart_massage/v_heart_massage.mdl"
SWEP.Author					= "Venatuss"
SWEP.Instructions			= "Click to attack"

SWEP.Spawnable				= false
SWEP.AdminSpawnable			= false

SWEP.Primary.Damage         = 0
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
SWEP.PrintName				= "Heart Massage"
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

end

function SWEP:Deploy()
   return true
end
function SWEP:Initialize()
	self:SetHoldType( "normal" )
end

function SWEP:Holster()
	return true
end
