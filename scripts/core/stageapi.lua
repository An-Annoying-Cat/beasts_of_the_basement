local Mod = BotB
local StageAPI = Mod.StageAPI
local game = Game()

if StageAPI and StageAPI.Loaded then

	--#region Background
	Mod.Backdrop = {

		HoarderBasement = StageAPI.BackdropHelper({
			Walls = {"0"},
			NFloors = {"nfloors"},
			LFloors = {"lfloor"},
			Corners = {"innercorner"}
		}, "gfx/backdrop/hoarderbasement_", ".png"),

		HoarderBasement_v1 = StageAPI.BackdropHelper({
			Walls = {"0"},
			NFloors = {"nfloors"},
			LFloors = {"lfloor"},
			Corners = {"innercorner"}
		}, "gfx/backdrop/hoarderbasement_", ".png"),

		HoarderBasement_v2 = StageAPI.BackdropHelper({
			Walls = {"1"},
			NFloors = {"nfloors"},
			LFloors = {"lfloor"},
			Corners = {"innercorner"}
		}, "gfx/backdrop/hoarderbasement_", ".png"),

		HoarderBasement_v3 = StageAPI.BackdropHelper({
			Walls = {"2"},
			NFloors = {"nfloors"},
			LFloors = {"lfloor"},
			Corners = {"innercorner"}
		}, "gfx/backdrop/hoarderbasement_", ".png"),

		HoarderBasement_v4 = StageAPI.BackdropHelper({
			Walls = {"3"},
			NFloors = {"nfloors"},
			LFloors = {"lfloor"},
			Corners = {"innercorner"}
		}, "gfx/backdrop/hoarderbasement_", ".png"),

		SlotRoom = StageAPI.BackdropHelper({
			Walls = {"1", "2_paper","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1",},
			--NFloors = {"nfloor"},
			--LFloors = {"lfloor"},
			--Corners = {"corner"}
		}, "gfx/backdrop/slotroom_", ".png"),
		--
		CrystalMines = StageAPI.BackdropHelper({
			Walls = {"wall1", "wall1"},
			NFloors = {"nfloor"},
			LFloors = {"lfloor"},
			Corners = {"corner"}
		}, "gfx/backdrop/crystal_", ".png"),
	}
	--#endregion

	



	--#region Grids
	Mod.HoarderBasementGrid = StageAPI.GridGfx()
		Mod.HoarderBasementGrid:SetRocks("gfx/grid/rocks_hoarderbasement.png")
		Mod.HoarderBasementGrid:SetPits("gfx/grid/pit_hoarderbasement.png", "gfx/grid/pit_hoarderbasement.png", true)
		Mod.HoarderBasementGrid:SetDecorations("gfx/grid/hoard_props.png", "gfx/grid/hoard_props.anm2", 37)
		Mod.HoarderBasementGrid:AddDoors("gfx/grid/door_01_hoard.png", StageAPI.DefaultDoorSpawn)

	--#endregion
	--[[
	Mod.HoarderBasementGrid = StageAPI.GridGfx()
		Mod.HoarderBasementGrid:SetRocks("gfx/grid/rocks_hoarderbasement.png")
		--Mod.HoarderBasementGrid:SetPits("gfx/grid/pit_hoarderbasement.png")]]
	--#region Backdrop
	Mod.HoarderBasementBackdrop = StageAPI.RoomGfx(Mod.Backdrop.HoarderBasement, Mod.HoarderBasementGrid, nil, nil)

	Mod.SlotRoomGrid = StageAPI.GridGfx()
		Mod.SlotRoomGrid:SetRocks("gfx/grid/rocks_slotroom.png")
		--Mod.HoarderBasementGrid:SetPits("gfx/grid/pit_hoarderbasement.png")

	--#endregion

	--#region Backdrop
	Mod.SlotRoomBackdrop = StageAPI.RoomGfx(Mod.Backdrop.SlotRoom, Mod.SlotRoomGrid, nil, nil)
	--
	Mod.CrystalMinesGrid = StageAPI.GridGfx()
		Mod.CrystalMinesGrid:SetRocks("gfx/grid/rocks_crystal.png")
		Mod.CrystalMinesGrid:SetPits("gfx/grid/pit_crystal.png")

	--#endregion

	--#region Backdrop
	Mod.CrystalMinesBackdrop = StageAPI.RoomGfx(Mod.Backdrop.CrystalMines, Mod.CrystalMinesGrid, nil, nil)

	--#endregion

	--
	Mod.StageAPIBosses = {
		StageAPI.AddBossData("Despair", {
			Name = "Despair",
			Portrait = "gfx/bosses/despair/despair_portrait_placeholder.png",
			Bossname = "gfx/bosses/despair/bossname_despair.png",
			Horseman = true,
			Rooms = StageAPI.RoomsList("DespairBossRooms", include("resources.luarooms.bosses.boss_despair"))
		}),

		StageAPI.AddBossData("Queenie", {
			Name = "Queenie",
			Portrait = "gfx/bosses/queenie/despair_portrait.png",
			Bossname = "gfx/bosses/queenie/bossname_queenie.png",
			Rooms = StageAPI.RoomsList("QueenieBossRooms", include("resources.luarooms.bosses.boss_queenie"))
		}),

		StageAPI.AddBossData("Mucus Monstro", {
			Name = "Mucus Monstro",
			Portrait = "gfx/bosses/mucus_monstro/mucus_monstro_portrait.png",
			Bossname = "gfx/bosses/mucus_monstro/bossname_mucus_monstro.png",
			Rooms = StageAPI.RoomsList("MucusMonstroBossRooms", include("resources.luarooms.bosses.boss_mucus_monstro"))
		}),
	
	}
	
	StageAPI.AddBossToBaseFloorPool({BossID = "Despair", Weight = 1}, LevelStage.STAGE1_1, StageType.STAGETYPE_WOTL)
	--StageAPI.AddBossToBaseFloorPool({BossID = "Mucus Monstro", Weight = 99999}, LevelStage.STAGE1_1, StageType.STAGETYPE_ORIGINAL)



	--Hoard Level

	BotB.HoardRooms = {
		RoomFiles = {
			"hoard"
		}
	}

	BotB.HoardRoomlist = {}

	for _, roomName in ipairs(BotB.HoardRooms.RoomFiles) do
		BotB.HoardRooms.RoomFiles[roomName] = require("resources.luarooms." .. roomName)
		BotB.HoardRoomlist[#BotB.HoardRoomlist + 1] = BotB.HoardRooms.RoomFiles[roomName]
	end

	local HoardRoomsReal = StageAPI.RoomsList("Rooms", table.unpack(BotB.HoardRoomlist))

	local HoardBosses = {
	"Queenie",
	"Mucus Monstro",
	}

	BotB.Hoard = StageAPI.CustomStage("Hoard")
	BotB.Hoard:SetRoomGfx(Mod.HoarderBasementBackdrop, {RoomType.ROOM_DEFAULT, RoomType.ROOM_TREASURE, RoomType.ROOM_MINIBOSS, RoomType.ROOM_BOSS})
	BotB.Hoard:SetMusic(Isaac.GetMusicIdByName("Hoard"), {RoomType.ROOM_DEFAULT})
	BotB.Hoard:SetRooms(HoardRoomsReal)
	BotB.Hoard:SetBosses(HoardBosses)

	--print("lord help us all")

	StageAPI.AddCallback("Beasts of the Basement", "PRE_CHANGE_ROOM_GFX", 1, function(currentRoom, usingGfx, onRoomLoad, currentDimension)
		--print("Checking the thing")
		if StageAPI.GetCurrentStage().Name == "Hoard" then
			if game:GetRoom():IsFirstVisit() then
				--print("stage is right. randomize the bg")
				local hoardRoomRandomBackdrops = { Mod.Backdrop.HoarderBasement_v1, Mod.Backdrop.HoarderBasement_v2, Mod.Backdrop.HoarderBasement_v3, Mod.Backdrop.HoarderBasement_v4,}
				local chosenHoardBackdrop = hoardRoomRandomBackdrops[math.random(1,#hoardRoomRandomBackdrops)]
				return StageAPI.RoomGfx(chosenHoardBackdrop, Mod.HoarderBasementGrid)
			end
		end
	end)


end

function BotB:makeMucusMonstro(npc)
    if npc.Variant == 106 then
        local spawnedSkuzz = Isaac.Spawn(20, 0, 3, npc.Position, Vector.Zero, npc):ToNPC()
        npc:Remove() 
    end
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, BotB.makeMucusMonstro, 501)