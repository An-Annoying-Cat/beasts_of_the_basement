local Mod = BotB
local FAITHFUL_FLEET = {}
local Familiars = BotB.Enums.Familiars
local Items = BotB.Enums.Items

function FAITHFUL_FLEET:FamiliarUpdate(npc)

    local sprite = npc:GetSprite()
    local data = npc:GetData()
    local room = Game():GetRoom()
    local player = npc.Player
    local target


    if npc.Type == Familiars.FAITHFUL_FLEET.TYPE and npc.Variant == Familiars.FAITHFUL_FLEET.VARIANT then 
        --print("states is " .. npc.State)

        if npc.State == 0 then
            if data.distThreshold == nil then
                --How close does it have to get before attacking?
                data.distThreshold = 100
                --When attacking it will fire each X frames
                data.zapFrequency = 10
                npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
                --Is it orbiting player?
                data.isFollowing = true
                --Switch to tell code that isfollowing is already changed
                data.isFollowingQueueChange = false
                --npc:AddToFollowers()
                data.isOrbiter = false
                --how mant frames between each fire?
                data.fireCooldownMax = 30
                data.fireCooldown = data.fireCooldownMax
                --the bullet it fires
                data.projectile = nil
                npc.CollisionDamage = 0

            end
            npc.State = 99
            sprite:Play("Inactive")
        end


        if player:HasTrinket(TrinketType.TRINKET_FORGOTTEN_LULLABY) then
            data.zapFrequency = 5
        else
            data.zapFrequency = 10
        end



        --States
        -- 98 - activate
        -- 99 - inactive
        -- 100 - moving, attacking

        -- 101 - attack

        --Inactive
        if npc.State == 99 then
            if room:IsClear() == false then
                --[[
                if data.isOrbiter then
                    npc:RemoveFromOrbit()
                    data.isOrbiter = false
                end
                --]]              
                npc:PickEnemyTarget(9999, 13, 0)
                npc.State = 100
                --sprite:Play("Activate")
            else
                if not data.isOrbiter then
                    npc:AddToOrbit(2)
                    data.isOrbiter = true
                else
                    --npc:FollowParent()
                    npc.Velocity = ((0.75 * npc.Velocity) + (0.25 * (npc:GetOrbitPosition(npc.Player.Position) - npc.Position))):Clamped(-10,-10,10,10)
                end  
            end
            if data.fireCooldown ~= 0 then
                data.fireCooldown = data.fireCooldown - 1
            end
        end

        --Activate
        if npc.State == 98 then
            if sprite:IsEventTriggered("Back") then
                npc.State = 100
                --sprite:Play("PursuitDown")
            end
        end

        if npc.State == 100 then
            if npc.Target ~= nil then
                npc.Velocity = ((0.9 * npc.Velocity) + (0.1 * (npc:GetOrbitPosition(npc.Target.Position) - npc.Position))):Clamped(-12,-12,12,12)

                data.animAngle = -((npc.Target.Position - npc.Position):GetAngleDegrees()) % 360
                --print("angle should be " .. data.animAngle)
                --print("current anim is " .. sprite:GetAnimation())

                if (data.animAngle <= 22.5 and data.animAngle >= 0) or (data.animAngle >= 337.5 and data.animAngle > 360) then
                    --facing right
                    if sprite:GetAnimation() ~= "PursuitRight" then
                        sprite:Play("PursuitRight")
                    end
                elseif (data.animAngle <= 157.5 and data.animAngle > 22.5) then
                    --all the ones where the eye would realistically not show
                    if sprite:GetAnimation() ~= "PursuitBack" then
                        sprite:Play("PursuitBack")
                    end
                elseif (data.animAngle <= 202.5 and data.animAngle > 157.5) then
                    --facing left
                    if sprite:GetAnimation() ~= "PursuitLeft" then
                        sprite:Play("PursuitLeft")
                    end
                elseif (data.animAngle <= 247.5 and data.animAngle > 202.5) then
                    --facing down-left
                    if sprite:GetAnimation() ~= "PursuitDownLeft" then
                        sprite:Play("PursuitDownLeft")
                    end
                elseif (data.animAngle <= 292.5 and data.animAngle > 247.5) then
                    --facing down
                    if sprite:GetAnimation() ~= "PursuitDown" then
                        sprite:Play("PursuitDown")
                    end
                elseif (data.animAngle <= 337.5 and data.animAngle > 292.5) then
                    --facing down-right
                    if sprite:GetAnimation() ~= "PursuitDownRight" then
                        sprite:Play("PursuitDownRight")
                    end
                end

                if (npc.Target.Position - npc.Position):Length() <= data.distThreshold then
                    --npc.Velocity = 0.995 * npc.Velocity
                    npc.Velocity = ((0.95 * npc.Velocity) + (0.05 * (npc:GetOrbitPosition(npc.Target.Position) - npc.Position))):Clamped(-10,-10,10,10)
                    if data.fireCooldown ~= 0 then
                        data.fireCooldown = data.fireCooldown - 1
                    else
                        --[[
                        data.projectile = npc:FireProjectile(Vector(2,0):Rotated((npc.Target.Position - npc.Position):GetAngleDegrees()))
                        data.projectile.CollisionDamage = npc.Player.Damage * 0.3
                        data.projectile.TearFlags = npc.Player.TearFlags
                        data.projectile.Color = npc.Player.TearColor
                        sfx:Play(SoundEffect.SOUND_TEARS_FIRE, 0.5, 0, false, math.random(125,175)/100)
                        --]]
                        local params = npc.Player:GetTearHitParams(WeaponType.WEAPON_TEARS, 1, 1, nil)


                        local newTear = Isaac.Spawn(EntityType.ENTITY_TEAR, params.TearVariant, 0, npc.Position, Vector(7.5,0):Rotated((npc.Target.Position - npc.Position):GetAngleDegrees()), npc):ToTear()
                        newTear.CollisionDamage = npc.Player.Damage * 0.3
                        newTear.TearFlags = npc.Player.TearFlags | TearFlags.TEAR_SPECTRAL
                        newTear.Color = npc.Player.TearColor
                        data.fireCooldown = data.fireCooldownMax
                    end
                end
            else
                npc.State = 101
            end
        end

        if npc.State == 101 then
            if room:IsClear() == false then
                --[[
                if data.isOrbiter then
                    npc:RemoveFromOrbit()
                    data.isOrbiter = false
                end
                --]]              
                npc:PickEnemyTarget(9999, 13, 0)
                npc.State = 100
            else
                if not data.isOrbiter then
                    npc:AddToOrbit(2)
                    data.isOrbiter = true
                else
                    --npc:FollowParent()
                    npc.Velocity = ((0.75 * npc.Velocity) + (0.25 * (npc:GetOrbitPosition(npc.Player.Position) - npc.Position))):Clamped(-10,-10,10,10)
                end
                npc.State = 99
                sprite:Play("Inactive")
            end
            if data.fireCooldown ~= 0 then
                data.fireCooldown = data.fireCooldown - 1
            end
        end

    end
end


Mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, FAITHFUL_FLEET.FamiliarUpdate, Isaac.GetEntityVariantByName("Faithful Fleet"))


--ITEM code

if EID then
	EID:addCollectible(Isaac.GetItemIdByName("Faithful Fleet"), "Set of 4 familiars that automatically seek out and fire at enemies, inheriting the player's tear effects and 0.3x their damage. #Familiars orbit player in completed rooms.")
end
--Egocentrism moment

--Stats
function FAITHFUL_FLEET:onCache(player, _)
    --local collectibleRNG = player:GetCollectibleRNG(Isaac.GetItemIdByName("Faithful Fleet"))
    --local itemConfig = Isaac.GetItemConfig():GetCollectible(Isaac.GetItemIdByName("Faithful Fleet"))
    player:CheckFamiliar(Isaac.GetEntityVariantByName("Faithful Fleet"), (BotB.Functions.GetExpectedFamiliarNum(player,Items.FAITHFUL_FLEET)) * 4, player:GetCollectibleRNG(Isaac.GetItemIdByName("Faithful Fleet")), Isaac.GetItemConfig():GetCollectible(Isaac.GetItemIdByName("Faithful Fleet")))
end
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, FAITHFUL_FLEET.onCache,CacheFlag.CACHE_FAMILIARS)