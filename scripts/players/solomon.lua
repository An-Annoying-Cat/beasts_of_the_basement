local Mod = BotB
local Solomon = {}
BotB.FF = FiendFolio

local PLAYER_SOLOMON = Isaac.GetPlayerTypeByName("Solomon", false)
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
if EID then
  local myPlayerID = Isaac.GetPlayerTypeByName("Solomon")
  EID:addBirthright(myPlayerID, "Friendly monsters have a chance to deal critical hits, dealing quadruple damage. #Friendly monsters have a chance to ignore damage. #Knowledge Point cap is increased to 18. #Extra Knowledge Points spawn more often.")
end


function Solomon:playerUpdate(player)
	local data = player:GetData()
	local level = Game():GetLevel()
    if player:GetPlayerType() == PLAYER_SOLOMON then
      if data.friendlySolomonEnemiesToSpawn == nil then
        data.friendlySolomonEnemiesToSpawn = {}
        data.friendlySolomonEnemiesDeathQueue = {}
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
--Old friendly enemy revival. Time to fix

--[[
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
]]

function Solomon:spawnNewFloorFrens()
  local players = Solomon:GetPlayers()
  for i=1,#players,1 do
    if players[i]:GetPlayerType() == PLAYER_SOLOMON then
      local friendlySolomonSpawnTable = players[i]:GetData().friendlySolomonEnemiesDeathQueue
      if friendlySolomonSpawnTable ~= nil then
        for j=1,#friendlySolomonSpawnTable,1 do
          local friendo = Isaac.Spawn(friendlySolomonSpawnTable[j][1],friendlySolomonSpawnTable[j][2],friendlySolomonSpawnTable[j][3],players[i].Position,Vector.Zero,players[i]):ToNPC()
					friendo:AddCharmed(EntityRef(players[i]),-1)
          players[i]:GetData().friendlySolomonEnemiesDeathQueue[j] = nil
        end
      end
    end
  end
end

Mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, Solomon.spawnNewFloorFrens, 0)


function Solomon:friendlyEnemyDeathCheck(entity)
  --Is there a Solomon here?
  local players = Solomon:GetPlayers()
  local isSolomonHere = false
  for i=1,#players,1 do
    if players[i]:GetPlayerType() == PLAYER_SOLOMON and isSolomonHere == false then
      if EntityRef(entity).IsFriendly == true then
        if entity:GetData().wasDirectlyBestiaried == true then
        local isBlacklisted = false
        local friendlyEnemyDeathBlacklist = {
          {150,0,0}, --tar bubble
          {150,0,1}, --spider egg
          {150,450,0}, --blasted mine
          {150,454,0}, --molar orbital (just in case...?)
          {85,962,0}, --baby spider
          {170,40,0}, --blot
        }
        --enemy blacklist check
        for j=1,#friendlyEnemyDeathBlacklist,1 do
          if friendlyEnemyDeathBlacklist[j][1] == entity.Type and friendlyEnemyDeathBlacklist[j][2] == entity.Variant and friendlyEnemyDeathBlacklist[j][3] == entity.SubType and isBlacklisted == false then
            isBlacklisted = true
          end
        end
        if isBlacklisted == false then
          table.insert(players[i]:GetData().friendlySolomonEnemiesDeathQueue, {entity.Type , entity.Variant, entity.SubType})
          print("friendly enemy died (for real this time)")
        end
        else
          print("something spawned by friendly enemy died") 
        end
      end
      isSolomonHere = true
    end
  end
end
Mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, Solomon.friendlyEnemyDeathCheck)



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
  if not isSolomonHere then return end
  if isSolomonHere then
    if entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) == true then
      print("frand")
      local actualDamage = amt
      if entity:GetData().solomonFriendlyIFrames ~= 0 then
        sfx:Play(SoundEffect.SOUND_BEEP,1,0,false,math.random(125,150)/100,0)
        return false
      elseif flags & DamageFlag.DAMAGE_FIRE ~= 0 or flags & DamageFlag.DAMAGE_EXPLOSION ~= 0 or flags & DamageFlag.DAMAGE_SPIKES ~= 0 then
        return false
      else
        actualDamage = amt*0.25
        entity:GetData().solomonFriendlyIFrames = 60
        return actualDamage
      end
    end
  end
end
Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Solomon.friendlyEnemyDefenseBuff)

function Solomon:friendlyEnemyBirthrightStuff(entity,amt,_,source,_)
  --Is there a Solomon with Birthright here?
  local players = Solomon:GetPlayers()
  local isSolomonHere = false
  for i=1,#players,1 do
    if players[i]:GetPlayerType() == PLAYER_SOLOMON and players[i]:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
      isSolomonHere = true
    end
  end
  if not isSolomonHere then return end
  if isSolomonHere then
    --Damage block
    if EntityRef(entity).IsFriendly == true then
      local chance2 = math.random(0, 100)
      if chance2 >= 75 then
        sfx:Play(SoundEffect.SOUND_POT_BREAK,1,0,false,math.random(50,80)/100,0)

        local str = "Blocked!"
        local AbacusFont = Font()
        AbacusFont:Load("font/pftempestasevencondensed.fnt")
        for i = 1, 60 do
            BotB.FF.scheduleForUpdate(function()
                local pos = game:GetRoom():WorldToScreenPosition(entity.Position) + Vector(AbacusFont:GetStringWidth(str) * -0.5, -(entity.SpriteScale.Y * 35) - i/2)
                local opacity
                if i >= 30 then
                    opacity = 1 - ((i-30)/30)
                else
                    opacity = i/15
                end
                AbacusFont:DrawString(str .. "!", pos.X, pos.Y, KColor(1,1,1,opacity), 0, false)
            end, i, ModCallbacks.MC_POST_RENDER)
        end

        return false
      end
    end
    --Did the damage come from a friendly enemy?
    if source.IsFriendly == true and entity.Type ~= EntityType.ENTITY_PLAYER and EntityRef(entity).IsFriendly ~= true then
      local actualDamage = amt
      local chance = math.random(0, 100)
      if chance >= 75 then
        sfx:Play(SoundEffect.SOUND_PUNCH,1,0,false,math.random(125,150)/100,0)
        sfx:Play(SoundEffect.SOUND_BABY_BRIM,0.5,0,false,math.random(60,80)/100,0)

        local str = "Crit!"
        local AbacusFont = Font()
        AbacusFont:Load("font/pftempestasevencondensed.fnt")
        for i = 1, 60 do
            BotB.FF.scheduleForUpdate(function()
                local pos = game:GetRoom():WorldToScreenPosition(source.Position) + Vector(AbacusFont:GetStringWidth(str) * -0.5, -(35) - i/2)
                local opacity
                if i >= 30 then
                    opacity = 1 - ((i-30)/30)
                else
                    opacity = i/15
                end
                AbacusFont:DrawString(str .. "!", pos.X, pos.Y, KColor(1,1,1,opacity), 0, false)
            end, i, ModCallbacks.MC_POST_RENDER)
        end

        actualDamage = amt*4
      end
      return actualDamage
    end
  end
end
Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Solomon.friendlyEnemyBirthrightStuff)

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



--Friendly enemy iframes

function Solomon:friendlyIFrames(npc)

  local sprite = npc:GetSprite()
  local player = npc:GetPlayerTarget()
  local data = npc:GetData()
  local target = npc:GetPlayerTarget()
local targetpos = target.Position
local targetangle = (targetpos - npc.Position):GetAngleDegrees()
local targetdistance = (targetpos - npc.Position):Length()
local players = Solomon:GetPlayers()
local isSolomonHere = false
for i=1,#players,1 do
  if players[i]:GetPlayerType() == PLAYER_SOLOMON then
    isSolomonHere = true
  end
end

if isSolomonHere then
  if EntityRef(npc).IsFriendly == true then 
    --print("frand")
    if data.solomonFriendlyIFrames == nil then
      data.solomonFriendlyIFrames = 0
    end
      if data.solomonFriendlyIFrames ~= 0 then
        data.solomonFriendlyIFrames = data.solomonFriendlyIFrames - 1
        --print(data.solomonFriendlyIFrames)
      end
    end
end
end

Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, Solomon.friendlyIFrames)