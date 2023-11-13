local Mod = BotB
local StageAPI = Mod.StageAPI

if StageAPI and StageAPI.Loaded then

	--#region Background
	Mod.Backdrop = {

		HoarderBasement = StageAPI.BackdropHelper({
			Walls = {"1", "2_mold"},
			--NFloors = {"nfloor"},
			--LFloors = {"lfloor"},
			--Corners = {"corner"}
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
		--Mod.HoarderBasementGrid:SetPits("gfx/grid/pit_hoarderbasement.png")

	--#endregion
	Mod.HoarderBasementGrid = StageAPI.GridGfx()
		Mod.HoarderBasementGrid:SetRocks("gfx/grid/rocks_hoarderbasement.png")
		--Mod.HoarderBasementGrid:SetPits("gfx/grid/pit_hoarderbasement.png")
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
			"hoard_test"
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


end