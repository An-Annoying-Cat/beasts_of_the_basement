local Mod = BotB
local POPE = {}
local Entities = BotB.Enums.Entities

local function getNonDivineEnemies()
    local roomEntities = Isaac.GetRoomEntities() -- table
    local vulnerableEnemies = {}
    for i = 1, #roomEntities do
        local entity = roomEntities[i]
        if entity:IsVulnerableEnemy() and EntityRef(entity).IsFriendly == false and entity:GetData().botbHasDivine ~= true then
            vulnerableEnemies[#vulnerableEnemies+1] = entity
        end
    end
    
  
	return vulnerableEnemies
end


function POPE:NPCUpdate(npc)
    if npc.Type == BotB.Enums.Entities.POPE.TYPE and npc.Variant == BotB.Enums.Entities.POPE.VARIANT then 
        local sprite = npc:GetSprite()
        local player = npc:GetPlayerTarget()
        local data = npc:GetData()
        local target = npc:GetPlayerTarget()
        local targetpos = target.Position
        local targetangle = (targetpos - npc.Position):GetAngleDegrees()
        local targetdistance = (targetpos - npc.Position):Length()
        if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_GROUND then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        end
        
        if npc.State == 0 then
            if sprite:IsPlaying("Appear") ~= true then
                sprite:Play("Appear")
                npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
                
                
            end
            if sprite:IsFinished("Appear") then
                data.botbHasDivine = true
                data.botbPopeSpawnpoints = {}
                data.botbPopeSpawnPositions = {}
                data.botbPopeSpawnedMonsterList = {}
                data.botbPopeSpawnableMonsters = {}
                --the monsters a Pope can spawn are all taken from the grid spaces adjacent to it
                local roomEntities = Isaac.GetRoomEntities() -- table
                for i = 1, #roomEntities do
                    local entity = roomEntities[i]
                    local measureFromPos = npc.Position
                    local measureToPos = entity.Position
                    if (entity.Type == Entities.POPE.TYPE and entity.Variant == Entities.POPE.VARIANT) ~= true and entity:IsVulnerableEnemy() and measureToPos.X >= measureFromPos.X - 60 and measureToPos.X <= measureFromPos.X + 60 then     
                        if measureToPos.Y >= measureFromPos.Y - 60 and measureToPos.Y <= measureFromPos.Y + 60 then
                            data.botbPopeSpawnableMonsters[#data.botbPopeSpawnableMonsters+1] = {Type = entity.Type, Var = entity.Variant, Sub = entity.SubType}
                            entity:Remove()
                        end
                    end
                end 
                --failsafe
                if #data.botbPopeSpawnableMonsters == 0 then
                    data.botbPopeSpawnableMonsters[#data.botbPopeSpawnableMonsters+1] = {Type = 10, Var = 0, Sub = 0}
                end
                local roomEntities = Isaac.GetRoomEntities() -- table
                for i = 1, #roomEntities do
                    local entity = roomEntities[i]
                    --)
                    if entity.Type == EntityType.ENTITY_GENERIC_PROP and entity.Variant == BotB.Enums.Props.POPE_SPAWNPOINT.VARIANT then     
                        data.botbPopeSpawnpoints[#data.botbPopeSpawnpoints+1] = entity
                        data.botbPopeSpawnPositions[#data.botbPopeSpawnPositions+1] = entity.Position
                    end
                end
                npc.State = 100
                sprite:Play("Toot")
            end
        end
        -- 99: idling 
        -- 100: spawning enemies (use SoundEffect.SOUND_SUMMONSOUND)
        if npc.State == 99 then
            --print(#getNonDivineEnemies())
            if sprite:GetFrame() == 63 then
                --check
                if #data.botbPopeSpawnedMonsterList <= 1 then
                    npc.State = 100
                    sprite:Play("Toot")
                end
            end
        end

        if npc.State == 100 then
            if sprite:IsEventTriggered("Effect") then
                npc:PlaySound(SoundEffect.SOUND_FLUTE,1,0,false,math.random(50,150)/100)
                npc:PlaySound(SoundEffect.SOUND_FLUTE,1,0,false,math.random(50,150)/100)
                npc:PlaySound(SoundEffect.SOUND_FLUTE,1,0,false,math.random(50,150)/100)
            end
            if sprite:IsFinished("Toot") then
                for i=1,1000 do
                    if #data.botbPopeSpawnedMonsterList < #data.botbPopeSpawnpoints then
                        local spawnpointIndex = (i % #data.botbPopeSpawnPositions)+1
                        --pick from the spawnable table
                        local monsterIndex = data.botbPopeSpawnableMonsters[math.random(1, #data.botbPopeSpawnableMonsters)]
                        local newEntity = Isaac.Spawn(monsterIndex.Type,monsterIndex.Var,monsterIndex.Sub,data.botbPopeSpawnPositions[spawnpointIndex],Vector.Zero,npc):ToNPC()
                        data.botbPopeSpawnedMonsterList[#data.botbPopeSpawnedMonsterList+1] = newEntity
                        if (npc.FrameCount <= 64) ~= true then
                            npc.HitPoints = npc.HitPoints - newEntity.MaxHitPoints
                        end
                        if npc.HitPoints <= 0 then
                            for i=1, #data.botbPopeSpawnpoints do
                                data.botbPopeSpawnpoints[i]:Remove()
                            end
                            npc:Kill()
                        end
                    else
                        break
                    end
                end
                SFXManager():Play(SoundEffect.SOUND_SUMMONSOUND,1,0,false,1,0)
                npc:PlaySound(SoundEffect.SOUND_MEATY_DEATHS,0.5,0,false,2)
                sprite:Play("Idle")
                npc.State = 99
            end
        end

        if #data.botbPopeSpawnedMonsterList > 0 then
            if data.botbHasDivine ~= true then
                data.botbHasDivine = true
            end
            local lengthCheck = #data.botbPopeSpawnedMonsterList
            for i=1,lengthCheck do
                if data.botbPopeSpawnedMonsterList[i] ~= nil then
                    local spawnedIndex = data.botbPopeSpawnedMonsterList[i]
                    if spawnedIndex:IsDead() == true then
                        table.remove(data.botbPopeSpawnedMonsterList,i)
                    end
                end
            end
        end

        --spawned monster list death check
        
    end
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, POPE.NPCUpdate, Isaac.GetEntityTypeByName("Pope"))

--Janky, but it works
function POPE:spawnPointUpdate(player)
    local roomEntities = Isaac.GetRoomEntities() -- table
    local panelsInTheRoom = {}
    for i = 1, #roomEntities do
        local entity = roomEntities[i]
        --Self processing for the props
        if entity.Type == EntityType.ENTITY_GENERIC_PROP and entity.Variant == BotB.Enums.Props.POPE_SPAWNPOINT.VARIANT then     
            entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        end
    end
    
end
Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, POPE.spawnPointUpdate, 0)

local function getPlayers()
	local game = Game()
	local numPlayers = game:GetNumPlayers()
  
	local players = {}
	for i = 0, numPlayers - 1 do
	  local player = Isaac.GetPlayer(i)
	  table.insert(players, player)
	end
  
	return players
end



            
