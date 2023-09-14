local Mod = BotB
local BABBY_FAKE = {}
local Entities = BotB.Enums.Entities

function BABBY_FAKE:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local data = npc:GetData()
    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()
    


    if npc.Type == BotB.Enums.Entities.BABBY_FAKE.TYPE and npc.Variant == BotB.Enums.Entities.BABBY_FAKE.VARIANT then 
        local fakeBabbyPathfinder = npc.Pathfinder
        if npc.State == 0 then
            --Init
            if not sprite:IsPlaying("FakeSpawn") then
                sprite:Play("FakeSpawn")
            end
            if sprite:IsFinished("FakeSpawn") then
                npc.State = 99
                sprite:Play("FakeIdle")
            end
            if data.botbBabbyFakeGotHit == nil then
                data.botbBabbyFakeGotHit = false
                --So if ignored it will also eventually charge at player
                data.botbBabbyFakeChargeTimerMax = math.random(150,210) --Somewhere around 3 seconds, give or take a second (60 frames)
                data.botbBabbyFakeChargeTimer = data.botbBabbyFakeChargeTimerMax --Initialize the timer
                data.botbBabbyFakeDashAngle = 0
                data.botbBabbyFakeSpriteFlipped = false
            end
        end
        --States:
        --99: Idle
        --100: Got hit or timer ran out, initiate dash
        --101: Hit a wall, explode into shots and red creep
        
        if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_WALLS then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
        end

        if npc.State == 99 then
            fakeBabbyPathfinder:MoveRandomly()
            if data.botbBabbyFakeChargeTimer > 0 then
                data.botbBabbyFakeChargeTimer = data.botbBabbyFakeChargeTimer - 1
            end
            --print(data.botbBabbyFakeChargeTimer)
            if data.botbBabbyFakeChargeTimer == 0 or data.botbBabbyFakeGotHit or npc.HitPoints < npc.MaxHitPoints then
                npc.State = 100
                npc:PlaySound(FiendFolio.Sounds.FlashBaby,1,2,false,(math.random(120,140)/100))
                sprite:Play("DashStart")
            end
        end

        if npc.State == 100 then
            npc.Velocity = 0.5*npc.Velocity
            if sprite:IsEventTriggered("Back") then
                npc.State = 101
                data.botbBabbyFakeDashAngle = targetangle % 360
                --Angle time...Oh boy...
                --print(data.botbBabbyFakeDashAngle)
                if data.botbBabbyFakeDashAngle <= 45 and data.botbBabbyFakeDashAngle >= 0 then
                    --print("hori 1")
                    sprite:Play("DashHori")
                elseif data.botbBabbyFakeDashAngle > 45 and data.botbBabbyFakeDashAngle <= 135 then
                    
                    sprite:Play("DashDown")
                elseif data.botbBabbyFakeDashAngle > 135 and data.botbBabbyFakeDashAngle <= 225 then
                    --print("hori 2")
                    sprite:Play("DashHori")
                    data.botbBabbyFakeSpriteFlipped = true
                elseif data.botbBabbyFakeDashAngle > 225 and data.botbBabbyFakeDashAngle <= 315 then
                    sprite:Play("DashUp")
                elseif data.botbBabbyFakeDashAngle > 315 then
                    sprite:Play("DashHori")
                end
                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 5, npc.Position, Vector.Zero, npc)
                npc.Velocity = Vector(4,0):Rotated(data.botbBabbyFakeDashAngle)
            end
        end

        if npc.State == 101 then
            npc.Velocity = 1.15 * npc.Velocity
            if npc:CollidesWithGrid() then
                --Just kill the thing on the spot
                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 5, npc.Position, Vector.Zero, npc)
                local params = ProjectileParams()
                params.VelocityMulti = 2
                --params.BulletFlags = ProjectileFlags.ACID_RED
                game:ShakeScreen(3)
                npc:PlaySound(SoundEffect.SOUND_ROCKET_BLAST_DEATH, 1, 0, false, 1)
                npc:FireBossProjectiles(10, npc.Position, 6, params)
                local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_RED, 0, npc.Position, Vector.Zero, npc):ToEffect()
                creep.SpriteScale = Vector(2.5, 2.5)
                creep:Update()
                npc:BloodExplode()
                npc:Remove()
            end
        end

        if data.botbBabbyFakeSpriteFlipped then
            sprite.FlipX = true
        end

    end
end


Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, BABBY_FAKE.NPCUpdate, Isaac.GetEntityTypeByName("Babby (Fake)"))



function BABBY_FAKE:DamageCheck(npc, _, _, _, _)
    --print("sharb")
    if npc.Type == BotB.Enums.Entities.BABBY_FAKE.TYPE and npc.Variant == BotB.Enums.Entities.BABBY_FAKE.VARIANT then 
        if npc.State == 99 and npc:GetData().botbBabbyFakeGotHit ~= true then
            npc:GetData().botbBabbyFakeGotHit = true
        end
        if npc.State == 100 or npc.State == 101 then
            return false
            --Cant stop it once its charging
        end
    end
end
Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, BABBY_FAKE.DamageCheck, Isaac.GetEntityTypeByName("Babby (Fake)"))