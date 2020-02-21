include("shared.lua")

local materialBackground = Material("materials/medical_background.png")
local sentences = ConfigurationMedicMod.Sentences
local lang = ConfigurationMedicMod.Language

local Background = Material( "medic/terminal/background.png" )

local ArrowRight = Material( "medic/terminal/arrow_right.png" )
local ArrowLeft = Material( "medic/terminal/arrow_left.png" )

function ENT:CreateGUI( scale )
	
	local scale = scale or 1
	
	local ActiveItem = 1

	/* MAIN FRAME */

	local frame = vgui.Create( "DPanel" )
	-- frame:SetPos( 0, 0 )
	frame:SetSize( 158, 130 )
	frame:SetPaintedManually(true)
	-- frame:MakePopup()
	-- frame.Think = function()
			-- if not IsValid( self ) then 
				-- if not frame then return end
				-- if not ispanel( frame ) then return end
				
				-- frame:Remove()
				
				-- return
			-- end

			-- if not frame then return end
			-- if not ispanel(frame) then return end -- if the panel exists

			-- local distance = self:GetPos():Distance(LocalPlayer():GetPos())

			-- if distance > 700 then frame:SetPos( -490, -380 ) return end

			-- if not isDraw then frame:SetPos( -490, -380 ) return end -- if is draw

			-- local pos = self:GetPos():ToScreen()
			
			-- if not pos.visible then return end

			-- frame:SetPos( 0,0 )
						
		-- end

	frame.Paint = function( pnl, w, h )

		/* BACKGROUND */

		surface.SetDrawColor( 255, 255, 255 )
		surface.SetMaterial( Background )
		surface.DrawTexturedRect( 0, 0, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 225 ))

		/* TOP */

		draw.RoundedBox( 0, 0, 0, w, h*0.2, Color( 255, 255, 255, 10 ))

		draw.DrawText( "Terminal", "MedicModFont15", w*0.5, h*0.065, Color( 255, 255, 255 ), 1)

		/* BOTTOM */

		draw.DrawText( ConfigurationMedicMod.Entities[ActiveItem].price..ConfigurationMedicMod.MoneyUnit, "MedicModFont12", w*0.5, h*0.785, Color( 255, 255, 255 ), 1)

		draw.RoundedBox( 0, w*0.2, h*0.75, w*0.6, 2, Color( 255, 255, 255 ))
	end

	/* SCROLL SYSTEM */

	local ItemScrollPanel = vgui.Create("DScrollPanel", frame )
	ItemScrollPanel:SetSize( frame:GetWide()*0.6, frame:GetTall()*0.45 )
	ItemScrollPanel:SetPos( frame:GetWide()*0.2, frame:GetTall()*0.25 )

	ItemScrollPanel:GetVBar().Paint = function()
	end

	ItemScrollPanel:GetVBar().btnGrip.Paint = function()
	end

	ItemScrollPanel:GetVBar().btnUp.Paint = function()
	end

	ItemScrollPanel:GetVBar().btnDown.Paint = function()
	end

	/* ITEM LIST */

	local ItemsList = vgui.Create( "DIconLayout", ItemScrollPanel )
	ItemsList:SetSize( ItemScrollPanel:GetWide(), ItemScrollPanel:GetTall() )
	ItemsList:SetPos( 0, 0 )
	ItemsList:SetSpaceY( 0 )
	ItemsList:SetSpaceX( 0 )

	ItemSlot = {}

	for k, v in pairs( ConfigurationMedicMod.Entities ) do

		ItemSlot[k] = vgui.Create( "DPanel", ItemsList )
		ItemSlot[k]:SetSize( ItemsList:GetWide(), ItemsList:GetTall() )
		
		ItemSlot[k].Paint = function( pnl, w, h )

			draw.DrawText( v.name, "MedicModFont12", w*0.5, h*0.1, Color( 255, 255, 255 ), 1)
			
		end
		
		local SpawnI = vgui.Create( "SpawnIcon" , ItemSlot[k] )
			SpawnI:SetPos( 20, 10 )
			SpawnI:SetSize( ItemSlot[k]:GetWide() - 40, ItemSlot[k]:GetWide() - 40 )
			SpawnI:SetModel( v.mdl )
			
	end

	/* LEFT */

	local _LeftArrow = vgui.Create( "DButton", frame )
	_LeftArrow:SetSize( 50/2, 50/2 )
	_LeftArrow:SetPos( frame:GetWide()*0.1, frame:GetTall()*0.4 )
	_LeftArrow:SetText("")

	_LeftArrow.Paint = function( pnl, w, h )

		surface.SetDrawColor( 255, 255, 255 )
		surface.SetMaterial( ArrowLeft )
		surface.DrawTexturedRect( 0, 0, w, h )
	end

	_LeftArrow.DoClick = function()

		if ActiveItem == 1 then return end

		ActiveItem = ActiveItem - 1

		ItemScrollPanel:ScrollToChild(ItemSlot[ActiveItem])
	end

	/* RIGHT */

	local _RightArrow = vgui.Create( "DButton", frame )
	_RightArrow:SetSize( 50/2, 50/2 )
	_RightArrow:SetPos( frame:GetWide()*0.9 - 25, frame:GetTall()*0.4 )
	_RightArrow:SetText("")

	_RightArrow.Paint = function( pnl, w, h )

		surface.SetDrawColor( 255, 255, 255 )
		surface.SetMaterial( ArrowRight )
		surface.DrawTexturedRect( 0, 0, w, h )
	end

	_RightArrow.DoClick = function()

		if ActiveItem == table.Count( ConfigurationMedicMod.Entities ) then return end

		ActiveItem = ActiveItem + 1	

		ItemScrollPanel:ScrollToChild(ItemSlot[ActiveItem])
	end

	/* BUY */

	local _BuyButton = vgui.Create( "DButton", frame )
	_BuyButton:SetSize( frame:GetWide()*0.3, frame:GetTall()*0.12 )
	_BuyButton:SetPos( frame:GetWide()*0.5 - ( _BuyButton:GetWide() / 2 ), frame:GetTall()*0.87 )
	_BuyButton:SetText("")
	_BuyButton.Color = Color(200,200,200,255)

	_BuyButton.Paint = function( pnl, w, h )
		
		local color = _BuyButton.Color
		
		draw.DrawText( sentences["Buy"][lang], "MedicModFont12", w*0.5, h*0.1, color, 1)
		
		if _BuyButton:IsHovered() then
			
			local r = math.Clamp(color.r+10, 200, 255 )
			local g = math.Clamp(color.g+10, 200, 255 )
			local b = math.Clamp(color.b+10, 200, 255 )

			_BuyButton.Color = Color(r,g,b,255)
			
		else
			
			local r = math.Clamp(color.r-5, 200, 255 )
			local g = math.Clamp(color.g-5, 200, 255 )
			local b = math.Clamp(color.b-5, 200, 255 )

			_BuyButton.Color = Color(r,g,b,255)
			
		end
		
		draw.RoundedBox( 3, 0, 0, w, 2, color)
		draw.RoundedBox( 3, 0, 0, 2, h, color)
		draw.RoundedBox( 3, 0, h-2, w, 2, color)
		draw.RoundedBox( 3, w-2, 0, 2, h, color)
	end

	_BuyButton.DoClick = function()

		net.Start("MedicMod.BuyMedicEntity")
			net.WriteInt( ActiveItem, 32 )
			net.WriteEntity( self )
		net.SendToServer()
		
	end
	
	return frame
	
end

-- function ENT:Initialize()
	-- if ConfigurationMedicMod.Terminal3D2D then 
		-- timer.Simple(1, function() if IsValid(self) then self:CreateGUI() end end)
	-- end
-- end
	
function ENT:Draw()

    self:DrawModel()
		
	if not ConfigurationMedicMod.Terminal3D2D then return end
	
	local ang = self:GetAngles()
	-- local pos = self:GetPos() + ang:Right() *  80 + ang:Forward() * 2 + ang:Up() * 96.5
	local pos = self:LocalToWorld( Vector(4,-8,58 ) )

	-- local pos = self:GetPos()
		
	ang:RotateAroundAxis(ang:Forward(), 0);
	ang:RotateAroundAxis(ang:Right(),-87);
	ang:RotateAroundAxis(ang:Up(), 90);
	
	if self.ActualizeGui then
		if self.frame then self.frame:Remove() end
		self.frame = self:CreateGUI()
		self.ActualizeGui = false
	else
		self.frame = self.frame or self:CreateGUI()
	end
	
	vgui.Start3D2D( pos, ang, 0.1 )
		self.frame:Paint3D2D()
	vgui.End3D2D()
		
end

function ENT:OnRemove()
	if not self.frame or not IsValid( self.frame ) then return end
	if not ispanel( self.frame ) then return end
	self.frame:Remove()
end

