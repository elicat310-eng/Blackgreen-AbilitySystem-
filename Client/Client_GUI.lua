local Players = game:GetService("Players")
local Replicated = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

local InvisEvent = Replicated:WaitForChild("InvisibilityToggle")
local PlatformEvent = Replicated:WaitForChild("CreatePlatformRequest")

local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 9999
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,320,0,160)
frame.Position = UDim2.new(0.7,0,0.1,0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Parent = gui

local top = Instance.new("Frame")
top.Size = UDim2.new(1,0,0,28)
top.BackgroundColor3 = Color3.fromRGB(15,15,15)
top.Parent = frame
top.Active = true

local close = Instance.new("TextButton")
close.Text = "X"
close.Size = UDim2.new(0,28,0,20)
close.Position = UDim2.new(1,-28,0,4)
close.Parent = top

local min = Instance.new("TextButton")
min.Text = "_"
min.Size = UDim2.new(0,28,0,20)
min.Position = UDim2.new(1,-56,0,4)
min.Parent = top

local invis = Instance.new("TextButton")
invis.Text = "Invisibilidad"
invis.Size = UDim2.new(0,140,0,44)
invis.Position = UDim2.new(0,12,0,40)
invis.Parent = frame

local jump = Instance.new("TextButton")
jump.Text = "Salto"
jump.Size = UDim2.new(0,140,0,44)
jump.Position = UDim2.new(0,168,0,40)
jump.Parent = frame

local circle = Instance.new("Frame")
circle.Size = UDim2.new(0,44,0,44)
circle.Position = UDim2.new(0.9,0,0.1,0)
circle.BackgroundColor3 = Color3.fromRGB(40,40,40)
circle.Visible = false
circle.Active = true
circle.Parent = gui

local cLabel = Instance.new("TextLabel")
cLabel.Text = "☰"
cLabel.Size = UDim2.new(1,0,1,0)
cLabel.BackgroundTransparency = 1
cLabel.Font = Enum.Font.GothamBlack
cLabel.TextSize = 24
cLabel.TextColor3 = Color3.fromRGB(230,230,230)
cLabel.Parent = circle

local function drag(obj)
	local dragging, startPos, startInput
	obj.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			startInput = input
			startPos = obj.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - startInput.Position
			obj.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)
end

drag(frame)
drag(circle)

close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

min.MouseButton1Click:Connect(function()
	frame.Visible = false
	circle.Visible = true
end)

circle.MouseButton1Click:Connect(function()
	frame.Visible = true
	circle.Visible = false
end)

local invisState = false
invis.MouseButton1Click:Connect(function()
	invisState = not invisState
	InvisEvent:FireServer(invisState)
end)

local jumpState = false
jump.MouseButton1Click:Connect(function()
	jumpState = not jumpState
end)

player.CharacterAdded:Connect(function(char)
	local hum = char:WaitForChild("Humanoid")
	hum.Jumping:Connect(function(active)
		if active and jumpState then
			PlatformEvent:FireServer()
		end
	end)
end)
