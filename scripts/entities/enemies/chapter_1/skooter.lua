local Mod = BotB
local SKUZZ = {}
local Entities = BotB.Enums.Entities

function SKUZZ:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()

    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()

    --skooter, super skooter
    if npc.Variant == Isaac.GetEntityVariantByName("Skuzz") and npc.SubType ~= nil and (npc.SubType == Entities.SUPER_SKOOTER.SUBTYPE or npc.SubType == Entities.SKOOTER.SUBTYPE) then
        if sprite:IsPlaying("hopstart") then
            if sprite:GetFrame() == 1 then
                if npc.SubType == Entities.SUPER_SKOOTER.SUBTYPE then
                    npc:PlaySound(SoundEffect.SOUND_BLOODSHOOT,1,0,false,1)
                local projectile = Isaac.Spawn(9, 0, 0, npc.Position, Vector(math.floor(0.05 * targetdistance * (math.random(8, 10) / 10), 6),0):Rotated(targetangle-15), npc):ToProjectile();
		        projectile.FallingSpeed = -30;
		        projectile.FallingAccel = 2
		        projectile.Height = -10
                local projectile2 = Isaac.Spawn(9, 0, 0, npc.Position, Vector(math.floor(0.05 * targetdistance * (math.random(8, 10) / 10), 6),0):Rotated(targetangle+15), npc):ToProjectile();
		        projectile2.FallingSpeed = -30;
		        projectile2.FallingAccel = 2
		        projectile2.Height = -10
                elseif npc.SubType == Entities.SKOOTER.SUBTYPE then
                npc:PlaySound(SoundEffect.SOUND_BLOODSHOOT,1,0,false,1)
                local projectile = Isaac.Spawn(9, 0, 0, npc.Position, Vector(math.floor(0.05 * targetdistance * (math.random(8, 10) / 10), 6),0):Rotated(targetangle), npc):ToProjectile();
		        projectile.FallingSpeed = -30;
		        projectile.FallingAccel = 2
		        projectile.Height = -10
                end
            end
            --npc:PlaySound(BotB.FF.Sounds.FunnyFart,1,0,false,math.random(120,150)/100)
        end
    end


end

Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, SKUZZ.NPCUpdate, Isaac.GetEntityTypeByName("Skuzz"))