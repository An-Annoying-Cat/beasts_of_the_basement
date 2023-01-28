local Mod = BotB
local ffmod = Mod.FF
local ETERNAL_FLY = {}
local Entities = BotB.Enums.Entities

function ETERNAL_FLY:NPCUpdate(npc)
    npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
    npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
	npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
    local d = npc:GetData()
    if npc.Variant == Entities.ETERNAL_FLY_DUMMY.VARIANT then
        if not d.init then
            for _, ent in pairs(Isaac.FindInRadius(npc.Position, 60, EntityPartition.ENEMY)) do
                if ent.Type ~= Entities.ETERNAL_FLY_DUMMY.TYPE and ent.Variant ~= Entities.ETERNAL_FLY_DUMMY.VARIANT then
                    local fly = Isaac.Spawn(ffmod.FF.DeadFlyOrbital.ID, ffmod.FF.DeadFlyOrbital.Var, 0, npc.Position, Vector.Zero, ent)
                    local fd = fly:GetData()
                    local pd = ent:GetData()

                    if not pd.BotB_children then
                        pd.BotB_children = 0
                        pd.BotB_childCounter = 1
                        for _, dummy in pairs(Isaac.FindInRadius(ent.Position, 80)) do
                            if (dummy.Type == Entities.ETERNAL_FLY_DUMMY.TYPE and dummy.Variant == Entities.ETERNAL_FLY_DUMMY.VARIANT) then
                                pd.BotB_children = pd.BotB_children + 1
                            end
                        end
                    end

                    fly.Parent = ent
                    fd.rotval = (100 / pd.BotB_children) * pd.BotB_childCounter
                    fd.FrameOffset = fd.rotval
                    fly:Update()

                    pd.BotB_childCounter = pd.BotB_childCounter + 1

                    npc:Remove()
                    return
                end
            end
        end
    end
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, ETERNAL_FLY.NPCUpdate, Entities.ETERNAL_FLY_DUMMY.TYPE)
Mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, ETERNAL_FLY.NPCUpdate, Entities.ETERNAL_FLY_DUMMY.TYPE)