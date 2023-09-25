--yoinked from FF, credit to them

BotB.ACHIEVEMENT = {
	-- Order of this table determines order of button appearance in menu

	-- To-do unlocks
	--[[
		Community Rocks:    Beat Challenge #FF_ - The Gauntlet
	]]

	{
		ID = "FIENDISH_FOES",
		AlwaysUnlocked = true,
		Note = "fiendish_foes",
		Tags = {"Misc"},
		NoInsertTags = {"Misc"},
		Tooltip = {"thank you", "for playing", "our mod"}
	},

	-- Character Unlocks
	{
		ID = "JEZEBEL",
		AlwaysUnlocked = true,
		Note = "achievement_jezebel",
		Name = "jezebel",
		Tags = {"Jezebel"},
		NoInsertTags = {"Jezebel"},
		Tooltip = {"2 kings", "9:30-37", "nkjv"}
	},
	{
		ID = "SOLOMON",
		AlwaysUnlocked = true,
		Note = "achievement_solomon",
		Name = "solomon",
		Tags = {"Solomon"},
		NoInsertTags = {"Solomon"},
		Tooltip = {"1 kings", "4:33", "niv"}
	},

	-- Solomon Unlocks
	{
		ID = "TOY_CHEST",
		Note = "toy_chest",
		Tooltip = {"beat", "mom", "as solomon"},
		Tags = {"Solomon", "Character"}
	},
	{
		ID = "LIL_FIEND",
		Note = "lil_fiend",
		Item = FiendFolio.ITEM.COLLECTIBLE.LIL_FIEND,
		Tooltip = {"beat", "mom's heart", "on hard", "as fiend"},
		CompletionMark = {FiendFolio.PLAYER.FIEND, "Heart"},
		Tags = {"Fiend", "Character"}
	},
}

