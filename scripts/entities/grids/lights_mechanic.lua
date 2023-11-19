local Mod = BotB
local LIGHTS_MECHANIC = {}
local Entities = BotB.Enums.Entities

function LIGHTS_MECHANIC:NPCUpdate(npc)
    if npc.Type == EntityType.ENTITY_GENERIC_PROP and npc.Variant == BotB.Enums.Props.ON_TOTEM.VARIANT then 
        print("ontotem")
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, LIGHTS_MECHANIC.NPCUpdate, EntityType.ENTITY_GENERIC_PROP)

--pass an entity enum to it. this checks type and variant and returns the right boolean.
function LIGHTS_MECHANIC:isItThisNPC(checkMe, enum)
    if checkMe.Type == enum.TYPE and checkMe.Variant == enum.VARIANT then
        return true
    else
        return false
    end
end

function LIGHTS_MECHANIC:shouldIDoTheLightsEasterEgg()
    local roomEntities = Isaac.GetRoomEntities() -- table
    local roomNeedsBotBLightStateTracker = false
    local roomActuallyHasBotBLightStateTracker = false
        for i = 1, #roomEntities do
            local entity = roomEntities[i]
            local npc = entity:ToNPC()
            if LIGHTS_MECHANIC:isItThisNPC(entity, BotB.Enums.Entities.VANTAGE) then
                roomNeedsBotBLightStateTracker = true
            end

            if LIGHTS_MECHANIC:isItThisNPC(entity, BotB.Enums.Entities.NYCTO) then
                roomNeedsBotBLightStateTracker = true
            end

            if LIGHTS_MECHANIC:isItThisNPC(entity, BotB.Enums.Entities.HELIO) then
                roomNeedsBotBLightStateTracker = true
            end

            if entity.Type == BotB.Enums.Props.ROOM_LIGHT_STATE_TRACKER.TYPE and entity.Variant == BotB.Enums.Props.ROOM_LIGHT_STATE_TRACKER.VARIANT then
                roomActuallyHasBotBLightStateTracker = true
            end
        end
    local doBotBIncorrectLightsEasterEgg = false
    if (roomNeedsBotBLightStateTracker ~= roomActuallyHasBotBLightStateTracker) then
        return true
    else
        return false
    end
end
--
function LIGHTS_MECHANIC:playerUpdate(player)
    if player:GetData().lightSwitchCooldown == nil then
        player:GetData().lightSwitchCooldown = 15
    end
    local roomEntities = Isaac.GetRoomEntities() -- table
    if LIGHTS_MECHANIC:shouldIDoTheLightsEasterEgg() then
            for i = 1, #roomEntities do
                local entity = roomEntities[i]
                local npc = entity:ToNPC()
                if LIGHTS_MECHANIC:isItThisNPC(entity, BotB.Enums.Entities.VANTAGE) then
                    Isaac.Spawn(Entities.ASYLUM_ENEMY_EASTER_EGG.TYPE,Entities.ASYLUM_ENEMY_EASTER_EGG.VARIANT, 2, npc.Position, Vector.Zero, nil)
                    entity:Remove()
                end
    
                if LIGHTS_MECHANIC:isItThisNPC(entity, BotB.Enums.Entities.NYCTO) then
                    Isaac.Spawn(Entities.ASYLUM_ENEMY_EASTER_EGG.TYPE,Entities.ASYLUM_ENEMY_EASTER_EGG.VARIANT, 0, npc.Position, Vector.Zero, nil)
                    entity:Remove()
                end
    
                if LIGHTS_MECHANIC:isItThisNPC(entity, BotB.Enums.Entities.HELIO) then
                    Isaac.Spawn(Entities.ASYLUM_ENEMY_EASTER_EGG.TYPE,Entities.ASYLUM_ENEMY_EASTER_EGG.VARIANT, 1, npc.Position, Vector.Zero, nil)
                    entity:Remove()
                end
            end
        
    end

    local hasEasterEggEffect = false
    for i = 1, #roomEntities do
        local entity = roomEntities[i]
        local npc = entity:ToNPC()
        if LIGHTS_MECHANIC:isItThisNPC(entity, BotB.Enums.Entities.ASYLUM_ENEMY_EASTER_EGG) then
            hasEasterEggEffect = true
        end
    end
    if hasEasterEggEffect == true then
        if SFXManager():IsPlaying(BotB.Enums.SFX.NOELLE_POP) ~= true then
            SFXManager():Play(BotB.Enums.SFX.NOELLE_POP,0.5,0,true,1)
        end
    else
        if SFXManager():IsPlaying(BotB.Enums.SFX.NOELLE_POP) == true then
            SFXManager():Stop(BotB.Enums.SFX.NOELLE_POP)
        end
    end

    

    if player:GetData().lightSwitchCooldown ~= 0 then
        player:GetData().lightSwitchCooldown = player:GetData().lightSwitchCooldown - 1
    end
    
    local panelsInTheRoom = {}
    for i = 1, #roomEntities do
        local entity = roomEntities[i]
        local data = entity:GetData()
        --Self processing for the props

        --Power Off Button
        --is enabled only when the lights are on. can only switch them off
        if entity.Type == EntityType.ENTITY_GENERIC_PROP and entity.Variant == BotB.Enums.Props.POWER_OFF_BUTTON.VARIANT then    
            entity.DepthOffset = -999 
            entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            local sprite = entity:GetSprite()
            if data.State == nil then
                entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                entity.SortingLayer = SortingLayer.SORTING_BACKGROUND
                sprite:Play("Button_Off")
                data.State = "off"
            end

            if data.State == "on2off" then
                if sprite:IsPlaying("Button_SwitchedOff") ~= true then
                    sprite:Play("Button_SwitchedOff")
                end
                if sprite:IsFinished("Button_SwitchedOff") then
                    sprite:Play("Button_Off")
                    data.State = "off"
                end
            end

            if data.State == "off2on" then
                if sprite:IsPlaying("Button_SwitchedOn") ~= true then
                    sprite:Play("Button_SwitchedOn")
                end
                if sprite:IsFinished("Button_SwitchedOn") then
                    sprite:Play("Button_On")
                    data.State = "on"
                end
            end

            local measureFromPos = entity.Position
            local measureToPos = player.Position
            if data.playerIsSteppingOnBOTBLightSwitch == false and data.State == "on" then
                if (measureToPos.X >= measureFromPos.X - 20 and measureToPos.X <= measureFromPos.X + 20) and (measureToPos.Y >= measureFromPos.Y - 20 and measureToPos.Y <= measureFromPos.Y + 20) and player:GetData().lightSwitchCooldown == 0  then
                    player:GetData().lightSwitchCooldown = 15
                    SFXManager():Play(SoundEffect.SOUND_SLOTSPAWN,1,0,false,0.6)
                    data.playerIsSteppingOnBOTBLightSwitch = true
                    LIGHTS_MECHANIC:changeAllLightSwitches()
                    --OH BOY HERE WE GO
                    
                end
            end

            if ((measureToPos.X >= measureFromPos.X - 20 and measureToPos.X <= measureFromPos.X + 20) and (measureToPos.Y >= measureFromPos.Y - 20 and measureToPos.Y <= measureFromPos.Y + 20)) ~= true then
                data.playerIsSteppingOnBOTBLightSwitch = false
            end            
        end

        --Power On Button
        --is enabled only when the lights are off. can only switch them on
        if entity.Type == EntityType.ENTITY_GENERIC_PROP and entity.Variant == BotB.Enums.Props.POWER_ON_BUTTON.VARIANT then  
            entity.DepthOffset = -999  
            entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE 
            local sprite = entity:GetSprite()
            if data.State == nil then
                entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                entity.SortingLayer = SortingLayer.SORTING_BACKGROUND
                sprite:Play("Button_Off")
                data.State = "off"
            end

            if data.State == "on2off" then
                if sprite:IsPlaying("Button_SwitchedOff") ~= true then
                    sprite:Play("Button_SwitchedOff")
                end
                if sprite:IsFinished("Button_SwitchedOff") then
                    sprite:Play("Button_Off")
                    data.State = "off"
                end
            end

            if data.State == "off2on" then
                if sprite:IsPlaying("Button_SwitchedOn") ~= true then
                    sprite:Play("Button_SwitchedOn")
                end
                if sprite:IsFinished("Button_SwitchedOn") then
                    sprite:Play("Button_On")
                    data.State = "on"
                end
            end

            local measureFromPos = entity.Position
            local measureToPos = player.Position
            if data.playerIsSteppingOnBOTBLightSwitch == false and data.State == "off" then
                if (measureToPos.X >= measureFromPos.X - 20 and measureToPos.X <= measureFromPos.X + 20) and (measureToPos.Y >= measureFromPos.Y - 20 and measureToPos.Y <= measureFromPos.Y + 20) and player:GetData().lightSwitchCooldown == 0  then
                    player:GetData().lightSwitchCooldown = 15
                    SFXManager():Play(SoundEffect.SOUND_SLOTSPAWN,1,0,false,0.6)
                    data.playerIsSteppingOnBOTBLightSwitch = true
                    LIGHTS_MECHANIC:changeAllLightSwitches()
                    --OH BOY HERE WE GO
                    
                end
            end

            if ((measureToPos.X >= measureFromPos.X - 20 and measureToPos.X <= measureFromPos.X + 20) and (measureToPos.Y >= measureFromPos.Y - 20 and measureToPos.Y <= measureFromPos.Y + 20)) ~= true then
                data.playerIsSteppingOnBOTBLightSwitch = false
            end            
        end


        --light switch
        --toggles lights. can go from on to off or off to on
        if entity.Type == EntityType.ENTITY_GENERIC_PROP and entity.Variant == BotB.Enums.Props.LIGHT_SWITCH.VARIANT then    
            entity.DepthOffset = -999
            entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE 
            local sprite = entity:GetSprite()
            if data.State == nil then
                entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                entity.SortingLayer = SortingLayer.SORTING_BACKGROUND
                sprite:Play("Button_Off")
                data.State = "off"
            end

            if data.State == "on2off" then
                if sprite:IsPlaying("Button_SwitchedOff") ~= true then
                    sprite:Play("Button_SwitchedOff")
                end
                if sprite:IsFinished("Button_SwitchedOff") then
                    sprite:Play("Button_Off")
                    data.State = "off"
                end
            end

            if data.State == "off2on" then
                if sprite:IsPlaying("Button_SwitchedOn") ~= true then
                    sprite:Play("Button_SwitchedOn")
                end
                if sprite:IsFinished("Button_SwitchedOn") then
                    sprite:Play("Button_On")
                    data.State = "on"
                end
            end

            local measureFromPos = entity.Position
            local measureToPos = player.Position
            if data.playerIsSteppingOnBOTBLightSwitch == false then
                if (measureToPos.X >= measureFromPos.X - 20 and measureToPos.X <= measureFromPos.X + 20) and (measureToPos.Y >= measureFromPos.Y - 20 and measureToPos.Y <= measureFromPos.Y + 20) and player:GetData().lightSwitchCooldown == 0  then
                    player:GetData().lightSwitchCooldown = 15
                    SFXManager():Play(SoundEffect.SOUND_SLOTSPAWN,1,0,false,0.6)
                    data.playerIsSteppingOnBOTBLightSwitch = true
                    --OH BOY HERE WE GO
                    LIGHTS_MECHANIC:changeAllLightSwitches()
                    
                end
            end

            if ((measureToPos.X >= measureFromPos.X - 20 and measureToPos.X <= measureFromPos.X + 20) and (measureToPos.Y >= measureFromPos.Y - 20 and measureToPos.Y <= measureFromPos.Y + 20)) ~= true then
                data.playerIsSteppingOnBOTBLightSwitch = false
            end            
        end

        --room light state tracker
        --keeps track of whether the lights are on or off in a room.
        --subtype can be toggled to 1 to have a room start with the lights out, otherwise will start with the lights on.

        if entity.Type == EntityType.ENTITY_GENERIC_PROP and entity.Variant == BotB.Enums.Props.ROOM_LIGHT_STATE_TRACKER.VARIANT then   

            entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE  
            local sprite = entity:GetSprite()
            if data.State == nil then
                
                entity.SortingLayer = SortingLayer.SORTING_BACKGROUND
                if entity.SubType == 1 then
                    LIGHTS_MECHANIC:initLightSwitches("off")
                else
                    LIGHTS_MECHANIC:initLightSwitches("on")
                end
                
            end

            if data.State == "on2off" then
                data.State = "off"
            end

            if data.State == "off2on" then
                data.State = "on"
            end

            if data.State == "off" then
                --the lights are out
                if SFXManager():IsPlaying(BotB.Enums.SFX.ASYLUM_LIGHT_LOOP) == true then
                    SFXManager():Stop(BotB.Enums.SFX.ASYLUM_LIGHT_LOOP)
                end
                Game():Darken(1, 1000)
            end

            if data.State == "on" then
                --the lights are on
                --Game():Darken(0.75, 1)
                if SFXManager():IsPlaying(BotB.Enums.SFX.ASYLUM_LIGHT_LOOP) == false then
                    SFXManager():Play(BotB.Enums.SFX.ASYLUM_LIGHT_LOOP,0.25,0,true,1)
                end
                Game():Darken(0, 1)
            end
            
            LIGHTS_MECHANIC:doLightStateUpdates(data.State)
            
        end


    end
    
end
Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, LIGHTS_MECHANIC.playerUpdate, 0)

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

--changes all light switches and buttons to the appropriate state
function LIGHTS_MECHANIC:changeAllLightSwitches()
    local roomEntities = Isaac.GetRoomEntities() -- table
    for i = 1, #roomEntities do
        local entity = roomEntities[i]
        if entity.Type == EntityType.ENTITY_GENERIC_PROP and (entity.Variant == BotB.Enums.Props.POWER_ON_BUTTON.VARIANT or entity.Variant == BotB.Enums.Props.POWER_OFF_BUTTON.VARIANT or entity.Variant == BotB.Enums.Props.LIGHT_SWITCH.VARIANT or entity.Variant == BotB.Enums.Props.ROOM_LIGHT_STATE_TRACKER.VARIANT) then
            
            if entity:GetData().State == "on" then
                entity:GetData().State = "on2off"
            end
            if entity:GetData().State == "off" then
                entity:GetData().State = "off2on"
            end
        end
    end
end

--takes a string reading "on" or "off", changes the state of all switches and buttons appropriately
function LIGHTS_MECHANIC:initLightSwitches(state)
    if state == "on" then
        local roomEntities = Isaac.GetRoomEntities() -- table
        for i = 1, #roomEntities do
            local entity = roomEntities[i]
            if entity.Type == EntityType.ENTITY_GENERIC_PROP and (entity.Variant == BotB.Enums.Props.POWER_ON_BUTTON.VARIANT or entity.Variant == BotB.Enums.Props.POWER_OFF_BUTTON.VARIANT or entity.Variant == BotB.Enums.Props.LIGHT_SWITCH.VARIANT or entity.Variant == BotB.Enums.Props.ROOM_LIGHT_STATE_TRACKER.VARIANT) then
                
                if entity:GetData().State ~= "on" then
                    entity:GetData().State = "on"
                end
            end
        end
    end
    if state == "off" then
        local roomEntities = Isaac.GetRoomEntities() -- table
        for i = 1, #roomEntities do
            local entity = roomEntities[i]
            if entity.Type == EntityType.ENTITY_GENERIC_PROP and (entity.Variant == BotB.Enums.Props.POWER_ON_BUTTON.VARIANT or entity.Variant == BotB.Enums.Props.POWER_OFF_BUTTON.VARIANT or entity.Variant == BotB.Enums.Props.LIGHT_SWITCH.VARIANT or entity.Variant == BotB.Enums.Props.ROOM_LIGHT_STATE_TRACKER.VARIANT) then
                
                if entity:GetData().State ~= "off" then
                    entity:GetData().State = "off"
                end
            end
        end
    end
end


--update all enemies that have a state related to whatever the current light is
function LIGHTS_MECHANIC:doLightStateUpdates(currentLightState)

    local roomEntities = Isaac.GetRoomEntities() -- table
    --local roomhasActiveVantage = false
        for i = 1, #roomEntities do
            local entity = roomEntities[i]
            local npc = entity:ToNPC()
            if LIGHTS_MECHANIC:isItThisNPC(entity, BotB.Enums.Entities.VANTAGE) then
                if currentLightState == "on" then
                    if npc.State ~= 99 then
                        npc.State = 99
                        npc:GetSprite():PlayOverlay("Head")
                    end
                end
                if currentLightState == "off" then
                    if npc.State ~= 101 then
                        npc.State = 101
                        --roomhasActiveVantage = true
                        npc:GetSprite():PlayOverlay("HeadActive")
                    end
                end
            end

            if LIGHTS_MECHANIC:isItThisNPC(entity, BotB.Enums.Entities.NYCTO) then
                if currentLightState == "on" then
                    if npc.State ~= 100 and npc.State ~= 102 then
                        npc.State = 100
                        npc:GetSprite():Play("Reappear")
                    end
                end
                if currentLightState == "off" then
                    if npc.State ~= 101 and npc.State ~= 99 then
                        npc.State = 101
                        npc:GetSprite():PlayOverlay("Vanish")
                    end
                end
            end

            if LIGHTS_MECHANIC:isItThisNPC(entity, BotB.Enums.Entities.HELIO) then
                if currentLightState == "on" then
                    if npc.State ~= 101 and npc.State ~= 99 then
                        npc.State = 101
                        npc:GetSprite():PlayOverlay("Vanish")
                    end
                end
                if currentLightState == "off" then
                    if npc.State ~= 100 and npc.State ~= 102 then
                        npc.State = 100
                        npc:GetSprite():Play("Reappear")
                    end
                end
            end
        end

        if Isaac.CountEntities(nil, Entities.VANTAGE.TYPE, Entities.VANTAGE.VARIANT, 0) < 1 then
            if SFXManager():IsPlaying(BotB.Enums.SFX.VANTAGE_SCREECH_LOOP) == true then
                SFXManager():Stop(BotB.Enums.SFX.VANTAGE_SCREECH_LOOP)
            end
        end
end


function BotB:AsylumEnemyEasterEgg(effect)
    if effect.Variant ~= Isaac.GetEntityVariantByName("Asylum Enemy Easter Egg") then return end
    if effect.SubType == 0 then
        effect:GetSprite():Play("Nycto Dansen")
    end
    if effect.SubType == 1 then
        effect:GetSprite():Play("Helio Dansen")
    end
    if effect.SubType == 2 then
        effect:GetSprite():Play("Polite Vantage")
    end
    if effect.FrameCount % 60 == 0 then
        local str = "This room needs a Light State Tracker! Place one in this room in Basement Renovator!"
        local AbacusFont = Font()
        AbacusFont:Load("font/pftempestasevencondensed.fnt")
        for i = 0, 60 do
            BotB.FF.scheduleForUpdate(function()
                local pos = game:GetRoom():WorldToScreenPosition(Game():GetRoom():GetCenterPos()) + Vector(AbacusFont:GetStringWidth(str) * -0.5,  -(effect.SpriteScale.Y * 35))
                local opacity
                if i >= 30 then
                    opacity = 1 - ((i-30)/30)
                else
                    opacity = i/15
                end
                AbacusFont:DrawString(str .. "!", pos.X, pos.Y, KColor(1,1,1,opacity), 0, false)
            end, i, ModCallbacks.MC_POST_RENDER)
        end
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE,BotB.AsylumEnemyEasterEgg, Isaac.GetEntityVariantByName("Asylum Enemy Easter Egg"))