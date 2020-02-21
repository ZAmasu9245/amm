local meta = FindMetaTable( "Player" )
local sentences = ConfigurationMedicMod.Sentences
local lang = ConfigurationMedicMod.Language

function StartMedicAnimation( ply, id )

	if not IsValid(ply) then return end

	if ply.mdlanim && IsValid( ply.mdlanim ) then print("model already exist, removed") ply.mdlanim:Remove() end
	
	if ply:GetNWString("MedicPlayerModel") then

		ply.mdlanim = ClientsideModel(ply:GetNWString("MedicPlayerModel"))
        
		if IsValid( ply.mdlanim ) then
			ply.mdlanim:SetParent( ply )
			ply.mdlanim:AddEffects( EF_BONEMERGE )
			return ply.mdlanim
		else
			return false
		end
	end

end

function StopMedicAnimation( ply )
	if IsValid( ply.mdlanim ) && ply:GetMedicAnimation() == 0 then
		ply.mdlanim:Remove()
	end
end

local Background = Material( "medic/terminal/background.png" )

local ArrowRight = Material( "medic/terminal/arrow_right.png" )
local ArrowLeft = Material( "medic/terminal/arrow_left.png" )

function MedicMod.TerminalMenu( ent )

	local ActiveItem = 1

	/* MAIN FRAME */

	local _MainFrame = vgui.Create( "DPanel" )
	_MainFrame:SetSize( 750, 500 )
	_MainFrame:Center()
	_MainFrame:MakePopup()

	_MainFrame.Paint = function( pnl, w, h )

		/* BACKGROUND */

		surface.SetDrawColor( 255, 255, 255 )
		surface.SetMaterial( Background )
		surface.DrawTexturedRect( 0, 0, w, h )

		draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 225 ))

		/* TOP */

		draw.RoundedBox( 0, 0, 0, w, h*0.2, Color( 255, 255, 255, 10 ))

		draw.DrawText( "Terminal", "MedicModFont17", w*0.5, h*0.065, Color( 255, 255, 255 ), 1)

		/* BOTTOM */

		draw.DrawText( ConfigurationMedicMod.Entities[ActiveItem].price..ConfigurationMedicMod.MoneyUnit, "Aam::Normal", w*0.5, h*0.785, Color( 255, 255, 255 ), 1)

		draw.RoundedBox( 0, w*0.2, h*0.75, w*0.6, 2, Color( 255, 255, 255 ))
	end

	/* SCROLL SYSTEM */

	local ItemScrollPanel = vgui.Create("DScrollPanel", _MainFrame )
	ItemScrollPanel:SetSize( _MainFrame:GetWide()*0.6, _MainFrame:GetTall()*0.45 )
	ItemScrollPanel:SetPos( _MainFrame:GetWide()*0.2, _MainFrame:GetTall()*0.25 )

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

			draw.DrawText( v.name, "MedicModFont17", w*0.5, h*0.1, Color( 255, 255, 255 ), 1)
			
		end
		
		ItemSlot[k].model = vgui.Create( "DModelPanel", ItemSlot[k] )
		ItemSlot[k].model:SetPos( 0, 100 )
		ItemSlot[k].model:SetSize( ItemsList:GetWide(), ItemsList:GetTall()-100 )
		ItemSlot[k].model:SetLookAt( Vector(0, 0, 0 ) )
		ItemSlot[k].model:SetCamPos( Vector( -50, 0, 30 ) )
		ItemSlot[k].model:SetModel( v.mdl )
		
	end

	/* LEFT */

	local _LeftArrow = vgui.Create( "DButton", _MainFrame )
	_LeftArrow:SetSize( 50, 50 )
	_LeftArrow:SetPos( _MainFrame:GetWide()*0.1, _MainFrame:GetTall()*0.4 )
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

	local _RightArrow = vgui.Create( "DButton", _MainFrame )
	_RightArrow:SetSize( 50, 50 )
	_RightArrow:SetPos( _MainFrame:GetWide()*0.9 - 50, _MainFrame:GetTall()*0.4 )
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

	local _BuyButton = vgui.Create( "DButton", _MainFrame )
	_BuyButton:SetSize( _MainFrame:GetWide()*0.15, _MainFrame:GetTall()*0.0725 )
	_BuyButton:SetPos( _MainFrame:GetWide()*0.5 - ( _BuyButton:GetWide() / 2 ), _MainFrame:GetTall()*0.9 )
	_BuyButton:SetText("")
	_BuyButton.Color = Color(200,200,200,255)

	_BuyButton.Paint = function( pnl, w, h )
		
		local color = _BuyButton.Color
		
		draw.DrawText( sentences["Buy"][lang], "Aam::Button", w*0.5, h*0.1, color, 1)
		
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
			net.WriteEntity( ent )
		net.SendToServer()
		
		_MainFrame:Remove()
	end

	/* CLOSE BUTTON */

	local _CloseButton = vgui.Create( "DButton", _MainFrame )
	_CloseButton:SetSize( _MainFrame:GetWide()*0.05, _MainFrame:GetTall()*0.0725 )
	_CloseButton:SetPos( _MainFrame:GetWide()*0.99 - ( _CloseButton:GetWide() ), _MainFrame:GetTall()*0.01 )
	_CloseButton:SetText("")
	_CloseButton.Color = Color(200,200,200,255)

	_CloseButton.Paint = function( pnl, w, h )
		
		local color = _CloseButton.Color
		
		draw.DrawText( "X", "Aam::Button", w*0.5, h*0.1, color, 1)

		if _CloseButton:IsHovered() then
			
			local r = math.Clamp(color.r+10, 200, 255 )
			local g = math.Clamp(color.g+10, 200, 255 )
			local b = math.Clamp(color.b+10, 200, 255 )

			_CloseButton.Color = Color(r,g,b,255)
			
		else
			
			local r = math.Clamp(color.r-5, 200, 255 )
			local g = math.Clamp(color.g-5, 200, 255 )
			local b = math.Clamp(color.b-5, 200, 255 )

			_CloseButton.Color = Color(r,g,b,255)
			
		end
		
		draw.RoundedBox( 3, 0, 0, w, 2, color)
		draw.RoundedBox( 3, 0, 0, 2, h, color)
		draw.RoundedBox( 3, 0, h-2, w, 2, color)
		draw.RoundedBox( 3, w-2, 0, 2, h, color)
	end

	_CloseButton.DoClick = function()

		_MainFrame:Remove()
	end
end

