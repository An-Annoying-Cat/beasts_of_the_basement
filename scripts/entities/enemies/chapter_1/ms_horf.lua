local Mod = BotB
local MS_HORF = {}
local Entities = BotB.Enums.Entities
local FF = Mod.FF

function MS_HORF:MsHorfAI(npc)
    if npc.Variant == Entities.MS_HORF.VARIANT then
		local sprite = npc:GetSprite()
		local d = npc:GetData()
		local target = npc:GetPlayerTarget()
		local path = npc.Pathfinder
		local r = npc:GetDropRNG()
		local room = Mod.Game:GetRoom()

		local headChoice = Entities.MS_HORF_HEAD
		local speeds = {4, 0.6}
		--[[if variant == mod.FF.MrRedHorf.Var then
			headchoice = mod.FF.MrRedHorfHead.Var
			speeds = {6, 0.8}
		end]]

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
				npc:Morph(EntityType.ENTITY_GUSHER, newvar, 0, -1)

			elseif sprite:IsPlaying("HeadThrow") and sprite:GetFrame() == 6 then
				npc:PlaySound(FF.Sounds.ClothRip,0.3,0,false,math.random(155,175)/100)

			elseif sprite:IsEventTriggered("Shoot") then
				d.BotB_hasthrown = true
				npc:PlaySound(SoundEffect.SOUND_SHAKEY_KID_ROAR,1,0,false,0.9)

				
				local head = Isaac.Spawn(headChoice.TYPE, headChoice.VARIANT, 0, npc.Position, Vector.Zero, npc):ToNPC()
				head:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				head.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
				head.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NOPITS

				local hd = head:GetData()
				hd.BotB_thrown = true
				head.Parent = npc
				FF:spritePlay(head:GetSprite(), "HeadSpin")
				head.HitPoints = npc.HitPoints
				head:Update()

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
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, MS_HORF.MsHorfAI, Entities.MS_HORF.TYPE)

function MS_HORF:MsHorfHeadAI(npc)
    if npc.Variant == Entities.MS_HORF_HEAD.VARIANT then
		local sprite = npc:GetSprite()
		local d = npc:GetData()
		local room = Game():GetRoom()
		local endresult = {Entities.HORF_GIRL.TYPE, Entities.HORF_GIRL.VARIANT}
		--[[if variant == 773 then
			endresult = {mod.FF.RedHorf.ID, mod.FF.RedHorf.Var}
			d.Explosiveness = 95
		end]]

		if not d.BotB_init then
			if not d.BotB_thrown then
				npc:Remove()
			end
			npc.Velocity = Mod.Functions:PositionToAxisDirection(npc.Position, Game():GetNearestPlayer(npc.Position).Position):Resized(20)
			d.BotB_init = true
		end

		if d.BotB_thrown then
			FF:spritePlay(sprite, "HeadSpin")
			npc.SpriteOffset = Vector(0, -8)
			npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_BULLET
			if npc.Velocity.X > 0 then
				sprite.FlipX = true
			else
				sprite.FlipX = false
			end

			if npc:CollidesWithGrid() then
				d.BotB_thrown = false
				npc.SpriteOffset = Vector(0, 0)
				npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
				npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
			end
		else
			sprite.FlipX = false
			npc.Velocity = npc.Velocity * 0.1
			if sprite:IsFinished("Land") then
				if room:GetGridEntityFromPos(npc.Position):GetType() == GridEntityType.GRID_PIT then
					npc:Kill()
				end
				npc:Morph(endresult[1], endresult[2], 0, -1)
			else
				FF:spritePlay(sprite, "Land")
			end
		end
	end
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, MS_HORF.MsHorfHeadAI, Entities.MS_HORF_HEAD.TYPE)


function MS_HORF:MsHorfKill(npc)
    if npc.Variant == Entities.MS_HORF.VARIANT then
		if not (npc:HasEntityFlags(EntityFlag.FLAG_FREEZE) or npc:HasEntityFlags(EntityFlag.FLAG_MIDAS_FREEZE) or FF:isLeavingStatusCorpse(npc)) then
			local d = npc:GetData()
			if not d.BotB_hasthrown then
				local r = npc:ToNPC():GetDropRNG()

				local newvar = 1
				if r:RandomInt(3) == 1 then
					newvar = 0
				end

				local spawned = Isaac.Spawn(11, newvar, Entities.MS_HORF.VARIANT, npc.Position, npc.Velocity, npc)
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