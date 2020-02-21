include("shared.lua")

function ENT:Draw()

    self:DrawModel()
	
	if not self:GetProduct() then return end
	if not ConfigurationMedicMod.Reagents[self:GetProduct()] then return end
	
	local dist = LocalPlayer():GetPos():Distance(self:GetPos())
	
	if dist > 500 then return end
	
	local angle = self.Entity:GetAngles()	
	
	local position = self.Entity:GetPos() + angle:Forward() * -2
	
	angle:RotateAroundAxis(angle:Forward(), 90);
	angle:RotateAroundAxis(angle:Right(),90);
	angle:RotateAroundAxis(angle:Up(), 0);
	
	cam.Start3D2D(position, angle, 0.2)
		
		draw.SimpleTextOutlined(self:GetProduct(), "MedicModFont15" ,0,-60, Color(255,255,255,255), 1, 1, 0.5, Color(0,0,0,255))
		draw.RoundedBox( 3, -3,-30, 5, 25, ConfigurationMedicMod.Reagents[self:GetProduct()].color )
		
	cam.End3D2D()
	
end

