local Mod = BotB
local mod = FiendFolio
local BRAIN_BEAN = {}
local pickups = BotB.Enums.Pickups
local sfx = SFXManager()

if EID then
	EID:addCollectible(Isaac.GetItemIdByName("Brain Bean"), "Makes a fart around Isaac that inflicts nearby enemies with {{StatusLunacy}} Lunacy for a few seconds. #Enemies with {{StatusLunacy}} Lunacy attempt to walk into bullets, weapons, and familiars that have contact damage.")
end

local HiddenItemManager = require("scripts.core.hidden_item_manager")
function BRAIN_BEAN:dustyD6ActiveItem(_, _, player, _, _, _)
	player:AnimateCollectible(Isaac.GetItemIdByName("Brain Bean"))
	local roomEntities = Isaac.GetRoomEntities()
	for i = 1, #roomEntities do
		local entity = roomEntities[i]
		if (entity.Position - player.Position):Length() <= 100 then
			if entity:ToNPC() ~= nil and entity:IsVulnerableEnemy() and EntityRef(entity).IsFriendly ~= true then
				if entity:GetData().botbLunacyDuration == nil then
					entity:GetData().botbLunacyDuration = 60 + (math.random(-10,10))
				else
					entity:GetData().botbLunacyDuration = entity:GetData().botbLunacyDuration + 60 + (math.random(-10,10))
				end
			end
		end
	end
	SFXManager():Play(Isaac.GetSoundIdByName("FunnyFart"),10,0,false,math.random(90,110)/100)
	local pinkFart = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.FART,0,player.Position,Vector.Zero,player):ToEffect()
                    --pinkFart.Scale = 0.5
                    pinkFart.Color = Color(2,0.5,0.5,1,8,0.5,0.5)
	Game():ButterBeanFart(player.Position, 40, player, false, false)
end
Mod:AddCallback(ModCallbacks.MC_USE_ITEM,BRAIN_BEAN.dustyD6ActiveItem,Isaac.GetItemIdByName("Brain Bean"))



