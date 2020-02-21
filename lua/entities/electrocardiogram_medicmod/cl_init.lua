include("shared.lua")

local matRate1 = Material("materials/heart_rate2.png")
local matRate2 = Material("materials/heart_rate1.png")
local matRate3 = Material("materials/heart_rate3.png")
local matWhiteBar = Material("materials/whitebar.png")

local matrate = matRate1

local posx = 0-20

function ENT:Draw()

    self:DrawModel()

		
	if IsValid(self:GetPatient()) then
		
		if self:GetPatient():GetHeartAttack() then
			matrate = matRate1
		elseif self:GetPatient():Stable() then
			matrate = matRate2
		else
			matrate = matRate3
		end
		
		local angle = self:GetAngles()
		local pos = self:GetPos() + angle:Right() * 5 + angle:Forward() * 7.5+ angle:Up() * 2.5
		local ang = self:GetAngles()
		
		ang:RotateAroundAxis(ang:Forward(), 0);
		ang:RotateAroundAxis(ang:Right(),-80);
		ang:RotateAroundAxis(ang:Up(), 90);
		
		cam.Start3D2D( pos, ang, 0.01)
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( matWhiteBar )
			surface.DrawTexturedRect( posx ,0, 20, 380 )
			
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( matrate )
			surface.DrawTexturedRect( 0,0, 490, 380 )
		cam.End3D2D()
		
		if posx > 380-20 then
			posx = 0-20
		else
			posx = posx + 1
		end
	
	end
	
end

function ENT:OnRemove()
	if not BaseFrame then return end
	if not ispanel( BaseFrame ) then return end
	BaseFrame:Remove()
end
