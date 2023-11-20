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
    [14] = Mod.SlotRoomBackdrop,
    [15] = Mod.CrystalMinesBackdrop,
})

--this is so they get added to void
--we start at 30
Mod.Functions.Tables:AddToDictionary(Mod.FF.FloorGrids,
{
    [30] = Mod.HoarderBasementGrid,
    [31] = Mod.SlotRoomGrid,
    [32] = Mod.CrystalMinesGrid,
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
        {ID = BotB.Enums.Items.FIFTY_SHADES, 		       	Reference = "Fifty Shades Of Grey"},
        {ID = BotB.Enums.Items.THE_DSM, 			        Reference = "Psychology, Four Voices Expansion"},
        {ID = BotB.Enums.Items.ENLIGHTENMENT, 		    	Reference = "Rain World: Downpour"},
        {ID = BotB.Enums.Items.BLOOD_MERIDIAN, 		    	Reference = "Blood Meridian"},
        {ID = BotB.Enums.Items.HOUSE_OF_LEAVES, 			Reference = "House Of Leaves"},
        {ID = BotB.Enums.Items.TRIGGER_BUTTON, 		    	Reference = "Edmund McMillen's old blog"},
        {ID = BotB.Enums.Items.EMETER_COLLECTIBLE, 			Reference = "Edmund McMillen's old blog"},
        {ID = BotB.Enums.Items.EMETER_IN, 			        Reference = "Edmund McMillen's old blog"},
        {ID = BotB.Enums.Items.EMETER_OUT, 		        	Reference = "Edmund McMillen's old blog"},
        {ID = BotB.Enums.Items.TOY_PHONE, 		        	Reference = "Skinimarink"},
        {ID = BotB.Enums.Items.TOY_PHONE_ALT, 		        Reference = "Skinimarink"},
        {ID = BotB.Enums.Items.DUSTY_D6, 		            Reference = "Flash Isaac", Partial = true},
        {ID = BotB.Enums.Items.DUSTY_D100, 		            Reference = "The Binding Of Isaac: Rebirth"},
        {ID = BotB.Enums.Items.DEAD_DAISY, 		            Reference = "Petscop"},
    }
    local BotBPassiveReferences = {
        {ID = BotB.Enums.Items.ALPHA_ARMOR, 		    	Reference = "Minecraft Alphaver"},
        {ID = BotB.Enums.Items.ONYXMARBLE, 		        	Reference = "Enigma, Oxyd"},
        {ID = BotB.Enums.Items.TOY_HELICOPTER, 		    	Reference = "Henry Stickmin"},
        {ID = BotB.Enums.Items.ATOMBOMBBABY, 		    	Reference = "The Five Stars, Fallout"},
        {ID = BotB.Enums.Items.BHF, 			            Reference = "The Binding Of Isaac: Revelations"},
        {ID = BotB.Enums.Items.LIQUID_LATEX, 		    	Reference = "Changed"},
        {ID = BotB.Enums.Items.CROWBAR, 			        Reference = "Risk Of Rain 2"},
        {ID = BotB.Enums.Items.CHAMPS_MASK, 		    	Reference = "Brutal Orchestra"},
        {ID = BotB.Enums.Items.THE_HUMAN_SOUL, 		    	Reference = "Brutal Orchestra"},
        {ID = BotB.Enums.Items.QUICKLOVE, 		        	Reference = "The Void Rains Upon Her Heart"},
        {ID = BotB.Enums.Items.STARLIGHT, 		        	Reference = "The Void Rains Upon Her Heart"},
        {ID = BotB.Enums.Items.PALE_BOX, 		        	Reference = "The Void Rains Upon Her Heart"},
        {ID = BotB.Enums.Items.LUCKY_FLOWER, 		    	Reference = "The Void Rains Upon Her Heart"},
        {ID = BotB.Enums.Items.FUCK_THAT_NOISE, 			Reference = "Newgrounds", Partial = true},
        {ID = BotB.Enums.Items.HEALTHY_SNACK, 			    Reference = "Edmund McMillen's old blog"},
        {ID = BotB.Enums.Items.LIL_ARI, 			        Reference = "Voices of the Void"},
        {ID = BotB.Enums.Items.FADED_NOTE, 			        Reference = "hfjONE"},
        {ID = BotB.Enums.Items.BUZZ_FLY, 			        Reference = "Chainsaw Man", Partial = true},
        {ID = BotB.Enums.Items.FLIPPED_NOTE, 			    Reference = "Flipnote Studio"},
        {ID = BotB.Enums.Items.PANDEMONIUM, 			    Reference = "The Myriad", Partial = true},
        {ID = BotB.Enums.Items.IMMORTAL_BABY, 			    Reference = "Brutal Orchestra"},
        {ID = BotB.Enums.Items.DIVINE_MUD, 			        Reference = "Brutal Orchestra"},
        {ID = BotB.Enums.Items.RABIES, 			            Reference = "BUGGERWORLD"},
        {ID = BotB.Enums.Items.STRANGE_STARS, 			    Reference = "Copy Kitty"},
        {ID = BotB.Enums.Items.COIN_OF_JUDGEMENT, 			Reference = "Fear & Hunger"},
        {ID = BotB.Enums.Items.CURSE_OF_JUSTICE, 			Reference = "Justice (the band)"},
        {ID = BotB.Enums.Items.THRONE, 			            Reference = "Local58"},
    }
    local BotBTrinketReferences = {
        {ID = BotB.Enums.Trinkets.DEMON_CORE, 			    Reference = "Brutal Orchestra"},
        {ID = BotB.Enums.Trinkets.FLASHCART, 		    	Reference = "Video Game Piracy"},
        {ID = BotB.Enums.Trinkets.IDOL_OF_MOLECH, 			Reference = "the Book of Leviticus"},
        {ID = BotB.Enums.Trinkets.FLOPPY_DISK, 			    Reference = "MyHouse.wad"},
        {ID = BotB.Enums.Trinkets.BLANK_WHITE_CARD, 		Reference = "1000 Blank White Cards"},
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
    --[[
    local BotBRockTrinkets = {
        [BotB.Enums.Trinkets.LITHOPEDION]           = 0,
    }]]

    Tables:AppendTable(FiendFolio.ReferenceItems.Actives, BotBActiveReferences)
    Tables:AppendTable(FiendFolio.ReferenceItems.Passives, BotBPassiveReferences)
    Tables:AppendTable(FiendFolio.ReferenceItems.Trinkets, BotBTrinketReferences)
    --Tables:AppendTable(FiendFolio.RockTrinkets, BotBRockTrinkets)
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