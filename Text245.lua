--------------------------------------------------
-- TOGGLE
--------------------------------------------------
if getgenv().PLAYER_BOX_ESP then
	getgenv().PLAYER_BOX_ESP = false

	for _,v in ipairs(workspace:GetDescendants()) do
		if v:IsA("BoxHandleAdornment") and v.Name == "PlayerBoxESP" then
			v:Destroy()
		end
	end

	return
end

getgenv().PLAYER_BOX_ESP = true
--------------------------------------------------

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local live = workspace:WaitForChild("Live")

local function addBox(model)

	if not getgenv().PLAYER_BOX_ESP then return end
	if model.Name == lp.Name then return end
	if not Players:FindFirstChild(model.Name) then return end
	if model:FindFirstChild("PlayerBoxESP") then return end

	local root = model:FindFirstChild("HumanoidRootPart")
	if not root then return end

	local box = Instance.new("BoxHandleAdornment")
	box.Name = "PlayerBoxESP"
	box.Adornee = root
	box.AlwaysOnTop = true
	box.Size = Vector3.new(4,6,2)
	box.Color3 = Color3.fromRGB(255,255,255)
	box.Transparency = 0.6
	box.ZIndex = 5
	box.Parent = root

end

local function check(obj)

	if not getgenv().PLAYER_BOX_ESP then return end

	if obj:IsA("Highlight") and obj.Name == "Highlight" then
		local model = obj:FindFirstAncestorOfClass("Model")

		if model and Players:FindFirstChild(model.Name) and model.Name ~= lp.Name then
			obj:Destroy()
			addBox(model)
		end
	end

	if obj:IsA("Model") and Players:FindFirstChild(obj.Name) and obj.Name ~= lp.Name then
		task.defer(function()
			addBox(obj)
		end)
	end

end

--------------------------------------------------
-- revisar lo que ya existe
--------------------------------------------------

for _,v in ipairs(live:GetDescendants()) do
	check(v)
end

--------------------------------------------------
-- detectar cosas nuevas
--------------------------------------------------

live.DescendantAdded:Connect(function(v)

	if not getgenv().PLAYER_BOX_ESP then return end

	task.defer(function()
		if v and v.Parent then
			check(v)
		end
	end)

end)
