local Mod = BotB

if EID then
	EID:addCollectible(Isaac.GetItemIdByName("Treeman Syndrome"), "Grants invulnerability frames after the player uses an active item or consumable. #{{Warning}} Duration of these frames is roughly four times the amount granted by getting damaged.")
end

--Todo: Literally everything lmao

--[[
	function Mod:armourblock()
		--print("cocks")
		local player = Isaac.GetPlayer()
			if player:HasCollectible(Isaac.GetItemIdByName("Alpha Armor")) then
				--print("cocks2")
				if player:GetData().alphaArmorPercentage ~= 0 then
					--print("cocks3")
					local randohurt = math.random(0,100)
					if randohurt <= player:GetData().alphaArmorPercentage then
						if player:GetData().alphaArmorPercentage >= 15 then
							player:GetData().alphaArmorPercentage = player:GetData().alphaArmorPercentage - 15
						end
						sfx:Play(Isaac.GetSoundIdByName("ArmorBlock"),1,0,false,1)
						--player.UseActiveItem(Isaac.GetItemIdByName("Dull Razor"))
						player:SetMinDamageCooldown(40)
						print("LMAO GET NEGATED IDIOT")
						print(player:GetData().alphaArmorPercentage)
						return false
					end
				end
			end
		end

	Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Mod.armourblock, EntityType.ENTITY_PLAYER)
	--]]
	function Mod:treemanSyndromeActiveItem(_, _, player, _, _, _)
		if player:HasCollectible(Isaac.GetItemIdByName("Treeman Syndrome")) then
			sfx:Play(SoundEffect.SOUND_BOIL_HATCH,0.25,0,false,(math.random(50,80)/100))
			for i=0,5,1 do
				local skinFlake = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.TOOTH_PARTICLE,0,player.Position,Vector((0.1*math.random(-40,40)),(0.1*math.random(-40,40))),player)
				skinFlake.Color = Color(0.66, 0.5625, 0.53125)
			end
			player:SetMinDamageCooldown(120)
		end
	end
	function Mod:treemanSyndromeCard(_, player, _)
		if player:HasCollectible(Isaac.GetItemIdByName("Treeman Syndrome")) then
			sfx:Play(SoundEffect.SOUND_BOIL_HATCH,0.25,0,false,(math.random(50,80)/100))
			for i=0,5,1 do
				local skinFlake = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.TOOTH_PARTICLE,0,player.Position,Vector((0.1*math.random(-40,40)),(0.1*math.random(-40,40))),player)
				skinFlake.Color = Color(0.66, 0.5625, 0.53125)
			end
			player:SetMinDamageCooldown(120)
		end
	end
	function Mod:treemanSyndromePill(_, player, _)
		if player:HasCollectible(Isaac.GetItemIdByName("Treeman Syndrome")) then
			sfx:Play(SoundEffect.SOUND_BOIL_HATCH,0.25,0,false,(math.random(50,80)/100))
			for i=0,5,1 do
				local skinFlake = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.TOOTH_PARTICLE,0,player.Position,Vector((0.1*math.random(-40,40)),(0.1*math.random(-40,40))),player)
				skinFlake.Color = Color(0.66, 0.5625, 0.53125)
			end
			player:SetMinDamageCooldown(120)
		end
	end

	Mod:AddCallback(ModCallbacks.MC_USE_ITEM,Mod.treemanSyndromeActiveItem)
	Mod:AddCallback(ModCallbacks.MC_USE_CARD, Mod.treemanSyndromeCard)
	Mod:AddCallback(ModCallbacks.MC_USE_PILL, Mod.treemanSyndromePill)