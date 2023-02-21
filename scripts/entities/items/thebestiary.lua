local Mod = BotB
local THE_BESTIARY = {}
local pickups = BotB.Enums.Pickups
local Entities = BotB.Enums.Entities
local sfx = SFXManager()
local PLAYER_SOLOMON = Isaac.GetPlayerTypeByName("Solomon")
local ret = Retribution

if EID then
	EID:addCollectible(Isaac.GetItemIdByName("The Bestiary"), "Marks the enemy with the highest maximum health in the room, making it and all others of its species weak. #For Solomon only: Spawns a friendly copy of said enemy each floor after the current one.")
end

function THE_BESTIARY:GetPlayers()
	local players = {}
	for i = 1, game:GetNumPlayers() do
		table.insert(players, game:GetPlayer(i))
	end
	return players
end

function THE_BESTIARY:GetBestiaryTargets()
	local bestiaryCompatibleRoomEntities = {}
	--List of vulnerable non-boss enemies
	for i, entity in ipairs(Isaac.GetRoomEntities()) do
		--Is it vulnerable and not a boss?
		local entityRef = EntityRef(entity)
		if entity:IsVulnerableEnemy() and entity:IsBoss() == false and entityRef.IsFriendly ~= true then
			table.insert(bestiaryCompatibleRoomEntities, entity)
		end
	end
	if #bestiaryCompatibleRoomEntities ~= 0 then
		local healthBaseline = 0
		local bestCandidates = {}
		for i, entity in ipairs(bestiaryCompatibleRoomEntities) do
			if entity.MaxHitPoints > healthBaseline then
				healthBaseline = entity.MaxHitPoints
			end
		end
		for i, entity in ipairs(bestiaryCompatibleRoomEntities) do
			if entity.MaxHitPoints == healthBaseline then
				table.insert(bestCandidates, entity)
			end
		end
		return bestCandidates
	else
		return nil
	end
	
end

	function THE_BESTIARY:bestiaryActiveItem(_, _, player, _, _, _)
		local room = Game():GetRoom()
		local bestiaryCandidates = THE_BESTIARY:GetBestiaryTargets()
		local data = player:GetData()
		if false then
			player:AnimateSad()
			sfx:Play(SoundEffect.SOUND_THUMBS_DOWN,1,0,false,1)
		else
			if player:GetPlayerType() ~= PLAYER_SOLOMON then
				if bestiaryCandidates ~= nil then
					--If not Solomon
					player:AnimateCollectible(Isaac.GetItemIdByName("The Bestiary"))
					sfx:Play(SoundEffect.SOUND_MENU_FLIP_DARK,0.75,0,false,1.5)
					local randomCandidate = math.random(#bestiaryCandidates)
					local trueCandidate = bestiaryCandidates[randomCandidate]
					local bestiaryMarker = Isaac.Spawn(EntityType.ENTITY_EFFECT,Entities.WARNING_TARGET.VARIANT,0,bestiaryCandidates[randomCandidate].Position,Vector(0,0),player):ToEffect()
					bestiaryMarker.Timeout = 15
					bestiaryMarker:GetSprite().Scale = Vector(2,2)
					if data.bestiaryQueue ~= nil then
						if trueCandidate.SubType ~= nil then
							table.insert(data.bestiaryQueue, {trueCandidate.Type , trueCandidate.Variant, trueCandidate.SubType})
							if player:GetPlayerType() == PLAYER_SOLOMON then
								table.insert(data.friendlySolomonEnemiesToSpawn, {trueCandidate.Type , trueCandidate.Variant, trueCandidate.SubType})
								local friendo = Isaac.Spawn(trueCandidate.Type,trueCandidate.Variant,trueCandidate.SubType,player.Position,Vector.Zero,player):ToNPC()
								friendo:AddCharmed(EntityRef(player),-1)
							end
						else
							table.insert(data.bestiaryQueue, {trueCandidate.Type , trueCandidate.Variant, 0})
							if player:GetPlayerType() == PLAYER_SOLOMON then
								table.insert(data.friendlySolomonEnemiesToSpawn, {trueCandidate.Type , trueCandidate.Variant, 0})
								local friendo = Isaac.Spawn(trueCandidate.Type,trueCandidate.Variant,0,player.Position,Vector.Zero,player):ToNPC()
								friendo:AddCharmed(EntityRef(player),-1)
							end
						end
						
					end
				end
				
			else
				--If Solomon
				if data.solomonHasBestiaryUIOpen == false then
					local bestiaryUI = Isaac.Spawn(EntityType.ENTITY_EFFECT,Isaac.GetEntityVariantByName("Solomon Bestiary UI"),0,player.Position,Vector.Zero,player):ToEffect()
            		bestiaryUI.Parent = player
					data.solomonHasBestiaryUIOpen = true
					return {Discharge=false,Remove=false,ShowAnim=true,}
				end
			end
			
		end
	end
	Mod:AddCallback(ModCallbacks.MC_USE_ITEM,THE_BESTIARY.bestiaryActiveItem,Isaac.GetItemIdByName("The Bestiary"))

	local PLAYER_SOLOMON = Isaac.GetPlayerTypeByName("Solomon")

	function THE_BESTIARY:subtractBestiaryCharge(player, sub)
		if player:GetActiveCharge(ActiveSlot.SLOT_POCKET)-sub <= 0 then
			player:SetActiveCharge(0, ActiveSlot.SLOT_POCKET)
		else
			player:SetActiveCharge(player:GetActiveCharge(ActiveSlot.SLOT_POCKET)-sub, ActiveSlot.SLOT_POCKET)
		end
	end

	function THE_BESTIARY:playerUpdate(player)
		local data = player:GetData()
		local level = Game():GetLevel()
		if player:HasCollectible(Isaac.GetItemIdByName("The Bestiary")) then
			if data.bestiaryQueue == nil then
				data.bestiaryQueue = {}
				if player:GetPlayerType() == PLAYER_SOLOMON then
					data.solomonHasBestiaryUIOpen = false
				end				
			end
		end
	end
	Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, THE_BESTIARY.playerUpdate, 0)

	function THE_BESTIARY:CombineBestiaryLists()
		local players = THE_BESTIARY:GetPlayers()
		local bestiaryWatchlist = {}
		local actuallyDoTheBestiaryShit = false
		--Combine contents of every player's bestiary queue should they have one
		for i=1,#players,1 do
			if players[i]:HasCollectible(Isaac.GetItemIdByName("The Bestiary")) then
					for j=1,#players[i]:GetData().bestiaryQueue,1 do
						Mod.Functions.Tables:AppendTable(bestiaryWatchlist,players[i]:GetData().bestiaryQueue)
						actuallyDoTheBestiaryShit = true
					end
			end
		end
		return bestiaryWatchlist
	end
--[[
	if npc:HasEntityFlags(EntityFlag.FLAG_WEAKNESS) == false then
						npc:AddEntityFlags(EntityFlag.FLAG_WEAKNESS)
					end
]]
	function THE_BESTIARY:npcUpdate(npc)
		local omniBestiaryList = THE_BESTIARY:CombineBestiaryLists()
		--Mod.Functions.Tables:print_table(omniBestiaryList)
		local npcIdentifier = {}
		if npc.SubType == 0 or npc.SubType == nil then
			npcIdentifier = {npc.Type,npc.Variant,0}
		else
			npcIdentifier = {npc.Type,npc.Variant,npc.SubType}
		end
		--Mod.Functions.Tables:print_table(npcIdentifier)
		--print(Mod.Functions.Tables:ContainsValue(omniBestiaryList,npcIdentifier))
		for i=1,#omniBestiaryList, 1 do
			if table.concat(omniBestiaryList[i]) == table.concat(npcIdentifier) and EntityRef(npc).IsFriendly == false then
				if npc:HasEntityFlags(EntityFlag.FLAG_WEAKNESS) == false then
					npc:AddEntityFlags(EntityFlag.FLAG_WEAKNESS)
				end
			end
		end
	end
	Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, THE_BESTIARY.npcUpdate)


------------------------------------------------------------------------------------------------------------------------------------------------------------------[[


--ACTUAL BESTIARY FUNCTIONS--


------------------------------------------------------------------------------------------------------------------------------------------------------------------]]
function THE_BESTIARY:BestiaryCall(player)
	sfx:Play(SoundEffect.SOUND_WHISTLE,1,0,false,1.5,0)
	for i, entity in ipairs(Isaac.GetRoomEntities()) do
		--Is it vulnerable and not a boss?
		local entityRef = EntityRef(entity)
		if entity:IsEnemy() and entity:IsVulnerableEnemy() and  entityRef.IsFriendly == true then
			entity.Position = player.Position
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
function THE_BESTIARY:BestiaryHeal(player)
	sfx:Play(SoundEffect.SOUND_VAMP_DOUBLE,1,0,false,1.5,0)
	for i, entity in ipairs(Isaac.GetRoomEntities()) do
		--Is it vulnerable and not a boss?
		
		local entityRef = EntityRef(entity)
		if entity:IsEnemy() and entity:IsVulnerableEnemy() and entityRef.IsFriendly == true then
			entity.HitPoints= entity.HitPoints + (0.5 * entity.MaxHitPoints)
			Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.HEART,0,entity.Position+Vector(0,-(entity.SpriteScale.Y * 35)),Vector.Zero,entity)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
function THE_BESTIARY:BestiaryUpgrade(player)
	local ret = Retribution
	local worked = false
	if ret then
		local friendlyTable = {}
		--Make friendly table
		for i, entity in ipairs(Isaac.GetRoomEntities()) do
			--Is it vulnerable and not a boss?
			local entityRef = EntityRef(entity)
			if entity:IsEnemy() and entity:IsVulnerableEnemy() and entityRef.IsFriendly == true then
				table.insert(friendlyTable,#friendlyTable + 1,entity)
			end
		end
		--Check ones that can be baptismal-upgraded
		for i=1,#friendlyTable,1 do
			local hp = friendlyTable[i].HitPoints / 2
			local new = ret.DoAntibaptismalUpgrade(friendlyTable[i], player:GetCollectibleRNG(BotB.Enums.Items.THE_BESTIARY))
			if new then
				Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.BATTERY,0,new.Position+Vector(0,-(new.SpriteScale.Y + 35)),Vector.Zero,new)
				if worked == false then
					worked = true
				end
			end
		end
	else
            local AbacusFont = Font()
            AbacusFont:Load("font/pftempestasevencondensed.fnt")
            for i = 1, 60 do
                BotB.FF.scheduleForUpdate(function()
                    local pos = game:GetRoom():WorldToScreenPosition(player.Position) + Vector(AbacusFont:GetStringWidth(str) * -0.5, -(player.SpriteScale.Y * 35) - i/2)
                    local opacity
                    if i >= 30 then
                        opacity = 1 - ((i-30)/30)
                    else
                        opacity = i/15
                    end
                    AbacusFont:DrawString("You need Retribution to upgrade your friendly monsters!", pos.X, pos.Y, KColor(1,1,1,opacity), 0, false)
                end, i, ModCallbacks.MC_POST_RENDER)
            end
		player:AnimateSad()
		sfx:Play(SoundEffect.SOUND_THUMBS_DOWN,1,0,false,1)

	end
	return worked
	
end
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
function THE_BESTIARY:BestiaryTame(player)
	local bestiaryCandidates = THE_BESTIARY:GetBestiaryTargets()
	local data = player:GetData()
	if bestiaryCandidates ~= nil then
		player:AnimateCollectible(Isaac.GetItemIdByName("The Bestiary"))
		sfx:Play(SoundEffect.SOUND_MENU_FLIP_DARK,0.75,0,false,1.5)
		local randomCandidate = math.random(#bestiaryCandidates)
		local trueCandidate = bestiaryCandidates[randomCandidate]
		local bestiaryMarker = Isaac.Spawn(EntityType.ENTITY_EFFECT,Entities.WARNING_TARGET.VARIANT,0,bestiaryCandidates[randomCandidate].Position,Vector(0,0),player):ToEffect()
		bestiaryMarker.Timeout = 15
		bestiaryMarker:GetSprite().Scale = Vector(2,2)
		if data.bestiaryQueue ~= nil then
			if trueCandidate.SubType ~= nil then
				table.insert(data.bestiaryQueue, {trueCandidate.Type , trueCandidate.Variant, trueCandidate.SubType})
				if player:GetPlayerType() == PLAYER_SOLOMON then
					table.insert(data.friendlySolomonEnemiesToSpawn, {trueCandidate.Type , trueCandidate.Variant, trueCandidate.SubType})
					local friendo = Isaac.Spawn(trueCandidate.Type,trueCandidate.Variant,trueCandidate.SubType,player.Position,Vector.Zero,player):ToNPC()
					friendo:AddCharmed(EntityRef(player),-1)
				end
			else
				table.insert(data.bestiaryQueue, {trueCandidate.Type , trueCandidate.Variant, 0})
				if player:GetPlayerType() == PLAYER_SOLOMON then
					table.insert(data.friendlySolomonEnemiesToSpawn, {trueCandidate.Type , trueCandidate.Variant, 0})
					local friendo = Isaac.Spawn(trueCandidate.Type,trueCandidate.Variant,0,player.Position,Vector.Zero,player):ToNPC()
					friendo:AddCharmed(EntityRef(player),-1)
				end
			end
			
		end
		THE_BESTIARY:subtractBestiaryCharge(player, 6)
	else
		player:AnimateSad()
		sfx:Play(SoundEffect.SOUND_THUMBS_DOWN,1,0,false,1)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------------------------------


function THE_BESTIARY:iconEffect(effect)
    local pdata = effect.Parent:GetData()
    effect.Position = effect.Parent.Position + Vector(0,-96)
    local sprite = effect:GetSprite()
    if effect.State == 0 then
        sprite:Play("Start")
        effect.State = 99
    end
    if effect.State == 99 then
        if sprite:IsEventTriggered("Back") then
            sprite:Play("Idle")
            effect.State = 100
        end
    end
    if effect.State == 100 and sprite:GetAnimation() == "Idle" then
        if Input.IsActionPressed(ButtonAction.ACTION_SHOOTRIGHT, 0) then
            --Recruit bestiary functions
			if pdata.solomonKnowledgePoints >= 6 then
				THE_BESTIARY:BestiaryTame(effect.Parent:ToPlayer())
				pdata.solomonKnowledgePoints = pdata.solomonKnowledgePoints - 6
			end
            --pdata.BestiaryFunc = 1
			
            sprite:Play("Right")
        end
        if Input.IsActionPressed(ButtonAction.ACTION_SHOOTDOWN, 0) then
            --Heal
            --pdata.BestiaryFunc = 2
			if pdata.solomonKnowledgePoints >= 3 then
				THE_BESTIARY:BestiaryHeal(effect.Parent:ToPlayer())
				pdata.solomonKnowledgePoints = pdata.solomonKnowledgePoints - 3
			end
			
            sprite:Play("Down")
        end
        if Input.IsActionPressed(ButtonAction.ACTION_SHOOTUP, 0) then
            --Upgrade
            --pdata.BestiaryFunc = 3
			if pdata.solomonKnowledgePoints >= 4 then
				local upgradeTestBool = THE_BESTIARY:BestiaryUpgrade(effect.Parent:ToPlayer())
				if upgradeTestBool == true then
					pdata.solomonKnowledgePoints = pdata.solomonKnowledgePoints - 4
				end
			end
			
            sprite:Play("Up")
        end
        if Input.IsActionPressed(ButtonAction.ACTION_SHOOTLEFT, 0) then
            --Call
            --pdata.BestiaryFunc = 4
			if pdata.solomonKnowledgePoints >= 1 then
				THE_BESTIARY:BestiaryCall(effect.Parent:ToPlayer())
				pdata.solomonKnowledgePoints = pdata.solomonKnowledgePoints - 1
			end
			
            sprite:Play("Left")
        end
		if (Input.IsActionPressed(ButtonAction.ACTION_DROP, 0) or Input.IsActionPressed(ButtonAction.ACTION_PILLCARD, 0)) then
            --Call
            --pdata.BestiaryFunc = 4
			effect:Remove()
        	pdata.solomonHasBestiaryUIOpen = false
        end
    end
    if sprite:IsEventTriggered("Remove") then
        effect:Remove()
        pdata.solomonHasBestiaryUIOpen = false
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE,THE_BESTIARY.iconEffect, Isaac.GetEntityVariantByName("Solomon Bestiary UI"))

--little knowledge point icon
local kpIcon = Sprite()
kpIcon:Load("gfx/ui/solomon_kp_ui.anm2", true)

function THE_BESTIARY:iconEffect2(effect)
    local pdata = effect.Parent:GetData()
    local sprite = effect:GetSprite()
	if sprite:GetAnimation() == "Idle" or (sprite:GetAnimation() == "Start" and effect.FrameCount > 1) then
		--Isaac.RenderText(pdata.solomonKnowledgePoints,Isaac.WorldToScreen(effect.Position).X,Isaac.WorldToScreen(effect.Position).Y+72,1,1,1,1)
		--Isaac.RenderText("Will this always be centered?",Isaac.WorldToScreen(effect.Position).X,Isaac.WorldToScreen(effect.Position).Y+72,1,1,1,1)	
		local f = Font() -- init font object
		f:Load("font/pftempestasevencondensed.fnt") -- load a font into the font object
		f:DrawString(pdata.solomonKnowledgePoints,Isaac.WorldToScreen(effect.Position).X,Isaac.WorldToScreen(effect.Position).Y+72,KColor(1,1,1,1),f:GetStringWidth(pdata.solomonKnowledgePoints),true) -- render string with loaded font
		kpIcon:Play("Idle")
		kpIcon:Render(Vector(Isaac.WorldToScreen(effect.Position).X-f:GetStringWidth(pdata.solomonKnowledgePoints),Isaac.WorldToScreen(effect.Position).Y+79))
	end
end
Mod:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER,THE_BESTIARY.iconEffect2, Isaac.GetEntityVariantByName("Solomon Bestiary UI"))