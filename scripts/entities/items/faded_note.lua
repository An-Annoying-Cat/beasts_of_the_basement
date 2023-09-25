local Mod = BotB
local FADED_NOTE = {}

if EID then
	EID:addCollectible(Isaac.GetItemIdByName("Faded Note"), "If you would die from taking damage, cancel the damage, use {{Collectible".. CollectibleType.COLLECTIBLE_DEATH_CERTIFICATE .."}} Death Certificate, and consume this item.")
end
	--[[
	function FADED_NOTE:fadedNoteHurt(player,amt)
		--print("cocks")
		--local player = Isaac.GetPlayer()
			if player:HasCollectible(Isaac.GetItemIdByName("Faded Note")) then
				
			end
		end

	Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, FADED_NOTE.fadedNoteHurt, EntityType.ENTITY_PLAYER)
		]]




	----------------------------------------------------------------------------------------------------
---- REVIVAL DETECTION / HANDLING ------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

-- MC_POST_PLAYER_UPDATE runs the entire time the player is "dying".
-- MC_POST_PEFFECT_UPDATE doesn't, but if the player revives, it will only run ONCE while the death animation is still playing, at the end before revival.
-- Detecting death/revival via the death animation still playing on that single PEFFECT frame could potentially be inconsistent.
-- So the method implemented here is described as follows:
--
-- On MC_POST_PEFFECT_UPDATE, if the player has our item and won't currently revive, we add the "Soul of Lazarus" effect, and keep track of the fact WE added it.
-- The "Soul of Lazarus" effect persists on quit and continue, so keeping track of the fact WE added it should be done in persistent player savedata.
-- We'll also remove our "Soul of Lazarus" effect if the player loses the item without dying, or if they get more than one "Soul of Lazarus" stack.
-- 
-- On MC_POST_PLAYER_UPDATE, we detect if the player is playing their death animation, will revive, AND that WE previously added the "Soul of Lazarus" effect.
-- If so, we're fairly confident that we're responsible for the revival, so we populate a GetData boolean (this doesn't need to be savedata).
--
-- On the next MC_POST_PEFFECT_UPDATE (which will only trigger post-revive) we'll see that we set that boolean, and trigger any post-revival effects (like removing our item).
--
-- The "Soul of Lazarus" null effect seems to take priority over other forms of revival.
--
-- This logic was originally based on "Crystal Skull" from Tainted Treasures, so thanks JD for that and for helping figure out how to solve compatability issues with this method.

-- On MC_POST_PLAYER_UPDATE, detect that the player is dying and will revive.
-- (See top of this section for more detail.)
function FADED_NOTE:fadedNotePlayerUpdate(player)
	local data = player:GetData()
	local savedata = data.ffsavedata
	
	local isPlayingDeathAnimation = player:GetSprite():GetAnimation():sub(-#"Death") == "Death"  -- Does their current animation end with "Death"?
	local framesSinceLastPeffectUpdate = game:GetFrameCount() - (data.LastPeffectUpdate or 0)  -- PEFFECT doesn't run while dying.
	
	if isPlayingDeathAnimation and framesSinceLastPeffectUpdate > 0 and player:WillPlayerRevive()
			and savedata.fadedNoteAddedLazEffect and not data.IsaacDotChrRevive
			and player:GetEffects():HasNullEffect(NullItemID.ID_LAZARUS_SOUL_REVIVE) then
		-- Pretty sure the player is reviving using OUR Soul of Lazarus effect.
		-- Trigger the revival effects on the next PEFFECT update.
		data.fadedNoteRevive = true
	end
end
Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, FADED_NOTE.fadedNotePlayerUpdate)

local sfx = SFXManager()
function FADED_NOTE:triggerFadedNoteRevive(player)
	sfx:Play(SoundEffect.SOUND_DEATH_CARD,1,0,false,0.5,0)
	--sfx:Play(SoundEffect.SOUND_ISAACDIES)
	--[[
	FiendFolio.scheduleForUpdate(function()
		sfx:Play(SoundEffect.SOUND_ISAACDIES)
	end, 10)]]

	-- Death certificate
	player:UseActiveItem(CollectibleType.COLLECTIBLE_DEATH_CERTIFICATE, UseFlag.USE_NOANIM)

end
-- On MC_POST_PEFFECT_UPDATE, handle adding/removing the Soul of Lazarus effect and any post-revival effects (after detecting death+revival above).
-- (See top of this section for more detail.)
function FADED_NOTE:fadedNotePeffectUpdate(player)
	local peffects = player:GetEffects()
	local data = player:GetData()
	local savedata = data.ffsavedata
	local playerHoldingSoulOfLazarus = player:GetCard(0) == Card.CARD_SOUL_LAZARUS or player:GetCard(1) == Card.CARD_SOUL_LAZARUS
	
	-- PEFFECT doesn't run while dying, so we can refer to this to more accurately detect death.
	data.LastPeffectUpdate = game:GetFrameCount()
	
	if not player:HasCollectible(BotB.Enums.Items.FADED_NOTE) then
		if savedata.fadedNoteAddedLazEffect then
			-- The player HAD this item and we added the Soul of Lazarus effect.
			-- But they lost the item without reviving using it, so remove a stack.
			peffects:RemoveNullEffect(NullItemID.ID_LAZARUS_SOUL_REVIVE)
			savedata.fadedNoteAddedLazEffect = nil
		end
		return
	end
	
	if data.fadedNoteRevive then
		-- We detected the player dying in MC_POST_PLAYER_UPDATE, and we assumed it was our revive because WE added a Soul of Lazarus effect.
		-- Remove our revive item and its associated booleans.
		data.fadedNoteRevive = nil
		savedata.fadedNoteAddedLazEffect = nil
		player:RemoveCollectible(BotB.Enums.Items.FADED_NOTE)
		
		-- Trigger the actual revival effects.
		FADED_NOTE:triggerFadedNoteRevive(player)
		
		-- Playing a different animation isn't necessary, but will stop other code from detecting the player's finished death animation this frame.
		player:AnimateAppear()
		player:GetSprite():Play("Glitch", true)
	elseif not playerHoldingSoulOfLazarus and not peffects:HasNullEffect(NullItemID.ID_LAZARUS_SOUL_REVIVE) then
		-- If the player doesn't already have a stack of the Lazarus effect, add it and keep track of the fact we did so in player savedata.
		peffects:AddNullEffect(NullItemID.ID_LAZARUS_SOUL_REVIVE)
		savedata.fadedNoteAddedLazEffect = true
	elseif savedata.fadedNoteAddedLazEffect and (peffects:GetNullEffectNum(NullItemID.ID_LAZARUS_SOUL_REVIVE) > 1 or playerHoldingSoulOfLazarus) then
		-- We previously added a "Soul of Lazarus" stack, but now there's more than one (or they have the actual Soul Stone).
		-- To be safe, remove ours. The player can revive using the other one.
		peffects:RemoveNullEffect(NullItemID.ID_LAZARUS_SOUL_REVIVE)
		savedata.fadedNoteAddedLazEffect = nil
	end
end
Mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, FADED_NOTE.fadedNotePeffectUpdate)


