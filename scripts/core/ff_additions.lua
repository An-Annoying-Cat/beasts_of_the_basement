local Mod = BotB

--#region Consumables
Mod.Functions.Tables:AddToDictionary(Mod.FF.PocketObjects,
{
    [BotB.Enums.Consumables.OBJECTS.WHITE_DRAGON] = true,
    [BotB.Enums.Consumables.OBJECTS.RED_DRAGON] = true,
    [BotB.Enums.Consumables.OBJECTS.GREEN_DRAGON] = true,
    [BotB.Enums.Consumables.OBJECTS.ONE_DOT] = true,
    [BotB.Enums.Consumables.OBJECTS.ONE_BAM] = true,
    [BotB.Enums.Consumables.OBJECTS.ONE_CRAK] = true,
    [BotB.Enums.Consumables.OBJECTS.NINE_DOT] = true,
    [BotB.Enums.Consumables.OBJECTS.NINE_BAM] = true,
    [BotB.Enums.Consumables.OBJECTS.NINE_CRAK] = true,
})

--#endregion


--#region Backdrops

--adds it to the end of the ff roomBackdropTable, which replaces grids based on the subtype of the
--background replacer, entity 150.1000. we start at subtype 13 (subtype is needed to add to basement renovator)
Mod.Functions.Tables:AddToDictionary(Mod.FF.roomBackdropTable,
{
    [13] = Mod.HoarderBasementBackdrop,
})

--this is so they get added to void
--we start at 30
Mod.Functions.Tables:AddToDictionary(Mod.FF.FloorGrids,
{
    [30] = Mod.HoarderBasementGrid,
})

--#endregion

