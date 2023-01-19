---@diagnostic disable: duplicate-set-field
function TSIL.Utils.Tables.ForEach(toIterate, funct)
	for index, value in pairs(toIterate) do
		funct(index, value)
	end
end
