include("shared.lua")


function ENT:Draw()

    self:DrawModel()
	
	if not self:GetDrug() then return end
	
	local dist = LocalPlayer():GetPos():Distance(self:GetPos())
	
	if dist > 500 then return end
	
	local angle = self.Entity:GetAngles()	
	
	local position = self.Entity:GetPos() + angle:Forward() * 5 + angle:Up() * 20 + angle:Right() * 0
	
	angle:RotateAroundAxis(angle:Forward(), 90);
	angle:RotateAroundAxis(angle:Right(),-40);
	angle:RotateAroundAxis(angle:Up(), 0);
	
	
	cam.Start3D2D(position + angle:Right() * math.sin(CurTime() * 2), angle, 0.2)
		
		draw.SimpleTextOutlined(self:GetDrug(), "MedicModFont15" ,-7,0, Color(255,255,255,255), 1, 1, 0.5, Color(0,0,0,255))

	cam.End3D2D()
	
end

