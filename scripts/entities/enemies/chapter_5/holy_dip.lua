local Mod = BotB
local HOLY_DIP = {}
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

function HOLY_DIP:NPCUpdate(npc)
    if npc.Type == BotB.Enums.Entities.HOLY_DIP.TYPE and npc.Variant == BotB.Enums.Entities.HOLY_DIP.VARIANT then 
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
        npc.SplatColor = Color(0.75,1,1,1,0.75,1,1)
        if npc.State == 0 then
            sprite:PlayOverlay("Halo")
            if sprite:IsPlaying("Idle") ~= true then
                sprite:Play("Idle")
                data.botbHolyDipMoveCooldownMax = 60
                data.botbHolyDipMoveCooldown = data.botbHolyDipMoveCooldownMax
                data.botbHolyDipNyoomAngle = 0
                data.botbHolyDipDeathSpawned = false
                data.botbHasDivine = true
                npc.State = 99
                
                
            end
        end
        if npc.State == 99 then
            npc:AnimWalkFrame("Idle","Idle",0)
            npc.Velocity = (0.94 * npc.Velocity) + (0.01 * (targetpos - npc.Position):Resized(npc.Velocity:Length()))
            if data.botbHolyDipMoveCooldown ~= 0 then
                data.botbHolyDipMoveCooldown = data.botbHolyDipMoveCooldown - 1
            else
                npc.State = 100
                data.botbHolyDipNyoomAngle = targetangle
                npc.Velocity = Vector(6,0):Rotated(data.botbHolyDipNyoomAngle)
                sprite:Play("Move")
            end
        end
        if npc.State == 100 then
            npc:AnimWalkFrame("Move","Move",0)
            npc.Velocity = (0.8 * npc.Velocity) + (0.2 * (targetpos - npc.Position):Resized(npc.Velocity:Length()))
            if sprite:GetFrame() == 24 then
                npc.State = 99
                sprite:Play("Idle")
                data.botbHolyDipMoveCooldown = data.botbHolyDipMoveCooldownMax
            end
        end
        if npc:HasMortalDamage() and data.botbHolyDipDeathSpawned == false then
            local warningTarget = Isaac.Spawn(EntityType.ENTITY_EFFECT,BotB.Enums.Entities.WARNING_TARGET.VARIANT,0,npc.Position,Vector(0,0),npc):ToEffect()
                        warningTarget.Scale = 0.75
                        warningTarget:GetSprite().Color = Color(1,1,1,1,0,1,1)
            data.botbHolyDipDeathSpawned = true
            local pos = npc.Position
            for i = 1, 210 do
                BotB.FF.scheduleForUpdate(function()
                    if i==0 then
                        SFXManager():Play(SoundEffect.SOUND_LIGHTBOLT_CHARGE,1,0,false,1)
                        
                    end
                    if i>=60 and i%30 == 0 then
                        local beam = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.CRACK_THE_SKY,0,pos,Vector(0,0),npc):ToEffect()
                        beam:SetTimeout(240)
                    end
                end, i, ModCallbacks.MC_POST_RENDER)
            end
        end
    end
end


Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, HOLY_DIP.NPCUpdate, Isaac.GetEntityTypeByName("Holy Dip"))