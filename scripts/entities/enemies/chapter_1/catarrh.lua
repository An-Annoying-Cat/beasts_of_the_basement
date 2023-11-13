local Mod = BotB
local CATARRH = {}
local Entities = BotB.Enums.Entities
local FF = BotB.FF

function CATARRH:NPCUpdate(npc)
    if npc.Type == BotB.Enums.Entities.CATARRH.TYPE and npc.Variant == BotB.Enums.Entities.CATARRH.VARIANT then 
        local sprite = npc:GetSprite()
        local player = npc:GetPlayerTarget()
        local data = npc:GetData()
        local target = npc:GetPlayerTarget()
        local targetpos = target.Position
        local targetangle = (targetpos - npc.Position):GetAngleDegrees()
        local targetdistance = (targetpos - npc.Position):Length()
        local somebodyPathfinder = npc.Pathfinder
        if npc.State == 0 then
            if data.flemmerShootCooldown == nil then
                data.flemmerShootCooldown = 4
            end
            npc.State = 99
            sprite:PlayOverlay("Head")
        end
        if npc.EntityCollisionClass ~= EntityCollisionClass.ENTCOLL_ALL then
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        end
        if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_GROUND then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
        end
        npc.SplatColor = FiendFolio.ColorSpittyGreen
        if npc.State == 99 then
            --npc:ClearEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
            npc:AnimWalkFrame("WalkHori", "WalkVert", 0.25)
            somebodyPathfinder:FindGridPath(targetpos, 0.325, 0, false)
            npc.Velocity = 0.8 * npc.Velocity
            if npc.FrameCount % 8 == 0 then
                local creep = Isaac.Spawn(1000, EffectVariant.CREEP_GREEN, 0, npc.Position, Vector(0,0), npc):ToEffect();
			    creep.SpriteScale = Vector(2.5, 1)
			    creep:SetTimeout(math.floor(creep.Timeout * 0.75))
			    creep:SetColor(Color(0, 0, 0, 1, 99 / 255, 56 / 255, 74 / 255), 60, 99999, true, false)
			    creep:Update()
            end
        end
    end
        
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, CATARRH.NPCUpdate, Isaac.GetEntityTypeByName("Catarrh"))

function CATARRH:MsHorfKill(npc)
    if npc.Variant == Entities.CATARRH.VARIANT then
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
Mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, CATARRH.MsHorfKill, Entities.CATARRH.TYPE)

