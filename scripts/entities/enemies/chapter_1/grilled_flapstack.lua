local Mod = BotB
local GRILLED_FLAPSTACK = {}
local Entities = BotB.Enums.Entities
local ff = FiendFolio

function GRILLED_FLAPSTACK:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local data = npc:GetData()
    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()
    local room = Game():GetRoom()


    if npc.Type == BotB.Enums.Entities.GRILLED_FLAPSTACK.TYPE and npc.Variant == BotB.Enums.Entities.GRILLED_FLAPSTACK.VARIANT then
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
            if npc.FrameCount % 6 == 0 then
                local fire = Isaac.Spawn(1000,7005, 20, npc.Position, Vector(4,0):Rotated(math.random(360)), npc):ToEffect()
                fire.SpriteScale = Vector(0.5,0.5)
                fire:GetData().timer = 10
                fire:GetData().gridcoll = 0
                fire.Parent = npc
            end
        end
        if npc.State == 100 then
            if sprite:IsEventTriggered("Back") then
                if data.amountLeft ~= 1 then
                    npc.State = 99
                    sprite:Play(data.amountLeft)
                else
                    npc.Friction = 1
                    local specialBoy = Isaac.Spawn(BotB.Enums.Entities.GRILLED_FLAPJACK.TYPE,BotB.Enums.Entities.GRILLED_FLAPJACK.VARIANT,0,npc.Position,npc.Velocity,npc):ToNPC()
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
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, GRILLED_FLAPSTACK.NPCUpdate, Isaac.GetEntityTypeByName("Flapstack"))


function GRILLED_FLAPSTACK:DamageCheck(npc, amount, damageFlags, source, _)
    --print("sharb")
    local npcConv = npc:ToNPC()
    local data = npc:GetData()
    local sprite = npc:GetSprite()
    local targetpos = source.Entity.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()
    if npc.Type == BotB.Enums.Entities.GRILLED_FLAPSTACK.TYPE and npc.Variant == BotB.Enums.Entities.GRILLED_FLAPSTACK.VARIANT then 
        if ff:HasDamageFlag(DamageFlag.DAMAGE_FIRE, damageFlags) then
            return false
        else
            npc.HitPoints = npc.MaxHitPoints
            npcConv.State = 100
            --print(data.amountLeft)
            local animString = data.amountLeft .. "to" .. (data.amountLeft - 1)
            --print(animString)
            sprite:Play(animString)
            data.amountLeft = data.amountLeft - 1
            local normalBoi = Isaac.Spawn(BotB.Enums.Entities.GRILLED_FLAPJACK.TYPE,BotB.Enums.Entities.GRILLED_FLAPJACK.VARIANT,0,npc.Position,Vector.Zero,npc)
            normalBoi.Velocity = Vector(4,0):Rotated(targetangle-BotB.Functions.RNG:RandomInt(normalBoi.InitSeed,45) - 22.5)
            npc.HitPoints = npc.MaxHitPoints
            npcConv:PlaySound(SoundEffect.SOUND_MEAT_JUMPS,1,0,false,math.random(120,140)/100)
        end
        
    end
end


Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, GRILLED_FLAPSTACK.DamageCheck, Isaac.GetEntityTypeByName("Flapstack"))