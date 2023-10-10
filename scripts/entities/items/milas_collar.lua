local Mod = BotB
local MILAS_COLLAR = {}

if EID then
	EID:addCollectible(Isaac.GetItemIdByName("Mila's Collar"), "When hurt by an enemy, the player releases powerful chain lightning that deals 4x your base damage.")
end
--Someone was already using ARMOR so I changed the variable to something more descriptive, and it starting working as intended. Who knew?
--TODO: Add mercy invincibility after hit!!!!!!

	function MILAS_COLLAR:milasCollarHurt()
		--print("cocks")
		local player = Isaac.GetPlayer()
		local data = player:GetData()
			if player:HasCollectible(BotB.Enums.Items.MILAS_COLLAR) then
				SFXManager():Play(SoundEffect.SOUND_REDLIGHTNING_ZAP_BURST,2,0,false,0.75,0)
				for i=0,7 do
					local zappies = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.CHAIN_LIGHTNING,0,player.Position+Vector(25,0):Rotated(45*i),Vector.Zero,player):ToEffect()
					zappies.CollisionDamage = player:ToPlayer().Damage * 0.5
					zappies.Scale = 2.0 * player:GetCollectibleNum(BotB.Enums.Items.MILAS_COLLAR, false)
				end
				
			end
		end

	Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, MILAS_COLLAR.milasCollarHurt, EntityType.ENTITY_PLAYER)

	