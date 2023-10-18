local Mod = BotB
local BUGGY_BABY = {}
local Familiars = BotB.Enums.Familiars
local Items = BotB.Enums.Items

function BUGGY_BABY:FamiliarUpdate(npc)

    local sprite = npc:GetSprite()
    local data = npc:GetData()
    local room = Game():GetRoom()
    local player = npc.Player


    if npc.Type == Familiars.BUGGY_BABY.TYPE and npc.Variant == Familiars.BUGGY_BABY.VARIANT then 
        --print(npc.State)

        if npc.State == 0 then
            if data.distThreshold == nil then
                --How close does it have to get before attacking?
                data.distThreshold = 100
                --When attacking it will spawn chain lightning each X frames
                data.zapFrequency = 10
                npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
                --Is it following player?
                data.isFollowing = true
                --Switch to tell code that isfollowing is already changed
                data.isFollowingQueueChange = false
                --npc:AddToFollowers()
            end
            npc.State = 99
            if npc.IsFollower then
                npc:RemoveFromFollowers()
            end   
            sprite:Play("Idle")
        end


        if player:HasTrinket(TrinketType.TRINKET_FORGOTTEN_LULLABY) then
            data.zapFrequency = 5
        else
            data.zapFrequency = 10
        end



        --States
        -- 99 - idle
        -- 100 - teleport out
        -- 101 - teleport in
        npc.Velocity = Vector.Zero
        if npc.State == 99 then
            sprite:Stop()
            if Input.IsActionPressed(ButtonAction.ACTION_SHOOTLEFT, npc.Player.ControllerIndex) or Input.IsActionPressed(ButtonAction.ACTION_SHOOTRIGHT, npc.Player.ControllerIndex) or Input.IsActionPressed(ButtonAction.ACTION_SHOOTUP, npc.Player.ControllerIndex) or Input.IsActionPressed(ButtonAction.ACTION_SHOOTDOWN, npc.Player.ControllerIndex) then
                sprite:Play("Out")
                npc.State = 100
            end
            if math.random(1,32) == 1 then
                for i = 1, 2 do
                    BotB.FF.scheduleForUpdate(function()
                        if i==1 then
                            sprite:SetOverlayFrame("Glitch", math.random(1,8))
                        end
                        if i==2 then
                            sprite:SetOverlayFrame("Glitch", 9)
                        end
                    end, i, ModCallbacks.MC_POST_RENDER)
                end
            end
        end

        if npc.State ~= 99 then
            sprite.PlaybackSpeed = 2
        else
            sprite.PlaybackSpeed = 1
        end

        if npc.State == 100 then
            if sprite:IsEventTriggered("Teleport") then
                npc.Position = Game():GetRoom():GetRandomPosition(20)
                --Game():ShakeScreen(2)
                local roomEntities = Isaac.GetRoomEntities() -- table
                for i = 1, #roomEntities do
                    local entity = roomEntities[i]
                    if (entity.Position - npc.Position):Length() <= 120 then
                        if entity:IsVulnerableEnemy() and EntityRef(entity).IsFriendly ~= true then
                            entity:TakeDamage(npc.Player.Damage/3, 0, EntityRef(npc), 0)
                            if math.random(0,4) == 0 and entity:IsVulnerableEnemy() == true and EntityRef(entity).IsFriendly ~= true then
                                entity:GetData().botbHasGlitched = true
                                entity:GetData().botbGlitchedSource = player
                            end
                        end
                    end
                end
                SFXManager():Play(BotB.Enums.SFX.GLITCH_NOISE,0.125,0,false,math.random(75,125)/100)
            end
            if sprite:IsFinished("Out") then
                npc.State = 101
                sprite:Play("In")
            end
        end
        if npc.State == 101 then
            if sprite:IsFinished("In") then
                npc.State = 99
                sprite:Play("Idle")
            end
        end
    end
end
Mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, BUGGY_BABY.FamiliarUpdate, Isaac.GetEntityVariantByName("Buggy Baby"))


--ITEM code

if EID then
	EID:addCollectible(Isaac.GetItemIdByName("Buggy Baby"), "Familiar that teleports around the room while the player is firing, dealing contact damage and occasionally inflicting {{StatusGlitched}} Glitched on whatever it ends up teleporting near.")
end
--Egocentrism moment

--Stats
function BUGGY_BABY:onCache(player, _)
    --local collectibleRNG = player:GetCollectibleRNG(Isaac.GetItemIdByName("Buggy Baby"))
    --local itemConfig = Isaac.GetItemConfig():GetCollectible(Isaac.GetItemIdByName("Buggy Baby"))
    player:CheckFamiliar(Isaac.GetEntityVariantByName("Buggy Baby"), BotB.Functions.GetExpectedFamiliarNum(player,Items.BUGGY_BABY), player:GetCollectibleRNG(Isaac.GetItemIdByName("Buggy Baby")), Isaac.GetItemConfig():GetCollectible(Isaac.GetItemIdByName("Buggy Baby")))
end
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, BUGGY_BABY.onCache,CacheFlag.CACHE_FAMILIARS)