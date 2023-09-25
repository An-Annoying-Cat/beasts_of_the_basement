local Mod = BotB
local OOZER = {}
local Entities = BotB.Enums.Entities

function OOZER:NPCUpdate(npc)

    


    if npc.Type == BotB.Enums.Entities.OOZER.TYPE and npc.Variant == BotB.Enums.Entities.OOZER.VARIANT then 
        local sprite = npc:GetSprite()
        local player = npc:GetPlayerTarget()
        local data = npc:GetData()
        local target = npc:GetPlayerTarget()
        local targetpos = target.Position
        local targetangle = (targetpos - npc.Position):GetAngleDegrees()
        local targetdistance = (targetpos - npc.Position):Length()
        local oozerPathfinder = npc.Pathfinder
        if data.oozerSpriteVariant == nil then
            data.oozerSpriteVariant = math.random(0,3)
            if data.oozerSpriteVariant == 0 then
                sprite:ReplaceSpritesheet(1, "gfx/monsters/chapter_2.5/ashpit/oozer_head1.png")
                sprite:ReplaceSpritesheet(0, "gfx/monsters/chapter_2.5/ashpit/oozer_body1.png")
			    sprite:LoadGraphics()
            elseif data.oozerSpriteVariant == 1 then
                sprite:ReplaceSpritesheet(1, "gfx/monsters/chapter_2.5/ashpit/oozer_head2.png")
                sprite:ReplaceSpritesheet(0, "gfx/monsters/chapter_2.5/ashpit/oozer_body2.png")
			    sprite:LoadGraphics()
            elseif data.oozerSpriteVariant == 2 then
                sprite:ReplaceSpritesheet(1, "gfx/monsters/chapter_2.5/ashpit/oozer_head3.png")
                sprite:ReplaceSpritesheet(0, "gfx/monsters/chapter_2.5/ashpit/oozer_body3.png")
			    sprite:LoadGraphics()
            elseif data.oozerSpriteVariant == 3 then
                sprite:ReplaceSpritesheet(1, "gfx/monsters/chapter_2.5/ashpit/oozer_head4.png")
                sprite:ReplaceSpritesheet(0, "gfx/monsters/chapter_2.5/ashpit/oozer_body4.png")
			    sprite:LoadGraphics()
            end
            
            data.oozerRadCircleMaxScale = 0.325
        end
        
        if npc.State == 0 then
            if not sprite:IsPlaying("Appear") then
                sprite:Play("Appear")
            end
            if sprite:IsFinished("Appear") then
                sprite:PlayOverlay("Head")
                npc.State = 99
                data.oozerRadCircleEffect = Isaac.Spawn(EntityType.ENTITY_EFFECT,Isaac.GetEntityVariantByName("Radiation Circle"),0,npc.Position,Vector.Zero,npc):ToEffect()
                data.oozerRadCircleEffect.Parent = npc
                data.oozerRadCircleEffect.SpriteScale = Vector(0.01,0.01)
                data.oozerRadCircleEffect.SortingLayer = SortingLayer.SORTING_BACKGROUND
                data.oozerRadCircleEffect:GetData().radCircleMaxScale = data.oozerRadCircleMaxScale
            end
        end

        if npc.State == 99 then
            if npc.EntityCollisionClass ~= EntityCollisionClass.ENTCOLL_ALL then
                npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
            end
            if npc.EntityGridCollisionClass ~= GridCollisionClass.COLLISION_SOLID then
                npc.EntityGridCollisionClass = GridCollisionClass.COLLISION_SOLID
            end
            npc:AnimWalkFrame("WalkHori", "WalkVert", 0.1)
            oozerPathfinder:FindGridPath(targetpos, 0.2, 0, false)
            --print(targetdistance)
            --both values in the vector are the same so what does it matter?
            --
            if data.oozerRadCircleEffect ~= nil then
                if targetdistance <= 200 * data.oozerRadCircleEffect.SpriteScale.X then
                    if target:ToPlayer() and not npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
                        if target:GetData().radDuration <= 60 then
                            target:GetData().addRads = true
                        end
                    end
                    if npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) and (target:IsEnemy() and not target:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)) then
                        if npc.FrameCount % 60 == 0 then
                            FiendFolio.AddBruise(target, npc, 120, 1, 1)
                        end
                    end
                end
            end
            
            --[[
            if (npc.FrameCount) % 60 == 0 then
                print("do it")
                OOZER:spawnTempRadCircle(true,500,0.5,npc.Position,npc)
            end]]
        end
    end
        
end




Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, OOZER.NPCUpdate, Isaac.GetEntityTypeByName("Oozer"))



function OOZER:tempRadCircleTest(cmd, _)
    if not cmd == "testradcirc" then return end
    if cmd == "testradcirc" then
        local player = Isaac.GetPlayer()
        OOZER:spawnTempRadCircle(false,500,1.0,Game():GetRoom():GetCenterPos(),player)
    end
end
Mod:AddCallback(ModCallbacks.MC_EXECUTE_CMD, OOZER.tempRadCircleTest)

function OOZER:radiationEffect(effect)
    local data = effect:GetData()
    if effect.Variant ~= Isaac.GetEntityVariantByName("Radiation Circle (Temporary)") then 
        if effect.Parent == nil and effect.Variant ~= Isaac.GetEntityVariantByName("Radiation Circle (Temporary)") then
            effect:Remove()
        else
            if effect.FrameCount <= 60 then
                effect.SpriteScale = Vector(data.radCircleMaxScale*(effect.FrameCount/60),data.radCircleMaxScale*(effect.FrameCount/60))
            end
            effect.Position = effect.Parent.Position

        end
        
    else
            --subtype: WXXXXYYYY
    --W: 1: is not friendly 2: is friendly
    --X: Duration in frames
    --Y: Max scale 1.000 format
    local data = effect:GetData()
    if effect.SubType ~= nil then
        if (effect.SubType - (effect.SubType % 100000000))*0.000000001 == 1 then
            data.isFriendly = false
        else
            data.isFriendly = true
        end
        data.radCircleMaxScale = (effect.SubType % 10000)/1000
        data.radCircleLifeTime = ((effect.SubType % 100000000) - (effect.SubType % 10000))*0.0001
        print(effect.SubType .. ", which means " .. data.radCircleLifeTime .. " and " .. data.radCircleMaxScale)
        --effect.SpriteScale = Vector(0.1,0.1)
    else
        data.isFriendly = false
        data.radCircleLifeTime = 300
        data.radCircleMaxScale = 1.0
        --effect.SpriteScale = Vector(0.1,0.1)
        --unfriendly 5 seconds at maximum scale as a failsafe
    end

    
    --print("peepnis")
    --print(effect.FrameCount)
    if effect.FrameCount <= 60 then
        effect.SpriteScale = Vector(data.radCircleMaxScale*(effect.FrameCount/60),data.radCircleMaxScale*(effect.FrameCount/60))
    end
    if data.radCircleLifeTime - effect.FrameCount <= 60 then
        effect.SpriteScale = Vector(data.radCircleMaxScale*((data.radCircleLifeTime - effect.FrameCount)/60),data.radCircleMaxScale*((data.radCircleLifeTime - effect.FrameCount)/60))
    end
    if effect.FrameCount >= data.radCircleLifeTime then
        effect:Remove()
    end

    local roomEntities = Isaac.GetRoomEntities() -- table
    for i = 1, #roomEntities do
        local entity = roomEntities[i]
        --print(entity.Type, entity.Variant, entity.SubType)
        if entity.Type == EntityType.ENTITY_PLAYER then
            local entdistance = (entity.Position - effect.Position):Length()
            --print("is " .. entdistance .. " <= " .. 200 * effect.SpriteScale.X .. " ?" )
            if entdistance <= 200 * effect.SpriteScale.X then
                if entity:GetData().radDuration <= 60 then
                    entity:GetData().addRads = true
                end
            end
        elseif data.isFriendly == true and (entity:IsEnemy() and not entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)) then
                if effect.FrameCount % 60 == 0 then
                    FiendFolio.AddBruise(entity, effect, 120, 1, 1)
                end
        end
    end


    end
    
end
Mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE,OOZER.radiationEffect, Isaac.GetEntityVariantByName("Radiation Circle"))

--Duration must be 4 digits or less, scale must be between 9.999 and 0.001
function OOZER:spawnTempRadCircle(friendly,duration,scale,position,source)
    print(friendly)
    local isFriendly = friendly or false
    print(isFriendly)
    local finalSubType = 200000000 + (duration*10000) + (scale * 1000)
    if isFriendly then
        finalSubType = 100000000 + (duration*10000) + (scale * 1000)
    end
    --local finalSubType = 200000000 + (duration*10000) + (scale * 1000)
    --print("final subtype is " .. finalSubType .. ", which should mean " .. duration .. " frames and " .. scale .. " maximum scale")
    local tempRadCirc = Isaac.Spawn(EntityType.ENTITY_EFFECT,BotB.Enums.Entities.RADIATION_CIRCLE_TEMPORARY.VARIANT,finalSubType,position,Vector.Zero,source):ToEffect()
    tempRadCirc.SortingLayer = SortingLayer.SORTING_BACKGROUND
    tempRadCirc.Parent = source
    tempRadCirc.Timeout = -1
end

--[[
function OOZER:radiationTempEffect(effect)
    --subtype: WXXXXYYYY
    --W: 1: is not friendly 2: is friendly
    --X: Duration in frames
    --Y: Max scale 1.000 format
    local data = effect:GetData()
    if effect.SubType ~= nil then
        if (effect.SubType - (effect.SubType % 100000000))*0.000000001 == 1 then
            data.isFriendly = false
        else
            data.isFriendly = true
        end
        data.radCircleMaxScale = (effect.SubType % 10000)/1000
        data.radCircleLifeTime = ((effect.SubType % 100000000) - (effect.SubType % 10000))*0.0001
        print(effect.SubType .. ", which means " .. data.radCircleLifeTime .. " and " .. data.radCircleMaxScale)
        effect.SpriteScale = Vector(0.1,0.1)
    else
        data.isFriendly = false
        data.radCircleLifeTime = 300
        data.radCircleMaxScale = 1.0
        effect.SpriteScale = Vector(0.1,0.1)
        --unfriendly 5 seconds at maximum scale as a failsafe
    end

    
    print("peepnis")
    if effect.FrameCount <= 60 then
        effect.SpriteScale = Vector(data.radCircleMaxScale*(effect.FrameCount/60),data.radCircleMaxScale*(effect.FrameCount/60))
    end
    if data.radCircleLifeTime - effect.FrameCount <= 60 then
        effect.SpriteScale = Vector(data.radCircleMaxScale*(data.radCircleLifeTime - effect.FrameCount/60),data.radCircleMaxScale*(data.radCircleLifeTime - effect.FrameCount/60))
    end

    local roomEntities = Isaac.GetRoomEntities() -- table
    for i = 1, #roomEntities do
        local entity = roomEntities[i]
        print(entity.Type, entity.Variant, entity.SubType)
        if entity:ToPlayer() and data.isFriendly == false then
            local entdistance = (entity.Position - effect.Position):Length()
            if entdistance <= 200 * effect.SpriteScale.X then
                if entity:GetData().radDuration <= 60 then
                    entity:GetData().addRads = true
                end
            end
        elseif entity:ToNPC() and data.isFriendly == true and (entity:IsEnemy() and not entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)) then
                if effect.FrameCount % 60 == 0 then
                    FiendFolio.AddBruise(entity, effect, 120, 1, 1)
                end
        end
    end
    --[[
    if effect.FrameCount >= data.radCircleLifeTime then
        effect:Remove()
    end]]
--end
Mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE,OOZER.radiationEffect, BotB.Enums.Entities.RADIATION_CIRCLE_TEMPORARY.VARIANT)


local radiationMalus={
    TEAR=-1.5,
    SPEED=0.5,
    --LUCK=-0.5,
    RANGE=-160,
    DAMAGE=0.5
}



--Stats
--240 is baseline amt of decay frames for stat boost
function OOZER:onRadCache(player, cacheFlag)
        local data = player:GetData()
        if data.radDuration ~= 0  and data.radDuration ~= nil then
            local Multiplier = data.radDuration / 60
            local recip = 1 - Multiplier
            if (cacheFlag&CacheFlag.CACHE_DAMAGE)==CacheFlag.CACHE_DAMAGE then
              player.Damage=(recip*(player.Damage))+Multiplier*radiationMalus.DAMAGE
            end
            if (cacheFlag&CacheFlag.CACHE_FIREDELAY)==CacheFlag.CACHE_FIREDELAY then
              local tps=30.0/(player.MaxFireDelay+1.0)
              player.MaxFireDelay=30.0/(math.max(0.1,tps+Multiplier*radiationMalus.TEAR))-1
            end
            if (cacheFlag&CacheFlag.CACHE_RANGE)==CacheFlag.CACHE_RANGE then
                player.TearRange=player.TearRange+Multiplier*radiationMalus.RANGE
            end
            if (cacheFlag&CacheFlag.CACHE_SPEED)==CacheFlag.CACHE_SPEED then
              player.MoveSpeed=(recip*(player.MoveSpeed))+Multiplier*radiationMalus.SPEED
            end
        elseif data.radDuration == 0 or data.radDuration == nil then
            return
        end
    
end
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, OOZER.onRadCache)

--[[
    local radiationMalus={
    TEAR=-1.5,
    SPEED=-0.2,
    --LUCK=-0.5,
    RANGE=-20,
    DAMAGE=-4
}
]]
--[[
function OOZER:onRadCache(player, cacheFlag)
    local data = player:GetData()
    if data.radDuration ~= 0  and data.radDuration ~= nil then
        local Multiplier = data.radDuration / 60
        if (cacheFlag&CacheFlag.CACHE_DAMAGE)==CacheFlag.CACHE_DAMAGE then
          player.Damage=player.Damage+Multiplier*radiationMalus.DAMAGE
        end
        if (cacheFlag&CacheFlag.CACHE_FIREDELAY)==CacheFlag.CACHE_FIREDELAY then
          local tps=30.0/(player.MaxFireDelay+1.0)
          player.MaxFireDelay=30.0/(math.max(0.1,tps+Multiplier*radiationMalus.TEAR))-1
        end
        if (cacheFlag&CacheFlag.CACHE_RANGE)==CacheFlag.CACHE_RANGE then
          player.TearRange=player.TearRange+Multiplier*radiationMalus.RANGE
        end
        if (cacheFlag&CacheFlag.CACHE_SPEED)==CacheFlag.CACHE_SPEED then
          player.MoveSpeed=player.MoveSpeed+Multiplier*radiationMalus.SPEED
        end
    elseif data.radDuration == 0 or data.radDuration == nil then
        return
    end

end
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, OOZER.onRadCache)
]]



function OOZER:playerUpdate()
    --print("stop the fucking presses")
    local seeds = Game():GetSeeds()
    local playerList = TSIL.Players.GetPlayers(true)
    for i=1,#playerList,1 do
        local player = playerList[i]:ToPlayer()
        local data = player:GetData()

        if data.radDuration == nil then
            data.radDuration = 0
            data.addRads = false
        end
        if data.addRads == true then
            if math.random(0,1) == 0 then
                SFXManager():Play(BotB.Enums.SFX.GEIGER_CLICK,math.random(80,120)/100,0,false,1,math.random(-25,25)/100)
            end
            data.radDuration = data.radDuration + 1
            
            data.addRads = false
        end
        if data.radDuration ~= 0 and player.FrameCount % 4 == 0 then
            data.radDuration = data.radDuration - 1
            player:SetColor(Color(0.5,1.75,0.5,1), 4, 1, true, true)
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_RANGE | CacheFlag.CACHE_SPEED)
            player:EvaluateItems()
        end

    end
end
Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, OOZER.playerUpdate)