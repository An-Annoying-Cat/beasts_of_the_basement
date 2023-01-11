local Mod = BotB
local MS_HORF = {}
local Entities = BotB.Enums.Entities
local Fiend = Mod.FF

function MS_HORF:mrHorfAI(npc, subt, variant)
	local sprite = npc:GetSprite()
	local d = npc:GetData()
	local target = npc:GetPlayerTarget()
	local path = npc.Pathfinder
	local r = npc:GetDropRNG()
    local room = game:GetRoom()

	local headchoice = mod.FF.MrHorfHead.Var
	local speeds = {4, 0.6}
	if variant == mod.FF.MrRedHorf.Var then
		headchoice = mod.FF.MrRedHorfHead.Var
		speeds = {6, 0.8}
	end

	if not d.init then
		d.init = true
		d.state = "idle"
		d.randwait = math.random(30)
		mod:spriteOverlayPlay(sprite, "Head")
	else
		npc.StateFrame = npc.StateFrame + 1
	end

	if sprite:IsOverlayFinished("Head") then
		mod:spriteOverlayPlay(sprite, "HeadIdle")
	end

	if d.state == "idle" then
		if npc.Velocity:Length() > 0.1 then
			npc:AnimWalkFrame("WalkHori","WalkVert",0)
		else
			sprite:SetFrame("WalkVert", 0)
		end

		local targetpos = mod:confusePos(npc, target.Position)
		if room:CheckLine(npc.Position,targetpos,0,1,false,false) or mod:isScare(npc) then
			local targetvel = mod:reverseIfFear(npc, (targetpos - npc.Position):Resized(speeds[1]))
			npc.Velocity = mod:Lerp(npc.Velocity, targetvel,0.25)
		else
			path:FindGridPath(targetpos, speeds[2], 900, true)
		end

		if (not mod:isScareOrConfuse(npc)) and npc.StateFrame > 10 + d.randwait and r:RandomInt(15) == 1 and room:GetGridCollisionAtPos(npc.Position) == GridCollisionClass.COLLISION_NONE and npc.Position:Distance(target.Position) < 180 then
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
			npc:Morph(11, newvar, variant, -1)
		elseif sprite:IsPlaying("HeadThrow") and sprite:GetFrame() == 6 then
			npc:PlaySound(mod.Sounds.ClothRip,0.3,0,false,math.random(155,175)/100)
		elseif sprite:IsEventTriggered("Shoot") then
			d.hasthrown = true
			npc:PlaySound(SoundEffect.SOUND_SHAKEY_KID_ROAR,1,0,false,0.9)

			local head = Isaac.Spawn(mod.FF.MrHorfHead.ID, headchoice, 0, npc.Position, nilvector, npc):ToNPC();
			head:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			head.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			head.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
			local hd = head:GetData()
			hd.startpos = npc.Position
			local clamppos = room:GetClampedPosition(target.Position + RandomVector()*math.random(120), -10)
			--Isaac.ConsoleOutput("\nX: " .. clamppos.X .. " Y: " .. clamppos.Y)
			--Making sure
			local targetforhead = room:FindFreeTilePosition(clamppos, 120)
			if not room:IsPositionInRoom(targetforhead, 10) then
				clamppos = room:GetClampedPosition(target.Position + (npc.Position - target.Position):Resized(10), -10)
				targetforhead = room:FindFreeTilePosition(clamppos, 120)
				if not room:IsPositionInRoom(targetforhead, 10) then
					targetforhead = npc.Position + RandomVector()*15
				end
			end
			hd.targetpos = targetforhead
			hd.thrown = true
			head.Parent = npc
			mod:spritePlay(head:GetSprite(), "HeadSpin")
			head.HitPoints = npc.HitPoints
			head:Update()

			local targetvel = (targetforhead - npc.Position):Resized(4)
			npc.Velocity = targetvel:Resized(7)
			d.bounding = true

			npc.HitPoints = npc.MaxHitPoints

			if targetforhead.X > npc.Position.X then
				sprite.FlipX = false
			else
				sprite.FlipX = true
			end
		elseif sprite:IsEventTriggered("Bomp") then
			d.bounding = false
		else
			mod:spritePlay(sprite, "HeadThrow")
			sprite:RemoveOverlay()
		end
		if not d.bounding then
			npc.Velocity = npc.Velocity * 0.1
		else
			npc.Velocity = npc.Velocity * 0.9
		end
	end
end

function MS_HORF:mrHorfHeadAI(npc, subt, variant)
	local sprite = npc:GetSprite()
	local d = npc:GetData()

	local endresult = {12, 0}
	if variant == 773 then
		endresult = {mod.FF.RedHorf.ID, mod.FF.RedHorf.Var}
		d.Explosiveness = 95
	end

	if not d.init then
		if not d.thrown then
			npc:Remove()
		end
		d.init = true
	end

	if d.thrown then
		mod:spritePlay(sprite, "HeadSpin")
		if npc.Velocity.X > 0 then
			sprite.FlipX = true
		else
			sprite.FlipX = false
		end

		local dist = (d.targetpos - d.startpos):Length()
		local arcmax = math.max(20, dist / 5)
		local ndist = (d.targetpos - npc.Position):Length()
		local offsetCalc = math.sin(ndist / dist * math.pi) * arcmax
		local curve = -10 - math.max(-10, math.min(arcmax, offsetCalc))
		npc.SpriteOffset = Vector(0, curve)

		local throwspeed = math.min(dist / 15, 10)

		npc.Position = d.startpos + ((d.targetpos - d.startpos):Resized(throwspeed) * npc.FrameCount)
		npc.Velocity = (d.targetpos - d.startpos):Resized(throwspeed)
		if npc.Position:Distance(d.targetpos) < 5 then
			d.thrown = false
			npc.SpriteOffset = Vector(0,0)
			npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
			npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
		end
	else
		sprite.FlipX = false
		npc.Velocity = npc.Velocity * 0.1
		if sprite:IsFinished("Land") then
			npc:Morph(endresult[1], endresult[2], 0, -1)
		else
			mod:spritePlay(sprite, "Land")
		end
	end
end

function MS_HORF:mrHorfKill(npc, variant)
    if not (npc:HasEntityFlags(EntityFlag.FLAG_FREEZE) or npc:HasEntityFlags(EntityFlag.FLAG_MIDAS_FREEZE) or mod:isLeavingStatusCorpse(npc)) then
        local d = npc:GetData()
        if not d.hasthrown then
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

Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, MS_HORF.NPCUpdate, )
Mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, MS_HORF.NPCDeathCheck)