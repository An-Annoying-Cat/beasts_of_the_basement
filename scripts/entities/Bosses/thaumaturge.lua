local Mod = BotB
local THAUMATURGE = {}
local Entities = BotB.Enums.Entities
local game = Game()
local mod = BotB.FF

function THAUMATURGE:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local data = npc:GetData()
    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()
    local thaumaturgePathfinder = npc.Pathfinder


    if npc.Type == BotB.Enums.Entities.THAUMATURGE.TYPE and npc.Variant == BotB.Enums.Entities.THAUMATURGE.VARIANT and BotB.Enums.Entities.THAUMATURGE.SUBTYPE then 

        --States:
        -- 3: Basic idle
        -- 99: Debuff projectile attack
        -- 13: Teleport shortcut
        -- 100: Single teleport start
        -- 101: Single teleport end

        -- 102: Multi-teleport idle
        -- 103, 104: Multi-teleport with homing shots

        -- 105: Teleport out for other attack
        -- 106: Invincible idle while other attack goes on
        -- 107: Teleport in when attack is done
        -- 

        if data.CastTimer == nil then
            data.CastTimer = 0
            data.CastTimerMax = 30
            data.cantBeHurt = false
            data.teleTimer = 120
            data.teleTimerMax = 120
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
            data.modeSwitchTimer = 60
            data.modeSwitchTimerMax = 60
            data.multiTeleCounter = 0
            data.multiTeleCounterMax = 3
        end



        if targetdistance <= 100 and npc.State == 3 then
            npc.State = 13
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
        if npc.State == 13 then 
            data.cantBeHurt = true
            npc.State = 100
            npc.Color = Color(256, 256, 256)
            sprite:Play("TeleOut") 
            npc.StateFrame = 0
        end
        --Attack
        if npc.State == 99 then
            if sprite:IsEventTriggered("Back") then 
                npc.State = 3
                sprite:Play("Idle")
                --npc.StateFrame = 0
            end
            if sprite:IsEventTriggered("Shoot") then

                for angleoffset=-30,30,30 do
                    local targcoord = mod:intercept(npc, target, 9.5)
                    local shootvec = targcoord:Normalized() * 20
                    npc:PlaySound(Mod.Enums.SFX.THAUMATURGE_SHOOT, 4, 0, false, mod:RandomInt(120,130)/100)
                    npc:PlaySound(SoundEffect.SOUND_BLOODSHOOT, 1.3, 0, false, 0.8)
                    local proj = Isaac.Spawn(mod.FF.DebuffProjectile.ID, mod.FF.DebuffProjectile.Var, mod:RandomInt(2,4), npc.Position, shootvec:Rotated(angleoffset), npc)
                    proj:GetData().isSpiked = false
                    proj:GetData().EffectTime = 60 --Default to 120 if this isn't there
                    local effect = Isaac.Spawn(1000, 2, 5, npc.Position, Vector.Zero, npc):ToEffect()
                    effect.SpriteOffset = Vector(0,-14)
                    effect.DepthOffset = npc.Position.Y * 1.25
                    local s = effect:GetSprite()
                    s:ReplaceSpritesheet(4, "gfx/effects/effect_002_bloodpoof_alt_white.png")
		            s:LoadGraphics()
		            effect.Color = mod.duskDebuffCols[proj.SubType]

                    --sfx:Play(Isaac.GetSoundIdByName("SeducerAttack"),0.4,0,false,math.random(80,90)/100)
                end
                    data.CastTimer = data.CastTimerMax
            end
        end

        --Teleport (Basic)
        if npc.State == 100 then
            if sprite:IsEventTriggered("Move") then 
                newPosition = game:GetRoom():GetRandomPosition(100)
                npc.Position = newPosition
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
            thaumaturgePathfinder:MoveRandomly()
            npc.Target = npc:GetPlayerTarget()
            if npc.Color ~= Color(1, 0, 0) then
                npc.Color = Color(1, 0, 0)
            end
            data.modeSwitchTimer = data.modeSwitchTimer - 1
            print(data.modeSwitchTimer)
            if data.modeSwitchTimer == 0 then
                data.nextAttack = math.random(0,1)
                if data.nextAttack == 0 then
                    npc.State = 3
                    data.modeSwitchTimer = data.modeSwitchTimerMax
                elseif data.nextAttack == 1 then
                    npc.State = 102
                    data.modeSwitchTimer = data.modeSwitchTimerMax
                end
            end
        end









        --Multi teleport init
        if npc.State == 102 then
            npc:PlaySound(Mod.Enums.SFX.THAUMATURGE_TAUNT, 4, 0, false, mod:RandomInt(120,130)/100)
            data.multiTeleCounter = data.multiTeleCounterMax
            sprite:Play("TeleOut")
            npc.State = 103
        end
        --Multi teleport out
        if npc.State == 103 then
            if sprite:IsEventTriggered("Move") then 
                newPosition = player.Position+Vector(200,0):Rotated(math.random(0,359))
                npc.Position = newPosition
                npc.State = 104
                sfx:Play(SoundEffect.SOUND_HELL_PORTAL1,1,0,false,math.random(80,90)/100)
                sprite:Play("TeleIn")
                npc.StateFrame = 0
            end
            if sprite:IsEventTriggered("On") then
                sfx:Play(SoundEffect.SOUND_HELL_PORTAL2,1,0,false,math.random(80,90)/100)
                
            end
        end
        --Multi teleport in
        if npc.State == 104 then
            if sprite:IsEventTriggered("Off") then 
                data.cantBeHurt = false
                npc.Color = Color(1, 1, 1)
                multiTeleProjParams = ProjectileParams()
                multiTeleProjParams.BulletFlags = ProjectileFlags.SMART
                multiTeleProjParams.Color = Color(1,0,1)
                multiTeleProjParams.HomingStrength = 1
                multiTeleProjParams.Scale = 1
                multiTeleProjParams.FallingSpeedModifier = 0.5
                --Volley of 8 on last teleport
                if data.multiTeleCounter == 0 then
                    multiTeleProjParams.Scale = 1
                    npc:FireProjectiles(npc.Position, Vector(15,0), 6, multiTeleProjParams)
                    multiTeleProjParams.Scale = 1.5
                    multiTeleProjParams.FallingSpeedModifier = 0.0001
                    npc:FireProjectiles(npc.Position, Vector(7.5,0), 7, multiTeleProjParams)
                else
                    if data.multiTeleCounter % 2 == 0 then
                        npc:FireProjectiles(npc.Position, Vector(12,0), 6, multiTeleProjParams)
                    else
                        npc:FireProjectiles(npc.Position, Vector(12,0), 7, multiTeleProjParams)
                    end
                end
                if data.multiTeleCounter ~= 0 then
                    data.multiTeleCounter = data.multiTeleCounter - 1
                    npc.State = 103
                    sprite:Play("TeleOut") 
                    --npc.StateFrame = 0
                else
                    npc.State = 3
                    sprite:Play("Idle")
                    --npc.StateFrame = 0
                end
            end
        end

        --Projectile drop






        if data.CastTimer ~= 0 then
            data.CastTimer = data.CastTimer - 1
        end

        if data.teleTimer ~= 0 then
            --print(data.teleTimer)
            data.teleTimer = data.teleTimer - 1
        end




    end
end

function THAUMATURGE.DamageCheck(npc, _, _, _, _)
    if npc.Type == BotB.Enums.Entities.THAUMATURGE.TYPE and npc.Variant == BotB.Enums.Entities.THAUMATURGE.VARIANT and BotB.Enums.Entities.THAUMATURGE.SUBTYPE then 
        local data = npc:GetData()
        if data.cantBeHurt then
            --sfx:Play(Isaac.GetSoundIdByName("SeducerAttack"),1,0,false,math.random(110,130)/100)
            return false
        else
            return true
        end
    end
end


Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, THAUMATURGE.NPCUpdate, Isaac.GetEntityTypeByName("Thaumaturge"))
Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, THAUMATURGE.DamageCheck, Isaac.GetEntityTypeByName("Thaumaturge"))