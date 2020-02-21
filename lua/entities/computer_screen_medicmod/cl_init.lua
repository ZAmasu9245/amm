include("shared.lua")

local materialBackground = Material("materials/medical_background_white.jpg")
local body1 = Material("materials/body.png")
local body2 = Material("materials/body_left_arm.png")
local body3 = Material("materials/body_right_arm.png")
local body4 = Material("materials/body_left_leg.png")
local body5 = Material("materials/body_right_leg.png")
local sentences = ConfigurationMedicMod.Sentences
local lang = ConfigurationMedicMod.Language

local posx = 0-20

function ENT:Draw()

    self:DrawModel()
	
	local radio = self:GetParent()
	if not radio then return end
		
	local angle = self:GetAngles()
	local pos = self:GetPos() + angle:Right() * 27.9 + angle:Forward() * 6+ angle:Up() * 35.5
	local ang = self:GetAngles()
	
	ang:RotateAroundAxis(ang:Forward(), 0);
	ang:RotateAroundAxis(ang:Right(),-90);
	ang:RotateAroundAxis(ang:Up(), 90);
	
	cam.Start3D2D( pos, ang, 0.282)
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( materialBackground )
		surface.DrawTexturedRect( 0 ,0, 852/4 - 10, 480/4 )
		
		-- draw.RoundedBox( 0, 0,0,500/9,901/9, Color(255,255,255,255))
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( body1 )
		surface.DrawTexturedRect( (852/4 - 10)/2 - (500/9)/2 , (480/4)/2 - (901/9)/2 , 500/9,901/9 )
				
		if radio.fracturesTable then
		
			if radio.fracturesTable[HITGROUP_LEFTLEG] then 
				surface.SetDrawColor( 255, 255, 255, 255 )
				surface.SetMaterial( body4 )
				surface.DrawTexturedRect( (852/4 - 10)/2 - (500/9)/2 , (480/4)/2 - (901/9)/2 , 500/9,901/9)
			end
			if radio.fracturesTable[HITGROUP_RIGHTLEG] then 
				surface.SetDrawColor( 255, 255, 255, 255 )
				surface.SetMaterial( body5 )
				surface.DrawTexturedRect( (852/4 - 10)/2 - (500/9)/2 , (480/4)/2 - (901/9)/2 , 500/9,901/9 )
			end
			if radio.fracturesTable[HITGROUP_LEFTARM] then 
				surface.SetDrawColor( 255, 255, 255, 255 )
				surface.SetMaterial( body2 )
				surface.DrawTexturedRect( (852/4 - 10)/2 - (500/9)/2 , (480/4)/2 - (901/9)/2 , 500/9,901/9)
			end
			if radio.fracturesTable[HITGROUP_RIGHTARM] then 
				surface.SetDrawColor( 255, 255, 255, 255 )
				surface.SetMaterial( body3 )
				surface.DrawTexturedRect((852/4 - 10)/2 - (500/9)/2 , (480/4)/2 - (901/9)/2 , 500/9,901/9)
			end
			
		end
		
	cam.End3D2D()

	
end

function ENT:OnRemove()
	if not BaseFrame then return end
	if not ispanel( BaseFrame ) then return end
	BaseFrame:Remove()
end
