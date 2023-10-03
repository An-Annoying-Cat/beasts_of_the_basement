local Mod = BotB
local BUZZ_FLY = {}
local Familiars = BotB.Enums.Familiars
local Items = BotB.Enums.Items

function BUZZ_FLY:FamiliarUpdate(npc)

    local sprite = npc:GetSprite()
    local data = npc:GetData()
    local room = Game():GetRoom()
    local player = npc.Player


    if npc.Type == Familiars.BUZZ_FLY.TYPE and npc.Variant == Familiars.BUZZ_FLY.VARIANT then 
        --print(npc.State)

        if npc.State == 0 then
            if data.stickDurationMax == nil then
                data.stickDurationMax = 360
                data.stickDuration = data.stickDurationMax
                data.targetChangeCooldownMax = 120
                data.targetChangeCooldown = data.targetChangeCooldownMax
                data.tickRate = 4
            end
            npc.State = 99
            sprite:Play("Idle")
        end


        if player:HasTrinket(TrinketType.TRINKET_FORGOTTEN_LULLABY) then
            data.tickRate = 4
        else
            data.tickRate = 2
        end



        --States
        -- 99 - idle
        -- 100 - dash start
        -- 101 - dashing, hopefully into enemy
        -- 102 - VROOM VROOM MOTHERFUCKER
        if npc.State == 99 then
            npc.Velocity = ((0.995 * npc.Velocity) + (0.005 * (npc.Player.Position - npc.Position))):Clamped(-12,-12,12,12)
            npc:PickEnemyTarget(9999, 120)
            if npc.Target ~= nil then
                npc.Parent = npc.Target
                npc.State = 100
                sprite:Play("DashStart")
            end
        end

        if npc.State == 100 then
            if npc.Parent == nil or npc.Parent:IsDead() then
                data.stickDuration = data.stickDurationMax
                npc.State = 99
                sprite:Play("Idle")
            end
            npc.Velocity = 0.8*npc.Velocity
            if sprite:IsFinished("DashStart") then
                npc.State = 101
                SFXManager():Play(BotB.Enums.SFX.MABELVROOM,4,0,false,1.25,0)
                npc.Velocity = Vector(12,0):Rotated((npc.Parent.Position - npc.Position):GetAngleDegrees())
                sprite:Play("Dash")
            end
        end

        if npc.State == 101 then
            if npc.Parent == nil or npc.Parent:IsDead()then
                data.stickDuration = data.stickDurationMax
                npc.State = 99
                sprite:Play("Idle")
            end
            npc.Position = 0.8*npc.Position + 0.2*npc.Parent.Position
            if (npc.Parent.Position - npc.Position):Length() <= 50 then
                npc.State = 102
            end
        end

        if npc.State == 102 then
            if npc.Parent == nil or npc.Parent:IsDead()then
                data.stickDuration = data.stickDurationMax
                npc.State = 99
                sprite:Play("Idle")
            end
            if npc.Parent ~= nil then
                npc.Position = 0.6*npc.Position + 0.4*npc.Parent.Position
            else
                data.stickDuration = data.stickDurationMax
                npc.State = 99
                sprite:Play("Idle")
            end
            --npc.Velocity = ((0.9 * npc.Velocity) + (0.1 * (npc.Position - npc.Target.Position))):Clamped(-12,-12,12,12)
            
            if npc.FrameCount % data.tickRate == 0 then
                --print("VROOM VROOM MOTHERFUCKER")
                FiendFolio.AddBleed(npc.Parent, npc.Player, data.tickRate * 2, npc.Player.Damage * 0.5, false, true)
                if math.random(0,4) ~= 0 then
                    local tear = Isaac.Spawn(2, 1, 0, npc.Position , Vector.One:Resized(math.random(110,150)/10):Rotated(math.random(0,359)), npc):ToTear()
                    tear:AddTearFlags(TearFlags.TEAR_SPECTRAL)
                    local val = 0.8 + math.random(4) / 10
                    tear.Scale = val
                    tear.CollisionDamage = 1.5 * val
                    tear.FallingSpeed = -10 + math.random(10)
                    
                    tear:Update()
                else
                    local tear = Isaac.Spawn(2, TearVariant.BONE, 0, npc.Position , Vector.One:Resized(math.random(110,150)/10):Rotated(math.random(0,359)), npc):ToTear()
                    tear:AddTearFlags(TearFlags.TEAR_BONE | TearFlags.TEAR_SPECTRAL)
                    local val = 0.8 + math.random(4) / 10
                    tear.Scale = val
                    tear.CollisionDamage = 3.5 * val
                    tear.FallingSpeed = -10 + math.random(10)
                    
                    tear:Update()
                end
            end

            if data.stickDuration ~= 0 then
                data.stickDuration = data.stickDuration - 1
            else
                data.stickDuration = data.stickDurationMax
                npc.State = 99
                sprite:Play("Idle")
            end
            
        end

        if npc.State == 102 then

        end

        if npc.State == 103 then

        end

    end
end


Mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, BUZZ_FLY.FamiliarUpdate, Isaac.GetEntityVariantByName("Buzz Fly"))


--ITEM code

if EID then
	EID:addCollectible(Isaac.GetItemIdByName("Buzz Fly"), "Familiar that targets the enemies that you attack, and proceeds to messily disembowel them, spraying blood, bones, and guts everywhere. #(That is to say, it applies Hemorrhage to the targeted enemy, spreads around red creep, and fires blood and bone tears everywhere.)")
end
--Egocentrism moment

--Stats
function BUZZ_FLY:onCache(player, _)
    --local collectibleRNG = player:GetCollectibleRNG(Isaac.GetItemIdByName("Buzz Fly"))
    --local itemConfig = Isaac.GetItemConfig():GetCollectible(Isaac.GetItemIdByName("Buzz Fly"))
    player:CheckFamiliar(Isaac.GetEntityVariantByName("Buzz Fly"), BotB.Functions.GetExpectedFamiliarNum(player,Items.BUZZ_FLY), player:GetCollectibleRNG(Isaac.GetItemIdByName("Buzz Fly")), Isaac.GetItemConfig():GetCollectible(Isaac.GetItemIdByName("Buzz Fly")))
end
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, BUZZ_FLY.onCache,CacheFlag.CACHE_FAMILIARS)