local Mod = BotB
local RAISIN = {}

if EID then
	EID:addTrinket(Isaac.GetTrinketIdByName("A Single Raisin"), "Spawns a Half Immoral Heart on pickup. #Adds a chance for Red Hearts to be replaced with Immoral Hearts that scales based on player luck.")
end

function RAISIN:raisinTryReplace(pickup)
    print("dongs")
    --[[
    local player = Isaac.GetPlayer()
		if player:HasCollectible(Isaac.GetTrinketIdByName("A Single Raisin")) then
			
		end
    --]]
end

function RAISIN:playerRaisinUpdate(player)
    local data = player:GetData()
    --Initialize on data for raisin being nil
    if data.alreadyGotTheirFuckingRaisin == nil then
        data.alreadyGotTheirFuckingRaisin = false
    end
    local queueItemData = player.QueuedItem
    --Is the queued item for the player a trinket with an id matching A Single Raisin?
    if queueItemData.Item ~= nil and  queueItemData.Item:IsTrinket() and queueItemData.Item.ID == BotB.Enums.Trinkets.A_SINGLE_RAISIN then
        print("holy fucking shit they got the fucking raisin")
        if data.alreadyGotTheirFuckingRaisin == false then
            npc:PlaySound(SoundEffect.SOUND_FORESTBOSS_STOMPS,1,0,false,math.random(8,9)/10)
            print("spawn the heart you fucking idiot")
        end
    end
    
end

	

Mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, RAISIN.raisinTryReplace, PickupVariant.PICKUP_HEART)
Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, RAISIN.playerRaisinUpdate, 0)