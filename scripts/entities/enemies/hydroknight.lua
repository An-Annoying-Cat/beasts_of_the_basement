local Mod = BotB
local HYDROKNIGHT = {}
local Entities = BotB.Enums.Entities

function HYDROKNIGHT:NPCUpdate(npc)

    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()

    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()


    if npc.Type == BotB.Enums.Entities.HYDROKNIGHT.TYPE and npc.Variant == BotB.Enums.Entities.HYDROKNIGHT.VARIANT then 
        if npc.State == 8 then 
            if npc.FrameCount % 4 == 0 then
                local splash = Isaac.Spawn(1000, 7002, 0, npc.Position, Vector.Zero, npc)
                splash:Update()
                --Big stationary projectile
                local params = ProjectileParams()
                params.HeightModifier = 10
                params.FallingSpeedModifier = -12
                params.FallingAccelModifier = 0.7
                params.Variant = 4
                npc:FireProjectiles(npc.Position, Vector.Zero, 0, params) 
                --Tiny side projectiles
                local sideParams = ProjectileParams()
                sideParams.HeightModifier = 10
                sideParams.Scale = 0.25
                sideParams.FallingSpeedModifier = -6
                sideParams.FallingAccelModifier = 0.95
                sideParams.Variant = 4
                npc:FireProjectiles(npc.Position, 0.2*(npc.Velocity:Rotated(120)), 0, sideParams)
                npc:FireProjectiles(npc.Position, 0.2*(npc.Velocity:Rotated(-120)), 0, sideParams)
            end
            local creep = Isaac.Spawn(1000, 22,  0, npc.Position, Vector(0, 0), npc):ToEffect()
            creep.Scale = creep.Scale * 0.75
            local color = Color(1, 1, 1, 1, 0, 0, 0)
            color:SetColorize(3.5, 3.75, 4, 1)
            local creepSprite = creep:GetSprite()
            creepSprite.Color = color
            creep:SetTimeout(creep.Timeout - 94)
            --creep:GetSprite():ReplaceSpritesheet(0, "gfx/effects/effect_waterpool.png")
            creep:Update()
            npc.Velocity = (0.85 * npc.Velocity) + (0.15*(2*npc.Velocity))
        end
    end
end


Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, HYDROKNIGHT.NPCUpdate, Isaac.GetEntityTypeByName("Hydro Knight"))