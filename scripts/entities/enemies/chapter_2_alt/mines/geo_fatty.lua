local Mod = BotB
local GEO_FATTY = {}
local Entities = BotB.Enums.Entities
local ff = FiendFolio


function GEO_FATTY:NPCUpdate(npc)

    


    if npc.Type == BotB.Enums.Entities.GEO_FATTY.TYPE and npc.Variant == BotB.Enums.Entities.GEO_FATTY.VARIANT then 
        local sprite = npc:GetSprite()
        local player = npc:GetPlayerTarget()
        local data = npc:GetData()
        local target = npc:GetPlayerTarget()
        local targetpos = target.Position
        local targetangle = (targetpos - npc.Position):GetAngleDegrees()
        local targetdistance = (targetpos - npc.Position):Length()
        local shitheadPathfinder = npc.Pathfinder
        if data.geoFattyFartCooldownMax == nil then
            data.geoFattyFartCooldownMax = 120
            data.geoFattyFartCooldown = data.geoFattyFartCooldownMax
        end

        if npc.State == 0 then
            sprite:Play("WalkHori")
            npc.State = 99
        end

        if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_GROUND then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
        end
        --0: init
        --99: Walking
        --100: Fart/Dip summon
        if npc.State == 99 then
            npc:AnimWalkFrame("WalkHori", "WalkVert", 1)
            shitheadPathfinder:FindGridPath(targetpos, 0.4, 1, false)
            --[[
            if npc.FrameCount % 8 == 0 then
                local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.CREEP_SLIPPERY_BROWN,0,npc.Position,Vector.Zero,npc):ToEffect()
                creep.SpriteScale = creep.SpriteScale * 0.8
                creep.Timeout = 90
                creep:Update()
            end
            ]]
            if data.geoFattyFartCooldown ~= 0 then
                data.geoFattyFartCooldown = data.geoFattyFartCooldown - 1
            else
                if targetdistance <= 300 then
                    sprite:Play("Shoot")
                    npc:PlaySound(SoundEffect.SOUND_BOSS_LITE_SLOPPY_ROAR, 1, 0, false, math.random(150,175)/100)
                    npc.State = 100
                    data.geoFattyFartCooldown = data.geoFattyFartCooldownMax
                end
            end
        end
        --Attacking
        if npc.State == 100 then
            if npc.Velocity ~= Vector.Zero then
                npc.Velocity = Vector.Zero
            end
            if sprite:IsEventTriggered("Shoot") then
                --lasers...
                local ring = Isaac.Spawn(7, 2, 2, npc.Position, Vector.Zero, npc):ToLaser()
                ring:GetData().GeoFatty = true
                ring:SetColor(Color(1,1,1,1,1), 3, 1, false, false)
                ring.Parent = npc
                npc.Child = ring
                ring.Radius = 5
                ring.Visible = true
                ring.Color = Color(0,0,0,1,1,0,1)
                ring:AddTearFlags(TearFlags.TEAR_PULSE)
                ring.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
                data.Growing = true
                sfx:Play(BotB.Enums.SFX.CRYSTAL_FIRE_BIG,5,0,false,math.random(90,110)/100)
                ring:SetTimeout(80)
            end
            if sprite:IsEventTriggered("Back") then
                npc.State = 99
            end
        end
    end
end


Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, GEO_FATTY.NPCUpdate, Isaac.GetEntityTypeByName("Geo Fatty"))




function GEO_FATTY:LaserCheck(laser)
    local data = laser:GetData()
    if not data.GeoFatty == true then return end
    if not data.StupidAssJankyHack then
        laser:AddTearFlags(TearFlags.TEAR_CONTINUUM)
        data.StupidAssJankyHack = true
    end
    local sprite = laser:GetSprite()
    if laser.FrameCount < 80 then
       laser.Radius = laser.Radius + 1
    else
        sfx:Play(BotB.Enums.SFX.CRYSTAL_FIRE_SMALL,0.5,0,false,math.random(90,110)/100)
    end
    
end
Mod:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, GEO_FATTY.LaserCheck)


function GEO_FATTY:DamageCheck(npc, _, _, source, _)
    --print("sharb")
    local npcConv = npc:ToNPC()
    local data = npc:GetData()
    local sprite = npc:GetSprite()
    if npc.Type == BotB.Enums.Entities.GEO_FATTY.TYPE and npc.Variant == BotB.Enums.Entities.GEO_FATTY.VARIANT then 
        if source.Entity.Type == 501 and source.Entity.Variant == 42 then
            return false
        end
        
        
    end
    --return true
end


Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, GEO_FATTY.DamageCheck, Isaac.GetEntityTypeByName("Geo Horf"))