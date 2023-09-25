local Mod = BotB
BotB.FF = FiendFolio
local MYBASEMENT = {}
local Items = BotB.Enums.Items
local sfx = SFXManager()






function MYBASEMENT:myBasementPlayerUpdate(player)
    if not Isaac.GetChallenge() == Isaac.GetChallengeIdByName("[BOTB] MyBasement.lua") then return end
    --
    local data = player:GetData()
    if Isaac.GetChallenge() == Isaac.GetChallengeIdByName("[BOTB] MyBasement.lua") then
        if data.botbGotTheirMyBasementShit == nil then
            --player:AddCollectible(Items.EMETER_IN, 0, false, ActiveSlot.SLOT_PRIMARY)
            
            
            --TSIL.Players.AddSmeltedTrinket(player,TrinketType.TRINKET_NO)
            
            local seeds = Game():GetSeeds()
            --sorry for the jank but it has to be done in order to make it work
            seeds:AddSeedEffect(SeedEffect.SEED_HEALTH_PITCH)
            seeds:AddSeedEffect(SeedEffect.SEED_PERMANENT_CURSE_LOST)
            seeds:AddSeedEffect(SeedEffect.SEED_PERMANENT_CURSE_MAZE)
            seeds:AddSeedEffect(SeedEffect.SEED_PREVENT_CURSE_DARKNESS)
            seeds:AddSeedEffect(SeedEffect.SEED_PREVENT_CURSE_UNKNOWN)
            seeds:AddSeedEffect(SeedEffect.SEED_PREVENT_CURSE_BLIND)
            --Isaac.ExecuteCommand("stage 13")
            Isaac.ExecuteCommand("goto s.secret.1")
            --player:AddCollectible(Items.HOUSE_OF_LEAVES, 0, false, ActiveSlot.SLOT_POCKET)
            player:SetPocketActiveItem(BotB.Enums.Items.HOUSE_OF_LEAVES, ActiveSlot.SLOT_POCKET, false)
            player:DischargeActiveItem(ActiveSlot.SLOT_POCKET)
            player:GetData().botbGotTheirMyBasementShit = true
            player:GetData().botbIsInMyBasement = true
            player:GetData().botbGotTheirMyBasementShit2 = false
            player:GetData().botbMyBasementBossProcessed = false
        end
        local level = Game():GetLevel()
        local room = Game():GetRoom()
        local roomDescriptor = level:GetCurrentRoomDesc()
        local roomConfigRoom = roomDescriptor.Data
       
    end
    --[[
    if data.botbIsInMyBasement and Game():GetLevel():GetStage() == LevelStage.STAGE1_2 then
        if not player:HasCollectible(BotB.Enums.Items.HOUSE_OF_LEAVES) then
            
        end
    end
    ]]

end
Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE,MYBASEMENT.myBasementPlayerUpdate)


function MYBASEMENT:myBasementRoomInit()

    local player = Isaac.GetPlayer()
    if not player:GetData().botbIsInMyBasement then return end
    if player:GetData().botbGotTheirMyBasementShit2 == false then
       
        if not Isaac.GetChallenge() == Isaac.GetChallengeIdByName("[BOTB] MyBasement.lua") then return end

        local roomEntities = Isaac.GetRoomEntities() -- table
        for i = 1, #roomEntities do
            local entity = roomEntities[i]
            if entity.Type == EntityType.ENTITY_PICKUP then
                entity:Remove()
            end
        end 
        MusicManager():Fadeout(0.1)
        local room = Game():GetRoom()
        player.Position = Game():GetRoom():GetCenterPos()
        --player:UseActiveItem(CollectibleType.COLLECTIBLE_WE_NEED_TO_GO_DEEPER,UseFlag.USE_NOANIM)
        room:SpawnGridEntity(room:GetClampedGridIndex(Game():GetRoom():GetCenterPos()),GridEntityType.GRID_TRAPDOOR,0,0,0)
        --Game():GetRoom():SpawnGridEntity(GridIndex, Type, Variant, Seed, VarData)
        player.Position = Game():GetRoom():GetCenterPos() + Vector(0,150)
        if Game():GetRoom():GetBackdropType() ~= BackdropType.DARK_CLOSET then
            Game():ShowHallucination(0, BackdropType.DARK_CLOSET)
            SFXManager():Stop(SoundEffect.SOUND_DEATH_CARD)
        end

        --Game:GetLevel():SetStage(1, 1)
        player:GetData().botbGotTheirMyBasementShit2 = true



    end

end

Mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, MYBASEMENT.myBasementRoomInit)


function MYBASEMENT:onRoomClear()
    --mybasement boss clear
    local level = Game():GetLevel()
        local room = Game():GetRoom()
        local roomDescriptor = level:GetCurrentRoomDesc()
        local roomConfigRoom = roomDescriptor.Data
        local players = MYBASEMENT:GetPlayers()
        local doesSomeoneHaveMyBasement = false
        for i=1,#players,1 do
				if players[i]:ToPlayer():GetData().botbIsInMyBasement == true then
                    doesSomeoneHaveMyBasement = true
                    local player = players[i]:ToPlayer()
                    if roomConfigRoom.Type == RoomType.ROOM_BOSS and doesSomeoneHaveMyBasement == true and Game():GetLevel():GetStage() == LevelStage.STAGE1_2 then
        
                        --print("get your trophy")
                        --
                            if not player:GetData().botbMyBasementTrophy then
                                local trophy = Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_TROPHY,0,Isaac.GetFreeNearPosition(Game():GetRoom():GetCenterPos(), 10),Vector.Zero,nil)
                                player:AddKeys(-99)
                                player:GetData().botbMyBasementTrophy = true
                            end
                            
                            local trapdoors = TSIL.GridSpecific.GetTrapdoors(TSIL.Enums.TrapdoorVariant.NORMAL)
                            if #trapdoors ~= 0 then
                                TSIL.GridEntities.RemoveGridEntities(trapdoors, true)
                            end
                            local doors = TSIL.Doors.GetDoors()
                            
                            if #doors ~= 0 then
                                for i=1,#doors do
                                    local doorSprite = doors[i]:GetSprite()
                                    --print(doorSprite:GetFilename())
                                    --delete anything that isnt the boss room door
                                    if doorSprite:GetFilename() ~= "gfx/grid/door_10_bossroomdoor.anm2" then
                                        TSIL.GridEntities.RemoveGridEntity(doors[i],true)
                                    end
                                        --doorSprite:Load("gfx/grid/taintedtreasureroomdoor.anm2", true)
                                        --doorSprite:ReplaceSpritesheet(0, "gfx/grid/taintedtreasureroomdoor.png")
                                    --doors[i]:ToDoor():Close(true)
                                    --doors[i]:ToDoor():Bar()
                                end
                                --TSIL.GridEntities.RemoveGridEntities(doors, true)
                            end
                            
                                        
                            local roomEntities = Game():GetRoom():GetEntities() -- cppcontainer
                            for i = 0, #roomEntities - 1 do
                                local entity = roomEntities:Get(i)
                                --print(entity.Type, entity.Variant, entity.SubType)
                                if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_COLLECTIBLE then
                                    entity:Remove()
                                end
                            end

                            player:GetData().botbMyBasementBossProcessed = true
                            
                           
                
                    end
                end

	

		end
		if not doesSomeoneHaveMyBasement then return end

    
    

end
Mod:AddCallback(TSIL.Enums.CustomCallback.POST_ROOM_CLEAR_CHANGED, MYBASEMENT.onRoomClear, true)

--[[
function MYBASEMENT:myBasementPlayerUpdate2(player)
        local level = Game():GetLevel()
        local room = Game():GetRoom()
        local roomDescriptor = level:GetCurrentRoomDesc()
        local roomConfigRoom = roomDescriptor.Data
       if roomConfigRoom.Type == RoomType.ROOM_BOSS and player:GetData().botbMyBasementBossProcessed == false and Game():GetLevel():GetStage() == LevelStage.STAGE7 then
         if room:IsClear() then
            print("balls")
            if player:GetData().botbMyBasementTrophy == nil then
                local trophy = Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_TROPHY,0,player.Position,Vector.Zero,player)
                local trapdoors = TSIL.GridSpecific.GetTrapdoors(TSIL.Enums.TrapdoorVariant.NORMAL)
                if #trapdoors ~= 0 then
                     trapdoors[1]:Destroy(true)
                end
                player:GetData().botbMyBasementBossProcessed = true
                player:GetData().botbMyBasementTrophy = true
            end
           --local trophy = Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_TROPHY,0,player.Position,Vector.Zero,player)
           
         end
       end
        --[[
        local room = Game():GetRoom()
        local level = game:GetLevel()
       local roomDescriptor = level:GetCurrentRoomDesc()
       local roomConfigRoom = roomDescriptor.Data
      if roomConfigRoom.Type == RoomType.ROOM_TREASURE then
            --converts item pedestals to randomized consumables in treasure rooms
            local roomEntities = Game():GetRoom():GetEntities() -- cppcontainer
            for i = 0, #roomEntities - 1 do
                local entity = roomEntities:Get(i)
                if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == 100 then
                    local spawnPos = entity.Position
                    local cardIDLimit = (#Isaac.GetItemConfig():GetCards())-1
                    Isaac.Spawn(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_TAROTCARD,math.random(1,cardIDLimit),spawnPos,Vector.Zero,player)
                    entity:Remove()
                end
            end
      end]]
      --player:GetData().botbMyBasementBossProcessed = false
    --end

--Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE,MYBASEMENT.myBasementPlayerUpdate2)



function MYBASEMENT:myBasementPlayerUpdateSecrets(player)
    if not Isaac.GetChallenge() == Isaac.GetChallengeIdByName("[BOTB] MyBasement.lua") then return end
    --
    local data = player:GetData()
    local musicManager = MusicManager()
    if player:GetData().botbGotTheirMyBasementShit == true then
        --player is in MyBasement.lua
        --print(Game().TimeCounter)
        local myBasementPursuerThreshold = 36000
        if Game().TimeCounter == myBasementPursuerThreshold then
            if not data.hasDoneMyBasementPursuer then
                Game():GetHUD():ShowItemText("...", "...You feel watched.", false)
                local pursuer = Isaac.Spawn(BotB.Enums.Entities.PURSUER.TYPE, BotB.Enums.Entities.PURSUER.VARIANT, 0, player.Position+Vector(1000,0):Rotated(math.random(0,360)),Vector.Zero,player):ToNPC()
                pursuer.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
                pursuer:AddEntityFlags(EntityFlag.FLAG_PERSISTENT)
                local seeds = Game():GetSeeds()
                seeds:RemoveSeedEffect(SeedEffect.SEED_HEALTH_PITCH)
                seeds:AddSeedEffect(SeedEffect.SEED_MOVEMENT_PITCH)
                seeds:AddSeedEffect(SeedEffect.SEED_ULTRA_SLOW_MUSIC)
                Game():Darken(0.95, 80)
                --name="myBasement Post Awareness"
                --musicManager:Play(Isaac.GetMusicIdByName("myBasement Post Awareness"),1)
                musicManager:Fadeout(0.09)
                --musicManager:Queue(Isaac.GetMusicIdByName("myBasement Post Awareness"))
                --seeds:AddSeedEffect(SeedEffect.SEED_PERMANENT_CURSE_DARKNESS)
                data.hasDoneMyBasementPursuer = true
                
            end
            
        end

        if Game().TimeCounter == myBasementPursuerThreshold + 80 then
            --local seeds = Game():GetSeeds()
            --seeds:AddSeedEffect(SeedEffect.SEED_PERMANENT_CURSE_DARKNESS)
            Game():Darken(0.95, -1)
            
        end
        --[[
        if Game().TimeCounter > myBasementPursuerThreshold and MusicManager():GetCurrentMusicID() ~= Isaac.GetMusicIdByName("myBasement Post Awareness") then
            --musicManager:Play(Isaac.GetMusicIdByName("myBasement Post Awareness"),1)
            musicManager:Queue(Isaac.GetMusicIdByName("myBasement Post Awareness"))
        end]]
    end
    
    

end
Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE,MYBASEMENT.myBasementPlayerUpdateSecrets)

local stageAPI = StageAPI



function MYBASEMENT:GetPlayers()
	local players = {}

	for i = 1, game:GetNumPlayers() do
		table.insert(players, game:GetPlayer(i))
	end

	return players
end
--[[
function MYBASEMENT:musicFix()
    local players = MYBASEMENT.GetPlayers
    for i=1, #players do
        if players[i]:GetData().hasDoneMyBasementPursuer then
            return Isaac.GetMusicIdByName("myBasement Post Awareness")
        end
    end
end
StageAPI.AddCallback(BotB, stageAPI.Callbacks.POST_SELECT_STAGE_MUSIC, 1, MYBASEMENT.musicFix)]]


function MYBASEMENT:pursuerHurt(entity,amt,flag,source)
    --print("cocks")
    local player = Isaac.GetPlayer()
    local data = player:GetData()
        if data.hasDoneMyBasementPursuer and source.Type == BotB.Enums.Entities.PURSUER.TYPE and source.Variant == BotB.Enums.Entities.PURSUER.VARIANT then
            
            SFXManager():Stop(SoundEffect.SOUND_ISAAC_HURT_GRUNT)

            print('this should unlock curse of the stalked')
            --[[
            game.Challenge = Challenge.CHALLENGE_XXXXXXXXL
            Isaac.ExecuteCommand("stage 12")
            game.Challenge = Isaac.GetChallengeIdByName("[BOTB] MyBasement.lua")
            ]]
        end
    end

Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, MYBASEMENT.pursuerHurt, EntityType.ENTITY_PLAYER)
--[[
function MYBASEMENT:emptyVoid(npc)
    local room = Game():GetRoom()
        local roomDescriptor = Game():GetLevel():GetCurrentRoomDesc()
        local roomConfigRoom = roomDescriptor.Data
    if roomConfigRoom.Type ~= RoomType.ROOM_BOSS and npc:IsEnemy() and Game():GetLevel():GetStage() == LevelStage.STAGE7 and (npc.Type ~= BotB.Enums.Entities.PURSUER.TYPE and npc.Variant ~= BotB.Enums.Entities.PURSUER.VARIANT) then
        npc:Remove()
    end
    --[[
    if npc.Type == BotB.Enums.Entities.PURSUER.TYPE and npc.Variant == BotB.Enums.Entities.PURSUER.VARIANT then
        npc:Remove()
    end]]
--end
--Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, MYBASEMENT.emptyVoid)