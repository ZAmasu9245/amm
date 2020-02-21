include("shared.lua")


function ENT:Draw()

    self:DrawModel()
	
	local dist = LocalPlayer():GetPos():Distance(self:GetPos())
	
	if dist > 500 then return end
	
	
	local angle = self.Entity:GetAngles()	
	
	local position = self.Entity:GetPos()
	
	angle:RotateAroundAxis(angle:Forward(), 0);
	angle:RotateAroundAxis(angle:Right(),0);
	angle:RotateAroundAxis(angle:Up(), 90);
	
	cam.Start3D2D(position, angle, 0.2)
	
		local blood = self:GetBlood()
		local bloodqt = math.Clamp(blood/100,0,1)
		
		local round
		if blood < 40 && blood > 20 then
			round = 5
		elseif blood <= 20 && blood > 10 then
			round = 3
		elseif blood <= 10 then
			round = 0
		elseif blood >= 40 then
			round = 8
		end
		
		draw.RoundedBox( round, -13,16 - 32* bloodqt, 26, 35 * bloodqt, Color(150,0,0) )
		draw.SimpleTextOutlined(blood.."%", "MedicModFont15" ,0,0, Color(255,255,255,255), 1, 1, 0.5, Color(0,0,0))
		
	cam.End3D2D()
	
end
