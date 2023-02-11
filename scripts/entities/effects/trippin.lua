local Mod = BotB
local TRIPPIN = {}

--This is just for the reversed controls effect on player
--Should be able to be turned on via an aura (in the enemy code of course),
--or given by a debuff projectile. Idk what color to make it, though.

--Insert zaza jokes here

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


function TRIPPIN:playerUpdate(player)
    local seed = Game():GetSeeds()
	local data = player:GetData()
    local sprite = player:GetSprite()
	local level = Game():GetLevel()
    if data.isInBotBZazaZone == nil then
        data.isInBotBZazaZone = false
        data.BotBZazaTimer = 0
        data.shouldPlayerHaveBotBZaza = false
        data.playerHasBotBTrippingIcon = false
    end
    if data.BotBZazaTimer ~= 0 then
        data.BotBZazaTimer = data.BotBZazaTimer - 1
    end
    if data.isInBotBZazaZone == false and data.BotBZazaTimer == 0 then
        data.shouldPlayerHaveBotBZaza = false
    elseif data.isInBotBZazaZone == true then
        data.shouldPlayerHaveBotBZaza = true
    elseif data.BotBZazaTimer ~= 0 then
        data.shouldPlayerHaveBotBZaza = true
    end
    if data.shouldPlayerHaveBotBZaza then
        if seed:CanAddSeedEffect(SeedEffect.SEED_CONTROLS_REVERSED) then
            seed:AddSeedEffect(SeedEffect.SEED_CONTROLS_REVERSED)
        end
        if data.playerHasBotBTrippingIcon == false then
            local zazaIcon = Isaac.Spawn(EntityType.ENTITY_EFFECT,Isaac.GetEntityVariantByName("Reversed Controls Icon"),0,player.Position,Vector.Zero,player):ToEffect()
            zazaIcon.Parent = player
            zazaIcon.LifeSpan = 1
            data.playerHasBotBTrippingIcon = true
        end
        --player:AddConfusion(EntityRef(player), 1, true)
        sprite.Color = Color(1,1,1,1,0,-0.25,0)
    else
        seed:RemoveSeedEffect(SeedEffect.SEED_CONTROLS_REVERSED)
        sprite.Color = Color(1,1,1,1,0,0,0)
        if data.playerHasBotBTrippingIcon ~= false then
            data.playerHasBotBTrippingIcon = false
        end
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, TRIPPIN.playerUpdate, 0)


function TRIPPIN:iconEffect(effect)
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
Mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE,TRIPPIN.iconEffect, Isaac.GetEntityVariantByName("Reversed Controls Icon"))


function TRIPPIN.oncmd(_, command, args)
    if command == "trip" then
        local players = getPlayers()
		for i=1,#players,1 do
			players[i]:GetData().BotBZazaTimer = 300
		end
        print("made all players trip balls")
    end
end
Mod:AddCallback(ModCallbacks.MC_EXECUTE_CMD, TRIPPIN.oncmd)
-- executing command "Test apple 1 Pear test" prints
-- Test
-- apple 1 Pear test

