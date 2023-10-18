local Mod = BotB
local YEET_A_BABY = {}
local Familiars = BotB.Enums.Familiars
local Items = BotB.Enums.Items

function YEET_A_BABY:FamiliarUpdate(npc)

    local sprite = npc:GetSprite()
    local data = npc:GetData()
    local room = Game():GetRoom()
    local player = npc.Player:ToPlayer()

    if npc.Type == Familiars.YEET_A_BABY.TYPE and npc.Variant == Familiars.YEET_A_BABY.VARIANT then 
        --print(npc.State)

        if npc.State == 0 then
            if data.distThreshold == nil then
                --How close does it have to get before attacking?
                data.distThreshold = 100
                npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
                --say to the tune of doofenshmirtz evil incorporated
                --data.InsivibleIntangibleCubeBaby
            end
            npc.State = 99
            sprite:Play("Idle")
        end
        
        


        --States
        -- 99 - idle
        -- 100 - moving
        -- 101 - attack start
        -- 102 - attacking
        -- 103 - attack end
        if data.botbInvisibleIntangibleCubeBaby == nil then
            data.botbInvisibleIntangibleCubeBaby = Isaac.Spawn(EntityType.ENTITY_FAMILIAR,FamiliarVariant.CUBE_BABY,0,npc.Position,Vector.Zero,npc):ToFamiliar()
            data.botbInvisibleIntangibleCubeBaby.Visible = false
            data.botbInvisibleIntangibleCubeBaby:GetData().botbIsAnInvisibleIntangibleCubeBaby = true
            data.botbInvisibleIntangibleCubeBaby:GetSprite().Color = Color(1,1,1,0)
            data.botbInvisibleIntangibleCubeBaby.Parent = npc
            npc.Position = data.botbInvisibleIntangibleCubeBaby.Position
        else
            npc.Position = data.botbInvisibleIntangibleCubeBaby.Position
        end
        data.botbInvisibleIntangibleCubeBaby.Visible = false
        data.botbInvisibleIntangibleCubeBaby.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        npc.DepthOffset = 9999
        npc.CollisionDamage = npc.Velocity:Length()/2
        --print(data.botbInvisibleIntangibleCubeBaby.Velocity:Length())
        if npc.State == 99 then
            if npc.SpriteOffset ~= Vector.Zero then
                npc.SpriteOffset = npc.SpriteOffset * 0.8
            end
            if room:IsClear() == false then
                --[[  
                npc:PickEnemyTarget(1000, 13, 0)
                if (npc.Target.Position - npc.Position):Length() <= data.distThreshold then
                    npc.State = 100
                end]]
            end
           --
            if (npc.Player.Position - npc.Position):Length() <= 40 and data.botbInvisibleIntangibleCubeBaby.Velocity:Length() <= 5 then
                
                --npc:AddEntityFlags(EntityFlag.FLAG_HELD)
                player:TryHoldEntity(data.botbInvisibleIntangibleCubeBaby)
                print("pick me up pls")
                npc.State = 101
            end
        end

        if npc.State == 100 then
            print("dinkler")
            npc.State = 99
        end

        if npc.State == 101 then
            print("kunkler")
            npc.SpriteOffset = Vector(0,-30)
            if (npc.Player.Position - npc.Position):Length() >= 40 then
                npc.State = 99
            end
            
        end

    end
end


Mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, YEET_A_BABY.FamiliarUpdate, Isaac.GetEntityVariantByName("Yeet-a-baby"))


--ITEM code

if EID then
	EID:addCollectible(Isaac.GetItemIdByName("Yeet-a-baby"), "Familiar that automatically targets enemies within range. #As its name suggests, it can also be picked up and thrown.")
end
--Egocentrism moment

--Stats
function YEET_A_BABY:onCache(player, _)
    --local collectibleRNG = player:GetCollectibleRNG(Isaac.GetItemIdByName("Yeet-a-baby"))
    --local itemConfig = Isaac.GetItemConfig():GetCollectible(Isaac.GetItemIdByName("Yeet-a-baby"))
    player:CheckFamiliar(Isaac.GetEntityVariantByName("Yeet-a-baby"), BotB.Functions.GetExpectedFamiliarNum(player,Items.YEET_A_BABY), player:GetCollectibleRNG(Isaac.GetItemIdByName("Yeet-a-baby")), Isaac.GetItemConfig():GetCollectible(Isaac.GetItemIdByName("Yeet-a-baby")))
end
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, YEET_A_BABY.onCache,CacheFlag.CACHE_FAMILIARS)


function YEET_A_BABY:getTheGoddamnedBaby()
    local roomEntities = Isaac.GetRoomEntities() -- table
    local locationsToCheckFrom = {}
    for i = 1, #roomEntities do
        local entity = roomEntities[i]
        if entity:GetData().botbIsAnInvisibleIntangibleCubeBaby == true then
            locationsToCheckFrom[#locationsToCheckFrom+1] = entity.Position
        end
    end
    return locationsToCheckFrom
end


function YEET_A_BABY:removeStuffMadeByTheInvisibleBaby(effect)
    --print(effect.Type,effect.Variant)
    --get the damn baby
    
    if effect.Variant == 54 or effect.Variant == 59 then
        local checkPositions = YEET_A_BABY:getTheGoddamnedBaby()
        for i=1,#checkPositions do
            if (effect.Position - checkPositions[i]):Length() <= 40 then
                effect:Remove()
            end
        end
    end
    
    --[[
    if effect.SpawnerEntity ~= nil and effect.SpawnerEntity:GetData().botbIsAnInvisibleIntangibleCubeBaby == true then
        effect:Remove()
    end]]
end
Mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, YEET_A_BABY.removeStuffMadeByTheInvisibleBaby)



