local Mod = BotB
local Fadeout = {}
local Functions = Mod.Functions

---@class FadeoutData
---@field Entity Entity
---@field Modifier "tint"|"colorize"|"offset"
---@field InitColor Color
---@field Duration integer
---@field R number
---@field G number
---@field B number
---@field A number
---@field Time integer

---@type FadeoutData[]
local FadeoutData = {}

local function RenderFadeout()
    if Game():IsPaused() then return end
    for i = #FadeoutData, 1, -1 do
        local data = FadeoutData[i]
        local color = data.Entity.Color
        local lerpValue = data.Time / data.Duration
        local red = Functions:Lerp(data.R, data.InitColor.R, lerpValue)
        local green = Functions:Lerp(data.G, data.InitColor.G, lerpValue)
        local blue = Functions:Lerp(data.B, data.InitColor.B, lerpValue)
        local amount = Functions:Lerp(data.A, data.InitColor.A, lerpValue)

        if data.Modifier == "tint" then color:SetTint(red, green, blue, amount) end
        if data.Modifier == "colorize" then color:SetColorize(red, green, blue, amount) end
        if data.Modifier == "offset" then color:SetOffset(red, green, blue) end

        data.Entity.Color = color
        
        if data.Time >= data.Duration then
            table.remove(FadeoutData, i)
        end
        data.Time = data.Time + 1
    end
end
Mod:AddCallback(ModCallbacks.MC_POST_RENDER, RenderFadeout)

Mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function ()
    FadeoutData = {}
end)

---works for both entities and sprites
---@param entity Entity
---@param red number @default 0
---@param green number @default 0
---@param blue number @default 0
---@param amount number @default 1
---@param fadeout? boolean @default false
---@param duration? integer @default 0
function Fadeout:Colorize(entity, red, green, blue, amount, fadeout, duration)
    local color = entity.Color
    local initColor = color

    color:SetColorize(red, green, blue, amount)
    entity.Color = color

    if fadeout then
        table.insert(FadeoutData, {
            Entity = entity,
            Modifier = "colorize",
            InitColor = initColor,
            Duration = duration,
            R = red,
            G = green,
            B = blue,
            A = amount,
            Time = 0,
        })
    end
end

---works for both entities and sprites
---@param entity Entity
---@param red number @default 0
---@param green number @default 0
---@param blue number @default 0
---@param alpha number @default 1
---@param fadeout? boolean @default false
---@param duration? integer @default 0
function Fadeout:Tint(entity, red, green, blue, alpha, fadeout, duration)
    local color = entity.Color
    local initColor = color

    color:SetTint(red, green, blue, alpha)
    entity.Color = color

    if fadeout then
        table.insert(FadeoutData, {
            Entity = entity,
            Modifier = "tint",
            InitColor = initColor,
            Duration = duration or 0,
            R = red,
            G = green,
            B = blue,
            A = alpha,
            Time = 0,
        })
    end
end

---works for both entities and sprites
---@param entity Entity
---@param red number @default 0
---@param green number @default 0
---@param blue number @default 0
---@param fadeout? boolean @default false
---@param duration? integer @default 0
function Fadeout:Offset(entity, red, green, blue, fadeout, duration)
    local color = entity.Color
    local initColor = color

    color:SetOffset(red, green, blue)
    entity.Color = color

    if fadeout then
        table.insert(FadeoutData, {
            Entity = entity,
            Modifier = "offset",
            InitColor = initColor,
            Duration = duration or 0,
            R = red,
            G = green,
            B = blue,
            A = 0,
            Time = 0,
        })
    end
end

Functions.Fadeout = Fadeout