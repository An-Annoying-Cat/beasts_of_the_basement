local Mod = BotB
local KEHEHAN = {}
local Entities = BotB.Enums.Entities
local game = Game()
local mod = BotB.FF

function KEHEHAN:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local data = npc:GetData()
    local room = game:GetRoom()
    

    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()
    local kehehanPathfinder = npc.Pathfinder


    if npc.Type == BotB.Enums.Entities.KEHEHAN.TYPE and npc.Variant == BotB.Enums.Entities.KEHEHAN.VARIANT and npc.SubType == BotB.Enums.Entities.KEHEHAN.SUBTYPE then 

        --[[
        if targetdistance <= 100 and data.teleTimer <= 0 then
            npc.State = 13
        end
        --]]
        if data.CastTimer == nil then
            data.CastTimer = 0
            data.CastTimerMax = 30
            data.cantBeHurt = false
            data.teleTimer = 120
            data.teleTimerMax = 120
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
        end

        if npc.State == 8 then 
            if data.CastTimer == 0 then
                npc.State = 99
                sprite:Play("Attack") 
                --npc.StateFrame = 0
            else
                npc.State = 3
                sprite:Play("Idle")
                --npc.StateFrame = 0
            end
        end
        --Teleport check?
        if npc.State == 13 then 
            if data.teleTimer == 0 then
                data.cantBeHurt = true
                npc.State = 100
                npc.Color = Color(256, 256, 256)
                sprite:Play("TeleOut") 
                npc.StateFrame = 0
            else
                npc.State = 3
                npc.StateFrame = 0
            end
        end
        --Attack
        if npc.State == 99 then
            if sprite:IsEventTriggered("Back") then 
                npc.State = 3
                sprite:Play("Idle")
                --npc.StateFrame = 0
            end
            if sprite:IsEventTriggered("Shoot") then

                local params = ProjectileParams()
                params.HeightModifier = 15
                local bullet = Isaac.Spawn(9, 0, 0, npc.Position, (Vector(math.floor(0.05 * targetdistance * (math.random(8, 10) / 10), 6),0):Rotated(targetangle)):Resized(15), npc):ToProjectile()
                bullet.Parent = npc

                sfx:Play(Isaac.GetSoundIdByName("SeducerAttack"),0.4,0,false,math.random(80,90)/100)
                data.CastTimer = data.CastTimerMax
            end
        end

        --Teleport
        if npc.State == 100 then
            if sprite:IsEventTriggered("Move") then 
                npc.Position = game:GetRoom():GetRandomPosition(10)
                npc.State = 101
                sfx:Play(SoundEffect.SOUND_HELL_PORTAL1,1,0,false,math.random(80,90)/100)
                sprite:Play("TeleIn")
                npc.StateFrame = 0
            end
            if sprite:IsEventTriggered("On") then
                sfx:Play(SoundEffect.SOUND_HELL_PORTAL2,1,0,false,math.random(80,90)/100)
                
            end
        end
        if npc.State == 101 then
            if sprite:IsEventTriggered("Off") then 
                data.cantBeHurt = false
                npc.Color = Color(1, 1, 1)
                data.teleTimer = data.teleTimerMax
                if data.CastTimer == 0 then
                    npc.State = 99
                    sprite:Play("Attack") 
                    --npc.StateFrame = 0
                else
                    npc.State = 3
                    sprite:Play("Idle")
                    --npc.StateFrame = 0
                end
            end
        end

        if npc.State == 3 then
            kehehanPathfinder:MoveRandomly()
            npc.Target = npc:GetPlayerTarget()
        end


        if data.CastTimer ~= 0 then
            data.CastTimer = data.CastTimer - 1
        end

        if data.teleTimer ~= 0 then
            --print(data.teleTimer)
            data.teleTimer = data.teleTimer - 1
        end
    end
end

function KEHEHAN.DamageCheck(npc, _, _, _, _)
    if npc.Type == BotB.Enums.Entities.KEHEHAN.TYPE and npc.Variant == BotB.Enums.Entities.KEHEHAN.VARIANT and npc.SubType == BotB.Enums.Entities.KEHEHAN.SUBTYPE then 
        local data = npc:GetData()
        if data.cantBeHurt then
            sfx:Play(Isaac.GetSoundIdByName("SeducerAttack"),1,0,false,math.random(110,130)/100)
            return false
        else
            return true
        end
    end
end

function KEHEHAN:BulletCheck(bullet)

    --Did it come from a Kehehan?
    local room = game:GetRoom()
    if bullet.Parent ~= nil and bullet.Parent.Type == BotB.Enums.Entities.KEHEHAN.TYPE and bullet.Parent.Variant == BotB.Enums.Entities.KEHEHAN.VARIANT and bullet.Parent.SubType == BotB.Enums.Entities.KEHEHAN.SUBTYPE then
        
        
        if bullet:IsDead() then
            if bullet:CollidesWithGrid() then
                local grid = room:GetGridEntityFromPos(bullet.Position)
                if grid.Desc.Type == GridEntityType.GRID_ROCK or grid.Desc.Type == GridEntityType.GRID_ROCKT or grid.Desc.Type == GridEntityType.GRID_ROCK_BOMB or grid.Desc.Type == GridEntityType.GRID_ROCKSS or grid.Desc.Type == GridEntityType.GRID_ROCK_SPIKED or grid.Desc.Type == GridEntityType.GRID_ROCK_GOLD then
                    local index = room:GetGridIndex(bullet.Position)
                    Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.POOF02,0,grid.Position,Vector(0,0),bullet)
                    Isaac.Spawn(BotB.Enums.Entities.SHARD.TYPE,BotB.Enums.Entities.SHARD.VARIANT,3,grid.Position,Vector(0,0),bullet)
                    room:DestroyGrid(index, true)
                    sfx:Play(SoundEffect.SOUND_BLACK_POOF,1,0,false,math.random(80,90)/100)
                    
                    print("yeah")
                end
            else
                print("nope")
            end
            --sfx:Play(SoundEffect.SOUND_ANIMAL_SQUISH,1,0,false,math.random(120,150)/100)
            --local creep = Isaac.Spawn(1000, 22, 0, bullet.Position, Vector(0,0), bullet)
            --creep.SpriteScale = creep.SpriteScale * 1.5
        end
      end
    

end

Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, KEHEHAN.NPCUpdate, Isaac.GetEntityTypeByName("Kehehan"))
Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, KEHEHAN.DamageCheck, Isaac.GetEntityTypeByName("Kehehan"))
Mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, KEHEHAN.BulletCheck)