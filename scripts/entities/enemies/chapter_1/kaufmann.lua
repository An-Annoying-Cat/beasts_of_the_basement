local Mod = BotB
local KAUFMANN = {}
local Entities = BotB.Enums.Entities

function KAUFMANN:NPCUpdate(npc)
    if npc.Type == BotB.Enums.Entities.KAUFMANN.TYPE and npc.Variant == BotB.Enums.Entities.KAUFMANN.VARIANT then 
        local sprite = npc:GetSprite()
        local player = npc:GetPlayerTarget()
        local data = npc:GetData()
        local target = npc:GetPlayerTarget()
        local targetpos = target.Position
        local targetangle = (targetpos - npc.Position):GetAngleDegrees()
        local targetdistance = (targetpos - npc.Position):Length()
        local somebodyPathfinder = npc.Pathfinder
        if npc.State == 0 then
            if not sprite:IsPlaying("Appear") then
                sprite:Play("Appear")
            end
            if sprite:IsFinished("Appear") then
                if data.kaufmannAttackCooldownMax == nil then
                    data.kaufmannAttackCooldownMax = 120
                    data.kaufmannAttackCooldown = 90
                    data.kaufmannTriggerDistance = 180
                end
                sprite:PlayOverlay("Head")
                npc.State = 99
                
            end
        end
        if npc.EntityCollisionClass ~= EntityCollisionClass.ENTCOLL_ALL then
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        end
        if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_GROUND then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
        end
        if npc.State == 99 then
            --npc:ClearEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
            npc:AnimWalkFrame("WalkHori", "WalkVert", 0.1)
            somebodyPathfinder:FindGridPath(targetpos, 0.3, 0, false)
            if data.kaufmannAttackCooldown ~= 0 then
                data.kaufmannAttackCooldown = data.kaufmannAttackCooldown - 1
            else
                if targetdistance <= data.kaufmannTriggerDistance then
                    npc.State = 100
                    sprite:PlayOverlay("Attack")
                end
            end
        end
        if npc.State == 100 then
            --npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
            npc:AnimWalkFrame("WalkHori", "WalkVert", 0.1)
            somebodyPathfinder:FindGridPath(targetpos, 0.3, 0, false)
            if sprite:GetOverlayFrame() == 3 then
                npc:PlaySound(BotB.Enums.SFX.SICK_COUGH,1,0,false,math.random(60,80)/100)
                for i=0,4 do
                    local bullet = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 0, 0, npc.Position, Vector(math.random(400,800)/100,0):Rotated(targetangle+(math.random(-3000,3000)/100)), npc):ToProjectile()
                        bullet:GetData().isMoldProjectile = true
                        bullet.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
                        bullet.Parent = npc
                        bullet.FallingAccel = -0.092
                        bullet.FallingSpeed = 0
                        local bsprite = bullet:GetSprite()
                        bsprite:Load("gfx/monsters/chapter_1/mold_projectile.anm2", true)
                        bsprite:Play("Move", true)
                        --bullet:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)
                        bullet:Update()
                end
            end
            if sprite:IsOverlayFinished() then
                data.kaufmannAttackCooldown = data.kaufmannAttackCooldownMax
                sprite:PlayOverlay("Head")
                npc.State = 99
            end
        end
    end
        
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, KAUFMANN.NPCUpdate, Isaac.GetEntityTypeByName("Kaufmann"))



