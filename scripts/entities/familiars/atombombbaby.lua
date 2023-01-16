local Mod = BotB
local ATOMBOMBBABY = {}
local Familiars = BotB.Enums.Familiars
local Items = BotB.Enums.Items

function ATOMBOMBBABY:FamiliarUpdate(npc)

    local sprite = npc:GetSprite()
    local data = npc:GetData()
    local room = Game():GetRoom()
    local player = npc.Player


    if npc.Type == Familiars.ATOMBOMBBABY.TYPE and npc.Variant == Familiars.ATOMBOMBBABY.VARIANT then 
        --print(npc.State)

        if npc.State == 0 then
            if data.statusDist == nil then
                --Within what radius does it inflict the status?
                data.statusDist = 150
                data.respawnTimerMax = 300
                data.respawnTimer = data.respawnTimerMax
                data.radiationDamage = 0.05
                --Spawn the aura
                data.abbAura = Isaac.Spawn(EntityType.ENTITY_EFFECT, BotB.Enums.Entities.ABB_AURA.VARIANT, 0, npc.Position, Vector.Zero, npc):ToEffect()
                data.abbAura.Parent = npc
                data.abbAura.Timeout = 1
                data.abbAura.SortingLayer = SortingLayer.SORTING_BACKGROUND
                npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
                npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                npc.MaxHitPoints = 600
                npc.HitPoints = npc.MaxHitPoints
            end
            npc.State = 99
            sprite:Play("Idle")
        end


        



        --States
        -- 99 - idle
        -- 100 - kaboom
        -- 101 - invisible
        -- 102 - respawn
        if npc.State == 99 then

            if player:HasTrinket(TrinketType.TRINKET_FORGOTTEN_LULLABY) then
                npc.CollisionDamage = 5
            else
                npc.CollisionDamage = 2.5
            end

            npc:MoveDiagonally(0.75)
            if not data.abbAura:Exists() then
                data.abbAura = Isaac.Spawn(EntityType.ENTITY_EFFECT, BotB.Enums.Entities.ABB_AURA.VARIANT, 0, npc.Position, Vector.Zero, npc):ToEffect()
                data.abbAura.Parent = npc
                data.abbAura.Timeout = 1
                data.abbAura.SortingLayer = SortingLayer.SORTING_BACKGROUND
            end
            data.abbAura.Position = data.abbAura.Parent.Position
            data.abbAura.Timeout = data.abbAura.Timeout + 1
            if npc.HitPoints <= 2 then
                npc.State = 100
                sprite:Play("Explode")
            end

            for i, entity in ipairs(Isaac.GetRoomEntities()) do
                if entity:IsActiveEnemy(false) and entity:IsVulnerableEnemy() then
                    if (entity.Position - npc.Position):Length() <= data.statusDist then
                        if not entity:HasEntityFlags(EntityFlag.FLAG_WEAKNESS) then
                            entity:AddEntityFlags(EntityFlag.FLAG_WEAKNESS)
                        end
                        --if npc.FrameCount % 2 == 0 then
                            --entity:AddEntityFlags(EntityFlag.FLAG_NO_FLASH_ON_DAMAGE)
                            entity:TakeDamage(data.radiationDamage,DamageFlag.DAMAGE_NOKILL | DamageFlag.DAMAGE_IGNORE_ARMOR,EntityRef(npc),0)
                            --entity:ClearEntityFlags(EntityFlag.FLAG_NO_FLASH_ON_DAMAGE)
                        --end
                        npc.HitPoints = npc.HitPoints - 1
                    end
                end
            end

        end

        if npc.State == 100 then
            if sprite:IsEventTriggered("Back") then
                data.abbAura:Remove()
                local abbBomb = Isaac.Spawn(EntityType.ENTITY_BOMB, BombVariant.BOMB_BIG, 0, npc.Position, Vector.Zero, npc):ToBomb()
                abbBomb.Color = Color(0,0,0,0)
                abbBomb:AddTearFlags(TearFlags.TEAR_BUTT_BOMB)
                abbBomb.RadiusMultiplier = 1.5
                abbBomb.ExplosionDamage = 185
                abbBomb:SetExplosionCountdown(1)
                data.respawnTimer = data.respawnTimerMax
                npc.CollisionDamage = 0
                npc.State = 101
                sprite:Play("Invis")
            end
        end

        if npc.State == 101 then
            npc.Velocity = Vector.Zero
            if data.respawnTimer == 0 then
                if player:HasTrinket(TrinketType.TRINKET_FORGOTTEN_LULLABY) then
                    npc.CollisionDamage = 5
                else
                    npc.CollisionDamage = 2.5
                end
                local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.POOF01,0,npc.Position,Vector(0,0),npc)
                data.abbAura = Isaac.Spawn(EntityType.ENTITY_EFFECT, BotB.Enums.Entities.ABB_AURA.VARIANT, 0, npc.Position, Vector.Zero, npc):ToEffect()
                data.abbAura.Parent = npc
                data.abbAura.Timeout = 1
                data.abbAura.SortingLayer = SortingLayer.SORTING_BACKGROUND
                data.abbAura.Position = data.abbAura.Parent.Position
                sfx:Play(BotB.FF.Sounds.FunnyFart,0.25,0,false,1)
                npc.State = 102
                sprite:Play("Respawn")
            else
                data.respawnTimer = data.respawnTimer - 1
            end
            npc.HitPoints = npc.MaxHitPoints
        end

        if npc.State == 102 then
            if sprite:IsEventTriggered("Back") then
                
                npc.MaxHitPoints = 600
                npc.HitPoints = npc.MaxHitPoints
                npc.State = 99
                sprite:Play("Idle")
            end
        end



    end
end
Mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, ATOMBOMBBABY.FamiliarUpdate, Isaac.GetEntityVariantByName("Atom Bomb Baby"))


--ITEM code

if EID then
	EID:addCollectible(Isaac.GetItemIdByName("Atom Bomb Baby"), "Familiar that moves diagonally, weakening enemies and dealing very low, but never fatal, armor-piercing damage extremely rapidly in a radius around it. #After dealing enough damage this way, the familiar will explode identically to a bomb with {{Collectible".. Isaac.GetItemIdByName("Mr. Mega") .."}} Mr. Mega and {{Collectible".. Isaac.GetItemIdByName("Butt Bombs") .."}} Butt Bombs. #Familiar respawns a short while afterward.")
end
--Egocentrism moment

--Stats
function ATOMBOMBBABY:onCache(player, _)
    --local collectibleRNG = player:GetCollectibleRNG(Isaac.GetItemIdByName("Atom Bomb Baby"))
    --local itemConfig = Isaac.GetItemConfig():GetCollectible(Isaac.GetItemIdByName("Atom Bomb Baby"))
    player:CheckFamiliar(Isaac.GetEntityVariantByName("Atom Bomb Baby"), BotB.Functions.GetExpectedFamiliarNum(player,Items.ATOMBOMBBABY), player:GetCollectibleRNG(Isaac.GetItemIdByName("Atom Bomb Baby")), Isaac.GetItemConfig():GetCollectible(Isaac.GetItemIdByName("Atom Bomb Baby")))
end
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, ATOMBOMBBABY.onCache, CacheFlag.CACHE_FAMILIARS)

--player:GetCollectibleNum(Items.ATOMBOMBBABY, false) + player:GetEffects():GetCollectibleEffectNum(Items.ATOMBOMBBABY)