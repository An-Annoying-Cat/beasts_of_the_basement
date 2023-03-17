local Mod = BotB
local UNBOXER = {}
local Entities = BotB.Enums.Entities
local ff = FiendFolio
local sfx = SFXManager()

function UNBOXER:NPCDeath(npc)
	if npc.Type == Entities.UNBOXER.TYPE and npc.Variant == Entities.UNBOXER.VARIANT then
		Isaac.Spawn(884, 0, 5, npc.Position, Vector(0,0), npc)
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, UNBOXER.NPCDeath, Entities.UNBOXER.TYPE)

function UNBOXER:NPCUpdate(npc)
	local unbox = npc:GetSprite()
	if npc.Type == Entities.UNBOXER.TYPE and npc.Variant == Entities.UNBOXER.VARIANT then
		if unbox:IsEventTriggered("Shoot") then
			sfx:Play(SoundEffect.SOUND_SPIDER_COUGH)
			for i = 0, 1, 1 do
				local swarmy = Isaac.Spawn(884, 0, 0, npc.Position, Vector(0,0), npc):ToNPC()
				swarmy:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			end
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, UNBOXER.NPCUpdate, Entities.UNBOXER.TYPE)