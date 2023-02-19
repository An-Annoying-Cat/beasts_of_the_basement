local Mod = BotB
local SOLOMON_BESTIARY_UI = {}

--This is the visual effect for all of The Bestiary's special functions when playing as Solomon

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


function SOLOMON_BESTIARY_UI:playerUpdate(player)

end
Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, SOLOMON_BESTIARY_UI.playerUpdate, 0)


function SOLOMON_BESTIARY_UI:iconEffect(effect)
    local pdata = effect.Parent:GetData()
    effect.Position = effect.Parent.Position + Vector(0,-64)
    if pdata.shouldPlayerHaveBotBZaza == true then
        --print("weenor")
        effect.LifeSpan = effect.LifeSpan + 1
    else
        --print("weenis")
        pdata.playerHasBotBTrippingIcon = false
        effect:Remove()
       
    end
    
end
Mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE,SOLOMON_BESTIARY_UI.iconEffect, Isaac.GetEntityVariantByName("Reversed Controls Icon"))


function SOLOMON_BESTIARY_UI.oncmd(_, command, args)
    if command == "trip" then
        local players = getPlayers()
		for i=1,#players,1 do
			players[i]:GetData().BotBZazaTimer = 300
		end
        print("made all players trip balls")
    end
end
Mod:AddCallback(ModCallbacks.MC_EXECUTE_CMD, SOLOMON_BESTIARY_UI.oncmd)
-- executing command "Test apple 1 Pear test" prints
-- Test
-- apple 1 Pear test

