local Mod = BotB
sfx = SFXManager()
game = Game()
local WRATHMODE = {}
local HiddenItemManager = require("scripts.core.hidden_item_manager")
Mod.ClearedRooms = {}

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

--[[
function BotB:wrathCMD(cmd, params)
    if not cmd == "wrath" then return end
    if cmd == "wrath" then
        --local playerTable = BotB:GetPlayers()
        --print("this better have been worth the effort")
        if Game():GetRoom():GetType() ~= RoomType.ROOM_BOSS then
            print("YOU WANT SOME, JACKASS?")
            local players = getPlayers()
            for i=1, #getPlayers() do
                local player = players[i]
                player:GetData().isDoingPizzaTime = true
            end
        end
            

        


    end
    
    
end
Mod:AddCallback(ModCallbacks.MC_EXECUTE_CMD, BotB.wrathCMD)]]

local specialMusicManager = MusicManager()


Mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, function(_, rng)
	local level = game:GetLevel()
	local room = game:GetRoom()

	if room:GetType() == RoomType.ROOM_DEFAULT then
		table.insert(Mod.ClearedRooms, level:GetCurrentRoomIndex())
	elseif room:GetType() == RoomType.ROOM_BOSS then
        local players = getPlayers()
        local letsdothis = false
            for i=1, #getPlayers() do
                local player = players[i]
                if player:GetData().isDoingPizzaTime == true then
                    letsdothis = true
                    player:GetData().isInPizzaTime = true
                end
            end
        if letsdothis then
            print("LET'S DANCE, BASTARD!")
                    for _, index in pairs(Mod.ClearedRooms) do
                        local roomdesc = level:GetRoomByIdx(index)
                        roomdesc.Clear = false
                        roomdesc.NoReward = false
                        roomdesc.AwardSeed = roomdesc.DecorationSeed
                        roomdesc.VisitedCount = 0
                        roomdesc.PressurePlatesTriggered = false
                        roomdesc.DisplayFlags = 5
        
                        if MinimapAPI then
                            MinimapAPI:LoadDefaultMap()
                        end
                    end
        
                    level:UpdateVisibility()
                    MusicManager():Disable()
                    SFXManager():Play(BotB.Enums.SFX.GTFO_INTRO,1,0,false,1,1)
        end
	end
end)

Mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
	Mod.ClearedRooms = {}
    
end)


Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function()

    local players = getPlayers()
    local letsfuckinGODUDE = false
    for i=1, #players do
        local player = players[i]:ToPlayer()
        if player:GetData().isInPizzaTime == true then
            letsfuckinGODUDE = true
        end
    end

    if letsfuckinGODUDE == true then
        local musicManager = MusicManager()
        if SFXManager():IsPlaying(BotB.Enums.SFX.GTFO_INTRO) == false and SFXManager():IsPlaying(BotB.Enums.SFX.GTFO) == false then
            SFXManager():Play(BotB.Enums.SFX.GTFO,1,0,false,1,1)
        end
        --[[
        if musicManager:GetCurrentMusicID() ~= Isaac.GetMusicIdByName("GTFO!") then
            musicManager:Play(Isaac.GetMusicIdByName("GTFO!"),1)
            musicManager:Queue(Isaac.GetMusicIdByName("GTFO!"))
        end]]
        if Game():GetFrameCount() % 2 == 0 then
            Game():ShakeScreen(2)
        end
        if Game():GetLevel():GetCurrentRoomIndex() == Game():GetLevel():GetStartingRoomIndex() then
            SFXManager():Stop(BotB.Enums.SFX.GTFO)
            MusicManager():Enable()
            print("FUCK, FOILED AGAIN, HAVE SOME SHIT I GUESS")
            local players = getPlayers()
            local you
                for i=1, #getPlayers() do
                    local player = players[i]
                    you = players[i]
                    player:GetData().isDoingPizzaTime = false
                    player:GetData().isInPizzaTime = false
                end
                musicManager:Crossfade(Music.MUSIC_BOSS_OVER, 0.5)
            Isaac.GridSpawn(GridEntityType.GRID_TRAPDOOR, 0, Game():GetRoom():GetCenterPos(), true)
    
            HiddenItemManager:Add(you,BotB.Enums.Items.PANDEMONIUM,0,1,"PIZZA_REWARD")
            for i=0,9 do
                Isaac.Spawn(EntityType.ENTITY_PICKUP,0,0,Game():GetRoom():GetRandomPosition(10),Vector(math.random(6,12),0):Rotated(math.random(0,359)),you)
            end
            HiddenItemManager:RemoveAll(you, "PIZZA_REWARD")
            for i=1, #players do
                local player = players[i]:ToPlayer()
                if player:GetData().isInPizzaTime == true then
                    player:GetData().isInPizzaTime = false
                end
            end
        end
    else
        SFXManager():Stop(BotB.Enums.SFX.GTFO)
    end

    

end)

Mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()

    local players = getPlayers()
    local letsfuckinGODUDE = false
    for i=1, #getPlayers() do
        local player = players[i]
        if player:GetData().isInPizzaTime == true then
            letsfuckinGODUDE = true
        end
    end
    if letsfuckinGODUDE then
        local roomEntities = Isaac.GetRoomEntities() -- table
        for i = 1, #roomEntities do
            local entity = roomEntities[i]
            if entity:ToNPC() ~= nil and EntityRef(entity).IsFriendly ~= true and math.random(0,1) == 0 then
                local new = Retribution.DoAntibaptismalUpgrade(entity, RNG())
                if new then
                    new:GetData().ammoDepotEffect = true
                end
                
            end
        end
    end
    
    



end)

--[[


]]
