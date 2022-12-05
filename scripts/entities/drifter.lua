Mod = BotB
DRIFTER = {}
local Entities = BotB.Enums.Entities
print("COCK")

--When player is within a few grids of them they should get a dialogue prompt
--From there, choose dialogue from either floor pool, or room pool
--Using the anm2 to make randomized appearances. All animations need to have the same naming scheme.
--Table of costume string and the sound id they should make when talked with?
--Table should have dialogue too, maybe

local drifterSkins = {
    --TEST
    {"Test",SoundEffect.SOUND_ANIMAL_SQUISH,1.5},
    --ALT
    {"Alt",SoundEffect.SOUND_ISAACDIES,2.0}
}

function DRIFTER.drifterUpdate(npc)
    local sprite = npc:GetSprite()
    local data = npc:GetData()
    if npc.Type == Entities.DRIFTER.TYPE and npc.Variant == Entities.DRIFTER.VARIANT then
        --Initialize...
        print("AND BALLS")
        --Pick skin at random
        
        npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        

        if data.binted == nil then
            print("cock")
            npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            data.skinIndex = rng:RandomIntStartSeed(#drifterSkins)
            print("skin index is "..data.SkinIndex)
            --data.skinTable = drifterSkins[data.skinIndex]
            sprite:Play(drifterSkins[data.skinIndex][1].."Idle")
            data.binted = true
            sfx:Play(BotB.Enums.SFX.TIPPYTAPSTEP, 3, 0, false, 0.5)
        end
    end
end

Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, DRIFTER.drifterUpdate, Isaac.GetEntityTypeByName("Drifter"))