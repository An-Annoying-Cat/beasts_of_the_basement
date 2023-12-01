local Mod = BotB

local json = require("json")

local BotBSaveData = {}

--BotB.SavedData = BotBSaveData
--

  --[[
  function Mod:preGameExit()
    print("attempting to save data...")
    TSIL.SaveManager.SaveToDisk()
  end
  
  Mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, BotB.preGameExit)

  function BotB:OnGameStart(isSave)
    --Loading Moddata--
    TSIL.SaveManager.LoadFromDisk()
    if TSIL.SaveManager.GetPersistentVariable(BotB, "useNewWormSprites") == nil then
        print("it was nil")
        TSIL.SaveManager.AddPersistentVariable(BotB,"useNewWormSprites",true,TSIL.Enums.VariablePersistenceMode.NONE,true)
    else
        print("it SHOULD be something")
        TSIL.SaveManager.SetPersistentVariable(BotB,"useNewWormSprites", TSIL.SaveManager.GetPersistentVariable(BotB, "useNewWormSprites"))
    end
end
BotB:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, BotB.OnGameStart)]]

--PERSISTENT BOTB VARIABLES
--[[
if TSIL.SaveManager.GetPersistentVariable(BotB, "useNewWormSprites") == nil then
    print("it was nil. f")
    TSIL.SaveManager.AddPersistentVariable(BotB,"useNewWormSprites",true,TSIL.Enums.VariablePersistenceMode.NONE,true)
else
    print("it SHOULD be something")
    TSIL.SaveManager.SetPersistentVariable(BotB,"useNewWormSprites", TSIL.SaveManager.GetPersistentVariable(BotB, "useNewWormSprites"))
end]]
TSIL.SaveManager.AddPersistentVariable(BotB,"useNewWormSprites",true,TSIL.Enums.VariablePersistenceMode.NONE,true)

function BotB:wormSpriteCMD(cmd, params)
    if cmd ~= "botb_usenewwormsprite" then return end
    if cmd == "botb_usenewwormsprite" then
        if params == "true" then
            if TSIL.SaveManager.GetPersistentVariable(BotB, "useNewWormSprites") ~= true then
                TSIL.SaveManager.SetPersistentVariable(BotB,"useNewWormSprites", true)
            end
            print("Using new worm sprites")
        end
        if params == "false" then
            if TSIL.SaveManager.GetPersistentVariable(BotB, "useNewWormSprites") ~= false then
                TSIL.SaveManager.SetPersistentVariable(BotB,"useNewWormSprites", false)
            end
            print("Using old worm sprites")
        end
    end
end
Mod:AddCallback(ModCallbacks.MC_EXECUTE_CMD, BotB.wormSpriteCMD)

function BotB:saveDataListCMD(cmd, params)
    if not cmd == "botbdata" then return end
    
    if cmd == "botbdata" then
        if TSIL.SaveManager.GetPersistentVariable(BotB, "useNewWormSprites") == true then
            print("use new worm sprites: true")
        elseif TSIL.SaveManager.GetPersistentVariable(BotB, "useNewWormSprites") == false then
            print("use new worm sprites: false")
        else
            print("use new worm sprites: other")
        end
        

    end
end
Mod:AddCallback(ModCallbacks.MC_EXECUTE_CMD, BotB.saveDataListCMD)

function BotB:helpCMD(cmd, params)
    if cmd ~= "botbhelp" then return end
    if cmd == "botbhelp" then
        print("Current commands:")
        print("botbdata - Iterates over each savedata code in BotB's save data and prints it")
        print("lunacy - Inflicts every vulnerable enemy in the room with Lunacy for testing purposes.")
        print("glitched - Inflicts every vulnerable enemy in the room with Glitched for testing purposes.")
        print("searchtest - iterates over room spawn entries and prints their names. does not seem to work properly on Modded floors")
        print("wrath - currently commented out in ehehe.lua, basically my shitty attempt at making a Pizza Time-esque feature, not balanced in the slightest and really buggy")
        print("botb_usenewwormsprite [true/false] - switches the sprites for Inch Worms and Meal Worms to the newer ones done by Moofy")
    end
end
Mod:AddCallback(ModCallbacks.MC_EXECUTE_CMD, BotB.helpCMD)

function BotB:saveDataListCMD(cmd, params)
    if not cmd == "botbdata" then return end
    
    if cmd == "botbdata" then
        if TSIL.SaveManager.GetPersistentVariable(BotB, "useNewWormSprites") == true then
            print("use new worm sprites: true")
        elseif TSIL.SaveManager.GetPersistentVariable(BotB, "useNewWormSprites") == false then
            print("use new worm sprites: false")
        else
            print("use new worm sprites: other")
        end
        

    end
end
Mod:AddCallback(ModCallbacks.MC_EXECUTE_CMD, BotB.saveDataListCMD)


--[[
How to divvy up save data:

BotB.SavedData.Persistent -
    This stays between runs. Hypothetically it should be used for things like unlocks and Mod config.

BotB.SavedData.CurrentRun -
    This is for the current run only. 
    Essentially, keeping stuff like player data, i.e. jezebel's overheal buff, stored so runs can actually be continued.

]]


function BotB:wormSpriteCMD(cmd, params)
    if cmd ~= "botb_usenewwormsprite" then return end
    if cmd == "botb_usenewwormsprite" then
        if params == "true" then
            if TSIL.SaveManager.GetPersistentVariable(BotB, "useNewWormSprites") ~= true then
                TSIL.SaveManager.SetPersistentVariable(BotB,"useNewWormSprites", true)
            end
            print("Using new worm sprites")
        end
        if params == "false" then
            if TSIL.SaveManager.GetPersistentVariable(BotB, "useNewWormSprites") ~= false then
                TSIL.SaveManager.SetPersistentVariable(BotB,"useNewWormSprites", false)
            end
            print("Using old worm sprites")
        end
    end
end
Mod:AddCallback(ModCallbacks.MC_EXECUTE_CMD, BotB.wormSpriteCMD)