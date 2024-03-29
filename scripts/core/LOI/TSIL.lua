local LOCAL_TSIL = {}
local LOCAL_TSIL_VERSION = 0.1

--- Initializes the TSIL library
---@param FolderName string
function LOCAL_TSIL.Init(FolderName)
	if not TSIL then
		--If TSIL hasnt been initialized yet, initialize it
		TSIL = {}
		TSIL.__PROXY = {}
		TSIL.__FUNCTION_VERSIONS = {}
	else
		--There's another version of TSIL version, overwrite it
		for _, InternalCallback in pairs(TSIL.__INTERNAL_CALLBACKS) do
			TSIL.__MOD:RemoveCallback(
				InternalCallback.Callback,
				InternalCallback.Funct
			)
		end
	end

	--METATABLE
	local TSIL_META = {}

	function TSIL_META.__index(module, key)
		local proxy = rawget(module, "__PROXY")

		if proxy[key] == nil then
			local newModule = {}
			newModule.__PROXY = {}
			newModule.__FUNCTION_VERSIONS = {}
			setmetatable(newModule, TSIL_META)
			proxy[key] = newModule
		end

		return proxy[key]
	end

	function TSIL_META.__newindex(module, key, value)
		local proxy = rawget(module, "__PROXY")
		local functionVersions = rawget(module, "__FUNCTION_VERSIONS")

		if functionVersions[key] and LOCAL_TSIL_VERSION <= functionVersions[key] then
			--Trying to update from same/older version
			return
		end

		functionVersions[key] = LOCAL_TSIL_VERSION
		proxy[key] = value
	end

	setmetatable(TSIL, TSIL_META)

	--VARIABLES INITIALIZATION
	rawget(TSIL, "__PROXY").__MOD = RegisterMod("TSILMOD_" .. FolderName, 1)
	--Is always the highest version loaded
	TSIL.__VERSION = LOCAL_TSIL_VERSION
	--Is the last version loaded
	TSIL.__LOCAL_VERSION = LOCAL_TSIL_VERSION
	rawget(TSIL, "__PROXY").__LOCAL_VERSION = LOCAL_TSIL_VERSION
	--Is the last folder loaded
	TSIL.__LOCAL_FOLDER = FolderName
	rawget(TSIL, "__PROXY").__LOCAL_FOLDER = FolderName

	--- @class InternalTSILCallback
	--- @field Id string
	--- @field Version number
	--- @field Callback ModCallbacks | CustomCallback
	--- @field Funct function
	--- @field Priority integer | CallbackPriority
	--- @field OptionalParam integer | integer[]?
	if not rawget(TSIL, "__PROXY").__INTERNAL_CALLBACKS then
		--- @type InternalTSILCallback[]
		TSIL.__INTERNAL_CALLBACKS = {}
	end

	if not rawget(TSIL, "__PROXY").__VERSION_PERSISTENT_DATA then
		TSIL.__VERSION_PERSISTENT_DATA = {}

		---@class RegisteredCustomCallback
		---@field Version number
		---@field Trigger function

		---@type table<CustomCallback, RegisteredCustomCallback>
		TSIL.__VERSION_PERSISTENT_DATA.RegisteredCustomCallbacks = {}

		--- @class PersistentVariable
		--- @field name string
		--- @field value any
		--- @field default any
		--- @field persistenceMode VariablePersistenceMode
		--- @field ignoreGlowingHourglass boolean
		--- @field conditionalSave? fun(): boolean

		--- @class ModPersistentData
		--- @field mod string
		--- @field variables PersistentVariable[]

		--- @type ModPersistentData[]
		TSIL.__VERSION_PERSISTENT_DATA.PersistentData = {}

		--- @type table<string, table<string, any>>
		TSIL.__VERSION_PERSISTENT_DATA.GlowingHourglassPersistentDataBackup = {}
	end

	--LOAD SCRIPTS
	local scripts = require(TSIL.__LOCAL_FOLDER .. ".scripts")

	for _, script in ipairs(scripts) do
		local hasError, error = pcall(function ()
			require(TSIL.__LOCAL_FOLDER .. "." ..  script)
		end)

		--TODO: Handle not found files better (it is expected)
		if not hasError then
			print("Error loading script (" .. TSIL.__LOCAL_FOLDER .. "." .. script .. ") : " .. error)
		end
	end

	--INTERNAL CALLBACKS
	for _, internalCallback in pairs(TSIL.__INTERNAL_CALLBACKS) do
		TSIL.__MOD:AddPriorityCallback(
			internalCallback.Callback,
			internalCallback.Priority - 10000,
			internalCallback.Funct,
			internalCallback.OptionalParam
		)
	end

	--TSIL LOAD CALLBACK
	TSIL.__RegisterCustomCallback(TSIL.Enums.CustomCallback.POST_TSIL_LOAD)
	TSIL.__TriggerCustomCallback(TSIL.Enums.CustomCallback.POST_TSIL_LOAD)

	print("TSIL (" .. TSIL.__LOCAL_VERSION .. ") has been properly initialized.")
end

return LOCAL_TSIL