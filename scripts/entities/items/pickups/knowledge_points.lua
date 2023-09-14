local Mod = BotB
sfx = SFXManager()
game = Game()
local KP= {}
local PLAYER_SOLOMON = Isaac.GetPlayerTypeByName("Solomon")

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

function KP:onKPPickup(pickup,collider,_)
    local data = pickup:GetData()
    
    --local sprite = pickup:GetSprite()
    --print(pickup.Type .. "," .. pickup.Variant .. "," .. pickup.SubType)
    if pickup.SubType ~= nil and pickup.SubType == Mod.Enums.Pickups.KP_SMALL.SUBTYPE and collider.Type == Isaac.GetEntityTypeByName("Player") then
        local player = collider:ToPlayer()
        local pdata = player:GetData()
        sfx:Play(SoundEffect.SOUND_BISHOP_HIT,0.75,0,false,math.random(20,25)/10)
        pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        
        if player:GetPlayerType() == PLAYER_SOLOMON then
            pdata.solomonKnowledgePoints = pdata.solomonKnowledgePoints + 2
        end
        local smallPoof = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.POOF01,0,pickup.Position,Vector(0,0),pickup):ToEffect()
        smallPoof.SpriteScale = Vector(0.5,0.5)
        smallPoof:SetColor(Color(0.75,0.75,1,1), 30, 1, false, false)
        pickup:Remove()
        return false
    end
    if pickup.SubType ~= nil and pickup.SubType == Mod.Enums.Pickups.KP_LARGE.SUBTYPE and collider.Type == Isaac.GetEntityTypeByName("Player") then
        local player = collider:ToPlayer()
        local pdata = player:GetData()
        sfx:Play(SoundEffect.SOUND_BISHOP_HIT,0.75,0,false,math.random(20,25)/10)
        pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        local player = collider:ToPlayer()
        if player:GetPlayerType() == PLAYER_SOLOMON then
            pdata.solomonKnowledgePoints = pdata.solomonKnowledgePoints + 4
        end
        local bigPoof = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.POOF01,0,pickup.Position,Vector(0,0),pickup)
        bigPoof.SpriteScale = Vector(0.75,0.75)
        bigPoof:SetColor(Color(0.75,0.75,1,1), 30, 1, false, false)
        pickup:Remove()
        return false
    end
end

Mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION,KP.onKPPickup,PickupVariant.PICKUP_GRAB_BAG)


function KP:KPUpdate(pickup)
    local sprite = pickup:GetSprite()
    --print(pickup:GetCoinValue())
    if pickup.SubType ~= nil and (pickup.SubType == Mod.Enums.Pickups.KP_SMALL.SUBTYPE or pickup.SubType == Mod.Enums.Pickups.KP_LARGE.SUBTYPE) then

        if sprite:GetAnimation() ~= "Idle" then
            sprite:Play("Idle")
        end
        if pickup.EntityCollisionClass ~= EntityCollisionClass.ENTCOLL_ALL then
            pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        end
        if pickup.SubType ~= nil and (pickup.SubType == Mod.Enums.Pickups.KP_SMALL.SUBTYPE) then
            if pickup.SpriteScale ~= Vector(0.75,0.75) then
                pickup.SpriteScale = Vector(0.75,0.75)
            end
        end
    end

end
Mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE,KP.KPUpdate,PickupVariant.PICKUP_GRAB_BAG)
