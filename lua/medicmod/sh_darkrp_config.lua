----------------------------------------------------------------------------------
----------------------------------------------------------------------------------

local lang = ConfigurationMedicMod.Language
local sentences = ConfigurationMedicMod.Sentences

-- add entities to the medic job
timer.Simple(0, function()	

	DarkRP.createEntity("Beaker", {
		ent = "beaker_medicmod",
		model = "models/medicmod/beaker/beaker.mdl",
		price = 30,
		max = 2,
		cmd = "buybeaker",
		allowed = ConfigurationMedicMod.MedicTeams,
	})
	
	DarkRP.createEntity("Drug pot", {
		ent = "drug_medicmod",
		model = "models/medicmod/drug/drug.mdl",
		price = 10,
		max = 2,
		cmd = "buydrugpot",
		allowed = ConfigurationMedicMod.MedicTeams,
	})
	
	DarkRP.createEntity("Blood bag", {
		ent = "bloodbag_medicmod",
		model = "models/medicmod/bloodbag/bloodbag.mdl",
		price = 10,
		max = 2,
		cmd = "buybloodbag",
		allowed = ConfigurationMedicMod.MedicTeams,
	})	
	
	DarkRP.createEntity("Drip", {
		ent = "drip_medicmod",
		model = "models/medicmod/medical_stand/medical_stand.mdl",
		price = 100,
		max = 2,
		cmd = "buydrip",
		allowed = ConfigurationMedicMod.MedicTeams,
	})
	
end)

