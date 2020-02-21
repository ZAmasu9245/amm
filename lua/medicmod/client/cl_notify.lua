-- NotificationTable_Venatuss = NotificationTable_Venatuss or {}

-- function MedicNotif( msg, time )
	
	-- local time = time or 10
	
	-- NotificationTable_Venatuss[#NotificationTable_Venatuss + 1] = {
	-- text = msg,
	-- apptime = CurTime() + 0.2,
	-- timeremove = CurTime() + 0.2 + 1 + time,
	-- type = "medic",
	-- }

-- end

-- local iconMat = Material( "materials/notify_icon.png" )
-- local iconMatR = Material( "materials/notify_rect.png" )

-- hook.Add("HUDPaint", "MedicMod.HUDNotifications", function()
		
	-- for k, v in pairs( NotificationTable_Venatuss ) do
		-- if v.type == "medic" then
			-- if v.timeremove - CurTime() < 0 then table.remove(NotificationTable_Venatuss,k) continue end
			
			-- local alpha = ( math.Clamp(CurTime() - v.apptime, 0 , 1) )
			-- local posy = ScrH() - 200 - 60 * k - 40 * ( 1 - ( math.Clamp(CurTime() - v.apptime, 0 , 1) ) )
			-- local posx = math.Clamp(v.timeremove - CurTime(),0,0.25) * 4 * 30 + (0.25 - math.Clamp(v.timeremove - CurTime(),0,0.25)) * 4 * - 340
			
			-- surface.SetFont( "MedicModFont20" )
			-- local textsize = select( 1,surface.GetTextSize( v.text ) )
					
			 -- surface.SetDrawColor( 255, 255, 255, 255 * alpha )
			---- surface.DrawRect( posx + 50, posy, 20 + textsize, 40 )
		
			-- surface.SetMaterial( iconMat )
			-- surface.DrawTexturedRect( posx - 20, posy - 18 , 75,75 )
			-- surface.SetMaterial( iconMatR )		
			-- surface.DrawTexturedRect( posx + 75 - 34, posy - 17.5 , textsize + 30, 75 )
			
			-- surface.SetTextPos( posx + 50 + 10, posy + 10 )
			-- surface.SetTextColor( 255,255,255, 255 * alpha)
			-- surface.DrawText( v.text )
		-- end
	-- end	
	
-- end)


NotificationTable_Venatuss = NotificationTable_Venatuss or {}

surface.CreateFont( "Bariol20", {
	font = "Bariol Regular", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 20,
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

function MedicNotif( msg, time )
	
	local time = time or 10
	
	NotificationTable_Venatuss[#NotificationTable_Venatuss + 1] = {
		text = msg,
		apptime = CurTime() + 0.2,
		timeremove = CurTime() + 0.2 + 1 + time,
		type = "medic",
	}

end

local iconMat = Material( "materials/heart_attack_icon.png" )

hook.Add("HUDPaint", "MedicMod.HUDNotifications", function()
		
	for k, v in pairs( NotificationTable_Venatuss ) do
		if v.type == "medic" then
			if v.timeremove - CurTime() < 0 then table.remove(NotificationTable_Venatuss,k) continue end
		
			local alpha = ( math.Clamp(CurTime() - v.apptime, 0 , 1) )
			local posy = ScrH() - 200 - 60 * k - 40 * ( 1 - ( math.Clamp(CurTime() - v.apptime, 0 , 1) ) )
			local posx = math.Clamp(v.timeremove - CurTime(),0,0.25) * 4 * 30 + (0.25 - math.Clamp(v.timeremove - CurTime(),0,0.25)) * 4 * - 340
			
			surface.SetFont( "Bariol20" )
			local x,y = surface.GetTextSize( v.text ) 
			
			draw.RoundedBox( 5, posx, posy , 60, 40, Color(0, 131, 167,255 * alpha ) )	
			
			surface.SetDrawColor( 255, 255, 255, 255 * alpha )
			surface.DrawRect( posx + 50, posy, 20 + x, 40 )
		
			surface.SetMaterial( iconMat )
			surface.DrawTexturedRect( posx + 10, posy + 5, 30, 30 )
			
			
			surface.SetTextPos( posx + 50 + 10, posy + 40/2-y/2 )
			surface.SetTextColor( 0, 0, 0, 255 * alpha)
			surface.DrawText( v.text )
		end
	end	
	
end)

net.Receive("MedicMod:NotifyPlayer", function()
	local msg = net.ReadString()
	local time = net.ReadInt( 32 )
	MedicNotif( msg, time )
end)
