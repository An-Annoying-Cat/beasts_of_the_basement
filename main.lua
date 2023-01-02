-- to do

-- each enemy to their own file so main isnt 38000 lines
-- get rid of magic numbers


BotB = RegisterMod("Beasts of the Basement", 1)
local Mod = BotB

--globals
BotB.Game = Game()
BotB.Config = Isaac.GetItemConfig()
BotB.SFX = SFXManager()
BotB.Music = MusicManager()
BotB.JSON = require('json')
BotB.HUD = Game():GetHUD()
BotB.FF = FiendFolio --:pleading_face:
local mod = BotB.FF
BotB.StageAPI = StageAPI


if not BotB.FF then
    Isaac.DebugString("[BASEMENTS N BEASTIES] hey buddy you kinda need Fiend Folio for this")
    print("[BASEMENTS N BEASTIES] hey buddy you kinda need Fiend Folio for this")
return end


if not BotB.StageAPI then
    Isaac.DebugString("[BASEMENTS N BEASTIES] hey buddy you kinda need StageAPI for this")
    print("[BASEMENTS N BEASTIES] hey buddy you kinda need StageAPI for this")
end

--[[
local LOCAL_TSIL = require("scripts/core/loi" .. ".TSIL")
LOCAL_TSIL.Init("scripts/core/loi")
]]

--[[
function LoadScripts(scripts)
	--load scripts
	for i,v in ipairs(scripts) do
		include(v)
	end
end --]]

--Until that's sorted out...

--CORE
include("scripts.core.enums")
include("scripts.core.functions")

include("scripts.core.stageapi")
include("scripts.core.ff_additions")

--ENTITIES
include("scripts.entities.drifter")
include("scripts.entities.golfball")

--ENEMIES
include("scripts.entities.enemies.palesniffle")
include("scripts.entities.enemies.tippytap")
include("scripts.entities.enemies.batso")
include("scripts.entities.enemies.croast")
include("scripts.entities.enemies.seducer")
include("scripts.entities.enemies.desirer")
include("scripts.entities.enemies.skooter")
include("scripts.entities.enemies.chaff")
include("scripts.entities.enemies.sleazebag")
include("scripts.entities.enemies.culo")
include("scripts.entities.enemies.kehehan")
include("scripts.entities.enemies.hydroknight")
include("scripts.entities.enemies.giblet")
include("scripts.entities.enemies.kettle")
include("scripts.entities.enemies.planecreep")
include("scripts.entities.enemies.shard")
include("scripts.entities.enemies.crockpot")
include("scripts.entities.enemies.innie")
include("scripts.entities.enemies.inniereverse")
include("scripts.entities.enemies.gibby")
include("scripts.entities.enemies.cadre")
include("scripts.entities.enemies.funguy")
include("scripts.entities.enemies.mabel")
include("scripts.entities.enemies.eternalfly")

include("scripts.entities.enemies.ping")
include("scripts.entities.enemies.pong")



include("scripts.entities.bosses.thaumaturge")

--FAMILIARS
include("scripts.entities.familiars.robobabyzero")
include("scripts.entities.familiars.onyxmarble")
--ITEMS
include("scripts.entities.items.alphaarmor")
include("scripts.entities.items.treemansyndrome")
include("scripts.entities.items.placeholder_item")
--TRINKETS
include("scripts.entities.items.trinkets.demoncore")
include("scripts.entities.items.trinkets.asingleraisin")
include("scripts.entities.items.trinkets.placeholder_trinket")
--PICKUPS
include("scripts.entities.items.pickups.kickcube")
include("scripts.entities.items.pickups.jumpcrystal")
--CONSUMABLES
--include("scripts.entities.consumables.basic")
include("scripts.entities.consumables.shotgunkingcards")

include("scripts.entities.consumables.mahjongtiles")

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
    if mod.UnbiasedPickups[suitName] then
        local dynamicPool = {}
        for _, data in pairs(mod.UnbiasedPickups[suitName]) do
            if data.Unlocked() then
                table.insert(dynamicPool, data.ID)
            end
        end
        return dynamicPool[math.random(0,#dynamicPool)+1]
    end
end

--Thank you Danial for this 
--[[
function Mod:NPCAIChecker(npc,offset)
    local data = npc:GetData()
        Isaac.RenderText(npc.Type .. "." .. npc.Variant .. "." .. npc.SubType, Isaac.WorldToScreen(npc.Position).X - 20,Isaac.WorldToScreen(npc.Position).Y-40,1,1,1,1)
        Isaac.RenderText(npc.State .. "          " .. npc.StateFrame, Isaac.WorldToScreen(npc.Position).X - 35,Isaac.WorldToScreen(npc.Position).Y-30,1,1,1,1)
        Isaac.RenderText(npc.I1 .. "          " .. npc.I2, Isaac.WorldToScreen(npc.Position).X - 35,Isaac.WorldToScreen(npc.Position).Y-20,1,1,1,1)
end
Mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER,Mod.NPCAIChecker)
--]]
--Death checker
Mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, BotB.NPCDeathCheck)


local PLAYER_JEZEBEL = Isaac.GetPlayerTypeByName("Jezebel")
BotB.JEZ_EXTRA = Isaac.GetCostumeIdByPath("gfx/characters/character_jez_extra.anm2")
function BotB:playerGetCostume(player)
    --print("weebis")
    if player:GetPlayerType() == PLAYER_JEZEBEL then
        --print("whongus")
        player:AddNullCostume(BotB.JEZ_EXTRA)
    end
end

Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, BotB.playerGetCostume, 0)