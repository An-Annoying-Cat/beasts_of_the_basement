local Mod = BotB
local MYPAD = {}

if EID then
	EID:addCollectible(Isaac.GetItemIdByName("MyPad"), "Time-recharge active item. #When used, the next time the player presses one of the shoot keys, all movable entities in the room are shoved in the direction the player shot in. #Movable entities include NPCs, pickups, tears, enemy projectiles, and familiars that are not prevented from otherwise moving.")
end

function MYPAD:houseOfLeavesActiveItem(_, _, player, _, _, _)
	player:AnimateCollectible(Isaac.GetItemIdByName("MyPad"))
	SFXManager():Play(BotB.Enums.SFX.MYPAD_USED,1,0,false,1,0)
	local data = player:GetData()
	data.botbMyPadUses = data.botbMyPadUses + 1
end
Mod:AddCallback(ModCallbacks.MC_USE_ITEM,MYPAD.houseOfLeavesActiveItem,Isaac.GetItemIdByName("MyPad"))

	function MYPAD:playerUpdate(player)
		local data = player:GetData()
		local level = Game():GetLevel()
		if data.botbMyPadUses == nil then
			data.botbMyPadUses = 0
		end
		if data.botbMyPadUses ~= 0 then
			if Input.IsActionTriggered(ButtonAction.ACTION_SHOOTDOWN, player.ControllerIndex)then
				SFXManager():Play(SoundEffect.SOUND_FORESTBOSS_STOMPS,1,0,false,0.8,0)
				SFXManager():Play(SoundEffect.SOUND_PUNCH,1,0,false,0.8,0)
				Game():ShakeScreen(12)
				MYPAD:impartVectorOntoEverything(Vector(0,48),player)
				data.botbMyPadUses = data.botbMyPadUses - 1
			end
			if Input.IsActionTriggered(ButtonAction.ACTION_SHOOTLEFT, player.ControllerIndex) then
				SFXManager():Play(SoundEffect.SOUND_FORESTBOSS_STOMPS,1,0,false,0.8,0)
				SFXManager():Play(SoundEffect.SOUND_PUNCH,1,0,false,0.8,0)
				Game():ShakeScreen(12)
				MYPAD:impartVectorOntoEverything(Vector(-48,0),player)
				data.botbMyPadUses = data.botbMyPadUses - 1
			end
			if Input.IsActionTriggered(ButtonAction.ACTION_SHOOTUP, player.ControllerIndex) then
				SFXManager():Play(SoundEffect.SOUND_FORESTBOSS_STOMPS,1,0,false,0.8,0)
				SFXManager():Play(SoundEffect.SOUND_PUNCH,1,0,false,0.8,0)
				Game():ShakeScreen(12)
				MYPAD:impartVectorOntoEverything(Vector(0,-48),player)
				data.botbMyPadUses = data.botbMyPadUses - 1
			end
			if Input.IsActionTriggered(ButtonAction.ACTION_SHOOTRIGHT, player.ControllerIndex) then
				SFXManager():Play(SoundEffect.SOUND_FORESTBOSS_STOMPS,1,0,false,0.8,0)
				SFXManager():Play(SoundEffect.SOUND_PUNCH,1,0,false,0.8,0)
				Game():ShakeScreen(12)
				MYPAD:impartVectorOntoEverything(Vector(48,0),player)
				data.botbMyPadUses = data.botbMyPadUses - 1
			end
		end
	end
	Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, MYPAD.playerUpdate, 0)
	
--vec is a vector, should shove everything with that vector
function MYPAD:impartVectorOntoEverything(vec, player)

	local roomEntities = Isaac.GetRoomEntities() -- table
    local roomNeedsBotBLightStateTracker = false
    local roomActuallyHasBotBLightStateTracker = false
        for i = 1, #roomEntities do
            local entity = roomEntities[i]
            if entity:ToNPC() ~= nil then
				if (entity:HasEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK) or entity:HasEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)) == false and EntityRef(entity).IsFriendly == false then
					entity:AddEntityFlags(EntityFlag.FLAG_KNOCKED_BACK | EntityFlag.FLAG_APPLY_IMPACT_DAMAGE)
					entity.Velocity = entity.Velocity + vec
					entity:TakeDamage(entity.Velocity:Length()/8,DamageFlag.DAMAGE_IGNORE_ARMOR,EntityRef(player),0)
					--[[
					for i = 0, 60 do
						BotB.FF.scheduleForUpdate(function()
							if i == 0 then
								entity:AddEntityFlags(EntityFlag.FLAG_KNOCKED_BACK | EntityFlag.FLAG_APPLY_IMPACT_DAMAGE)
							end
							if i == 60 then
								entity:ClearEntityFlags(EntityFlag.FLAG_KNOCKED_BACK | EntityFlag.FLAG_APPLY_IMPACT_DAMAGE)
							end
						end, i, ModCallbacks.MC_NPC_UPDATE)
					end]]
				end
			end
			if entity:ToTear() ~= nil then
				if (entity:HasEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK) or entity:HasEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)) == false then
					entity.Velocity = entity.Velocity + vec
				end
			end
			if entity:ToProjectile() ~= nil then
				if (entity:HasEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK) or entity:HasEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)) == false then
					entity.Velocity = entity.Velocity + vec
				end
			end
			if entity:ToPickup() ~= nil then
				if (entity:HasEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK) or entity:HasEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)) == false then
					entity.Velocity = entity.Velocity + vec
				end
			end
			if entity:ToFamiliar() ~= nil then
				if (entity:HasEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK) or entity:HasEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)) == false then
					entity.Velocity = entity.Velocity + vec
				end
			end
			

        end

end