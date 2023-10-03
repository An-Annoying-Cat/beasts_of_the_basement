local mod = FiendFolio
local Mod = BotB
local RADIOACTIVE_BARREL = {}
local game = Game()
local sfx = SFXManager()

BotB.RadiactiveBarrelGrid = StageAPI.CustomGrid("BotBRadioactiveBarrel", {
    BaseType = GridEntityType.GRID_ROCK_BOMB, -- using spikes rather than metal block because metal blocks block explosion damage D:`
    Anm2 = "gfx/grid/grid_radioactive_barrel.anm2",
    Animation = "Idle",
    --RemoveOnAnm2Change = true,
    --OverrideGridSpawns = true,
    SpawnerEntity = {Type = 502, Variant = 1}
})
--[[
function mod:tryTriggerBulbRock(forceShut)
    for _, customGrid in ipairs(StageAPI.GetCustomGrids(nil, "FFBulbRock")) do
        customGrid.Data.TryActivation = true
        if forceShut then
            local forcedDarkness = game:GetLevel():GetCurrentRoomDesc().Flags & RoomDescriptor.FLAG_PITCH_BLACK ~= 0

            sfx:Play(mod.Sounds.LightSwitch,1,0,false,0.9)
            sfx:Play(mod.Sounds.CameraFlash,2,0,false,3)
            if not forcedDarkness then
                game:Darken(1, 150)
            end
            customGrid.GridEntity:GetSprite():Play("Bombed", true)
            customGrid.Data.Cooldown = 150
        end
    end
end

local function bulbRockHitboxCollide(hitbox, hitting)
    if hitting.Type == EntityType.ENTITY_PLAYER or hitting.Type == EntityType.ENTITY_TEAR or hitting.Type == EntityType.ENTITY_PROJECTILE then
        mod:tryTriggerBulbRock()
    end

    return true
end

local function bulbRockHitboxHurt(hitbox, damage, flag, source, countdown)
    if flag & DamageFlag.DAMAGE_EXPLOSION ~= 0 then
        hitbox:GetData().CustomGrid:Destroy(true)
    end

    return false
end]]


function Mod.radioactiveBarrelUpdate(customGrid)
    local grid = customGrid.GridEntity
    if grid ~= nil then
        local sprite = grid:GetSprite()
        --local forcedDarkness = game:GetLevel():GetCurrentRoomDesc().Flags & RoomDescriptor.FLAG_PITCH_BLACK ~= 0
    
        local lightColor = Color(0, 1, 0, 1, 0, 0, 0)
        local lightColorNoAlpha = Color(0, 1, 0, 0, 0, 0, 0)
        if sprite:IsPlaying("Idle") then
            
        end
        if grid.State == 2 then
            customGrid.Data.Light:Remove()
            customGrid.Data.Hitbox:Remove()
            local tempRadCirc = RADIOACTIVE_BARREL:spawnTempRadCircle(false,240,0.75,grid.Position,customGrid.Data.Hitbox):ToEffect()
            tempRadCirc.SpriteScale = Vector(0.01,0.01)
            customGrid:Remove()
        else
            local roomEntities = Isaac.GetRoomEntities() -- table
            local grid = customGrid.GridEntity
            for i = 1, #roomEntities do
                local entity = roomEntities[i]
                --print(entity.Type, entity.Variant, entity.SubType)
                if entity.Type == EntityType.ENTITY_PLAYER then
                    local entdistance = (entity.Position - grid.Position):Length()
                    --print("is " .. entdistance .. " <= " .. 200 * effect.SpriteScale.X .. " ?" )
                    if entdistance <= 80 then
                        if entity:GetData().radDuration <= 60 then
                            entity:GetData().addRads = true
                        end
                    end
                end
            end
        end
        
        --print(grid.State)
        --customGrid.Data.Light.Color = lightColor
    
        --grid.State = 2
    end
    
end

function RADIOACTIVE_BARREL:spawnTempRadCircle(friendly,duration,scale,position,source)
    print(friendly)
    local isFriendly = friendly or false
    print(isFriendly)
    local finalSubType = 200000000 + (duration*10000) + (scale * 1000)
    if isFriendly then
        finalSubType = 100000000 + (duration*10000) + (scale * 1000)
    end
    --local finalSubType = 200000000 + (duration*10000) + (scale * 1000)
    --print("final subtype is " .. finalSubType .. ", which should mean " .. duration .. " frames and " .. scale .. " maximum scale")
    local tempRadCirc = Isaac.Spawn(EntityType.ENTITY_EFFECT,BotB.Enums.Entities.RADIATION_CIRCLE_TEMPORARY.VARIANT,finalSubType,position,Vector.Zero,source):ToEffect()
    tempRadCirc.SortingLayer = SortingLayer.SORTING_BACKGROUND
    tempRadCirc.Parent = source
    tempRadCirc.Timeout = -1
    return tempRadCirc
end

function Mod.radioactiveBarrelSpawn(customGrid)
    local grid = customGrid.GridEntity
    grid.CollisionClass = GridCollisionClass.COLLISION_SOLID
    customGrid.Data.Hits = {}

    customGrid.Data.Light = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.LIGHT, 0, grid.Position, Vector.Zero, nil)

    customGrid.Data.Hitbox = Isaac.Spawn(mod.FF.Hitbox.ID, mod.FF.Hitbox.Var, 1, grid.Position, Vector.Zero, nil)
    customGrid.Data.Hitbox.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
    customGrid.Data.Hitbox:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
    local npc = customGrid.Data.Hitbox
    if customGrid.Data.radCirle == nil then
        customGrid.Data.radCirle = Isaac.Spawn(EntityType.ENTITY_EFFECT,Isaac.GetEntityVariantByName("Radiation Circle"),0,npc.Position,Vector.Zero,npc):ToEffect()
                customGrid.Data.radCirle.Parent = npc
                customGrid.Data.radCirle.SpriteScale = Vector(0.01,0.01)
                customGrid.Data.radCirle.SortingLayer = SortingLayer.SORTING_BACKGROUND
                customGrid.Data.radCirle:GetData().radCircleMaxScale = 0.4
    end

    local hdata = customGrid.Data.Hitbox:GetData()
    hdata.CustomGrid = customGrid
    hdata.FixToSpawner = true
    hdata.Width = 22
    hdata.Height = 22
    --hdata.OnCollide = bulbRockHitboxCollide
    --hdata.OnHurt = bulbRockHitboxHurt
end

StageAPI.AddCallback("FiendFolio", "POST_CUSTOM_GRID_UPDATE", 1, Mod.radioactiveBarrelUpdate, BotB.RadiactiveBarrelGrid.Name)
StageAPI.AddCallback("FiendFolio", "POST_SPAWN_CUSTOM_GRID", 1, Mod.radioactiveBarrelSpawn, BotB.RadiactiveBarrelGrid.Name)