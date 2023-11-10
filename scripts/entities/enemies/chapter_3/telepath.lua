local Mod = BotB
local TELEPATH = {}
local Entities = BotB.Enums.Entities
--print("geo horf script loaded!")
function TELEPATH:NPCUpdate(npc)

    if npc.Type == BotB.Enums.Entities.TELEPATH.TYPE and npc.Variant == BotB.Enums.Entities.TELEPATH.VARIANT then 

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
        --100: ping
        --101: pull
        --Subtype 1 does not make bullet

        if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_GROUND then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
        end

        if npc.State == 0 then
            --Init
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
            if not sprite:IsPlaying("Appear") then
                sprite:Play("Appear")
            end
            if sprite:IsFinished("Appear") then
                if npc.SubType == 0 then
                    local proj = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_HUSH,0,npc.Position,Vector.Zero,npc):ToProjectile()
                    proj:GetData().isATelepathProjectile = true
                    proj.ProjectileFlags = ProjectileFlags.GHOST
                    proj.FallingAccel = -0.1
                    proj.FallingSpeed = 0
                    data.telepathMyProj = proj
                end
                npc.State = 99
                sprite:Play("Shake")
            end
            
        end

        if data.telepathMyProj ~= nil and data.telepathMyProj:IsDead() then
            local proj = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_HUSH,0,npc.Position,Vector.Zero,npc):ToProjectile()
                    proj:GetData().isATelepathProjectile = true
                    proj.ProjectileFlags = ProjectileFlags.GHOST
                    proj.FallingAccel = -0.1
                    proj.FallingSpeed = 0
                    data.telepathMyProj = proj
        end

        npc.Velocity = 0.8 * npc.Velocity
        if npc.State == 99 then

        end

        if npc.State == 100 then
            if sprite:IsEventTriggered("Shoot") then
                npc:PlaySound(BotB.Enums.SFX.TELEPATH_PING,0.75,0,false,math.random(150,250)/100)
            end
            if sprite:IsFinished() then
                npc.State = 99
                sprite:Play("Shake")
            end
        end

        if npc.State == 101 then

        end

    end
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, TELEPATH.NPCUpdate, Isaac.GetEntityTypeByName("Moldy Horf"))

function TELEPATH:BulletCheck(bullet)
    local data = bullet:GetData()
    if bullet:GetData().isATelepathProjectile == true then

        if TELEPATH:GetNumTelepaths() <= 1 then
            bullet:AddFallingAccel(2)
        else

            if data.telepathProjTarget == nil then
                local possibleDestinations = TELEPATH:GetAllTelepathsExcludingSelf(bullet.Position)
                data.telepathProjTarget = possibleDestinations[math.random(1,#possibleDestinations)]
                data.telepathProjTarget.State = 101
                data.telepathProjTarget:GetSprite():Play("Pull")
            else
                bullet.Velocity = ((0.95 * bullet.Velocity) + (0.05 * (data.telepathProjTarget.Position - bullet.Position))):Clamped(-10,-10,10,10)
                if (data.telepathProjTarget.Position - bullet.Position):Length() < 30 or data.telepathProjTarget:IsDead() then
                    if data.telepathProjTarget:IsDead() ~= true then
                        data.telepathProjTarget.State = 100
                        data.telepathProjTarget:GetSprite():Play("Attack")
                    end
                    local possibleDestinations = TELEPATH:GetAllTelepathsExcludingSelf(bullet.Position)
                    data.telepathProjTarget = possibleDestinations[math.random(1,#possibleDestinations)]
                    data.telepathProjTarget.State = 101
                    data.telepathProjTarget:GetSprite():Play("Pull")
                end
            end

            if bullet:IsDead() then
                if data.telepathProjTarget ~= nil then
                    data.telepathProjTarget.State = 99
                    data.telepathProjTarget:GetSprite():Play("Shake")
                end
            end

        end

        
    end
    

end

Mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, TELEPATH.BulletCheck)


function TELEPATH:IsACurrentBulletTarget(me)
    local check = false
    local roomEntities = Isaac.GetRoomEntities() -- table
    for i = 1, #roomEntities do
        local npc = roomEntities[i]
        if npc.Type == EntityType.ENTITY_PROJECTILE and npc.Variant == ProjectileVariant.PROJECTILE_HUSH and npc:GetData().isATelepathProjectile == true and npc:GetData().telepathProjTarget ~= nil then 
            if npc:GetData().telepathProjTarget.Position == me.Position then
                print("DO THE PULL")
                check = true
            end
        end
    end
    return check
end


function TELEPATH:GetAllTelepathsExcludingSelf(pos)
    local telepaths = {}
    local roomEntities = Isaac.GetRoomEntities() -- table
    for i = 1, #roomEntities do
        local npc = roomEntities[i]
        if npc.Type == BotB.Enums.Entities.TELEPATH.TYPE and npc.Variant == BotB.Enums.Entities.TELEPATH.VARIANT then 
            if not ((npc.Position - pos):Length() < 30) then
                telepaths[#telepaths+1] = npc:ToNPC()
            end
        end
    end
    return telepaths
end

function TELEPATH:GetNumTelepaths()
    local telepaths = {}
    local roomEntities = Isaac.GetRoomEntities() -- table
    for i = 1, #roomEntities do
        local npc = roomEntities[i]
        if npc.Type == BotB.Enums.Entities.TELEPATH.TYPE and npc.Variant == BotB.Enums.Entities.TELEPATH.VARIANT then 
            telepaths[#telepaths+1] = npc:ToNPC()
        end
    end
    return #telepaths
end