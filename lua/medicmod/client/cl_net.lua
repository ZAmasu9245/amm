local sentences = ConfigurationMedicMod.Sentences
local lang = ConfigurationMedicMod.Language

local function CreateCloseButton( Parent, Panel, color, sx, sy, back, backcolor)
	
	Parent = Parent or ""
	sx = sx or 50
	sy = sy or 20
	color = color or Color(255,255,255,255)
	back = back or false
	backcolor = backcolor or false

	local x,y  = Parent:GetSize()
	
	local CloseButton = vgui.Create("DButton", Parent)
		CloseButton:SetPos(x-sx, 0)
		CloseButton:SetSize(sx,sy)
		CloseButton:SetFont("Trebuchet24")
		CloseButton:SetTextColor( color )
		CloseButton:SetText("X")
		function CloseButton:DoClick()
			Panel:Close()
		end
		CloseButton.Paint = function(s , w , h)
			if back then
				draw.RoundedBox(0,0,0,w , h,backcolor)
			end
		end
		
	return CloseButton
	
end

local function CreateButton( Parent, text, font, colorText, px, py, sx, sy, func, back, backcolor, backcolorbar, sound)
	
	Parent = Parent or ""
	font = font or "Trebuchet18"
	text = text or ""
	px = px or 0
	py = py or 0
	sx = sx or 50
	sound = sound or true
	func = func or function() end
	sy = sy or 50
	colorText = colorText or Color(255,255,255,255)
	back = back or true
	backcolor = backcolor or Color( 0, 100 , 150 )
	backcolorbar = backcolorbar or Color( 0 , 80 , 120 )

	local Button = vgui.Create("DButton", Parent)
		Button:SetPos( px , py )
		Button:SetSize(sx,sy)
		Button:SetFont("Trebuchet24")
		Button:SetTextColor( colorText )
		Button:SetText(text)
		function Button:DoClick()
			func()
			if sound then
				surface.PlaySound( "UI/buttonclick.wav" )
			end
		end
		
		if sound then
			function Button:OnCursorEntered()
				surface.PlaySound( "UI/buttonrollover.wav" )
			end
		end
		
		Button.Paint = function(s , w , h)
			if back then
				if Button:IsHovered() then
					draw.RoundedBox(0,0,0,w , h, Color( backcolor.r + 30, backcolor.g + 30, backcolor.b + 30 ))
					draw.RoundedBox(0,0,h-sy/10,sx , sy/10, Color( backcolorbar.r + 30, backcolorbar.g + 30, backcolorbar.b + 30  ))
				else
					draw.RoundedBox(0,0,0,w , h, backcolor)
					draw.RoundedBox(0,0,h-sy/10,sx , sy/10, backcolorbar)
				end
			end
		end
		
	return Button
	
end

local function CreatePanel( Parent, sx, sy, posx, posy, backcolor, scroll, bar, grip, btn)
	
	Parent = Parent or ""
	sx = sx or 100
	sy = sy or 100
	backcolor = backcolor or Color(35, 35, 35, 255)
	posx = posx or 0
	posy = posy or 0
	scroll = scroll or false
	bar = bar or Color( 30, 30, 30 )
	grip = grip or Color( 0, 140, 208 )
	btn = btn or Color( 4,95,164 )
	
	local typ = "DPanel"
	if scroll then
		typ = "DScrollPanel"
	else
		typ = "DPanel"
	end
	
	local Panel = vgui.Create(typ, Parent)
		Panel:SetSize(sx,sy)
		Panel:SetPos(posx,posy)
		Panel.Paint = function(s , w , h)
			draw.RoundedBox(0,0,0,w , h, backcolor)
		end
		
	if typ == "DScrollPanel" then
	
		local sbar = Panel:GetVBar()
	
		function sbar:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, bar )
		end
		
		function sbar.btnUp:Paint( w, h )
			draw.SimpleText( "?", "Trebuchet24", -3, -4, btn )
		end
		
		function sbar.btnDown:Paint( w, h )
			draw.SimpleText( "?", "Trebuchet24", -3, -4, btn )
		end
		
		function sbar.btnGrip:Paint( w, h )
			draw.RoundedBox( 8, 0, 0, w, h, grip )
		end
	end
		
	return Panel
	
end

local function CreateLabel( Parent, font, text, sx, sy, posx, posy, color, time)
	
	Parent = Parent or ""
	font = font or "Trebuchet24"
	text = text or ""
	sx = sx or 100
	sy = sy or 100
	posx = posx or 0
	posy = posy or 0
	color = color or Color(255,255,255,255)
	time = time or 0

	local EndTime = CurTime() + time
	local SizeString = string.len( text )
	
	local Label = vgui.Create("DLabel", Parent)
		Label:SetPos( posx, posy )
		Label:SetSize( sx,sy )
		if time == 0 then
			Label:SetText( text )
		else
			Label:SetText( "" )
		end
		Label:SetWrap( true )
		Label:SetTextColor(color)
		Label:SetFont(font)
	
		Label.Think = function()
			
			if Label:GetText() == text then
				return
			end
			
			local TimeLeft = EndTime - CurTime()
			local StringSizeP1 = ( TimeLeft / ( time / 100 ) ) / 100
			local StringSize = 1 - StringSizeP1

			Label:SetText( string.sub(text, 0, SizeString * StringSize ))
			
		end
		
	return Label
	
end


local SizeX = 400
local SizeY = 250

net.Receive("MedicMod.MedicMenu", function()
	
	local ent = net.ReadEntity()
	local fract = net.ReadTable()
	
	local FramePrincipal = vgui.Create( "DFrame" )
		FramePrincipal:SetSize( SizeX, SizeY )
		FramePrincipal:SetPos( ScrW()/2 - SizeX/2, ScrH()/2 - SizeY/2 )
		FramePrincipal:SetTitle( "Panel" )
		FramePrincipal:SetDraggable( false )
		FramePrincipal:ShowCloseButton( false )
		FramePrincipal:MakePopup()
		FramePrincipal.Paint = function(s , w , h)
		end
	
	local boxTitle = CreatePanel( FramePrincipal, SizeX, 20, 0, 0, Color(0, 140, 208, 255), false )
	
	local CloseButton = CreateCloseButton( boxTitle, FramePrincipal )
	
	local LabelTitle = CreateLabel( boxTitle, "Trebuchet24", "Medecin", SizeX-40, 20, 50, 0, nil, 0)

	local boxContent = CreatePanel( FramePrincipal, SizeX, SizeY-20, 0, 20, Color(35, 35, 35, 255), true )
	
	local fractn = table.Count(fract)
	
	if LocalPlayer():Health() < LocalPlayer():GetMaxHealth() or fractn > 0 then
		local money =  ( LocalPlayer():GetMaxHealth() - LocalPlayer():Health() ) * ConfigurationMedicMod.HealthUnitPrice
		
		if fractn > 0 then
			money = money + fractn * ConfigurationMedicMod.FractureRepairPrice
		end
		
		local Label1 = CreateLabel( boxContent, nil, sentences["Hello, you look sick. I can heal you,  it will cost"][lang].." "..money..ConfigurationMedicMod.MoneyUnit.."." , SizeX - 40, SizeY - 35 - 50 - 10, 10, 0, nil, 3)
		local Button1 = CreateButton( boxContent, sentences["Heal me"][lang], nil, nil, SizeX/2-75, SizeY - 50 - 10 - 25, 150, 50,	function() net.Start("MedicMod.MedicStart") net.WriteEntity( ent ) net.SendToServer() FramePrincipal:Close() end )
	else
		local Label1 = CreateLabel( boxContent, nil,  sentences["Hello, you seem healthy-looking today"][lang] , SizeX - 40, SizeY - 35 - 50 - 10, 10, 0, nil, 2)
		local Button1 = CreateButton( boxContent, sentences["Thanks"][lang], nil, nil, SizeX/2-75, SizeY - 50 - 10 - 25, 150, 50,	function() FramePrincipal:Close() end )
	end
		
end)

-- net.Receive("MedicMod.NotifiyPlayer", function()
	-- local msg = net.ReadString()
	-- local time = net.ReadInt( 32 )
	-- MedicNotif( msg, time )
-- end)

net.Receive("MedicMod.ScanRadio", function()

	local ent = net.ReadEntity()
	local fractures = net.ReadTable()
		
	ent.fracturesTable = fractures
		
end)

net.Receive("MedicMod.PlayerStartAnimation", function()	

	timer.Simple(0.15, function()

		for k, v in pairs(player.GetAll()) do

		if not v:GetMedicAnimation() then continue end

			if v:GetMedicAnimation() != 0 then
				StartMedicAnimation( v, v:GetMedicAnimation() )
			end
			
		end
	
	end)
	
end)

net.Receive("MedicMod.PlayerStopAnimation", function()	

	timer.Simple(0.15, function()

		for k, v in pairs(player.GetAll()) do
					
			if v:GetMedicAnimation() == 0 and IsValid( v.mdlanim ) then
				StopMedicAnimation( v )
			end
			
		end
	
	end)
	
end)

net.Receive("MedicMod.Respawn", function()
    MedicMod.seconds = net.ReadInt(32)
end)

net.Receive("MedicMod.TerminalMenu", function()
	local ent = net.ReadEntity()
	
	if not IsValid( ent ) then return end

	MedicMod.TerminalMenu( ent )
end)


-- medic menu

for i=1,30 do

	surface.CreateFont( "Bariol"..i, {
	font = "Bariol Regular", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = i,
	weight = 750,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
	} )

end


local venalib = {}

local matCloseButton = Material( "materials/medic/lib/close_button.png" )

venalib.Frame = function( sizex, sizey, posx, posy, parent )
	
	local parent = parent or nil
	local sizex = sizex or 500
	local sizey = sizey or 500
	
	local frame = vgui.Create("DFrame", parent)
	frame:SetSize( sizex, sizey )
	frame:MakePopup()
	frame:ShowCloseButton(false)
	frame:SetTitle("")
	
	if not posx or not posy then
		frame:Center()
	else
		frame:SetPos( posx, posy )
	end
	
	frame.Paint = function( pnl, w, h )
		draw.RoundedBox( 3, 0, 0, w,h, Color( 46, 46, 54))
		draw.RoundedBox( 3, 0, 0, w,40, Color( 36, 36, 44))
		draw.RoundedBox( 0, 0, 40, w,2, Color( 26, 26, 34))
		draw.SimpleText( sentences["Medic"][lang].." - Menu", "Bariol20", 10, 10, Color( 255, 255, 255, 255 ) )
	end
	
	local DermaButton = vgui.Create( "DButton", frame )
	DermaButton:SetText( "" )
	DermaButton:SetPos( sizex-30, 15/2 )
	DermaButton:SetSize( 25, 25 )
	DermaButton.DoClick = function()
		if frame then frame:Remove() end
	end
	DermaButton.Paint = function( pnl, w, h )
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( matCloseButton )
		surface.DrawTexturedRect( 0, 0, 25, 25 )
	end
	
	local dpanel = vgui.Create("DPanel", frame)
	dpanel:SetPos( 0, 42 )
	dpanel:SetSize( sizex, sizey-42 )
	dpanel.Paint = function( pnl, w, h )
	end
	
	return dpanel
	
end

venalib.Panel = function( sizex, sizey, posx, posy, parent )
	
	local parent = parent or nil
	local sizex = sizex or 500
	local sizey = sizey or 500
	
	local panel = vgui.Create("DScrollPanel", parent)
	panel:SetSize( sizex, sizey )
	
	if not posx or not posy then
		panel:SetPos(0,0)
	else
		panel:SetPos( posx, posy )
	end
	
	panel.Paint = function( pnl, w, h )
		draw.RoundedBox( 0, 0, 0, w,h, Color(36, 36, 44))
		draw.RoundedBox( 0, 0, 0, w,h-2, Color(46, 46, 54))
	end
	
	
	local sbar = panel:GetVBar()

	function sbar:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color(56, 56, 64) )
	end
	
	function sbar.btnUp:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color(36, 36, 44) )
	end
	
	function sbar.btnDown:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color(36, 36, 44) )
	end
	
	function sbar.btnGrip:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color(31, 31, 39) )
	end
	
	return panel
	
end

venalib.Label = function( text, font, sx, sy, posx, posy, color, Parent, time) 
	
	Parent = Parent or ""
	font = font or 15
	text = text or ""
	sx = sx or 100
	sy = sy or 100
	posx = posx or 0
	posy = posy or 0
	color = color or Color(255,255,255,255)
	time = time or 0

	local EndTime = CurTime() + time
	local SizeString = string.len( text )
	
	local Label = vgui.Create("DLabel", Parent)
		Label:SetPos( posx, posy )
		Label:SetSize( sx,sy )
		if time == 0 then
			Label:SetText( text )
		else
			Label:SetText( "" )
		end
		Label:SetWrap( true )
		Label:SetTextColor(color)
		Label:SetFont("Bariol"..font)
	
		Label.Think = function()
			
			if Label:GetText() == text then
				return
			end
			
			local TimeLeft = EndTime - CurTime()
			local StringSizeP1 = ( TimeLeft / ( time / 100 ) ) / 100
			local StringSize = 1 - StringSizeP1

			Label:SetText( string.sub(text, 0, SizeString * StringSize ))
			
		end
		
	return Label
	
end

venalib.Button = function( text, sizex, sizey, posx, posy, func, parent )
	
	local text = text or ""
	local sizex = sizex or 100
	local sizey = sizey or 30
	local posx = posx or 0
	local posy = posy or 0
	local parent = parent or nil
	local func = func or function() end
	
	local button = vgui.Create( "DButton", parent )
	button:SetText( "" )
	button:SetPos( posx, posy)
	button:SetSize( sizex, sizey )
	
	local colorr = 36
	local colorg = 36
	local colorb = 44
	
	function button:DoClick()
		func()
		surface.PlaySound( "UI/buttonclick.wav" )
	end
	
	button.Paint = function( pnl, w, h )
		
		local color = Color( 36, 36, 44)
		local pa = 0.1
		
		if button:IsHovered() then
			colorr = math.Clamp( colorr + pa, 36, 36+5 ) 
			colorg = math.Clamp( colorg + pa, 36, 36+5 ) 
			colorb = math.Clamp( colorb + pa, 44, 44+5 ) 
			color = Color( colorr, colorg, colorb, 255 )
		else
			colorr = math.Clamp( colorr - pa, 36, 36+5 ) 
			colorg = math.Clamp( colorg - pa, 36, 36+5 ) 
			colorb = math.Clamp( colorb - pa, 44, 44+5 ) 
			color = Color( colorr, colorg, colorb, 255 )
		end
		draw.RoundedBox( 0, 0, 0, w,h-2, color)
		draw.RoundedBox( 0, 0, h-2, w,2, Color( 26, 26, 34))
		-- draw.RoundedBox( 0, w-2, 0, 2,h, Color( 31, 31, 41))
		draw.SimpleText( text, "Bariol17", 10, sizey/2-17/2-2, Color( 255, 255, 255, 255 ) )
	end
	function button:OnCursorEntered()
		surface.PlaySound( "UI/buttonrollover.wav" )
	end
	return button
end

local sizex = 800
local sizey = 600

local function OpenTestTubesPart(MainFrame)

	local sizex = 800
	local sizey = 600
	
	local panelM = venalib.Panel( sizex-160, sizey-40, 160, 0, MainFrame )
	local nbing = 0
	for k , v in pairs( ConfigurationMedicMod.Reagents ) do

		local name = k
		local price = v.price or 10
		
		local x = (sizex-160-40-10)/2
		local y = 100
		
		local ispair = math.mod( nbing, 2 )
		
		local panelMIng = venalib.Panel( x, y, 10+(10+(x))*ispair, 10 + math.floor(nbing/2) * (y+10), panelM )
		panelMIng.Paint = function( pnl, w, h )
			draw.RoundedBox( 0, 0, 0, w,h, Color(36, 36, 44))
		end
		
		local icon = vgui.Create( "SpawnIcon", panelMIng )
		icon:SetPos( 10, 10 )
		icon:SetSize( 80, 80 )
		icon:SetModel( "models/medicmod/test_tube/testtube.mdl" )
		function icon:LayoutEntity( Entity ) return end 
		
		local text = venalib.Label( sentences["Test tube"][lang]..": "..name, 14, x-100-20, 30, 110, 10, Color(255,255,255), panelMIng) 
		text:SetWrap(false)
		local text2 = venalib.Label( price..ConfigurationMedicMod.MoneyUnit, 14, x-100-20, 70, 110, 10, Color(255,255,255), panelMIng) 
		text2:SetWrap(false)
		
		local button1 = venalib.Button( "> "..sentences["Buy"][lang], x-100-20, 40, x-(x-100-20)-10, y - 45 , function() 
			net.Start("MedicMod.BuyMedicJobEntity")
				net.WriteString( k )
				net.WriteString( "test_tube_medicmod_s" )
			net.SendToServer()
		end,panelMIng )
		
		local colorr = 36
		local colorg = 36
		local colorb = 44
		
		button1.Paint = function( pnl, w, h )
		
			local color = Color( 36, 36, 44)
			local pa = 0.1
			
			if not button1:IsHovered() then
				colorr = math.Clamp( colorr + pa, 36, 36+5 ) 
				colorg = math.Clamp( colorg + pa, 36, 36+5 ) 
				colorb = math.Clamp( colorb + pa, 44, 44+5 ) 
				color = Color( colorr, colorg, colorb, 255 )
			else
				colorr = math.Clamp( colorr - pa, 36, 36+5 ) 
				colorg = math.Clamp( colorg - pa, 36, 36+5 ) 
				colorb = math.Clamp( colorb - pa, 44, 44+5 ) 
				color = Color( colorr, colorg, colorb, 255 )
			end
			draw.RoundedBox( 0, 0, 0, w,h-2, color)
			draw.RoundedBox( 0, 0, h-2, w,2, Color( 26, 26, 34))
			-- draw.RoundedBox( 0, w-2, 0, 2,h, Color( 31, 31, 41))
			draw.SimpleText( "> "..sentences["Buy"][lang], "Bariol17", 15, 40/2-17/2-2, Color( 255, 255, 255, 255 ) )
		end
		
		nbing = nbing + 1
		
	end
	
	return panelM
end

local function OpenEntitiesPart(MainFrame)

	local sizex = 800
	local sizey = 600
	
	local panelM = venalib.Panel( sizex-160, sizey-40, 160, 0, MainFrame )
	local nbing = 0
	for k , v in pairs( ConfigurationMedicMod.MedicShopEntities ) do

		local name = v.name or "No name"
		local price = v.price or 10
		
		local x = (sizex-160-40-10)/2
		local y = 100
		
		local ispair = math.mod( nbing, 2 )
		
		local panelMIng = venalib.Panel( x, y, 10+(10+(x))*ispair, 10 + math.floor(nbing/2) * (y+10), panelM )
		panelMIng.Paint = function( pnl, w, h )
			draw.RoundedBox( 0, 0, 0, w,h, Color(36, 36, 44))
		end
		
		local icon = vgui.Create( "SpawnIcon", panelMIng )
		icon:SetPos( 10, 10 )
		icon:SetSize( 80, 80 )
		icon:SetModel( v.model or "" )
		function icon:LayoutEntity( Entity ) return end 
		
		local text = venalib.Label( sentences["Test tube"][lang]..": "..name, 14, x-100-20, 30, 110, 10, Color(255,255,255), panelMIng) 
		text:SetWrap(false)
		local text2 = venalib.Label( price..ConfigurationMedicMod.MoneyUnit, 14, x-100-20, 70, 110, 10, Color(255,255,255), panelMIng) 
		text2:SetWrap(false)
		
		local button1 = venalib.Button( "> "..sentences["Buy"][lang], x-100-20, 40, x-(x-100-20)-10, y - 45 , function() 
			net.Start("MedicMod.BuyMedicJobEntity")
				net.WriteString( "entity" )
				net.WriteString( k )
			net.SendToServer()
		end,panelMIng )
		
		local colorr = 36
		local colorg = 36
		local colorb = 44
		
		button1.Paint = function( pnl, w, h )
		
			local color = Color( 36, 36, 44)
			local pa = 0.1
			
			if not button1:IsHovered() then
				colorr = math.Clamp( colorr + pa, 36, 36+5 ) 
				colorg = math.Clamp( colorg + pa, 36, 36+5 ) 
				colorb = math.Clamp( colorb + pa, 44, 44+5 ) 
				color = Color( colorr, colorg, colorb, 255 )
			else
				colorr = math.Clamp( colorr - pa, 36, 36+5 ) 
				colorg = math.Clamp( colorg - pa, 36, 36+5 ) 
				colorb = math.Clamp( colorb - pa, 44, 44+5 ) 
				color = Color( colorr, colorg, colorb, 255 )
			end
			draw.RoundedBox( 0, 0, 0, w,h-2, color)
			draw.RoundedBox( 0, 0, h-2, w,2, Color( 26, 26, 34))
			-- draw.RoundedBox( 0, w-2, 0, 2,h, Color( 31, 31, 41))
			draw.SimpleText( "> "..sentences["Buy"][lang], "Bariol17", 15, 40/2-17/2-2, Color( 255, 255, 255, 255 ) )
		end
		
		nbing = nbing + 1
		
	end
	
	return panelM
end

local function OpenWeaponsPart(MainFrame)

	local sizex = 800
	local sizey = 600
	
	local panelM = venalib.Panel( sizex-160, sizey-40, 160, 0, MainFrame )
	local nbing = 0
	for k , v in pairs( ConfigurationMedicMod.MedicShopWeapons ) do

		local name = v.name or "No name"
		local price = v.price or 10
		
		local x = (sizex-160-40-10)/2
		local y = 100
		
		local ispair = math.mod( nbing, 2 )
		
		local panelMIng = venalib.Panel( x, y, 10+(10+(x))*ispair, 10 + math.floor(nbing/2) * (y+10), panelM )
		panelMIng.Paint = function( pnl, w, h )
			draw.RoundedBox( 0, 0, 0, w,h, Color(36, 36, 44))
		end
		
		local icon = vgui.Create( "SpawnIcon", panelMIng )
		icon:SetPos( 10, 10 )
		icon:SetSize( 80, 80 )
		icon:SetModel( v.model or "" )
		function icon:LayoutEntity( Entity ) return end 
		
		local text = venalib.Label( sentences["Test tube"][lang]..": "..name, 14, x-100-20, 30, 110, 10, Color(255,255,255), panelMIng) 
		text:SetWrap(false)
		local text2 = venalib.Label( price..ConfigurationMedicMod.MoneyUnit, 14, x-100-20, 70, 110, 10, Color(255,255,255), panelMIng) 
		text2:SetWrap(false)
		
		local button1 = venalib.Button( "> "..sentences["Buy"][lang], x-100-20, 40, x-(x-100-20)-10, y - 45 , function() 
			net.Start("MedicMod.BuyMedicJobEntity")
				net.WriteString( "weapon" )
				net.WriteString( k )
			net.SendToServer()
		end,panelMIng )
		
		local colorr = 36
		local colorg = 36
		local colorb = 44
		
		button1.Paint = function( pnl, w, h )
		
			local color = Color( 36, 36, 44)
			local pa = 0.1
			
			if not button1:IsHovered() then
				colorr = math.Clamp( colorr + pa, 36, 36+5 ) 
				colorg = math.Clamp( colorg + pa, 36, 36+5 ) 
				colorb = math.Clamp( colorb + pa, 44, 44+5 ) 
				color = Color( colorr, colorg, colorb, 255 )
			else
				colorr = math.Clamp( colorr - pa, 36, 36+5 ) 
				colorg = math.Clamp( colorg - pa, 36, 36+5 ) 
				colorb = math.Clamp( colorb - pa, 44, 44+5 ) 
				color = Color( colorr, colorg, colorb, 255 )
			end
			draw.RoundedBox( 0, 0, 0, w,h-2, color)
			draw.RoundedBox( 0, 0, h-2, w,2, Color( 26, 26, 34))
			-- draw.RoundedBox( 0, w-2, 0, 2,h, Color( 31, 31, 41))
			draw.SimpleText( "> "..sentences["Buy"][lang], "Bariol17", 15, 40/2-17/2-2, Color( 255, 255, 255, 255 ) )
		end
		
		nbing = nbing + 1
		
	end
	
	return panelM
end

local function OpenGuidePage( MainFrame )
	
	local sizex = 800
	local sizey = 600
	
	local panelM = venalib.Panel( sizex-160, sizey-40, 160, 0, MainFrame )
	
	local GuideText = sentences.GuideText[lang]
	
		
		
	local htmlc = [[<style>
	::-webkit-scrollbar {
		width: 10px;
	}

	::-webkit-scrollbar-track {
		background: #383840; 
	}
	 
	::-webkit-scrollbar-thumb {
		background: #555; 
	}

	::-webkit-scrollbar-thumb:hover {
		background: #555; 
	}
	</style>]]
	
	for _, tab in pairs( GuideText ) do
	
		local text = tab[1] or ""
		local size = tab[2] or 15
		
		-- local TextLabel = vgui.Create( "DLabel", panelM )
		-- TextLabel:SetPos( 10, pos )
		-- TextLabel:SetText( text )
		-- TextLabel:SetWrap( true )
		-- TextLabel:SetFont("Bariol"..size)
		-- TextLabel:SetWide(sizex-160-10)
		-- TextLabel:SetAutoStretchVertical( true )
		htmlc = htmlc..'<font size="'..(size/4)..'" face="Bariol Regular" color="white">'..text..'</font></br></br>'
		
		-- local sx, sy = TextLabel:GetSize()
		
		-- pos = pos + sy
		
	end
	
	local html = vgui.Create( "DHTML" , panelM )
	html:SetSize( sizex-160, sizey-40 )
	html:SetHTML( htmlc )	
	
	-- local panelM2 = venalib.Panel( 1, 1000, 160, 0, panelM )
	-- local panelM1Title = venalib.Label( "Comment cuisiner?", 20, sizex-160, 20, 20, 10 , Color(255,255,255), panelM )
	-- panelM1Title:SetWrap(false)
	
	-- local panelM1desc = venalib.Label( [[testen 
	-- effet
	-- oui]], 20, sizex-160, 20, 20, 30 , Color(255,255,255), panelM )

	
	-- local panelM2Title = venalib.Label( "Comment utiliser l'écran et le terminal?", 20, sizex-160, 20, 20, 350 , Color(255,255,255), panelM )
	-- panelM2Title:SetWrap(false)
	
	return panelM
	
end

local function OpenMedicinesPart(MainFrame)
	local rn = 0
	local panelB = venalib.Panel( sizex-160, sizey-40, 160, 0, MainFrame )
	
	for k, v in pairs( ConfigurationMedicMod.Drugs ) do
		
		local panel1 = venalib.Panel( sizex-160, 100, 0, 100*rn, panelB )
		local panelM1text = venalib.Label( k, 15, 200, 15, 10, 10, Color(255,255,255), panel1 )
		
		local icon = vgui.Create( "SpawnIcon", panel1 )
		icon:SetSize( 60, 60 )
		icon:SetPos(15, 30)
		icon:SetModel( "models/medicmod/drug/drug.mdl" )
		
		local ingnum = 0
		
		for a, b in pairs( v ) do
		
			if a == "func" or a == "price" then continue end
			local panelM1Ing1 = venalib.Label( "● "..a, 15, sizex-160-100-20-100, 15, 60+15+5, 32 + 15 * ingnum, Color(255,255,255), panel1 )
			panelM1Ing1:SetWrap( false )
			
			ingnum = ingnum + 1
			
		end
		
		local buttonR = venalib.Button( sentences["Buy"][lang].. "( "..v.price..ConfigurationMedicMod.MoneyUnit.." )", 100, 35, sizex-160-100-20, 40, function()

			net.Start("MedicMod.BuyMedicJobEntity")
				net.WriteString( k )
				net.WriteString( "drug_medicmod_s" )
			net.SendToServer()

		end,panel1 )
		
		rn = rn + 1
		
	end
	
	return panelB
end

local function OpenMainUI()
	
	local actualPart
	
	local MainFrame = venalib.Frame( sizex,sizey )
	MainFrame.Paint = function( pnl, w, h )
		draw.RoundedBox( 0, 0, 0, w,h, Color(36, 36, 44))
	end
	local button1 = venalib.Button( "> "..sentences["Test tube"][lang], 160, 40, 0, 80, function() if ispanel(actualPart) then actualPart:Remove() end actualPart = OpenTestTubesPart(MainFrame) end,MainFrame )
	local button2 = venalib.Button( "> "..sentences["Drugs"][lang], 160, 40, 0, 40, function() if ispanel(actualPart) then actualPart:Remove() end actualPart = OpenMedicinesPart(MainFrame) end,MainFrame )
	local button2 = venalib.Button( "> Guide", 160, 40, 0, 0, function() if ispanel(actualPart) then actualPart:Remove() end actualPart = OpenGuidePage(MainFrame) end,MainFrame )
	local button2 = venalib.Button( "> Entities", 160, 40, 0, 120, function() if ispanel(actualPart) then actualPart:Remove() end actualPart = OpenEntitiesPart(MainFrame) end,MainFrame )
	local button2 = venalib.Button( "> Weapons", 160, 40, 0, 160, function() if ispanel(actualPart) then actualPart:Remove() end actualPart = OpenWeaponsPart(MainFrame) end,MainFrame )
	
	actualPart = OpenTestTubesPart( MainFrame )
	
end

net.Receive("MedicMod.OpenMedicMenu", function()
	OpenMainUI()
end)
