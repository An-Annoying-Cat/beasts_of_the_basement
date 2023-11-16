local Mod = BotB
local MR_GULLET = {}
local Entities = BotB.Enums.Entities

function MR_GULLET:NPCUpdate(npc)
    if npc.Type == BotB.Enums.Entities.MR_GULLET.TYPE and npc.Variant == BotB.Enums.Entities.MR_GULLET.VARIANT then 
        local sprite = npc:GetSprite()
            local player = npc:GetPlayerTarget()
            local data = npc:GetData()
            local target = npc:GetPlayerTarget()
            local targetpos = target.Position
            local targetangle = (targetpos - npc.Position):GetAngleDegrees()
            local targetdistance = (targetpos - npc.Position):Length()
            local somebodyPathfinder = npc.Pathfinder
            if npc.State == 0 then
                if data.mrGulletHeadCooldown == nil then
                    data.mrGulletHeadCooldown = 4
                    data.botbMrGulletMyHead = Isaac.Spawn(Entities.GULLET.TYPE, Entities.GULLET.VARIANT,1,npc.Position,Vector.Zero,npc):ToNPC()
                    data.botbMrGulletMyHead.Parent = npc
                    for i=2,8,2 do
                        local jemChainEffect = Isaac.Spawn(EntityType.ENTITY_EFFECT,BotB.Enums.Entities.MR_GULLET_CHAIN.VARIANT,i,npc.Position,Vector.Zero,npc):ToEffect()
                        jemChainEffect.Parent = npc
                        jemChainEffect.Child = data.botbMrGulletMyHead
                    end
                    data.botbMrGulletMyHead.Visible = false
                    data.botbMrGulletHeadThrowBaseFrame = 0
                end
                npc.State = 99
            end
            if npc.EntityCollisionClass ~= EntityCollisionClass.ENTCOLL_ALL then
                npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
            end
            if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_GROUND then
                npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
            end
            --states:
            --99: idle
            --100: head out, wait for return
            if npc.State == 99 then
                data.botbMrGulletMyHead.Position = npc.Position
                --npc:ClearEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
                npc:AnimWalkFrame("WalkHori", "WalkVert", 0.1)
                somebodyPathfinder:FindGridPath(targetpos, 0.325, 0, false)
                npc.Velocity = 0.8 * npc.Velocity
                if data.mrGulletHeadCooldown ~= 0 then
                    data.mrGulletHeadCooldown = data.mrGulletHeadCooldown - 1
                else
                    if targetdistance <= 180 then
                        --print("so, head?")
                    npc:PlaySound(SoundEffect.SOUND_MEATHEADSHOOT,1,0,false,math.random(95,105)/100)
                    data.mrGulletHeadCooldown = 60
                    data.botbMrGulletMyHead.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
                    data.botbMrGulletMyHead.Visible = true
                    data.botbMrGulletMyHead.Position = npc.Position
                    data.botbMrGulletMyHead.Velocity = Vector(14,0):Rotated(targetangle)
                    data.botbMrGulletHeadThrowBaseFrame = npc.FrameCount
                    data.botbMrGulletMyHead.State = 99
                    data.botbMrGulletMyHead:GetSprite():Play("Shoot")
                    npc.State = 100
                    
                    sprite:Play("ThrowingHead")
                    end
                    
                end
            end

            if npc.State == 100 then
                npc.Velocity = 0.4 * npc.Velocity
                if (data.botbMrGulletMyHead.Position - npc.Position):Length() <= 30 and npc.FrameCount > (data.botbMrGulletHeadThrowBaseFrame + 20) then
                    npc.State = 99
                    npc:PlaySound(SoundEffect.SOUND_GOOATTACH0,1,0,false,math.random(95,105)/100)
                    data.botbMrGulletMyHead.Visible = false
                    data.botbMrGulletMyHead.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
                    data.botbMrGulletMyHead.Position = npc.Position
                end
                if data.botbMrGulletMyHead:IsDead() == true then
                    local blub = Isaac.Spawn(EntityType.ENTITY_BLUBBER,0,0,npc.Position,npc.Velocity,npc)
                    blub:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                    npc:Remove()
                end
            end

            if npc.State ~= 100 and npc:HasMortalDamage() then
                data.botbMrGulletMyHead:Remove()
            end

    end  
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, MR_GULLET.NPCUpdate, Isaac.GetEntityTypeByName("Mr. Gullet"))


function MR_GULLET:chainEffect(effect)
    effect.Velocity = effect.Velocity:Rotated(effect.Velocity:GetAngleDegrees() + ((4*math.random())-2))
    if effect.Parent == nil or effect.Child == nil then
        effect:Remove()
    else
        effect.Position = effect.Parent.Position + ((effect.Child.Position - effect.Parent.Position) * (1-(effect.SubType/10)))
        if effect.Child:ToNPC().Visible == false then
            effect.Visible = false
        else
            effect.Visible = true
        end
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE,MR_GULLET.chainEffect, Isaac.GetEntityVariantByName("Mr. Gullet Chain"))
