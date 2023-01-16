local Mod = BotB
local TOY_HELICOPTER = {}
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

function TOY_HELICOPTER:charlesHeliEffect(effect)
    local room = Game():GetRoom()
    local sprite = effect:GetSprite()
    if room:IsClear() then
        effect:Remove()
    end
    if effect.FrameCount == 60 then
        
        sfx:Play(BotB.Enums.SFX.CHARLES_CUE,1,0,false,1)
    end
    if effect.FrameCount == 366 then
        sfx:Play(BotB.Enums.SFX.TOY_HELICOPTER_ATTACK,0.5,0,false,0.5)
    end
    if effect.FrameCount == 510 then
        sfx:Play(SoundEffect.SOUND_BEEP,1,0,false,1)
    end
    if effect.FrameCount == 540 then
        sfx:Play(SoundEffect.SOUND_BEEP,1,0,false,2)
    end
    if effect.FrameCount == 570 then
        sfx:Play(SoundEffect.SOUND_BEEP,1,0,false,3)
    end
    if effect.FrameCount == 600 then
        
        effect:GetSprite():Play("Effect")
        if isFunny == 1337 then
            sprite:ReplaceSpritesheet(0, "gfx/effects/charles_heli_funny.png")
            sprite:LoadGraphics()
        end
        --Isaac.Spawn(EntityType.ENTITY_EFFECT,Entities.WARNING_TARGET.VARIANT,0,effect.Parent.Position,Vector(0,0),npc)
    end
    if effect.FrameCount < 600 then
        effect.Position = effect.Parent.Position
    end
    if effect:GetSprite():IsEventTriggered("Blast") then
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.MAMA_MEGA_EXPLOSION, 0, effect.Parent.Position, Vector.Zero, effect)
        game:ShakeScreen(30)
    elseif effect:GetSprite():IsEventTriggered("Delete") then
        effect:Remove()
    end
end

Mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE,TOY_HELICOPTER.charlesHeliEffect, Isaac.GetEntityVariantByName("Charles Heli"))

function TOY_HELICOPTER:charlesHeliFunnyEffect(effect)
    local room = Game():GetRoom()
    local sprite = effect:GetSprite()
    if room:IsClear() then
        effect:Remove()
    end
    if effect.FrameCount == 60 then
        sfx:Play(BotB.Enums.SFX.CHARLES_CUE_FUNNY,1,0,false,1)
    end
    if effect.FrameCount == 366 then
        sfx:Play(BotB.Enums.SFX.TOY_HELICOPTER_ATTACK,0.5,0,false,0.5)
    end
    if effect.FrameCount == 510 then
        sfx:Play(SoundEffect.SOUND_BEEP,1,0,false,1)
    end
    if effect.FrameCount == 540 then
        sfx:Play(SoundEffect.SOUND_BEEP,1,0,false,2)
    end
    if effect.FrameCount == 570 then
        sfx:Play(SoundEffect.SOUND_BEEP,1,0,false,3)
    end
    if effect.FrameCount == 600 then 
        effect:GetSprite():Play("Effect")
        --Isaac.Spawn(EntityType.ENTITY_EFFECT,Entities.WARNING_TARGET.VARIANT,0,effect.Parent.Position,Vector(0,0),npc)
    end
    if effect.FrameCount < 600 then
        effect.Position = effect.Parent.Position
    end
    if effect:GetSprite():IsEventTriggered("Blast") then
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.MAMA_MEGA_EXPLOSION, 0, effect.Parent.Position, Vector.Zero, effect)
        sfx:Play(BotB.FF.Sounds.FunnyFart,5,0,false,0.8)
        game:ShakeScreen(30)
    elseif effect:GetSprite():IsEventTriggered("Delete") then
        effect:Remove()
    end
end

Mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE,TOY_HELICOPTER.charlesHeliFunnyEffect, Isaac.GetEntityVariantByName("Charles Heli (Funny)"))

if EID then
	EID:addCollectible(Isaac.GetItemIdByName("Toy Helicopter"), "Drops an explosive helicopter on the boss when you enter the boss room of a floor, 10 seconds after the fight begins. #Helicopter deals damage roughly equivalent to a single {{Collectible".. Isaac.GetItemIdByName("Mama Mega!") .."}} Mama Mega shockwave.")
end

function TOY_HELICOPTER.newRoomCheck()
    local room = Game():GetRoom()
    local numHelis = 0
    local numDropped = 0
    local hasDoneHeli = false
    if room:GetType() == RoomType.ROOM_BOSS then
		local doTheyActuallyHaveThem = false
		local players = getPlayers()
		for i=1,#players,1 do
			if players[i]:HasCollectible(Items.TOY_HELICOPTER) then
                numHelis = numHelis + players[i]:GetCollectibleNum(Items.TOY_HELICOPTER, false)
				doTheyActuallyHaveThem = true
			end
		end

		if doTheyActuallyHaveThem == true and hasDoneHeli == false then
			for i, entity in ipairs(Isaac.GetRoomEntities()) do
                --print(entity.Type, entity.Variant, entity.SubType)
                if entity:IsBoss() then
                    if numDropped <= numHelis then
                        local isFunny = math.random(8192)
                        if isFunny == 1337 then
                            local heliFunny = Isaac.Spawn(EntityType.ENTITY_EFFECT, BotB.Enums.Entities.CHARLESHELIFUNNY.VARIANT, 0, entity.Position, Vector.Zero, entity)
                            --effect:GetSprite():ReplaceSpritesheet(1, "gfx/charles_heli_funny.png")
                            heliFunny.Parent = entity
                        else
                            local heli = Isaac.Spawn(EntityType.ENTITY_EFFECT, BotB.Enums.Entities.CHARLESHELI.VARIANT, 0, entity.Position, Vector.Zero, entity)
                            heli.Parent = entity
                        end
                    end
                end
            end
            hasDoneHeli = true
		end
    end
end

Mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM,TOY_HELICOPTER.newRoomCheck)