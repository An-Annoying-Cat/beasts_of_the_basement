Mod = BotB
DRIFTER = {}
local Entities = BotB.Enums.Entities
print("COCK")

--When player is within a few grids of them they should get a dialogue prompt
--From there, choose dialogue from either floor pool, or room pool
--Using the anm2 to make randomized appearances. All animations need to have the same naming scheme.
--Table of costume string and the sound id they should make when talked with?
--Table should have dialogue too, maybe

--Order used for Drifter index array:
--Name of spritesheet in gfx/drifters, talk sound id, and a relative pitch for it to play around (probably a margin of 5% in either direction)
local drifterSkins = {
    --TEST
    {"test",SoundEffect.SOUND_ANIMAL_SQUISH,1.5},
    --ALT
    {"alt",SoundEffect.SOUND_ISAACDIES,2.0}
}
local multiLineTest = {
    "but what if i",
    "need multiple lines",
    "of dialogue?",
    "how should",
    "i handle",
    "that?"
}


local roomDialogueList = {
    --1: Normal Room
    {
        {
            "How are you even reading this?",
            "What even registers as a normal room, anyway?",
            "Why am I asking so many questions?",
            "Well, whatever. Have fun doing whatever it is you're doing.",
            "Don't let an amateur philosopher like me hold you down."
        },
        {
            "You ever wonder how we started drinking milk?",
            "Maybe some pervert diddled a cow,",
            "and then reluctantly shared his findings with the world.",
            "And now we all drink milk.",
            "At all times maybe we are just one pervert away from greatness.",
            "Maybe the world just needs the right pervert in the right place...",
            "...and boy oh boy, am I in the right place.",
            "Listen, I don't expect a simpleton like yourself to understand, but...",
            "I'm gonna need you to leave, I'm about to change the world.",
            "I'm like a horny Jesus.",
            "Nothing will ever be the same."
        },
        {
            "Hey! Ugly!",
            "Yeah, you!",
            "You're ugly!",
            "*They do a little jig in place...*",
            "*and then promptly fall over.*",
            "...",
            "......",
            ".........",
            "...you're still ugly."
        },
        {
            "What the fuck did you just fucking say about me,",
            "you little bitch?",
            "I'll have you know I graduated top of my class in the Navy Seals,",
            "and I've been involved in numerous secret raids on Al-Quaeda,",
            "and I have over 300 confirmed kills.",
            "I am trained in gorilla warfare and I'm the top sniper in the entire US armed forces.",
            "You are nothing to me but just another target.",
            "I will wipe you the fuck out with precision the likes of which has never been seen before on this Earth,",
            "mark my fucking words.",
            "You think you can get away with saying that shit to me over the Internet?",
            "Think again, fucker.",
            "As we speak I am contacting my secret network of spies across the USA,",
            "and your IP is being traced right now so you better prepare for the storm, maggot.",
            "The storm that wipes out the pathetic little thing you call your life.",
            "You're fucking dead, kid.",
            "I can be anywhere, anytime, and I can kill you in over seven hundred ways,",
            "and that's just with my bare hands.",
            "Not only am I extensively trained in unarmed combat,",
            "but I have access to the entire arsenal of the United States Marine Corps,",
            "and I will use it to its full extent to wipe your miserable ass off the face of the continent,",
            "you little shit.",
            "If only you could have known what unholy retribution your little \"clever\" comment was about to bring down upon you,", 
            "maybe you would have held your fucking tongue.", 
            "But you couldn't,", 
            "you didn't,", 
            "and now you're paying the price,", 
            "you goddamn idiot.",
            "I will shit fury all over you,",
            "and you will drown in it.",
            "You're fucking dead, kiddo."
        },
        {
            "Damn.",
            "You look like you've seen better days.",
            "Or not.",
            "Maybe life is just like this for you.",
            "Who am I to judge?",
            "...",
            "...Stop looking at me like that."
        },
        {
            "Those sickos in black leather...",
            "I hate 'em.",
            "But, honestly?",
            "The stuff they wear looks comfy. Tight, too.",
            "Beats trudging around naked like everyone else.",
            "...But then everyone's gonna think I'm a sicko!",
            "It's a catch-22! Dammit!"
        },
        {
            "Are you an emissary of God?",
            "You kinda look like one.",
            "Because, like...",
            "The big man upstairs, He's really done some weird shit!",
            "Have you see what they call angels?",
            "That's not the cute person with wings and a halo I thought of!",
            "When it isn't some godforsaken cluster of wings,",
            "Or golden rings with those horrifying eyes on them,",
            "The damn things don't even have faces!",
            "\"Be not afraid\" my ass!",
            "...Oh no, do you think He heard me?",
            "Um, uh, forget this happened!",
            "I'm a good Christian, I promise!"
        },
    },
    --2: Shop
    {
        {
            "Dude...",
            "The door was locked.",
            "We're closed.",
            "...Eh, whatever, just buy some shit, I guess.",
            "Money is money.",
            "Thank you for your patronage...",
            "And then do me a favor and leave."
        },
        {
            "Welcome to the Toy Cack.",
            "Stop giggling!",
            "Man, I didn't even make the name myself!",
            "Stupid management..."
        },
        {
            "This selection...",
            "It has too many...",
            "PRICES.",
            "And VALUES."
        },
        {
            "What do you mean,",
            "you're not allowed in the GreedMart?"
        },
        {
            "FUCK YOU, BASEMENT!",
            "IF YOU'RE DUMB ENOUGH TO BUY A NEW ITEM THIS WEEKEND,",
            "YOU'RE A BIG ENOUGH SCHMUCK TO COME TO BIG BILL HELL'S ITEM AND PICKUP STORE!",
            "BAD DEALS, ITEMS THAT BREAK DOWN, THIEVES!",
            "IF YOU THINK YOUR GOING TO FIND A BARGAIN AT BIG BILL'S,",
            "YOU CAN KISS MY ASS!",
            "IT'S OUR BELIEF THAT YOU'RE SUCH A STUPID MOTHERFUCKER,",
            "YOU'LL FALL FOR THIS BULLSHIT GUARANTEED!",
            "IF YOU FIND A BETTER DEAL:",
            "SHOVE IT UP YOUR UGLY ASS!",
            "YOU HEARD US RIGHT:",
            "SHOVE IT UP YOUR UGLY ASS!",
            "BRING YOUR TRADE,",
            "BRING YOUR TITLE,",
            "BRING YOUR WIFE,",
            "WE'LL FUCK HER!",
            "THAT'S RIGHT, WE'LL FUCK YOUR WIFE!",
            "BECAUSE AT BIG BILL HELL'S,",
            "YOU'RE FUCKED SIX WAYS FROM SUNDAY!",
            "TAKE A HIKE TO BIG BILL HELL'S!",
            "HOME OF CHALLENGE PISSING!",
            "THAT'S RIGHT, CHALLENGE PISSING!",
            "HOW DOES IT WORK?",
            "IF YOU CAN PISS 6 FEET IN THE AIR,",
            "STRAIGHT UP,",
            "AND NOT GET WET,",
            "YOU GET NO DOWN PAYMENT!",
            "DON'T WAIT!",
            "DON'T DELAY!",
            "DON'T FUCK WITH US,",
            "OR WE'LL RIP YOUR NUTS OFF!",
            "ONLY AT BIG BILL HELL'S,",
            "THE ONLY SHOP THAT TELLS YOU TO FUCK OFF!",
            "HURRY UP, ASSHOLE!",
            "THIS EVENT ENDS THE MINUTE YOU GIVE US YOUR PENNIES!",
            "AND YOU BETTER NOT SHORTCHANGE US OR YOU'RE A DEAD MOTHERFUCKER!",
            "GO TO HELL!",
            "BIG BILL HELL'S ITEM AND PICKUP STORE!",
            "THE BASEMENT'S FILTHIEST,", 
            "AND EXCLUSIVE HOME OF THE MEANEST SONS OF BITCHES IN THIS WHOLE DAMNED WORLD,",
            "GUARANTEED!!"
        },
        {
            "Are you gonna blow up our donation box?",
            "Like the other guy?",
            "You better fucking not."
        },
    },
    --3: Error room
    {
        {
            "...You have to help me...",
            "I did everything they asked!",
            "I took the meds they wanted me to!",
            "I...",
            "...I-I'm sorry, I sound like a pussy..."
        },
        {
            "I am error.",
            "You are, too, if you're here."
        },
        {
            ".-.. --- --- -.-",
            "-- .- --..--",
            "..",
            "-.- -. --- .--",
            "-- --- .-. ... .",
            "-.-. --- -.. . -.-.--"
        },
        {
            "44 69 64 20 79 6F 75",
            "72 65 61 6C 6C 79 20 74 61 6B 65",
            "74 68 65 20 74 69 6D 65 20 74 6F",
            "74 72 61 6E 73 6C 61 74 65",
            "61 6C 6C 20 6F 66 20 74 68 69 73 3F",
            "4D 61 64 20 72 65 73 70 65 63 74 2E"
        },
        {
            "Oh God...!",
            "I can see the backs of my eyes and feel the inside of my skin...!",
            "What did I do to deserve this hell...!?"
        },
        {
            "01001101",
            "01000101",
            "01001111",
            "01010111"
        },
        {
            "VGFudHJpYyBzdWljaWRlLg==",
            "SXQncyBteSBvbmx5IHdheSBvdXQuLi4=",
            "QW5kLCBzb21lZGF5Li4uPw==",
            "SXQnbGwgYmUgeW91cnMsIHRvby4="
        },
        {
            "Let me guess:",
            "You \"turned the right\",",
            "in hopes of becoming a \"shadow monster man\",",
            "Like me?",
            "Idiot.",
            "...well, idiot*s*.",
            "I'm not gonna deny that I tried it too."
        },
        {
            "...please return...",
            "...forever..."
        },
        {
            "Wife bore child 4-8-08",
            "..."
        }
    },
    --4: Treasure
    {
        {
            "You see that thing on the pedestal?",
            "Yeah, well, I ain't touching it.",
            "Looks mighty suspicious to me...",
            "...but you do you. Heh heh heh."
        },
        {
            "Oh! Thanks for saving me!",
            "I think I'mma just chill here.",
            "Maybe it's stockholm syndrome, but...",
            "It's honestly kinda comfy here.",
            "Plus, nothing's trying to kill me or anything.",
            "So that's a plus."
        },
        {
            "You are SO scrimblo!",
            "Like, baller skeemk and tupa!",
            "You are a feebee bouba!",
            "Fleebybeepis frambingliosticus~"
        },
        {
            "OwO?",
            "What's this?",
            "...I know I'm pissing you off by saying that.",
            "That's the point of it, jackass.",
            "...uwu."
        },
        {
            "Hello, hello?", 
            "Uh, I wanted to record a message for you to help you get settled in on your first night.",
            "Um, I actually worked in that room before you.",
            "I'm finishing up my last week now, as a matter of fact.",
            "So, I know it can be a bit overwhelming,",
            "but I'm here to tell you there's nothing to worry about.",
            "Uh, you'll do fine.",
            "So,",
            "let's just focus on getting you through your first week.",
            "Okay?"
        },
    },
    --5: Boss
    {
        {
            "Holy shit, dude!",
            "Don't focus on me, focus on the thing trying to end you!"
        },
        {
            "Ah!",
            "This is...",
            "...quite the predicament, isn't it?"
        }
    },
    --6: Miniboss
    {
        {
            "I don't know who these 7 assholes think they are.",
            "All \"oooOOOooo we're the Seven Deadly Sins!!!\" and stuff.",
            "Well, what about it!?",
            "So what if you're a super sentai team of--",
            "Being too damn horny!",
            "Being too damn hungry!",
            "Being too damn rich!",
            "Being too damn lazy!",
            "Being too damn angry!",
            "Being too damn jealous!",
            "And being just *too goddamn awesome*!",
            "...",
            "...Honestly? It sounds kind of dope, now that I think about it."
        },
        {
            "...Don't go near me,",
            "Especially after coming into contact with *that* guy."
        }
    },
    --7: Secret
    {
        {
            "It's dangerous to go alone!",
            "Take...",
            "uh...",
            "...",
            "Whatever this shit is!"
        },
        {
            "It's a secret to everybody!",
            "Well, it *was* before you barged in!",
            "Nice going, jerk!"
        },
        {
            "I see you've found my evil lair!",
            "It's *evil* because I practice sinning here!",
            "In fact, I'm sinning right now!",
            "How, you ask?",
            "Well, by sitting on my ass and doing nothing,",
            "I'm practicing the sin of Sloth!",
            "You should be more afraid, lest I...",
            "uh...",
            "Whatever, you get the point! Bleh!"
        },
    },
    --8: Super Secret
    {
        {
            "Man,",
            "I thought nobody would find me,",
            "Especially after I got myself all Montresor'd up in here!",
            "I'd thank you, but quite frankly,",
            "I really wish you just left me alone!",
            "Why else would I brick myself up in a room like this!?"
        },
        {
            "*They've either got a thousand-yard stare,",
            "a bad case of sleeping with their eyes open,",
            "or, as a worst-case scenario,",
            "an acute case of rigor mortis.",
            "*You decide that you don't want to find out.*"
        }
    },
    --9: Arcade
    {
        {
            "Those assholes with the 3 skulls...",
            "They're all scams.",
            "Literally, the one time I won their supposed \"grand prize\",",
            "It was a lump of crap!",
            "I'm not even exaggerating, it was literal feces!"
        },
        {
            "None of the damn cabinets here work!",
            "Pretty lousy arcade, if you ask me!"
        }
    },
    --10: Curse
    {
        {
            "Test",
            "Null placeholder here."
        },
        {
            "Test2",
            "Null placeholder here too."
        }
    },
    --11: Challenge
    {
        {
            "Test",
            "Null placeholder here."
        },
        {
            "Test2",
            "Null placeholder here too."
        }
    },
    --12: Library
    {
        {
            "Test",
            "Null placeholder here."
        },
        {
            "Test2",
            "Null placeholder here too."
        }
    },
    --13: Sacrifice
    {
        {
            "Test",
            "Null placeholder here."
        },
        {
            "Test2",
            "Null placeholder here too."
        }
    },
    --14: Devil room
    {
        {
            "Test",
            "Null placeholder here."
        },
        {
            "Test2",
            "Null placeholder here too."
        }
    },
    --15: Angel room
    {
        {
            "Test",
            "Null placeholder here."
        },
        {
            "Test2",
            "Null placeholder here too."
        }
    },
    --16: Crawlspace
    {
        {
            "Test",
            "Null placeholder here."
        },
        {
            "Test2",
            "Null placeholder here too."
        }
    },
    --17: Boss rush
    {
        {
            "Test",
            "Null placeholder here."
        },
        {
            "Test2",
            "Null placeholder here too."
        }
    },
    --18: Clean bedroom
    {
        {
            "Test",
            "Null placeholder here."
        },
        {
            "Test2",
            "Null placeholder here too."
        }
    },
    --19: Dirty bedroom
    {
        {
            "Test",
            "Null placeholder here."
        },
        {
            "Test2",
            "Null placeholder here too."
        }
    },
    --20: Vault
    {
        {
            "Test",
            "Null placeholder here."
        },
        {
            "Test2",
            "Null placeholder here too."
        }
    },
    --21: Dice
    {
        {
            "Test",
            "Null placeholder here."
        },
        {
            "Test2",
            "Null placeholder here too."
        }
    },
    --22: Black market
    {
        {
            "Test",
            "Null placeholder here."
        },
        {
            "Test2",
            "Null placeholder here too."
        }
    },
    --23: Greed exit
    {
        {
            "Test",
            "Null placeholder here."
        },
        {
            "Test2",
            "Null placeholder here too."
        }
    },
    --24: Planetarium
    {
        {
            "Test",
            "Null placeholder here."
        },
        {
            "Test2",
            "Null placeholder here too."
        }
    },
    --25: Maus teleporter (unused)
    {
        {
            "Test",
            "Null placeholder here."
        },
        {
            "Test2",
            "Null placeholder here too."
        }
    },
    --26: Maus teleporter exit (unused)
    {
        {
            "Test",
            "Null placeholder here."
        },
        {
            "Test2",
            "Null placeholder here too."
        }
    },
    --27: Alt path trapdoor
    {
        {
            "Test",
            "Null placeholder here."
        },
        {
            "Test2",
            "Null placeholder here too."
        }
    },
    --28: Blue Key passage
    {
        {
            "Test",
            "Null placeholder here."
        },
        {
            "Test2",
            "Null placeholder here too."
        }
    },
    --29: Ultra secret room
    {
        {
            "Test",
            "Null placeholder here."
        },
        {
            "Test2",
            "Null placeholder here too."
        }
    },
    --30: Unused. Probably will use this for special conditional dialogues
    {
        {
            "Test",
            "Null placeholder here."
        },
        {
            "Test2",
            "Null placeholder here too."
        }
    },

}

function DRIFTER:npcUpdate(npc)
    local sprite = npc:GetSprite()
    local data = npc:GetData()
    local target = npc:GetPlayerTarget()
	local targetpos = target.Position
	local targetangle = (targetpos - npc.Position):GetAngleDegrees()
	local targetdistance = (targetpos - npc.Position):Length()
    
    if npc.Type == Entities.DRIFTER.TYPE and npc.Variant == Entities.DRIFTER.VARIANT then

        if npc.State == 0 then
            npc.State = 3
            sprite:Play("Idle")
        end

        npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        if data.drifterSkinIndex == nil then
            if npc.SubType == nil then
                data.drifterSkinIndex = drifterSkins[math.random(0,#drifterSkins)]
            else
                data.drifterSkinIndex = drifterSkins[npc.SubType]
            end
            print(data.drifterSkinIndex)
            data.drifterSprite = data.drifterSkinIndex[1]
            print("Sprite = " .. data.drifterSprite)
            --Switch sprite
            sprite:ReplaceSpritesheet(0, "gfx/drifters/" .. data.drifterSprite .. ".png")
            sprite:LoadGraphics()
            data.drifterSound = data.drifterSkinIndex[2]
            print("Sound = " .. data.drifterSound)
            data.drifterPitch = data.drifterSkinIndex[3]
            print("Pitch = " .. data.drifterPitch)
            data.isTalking = false
            data.talkCooldown = 0
            data.talkIterator = 0
            --Choose dialogue...
            --data.dialogueIndex = roomDialogueList[math.random(0,#roomDialogueList)]
            data.dialogueIndex = roomDialogueList[game:GetRoom():GetType()][math.random(1,#roomDialogueList[game:GetRoom():GetType()])]
            data.talkCooldownMax = 45

        end


        --STATES:
        --3: Idle, waiting for taLk input
        --4: Waiting for talk cooldown, checking if next dialogue is extant, if it is then go to 5, if it isnt then go back to 3
        --5: talking, but iterating through multi line

        
        if npc.State == 3 then
            if targetdistance <= 100 then
                if Input.IsActionPressed(ButtonAction.ACTION_MENUCONFIRM, 0) and data.isTalking == false then
                    --npc:PlaySound(data.drifterSound, 1, 0, false, (data.drifterPitch*100 + math.random(-20,20))/100)
                    data.talkIterator = 0
                    npc.State = 4
                    sprite:Play("Talk")
                end
            end
        end


        if npc.State == 4 then
            data.isTalking = true
            
            if data.talkCooldown ~= 0 then
                data.talkCooldown = data.talkCooldown - 1 
            elseif data.dialogueIndex[data.talkIterator+1] ~= nil then
                data.talkIterator = data.talkIterator + 1
                npc:PlaySound(data.drifterSound, 1, 0, false, (data.drifterPitch*100 + math.random(-20,20))/100)
                npc.State = 5
            else
                data.isTalking = false
                npc.State = 3
                sprite:Play("Idle")
            end
            
        end

        if npc.State == 5 then
            data.talkCooldown = data.talkCooldownMax

            local str = data.dialogueIndex[data.talkIterator]
            if str ~= nil then
                print(data.talkIterator .. ": " .. str)
                local AbacusFont = Font()
                AbacusFont:Load("font/pftempestasevencondensed.fnt")
                for i = 1, 120 do
                    BotB.FF.scheduleForUpdate(function()
                        local pos = game:GetRoom():WorldToScreenPosition(npc.Position) + Vector(AbacusFont:GetStringWidth(str) * -0.5, -(npc.SpriteScale.Y * 35) - i/2)
                        local opacity
                        if i >= 60 then
                            opacity = 1 - ((i-60)/60)
                        else
                            opacity = i/30
                        end
                        AbacusFont:DrawString(str, pos.X, pos.Y, KColor(1, 1, 1,opacity), 0, false)
                    end, i, ModCallbacks.MC_POST_RENDER)
                end
                npc.State = 4
                sprite:Play("Talk")
            else
                data.isTalking = false
                npc.State = 3
                sprite:Play("Idle")
            end
            
        end

        
    end
end

Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, DRIFTER.npcUpdate, Isaac.GetEntityTypeByName("Drifter"))