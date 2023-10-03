local Mod = BotB
local DESPAIR = {}
local Entities = BotB.Enums.Entities
local game = Game()
local mod = BotB.FF

function DESPAIR:NPCUpdate(npc)

    


    if npc.Type == BotB.Enums.Entities.DESPAIR.TYPE and npc.Variant == BotB.Enums.Entities.DESPAIR.VARIANT  then 

        --States:
        -- 0: init--no appear. Straight to idle
        --99: idle
        --100: ram start
        --101: ramming
        --102: ram fadeout
        --103: summon spoops
        --104: phase transition
        --105: phase 2 idle
        --106: phase 2 shoot
        --107: phase 2 teleport out
        --108: phase 2 teleport in
        local sprite = npc:GetSprite()
        local player = npc:GetPlayerTarget()
        local data = npc:GetData()
        local target = npc:GetPlayerTarget()
        local targetpos = target.Position
        local targetangle = (targetpos - npc.Position):GetAngleDegrees()
        local targetdistance = (targetpos - npc.Position):Length()
        local despairPathfinder = npc.Pathfinder
        local room = Game():GetRoom()
			local topLeft = room:GetTopLeftPos()
			local bottomRight = room:GetBottomRightPos()
			local sizeVec = bottomRight - topLeft
			local xLowThreshold = (topLeft.X + 0.1*sizeVec.X)
			local xHighThreshold = (topLeft.X + 0.9*sizeVec.X)
			local yLowThreshold = (topLeft.Y + 0.1*sizeVec.Y)
			local yHighThreshold = (topLeft.Y + 0.9*sizeVec.Y)
        if data.despairIsInPhase2 == nil then
            data.chargeEndBaseFrame = 0
            data.chargeEndRoomBaseFrame = 0
            data.doChargeEndRoom = false
            data.despairIsInPhase2 = false
            data.despairChargeTimerMax = 240
            data.despairChargeTimer = data.despairChargeTimerMax - 200
            data.despairChargeDir = 0
            --[[
            data.despairChargeDurationMax = 240
            data.despairChargeDuration = data.despairChargeDurationMax
            ]]
            data.despairPhase1ShootTimerMax = 80
            data.despairPhase1ShootTimer = data.despairPhase1ShootTimerMax
            data.despairPhase2ShootTimerMax = 180
            data.despairPhase2ShootTimer = data.despairPhase2ShootTimerMax
            data.despairPhase2HorseTimerMax = 280
            data.despairPhase2HorseTimer = data.despairPhase2HorseTimerMax
            data.despairPhase2TeleTimerMax = 240
            data.despairPhase2TeleTimer = 0
        end

        if npc.State == 0 then
            local musManager = MusicManager()
            --musManager:Play(Isaac.GetMusicIdByName("FiendFolioHorseman"), 1)
            npc.State = 99
            sprite:Play("FullFloat")
            
        end

        if data.despairIsInPhase2 == false then
            --cooldowns
            if data.despairChargeTimer ~= 0 then
                data.despairChargeTimer = data.despairChargeTimer - 1
            end
            if data.despairPhase1ShootTimer ~= 0 then
                data.despairPhase1ShootTimer = data.despairPhase1ShootTimer - 1
            end
        end

        if npc.State == 99 then
            ---local musManager = MusicManager()
            ---if musManager:GetCurrentMusicID() ~= Isaac.GetMusicIdByName("FiendFolioHorseman") then
            ---    musManager:Play(Isaac.GetMusicIdByName("FiendFolioHorseman"), 1)
            ---end
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
            --npc.Color = Color(1,1,1,1)
            if math.random(0,1) == 1 then
                despairPathfinder:EvadeTarget(targetpos)
                despairPathfinder:EvadeTarget(targetpos)
            else
                despairPathfinder:FindGridPath(targetpos, 0.1, 0, true)
            end
            
            if (npc.HitPoints/npc.MaxHitPoints) <= 0.5 then
                print("initate phase change")
                npc.State = 104
                data.despairIsInPhase2 = true
                local despairHorse = Isaac.Spawn(Isaac.GetEntityTypeByName("Despair Horse"),Isaac.GetEntityVariantByName("Despair Horse"),0,Vector(500,500),Vector.Zero,npc):ToNPC()
                despairHorse.Color = Color(1,1,1,0)
                despairHorse:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                data.despairPhase2HorseTimer = data.despairPhase2HorseTimerMax
                sprite:Play("PhaseTransition")
            else
                if data.despairChargeTimer == 0 then
                    npc.State = 100
                    sprite:Play("AttackDashStart")
                end
                --
                if data.despairPhase1ShootTimer == 0 then
                    npc.State = 103
                    sprite:Play("Attack1")
                end
            end
            
            
        end

        if npc.State == 100 then
            if sprite:IsEventTriggered("Shoot") then
                if Isaac.CountEntities(npc, Isaac.GetEntityTypeByName("Shirk"), Isaac.GetEntityVariantByName("Shirk"),0) < 1 then
                    Isaac.Spawn(Isaac.GetEntityTypeByName("Shirk"),Isaac.GetEntityVariantByName("Shirk"),0,room:FindFreeTilePosition(npc.Position, 999),Vector.Zero,npc)
                end
                --flee!
                local baseFleeVector = Vector(20,0):Rotated(targetangle)
                npc.Velocity = Vector(-baseFleeVector.X, -baseFleeVector.Y)
                npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
            end
            if sprite:IsFinished() then
                data.despairChargeDir = math.random(0,1)
                Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.POOF01,0,npc.Position,Vector.Zero,npc)
                --left
                if data.despairChargeDir == 0 then
                    --print("left")
                    npc.Position = (Vector(room:GetCenterPos().X,targetpos.Y)+Vector(510,0))
                end
                --right
                if data.despairChargeDir == 1 then
                    --print("left")
                    npc.Position = (Vector(room:GetCenterPos().X,targetpos.Y)+Vector(-510,0))
                end
                npc.State = 101
                sprite:Play("AttackDash")
                npc:SetColor(Color(1,1,1,0), 15, 0, true, true)
            end
        end

        if npc.State == 101 then
            local pos = npc.Position

            if room:IsPositionInRoom(npc.Position, 0) and npc.FrameCount % 7 == 0 then
                Isaac.Spawn(Isaac.GetEntityTypeByName("Spoop"),Isaac.GetEntityVariantByName("Spoop"),0,npc.Position,Vector(4,0):Rotated(math.random(0,360)),npc)
            end

            --print(npc.Position.X .. " , " .. npc.Position.Y)
            --
            if data.despairChargeDir == 0 then
                --left
                npc.FlipX = true
                --print("left?")
                npc.Velocity = Vector(-15,0)
                --
                if npc.Position.X <= xLowThreshold then
                    --print("alerta " .. npc.Position.X .. " , " .. npc.Position.Y)
                    --npc.Position = (room:GetCenterPos())
                    data.despairChargeTimer = data.despairChargeTimerMax
                    npc.Color = Color(1,1,1,0)
                    npc:SetColor(Color(1,1,1,1), 5, 1, true, false)
                    npc.State = 102
                    data.chargeEndBaseFrame = npc.FrameCount
                    --sprite:Play("FullFloat")
                end
                
            else
                --right
                npc.FlipX = false
                --print("right?")
                npc.Velocity = Vector(15,0)
                --local pos = npc.Position
                --
                if npc.Position.X >= xHighThreshold  then
                    --print("alerta " .. npc.Position.X .. " , " .. npc.Position.Y)
                    data.despairChargeTimer = data.despairChargeTimerMax
                    --npc:SetColor(Color(1,1,1,0), 15, 0, true, true)
                    npc.Color = Color(1,1,1,0)
                    npc:SetColor(Color(1,1,1,1), 5, 1, true, false)
                    npc.State = 102
                    data.chargeEndBaseFrame = npc.FrameCount
                    --sprite:Play("FullFloat")
                end
                
            end
            
        end

        if npc.State == 102 then
            ----print(npc.Position)
            if npc.FrameCount == data.chargeEndBaseFrame + 60 then
                --npc.Color = Color(1,1,1,0)
                if data.despairChargeDir == 0 then
                    npc.Position = (Vector(room:GetCenterPos().X,targetpos.Y)+Vector(300,0))
                else
                    npc.Position = (Vector(room:GetCenterPos().X,targetpos.Y)+Vector(-300,0))
                end
                --npc.Position = (room:GetCenterPos())
                --npc:SetColor(Color(1,1,1,1), 30, 1, true, false)
                
            end
            --
            ----print(room:IsPositionInRoom(npc.Position, 10))
            if room:IsPositionInRoom(npc.Position, 10)then
                --data.doChargeEndRoom = true
                --data.chargeEndRoomBaseFrame = npc.FrameCount
                
                npc.Velocity = 0.8*npc.Velocity
                
            end
            
            if npc.FrameCount == data.chargeEndBaseFrame + 120 or npc.Velocity:Length() <= 1 then
                npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
                npc.Color = Color(1,1,1,1)
                npc:SetColor(Color(1,1,1,0), 5, 1, true, false)
                npc.State = 99
                data.doChargeEndRoom = false
                --data.chargeEndRoomBaseFrame = 0
                sprite:Play("FullFloat")
            end
        end

        if npc.State == 103 then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
            if sprite:IsEventTriggered("Shoot") then
                local params = ProjectileParams()
                params.BulletFlags = ProjectileFlags.GHOST
                params.Variant = 4
                npc:FireProjectiles(npc.Position, (targetpos - npc.Position):Resized(10), 0, params)
                npc:FireProjectiles(npc.Position, (targetpos - npc.Position):Resized(8), 1, params)
                mod:PlaySound(mod.Sounds.FlashShakeyKidRoar, npc, 0.8, 2)
                mod:PlaySound(SoundEffect.SOUND_BLOODSHOOT)
                --[[
                local effect = Isaac.Spawn(1000, 2, 5, npc.Position, Vector.Zero, npc):ToEffect()
                effect.SpriteOffset = Vector(0,-6)
                effect.DepthOffset = npc.Position.Y * 1.25
                effect.Color = mod.ColorGhostly]]
            end
            --print(sprite:GetFrame())
            if sprite:GetFrame() >= 33 then
                data.despairPhase1ShootTimer = data.despairPhase1ShootTimerMax
                npc.State = 99
                sprite:Play("FullFloat")
            end
        end

        if npc.State == 104 then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
            if sprite:IsEventTriggered("LandSound") then
                mod:PlaySound(SoundEffect.SOUND_GOOATTACH0, npc, 0.5, 2)
            end
            if sprite:IsEventTriggered("Back") or sprite:IsFinished("PhaseTransition") then
                npc.State = 105
                sprite:Play("Phase2Idle")
            end
            
        end

        if npc.State == 105 then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
            npc.Velocity = 0.75*npc.Velocity
            if npc.FrameCount % 90 == 0 then
                print("dim")
                local despairDimSoul = Isaac.Spawn(Isaac.GetEntityTypeByName("Dim's Soul"),Isaac.GetEntityVariantByName("Dim's Soul"),0,room:GetCenterPos()+Vector(500,0):Rotated(math.random(0,400)),Vector.Zero,npc):ToNPC()
                despairDimSoul:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                despairDimSoul:SetColor(Color(1,1,1,0), 30, 1, true, false)
                despairDimSoul.Velocity = Vector(10,0):Rotated(targetangle)
            end
            --npc.Color = Color(1,1,1,1)

            if data.despairPhase2TeleTimer ~= 0 then
                data.despairPhase2TeleTimer = data.despairPhase2TeleTimer - 1
            end
            --
            if data.despairPhase2ShootTimer == 0 then
                npc.State = 103
                sprite:Play("Phase2Shoot")
            end
            --
            if data.despairPhase2HorseTimer == 0 then
                print("honse")
                local despairHorse = Isaac.Spawn(Isaac.GetEntityTypeByName("Despair Horse"),Isaac.GetEntityVariantByName("Despair Horse"),0,Vector(500,500),Vector.Zero,npc):ToNPC()
                despairHorse.Color = Color(1,1,1,0)
                despairHorse:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                data.despairPhase2HorseTimer = data.despairPhase2HorseTimerMax
            else
                data.despairPhase2HorseTimer = data.despairPhase2HorseTimer - 1
            end
            --print(data.despairPhase2TeleTimer)
            --print(data.despairPhase2TeleTimer == 0)
            
        end

        if npc.State == 107 then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
            npc.Velocity = Vector.Zero
            if sprite:IsEventTriggered("Back") then

                local despairCrotchetySoul = Isaac.Spawn(Isaac.GetEntityTypeByName("Crotchety"),Isaac.GetEntityVariantByName("Crotchety"),0,npc.Position,Vector.Zero,npc):ToNPC()
                despairCrotchetySoul:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                despairCrotchetySoul:AddEntityFlags(EntityFlag.FLAG_REDUCE_GIBS)
                despairCrotchetySoul:SetColor(Color(1,1,1,0), 30, 1, true, false)
                despairCrotchetySoul:GetData().ghost = true
                npc.Position = Isaac.GetFreeNearPosition(game:GetRoom():GetRandomPosition(10), 5)
                sprite:Play("Appear") 
                npc.State = 108
            end
        end

        if npc.State == 108 then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
            npc.Velocity = Vector.Zero
            if sprite:IsEventTriggered("Back") then
                --npc.Position = Isaac.GetFreeNearPosition(game:GetRoom():GetRandomPosition(10), 5)
                sprite:Play("Phase2Idle")
                npc.State = 105
            end
        end


        if npc.State == 101 or npc.State == 102 then
            data.cantBeHurt = true
        else
            data.cantBeHurt = false
        end

    end
end

function DESPAIR:DamageCheck(npc, amount, _, _, _)
    if npc.Type == BotB.Enums.Entities.DESPAIR.TYPE and npc.Variant == BotB.Enums.Entities.DESPAIR.VARIANT then 
        local data = npc:GetData()
        --print("gunt2")
        if data.despairIsInPhase2 == true and data.despairPhase2TeleTimer == 0 then
            --print("gunt")
            SFXManager():Play(Isaac.GetSoundIdByName("SeducerAttack"),1,0,false,math.random(110,130)/100)

            data.despairPhase2TeleTimer = data.despairPhase2TeleTimerMax
            npc:ToNPC().State = 107
            npc:GetSprite():Play("Leave")
        end

        if data.cantBeHurt == true then
            return false
        end

        if amount >= npc.HitPoints then
            print("oh no its murder")
            local roomEntities = Game():GetRoom():GetEntities() -- cppcontainer
            for i = 0, #roomEntities - 1 do
                local entity = roomEntities:Get(i)
                if entity.Type == 150 and entity.Variant == 451 then
                    entity:Remove()
                end
                if entity.Type == BotB.Enums.Entities.DESPAIR_HORSE.TYPE and entity.Variant == BotB.Enums.Entities.DESPAIR_HORSE.VARIANT then
                    entity:Remove()
                end
                if entity.Type == Isaac.GetEntityTypeByName("Dim's Soul") and entity.Variant == Isaac.GetEntityVariantByName("Dim's Soul") then
                    entity:Remove()
                end
                if entity.Type == Isaac.GetEntityTypeByName("Shirk") and entity.Variant == Isaac.GetEntityVariantByName("Shirk") then
                    entity:Remove()
                end
            end

        end
    end
end


Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, DESPAIR.NPCUpdate, Isaac.GetEntityTypeByName("Despair"))
Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, DESPAIR.DamageCheck, Isaac.GetEntityTypeByName("Despair"))



function DESPAIR:HorseUpdate(npc)

    


    if npc.Type == BotB.Enums.Entities.DESPAIR_HORSE.TYPE and npc.Variant == BotB.Enums.Entities.DESPAIR_HORSE.VARIANT  then 

        --States:

        --100: ram start
        --101: ramming
        --102: ram fadeout
        local sprite = npc:GetSprite()
        local player = npc:GetPlayerTarget()
        local data = npc:GetData()
        local target = npc:GetPlayerTarget()
        local targetpos = target.Position
        local targetangle = (targetpos - npc.Position):GetAngleDegrees()
        local targetdistance = (targetpos - npc.Position):Length()
        local despairPathfinder = npc.Pathfinder
        local room = Game():GetRoom()
			local topLeft = room:GetTopLeftPos()
			local bottomRight = room:GetBottomRightPos()
			local sizeVec = bottomRight - topLeft
			local xLowThreshold = (topLeft.X + 0.1*sizeVec.X)
			local xHighThreshold = (topLeft.X + 0.9*sizeVec.X)
			local yLowThreshold = (topLeft.Y + 0.1*sizeVec.Y)
			local yHighThreshold = (topLeft.Y + 0.9*sizeVec.Y)
        if data.despairIsInPhase2 == nil then
            data.chargeEndBaseFrame = 0
            data.chargeEndRoomBaseFrame = 0
            data.doChargeEndRoom = false
            data.despairChargeTimerMax = 240
            data.despairChargeTimer = data.despairChargeTimerMax - 200
            data.despairChargeDir = 0
        end

        if npc.State == 0 then
            npc.Visible = false
            if not sprite:IsPlaying("Appear") then
                sprite:Play("Appear")
            end
            if sprite:IsFinished("Appear") then
                npc.State = 100
                sprite:Play("Idle")
            end
        end

        --print(npc.State)

        if npc.State == 100 then
            npc.Visible = false
            data.despairChargeDir = 0
                --Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.POOF01,0,npc.Position,Vector.Zero,npc)
                --left
                if data.despairChargeDir == 0 then
                    print("left")
                    npc.Position = (Vector(room:GetCenterPos().X,targetpos.Y)+Vector(510,0))
                end
                --right
                if data.despairChargeDir == 1 then
                    print("right")
                    npc.Position = (Vector(room:GetCenterPos().X,targetpos.Y)+Vector(-510,0))
                end
                npc.State = 101
                sprite:Play("Idle")
                npc:SetColor(Color(1,1,1,0), 15, 0, true, true)
            
        end

        if npc.State == 101 then
            npc.Visible = true
            npc.Color = Color(1,1,1,1)
            local pos = npc.Position

            if room:IsPositionInRoom(npc.Position, 0) and npc.FrameCount % 6 == 0 then
                if targetangle >= 0 and targetangle < 180 then
                    local params = ProjectileParams()
                    params.BulletFlags = ProjectileFlags.GHOST
                    params.Variant = 4
                    npc:FireProjectiles(npc.Position, Vector(0,10), 0, params)
                    mod:PlaySound(SoundEffect.SOUND_BLOODSHOOT, npc, 0.8, 1.5)
                    local effect = Isaac.Spawn(1000, 2, 5, npc.Position, Vector.Zero, npc):ToEffect()
                    effect.SpriteOffset = Vector(0,-6)
                    effect.DepthOffset = npc.Position.Y * 1.25
                    effect.Color = mod.ColorGhostly
                else
                    local params = ProjectileParams()
                    params.BulletFlags = ProjectileFlags.GHOST
                    params.Variant = 4
                    npc:FireProjectiles(npc.Position, Vector(0,-10), 0, params)
                    mod:PlaySound(SoundEffect.SOUND_BLOODSHOOT, npc, 0.8, 1.5)
                    local effect = Isaac.Spawn(1000, 2, 5, npc.Position, Vector.Zero, npc):ToEffect()
                    effect.SpriteOffset = Vector(0,-6)
                    effect.DepthOffset = npc.Position.Y * 1.25
                    effect.Color = mod.ColorGhostly
                end
            end

            --print(npc.Position.X .. " , " .. npc.Position.Y)
            --
            if data.despairChargeDir == 0 then
                --left
                npc.FlipX = true
                --print("left?")
                npc.Velocity = Vector(-15,0)
                --
                if npc.Position.X <= xLowThreshold and npc.FrameCount >= 120 then
                    --print("alerta " .. npc.Position.X .. " , " .. npc.Position.Y)
                    --npc.Position = (room:GetCenterPos())
                    data.despairChargeTimer = data.despairChargeTimerMax
                    npc.Color = Color(1,1,1,0)
                    npc:SetColor(Color(1,1,1,1), 5, 1, true, false)
                    npc.State = 102
                    data.chargeEndBaseFrame = npc.FrameCount
                    --sprite:Play("FullFloat")
                end
                
            else
                --right
                npc.FlipX = false
                --print("right?")
                npc.Velocity = Vector(15,0)
                --local pos = npc.Position
                --
                if npc.Position.X >= xHighThreshold and npc.FrameCount >= 120 then
                    --print("alerta " .. npc.Position.X .. " , " .. npc.Position.Y)
                    data.despairChargeTimer = data.despairChargeTimerMax
                    --npc:SetColor(Color(1,1,1,0), 15, 0, true, true)
                    npc.Color = Color(1,1,1,0)
                    npc:SetColor(Color(1,1,1,1), 5, 1, true, false)
                    npc.State = 102
                    data.chargeEndBaseFrame = npc.FrameCount
                    --sprite:Play("FullFloat")
                end
                
            end
            
        end

        if npc.State == 102 then
            ----print(npc.Position)
            if npc.FrameCount == data.chargeEndBaseFrame + 60 then
                --npc.Color = Color(1,1,1,0)
                if data.despairChargeDir == 0 then
                    npc.Position = (Vector(room:GetCenterPos().X,targetpos.Y)+Vector(300,0))
                else
                    npc.Position = (Vector(room:GetCenterPos().X,targetpos.Y)+Vector(-300,0))
                end
                --npc.Position = (room:GetCenterPos())
                --npc:SetColor(Color(1,1,1,1), 30, 1, true, false)
                
            end
            --
            ----print(room:IsPositionInRoom(npc.Position, 10))
            if room:IsPositionInRoom(npc.Position, 10) then
                --data.doChargeEndRoom = true
                --data.chargeEndRoomBaseFrame = npc.FrameCount
                npc.Velocity = 0.8*npc.Velocity
                
            end
            if data.doChargeEndRoom then
                npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                npc.Color = Color(1,1,1,1)
                npc:SetColor(Color(1,1,1,0), 5, 1, true, false)
                data.doChargeEndRoom = false
            end
            if npc.FrameCount == data.chargeEndBaseFrame + 120 or npc.Velocity:Length() <= 1 then
                npc:Remove()
            end
        end

       
    end
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, DESPAIR.HorseUpdate, Isaac.GetEntityTypeByName("Despair Horse"))




