local Mod = BotB
local Solomon = {}

local PLAYER_SOLOMON = Isaac.GetPlayerTypeByName("Solomon")
BotB.SOLOMON_EXTRA1 = Isaac.GetCostumeIdByPath("gfx/characters/character_solomon_extra1.anm2")
BotB.SOLOMON_EXTRA2 = Isaac.GetCostumeIdByPath("gfx/characters/character_solomon_extra2.anm2")
function Solomon:playerGetCostume(player)
    --print("weebis")
    if player:GetPlayerType() == PLAYER_SOLOMON then
        --print("whongus")
        player:AddNullCostume(BotB.SOLOMON_EXTRA1)
        player:AddNullCostume(BotB.SOLOMON_EXTRA2)
		    player:SetPocketActiveItem(BotB.Enums.Items.THE_BESTIARY, ActiveSlot.SLOT_POCKET, false)
        if FiendFolio then
          player:AddTrinket(Isaac.GetTrinketIdByName("Solemn Vow"), true)
        end
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, Solomon.playerGetCostume, 0)

local myPlayerID = Isaac.GetPlayerTypeByName("Solomon")
EID:addBirthright(myPlayerID, "Friendly monsters have a chance to deal critical hits, dealing quadruple damage. #Friendly monsters have a chance to ignore damage. #Knowledge Point cap is increased to 18. #Extra Knowledge Points spawn more often.")

function Solomon:playerUpdate(player)
	local data = player:GetData()
	local level = Game():GetLevel()
    if player:GetPlayerType() == PLAYER_SOLOMON then
      if data.friendlySolomonEnemiesToSpawn == nil then
        data.friendlySolomonEnemiesToSpawn = {}
        data.solomonKnowledgePoints = 6
        data.solomonKnowledgePointsMax = 14
      end
      if data.solomonKnowledgePoints > data.solomonKnowledgePointsMax then
        data.solomonKnowledgePoints = data.solomonKnowledgePointsMax
      end
      if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) and data.solomonKnowledgePointsMax ~= 18 then
        data.solomonKnowledgePointsMax = 18
      end
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, Solomon.playerUpdate, 0)


function Solomon:GetPlayers()
	local players = {}

	for i = 1, game:GetNumPlayers() do
		table.insert(players, game:GetPlayer(i))
	end

	return players
end

function Solomon:spawnNewFloorFrens()
  local players = Solomon:GetPlayers()
  for i=1,#players,1 do
    if players[i]:GetPlayerType() == PLAYER_SOLOMON then
      local friendlySolomonSpawnTable = players[i]:GetData().friendlySolomonEnemiesToSpawn
      if friendlySolomonSpawnTable ~= nil then
        for j=1,#friendlySolomonSpawnTable,1 do
          local friendo = Isaac.Spawn(friendlySolomonSpawnTable[j][1],friendlySolomonSpawnTable[j][2],friendlySolomonSpawnTable[j][3],player.Position,Vector.Zero,player):ToNPC()
					friendo:AddCharmed(EntityRef(players[i]),-1)
        end
      end
    end
  end
end
Mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, Solomon.spawnNewFloorFrens, 0)

function Solomon:unfuckTheUI()
  local players = Solomon:GetPlayers()
  for i=1,#players,1 do
    if players[i]:GetPlayerType() == PLAYER_SOLOMON then
      if players[i]:GetData().solomonHasBestiaryUIOpen == true then
         players[i]:GetData().solomonHasBestiaryUIOpen = false
      end
    end
  end
end
Mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, Solomon.unfuckTheUI, 0)

--[[
function Solomon:npcUpdate(npc)
  --Is there a Solomon here?
  local players = Solomon:GetPlayers()
  local isSolomonHere = false
  local level = Game():GetLevel()
  for i=1,#players,1 do
    if players[i]:GetPlayerType() == PLAYER_SOLOMON then
      isSolomonHere = true
    end
  end
  if isSolomonHere then
    if EntityRef(npc).IsFriendly == true then
      if npc:HasEntityFlags(EntityFlag.FLAG_NO_SPIKE_DAMAGE) ~= true then
        npc:AddEntityFlags(EntityFlag.FLAG_NO_SPIKE_DAMAGE)
      end
      if level:GetCurrentRoomDesc().Clear then
        if npc.HitPoints ~= npc.MaxHitPoints then
          npc.HitPoints = npc.HitPoints + 0.5
        end
      end
    end
  end
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, Solomon.npcUpdate)
]]
function Solomon:friendlyEnemyDefenseBuff(entity,amt,flags,_,_)
  --Is there a Solomon here?
  local players = Solomon:GetPlayers()
  local isSolomonHere = false
  for i=1,#players,1 do
    if players[i]:GetPlayerType() == PLAYER_SOLOMON then
      isSolomonHere = true
    end
  end
  if isSolomonHere then
    if EntityRef(entity).IsFriendly == true then
      local actualDamage = amt
      if flags & DamageFlag.DAMAGE_FIRE ~= 0 or flags & DamageFlag.DAMAGE_EXPLOSION ~= 0 or flags & DamageFlag.DAMAGE_SPIKES ~= 0 then
        actualDamage = amt*0
        return actualDamage
      else
        actualDamage = amt*0.25
        return actualDamage
      end
    end
  end
end
Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Solomon.friendlyEnemyDefenseBuff)

--Spawn knowledge points in completed rooms

function Solomon:SpawnKnowledgePoints()
   local room = Game():GetRoom()
   local game = Game()
   local level = game:GetLevel()
   local roomDescriptor = level:GetCurrentRoomDesc()
   local roomConfigRoom = roomDescriptor.Data
   local players = Solomon:GetPlayers()
   if roomConfigRoom.Type == RoomType.ROOM_BOSS or roomConfigRoom.Type == RoomType.ROOM_BOSSRUSH then
    --Spawn a large
    for i=1,#players,1 do
      if players[i]:GetPlayerType() == PLAYER_SOLOMON then
        Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_GRAB_BAG,Mod.Enums.Pickups.KP_LARGE.SUBTYPE,room:FindFreePickupSpawnPosition(room:GetCenterPos()),Vector.Zero,players[i])
      end
    end
   elseif roomConfigRoom.Type == RoomType.ROOM_DEFAULT then
    --Spawn a small
    if room:GetRoomShape() ~= RoomShape.ROOMSHAPE_1x1 and room:GetRoomShape() ~= RoomShape.ROOMSHAPE_IH and room:GetRoomShape() ~= RoomShape.ROOMSHAPE_IV then
      for i=1,#players,1 do
        if players[i]:GetPlayerType() == PLAYER_SOLOMON then
          Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_GRAB_BAG,Mod.Enums.Pickups.KP_LARGE.SUBTYPE,room:FindFreePickupSpawnPosition(room:GetCenterPos()),Vector.Zero,players[i])
        end
      end
    else
      for i=1,#players,1 do
        if players[i]:GetPlayerType() == PLAYER_SOLOMON then
          Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_GRAB_BAG,Mod.Enums.Pickups.KP_SMALL.SUBTYPE,room:FindFreePickupSpawnPosition(room:GetCenterPos()),Vector.Zero,players[i])
        end
      end
    end
    
   else
    --No spawns
   end
   

end
Mod:AddCallback(TSIL.Enums.CustomCallback.POST_ROOM_CLEAR_CHANGED, Solomon.SpawnKnowledgePoints, true)

--Knowledge Points spawn upon entering a library, secret room of any kind, or planetarium
function Solomon:SpawnVisitKnowledgePoints()
  local players = Solomon:GetPlayers()
  local room = Game():GetRoom()
  local game = Game()
   local level = game:GetLevel()
   local roomDescriptor = level:GetCurrentRoomDesc()
   local roomConfigRoom = roomDescriptor.Data
  if roomConfigRoom.Type == RoomType.ROOM_LIBRARY or roomConfigRoom.Type == RoomType.ROOM_SECRET or roomConfigRoom.Type == RoomType.ROOM_SUPERSECRET or roomConfigRoom.Type == RoomType.ROOM_ULTRASECRET or roomConfigRoom.Type == RoomType.ROOM_PLANETARIUM then
    if roomDescriptor.VisitedCount == 1 then
      for i=1,#players,1 do
        if players[i]:GetPlayerType() == PLAYER_SOLOMON then
          Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_GRAB_BAG,Mod.Enums.Pickups.KP_LARGE.SUBTYPE,room:FindFreePickupSpawnPosition(room:GetCenterPos()),Vector.Zero,players[i])
        end
      end
    end
  end
end
Mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, Solomon.SpawnVisitKnowledgePoints, 0)