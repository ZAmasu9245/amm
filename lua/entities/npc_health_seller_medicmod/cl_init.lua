include( "shared.lua" )

local sentences = ConfigurationMedicMod.Sentences
local lang = ConfigurationMedicMod.Language

function ENT:Draw()

	self:DrawModel()
	
	local dist = LocalPlayer():GetPos():Distance(self:GetPos())
	
	if dist > 500 then return end
	
	local ang = Angle(0, LocalPlayer():EyeAngles().y-90, 90)
	
	local angle = self.Entity:GetAngles()	
	
	local position = self.Entity:GetPos()+Vector(0,0,0)
	
	angle:RotateAroundAxis(angle:Forward(), 0);
	angle:RotateAroundAxis(angle:Right(),0);
	angle:RotateAroundAxis(angle:Up(), 90);
	
	cam.Start3D2D(position+angle:Right()*0+angle:Up()*( math.sin(CurTime() * 2) * 2.5 + 78 )+angle:Forward()*0, ang, 0.1)
		
		draw.RoundedBox( 5, -150/2, -25, 150, 50, Color(40,100,170, 500-dist ) )
		draw.SimpleTextOutlined( sentences["Medic"][lang], "Trebuchet24" ,0,0, Color(255,255,255,500-dist), 1, 1, 1, Color(0,0,0))
	
	cam.End3D2D()
	
end
