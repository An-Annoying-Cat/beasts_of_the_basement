local Mod = BotB
local GRILLED_FLAPJACK = {}
local Entities = BotB.Enums.Entities
local ff = FiendFolio

function GRILLED_FLAPJACK:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local data = npc:GetData()
    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()
    local room = Game():GetRoom()


    if npc.Type == BotB.Enums.Entities.GRILLED_FLAPJACK.TYPE and npc.Variant == BotB.Enums.Entities.GRILLED_FLAPJACK.VARIANT then
        if npc.State == 0 then
            if data.flapjackInitDirection == nil then
                --print(npc.InitSeed)
                data.flapjackInitDirection = BotB.Functions.RNG:RandomInt(npc.InitSeed,3) + 1
                --1 is added cuz table indexing and shit
                data.flapjackDirection = data.flapjackInitDirection
                if data.flapjackIsSpecial == true then
                    sprite:ReplaceSpritesheet(0, "gfx/monsters/chapter_1/grilled_flapjack_bone.png")
                    sprite:LoadGraphics()
                end
            end
            if not sprite:IsPlaying("Appear") then
                sprite:Play("Appear")
            end
            if sprite:IsFinished("Appear") or sprite:IsEventTriggered("Back") then
                sprite:Play("Slide")
                npc.State = 99
            end
            if data.isFromFlapstack then
                data.flapjackDirection = math.random(1,4)
            end
        end
        
        --States:
        --99: shlide...
        if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_GROUND then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
        end
        if npc.EntityCollisionClass ~= EntityCollisionClass.ENTCOLL_ALL then
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        end
        
        if npc.State == 99 then
            npc.Velocity = (0.95 * npc.Velocity) + (0.05 * ff:diagonalMove(npc, 6, 1))
            if npc.FrameCount % 6 == 0 then
                local fire = Isaac.Spawn(1000,7005, 20, npc.Position, (Vector(0.5,0.5) * npc.Velocity):Rotated(180), npc):ToEffect()
                fire.DepthOffset = -10
                fire.SpriteScale = Vector(0.5,0.5)
                fire:GetData().timer = 10
                fire:GetData().gridcoll = 0
                fire.Parent = npc
            end
        end
    end
end


Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, GRILLED_FLAPJACK.NPCUpdate, Isaac.GetEntityTypeByName("Grilled Flapjack"))


--Grilled Flapjacks don't take fire damage
function GRILLED_FLAPJACK:DamageCheck(npc, amount, damageFlags, source, _)
    if npc.Variant ~= BotB.Enums.Entities.GRILLED_FLAPJACK.VARIANT then return end
    if npc.Type == BotB.Enums.Entities.GRILLED_FLAPJACK.TYPE and npc.Variant == BotB.Enums.Entities.GRILLED_FLAPJACK.VARIANT and ff:HasDamageFlag(DamageFlag.DAMAGE_FIRE, damageFlags) then
        return false
    end
end
Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, GRILLED_FLAPJACK.DamageCheck, Isaac.GetEntityTypeByName("Grilled Flapjack"))