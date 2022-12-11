local Mod = BotB
local StageAPI = Mod.StageAPI

if StageAPI and StageAPI.Loaded then

	--#region Background
	Mod.Backdrop = {

		--[[
		HoarderBasement = StageAPI.BackdropHelper({
			Walls = {"1", "2_mold"},
			NFloors = {"nfloor"},
			LFloors = {"lfloor"},
			Corners = {"corner"}
		}, "gfx/backdrop/hoarderbasement", ".png"),
		]]
	}
	--#endregion

	--#region Grids
	Mod.HoarderBasement = StageAPI.GridGfx()
		Mod.HoarderBasementGrid:SetRocks("gfx/grid/rocks_hoardbasement.png")
		--Mod.HoarderBasementGrid:SetPits("gfx/grid/pit_hoard.png")

	--#endregion

	--#region Backdrop
	Mod.HoarderBasementBackdrop = StageAPI.RoomGfx(nil, Mod.HoarderBasementGrid, nil, nil)

	--#endregion

end