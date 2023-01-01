local Mod = BotB
local FiendFolio = Mod.FF
local ETERNAL_FLY = {}
local Entities = BotB.Enums.Entities

function ETERNAL_FLY:NPCUpdate(npc)
    local d = npc:GetData()
    if npc.Variant == Entities.ETERNAL_FLY_DUMMY.VARIANT then
        if not d.init then
            for _, ent in ipairs(Isaac.FindInRadius(npc.Position, 50, EntityPartition.ENEMY)) do
                --put this in a scheduler because it sometimes bugs
                local fly = Isaac.Spawn(FiendFolio.FF.DeadFlyOrbital.ID, FiendFolio.FF.DeadFlyOrbital.Var, 0, npc.Position, Vector.Zero, ent):ToNPC()
                npc:Remove()
                fly.Parent = ent
                ent.Child = fly
                fly:GetData().rotval = math.random(100)
                fly:Update()
 
                d.init = true
                return
            end
        end
    end
end
Isaac.AddPriorityCallback(Mod, ModCallbacks.MC_NPC_UPDATE, CallbackPriority.LATE, ETERNAL_FLY.NPCUpdate, Entities.ETERNAL_FLY_DUMMY.TYPE)