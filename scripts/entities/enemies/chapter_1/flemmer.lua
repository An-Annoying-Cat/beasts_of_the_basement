local Mod = BotB
local FLEMMER = {}
local Entities = BotB.Enums.Entities

function FLEMMER:NPCUpdate(npc)
    if npc.Type == BotB.Enums.Entities.FLEMMER.TYPE and npc.Variant == BotB.Enums.Entities.FLEMMER.VARIANT then 
        local sprite = npc:GetSprite()
        local player = npc:GetPlayerTarget()
        local data = npc:GetData()
        local target = npc:GetPlayerTarget()
        local targetpos = target.Position
        local targetangle = (targetpos - npc.Position):GetAngleDegrees()
        local targetdistance = (targetpos - npc.Position):Length()
        local somebodyPathfinder = npc.Pathfinder
        if npc.State == 0 then
            if data.flemmerShootCooldown == nil then
                data.flemmerShootCooldown = 4
                data.botbGoHere = FiendFolio:FindRandomValidPathPosition(npc, 3)
            end
            npc.State = 99
            sprite:PlayOverlay("Blood")
        end
        if npc.EntityCollisionClass ~= EntityCollisionClass.ENTCOLL_ALL then
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        end
        if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_GROUND then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
        end
        npc.SplatColor = FiendFolio.ColorSpittyGreen
        if npc.State == 99 then
            --npc:ClearEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
            npc:AnimWalkFrame("WalkHori", "WalkVert", 0.25)
            somebodyPathfinder:FindGridPath(data.botbGoHere, 0.25, 0, false)
            npc.Velocity = 0.8 * npc.Velocity
            if (data.botbGoHere - npc.Position):Length() <= 60 then
                data.botbGoHere = FiendFolio:FindRandomValidPathPosition(npc, 3)
            end
            if data.flemmerShootCooldown ~= 0 then
                data.flemmerShootCooldown = data.flemmerShootCooldown - 1
            else

                local proj = Isaac.Spawn(9, 0, 0, npc.Position, Vector(math.random(40,80)/10,0):Rotated(math.random(0,359)), npc):ToProjectile()
                    proj.Color = FiendFolio.ColorSpittyGreen
                    proj.FallingSpeed = 1
                    proj.FallingAccel = 0.5
                    local pd = proj:GetData()
                    pd.projType = "acidic splot"
                    FiendFolio:PlaySound(SoundEffect.SOUND_BLOODSHOOT, npc, 1.5, 0.6)
                if math.random(0,1) == 1 then
                    local proj = Isaac.Spawn(9, 0, 0, npc.Position, Vector(math.random(40,80)/10,0):Rotated(math.random(0,359)), npc):ToProjectile()
                    proj.Color = FiendFolio.ColorSpittyGreen
                    proj.FallingSpeed = 1
                    proj.FallingAccel = 0.5
                    local pd = proj:GetData()
                    pd.projType = "acidic splot"
                    FiendFolio:PlaySound(SoundEffect.SOUND_BLOODSHOOT, npc, 1.5, 0.6)
                end

                    data.flemmerShootCooldown = math.random(7,14)

            end
        end
    end
        
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, FLEMMER.NPCUpdate, Isaac.GetEntityTypeByName("Flemmer"))



