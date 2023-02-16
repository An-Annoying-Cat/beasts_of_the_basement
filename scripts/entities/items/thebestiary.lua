local Mod = BotB
local THE_BESTIARY = {}
local pickups = BotB.Enums.Pickups
local Entities = BotB.Enums.Entities
local sfx = SFXManager()
local PLAYER_SOLOMON = Isaac.GetPlayerTypeByName("Solomon")

if EID then
	EID:addCollectible(Isaac.GetItemIdByName("The Bestiary"), "Marks the enemy with the highest maximum health in the room, making it and all others of its species weak. #For Solomon only: Spawns a friendly copy of said enemy each floor after the current one.")
end

function THE_BESTIARY:GetPlayers()
	local players = {}

	for i = 1, game:GetNumPlayers() do
		table.insert(players, game:GetPlayer(i))
	end

	return players
end

function THE_BESTIARY:GetBestiaryTargets()
	local bestiaryCompatibleRoomEntities = {}
	--List of vulnerable non-boss enemies
	for i, entity in ipairs(Isaac.GetRoomEntities()) do
		--Is it vulnerable and not a boss?
		local entityRef = EntityRef(entity)
		if entity:IsVulnerableEnemy() and entity:IsBoss() == false and entityRef.IsFriendly ~= true and entity:HasEntityFlags(EntityFlag.FLAG_WEAKNESS) == false then
			table.insert(bestiaryCompatibleRoomEntities, entity)
		end
	end
	if #bestiaryCompatibleRoomEntities ~= 0 then
		local healthBaseline = 0
		local bestCandidates = {}
		for i, entity in ipairs(bestiaryCompatibleRoomEntities) do
			if entity.MaxHitPoints > healthBaseline then
				healthBaseline = entity.MaxHitPoints
			end
		end
		for i, entity in ipairs(bestiaryCompatibleRoomEntities) do
			if entity.MaxHitPoints == healthBaseline then
				table.insert(bestCandidates, entity)
			end
		end
		return bestCandidates
	else
		return nil
	end
	
end

	function THE_BESTIARY:bestiaryActiveItem(_, _, player, _, _, _)
		local room = Game():GetRoom()
		local bestiaryCandidates = THE_BESTIARY:GetBestiaryTargets()
		local data = player:GetData()
		if bestiaryCandidates == nil then
			player:AnimateSad()
			sfx:Play(SoundEffect.SOUND_THUMBS_DOWN,1,0,false,1)
		else
			player:AnimateCollectible(Isaac.GetItemIdByName("The Bestiary"))
			sfx:Play(SoundEffect.SOUND_MENU_FLIP_DARK,0.75,0,false,1.5)
			local randomCandidate = math.random(#bestiaryCandidates)
			local trueCandidate = bestiaryCandidates[randomCandidate]
			local bestiaryMarker = Isaac.Spawn(EntityType.ENTITY_EFFECT,Entities.WARNING_TARGET.VARIANT,0,bestiaryCandidates[randomCandidate].Position,Vector(0,0),player):ToEffect()
			bestiaryMarker.Timeout = 15
            bestiaryMarker:GetSprite().Scale = Vector(2,2)
			if data.bestiaryQueue ~= nil then
				if trueCandidate.SubType ~= nil then
					table.insert(data.bestiaryQueue, {trueCandidate.Type , trueCandidate.Variant, trueCandidate.SubType})
					if player:GetPlayerType() == PLAYER_SOLOMON then
						table.insert(data.friendlySolomonEnemiesToSpawn, {trueCandidate.Type , trueCandidate.Variant, trueCandidate.SubType})
						local friendo = Isaac.Spawn(trueCandidate.Type,trueCandidate.Variant,trueCandidate.SubType,player.Position,Vector.Zero,player):ToNPC()
						friendo:AddCharmed(EntityRef(player),-1)
					end
				else
					table.insert(data.bestiaryQueue, {trueCandidate.Type , trueCandidate.Variant, 0})
					if player:GetPlayerType() == PLAYER_SOLOMON then
						table.insert(data.friendlySolomonEnemiesToSpawn, {trueCandidate.Type , trueCandidate.Variant, 0})
						local friendo = Isaac.Spawn(trueCandidate.Type,trueCandidate.Variant,0,player.Position,Vector.Zero,player):ToNPC()
						friendo:AddCharmed(EntityRef(player),-1)
					end
				end
				
			end
		end
		
	end
	Mod:AddCallback(ModCallbacks.MC_USE_ITEM,THE_BESTIARY.bestiaryActiveItem,Isaac.GetItemIdByName("The Bestiary"))


	function THE_BESTIARY:playerUpdate(player)
		local data = player:GetData()
		local level = Game():GetLevel()
		if player:HasCollectible(Isaac.GetItemIdByName("The Bestiary")) then
			if data.bestiaryQueue == nil then
				data.bestiaryQueue = {}
			else
				
			end
		end
	end
	Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, THE_BESTIARY.playerUpdate, 0)

	function THE_BESTIARY:CombineBestiaryLists()
		local players = THE_BESTIARY:GetPlayers()
		local bestiaryWatchlist = {}
		local actuallyDoTheBestiaryShit = false
		--Combine contents of every player's bestiary queue should they have one
		for i=1,#players,1 do
			if players[i]:HasCollectible(Isaac.GetItemIdByName("The Bestiary")) then
					for j=1,#players[i]:GetData().bestiaryQueue,1 do
						Mod.Functions.Tables:AppendTable(bestiaryWatchlist,players[i]:GetData().bestiaryQueue)
						actuallyDoTheBestiaryShit = true
					end
			end
		end
		return bestiaryWatchlist
	end
--[[
	if npc:HasEntityFlags(EntityFlag.FLAG_WEAKNESS) == false then
						npc:AddEntityFlags(EntityFlag.FLAG_WEAKNESS)
					end
]]
	function THE_BESTIARY:npcUpdate(npc)
		local omniBestiaryList = THE_BESTIARY:CombineBestiaryLists()
		--Mod.Functions.Tables:print_table(omniBestiaryList)
		local npcIdentifier = {}
		if npc.SubType == 0 or npc.SubType == nil then
			npcIdentifier = {npc.Type,npc.Variant,0}
		else
			npcIdentifier = {npc.Type,npc.Variant,npc.SubType}
		end
		--Mod.Functions.Tables:print_table(npcIdentifier)
		--print(Mod.Functions.Tables:ContainsValue(omniBestiaryList,npcIdentifier))
		for i=1,#omniBestiaryList, 1 do
			if table.concat(omniBestiaryList[i]) == table.concat(npcIdentifier) and EntityRef(npc).IsFriendly == false then
				if npc:HasEntityFlags(EntityFlag.FLAG_WEAKNESS) == false then
					npc:AddEntityFlags(EntityFlag.FLAG_WEAKNESS)
				end
			end
		end
	end
	Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, THE_BESTIARY.npcUpdate)