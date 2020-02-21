ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Beaker"
ENT.Category = "Medic Mod"
ENT.Author = "Venatuss"
ENT.Spawnable = true

function ENT:SetupDataTables()
    self:NetworkVar("String", 0, "Product1")
    self:NetworkVar("String", 1, "Product2")
    self:NetworkVar("String", 2, "Product3")
end

