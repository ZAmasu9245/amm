SWEP.ViewModelFlip 			= false
SWEP.UseHands				= true
SWEP.ViewModel 				= "models/medicmod/firstaidkit/v_firstaidkit.mdl"
SWEP.WorldModel 			= "models/medicmod/firstaidkit/w_firstaidkit.mdl"
SWEP.Author					= "Venatuss"
SWEP.Instructions			= "Click to attack"

SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.Primary.Damage         = 2
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Delay 			= 0.5

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Category 				= "Medic Mod"
SWEP.PrintName				= "First Aid Kit"
SWEP.Slot					= 1
SWEP.SlotPos				= 1
SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= true

function SWEP:SetupDataTables()
    self:NetworkVar("Int", 0, "Bandage")
    self:NetworkVar("Int", 1, "Antidote")
    self:NetworkVar("Int", 2, "Morphine")
    self:NetworkVar("Int", 3, "Active")
	if SERVER then
		self:SetBandage( 0 )
		self:SetAntidote( 0 )
		self:SetMorphine( 0 )
		self:SetActive( 1 )
	end
end

local sentences = ConfigurationMedicMod.Sentences
local lang = ConfigurationMedicMod.Language

function SWEP:SecondaryAttack()

	self:SetHoldType("grenade")
	
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )

	if SERVER then
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
		
		timer.Simple(0.3, function()
			
			if self:GetBandage() > 0 or self:GetAntidote() > 0 or self:GetMorphine() > 0 then
				local fak = ents.Create("firstaidkit_medicmod")
				fak:SetPos(self.Owner:GetPos() + self.Owner:GetAngles():Forward() * 15 + self.Owner:GetAngles():Up() * 50)
				fak:Spawn()
				fak.Content = {
					["bandage"] = self:GetBandage(),
					["syringe_antidote"] = self:GetAntidote(),
					["syringe_morphine"] = self:GetMorphine(),
				}
			else
				self.Owner:MedicNotif(sentences["Your care kit was thrown away because it is empty"][lang], 5)
			end
			
			if IsValid( self ) then self:Remove() end 
			
		end)
	end

end

function SWEP:ShouldDropOnDie()
	return false
end

local nextSelectTime = CurTime()

function SWEP:Reload()
	
	if nextSelectTime >= CurTime() then return end
	
	nextSelectTime = CurTime() + 1
	
	if self:GetActive() == 3 then
		self:SetActive(1)
	else
		self:SetActive(self:GetActive()+1)
	end
	
end 

function SWEP:PrimaryAttack()
	
	if not SERVER then return end
	
	if not IsValid( self.Owner ) then return end
	
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
	local items = {
		[1] = "bandage",
		[2] = "syringe_morphine",
		[3] = "syringe_antidote"
	}
	
	local selecteditem = items[self:GetActive()]
	
	if selecteditem == "bandage" && self:GetBandage() > 0 then
		if self.Owner:HasWeapon( selecteditem ) then self.Owner:MedicNotif(sentences["You already carry this element on you"][lang]) return end
		self:SetBandage( self:GetBandage() - 1) 
		self.Owner:Give(selecteditem)
		return
	end
	if selecteditem == "syringe_morphine" && self:GetMorphine() > 0 then
		if self.Owner:HasWeapon( selecteditem ) then self.Owner:MedicNotif(sentences["You already carry this element on you"][lang]) return end
		self:SetMorphine( self:GetMorphine() - 1) 
		self.Owner:Give(selecteditem)
		return
	end
	if selecteditem == "syringe_antidote" && self:GetAntidote() > 0 then
		if self.Owner:HasWeapon( selecteditem ) then self.Owner:MedicNotif(sentences["You already carry this element on you"][lang]) return end
		self:SetAntidote( self:GetAntidote() - 1) 
		self.Owner:Give(selecteditem)
		return
	end
	
		
end

function SWEP:DrawHUD()
	 
	
	local outlineColor1 = Color(0,0,0)
	local outlineColor2 = Color(0,0,0)
	local outlineColor3 = Color(0,0,0)
	
	local items = {
		[1] = sentences["Bandage"][lang],
		[2] = sentences["Morphine"][lang],
		[3] = sentences["Antidote"][lang]
	}
	
	if self:GetActive() == 1 then
		outlineColor1 = Color(200,50,50)
	elseif self:GetActive() == 2 then
		outlineColor2 = Color(200,50,50)
	elseif self:GetActive() == 3 then
		outlineColor3 = Color(200,50,50)
	end
	
	
	draw.SimpleTextOutlined(sentences["Bandage"][lang].." : "..self:GetBandage(), "MedicModFont20", ScrW()/2 - ScrW()*0.1,ScrH()/2 + ScrH()*0.2,Color(255,255,255),1,1,1,outlineColor1)
	draw.SimpleTextOutlined(sentences["Antidote"][lang].." : "..self:GetAntidote(), "MedicModFont20", ScrW()/2 +  ScrW()*0.1,ScrH()/2 + ScrH()*0.2,Color(255,255,255),1,1,1,outlineColor3)
	draw.SimpleTextOutlined(sentences["Morphine"][lang].." : "..self:GetMorphine(), "MedicModFont20", ScrW()/2,ScrH()/2 + ScrH()*0.25,Color(255,255,255),1,1,1,outlineColor2)
	
	draw.SimpleTextOutlined(sentences["Item selected"][lang].." : "..items[self:GetActive()], "MedicModFont20", ScrW()/2,ScrH()/2 + ScrH()*0.3 + 40,Color(255,255,255),1,1,1,Color(0,0,0))
	draw.SimpleTextOutlined(sentences["Press [RELOAD] to select another item"][lang], "MedicModFont20", ScrW()/2,ScrH()/2 + ScrH()*0.3 + 70,Color(255,255,255),1,1,1,Color(0,0,0))
	draw.SimpleTextOutlined(sentences["Press [LEFT CLICK] to take"][lang], "MedicModFont20", ScrW()/2,ScrH()/2 + ScrH()*0.3 + 100,Color(255,255,255),1,1,1,Color(0,0,0))
	draw.SimpleTextOutlined(sentences["Press [RIGHT CLICK] to drop"][lang], "MedicModFont20", ScrW()/2,ScrH()/2 + ScrH()*0.3 + 130,Color(255,255,255),1,1,1,Color(0,0,0))
	
end

function SWEP:Deploy()
   return true
end
function SWEP:Initialize()
	self:SetHoldType( "normal" )
	self:SetBandage( 0 )
	self:SetAntidote( 0 )
	self:SetMorphine( 0 )
	self:SetActive( 1 )
end

function SWEP:Holster()
	return true
end
