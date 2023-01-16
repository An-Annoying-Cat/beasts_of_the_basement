local Mod = BotB
local INCH_WORM = {}
local Entities = BotB.Enums.Entities

function INCH_WORM:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local data = npc:GetData()
    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()
    local room = Game():GetRoom()


    if npc.Type == BotB.Enums.Entities.INCH_WORM.TYPE and npc.Variant == BotB.Enums.Entities.INCH_WORM.VARIANT then 
        if npc.State == 0 then
            if data.isUnder == nil then
                --Is it underground?
                data.isUnder = false
                --What distance from the player will it come up?
                data.digDistance = 75
                --Timer for going underground and raising
                if npc.SubType ~= 1 then
                    data.underTimerMax = 10
                else
                    data.underTimerMax = 5
                end
                data.underTimer = data.underTimerMax
                --Using this to delay where they shoot towards
                data.fireAtPos = npc.Position
                --Using this to better find a spot near the player to dig up at
                data.digPos = nil
                data.gotValidDigPos = false
            end
            npc.State = 99
            sprite:Play("Idle")
        end
        --States:
        --99: Aboveground
        --100: Go below
        --101: Underground
        --102: Shoot/Surface


        --aboveground countin down
        if npc.State == 99 then
            if data.underTimer == 0 then
                if targetdistance >= data.digDistance + 25 then
                    npc.State = 100
                    sprite:Play("DigIn")
                    data.underTimer = data.underTimerMax
                else
                    npc.State = 99
                    sprite:Play("Idle")
                    data.underTimer = data.underTimerMax
                end
                
                
            else
                data.underTimer = data.underTimer - 1
            end
        end



        if npc.State == 100 then
            --Going underground
            if sprite:IsEventTriggered("Back") then
                data.isUnder = true
                npc.CollisionDamage = 0
                npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                npc.State = 101
                data.gotValidDigPos = false
                sprite:Play("Under")
            end
        end


        --Searching for valid position to surface from underground
        if npc.State == 101 then
            if data.underTimer == 0 then
                npc.Position = data.digPos
                data.isUnder = false
                npc.CollisionDamage = 1
                npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
                npc.State = 102
                sprite:Play("DigOut")
                data.underTimer = data.underTimerMax
            else
                --Get random position then check validity
                if data.gotValidDigPos == false then
                    data.digPos = targetpos + Vector(data.digDistance,0):Rotated(math.random(360))
                end
                if room:GetGridCollisionAtPos(data.digPos) ~= GridCollisionClass.COLLISION_NONE then
                    data.gotValidDigPos = false
                else
                    data.gotValidDigPos = true
                end
                data.underTimer = data.underTimer - 1
            end
        end

        if npc.State == 102 then
            if sprite:IsEventTriggered("PreShoot") then
                data.fireAtPos = targetpos
            end
            if sprite:IsEventTriggered("Shoot") then
                if npc.SubType ~= 1 then
                    npc:PlaySound(SoundEffect.SOUND_WORM_SPIT,0.75,0,false,math.random(150,200)/100)
                    npc:FireProjectiles(npc.Position, (data.fireAtPos - npc.Position):Normalized()*5, 0, ProjectileParams())
                else
                    npc:PlaySound(SoundEffect.SOUND_WORM_SPIT,0.75,0,false,math.random(110,140)/100)
                    local projectile = Isaac.Spawn(9, 0, 0, npc.Position, (data.fireAtPos - npc.Position):Normalized()*7, npc):ToProjectile();
                    projectile.FallingSpeed = -30;
                    projectile.FallingAccel = 2
                    projectile.Height = -10
                    projectile.Color = Color(0, 0.9, 0.4, 1, 0, 0, 0)
                    projectile:AddProjectileFlags(ProjectileFlags.BURST)
                end
                
            end
            --Going underground
            if sprite:IsEventTriggered("Back") then
                npc.State = 99
                sprite:Play("Idle")
            end
        end



    end
end


Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, INCH_WORM.NPCUpdate, Isaac.GetEntityTypeByName("Inch Worm"))

function INCH_WORM:DamageNull(npc, _, _, _, _)
    --print("sharb")
    local data = npc:GetData()
    if npc.Type == BotB.Enums.Entities.INCH_WORM.TYPE and npc.Variant == BotB.Enums.Entities.INCH_WORM.VARIANT and data.isUnder == true then 
        --print("nope!")
        return false
    end
end


Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, INCH_WORM.DamageNull, Isaac.GetEntityTypeByName("Inch Worm"))