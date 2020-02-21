local meta = FindMetaTable( "Player" )

function meta:IsBleeding()
	return self:GetNWBool("Bleeding") or false
end

function meta:GetHeartAttack()
	return self:GetNWBool("HeartAttack") or false
end

function meta:IsPoisoned()
	return self:GetNWBool("Poisoned") or false
end

function meta:GetMedicAnimation()
	return self:GetNWInt("MedicActivity") or 0
end

function meta:IsMorphine()
	return self:GetNWBool("Morphine") or false
end

function meta:IsFractured()
	return self:GetNWBool("Fracture") or false
end

function meta:Stable()
	if self:IsPoisoned() or self:GetHeartAttack() or self:IsBleeding() then
		return false
	else
		return true
	end
end


local ent = FindMetaTable( "Entity" )

function ent:IsDeathRagdoll()
	return self:GetNWBool("IsDeathRagdoll") or false
end


