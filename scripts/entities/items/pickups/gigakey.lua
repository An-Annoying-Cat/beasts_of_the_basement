local Mod = BotB
sfx = SFXManager()
game = Game()
local GIGA_KEY = {}

--print("wtf is going on")
--
function GIGA_KEY:getGigaKey(pickup,collider,_)
    local data = pickup:GetData()
    local sprite = pickup:GetSprite()
    --print(pickup.Type .. "," .. pickup.Variant .. "," .. pickup.SubType)
    if pickup.SubType ~= nil and pickup.SubType == Mod.Enums.Pickups.GIGA_KEY.SUBTYPE and collider.Type == Isaac.GetEntityTypeByName("Player") then
        sfx:Play(SoundEffect.SOUND_GOLDENKEY,2,0,false,0.5)
        pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        sprite:Play("Collect")
        data.Collector = collider:ToPlayer()
        data.Collector:AddKeys(6)
        --TSIL.Players.AddSmeltedTrinket(collider:ToPlayer(),TrinketType.TRINKET_STORE_CREDIT)
        return false
    end
end

function GIGA_KEY:gigaKeyUpdate(pickup)
    local data = pickup:GetData()
    local sprite = pickup:GetSprite()
    if data.Collector == nil then
        data.Collector = pickup
    end
    --print("cock2")
    --print(pickup:GetCoinValue())
    if pickup.SubType ~= nil and pickup.SubType == Mod.Enums.Pickups.GIGA_KEY.SUBTYPE then

        if sprite:IsEventTriggered("DropSound") then
            Game():ShakeScreen(15)
            SFXManager():Play(SoundEffect.SOUND_KEY_DROP0,2,0,false,math.random(50, 60)/100)
            SFXManager():Play(BotB.Enums.SFX.FUNNY_PIPE,1,0,false,math.random(80, 90)/100)
        end
        if sprite:IsEventTriggered("Remove") then
            pickup:Remove()
        end
    end

end

Mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION,GIGA_KEY.getGigaKey,PickupVariant.PICKUP_KEY)
Mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE,GIGA_KEY.gigaKeyUpdate,PickupVariant.PICKUP_KEY)

function BotB:searchCMD(cmd, params)
    if not cmd == "searchtest" then return end
    if cmd == "searchtest" then
        --local playerTable = BotB:GetPlayers()
        print("this better have been worth the effort")

        local rooms = Game():GetLevel():GetRooms()
        for i = 0, rooms.Size-1 do
                print("---------------------")
                local room = rooms:Get(i)
                
                local everythingInRoomString = "("
                local roomConfigRoom = room.Data
                local spawnList = roomConfigRoom.Spawns
                for j=0, spawnList.Size-1 do
                    local roomConfigSpawn = spawnList:Get(j)
                    local roomConfigEntry = roomConfigSpawn:PickEntry(0)
                    
                    local config = StageAPI.GetEntityConfig(roomConfigEntry.Type, roomConfigEntry.Variant, roomConfigEntry.SubType)
                        if config and config.Name and roomConfigEntry.Type ~= EntityType.ENTITY_EFFECT then
                            everythingInRoomString = everythingInRoomString .. config.Name .. ", "
                        end
                    --[[
                    if roomConfigEntry.Type == EntityType.ENTITY_PICKUP and roomConfigEntry.Variant == PickupVariant.PICKUP_COLLECTIBLE then
                        print("Found pedestal of subtype " .. roomConfigEntry.Subtype .. " in " .. roomConfigRoom.Name .. " of type " .. roomConfigRoom.Type)
                    else
                        local config = StageAPI.GetEntityConfig(roomConfigEntry.Type, roomConfigEntry.Variant, roomConfigEntry.SubType)
                        if config and config.Name and roomConfigEntry.Type ~= EntityType.ENTITY_EFFECT then
                            print(config.Name)
                        end
                    end]]

                    
                end
                everythingInRoomString = everythingInRoomString .. ")"
                print(everythingInRoomString)
            

        end


    end
    
    
end
Mod:AddCallback(ModCallbacks.MC_EXECUTE_CMD, BotB.searchCMD)