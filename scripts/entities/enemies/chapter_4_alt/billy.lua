local Mod = BotB
local BILLY = {}
local Entities = BotB.Enums.Entities

function BILLY:NPCUpdate(npc)
    if npc.Type == BotB.Enums.Entities.BILLY.TYPE and npc.Variant == BotB.Enums.Entities.BILLY.VARIANT then 

        local sprite = npc:GetSprite()
        local player = npc:GetPlayerTarget()
        local data = npc:GetData()
        local target = npc:GetPlayerTarget()
        local targetpos = target.Position
        local targetangle = (targetpos - npc.Position):GetAngleDegrees()
        local targetdistance = (targetpos - npc.Position):Length()
        if data.billySpriteVariant == nil then
            data.billySpriteVariant = math.random(1,4)
            sprite:ReplaceSpritesheet(0, "gfx/monsters/chapter_4.5/billy".. data.billySpriteVariant ..".png")
			sprite:LoadGraphics()
        end
        if sprite:IsFinished("Appear") then
            --[[
            data.botbCordLength = 50
            data.botbCordTester = Isaac.Spawn(Entities.BILLY_CORD_DUMMY.TYPE,Entities.BILLY_CORD_DUMMY.VARIANT,0,npc.Position+Vector(25,0),Vector.Zero,npc) 
            data.botbCordTester:GetData().botbIsCorded = true
            data.botbCordTester:GetData().botbCordedParent = npc
            data.botbCordTester.Parent = npc
            data.botbBillyCord = Isaac.Spawn(EntityType.ENTITY_EVIS, 10, 0, npc.Position, Vector.Zero, npc):ToNPC()
            data.botbBillyCord:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            --local dummyeffect = mod:AddDummyEffect(npc, Vector(10,-30))
            data.botbBillyCord.Parent = npc
            data.botbBillyCord.Target = data.botbCordTester]]
            --todo: table of entity, then cord length
            data.botbBillyBaseCordLength = 300
            data.botbBillyCordChildTable = {}
            for i=0, 4 do
                data.botbCordLength = data.botbBillyBaseCordLength + (20*math.random(-3,3))
                local randomStartAngle = math.random(0,359)
                data.botbCordTester = Isaac.Spawn(Entities.BILLY_CORD_DUMMY.TYPE,Entities.BILLY_CORD_DUMMY.VARIANT,0,npc.Position+Vector(25,0):Rotated(randomStartAngle),Vector.Zero,npc) 
                data.botbBillyCord = Isaac.Spawn(EntityType.ENTITY_EVIS, 10, 0, npc.Position, Vector.Zero, npc):ToNPC()
                local cordSprite = math.random(1,4)
                if cordSprite == 1 then
                    data.botbBillyCord:GetSprite():ReplaceSpritesheet(0, "gfx/monsters/chapter_4.5/billy_cord.png")
                    data.botbBillyCord:GetSprite():ReplaceSpritesheet(1, "gfx/monsters/chapter_4.5/billy_cord.png")
                else
                    data.botbBillyCord:GetSprite():ReplaceSpritesheet(0, "gfx/monsters/chapter_4.5/billy_cord_".. cordSprite ..".png")
                    data.botbBillyCord:GetSprite():ReplaceSpritesheet(1, "gfx/monsters/chapter_4.5/billy_cord_".. cordSprite ..".png")
                end
                data.botbBillyCord:GetSprite():LoadGraphics()
                data.botbBillyCord:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                --local dummyeffect = mod:AddDummyEffect(npc, Vector(10,-30))
                data.botbBillyCord.Parent = npc
                data.botbBillyCord.Target = data.botbCordTester
                data.botbCordTester.Velocity = Vector(12,0):Rotated(randomStartAngle)
                data.botbCordTester:GetData().botbIsCorded = true
                data.botbCordTester:GetData().botbBillyCordMoveAngle = randomStartAngle
                data.botbCordTester:GetData().botbCordedParent = npc
                data.botbCordTester.Parent = npc
                data.botbBillyCordChildTable[#data.botbBillyCordChildTable+1] = {
                    ENTITY = data.botbCordTester,
                    CORD_LENGTH = data.botbCordLength,
                }
            end

            npc.State = 99
            sprite:Play("Idle")
        end

        if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_WALLS then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
        end

        if npc.State == 99 then
            --just attempts to move toward the player
            --checks distance of all children and is pulled accordingly
            for i=1,#data.botbBillyCordChildTable do
                local cordedEnt = data.botbBillyCordChildTable[i].ENTITY
                local cordedEntLength = data.botbBillyCordChildTable[i].CORD_LENGTH
                local cordedEntDist = (cordedEnt.Position - npc.Position):Length()
                if cordedEntDist > cordedEntLength then
                    local distToClose = (cordedEnt.Position - npc.Position) - (cordedEnt.Position - npc.Position):Resized(cordedEntLength)
                    npc.Velocity = npc.Velocity + distToClose*(1/16)
                end
            end

            npc.Velocity = npc.Velocity + Vector(0.1,0):Rotated(targetangle)
        end

        npc.Velocity = npc.Velocity:Clamped(-10,-10,10,10)
    end   
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, BILLY.NPCUpdate, Isaac.GetEntityTypeByName("I.L.L."))


function BILLY:CordedEntityUpdate(npc)
    local data = npc:GetData()
    if data.botbIsCorded ~= true or data.botbCordedParent == nil then return end

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
            npc.Velocity = (npc.Velocity + distToClose*(1/16))
        end


end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, BILLY.CordedEntityUpdate)


function BILLY:CordDummyUpdate(npc)
    if npc.Type == BotB.Enums.Entities.BILLY_CORD_DUMMY.TYPE and npc.Variant == BotB.Enums.Entities.BILLY_CORD_DUMMY.VARIANT then 

        local sprite = npc:GetSprite()
        local player = npc:GetPlayerTarget()
        local data = npc:GetData()
        local target = npc:GetPlayerTarget()
        local targetpos = target.Position
        local targetangle = (targetpos - npc.Position):GetAngleDegrees()
        local targetdistance = (targetpos - npc.Position):Length()

        if npc.State == 0 then
            if data.botbBillyCordStickTimer == nil then
                data.botbBillyCordStickTimer = 0
                
                data.botbBillyCordStickPos = npc.Position
                data.botbBillyCordCanStickCooldown = 0
                --initial angle is random
            end
            npc.State = 99
        end

        if npc.Parent == nil or npc.Parent:IsDead() == true then
            npc:Remove()
        end

        --99: Moves and accelerates in the direction of Isaac, if colliding with a grid when the can stick cooldown is 0 update the stick position, set the cooldown and turn to state 100
        --100: sticking to a grid, keep position to the stick position and decrement timer and when it runs out redo the move angle
        --move angle should default to being toward isaac, but if it leads directly into a grid then just seek a random angle
        if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_NOPITS then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NOPITS
        end

        if npc.State == 99 then
            if data.botbBillyCordMoveAngle ~= nil then
                npc.Velocity = (npc.Velocity + Vector(2,0):Rotated(data.botbBillyCordMoveAngle)):Clamped(-10,-10,10,10)

                    --slight steering toward target?
                    if Game():GetRoom():CheckLine(npc.Position, npc.Position+(Vector(2,0):Rotated(targetangle)), 3) == true then
                        npc.Velocity = (npc.Velocity + Vector(2,0):Rotated(targetangle)):Clamped(-10,-10,10,10)
                    end

                if data.botbBillyCordCanStickCooldown ~= 0 then
                    data.botbBillyCordCanStickCooldown = data.botbBillyCordCanStickCooldown - 1
                else
                    if npc:CollidesWithGrid() then
                        npc:PlaySound(SoundEffect.SOUND_MEAT_IMPACTS,0.5,0,false,math.random(400,600)/1000)
                        data.botbBillyCordStickPos = npc.Position
                        data.botbBillyCordStickTimer = math.random(60,240)
                        npc.State = 100
                    end
                end
            end
        end

        if npc.State == 100 then
            npc.Velocity = Vector.Zero
            npc.Position = data.botbBillyCordStickPos
            if data.botbBillyCordStickTimer ~= 0 then
                data.botbBillyCordStickTimer = data.botbBillyCordStickTimer - 1
            else
                npc:PlaySound(SoundEffect.SOUND_MEAT_IMPACTS,0.8,0,false,math.random(400,600)/1000)
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
                    data.botbBillyCordMoveAngle = angleToCheck
                    data.botbBillyCordCanStickCooldown = 15
                    npc.State = 99
            end
        end
    end   
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, BILLY.CordDummyUpdate, Isaac.GetEntityTypeByName("I.L.L. Cord Dummy"))


