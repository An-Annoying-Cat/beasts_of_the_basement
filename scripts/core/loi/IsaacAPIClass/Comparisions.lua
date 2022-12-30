---@diagnostic disable: duplicate-set-field
function TSIL.IsaacAPIClass.IsBitSet128(variable)
    return TSIL.IsaacAPIClass.GetIsaacAPIClassName(variable) == "BitSet128"
end


function TSIL.IsaacAPIClass.IsColor(variable)
    return TSIL.IsaacAPIClass.GetIsaacAPIClassName(variable) == "Color"
end


function TSIL.IsaacAPIClass.IsKColor(variable)
    return TSIL.IsaacAPIClass.GetIsaacAPIClassName(variable) == "KColor"
end











function TSIL.IsaacAPIClass.IsRNG(variable)
    return TSIL.IsaacAPIClass.GetIsaacAPIClassName(variable) == "RNG"
end






function TSIL.IsaacAPIClass.IsVector(variable)
    return TSIL.IsaacAPIClass.GetIsaacAPIClassName(variable) == "Vector"
end

