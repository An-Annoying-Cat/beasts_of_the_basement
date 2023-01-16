---@diagnostic disable: duplicate-set-field
function TSIL.Utils.Tables.FindFirst(toFind, predicate)
	for index, value in pairs(toFind) do
		if predicate(index, value) then
			return value
		end
	end

	return nil
end
