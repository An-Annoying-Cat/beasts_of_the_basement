local Mod = BotB

if EID then
	EID:addTrinket(Mod.Enums.Trinkets.DEMON_CORE, "The next hit you take causes the {{Collectible483}}Mama Mega! effect and then consume this trinket. #{{Warning}} This hit will cause a random amount of damage anywhere between a half heart and five full heart's worth!")
end


	function Mod:demonCoreBlast(player, _, _, source, _)
		--https://cdn.discordapp.com/attachments/933137074461241364/1048692744748535838/SPOILER_FNluorjVgAMBh6c.png
	    local player = Isaac.GetPlayer()
			if player:HasTrinket(Mod.Enums.Trinkets.DEMON_CORE) and source ~= EntityRef(player) then
				sfx:Play(Mod.Enums.SFX.DEMON_CORE_EFFECT,1,0,false,1)
				sfx:Play(BotB.FF.Sounds.Nuke,1,0,false,math.random(8,12)/10)
				player:UseActiveItem(Isaac.GetItemIdByName("Mama Mega!"))
				local damageAmount = math.random(1,5)
				print(damageAmount)
				--Has flages for Fire and Explosive damage because, you know, nuclear fire
				player:TryRemoveTrinket(Mod.Enums.Trinkets.DEMON_CORE)
				player:TakeDamage(damageAmount, 6, EntityRef(player), 40)
				return true
			end

	end
	Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Mod.demonCoreBlast, EntityType.ENTITY_PLAYER)