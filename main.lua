-- to do

-- each enemy to their own file so main isnt 38000 lines
-- get rid of magic numbers


BotB = RegisterMod("Beasts of the Basement", 1)
local Mod = BotB
json = require("json")
local myFolder = "scripts.core.LOI"
local LOCAL_TSIL = require(myFolder .. ".TSIL")
LOCAL_TSIL.Init(myFolder)

--globals
BotB.Game = Game()
BotB.Config = Isaac.GetItemConfig()
BotB.SFX = SFXManager()
--BotB.Music = MusicManager()
BotB.JSON = require('json')
BotB.HUD = Game():GetHUD()
BotB.FF = FiendFolio --:pleading_face:
BotB.TT = TaintedTreasure
BotB.StageAPI = StageAPI

if Mod:HasData() then
	Mod.savedata = json.decode(Mod:LoadData())
else
	Mod.savedata = {}
end

function Mod:GetSaveData()
    if not Mod.savedata then
        if Isaac.HasModData(saveDataMod) then
            Mod.savedata = json.decode(Mod:LoadData())
        else
            Mod.savedata = {}
        end
    end

    return Mod.savedata
end



if not BotB.FF then
    Isaac.DebugString("[BASEMENTS N BEASTIES] hey buddy you kinda need Fiend Folio for this")
    print("[BASEMENTS N BEASTIES] hey buddy you kinda need Fiend Folio for this")
return end


if not BotB.StageAPI then
    Isaac.DebugString("[BASEMENTS N BEASTIES] hey buddy you kinda need StageAPI for this")
    print("[BASEMENTS N BEASTIES] hey buddy you kinda need StageAPI for this")
end
--[[
local myFolder = "scripts.core.LOI"
local LOCAL_TSIL = require(myFolder .. ".TSIL")
LOCAL_TSIL.Init(myFolder)
]]


--Hidden item manager
local hiddenItemManager = require("scripts.core.hidden_item_manager")
--hiddenItemManager:Init(BotB)


local function LoadScripts(scripts)
	--load scripts
	for i,v in ipairs(scripts) do
		include(v)
	end
end

BotB.LoadScripts = LoadScripts

Mod.CoreScripts = {
    "scripts.core.enums",
    "scripts.core.functions",
    "scripts.core.table_functions",
    "scripts.core.fadeout",
    "scripts.core.stageapi",
    "scripts.core.ff_additions",
    --"scripts.core.jail_generator_v2",
    --"scripts.core.savedata",
    "scripts.loader",
}
LoadScripts(Mod.CoreScripts)
hiddenItemManager:Init(BotB)


--General enemy override. Guess we Ministro now

function BotB:MinistroOverrideTest(npc)
    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()
    --Sleazebag 
    --Idk why this isnt working if I put these into its own lua file. Fuck it
    --Convert flies spawned by Sleazebags into Skuzzes
    if npc.Type == Isaac.GetEntityTypeByName("Fly") or Isaac.GetEntityTypeByName("Attack Fly") or npc.Type == Isaac.GetEntityTypeByName("Pooter") then 
        if npc.SpawnerVariant == BotB.Enums.Entities.SLEAZEBAG.VARIANT and npc.SpawnerType == BotB.Enums.Entities.SLEAZEBAG.TYPE then
            if npc.Type == Isaac.GetEntityTypeByName("Pooter") then
                --Convert Pooters into Skooters
                npc:Morph(Isaac.GetEntityTypeByName("Skooter"), Isaac.GetEntityVariantByName("Skooter"), 1, 0)
                --npc.StateFrame = 0
                sprite:Play("idle")
            elseif npc.Type == Isaac.GetEntityTypeByName("Fly") or Isaac.GetEntityTypeByName("Attack Fly") then
                
                --Convert Flies and Attack Flies into normal Skuzzes
                npc:Morph(Isaac.GetEntityTypeByName("Skuzz"), Isaac.GetEntityVariantByName("Skuzz"), 0, 0)
                sprite:Play("idle")
                --npc.StateFrame = 0
            end
        end
        
    end

end


function BotB:anvilEffect(effect)
    if effect:GetSprite():IsEventTriggered("Anvil") then
      --effect:PlaySound(Isaac.GetSoundIdByName("AcmeDeath"),1,0,false,math.random(120,150)/100)
      game:ShakeScreen(8)
    elseif effect:GetSprite():IsFinished("Death") then
        sfx:Play(Isaac.GetSoundIdByName("AcmeDeath"),1,0,false,1)
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SHOCKWAVE, 5, effect.Position, Vector.Zero, effect)
        Isaac.GridSpawn(GridEntityType.GRID_PIT, 0, effect.Position, true)
      game:ShakeScreen(15)
      effect:Remove()
    end
end

function BotB:killTargetEffect(effect)
    if effect:GetSprite():IsFinished("Effect") then
      effect:Remove()
    end
end

--Generalized death checker
function BotB:NPCDeathCheck(npc)
    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    local data = npc:GetData()
    --Is it an Acme?
    if npc.Type == 10 and npc.Variant == BotB.Enums.Entities.ACME.VARIANT then 
        --sprite:Play("Death")
        --npc:PlaySound(Isaac.GetSoundIdByName("AcmeDeath"),1,0,false,math.random(120,150)/100)
        --npc:PlaySound(BotB.FF.Sounds.FunnyFart,1,0,false,math.random(120,150)/100)
        anvil = Isaac.GetEntityVariantByName("Acme's Anvil")
        AcmeDeathAnvil = Isaac.Spawn(EntityType.ENTITY_EFFECT,anvil,0,npc.Position,Vector(0,0),npc)
        --Mod.AcmeDeathEffect(npc)
    end
end

--Test for Acme death. Using code from Tagbag
function Mod.AcmeDeathEffect(npc)
    anvil = Isaac.GetEntityVariantByName("Acme's Anvil")
    Isaac.Spawn(EntityType.ENTITY_EFFECT,anvil,0,npc.Position,Vector(0,0),npc)
end
acmeAnvil = Isaac.GetEntityVariantByName("Acme's Anvil")
--Tutorial shit
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE,BotB.MinistroOverrideTest)
--Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE,BotB.SkuzzOverrideTest)
Mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE,BotB.anvilEffect, Isaac.GetEntityVariantByName("Acme's Anvil"))
Mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE,BotB.killTargetEffect, Isaac.GetEntityVariantByName("Warning Target"))
--Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, BotB.MinistroNPCUpdate, EntityType.ENTITY_MINISTRO)
--Culo poop spawn
Mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, v)
    local d = v:GetData()
    if d.fartTearPoopEdition == true then
        if Game():GetRoom():IsPositionInRoom(v.Position,0) then Isaac.GridSpawn(GridEntityType.GRID_POOP,0,v.Position,true) end
        game:ButterBeanFart(v.Position, 140, v, true, false)
    end
end, EntityType.ENTITY_PROJECTILE)


function Mod.unbiasedFromSuit(suitName)
    if BotB.FF.UnbiasedPickups[suitName] then
        local dynamicPool = {}
        for _, data in pairs(mod.UnbiasedPickups[suitName]) do
            if data.Unlocked() then
                table.insert(dynamicPool, data.ID)
            end
        end
        return dynamicPool[math.random(0,#dynamicPool)+1]
    end
end


function BotB:GetPlayers()
	local players = {}

	for i = 1, game:GetNumPlayers() do
		table.insert(players, game:GetPlayer(i))
	end

	return players
end
--Thank you Danial for this 
--
function Mod:NPCAIChecker(npc,offset)
    local doTheDataCheck = false
    local playerTable = BotB:GetPlayers()
    for i=1, #playerTable do
        if playerTable[i]:ToPlayer():GetData().doBotBEntityData == true then
            doTheDataCheck = true
        end
    end
    if not doTheDataCheck then return end

    local data = npc:GetData()
    --local nameString = BotB.Functions:GetEntityNameString(npc)
        Isaac.RenderText(npc.Type .. "." .. npc.Variant .. "." .. npc.SubType, Isaac.WorldToScreen(npc.Position).X - 20,Isaac.WorldToScreen(npc.Position).Y-40,1,1,1,1)
        Isaac.RenderText(npc.State .. "          " .. npc.StateFrame, Isaac.WorldToScreen(npc.Position).X - 35,Isaac.WorldToScreen(npc.Position).Y-30,1,1,1,1)
        Isaac.RenderText(npc.I1 .. "          " .. npc.I2, Isaac.WorldToScreen(npc.Position).X - 35,Isaac.WorldToScreen(npc.Position).Y-20,1,1,1,1)
        --if nameString ~= nil then
        --    Isaac.RenderText(nameString, Isaac.WorldToScreen(npc.Position).X - 20,Isaac.WorldToScreen(npc.Position).Y-50,1,1,1,1)
        --end
        if npc.Target then
            Isaac.RenderText("target", npc.Target.Position.X,  npc.Target.Position.Y,1,1,1,1)
        end
        if npc.TargetPosition then
            Isaac.RenderText("movement target", npc.TargetPosition.X, npc.TargetPosition.Y,1,1,1,1)
        end

end
Mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER,Mod.NPCAIChecker)
--
--Death checker
Mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, BotB.NPCDeathCheck)




function BotB:dataSwitchCMD(cmd, params)
    if not cmd == "data" then return end
    if cmd == "data" then
        local playerTable = BotB:GetPlayers()
    if params == "on" then
        for i=1, #playerTable do
            if playerTable[i]:ToPlayer():GetData().doBotBEntityData ~= true then
                playerTable[i]:ToPlayer():GetData().doBotBEntityData = true
            end
        end
    elseif params == "off" then
        for i=1, #playerTable do
            if playerTable[i]:ToPlayer():GetData().doBotBEntityData ~= false then
                playerTable[i]:ToPlayer():GetData().doBotBEntityData = false
            end
        end
    else
        print("this function needs on or off to work")
    end
    end
    
    
end
Mod:AddCallback(ModCallbacks.MC_EXECUTE_CMD, BotB.dataSwitchCMD)

local botbTaintedItems = {
    {CollectibleType.COLLECTIBLE_BBF, Isaac.GetItemIdByName("B.H.F.")},
}
local uhhidk = {}

function BotB:TaintedCompat()
    if BotB.TT then
        --BotB.TT:MergeTaintedTreasures(botbTaintedItems)
        print("[BotB] The PogChamp")
        BotB.TT:AddTaintedTreasure(CollectibleType.COLLECTIBLE_BBF,Isaac.GetItemIdByName("B.H.F."))
        BotB.TT:AddTaintedTreasure(CollectibleType.COLLECTIBLE_TWISTED_PAIR,Isaac.GetItemIdByName("Faithful Fleet"))
        BotB.TT:AddTaintedTreasure(CollectibleType.COLLECTIBLE_INFAMY,Isaac.GetItemIdByName("Champ's Mask"))
        BotB.TT:AddTaintedTreasure(CollectibleType.COLLECTIBLE_RUBBER_CEMENT,Isaac.GetItemIdByName("Liquid Latex"))
    else
        print("[BotB] You're missing out on some pretty dope Tainted Treasures compatability, my dude")
    end
end
--TSIL.AddVanillaCallback(BotB, ModCallbacks.MC_POST_GAME_STARTED, BotB.TaintedCompat,CallbackPriority.LATE)
Mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, BotB.TaintedCompat)

--
if EID then
    EID:setModIndicatorName("Beasts Of The Basement")

		local sprite = Sprite()
		sprite:Load("gfx/misc/eidMarkup.anm2", true)
		EID:addIcon("BotBIndicator", "BotB",0,16,18,0,0,sprite)
		EID:setModIndicatorIcon("BotBIndicator")
        EID:addIcon("StatusDisease", "Disease",0,16,16,0,0,sprite)
        EID:addIcon("StatusDivine", "Divine",0,16,16,0,0,sprite)
        EID:addIcon("StatusIrradiated", "Irradiated",0,16,16,0,0,sprite)
end
--



