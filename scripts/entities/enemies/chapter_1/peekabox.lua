local Mod = BotB
local PEEKABOX = {}
local Entities = BotB.Enums.Entities
--print("geo horf script loaded!")
function PEEKABOX:NPCUpdate(npc)

    if npc.Type == BotB.Enums.Entities.PEEKABOX.TYPE and npc.Variant == BotB.Enums.Entities.PEEKABOX.VARIANT then 

        local sprite = npc:GetSprite()
        local player = npc:GetPlayerTarget()
        local data = npc:GetData()
        local target = npc:GetPlayerTarget()
        local targetpos = target.Position
        local targetangle = (targetpos - npc.Position):GetAngleDegrees()
        local targetdistance = (targetpos - npc.Position):Length()
        local cursedPooterPathfinder = npc.Pathfinder

        --States:
        --99: Idle
        --100: Shoot
        --101: alert

        if data.peekaboxFacingAngle == nil then
            if npc.SubType == 0 then
                sprite:ReplaceSpritesheet(0, "gfx/monsters/chapter_1/peekabox_left.png")
			    sprite:LoadGraphics()
                data.peekaboxFacingAngle = 180
            elseif npc.SubType == 1 then
                sprite:ReplaceSpritesheet(0, "gfx/monsters/chapter_1/peekabox_up.png")
			    sprite:LoadGraphics()
                data.peekaboxFacingAngle = 270
            elseif npc.SubType == 2 then
                sprite:ReplaceSpritesheet(0, "gfx/monsters/chapter_1/peekabox_right.png")
			    sprite:LoadGraphics()
                data.peekaboxFacingAngle = 0
            elseif npc.SubType == 3 then
                sprite:ReplaceSpritesheet(0, "gfx/monsters/chapter_1/peekabox_down.png")
			    sprite:LoadGraphics()
                data.peekaboxFacingAngle = 90
            end
        end

        if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_GROUND then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
        end

        if npc.State == 0 then
            --Init
            --npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
            npc:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)
            if not sprite:IsPlaying("Appear") then
                sprite:Play("Appear")
            end
            if sprite:IsFinished("Appear") then
                npc.State = 99
                sprite:Play("Idle")
            end
        end

        if npc.State == 99 then
            --npc.Velocity = 0.8 * npc.Velocity
            --cursedPooterPathfinder:MoveRandomly(true)
            if PEEKABOX:CheckIfTargetInDetectionRange(npc, target) then  
                npc:PlaySound(BotB.Enums.SFX.PEEKABOX_ALERT,3,15,false,math.random(190,210)/100)
                local roomEntities = Isaac.GetRoomEntities() -- table
                for i = 1, #roomEntities do
                    local entity = roomEntities[i]
                    if entity:ToNPC() ~= nil and entity.Type == BotB.Enums.Entities.PEEKABOX.TYPE and entity.Variant == BotB.Enums.Entities.PEEKABOX.VARIANT and entity:ToNPC().State == 99 then
                        entity:ToNPC().State = 101
                        entity:GetSprite():Play("Alert", true)
                    end
                end
            end
        end

        if npc.State == 100 then
            if sprite:IsEventTriggered("Shoot") then
                npc:PlaySound(BotB.Enums.SFX.GRENADE_LAUNCHER_POP,1,0,false,math.random(180,220)/100)
                local bullet = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 0, 0, npc.Position, Vector(12,0):Rotated(data.peekaboxFacingAngle), npc):ToProjectile()
                if EntityRef(npc).IsFriendly or EntityRef(npc).IsCharmed then
                    bullet:AddProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER | ProjectileFlags.HIT_ENEMIES)
                end
                        bullet.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
                        bullet:AddHeight(15)
                        bullet.Parent = npc
                        bullet.FallingAccel = -0.08
                        bullet.FallingSpeed = 0
                        --bullet:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)
                        bullet:Update()
            end

            if sprite:IsFinished() then
                npc.State = 99
                sprite:Play("Idle")
            end
        end

        if npc.State == 101 then
            if sprite:IsFinished() then
                npc.State = 100
                sprite:Play("Shoot")
            end
        end

    end
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, PEEKABOX.NPCUpdate, Isaac.GetEntityTypeByName("Peekabox"))

function PEEKABOX:CheckIfTargetInDetectionRange(npc, target)
    --target is within 15 degrees of facing direction, and box has direct LOS, and if target has data for detection cooldown it is at zero
    local data = npc:GetData()
    local targetpos = target.Position
    local targetangle = (targetpos - npc.Position):GetAngleDegrees()
    local targetdistance = (targetpos - npc.Position):Length()
    if targetangle >= (data.peekaboxFacingAngle - 7.5) 
    and targetangle <= (data.peekaboxFacingAngle + 7.5) 
    and Game():GetRoom():CheckLine(npc.Position, targetpos, 0, 0, false, false)
    and target:ToPlayer() ~= nil 
    and target:GetData().peekaboxImmunityDuration ~= nil 
    and target:GetData().peekaboxImmunityDuration == 0 then
        target:GetData().peekaboxImmunityDuration = 30
        return true
    else
        return false
    end
end


function PEEKABOX:playerUpdate()
    --print("stop the fucking presses")
    local seeds = Game():GetSeeds()
    local playerList = TSIL.Players.GetPlayers(true)
    for i=1,#playerList,1 do
        local player = playerList[i]:ToPlayer()
        local data = player:GetData()

        if data.peekaboxImmunityDuration == nil then
            data.peekaboxImmunityDuration = 0
        end
        if data.peekaboxImmunityDuration ~= 0 then
            data.peekaboxImmunityDuration = data.peekaboxImmunityDuration - 1
        end

    end
end
Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, PEEKABOX.playerUpdate)