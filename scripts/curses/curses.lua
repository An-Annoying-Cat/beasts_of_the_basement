local Mod = BotB
local BOTB_CURSES = {}

--A lot of this code is taken from Black Lantern from Fiend Folio


local function levelHasCurse(level, curse)
    if level == nil then return false end
    if curse == -1 then return false end
    return level:GetCurses() & (1 << curse - 1) >= (1 << curse - 1)
end

local game = Game()

local minimapToggle = minimapToggle or false
local tabCooldown = tabCooldown or 0

local function levelHasCurse(level, curse)
    if level == nil then return false end
    if curse == -1 then return false end
    return level:GetCurses() & (1 << curse - 1) >= (1 << curse - 1)
end

local function levelHasAnyBotBCurse(level)
    if level == nil then return false end
    --[[
    for _, c in pairs(BotB.Enums.Curses) do
        if levelHasCurse(level, (1 << c - 1)) then return true end
    end]]
    if levelHasCurse(level, Isaac.GetCurseIdByName("Curse of the Stalked")) then return true end
    return false
end


local function getMinimapHeight(level)
    local height = 0

    local firstRow = -1
    local lastRow = -1

    for i = 0, 12 do
        for j = 0, 12 do
            local index = i * 13 + j

            local desc = level:GetRoomByIdx(index)
            if desc.DisplayFlags ~= 0 then
                if firstRow == -1 then
                    firstRow = i
                    lastRow = i
                else
                    lastRow = i
                end
                break
            end
        end
    end

    height = 1 + lastRow - firstRow

    return height
end

local function getMappingOffset(player)
    local c = 0

    if player:HasCollectible(CollectibleType.COLLECTIBLE_COMPASS) then
        c = c + 1
    end
    if player:HasCollectible(CollectibleType.COLLECTIBLE_TREASURE_MAP) then
        c = c + 1
    end
    if player:HasCollectible(CollectibleType.COLLECTIBLE_BLUE_MAP) then
        c = c + 1
    end

    if player:HasCollectible(CollectibleType.COLLECTIBLE_MIND) then
        c = 1
    end

    return c
end


local function getRoomEnemies()
    local enemies = {}
    for _, e in pairs(Isaac.GetRoomEntities()) do
        if e:IsVulnerableEnemy() then
            table.insert(enemies, e)
        end
    end
    return enemies
end

local curseAnimNames = {}

curseAnimNames[Isaac.GetCurseIdByName("Curse of the Stalked")] = "stalked"

local function getPlayers()
	local game = Game()
	local numPlayers = game:GetNumPlayers()
  
	local players = {}
	for i = 0, numPlayers - 1 do
	  local player = Isaac.GetPlayer(i)
	  table.insert(players, player)
	end
  
	return players
end





local level = Game():GetLevel()
--print(level:GetCurses(), (1 << Isaac.GetCurseIdByName("Curse of the Stalked") - 1))
function BOTB_CURSES:GiveMeStalkedPls()
    local level = Game():GetLevel()
    local chance = math.random(0,7)
    local players = getPlayers()
        for i=1,#players do
            local dude = players[i]
            if dude:HasCollectible(BotB.Enums.Items.TOY_PHONE_DUMMY) then
                chance = 0
                level:AddCurse(((1 << Isaac.GetCurseIdByName("Curse of the Stalked") - 1)), false)
            end
        end
    
    if level:GetCurses() == 0 and chance == 0 then
        --print("entry time: " .. Game():GetFrameCount() .. " expected arrival: " .. (Game():GetFrameCount() + 1800))
        local player = Isaac.GetPlayer(0)
        player:GetData().botbStalkedExpectedArrival = Game():GetFrameCount() + 1800
        --fix the lost curse when going to a new floor
        local players = getPlayers()
        for i=1,#players do
            local dude = players[i]
            local effects = dude:GetEffects()
            
            dude:GetData().gotPursued = false
            dude:GetData().botbSpawnedStalkedPursuer = false
        end
        level:AddCurse(((1 << Isaac.GetCurseIdByName("Curse of the Stalked") - 1)), false)
    end
    
end
--replace normal curses
Mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, BOTB_CURSES.GiveMeStalkedPls)

if MinimapAPI then
    --print("scrunt")
    local icons = Sprite()
	icons:Load("gfx/icons.anm2", true)
    
    --icons:LoadGraphics()

   
    function StalkedCurse()
        local level = game:GetLevel()
        return levelHasCurse(level, Isaac.GetCurseIdByName("Curse of the Stalked"))
    end
    
    --print(StalkedCurse())
    MinimapAPI:AddMapFlag("CurseStalked", StalkedCurse, icons, "Stalked", 0)
end

function BOTB_CURSES:spawnPursuerWhenStalked(player)
    if levelHasCurse(level, Isaac.GetCurseIdByName("Curse of the Stalked")) then
        if player:GetData().botbStalkedExpectedArrival ~= nil and Game():GetFrameCount() == player:GetData().botbStalkedExpectedArrival and player:GetData().botbSpawnedStalkedPursuer ~= true then
            Game():GetHUD():ShowItemText("...", "...You feel watched.", false)
                local pursuer = Isaac.Spawn(BotB.Enums.Entities.PURSUER_V2.TYPE, BotB.Enums.Entities.PURSUER_V2.VARIANT, BotB.Enums.Entities.PURSUER_V2.SUBTYPE, player.Position+Vector(1000,0):Rotated(math.random(0,360)),Vector.Zero,player):ToNPC()
                pursuer.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
                Game():Darken(0.95, 80)
                player:GetData().botbSpawnedStalkedPursuer = true
        end
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, BOTB_CURSES.spawnPursuerWhenStalked)

--
if MinimapAPI then
    --print("scrunt")
    local icons = Sprite()
	icons:Load("gfx/icons.anm2", true)
    
    --icons:LoadGraphics()

   
    function StalkedCurse()
        local level = game:GetLevel()
        return levelHasCurse(level, Isaac.GetCurseIdByName("Curse of the Stalked"))
    end
    
    --print(StalkedCurse())
    MinimapAPI:AddMapFlag("CurseStalked", StalkedCurse, icons, "Stalked", 0)
end
--MinimapAPI.Debug.RandomMap()
--MinimapAPI.Debug.Shapes()
--wip-ish curse icon rendering

Mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    if not MinimapAPI then
        if (StageAPI and StageAPI.Loaded and StageAPI.IsHUDAnimationPlaying()) or game:GetSeeds():HasSeedEffect(SeedEffect.SEED_NO_HUD) then
            return
        end
        ----print("Shitfuck2!(tm)")
        local player = Isaac.GetPlayer(0)
        local level = game:GetLevel()

        --if mod.anyPlayerHas(CollectibleType.COLLECTIBLE_BLACK_LANTERN) then --dumb shitty safeguard
            if levelHasAnyBotBCurse(level) then
                ----print("bengis")
                local hud_offset = Options.HUDOffset

                local s = Sprite()
                local c
                s:Load("gfx/ui/curseicons.anm2", true)

                if levelHasCurse(level, Isaac.GetCurseIdByName("Curse of the Stalked")) then
                    ----print("galunga")
                    s:Play("stalked", true)
                end
                

                local x_offset = 0

                if StageAPI then --fix for weird renderscales/resolutions
                    local center = StageAPI.GetScreenCenterPosition()
                    local br = StageAPI.GetScreenBottomRight()

                    x_offset = br.X - 480
                end

                local y = 48 + hud_offset * 14
                local x = 460 - hud_offset * 24

                local height = getMinimapHeight(level)
                local multiplier = 15

                if minimapToggle then
                    y = 10 + height * multiplier + hud_offset * 14
                    x = 463 - hud_offset * 24
                    s:Play("stalked".."_trans", true)
                end

                if not game:IsPaused() then
                    if Input.IsActionTriggered(ButtonAction.ACTION_MAP, player.ControllerIndex) then
                        tabCooldown = 10
                        minimapToggle = not minimapToggle
                    elseif Input.IsActionPressed(ButtonAction.ACTION_MAP, player.ControllerIndex) and tabCooldown == 0 then
                        if minimapToggle then
                            minimapToggle = not minimapToggle
                        end
                        y = 10 + height * multiplier + hud_offset * 14
                        x = 463 - hud_offset * 24
                    end
                end

                x = x + x_offset

                local icon_offset = getMappingOffset(player)

                for i = 1, 7 do
                    if levelHasCurse(level, i) then
                        icon_offset = icon_offset + 1
                    end
                end

                x = x - 16 * icon_offset

                s:Render(Vector(x, y), Vector.Zero, Vector.Zero)
            elseif not game:IsPaused() then
                --this runs even when the player doesnt have black lantern to
                --fix the icons being misaligned when you pick up the item
                --while having an expanded map
                if Input.IsActionTriggered(ButtonAction.ACTION_MAP, player.ControllerIndex) then
                    tabCooldown = 10
                    minimapToggle = not minimapToggle
                elseif Input.IsActionPressed(ButtonAction.ACTION_MAP, player.ControllerIndex) and tabCooldown == 0 then
                    if minimapToggle then
                        minimapToggle = not minimapToggle
                    end
                end
            end
        --end

        if tabCooldown > 0 then tabCooldown = tabCooldown - 1 end
    end

end)


