local Mod = BotB
local MR_MUCUS = {}
local Entities = BotB.Enums.Entities
local FF = Mod.FF

function MR_MUCUS:MrMucusAI(npc)
    if npc.Variant == Entities.MR_MUCUS.VARIANT then
		local sprite = npc:GetSprite()
		local d = npc:GetData()
		local target = npc:GetPlayerTarget()
		local path = npc.Pathfinder
		local r = npc:GetDropRNG()
		local room = Mod.Game:GetRoom()
		local speeds = {4, 0.6}
		--[[if variant == mod.FF.MrRedHorf.Var then
			headchoice = mod.FF.MrRedHorfHead.Var
			speeds = {6, 0.8}
		end]]
		npc.SplatColor = FF.ColorSpittyGreen
		if not d.BotB_init then
			d.BotB_init = true
			d.BotB_state = "idle"
			d.BotB_randWait = r:RandomInt(30)
			FF:spriteOverlayPlay(sprite, "Head")
		else
			npc.StateFrame = npc.StateFrame + 1
		end

		if sprite:IsOverlayFinished("Head") then
			FF:spriteOverlayPlay(sprite, "HeadIdle")
		end
		if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_GROUND then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
        end
		if d.BotB_state == "idle" then
			if npc.Velocity:Length() > 0.1 then
				npc:AnimWalkFrame("WalkHori","WalkVert",0)
			else
				sprite:SetFrame("WalkVert", 0)
			end

			local targetpos = FF:confusePos(npc, target.Position)
			if room:CheckLine(npc.Position,targetpos,0,1,false,false) or FF:isScare(npc) then
				local targetvel = FF:reverseIfFear(npc, (targetpos - npc.Position):Resized(speeds[1]))
				npc.Velocity = FF:Lerp(npc.Velocity, targetvel,0.25)
			else
				path:FindGridPath(targetpos, speeds[2], 900, true)
			end

			if (not FF:isScareOrConfuse(npc)) and npc.StateFrame > 10 + d.BotB_randWait and r:RandomInt(10) == 1
			and room:GetGridCollisionAtPos(npc.Position) == GridCollisionClass.COLLISION_NONE
			and ((math.abs(target.Position.X - npc.Position.X) <= 30) or (math.abs(target.Position.Y - npc.Position.Y) <= 30)) then
				d.BotB_state = "throw"
				d.BotB_backupThrowpos = npc.Position
				if target.Position.X > npc.Position.X then
					sprite.FlipX = false
				else
					sprite.FlipX = true
				end
			end
		elseif d.BotB_state == "throw" then
			if sprite:IsFinished("HeadThrow") then
				local newvar = 1
				if r:RandomInt(3) == 1 then
					newvar = 0
				end
				if newvar == 0 then
					npc:Morph(Entities.FLEMMER.TYPE, Entities.FLEMMER.VARIANT, 0, -1)
				else
					npc:Morph(Entities.FLEMMER.TYPE, Entities.FLEMMER.VARIANT, 0, -1)
				end
				

			elseif sprite:IsPlaying("HeadThrow") and sprite:GetFrame() == 6 then
				npc:PlaySound(FF.Sounds.ClothRip,0.3,0,false,math.random(155,175)/100)

			elseif sprite:IsEventTriggered("Shoot") then
				d.BotB_hasthrown = true
				npc:PlaySound(SoundEffect.SOUND_SHAKEY_KID_ROAR,1,0,false,0.9)

				
				local spitum = Isaac.Spawn(Isaac.GetEntityTypeByName("Spitum"), Isaac.GetEntityVariantByName("Spitum"), 0, npc.Position, Vector(0,0), npc):ToNPC()
				spitum:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				spitum.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
				spitum.GridCollisionClass = GridCollisionClass.COLLISION_NONE
				spitum:GetData().state = "airtime"
				spitum:GetData().init = true
				spitum.Velocity = (Vector(target.Position.X - npc.Position.X, target.Position.Y - npc.Position.Y) * 0.035) + RandomVector():Resized(math.random(50, 100) *  0.0005)
				spitum.MaxHitPoints = spitum.MaxHitPoints * 0.75
				spitum.HitPoints = spitum.MaxHitPoints
				spitum.SpriteScale = spitum.SpriteScale
				spitum.SplatColor = FF.ColorSpittyGreen

				d.BotB_bounding = true

				npc.HitPoints = npc.MaxHitPoints

				if target.Position.X > npc.Position.X then
					sprite.FlipX = false
				else
					sprite.FlipX = true
				end
			elseif sprite:IsEventTriggered("Bomp") then
				d.BotB_bounding = false
			else
				FF:spritePlay(sprite, "HeadThrow")
				sprite:RemoveOverlay()
			end
			if not d.BotB_bounding then
				npc.Velocity = npc.Velocity * 0.1
			else
				npc.Velocity = npc.Velocity * 0.9
			end
		end
	end
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, MR_MUCUS.MrMucusAI, Entities.MR_MUCUS.TYPE)

function MR_MUCUS:MsHorfKill(npc)
    if npc.Variant == Entities.MR_MUCUS.VARIANT then
		if not (npc:HasEntityFlags(EntityFlag.FLAG_FREEZE) or npc:HasEntityFlags(EntityFlag.FLAG_MIDAS_FREEZE) or FF:isLeavingStatusCorpse(npc)) then
			local d = npc:GetData()
			if not d.BotB_hasthrown then
				local r = npc:ToNPC():GetDropRNG()

				--local newvar = 1
				if r:RandomInt(3) == 1 then
					--newvar = 0
					local spawned = Isaac.Spawn(Entities.FLEMMER.TYPE, Entities.FLEMMER.VARIANT, 0, npc.Position, npc.Velocity, npc)
					spawned:ToNPC():Morph(spawned.Type, spawned.Variant, spawned.SubType, npc:ToNPC():GetChampionColorIdx())
					spawned.HitPoints = spawned.MaxHitPoints
					spawned:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	
					if (npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)) then
						spawned:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
					end
				end

				

				npc:Remove()
			end
		end
	end
end
Mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, MR_MUCUS.MsHorfKill, Entities.MR_MUCUS.TYPE)