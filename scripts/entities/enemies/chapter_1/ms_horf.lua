local Mod = BotB
local MS_HORF = {}
local Entities = BotB.Enums.Entities
local FF = Mod.FF

function MS_HORF:GetTargetCardinalAligned(distance, )
	local targrel
	local targdistance = mod:reverseIfFear(npc,targpos - npc.Position) 
	if math.abs(targdistance.X) > math.abs(targdistance.Y) then
		if targdistance.X < 0 then
			targrel = 3 -- Left
		else
			targrel = 1 -- Right
		end
	else
		if targdistance.Y < 0 then
			targrel = 2 -- Up
		else
			targrel = 0 -- Down
		end
	end

	local tpa = target.Position
	if targrel == 0 then
		tpa = target.Position + Vector((target.Position.X - npc.Position.X), -distanceabs)
	elseif targrel == 1 then
		tpa = target.Position + Vector(-distanceabs, (target.Position.Y - npc.Position.Y))
	elseif targrel == 2 then
		tpa = target.Position + Vector((target.Position.X - npc.Position.X), distanceabs + extravec)
	elseif targrel == 3 then
		tpa = target.Position + Vector(distanceabs + extravec, (target.Position.Y - npc.Position.Y))
	end

	if npc.Position:Distance(tpa) > 10 then
		d.targetvelocity = (tpa - npc.Position):Resized(movespeed)
		npc.Velocity = Mod.Functions:Lerp(d.targetvelocity, npc.Velocity, 0.8)
	else
		npc.Velocity = npc.Velocity * 0.8
	end
	local targvec = Vector(npc.Position.X, targetpos.Y)
		if targrel == 2 or targrel == 0 then
			targvec = Vector(targetpos.X, npc.Position.Y)
		end
	
end

function MS_HORF:MsHorfAI(npc)
    if npc.Variant == Entities.MS_HORF.SUBTYPE and npc.SubType == Entities.MS_HORF.SUBTYPE then
		local sprite = npc:GetSprite()
		local d = npc:GetData()
		local target = npc:GetPlayerTarget()
		local path = npc.Pathfinder
		local r = npc:GetDropRNG()
		local room = game:GetRoom()

		local headChoice = Entities.MS_HORF_HEAD
		local speeds = {4, 0.6}
		--[[if variant == mod.FF.MrRedHorf.Var then
			headchoice = mod.FF.MrRedHorfHead.Var
			speeds = {6, 0.8}
		end]]

		if not d.BotB_init then
			d.BotB_init = true
			d.BotB_state = "idle"
			d.BotB_randWait = math.random(30) --gross, fix this
			FF:spriteOverlayPlay(sprite, "Head")
		else
			npc.StateFrame = npc.StateFrame + 1
		end

		if sprite:IsOverlayFinished("Head") then
			FF:spriteOverlayPlay(sprite, "HeadIdle")
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

			if (not FF:isScareOrConfuse(npc)) and npc.StateFrame > 10 + d.BotB_randWait and room:GetGridCollisionAtPos(npc.Position) == GridCollisionClass.COLLISION_NONE then
				d.state = "throw"
				d.backupThrowpos = npc.Position
				if target.Position.X > npc.Position.X then
					sprite.FlipX = false
				else
					sprite.FlipX = true
				end
			end
		elseif d.state == "throw" then
			if sprite:IsFinished("HeadThrow") then
				local newvar = 1
				if r:RandomInt(3) == 1 then
					newvar = 0
				end
				npc:Morph(EntityType.ENTITY_GUSHER, newvar, headChoice.SUBTYPE, -1)

			elseif sprite:IsPlaying("HeadThrow") and sprite:GetFrame() == 6 then
				npc:PlaySound(FF.Sounds.ClothRip,0.3,0,false,math.random(155,175)/100)

			elseif sprite:IsEventTriggered("Shoot") then
				d.BotB_hasthrown = true
				npc:PlaySound(SoundEffect.SOUND_SHAKEY_KID_ROAR,1,0,false,0.9)

				
				local head = Isaac.Spawn(headChoice.TYPE, headChoice.VARIANT, headChoice.SUBTYPE, npc.Position, Vector.Zero, npc):ToNPC()
				head:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				head.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
				head.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS

				local hd = head:GetData()
				hd.BotB_startpos = npc.Position
				local clamppos = room:GetClampedPosition(target.Position, -10)
				--Isaac.ConsoleOutput("\nX: " .. clamppos.X .. " Y: " .. clamppos.Y)
				--Making sure
				local targetforhead = room:FindFreeTilePosition(clamppos, 120)

				hd.BotB_targetpos = targetforhead
				hd.BotB_thrown = true
				head.Parent = npc
				FF:spritePlay(head:GetSprite(), "HeadSpin")
				head.HitPoints = npc.HitPoints
				head:Update()

				local targetvel = (targetforhead - npc.Position):Resized(10)
				npc.Velocity = targetvel:Resized(7)
				d.BotB_bounding = true

				npc.HitPoints = npc.MaxHitPoints

				if targetforhead.X > npc.Position.X then
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
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, MS_HORF.MsHorfAI, Entities.MS_HORF.TYPE)

function MS_HORF:MsHorfHeadAI(npc)
    if npc.Variant ~= Entities.MS_HORF_HEAD.SUBTYPE and npc.SubType ~= Entities.MS_HORF_HEAD.SUBTYPE then
		local sprite = npc:GetSprite()
		local d = npc:GetData()

		local endresult = {Entities.HORF_GIRL.TYPE, Entities.HORF_GIRL.VARIANT}
		--[[if variant == 773 then
			endresult = {mod.FF.RedHorf.ID, mod.FF.RedHorf.Var}
			d.Explosiveness = 95
		end]]

		if not d.BotB_init then
			if not d.BotB_thrown then
				npc:Remove()
			end
			d.BotB_init = true
		end

		if d.BotB_thrown then
			FF:spritePlay(sprite, "HeadSpin")
			if npc.Velocity.X > 0 then
				sprite.FlipX = true
			else
				sprite.FlipX = false
			end

			local dist = (d.BotB_targetpos - d.BotB_startpos):Length()
			local arcmax = math.max(20, dist / 5)
			local ndist = (d.BotB_targetpos - npc.Position):Length()
			local offsetCalc = math.sin(ndist / dist * math.pi) * arcmax
			local curve = -10 - math.max(-10, math.min(arcmax, offsetCalc))
			npc.SpriteOffset = Vector(0, curve)

			local throwspeed = math.min(dist / 15, 10)

			npc.Position = d.BotB_startpos + ((d.BotB_targetpos - d.BotB_startpos):Resized(throwspeed) * npc.FrameCount)
			npc.Velocity = (d.BotB_targetpos - d.BotB_startpos):Resized(throwspeed)
			if npc.Position:Distance(d.BotB_targetpos) < 5 then
				d.BotB_thrown = false
				npc.SpriteOffset = Vector(0,0)
				npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
				npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
			end
		else
			sprite.FlipX = false
			npc.Velocity = npc.Velocity * 0.1
			if sprite:IsFinished("Land") then
				npc:Morph(endresult[1], endresult[2], 0, -1)
			else
				FF:spritePlay(sprite, "Land")
			end
		end
	end
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, MS_HORF.MsHorfHeadAI, Entities.MS_HORF_HEAD.TYPE)


function MS_HORF:MsHorfKill(npc, variant)
    if npc.Variant ~= Entities.MS_HORF.SUBTYPE and npc.SubType ~= Entities.MS_HORF.SUBTYPE then
		if not (npc:HasEntityFlags(EntityFlag.FLAG_FREEZE) or npc:HasEntityFlags(EntityFlag.FLAG_MIDAS_FREEZE) or FF:isLeavingStatusCorpse(npc)) then
			local d = npc:GetData()
			if not d.BotB_hasthrown then
				local r = npc:ToNPC():GetDropRNG()

				local newvar = 1
				if r:RandomInt(3) == 1 then
					newvar = 0
				end

				local spawned = Isaac.Spawn(11, newvar, variant, npc.Position, npc.Velocity, npc)
				spawned:ToNPC():Morph(spawned.Type, spawned.Variant, spawned.SubType, npc:ToNPC():GetChampionColorIdx())
				spawned.HitPoints = spawned.MaxHitPoints
				spawned:ClearEntityFlags(EntityFlag.FLAG_APPEAR)

				if (npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY)) then
					spawned:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
				end

				npc:Remove()
			end
		end
	end
end
Mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, MS_HORF.MsHorfKill, Entities.MS_HORF.TYPE)