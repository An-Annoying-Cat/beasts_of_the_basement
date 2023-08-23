local Mod = BotB
local CURSED_MULLIBOOM = {}
local Entities = BotB.Enums.Entities

function CURSED_MULLIBOOM:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local data = npc:GetData()
    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()
    local cursedMulliganPathfinder = npc.Pathfinder
    local game = Game()


    if npc.Type == BotB.Enums.Entities.CURSED_MULLIBOOM.TYPE and npc.Variant == BotB.Enums.Entities.CURSED_MULLIBOOM.VARIANT then 
        --States:
        --99: Flee
        --102: Teleport out
        --103: Teleport in
        if data.cursedMulliganSelfTeleportCooldownMax == nil then
            data.cursedMulliganSelfTeleportCooldownMax = 360
            data.cursedMulliganSelfTeleportCooldown = data.cursedMulliganSelfTeleportCooldownMax + math.random(0,100)
        end

        if npc.State == 102 or npc.State == 103 then
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        else
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        end

        if npc.State == 100 or npc.State == 101 then
            data.cursedHorfDoTeleportOnHurt = true
        else
            if data.cursedHorfDoTeleportOnHurt ~= false then
                data.cursedHorfDoTeleportOnHurt = false
            end
        end
        if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_GROUND then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
        end
        if npc.State == 0 then
            --Init
            
            if not sprite:IsPlaying("AppearBoom") then
                sprite:Play("AppearBoom")
            end
            if sprite:IsFinished("AppearBoom") then
                npc.State = 99
                sprite:PlayOverlay("WalkOpenEye")
            end
        end

        if npc.State ~= 99 then
            sprite:PlayOverlay("Wait")
        end

        if npc.State == 99 then
            npc:AnimWalkFrame("WalkHori", "WalkVert", 1)
            cursedMulliganPathfinder:FindGridPath(targetpos, 1, 999, true)
            if targetdistance < 75 then
                npc.State = 102
                data.cursedMulliganSelfTeleportCooldown = data.cursedMulliganSelfTeleportCooldownMax
                sprite:Play("TeleOutBoom")
                sprite:PlayOverlay("Wait")
            end
        end

        if npc.State == 102 then
            if sprite:IsEventTriggered("Land") then
                
            end
            if sprite:IsEventTriggered("Teleport") then
                --local cursedMulliboomExplosion = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.BOMB_EXPLOSION,0,npc.Position, Vector.Zero,npc)
                --game:BombExplosionEffects(npc.Position,1,TearFlags.TEAR_GOLDEN_BOMB,Color(0,1,1,1), npc, 1, true, false, DamageFlag.DAMAGE_EXPLOSION)
                local cursedMulliboomLandingBomb = Isaac.Spawn(EntityType.ENTITY_BOMB,BombVariant.BOMB_SMALL,0,npc.Position,Vector.Zero,npc):ToBomb()
                ---cursedMulliboomLandingBomb:AddTearFlags(TearFlags.TEAR_GOLDEN_BOMB) cursedMulliboomLandingBomb:GetSprite()
                cursedMulliboomLandingBomb:GetSprite():ReplaceSpritesheet(0, "gfx/items/pick ups/bombs/costumes/bomb_gold.png")
                cursedMulliboomLandingBomb:GetSprite():LoadGraphics()
                npc.Position = game:GetRoom():GetRandomPosition(10)
                npc.State = 103
                sfx:Play(SoundEffect.SOUND_HELL_PORTAL1,1,0,false,math.random(120,130)/100)
                npc:GetSprite():Play("TeleInBoom")
            end
        end

        if npc.State == 103 then
            if sprite:IsEventTriggered("Land") then
                local cursedMulliboomLandingBomb = Isaac.Spawn(EntityType.ENTITY_BOMB,BombVariant.BOMB_SMALL,0,npc.Position,Vector.Zero,npc):ToBomb()
                
            end
            if sprite:IsEventTriggered("Back") then
                sfx:Play(SoundEffect.SOUND_HELL_PORTAL2,1,0,false,math.random(120,130)/100)

                

                npc.State = 99
                sprite:PlayOverlay("WalkOpenEye")
            end
        end

    end
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, CURSED_MULLIBOOM.NPCUpdate, Isaac.GetEntityTypeByName("Cursed Mulliboom"))



function CURSED_MULLIBOOM:TeleportCheck(npc, _, flags, _, _)
    --print("sharb")
    if flags & DamageFlag.DAMAGE_EXPLOSION ~= 0 then return false end

    if npc.Type == BotB.Enums.Entities.CURSED_MULLIBOOM.TYPE and npc.Variant == BotB.Enums.Entities.CURSED_MULLIBOOM.VARIANT then 
        if npc:ToNPC().State ~= 102 and npc:ToNPC().State ~= 103 then
            npc:ToNPC().State = 102
            --local data = npc:GetData()
            npc:GetSprite():Play("TeleOutBoom")
        end
    end
end
Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, CURSED_MULLIBOOM.TeleportCheck, Isaac.GetEntityTypeByName("Cursed Mulliboom"))

