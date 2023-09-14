local Mod = BotB
local FIRE_REWORK = {}

function FIRE_REWORK:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget():ToPlayer()
    local data = npc:GetData()
    local target = npc:GetPlayerTarget()
    local room = Game():GetRoom()

    local RECOMMENDED_SHIFT_IDX = 35

    local game = Game()
    local seeds = game:GetSeeds()
    local startSeed = seeds:GetStartSeed()
    local rng = RNG()
    rng:SetSeed(startSeed, RECOMMENDED_SHIFT_IDX)

    if data.botbBurnSpreadDurationCooldown == nil then
        data.botbBurnSpreadDurationCooldown = 0
        data.botbBurnSpreadOffset = math.random(0,29)
    end
    
    if data.botbBurnSpreadDurationCooldown ~= 0 then
        --Count down frame by frame
        data.botbBurnSpreadDurationCooldown = data.botbBurnSpreadDurationCooldown - 1
    end

    if npc:HasEntityFlags(EntityFlag.FLAG_BURN) and (npc.FrameCount + data.botbBurnSpreadOffset) % 30 == 0 then 
        --Entity is burning
        --Get all entities in radius around entity (size based on enemy hitbox--bigger enemies spread more flame)
        --As a base, using half player damage as the burning damage value and a randomized duration from 1 to 5 seconds
        local botbEntitiesInBurnRadius = Isaac.FindInRadius(npc.Position, math.ceil(npc.Size*4))
        if #botbEntitiesInBurnRadius == 0 then return end
        local botbBurnSpreadLimit = 2
        local botbTimesBurned = 0
        for i=1,#botbEntitiesInBurnRadius,1 do
            if botbEntitiesInBurnRadius[i]:IsVulnerableEnemy() and not botbEntitiesInBurnRadius[i]:HasEntityFlags(EntityFlag.FLAG_BURN) and botbEntitiesInBurnRadius[i]:GetData().botbBurnSpreadDurationCooldown == 0 and botbTimesBurned < botbBurnSpreadLimit then
                --enemy is vulnerable and not burning! burn it now
                local botbBurnSpreadRandomDuration = (rng:RandomInt(4)*20)+23
                local botbBurnSpreadDamage
                if botbEntitiesInBurnRadius[i]:GetData().botbLuckyLighterBurnDamage ~= nil then
                    botbBurnSpreadDamage = botbEntitiesInBurnRadius[i]:GetData().botbLuckyLighterBurnDamage
                    print("transmitted value of " .. botbBurnSpreadDamage)
                else
                    botbBurnSpreadDamage = 2 --fallback
                end
                botbEntitiesInBurnRadius[i]:AddBurn(EntityRef(player), botbBurnSpreadRandomDuration , botbBurnSpreadDamage)
                botbEntitiesInBurnRadius[i]:GetData().botbLuckyLighterBurnDamage = (botbBurnSpreadDamage/2)
                botbEntitiesInBurnRadius[i]:GetData().botbBurnSpreadDurationCooldown = math.floor(botbBurnSpreadRandomDuration * 1.5)
                botbTimesBurned = botbTimesBurned + 1
            end
        end
        if botbTimesBurned ~= 0 then
            npc:PlaySound(SoundEffect.SOUND_CANDLE_LIGHT,1,0,false,(math.random(150,250)/100))
        end
    end
end


Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, FIRE_REWORK.NPCUpdate)
