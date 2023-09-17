local Mod = BotB
local JAIL_KEYGHOST = {}
local Familiars = BotB.Enums.Familiars
local Items = BotB.Enums.Items

local HiddenItemManager = require("scripts.core.hidden_item_manager")
--HiddenItemManager:Init(BotB)

function JAIL_KEYGHOST:FamiliarUpdate(npc)

    local sprite = npc:GetSprite()
    local data = npc:GetData()
    local room = Game():GetRoom()
    local player = npc.Player:ToPlayer()


    if npc.Type == Familiars.JAIL_KEYGHOST.TYPE and npc.Variant == Familiars.JAIL_KEYGHOST.VARIANT then 
        --print("oi shitnuts my state is " .. npc.State)

        if npc.State == 0 then
            if data.botbJailGhostHasDoneDoorCheck == nil then
                --exists to make it do the door check once per new room
                data.botbJailGhostHasDoneDoorCheck = false
            end
            sprite:Play("Appear")
            if sprite:IsFinished("Appear") then
                npc.State = 99
                sprite:Play("Move")
                npc:AddToFollowers()
            end
        end



        --States
        -- 99 - idle
        -- 100 - going to jail door
        -- 101 - dissappear
        if npc.State == 99 then
            --idk lol
            --oh wait check for jail door right
            if data.botbJailGhostHasDoneDoorCheck == false and room:IsClear() then
                for i=0,8,1 do
                    if room:GetDoor(i) ~= nil then
                        local door = room:GetDoor(i)
                        if door:GetSprite():GetFilename() == "gfx/grid/jaildoor.anm2" then
                            --this door is the one!!
                            data.botbJailGhostTargetDoor = door
                            npc.State = 100
                        end
                    end
                end
                data.botbJailGhostHasDoneDoorCheck = true
            else
                npc:FollowParent()
            end
            
        end

        if npc.State == 100 then
            npc:FollowPosition(data.botbJailGhostTargetDoor.Position)
            if npc.Position:Distance(data.botbJailGhostTargetDoor.Position) <= 5 then
                npc.State = 101
                npc.Velocity = Vector.Zero
                sprite:Play("Poof")
            end
        end

        if npc.State == 101 then
            if sprite:IsEventTriggered("UseKey") then
                sfx:Play(SoundEffect.SOUND_UNLOCK00,2,0,false,0.75)
                data.botbJailGhostTargetDoor:TryUnlock(player, true)
            end
            if sprite:IsFinished("Poof") then
                --get rid of the dummy item, and then remove the npc
                if HiddenItemManager:Has(player, BotB.Enums.Items.JAIL_KEYGHOST, "JAILGHOST_GROUP") then
                    player:GetData().hasOpenedTheJailDoorThisFloor = true
                    HiddenItemManager:RemoveAll(player, "JAILGHOST_GROUP")
                end
                npc:Remove()
            end
        end

    end
end


Mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, JAIL_KEYGHOST.FamiliarUpdate, Isaac.GetEntityVariantByName("Jail Keyghost"))


--ITEM code

if EID then
	EID:addCollectible(Isaac.GetItemIdByName("Jail Keyghost"), "Opens the jail door for you. That's all. How did you even get this on a pedestal?")
end
--Egocentrism moment

--Stats
function JAIL_KEYGHOST:onCache(player, _)
    --local collectibleRNG = player:GetCollectibleRNG(Isaac.GetItemIdByName("Jail Keyghost"))
    --local itemConfig = Isaac.GetItemConfig():GetCollectible(Isaac.GetItemIdByName("Jail Keyghost"))
    player:CheckFamiliar(Isaac.GetEntityVariantByName("Jail Keyghost"), BotB.Functions.GetExpectedFamiliarNum(player,Items.JAIL_KEYGHOST), player:GetCollectibleRNG(Isaac.GetItemIdByName("Jail Keyghost")), Isaac.GetItemConfig():GetCollectible(Isaac.GetItemIdByName("Jail Keyghost")))
end
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, JAIL_KEYGHOST.onCache,CacheFlag.CACHE_FAMILIARS)


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


function JAIL_KEYGHOST:onNewRoom()

    local room = Game():GetRoom()
    local roomEntities = room:GetEntities()
    for i = 0, #roomEntities - 1 do
        local entity = roomEntities:Get(i)
        if entity.Type == BotB.Enums.Familiars.JAIL_KEYGHOST.TYPE and entity.Variant == BotB.Enums.Familiars.JAIL_KEYGHOST.VARIANT then
            entity:GetData().botbJailGhostHasDoneDoorCheck = false
        end
    end

    

end
Mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, JAIL_KEYGHOST.onNewRoom)


--just resets the door state per floor
function JAIL_KEYGHOST:botbResetJailDoorState()
    local players = getPlayers()
    for i=1,#players,1 do
      if players[i]:GetData().hasOpenedTheJailDoorThisFloor ~= false then
        players[i]:GetData().hasOpenedTheJailDoorThisFloor = false
      end
    end
  end
  
  Mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, JAIL_KEYGHOST.botbResetJailDoorState, 0)