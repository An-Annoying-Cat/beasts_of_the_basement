local Mod = BotB

if EID then
	EID:addCollectible(Isaac.GetItemIdByName("Popped Balloon"), "{{HolyMantleSmall}} Negates the first hit taken on the floor. #Afterward, has a 85% chance to negate the next hit you take. #Chance to negate is lowered by 15% for each negated hit.#Chance cannot go below 10%.#{{Warning}} Blocking damage with this item causes fake damage, a la Dull Razor.")
end

--Todo: Literally everything lmao

--[[
	function Mod:armour()
		--print("balls")
		--sfx:Play(Isaac.GetSoundIdByName("ArmorBlock"),1,0,false,1)
		local player = Isaac.GetPlayer()
		if player:HasCollectible(Isaac.GetItemIdByName("Alpha Armor")) then
			player:GetData().alphaArmorPercentage = 100
			--print(player:GetData().alphaArmorPercentage)
		end
	end

	Mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, Mod.armour)


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