local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer


local ScreenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 200, 0, 330)
Frame.Position = UDim2.new(0, 20, 0, 20)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.Text = "KY Menu"
Title.TextColor3 = Color3.fromRGB(0, 255, 0)

-- Arrastável
local dragging, dragStart, startPos = false
Title.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = Frame.Position
	end
end)
Title.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)


local function createButton(name, y, callback)
	local btn = Instance.new("TextButton", Frame)
	btn.Size = UDim2.new(1, -10, 0, 30)
	btn.Position = UDim2.new(0, 5, 0, y)
	btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Text = name
	btn.MouseButton1Click:Connect(callback)
	return btn
end

local function createSlider(name, y, min, max, default, callback)
	local label = Instance.new("TextLabel", Frame)
	label.Size = UDim2.new(1, -10, 0, 20)
	label.Position = UDim2.new(0, 5, 0, y)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(255,255,255)
	label.Text = name..": "..default

	local slider = Instance.new("Frame", Frame)
	slider.Size = UDim2.new(1, -10, 0, 10)
	slider.Position = UDim2.new(0, 5, 0, y + 20)
	slider.BackgroundColor3 = Color3.fromRGB(100,100,100)

	local fill = Instance.new("Frame", slider)
	fill.Size = UDim2.new((default-min)/(max-min), 1, 1, 0)
	fill.BackgroundColor3 = Color3.fromRGB(0,255,0)

	local draggingSlider = false
	slider.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			draggingSlider = true
		end
	end)
	slider.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			draggingSlider = false
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
			local relative = math.clamp((input.Position.X - slider.AbsolutePosition.X)/slider.AbsoluteSize.X, 0, 1)
			local value = min + (max-min)*relative
			fill.Size = UDim2.new(relative,0,1,0)
			label.Text = name..": "..string.format("%.1f", value)
			callback(value)
		end
	end)
	return label, slider
end

local espEnabled = false
local espObjects = {}
local function toggleESP()
	espEnabled = not espEnabled
	if espEnabled then
		for _, player in pairs(Players:GetPlayers()) do
			if player ~= LocalPlayer and player.Character then
				local hl = Instance.new("Highlight")
				hl.FillTransparency = 1
				hl.OutlineColor = Color3.fromRGB(0,255,0)
				hl.Parent = player.Character
				espObjects[player] = hl
			end
		end
	else
		for _, hl in pairs(espObjects) do
			hl:Destroy()
		end
		espObjects = {}
	end
end

local flyEnabled = false
local flySpeed = 5
local hrpFly

local function toggleFly()
	flyEnabled = not flyEnabled
	if LocalPlayer.Character then
		hrpFly = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
	end
end

RunService.RenderStepped:Connect(function()
	if flyEnabled and hrpFly then
		local cam = workspace.CurrentCamera
		local move = Vector3.zero
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move -= Vector3.new(0,1,0) end
		if move.Magnitude > 0 then
			hrpFly.CFrame = hrpFly.CFrame + move.Unit * flySpeed
			hrpFly.Velocity = Vector3.zero
			hrpFly.RotVelocity = Vector3.zero
		end
	end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
	if flyEnabled then
		hrpFly = char:WaitForChild("HumanoidRootPart")
	end
end)

local noclipEnabled = false

local function toggleNoclip()
	noclipEnabled = not noclipEnabled
end

RunService.RenderStepped:Connect(function()
	if noclipEnabled then
		local char = LocalPlayer.Character
		if char then
			for _, part in pairs(char:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = false
				end
			end
		end
	end
end)


createSlider("Fly Speed", 120, 1, 5, flySpeed, function(value)
	flySpeed = value
end)


local aimbotEnabled = false
local function toggleAimbot()
	aimbotEnabled = not aimbotEnabled
end

RunService.RenderStepped:Connect(function()
	if aimbotEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
		local closest, dist = nil, math.huge
		for _, player in pairs(Players:GetPlayers()) do
			if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
				local mag = (LocalPlayer.Character.Head.Position - player.Character.Head.Position).Magnitude
				if mag < dist then
					closest, dist = player, mag
				end
			end
		end
		if closest then
			workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, closest.Character.Head.Position)
		end
	end
end)


local antiWaterEnabled = false
local originalProperties = {}
local heartConnection

local function findWaterPart(parent)
	for _, obj in pairs(parent:GetDescendants()) do
		if obj:IsA("BasePart") and obj.Name == "WaterBase-Plane" then
			return obj
		end
	end
	return nil
end

local function toggleAntiWater()
	local mapFolder = workspace:FindFirstChild("Map")
	if not mapFolder then return end
	local water = findWaterPart(mapFolder)
	if not water then return end

	if not antiWaterEnabled then

		if not originalProperties.CFrame then
			originalProperties.CFrame = water.CFrame
			originalProperties.CanCollide = water.CanCollide
			originalProperties.Transparency = water.Transparency
		end

		water.CanCollide = true


		heartConnection = RunService.Heartbeat:Connect(function()
			if antiWaterEnabled then

				if not water:GetAttribute("MovedUp") then
					water.CFrame = water.CFrame + Vector3.new(0, 30, 0)
					water:SetAttribute("MovedUp", true)
					task.delay(0.3, function()
						water:SetAttribute("MovedUp", false)
					end)
				end
			end
		end)

		antiWaterEnabled = true
	else

		if heartConnection then
			heartConnection:Disconnect()
			heartConnection = nil
		end


		water.CFrame = originalProperties.CFrame
		water.CanCollide = originalProperties.CanCollide
		water.Transparency = originalProperties.Transparency

		antiWaterEnabled = false
	end
end

createButton("ESP", 40, toggleESP)
createButton("Fly", 80, toggleFly)
createButton("Noclip", 160, toggleNoclip)
createButton("Aimbot", 200, toggleAimbot)
createButton("Anti Water", 240, toggleAntiWater)
