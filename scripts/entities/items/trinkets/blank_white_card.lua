local Mod = BotB
local BLANK_WHITE_CARD = {}
local ff = FiendFolio

if EID then
	EID:addTrinket(Isaac.GetTrinketIdByName("Blank White Card"), "Consumables have a 33% chance to be rerolled on spawn. #This reroll includes all defined modded consumables.")
    EID:addTrinket(Isaac.GetTrinketIdByName("Blank White Card")+TrinketType.TRINKET_GOLDEN_FLAG, "Consumables have a {{ColorRainbow}}50% chance{{ColorReset}} to be rerolled on spawn. #This reroll includes all defined modded consumables.")
end

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
--[[
function BLANK_WHITE_CARD:doBlankWhiteCardReroll()
    local room = Game():GetRoom()
    local game = Game()
     local level = game:GetLevel()
     local roomDescriptor = level:GetCurrentRoomDesc()
     local roomConfigRoom = roomDescriptor.Data
    if not roomDescriptor.VisitedCount == 1 then return end
    local players = getPlayers()
    local doesSomeoneHaveBlankWhiteCard = false
    local bwcMultiplier= 0
	for i=1,#players,1 do
		if players[i]:ToPlayer():HasTrinket(Isaac.GetTrinketIdByName("Blank White Card")) then
			--print("dicks")
			bwcMultiplier= bwcMultiplier+ players[i]:ToPlayer():GetTrinketMultiplier(Isaac.GetTrinketIdByName("Blank White Card"))

		end
	end
    if bwcMultiplier == 0 then return end


    if roomDescriptor.VisitedCount == 1 then
        local roomEntities = room:GetEntities() -- cppcontainer
        for i = 0, #roomEntities - 1 do
            local entity = roomEntities:Get(i)
            --print(entity.Type, entity.Variant, entity.SubType)
            if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_TAROTCARD then
                local spawnPos = entity.Position
                local cardIDLimit = (#Isaac.GetItemConfig():GetCards())-1
                local entityPickup = entity:ToPickup()
                entityPickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, math.random(1,cardIDLimit), true, true, true)
                --Golden trinket or mom's box: You get a choice between however many consumables instead of just one
                if bwcMultiplier > 1 then
                    if entityPickup.OptionsPickupIndex == 0 then
                        local blankWhiteCardOptionsIndex = 99 + TSIL.Pickups.GetPickupIndex(entityPickup)
                        entityPickup.OptionsPickupIndex = blankWhiteCardOptionsIndex
                        for j=1,bwcMultiplier do
                            local bwcOptionsPickupSpawn = Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_TAROTCARD,math.random(1,cardIDLimit),Isaac.GetFreeNearPosition(entityPickup.Position, 10),Vector.Zero,entityPickup):ToPickup()
                            bwcOptionsPickupSpawn.OptionsPickupIndex = entityPickup.OptionsPickupIndex
                        end
                    else
                        local blankWhiteCardOptionsIndex = entityPickup.OptionsPickupIndex
                        for j=1,bwcMultiplier do
                            local bwcOptionsPickupSpawn = Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_TAROTCARD,math.random(1,cardIDLimit),Isaac.GetFreeNearPosition(entityPickup.Position, 10),Vector.Zero,entityPickup):ToPickup()
                            bwcOptionsPickupSpawn.OptionsPickupIndex = blankWhiteCardOptionsIndex
                        end
                    end
                end
            end
        end    
    end
  end
  Mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, BLANK_WHITE_CARD.doBlankWhiteCardReroll, 0)
]]

  --yoinked from rare chests and modified with FF code
local grng = RNG()
function BLANK_WHITE_CARD:cardUpdate(pickup)
	if (pickup:GetSprite():IsPlaying("Appear") or pickup:GetSprite():IsPlaying("AppearFast"))  and not pickup:GetData().nomorph then
        --if player has Blank White Card
		if pickup.Variant == 300 then
            grng:SetSeed(pickup.InitSeed, 0)
            --print("card")
            --Toy Chest
            local rhchance
            if FiendFolio.anyPlayerHas(BotB.Enums.Trinkets.BLANK_WHITE_CARD, true) then
                rhchance = 2
                if FiendFolio.getTrinketMultiplierAcrossAllPlayers(BotB.Enums.Trinkets.BLANK_WHITE_CARD) > 1 then
                    rhchance = 1
                end
                if grng:RandomInt(rhchance) == 0 then
                    --local spawnPos = entity.Position
                    local cardIDLimit = (#Isaac.GetItemConfig():GetCards())-1
                    --print("REROLL")
                    pickup:Morph(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_TAROTCARD,math.random(1,cardIDLimit), true)
                    pickup:GetData().nomorph = true
                    SFXManager():Play(Isaac.GetSoundIdByName("CardFlip"), 0.9, 2, false, 2, 0)
                end
            end
			
		end
	end
end
Mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, BLANK_WHITE_CARD.cardUpdate)