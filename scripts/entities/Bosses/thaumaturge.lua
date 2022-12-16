local Mod = BotB
local THAUMATURGE = {}
local Entities = BotB.Enums.Entities
local game = Game()
local mod = BotB.FF

function THAUMATURGE:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local data = npc:GetData()
    if data.CastTimer == nil then
        data.CastTimer = 0
        data.CastTimerMax = 60
        data.cantBeHurt = false
    end

    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()
    local kehehanPathfinder = npc.Pathfinder


    if npc.Type == BotB.Enums.Entities.THAUMATURGE.TYPE and npc.Variant == BotB.Enums.Entities.THAUMATURGE.VARIANT and BotB.Enums.Entities.THAUMATURGE.SUBTYPE then 


        if targetdistance <= 100 then
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

                local targcoord = mod:intercept(npc, target, 9.5)
                local shootvec = targcoord:Normalized() * 20
                npc:PlaySound(SoundEffect.SOUND_GHOST_SHOOT, 0.8, 0, false, mod:RandomInt(110,120)/100)
                npc:PlaySound(SoundEffect.SOUND_BLOODSHOOT, 1.3, 0, false, 0.8)
                local proj = Isaac.Spawn(mod.FF.DebuffProjectile.ID, mod.FF.DebuffProjectile.Var, mod:RandomInt(2,4), npc.Position, shootvec, npc)
                proj:GetData().isSpiked = true
                proj:GetData().EffectTime = 60 --Default to 120 if this isn't there
                local effect = Isaac.Spawn(1000, 2, 5, npc.Position, Vector.Zero, npc):ToEffect()
                effect.SpriteOffset = Vector(0,-14)
                effect.DepthOffset = npc.Position.Y * 1.25
                local s = effect:GetSprite()
                s:ReplaceSpritesheet(4, "gfx/effects/effect_002_bloodpoof_alt_white.png")
		        s:LoadGraphics()
		        effect.Color = mod.duskDebuffCols[proj.SubType]

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
        end


        if data.CastTimer ~= 0 then
            data.CastTimer = data.CastTimer - 1
        end




    end
end

function THAUMATURGE.DamageCheck(npc, _, _, _, _)
    if npc.Type == BotB.Enums.Entities.THAUMATURGE.TYPE and npc.Variant == BotB.Enums.Entities.THAUMATURGE.VARIANT and BotB.Enums.Entities.THAUMATURGE.SUBTYPE then 
        local data = npc:GetData()
        if data.cantBeHurt then
            sfx:Play(Isaac.GetSoundIdByName("SeducerAttack"),1,0,false,math.random(110,130)/100)
            return false
        else
            return true
        end
    end
end


Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, THAUMATURGE.NPCUpdate, Isaac.GetEntityTypeByName("Thaumaturge"))
Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, THAUMATURGE.DamageCheck, Isaac.GetEntityTypeByName("Thaumaturge"))