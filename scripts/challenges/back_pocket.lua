local Mod = BotB
local mod = FiendFolio
local BACK_POCKET = {}
local Items = BotB.Enums.Items
local sfx = SFXManager()






function BACK_POCKET:backPocketPlayerUpdate(player)
    if not Isaac.GetChallenge() == Isaac.GetChallengeIdByName("[BOTB] Back Pocket") then return end
    local data = player:GetData()
    if Isaac.GetChallenge() == Isaac.GetChallengeIdByName("[BOTB] Back Pocket") then
        if data.botbGotTheirBackPocketShit == nil then
            player:AddCollectible(Items.EMETER_IN, 0, false, ActiveSlot.SLOT_PRIMARY)
            player:SetPocketActiveItem(Items.DECK_OF_TOO_MANY_THINGS, ActiveSlot.SLOT_POCKET, false)
            --player:AddCollectible(Items.DECK_OF_TOO_MANY_THINGS, 0, false, ActiveSlot.SLOT_POCKET)
            TSIL.Players.AddSmeltedTrinket(player,TrinketType.TRINKET_NO)
            data.botbGotTheirBackPocketShit = true
        end
        local room = Game():GetRoom()
        local level = game:GetLevel()
       local roomDescriptor = level:GetCurrentRoomDesc()
       local roomConfigRoom = roomDescriptor.Data
      if roomConfigRoom.Type == RoomType.ROOM_TREASURE then
            --converts item pedestals to randomized consumables in treasure rooms
            local roomEntities = Game():GetRoom():GetEntities() -- cppcontainer
            for i = 0, #roomEntities - 1 do
                local entity = roomEntities:Get(i)
                if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == 100 then
                    local spawnPos = entity.Position
                    local cardIDLimit = (#Isaac.GetItemConfig():GetCards())-1
                    Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_TAROTCARD,math.random(1,cardIDLimit),spawnPos,Vector.Zero,player)
                    entity:Remove()
                end
            end
      end
    end
    
    

end
Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE,BACK_POCKET.backPocketPlayerUpdate)


