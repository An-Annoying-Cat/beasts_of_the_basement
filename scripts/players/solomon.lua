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
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, Solomon.playerGetCostume, 0)

local myPlayerID = Isaac.GetPlayerTypeByName("Solomon")
EID:addBirthright(myPlayerID, "Monsters and bosses of the same general type as ones that the Bestiary has successfully been used on (i.e. flies, spiders, hosts, etc) are also counted as successfully targeted, and the weakened status effect is applied.")

function Solomon:playerUpdate(player)
	local data = player:GetData()
	local level = Game():GetLevel()
    if player:GetPlayerType() == PLAYER_SOLOMON then
      if data.friendlySolomonEnemiesToSpawn == nil then
        data.friendlySolomonEnemiesToSpawn = {}
      end
		  --print("am solomon hello")
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
        for j=1,#friendlySolomonSpawnTable,1 do
          local friendo = Isaac.Spawn(friendlySolomonSpawnTable[j][1],friendlySolomonSpawnTable[j][2],friendlySolomonSpawnTable[j][3],player.Position,Vector.Zero,player):ToNPC()
					friendo:AddCharmed(EntityRef(players[i]),-1)
        end
    end
  end
end
Mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, Solomon.spawnNewFloorFrens, 0)

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
      if flags & DamageFlag.DAMAGE_FIRE ~= 0 or flags & DamageFlag.DAMAGE_EXPLOSION ~= 0 then
        actualDamage = amt*0.1
        return actualDamage
      else
        actualDamage = amt*0.25
        return actualDamage
      end
    end
  end
end
Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Solomon.friendlyEnemyDefenseBuff)

