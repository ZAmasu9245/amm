ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Bloodbag"
ENT.Category = "Medic Mod"
ENT.Author = "Venatuss"
ENT.Spawnable = true

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "Blood")
end

