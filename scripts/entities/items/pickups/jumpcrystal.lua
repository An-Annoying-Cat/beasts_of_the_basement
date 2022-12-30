local Mod = BotB
sfx = SFXManager()
game = Game()
local JUMPCRYSTAL = {}
local canRefreshCrystals = false

--Yoinking this from Fiend Folio--unbiased pickup spawns


function JUMPCRYSTAL:JCTouched(player,collider,_)
    local data = collider:GetData()
    --if the collider is a jump crystal, the player is a player, the player has a jump, and the crystal itself is active
    if collider.Type == BotB.Enums.Pickups.JUMPCRYSTAL.TYPE and collider.Variant == BotB.Enums.Pickups.JUMPCRYSTAL.VARIANT and player.Type == Isaac.GetEntityTypeByName("Player") and player:GetData().hasBotBCrawlspaceJump ~= true and data.jumpCrystalIsActive == true then
        local sprite = collider:GetSprite()
        local pdata = player:GetData()
        local colliderNPC = collider:ToNPC()
        sfx:Play(SoundEffect.SOUND_THREAD_SNAP,2,0,false,math.random(80, 120)/100)
        pdata.hasBotBCrawlspaceJump = true
        colliderNPC.State = 100
        sprite:Play("Inactive")
        return true
    end
end

function JUMPCRYSTAL:JCUpdate(npc)
    if npc.Type == BotB.Enums.Pickups.JUMPCRYSTAL.TYPE and npc.Variant == BotB.Enums.Pickups.JUMPCRYSTAL.VARIANT then
        local data = npc:GetData()
        local sprite = npc:GetSprite()
        --local pdata = player:GetData()
        if data.PleaseStayHere == nil then
            data.PleaseStayHere = npc.Position
            data.jumpCrystalIsActive = true
            npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
            Isaac.GridSpawn(GridEntityType.GRID_GRAVITY, 0, npc.Position, true)
        end
        npc.Position = data.PleaseStayHere
        npc.Velocity = Vector.Zero

        if npc.State == 1 then
            npc.State = 99
            sprite:Play("Idle")
        end

        if npc.State == 99 then
            --happy happy ha-ppy! (ding ding ding ding ding, ding)
        end
        --Inactive outline
        if npc.State == 100 then
            if data.jumpCrystalIsActive == true then
                data.jumpCrystalIsActive = false
            end
            if canRefreshCrystals == true then
                npc.State = 101
                sprite:Play("Reform")
            end
        end
        --Reforming animation
        if npc.State == 101 then
            if sprite:IsEventTriggered("ReActive") then
                data.jumpCrystalIsActive = true
            end
            if sprite:IsEventTriggered("Back") then
                npc.State = 99
                sprite:Play("Idle")
            end
        end
        
    end
    --print(Card.NUM_CARDS)
end

function JUMPCRYSTAL:PlayerUpdate(player)
    local data = player:GetData()
    local room = Game():GetRoom()
    --If player is in crawlspace
    if room:GetType() == RoomType.ROOM_DUNGEON then

        --Init ability to jump to false
        if data.hasBotBCrawlspaceJump == nil then
            data.hasBotBCrawlspaceJump = false
            data.BotBJumpFrameAfterImageMax = 20
            data.BotBJumpFrameAfterImage = 0
        end

        --All 4 dash directions
        if Input.IsActionPressed(ButtonAction.ACTION_SHOOTUP, 0) and data.hasBotBCrawlspaceJump == true then
            --print("JUMP!")
            sfx:Play(SoundEffect.SOUND_FETUS_JUMP,2,0,false,math.random(60, 80)/100)
            sfx:Play(SoundEffect.SOUND_SUMMON_POOF,2,0,false,math.random(60, 80)/100)
            player.Velocity = Vector(0, -7)
            data.BotBJumpFrameAfterImage = data.BotBJumpFrameAfterImageMax
            data.hasBotBCrawlspaceJump = false
        end

        if Input.IsActionPressed(ButtonAction.ACTION_SHOOTDOWN, 0) and data.hasBotBCrawlspaceJump == true then
            --print("JUMP!")
            sfx:Play(SoundEffect.SOUND_FETUS_JUMP,2,0,false,math.random(60, 80)/100)
            sfx:Play(SoundEffect.SOUND_SUMMON_POOF,2,0,false,math.random(60, 80)/100)
            player.Velocity = Vector(0, 7)
            data.BotBJumpFrameAfterImage = data.BotBJumpFrameAfterImageMax
            data.hasBotBCrawlspaceJump = false
        end

        if Input.IsActionPressed(ButtonAction.ACTION_SHOOTRIGHT, 0) and data.hasBotBCrawlspaceJump == true then
            --print("JUMP!")
            sfx:Play(SoundEffect.SOUND_FETUS_JUMP,2,0,false,math.random(60, 80)/100)
            sfx:Play(SoundEffect.SOUND_SUMMON_POOF,2,0,false,math.random(60, 80)/100)
            player.Velocity = Vector(28, 0)
            data.BotBJumpFrameAfterImage = data.BotBJumpFrameAfterImageMax
            data.hasBotBCrawlspaceJump = false
        end

        if Input.IsActionPressed(ButtonAction.ACTION_SHOOTLEFT, 0) and data.hasBotBCrawlspaceJump == true then
            --print("JUMP!")
            sfx:Play(SoundEffect.SOUND_FETUS_JUMP,2,0,false,math.random(60, 80)/100)
            sfx:Play(SoundEffect.SOUND_SUMMON_POOF,2,0,false,math.random(60, 80)/100)
            player.Velocity = Vector(-28, 0)
            data.BotBJumpFrameAfterImage = data.BotBJumpFrameAfterImageMax
            data.hasBotBCrawlspaceJump = false
        end
        
        --Refresh crystals switch
        --If you exit a gravity zone, or touch the ground
        --Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.TEAR_POOF_A,0,Vector(player.Position.X,player.Position.Y+25),Vector(0,0),player)
        --print(room:GetGridCollisionAtPos(Vector(player.Position.X,player.Position.Y+25)))
        if player:HasEntityFlags(EntityFlag.FLAG_APPLY_GRAVITY) ~= true then
            canRefreshCrystals = true
            --data.hasBotBCrawlspaceJump = false
        elseif room:GetGridCollisionAtPos(Vector(player.Position.X,player.Position.Y+25)) ~= 0 then
            canRefreshCrystals = true
            --data.hasBotBCrawlspaceJump = false
        else
            canRefreshCrystals = false
        end

        
        



    else
        --set to false upon crawlspace exit
        if data.hasBotBCrawlspaceJump == nil then
            data.hasBotBCrawlspaceJump = false
        elseif data.hasBotBCrawlspaceJump ~= false then
            data.hasBotBCrawlspaceJump = false
        end
    end
    --print(Card.NUM_CARDS)
    if data.BotBJumpFrameAfterImage ~= 0 and data.BotBJumpFrameAfterImage ~= nil then
        if player.FrameCount % 4 == 0 then
            local spriteAfterImage = Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.SPRITE_TRAIL,0,player.Position,Vector(0,0),player):ToEffect()
            spriteAfterImage.Parent = player
            spriteAfterImage.Timeout = 12
        end
        data.BotBJumpFrameAfterImage = data.BotBJumpFrameAfterImage - 1
    end
end



Mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_COLLISION,JUMPCRYSTAL.JCTouched,0)
Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE,JUMPCRYSTAL.PlayerUpdate,0)
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE,JUMPCRYSTAL.JCUpdate,BotB.Enums.Pickups.JUMPCRYSTAL.TYPE)