local Mod = BotB
local BOTB_MENUCHANGES = {}
local isInBestiaryExtension = false
local xmlTestCounter = 0
local bestiaryExtensionTestString = 0
local bestiaryExtensionSelectedEntry = ""

--[[
function BOTB_MENUCHANGES:populateBestiaryExtension(animpath)
    local returnedEntry = XMLData.GetEntryById(XMLNode.ENTITY, 1)
    local entry = XMLData.GetEntryById(XMLNode.ENTITY, i)
        for key, value in pairs(entry) do
            print(key, value)
        end
    --return returnedEntry
end]]

function BOTB_MENUCHANGES:testEntityXMLRead(id)
    local entry = XMLData.GetEntryById(XMLNode.ENTITY, id)
    for key, value in pairs(entry) do
        print(key, value)
    end
end

function BOTB_MENUCHANGES:getTheWholeFuckingEntityTable()
    local theWholeFuckingTable = {}
    for i=1, XMLData.GetNumEntries(XMLNode.ENTITY) do
        theWholeFuckingTable[i] = XMLData.GetEntryById(XMLNode.ENTITY, i)
    end
    --print(#theWholeFuckingTable)
    return theWholeFuckingTable
end

local botbBestiaryEntryNameBlacklist = {
    "Frozen Enemy",
    "Psychic Gaper",
    "Wall Gaper",
}

function BOTB_MENUCHANGES:getExtensionEntryString(str)
    local shouldUpdateSelected = true
    if str ~= nil then
        for i=1, #botbBestiaryEntryNameBlacklist, 1 do
            if str == botbBestiaryEntryNameBlacklist[i] then
                shouldUpdateSelected = false
            end
        end
    end
    if shouldUpdateSelected then
        bestiaryExtensionSelectedEntry = str
        print("selected " .. bestiaryExtensionSelectedEntry)
    end
end

function BOTB_MENUCHANGES:populateBestiaryExtension(animpath)
    local theEntireGoddamnTable = BOTB_MENUCHANGES:getTheWholeFuckingEntityTable()
    local selectedEntry = nil
    for key, value in pairs(theEntireGoddamnTable) do
        if key ~= nil and value ~= nil and type(value) == "table" then --and value.anm2path == animpath then
            local fuckshit = EntityConfig.GetEntity(value.id, value.variant, tonumber(value.subtype))
            if fuckshit:GetBestiaryAnm2Path() ~= nil and #fuckshit:GetBestiaryAnm2Path() > 0 then
                if fuckshit:GetBestiaryAnm2Path() == animpath then
                    SFXManager():Play(BotB.Enums.SFX.FURSUIT_MEOW,5,0,false,1,0)
                    selectedEntry = value
                        



                    BOTB_MENUCHANGES:getExtensionEntryString(selectedEntry.name)




                end
            else
                if fuckshit:GetAnm2Path() == animpath then
                    SFXManager():Play(Isaac.GetSoundIdByName("FunnyFart"),5,0,false,1,0)
                    selectedEntry = value
                    
                    
                    

                    BOTB_MENUCHANGES:getExtensionEntryString(selectedEntry.name)




                end
            end
        end
    end
    

    return selectedEntry
end

local extendedBestiaryDict = {
    ["Frowning Gaper"] = {
        desc = "Chases the player. Will eventually open its eyes \n and chase the player slightly more quickly."
    },
    ["Gaper"] = {
        desc = "Chases after the player, dealing damage upon contact."
    },
    ["Flaming Gaper"] = {
        desc = "why he on fuckin fire"
    },
}

function BOTB_MENUCHANGES:RenderExtendedBestiary(entry)
    local chosenName = ""
    local drawString = ""
    local doNoData = true
    for key, value in pairs(extendedBestiaryDict) do

        if key == entry then
            doNoData = false
            chosenName = key
            drawString = value.desc
            print(value.desc)
        end

    end
    --
    if doNoData then
        drawString = "No data found."
    end

    local f3 = Font() -- init font object
        f3:Load("font/teammeatfont16bold.fnt")
        --BOTB_MENUCHANGES:testEntityXMLRead(xmlTestCounter)
        local drawNameVector = MenuManager.GetViewPosition()+Vector(-240,2048)+Vector(-210,-65)
        f3:DrawString(chosenName,drawNameVector.X,drawNameVector.Y,KColor(0,0,0,0.6,0,0,0),0,false) -- render string with loaded font on position 60x50y

    local f2 = Font() -- init font object
        f2:Load("font/luamini.fnt")
        --BOTB_MENUCHANGES:testEntityXMLRead(xmlTestCounter)
        local drawDescVector = MenuManager.GetViewPosition()+Vector(-240,2048)+Vector(-210,-20)
        f2:DrawString(drawString,drawDescVector.X,drawDescVector.Y,KColor(0,0,0,0.6,0,0,0),0,false) -- render string with loaded font on position 60x50y
end

local baseBestiaryView = Vector(0,0)
function BOTB_MENUCHANGES:menuChangesTest()
    local viewPos = Vector(0,0)
    local drawPos = Vector(0,0)
    local targetViewVector = Vector(0,0)
    --print("yodelayeehoo or whatever")
    --base vector is 533.5, -1633

    local extPage1 = Sprite("gfx/ui/mainmenu/botb_sketches.anm2", true)
    extPage1:Play("Page", true)
    extPage1:Render(MenuManager.GetViewPosition()+Vector(-240,2048))

    if MenuManager.GetActiveMenu() == MainMenuType.BESTIARY then
        --print(BestiaryMenu.GetBestiaryMenuSprite())
        --XMLData.GetEntryByName(XMLNode.ENTITY, Name)
        --print(BestiaryMenu.GetBestiaryMenuSprite():GetFilename())
        --print(MenuManager.GetViewPosition())
        if Input.IsActionTriggered(ButtonAction.ACTION_DROP, 0)  then
            SFXManager():Play(BotB.Enums.SFX.FURSUIT_MEOW,5,0,false,1,0)
            if isInBestiaryExtension == false then
                isInBestiaryExtension = true
            else
                isInBestiaryExtension = false
            end
        end
        if isInBestiaryExtension ~= true then
            baseBestiaryView = MenuManager.GetViewPosition()
        end

        if isInBestiaryExtension == true then
            --targetViewVector = Vector(533.5, (-1633)-512)
            MenuManager.SetViewPosition(baseBestiaryView - Vector(0,256))
        else
            
           --MenuManager.SetViewPosition(Vector(533.5, -1633))
        end

        --MenuManager.SetViewPosition((   0.8 * MenuManager.GetViewPosition()   ) + (  0.2 * targetViewVector ))
        
    else
        isInBestiaryExtension = false
        --targetViewVector = Vector(0,0)
    end
    
    

    if bestiaryExtensionTestString ~= BestiaryMenu.GetSelectedElement() then
        bestiaryExtensionTestString = BestiaryMenu.GetSelectedElement()
        viewPos = BestiaryMenu.GetBestiaryMenuSprite().Offset + Vector(50,50)
            local f = Font() -- init font object
            f:Load("font/luaminioutlined.fnt")
            f:DrawString(bestiaryExtensionTestString,viewPos.X,viewPos.Y,KColor(1,1,1,1,0,0,0),0,true) -- render string with loaded font on position 60x50y
            --print("THIS!!!!!!! " .. bestiaryExtensionTestString)
        if isInBestiaryExtension then
            
        end
        BOTB_MENUCHANGES:populateBestiaryExtension(BestiaryMenu.GetEnemySprite():GetFilename())
    else

    end

    --print(bestiaryExtensionTestString)
    

    

    local sketch1 = Sprite("gfx/ui/mainmenu/botb_sketches.anm2", true)
    sketch1:Play("Ant", true)
    sketch1:Render(MenuManager.GetViewPosition()+Vector(420,165))

    local sketch2 = Sprite("gfx/ui/mainmenu/botb_sketches.anm2", true)
    sketch2:Play("Nerd", true)
    sketch2:Render(MenuManager.GetViewPosition()+Vector(48,512))

    local sketch3 = Sprite("gfx/ui/mainmenu/botb_sketches.anm2", true)
    sketch3:Play("OTP", true)
    sketch3:Render(MenuManager.GetViewPosition()+Vector(-128,1620))

    local sketch4 = Sprite("gfx/ui/mainmenu/botb_sketches.anm2", true)
    sketch4:Play("Flapjack", true)
    sketch4:Render(MenuManager.GetViewPosition()+Vector(360,670))


    if BestiaryMenu.GetEnemySprite() ~= nil and BestiaryMenu.GetEnemySprite():GetDefaultAnimationName() ~= nil then
        local enemyThing = Sprite(BestiaryMenu.GetEnemySprite():GetFilename(), true)
        if enemyThing:IsPlaying(BestiaryMenu.GetEnemySprite():GetDefaultAnimationName()) ~= true then
            enemyThing:Play(BestiaryMenu.GetEnemySprite():GetDefaultAnimationName(), true)
        end
        local enemySpriteAnimFrame = math.floor(Isaac.GetFrameCount()/2)
        enemyThing:SetFrame(BestiaryMenu.GetEnemySprite():GetDefaultAnimationName(),(enemySpriteAnimFrame % enemyThing:GetCurrentAnimationData():GetLength()))
        enemyThing:Render(MenuManager.GetViewPosition()+Vector(-512,1800))
    end
    
    --[[
    if Isaac.GetFrameCount() % 64 == 0 then
        local f2 = Font() -- init font object
        f2:Load("font/luaminioutlined.fnt")
        BOTB_MENUCHANGES:testEntityXMLRead(xmlTestCounter)
        --f2:DrawString(BOTB_MENUCHANGES:populateBestiaryExtension(BestiaryMenu.GetEnemySprite():GetFilename()).name,100,100,KColor(1,1,1,1,0,0,0),0,true) -- render string with loaded font on position 60x50y
    end]]

    if isInBestiaryExtension then
        
        
        BOTB_MENUCHANGES:RenderExtendedBestiary(bestiaryExtensionSelectedEntry)

    end
    
    


end
Mod:AddCallback(ModCallbacks.MC_MAIN_MENU_RENDER,BOTB_MENUCHANGES.menuChangesTest)

--print(ImGui.ElementExists("BetterBestiary"))

if ImGui.ElementExists("BetterBestiaryTab") == false then
    ImGui.CreateMenu("BetterBestiaryTab", "\u{f52b} Bestiary")
    ImGui.AddElement("BetterBestiaryTab", "BetterBestiaryButton", ImGuiElement.MenuItem, "Open")
    ImGui.CreateWindow("BetterBestiaryWindow", "BetterBestiary")
    ImGui.LinkWindowToElement("BetterBestiaryWindow", "BetterBestiaryButton")
    ImGui.AddElement("BetterBestiaryWindow", "BetterBestiaryLeftContainer", ImGuiElement.Text, "SHIT")
    ImGui.AddElement("BetterBestiaryWindow", "BetterBestiaryRightContainer", ImGuiElement.SameLine, "FUCK")

end




function BOTB_MENUCHANGES:BetterBestiaryWindowActive()
    --ImGui.SetWindowSize("BetterBestiaryWindow", 1000, 1000)
    --ImGui.SetWindowPosition("BetterBestiaryWindow", 0, 0)
end
ImGui.AddCallback("BetterBestiaryButton", ImGuiCallback.Clicked, BOTB_MENUCHANGES.BetterBestiaryWindowActive)