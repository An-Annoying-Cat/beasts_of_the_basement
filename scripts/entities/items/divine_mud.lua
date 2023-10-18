local Mod = BotB
local DIVINE_MUD = {}
local Entities = BotB.Enums.Entities
local Items = BotB.Enums.Items


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

if EID then
	EID:addCollectible(Isaac.GetItemIdByName("Divine Mud"), "Each room, if more than 1 enemy is present, a random enemy will gain {{StatusDivine}} Divine Protection. #{{StatusDivine}} Enemies with Divine Protection cannot die unless they are the last enemy left, but any damage taken by them is redirected into armor-piercing damage spread evenly between every enemy in the room.")
end

local function getVulnerableEnemies()
    local roomEntities = Isaac.GetRoomEntities() -- table
    local vulnerableEnemies = {}
    for i = 1, #roomEntities do
        local entity = roomEntities[i]
        if entity:IsVulnerableEnemy() and EntityRef(entity).IsFriendly == false then
            vulnerableEnemies[#vulnerableEnemies+1] = entity
        end
    end
    
  
	return vulnerableEnemies
end

local function getNonDivineEnemies()
    local roomEntities = Isaac.GetRoomEntities() -- table
    local vulnerableEnemies = {}
    for i = 1, #roomEntities do
        local entity = roomEntities[i]
        if entity:IsVulnerableEnemy() and EntityRef(entity).IsFriendly == false and entity:GetData().botbHasDivine ~= true then
            vulnerableEnemies[#vulnerableEnemies+1] = entity
        end
    end
    
  
	return vulnerableEnemies
end


function DIVINE_MUD:divineMudNewRoom()
    local players = getPlayers()
    local room = Game():GetRoom()
    local amountToDo = 0
    local actuallyHasIt = false
    for i=1,#players do
        local player = players[i]
        if player:HasCollectible(Items.DIVINE_MUD, false) then
            amountToDo = amountToDo + player:GetCollectibleNum(Items.DIVINE_MUD, false)
            actuallyHasIt = true
        end
    end
    if actuallyHasIt ~= true then return end
    --print(amountToDo .. " enemies should get divine")
    if not room:IsClear() and #getVulnerableEnemies() > amountToDo then
        local validForDivine = getVulnerableEnemies()
        local divineQuota = 0
        for i=1,1000 do
            local chosen = validForDivine[math.random(1,#validForDivine)]
            if chosen:GetData().botbHasDivine ~= true then
                chosen:GetData().botbHasDivine = true
                if chosen:GetData().botbDivineIndicator == nil or chosen:GetData().botbDivineIndicator:IsDead() then
                    chosen:GetData().botbDivineIndicator = Isaac.Spawn(Entities.BOTB_STATUS_EFFECT.TYPE,Entities.BOTB_STATUS_EFFECT.VARIANT,0,chosen.Position,Vector.Zero, chosen):ToEffect()
                    chosen:GetData().botbDivineIndicator.Parent = chosen
                    --data.botbDivineIndicator.ParentOffset = Vector(0,-(npc.SpriteScale.Y * 70))
                    chosen:GetData().botbDivineIndicator:GetSprite():Play("Divine", true)
                end
                divineQuota = divineQuota + 1
            end
            if divineQuota >= amountToDo then
                break
            end
        end
    end
    
    
end
Mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, DIVINE_MUD.divineMudNewRoom)

function DIVINE_MUD:rabiesDamageNull(entity,amt,flags,source,_)
    if entity:GetData().botbHasDivine == true then
        local divineDamageTargets = getNonDivineEnemies()
        local divineDamageFactor = 1.5
        if (entity.Type == Entities.HOLY_DIP.TYPE and entity.Variant == Entities.HOLY_DIP.VARIANT) or (entity.Type == Entities.HOLY_SQUIRT.TYPE and entity.Variant == Entities.HOLY_SQUIRT.VARIANT) or (entity.Type == Entities.POPE.TYPE and entity.Variant == Entities.POPE.VARIANT) then
            divineDamageFactor = 0.75
        end
        local amountToHurt = (divineDamageFactor*amt)/#divineDamageTargets
        if amt > 0 then
            SFXManager():Play(BotB.Enums.SFX.DIVINE_PROC,2,16, false, 1, 0)
        end
        for i=1,#divineDamageTargets do
            local dudeToHurt = divineDamageTargets[i]:ToNPC()
            dudeToHurt:TakeDamage(amountToHurt, DamageFlag.DAMAGE_IGNORE_ARMOR, source, 0)
            if amt > 0 then
                dudeToHurt:PlaySound(SoundEffect.SOUND_MEATY_DEATHS,0.5,0,false,2)
            end
        end
        return false
    end
        
end
Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, DIVINE_MUD.rabiesDamageNull)

function DIVINE_MUD:rabiesNPCUpdate(npc)
    local data = npc:GetData()
    if data.botbHasDivine == true then
        if data.botbDivineIndicator == nil or data.botbDivineIndicator:IsDead() then
            data.botbDivineIndicator = Isaac.Spawn(Entities.BOTB_STATUS_EFFECT.TYPE,Entities.BOTB_STATUS_EFFECT.VARIANT,0,npc.Position,Vector.Zero, npc):ToEffect()
            data.botbDivineIndicator.Parent = npc
            --data.botbDivineIndicator.ParentOffset = Vector(0,-(npc.SpriteScale.Y * 70))
            data.botbDivineIndicator:GetSprite():Play("Divine", true)
        end
        --print(#getNonDivineEnemies())
        if #getNonDivineEnemies() < 1 then
            data.botbHasDivine = false
            SFXManager():Play(SoundEffect.SOUND_GLASS_BREAK,0.5,0, false, 1.5, 0)
        end

    end
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, DIVINE_MUD.rabiesNPCUpdate)


function DIVINE_MUD:divineMudEffectUpdate(npc)
    local data = npc:GetData()
    local sprite = npc:GetSprite()
    if npc.Parent ~= nil then
        if sprite:IsPlaying("Divine") then
            if npc.Parent:GetData().botbHasDivine == true then
                npc.Position = Vector(npc.Parent.Position.X, npc.Parent.Position.Y-(npc.SpriteScale.Y * 80))
            else
                npc:Remove()
            end
        end
    else
        npc:Remove()
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, DIVINE_MUD.divineMudEffectUpdate, Entities.BOTB_STATUS_EFFECT.VARIANT)