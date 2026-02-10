-- ===== TOGGLE =====
if _G.AUTO_PUNCH then
	_G.AUTO_PUNCH = false
	print("AUTO PUNCH: OFF")
	return
end

_G.AUTO_PUNCH = true
print("AUTO PUNCH: ON")

-- ===============================
-- SERVICIOS
-- ===============================
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- CONFIG
local START_DELAY = 3
local CLICK_DELAY = 0.8
local OFFSET_X = 2
local OFFSET_Y = 4
local SPIN_PAUSE = 7

task.wait(START_DELAY)

-- Buscar botones
local punchButton = playerGui:FindFirstChild("PunchButton", true)
local spinButton = playerGui:FindFirstChild("Spin", true)

if not punchButton then
	warn("No se encontró PunchButton")
	return
end

-- ===============================
-- DETECTOR SPIN
-- ===============================
local spinActive = false

if spinButton then
	spinButton.MouseButton1Down:Connect(function()
		spinActive = true
		
		task.delay(SPIN_PAUSE, function()
			spinActive = false
		end)
	end)
end

-- ===============================
-- AUTO CLICK
-- ===============================
task.spawn(function()

	while _G.AUTO_PUNCH do
		task.wait(CLICK_DELAY)

		if spinActive then
			continue
		end

		local absPos = punchButton.AbsolutePosition
		local absSize = punchButton.AbsoluteSize

		local x = absPos.X + absSize.X / 1 + OFFSET_X
		local y = absPos.Y + absSize.Y / 1 + OFFSET_Y

		-- Presionar
		VirtualInputManager:SendMouseButtonEvent(x,y,0,true,game,0)
		task.wait(0.05)
		VirtualInputManager:SendMouseButtonEvent(x,y,0,false,game,0)
	end

end)
