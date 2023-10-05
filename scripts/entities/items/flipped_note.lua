local Mod = BotB
local FLIPPED_NOTE = {}
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
	EID:addCollectible(Isaac.GetItemIdByName("Flipped Note"), "Your tears gain piercing, and instead of traveling smoothly, teleport from place to place along the path the tear would have normally taken. #When changing their location, they deal their damage in a small radius around them.")
end
--Egocentrism moment

--Stats


--Shotgun of tears



function FLIPPED_NOTE:onTear(tear)
	
	if not tear.Parent:ToPlayer():HasCollectible(Items.FLIPPED_NOTE) then  return end
	--[[
	if tear.FrameCount == 8 then
		print("do it")
		local flippedNoteFollowerTear = Isaac.Spawn(2,0,0,tear.Parent:ToPlayer().Position,Vector.Zero,player):ToTear()

	end]]

	local data = tear:GetData()
	if data.isFlippedNoteBaseTear == nil and data.dontSetMeAsAFlippedNoteTear ~= true then
		data.isFlippedNoteBaseTear = true
		if tear.TearFlags & TearFlags.TEAR_HYDROBOUNCE == TearFlags.TEAR_HYDROBOUNCE then
			tear:ClearTearFlags(TearFlags.TEAR_BURSTSPLIT)
			data.flippedNoteDoRipples = true
		end
		data.inheritedTearFlags = tear.TearFlags
		--tear.TearFlags = TearFlags.TEAR_NORMAL
		if tear.TearFlags & TearFlags.TEAR_EXPLOSIVE == TearFlags.TEAR_EXPLOSIVE then
			tear:ClearTearFlags(TearFlags.TEAR_EXPLOSIVE)
		end
		if tear.TearFlags & TearFlags.TEAR_EXPLOSIVE == TearFlags.TEAR_EXPLOSIVE then
			tear:ClearTearFlags(TearFlags.TEAR_EXPLOSIVE)
		end
		if tear.TearFlags & TearFlags.TEAR_ABSORB == TearFlags.TEAR_ABSORB then
			tear:ClearTearFlags(TearFlags.TEAR_ABSORB)
		end
		if tear.TearFlags & TearFlags.TEAR_QUADSPLIT == TearFlags.TEAR_QUADSPLIT then
			tear:ClearTearFlags(TearFlags.TEAR_QUADSPLIT)
		end
		if tear.TearFlags & TearFlags.TEAR_BURSTSPLIT == TearFlags.TEAR_BURSTSPLIT then
			tear:ClearTearFlags(TearFlags.TEAR_BURSTSPLIT)
		end
		
		if tear.TearFlags & TearFlags.TEAR_ORBIT == TearFlags.TEAR_ORBIT then
			tear.FallingSpeed = 0
			tear.FallingAcceleration = -0.08
		end
		if tear.TearFlags & TearFlags.TEAR_ORBIT_ADVANCED == TearFlags.TEAR_ORBIT_ADVANCED then
			tear.FallingSpeed = 0
			tear.FallingAcceleration = -0.5
		end
		data.inheritedTearColor = tear.Color
		tear.Color = Color(1,1,1,0)
		tear.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
		--SFXManager():Stop(SoundEffect.SOUND_TEARS_FIRE)

		local flippedNoteFollowerTear = Isaac.Spawn(2,0,0,tear.Position,Vector.Zero,player):ToTear()
			
			flippedNoteFollowerTear:GetData().flippedNoteFollowerTarget = tear
			flippedNoteFollowerTear:ChangeVariant(tear.Variant)
			flippedNoteFollowerTear.CollisionDamage = tear.CollisionDamage
			flippedNoteFollowerTear.Scale = tear.Scale
			flippedNoteFollowerTear.TearFlags = tear:GetData().inheritedTearFlags | TearFlags.TEAR_PIERCING
			flippedNoteFollowerTear:GetData().dontSetMeAsAFlippedNoteTear = true
			flippedNoteFollowerTear.Parent = tear.Parent
			flippedNoteFollowerTear.Color = tear:GetData().inheritedTearColor
			flippedNoteFollowerTear.Rotation = tear.Rotation

			for key, value in pairs(tear:GetData()) do
				flippedNoteFollowerTear:GetData()[key] = value
			end
			flippedNoteFollowerTear:GetData().isFlippedNoteBaseTear = false

			if flippedNoteFollowerTear.TearFlags & TearFlags.TEAR_ORBIT == TearFlags.TEAR_ORBIT then
				flippedNoteFollowerTear.FallingSpeed = 0
				flippedNoteFollowerTear.FallingAcceleration = -0.08
			end

			if flippedNoteFollowerTear.TearFlags & TearFlags.TEAR_ORBIT_ADVANCED == TearFlags.TEAR_ORBIT_ADVANCED then
				flippedNoteFollowerTear.FallingSpeed = 0
				flippedNoteFollowerTear.FallingAcceleration = -0.5
			end

			if flippedNoteFollowerTear.TearFlags & TearFlags.TEAR_TRACTOR_BEAM == TearFlags.TEAR_TRACTOR_BEAM then
				flippedNoteFollowerTear:ClearTearFlags(TearFlags.TEAR_TRACTOR_BEAM)
			end

			tear.Visible = false
	end
	--print("lmao flipnote")

	--tear:ToTear():Remove()
end
Mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, FLIPPED_NOTE.onTear)



function FLIPPED_NOTE:onUpdTear(tear)
	
	if tear.Parent == nil then return end
	if tear.Parent:ToPlayer() == nil then return end
	if not tear.Parent:ToPlayer():HasCollectible(Items.FLIPPED_NOTE) then  return end
	if tear:GetData().isFlippedNoteBaseTear == true then
		local player = tear.Parent:ToPlayer()
		--[[
		if tear.FrameCount == 1 then
			--print("do it")
			local flippedNoteFollowerTear = Isaac.Spawn(2,0,0,tear.Position,Vector.Zero,player):ToTear()
			
			flippedNoteFollowerTear:GetData().flippedNoteFollowerTarget = tear
			flippedNoteFollowerTear:ChangeVariant(tear.Variant)
			flippedNoteFollowerTear.CollisionDamage = tear.CollisionDamage
			flippedNoteFollowerTear.Scale = tear.Scale
			flippedNoteFollowerTear.TearFlags = tear:GetData().inheritedTearFlags | TearFlags.TEAR_PIERCING
			flippedNoteFollowerTear:GetData().dontSetMeAsAFlippedNoteTear = true
			flippedNoteFollowerTear.Parent = tear.Parent
			flippedNoteFollowerTear.Color = tear:GetData().inheritedTearColor

			for key, value in pairs(tear:GetData()) do
				flippedNoteFollowerTear:GetData()[key] = value
			end
			flippedNoteFollowerTear:GetData().isFlippedNoteBaseTear = false
			tear.Visible = false
		end]]
	end
	
	if tear:GetData().dontSetMeAsAFlippedNoteTear == true then
		if tear:GetData().flippedNoteFollowerTarget == nil then
			if tear.TearFlags & TearFlags.TEAR_EXPLOSIVE == TearFlags.TEAR_EXPLOSIVE then
				Game():BombExplosionEffects(tear.Position, tear.CollisionDamage, tear.TearFlags, tear.Color, tear.Parent, tear.Scale)
			end
			if tear.TearFlags & TearFlags.TEAR_LIGHT_FROM_HEAVEN == TearFlags.TEAR_LIGHT_FROM_HEAVEN then
				local lightbeam = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.CRACK_THE_SKY,0,tear.Position,Vector.Zero,tear.Parent):ToEffect()
				lightbeam:GetSprite().Scale = Vector(1,1)
			end
			local doRemove = true
			if tear.TearFlags & TearFlags.TEAR_ABSORB ~= TearFlags.TEAR_ABSORB then
				doRemove = false
			end
			if tear.TearFlags & TearFlags.TEAR_QUADSPLIT ~= TearFlags.TEAR_QUADSPLIT then
				doRemove = false
			end
			if tear.TearFlags & TearFlags.TEAR_BURSTSPLIT ~= TearFlags.TEAR_BURSTSPLIT then
				doRemove = false
			end


			if doRemove == true then
				tear:Remove()
			end
			
		end
		if tear:GetData().flippedNoteFollowerTarget:IsDead() then
			if tear.TearFlags & TearFlags.TEAR_EXPLOSIVE == TearFlags.TEAR_EXPLOSIVE then
				Game():BombExplosionEffects(tear.Position, tear.CollisionDamage, tear.TearFlags, tear.Color, tear.Parent, tear.Scale)
			end
			if tear.TearFlags & TearFlags.TEAR_LIGHT_FROM_HEAVEN == TearFlags.TEAR_LIGHT_FROM_HEAVEN then
				local lightbeam = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.CRACK_THE_SKY,0,tear.Position,Vector.Zero,tear.Parent):ToEffect()
				lightbeam:GetSprite().Scale = Vector(1,1)
				if tear.TearFlags & TearFlags.TEAR_EXPLOSIVE == TearFlags.TEAR_EXPLOSIVE then
					for i=0,8 do
						local lightbeam2 = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.CRACK_THE_SKY,0,tear.Position+Vector(math.random(-600,600)/10,math.random(-600,600)/10),Vector.Zero,tear.Parent):ToEffect()
						lightbeam2:GetSprite().Scale = Vector(0.25,1)
					end
				end
				
			end
			local doRemove = true
			if tear.TearFlags & TearFlags.TEAR_ABSORB ~= TearFlags.TEAR_ABSORB then
				doRemove = false
			end
			if tear.TearFlags & TearFlags.TEAR_QUADSPLIT ~= TearFlags.TEAR_QUADSPLIT then
				doRemove = false
			end
			if tear.TearFlags & TearFlags.TEAR_BURSTSPLIT ~= TearFlags.TEAR_BURSTSPLIT then
				doRemove = false
			end


			if doRemove == true then
				tear:Remove()
			end
		end
		if tear.FrameCount % 4 == 0 and tear:GetData().flippedNoteFollowerTarget ~= nil then
			local roomEntities = Isaac.GetRoomEntities() -- table
			if tear:GetData().flippedNoteDoRipples == true then
				local ripple = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.RIPPLE_POOF,0,tear.Position, Vector.Zero,tear.Parent):ToEffect()
				ripple:GetSprite().Scale = Vector(0.5,0.5) * tear.Scale
				for i = 1, #roomEntities do
					local entity = roomEntities[i]
					if (entity.Position - tear.Position):Length() <= 80*tear.Scale then
						if entity:IsVulnerableEnemy() and EntityRef(entity).IsFriendly ~= true then
							entity:TakeDamage(tear.CollisionDamage, 0, EntityRef(tear), 0)
						end
					end
				end
			else
				for i = 1, #roomEntities do
					local entity = roomEntities[i]
					if (entity.Position - tear.Position):Length() <= 40*tear.Scale then
						if entity:IsVulnerableEnemy() and EntityRef(entity).IsFriendly ~= true then
							entity:TakeDamage(tear.CollisionDamage, 0, EntityRef(tear), 0)
						end
					end
				end
			end
			

			tear.Position = tear:GetData().flippedNoteFollowerTarget.Position
			tear.Velocity = Vector.Zero

			if tear.TearFlags & TearFlags.TEAR_EXPLOSIVE == TearFlags.TEAR_EXPLOSIVE then
				Game():BombExplosionEffects(tear.Position, tear.CollisionDamage, tear.TearFlags, tear.Color, tear.Parent, 0.25*tear.Scale)
			end
			if tear.TearFlags & TearFlags.TEAR_EGG == TearFlags.TEAR_EGG then
				local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.PLAYER_CREEP_WHITE,0,tear.Position,Vector.Zero,tear.Parent):ToEffect()
			end
			if tear.TearFlags & TearFlags.TEAR_LIGHT_FROM_HEAVEN == TearFlags.TEAR_LIGHT_FROM_HEAVEN then
				local lightbeam = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.CRACK_THE_SKY,0,tear.Position+Vector(math.random(-40,40),math.random(-40,40)),Vector.Zero,tear.Parent):ToEffect()
				lightbeam:GetSprite().Scale = Vector(0.25,1)
				if tear.TearFlags & (TearFlags.TEAR_EXPLOSIVE | TearFlags.TEAR_LIGHT_FROM_HEAVEN) == (TearFlags.TEAR_EXPLOSIVE | TearFlags.TEAR_LIGHT_FROM_HEAVEN) then
					Game():BombExplosionEffects(lightbeam.Position, tear.CollisionDamage, tear.TearFlags, tear.Color, tear.Parent, 0.125*tear.Scale)
				end
			end
			if tear.TearFlags & TearFlags.TEAR_JACOBS == TearFlags.TEAR_JACOBS then
				SFXManager():AdjustVolume(SoundEffect.SOUND_REDLIGHTNING_ZAP_WEAK, 0.25)
				local zappies = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.CHAIN_LIGHTNING,0,tear.Position,Vector.Zero,tear.Parent):ToEffect()
                    zappies.CollisionDamage = tear.CollisionDamage / 4
				SFXManager():AdjustVolume(SoundEffect.SOUND_REDLIGHTNING_ZAP_WEAK, 0.25)
			end

			if tear.TearFlags & TearFlags.TEAR_SHIELDED == TearFlags.TEAR_SHIELDED then
				for i=0,3 do
					local pos = tear.Position+Vector(math.random(-40,40),math.random(-40,40))
					local angle = Vector(1,0):Resized((pos-tear.Position):Length()*0.125):Rotated((pos-tear.Position):GetAngleDegrees())
					local ripple = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.ULTRA_GREED_BLING,0,pos,angle,tear.Parent):ToEffect()
					ripple:GetSprite().Scale = Vector(0.5,0.5)
					ripple.Color = Color(1,1,1,1)
				end
				
				for i = 1, #roomEntities do
					local entity = roomEntities[i]
					if (entity.Position - tear.Position):Length() <= 40*tear.Scale then
						if entity.Type == EntityType.ENTITY_PROJECTILE and entity:ToProjectile() ~= nil and (entity:ToProjectile():HasProjectileFlags(ProjectileFlags.CANT_HIT_PLAYER) and entity:ToProjectile():HasProjectileFlags(ProjectileFlags.HIT_ENEMIES)) == false then
							--print("delete projectile")
							entity:Remove()
						end
					end
				end
			end
			--Game():BombDamage(tear.Position, tear.CollisionDamage, 40*tear.Scale, false, tear.Parent:ToPlayer(), tear.TearFlags, DamageFlag.DAMAGE_EXPLOSION - 4, false)
			
			for i = 1, #roomEntities do
				local entity = roomEntities[i]
				if (entity.Position - tear.Position):Length() <= 40*tear.Scale then
					if entity:IsVulnerableEnemy() and EntityRef(entity).IsFriendly ~= true then
						entity:TakeDamage(tear.CollisionDamage, 0, EntityRef(tear), 0)
					end
				end
			end
		end
	end

	--print("lmao flipnote")

	--tear:ToTear():Remove()
end
Mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, FLIPPED_NOTE.onUpdTear)


function FLIPPED_NOTE:spawnFlippedNoteChildTear(tear)

	local flippedNoteFollowerTear = Isaac.Spawn(2,0,0,tear.Position,Vector.Zero,player):ToTear()
			
			
			flippedNoteFollowerTear:ChangeVariant(tear.Variant)
			flippedNoteFollowerTear.CollisionDamage = tear.CollisionDamage
			flippedNoteFollowerTear.Scale = tear.Scale
			flippedNoteFollowerTear.TearFlags = tear:GetData().inheritedTearFlags | TearFlags.TEAR_PIERCING
			flippedNoteFollowerTear:GetData().dontSetMeAsAFlippedNoteTear = true
			flippedNoteFollowerTear.Parent = tear.Parent
			flippedNoteFollowerTear.Color = tear:GetData().inheritedTearColor
			flippedNoteFollowerTear.Rotation = tear.Rotation

			for key, value in pairs(tear:GetData()) do
				flippedNoteFollowerTear:GetData()[key] = value
			end
			flippedNoteFollowerTear:GetData().isFlippedNoteBaseTear = false
			flippedNoteFollowerTear:GetData().flippedNoteFollowerTarget = tear
			--tear.Visible = false

end


function FLIPPED_NOTE:onUpdTear2(tear)
	
	if tear.Parent == nil or tear.Parent.Parent == nil then return end
	if tear.Parent.Parent:ToPlayer() == nil then return end
	if not tear.Parent.Parent:ToPlayer():HasCollectible(Items.FLIPPED_NOTE) then  return end
	if tear:GetData().isFlippedNoteBaseTear == true then
		local player = tear.Parent.Parent:ToPlayer()
		--[[
		if tear.FrameCount == 1 then
			--print("do it")
			local flippedNoteFollowerTear = Isaac.Spawn(2,0,0,tear.Position,Vector.Zero,player):ToTear()
			
			flippedNoteFollowerTear:GetData().flippedNoteFollowerTarget = tear
			flippedNoteFollowerTear:ChangeVariant(tear.Variant)
			flippedNoteFollowerTear.CollisionDamage = tear.CollisionDamage
			flippedNoteFollowerTear.Scale = tear.Scale
			flippedNoteFollowerTear.TearFlags = tear:GetData().inheritedTearFlags | TearFlags.TEAR_PIERCING
			flippedNoteFollowerTear:GetData().dontSetMeAsAFlippedNoteTear = true
			flippedNoteFollowerTear.Parent = tear.Parent
			flippedNoteFollowerTear.Color = tear:GetData().inheritedTearColor

			for key, value in pairs(tear:GetData()) do
				flippedNoteFollowerTear:GetData()[key] = value
			end
			flippedNoteFollowerTear:GetData().isFlippedNoteBaseTear = false
			tear.Visible = false
		end]]
	end
	
	if tear:GetData().dontSetMeAsAFlippedNoteTear == true then
		if tear:GetData().flippedNoteFollowerTarget == nil then
			if tear.TearFlags & TearFlags.TEAR_EXPLOSIVE == TearFlags.TEAR_EXPLOSIVE then
				Game():BombExplosionEffects(tear.Position, tear.CollisionDamage, tear.TearFlags, tear.Color, tear.Parent, tear.Scale)
			end
			tear:Remove()
		end
		if tear:GetData().flippedNoteFollowerTarget:IsDead() then
			if tear.TearFlags & TearFlags.TEAR_EXPLOSIVE == TearFlags.TEAR_EXPLOSIVE then
				Game():BombExplosionEffects(tear.Position, tear.CollisionDamage, tear.TearFlags, tear.Color, tear.Parent, tear.Scale)
			end
			
			tear:Remove()
		end
		if tear.FrameCount % 4 == 0 and tear:GetData().flippedNoteFollowerTarget ~= nil then
			local roomEntities = Isaac.GetRoomEntities() -- table
			for i = 1, #roomEntities do
				local entity = roomEntities[i]
				if (entity.Position - tear.Position):Length() <= 40*tear.Scale then
					if entity:IsVulnerableEnemy() and EntityRef(entity).IsFriendly ~= true then
						entity:TakeDamage(tear.CollisionDamage, 0, EntityRef(tear), 0)
					end
				end
			end

			tear.Position = tear:GetData().flippedNoteFollowerTarget.Position
			if tear.TearFlags & TearFlags.TEAR_EXPLOSIVE == TearFlags.TEAR_EXPLOSIVE then
				Game():BombExplosionEffects(tear.Position, tear.CollisionDamage, tear.TearFlags, tear.Color, tear.Parent, 0.25*tear.Scale)
			end
			--Game():BombDamage(tear.Position, tear.CollisionDamage, 40*tear.Scale, false, tear.Parent:ToPlayer(), tear.TearFlags, DamageFlag.DAMAGE_EXPLOSION - 4, false)
			
			for i = 1, #roomEntities do
				local entity = roomEntities[i]
				if (entity.Position - tear.Position):Length() <= 40*tear.Scale then
					if entity:IsVulnerableEnemy() and EntityRef(entity).IsFriendly ~= true then
						entity:TakeDamage(tear.CollisionDamage, 0, EntityRef(tear), 0)
					end
				end
			end
		end
	end

	--print("lmao flipnote")

	--tear:ToTear():Remove()
end
Mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, FLIPPED_NOTE.onUpdTear2)