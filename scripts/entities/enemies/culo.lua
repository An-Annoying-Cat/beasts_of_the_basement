local Mod = BotB
local CULO = {}
local Entities = BotB.Enums.Entities

function CULO:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()

    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()

    --Culo
    if npc.Type == Entities.CULO.TYPE and npc.Variant == Entities.CULO.VARIANT then 
        if npc.State == 8 then npc.State = 9 sprite:Play("Attack") end 
            if npc.State == 9 then
                if npc.StateFrame == 23 then npc.State = 3 npc.StateFrame = 0 end
                if sprite:IsEventTriggered("Shoot") then
                    local randomvalue = math.random(-100,100)/100
                    npc:PlaySound(BotB.FF.Sounds.FunnyFart,1,0,false,math.random(120,150)/100)
                for farts = 0,2,1 do
                    local projectile = Isaac.Spawn(9, 0, 0, npc.Position, Vector(math.random(-8,8),math.random(-8,8)), npc):ToProjectile();
                    projectile.FallingSpeed = -15 + 5*randomvalue
                    projectile.FallingAccel = 1.5 + 0.5*randomvalue
                    projectile.Height = -30 + 10*randomvalue
                    projectile.Scale = 1.5
                    local color = Color(1,1,0,1,100 / 255,50 / 255,30 / 255)
                    color:SetColorize(1,1,1,1)
                    projectile.Color = color
                    projectile:GetData().fartTearPoopEdition = true
                end
                end
            end
        end
end


Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, CULO.NPCUpdate, Isaac.GetEntityTypeByName("Culo"))