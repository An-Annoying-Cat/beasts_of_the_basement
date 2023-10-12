local Mod = BotB
local PURSUER_V2 = {}
local Entities = BotB.Enums.Entities

function PURSUER_V2:NPCUpdate(npc)

    
    
    

    if npc.Type == BotB.Enums.Entities.PURSUER_V2.TYPE and npc.Variant == BotB.Enums.Entities.PURSUER_V2.VARIANT and npc.SubType == 20 then 


        local sprite = npc:GetSprite()
        local player = npc:GetPlayerTarget()
        local data = npc:GetData()
        local target = npc:GetPlayerTarget()
        local targetpos = target.Position
        local targetangle = (targetpos - npc.Position):GetAngleDegrees()
        local targetdistance = (targetpos - npc.Position):Length()

        --print("beebis")
        if npc.State ~= 99 then
            --Init
                npc.State = 99
                sprite:Play("Idle")
        end
        --States:
        --99: Watching
        --    Following
        --    Stalking
        --    Hiding
        
        if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_NONE then
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
        end
        if not npc:HasEntityFlags(EntityFlag.FLAG_PERSISTENT) then
            npc:AddEntityFlags(EntityFlag.FLAG_PERSISTENT | EntityFlag.FLAG_TRANSITION_UPDATE)
        end

        if npc.State == 99 then
            if Game():GetRoom():IsPositionInRoom(npc.Position, 0) then
                npc.Velocity = (((0.999 * npc.Velocity) + (0.001 * (target.Position - npc.Position))):Clamped(-1,-1,1,1))
            else
                npc.Velocity = (((0.999 * npc.Velocity) + (0.001 * (target.Position - npc.Position))):Clamped(-2,-2,2,2))
            end
            

            local pitchbendAmount
            --20 is minimum, 1000 is maximum
            pitchbendAmount = 1-((1000-(targetdistance - 20))/1000)
            if pitchbendAmount <= 0.1 then
                pitchbendAmount = 0.1
            end
            if pitchbendAmount >= 0.8 then
                pitchbendAmount = 0.8
            end
            MusicManager():PitchSlide(pitchbendAmount)

            if targetdistance < 20 then
                -- uh oh jacobs curse
                if target:ToPlayer() ~= nil then
                    if player:GetData().gotPursued ~= true then
                        player:GetData().gotPursued = true
                        BotB.FF.scheduleForUpdate(function()
                            sfx:Play(SoundEffect.SOUND_FIREDEATH_HISS)
                            sfx:Play(SoundEffect.SOUND_ISAACDIES)
                        end, 0, ModCallbacks.MC_POST_PEFFECT_UPDATE)
                    end
                    
                    
                end
                --print("get jainted tacobed idiot")
            end

            --avoid doors so the curse cant be cheesed
            local doors = TSIL.Doors.GetDoors()
            for i=1, #doors do
                local door = doors[i]
                local doorpos = door.Position
                local doorangle = (doorpos - npc.Position):GetAngleDegrees()
                local doordistance = (doorpos - npc.Position):Length()
                --print("door's state is " .. door.State)
                if doordistance <= 125 and door.State == 2 then
                    if Game():GetRoom():IsPositionInRoom(npc.Position, 0) then
                        npc.Velocity = ((0.99 * npc.Velocity) + (0.01 * (npc.Position - door.Position))):Clamped(-1,-1,1,1)
                    else
                        npc.Velocity = ((0.99 * npc.Velocity) + (0.01 * (npc.Position - door.Position))):Clamped(-2,-2,2,2)
                    end
                end
            end
        end

    end
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, PURSUER_V2.NPCUpdate, Isaac.GetEntityTypeByName("Pursuer V2"))

--no mantle 4 u
Mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
	if player:GetData().gotPursued == true then
		local effects = player:GetEffects()
        effects:RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE, 1)
		if not effects:HasNullEffect(NullItemID.ID_LOST_CURSE) then
			effects:AddNullEffect(NullItemID.ID_LOST_CURSE)
            effects:RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE, 1)
            
			if game:GetRoom():GetFrameCount() > 0 then
				sfx:Play(SoundEffect.SOUND_FIREDEATH_HISS)
			elseif effects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE) then
				effects:RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE, 1)
			end
		end
    else
        local effects = player:GetEffects()
        effects:RemoveNullEffect(NullItemID.ID_LOST_CURSE)
        effects:RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE, 1)
	end
end)





