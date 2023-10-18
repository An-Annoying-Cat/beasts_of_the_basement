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
	
	}
	
	StageAPI.AddBossToBaseFloorPool({BossID = "Despair", Weight = 1}, LevelStage.STAGE1_1, StageType.STAGETYPE_WOTL)

end