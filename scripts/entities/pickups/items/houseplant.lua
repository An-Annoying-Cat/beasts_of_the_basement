local Mod = BotB
local HOUSEPLANT = {}

if EID then
	EID:addCollectible(Isaac.GetItemIdByName("Houseplant"), "+1 max health. #When hurt, Isaac will leave a trail of red creep for 1 full second. #{{Warning}} The amount of time which creep is left per player hurt increases linearly with the amount of copies of this item that the player possesses.")
end
--Someone was already using ARMOR so I changed the variable to something more descriptive, and it starting working as intended. Who knew?
--TODO: Add mercy invincibility after hit!!!!!!

	function HOUSEPLANT:houseplantHurt()
		--print("cocks")
		local player = Isaac.GetPlayer()
		local data = player:GetData()
			if player:HasCollectible(Isaac.GetItemIdByName("Houseplant")) then
				data.houseplantTimer = data.houseplantTimer + (60 * player:GetCollectibleNum(BotB.Enums.Items.HOUSEPLANT, false))
			end
		end

	Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, HOUSEPLANT.houseplantHurt, EntityType.ENTITY_PLAYER)

	function HOUSEPLANT:playerUpdate(player)
		local data = player:GetData()
		local level = Game():GetLevel()
		if data.houseplantTimer == nil then
			data.houseplantTimer = 0
		end
		if data.houseplantTimer ~= 0 then
			if player.FrameCount % 4 == 0 then
				local houseplantCreep = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.PLAYER_CREEP_RED,0,player.Position,Vector(0,0),player)
				houseplantCreep.CollisionDamage = player.Damage/2
			end
			data.houseplantTimer = data.houseplantTimer - 1
		end
	end
	Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, HOUSEPLANT.playerUpdate, 0)
	