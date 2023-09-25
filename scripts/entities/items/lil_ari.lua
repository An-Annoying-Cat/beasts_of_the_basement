local Mod = BotB
local LIL_ARI = {}
local Items = BotB.Enums.Items

if EID then
	EID:addCollectible(Isaac.GetItemIdByName("Lil Ari"), "Invisible familiar that throws rocks at enemies. #It also breaks tinted, fool's gold, and super secret rocks for you!")
end
--
--Spawn the special friendly polty
--


--function LIL_ARI:lilAriPlayerUpdate(player)
	--[[
	if not player:HasCollectible(BotB.Enums.Items.LIL_ARI) then return end
	if data.lilAriPoltyTable == nil then
		data.lilAriPoltyTable = {}
	end
	print(player:GetCollectibleNum(Items.LIL_ARI, false) .. " , " .. #data.lilAriPoltyTable)
	if #data.lilAriPoltyTable < player:GetCollectibleNum(Items.LIL_ARI, false) then
		print("added an ariral")
		data.lilAriPolty = Isaac.Spawn(EntityType.ENTITY_POLTY,0,0,Vector.Zero,Vector.Zero,player):ToNPC()
		data.lilAriPolty.MaxHitPoints = 0
		data.lilAriPolty.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		data.lilAriPolty.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
		data.lilAriPolty:AddEntityFlags(EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_PERSISTENT)
		data.lilAriPolty:GetData().isLilAri = true
		data.lilAriPoltyTable[#data.lilAriPoltyTable+1] = data.lilAriPolty
	elseif #data.lilAriPoltyTable > player:GetCollectibleNum(Items.LIL_ARI, false) then
		print("removed an ariral")
		data.lilAriPoltyTable[#data.lilAriPoltyTable]:Remove()
	end
	
	--


end
Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE,LIL_ARI.lilAriPlayerUpdate)]]

--


function LIL_ARI:NPCUpdate(npc)
	local data = npc:GetData()
	if not npc:HasEntityFlags(EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_PERSISTENT) then return end
	if not data.isLilAri == true then return end
	--print("ariral detected")
	
    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local data = npc:GetData()

    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()

	local nearbyRocks = TSIL.GridEntities.GetGridEntities()
	for i=1,#nearbyRocks do
		local gridToCheck = nearbyRocks[i]
		if npc.Position:Distance(gridToCheck.Position) <= 150 and (gridToCheck.Desc.Type == GridEntityType.GRID_ROCKT or gridToCheck.Desc.Type == GridEntityType.GRID_ROCK_SS or gridToCheck.Desc.Type == GridEntityType.GRID_ROCK_ALT2 or gridToCheck.Desc.Type == GridEntityType.GRID_ROCK_GOLD) then
			gridToCheck:Destroy(true)
		end
	end
	npc:GetSprite().Color = Color(1,0,0,0)
    local room = Game():GetRoom()
	if room:IsClear() then
		npc.Position = player.Position
		npc.Visible = false
	else
		npc.Visible = true
	end
	if npc:GetData().LilAriParent == nil then
		npc:Remove()
	end

end


Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, LIL_ARI.NPCUpdate, EntityType.ENTITY_POLTY)



function LIL_ARI:ProjUpdate(projectile)
	if projectile.SpawnerEntity == nil then return end
	if not (projectile.SpawnerEntity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_PERSISTENT) and projectile.SpawnerEntity.Type == EntityType.ENTITY_POLTY) then return end
	--print("oh shit the ariral threw something oh fuck oh shit")
	if projectile.GridCollisionClass ~= GridCollisionClass.COLLISION_NONE then
		projectile.GridCollisionClass = GridCollisionClass.COLLISION_NONE
	end

	if projectile.EntityCollisionClass ~= GridCollisionClass.COLLISION_NONE then
		projectile.GridCollisionClass = GridCollisionClass.COLLISION_NONE
	end
	projectile:AddProjectileFlags(ProjectileFlags.SMART_PERFECT | ProjectileFlags.CANT_HIT_PLAYER | ProjectileFlags.HIT_ENEMIES | ProjectileFlags.BOUNCE | ProjectileFlags.BOUNCE_FLOOR)

	

end
Mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, LIL_ARI.ProjUpdate)


------------------------------------------------------------------------------------------------



--PLUSHIE FAMILIAR 


------------------------------------------------------------------------------------------------


local Mod = BotB
local LIL_ARI_PLUSH = {}
local Familiars = BotB.Enums.Familiars
local Items = BotB.Enums.Items

function LIL_ARI_PLUSH:FamiliarUpdate(npc)

    local sprite = npc:GetSprite()
    local data = npc:GetData()
    local room = Game():GetRoom()
    local player = npc.Player


    if npc.Type == Familiars.LIL_ARI_PLUSH.TYPE and npc.Variant == Familiars.LIL_ARI_PLUSH.VARIANT then 
        --print(npc.State)

        if npc.State == 0 then
            
            npc.State = 99
            sprite:Play("Idle")
        end



        --States
        -- 99 - idle as ever
        if npc.State == 99 then
			if data.lilAriPolty == nil or data.lilAriPolty:IsDead() then
				print("spawning the polty")
				data.lilAriPolty = Isaac.Spawn(EntityType.ENTITY_POLTY,0,0,npc.Player.Position,Vector.Zero,player):ToNPC()
				data.lilAriPolty:GetSprite().Color = Color(1,0,0,1)
				data.lilAriPolty:AddEntityFlags(EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_PERSISTENT)
				data.lilAriPolty.MaxHitPoints = 0
				data.lilAriPolty.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
				data.lilAriPolty.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
				data.lilAriPolty:AddCharmed(EntityRef(npc.Player),-1)
				--data.lilAriPolty:GetSprite().Color = Color(1,0,0,0)
				data.lilAriPolty:GetData().isLilAri = true
				data.lilAriPolty:GetData().LilAriParent = npc
            end
            if not npc.IsFollower then
				npc:AddToFollowers()
			else
				npc:FollowParent()
			end  
        end

    end
end


Mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, LIL_ARI_PLUSH.FamiliarUpdate, Isaac.GetEntityVariantByName("Lil Ari (Plush)"))


--ITEM code
--Egocentrism moment

--Stats
function LIL_ARI_PLUSH:onCache(player, _)
    --local collectibleRNG = player:GetCollectibleRNG(Isaac.GetItemIdByName("Robo-Baby Zero"))
    --local itemConfig = Isaac.GetItemConfig():GetCollectible(Isaac.GetItemIdByName("Robo-Baby Zero"))
    player:CheckFamiliar(Isaac.GetEntityVariantByName("Lil Ari (Plush)"), BotB.Functions.GetExpectedFamiliarNum(player,Items.LIL_ARI), player:GetCollectibleRNG(Isaac.GetItemIdByName("Lil Ari")), Isaac.GetItemConfig():GetCollectible(Isaac.GetItemIdByName("Lil Ari")))
end
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, LIL_ARI_PLUSH.onCache,CacheFlag.CACHE_FAMILIARS)