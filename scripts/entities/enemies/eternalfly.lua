local Mod = BotB
local ffmod = Mod.FF
local ETERNAL_FLY = {}
local Entities = BotB.Enums.Entities

function ETERNAL_FLY:NPCUpdate(npc)
    local d = npc:GetData()
    if npc.Variant == Entities.ETERNAL_FLY_DUMMY.VARIANT then
        if not d.BotB_init then
            for _, ent in pairs(Isaac.FindInRadius(npc.Position, 30, EntityPartition.ENEMY)) do
                if ent.Type ~= Entities.ETERNAL_FLY_DUMMY.TYPE and ent.Variant ~= Entities.ETERNAL_FLY_DUMMY.VARIANT then
                    local fly = Isaac.Spawn(ffmod.FF.DeadFlyOrbital.ID, ffmod.FF.DeadFlyOrbital.Var, 0, npc.Position, Vector.Zero, ent)
                    npc:Remove()
                    fly.Parent = ent
                    fly:Update()

                    d.BotB_init = true
                    return
                end
            end
        end
    end
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, ETERNAL_FLY.NPCUpdate, Entities.ETERNAL_FLY_DUMMY.TYPE)