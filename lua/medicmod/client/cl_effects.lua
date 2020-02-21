local tabPoisonEffect = {
	[ "$pp_colour_addr" ] = 0.3,
	[ "$pp_colour_addg" ] = 0.3,
	[ "$pp_colour_addb" ] = 0,
	[ "$pp_colour_brightness" ] = 0,
	[ "$pp_colour_contrast" ] = 1,
	[ "$pp_colour_colour" ] = 0.8,
	[ "$pp_colour_mulr" ] = 0,
	[ "$pp_colour_mulg" ] = 0,
	[ "$pp_colour_mulb" ] = 0
	}

local tabBleedingEffect = {
	[ "$pp_colour_addr" ] = 0.0,
	[ "$pp_colour_addg" ] = 0.0,
	[ "$pp_colour_addb" ] = 0.0,
	[ "$pp_colour_brightness" ] = 0,
	[ "$pp_colour_contrast" ] = 1,
	[ "$pp_colour_colour" ] = 1,
	[ "$pp_colour_mulr" ] = 0,
	[ "$pp_colour_mulg" ] = 0,
	[ "$pp_colour_mulb" ] = 0
	}
	
function MedicMod.BleedingEffect()

	if LocalPlayer():IsMorphine() then return end

	tabBleedingEffect[ "$pp_colour_addr" ] = math.abs(math.sin( CurTime() * 2 )) * 0.2
	
	DrawColorModify( tabBleedingEffect )
		
end


function MedicMod.PoisonEffect()

	if LocalPlayer():IsMorphine() then return end

	DrawColorModify( tabPoisonEffect )
	DrawMotionBlur( 0.1, 0.7, 0.05 )
	
end


