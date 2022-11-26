-- to do

-- enums file
-- each enemy to their own file so main isnt 38000 lines
-- global variables


local mod = RegisterMod("MMMM", 1)
local ff = FiendFolio --:pleading_face:
local sfx = SFXManager()
local game = Game()
local nilvector = Vector(0,0)

local function LoadScripts(scripts)
	--load scripts
	for i,v in ipairs(scripts) do
		include(v)
	end
end

if not ff then 
    Isaac.DebugString("[BASEMENTS N BEASTIES] hey buddy you kinda need Fiend Folio for this")    
return end

local MinistroVariant = {
    CULO = Isaac.GetEntityVariantByName("Culo")
}
local DipVariant = {
    PING = Isaac.GetEntityVariantByName("Ping")
}
local SkuzzVariant = {
    SKUZZ = Isaac.GetEntityVariantByName("Skuzz"),
    SKOOTER = Isaac.GetEntityVariantByName("Skooter"),
    SUPER_SKOOTER = Isaac.GetEntityVariantByName("Super Skooter")
}
local KeeperVariant = {
    DESIRER = Isaac.GetEntityVariantByName("Desirer"),
    SEDUCER = Isaac.GetEntityVariantByName("Seducer")
    --SLACKER = Isaac.GetEntityVariantByName("Slacker"),
    --BOOMER = Isaac.GetEntityVariantByName("Boomer")
}
local ProjectileVariant = {
    HUMBLED_PROJECTILE = Isaac.GetEntityVariantByName("Humbled Projectile")--,
}
local SpiderVariant = {
    HUMBLED = Isaac.GetEntityVariantByName("Humbled"),
    SEDUCER = Isaac.GetEntityVariantByName("Seducer")
    --SLACKER = Isaac.GetEntityVariantByName("Slacker"),
    --BOOMER = Isaac.GetEntityVariantByName("Boomer")
}
local HiveVariant = {
    SLEAZEBAG = Isaac.GetEntityVariantByName("Sleazebag")--,
}
local MMMM = {}


--Isaac.Spawn(EntityType.ENTITY_MINISTRO, MinistroVariant.CULO, 0, vector(270 + 50*x, 200 + 50*y), Vector(0,0), nil)


function MMMM:MinistroNPCUpdate(Ministro)
    local MinistroData = Ministro:GetData()
    local MinistroSprite = Ministro:GetSprite()

    if type(MinistroData) == "table" and MinistroData.MinistroInit == nil and Ministro:IsActiveEnemy() then
        MinistroData.MinistroInit = true
        if Ministro.Variant == 0 and math.random(100) <= DOT_CHANCE then
            NewMinistro = Isaac.Spawn(EntityType.ENTITY_MINISTRO, MinistroVariant.CULO, 0, Ministro.Position, Vector(0,0), nil)
            NewMinistro:GetData().MinistroInit = true
            Ministro:Remove()
        end
    end

    --if Ministro.Variant == MinistroVariant.CULO and Ministro.GetPlayerTarget() ~= nil then
    --    Ministro.Velocity = (Ministro:GetPlayerTarget().Position - Ministro.Position):Normalized() * Ministro.Velocity:Length()
    --end
    --shamelessly stolen from fiend folio because i am a brainlet who can't code with shit
    --[[
    if MinistroSprite:IsEventTriggered("Shoot") then
		if Ministro.Variant == MinistroVariant.CULO then
			Ministro:PlaySound(ff.Sounds.FunnyFart,1,0,false,math.random(120,150)/100)
            for farts = 0,2,1 do
			    local projectile = Isaac.Spawn(9, 0, 0, Ministro.Position, Vector(math.random(-8,8),math.random(-8,8)), Ministro):ToProjectile();
			    projectile.FallingSpeed = -20
			    projectile.FallingAccel = 1.5
			    projectile.Height = -30
			    projectile.Scale = 1.5
			    projectile.SpawnerEntity = Ministro
			    projectile.Color = Color(5.0,0.5,0.5,1)
			    projectile:GetData().projType = "TrashFart"
            end
		end
	end
    ]]--


end

--General enemy override. Guess we Ministro now
function MMMM:MinistroOverrideTest(npc)
    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()

    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()

    --Culo
    if npc.Type == 305 and MinistroVariant.CULO then 
    if npc.State == 8 then npc.State = 9 sprite:Play("Attack") end 
        if npc.State == 9 then
            if npc.StateFrame == 23 then npc.State = 3 npc.StateFrame = 0 end
            if sprite:IsEventTriggered("Shoot") then
                local randomvalue = math.random(-100,100)/100
                npc:PlaySound(ff.Sounds.FunnyFart,1,0,false,math.random(120,150)/100)
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

    --skooter, super skooter
    if (npc.Variant == SkuzzVariant.SKOOTER or SkuzzVariant.SUPER_SKOOTER) and npc.SubType ~= nil then 
        if sprite:IsPlaying("hopstart") then
            if sprite:GetFrame() == 1 then
                if npc.SubType == 2 then
                    npc:PlaySound(SoundEffect.SOUND_BLOODSHOOT,1,0,false,1)
                local projectile = Isaac.Spawn(9, 0, 0, npc.Position, Vector(math.floor(0.05 * targetdistance * (math.random(8, 10) / 10), 6),0):Rotated(targetangle-15), npc):ToProjectile();
		        projectile.FallingSpeed = -30;
		        projectile.FallingAccel = 2
		        projectile.Height = -10
                local projectile2 = Isaac.Spawn(9, 0, 0, npc.Position, Vector(math.floor(0.05 * targetdistance * (math.random(8, 10) / 10), 6),0):Rotated(targetangle+15), npc):ToProjectile();
		        projectile2.FallingSpeed = -30;
		        projectile2.FallingAccel = 2
		        projectile2.Height = -10
                elseif npc.SubType == 1 then
                npc:PlaySound(SoundEffect.SOUND_BLOODSHOOT,1,0,false,1)
                local projectile = Isaac.Spawn(9, 0, 0, npc.Position, Vector(math.floor(0.05 * targetdistance * (math.random(8, 10) / 10), 6),0):Rotated(targetangle), npc):ToProjectile();
		        projectile.FallingSpeed = -30;
		        projectile.FallingAccel = 2
		        projectile.Height = -10
                end
            end
            --npc:PlaySound(ff.Sounds.FunnyFart,1,0,false,math.random(120,150)/100)
        end
    end

    --Desirer
    if npc.Type == 86 and npc.Variant == KeeperVariant.DESIRER then 
        if npc.State == 8 then npc.State = 9 sprite:Play("ShootDown") end 
            if npc.State == 9 then
                if npc.StateFrame == 23 then npc.State = 3 npc.StateFrame = 0 end
                if sprite:IsEventTriggered("Shoot") then
                    sfx:Play(Isaac.GetSoundIdByName("DesirerAttack"),1,0,false,math.random(90,110)/100)
                    --npc:PlaySound(SoundEffect.SOUND_BOIL_HATCH, 1, 0, false, math.random(75,85)/100)

                    local bullet = Isaac.Spawn(9, 0, 0, npc.Position, Vector(math.floor(0.05 * targetdistance * (math.random(8, 10) / 10), 6),0):Rotated(targetangle), npc):ToProjectile()
                    bullet:AddProjectileFlags(ProjectileFlags.NO_WALL_COLLIDE)
                    bullet.FallingSpeed = -30;
		            bullet.FallingAccel = 2
		            bullet.Height = -10
                    bullet.Parent = npc
                    local bsprite = bullet:GetSprite()
                    bsprite:Load("gfx/humbled_projectile.anm2", true)
                    bsprite:Play("Move", true)
                    --bullet:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)
                    bullet:Update()
                end
            end
        end


    --Seducer
    if npc.Type == 86 and npc.Variant == KeeperVariant.SEDUCER then 
        if npc.State == 8 then npc.State = 9 sprite:Play("ShootDown") end 
            if npc.State == 9 then
                if npc.StateFrame == 23 then npc.State = 3 npc.StateFrame = 0 end
                if sprite:IsEventTriggered("Shoot") then
                    sfx:Play(Isaac.GetSoundIdByName("SeducerAttack"),1,0,false,math.random(110,130)/100)
                    --Creep spawning
                    local creep = Isaac.Spawn(1000, 22, 0, npc.Position, Vector(0,0), npc)
				    creep.SpriteScale = creep.SpriteScale * 3
				    for i = 1, 3 do
				    	local creep = Isaac.Spawn(1000, 22, 0, npc.Position + 2*(Vector.FromAngle(i * (360 / 3)) * 22), Vector(0,0), npc)
				    end
                    --Fire a projectile
                    local bullet = Isaac.Spawn(9, 0, 0, npc.Position, Vector(math.floor(0.05 * targetdistance * (math.random(8, 10) / 10), 6),0):Rotated(targetangle), npc):ToProjectile()
                    bullet.FallingSpeed = -30;
		            bullet.FallingAccel = 2
		            bullet.Height = -10
                    bullet.Parent = npc
				    	
				    
                end
            end

            if sprite:IsEventTriggered("Land") then
                local creep = Isaac.Spawn(1000, 22, 0, npc.Position, nilvector, npc)
				creep.SpriteScale = creep.SpriteScale * 2
            end
        end



    --Sleazebag (This just plays the wheeze sound)
    if npc.Type == 22 and npc.Variant == HiveVariant.SLEAZEBAG and npc.SubType ~= nil then 
        if npc.State == 8 then npc.State = 99 sprite:Play("HeadAttack") end 
            if npc.State == 99 then
                if npc.StateFrame == 23 then npc.State = 3 npc.StateFrame = 0 end
                if sprite:IsEventTriggered("Shoot") then
                    sfx:Play(Isaac.GetSoundIdByName("Wheeze"),1,0,false,math.random(75, 85)/100)
                    --npc:PlaySound(SoundEffect.SOUND_BOIL_HATCH, 1, 0, false, math.random(75,85)/100)

                    --local spawnedSkuzz = Isaac.Spawn(666, 60, 0, npc.Position, Vector.Zero, npc)
                end
            end
    end
    --Convert flies spawned by Sleazebags into Skuzzes
    if npc.Type == 13 or npc.Type == 18 or npc.Type == 14 then 
        if npc.SpawnerVariant == HiveVariant.SLEAZEBAG then
            if npc.Type == 14 then
                --Convert Pooters into Skooters
                npc:Morph(Isaac.GetEntityTypeByName("Skooter"), Isaac.GetEntityVariantByName("Skooter"), 1, 0)
            elseif npc.Type == 13 or npc.Type == 18 then
                
                --Convert Flies and Attack Flies into normal Skuzzes
                npc:Morph(Isaac.GetEntityTypeByName("Skuzz"), Isaac.GetEntityVariantByName("Skuzz"), 0, 0)
            end
        end
        
    end

end

function MMMM:BulletCheck(bullet)
    --Humbled projectile spawnstuff
    if bullet.Parent ~= nil and bullet.Parent.Variant == KeeperVariant.DESIRER then
        
      --effect:PlaySound(Isaac.GetSoundIdByName("AcmeDeath"),1,0,false,math.random(120,150)/100)
      if bullet:IsDead() then
        dumbass = Isaac.GetEntityVariantByName("Humbled")
        sfx:Play(SoundEffect.SOUND_CLAP,1,0,false,math.random(120,150)/100)
        idiot = Isaac.Spawn(EntityType.ENTITY_SWARM_SPIDER, dumbass, 0, bullet.Position, Vector.Zero, bullet.Parent)
        idiot:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
      end
    end

    --Seducer projectiles spawn red creep when they splat
    if bullet.Parent ~= nil and bullet.Parent.Variant == KeeperVariant.SEDUCER then
        
        
        if bullet:IsDead() then
            sfx:Play(SoundEffect.SOUND_ANIMAL_SQUISH,1,0,false,math.random(120,150)/100)
            local creep = Isaac.Spawn(1000, 22, 0, bullet.Position, Vector(0,0), bullet)
            creep.SpriteScale = creep.SpriteScale * 1.5
        end
      end
    

end



--[[Skooter and Super Skooter test
function MMMM:SkuzzOverrideTest(npc)
    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    if npc.Type == 666 and npc.Variant == 660 and npc.SubType == 1 then 
        if sprite:IsEventTriggered("Shoot") then
            npc:PlaySound(ff.Sounds.FunnyFart,1,0,false,math.random(120,150)/100)
        end
    end
end
--]]
--[[Anvil shit
function MMMM:AnvilEffectTest(npc)
    local sprite = npc:GetSprite()
    --Anvil...
    if npc.Type == 1000 and npc.Variant == 853983151 then 
        if sprite:IsEventTriggered("Anvil") then
            npc:PlaySound(Isaac.GetSoundIdByName("AcmeDeath"),1,0,false,math.random(120,150)/100)
            
        end
    end
end
]]--


function MMMM:anvilEffect(effect)
    
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



--Generalized death checker
function MMMM:NPCDeathCheck(npc)
    local sprite = npc:GetSprite()
    local player = npc:GetPlayerTarget()
    --Is it an Acme?
    if npc.Type == 10 and Isaac.GetEntityVariantByName("Acme") then 
        --sprite:Play("Death")
        --npc:PlaySound(Isaac.GetSoundIdByName("AcmeDeath"),1,0,false,math.random(120,150)/100)
        --npc:PlaySound(ff.Sounds.FunnyFart,1,0,false,math.random(120,150)/100)
        anvil = Isaac.GetEntityVariantByName("Acme's Anvil")
        AcmeDeathAnvil = Isaac.Spawn(EntityType.ENTITY_EFFECT,anvil,0,npc.Position,Vector(0,0),npc)
        --mod.AcmeDeathEffect(npc)
    end
end

--Test for Acme death. Using code from Tagbag
function mod.AcmeDeathEffect(npc)
    anvil = Isaac.GetEntityVariantByName("Acme's Anvil")
    Isaac.Spawn(EntityType.ENTITY_EFFECT,anvil,0,npc.Position,Vector(0,0),npc)
end
acmeAnvil = Isaac.GetEntityVariantByName("Acme's Anvil")
--Tutorial shit
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE,MMMM.MinistroOverrideTest)
--mod:AddCallback(ModCallbacks.MC_NPC_UPDATE,MMMM.SkuzzOverrideTest)
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE,MMMM.anvilEffect, Isaac.GetEntityVariantByName("Acme's Anvil"))
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, MMMM.MinistroNPCUpdate, EntityType.ENTITY_MINISTRO)
--Culo poop spawn
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, v)
    local d = v:GetData()
    if d.fartTearPoopEdition == true then
        if Game():GetRoom():IsPositionInRoom(v.Position,0) then Isaac.GridSpawn(GridEntityType.GRID_POOP,0,v.Position,true) end
        game:ButterBeanFart(v.Position, 140, v, true, false)
    end
end, EntityType.ENTITY_PROJECTILE)




--Thank you Danial for this 
--[[
function mod:NPCAIChecker(npc,offset)
    local data = npc:GetData()
        Isaac.RenderText(npc.Type .. "." .. npc.Variant .. "." .. npc.SubType, Isaac.WorldToScreen(npc.Position).X - 20,Isaac.WorldToScreen(npc.Position).Y-40,1,1,1,1)
        Isaac.RenderText(npc.State .. "          " .. npc.StateFrame, Isaac.WorldToScreen(npc.Position).X - 35,Isaac.WorldToScreen(npc.Position).Y-30,1,1,1,1)
        Isaac.RenderText(npc.I1 .. "          " .. npc.I2, Isaac.WorldToScreen(npc.Position).X - 35,Isaac.WorldToScreen(npc.Position).Y-20,1,1,1,1)
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER,mod.NPCAIChecker)
--]]
--Death checker
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, MMMM.NPCDeathCheck)

--Projectile checker
mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, MMMM.BulletCheck)