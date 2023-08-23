local Mod = BotB
local SLIGHT = {}
local Entities = BotB.Enums.Entities
local game = Game()

function SLIGHT:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local data = npc:GetData()
    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()
    local paranoiacPathfinder = npc.Pathfinder
    local room = Game():GetRoom()

    if npc.Type == BotB.Enums.Entities.SLIGHT.TYPE and npc.Variant == BotB.Enums.Entities.SLIGHT.VARIANT then 
        --States:
        --99: Move normal (follow spawner/parent)
        --100: Move panicked (chase player)
        npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
        if npc.State == 0 then
            --Init
            
            if not sprite:IsPlaying("Appear") then
                sprite:Play("Appear")
            end
            if sprite:IsFinished("Appear") then
                npc.State = 99
                sprite:Play("Move")
            end
        end

        if npc.State == 99 then
            if npc.Parent ~= nil then
                npc.Velocity = ((0.995 * npc.Velocity) + (0.005 * (npc.Parent.Position - npc.Position))):Clamped(-8,-8,8,8)
                if npc.SpawnerEntity:IsDead() then
                    --time to panic (parent entity died)
                    sfx:Play(BotB.Enums.SFX.SLIGHT_PANIC,1,0,false,math.random(90,110)/100)
                    game:MakeShockwave(npc.Position, 0.035, 0.025, 10)
                    npc.Velocity = ((0.99 * npc.Velocity) + (0.01 * (target.Position - npc.Position))):Clamped(-10,-10,10,10)
                    npc.State = 100
                    sprite:Play("MovePanic")
                end
            else
                --time to panic (as a placeholder for not having a parent)
                sfx:Play(BotB.Enums.SFX.SLIGHT_PANIC,0.75,0,false,math.random(90,110)/100)
                game:MakeShockwave(npc.Position, 0.035, 0.025, 10)
                npc.Velocity = ((0.99 * npc.Velocity) + (0.01 * (target.Position - npc.Position))):Clamped(-10,-10,10,10)
                npc.State = 100
                sprite:Play("MovePanic")
            end
        end

        if npc.State == 100 then
            npc.Velocity = ((0.995 * npc.Velocity) + (0.005 * (target.Position - npc.Position))):Clamped(-8,-8,8,8)
        end
        
    end
end


Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, SLIGHT.NPCUpdate, Isaac.GetEntityTypeByName("Slight"))


--SLIGHT