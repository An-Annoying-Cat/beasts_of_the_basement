local Mod = BotB
local TOTEMS = {}
local Entities = BotB.Enums.Entities

function TOTEMS:NPCUpdate(npc)
    if npc.Type == EntityType.ENTITY_GENERIC_PROP and npc.Variant == BotB.Enums.Props.ON_TOTEM.VARIANT then 
        print("ontotem")
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, TOTEMS.NPCUpdate, EntityType.ENTITY_GENERIC_PROP)
--
function TOTEMS:playerUpdate(player)
    if player:GetData().totemSwitchCooldown == nil then
        player:GetData().totemSwitchCooldown = 15
    end

    if player:GetData().totemSwitchCooldown ~= 0 then
        player:GetData().totemSwitchCooldown = player:GetData().totemSwitchCooldown - 1
    end
    local roomEntities = Isaac.GetRoomEntities() -- table
    local panelsInTheRoom = {}
    for i = 1, #roomEntities do
        local entity = roomEntities[i]
        local data = entity:GetData()
        --Self processing for the props
        --ON PILLAR
        if entity.Type == EntityType.ENTITY_GENERIC_PROP and entity.Variant == BotB.Enums.Props.ON_TOTEM.VARIANT then     
            local sprite = entity:GetSprite()
            if data.State == nil then
                entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                entity.SortingLayer = SortingLayer.SORTING_BACKGROUND
                sprite:Play("OnPillar_Down")
                data.State = "off"
            end

            if data.State == "on2off" then
                if sprite:IsPlaying("OnPillar_Lower") ~= true then
                    sprite:Play("OnPillar_Lower")
                end
                if sprite:IsFinished("OnPillar_Lower") then
                    sprite:Play("OnPillar_Down")
                    data.State = "off"
                end
            end

            if data.State == "off2on" then
                if sprite:IsPlaying("OnPillar_Raise") ~= true then
                    sprite:Play("OnPillar_Raise")
                end
                if sprite:IsFinished("OnPillar_Raise") then
                    sprite:Play("OnPillar_Up")
                    data.State = "on"
                end
            end

            if sprite:IsEventTriggered("Down") then
                entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                entity.SortingLayer = SortingLayer.SORTING_BACKGROUND
            end
            if sprite:IsEventTriggered("Up") then
                entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
                entity.SortingLayer = SortingLayer.SORTING_NORMAL
            end
        end

        --OFF PILLAR
        if entity.Type == EntityType.ENTITY_GENERIC_PROP and entity.Variant == BotB.Enums.Props.OFF_TOTEM.VARIANT then     
            local sprite = entity:GetSprite()
            if data.State == nil then
                entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                entity.SortingLayer = SortingLayer.SORTING_BACKGROUND
                sprite:Play("OffPillar_Down")
                data.playerIsStepping = false
                data.State = "off"
            end

            if data.State == "on2off" then
                if sprite:IsPlaying("OffPillar_Raise") ~= true then
                    sprite:Play("OffPillar_Raise")
                end
                if sprite:IsFinished("OffPillar_Raise") then
                    sprite:Play("OffPillar_Up")
                    data.State = "off"
                end
            end

            if data.State == "off2on" then
                if sprite:IsPlaying("OffPillar_Lower") ~= true then
                    sprite:Play("OffPillar_Lower")
                end
                if sprite:IsFinished("OffPillar_Lower") then
                    sprite:Play("OffPillar_Down")
                    data.State = "on"
                end
            end

            if sprite:IsEventTriggered("Down") then
                entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                entity.SortingLayer = SortingLayer.SORTING_BACKGROUND
            end
            if sprite:IsEventTriggered("Up") then
                entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
                entity.SortingLayer = SortingLayer.SORTING_NORMAL
            end
        end

        --switch
        if entity.Type == EntityType.ENTITY_GENERIC_PROP and entity.Variant == BotB.Enums.Props.TOTEM_SWITCH.VARIANT then     
            local sprite = entity:GetSprite()
            if data.State == nil then
                entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                entity.SortingLayer = SortingLayer.SORTING_BACKGROUND
                sprite:Play("Button_Off")
                data.State = "off"
            end

            if data.State == "on2off" then
                if sprite:IsPlaying("Button_SwitchedOff") ~= true then
                    sprite:Play("Button_SwitchedOff")
                end
                if sprite:IsFinished("Button_SwitchedOff") then
                    sprite:Play("Button_Off")
                    data.State = "off"
                end
            end

            if data.State == "off2on" then
                if sprite:IsPlaying("Button_SwitchedOn") ~= true then
                    sprite:Play("Button_SwitchedOn")
                end
                if sprite:IsFinished("Button_SwitchedOn") then
                    sprite:Play("Button_On")
                    data.State = "on"
                end
            end

            local measureFromPos = entity.Position
            local measureToPos = player.Position
            if data.playerIsStepping == false then
                if (measureToPos.X >= measureFromPos.X - 20 and measureToPos.X <= measureFromPos.X + 20) and (measureToPos.Y >= measureFromPos.Y - 20 and measureToPos.Y <= measureFromPos.Y + 20) and player:GetData().totemSwitchCooldown == 0  then
                    player:GetData().totemSwitchCooldown = 15
                    SFXManager():Play(SoundEffect.SOUND_SLOTSPAWN,1,0,false,0.6)
                    data.playerIsStepping = true
                    --OH BOY HERE WE GO
                    for i = 1, #roomEntities do
                        local entity = roomEntities[i]
                        if entity.Type == EntityType.ENTITY_GENERIC_PROP and (entity.Variant == BotB.Enums.Props.ON_TOTEM.VARIANT or entity.Variant == BotB.Enums.Props.OFF_TOTEM.VARIANT or entity.Variant == BotB.Enums.Props.TOTEM_SWITCH.VARIANT or entity.Variant == BotB.Enums.Props.TOTEM_LEVER.VARIANT) then
                            
                            if entity:GetData().State == "on" then
                                entity:GetData().State = "on2off"
                            end
                            if entity:GetData().State == "off" then
                                entity:GetData().State = "off2on"
                            end
                        end
                    end
                end
            end

            if ((measureToPos.X >= measureFromPos.X - 20 and measureToPos.X <= measureFromPos.X + 20) and (measureToPos.Y >= measureFromPos.Y - 20 and measureToPos.Y <= measureFromPos.Y + 20)) ~= true then
                data.playerIsStepping = false
                --OH BOY HERE WE GO
            end            
        end
    end
    
end
Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, TOTEMS.playerUpdate, 0)

local function getPlayers()
	local game = Game()
	local numPlayers = game:GetNumPlayers()
  
	local players = {}
	for i = 0, numPlayers - 1 do
	  local player = Isaac.GetPlayer(i)
	  table.insert(players, player)
	end
  
	return players
end