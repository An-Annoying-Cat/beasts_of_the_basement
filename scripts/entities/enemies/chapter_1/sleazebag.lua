--Old

--
local Mod = BotB
local SLEAZEBAG = {}
local Entities = BotB.Enums.Entities

function SLEAZEBAG:NPCUpdate(npc)
    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()
    --Sleazebag (This just plays the wheeze sound)
    if Entities.SLEAZEBAG.TYPE and npc.Variant == Entities.SLEAZEBAG.VARIANT then 
        if npc.State == 8 then npc.State = 99 sprite:PlayOverlay("HeadAttack") end 
            if npc.State == 99 then
                if npc.StateFrame == 23 then npc.State = 3 npc.StateFrame = 0 end
                if sprite:IsEventTriggered("Shoot") then
                    sfx:Play(Isaac.GetSoundIdByName("Wheeze"),1,0,false,math.random(75, 85)/100)
                    --npc:PlaySound(SoundEffect.SOUND_BOIL_HATCH, 1, 0, false, math.random(75,85)/100)
                    --local spawnedSkuzz = Isaac.Spawn(666, 60, 0, npc.Position, Vector.Zero, npc)
                end
            end
    end   
end



--Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, SLEAZEBAG.NPCUpdate, Isaac.GetEntityTypeByName("Sleazebag"))

--[[
local Mod = BotB
local SLEAZEBAG = {}
local Entities = BotB.Enums.Entities

function SLEAZEBAG:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local data = npc:GetData()
    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()
    local sleazebagPathfinder = npc.Pathfinder
    local room = Game():GetRoom()

    if npc.Type == BotB.Enums.Entities.SLEAZEBAG.TYPE and npc.Variant == BotB.Enums.Entities.SLEAZEBAG.VARIANT then 
        if data.sleazebagSpawnCooldownMax == nil then
            data.sleazebagSpawnCooldownMax = 80
            data.sleazebagSpawnCooldown = data.sleazebagSpawnCooldownMax

        end
        data.targPos = targetpos
        --:AnimWalkFrame(HorizontalAnim, VerticalAnim, SpeedThreshold)
        --States:
        --99: Walk
        --100: Summon a Slight
        npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
        if npc.State == 0 then
            --Init
            if not sprite:IsPlaying("Appear") then
                sprite:Play("Appear")
            end
            if sprite:IsFinished("Appear") then
                npc.State = 99
                sprite:PlayOverlay("HeadWalk")
            end
        end

        if npc.State == 99 then
            npc:AnimWalkFrame("WalkHori", "WalkVert", 1)
            sleazebagPathfinder:EvadeTarget(targetpos)
            --sleazebagPathfinder:EvadeTarget(targetpos)
            --print(data.sleazebagSpawnCooldown)
            if data.sleazebagSpawnCooldown ~= 0 then
                data.sleazebagSpawnCooldown = data.sleazebagSpawnCooldown - 1
            else
                    if Isaac.CountEntities(npc, 666, 60) < 3 then
                        
                        sprite:PlayOverlay("HeadAttack")
                        npc.State = 100
                        data.sleazebagSpawnCooldown = data.sleazebagSpawnCooldownMax
                        local spawnedSkuzz = Isaac.Spawn(666, 60, 0, npc.Position, Vector.Zero, npc):ToNPC()
                    end
            end
        end

        if npc.State == 100 then
            --sfx:Play(Isaac.GetSoundIdByName("SeducerAttack"),1,0,false,math.random(110,130)/100)
            local spawnedSkuzz = Isaac.Spawn(666, 81, 0, npc.Position, Vector.Zero, npc):ToNPC()
            if sprite:GetOverlayFrame() == 5 then
                sfx:Play(Isaac.GetSoundIdByName("Wheeze"),1,0,false,math.random(75, 85)/100)
                    npc:PlaySound(SoundEffect.SOUND_BOIL_HATCH, 1, 0, false, math.random(75,85)/100)
                    --FiendFolio.spawnent(npc, npc.Position, Vector(0,0), 666, 81, 0)
                    
                    --spawnedSkuzz:GetSprite():Load("gfx/enemies/skuzzball/skuzz.anm2",true)
			        --FiendFolio:spritePlay(spawnedSkuzz:GetSprite(), "Appear")
                    --spawnedSkuzz:Morph(666,60,0,0)
                    --spawnedSkuzz:AddEntityFlags(EntityFlag.FLAG_APPEAR)
                    --spawnedSkuzz:GetSprite():Play("Idle")
                    --FiendFolio:skuzzai(spawnedSkuzz, spawnedSkuzz:GetSprite(), spawnedSkuzz:GetData())
            end
            if sprite:GetOverlayFrame() == 10 then
                sprite:PlayOverlay("HeadWalk")
                npc.State = 99
            end
            
            
        end
        
    end
end


Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, SLEAZEBAG.NPCUpdate, Isaac.GetEntityTypeByName("Sleazebag"))


function SLEAZEBAG:DamageCheck(npc, amount, _, _, _)
    if npc.Variant ~= BotB.Enums.Entities.SLEAZEBAG.VARIANT then return end
    --print("sharb")
    local npcConv = npc:ToNPC()
    local data = npc:GetData()
    local sprite = npc:GetSprite()
    if npc.Type == BotB.Enums.Entities.SLEAZEBAG.TYPE and npc.Variant == BotB.Enums.Entities.SLEAZEBAG.VARIANT then 
        if amount >= npc.HitPoints then
            
        end 
    end
    --return true
end


Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, SLEAZEBAG.DamageCheck, Isaac.GetEntityTypeByName("Sleazebag"))
]]