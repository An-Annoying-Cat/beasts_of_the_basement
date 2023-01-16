local Mod = BotB
local BHF = {}
local Familiars = BotB.Enums.Familiars
local Items = BotB.Enums.Items

local function gridInRadius(grid, pos, radius)
	local x1 = grid.Position.X - 20
	local x2 = grid.Position.X + 20
	local y1 = grid.Position.Y - 20
	local y2 = grid.Position.Y + 20
	
    local xn = math.max(x1, math.min(pos.X, x2))
    local yn = math.max(y1, math.min(pos.Y, y2))
	
    local dx = xn - pos.X
    local dy = yn - pos.Y
	
    return (dx ^ 2 + dy ^ 2) <= radius ^ 2
end

function BHF:FamiliarUpdate(npc)

    local sprite = npc:GetSprite()
    local data = npc:GetData()
    local room = Game():GetRoom()
    local player = npc.Player


    if npc.Type == Familiars.BHF.TYPE and npc.Variant == Familiars.BHF.VARIANT then 
        --print(npc.State)

        if npc.State == 0 then
            if data.triggerDist == nil then
                --Within what radius does it go KAPOOF?
                data.triggerDist = 50
                data.respawnTimerMax = 300
                data.respawnTimer = data.respawnTimerMax
                npc.MaxHitPoints = 0
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
                npc:MoveDiagonally(1.5)
            else
                npc:MoveDiagonally(1)
            end
            for i, entity in ipairs(Isaac.GetRoomEntities()) do
                if entity:IsActiveEnemy(false) and entity:IsVulnerableEnemy() then
                    if (entity.Position - npc.Position):Length() <= data.triggerDist then
                        sfx:Play(BotB.Enums.SFX.BHF_EXPLODE_PREPARE,0.5,0,false,1.2)
                        npc.Velocity = Vector.Zero
                        npc.State = 100
                        sprite:Play("Explode")
                    end
                end
            end

        end

        if npc.State == 100 then
            npc.Velocity = Vector.Zero
            if sprite:IsEventTriggered("Explode") then
                sfx:Stop(BotB.Enums.SFX.BHF_EXPLODE_PREPARE)
                sfx:Play(BotB.Enums.SFX.BHF_EXPLODE,1,0,false,1.2)
                sfx:Play(SoundEffect.SOUND_BLACK_POOF,3,0,false,0.8)
                --[[
                local bhfBomb = Isaac.Spawn(EntityType.ENTITY_BOMB, BombVariant.BOMB_BIG, 0, npc.Position, Vector.Zero, npc):ToBomb()
                bhfBomb.Parent = npc
                bhfBomb.Color = Color(0,0,0,0)
                bhfBomb:AddTearFlags(TearFlags.TEAR_ICE|TearFlags.TEAR_NO_GRID_DAMAGE|TearFlags.TEAR_SLOW)
                bhfBomb.RadiusMultiplier = 1.25
                bhfBomb.ExplosionDamage = 100
                print(bhfBomb.Parent.Name)
                --]]
                Game():BombDamage(npc.Position, 60, 120, true, npc, TearFlags.TEAR_ICE|TearFlags.TEAR_NO_GRID_DAMAGE|TearFlags.TEAR_SLOW, nil, npc)
                Game():ButterBeanFart(npc.Position, 240, npc, false, true)
                local explosionRadius = 120
                local madeBridge = false
                for x = math.ceil(explosionRadius / 40) * -1, math.ceil(explosionRadius / 40) do
                    for y = math.ceil(explosionRadius / 40) * -1, math.ceil(explosionRadius / 40) do
                        local grid = room:GetGridEntityFromPos(Vector(npc.Position.X + 40 * x, npc.Position.Y + 40 * y))
                        if grid and grid:ToPit() then
                            local pit = grid:ToPit()
                            if gridInRadius(pit, npc.Position, explosionRadius) then
                                pit:MakeBridge(nil)
                                madeBridge = true
                            end
                        end
                    end
                end
                
                if madeBridge then
                    sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE, 1.0, 0, false, 1.0)
                end
                --bhfBomb:SetExplosionCountdown(0)
                sfx:Stop(SoundEffect.SOUND_EXPLOSION_WEAK)
                sfx:Stop(SoundEffect.SOUND_EXPLOSION_STRONG)



            end
            if sprite:IsEventTriggered("Back") then
                data.respawnTimer = data.respawnTimerMax
                npc.CollisionDamage = 0
                npc.State = 101
                sprite:Play("Invis")
            end
        end

        if npc.State == 101 then
            npc.Velocity = Vector.Zero
            if data.respawnTimer == 0 then
                local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.POOF01,0,npc.Position,Vector(0,0),npc)
                sfx:Play(SoundEffect.SOUND_HAPPY_RAINBOW,0.25,0,false,1.5)
                sfx:Play(BotB.Enums.SFX.BHF_RESPAWN,0.5,0,false,1.2)
                npc.State = 102
                sprite:Play("Appear")
            else
                data.respawnTimer = data.respawnTimer - 1
            end
            npc.HitPoints = npc.MaxHitPoints
        end

        if npc.State == 102 then
            npc.Velocity = Vector.Zero
            if sprite:IsEventTriggered("Back") then
                
                npc.MaxHitPoints = 0
                npc.HitPoints = npc.MaxHitPoints
                npc.State = 99
                sprite:Play("Fly")
            end
        end



    end
end
Mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, BHF.FamiliarUpdate, Isaac.GetEntityVariantByName("B.H.F."))


--ITEM code

if EID then
	EID:addCollectible(Isaac.GetItemIdByName("B.H.F."), "Grants a familiar based on a Shy Fly from Revelations, which bounces around the room diagonally. #When coming into contact with an enemy, it will explode in a manner that does not harm the player. #This explosion will fill in pits, slow enemies, freeze enemies that it kills, and apply large amounts of knockback, but will not break rocks or open secret rooms.")
end

--Stats
function BHF:onCache(player, _)
    --local collectibleRNG = player:GetCollectibleRNG(Isaac.GetItemIdByName("B.H.F."))
    --local itemConfig = Isaac.GetItemConfig():GetCollectible(Isaac.GetItemIdByName("B.H.F."))
    player:CheckFamiliar(Isaac.GetEntityVariantByName("B.H.F."), BotB.Functions.GetExpectedFamiliarNum(player,Items.BHF), player:GetCollectibleRNG(Isaac.GetItemIdByName("B.H.F.")), Isaac.GetItemConfig():GetCollectible(Isaac.GetItemIdByName("B.H.F.")))
end
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, BHF.onCache, CacheFlag.CACHE_FAMILIARS)

--player:GetCollectibleNum(Items.BHF, false) + player:GetEffects():GetCollectibleEffectNum(Items.BHF)



function BHF:noPlayerExplodeDamage(_, _, _, source)
    print(source)
    --local realSource = source.Entity
    --print("cocks")
    if source.Variant == Familiars.BHF.VARIANT then
        return false
    end
    
end

Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, BHF.noPlayerExplodeDamage, EntityType.ENTITY_PLAYER)