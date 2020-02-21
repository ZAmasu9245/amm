MsgC(Color(255,0,0), "[MEDICMOD]", Color(255,255,255), "Loading files...")

MedicMod = {}
MedicMod.Version = "2.0.5"
DMG_MEDICMODBLEEDING = 4294967296
DMG_MEDICMOD = 8589934592
ConfigurationMedicMod = {}
ConfigurationMedicMod.DamagePoisoned = {}
ConfigurationMedicMod.DamageBurn = {}
ConfigurationMedicMod.Sentences = {}
ConfigurationMedicMod.DamageBleeding = {}
ConfigurationMedicMod.Vehicles = {}
ConfigurationMedicMod.Entities = {}
ConfigurationMedicMod.Reagents = {}
ConfigurationMedicMod.Drugs = {}


ConfigurationMedicMod.AddReagent = function( name, price, color )
	
	local name = name or nil
	local price = price or 150
	local color = color or Color(255,0,0)
	
	if not name then return end
	
	if not color then color = Color(255,255,255) end
	
	ConfigurationMedicMod.Reagents[name] = {
		color = color,
		price = price
	}
	
end

ConfigurationMedicMod.AddDrug = function( name, price, ing1, ing2, ing3, func )
	
	local price = price or 0
	local name = name or nil	
	if not name then return end
	
	local func = func or function() end
		
	ConfigurationMedicMod.Drugs[name] = {}
	
	ConfigurationMedicMod.Drugs[name].price = price
	
	if ing1 then
		ConfigurationMedicMod.Drugs[name][ing1] = true
	end
	if ing2 then
		ConfigurationMedicMod.Drugs[name][ing2] = true
	end
	if ing3 then
		ConfigurationMedicMod.Drugs[name][ing3] = true
	end
	
	ConfigurationMedicMod.Drugs[name].func = func

	
end


-- include shared
include("medicmod/sh_lang.lua")
include("medicmod/sh_config.lua")
include("medicmod/sh_darkrp_config.lua")
include("medicmod/shared/sh_functions.lua")
include("medicmod/shared/sh_hooks.lua")

if SERVER then
	
	resource.AddWorkshop("1112537374")
	
	-- AddCSLuaFile shared
	AddCSLuaFile("medicmod/sh_config.lua")
	AddCSLuaFile("medicmod/sh_lang.lua")
	AddCSLuaFile("medicmod/sh_darkrp_config.lua")
	AddCSLuaFile("medicmod/shared/sh_functions.lua")
	AddCSLuaFile("medicmod/shared/sh_hooks.lua")
	
	-- AddCSLuaFile client
	AddCSLuaFile("medicmod/client/cl_effects.lua")
	AddCSLuaFile("medicmod/client/cl_hooks.lua")
	AddCSLuaFile("medicmod/client/cl_font.lua")
	AddCSLuaFile("medicmod/client/cl_functions.lua")
	AddCSLuaFile("medicmod/client/cl_notify.lua")
	AddCSLuaFile("medicmod/client/cl_net.lua")
	AddCSLuaFile("medicmod/client/3d2dvgui.lua")
	
	-- include server
	include("medicmod/server/sv_functions.lua")
	include("medicmod/server/sv_hooks.lua")
	include("medicmod/server/sv_notify.lua")
	include("medicmod/server/sv_net.lua")

elseif CLIENT then

	-- include client
	include("medicmod/client/cl_effects.lua")
	include("medicmod/client/cl_hooks.lua")
	include("medicmod/client/cl_font.lua")
	include("medicmod/client/cl_functions.lua")
	include("medicmod/client/cl_notify.lua")
	include("medicmod/client/cl_net.lua")
	include("medicmod/client/3d2dvgui.lua")
	
end



