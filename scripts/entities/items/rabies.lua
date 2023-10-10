local Mod = BotB
local RABIES = {}
local Entities = BotB.Enums.Entities
local Items = BotB.Enums.Items


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


if EID then
	EID:addCollectible(Isaac.GetItemIdByName("Rabies"), "Your tears have a chance to apply {{StatusDisease}} Disease on hit. #{{StatusDisease}} Disease deals damage in one large hit when it runs out, which increases in strength with the amount of times it is stacked. #On enemy death, Disease spreads to nearby enemies. #If the damage from Disease running out would kill an enemy, it triggers immediately.")
end



function RABIES:rabiesFireTear(tear)
    ----print("tear!")
    if tear.SpawnerEntity.Type == EntityType.ENTITY_PLAYER then
        local tearPlayer = tear.SpawnerEntity:ToPlayer()
        tear:GetData().techNanoPlayerParent = tearPlayer
        ----print("player tear!")
        if tearPlayer:HasCollectible(Items.RABIES) then
            ----print("player with tech nano tear!")
            local tearPlayerRNG = tearPlayer:GetCollectibleRNG(Items.RABIES)
            local luckThreshold = 0.25 + (tearPlayer.Luck/24)
            if luckThreshold <= 0 then
                luckThreshold = 0.25
            end
            local techNanoRand = tearPlayerRNG:RandomFloat()
            --luckThreshold = 999
            ----print(techNanoRand .. " , " .. luckThreshold)
            if techNanoRand <= luckThreshold then
                tear:GetData().isARabiesTear = true
            end
        end
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR,RABIES.rabiesFireTear)

function RABIES:rabiesTearUpdate(tear)
    if tear:GetData().isARabiesTear then
        local data = tear:GetData()
        if tear:HasTearFlags(TearFlags.TEAR_HOMING) ~= true then
            tear:AddTearFlags(TearFlags.TEAR_HOMING)
        end
        if tear:HasTearFlags(TearFlags.TEAR_PIERCING) then
            tear:ClearTearFlags(TearFlags.TEAR_PIERCING)
        end
        if tear:GetData().hasRabiesAdjustments ~= true then
            tear.FallingAcceleration = -0.05
            tear.Color = Color(1,1,0.25)
            --tear.HomingFriction = 0.5
            tear:GetData().hasRabiesAdjustments = true
        end
        local correctPos = tear.Position
        if tear:IsDead() then
            --rabies
        end
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE,RABIES.rabiesTearUpdate)




function RABIES:rabiesTearCollision(tear,_,_)
    if tear:GetData().isARabiesTear then
        if tear.Parent:ToPlayer() ~= nil and tear.Parent:ToPlayer():HasWeaponType(WeaponType.WEAPON_FETUS) then return end
        local correctPos = tear.Position
        --rabies
    end
end
Mod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION,RABIES.rabiesTearCollision)

function RABIES:rabiesLaserUpdate(laser)
    --print(laser.Parent.Type,laser.SpawnerEntity.Type)
    if laser.Parent:ToPlayer() ~= nil and laser.Parent:ToPlayer():HasCollectible(Items.RABIES) then
        laser.Color = Color(1,1,1,1,0.5,1,0)
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE,RABIES.rabiesLaserUpdate)


--now to give it a synergy with dr fetus and epic fetus...
function RABIES:rabiesBombUpdate(bomb)
    ----print(bomb.FrameCount)
    if bomb.FrameCount ~= 1 then return end
    if bomb.IsFetus ~= true then return end
    if bomb.Parent:ToPlayer() ~= nil then
        local player = bomb.Parent:ToPlayer()
        if not player:HasCollectible(Items.RABIES) then return end
        local tearPlayerRNG = player:GetCollectibleRNG(Items.RABIES)
        local luckThreshold = 0.25 + (player.Luck/24)
        if luckThreshold <= 0 then
            luckThreshold = 0.25
        end
        local techNanoRand = tearPlayerRNG:RandomFloat()
        if techNanoRand <= luckThreshold then
            --tech nano time!
            --bomb:AddTearFlags(TearFlags.TEAR_HOMING)
            bomb:GetData().isRabiesFetusBomb = true
            bomb:GetData().rabiesFetusBombPlayer = player
        end
    end

end
Mod:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE,RABIES.rabiesBombUpdate)
--[[
function RABIES:rabiesBombUpdate2(bomb)
    --print(bomb.FrameCount)
    if bomb.FrameCount ~= 1 then return end
    if bomb.IsFetus ~= true then return end
    if bomb.Parent:ToPlayer() ~= nil then
        local player = bomb.Parent:ToPlayer()
        if not player:HasCollectible(Items.RABIES) then return end
        local tearPlayerRNG = player:GetCollectibleRNG(Items.RABIES)
        local luckThreshold = 0.125 + (player.Luck/24)
        if luckThreshold <= 0 then
            luckThreshold = 0.125
        end
        local techNanoRand = tearPlayerRNG:RandomFloat()
        if techNanoRand <= luckThreshold then
            --tech nano time!
            bomb:GetData().isRabiesFetusBomb = true
        end
    end

end
Mod:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE,RABIES.rabiesBombUpdate2)]]



function RABIES:rabiesBombCheck(bomb) 
    ----print(entity.Type, entity.Variant, entity.SubType)
    if bomb.Type ~= 4 then 
        --epic fetus checking
        if bomb.Type == EntityType.ENTITY_EFFECT and bomb.Variant == EffectVariant.ROCKET then
            if bomb.SpawnerEntity ~= nil and bomb.SpawnerEntity:ToPlayer() ~= nil then
                local player = bomb.SpawnerEntity:ToPlayer()
                if not player:HasCollectible(Items.RABIES) then return end
                --rabies
                bomb:GetData().rabiesFartVisual = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.POOF02,1,bomb.Position,Vector.Zero,bomb):ToEffect()
                bomb:GetData().rabiesFartVisual.Color = Color(1.75,1.5,1,1)
                bomb:GetData().rabiesFartVisual.Scale = 0.5
                local roomEntities = Isaac.GetRoomEntities()
                for i = 1, #roomEntities do
                    local entity = roomEntities[i]
                    if (entity.Position - bomb.Position):Length() <= 150 then
                        if entity:IsVulnerableEnemy() and EntityRef(entity).IsFriendly == false then
                            local edata = entity:GetData()
                            if edata.botbHasDisease ~= true then
                                edata.botbDiseaseBaseColor = entity.Color
                                edata.botbHasDisease = true
                                edata.botbDiseaseDuration = 75
                                edata.botbDiseaseStacks = 1
                                edata.botbDiseaseSourcePlayer = player:ToPlayer()
                                SFXManager():Play(BotB.Enums.SFX.DISEASE_STACK,1,0, false, 1 + (0.1 * edata.botbDiseaseStacks), 0)
                                
                            else
                                edata.botbDiseaseDuration = 75
                                edata.botbDiseaseStacks = edata.botbDiseaseStacks + 1
                                local str = "" .. edata.botbDiseaseStacks
                                local AbacusFont = Font()
                                AbacusFont:Load("font/pftempestasevencondensed.fnt")
                                for i = 1, 40 do
                                    BotB.FF.scheduleForUpdate(function()
                                        local pos = game:GetRoom():WorldToScreenPosition(entity.Position) + Vector(AbacusFont:GetStringWidth(str) * -0.5, -(entity.SpriteScale.Y * 35) - 2*i)
                                        local opacity
                                        if i >= 20 then
                                            opacity = 1 - ((i-20)/20)
                                        else
                                            opacity = i/10
                                        end
                                        AbacusFont:DrawString(str .. "!", pos.X, pos.Y, KColor(1,1,0,opacity), 0, false)
                                    end, i, ModCallbacks.MC_POST_RENDER)
                                end
                                SFXManager():Play(BotB.Enums.SFX.DISEASE_STACK,1,0, false, 1 + (0.1 * edata.botbDiseaseStacks), 0)
                            end
                        end
                    end
                end


            end
        end
    else
        if bomb:GetData().isRabiesFetusBomb ~= true then return end
        local player = bomb:GetData().rabiesFetusBombPlayer:ToPlayer()
        --rabies
        bomb:GetData().rabiesFartVisual = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.POOF02,1,bomb.Position,Vector.Zero,bomb):ToEffect()
        bomb:GetData().rabiesFartVisual.Color = Color(1.75,1.5,1,1)
        bomb:GetData().rabiesFartVisual.Scale = 0.5
        local roomEntities = Isaac.GetRoomEntities()
        for i = 1, #roomEntities do
            local entity = roomEntities[i]
            if (entity.Position - bomb.Position):Length() <= 150 then
                if entity:IsVulnerableEnemy() and EntityRef(entity).IsFriendly == false then
                    local edata = entity:GetData()
                    if edata.botbHasDisease ~= true then
                        edata.botbDiseaseBaseColor = entity.Color
                        edata.botbHasDisease = true
                        edata.botbDiseaseDuration = 75
                        edata.botbDiseaseStacks = 1
                        edata.botbDiseaseSourcePlayer = bomb:GetData().rabiesFetusBombPlayer:ToPlayer()
                        SFXManager():Play(BotB.Enums.SFX.DISEASE_STACK,1,0, false, 1 + (0.1 * edata.botbDiseaseStacks), 0)
                        
                    else
                        edata.botbDiseaseDuration = 75
                        edata.botbDiseaseStacks = edata.botbDiseaseStacks + 1
                        local str = "" .. edata.botbDiseaseStacks
                        local AbacusFont = Font()
                        AbacusFont:Load("font/pftempestasevencondensed.fnt")
                        for i = 1, 40 do
                            BotB.FF.scheduleForUpdate(function()
                                local pos = game:GetRoom():WorldToScreenPosition(entity.Position) + Vector(AbacusFont:GetStringWidth(str) * -0.5, -(entity.SpriteScale.Y * 35) - 2*i)
                                local opacity
                                if i >= 20 then
                                    opacity = 1 - ((i-20)/20)
                                else
                                    opacity = i/10
                                end
                                AbacusFont:DrawString(str .. "!", pos.X, pos.Y, KColor(1,1,0,opacity), 0, false)
                            end, i, ModCallbacks.MC_POST_RENDER)
                        end
                        SFXManager():Play(BotB.Enums.SFX.DISEASE_STACK,1,0, false, 1 + (0.1 * edata.botbDiseaseStacks), 0)
                    end
                end
            end
        end
    end
    
end
Mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, RABIES.rabiesBombCheck)


function RABIES:rabiesDamageNull(entity,amt,flags,source,_)
    local src = source.Entity
    --is it not friendly and not a player
    ----print("dicks")
    ----print(source.Type)
    ----print(flags & DamageFlag.DAMAGE_TIMER)
    --local sdata = source.Entity:GetData()

    --mom's knife, ludo, dr. fetus have parent
    --technology, brimstone is direct to player
    --epic fetus and also ludo for some reason use spawner
    --spirit sword is direct to player
    --c section is parent and spawner
    --fetus whip is nil source for some reason?
    if src ~= nil and src:GetData().isATechNanoLaser == false then
        ----print(src.Type, src.Variant, src.SubType)
        local player
        if src:ToPlayer() ~= nil then
            player = src:ToPlayer()
        elseif src.Parent:ToPlayer() ~= nil then
            player = src.Parent:ToPlayer()
        elseif src.SpawnerEntity:ToPlayer() ~= nil then
            player = src.SpawnerEntity:ToPlayer()
        end
        --only if player is not using tears
        if player ~= nil then
            if not player:HasCollectible(Items.RABIES) then return end
            if player:HasWeaponType(WeaponType.WEAPON_TEARS) then return end
            if player:HasWeaponType(WeaponType.WEAPON_FETUS) then return end
            
            --use the same luck formula
            local tearPlayerRNG = player:GetCollectibleRNG(Items.RABIES)
            local luckThreshold = 0.25 + (player.Luck/24)
            if luckThreshold <= 0 then
                luckThreshold = 0.25
            end
            local techNanoRand = tearPlayerRNG:RandomFloat()
            if techNanoRand <= luckThreshold then
                --rabies
                local data = entity:GetData()
                if data.botbHasDisease ~= true then
                    data.botbDiseaseBaseColor = entity.Color
                    data.botbHasDisease = true
                    data.botbDiseaseDuration = 75
                    data.botbDiseaseStacks = 1
                    data.botbDiseaseSourcePlayer = player:ToPlayer()
                    SFXManager():Play(BotB.Enums.SFX.DISEASE_STACK,1,0, false, 1 + (0.1 * data.botbDiseaseStacks), 0)
                else
                    data.botbDiseaseDuration = 75
                    data.botbDiseaseStacks = data.botbDiseaseStacks + 1
                    local str = "" .. data.botbDiseaseStacks
                    local AbacusFont = Font()
                    AbacusFont:Load("font/pftempestasevencondensed.fnt")
                    for i = 1, 40 do
                        BotB.FF.scheduleForUpdate(function()
                            local pos = game:GetRoom():WorldToScreenPosition(entity.Position) + Vector(AbacusFont:GetStringWidth(str) * -0.5, -(entity.SpriteScale.Y * 35) - 2*i)
                            local opacity
                            if i >= 20 then
                                opacity = 1 - ((i-20)/20)
                            else
                                opacity = i/10
                            end
                            AbacusFont:DrawString(str .. "!", pos.X, pos.Y, KColor(1,1,0,opacity), 0, false)
                        end, i, ModCallbacks.MC_POST_RENDER)
                    end
                    SFXManager():Play(BotB.Enums.SFX.DISEASE_STACK,1,0, false, 1 + (0.1 * data.botbDiseaseStacks), 0)
                end

            end
        end
    end
    
    if src ~= nil then
        if source.Entity ~= nil and source.Type == EntityType.ENTITY_LASER and src:GetData().isATechNanoLaser then
            if EntityRef(entity).IsFriendly or entity.Type == EntityType.ENTITY_PLAYER or entity.Type == EntityType.ENTITY_FAMILIAR then
                return false
            end
        end
    end
    
    
        
end
Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, RABIES.rabiesDamageNull)


function RABIES:rabiesAddStatus(entity,amt,flags,source,_)
    local src = source.Entity
    --is it not friendly and not a player
    ----print("dicks")
    ----print(source.Type)
    ----print(flags & DamageFlag.DAMAGE_TIMER)
    --local sdata = source.Entity:GetData()

    --mom's knife, ludo, dr. fetus have parent
    --technology, brimstone is direct to player
    --epic fetus and also ludo for some reason use spawner
    --spirit sword is direct to player
    --c section is parent and spawner
    --fetus whip is nil source for some reason?
    if src ~= nil and src:GetData().isARabiesTear == true then
        ----print(src.Type, src.Variant, src.SubType)
        local player
        if src:ToPlayer() ~= nil then
            player = src:ToPlayer()
        elseif src.Parent:ToPlayer() ~= nil then
            player = src.Parent:ToPlayer()
        elseif src.SpawnerEntity:ToPlayer() ~= nil then
            player = src.SpawnerEntity:ToPlayer()
        end


        local data = entity:GetData()
        if data.botbHasDisease ~= true then
            data.botbDiseaseBaseColor = entity.Color
            data.botbHasDisease = true
            data.botbDiseaseDuration = 75
            data.botbDiseaseStacks = 1
            data.botbDiseaseSourcePlayer = player:ToPlayer()
            SFXManager():Play(BotB.Enums.SFX.DISEASE_STACK,1,0, false, 1 + (0.1 * data.botbDiseaseStacks), 0)
        else
            data.botbDiseaseDuration = 75
            data.botbDiseaseStacks = data.botbDiseaseStacks + 1
            local str = "" .. data.botbDiseaseStacks
            local AbacusFont = Font()
            AbacusFont:Load("font/pftempestasevencondensed.fnt")
            for i = 1, 40 do
                BotB.FF.scheduleForUpdate(function()
                    local pos = game:GetRoom():WorldToScreenPosition(entity.Position) + Vector(AbacusFont:GetStringWidth(str) * -0.5, -(entity.SpriteScale.Y * 35) - 2*i)
                    local opacity
                    if i >= 20 then
                        opacity = 1 - ((i-20)/20)
                    else
                        opacity = i/10
                    end
                    AbacusFont:DrawString(str .. "!", pos.X, pos.Y, KColor(1,1,0,opacity), 0, false)
                end, i, ModCallbacks.MC_POST_RENDER)
            end
            SFXManager():Play(BotB.Enums.SFX.DISEASE_STACK,1,0, false, 1 + (0.1 * data.botbDiseaseStacks), 0)
        end
    end
        
end
Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, RABIES.rabiesAddStatus)






function RABIES:rabiesNPCUpdate(npc)
    local data = npc:GetData()
    if data.botbHasDisease == true then
        if data.botbDiseaseIndicator == nil or data.botbDiseaseIndicator:IsDead() then
            data.botbDiseaseIndicator = Isaac.Spawn(Entities.BOTB_STATUS_EFFECT.TYPE,Entities.BOTB_STATUS_EFFECT.VARIANT,0,npc.Position,Vector.Zero, npc):ToEffect()
            data.botbDiseaseIndicator.Parent = npc
            --data.botbDiseaseIndicator.ParentOffset = Vector(0,-(npc.SpriteScale.Y * 70))
            data.botbDiseaseIndicator:GetSprite():Play("Rabies", true)
        end
        if data.botbDiseaseDuration ~= 0 then
            local color = npc.Color
            local lerpValue = (data.botbDiseaseDuration/75)
            npc.Color = Color.Lerp(Color(1,1,1,1,0.5,0.5,0),Color(1,1,1), lerpValue)
            ----print(data.botbDiseaseDuration, data.botbDiseaseStacks)
            data.botbDiseaseDuration = data.botbDiseaseDuration - 1
            
        else 
            ----print((data.botbDiseaseStacks) .. "'s worth of damage")
            npc.Color = data.botbDiseaseBaseColor
            Game():ShakeScreen(data.botbDiseaseStacks)
            npc:TakeDamage((data.botbDiseaseSourcePlayer.Damage)*(1.5 ^ data.botbDiseaseStacks), DamageFlag.DAMAGE_IGNORE_ARMOR, EntityRef(data.botbDiseaseSourcePlayer), 0)
            local str = "" .. data.botbDiseaseStacks
            local AbacusFont = Font()
            AbacusFont:Load("font/terminus.fnt")
            for i = 1, 40 do
                BotB.FF.scheduleForUpdate(function()
                    local pos = game:GetRoom():WorldToScreenPosition(npc.Position) + Vector(AbacusFont:GetStringWidth(str) * -0.5, -(npc.SpriteScale.Y * 35) - 2*i)
                    local opacity
                    if i >= 20 then
                        opacity = 1 - ((i-20)/20)
                    else
                        opacity = i/10
                    end
                    AbacusFont:DrawString(str .. "!", pos.X, pos.Y, KColor(1,1,0,opacity), 0, false)
                end, i, ModCallbacks.MC_POST_RENDER)
            end
            SFXManager():Stop(BotB.Enums.SFX.DISEASE_STACK)
            SFXManager():Play(SoundEffect.SOUND_HAND_LASERS,0.5,0, false, 3, 0)
            SFXManager():Play(BotB.Enums.SFX.DISEASE_PROC,8,0, false, 1, 0)
            data.botbHasDisease = false
            data.botbDiseaseStacks = 1
        end

        if npc.HitPoints - ((data.botbDiseaseSourcePlayer.Damage)*(1.5 ^ data.botbDiseaseStacks)) <= 0 then
            
            SFXManager():Play(SoundEffect.SOUND_HAND_LASERS,0.5,0, false, 3, 0)
        SFXManager():Play(BotB.Enums.SFX.DISEASE_PROC,8,0, false, 1, 0)
        SFXManager():Stop(BotB.Enums.SFX.DISEASE_STACK)
        data.botbHasDisease = false
        --data.botbDiseaseStacks = 1
                npc.Color = data.botbDiseaseBaseColor
        Game():ShakeScreen(data.botbDiseaseStacks)
        npc:TakeDamage((data.botbDiseaseSourcePlayer.Damage)*(1.5 ^ data.botbDiseaseStacks), DamageFlag.DAMAGE_IGNORE_ARMOR, EntityRef(data.botbDiseaseSourcePlayer), 0)
        local str = "" .. data.botbDiseaseStacks
        local AbacusFont = Font()
        AbacusFont:Load("font/terminus.fnt")
        for i = 1, 40 do
            BotB.FF.scheduleForUpdate(function()
                local pos = game:GetRoom():WorldToScreenPosition(npc.Position) + Vector(AbacusFont:GetStringWidth(str) * -0.5, -(npc.SpriteScale.Y * 35) - 2*i)
                local opacity
                if i >= 20 then
                    opacity = 1 - ((i-20)/20)
                else
                    opacity = i/10
                end
                AbacusFont:DrawString(str .. "!", pos.X, pos.Y, KColor(1,1,0,opacity), 0, false)
            end, i, ModCallbacks.MC_POST_RENDER)
        end

        
        end

        if npc:HasMortalDamage() then
            if data.rabiesFartVisual == nil then
                data.rabiesFartVisual = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.POOF02,1,npc.Position,Vector.Zero,npc):ToEffect()
                data.rabiesFartVisual.Color = Color(1.75,1.5,1,1)
                data.rabiesFartVisual.Scale = 0.5
            end
            local roomEntities = Isaac.GetRoomEntities()
            for i = 1, #roomEntities do
                local entity = roomEntities[i]
                if (entity.Position - npc.Position):Length() <= 40 * data.botbDiseaseStacks then
                    if entity:IsVulnerableEnemy() and EntityRef(entity).IsFriendly == false then
                        local edata = entity:GetData()
                        if edata.botbHasDisease ~= true then
                            edata.botbDiseaseBaseColor = entity.Color
                            edata.botbHasDisease = true
                            edata.botbDiseaseDuration = 75
                            edata.botbDiseaseStacks = 1
                            edata.botbDiseaseSourcePlayer = data.botbDiseaseSourcePlayer:ToPlayer()
                            SFXManager():Play(BotB.Enums.SFX.DISEASE_STACK,1,0, false, 1 + (0.1 * edata.botbDiseaseStacks), 0)
                            
                        else
                            --[[
                            edata.botbDiseaseDuration = 75
                            edata.botbDiseaseStacks = edata.botbDiseaseStacks + 1
                            local str = "" .. edata.botbDiseaseStacks
                            local AbacusFont = Font()
                            AbacusFont:Load("font/pftempestasevencondensed.fnt")
                            for i = 1, 40 do
                                BotB.FF.scheduleForUpdate(function()
                                    local pos = game:GetRoom():WorldToScreenPosition(entity.Position) + Vector(AbacusFont:GetStringWidth(str) * -0.5, -(entity.SpriteScale.Y * 35) - 2*i)
                                    local opacity
                                    if i >= 20 then
                                        opacity = 1 - ((i-20)/20)
                                    else
                                        opacity = i/10
                                    end
                                    AbacusFont:DrawString(str .. "!", pos.X, pos.Y, KColor(1,1,0,opacity), 0, false)
                                end, i, ModCallbacks.MC_POST_RENDER)
                            end
                            SFXManager():Play(BotB.Enums.SFX.DISEASE_STACK,1,0, false, 1 + (0.1 * edata.botbDiseaseStacks), 0)]]
                        end
                    end
                end
            end
        end

    end
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, RABIES.rabiesNPCUpdate)


function RABIES:rabiesEffectUpdate(npc)
    local data = npc:GetData()
    local sprite = npc:GetSprite()
    if npc.Parent ~= nil then
        if sprite:IsPlaying("Rabies") then
            if npc.Parent:GetData().botbDiseaseDuration ~= nil and npc.Parent:GetData().botbDiseaseDuration ~= 0 then
                npc.Position = Vector(npc.Parent.Position.X, npc.Parent.Position.Y-(npc.SpriteScale.Y * 70))
            else
                npc:Remove()
            end
        end
    else
        npc:Remove()
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, RABIES.rabiesEffectUpdate, Entities.BOTB_STATUS_EFFECT.VARIANT)