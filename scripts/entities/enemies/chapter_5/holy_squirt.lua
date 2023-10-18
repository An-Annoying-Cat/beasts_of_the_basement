local Mod = BotB
local HOLY_SQUIRT = {}
local Entities = BotB.Enums.Entities
local mod = FiendFolio

local function getNonDivineEnemies()
    local roomEntities = Isaac.GetRoomEntities() -- table
    local vulnerableEnemies = {}
    for i = 1, #roomEntities do
        local entity = roomEntities[i]
        if entity:IsVulnerableEnemy() and EntityRef(entity).IsFriendly == false and entity:GetData().botbHasDivine ~= true then
            vulnerableEnemies[#vulnerableEnemies+1] = entity
        end
    end
    
  
	return vulnerableEnemies
end

function HOLY_SQUIRT:NPCUpdate(npc)
    if npc.Type == BotB.Enums.Entities.HOLY_SQUIRT.TYPE and npc.Variant == BotB.Enums.Entities.HOLY_SQUIRT.VARIANT then 
        local sprite = npc:GetSprite()
        local player = npc:GetPlayerTarget()
        local data = npc:GetData()
        local target = npc:GetPlayerTarget()
        local targetpos = target.Position
        local targetangle = (targetpos - npc.Position):GetAngleDegrees()
        local targetdistance = (targetpos - npc.Position):Length()
        if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_GROUND then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        end
        npc.SplatColor = Color(0.75,1,1,1,0.75,1,1)
        if npc.State == 0 then
            sprite:PlayOverlay("Halo")
            if sprite:IsPlaying("Appear") ~= true then
                sprite:Play("Appear")
            end
            if sprite:IsFinished("Appear") then
                sprite:Play("Idle")
                data.botbHolySquirtMoveCooldownMax = 60
                data.botbHolySquirtMoveCooldown = data.botbHolySquirtMoveCooldownMax
                data.botbHolySquirtNyoomAngle = 0
                data.botbHolySquirtDeathSpawned = false
                data.botbHasDivine = true
                npc.State = 99
            end
        end
        if npc.State == 99 then
            npc:AnimWalkFrame("Idle","Idle",0)
            npc.Velocity = (0.89 * npc.Velocity) + (0.01 * (targetpos - npc.Position):Resized(npc.Velocity:Length()))
            if data.botbHolySquirtMoveCooldown ~= 0 then
                data.botbHolySquirtMoveCooldown = data.botbHolySquirtMoveCooldown - 1
            else
                npc.State = 98
                
                sprite:Play("Attack01")
            end
        end
        --99:idle
        --98: windup
        --101: dash
        if npc.State == 98 then
            if sprite:IsEventTriggered("Slide") then
                data.botbHolySquirtNyoomAngle = targetangle
                npc.Velocity = Vector(16,0):Rotated(data.botbHolySquirtNyoomAngle)
                npc:PlaySound(SoundEffect.SOUND_CHILD_HAPPY_ROAR_SHORT,1,0,false,math.random(120,160)/100)
            end
            if sprite:IsFinished("Attack01") then
                npc.State = 100
                sprite:Play("Slide")
            end
        end
        if npc.State == 100 then
            npc:AnimWalkFrame("Slide","Slide",0.1)
            npc.Velocity = (0.8 * npc.Velocity) + (0.19 * (targetpos - npc.Position):Resized(npc.Velocity:Length()))
            if npc.Velocity:Length() <= 2 then
                npc.State = 99
                sprite:Play("Idle")
                data.botbHolySquirtMoveCooldown = data.botbHolySquirtMoveCooldownMax
            end
        end
        if npc:HasMortalDamage() and data.botbHolySquirtDeathSpawned == false then
            local botbHolySquirtBeamPos = npc.Position
            data.botbHolySquirtDeathSpawned = true
            local holdAngle = math.random(0,359)
            Isaac.Spawn(BotB.Enums.Entities.HOLY_DIP.TYPE,BotB.Enums.Entities.HOLY_DIP.VARIANT,0,npc.Position, Vector(2,0):Rotated(holdAngle),npc)
            Isaac.Spawn(BotB.Enums.Entities.HOLY_DIP.TYPE,BotB.Enums.Entities.HOLY_DIP.VARIANT,0,npc.Position, Vector(-2,0):Rotated(holdAngle),npc)
            local botbEnlightenmentDelay = 150
            for i = 1, botbEnlightenmentDelay do
                BotB.FF.scheduleForUpdate(function()
                    --print(i)
                    if i >= botbEnlightenmentDelay then
                        --Utter goddamn chaos
						
						local botbEnlightenmentVirtueBeam = Isaac.Spawn(1000,mod.FF.ZealotBeam.Var,mod.FF.ZealotBeam.Sub,botbHolySquirtBeamPos,Vector.Zero,player):ToEffect()
						botbEnlightenmentVirtueBeam:GetData().botbVirtueBeamIsFromHolySquirt = true
						botbEnlightenmentVirtueBeam.SpriteScale = Vector(1,1)
                        botbEnlightenmentVirtueBeam:SetTimeout(240)
						--botbEnlightenmentVirtueBeam:SetDamageSource(EntityType.ENTITY_PLAYER)
						local botbEnlightenmentVirtueSprite = botbEnlightenmentVirtueBeam:GetSprite()
						for j = 0, 2 do
							botbEnlightenmentVirtueSprite:ReplaceSpritesheet(i, "gfx/enemies/zealot/monster_zealot_cathedral.png")
						end
						
						botbEnlightenmentVirtueSprite:LoadGraphics()
						
						--Play the sound
						--SFXManager():Play(Isaac.GetSoundIdByName("EnlightenmentFire"),10,0,false,math.random(90, 110)/100)
					elseif i == 1 then
						botbHolySquirtBeamPos = npc.Position
						--Warning!!
						local warningTarget = Isaac.Spawn(EntityType.ENTITY_EFFECT,BotB.Enums.Entities.WARNING_TARGET.VARIANT,0,botbHolySquirtBeamPos,Vector(0,0),nil):ToEffect()
						warningTarget.Color = Color(1,1,1,1,1,2,2)
						warningTarget.SpriteScale = Vector(3,3)
                    else
						botbHolySquirtBeamPos = npc.Position
                        --Nothing lol
                    end
                    
                end, i, ModCallbacks.MC_NPC_UPDATE)
				
            end






        end
    end
end


Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, HOLY_SQUIRT.NPCUpdate, Isaac.GetEntityTypeByName("Holy Dip"))