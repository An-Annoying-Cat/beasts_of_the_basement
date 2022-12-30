local Mod = BotB
local GIBBY = {}
local Entities = BotB.Enums.Entities
local sfx = SFXManager()

function GIBBY:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local data = npc:GetData()
    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()


    if npc.Type == BotB.Enums.Entities.GIBBY.TYPE and npc.Variant == BotB.Enums.Entities.GIBBY.VARIANT then 
        local gibbyPathfinder = npc.Pathfinder
        if data.amountContained == nil then
            if npc.SubType == 0 then
                data.amountContained = math.random(3,6)
            else
                data.amountContained = npc.SubType
            end
            data.amountLeft = data.amountContained
            npc.MaxHitPoints = 5 * data.amountContained
            npc.HitPoints = npc.MaxHitPoints
            data.damageThresholdMax = 5
            data.damageThreshold = data.damageThresholdMax
            data.scaleCoeff = (data.amountLeft/data.amountContained)
        end
        npc.Scale = (npc.HitPoints/npc.MaxHitPoints)*0.5 + 0.5
    end
end

function GIBBY:DamageCheck(npc, amount, _, _, _)
    --print("sharb")
    local data = npc:GetData()
    local sprite = npc:GetSprite()
    if npc.Type == BotB.Enums.Entities.GIBBY.TYPE and npc.Variant == BotB.Enums.Entities.GIBBY.VARIANT then 
        if amount > data.damageThreshold then
            local damageDividend = amount
            local boisToSpawn = (damageDividend - (damageDividend % data.damageThresholdMax))/data.damageThresholdMax
            if amount > npc.HitPoints then
                boisToSpawn = data.amountLeft
            end
            sfx:Play(SoundEffect.SOUND_MEAT_JUMPS,1,0,false,1+(1-(data.amountLeft+1/data.amountContained+1)))
            for i=1,boisToSpawn,1 do
                local randoAngle = math.random(360)
                local smolBoi = Isaac.Spawn(Entities.GIBLET.TYPE, Entities.GIBLET.VARIANT, 0, npc.Position+Vector(25,0):Rotated(randoAngle), Vector(10,0):Rotated(randoAngle),npc)
                Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.POOF04,0,npc.Position,Vector(0,0),npc):ToEffect()
                smolBoi:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                smolBoi.Parent = npc
                --[[
                local funnyCord = Isaac.Spawn(Isaac.GetEntityTypeByName("Evis Guts"),Isaac.GetEntityVariantByName("Evis Guts"),0,npc.Position,Vector.Zero,npc)
                local cordSprite = funnyCord:GetSprite()
                funnyCord.Parent = npc
                funnyCord.Target = smolBoi
                print(funnyCord)()
                cordSprite:ReplaceSpritesheet(0,"gfx/monsters/gibby_guts.png")
                cordSprite:ReplaceSpritesheet(1,"gfx/monsters/gibby_guts.png")
                print(cordSprite)
                --]]
                data.scaleCoeff = (data.amountLeft/data.amountContained)
                --npc.Scale = data.scaleCoeff
                --npc.Friction = (1+0.1*(1-(data.amountLeft+1/data.amountContained+1)))
                data.amountLeft = data.amountLeft - 1
            end
        else
            data.damageThreshold = data.damageThreshold - amount
        end
        
    end
    --return true
end


Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, GIBBY.DamageCheck, Isaac.GetEntityTypeByName("Gibby"))

Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, GIBBY.NPCUpdate, Isaac.GetEntityTypeByName("Gibby"))