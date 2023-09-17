local Mod = BotB
local FLAPJACK = {}
local Entities = BotB.Enums.Entities
local ff = FiendFolio

function FLAPJACK:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local data = npc:GetData()
    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()
    local room = Game():GetRoom()


    if npc.Type == BotB.Enums.Entities.FLAPJACK.TYPE and npc.Variant == BotB.Enums.Entities.FLAPJACK.VARIANT then
        if npc.State == 0 then
            if data.flapjackInitDirection == nil then
                --print(npc.InitSeed)
                data.flapjackInitDirection = BotB.Functions.RNG:RandomInt(npc.InitSeed,3) + 1
                --1 is added cuz table indexing and shit
                data.flapjackDirection = data.flapjackInitDirection
                if data.flapjackIsSpecial == true then
                    sprite:ReplaceSpritesheet(0, "gfx/monsters/chapter_1/flapjack_bone.png")
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
            npc.Velocity = (0.95 * npc.Velocity) + (0.05 * ff:diagonalMove(npc, 4, 1))
            if npc.FrameCount % 4 == 0 then
                local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_RED, 0, npc.Position, Vector(0,0), npc):ToEffect()
                creep.SpriteScale = creep.SpriteScale * 0.6
                creep.Timeout = 30
                creep:Update()
            end
        end
    end
end


Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, FLAPJACK.NPCUpdate, Isaac.GetEntityTypeByName("Flapjack"))

function FLAPJACK:DamageCheck(npc, amount, damageFlags, source, _)
    if npc.Variant ~= BotB.Enums.Entities.FLAPJACK.VARIANT then return end
    if ff:HasDamageFlag(DamageFlag.DAMAGE_FIRE, damageFlags) and not game:GetRoom():HasWater() then
        if npc.Variant ~= BotB.Enums.Entities.GRILLED_FLAPJACK.VARIANT then
            npc:Morph(BotB.Enums.Entities.GRILLED_FLAPJACK.TYPE, BotB.Enums.Entities.GRILLED_FLAPJACK.VARIANT, 0, 0)
        end
        if not ff:IsPlayerDamage(source) then
            return false
        end
    end
end


Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, FLAPJACK.DamageCheck, Isaac.GetEntityTypeByName("Flapjack"))