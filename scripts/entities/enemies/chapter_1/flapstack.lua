local Mod = BotB
local FLAPSTACK = {}
local Entities = BotB.Enums.Entities
local ff = FiendFolio

function FLAPSTACK:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local data = npc:GetData()
    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()
    local room = Game():GetRoom()


    if npc.Type == BotB.Enums.Entities.FLAPSTACK.TYPE and npc.Variant == BotB.Enums.Entities.FLAPSTACK.VARIANT then
        if npc.State == 0 then
            if data.amountLeft == nil then
                if npc.SubType == nil or npc.SubType == 0 then
                    data.amountLeft = 2
                else
                    data.amountLeft = npc.SubType + 1
                end
            end
            npc.Friction = 0
            npc.State = 99
            sprite:Play(data.amountLeft)
        end
        
        --States:
        --99: Idle
        --100: Hurt anim, dropping a flapjack (or converting into one)
        if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_GROUND then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
        end
        
        if npc.State == 99 then
            if npc.FrameCount % 8 == 0 then
                local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_RED, 0, npc.Position, Vector(0,0), npc):ToEffect()
                local newScale = Vector(1,1) + Vector(0.2*data.amountLeft,0.2*data.amountLeft)
                --print(newScale)
                creep.SpriteScale = newScale
                creep.Timeout = 12
                creep:Update()
            end
        end
        if npc.State == 100 then
            if sprite:IsEventTriggered("Back") then
                if data.amountLeft ~= 1 then
                    npc.State = 99
                    sprite:Play(data.amountLeft)
                else
                    npc.Friction = 1
                    local specialBoy = Isaac.Spawn(BotB.Enums.Entities.FLAPJACK.TYPE,BotB.Enums.Entities.FLAPJACK.VARIANT,0,npc.Position,npc.Velocity,npc):ToNPC()
                    specialBoy:GetData().flapjackIsSpecial = true
                    npc:Remove()
                end
            end
        end
        if data.amountLeft ~= 1 then
            npc.Velocity = Vector.Zero
        end
    end
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, FLAPSTACK.NPCUpdate, Isaac.GetEntityTypeByName("Flapstack"))


function FLAPSTACK:DamageCheck(npc, amount, damageFlags, source, _)
    --print("sharb")
    local npcConv = npc:ToNPC()
    local data = npc:GetData()
    local sprite = npc:GetSprite()
    local targetpos = source.Entity.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()
    if ff:HasDamageFlag(DamageFlag.DAMAGE_FIRE, damageFlags) and not game:GetRoom():HasWater() then
        if npc.Variant ~= BotB.Enums.Entities.GRILLED_FLAPSTACK.VARIANT then
            npc:Morph(BotB.Enums.Entities.GRILLED_FLAPSTACK.TYPE, BotB.Enums.Entities.GRILLED_FLAPSTACK.VARIANT, 0, npc:GetChampionColorIdx())
        end
        if not ff:IsPlayerDamage(source) then
            return false
        end
    end
    if npc.Type == BotB.Enums.Entities.FLAPSTACK.TYPE and npc.Variant == BotB.Enums.Entities.FLAPSTACK.VARIANT then 
        npc.HitPoints = npc.MaxHitPoints
        npcConv.State = 100
        --print(data.amountLeft)
        local animString = data.amountLeft .. "to" .. (data.amountLeft - 1)
        --print(animString)
        sprite:Play(animString)
        data.amountLeft = data.amountLeft - 1
        local normalBoi = Isaac.Spawn(BotB.Enums.Entities.FLAPJACK.TYPE,BotB.Enums.Entities.FLAPJACK.VARIANT,0,npc.Position,Vector.Zero,npc)
        normalBoi.Velocity = Vector(4,0):Rotated(targetangle-BotB.Functions.RNG:RandomInt(normalBoi.InitSeed,45) - 22.5)
        npc.HitPoints = npc.MaxHitPoints
        npcConv:PlaySound(SoundEffect.SOUND_MEAT_JUMPS,1,0,false,math.random(120,140)/100)
    end
end


Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, FLAPSTACK.DamageCheck, Isaac.GetEntityTypeByName("Flapstack"))