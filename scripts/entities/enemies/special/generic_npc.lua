local Mod = BotB
local GENERIC_NPC = {}
local Entities = BotB.Enums.Entities
function GENERIC_NPC:NPCUpdate(npc)
    --It's a lofty dream, but that's no reason not to pursue it.
    if npc.Type == BotB.Enums.Entities.GENERIC_NPC.TYPE and npc.Variant == BotB.Enums.Entities.GENERIC_NPC.VARIANT then 
        local sprite = npc:GetSprite()
        local player = npc:GetPlayerTarget()
        local data = npc:GetData()
        local target = npc:GetPlayerTarget()
        local targetpos = target.Position
        local targetangle = (targetpos - npc.Position):GetAngleDegrees()
        local targetdistance = (targetpos - npc.Position):Length()
        local genericNPCPathfinder = npc.Pathfinder
        if data.botbGenericNPCMoveMode == nil then
            data.botbIsAGenericNPC = true
            data.botbGenericNPCMoveMode = "wander"
            --planned:
            --"wander" "random" "stay" "follow" "flee" "chill"
            data.botbGenericNPCMoveTarget = npc.Position
            data.botbGenericNPCMoveTargetDist = (data.botbGenericNPCMoveTarget - npc.Position):Length()
            data.botbGenericNPCWanderCooldown = 0
            data.botbGenericNPCIsTalking = false
            data.botbGenericNPCUnpromptedTalkCooldown = 0

            data.botbGenericNPCSpecialTalkStrings = {
                "Bringer of kings, ten thousand furlongs",
                "No sisters, one brother, composer of song,",
                "Desired equal voices for any and all,",
                "yet my speaking out caused my muted downfall.",
                "From your book of wings and matricide",
                "With the famous parter who was born by my side,",
                "Who am I?",
                "...",
            }
            data.botbGenericNPCSpecialTalkStringIteration = 1
        end
        
        if npc.State == 0 then
            sprite:PlayOverlay("Head")
            npc.State = 99
        end

        --no outside use for u~?

        if Game().Challenge ~= Isaac.GetChallengeIdByName("[BOTB] Basement Crossing")  then
            local game = Game()
            local level = game:GetLevel()
            local roomDescriptor = level:GetCurrentRoomDesc()
            local roomConfigRoom = roomDescriptor.Data
            if roomConfigRoom.Name ~= "MillieAmp - ...?" then
                npc:Remove()
            end
        end

        if npc.State == 99 then
            if npc.EntityCollisionClass ~= EntityCollisionClass.ENTCOLL_PLAYERONLY then
                npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
            end
            if npc.GridCollisionClass ~= EntityGridCollisionClass.GRIDCOLL_GROUND then
                npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND
            end
            npc:AnimWalkFrame("WalkHori", "WalkVert", 0.1)
            --genericNPCPathfinder:FindGridPath(targetpos, 0.2, 0, false)
            if math.random(0,64) == 0 then
                sprite:PlayOverlay("Blink")
            end
        end

        if math.random(0,128) == 8 then
            if data.botbGenericNPCUnpromptedTalkCooldown == 0 and data.botbGenericNPCIsTalking == false then
                if Game().Challenge == Isaac.GetChallengeIdByName("[BOTB] Basement Crossing")  then
                    local talkString = GENERIC_NPC:generateNameForTest(math.random(1,3))
                    GENERIC_NPC:DoTestDialogue(npc, talkString)
                else
                    if data.botbGenericNPCSpecialTalkStringIteration > #data.botbGenericNPCSpecialTalkStrings then
                    else
                        GENERIC_NPC:DoTestDialogue(npc, data.botbGenericNPCSpecialTalkStrings[data.botbGenericNPCSpecialTalkStringIteration])
                        data.botbGenericNPCSpecialTalkStringIteration = data.botbGenericNPCSpecialTalkStringIteration + 1
                    end
                end
                
            end
        end

        if data.botbGenericNPCUnpromptedTalkCooldown ~= 0 then
            data.botbGenericNPCUnpromptedTalkCooldown = data.botbGenericNPCUnpromptedTalkCooldown - 1
        end

        if data.botbGenericNPCIsTalking then
            if sprite:IsOverlayPlaying("Blink") ~= true then
                if sprite:IsOverlayPlaying("Talk") ~= true then
                    sprite:PlayOverlay("Talk")
                end
            end
        else
            if sprite:IsOverlayPlaying("Blink") ~= true then
                if sprite:IsOverlayPlaying("Head") ~= true then
                    sprite:PlayOverlay("Head")
                end
            end
        end

        if sprite:IsOverlayFinished("Blink") then
            sprite:PlayOverlay("Head")
        end
        --Movement calculations
        if data.botbGenericNPCMoveMode == "stay" then
            --just sit there and do nothing
            npc.Velocity = 0.8 * npc.Velocity
        end
        if data.botbGenericNPCMoveMode == "wander" then
            data.botbGenericNPCMoveTargetDist = (data.botbGenericNPCMoveTarget - npc.Position):Length()
            --print(data.botbGenericNPCMoveTargetDist)
            if data.botbGenericNPCMoveTargetDist < 40 then
                if math.random(0,1) == 1 then
                    data.botbGenericNPCWanderCooldown = math.random(30,240)
                    data.botbGenericNPCMoveMode = "chill"
                    --print("chilling")
                else
                    data.botbGenericNPCMoveTarget = GENERIC_NPC:GetRandomAccessiblePosition(npc)
                end
            end
            genericNPCPathfinder:FindGridPath(data.botbGenericNPCMoveTarget, 0.25, 0, false)
        end
        if data.botbGenericNPCMoveMode == "chill" then
            npc.Velocity = 0.8 * npc.Velocity
            if data.botbGenericNPCWanderCooldown ~= 0 then
                data.botbGenericNPCWanderCooldown = data.botbGenericNPCWanderCooldown - 1
            else
                data.botbGenericNPCMoveTarget = GENERIC_NPC:GetRandomAccessiblePosition(npc)
                data.botbGenericNPCMoveMode = "wander"
                --print("wandering")
            end
        end
        

    end
        
end
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, GENERIC_NPC.NPCUpdate, Isaac.GetEntityTypeByName("Generic NPC"))
--Gets a location that a Generic NPC can reasonably pathfind to.
--give it the npc, and it'll find one.
function GENERIC_NPC:GetRandomAccessiblePosition(npc)
    local returnedPos = Vector.Zero
    local startPos = npc.Position
    local pathfinder = npc.Pathfinder
    for i=0, 1000 do
        returnedPos = Game():GetRoom():FindFreePickupSpawnPosition(Game():GetRoom():GetRandomPosition(0), 1, true, false)
        if pathfinder:HasPathToPos(returnedPos, true) == true then
            break
        end
        if i==1000 then
            --failsafe
            returnedPos = startPos
        end
    end
    return returnedPos
end
local tolFamiliarNames = {
    --actual ingame character names
    "Isaac", "Maggy", "Magdalene", "Cain", "Judas", "Eve", "Samson", "???", "Blue Baby", "Ethan", "Azazel", "Lazarus", "Eden", "Lost", "Lilith", "Keeper", "Apollyon", "Forgotten", "Bethany", "Jacob", "Esau",
    "Guppy", "Tammy", "Cricket", "Max", "Kalu", "Moxie", "Bob", 
    --modded characters
    "Rebekah", "Gappi", "Fiend", "Golem", "Icarus", "Mammon", "Deleted", "Awan", "Job", "Andromeda", "Samael", "Solomon", "Jezebel", "Bertran", "Sarah", "Dante", "Charon", "!!!",
    --devs :) and friends
    "Millie", "Crispy", "Kuba", "Gabs", "Moofy", "Hyper", "Puter", "Alter", "Emi", "Gabs", "Lalhs", "Meojo", "Mac", "Cheese", "Gunk", "Gen", "Eric", "Smelly", "One", 
    --characters from random shit
    "Brad", "Wayne", "Nowak", "Bosch", "Anton", "Hans", "Leviat", "Bimini", "Terry", "Cromslor", "Pinskidan", "Finn", "Jake", "Bronwyn", "Coconteppi", "Jerry", "Prismo", "Scarab", "GOLB", "Simon", "Betty", "Fionna", "Cake", "Griffin", "Justin", "Travis",
    "Cox", "Crendor", "Bluey", "Bingo", "Bandit", "Chilli", "Muffin", "Socks", "Orbo", "Peeb", "Doomguy", "Daisy", "Red", "Felix", "Faux", "DJ", "Cyber", "Boki", "Savant", "Lymia", "Isotope", "Analog",
    "Denji", "Dennis", "Asa", "Ashley", "Power", "Pawa", "Konata", "Kagami", "Tsukasa", "Miyuki", "Misao", "Wubbzy", "Walden", "Widget", "Omori", "Mari", "Aubrey", "Kel", "Basil", 
    "Airy", "Liam", "Plecak", "Bryce", "Hansen", "Amelia", "Euler", "Taylor", "Nolan", "Charlotte", "Stern", "Charlie", "Howling", "Texty", "Stone", "Folder", "Atom", 
    "Tara", "Strong", "Twilight", "Sparkle", "Pinkie", "Pie", "Rainbow", "Dash", "Apple", "Jack", "Bloom", "Big Mac", "Flutter", "Shy", "Rarity", "Spike", "Colin", "Puro",
    "Kiryu", "Majima", "Nishiki", "Akira", "Tetsuo", "Navidson", "Francis", "Gabby", "Zaggy", "Orpho", "Gale", "Ponytail", "Pogey", "Leverette", "Mama", "Zelle", "Your Dad", "Terence", "Pumpkin", "Kid", "Cupper", "Dup",
    "Izu", "Kamiya", "Cyl", "Burger", "Cornchip", "Benny", "Pete", "Courier", "Joshua", "Graham", "Doctor", "Gumball", "Tyrone", "Darwin", "Richard", "Penny", "Anais", "Carrie", "Watterson", "Calvin", "Hobbes", "Suzy", "Ami", "Kento", "Iyo", "Issa",
    "Mario", "Luigi", "Peach", "Wario", "Waluigi", "Toad", "Ena", "Moony", "Argemia", "Bob", "Patrick", "Rose", "Boykisser", "BK", "Burger King", "McDonalds", "Taco Bell", "The People's Republic Of China",
    "The United States Of America", "The United Kingdom", "Spain", "Ireland", "Tainwan", "Trans Rights", "Enby", "Wint", "Dril", "Kitty", "Melody", "Kuromi", "Romina", "Daniel", "Maru", "Hana",
    "Finnegan", "Dixie", "Muttais", "Jotaro", "Joseph", "Kakyoin", "Dio", "Solid", "Liquid", "Gas", "Plasma", "Bose-Einstein Condensate", "Peppino", "Noise", "Scrimmy", "Bingus", "Crungy", "Spingus",
    "Bippo", "Pelb", "Tootsy", "Spingus", "Doinkus", "Tume", "Blepp", "Lumpus Umpus", "Lorge", "Brumbus", "Luckie", "Master Chuk", "Master", "Screwball", "Fifi", "Potato", "Lord", "Margeline", "Henry the Squirrel", "Tappy",
    "Thomas", "Henry", "James", "Leyland", "Kirby", "Flaky", "Flippy", "Nutty", "Tran", "Leland", "Fat", "Friend", "Roybertito", "Mal0", "[REDACTED]", "[DATA EXPUNGED]", "[CENSORED]", "[REMOVED BY THE PEOPLE'S REPUBLIC OF CHINA]", "[TRUST ME YOU DON'T WANNA KNOW]",
    "Cyanide", "Bleach", "Hammond", "Care", "Marvin", "Paul", "Tiara", "Belle", "Lina", "Rainer", "Phillip", "Poisson", "Phil", "Fish", "Sylvie", "Veevee", "Manly", "Badass", "Hero", "Dipper", "Mabel", "Stan", "Soos", "Urist", "Cacame",
    "Q Girl", "Joppa", "Ash", "Spewer", "Golgotha", "Exodus", "Cloaca", "Niko", "Alula", "Calamus", "Plight", "Rue", "George", "Kelvin", "Madotsuki", "Poniko", "Uboa", "Skye", "Everest", "Madeline", "Celeste", "Theo",
    "Distant", "Cry", "Looks To The Moon", "Five Pebbles", "No Significant Harassment", "Survivor", "Monk", "Hunter", "Gourmand", "Rivulet", "Artificer", "Spearmaster", "Saint", "Enot", "Inv", "Sofanthiel", "Toby", "Noelle", "Kris", "Susie",
    "V1", "V2", "Minos", "Sisyphus", "Mother", "Corruptus", "Skibidirizz", "Ohiogyatt", "Help! I'm trapped in a name factory!", "Dreamy", "Bull", "Ambatu", "Omaygot", "Gachi", "Muchi", "[Roland 169 \'Ahh!\' sound]", "[Wilhelm scream]", "[Toilet flushing sound]",
    "[Shotgun cocking sound]", "[School fire alarm noises]", "[Stock baby crying sound]", "Hengus", "Grengus", "Belps", "Alpohol", "Claire", "Edgar", "Pim", "Mister", "Missus", "Mix", "Big", "Glaggle", "HELP!", "HEEEEEELP!",
    "Toyota", "Honda", "Mazda", "Bugatti", "Ford", "Subaru", "Car", "Bike", "Plane", "Scooter", "Segway", "Booster", "Ragdoll", "Prop", "Mingebag", "Chikn", "Chee", "Iscream", "Fwench Fwy", "Sody Pop", "Cofi", "Spherefriend", "Egg", "Heir",
    "Sklimpton", "Rick James", "Bitch", "Conan", "Fucknut", "Shitnuts", "Finger", "Waltuh", "Jesse", "Saul", "Jimmy", "Jerma", "Reimu", "Marisa", "Sanae", "Reisen", "Tewi", "[This space intentionally left blank.]", "[Sexual moan]", "[Painful groan]", "[Loud burp]", "[Fart sound]",
    "[Loud, abrasive white noise]", "[Car horn sound]", "[Stock crying sound]", "[Explosion]", "Horse", "Dog", "Cat", "Rabbit", "Bnuuy", "Doggo", "Pupper", "Kity", "Dogy", "Pringles", "Your Mom", "Ray", "William", "Johnson",
    "Ed", "Edd", "Eddy", "Rolf", "Johnny", "Dukey", "Uncle", "Grandpa", "Garnet", "Amethyst", "Pearl", "Ruby", "Sapphire", "Lapis", "Peridot", "Steven", "Greg",
    --random bullshit i and friends came up with
    "Gurt", "Skluntt", "Gorky", "Crungle", "Fuck", "Shit", "Piss", "Boner", --I am very mature
    "Chunt", "Bungleton", "Fugorp", "Fenchalor", "Beebis", "Chongo", "Scrunt", "Shanaenae", "Lakakos", "Foog",
    "Fergus", "Brempel", "Scrumble", "Wimphort", "Kevin", "Kebin", "FlingyDeengee", "Waoflumt", "Queamples",  "Gaben At Valve Software Dot Com",
    "[The entirety of Pulse Demon by Merzbow]", "Moist", "Brungtt", "Jungus", "Flobing", "Bitorong", "Bolainas", "Pilgor", "Buckley","Buttnick", "Wanka", "Ol Chap","Fred Fuchs", "Xavier", "Smokey","Luchetti", "DICKTONG", "ASSPLITS", "TILLBIRTH", "Friendlyvilleson",
    "Filbit", "Quartet", "Snarled", "Flossing", "Dingdong", "BABING", "ticktok", "Generic", "Placeholder", "Namenotfound", "Isaac", "David Streaks from The Popular Webcomic Full House", "E", "Dude", "The Cooler Dude",
    "The", "Postal", "I  I I  I I  L", "Ricardo", "Elver Galarga", "Sapee", "Rosamelano", 
    "Bolainas", "Pilgor", "Buckley", "Buttnick", "Wanka", "Ol Chap", "Fred Fuchs", "Xavier", "Smokey", "Flimflam", "Joe", "Cacarion", "Meaty", "SilSSSLLLLAMMER!",
}
local tolFamiliarLinks = {
    " ", "", "-", " and ", " with ", " or ", " without ", " when ", " at ", "...", " of ", " of the ", " for ", ": ", "_",  " because ", " for ", "/", " the "
}
local tolFamiliarLinksRare = {
    " when there's ", "'s face when ", " at the end of ", " out of ", " in the millenium of ",
    " think he ", " think she ", " think they ", " think xey ", ", voted ", ", abjurer of ", ", consumer of ", ", lover of ", ", buyer of ", ", secret crush of ", ", killer of ", ", little pissboy of ", ", friend of ",
    ", enemy of ", ", lover of ", ", divorced wife of ", ", divorced husband of ", ", divorced spouse of ", ", wife of ", ", husbando of ", ", waifu of ", ", who kins ", ", creator of ", ", progenitor of ", ", responsible for ",
    ", heir to ", ", bitch, ", ", motherfucker, "
}
local tolFamiliarPrefixes = {
    "Master ", "Mistress ", "Mr. ", "Mrs. ", "Ms. ", "Mx. ", "God-tier ", "Pretty Good ", "Decent ", "Kinda Shitty ", "Horrible ", "Proto-", "Neo-", "Macro-", "Micro-", "Anarcho-", "Dr. ", "Messrs. ", "Sir ", "Madam ", "Noble ", "Lady ", "Lord ", "Duke ", "Duchess ",
    "Prince ", "Princess ", "Queen ", "King ", "His Majesty ", "Her Majesty ", "Their Majesty, ", "Xir Majesty ", "His Excellency ", "Her Excellency ", "Their Excellency, ", "Xir Excellency ", "Professor ", "Chancellor ", "Vice Chancellor ", 
    "His Holiness ", "Her Holiness ", "Their Holiness, ", "Xir Holiness ", "His Eminence ", "Her Eminence ", "Their Eminence, ", "Xir Eminence ", "The Ultimate ", "The Final ", "The Real ", "The Last ", "The First ", "The Second ", "The First Coming of ", "The Second Coming of ",
    "Principal ", "Dean ", "Warden ", "Rector ", "Director ", "Provost ", "Chief Executive ", "Father ", "Mother ", "Sister ", "Brother ", "Elder ", "Reverend ", "Priest ", "Priestess ", "High ", "Low ", "Venerable ",
    "Judicio-", "Supreme Court Justice ", "Good Friend ", "Best Friend ", "Worst Friend ", "President ", "Prime Minister ", "Dictator ", "Senator ", "Congress Representative ", "Real ", "Psycho-", "Vino-", "Mega-", "Nano-", "Sykoh-", "Mc",
    "The ", "Super ", "Ultra ", "Mega ", "Mini ", "Tera ", "It's ", "That's ", "It's a ", "A ", "This ", "That ", "Fat ", "Big ", "Huge ", "Cream of ",
}
local tolFamiliarSuffixes = {
    "son", "erson", "kin", "daughter", "dottir", "kind", "kid", "pup", "kit", "star", "leaf", "stripe", "claw", "butt", "snoot", ", Esq.", ", M.D.", ", PhD", ", E.D.", "-san", "-tan", "-kun", "-chan", "-sama", "-sensei",
    "-senpai", "-hakase", "-heika", "-kakka", "-denka", "-domo", "-khan", "mancy", "mancer", "bender", "killer", "lover", "kisser", "drinker", "eater", "hater", "master", "fucker", "god", "shitter", "pisser", "nut", "sucker",", bitch!",
    "ford", "ley", "ing", "ington", "ingford", "ingley", "fart", "fuck", "...?",
}
--Oh Boy!
function GENERIC_NPC:generateNameForTest(nameComplexity)
    local nameStr = ""
    for i=1, nameComplexity do
        --Prefix
        if nameComplexity >= 1 then
            if math.random(0,1) == 0 then
                local amtPrefixes = math.random(0,nameComplexity)
                if amtPrefixes ~= 0 then
                    for j=0, amtPrefixes do
                        nameStr = nameStr .. tolFamiliarPrefixes[math.random(1,#tolFamiliarPrefixes)]
                    end
                end
            end
        end
        --Name
        if math.random(0,3) == 0 and nameComplexity > 2 then
            --Multi-name
            local amtNames = math.random(1,math.ceil(nameComplexity*1.25))
            for j=0, amtNames do
                nameStr = nameStr .. tolFamiliarNames[math.random(1,#tolFamiliarNames)]
            end
        else
            --Single name
            nameStr = nameStr .. tolFamiliarNames[math.random(1,#tolFamiliarNames)]
        end
        --Suffix
        if math.random(0,1) == 0 and nameComplexity >= 1 then
            local amtSuffixes = math.random(0,nameComplexity)
            if amtSuffixes ~= 0 then
                for j=0, amtSuffixes do
                    nameStr = nameStr .. tolFamiliarSuffixes[math.random(1,#tolFamiliarSuffixes)]
                end
            end
        end
        --Link
        if nameComplexity - i > 0 then
            
            if math.random(0,3) == 0 then
                --Rare link
                nameStr = nameStr .. tolFamiliarLinksRare[math.random(1,#tolFamiliarLinksRare)]
            else
                --link
                nameStr = nameStr .. tolFamiliarLinks[math.random(1,#tolFamiliarLinks)]
            end
        end
        
    end 
    if nameStr == "" then
        nameStr = "[NAME UNKNOWN]"
    end
    return nameStr
end
--does generic test dialogue
function GENERIC_NPC:DoTestDialogue(npc, stringu)
    local str = stringu
            local AbacusFont = Font()
            AbacusFont:Load("font/pftempestasevencondensed.fnt")
            local frameLength = (8*#str) + 240
            npc:GetData().botbGenericNPCUnpromptedTalkCooldown = ((8*#str) + 240) + 120
            --local stringLength = 8*#str
            --last 80 are fadeout
            for i = 1, frameLength do
                BotB.FF.scheduleForUpdate(function()

                    local amtChars = ((i-i%8)/8) + 1

                    local drawnString = string.sub(str,1,amtChars)
                    if drawnString == str then
                        if npc:GetData().botbGenericNPCIsTalking ~= false then
                            npc:GetData().botbGenericNPCIsTalking = false
                        end
                    end
                    

                    local pos = game:GetRoom():WorldToScreenPosition(npc.Position) + Vector(AbacusFont:GetStringWidth(str) * -0.5, -(npc.SpriteScale.Y * 35) - 20)
                    local opacity
                    if i >= (frameLength - 240) then
                        --print(1 - ((frameLength - i)/80))
                        opacity = ((frameLength - i)/240)
                    else
                        opacity = 1
                        if npc:GetData().botbGenericNPCIsTalking ~= true then
                            npc:GetData().botbGenericNPCIsTalking = true
                        end
                    end

                    if i==frameLength then
                        if npc:GetData().botbGenericNPCIsTalking ~= false then
                            npc:GetData().botbGenericNPCIsTalking = false
                        end
                    end

                    if npc:GetData().botbGenericNPCIsTalking == true then
                        if i % 8 == 0 then
                            npc:ToNPC():PlaySound(Isaac.GetSoundIdByName("CursedPennyNeutral"),0.5,0,false,math.random(160,260)/100)
                        end
                    end
                    
                    AbacusFont:DrawString(drawnString, pos.X, pos.Y, KColor(1,1,1,opacity), 0, false)
                end, i, ModCallbacks.MC_POST_RENDER)
            end
end



