local scheduler = {}
local Mod = BotB
scheduler.ScheduleData = {}
function scheduler.Schedule(delay, func, args)
  table.insert(scheduler.ScheduleData, {
    Time = Game():GetFrameCount(),
    Delay = delay,
    Call = func,
    Args = args or {}
  })
end

Mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
  local time = Game():GetFrameCount()
  for i = #scheduler.ScheduleData, 1, -1 do
    local data = scheduler.ScheduleData[i]
    if data.Time + data.Delay <= time then
      table.remove(scheduler.ScheduleData, i)
      data.Call(table.unpack(data.Args))
    end
  end
end)

scheduler.FadeoutData = {}
function scheduler.RenderFadeout()
	if Game():IsPaused() then return end
	for i = #scheduler.FadeoutData, 1, -1 do
		local data = scheduler.FadeoutData[i]
		local color = data.Entity.Color
		local lerpValue = data.Time / data.Duration
		local red = Mod.Functions:Lerp(data.R, data.InitColor.R, lerpValue)
		local green = Mod.Functions:Lerp(data.G, data.InitColor.G, lerpValue)
		local blue = Mod.Functions:Lerp(data.B, data.InitColor.B, lerpValue)
		local amount = Mod.Functions:Lerp(data.A, data.InitColor.A, lerpValue)

		if data.Modifier == "tint" then color:SetTint(red, green, blue, amount) end
		if data.Modifier == "colorize" then color:SetColorize(red, green, blue, amount) end
		if data.Modifier == "offset" then color:SetOffset(red, green, blue) end

		data.Entity.Color = color
		
		if data.Time >= data.Duration then
			Mod:RemoveCallback(ModCallbacks.MC_POST_RENDER, scheduler.RenderFadeout)
			table.remove(scheduler.FadeoutData, i)
		end
		data.Time = data.Time + 1
	end
end

Mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, function ()
  scheduler.ScheduleData = {}
  scheduler.FadeoutData = {}
end)

return scheduler