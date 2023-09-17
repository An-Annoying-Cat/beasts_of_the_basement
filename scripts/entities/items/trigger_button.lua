local Mod = BotB
local mod = FiendFolio
local TRIGGER_BUTTON = {}
local pickups = BotB.Enums.Pickups
local sfx = SFXManager()
local fiftyShadesBaseDuration = 480

if EID then
	EID:addCollectible(Isaac.GetItemIdByName("Trigger Button"), "Single-use active item. #Erases every enemy in the room for the rest of the run, and removes all obstacles (including pits, metal blocks, and pillars) from the room as well.")
end


	function TRIGGER_BUTTON:triggerButtonActiveItem(_, _, player, _, _, _)
		player:AnimateCollectible(Isaac.GetItemIdByName("Trigger Button"))
		
		--erase all the grids



		local roomEntities = Isaac.GetRoomEntities() -- table
		for i = 1, #roomEntities do
			local entity = roomEntities[i]
			if entity:IsEnemy() then
				if not EntityRef(entity).IsFriendly then
					local triggerButtonEraserTear = player:FireTear(entity.Position, Vector.Zero, false, true, false, player, 0.01):ToTear()
					triggerButtonEraserTear:AddTearFlags(TearFlags.TEAR_SPECTRAL | TearFlags.TEAR_HOMING )
					if triggerButtonEraserTear.Variant ~= TearVariant.ERASER then
						triggerButtonEraserTear:ChangeVariant(TearVariant.ERASER)
					end
					triggerButtonEraserTear.Target = entity
					triggerButtonEraserTear.FallingAcceleration = -0.1
					triggerButtonEraserTear:GetData().botbIsTriggerButtonEraserTear = true
					triggerButtonEraserTear.Color = Color(1,1,1,0)
				end
			end
			--print(entity.Type, entity.Variant, entity.SubType)
		end

		local roomGrids = TSIL.GridEntities.GetGridEntities()
		for i = 1, #roomGrids do
			local grid = roomGrids[i]
			if not (grid:GetType() == GridEntityType.GRID_DOOR or grid:GetType() == GridEntityType.GRID_TRAPDOOR or grid:GetType() == GridEntityType.GRID_DECORATION or grid:GetType() == GridEntityType.GRID_STAIRS or grid:GetType() == GridEntityType.GRID_WALL or grid:GetType() == GridEntityType.GRID_STATUE) then
				--if it isnt: door, trapdoor, room wall, decoration, stairs (whatever uses that <_<), or a statue,
				--then destroy it
				grid:Destroy(true)
			end
		end

		SFXManager():Play(SoundEffect.SOUND_SCARED_WHIMPER,2,0,false,math.random(150,200)/100,0)

		player:RemoveCollectible(BotB.Enums.Items.TRIGGER_BUTTON)

	end
	Mod:AddCallback(ModCallbacks.MC_USE_ITEM,TRIGGER_BUTTON.triggerButtonActiveItem,Isaac.GetItemIdByName("Trigger Button"))


	function TRIGGER_BUTTON:triggerButtonTearUpdate(tearpreconv)
		local tear = tearpreconv:ToTear()
		if not tear:GetData().botbIsTriggerButtonEraserTear then return end
		if tear.Target == nil then
			tear:Remove()
		end
	end
	Mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE,TRIGGER_BUTTON.triggerButtonTearUpdate,TearVariant.ERASER)


