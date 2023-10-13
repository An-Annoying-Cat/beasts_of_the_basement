local Mod = BotB
local TRIACHNOID = {}
local Entities = BotB.Enums.Entities





function TRIACHNOID:NPCUpdate(npc)
    if npc.Type == BotB.Enums.Entities.TRIACHNOID.TYPE and npc.Variant == BotB.Enums.Entities.TRIACHNOID.VARIANT then 

        local sprite = npc:GetSprite()
        local player = npc:GetPlayerTarget()
        local data = npc:GetData()
        local target = npc:GetPlayerTarget()
        local targetpos = target.Position
        local targetangle = (targetpos - npc.Position):GetAngleDegrees()
        local targetdistance = (targetpos - npc.Position):Length()
        --[[
        if data.billySpriteVariant == nil then
            data.billySpriteVariant = math.random(1,4)
            sprite:ReplaceSpritesheet(0, "gfx/monsters/chapter_4.5/billy".. data.billySpriteVariant ..".png")
			sprite:LoadGraphics()
        end]]
        if sprite:IsFinished("Appear") then
            --[[
            data.botbCordLength = 50
            data.botbCordTester = Isaac.Spawn(Entities.TRIACHNOID_CORD_DUMMY.TYPE,Entities.TRIACHNOID_CORD_DUMMY.VARIANT,0,npc.Position+Vector(25,0),Vector.Zero,npc) 
            data.botbCordTester:GetData().botbIsTriachnoidCorded = true
            data.botbCordTester:GetData().botbCordedParent = npc
            data.botbCordTester.Parent = npc
            data.botbTriachnoidCord = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.KINETI_BEAM, 0, npc.Position, Vector.Zero, npc):ToEffect()
            data.botbTriachnoidCord:GetSprite():ReplaceSpritesheet(0, "gfx/monsters/chapter_4/kineti_beam.png")
            data.botbTriachnoidCord:GetSprite():ReplaceSpritesheet(1, "gfx/monsters/chapter_4/kineti_beam.png")
            data.botbTriachnoidCord:GetSprite():LoadGraphics()
            --data.botbTriachnoidCord:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            --local dummyeffect = mod:AddDummyEffect(npc, Vector(10,-30))
            data.botbTriachnoidCord.Parent = npc
            data.botbTriachnoidCord.Target = data.botbCordTester]]
            data.botbTriachnoidCord = Isaac.Spawn(EntityType.ENTITY_EFFECT,BotB.Enums.Entities.TRIACHNOID_LEG.VARIANT,0,Vector(75,75),Vector.Zero,npc)
            data.botbTriachnoidCord:GetData().botbFirstPoint = data.botbCordTester
            data.botbTriachnoidCord:GetData().botbSecondPoint = npc
            --todo: table of entity, then cord length
            data.botbBillyBaseCordLength = 50
            data.botbTriachnoidCordChildTable = {}
            for i=0, 2 do
                data.botbCordLength = data.botbBillyBaseCordLength
                local randomStartAngle = math.random(0,359)
                data.botbCordTester = Isaac.Spawn(Entities.TRIACHNOID_CORD_DUMMY.TYPE,Entities.TRIACHNOID_CORD_DUMMY.VARIANT,0,npc.Position+Vector(25,0):Rotated(randomStartAngle),Vector.Zero,npc) 
                --[[
                    data.botbTriachnoidCord = Isaac.Spawn(EntityType.ENTITY_EVIS, 10, 0, npc.Position, Vector.Zero, npc):ToNPC()
                    data.botbTriachnoidCord:GetSprite():ReplaceSpritesheet(0, "gfx/monsters/chapter_4/triachnid_cord_end.png")
                    data.botbTriachnoidCord:GetSprite():ReplaceSpritesheet(1, "gfx/monsters/chapter_4/triachnid_cord_end.png")
                    data.botbTriachnoidCord:GetSprite():LoadGraphics()
                    data.botbTriachnoidCord:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                    data.botbTriachnoidCord:GetData().isATriachnoidRope = true]]
                --local dummyeffect = mod:AddDummyEffect(npc, Vector(10,-30))
                --data.botbTriachnoidCord.Parent = npc
                --data.botbTriachnoidCord.Target = data.botbCordTester
                data.botbTriachnoidCord = Isaac.Spawn(EntityType.ENTITY_EFFECT,BotB.Enums.Entities.TRIACHNOID_LEG.VARIANT,0,Vector(75,75),Vector.Zero,npc)
                data.botbTriachnoidCord:GetData().botbFirstPoint = npc
                data.botbTriachnoidCord:GetData().botbSecondPoint = data.botbCordTester
                data.botbCordTester.Velocity = Vector(12,0):Rotated(randomStartAngle)
                data.botbCordTester:GetData().botbIsTriachnoidCorded = true
                data.botbCordTester:GetData().botbTriachnoidCordMoveAngle = randomStartAngle
                data.botbCordTester:GetData().botbCordedParent = npc
                data.botbCordTester.Parent = npc
                data.botbTriachnoidCordChildTable[#data.botbTriachnoidCordChildTable+1] = {
                    ENTITY = data.botbCordTester,
                    CORD_LENGTH = data.botbCordLength,
                }
            end

            npc.State = 99
            sprite:Play("Idle")
        end
        npc.DepthOffset = 99999
        if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_WALLS then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
        end

        if npc.State == 99 then
            --just attempts to move toward the player
            --checks distance of all children and is pulled accordingly
            for i=1,#data.botbTriachnoidCordChildTable do
                local cordedEnt = data.botbTriachnoidCordChildTable[i].ENTITY
                local cordedEntLength = data.botbTriachnoidCordChildTable[i].CORD_LENGTH
                local cordedEntDist = (cordedEnt.Position - npc.Position):Length()
                if cordedEntDist > cordedEntLength then
                    local distToClose = (cordedEnt.Position - npc.Position) - (cordedEnt.Position - npc.Position):Resized(cordedEntLength)
                    npc.Velocity = npc.Velocity + distToClose*(1/8)
                end
            end

            npc.Velocity = npc.Velocity + Vector(0.5,0):Rotated(targetangle)
        end

        npc.Velocity = npc.Velocity:Clamped(-2,-2,2,2)
    end   
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, TRIACHNOID.NPCUpdate, Isaac.GetEntityTypeByName("Triachnoid"))


Mod:AddCallback(ModCallbacks.MC_PRE_NPC_UPDATE, function(_, npc)
    if npc.Variant == 10 and npc:GetData().isATriachnoidRope == true then
        npc.Velocity = npc.Velocity:Clamped(-2,-2,2,2)
    end
end, EntityType.ENTITY_EVIS)

--[[
function TRIACHNOID:CordedEntityUpdate(npc)
    local data = npc:GetData()
    if data.botbIsTriachnoidCorded ~= true or data.botbCordedParent == nil then return end

        local sprite = npc:GetSprite()
        local player = npc:GetPlayerTarget()
        local data = npc:GetData()
        local cdata = data.botbCordedParent:GetData()
        local target = npc:GetPlayerTarget()
        local targetpos = target.Position
        local targetangle = (targetpos - npc.Position):GetAngleDegrees()
        local targetdistance = (targetpos - npc.Position):Length()
        local cordParentPos = data.botbCordedParent.Position
        local cordParentLength = (cordParentPos - npc.Position):Length()
        if cdata.botbCordLength == nil then return end
        if cordParentLength > cdata.botbCordLength then
            local distToClose = (cordParentPos - npc.Position) - (cordParentPos - npc.Position):Resized(cdata.botbCordLength)
            npc.Velocity = (npc.Velocity + distToClose*(1/8))
        end


end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, TRIACHNOID.CordedEntityUpdate)]]

function TRIACHNOID:FirstCordUpdate(npc)
    local data = npc:GetData()
    --if data.botbIsTriachnoidCorded ~= true or data.botbCordedParent == nil then return end
        if npc.Type == BotB.Enums.Entities.TRIACHNOID_CORD_DUMMY.TYPE and npc.Variant == BotB.Enums.Entities.TRIACHNOID_CORD_DUMMY.VARIANT then 
            npc.DepthOffset = 99999
            npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            local sprite = npc:GetSprite()
            local player = npc:GetPlayerTarget()
            local data = npc:GetData()
            local cdata = data.botbCordedParent:GetData()
            local target = npc:GetPlayerTarget()
            local targetpos = target.Position
            local targetangle = (targetpos - npc.Position):GetAngleDegrees()
            local targetdistance = (targetpos - npc.Position):Length()
            local cordParentPos = data.botbCordedParent.Position
            local cordParentLength = (cordParentPos - npc.Position):Length()
            if cdata.botbCordLength == nil then return end
            

            if npc.FrameCount == 1 then
                data.botbBillyBaseCordLength = 50
                data.botbTriachnoidCordChildTable = {}
                data.botbCordLength = data.botbBillyBaseCordLength
                    local randomStartAngle = math.random(0,359)
                    data.botbCordTester = Isaac.Spawn(Entities.TRIACHNOID_LEG_CORD_DUMMY.TYPE,Entities.TRIACHNOID_LEG_CORD_DUMMY.VARIANT,0,npc.Position+Vector(25,0):Rotated(randomStartAngle),Vector.Zero,npc) 
                    --[[
                    data.botbTriachnoidCord = Isaac.Spawn(EntityType.ENTITY_EVIS, 10, 0, npc.Position, Vector.Zero, npc):ToNPC()
                    data.botbTriachnoidCord:GetSprite():ReplaceSpritesheet(0, "gfx/monsters/chapter_4/triachnid_cord_end.png")
                    data.botbTriachnoidCord:GetSprite():ReplaceSpritesheet(1, "gfx/monsters/chapter_4/triachnid_cord_end.png")
                    data.botbTriachnoidCord:GetSprite():LoadGraphics()
                    data.botbTriachnoidCord:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                    data.botbTriachnoidCord:GetData().isATriachnoidRope = true]]
                    --local dummyeffect = mod:AddDummyEffect(npc, Vector(10,-30))
                    --data.botbTriachnoidCord.Parent = npc
                    --data.botbTriachnoidCord.Target = data.botbCordTester
                    data.botbTriachnoidCord = Isaac.Spawn(EntityType.ENTITY_EFFECT,BotB.Enums.Entities.TRIACHNOID_LEG.VARIANT,0,Vector(75,75),Vector.Zero,npc)
                    data.botbTriachnoidCord:GetData().botbFirstPoint = npc
                    data.botbTriachnoidCord:GetData().botbSecondPoint = data.botbCordTester
                    data.botbCordTester.Velocity = Vector(1,0):Rotated(randomStartAngle)
                    data.botbCordTester:GetData().botbIsTriachnoidCorded = true
                    data.botbCordTester:GetData().botbTriachnoidCordMoveAngle = randomStartAngle
                    data.botbCordTester:GetData().botbCordedParent = npc
                    data.botbCordTester.Parent = npc
                    data.botbTriachnoidCordChildTable[#data.botbTriachnoidCordChildTable+1] = {
                        ENTITY = data.botbCordTester,
                        CORD_LENGTH = data.botbCordLength,
                    }
            end
            
            if cordParentLength > cdata.botbCordLength then
                local distToClose = (cordParentPos - npc.Position) - (cordParentPos - npc.Position):Resized(cdata.botbCordLength)
                npc.Velocity = (npc.Velocity + distToClose*(1/8))
            end
            if data.botbTriachnoidCordChildTable ~= nil then
                for i=1,#data.botbTriachnoidCordChildTable do
                    local cordedEnt = data.botbTriachnoidCordChildTable[i].ENTITY
                    local cordedEntLength = data.botbTriachnoidCordChildTable[i].CORD_LENGTH
                    local cordedEntDist = (cordedEnt.Position - npc.Position):Length()
                    if cordedEntDist > cordedEntLength then
                        local distToClose = (cordedEnt.Position - npc.Position) - (cordedEnt.Position - npc.Position):Resized(cordedEntLength)
                        npc.Velocity = npc.Velocity + distToClose*(1/8)
                    end
                end
            end
            

            if npc.Parent == nil or npc.Parent:IsDead() == true then
                Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.POOF04,0,npc.Position,Vector.Zero,effect)
                npc:Remove()
            end

            npc.Velocity = npc.Velocity:Clamped(-8,-8,8,8)

        end
        


end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, TRIACHNOID.FirstCordUpdate)

--
function TRIACHNOID:LegCordDummyUpdate(npc)
    if npc.Type == BotB.Enums.Entities.TRIACHNOID_LEG_CORD_DUMMY.TYPE and npc.Variant == BotB.Enums.Entities.TRIACHNOID_LEG_CORD_DUMMY.VARIANT then 
        npc.DepthOffset = 99999
        local sprite = npc:GetSprite()
        local player = npc:GetPlayerTarget()
        local data = npc:GetData()
        local target = npc:GetPlayerTarget()
        local targetpos = target.Position
        local targetangle = (targetpos - npc.Position):GetAngleDegrees()
        local targetdistance = (targetpos - npc.Position):Length()

        if npc.State == 0 then
            if data.botbTriachnoidCordStickTimer == nil then
                data.botbTriachnoidCordStickTimer = 0
                
                data.botbTriachnoidCordStickPos = npc.Position
                data.botbTriachnoidCordCanStickCooldown = 0
                --initial angle is random
            end
            npc.State = 99
        end

        if npc.Parent == nil or npc.Parent:IsDead() == true then
            Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.POOF04,0,npc.Position,Vector.Zero,effect)
            npc:Remove()
        end

        --99: Moves and accelerates in the direction of Isaac, if colliding with a grid when the can stick cooldown is 0 update the stick position, set the cooldown and turn to state 100
        --100: sticking to a grid, keep position to the stick position and decrement timer and when it runs out redo the move angle
        --move angle should default to being toward isaac, but if it leads directly into a grid then just seek a random angle
        if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_NOPITS then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NOPITS
        end

        if npc.State == 99 then
            if data.botbTriachnoidCordMoveAngle ~= nil then
                npc.Velocity = (npc.Velocity + Vector(2,0):Rotated(data.botbTriachnoidCordMoveAngle)):Clamped(-8,-8,8,8)

                    --slight steering toward target?
                    if Game():GetRoom():CheckLine(npc.Position, npc.Position+(Vector(1,0):Rotated(targetangle)), 3) == true then
                        npc.Velocity = (npc.Velocity + Vector(1,0):Rotated(targetangle)):Clamped(-8,-8,8,8)
                    end
                if data.botbTriachnoidCordCanStickCooldown ~= 0 then
                    data.botbTriachnoidCordCanStickCooldown = data.botbTriachnoidCordCanStickCooldown - 1
                else
                    if npc:CollidesWithGrid() then
                        npc:PlaySound(SoundEffect.SOUND_MEAT_IMPACTS,0.5,0,false,1)
                        data.botbTriachnoidCordStickPos = npc.Position
                        data.botbTriachnoidCordStickTimer = math.random(60,240)
                        npc.State = 100
                    end
                end
            end
        end

        if npc.State == 100 then
            npc.Velocity = Vector.Zero
            npc.Position = data.botbTriachnoidCordStickPos
            if data.botbTriachnoidCordStickTimer ~= 0 then
                data.botbTriachnoidCordStickTimer = data.botbTriachnoidCordStickTimer - 1
            else
                npc:PlaySound(SoundEffect.SOUND_MEAT_IMPACTS,0.8,0,false,1)
                --search for good angle
                --minimum distance should be uhhh idk, 50?
                local angleToCheck = targetangle
                local room = Game():GetRoom()
                for i=0,1000 do
                    if i==0 then
                        angleToCheck = targetangle
                    else
                        angleToCheck = math.random(0,359)
                    end
                    if room:CheckLine(npc.Position, npc.Position+(Vector(50,0):Rotated(angleToCheck)), 3) == true then
                        break
                    end
                end
                    data.botbTriachnoidCordMoveAngle = angleToCheck
                    data.botbTriachnoidCordCanStickCooldown = 15
                    npc.State = 99
            end
        end
        if data.botbCordedParent ~= nil then
            local cdata = data.botbCordedParent:GetData()
        local cordParentPos = data.botbCordedParent.Position
            local cordParentLength = (cordParentPos - npc.Position):Length()
            if cordParentLength ~= nil and cdata.botbCordLength ~= nil and cordParentLength > cdata.botbCordLength then
                local distToClose = (cordParentPos - npc.Position) - (cordParentPos - npc.Position):Resized(cdata.botbCordLength)
                npc.Velocity = (npc.Velocity + distToClose*(1/8))
            end
        end
        

    end   
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, TRIACHNOID.LegCordDummyUpdate, Isaac.GetEntityTypeByName("Triachnoid Leg Cord Dummy"))
--[[
local fucknutNumber1 = Isaac.Spawn(EntityType.ENTITY_GAPER,1,0,Vector(50,20),Vector.Zero, nil):ToNPC()
local fucknutNumber2 = Isaac.Spawn(EntityType.ENTITY_GAPER,1,0,Vector(20,50),Vector.Zero, nil):ToNPC()
local effectTest = Isaac.Spawn(EntityType.ENTITY_EFFECT,BotB.Enums.Entities.TRIACHNOID_LEG.VARIANT,0,Vector(75,75),Vector.Zero,fucknutNumber1)
effectTest:GetData().botbFirstPoint = fucknutNumber1
effectTest:GetData().botbSecondPoint = fucknutNumber2]]

function TRIACHNOID:triachnoidLegEffect(effect)
    local sprite = effect:GetSprite()
    local data = effect:GetData()
    if data.botbFirstPoint == nil or data.botbSecondPoint == nil or data.botbFirstPoint:IsDead() or data.botbSecondPoint:IsDead() then
        Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.POOF04,0,effect.Position,Vector.Zero,effect)
        effect:Remove()
    else
        effect.DepthOffset = -25
        sprite.Scale = Vector(((data.botbFirstPoint.Position - (data.botbSecondPoint.Position))/2):Length()*0.6,1)
        effect.Position = (data.botbFirstPoint.Position + (data.botbSecondPoint.Position))/2
        sprite.Rotation = (data.botbFirstPoint.Position - data.botbSecondPoint.Position):GetAngleDegrees()
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE,TRIACHNOID.triachnoidLegEffect, Isaac.GetEntityVariantByName("Triachnoid Leg"))