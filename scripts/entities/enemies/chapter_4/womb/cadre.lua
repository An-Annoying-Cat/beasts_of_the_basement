local Mod = BotB
local CADRE = {}
local Entities = BotB.Enums.Entities

function CADRE:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local data = npc:GetData()
    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()


    if npc.Type == BotB.Enums.Entities.CADRE.TYPE and npc.Variant == BotB.Enums.Entities.CADRE.VARIANT and (npc.SubType == BotB.Enums.Entities.CADRE.SUBTYPE or npc.SubType == BotB.Enums.Entities.CADRE.SUBTYPE + 1 or npc.SubType == BotB.Enums.Entities.CADRE.SUBTYPE + 2 or npc.SubType == BotB.Enums.Entities.CADRE.SUBTYPE + 3 or npc.SubType == BotB.Enums.Entities.CADRE.SUBTYPE + 4)  then 
        if data.containedEnemy == nil then
            if npc.SubType ~= 30 then
                data.containedEnemy = npc.SubType - 30
            else
                data.containedEnemy = math.random(1,4)
            end
            if data.containedEnemy == 1 then
                --Globin
                sprite:ReplaceSpritesheet(0,"gfx/monsters/chapter_4/womb/cadre/cadre_basic.png")
                
            elseif data.containedEnemy == 2 then
                --Gazing Globin
                sprite:ReplaceSpritesheet(0,"gfx/monsters/chapter_4/womb/cadre/cadre_gazing.png")
            elseif data.containedEnemy == 3 then
                --Globlet
                sprite:ReplaceSpritesheet(0,"gfx/monsters/chapter_4/womb/cadre/cadre_globlet.png")
            elseif data.containedEnemy == 4 then
                --Giblet
                sprite:ReplaceSpritesheet(0,"gfx/monsters/chapter_4/womb/cadre/cadre_giblet.png")
            else
            end
            sprite:LoadGraphics()
        end
    end
end

function CADRE:NPCDeathCheck(entity)
    local npc = entity:ToNPC()
    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local data = npc:GetData()
    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()


    if npc.Type == BotB.Enums.Entities.CADRE.TYPE and npc.Variant == BotB.Enums.Entities.CADRE.VARIANT and (npc.SubType == BotB.Enums.Entities.CADRE.SUBTYPE or npc.SubType == BotB.Enums.Entities.CADRE.SUBTYPE + 1 or npc.SubType == BotB.Enums.Entities.CADRE.SUBTYPE + 2 or npc.SubType == BotB.Enums.Entities.CADRE.SUBTYPE + 3 or npc.SubType == BotB.Enums.Entities.CADRE.SUBTYPE + 4) then 
        sfx:Play(SoundEffect.SOUND_MEAT_JUMPS,1,0,false,math.random(40,60)/100)
        Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.POOF04,0,npc.Position,Vector(0,0),npc):ToEffect()
        --print("fuck")
        if data.containedEnemy == 1 then
            --Globin
            --print("globin")
            local randoAngle = targetangle + math.random(-90, 90)
            local smolBoi = Isaac.Spawn(24,0, 0, npc.Position+Vector(25,0):Rotated(randoAngle), Vector(10,0):Rotated(randoAngle),npc)
            --smolBoi:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            smolBoi.Parent = npc
        elseif data.containedEnemy == 2 then
            --Gazing Globin
            --print("globin2")
            local randoAngle = targetangle + math.random(-90, 90)
            local smolBoi = Isaac.Spawn(24,1, 0, npc.Position+Vector(25,0):Rotated(randoAngle), Vector(10,0):Rotated(randoAngle),npc)
            --smolBoi:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            smolBoi.Parent = npc
        elseif data.containedEnemy == 3 then
            --Globlet
            --print("globlet")
            for i=0,1,1 do
                local randoAngle = targetangle + math.random(-90, 90)
                local smolBoi = Isaac.Spawn(Isaac.GetEntityTypeByName("Globlet"),Isaac.GetEntityVariantByName("Globlet"), 0, npc.Position+Vector(25,0):Rotated(randoAngle), Vector(10,0):Rotated(randoAngle),npc)
                --smolBoi:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                smolBoi.Parent = npc
            end
        elseif data.containedEnemy == 4 then
            --Giblet
            --print("giblet")
            for i=0,1,1 do
                local randoAngle = targetangle + math.random(-90, 90)
                local smolBoi = Isaac.Spawn(Entities.GIBLET.TYPE, Entities.GIBLET.VARIANT, 0, npc.Position+Vector(25,0):Rotated(randoAngle), Vector(10,0):Rotated(randoAngle),npc)
                --smolBoi:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                smolBoi.Parent = npc
            end
        end
    end
end


Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, CADRE.NPCUpdate, Isaac.GetEntityTypeByName("Cadre"))
Mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, CADRE.NPCDeathCheck, Isaac.GetEntityTypeByName("Cadre"))