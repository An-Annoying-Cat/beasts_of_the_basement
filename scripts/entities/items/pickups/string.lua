local Mod = BotB
local STRING = {}

function STRING:RunInit(continued)
    if continued == false then
        TSIL.SaveManager:AddPersistentVariable(Mod, StringCount, 0, VariablePersistentMode.REMOVE_RUN)
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, STRING.StringUpdate)

function STRING:StringTouch(pickup,collider,_)
    local data = pickup:GetData()
    local sprite = pickup:GetSprite()

    if Mod.FF:EpiphanyPickupCheck(pickup, collider) then return end
    if collider.Type == EntityType.ENTITY_PLAYER then
        if sprite:WasEventTriggered("DropSound") or sprite:IsPlaying("Idle") or sprite:IsFinished("Idle") then

            --sfx:Play(SoundEffect.SOUND_THREAD_SNAP,2,0,false,math.random(80, 120)/100)
            sprite:Play("Collect")
            TSIL.SaveManager:SetPersistentVariable(Mod, StringCount, TSIL.SaveManager.GetPersistentVariable(Mod, StringCount) + 1)

            pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            pickup.Velocity = Vector.Zero

            Game():SetStateFlag(GameStateFlag.STATE_HEART_BOMB_COIN_PICKED, true)

            print(TSIL.SaveManager.GetPersistentVariable(Mod, StringCount))
            
            pickup:Die()
        end
    end
end
Mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, STRING.StringTouch, Mod.Enums.Pickups.STRING.VARIANT)


function STRING:StringUpdate(pickup)
    local data = pickup:GetData()
    local sprite = pickup:GetSprite()
end
Mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, STRING.StringUpdate, Mod.Enums.Pickups.STRING.VARIANT)