local Mod = BotB
local DOORTRAP = {}
local Entities = BotB.Enums.Entities
local game = Game()
local mod = BotB.FF

function DOORTRAP:EyeUpdate(npc)
    if npc.Type == BotB.Enums.Entities.DOORTRAP_EYE.TYPE and npc.Variant == BotB.Enums.Entities.DOORTRAP_EYE.VARIANT  then 
        local sprite = npc:GetSprite()
        local player = npc:GetPlayerTarget()
        local data = npc:GetData()
        local target = npc:GetPlayerTarget()
        local targetpos = target.Position
        local targetangle = (targetpos - npc.Position):GetAngleDegrees()
        local targetdistance = (targetpos - npc.Position):Length()
        --local antPathfinder = npc.Pathfinder

        if npc.State == 0 then
            if data.doortrapDetectDistance == nil then
                --data.doortrapStayPosition = npc.Position
                data.doortrapDetectDistance = 200
                data.doortrapAttackCooldownMax = 120
                data.doortrapAttackCooldown = data.doortrapAttackCooldownMax + math.random(0,60)
                data.doortrapBackSprite = math.random(1,4)
                sprite:ReplaceSpritesheet(1, "gfx/bosses/doortrap/doortrap_back" .. data.doortrapBackSprite .. ".png")
                sprite:LoadGraphics()
                npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
                --[[
                if MusicManager():GetCurrentMusicID() ~= Isaac.GetMusicIdByName("Nevermore") then
                    MusicManager():Play(Isaac.GetMusicIdByName("Nevermore"), 0.25)
                end]]
            end
            sprite:Play("Idle")
            npc.State = 99 
        end

        --npc.Position = data.doortrapStayPosition 

        if npc.State == 99 then
            --[[
            if MusicManager():GetCurrentMusicID() ~= Isaac.GetMusicIdByName("Nevermore") then
                MusicManager():Play(Isaac.GetMusicIdByName("Nevermore"), 0.25)
            end]]
            if data.doortrapAttackCooldown ~= 0 then
                data.doortrapAttackCooldown = data.doortrapAttackCooldown - 1
            else
                if targetdistance <= data.doortrapDetectDistance then
                    data.doortrapAttackCooldown = data.doortrapAttackCooldownMax
                    sprite:Play("Shoot")
                    npc.State = 100
                end
            end
        end

        if npc.State == 100 then
            if sprite:IsFinished("Shoot") then
                npc.State = 99
                sprite:Play("Idle")
            end
            if sprite:IsEventTriggered("Shoot") then
                SFXManager():Play(SoundEffect.SOUND_BLOODSHOOT,2,0,false,math.random(50,90)/100, 0)
                local doortrapProjParams = ProjectileParams()
                --doortrapProjParams.BulletFlags = ProjectileFlags.GHOST
                npc:FireProjectiles(npc.Position, Vector(6,0):Rotated(targetangle), 0, doortrapProjParams)
            end
        end
        
    end
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, DOORTRAP.EyeUpdate, Isaac.GetEntityTypeByName("Doortrap (Eye)"))

function DOORTRAP:MouthUpdate(npc)
    if npc.Type == BotB.Enums.Entities.DOORTRAP_MOUTH.TYPE and npc.Variant == BotB.Enums.Entities.DOORTRAP_MOUTH.VARIANT  then 
        local sprite = npc:GetSprite()
        local player = npc:GetPlayerTarget()
        local data = npc:GetData()
        local target = npc:GetPlayerTarget()
        local targetpos = target.Position
        local targetangle = (targetpos - npc.Position):GetAngleDegrees()
        local targetdistance = (targetpos - npc.Position):Length()
        --local antPathfinder = npc.Pathfinder

        if npc.State == 0 then
            if data.doortrapDetectDistance == nil then
                --data.doortrapStayPosition = npc.Position
                data.doortrapDetectDistance = 400
                data.doortrapAttackCooldownMax = 180
                data.doortrapAttackCooldown = data.doortrapAttackCooldownMax + math.random(0,60)
                data.doortrapBackSprite = math.random(1,4)
                sprite:ReplaceSpritesheet(1, "gfx/bosses/doortrap/doortrap_back" .. data.doortrapBackSprite .. ".png")
                sprite:LoadGraphics()
                npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
            end
            sprite:Play("Idle")
            npc.State = 99 
        end

        --npc.Position = data.doortrapStayPosition 

        if npc.State == 99 then
            if data.doortrapAttackCooldown ~= 0 then
                data.doortrapAttackCooldown = data.doortrapAttackCooldown - 1
            else
                if targetdistance <= data.doortrapDetectDistance then
                    data.doortrapAttackCooldown = data.doortrapAttackCooldownMax
                    sprite:Play("Shoot")
                    npc.State = 100
                end
            end
        end

        if npc.State == 100 then
            if sprite:IsFinished("Shoot") then
                npc.State = 99
                sprite:Play("Idle")
            end
            if sprite:IsEventTriggered("Shoot") then
                SFXManager():Play(SoundEffect.SOUND_BLOODSHOOT,2,0,false,math.random(50,90)/100, 0)
                local doortrapProjParams = ProjectileParams()
                doortrapProjParams.BulletFlags = ProjectileFlags.BOUNCE | ProjectileFlags.BOUNCE_FLOOR
                doortrapProjParams.ChangeTimeout = 180
                doortrapProjParams.ChangeFlags = 0
                npc:FireProjectiles(npc.Position, Vector(8,0):Rotated(targetangle), 0, doortrapProjParams)
            end
        end
        
    end
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, DOORTRAP.MouthUpdate, Isaac.GetEntityTypeByName("Doortrap (Mouth)"))

function DOORTRAP:ButtUpdate(npc)
    if npc.Type == BotB.Enums.Entities.DOORTRAP_BUTT.TYPE and npc.Variant == BotB.Enums.Entities.DOORTRAP_BUTT.VARIANT  then 
        local sprite = npc:GetSprite()
        local player = npc:GetPlayerTarget()
        local data = npc:GetData()
        local target = npc:GetPlayerTarget()
        local targetpos = target.Position
        local targetangle = (targetpos - npc.Position):GetAngleDegrees()
        local targetdistance = (targetpos - npc.Position):Length()
        --local antPathfinder = npc.Pathfinder

        if npc.State == 0 then
            if data.doortrapDetectDistance == nil then
                --data.doortrapStayPosition = npc.Position
                data.doortrapDetectDistance = 99999
                data.doortrapAttackCooldownMax = 120
                data.doortrapAttackCooldown = data.doortrapAttackCooldownMax + math.random(0,60)
                data.doortrapBackSprite = math.random(1,4)
                sprite:ReplaceSpritesheet(1, "gfx/bosses/doortrap/doortrap_back" .. data.doortrapBackSprite .. ".png")
                sprite:LoadGraphics()
                npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
            end
            sprite:Play("Idle")
            npc.State = 99 
        end

        --npc.Position = data.doortrapStayPosition 

        if npc.State == 99 then
            if data.doortrapAttackCooldown ~= 0 then
                data.doortrapAttackCooldown = data.doortrapAttackCooldown - 1
            else
                if targetdistance <= data.doortrapDetectDistance then
                    data.doortrapAttackCooldown = data.doortrapAttackCooldownMax
                    sprite:Play("Shoot")
                    npc.State = 100
                end
            end
        end

        if npc.State == 100 then
            if sprite:IsFinished("Shoot") then
                npc.State = 99
                sprite:Play("Idle")
            end
            if sprite:IsEventTriggered("Shoot") then
                --print("blargh")
                local doortrapProjParams = ProjectileParams()
                SFXManager():Play(SoundEffect.SOUND_FART,2,0,false,math.random(50,90)/100, 0)
                --doortrapProjParams.BulletFlags = ProjectileFlags.GHOST
                doortrapProjParams.Color = Color(151/255, 102/255, 60/255, 1)
                --npc:FireProjectiles(npc.Position, Vector(6,0):Rotated(targetangle), 0, doortrapProjParams)
                npc:FireBossProjectiles(6, npc.Position+Vector(0.1,0):Rotated(targetangle), 5, doortrapProjParams)
            end
        end
        
    end
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, DOORTRAP.ButtUpdate, Isaac.GetEntityTypeByName("Doortrap (Butt)"))

function DOORTRAP:HiveUpdate(npc)
    if npc.Type == BotB.Enums.Entities.DOORTRAP_HIVE.TYPE and npc.Variant == BotB.Enums.Entities.DOORTRAP_HIVE.VARIANT  then 
        local sprite = npc:GetSprite()
        local player = npc:GetPlayerTarget()
        local data = npc:GetData()
        local target = npc:GetPlayerTarget()
        local targetpos = target.Position
        local targetangle = (targetpos - npc.Position):GetAngleDegrees()
        local targetdistance = (targetpos - npc.Position):Length()
        --local antPathfinder = npc.Pathfinder

        if npc.State == 0 then
            if data.doortrapDetectDistance == nil then
                --data.doortrapStayPosition = npc.Position
                data.doortrapDetectDistance = 400
                data.doortrapAttackCooldownMax = 240
                data.doortrapAttackCooldown = data.doortrapAttackCooldownMax + math.random(0,60)
                data.doortrapBackSprite = math.random(1,4)
                sprite:ReplaceSpritesheet(1, "gfx/bosses/doortrap/doortrap_back" .. data.doortrapBackSprite .. ".png")
                sprite:LoadGraphics()
                npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
            end
            sprite:Play("Idle")
            npc.State = 99 
        end

        --npc.Position = data.doortrapStayPosition 

        if npc.State == 99 then
            if data.doortrapAttackCooldown ~= 0 then
                data.doortrapAttackCooldown = data.doortrapAttackCooldown - 1
            else
                if targetdistance <= data.doortrapDetectDistance then
                    data.doortrapAttackCooldown = data.doortrapAttackCooldownMax
                    sprite:Play("Shoot")
                    npc.State = 100
                end
            end
        end

        if npc.State == 100 then
            if sprite:IsFinished("Shoot") then
                npc.State = 99
                sprite:Play("Idle")
            end
            if sprite:IsEventTriggered("Shoot") then
                if Isaac.CountEntities(npc, 18, 0) < 3 then
                    sfx:Play(Isaac.GetSoundIdByName("Wheeze"),1,0,false,math.random(75, 85)/100)
                    local spawnedFly = Isaac.Spawn(18, 0, 0, npc.Position + Vector(5,0):Rotated(targetangle), Vector(0,0), npc)
                    spawnedFly:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                    spawnedFly.Velocity = Vector(6,0):Rotated(targetangle)
                    spawnedFly.HitPoints = 1
                else
                    sfx:Play(Isaac.GetSoundIdByName("Wheeze"),0.5,0,false,math.random(100, 125)/100)
                end
            end
        end
        
    end
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, DOORTRAP.HiveUpdate, Isaac.GetEntityTypeByName("Doortrap (Hive)"))

function DOORTRAP:CubeUpdate(npc)
    if npc.Type == BotB.Enums.Entities.DOORTRAP_CUBE.TYPE and npc.Variant == BotB.Enums.Entities.DOORTRAP_CUBE.VARIANT  then 
        local sprite = npc:GetSprite()
        local player = npc:GetPlayerTarget()
        local data = npc:GetData()
        local target = npc:GetPlayerTarget()
        local targetpos = target.Position
        local targetangle = (targetpos - npc.Position):GetAngleDegrees()
        local targetdistance = (targetpos - npc.Position):Length()
        --local antPathfinder = npc.Pathfinder

        if npc.State == 0 then
            if data.doortrapDetectDistance == nil then
                --data.doortrapStayPosition = npc.Position
                data.doortrapDetectDistance = 400
                data.doortrapAttackCooldownMax = 120
                data.doortrapAttackCooldown = data.doortrapAttackCooldownMax
                data.doortrapBackSprite = math.random(1,4)
                sprite:ReplaceSpritesheet(1, "gfx/bosses/doortrap/doortrap_back" .. data.doortrapBackSprite .. ".png")
                sprite:LoadGraphics()
                npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
                data.doortrapDeathFrameRando = math.random(1,12)
                data.doortrapShouldDie = false
                data.doortrapDoDeathCheck = false
            end
            sprite:Play("Idle")
            sprite:Stop()
            npc.State = 99 
        end

        --npc.Position = data.doortrapStayPosition 
        --100: death check
        if npc.State == 99 then
            --insert maxwell theme
            if data.doortrapShouldDie == true then
                if npc.FrameCount % data.doortrapDeathFrameRando == 0 then
                    if math.random(0,3) == 0 then
                        Isaac.Spawn(5,0,0,npc.Position,Vector.Zero,npc)
                    end
                    npc:Kill()
                end
            end
        end
        
    end
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, DOORTRAP.CubeUpdate, Isaac.GetEntityTypeByName("Doortrap (Cube)"))
--[[
function DOORTRAP:checkforNoOrgansLeft()
    local roomEntities = Isaac.GetRoomEntities() -- table
    local numOrgans = 0
    for i = 1, #roomEntities do
        local entity = roomEntities[i]
        if entity.Type == BotB.Enums.Entities.DOORTRAP_CUBE.TYPE and entity.Variant >= BotB.Enums.Entities.DOORTRAP_EYE.VARIANT and entity.Variant <= BotB.Enums.Entities.DOORTRAP_HIVE.VARIANT then
            --print("got an organ")
            numOrgans = numOrgans + 1
        end
        --print(entity.Type, entity.Variant, entity.SubType)
    end
    if numOrgans > 0 then
        return false
    else
        return true
    end
end]]

function DOORTRAP:makeAllCubesCheck()
    local roomEntities = Isaac.GetRoomEntities() -- table
    local numOrgans = 0
    local allOrgansDead = false
    for i = 1, #roomEntities do
        local entity = roomEntities[i]
        if entity.Type == BotB.Enums.Entities.DOORTRAP_CUBE.TYPE and entity.Variant >= BotB.Enums.Entities.DOORTRAP_EYE.VARIANT and entity.Variant <= BotB.Enums.Entities.DOORTRAP_HIVE.VARIANT then
            --print("got an organ")
            numOrgans = numOrgans + 1
        end
        --print(entity.Type, entity.Variant, entity.SubType)
    end
    if numOrgans > 0 then
        allOrgansDead = false
    else
        allOrgansDead = true
    end
    if allOrgansDead then
        for i = 1, #roomEntities do
            local entity = roomEntities[i]
            if entity.Type == BotB.Enums.Entities.DOORTRAP_CUBE.TYPE and entity.Variant == BotB.Enums.Entities.DOORTRAP_CUBE.VARIANT then
                --print("got an organ")
                entity:GetData().doortrapShouldDie = true
            end
            --print(entity.Type, entity.Variant, entity.SubType)
        end
    end
    
end
Mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, DOORTRAP.makeAllCubesCheck)


function DOORTRAP:doPickupDrop(npc)
    if npc.Type == BotB.Enums.Entities.DOORTRAP_EYE.TYPE and npc.Variant >= BotB.Enums.Entities.DOORTRAP_EYE.VARIANT and npc.Variant <= BotB.Enums.Entities.DOORTRAP_HIVE.VARIANT  then 
        Isaac.Spawn(5,0,0,npc.Position,Vector.Zero,npc)
    else
        if npc.Type == BotB.Enums.Entities.DOORTRAP_CUBE.TYPE and npc.Type == BotB.Enums.Entities.DOORTRAP_CUBE.VARIANT then
            if math.random(0,3) == 0 then
                Isaac.Spawn(5,0,0,npc.Position,Vector.Zero,npc)
            end
        end
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, DOORTRAP.doPickupDrop)