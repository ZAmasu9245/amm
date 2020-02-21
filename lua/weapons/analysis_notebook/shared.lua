SWEP.ViewModelFlip 			= false
SWEP.UseHands				= true
SWEP.Author					= "Venatuss"
SWEP.Instructions			= "Click to use"

SWEP.WorldModel				= ""

SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.Primary.Damage         = 0
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Delay 			= 1

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Category 				= "Medic Mod"
SWEP.PrintName				= "Medic Analysis"
SWEP.Slot					= 1
SWEP.SlotPos				= 1
SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= true

local lang = ConfigurationMedicMod.Language

SWEP.Infos = {}

function SWEP:SetupDataTables()
    self:NetworkVar("Bool", 0, "Searching")
    self:NetworkVar("Entity", 0, "Player")
    self:NetworkVar("Float", 1, "AnalyseEndTime")
    self:NetworkVar("Entity", 1, "Patient")
end


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
	
	if SERVER then 
		
		if not IsValid(ent) or ent:GetPos():Distance(self.Owner:GetPos()) > 200 then return end
		if self:GetSearching() then return end
		
		if ent:IsDeathRagdoll() then
			self:SetSearching( true )
			self:SetAnalyseEndTime( CurTime() + ConfigurationMedicMod.TimeToQuickAnalyse )
			self:SetPatient( ent )
			self:SetPlayer( ent:GetOwner() )
		elseif IsValid(ent.ragdoll) && ent.ragdoll:IsDeathRagdoll() then
			self:SetSearching( true )
			self:SetAnalyseEndTime( CurTime() + ConfigurationMedicMod.TimeToQuickAnalyse )
			self:SetPatient( ent )
			self:SetPlayer( ent.ragdoll:GetOwner() )
		end
	
	end

end

function SWEP:Deploy()
	if SERVER then timer.Simple( 0.1, function() self.Owner:DrawViewModel( false ) self.Owner:DrawWorldModel( false ) end) end
	return true
end
function SWEP:Initialize()
	self:SetHoldType( "normal" )
	
	if SERVER then timer.Simple( 0.1, function() self.Owner:DrawViewModel( false ) self.Owner:DrawWorldModel( false ) end) end
	
end

function SWEP:Holster()
	return true
end

function SWEP:Think()
	
	if not self:GetSearching() then return end
	if self:GetAnalyseEndTime() > CurTime() && self:GetAnalyseEndTime() > 0 then
		if IsValid(self:GetPatient()) && IsValid(self.Owner:GetEyeTrace().Entity) && self:GetPatient() == self.Owner:GetEyeTrace().Entity then 
			if self.Owner:GetPos():Distance(self:GetPatient():GetPos()) > 200 then
				self:SetSearching( false )
				self:SetPatient( nil )
				self:SetPlayer( nil )
				self:SetAnalyseEndTime( 0 )
			end
		else
			self:SetSearching( false )
			self:SetPlayer( nil )
			self:SetAnalyseEndTime( 0 )		
			self:SetPatient( nil )
		end
	else
	
		if not IsValid(self:GetPatient()) then 
				self:SetSearching( false )
				self:SetPlayer( nil )
				self:SetAnalyseEndTime( 0 )		
				self:SetPatient( nil )
			return
		end
		
		local ply = self:GetPlayer()
		
		self.Infos = {}
		self.Infos[1] = ConfigurationMedicMod.Sentences["The name of the individu is"][lang].." "..ply:Name()
		if ply:IsBleeding() then
			self.Infos[#self.Infos + 1] = ConfigurationMedicMod.Sentences["There's blood everywhere, it seems he's bleeding"][lang]
		end
		if ply:IsPoisoned() then
			self.Infos[#self.Infos + 1] = ConfigurationMedicMod.Sentences["He is greenish, may have been poisoned"][lang]
		end
		if ply:GetHeartAttack() then
			self.Infos[#self.Infos + 1] = ConfigurationMedicMod.Sentences["His heart no longer beats"][lang]
		end
		
		timer.Simple( 60, function() self.Infos = {} end)
		self:SetSearching( false )
		self:SetPatient( nil )
		self:SetPlayer( nil )
		self:SetAnalyseEndTime( 0 )
	end
	

end

local notepad = Material( "materials/note_paper_medic.png" )

local dots = {
    [0] = ".",
    [1] = "..",
    [2] = "...",
    [3] = ""
}

function SWEP:DrawHUD()
	surface.SetDrawColor( 255,255,255,255 )
	surface.SetMaterial( notepad )
	surface.DrawTexturedRect( ScrW() - 518 - 20, ScrH() - 720 - 20, 518, 720 )
		
	surface.SetFont("WrittenMedicMod80")
	
	local sizetextx, sizetexty = surface.GetTextSize(ConfigurationMedicMod.Sentences["Notebook"][lang])
	
	local posx = ScrW() - 518 - 20 + 518/2 - sizetextx/2 + 20
	local posy = ScrH() - 720 - 20
	
	surface.SetTextPos( posx, posy)
	surface.SetTextColor( 0, 0, 0, 255)
	surface.DrawText( ConfigurationMedicMod.Sentences["Notebook"][lang] )
	
	if self:GetSearching() then
		if (not self.NextDotsTime or SysTime() >= self.NextDotsTime) then
			self.NextDotsTime = SysTime() + 0.5
			self.Dots = self.Dots or ""
			local len = string.len(self.Dots)

			self.Dots = dots[len]
		end
		local sizetextx, sizetexty = surface.GetTextSize(ConfigurationMedicMod.Sentences["Writing"][lang]..self.Dots)
	
		local posx = ScrW() - 518 - 20 + 518/2 - sizetextx/2 + 20
		local posy = ScrH() - 720 - 20 + 518/2 + 10
		
		surface.SetTextPos( posx, posy)
		surface.SetTextColor( 0, 0, 0, 255)
		surface.DrawText( ConfigurationMedicMod.Sentences["Writing"][lang]..self.Dots )
		return
    end
	
	if self.Infos != nil then
		local line = 0
		for k, v in pairs(self.Infos) do 
			
			-- stop the loop if there is too many lines
			if line > 24 then return end
			
			local sizetextx, sizetexty = surface.GetTextSize(v)
			local posy = ScrH() - 720 - 20 + 57 * 1.5 + 10
			local posx = ScrW() - 518 - 20 + 65 * 1.5
			
			surface.SetFont("WrittenMedicMod40")
			surface.SetTextColor( 0, 0, 0, 255)
			
			if sizetextx > (518) - 65 - 20 then
				surface.SetFont("WrittenMedicMod40")
			end
			
			sizetextx, sizetexty = surface.GetTextSize(v)
			if sizetextx > (518) - 65 - 20 then
				local lengh = string.len( v )
				local ftcl = string.find(v," ", lengh/2-1)
				local text1 = string.sub(v, 1, ftcl-1)
				local text2 = string.sub(v, ftcl+1)

				surface.SetTextPos( posx, posy + 24 * line)
				surface.DrawText( text1 )
				line = line + 1
				surface.SetTextPos( posx , posy + 24 * line)
				surface.DrawText( text2 )
				line = line + 2
			else
				surface.SetTextPos( posx, posy + 24 * line)
				surface.DrawText( v	 )
				
				line = line + 2
			end
			
			
			
		end
	end	

end
