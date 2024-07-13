
--Trying to rework the Future steven textbox thing from the ground up. 
--Going to try and get permission from the Future devs beforehand.


--[[
local mod = TheFuture
local rng = RNG()
local game = Game()
local sfx = SFXManager()

mod.WasEnteredFromAltPath = false
mod.StevenChance = 0.33

local font = Font()
font:Load("mods/thefuture_2993558907/resources/font/TheFuture.fnt")

local mouth = Sprite()
mouth:Load("gfx/effects/effect_stevennpc.anm2", true)
mouth:Play("MouthIdle", true)

local textbox = Sprite()
textbox:Load("gfx/effects/steventextbox.anm2", true)
textbox.Scale = textbox.Scale*0.8

local swallow = Sprite()
swallow:Load("gfx/effects/stevenswallow.anm2", true)
swallow.Scale = swallow.Scale * 1.1

local function IsTaintedChar(player)
	return player:GetPlayerType() == Isaac.GetPlayerTypeByName(player:GetName(), true)
end


local stevenRoomsList = StageAPI.RoomsList("FutureStevenRooms", require("resources.luarooms.steven_rooms"))

if MinimapAPI then
	local mapicon = Sprite()
	mapicon:Load("gfx/ui/minimapapi/mapicon_steven.anm2", true)
	mapicon:SetFrame("CustomIconStevenNPC", 0)
	MinimapAPI:AddIcon("StevenNPC", mapicon)
end

StageAPI.AddEntityPersistenceData({
    Type = EntityType.ENTITY_EFFECT,
    Variant = mod.Effects.StevenNPC.Var
})

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_, effect)
	local data = effect:GetData()
	local sprite = effect:GetSprite()
	if mod.HasSpokenToSteven then
		sprite:Play("OpenWideLoop")
	end
	mouth:Play("MouthIdle", true)
	
	local target = mod:GetClosestEntity(mod:GetAllPlayers(), effect.Position)
	local targetangle = (effect.Position - target.Position):GetAngleDegrees()
	
	if (target:GetPlayerType() == PlayerType.PLAYER_THELOST and sprite:GetAnimation() ~= "IdleTalking") or target:GetPlayerType() == PlayerType.PLAYER_THELOST_B then
		targetangle = 0
	end
	
	data.eyeangle = targetangle
	
	if MinimapAPI then
		local minimaproom = MinimapAPI:GetRoomByIdx(game:GetLevel():GetCurrentRoomIndex())
		minimaproom.PermanentIcons = {"StevenNPC"}
	end
	
	for i = 0, 5 do
		local light = Isaac.Spawn(1000, EffectVariant.LIGHT, 0, effect.Position, Vector.Zero, effect):ToEffect() --This is a stupid way to do this but whatever!!
		light:FollowParent(effect)
	end
end, mod.Effects.StevenNPC.Var)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, effect)
	local data = effect:GetData()
	local sprite = effect:GetSprite()
	for i, player in pairs(mod:GetAllPlayers()) do
		if player.Position:Distance(effect.Position) < 70 then
			if sprite:GetAnimation() ~= "OpenWideLoop" then
				player.Velocity = mod:Lerp(player.Velocity, (player.Position-effect.Position), (70-player.Position:Distance(effect.Position))/1000)
			elseif player.Position:Distance(effect.Position) < 30 then
				sprite:Play("Chomp")
				sfx:Play(mod.Sounds.StevenSwallow)
				player.Visible = false
				player:GetData().EATED = true
				player.ControlsEnabled = false
				
				mod:scheduleForUpdate(function()
					mod.RenderSwallow = true
					swallow:Play("Swallow")
				end, 10)
				
				break
			end
			
			if sprite:GetAnimation() == "Idle" then
				sfx:Play(mod.Sounds.StevenNPC)
				mouth:Play("MouthTalking")
				textbox:Play("Appear")
				sprite:Play("IdleTalking")
				
				data.Dialogue = mod:PickStevenDialogue(player)
			end
		end
	end
	
	if data.Dialogue and effect.FrameCount % 2 == 0 and textbox:GetAnimation() == "Idle" then
		data.TextLine = data.TextLine or 1
		data.TextCharacters = data.TextCharacters or 1
		
		data.TextCharacters = data.TextCharacters + 1
		
		if #string.sub(data.Dialogue[data.TextLine], 1, data.TextCharacters) == #data.Dialogue[data.TextLine] then
			data.TextDelay = data.TextDelay or 10
			data.TextDelay = data.TextDelay - 1
			
			if data.TextDelay == 0 then
				if data.Dialogue[data.TextLine + 1] then
					data.TextLine = data.TextLine + 1
					data.TextCharacters = 1
				else
					data.Dialogue = nil
					sprite:Play("OpenWideBegin")
					mod.HasSpokenToSteven = true
				end
				data.TextDelay = nil
			end
		end
	end
	
	if sprite:IsFinished("OpenWideBegin") then
		mouth:Play("MouthIdle")
		textbox:Play("Disappear")
		sprite:Play("OpenWideLoop")
	end
	
	textbox:Update()
	if textbox:IsFinished("Appear") then
		textbox:Play("Idle")
	end
end, mod.Effects.StevenNPC.Var)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, function(_, effect)
	local data = effect:GetData()
	local sprite = effect:GetSprite()
	if sprite:GetAnimation() == "Idle" or sprite:GetAnimation() == "IdleTalking" then
        data.eyeangle = data.eyeangle or 0
        data.eyeoffset = -5
        if not game:IsPaused() then
			local target = mod:GetClosestEntity(mod:GetAllPlayers(), effect.Position)
			
			local targetangle = (effect.Position - target.Position):GetAngleDegrees()
			
			if (target:GetPlayerType() == PlayerType.PLAYER_THELOST and sprite:GetAnimation() ~= "IdleTalking") or target:GetPlayerType() == PlayerType.PLAYER_THELOST_B then
				targetangle = 0
			end
			
			data.eyeangle = targetangle
			
            if effect.Visible == false then
                mouth.Color = Color(1,1,1,0)
            else
                mouth.Color = sprite.Color
            end
            mouth.Scale = sprite.Scale
			
			if mouth:GetAnimation() == "MouthTalking" then
				mouth:SetFrame(sprite:GetFrame())
			end
        end
        local renderoffset = Vector(data.eyeoffset,0):Rotated(data.eyeangle) + Vector(0, -10)
        local renderpos = effect.Position + Vector(renderoffset.X * mouth.Scale.X, renderoffset.Y * mouth.Scale.Y)
        mouth:Render(Isaac.WorldToScreen(renderpos), Vector.Zero, Vector.Zero)
    end
end, mod.Effects.StevenNPC.Var)

StageAPI.AddCallback("TheFuture", "POST_HUD_RENDER", 1, function(isPauseMenuOpen, pauseMenuDarkPct)
	if not isPauseMenuOpen then
		for i, entity in pairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, mod.Effects.StevenNPC.Var)) do
			local effect = entity:ToEffect()
			local data = effect:GetData()
			local sprite = effect:GetSprite()
			
			
			if sprite:GetAnimation() ~= "Idle" then
				local renderpos = effect.Position + Vector(0, -100)
				textbox:Render(Isaac.WorldToScreen(renderpos), Vector.Zero, Vector.Zero)
			end
			
			if sprite:GetAnimation() == "IdleTalking" and data.Dialogue and data.Dialogue[data.TextLine] then
				local dialougetosplit
				local rendertext = string.sub(data.Dialogue[data.TextLine], 1, data.TextCharacters)
				if #data.Dialogue[data.TextLine] > 14 then
					dialougetosplit = data.Dialogue[data.TextLine]
				end
				
				if dialougetosplit then
					local cutoffspace
					for i = math.floor(#dialougetosplit/2), 1, -1 do
						local str = string.sub(dialougetosplit, i, i)
						--print(i, str, #str)
						if str == " " then
							cutoffspace = i
							break
						end
					end
					
					local targetpos = Isaac.WorldToScreen(effect.Position + Vector(-50, -180))
					font:DrawStringScaled(string.sub(rendertext, 1, cutoffspace-1), targetpos.X,targetpos.Y,0.5,0.5,KColor(1,1,1,1),50,true)
					
					targetpos = Isaac.WorldToScreen(effect.Position + Vector(-50, -160))
					font:DrawStringScaled(string.sub(rendertext, cutoffspace+1, #rendertext), targetpos.X,targetpos.Y,0.5,0.5,KColor(1,1,1,1),50,true)
				else
					local targetpos = Isaac.WorldToScreen(effect.Position + Vector(-50, -170))
					font:DrawStringScaled(rendertext, targetpos.X,targetpos.Y,0.5,0.5,KColor(1,1,1,1),50,true)
				end
			end
		end
		
		if mod.RenderSwallow then
			swallow:Render(StageAPI.GetScreenCenterPosition(), Vector.Zero, Vector.Zero)
		end
	end
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function(_)
	local level = game:GetLevel()
	local chance = mod.StevenChance
	if mod:IsPlayerWithCollectible(CollectibleType.COLLECTIBLE_STEVEN) then
		chance = chance + 0.1
	end
	if not game:IsGreedMode() and Isaac.GetChallenge() == Challenge.CHALLENGE_NULL and level:GetStage() == LevelStage.STAGE2_2 --and not BasementRenovator
	and not (StageAPI.InOverriddenStage() and not (StageAPI.GetCurrentStage().Name == "Catacombs 2" or StageAPI.GetCurrentStage().StageHPNumber == 4)) and rng:RandomFloat() <= chance then
		mod:MakeStevenRoom()
	end
	mod.HasSpokenToSteven = false
end)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function(_)
	if mod.RenderSwallow then
		swallow:Update()
		
		if swallow:IsEventTriggered("Teleport") then
			--DO THE FUTURE THING
			if game:GetLevel():GetStageType() == StageType.STAGETYPE_REPENTANCE or game:GetLevel():GetStageType() == StageType.STAGETYPE_REPENTANCE_B then
				mod.WasEnteredFromAltPath = true
			else
				mod.WasEnteredFromAltPath = false
			end
			StageAPI.GotoCustomStage(mod.Stage, false)
			for i, player in pairs(mod:GetAllPlayers()) do
				if player:GetData().EATED then
					player:GetData().EATED = false
					player.Visible = true
					player.ControlsEnabled = true
				end
			end
		end
		
		if swallow:IsFinished("Swallow") then
			mod.RenderSwallow = false
			swallow:Play("Idle")

			game:GetHUD():ShowItemText("The Future")
		end
	end
end)

--Thanks Fiend Folio
local function IsRoomDeadEnd(index)
	local level = game:GetLevel()
	local connections = 0

	for _, shift in pairs({1, -1, 13, -13}) do
		local desc = level:GetRoomByIdx(index + shift)
		if desc.Data then
			connections = connections + 1
		end
	end

	return connections == 1
end

local function GetRoomToOverride(rng)
	local level = game:GetLevel()
	local roomsList = level:GetRooms()

	local deadEndIndexes = {}

	for i = 0, #roomsList - 1 do
		local desc = roomsList:Get(i)
		if desc.Data.Shape == RoomShape.ROOMSHAPE_1x1 and desc.Data.Type == RoomType.ROOM_DEFAULT and desc.Data.Subtype == 0 then
			if IsRoomDeadEnd(desc.SafeGridIndex) then
				table.insert(deadEndIndexes, desc.SafeGridIndex)
			end
		end
	end

	return deadEndIndexes[rng:RandomInt(#deadEndIndexes) + 1]
end

function mod:MakeStevenRoom()
	local level = game:GetLevel()
	local toOverride = GetRoomToOverride(rng)
	if not toOverride then
		return
	end
	local overwriteDesc = level:GetRoomByIdx(toOverride)
	local newData = StageAPI.GetGotoDataForTypeShape(RoomType.ROOM_DEFAULT, RoomShape.ROOMSHAPE_1x1)
	
	overwriteDesc.Data = newData
	local stevenRoom = StageAPI.LevelRoom{
		RoomType = RoomType.ROOM_DEFAULT,
		RequireRoomType = false,
		RoomsList = stevenRoomsList,
		RoomDescriptor = overwriteDesc
	}
	StageAPI.SetLevelRoom(stevenRoom, overwriteDesc.ListIndex)
end

mod:AddCallback(ModCallbacks.MC_EXECUTE_CMD, function(_, cmd, params)
	if cmd == "opensesasteve" then
		mod.StevenChance = 1
		Isaac.ConsoleOutput("Your chariot awaits...")
	end
end)

mod:AddCallback(ModCallbacks.MC_PRE_MOD_UNLOAD, function(_, newmod)
	if newmod.StevenChance and newmod.StevenChance == 1 then
		Isaac.ConsoleOutput("Steven Chance reset, use opensesasteve again if you want him guaranteed!                                           ")
	end
end)

function mod:PickStevenDialogue(player)
	local typ = player:GetPlayerType()
	local name = player:GetName()
	if TheFuture.Stage:IsStage() then
		return { "hey buddy, what do you think youre doing here?",
		"you want to go to the future? again?",
		--it could give you a hickey
		"dont think about it too hard..." ,
		"...",
		"were stuck in a loop, steven", }
	end
	
	--[[if player:HasCollectible(CollectibleType.COLLECTIBLE_LITTLE_STEVEN) then
		return { "whoa, talk about mini-me",
		"whered you pick up that thing?",
		"careful with it... you dont know what it could do" ,
		"it could give you a hickey", }
	elseif player:HasCollectible(CollectibleType.COLLECTIBLE_CUBE_OF_MEAT) then
		return { "oooh, and you come with a free snack?",
		"it must be my lucky day!", }
	end]]
--[[
	if typ == PlayerType.PLAYER_ISAAC then
		return { "mmmmmmmm!",
		"you reek of sadness!",
		"please poke your head into the future!", }
	elseif typ == PlayerType.PLAYER_MAGDALENE then
		return { "need a professional opinion",
		"would i look cute with a bow?",
		"...",
		"i’ll take your silence as a yes", }
	elseif typ == PlayerType.PLAYER_CAIN then
		return { "oh cool pirate costume",
		"arrrrgh! there be loot yonder",
		"step inside into ye abyss and..." ,
		"damn. lost it",
		"okay, you can go", }
	elseif typ == PlayerType.PLAYER_JUDAS then
		return { "a fez? really?",
		"not sure how out of style that is but",
		"I hope you dont leave a bad aftertaste", }
	elseif typ == PlayerType.PLAYER_BLUEBABY then
		return { "you seem familiar",
		"you dont happen to have a ball problem, do you?",
		"…" ,
		"the smell is telling me otherwise",
		"lets just get this over with", }
	elseif typ == PlayerType.PLAYER_EVE then
		return { "you look a lot like my ex!",
		"well, minus the dead bird",
		"she sure was a demon in disguise, though" ,
		"... get in here before i change my mind"}
	elseif typ == PlayerType.PLAYER_SAMSON then
		return { "hold your horses, pal",
		"im in pretty high demand",
		"you gotta wait at the back of the line-" ,
		"hey, whered everybody go?",
		"you killed them all?",
		"figures",}
	elseif typ == PlayerType.PLAYER_AZAZEL then
		return { "*gasp* a vampire!",
		"i dont have my garlic!",
		"or my stakes!" ,
		"but i know your one weakness",
		"you cant come in without being invited!",
		"ill even do this to prove a point", }
	elseif typ == PlayerType.PLAYER_LAZARUS or typ == PlayerType.PLAYER_LAZARUS2 then
		return { "you afraid of death?",
		"i know a couple of guys",
		"theyre all about it" ,
		"figured youd like to meet them", }
	elseif typ == PlayerType.PLAYER_EDEN then
		return { "i see you!",
		"behind the screen",
		"youre slouching" ,
		"sit up straight!", }
	elseif typ == PlayerType.PLAYER_THELOST then
		return { "AH! i didnt notice you come in" ,
		"dont do that next time", }
	elseif typ == PlayerType.PLAYER_LILITH then
		return { "must be nice having friends" ,
		"oh me? yeah i got tons",
		"do you wanna meet them?", }
	elseif typ == PlayerType.PLAYER_KEEPER then
		return { "hey man you alright?",
		"you look parched",
		"do you need a glass of water?" ,
		"my friends could probably go get one for you", }
	elseif typ == PlayerType.PLAYER_APOLLYON then
		return { "you upset me",
		"how does a statue walk?",
		"thats not my business to pry" ,
		"but they might ask you", }
	elseif typ == PlayerType.PLAYER_THEFORGOTTEN or typ == PlayerType.PLAYER_THESOUL then
		return { "spooky scary skeletons!",
		"send shivers down your spine!",
		"shrieking skulls will shock your soul" ,
		"and seal your doom tonight!",
		"im not being skeleton racist, am i?", }
	elseif typ == PlayerType.PLAYER_BETHANY then
		return { "can you read?",
		"could i ask for a favor",
		"i need you to do my taxes before friday" ,
		"in return ill show you a cool place",
		"here, ill pay upfront", }
	elseif typ == PlayerType.PLAYER_JACOB or typ == PlayerType.PLAYER_ESAU then
		return { "what? theres two of you now?",
		"one was enough, lets be real",
		"i understand the struggle though" ,
		"there are alot of me as well", }
	elseif typ == PlayerType.PLAYER_ISAAC_B then
		return { "my third eye is twitching",
		"are you ready to receive our gift?",}
	elseif typ == PlayerType.PLAYER_MAGDALENE_B then
		return { "christ, what happened to your hair?",
		"car accident? bar fight?",
		"mauled by a mutant bear?",
		"if youre on the run, then get in here" ,
		"i swear i wont rat you out", }
	elseif typ == PlayerType.PLAYER_CAIN_B then
		return { "you remind me of someone",
		"he was missing an eye as well",
		"if you see him...",
		"tell him i said hi", }
	elseif typ == PlayerType.PLAYER_JUDAS_B or typ == PlayerType.PLAYER_BLACKJUDAS then
		return { "youre not one of me, are you?",
		"no, i didnt think so",
		"but you could be",
		"youd fit right in", }
	elseif typ == PlayerType.PLAYER_BLUEBABY_B then
		return { "oh my god",
		"yknow what just–",
		"just get in here. you REEK",
		"im gonna need a mint after this", }
	elseif typ == PlayerType.PLAYER_EVE_B then
		return { "you remind me a lot of myself",
		"sad, depressed, miserable…",
		"...",
		"you should reconsider this", }
	elseif typ == PlayerType.PLAYER_SAMSON_B then
		return { "somebody woke up on the wrong side of the bed",
		"a case of the grumps!",
		"piss in the cereal!",
		"...for the record, those were all jokes",
		"lighten up, jeez",	}
	elseif typ == PlayerType.PLAYER_AZAZEL_B then
		return { "sorry about the wings",
		"must hurt like a bitch!",
		"ouch, and the horn" ,
		"not having a good day, huh?",
		"maybe things will get better in here", }
	elseif typ == PlayerType.PLAYER_LAZARUS_B or typ == PlayerType.PLAYER_LAZARUS2_B then
		return { "wait, im confused",
		"so are there two of you?",
		"or is it just a split personality?",
		"which ones the real deal?", }
	elseif typ == PlayerType.PLAYER_EDEN_B then
		return { "yknow",
		"ive had tons of people walk into my mouth",
		"you though?",
		"just dont mess up anything in there",
		"or else", }
	elseif typ == PlayerType.PLAYER_THELOST_B then
		return { "...",
		"man i havent seen anyone in a while",
		"where is everyone?",
		"someone usually visits by now",
		"making me kinda... *yawwwwwn*", }
	elseif typ == PlayerType.PLAYER_LILITH_B then
		return { "“oh! whens your baby due–",
		"oh. whoa",
		"okay",
		"just make sure you treat that... thing with respect",
		"and dont feed it after midnight!", }
	elseif typ == PlayerType.PLAYER_KEEPER_B then
		return { "hey now, not anyone can just get in here for free",
		"theres a toll! thirty bucks, pay up",
		"what? its only pennies down here?",
		"whatever! keep your change", }
	elseif typ == PlayerType.PLAYER_APOLLYON_B then
		return { "hey... a fellow portal brother",
		"where does yours lead?",
		"it only pulls bugs out? thats lame",
		"check mine out", }
	elseif typ == PlayerType.PLAYER_THEFORGOTTEN_B or typ == PlayerType.PLAYER_THESOUL_B then
		return { "haha look at this guy",
		"sitting on the floor, cant even move",
		"what a loser",
		"...",
		"sorry. guys like us gotta stick together", }
	elseif typ == PlayerType.PLAYER_BETHANY_B then
		return { "into future blind",
		"many and many and more",
		"rapture be confined",
		"you like that? i wrote it myself",
		"you seem the bright and intelligent type",
		"well, for someone with a hole in their head", }
	elseif typ == PlayerType.PLAYER_JACOB_B then
		return { "keep that thing on a leash, man",
		"oh wait",
		"you do",
		"i dont allow pets but... you seem responsible", }
	end
	
	if not IsTaintedChar(player) then
		if TheFuture.ModdedCharacterDialogue[player:GetName()] then
			return TheFuture.ModdedCharacterDialogue[player:GetName()]
		end
	else
		if TheFuture.ModdedTaintedCharacterDialogue[player:GetName()] then
			return TheFuture.ModdedTaintedCharacterDialogue[player:GetName()]
		end
	end
	
	return { "huh, you dont seem to be from around here",
	"i guess you can come in",
	"as long as you dont do anything shady…",
	"dont mess with the future!", }
end

TheFuture.ModdedCharacterDialogue = {
	["Fiend"] = { "you ever think about how weird it is",
	"to have all those minions?",
	"to be surrounded by tiny doppelgangers",
	"scary, right?",
	"good thing i dont have to deal with anything like that", },
	
	["Golem"] = { "haha, rock on, pal",
	"...get it, cause youre a rock",
	"...",
	"the silent treatment, huh",
	"i see how it is", },

	["Slippy"] = { "stink aside, i smell something...",
	"formalhyde?",
	"oh god the green splotches are appearing",
	"get outta here before you make my migraine worse!", },

	["China"] = { "i have nothing witty or funny to say",
	"good luck",
	"seriously", },

	["Fient"] = { "woah man, i dont do drugs",
	"drugs are for squares",
	"do i look like a square?", },

	["Fend"] = { "youre late",
	"your shift started an hour ago",
	"the future is filthy! get to work!", },

	["Peat"] = { "you know what i hate?",
	"violence in movies and sex on tv",
	"where did those good ole fashioned values go?",
	"i like to think im a bit of a family guy", },

	["Icarus"] = { "careful with those wings",
	"if you fall, then youre going to be falling",
	"for a very long time", },

	["Mammon"] = { "here piggy piggy",
	"heeeeere piggy piggy",
	"oh, you understand me?",
	"sorry", },

	["Sarah"] = { "did it hurt",
	"when you fell from heaven?",
	"that wasnt a flirt",
	"your wing looks pretty busted up",
	"so seriously, did it hurt?", },

	["Dante"] = { "are you writing fanfiction?",
	"whats it about",
	"will i be in it?", },

	["Charon"] = { "you seem lost",
	"i think i saw some old guy stroll past here",
	"probably should look elsewhere", },

	["Bertran"] = { "i smell",
	"cake",
	"care to share with the class?", },

	["Steven"] = { "back for more?",
	"good luck, steven",
	"but before you go",
	"say hi to steven for me!", },

	["Sodom"] = { "didnt know people were so open about...",
	"yknow",
	"the chain thing is a bondage thing, right?",
	"no?",
	"...", },

	["Gomorrah"] = { "didnt know people were so open about...",
	"yknow",
	"the chain thing is a bondage thing, right?",
	"no?",
	"...", },

	["Bela"] = { "how are you here?",
	"cheater", },

	["Samael"] = { "you looking for someone?",
	"i think we all are",
	"i havent personally seen them, but",
	"they could be in here", },

	["Job"] = { "whats with the rag",
	"youve got something to hide?",
	"its never good to live in shame",
	"i know that from experience", },

	["Andromeda"] = { "are you one of those tarot readers?",
	"thats all bullshit",
	"ill show you your real future", },

	["IsaacD"] = { "your fate trembles and shifts with every step",
	"you have no place here",
	"but ill allow it",
	"IsaacD...", },

	["The Rogue"] = { "oh shit!",
	"am i getting robbed?",
	"please",
	"i have a big future ahead of me!", },

	["Elijah"] = { "cool dog",
	"does he do tricks?",
	"play dead!",
	"...",
	"good boy!", },

	["Car"] = { "OH SHIT",},

	["Martha"] = { "religious type, huh",
	"yknow i think i saw a girl with hair like yours",
	"you guys related or something?"},

	["Noelle"] = { "woah is it christmas already?",
	"i dont know much bout a christmas past",
	"or a christmas present",
	"but i might know about a christmas future"},
}

TheFuture.ModdedTaintedCharacterDialogue = {
	["Fiend"] = { "you lost yourself, man",
	"we all do down here",
	"care to join us?", },

	["Mammon"] = { "sheesh",
	"bad day, huh?",
	"i know a place where you can unwind",
	"the white noise from the rain does wonders", },

	["Bertran"] = { "woah man",
	"might wanna calm down",
	"you might lose your head", },

	["Sodom"] = { "oh! is someone in there?",
	"you can come on out",
	"i dont bite",
	"wait",
	"thats a lie, thats the only thing i can do", },

	["Gomorrah"] = { "oh! is someone in there?",
	"you can come on out",
	"i dont bite",
	"wait",
	"thats a lie, thats the only thing i can do", },

	["Bela"] = { "how are you here?",
	"cheater", },

	["Samael"] = { "jeez, shut the door",
	"youre letting the draft in",
	"... wait a sec",
	"theres no wind underground",
	"why is it so cold then?", },

	["Job"] = { "oh cool",
	"youll fit in just perfectly",
	"with the leprosy and all", },

	["Andromeda"] = { "woah... trippy",
	"its like im looking into the void",
	"and the void is looking back at me",
	"i wonder if the void has a fate of its own", },

	["Martha"] = { "oh!",
	"what a surprise",
	"reminds me of my old mans relaxing farm",
	"he was the goat", },
}]]