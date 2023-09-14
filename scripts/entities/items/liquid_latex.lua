local Mod = BotB
local LIQUID_LATEX = {}
local Items = BotB.Enums.Items

local LiquidLatexStats={
	DAMAGE=0.6,
}

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
	EID:addCollectible(Isaac.GetItemIdByName("Liquid Latex"), "All tears fired by the player stick to their targets and deal additional damage over time, in addition to slowing them. #Enemies slowed this way leave slowing creep. #{{DamageSmall}} * 0.6")
end


--Stats
function LIQUID_LATEX:onCache(player, cacheFlag)
	if not player:HasCollectible(Items.LIQUID_LATEX) then return end
	--Damage penalty should not stack
	--local Multiplier = player:GetCollectibleNum(Items.LIQUID_LATEX, false)
	if (cacheFlag&CacheFlag.CACHE_DAMAGE)==CacheFlag.CACHE_DAMAGE then
		player.Damage=player.Damage*(LiquidLatexStats.DAMAGE)
	  end
end
Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, LIQUID_LATEX.onCache)

--Shotgun of tears



function LIQUID_LATEX:onTear(tear)
	
	if not tear.Parent:ToPlayer():HasCollectible(Items.LIQUID_LATEX) then  return end
	if tear:HasTearFlags(TearFlags.TEAR_BOOGER) ~= true then
		tear:AddTearFlags(TearFlags.TEAR_BOOGER)
		--print(tear.StickTimer)
	end
	if tear:AddTearFlags(TearFlags.TEAR_GISH) ~= true then
		tear:AddTearFlags(TearFlags.TEAR_GISH)
		--print("gished")
	end
	if tear:AddTearFlags(TearFlags.TEAR_SLOW) ~= true then
		tear:AddTearFlags(TearFlags.TEAR_SLOW)
		--print("slowed")
	end
	tear:GetData().isALiquidLatexTear = true
	--tear.Color = tear.Color*Color(0.25, 0.25, 0.25, 1)
	--local latexTestColor = Color(0.25, 0.25, 0.25)
	tear.Color = tear.Color*Color(0.25, 0.25, 0.25)
	--tear.Color = Color(1,0.25,0.25)

end
Mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, LIQUID_LATEX.onTear)

function LIQUID_LATEX:liquidLatexTearUpdate(tear)
    if tear:GetData().isALiquidLatexTear then
        if tear:IsDead() then
            local liquidLatexCreepPuddle = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_BLACK, 0, tear.Position, Vector.Zero, tear.Parent):ToEffect()
			liquidLatexCreepPuddle.LifeSpan = 30
			--print()
        end
		if tear.StickTarget ~= nil then
			tear.StickTarget:AddSlowing(EntityRef(tear.Parent), 1, 0, Color(0.25, 0.25, 0.25))
			tear.StickTarget:GetData().liquidLatexSlowingSource = tear.Parent
		end
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE,LIQUID_LATEX.liquidLatexTearUpdate)

function LIQUID_LATEX:NPCUpdate(npc)
	if not npc:IsEnemy() then return end
	if not npc:IsVulnerableEnemy() then return end
	local players = getPlayers()
	local doesSomeoneHaveLiquidLatex = false
	for i=1,#players,1 do
		if players[i]:HasCollectible(Items.LIQUID_LATEX) then
			doesSomeoneHaveLiquidLatex = true
		end
	end
	if doesSomeoneHaveLiquidLatex then
		if npc:HasEntityFlags(EntityFlag.FLAG_SLOW) then
			--print("they're slowed")
			if npc.FrameCount % 8 == 0 and npc:GetData().liquidLatexSlowingSource ~= nil then
				local liquidLatexCreepPuddle = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_BLACK, 0, npc.Position, Vector.Zero, npc:GetData().liquidLatexSlowingSource):ToEffect()
				liquidLatexCreepPuddle.LifeSpan = 30
			end
		end
	end
    
end


Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, LIQUID_LATEX.NPCUpdate)