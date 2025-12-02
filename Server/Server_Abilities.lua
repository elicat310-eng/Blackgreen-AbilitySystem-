local Replicated = game:GetService("ReplicatedStorage")
local InvisibilityToggle = Replicated:WaitForChild("InvisibilityToggle")
local PlatformRequest = Replicated:WaitForChild("CreatePlatformRequest")

local data = {}
local platforms = {}

local function setInvisible(player)
	local char = player.Character
	if not char then return end
	data[player] = {parts = {}, guis = {}}

	for _, inst in ipairs(char:GetDescendants()) do
		if inst:IsA("BasePart") then
			data[player].parts[inst] = inst.Transparency
			inst.Transparency = 1
		elseif inst:IsA("Decal") then
			data[player].parts[inst] = inst.Transparency
			inst.Transparency = 1
		elseif inst:IsA("SurfaceGui") or inst:IsA("BillboardGui") then
			data[player].guis[inst] = inst.Enabled
			inst.Enabled = false
		end
	end

	for _, tool in ipairs(char:GetChildren()) do
		if tool:IsA("Tool") or tool:IsA("Model") then
			for _, obj in ipairs(tool:GetDescendants()) do
				if obj:IsA("BasePart") then
					data[player].parts[obj] = obj.Transparency
					obj.Transparency = 1
				elseif obj:IsA("SurfaceGui") or obj:IsA("BillboardGui") then
					data[player].guis[obj] = obj.Enabled
					obj.Enabled = false
				end
			end
		end
	end
end

local function restoreVisible(player)
	if not data[player] then return end

	for inst, trans in pairs(data[player].parts) do
		if inst and inst.Parent then
			inst.Transparency = trans
		end
	end

	for inst, enabled in pairs(data[player].guis) do
		if inst and inst.Parent then
			inst.Enabled = enabled
		end
	end

	data[player] = nil
end

InvisibilityToggle.OnServerEvent:Connect(function(player, state)
	if state then
		setInvisible(player)
	else
		restoreVisible(player)
	end
end)

local function createPlatform(player)
	local char = player.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	local hum = char:FindFirstChild("Humanoid")
	if not hrp or not hum then return end

	if platforms[player] then
		platforms[player]:Destroy()
		platforms[player] = nil
	end

	local p = Instance.new("Part")
	p.Size = Vector3.new(6,0.6,6)
	p.Anchored = false
	p.CanCollide = true
	p.Transparency = 0.5
	p.Material = Enum.Material.SmoothPlastic
	p.CFrame = hrp.CFrame * CFrame.new(0,-(hum.HipHeight+1.5),0)
	p.Parent = workspace

	local weld = Instance.new("WeldConstraint")
	weld.Part0 = p
	weld.Part1 = hrp
	weld.Parent = p

	platforms[player] = p

	delay(10,function()
		if platforms[player] == p then
			p:Destroy()
			platforms[player] = nil
		end
	end)
end

PlatformRequest.OnServerEvent:Connect(createPlatform)

game.Players.PlayerRemoving:Connect(function(player)
	restoreVisible(player)
	if platforms[player] then
		platforms[player]:Destroy()
	end
end)
