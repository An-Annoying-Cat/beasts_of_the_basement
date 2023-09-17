local Mod = BotB
sfx = SFXManager()
game = Game()
local JAIL_KEY = {}
--print("wtf is going on")

local HiddenItemManager = require("scripts.core.hidden_item_manager")
--HiddenItemManager:Init(BotB)
if EID then
    EID:addEntity(5, Mod.Enums.Pickups.JAIL_KEY.VARIANT, Mod.Enums.Pickups.JAIL_KEY.SUBTYPE, "Jail Key", "#Grants a {{ColorOrange}}Black Keyghost{{ColorReset}} which can open the door to the {{ColorOrange}}Jail{{ColorReset}} somewhere on this floor.")
end

function JAIL_KEY:getJailKey(pickup,collider,_)
    local data = pickup:GetData()
    local sprite = pickup:GetSprite()
    --print(pickup.Type .. "," .. pickup.Variant .. "," .. pickup.SubType)
    if pickup.SubType ~= nil and pickup.SubType == Mod.Enums.Pickups.JAIL_KEY.SUBTYPE and collider.Type == Isaac.GetEntityTypeByName("Player") then
        sfx:Play(BotB.Enums.SFX.JAIL_KEY_GET,1,0,false,1)
        pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        sprite:Play("Collect")
        --print("as of now this does nothing until i make the familiar work")

        HiddenItemManager:AddForFloor(collider:ToPlayer(), BotB.Enums.Items.JAIL_KEYGHOST, 0, 1, "JAILGHOST_GROUP")

        --data.Collector = collider:ToPlayer()
        --data.Collector:AddKeys(6)
        --TSIL.Players.AddSmeltedTrinket(collider:ToPlayer(),TrinketType.TRINKET_STORE_CREDIT)
        return false
    end
end

function JAIL_KEY:jailKeyUpdate(pickup)
    local data = pickup:GetData()
    local sprite = pickup:GetSprite()
    if data.Collector == nil then
        data.Collector = pickup
    end
    --print("cock2")
    --print(pickup:GetCoinValue())
    if pickup.SubType ~= nil and pickup.SubType == Mod.Enums.Pickups.JAIL_KEY.SUBTYPE then

        if sprite:IsEventTriggered("DropSound") then
            --Game():ShakeScreen(15)
            sfx:Play(SoundEffect.SOUND_KEY_DROP0,2,0,false,math.random(50, 60)/100)
            --sfx:Play(BotB.Enums.SFX.FUNNY_PIPE,1,0,false,math.random(80, 90)/100)
        end
        if sprite:IsFinished("Collect") then
            pickup:Remove()
        end
    end

end

Mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION,JAIL_KEY.getJailKey,PickupVariant.PICKUP_GRAB_BAG)
Mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE,JAIL_KEY.jailKeyUpdate,PickupVariant.PICKUP_GRAB_BAG)





--This should make the grid appear in the room adjacent the jail.
--[[
function JAIL_KEY:onNewRoom()

end
Mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM,JAIL_KEY.onNewRoom)
]]


--Until we get the grid working, just spawn the key in the secret room
--[[
function JAIL_KEY:SpawnVisitJailKey()
    local players = Solomon:GetPlayers()
    local room = Game():GetRoom()
    local game = Game()
     local level = game:GetLevel()
     local roomDescriptor = level:GetCurrentRoomDesc()
     local roomConfigRoom = roomDescriptor.Data
    if roomConfigRoom.Type == RoomType.ROOM_LIBRARY or roomConfigRoom.Type == RoomType.ROOM_SECRET then
      if roomDescriptor.VisitedCount == 1 then
        for i=1,#players,1 do
          if players[i]:GetPlayerType() == PLAYER_SOLOMON then
            Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_GRAB_BAG,Mod.Enums.Pickups.KP_LARGE.SUBTYPE,room:FindFreePickupSpawnPosition(room:GetCenterPos()),Vector.Zero,players[i])
          end
        end
      end
    end
  end
  Mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, JAIL_KEY.SpawnVisitJailKey, 0)]]