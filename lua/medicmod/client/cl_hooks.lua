hook.Add( "CalcView", "CalcView.MedicMod", function( ply, pos, ang, fov )
    if ( !IsValid( ply ) or !ply:Alive() or ply:GetViewEntity() != ply ) then return end
    if ply:GetMedicAnimation() == 0 then return end
   
    local view = {}
       
    view.origin = pos - ( ang:Forward()*20 )
    view.angles = ang
    view.fov = fov
    view.drawviewer = true
       
    return view
   
end)
 
hook.Add("RenderScreenspaceEffects", "RenderScreenspaceEffects.MedicMod", function()
    if LocalPlayer():IsBleeding() then
        MedicMod.BleedingEffect()
    end
    if LocalPlayer():IsPoisoned() then
        MedicMod.PoisonEffect()
    end
end)
 
local bleedingIcon = Material("materials/bleeding.png")
local poisonedIcon = Material("materials/poisoned.png")
local hattackIcon = Material("materials/heart_attack_icon.png")
local morphIcon = Material("materials/morphine_icon.png")
local breakIcon = Material("materials/break_icon.png")
local notifIcon = Material("materials/heart_attack_icon.png")
  
local deathPanel = nil
 
hook.Add("HUDPaint", "HUDPaint.MedicMod", function()
   
    if ConfigurationMedicMod.MedicTeams and table.HasValue(ConfigurationMedicMod.MedicTeams, LocalPlayer():Team()) then
        for k, v in pairs(ents.FindByClass("prop_ragdoll")) do
           
            if not v:IsDeathRagdoll() then continue end        
           
            local pos = ( v:GetPos() + Vector(0,0,10) ):ToScreen()
            local dist = v:GetPos():Distance(LocalPlayer():GetPos())
           
            surface.SetDrawColor( 255, 255, 255, 255 )
            surface.SetMaterial( notifIcon )
            surface.DrawTexturedRect( pos.x - 25, pos.y, 50, 50 )
           
            draw.SimpleTextOutlined( math.floor(math.sqrt(dist/3)).."m", "MedicModFont30", pos.x, pos.y + 50, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, 255 ) )
   
        end
    end
   
    if not LocalPlayer():Alive() and not IsValid(deathPanel) and MedicMod.seconds then
		if MedicMod.seconds < CurTime() and MedicMod.seconds != -1 then return end
		
        deathPanel = vgui.Create("DFrame")
        deathPanel:SetSize(ScrW()*0.25, ScrH()*0.125)
        deathPanel:SetTitle("")
        deathPanel:SetAlpha(0)
        deathPanel:AlphaTo(255,1.2)
        deathPanel:Center()
        deathPanel:ShowCloseButton(false)
        deathPanel.Paint = function(s,w,h)
            draw.RoundedBox(0, 0, 0, w, h, Color(102, 207, 255))
            draw.RoundedBox(0, 0, 0, w, h*0.20, Color(0, 157, 230))
            draw.SimpleText(ConfigurationMedicMod.Sentences["Death Notice"][ConfigurationMedicMod.Language].." - Medic Mod", "MedicModFont17", w/2, h*0.20/2,Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText(ConfigurationMedicMod.Sentences["You have lost consciousness."][ConfigurationMedicMod.Language],"MedicModFont17",w/2,h/2-17.5,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
            draw.SimpleText(ConfigurationMedicMod.Sentences["You must be rescued by a medic, or wait."][ConfigurationMedicMod.Language] ,"MedicModFont17",w/2,h/2,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        end
        deathPanel.Think = function(s)
            if LocalPlayer():Alive() then
                s:AlphaTo(0, 1.2, 0, function(data,pnl) pnl:Remove() end)
            end
        end
        local x,y = deathPanel:GetSize()
        local button1 = vgui.Create("DButton",deathPanel)
            button1:Dock(BOTTOM)
            button1:SetText("")
            button1:SetSize(0,y*0.25)
            button1.DoClick = function(s)
                if MedicMod.seconds and MedicMod.seconds-CurTime() > 0 then return end
                net.Start("MedicMod.Respawn")
                net.SendToServer()
            end
            button1.Paint = function(s,w,h)
                draw.RoundedBox(8, 0, 0, w, h, Color(0, 157, 230))
                if MedicMod.seconds-CurTime() > 0 then
                    draw.SimpleText(ConfigurationMedicMod.Sentences["Please wait"][ConfigurationMedicMod.Language].." "..math.Round(MedicMod.seconds-CurTime()).." "..ConfigurationMedicMod.Sentences["seconds to respawn."][ConfigurationMedicMod.Language], "MedicModFont17", w/2, h/2,Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                elseif MedicMod.seconds == -1 then
                    draw.SimpleText(ConfigurationMedicMod.Sentences["You're receiving CPR, you can't respawn."][ConfigurationMedicMod.Language], "MedicModFont17", w/2, h/2,Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                else
                    draw.SimpleText(ConfigurationMedicMod.Sentences["Click to respawn."][ConfigurationMedicMod.Language], "MedicModFont17", w/2, h/2,Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                end
            end
    end
   
    local nbStat = 1
   
    if LocalPlayer():IsBleeding() then
        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.SetMaterial( bleedingIcon )
        surface.DrawTexturedRect( ScrW() - 300, ScrH() - 150 - 50 * nbStat, 50, 50 )
       
        draw.SimpleTextOutlined( ConfigurationMedicMod.Sentences["Bleeding"][ConfigurationMedicMod.Language], "MedicModFont30", ScrW() - 240, ScrH() - 140 - 50 * nbStat, Color( 255, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, 255 ) )
        nbStat = nbStat + 1
    end
    if LocalPlayer():IsPoisoned() then
        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.SetMaterial( poisonedIcon )
        surface.DrawTexturedRect( ScrW() - 300, ScrH()  - 150 - 50 * nbStat, 50, 50 )
       
        draw.SimpleTextOutlined( ConfigurationMedicMod.Sentences["Poisoned"][ConfigurationMedicMod.Language], "MedicModFont30", ScrW() - 240, ScrH() - 140 - 50 * nbStat, Color( 153, 201, 158, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, 255 ) )
        nbStat = nbStat + 1
    end
    if LocalPlayer():GetHeartAttack() then
        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.SetMaterial( hattackIcon )
        surface.DrawTexturedRect( ScrW() - 300, ScrH()  - 150 - 50 * nbStat, 50, 50 )
       
        draw.SimpleTextOutlined( ConfigurationMedicMod.Sentences["Heart Attack"][ConfigurationMedicMod.Language], "MedicModFont30", ScrW() - 240, ScrH() - 140 - 50 * nbStat , Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, 255 ) )
        nbStat = nbStat + 1
    end
    if LocalPlayer():IsMorphine() then
        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.SetMaterial( morphIcon )
        surface.DrawTexturedRect( ScrW() - 300, ScrH()  - 150 - 50 * nbStat, 50, 50 )
       
        draw.SimpleTextOutlined( ConfigurationMedicMod.Sentences["Morphine"][ConfigurationMedicMod.Language], "MedicModFont30", ScrW() - 240, ScrH() - 140 - 50 * nbStat, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, 255 ) )
        nbStat = nbStat + 1
    end
    if LocalPlayer():IsFractured() then
        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.SetMaterial( breakIcon )
        surface.DrawTexturedRect( ScrW() - 300, ScrH()  - 150 - 50 * nbStat, 50, 50 )
       
        draw.SimpleTextOutlined( ConfigurationMedicMod.Sentences["Fracture"][ConfigurationMedicMod.Language], "MedicModFont30", ScrW() - 240, ScrH() - 140 - 50 * nbStat, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, 255 ) )
        nbStat = nbStat + 1
    end
 
end)
