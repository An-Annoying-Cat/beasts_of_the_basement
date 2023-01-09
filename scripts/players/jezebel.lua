local Mod = BotB
local Jezebel = {}

local PLAYER_JEZEBEL = Isaac.GetPlayerTypeByName("Jezebel")
BotB.JEZ_EXTRA = Isaac.GetCostumeIdByPath("gfx/characters/character_jez_extra.anm2")
function Jezebel:playerGetCostume(player)
    --print("weebis")
    if player:GetPlayerType() == PLAYER_JEZEBEL then
        --print("whongus")
        player:AddNullCostume(BotB.JEZ_EXTRA)
		player:SetPocketActiveItem(BotB.Enums.Items.THE_HUNGER, ActiveSlot.SLOT_POCKET, false)
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, Jezebel.playerGetCostume, 0)



function Jezebel:playerUpdate(player)
	local data = player:GetData()
    if player:GetPlayerType() == PLAYER_JEZEBEL then
        if data.jezBloodTimer == nil then
			data.jezBloodTimer = 0
			data.jezBloodVariant = EffectVariant.PLAYER_CREEP_RED
			data.jezBloodColor = Color(1,0,0)
			data.jezBloodDamage = player.Damage/2
			data.jezDoBlood = false

		end

		if data.jezBloodTimer ~= 0 then
			if player.FrameCount % 4 == 0 then
				local jezCreep = Isaac.Spawn(EntityType.ENTITY_EFFECT,data.jezBloodVariant,0,player.Position,Vector(0,0),player)
				if data.jezBloodColor ~= nil then
					jezCreep.Color = data.jezBloodColor
				else
					jezCreep.Color:Reset()
				end
				jezCreep.CollisionDamage = player.Damage/2
				--[[
				if data.jezBloodVariant == EffectVariant.PLAYER_CREEP_WHITE then
					jezCreep.IsFollowing = true
				else
					jezCreep.IsFollowing = false
				end
				--]]
			end
			
		else
			if data.jezDoBlood then
				data.jezBloodTimer = data.jezBloodTimer - 1
			end
		end
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, Jezebel.playerUpdate, 0)



function Jezebel:nullHearts(pickup,player,_)
	local playerCast = player:ToPlayer()
	local data = player:GetData()
	if player.Type == EntityType.ENTITY_PLAYER and playerCast:GetPlayerType() == PLAYER_JEZEBEL then
        --print("whongus")
        Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.BLOOD_EXPLOSION,0,pickup.Position,Vector(0,0),player)
		Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.BLOOD_SPLAT,0,pickup.Position,Vector(0,0),player)
		sfx:Play(SoundEffect.SOUND_MEAT_JUMPS,1,0,false,0.75)
		sfx:Play(SoundEffect.SOUND_VAMP_DOUBLE,0.25,0,false,1.5)
		local heartType = pickup.SubType
		local AbacusFont = Font()
		AbacusFont:Load("font/pftempestasevencondensed.fnt")
		--240 is the base amount of blood time that a heart gives.

		--Full heart
		if heartType == 1 then
			--[[
			data.jezBloodVariant = EffectVariant.PLAYER_CREEP_RED
			data.jezBloodTimer = data.jezBloodTimer + 240
			data.jezBloodColor = Color(1,0,0)
			--]]
			playerCast:SetActiveCharge(playerCast:GetActiveCharge(ActiveSlot.SLOT_POCKET) + 2,ActiveSlot.SLOT_POCKET)

		end
		--Half
		if heartType == 2 then
			--[[
			data.jezBloodVariant = EffectVariant.PLAYER_CREEP_RED
			data.jezBloodTimer = data.jezBloodTimer + 120
			data.jezBloodColor = Color(1,0,0)
			--]]

			playerCast:SetActiveCharge(playerCast:GetActiveCharge(ActiveSlot.SLOT_POCKET) + 1,ActiveSlot.SLOT_POCKET)


		end
		--Soul
		if heartType == 3 then
			--[[
			data.jezBloodVariant = EffectVariant.PLAYER_CREEP_HOLYWATER_TRAIL
			data.jezBloodTimer = data.jezBloodTimer + 120
			data.jezBloodColor = nil
			--]]
			playerCast:SetActiveCharge(playerCast:GetActiveCharge(ActiveSlot.SLOT_POCKET) + 2,ActiveSlot.SLOT_POCKET)

		end
		--Eternal
		if heartType == 3 then
			--[[
			data.jezBloodVariant = EffectVariant.PLAYER_CREEP_HOLYWATER_TRAIL
			data.jezBloodTimer = data.jezBloodTimer + 120
			data.jezBloodColor = Color(1,1,1)
			--]]
			playerCast:SetActiveCharge(playerCast:GetActiveCharge(ActiveSlot.SLOT_POCKET) + 2,ActiveSlot.SLOT_POCKET)

		end
		--Double
		if heartType == 5 then
			--[[
			data.jezBloodVariant = EffectVariant.PLAYER_CREEP_RED
			data.jezBloodTimer = data.jezBloodTimer + 480
			data.jezBloodColor = Color(1,0,0)
			--]]
			playerCast:SetActiveCharge(playerCast:GetActiveCharge(ActiveSlot.SLOT_POCKET) + 4,ActiveSlot.SLOT_POCKET)

		end
		--Black
		if heartType == 6 then
			--[[
			data.jezBloodVariant = EffectVariant.PLAYER_CREEP_BLACKPOWDER
			data.jezBloodTimer = data.jezBloodTimer + 240
			data.jezBloodColor = nil
			--]]
			playerCast:SetActiveCharge(playerCast:GetActiveCharge(ActiveSlot.SLOT_POCKET) + 2,ActiveSlot.SLOT_POCKET)

		end
		--Gold

		--HSoul

		--Scared

		--Blended

		--Bone

		--Rotten

		pickup:Remove()
		return true
    end
end
Mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, Jezebel.nullHearts, PickupVariant.PICKUP_HEART)