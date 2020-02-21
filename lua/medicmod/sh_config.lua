----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Base Configuration
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------

ConfigurationMedicMod.AddonName = "Ethernium.net"

-- if set to false, the player would have to press E on the terminal to open the buying menu. 
ConfigurationMedicMod.Terminal3D2D = true

-- Percentage of chance that the shock of the defibrillator works ( Default : 50 )
ConfigurationMedicMod.DefibrillatorShockChance = 50 

ConfigurationMedicMod.MorphineEffectTime = 10

ConfigurationMedicMod.MoneyUnit = "€"

ConfigurationMedicMod.MedicCommand = "medic"
ConfigurationMedicMod.MaxTestTubesSpawnedWithTheShop = 4
ConfigurationMedicMod.MaxDrugsSpawnedWithTheShop = 3

ConfigurationMedicMod.ScanRadioTime = 5

ConfigurationMedicMod.HealedOnChangingJob = true

-- Only medic can use the button to take a stretcher in a vehicle?
ConfigurationMedicMod.OnlyMedicCanUseVehicleButton = true

ConfigurationMedicMod.SurgicalOperationTime = 15
ConfigurationMedicMod.HealthUnitPrice = 1
ConfigurationMedicMod.FractureRepairPrice = 50

ConfigurationMedicMod.ForceRespawn = false 

-- Time that the player will have to wait to respawn if there is no medics connected
ConfigurationMedicMod.TimeBeforeRespawnIfNoConnectedMedics = 10
-- Time that the player will have to wait to respawn if there is medics connected
ConfigurationMedicMod.TimeBeforeRespawn = 300
-- Time that the player will have to wait to respawn if someone has stabilized his state
ConfigurationMedicMod.TimeBeforeRespawnIfStable = 15

ConfigurationMedicMod.DamagePerSecsDuringBleeding = 0.5 
ConfigurationMedicMod.DamagePerSecsDuringPoisoned = 0.25

-- if the player get X damage on his leg or his arm, then he'll have a fracture
ConfigurationMedicMod.MinimumDamageToGetFractures = 40
ConfigurationMedicMod.MinimumDamageToGetBleeding = 0

ConfigurationMedicMod.CanGetFractures = true
-- if a player get a damage in his hands, I will not be able to switch weapon
ConfigurationMedicMod.CanBreakArms = true
ConfigurationMedicMod.CanGetBleeding = false
ConfigurationMedicMod.CanGetPoisoned = false

-- now set to false by defaut, because it caused some crashs.
ConfigurationMedicMod.DecalsBleeding = false

ConfigurationMedicMod.TimeToQuickAnalyse = 5

-- If the player can do CPR to another player
ConfigurationMedicMod.CanCPR = true
-- CPR Key, list of keys can be find here :  http://wiki.garrysmod.com/page/Enums/BUTTON_CODE
ConfigurationMedicMod.CPRKey = KEY_R

ConfigurationMedicMod.FracturePlayerSpeed = 100

-- if !reviveme can be used
ConfigurationMedicMod.CanUseReviveMeCommand = true

ConfigurationMedicMod.Vehicles["models/perrynsvehicles/ford_f550_ambulance/ford_f550_ambulance.mdl"] = {
	buttonPos = Vector(-40.929615,-139.366989,60.128445),
	buttonAngle = Angle(0,0,90),
	stretcherPos = Vector(0,-80,40),
	stretcherAngle = Angle(0,0,0),
	drawStretcher = false,
	backPos = Vector(0,-170,50)
}

ConfigurationMedicMod.Vehicles["models/perrynsvehicles/2015_mercedes_nhs_ambulance/2015_mercedes_nhs_ambulance.mdl"] = {
	buttonPos = Vector(40,-158,70),
	buttonAngle = Angle(90,-90,0),
	stretcherPos = Vector(13,-95,45),
	stretcherAngle = Angle(0,0,0),
	drawStretcher = false,
	backPos = Vector(0,-170,50)
}

-- list of entities that the medic can buy with his command
ConfigurationMedicMod.MedicShopEntities = {
	["firstaidkit_medicmod"] = {
		name = "First aid kit",
		price = 50,
		model = "models/medicmod/firstaidkit/firstaidkit.mdl",
		max = 1,
	},
	["beaker_medicmod"] = {
		name = "Empty beaker",
		price = 10,
		model = "models/medicmod/beaker/beaker.mdl",
		max = 1,
	},
	["bloodbag_medicmod"] = {
		name = "Blood bag",
		price = 10,
		model = "models/medicmod/bloodbag/bloodbag.mdl",
		max = 4,
	},
	["drip_medicmod"] = {
		name = "Drip",
		price = 10,
		model = "models/medicmod/medical_stand/medical_stand.mdl",
		max = 1,
	},
	["drug_medicmod"] = {
		name = "Emtpy drug jar",
		price = 10,
		model = "models/medicmod/drug/drug.mdl",
		max = 1,
	},

}-- list of weapons that the medic can buy with his command
ConfigurationMedicMod.MedicShopWeapons = {
	["syringe_antidote"] = {
		name = "Antidote syringe",
		price = 10,
		model = "models/medicmod/syringe/w_syringe.mdl",
	},
	["bandage"] = {
		name = "Bandage",
		price = 10,
		model = "models/medicmod/bandage/w_bandage.mdl",
	},
	["defibrillator"] = {
		name = "Defibrillator",
		price = 20,
		model = "models/medicmod/defib/w_defib.mdl",
	},
	["syringe_morphine"] = {
		name = "Morphine syringe",
		price = 10,
		model = "models/medicmod/syringe/w_syringe.mdl",
	},
	["syringe_poison"] = {
		name = "Poison syringe",
		price = 10,
		model = "models/medicmod/syringe/w_syringe.mdl",
	},

}

timer.Simple(0, function() -- don't touch this


ConfigurationMedicMod.MedicTeams = { 
	TEAM_MEDIC,
	TEAM_PARAMEDIC,
	}
ConfigurationMedicMod.TeamsCantGetFracture = {
	}
ConfigurationMedicMod.TeamsCantGetBleeding = {
	}
ConfigurationMedicMod.TeamsCantGetPoisoned = {

	}
ConfigurationMedicMod.TeamsCantPracticeCPR = {

	}
ConfigurationMedicMod.TeamsCantReceiveCPR = {

	}

end) -- don't touch this

local lang = ConfigurationMedicMod.Language
local sentences = ConfigurationMedicMod.Sentences
local function AddReagent( name, price, color ) ConfigurationMedicMod.AddReagent( name, price, color ) end
local function AddDrug( name, price, ing1, ing2, ing3, func ) ConfigurationMedicMod.AddDrug( name, price, ing1, ing2, ing3, func ) end

----------------------------------------------------------------------------------
----------------------------------------------------------------------------------

-- Add reagents (ingredients) for drugs
-- AddReagent( name, price, color )


AddReagent("Aminophenol", 20 ,Color(255,0,0))
AddReagent("Water", 20, Color(64, 164, 223) )
AddReagent("Ethanoic anhydride", 20,Color(255,255,0))
AddReagent("Potassium iodide", 20, Color(255,255,255))
AddReagent("Ethanol", 20,Color(255,255,255,150))
AddReagent("Sulfuric acid", 20,Color(0,255,0))
AddReagent("Calcium (left arm)", 20,Color(120,140,126))
AddReagent("Calcium (right arm)", 20,Color(120,140,126))
AddReagent("Calcium (left leg)", 20,Color(120,140,126))
AddReagent("Calcium (right leg)", 20,Color(120,140,126))

----------------------------------------------------------------------------------
----------------------------------------------------------------------------------

-- Add drugs
-- AddDrug( name, price, reagent1, reagent2, reagent3 , function(ply) end )
-- if there is no reagent 2 or 3 then replace them by nil

AddDrug("Tylenol", 20, "Aminophenol", "Water", "Ethanoic anhydride", function(ply) ply:MedicNotif(sentences["You have been healed"][lang]) ply:SetHealth(ply:GetMaxHealth()) end )
AddDrug("Antidote", 20, "Potassium iodide", nil, nil, function(ply) ply:SetPoisoned( false ) ply:MedicNotif( sentences["You have stopped your poisoning"][lang], 5 ) end)
AddDrug("Morphine", 20, "Water","Ethanol","Sulfuric acid", function(ply) ply:SetMorphine( true ) ply:MedicNotif( sentences["You injected some morphine"][lang], 5 ) end)
AddDrug("Medicine (Left arm)", 20,"Calcium (left arm)", nil, nil, function(ply) ply:SetFracture( false, HITGROUP_LEFTARM) end)
AddDrug("Drug (Right arm)", 20, "Calcium (right arm)", nil, nil, function(ply) ply:SetFracture( false, HITGROUP_RIGHTARM) end )
AddDrug("Drug (Left leg)",20,"Calcium (left leg)", nil, nil, function(ply) ply:SetFracture( false, HITGROUP_LEFTLEG) end )
AddDrug("Drug (Right leg)", 20, "Calcium (right leg)", nil, nil, function(ply) ply:SetFracture( false, HITGROUP_RIGHTLEG) end )

----------------------------------------------------------------------------------
----------------------------------------------------------------------------------

-- List of entities that can be bought with the terminal
ConfigurationMedicMod.Entities[1] = {
	name = sentences["Bandage"][lang],
	ent = "bandage",
	price = 10,
	mdl = "models/medicmod/bandage/bandage.mdl",
	func = function(ply, ent, price)
		if ply:HasWeapon( ent ) then
			ply:MedicNotif(sentences["You already carry this element on you"][lang])
			return
		end
		ply:addMoney( -price ) 
		ply:Give(ent)
	end
}
ConfigurationMedicMod.Entities[2] = {
	name = sentences["Morphine"][lang],
	ent = "syringe_morphine",
	price = 10,
	mdl = "models/medicmod/syringe/w_syringe.mdl",
	func = function(ply, ent, price)
		if ply:HasWeapon( ent ) then
			ply:MedicNotif(sentences["You already carry this element on you"][lang])
			return
		end
		ply:addMoney( -price ) 
		ply:Give(ent)
	end
}
ConfigurationMedicMod.Entities[3] = {
	name = sentences["Antidote"][lang],
	ent = "syringe_antidote",
	price = 10,
	mdl = "models/medicmod/syringe/w_syringe.mdl",
	func = function(ply, ent, price)
		if ply:HasWeapon( ent ) then
			ply:MedicNotif(sentences["You already carry this element on you"][lang])
			return
		end
		ply:addMoney( -price ) 
		ply:Give(ent)
	end
}
ConfigurationMedicMod.Entities[4] = {
	name = sentences["First Aid Kit"][lang],
	ent = "first_aid_kit",
	price = 50,
	mdl = "models/medicmod/firstaidkit/firstaidkit.mdl",
	func = function(ply, ent, price)
		if ply:HasWeapon( ent ) then
			ply:MedicNotif(sentences["You already carry a medical kit on you"][lang])
			return
		end
		ply:addMoney( -price ) 
		ply:Give(ent)
		local weap = ply:GetWeapon(ent)
		weap:SetBandage( 3 )
		weap:SetAntidote( 1 )
		weap:SetMorphine( 2 )
	end
}

----------------------------------------------------------------------------------
----------------------------------------------------------------------------------

ConfigurationMedicMod.DamagePoisoned[DMG_PARALYZE]=true
ConfigurationMedicMod.DamagePoisoned[DMG_POISON]=true
ConfigurationMedicMod.DamagePoisoned[DMG_ACID]=true
ConfigurationMedicMod.DamagePoisoned[DMG_RADIATION]=true

ConfigurationMedicMod.DamageBleeding[DMG_BULLET]=true
ConfigurationMedicMod.DamageBleeding[DMG_CRUSH]=true
ConfigurationMedicMod.DamageBleeding[DMG_SLASH]=true
ConfigurationMedicMod.DamageBleeding[DMG_VEHICLE]=true
ConfigurationMedicMod.DamageBleeding[DMG_BLAST]=true
ConfigurationMedicMod.DamageBleeding[DMG_CLUB]=true
ConfigurationMedicMod.DamageBleeding[DMG_AIRBOAT]=true
ConfigurationMedicMod.DamageBleeding[DMG_BLAST_SURFACE]=true
ConfigurationMedicMod.DamageBleeding[DMG_BUCKSHOT]=true
ConfigurationMedicMod.DamageBleeding[DMG_PHYSGUN]=true
ConfigurationMedicMod.DamageBleeding[DMG_FALL]=true
ConfigurationMedicMod.DamageBleeding[DMG_MEDICMODBLEEDING]=true

ConfigurationMedicMod.DamageBurn[DMG_BURN]=true
ConfigurationMedicMod.DamageBurn[DMG_SLOWBURN]=true

----------------------------------------------------------------------------------
----------------------------------------------------------------------------------

