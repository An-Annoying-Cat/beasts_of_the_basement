local Mod = BotB
local SEDUCER = {}
local Entities = BotB.Enums.Entities

--Even though they're a Slacker, she's still a seducer in our hearts

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
                    sfx:Play(Isaac.GetSoundIdByName("SeducerAttack"),1,0,false,math.random(70,90)/100)
                    --Creep spawning
                    local creep = Isaac.Spawn(1000, 23, 0, npc.Position, Vector(0,0), npc)
				    creep.SpriteScale = creep.SpriteScale * 3
                    creep:Update()
				    for i = 1, 3 do
				    	local creep = Isaac.Spawn(1000, 22, 0, npc.Position + 2*(Vector.FromAngle(i * (360 / 3)) * 22), Vector(0,0), npc)
                        creep:Update()
				    end
                    --Fire a projectile
                    local bullet = Isaac.Spawn(9, 0, 0, npc.Position, Vector(math.floor(0.05 * targetdistance * (math.random(8, 10) / 10), 6),0):Rotated(targetangle):Resized(15), npc):ToProjectile()
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

function SEDUCER:BulletCheck(bullet)

    --Seducer projectiles spawn red creep when they splat
    if bullet.Parent ~= nil and bullet.Parent.Type == BotB.Enums.Entities.SEDUCER.TYPE and bullet.Parent.Variant == BotB.Enums.Entities.SEDUCER.VARIANT then
        
        
        if bullet:IsDead() then
            sfx:Play(SoundEffect.SOUND_ANIMAL_SQUISH,1,0,false,math.random(120,150)/100)
            local creep = Isaac.Spawn(1000, EffectVariant.CREEP_GREEN, 0, bullet.Position, Vector(0,0), bullet)
            creep.SpriteScale = creep.SpriteScale * 1.5
        end
      end
    

end



Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, SEDUCER.NPCUpdate, Isaac.GetEntityTypeByName("Seducer"))
Mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, SEDUCER.BulletCheck)