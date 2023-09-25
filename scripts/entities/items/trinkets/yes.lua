local Mod = BotB
local BLANK_WHITE_CARD = {}
local ff = FiendFolio

if EID then
	EID:addTrinket(Isaac.GetTrinketIdByName("YES!"), "Grants a 0.25% chance for pickups to become pedestal items.")
    EID:addTrinket(Isaac.GetTrinketIdByName("YES!")+TrinketType.TRINKET_GOLDEN_FLAG, "Grants a {{ColorRainbow}}0.5%{{ColorReset}} chance for pickups to become pedestal items.")
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

function BLANK_WHITE_CARD:doBlankWhiteCardReroll()
    local room = Game():GetRoom()
    local game = Game()
     local level = game:GetLevel()
     local roomDescriptor = level:GetCurrentRoomDesc()
     local roomConfigRoom = roomDescriptor.Data
    if not roomDescriptor.VisitedCount == 1 then return end
    local players = getPlayers()
    local doesSomeoneHaveBlankWhiteCard = false
    local yesMultiplier= 0
	for i=1,#players,1 do
		if players[i]:ToPlayer():HasTrinket(Isaac.GetTrinketIdByName("YES!")) then
			--print("dicks")
			yesMultiplier= yesMultiplier+ players[i]:ToPlayer():GetTrinketMultiplier(Isaac.GetTrinketIdByName("YES!"))

		end
	end
    if yesMultiplier == 0 then return end
    --cuz random float
    local baseYesChance = 0.25/100

    if roomDescriptor.VisitedCount == 1 then
        local roomEntities = room:GetEntities() -- cppcontainer
        for i = 0, #roomEntities - 1 do
            local entity = roomEntities:Get(i)
            --print(entity.Type, entity.Variant, entity.SubType)
            if entity.Type == EntityType.ENTITY_PICKUP then
                local spawnPos = entity.Position
                local entityPickup = entity:ToPickup()
                --entityPickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, math.random(1,cardIDLimit), true, true, true)
                --Golden trinket or mom's box: chance is multiplied
                if yesMultiplier > 1 then
                    baseYesChance = baseYesChance * yesMultiplier
                end
                local yesRando = Random()
                print(yesRando)
                if yesRando < baseYesChance then
                    sfx:Play(FiendFolio.Sounds.CrowdCheer,4,0,false,0.9)
                    entityPickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0, true, true, true)
                    local yesFireworks = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.FIREWORKS,0,spawnPos,Vector.Zero,entityPickup):ToEffect()
                    yesFireworks:SetTimeout(60)
                end
            end
        end    
    end
  end
  Mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, BLANK_WHITE_CARD.doBlankWhiteCardReroll, 0)
