--WIP!!!!!

local Mod = BotB
local NEEDLESPIANO = {}
local Familiars = BotB.Enums.Familiars
local Items = BotB.Enums.Items
--Forgive me, but I have to do this so they all work at once (same direction)
local needlesPianoPressDirection = 0

function NEEDLESPIANO:checkShootDirInput(pressDir)
    --Returns a boolean comparing player input to needles piano variable
    --pressDir is the right direction
    if Input.IsActionTriggered(ButtonAction.ACTION_SHOOTLEFT, 0) then
        if pressDir == 0 then
            needlesPianoPressDirection = math.random(0,3)
            return true
        else
            return false
        end
    elseif Input.IsActionTriggered(ButtonAction.ACTION_SHOOTRIGHT, 0) then
        if pressDir == 1 then
            needlesPianoPressDirection = math.random(0,3)
            return true
        else
            return false
        end
    elseif Input.IsActionTriggered(ButtonAction.ACTION_SHOOTUP, 0) then
        if pressDir == 2 then
            needlesPianoPressDirection = math.random(0,3)
            return true
        else
            return false
        end
    elseif Input.IsActionTriggered(ButtonAction.ACTION_SHOOTDOWN, 0) then
        if pressDir == 3 then
            needlesPianoPressDirection = math.random(0,3)
            return true
        else
            return false
        end
    end
end

function NEEDLESPIANO:FamiliarUpdate(npc)

    local sprite = npc:GetSprite()
    local data = npc:GetData()
    local room = Game():GetRoom()
    local player = npc.Player


    if npc.Type == Familiars.NEEDLESPIANO.TYPE and npc.Variant == Familiars.NEEDLESPIANO.VARIANT then 
        --print(npc.State)

        if npc.State == 0 then
            if data.needlesDir == nil then
                --Collectively set
                data.needlesDir = needlesPianoPressDirection
            end
            npc.State = 99
            sprite:Play("Idle")
            if data.needlesDir == 0 then
                sprite:PlayOverlay("Left")
            elseif data.needlesDir == 0 then
                sprite:PlayOverlay("Right")
            elseif data.needlesDir == 0 then
                sprite:PlayOverlay("Up")
            elseif data.needlesDir == 0 then
                sprite:PlayOverlay("Down")
            end
            if not npc.IsFollower then
                npc:AddToFollowers()
            end  
                
        end


        if player:HasTrinket(TrinketType.TRINKET_FORGOTTEN_LULLABY) then
            --Iunno, damage up?
        end



        --States
        -- 99 - idle
        -- 100 - correct input
        -- 101 - wrong input
        if npc.State == 99 then
            npc:FollowParent()
            if NEEDLESPIANO.checkShootDirInput(needlesPianoPressDirection) then
                npc.State = 100
            else
                npc.State = 101
                sprite:PlayOverlay("Incorrect")
            end
        end

        if npc.State == 100 then
            sfx:Play(SoundEffect.SOUND_MEATHEADSHOOT,1,0,false,1.3)
            local needleProjectile = npc:FireProjectile(Dir)
        end

        if npc.State == 101 then
            if sprite:IsEventTriggered("Back") then
                npc.State = 99
                sprite:Play("Idle")
            end
        end

    end
end


Mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, NEEDLESPIANO.FamiliarUpdate, Isaac.GetEntityVariantByName("Needles Piano"))


--ITEM code

if EID then
	EID:addCollectible(Isaac.GetItemIdByName("Needles Piano"), "Familiar that, when the shooting direction of the arrow hovering about it is pressed, fires a homing spectral tear at the nearest enemy. #{{Warning}} Pressing a shoot direction not corresponding to the arrow disables the familiar for a few moments.")
end
--Egocentrism moment

--Stats
function NEEDLESPIANO:onCache(player, cacheFlag)
	if not player:HasCollectible(Items.NEEDLESPIANO) then return end
	if (cacheFlag&CacheFlag.CACHE_FAMILIARS)==CacheFlag.CACHE_FAMILIARS then
        local collectibleRNG = player:GetCollectibleRNG(Isaac.GetItemIdByName("Needles Piano"))
        local itemConfig = Isaac.GetItemConfig():GetCollectible(Isaac.GetItemIdByName("Needles Piano"))
        player:CheckFamiliar(Isaac.GetEntityVariantByName("Needles Piano"), player:GetCollectibleNum(Items.NEEDLESPIANO, false), collectibleRNG, itemConfig)
	end
end
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, NEEDLESPIANO.onCache)