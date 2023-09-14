local Mod = BotB
local IDOL_OF_MOLECH = {}

if EID then
	EID:addTrinket(BotB.Enums.Trinkets.IDOL_OF_MOLECH, "Enemies make bursts of flame upon death, burning nearby enemies for 4 seconds, and for double your base damage. #Golden trinkets and Mom's Box cause the explosions to be larger in size and the fire to be more damaging.")
end

function IDOL_OF_MOLECH:GetPlayers()
	local players = {}

	for i = 1, game:GetNumPlayers() do
		table.insert(players, game:GetPlayer(i))
	end

	return players
end

function IDOL_OF_MOLECH:flameKaboom(entity)
    --if not entity:IsVulnerableEnemy() then return end
    if entity:GetData().botbGotMolechBurnedAlready then return end
    local blastpos = entity.Position
    local pickupdata = entity:GetData()
    local sprite = entity:GetSprite()
    --print(pickup.Type .. "," .. pickup.Variant .. "," .. pickup.SubType)

    local botbMolechIdolMultiplier = 0
    local botbMolechIdolDamageSum = 0
    local doTheyActuallyHaveThem = false
		local players = IDOL_OF_MOLECH:GetPlayers()
		for i=1,#players,1 do
			if players[i]:ToPlayer():HasTrinket(BotB.Enums.Trinkets.IDOL_OF_MOLECH, true) then
                botbMolechIdolMultiplier = botbMolechIdolMultiplier + players[i]:GetTrinketMultiplier(BotB.Enums.Trinkets.IDOL_OF_MOLECH)
                botbMolechIdolDamageSum = botbMolechIdolDamageSum + 2*(players[i].Damage)*players[i]:GetTrinketMultiplier(BotB.Enums.Trinkets.IDOL_OF_MOLECH)
				doTheyActuallyHaveThem = true
			end
		end
    if not doTheyActuallyHaveThem then return end
        if doTheyActuallyHaveThem then
            
            --Entity is burning
        --Get all entities in radius around entity (size based on enemy hitbox--bigger enemies spread more flame)
        --As a base, using half player damage as the burning damage value and a randomized duration from 1 to 5 seconds
        local botbEntitiesInBurnRadius = Isaac.FindInRadius(blastpos, math.ceil(entity.Size*4)*botbMolechIdolMultiplier)
        if #botbEntitiesInBurnRadius == 0 then return end
        local botbBurnSpreadLimit = 4
        local botbTimesBurned = 0
        for i=1,#botbEntitiesInBurnRadius,1 do
            if botbEntitiesInBurnRadius[i]:IsVulnerableEnemy() and not botbEntitiesInBurnRadius[i]:HasEntityFlags(EntityFlag.FLAG_BURN) and botbEntitiesInBurnRadius[i]:GetData().botbBurnSpreadDurationCooldown == 0 and botbTimesBurned < botbBurnSpreadLimit and botbEntitiesInBurnRadius[i]:GetData().botbGotMolechBurnedAlready ~= true then
                --enemy is vulnerable and not burning! burn it now
                local botbBurnSpreadRandomDuration = 480
                if botbEntitiesInBurnRadius[i]:GetData().botbGotMolechBurnedAlready == nil then
                    botbEntitiesInBurnRadius[i]:GetData().botbGotMolechBurnedAlready = true
                end
                botbEntitiesInBurnRadius[i]:AddBurn(EntityRef(entity), botbBurnSpreadRandomDuration , botbMolechIdolDamageSum)
                botbEntitiesInBurnRadius[i]:GetData().botbLuckyLighterBurnDamage = (botbMolechIdolDamageSum/2)
                botbEntitiesInBurnRadius[i]:GetData().botbBurnSpreadDurationCooldown = math.floor(botbBurnSpreadRandomDuration * 1.5)
                botbTimesBurned = botbTimesBurned + 1
            end
        end
        SFXManager():Play(SoundEffect.SOUND_FIRE_RUSH,4,0,false,0.75)
        --local molechBlastPoof = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.POOF01,0,blastpos,Vector.Zero,entity):ToEffect()
        local molechBlastFart = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.POOF01,0,blastpos,Vector.Zero,entity):ToEffect()
        molechBlastFart.Color = Color(1,0.5,0)
        for i=0,12*botbMolechIdolMultiplier, 1 do
            local molechBlastEmber = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.EMBER_PARTICLE,0,blastpos,Vector(math.random(3,10),0):Rotated(math.random(0,359)),entity):ToEffect()
            molechBlastEmber:SetTimeout(math.random(30,150))
        end
        for i=0,24*botbMolechIdolMultiplier, 1 do
            local molechBlastSmoke = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.DARK_BALL_SMOKE_PARTICLE,0,blastpos,Vector(math.random(1,5),0):Rotated(math.random(0,359)),entity):ToEffect()
            molechBlastSmoke:SetTimeout(math.random(30,150))
        end

        end
		
end

Mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL,IDOL_OF_MOLECH.flameKaboom)


