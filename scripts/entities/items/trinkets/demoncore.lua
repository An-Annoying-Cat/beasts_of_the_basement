local Mod = BotB

if EID then
	EID:addTrinket(Mod.Enums.Trinkets.DEMON_CORE, "The next hit you take causes the {{Collectible483}}Mama Mega! effect and then consume this trinket. #{{Warning}} This hit will cause a random amount of damage anywhere between a half heart and five full heart's worth!")
end


	function Mod:demonCoreBlast(_, damageAmount, _, _, _)
		--https://cdn.discordapp.com/attachments/933137074461241364/1048692744748535838/SPOILER_FNluorjVgAMBh6c.png
		local player = Isaac.GetPlayer()
			if player:HasTrinket(Mod.Enums.Trinkets.DEMON_CORE) then
				sfx:Play(Mod.Enums.SFX.DEMON_CORE_EFFECT,1,0,false,1)
				sfx:Play(BotB.FF.Sounds.Nuke,1,0,false,math.random(8,12)/10)
				player:UseActiveItem(Isaac.GetItemIdByName("Mama Mega!"))
				damageAmount = math.random(1,10)
				print(damageAmount)
				--player:TryRemoveTrinket(Mod.Enums.Trinkets.DEMON_CORE)
				return true
			end

	end
	Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Mod.demonCoreBlast, EntityType.ENTITY_PLAYER)