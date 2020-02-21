ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Drug"
ENT.Category = "Medic Mod"
ENT.Author = "Venatuss"
ENT.Spawnable = true

function ENT:SetupDataTables()
    self:NetworkVar("String", 0, "Drug")
end
