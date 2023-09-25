local Mod = BotB
local mod = FiendFolio
local FLOPPY_DISK = {}
local pickups = BotB.Enums.Pickups
local sfx = SFXManager()
local fiftyShadesBaseDuration = 480

if EID then
	EID:addTrinket(Isaac.GetTrinketIdByName("Floppy Disk"), "Spawns up to 2 extra rooms when entering a new floor. #Completing a room has a chance to spawn a portal leading to an uncompleted room")
end
--print("got the floppy")
function FLOPPY_DISK:GetPlayers()
	local players = {}

	for i = 1, game:GetNumPlayers() do
		table.insert(players, game:GetPlayer(i))
	end

	return players
end


	--modified from Atlas from Tainted Treasures
	function FLOPPY_DISK:botbHOLFloorLogic()
		--[[
		local level = Game():GetLevel()
		if Game().Challenge ~= Challenge.CHALLENGE_XXXXXXXXL then
			print("now has xxxxxxl")
			local character = player:GetPlayerType()
			game.Challenge = Challenge.CHALLENGE_XXXXXXXXL
	  		player:ChangePlayerType(character)
		end
		]]
		local doesSomeoneHaveHouseOfLeaves = false
		local players = FLOPPY_DISK:GetPlayers()
		local generate = 0
		for i=1,#players,1 do
			if players[i]:ToPlayer():HasTrinket(Isaac.GetTrinketIdByName("Floppy Disk")) then
				generate = generate + (2 * players[i]:ToPlayer():GetTrinketMultiplier(Isaac.GetTrinketIdByName("Floppy Disk")))

				doesSomeoneHaveHouseOfLeaves = true
				if players[i]:ToPlayer():GetData().botbGotTheirMyBasementShit2 == true then
					--Game().Challenge = Isaac.GetChallengeIdByName("[BOTB] MyBasement.lua")
				end
	
			end
		end
		if not doesSomeoneHaveHouseOfLeaves then return end

		Game().Challenge = Challenge.CHALLENGE_NULL


		local level = game:GetLevel()
		if level:GetStage() ~= LevelStage.STAGE8 then --Home
			local generate = 2

			for i = 0, generate, 1 do

				TaintedTreasure:GenerateExtraRoom()

			end
		end
	end
	Mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, FLOPPY_DISK.botbHOLFloorLogic, 0)
	



	function FLOPPY_DISK:onRoomClear(player, type)
		--print("test")
		local doesSomeoneHaveHouseOfLeaves = false
		local players = FLOPPY_DISK:GetPlayers()
		local floppyDiskMult = 0
		for i=1,#players,1 do
			if players[i]:ToPlayer():HasTrinket(Isaac.GetTrinketIdByName("Floppy Disk")) then
				floppyDiskMult = floppyDiskMult + (2 * players[i]:ToPlayer():GetTrinketMultiplier(Isaac.GetTrinketIdByName("Floppy Disk")))

				doesSomeoneHaveHouseOfLeaves = true
				if players[i]:ToPlayer():GetData().botbGotTheirMyBasementShit2 == true then
					--Game().Challenge = Isaac.GetChallengeIdByName("[BOTB] MyBasement.lua")
				end
	
			end
		end
		if not doesSomeoneHaveHouseOfLeaves then return end
		--equation: -(1/((0.5*floppyDiskMult)+1))+1
		if math.random() <= -0.25*(1/((0.5*floppyDiskMult)+1))+1 then
			--animate everyone that has floppy disk, make sure to animate right for ones that are gold
			for i=1,#players,1 do
				if players[i]:ToPlayer():HasTrinket(Isaac.GetTrinketIdByName("Floppy Disk")) then
					players[i]:ToPlayer():AnimateTrinket(Isaac.GetTrinketIdByName("Floppy Disk"))
				end
				if players[i]:ToPlayer():HasTrinket(Isaac.GetTrinketIdByName("Floppy Disk")+TrinketType.TRINKET_GOLDEN_FLAG) then
					players[i]:ToPlayer():AnimateTrinket(Isaac.GetTrinketIdByName("Floppy Disk")+TrinketType.TRINKET_GOLDEN_FLAG)
				end
			end
			--spawn the portal
			local houseOfLeavesPortal = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.PORTAL_TELEPORT, 3, Isaac.GetFreeNearPosition(Game():GetRoom():GetCenterPos(), 10), Vector.Zero, nil)
			SFXManager():Play(BotB.Enums.SFX.GLITCHY_BOOM,1,0,false,math.random(125,150)/100)

		end

	end
	Mod:AddCallback(TSIL.Enums.CustomCallback.POST_ROOM_CLEAR_CHANGED, FLOPPY_DISK.onRoomClear, true)