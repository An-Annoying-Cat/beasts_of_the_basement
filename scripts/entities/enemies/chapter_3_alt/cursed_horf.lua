local Mod = BotB
local CURSED_HORF = {}
local Entities = BotB.Enums.Entities

local function getPlayers()
	local game = Game()
	local numPlayers = game:GetNumPlayers()
  
	local players = {}
	for i = 0, numPlayers - 1 do
	  local player = Isaac.GetPlayer(i)
	  table.insert(players, player)
	end
  
	return players
end

function CURSED_HORF:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local data = npc:GetData()
    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()


    if npc.Type == BotB.Enums.Entities.CURSED_HORF.TYPE and npc.Variant == BotB.Enums.Entities.CURSED_HORF.VARIANT then 
        --States:
        --99: Idle
        --100: Charge
        --101: Shoot
        --102: Teleport out
        --103: Teleport in
        if data.cursedHorfAttackCooldownMax == nil then
            data.cursedHorfAttackCooldownMax = 80
            data.cursedHorfAttackCooldown = data.cursedHorfAttackCooldownMax

            -- *sigh*
            local doTheyActuallyHaveThem = false
            local players = getPlayers()
            for i=1,#players,1 do
                if players[i]:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) or players[i]:HasCollectible(CollectibleType.COLLECTIBLE_ALMOND_MILK) then
                    doTheyActuallyHaveThem = true
                end
            end
            if doTheyActuallyHaveThem then
                data.cursedHorfTeleCooldownMax = 60
            else
                data.cursedHorfTeleCooldownMax = 10
            end
            
            data.cursedHorfTeleCooldown = data.cursedHorfTeleCooldownMax
            data.cursedHorfBaseAnimSpeed = sprite.PlaybackSpeed
            data.cursedHorfDoTeleportOnHurt = false
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

        if npc.State == 0 then
            --Init
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
            if not sprite:IsPlaying("Appear") then
                sprite:Play("Appear")
            end
            if sprite:IsFinished("Appear") then
                npc.State = 99
                sprite:Play("Shake")
            end
        end
        npc.Velocity = 0.5*npc.Velocity
        if npc.State == 99 then
            
            if data.cursedHorfAttackCooldown ~= 0 then
                data.cursedHorfAttackCooldown = data.cursedHorfAttackCooldown -1
            else
                npc.State = 100
                sprite:Play("Charge")
            end
        end

        if npc.State == 100 then
            --[[
            if sprite.PlaybackSpeed ~= data.cursedHorfBaseAnimSpeed * 0.5 then
                sprite.PlaybackSpeed = data.cursedHorfBaseAnimSpeed * 0.5 
            end
            ]]
        else
            if npc.State == 102 or npc.State == 103 then
                if sprite.PlaybackSpeed ~= data.cursedHorfBaseAnimSpeed * 2 then
                    sprite.PlaybackSpeed = data.cursedHorfBaseAnimSpeed * 2
                end
            else
                if sprite.PlaybackSpeed ~= data.cursedHorfBaseAnimSpeed then
                    sprite.PlaybackSpeed = data.cursedHorfBaseAnimSpeed
                end
            end
        end

        if npc.State == 100 then
            if sprite:IsEventTriggered("Back") then
                npc.State = 101
                npc:PlaySound(Isaac.GetSoundIdByName("FlashShakeyKidRoar"),3,0,false,math.random(40,60)/100)
                npc:PlaySound(Isaac.GetSoundIdByName("FlashShakeyKidRoar"),3,0,false,math.random(40,60)/100)
                sprite:Play("Attack")
            end
        end

        if npc.State == 101 then
            if sprite:IsEventTriggered("Shoot") then
                local cursedHorfProjParams = ProjectileParams()

                npc:FireProjectiles(npc.Position, Vector(12,0):Rotated(targetangle), 0, cursedHorfProjParams)
            end
            if sprite:GetFrame() >= 19 then
                npc.State = 99
                sprite:Play("Shake")
                data.cursedHorfAttackCooldown = data.cursedHorfAttackCooldownMax
            end
        end

        if npc.State == 102 then
            if sprite:IsEventTriggered("Teleport") then
                npc.Position = game:GetRoom():FindFreePickupSpawnPosition(game:GetRoom():GetRandomPosition(10), 0, true, false)
                npc.State = 103
                sfx:Play(SoundEffect.SOUND_HELL_PORTAL1,1,0,false,math.random(120,130)/100)
                npc:GetSprite():Play("WarpIn")
            end
        end

        if npc.State == 103 then
            if sprite:IsEventTriggered("Back") then
                data.cursedHorfTeleCooldown = data.cursedHorfTeleCooldownMax
                npc.State = 101
                sfx:Play(SoundEffect.SOUND_HELL_PORTAL2,1,0,false,math.random(120,130)/100)
                npc:PlaySound(Isaac.GetSoundIdByName("FlashShakeyKidRoar"),3,4,false,math.random(40,60)/100)
                npc:PlaySound(Isaac.GetSoundIdByName("FlashShakeyKidRoar"),3,4,false,math.random(40,60)/100)
                sprite:Play("Attack")
            end
        end

        if npc.State ~= 102 and npc.State ~= 103 then
            if data.cursedHorfTeleCooldown ~= 0 then
                data.cursedHorfTeleCooldown = data.cursedHorfTeleCooldown - 1
            end
        end

    end
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, CURSED_HORF.NPCUpdate, Isaac.GetEntityTypeByName("Cursed Horf"))



function CURSED_HORF:TeleportCheck(npc, _, _, _, _)
    if npc.Variant ~= BotB.Enums.Entities.CURSED_HORF.VARIANT then return end
    --print("sharb")
    if npc.Type == BotB.Enums.Entities.CURSED_HORF.TYPE and npc.Variant == BotB.Enums.Entities.CURSED_HORF.VARIANT then 
        if npc:GetData().cursedHorfTeleCooldown == 0 then
            npc:ToNPC().State = 102
            local data = npc:GetData()
            npc:GetSprite():Play("WarpOut")
        end
    end
end
Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, CURSED_HORF.TeleportCheck, Isaac.GetEntityTypeByName("Cursed Horf"))
