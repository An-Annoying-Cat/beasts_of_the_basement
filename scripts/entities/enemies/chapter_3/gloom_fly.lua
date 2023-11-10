local Mod = BotB
local GLOOM_FLY = {}
local Entities = BotB.Enums.Entities
local ff = FiendFolio

function GLOOM_FLY:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local data = npc:GetData()
    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()
    local room = Game():GetRoom()


    if npc.Type == BotB.Enums.Entities.GLOOM_FLY.TYPE and npc.Variant == BotB.Enums.Entities.GLOOM_FLY.VARIANT then
        if npc.State == 0 then
            if data.gloomFlyInitDirection == nil then
                --print(npc.InitSeed)
                data.gloomFlyInitDirection = BotB.Functions.RNG:RandomInt(npc.InitSeed,3) + 1
                --1 is added cuz table indexing and shit
                data.gloomFlyDirection = data.gloomFlyInitDirection
            end
            if not sprite:IsPlaying("Appear") then
                sprite:Play("Appear")
            end
            if sprite:IsFinished("Appear") or sprite:IsEventTriggered("Back") then
                sprite:Play("Fly")
                npc.State = 99
            end
            if data.isFromFlapstack then
                data.gloomFlyDirection = math.random(1,4)
            end
        end
        npc.SplatColor = Color(0,0,0,0.125,5,5,5)
        --States:
        --99: fly
        --100: spawn trail
        if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_WALLS then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
        end
        if npc.EntityCollisionClass ~= EntityCollisionClass.ENTCOLL_PLAYEROBJECTS then
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
        end
        if npc.State ~= 0 then
            npc.Velocity = (0.5 * npc.Velocity) + (0.5 * ff:diagonalMove(npc, 4, 1))
        end
        if npc.State == 99 then
            
            if npc.FrameCount % 8 == 0 then
                --SFXManager():Play(SoundEffect.SOUND_SUMMON_POOF,0.4,0,false,math.random(120,150)/100)
                Isaac.Spawn(Entities.GLOOM_FLY_TRAIL.TYPE,Entities.GLOOM_FLY_TRAIL.VARIANT,0,npc.Position,Vector.Zero,npc)
                --npc.State = 100
                --sprite:Play("Spawn")
            end
        end

        if npc.State == 100 then
            if sprite:IsEventTriggered("Spawn") then
                SFXManager():Play(SoundEffect.SOUND_SUMMON_POOF,0.4,0,false,math.random(120,150)/100)
                local duder = Isaac.Spawn(Entities.GLOOM_FLY_TRAIL.TYPE,Entities.GLOOM_FLY_TRAIL.VARIANT,0,npc.Position,Vector.Zero,npc):ToNPC()
                duder:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
            end
            if sprite:IsFinished() then
                npc.State = 99
                sprite:Play("Fly")
            end
        end
    end
end


Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, GLOOM_FLY.NPCUpdate, Isaac.GetEntityTypeByName("Gloom Fly"))

function GLOOM_FLY:DamageCheck(npc, amount, damageFlags, source, _)
    if npc.Type ~= BotB.Enums.Entities.GLOOM_FLY.TYPE or npc.Variant ~= BotB.Enums.Entities.GLOOM_FLY.VARIANT then return end
    if amount >= npc.HitPoints then
        --boom fly stuff
        --print("Fuck!(TM)")
        local params = ProjectileParams()
        params.BulletFlags = ProjectileFlags.GHOST | ProjectileFlags.CURVE_RIGHT
        params.CurvingStrength = 0.05625/4
        params.FallingAccelModifier = -0.075
        params.FallingSpeedModifier = 0
        npc:ToNPC():FireProjectiles(npc.Position, Vector(8,0), 8, params)

    end
end
Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, GLOOM_FLY.DamageCheck, Isaac.GetEntityTypeByName("Gloom Fly"))

function GLOOM_FLY:TrailUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local data = npc:GetData()
    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()
    local room = Game():GetRoom()


    if npc.Type == BotB.Enums.Entities.GLOOM_FLY_TRAIL.TYPE and npc.Variant == BotB.Enums.Entities.GLOOM_FLY_TRAIL.VARIANT then
        if npc.State == 0 then
            npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
            if not sprite:IsPlaying("Appear") then
                sprite:Play("Appear")
            end
            if sprite:IsFinished("Appear") or sprite:IsEventTriggered("Back") then
                sprite:Play("Fly")
                npc.State = 99
            end
        end
        
        --States:
        --99: fly
        --100: spawn trail
        if npc.EntityCollisionClass ~= EntityCollisionClass.ENTCOLL_ALL then
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        end
        if npc.State ~= 0 then
            npc.Velocity = Vector.Zero
        end
        if npc.State == 99 then
            
            if npc.FrameCount > 30 then
                local idiot = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 0, npc.Position, Vector.Zero, npc):ToEffect()
                idiot:GetSprite().Color = Color(1,1,1,0.25,2,2,2)
                idiot.Scale = 0.5
                npc:Remove()
            end
        end
    end
end


Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, GLOOM_FLY.TrailUpdate, Isaac.GetEntityTypeByName("Gloom Fly Trail"))