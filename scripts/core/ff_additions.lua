local Mod = BotB
local ret = Retribution
local FF_ADDITIONS = {}
local Tables = {}

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


--Fuzzy Pickle

--- Adds contents of tab2 to tab1
---@param tab1 any[]
---@param tab2 any[]
function Tables:AppendTable(tab1, tab2)
	for _,v in pairs(tab2) do
		table.insert(tab1, v)
	end
end

--
if FiendFolio.ReferenceItems then
    local BotBActiveReferences = {
        {ID = BotB.Enums.Items.FIFTY_SHADES, 			Reference = "Fifty Shades Of Grey"},
        {ID = BotB.Enums.Items.THE_DSM, 			Reference = "Psychology, Four Voices Expansion"},
        {ID = BotB.Enums.Items.ENLIGHTENMENT, 			Reference = "Rain World: Downpour"},
    }
    local BotBPassiveReferences = {
        {ID = BotB.Enums.Items.ALPHA_ARMOR, 			Reference = "Minecraft Alphaver"},
        {ID = BotB.Enums.Items.ONYXMARBLE, 			Reference = "Enigma, Oxyd"},
        {ID = BotB.Enums.Items.TOY_HELICOPTER, 			Reference = "Henry Stickmin"},
        {ID = BotB.Enums.Items.ATOMBOMBBABY, 			Reference = "The Five Stars"},
        {ID = BotB.Enums.Items.BHF, 			Reference = "The Binding Of Isaac: Revelations"},
        {ID = BotB.Enums.Items.LIQUID_LATEX, 			Reference = "Changed"},
        {ID = BotB.Enums.Items.CROWBAR, 			Reference = "Risk Of Rain 2"},
        {ID = BotB.Enums.Items.CHAMPS_MASK, 			Reference = "Brutal Orchestra"},
        {ID = BotB.Enums.Items.THE_HUMAN_SOUL, 			Reference = "Brutal Orchestra"},
    }
    local BotBTrinketReferences = {
        {ID = BotB.Enums.Trinkets.DEMON_CORE, 			Reference = "Brutal Orchestra"},
        {ID = BotB.Enums.Trinkets.FLASHCART, 			Reference = "Video Game Piracy"},
        {ID = BotB.Enums.Trinkets.IDOL_OF_MOLECH, 			Reference = "the Book of Leviticus"},
    }
    local BotBStackables = {
        BotB.Enums.Items.PLACEHOLDER_ITEM,
        BotB.Enums.Items.ROBOBABYZERO,
        BotB.Enums.Items.ATOMBOMBBABY,
        BotB.Enums.Items.BHF,
        BotB.Enums.Items.GRUB,
        BotB.Enums.Items.MUD_PIE,
        BotB.Enums.Items.HOUSEPLANT,
        BotB.Enums.Items.LUCKY_LIGHTER,
        BotB.Enums.Items.CROWBAR,
    }
    local BotBRockTrinkets = {
        [BotB.Enums.Trinkets.LITHOPEDION]           = 0,
    }

    Tables:AppendTable(FiendFolio.ReferenceItems.Actives, BotBActiveReferences)
    Tables:AppendTable(FiendFolio.ReferenceItems.Passives, BotBPassiveReferences)
    Tables:AppendTable(FiendFolio.ReferenceItems.Trinkets, BotBTrinketReferences)
    Tables:AppendTable(FiendFolio.RockTrinkets, BotBRockTrinkets)
    FiendFolio:AddStackableItems({
        BotB.Enums.Items.PLACEHOLDER_ITEM,
        BotB.Enums.Items.ROBOBABYZERO,
        BotB.Enums.Items.ATOMBOMBBABY,
        BotB.Enums.Items.BHF,
        BotB.Enums.Items.GRUB,
        BotB.Enums.Items.MUD_PIE,
        BotB.Enums.Items.HOUSEPLANT,
        BotB.Enums.Items.LUCKY_LIGHTER,
        BotB.Enums.Items.CROWBAR,
    })
end

function FF_ADDITIONS:FFCompat()
--References

end
--Rock Trinkets
--ret.BulkAppend(, )

--Stackables

--TSIL.AddVanillaCallback(BotB, ModCallbacks.MC_POST_GAME_STARTED, FF_ADDITIONS.FFCompat,CallbackPriority.LATE)
Mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, FF_ADDITIONS.FFCompat)




--Pinprick aint fixed so I'm doing it myself
--ret.ENEMIES.PINPRICK.TYPE, ret.ENEMIES.PINPRICK.VARIANT
--[[
function FF_ADDITIONS:pinprickBulletCheck(bullet)
    local sprite = bullet:GetSprite()
    --Invisible intangible projectile that handles the slow laser
    if bullet.SpawnerEntity.Type == 255 and bullet.SpawnerEntity.Variant == 1873 then

        --if bullet:GetData().botbGeoHorfNewLaserCountdown == nil then
        --    bullet:GetData().botbGeoHorfNewLaserCountdown = -1
        --end

        if EntityRef(bullet.SpawnerEntity).IsFriendly or EntityRef(bullet.SpawnerEntity).IsCharmed then
            --print("get converted dumbass")
            bullet.SpawnerEntity:ToNPC():Morph(666, 101, 0, 0)
            
        end
        
        


      end
    

end

Mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_INIT, FF_ADDITIONS.pinprickBulletCheck)
]]