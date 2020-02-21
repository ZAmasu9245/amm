include("shared.lua")


function ENT:Draw()

    self:DrawModel()
	
	if not self:GetProduct1() or not self:GetProduct2() or not self:GetProduct3() then return end
	
	local dist = LocalPlayer():GetPos():Distance(self:GetPos())
	
	if dist > 500 then return end
	
	local angle = self.Entity:GetAngles()	
	
	local position = self.Entity:GetPos() + angle:Forward() * -7 + angle:Up() * 5
	local position2 = self.Entity:GetPos() + angle:Forward() * 0 + angle:Up() * 5
	
	angle:RotateAroundAxis(angle:Forward(), 90);
	angle:RotateAroundAxis(angle:Right(),90);
	angle:RotateAroundAxis(angle:Up(), 0);
	
	local color1 = Color(0,0,0,200)
	local color2 = Color(0,0,0,200)
	local color3 = Color(0,0,0,200)
	
	local font1 = "MedicModFont15"
	local font2 = "MedicModFont15"
	local font3 = "MedicModFont15"
	
	if string.len(self:GetProduct1()) > 12 then
		font1 = "MedicModFont10"
	end
	if string.len(self:GetProduct2()) > 12 then
		font2 = "MedicModFont10"
	end
	if string.len(self:GetProduct3()) > 12 then
		font3 = "MedicModFont10"
	end
	
	if self:GetProduct1() != ConfigurationMedicMod.Sentences["Empty"][ConfigurationMedicMod.Language] then
		color1 = Color(ConfigurationMedicMod.Reagents[self:GetProduct1()].color.r,ConfigurationMedicMod.Reagents[self:GetProduct1()].color.g,ConfigurationMedicMod.Reagents[self:GetProduct1()].color.b,200)
	end
	if self:GetProduct2() != ConfigurationMedicMod.Sentences["Empty"][ConfigurationMedicMod.Language] then
		color2 = Color(ConfigurationMedicMod.Reagents[self:GetProduct2()].color.r,ConfigurationMedicMod.Reagents[self:GetProduct2()].color.g,ConfigurationMedicMod.Reagents[self:GetProduct2()].color.b,200)
	end
	if self:GetProduct3() != ConfigurationMedicMod.Sentences["Empty"][ConfigurationMedicMod.Language] then
		color3 = Color(ConfigurationMedicMod.Reagents[self:GetProduct3()].color.r,ConfigurationMedicMod.Reagents[self:GetProduct3()].color.g,ConfigurationMedicMod.Reagents[self:GetProduct3()].color.b,200)
	end
	
	cam.Start3D2D(position, angle, 0.2)
		
		draw.RoundedBox( 0, -40, -24, 80, 15, color1 )
		draw.RoundedBox( 0, -40, -24 + 16, 80, 15, color2 )
		draw.RoundedBox( 0, -40, -24 + 32, 80, 15, color3 )
			
		draw.SimpleTextOutlined(self:GetProduct1(), font1 ,0,-17.5, Color(255,255,255,255), 1, 1, 0.5, Color(0,0,0,255))
		draw.SimpleTextOutlined(self:GetProduct2(), font2 ,0,-17.5 + 16, Color(255,255,255,255), 1, 1, 0.5, Color(0,0,0,255))
		draw.SimpleTextOutlined(self:GetProduct3(), font3 ,0,-17.5 + 32, Color(255,255,255,255), 1, 1, 0.5, Color(0,0,0,255))

	cam.End3D2D()

end

