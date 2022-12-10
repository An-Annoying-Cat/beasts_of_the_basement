local Mod = BotB
local SEDUCER = {}
local Entities = BotB.Enums.Entities

function SEDUCER:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()

    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()


    if npc.Type == BotB.Enums.Entities.SEDUCER.TYPE and npc.Variant == BotB.Enums.Entities.SEDUCER.VARIANT then 
        if npc.State == 8 then npc.State = 9 sprite:Play("ShootDown") end 
            if npc.State == 9 then
                if npc.StateFrame == 23 then npc.State = 3 npc.StateFrame = 0 end
                if sprite:IsEventTriggered("Shoot") then
                    sfx:Play(Isaac.GetSoundIdByName("SeducerAttack"),1,0,false,math.random(110,130)/100)
                    --Creep spawning
                    local creep = Isaac.Spawn(1000, 22, 0, npc.Position, Vector(0,0), npc)
				    creep.SpriteScale = creep.SpriteScale * 3
                    creep:Update()
				    for i = 1, 3 do
				    	local creep = Isaac.Spawn(1000, 22, 0, npc.Position + 2*(Vector.FromAngle(i * (360 / 3)) * 22), Vector(0,0), npc)
                        creep:Update()
				    end
                    --Fire a projectile
                    local bullet = Isaac.Spawn(9, 0, 0, npc.Position, Vector(math.floor(0.05 * targetdistance * (math.random(8, 10) / 10), 6),0):Rotated(targetangle), npc):ToProjectile()
                    bullet.FallingSpeed = -30;
		            bullet.FallingAccel = 2
		            bullet.Height = -10
                    bullet.Parent = npc
				    	
				    
                end
            end

            if sprite:IsEventTriggered("Land") then
                local creep = Isaac.Spawn(1000, 22, 0, npc.Position, Vector.Zero, npc)
				creep.SpriteScale = creep.SpriteScale * 2
            end
        end
end


Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, SEDUCER.NPCUpdate, Isaac.GetEntityTypeByName("Seducer"))