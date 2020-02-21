ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Test tube"
ENT.Category = "Medic Mod"
ENT.Author = "Venatuss"
ENT.Spawnable = false

function ENT:SetupDataTables()
    self:NetworkVar("String", 0, "Product")
end

