local Mod = BotB
local drone = {}
local Entities = BotB.Enums.Entities
local ff = FiendFolio

function drone:NPCDeath(npc)
	if npc.Type == Entities.DRONE.TYPE and npc.Variant == Entities.DRONE.VARIANT then
		Isaac.Spawn(281, 0, 0, npc.Position, Vector(0,0), npc)
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, drone.NPCDeath, Isaac.GetEntityTypeByName("Drone"))