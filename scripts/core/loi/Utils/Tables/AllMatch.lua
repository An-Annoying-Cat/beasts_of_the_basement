---@diagnostic disable: duplicate-set-field
function TSIL.Utils.Tables.All(toCheck, predicate)
    for index, value in pairs(toCheck) do
		if not predicate(index, value) then
			return false
		end
	end

    return true
end
