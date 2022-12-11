local Mod = BotB
local Tables = {}

--taken from epiphany

--- Adds contents of tab2 to tab1
---@param tab1 any[]
---@param tab2 any[]
function Tables:AppendTable(tab1, tab2)
	for _,v in pairs(tab2) do
		table.insert(tab1, v)
	end
end

-- Inserts all values in given tables into a new table
-- Returns that new table
function Tables:CombineTables(...)
	local tabs = {...}
	local out = {}
	for _, tab in pairs(tabs) do
		for _, val in pairs(tab) do
			table.insert(out, val)
		end
	end
	return out
end

---Adds key-value pairs from dict2 to dict1
---@generic K,V
---@param dict1 table<K,V>
---@param dict2 table<K,V>
function Tables:AddToDictionary(dict1, dict2)
	for k,v in pairs(dict2) do
		dict1[k] = v
	end
end

---@generic K,V
---@param tab table<K,V>
---@return K[]
function Tables:GetKeys(tab)
	local out = {}
	for k in pairs(tab) do
		table.insert(out, k)
	end
	return out
end

---@generic K,V
---@param tab table<K,V>
---@return V[]
function Tables:GetValues(tab)
	local out = {}
	for _,v in pairs(tab) do
		table.insert(out, v)
	end
	return out
end

-- Basically a dump() optimized for extremely large tables.
-- I'm not sure why we'd ever need to work with such large tables but i'll let it stay.
--#region print_table
--[[
Most pure lua print table functions I've seen have a problem with deep recursion and tend to cause a stack overflow when 
going too deep. This print table function that I've written does not have this problem. It should also be capable of handling 
really large tables due to the way it handles concatenation. In my personal usage of this function, it outputted 63k lines to 
file in about a second.
 
The output also keeps lua syntax and the script can easily be modified for simple persistent storage by writing the output to 
file if modified to allow only number, boolean, string and table data types to be formatted.
 
author: Alundaio (aka Revolucas)
--]]
 
function Tables:print_table(node)
	-- to make output beautiful
	local function tab(amt)
		local str = ""
		for i=1,amt do
			str = str .. "\t"
		end
		return str
	end

	local cache, stack, output = {},{},{}
	local depth = 1
	local output_str = "{\n"

	while true do
		local size = 0
		for k,v in pairs(node) do
			size = size + 1
		end

		local cur_index = 1
		for k,v in pairs(node) do
			if (cache[node] == nil) or (cur_index >= cache[node]) then
				if (string.find(output_str,"}",output_str:len())) then
					output_str = output_str .. ",\n"
				elseif not (string.find(output_str,"\n",output_str:len())) then
					output_str = output_str .. "\n"
				end

				-- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
				table.insert(output,output_str)
				output_str = ""

				local key
				if (type(k) == "number" or type(k) == "boolean") then
					key = "["..tostring(k).."]"
				else
					key = "['"..tostring(k).."']"
				end

				if (type(v) == "number" or type(v) == "boolean") then
					output_str = output_str .. tab(depth) .. key .. " = "..tostring(v)
				elseif (type(v) == "table") then
					output_str = output_str .. tab(depth) .. key .. " = {\n"
					table.insert(stack,node)
					table.insert(stack,v)
					cache[node] = cur_index+1
					break
				else
					output_str = output_str .. tab(depth) .. key .. " = '"..tostring(v).."'"
				end

				if (cur_index == size) then
					output_str = output_str .. "\n" .. tab(depth-1) .. "}"
				else
					output_str = output_str .. ","
				end
			else
				-- close the table
				if (cur_index == size) then
					output_str = output_str .. "\n" .. tab(depth-1) .. "}"
				end
			end

			cur_index = cur_index + 1
		end

		if (#stack > 0) then
			node = stack[#stack]
			stack[#stack] = nil
			depth = cache[node] == nil and depth + 1 or depth - 1
		else
			break
		end
	end

	-- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
	table.insert(output,output_str)
	output_str = table.concat(output)

	LogString(output_str)
	--[[local filewrite = io.open("TARNISHEDDEBUG", "w")
	filewrite:write(output_str)
	filewrite:close()]]--
end
--#endregion

--- Returns amount of key-value pairs in a table.
--- Can't use # because it doesn't work for dictionaries
---@param tab table
---@return integer
function Tables:TableLength(tab)
    local count = 0
    for _ in pairs(tab) do count = count + 1 end
    return count
end

--- Returns a transposed table with keys equal to given table's values and values set to true
---@param list any[]
---@return {[any]: boolean?}
function Tables:Set(list)
    local set = {}
    for _, l in ipairs(list) do set[l] = true end
    return set
end

---@param tab table
---@param val any
---@return boolean
function Tables:ContainsValue(tab, val)
	for k,v in pairs(tab) do
		if v == val then return true end
	end
	return false
end

--- Returns a randomly rearranged table while keeping the given one intact.
---@generic K,V
---@param tab table<K,V>
---@param rng? RNG
---@return table<K,V>
function Tables:ShuffleTable(tab, rng)
	if not rng then rng = Mod.GENERIC_RNG end
	local out = SaveHelper.CopyTable(tab)

	for i = #out, 2, -1 do
		local j = rng:RandomInt(i) + 1
		out[i], out[j] = out[j], out[i]
	end
	return out
end

--- Removes all elements from a table.  
--- Returns given table.
---@generic K, V
---@param tab table<K,V>
---@param isArray? boolean
---@return table<K,V>
function Tables:ClearTable(tab, isArray)
	if isArray then
		local count = #tab
		for i=1,count do
			tab[i] = nil
		end
	else
		for i in pairs(tab) do
			tab[i] = nil
		end
	end
	return tab
end

---@generic K, V
---@param tab table<K, V>
---@param depth? integer
---@param out? V[]
---@return V[]
--- Writes all values in a given tables and its subtables
--- to an array recursively infinitely or with given max depth.
function Tables:FlattenTable(tab, depth, out)
	out = out or {}
	for _, v in pairs(tab) do
		if type(v) == "table" and (not depth or depth > 0) then
			FlattenTable(v, depth and depth - 1, out)
		else
			table.insert(out, v)
		end
	end
	return out
end

---@generic V
---@param tab table<any, V>
---@param comparer? fun(a: V, b: V): boolean
---@return any, V
--- Returns a key-value pair corresponding to maximum value in a given table
function Tables:MaxInTable(tab, comparer)
	comparer = comparer or function(a, b) return a < b end

	local maxKey, maxValue = _, math.mininteger
	for k,v in pairs(tab) do
		if comparer(maxValue, v) then
			maxKey, maxValue = k, v
		end
	end
	return maxKey, maxValue
end

---@generic V
---@param tab table<any, V>
---@param comparer? fun(a: V, b: V): boolean
---@return any, V
--- Returns a key-value pair corresponding to minimum value in a given table
function Tables:MinInTable(tab, comparer)
	comparer = comparer or function(a, b) return a < b end

	local minKey, minValue = _, math.maxinteger
	for k,v in pairs(tab) do
		if comparer(v, minValue) then
			minKey, minValue = k, v
		end
	end
	return minKey, minValue
end

---@generic V
---@param pool (table<V, number> | V)[]
---@param rng? RNG
---@return V, integer
---Returns a randomly selected value from a given weighted pool alongside its index.
---Weights are defined with *weight* field and default to 1.0
function Tables:GetValueFromWeightedPool(pool, rng)
	local function GetWeight(val)
		if type(val) == "table" then
			return val.Weight or 1.0
		else
			return 1.0
		end
	end

	local totalWeight = 0
	for _, entr in ipairs(pool) do
		totalWeight = totalWeight + GetWeight(entr)
	end

	local roll = rng:RandomFloat() * totalWeight
	local index = 0
	while roll > 0 do
		index = index + 1
		roll = roll - GetWeight(pool[index])
	end

	-- If we rolled into a table, return its first value
	local result = pool[index]
	if type(result) == "table" then
		result = result[1]
	end
	
	return result, index
end

---@generic K, V
---@param tab table<K, V>
---@param keys K[]
---@return V[]
---Returns a table consisting of values in **tab** corresponding to
---values in **keys** table.
function Tables:GetValuesByKeys(tab, keys)
    local out = {}
    for _, v in pairs(keys) do
        table.insert(out, tab[v])
    end

    return out
end

---@generic K, V
---@param tab table<K,V>
---@param func fun(val: V): any
function Tables:map(tab, func)
	local out = {}

	for k, v in pairs(tab) do
		out[k] = func(v)
	end

	return out
end

---@generic K, V
---@param tab table<K,V>
---@param filterFunc fun(val: V): boolean
---@return table<K,V>
function Tables:filter(tab, filterFunc)
	local out = {}

	for k, v in pairs(tab) do
		if filterFunc(v) then
			out[k] = v
		end
	end

	return out
end

---@generic K, V
---@param tab table<K,V>
---@param func fun(val: V): any
function Tables:foreach(tab, func)
	for k, v in pairs(tab) do
		func(v)
	end
end

return Tables