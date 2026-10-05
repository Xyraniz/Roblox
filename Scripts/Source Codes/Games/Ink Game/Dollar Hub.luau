if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local function applyEffects(character)
	local torso = character:WaitForChild("Torso", 5)
	if not torso then return end

	local nametag = torso:WaitForChild("Player_Nametag", 5)
	if not nametag then return end

	local levelText = nametag:WaitForChild("LevelText", 5)
	local displayName = nametag:WaitForChild("DisplayName", 5)
	if not levelText or not displayName then return end

	local player = Players.LocalPlayer
	local isOwner = (player.Name == "ArrowPower44")

	levelText.Text = isOwner and "[ DollarHub creator ]" or "[ DollarHub Bro ]"

	local wave = 0
	local rainbowHue = 0

	local messages = {
		"I like money (dsc.gg/dllrhub)",
		"this hub from sigma",
		"@" .. player.Name .. " (dsc.gg/dllrhub)"
	}
	local msgIndex = 1
	displayName.Text = messages[msgIndex]

	task.spawn(function()
		while character.Parent do
			msgIndex = (msgIndex % #messages) + 1
			displayName.Text = messages[msgIndex]
			task.wait(2)
		end
	end)

	RunService.RenderStepped:Connect(function(deltaTime)
		wave = (wave + deltaTime * 2) % (2 * math.pi)
		rainbowHue = (rainbowHue + deltaTime * 0.2) % 1

		if isOwner then
			local brightness = (math.sin(wave) + 1) / 2
			levelText.TextColor3 = Color3.new(1, brightness, brightness)
		else
			local brightness = (math.sin(wave) + 1) / 2
			levelText.TextColor3 = Color3.new(brightness, 1, brightness)
		end

		displayName.TextColor3 = Color3.fromHSV(rainbowHue, 1, 1)
	end)

	levelText:GetPropertyChangedSignal("Text"):Connect(function()
		local correctText = isOwner and "[ Dllrhub OWNER ]" or "[ Dllr MEMBER ]"
		if levelText.Text ~= correctText then
			levelText.Text = correctText
		end
	end)
end

local player = Players.LocalPlayer
if player.Character then
	applyEffects(player.Character)
end
player.CharacterAdded:Connect(applyEffects)

getgenv().TranslationCounter = nil
Translations = loadstring(game:HttpGet("https://raw.githubusercontent.com/Articles-Hub/ROBLOXScript/refs/heads/main/Translation/Translation.lua"))()
loadstring(game:HttpGet("https://pastefy.app/yavAjgX3/raw"))()
repeat task.wait() until TranslationCounter
if game.CoreGui:FindFirstChild("Country") then
game.CoreGui:FindFirstChild("Country"):Destroy()
end
wait(0.3)
local Player = game.Players.LocalPlayer
game:GetService("UserInputService").JumpRequest:connect(function()
	if _G.InfiniteJump == true then
		game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
	end
end)
game.Players.LocalPlayer.Character:FindFirstChild("Humanoid"):GetPropertyChangedSignal("WalkSpeed"):Connect(function()
if _G.AutoSpeed == true then
	if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
		game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = _G.Speed or 50
	end
end
end)
function CheckWall(Target)
    local Direction = (Target.Position - game.Workspace.CurrentCamera.CFrame.Position).unit * (Target.Position - game.Workspace.CurrentCamera.CFrame.Position).Magnitude
    local RaycastParams = RaycastParams.new()
    RaycastParams.FilterDescendantsInstances = {game.Players.LocalPlayer.Character, game.Workspace.CurrentCamera}
    RaycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    local Result = game.Workspace:Raycast(game.Workspace.CurrentCamera.CFrame.Position, Direction, RaycastParams)
    return Result == nil or Result.Instance:IsDescendantOf(Target)
end
function PartLagDe(g)
	for i, v in pairs(_G.PartLag) do
		if g.Name:find(v) then
			g:Destroy()
		end
	end
end
workspace.DescendantAdded:Connect(function(v)
	if _G.AntiLag == true then
		if v:IsA("ForceField") or v:IsA("Sparkles") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Beam") then
			v:Destroy()
		end
		if v:IsA("BasePart") then
			v.Material = "Plastic"
			v.Reflectance = 0
			v.BackSurface = "SmoothNoOutlines"
			v.BottomSurface = "SmoothNoOutlines"
			v.FrontSurface = "SmoothNoOutlines"
			v.LeftSurface = "SmoothNoOutlines"
			v.RightSurface = "SmoothNoOutlines"
			v.TopSurface = "SmoothNoOutlines"
		elseif v:IsA("Decal") then
			v.Transparency = 1
		elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
			v.Lifetime = NumberRange.new(0)
		end
	end
end)

local Name = "Ink Game"
function Translation(Section, Text)
	if TranslationCounter == "English" then
		return Text
	end
	local lang = Translations[TranslationCounter]
	if lang and lang[Name] and lang[Name][Section] and lang[Name][Section][Text] then
		return lang[Name][Section][Text]
	else
		return Text
	end
end

---- Script ----

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Articles-Hub/ROBLOXScript/refs/heads/main/Library/LinoriaLib/Test.lua"))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/Articles-Hub/ROBLOXScript/refs/heads/main/Library/LinoriaLib/addons/ThemeManagerCopy.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/Articles-Hub/ROBLOXScript/refs/heads/main/Library/LinoriaLib/addons/SaveManagerCopy.lua"))()
local Options = Library.Options
local Toggles = Library.Toggles

function Notification(Message, Time)
if _G.ChooseNotify == "Obsidian" then
Library:Notify(Message, Time or 5)
elseif _G.ChooseNotify == "Roblox" then
game:GetService("StarterGui"):SetCore("SendNotification",{Title = "Error",Text = Message,Icon = "rbxassetid://7733658504",Duration = Time or 5})
end
if _G.NotificationSound then
        local sound = Instance.new("Sound", workspace)
            sound.SoundId = "rbxassetid://4590662766"
            sound.Volume = _G.VolumeTime or 2
            sound.PlayOnRemove = true
            sound:Destroy()
        end
    end

Library:SetDPIScale(85)

local Window = Library:CreateWindow({
    Title = "Ink Game",
    Center = true,
    AutoShow = true,
    Resizable = true,
    Footer = "DollarHub",
	Icon = 78855714172148,
	AutoLock = true,
    ShowCustomCursor = true,
    NotifySide = "Right",
    TabPadding = 2,
    MenuFadeTime = 0
})

Tabs = {
	Tab = Window:AddTab((Translation("Tab", "Main")), "rbxassetid://7734053426"),
	Tab1 = Window:AddTab((Translation("Tab", "Misc")), "rbxassetid://4370318685"),
	["UI Settings"] = Window:AddTab((Translation("Tab", "UI Settings")), "rbxassetid://7733955511")
}

local MainTab = "Main"
local GreenGroup = Tabs.Tab:AddLeftGroupbox(Translation(MainTab, "Green Light, Red Light"))

GreenGroup:AddButton(Translation(MainTab, "Green Light, Red Light"), function()
if workspace:FindFirstChild("RedLightGreenLight") and workspace.RedLightGreenLight:FindFirstChild("sand") and workspace.RedLightGreenLight.sand:FindFirstChild("crossedover") then
local pos = workspace.RedLightGreenLight.sand.crossedover.Position + Vector3.new(0, 5, 0)
Player.Character.HumanoidRootPart.CFrame = CFrame.new(pos, pos + Vector3.new(0, 0, -1))
end
end)

GreenGroup:AddButton(Translation(MainTab, "Help Player To End"), function()
if Loading then return end
Loading = true
for _, v in pairs(game.Players:GetPlayers()) do
if v.Character:FindFirstChild("HumanoidRootPart") and v.Character.HumanoidRootPart:FindFirstChild("CarryPrompt") and v.Character.HumanoidRootPart.CarryPrompt.Enabled == true then
if v.Character:FindFirstChild("SafeRedLightGreenLight") == nil then
Player.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame
wait(0.3)
repeat task.wait(0.1)
fireproximityprompt(v.Character.HumanoidRootPart:FindFirstChild("CarryPrompt"))
until v.Character.HumanoidRootPart.CarryPrompt.Enabled == false
wait(0.5)
if workspace:FindFirstChild("RedLightGreenLight") and workspace.RedLightGreenLight:FindFirstChild("sand") and workspace.RedLightGreenLight.sand:FindFirstChild("crossedover") then
local pos = workspace.RedLightGreenLight.sand.crossedover.Position + Vector3.new(0, 5, 0)
Player.Character.HumanoidRootPart.CFrame = CFrame.new(pos, pos + Vector3.new(0, 0, -1))
end
wait(0.4)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ClickedButton"):FireServer({tryingtoleave = true})
break
end
end
end
Loading = false
end)

GreenGroup:AddToggle("Auto Help Player", {
    Text = Translation(MainTab, "Auto Help Player"),
    Default = false, 
    Callback = function(Value) 
_G.AutoHelpPlayer = Value
while _G.AutoHelpPlayer do
for _, v in pairs(game.Players:GetPlayers()) do
if v.Character:FindFirstChild("HumanoidRootPart") and v.Character.HumanoidRootPart:FindFirstChild("CarryPrompt") and v.Character.HumanoidRootPart.CarryPrompt.Enabled == true then
if v.Character:FindFirstChild("SafeRedLightGreenLight") == nil then
Player.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame
wait(0.3)
repeat task.wait(0.1)
fireproximityprompt(v.Character.HumanoidRootPart:FindFirstChild("CarryPrompt"))
until v.Character.HumanoidRootPart.CarryPrompt.Enabled == false
wait(0.5)
if workspace:FindFirstChild("RedLightGreenLight") then
Player.Character.HumanoidRootPart.CFrame = CFrame.new(-75, 1025, 143)
end
wait(0.4)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ClickedButton"):FireServer({tryingtoleave = true})
break
end
end
end
task.wait()
end
    end
})

GreenGroup:AddButton(Translation(MainTab, "Troll Player"), function()
if Loading1 then return end
Loading1 = true
for _, v in pairs(game.Players:GetPlayers()) do
if v.Character:FindFirstChild("HumanoidRootPart") and v.Character.HumanoidRootPart:FindFirstChild("CarryPrompt") and v.Character.HumanoidRootPart.CarryPrompt.Enabled == true then
if v.Character:FindFirstChild("SafeRedLightGreenLight") == nil then
Player.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame
wait(0.3)
repeat task.wait(0.1)
fireproximityprompt(v.Character.HumanoidRootPart:FindFirstChild("CarryPrompt"))
until v.Character.HumanoidRootPart.CarryPrompt.Enabled == false
wait(0.5)
if workspace:FindFirstChild("RedLightGreenLight") then
Player.Character.HumanoidRootPart.CFrame = CFrame.new(-84, 1023, -537)
end
wait(0.4)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ClickedButton"):FireServer({tryingtoleave = true})
break
end
end
end
Loading1 = false
end)

GreenGroup:AddToggle("Auto Troll Player", {
    Text = Translation(MainTab, "Auto Troll Player"),
    Default = false, 
    Callback = function(Value) 
_G.AutoTrollPlayer = Value
while _G.AutoTrollPlayer do
for _, v in pairs(game.Players:GetPlayers()) do
if v.Character:FindFirstChild("HumanoidRootPart") and v.Character.HumanoidRootPart:FindFirstChild("CarryPrompt") and v.Character.HumanoidRootPart.CarryPrompt.Enabled == true then
if v.Character:FindFirstChild("SafeRedLightGreenLight") == nil then
Player.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame
wait(0.3)
repeat task.wait(0.1)
fireproximityprompt(v.Character.HumanoidRootPart:FindFirstChild("CarryPrompt"))
until v.Character.HumanoidRootPart.CarryPrompt.Enabled == false
wait(0.5)
if workspace:FindFirstChild("RedLightGreenLight") then
Player.Character.HumanoidRootPart.CFrame = CFrame.new(-84, 1023, -537)
end
wait(0.4)
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ClickedButton"):FireServer({tryingtoleave = true})
break
end
end
end
task.wait()
end
    end
})


local DalgonaGroup = Tabs.Tab:AddRightGroupbox(Translation(MainTab, "Dalgona"))

DalgonaGroup:AddButton(Translation(MainTab, "Complete Dalgona"), function()
local DalgonaClientModule = game.ReplicatedStorage.Modules.Games.DalgonaClient
for i, v in pairs(getreg()) do
    if typeof(v) == "function" and islclosure(v) then
        if getfenv(v).script == DalgonaClientModule then
            if getinfo(v).nups == 73 then
                setupvalue(v, 31, 9e9)
            end
        end
    end
end
end)

local TugwarGroup = Tabs.Tab:AddLeftGroupbox(Translation(MainTab, "Tug Of War / Hide & Seek"))

TugwarGroup:AddToggle("AutoTug of War", {
    Text = Translation(MainTab, "Auto Tug of War"),
    Default = false, 
    Callback = function(Value) 
_G.TugOfWar = Value
while _G.TugOfWar do
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("TemporaryReachedBindable"):FireServer({GameQTE = true})
task.wait()
end
    end
})

TugwarGroup:AddDivider()

TugwarGroup:AddToggle("Esp DoorExit", {
    Text = Translation(MainTab, "Esp Door Exit"),
    Default = false, 
    Callback = function(Value) 
_G.DoorExit = Value
if _G.DoorExit == false then
if workspace:FindFirstChild("HideAndSeekMap") then
	for i, v in pairs(workspace:FindFirstChild("HideAndSeekMap"):GetChildren()) do
		if v.Name == "NEWFIXEDDOORS" then
			for k, m in pairs(v:GetChildren()) do
				if m.Name:find("Floor") and m:FindFirstChild("EXITDOORS") then
					for _, a in pairs(m:FindFirstChild("EXITDOORS"):GetChildren()) do
						if a:IsA("Model") and a:FindFirstChild("DoorRoot") then
							for _, z in pairs(a:FindFirstChild("DoorRoot"):GetChildren()) do
								if z.Name:find("Esp_") then
									z:Destroy()
								end
							end
						end
					end
				end
			end
		end
	end
end
end
while _G.DoorExit do
if workspace:FindFirstChild("HideAndSeekMap") then
for i, v in pairs(workspace:FindFirstChild("HideAndSeekMap"):GetChildren()) do
if v.Name == "NEWFIXEDDOORS" then
for k, m in pairs(v:GetChildren()) do
if m.Name:find("Floor") and m:FindFirstChild("EXITDOORS") then
for _, a in pairs(m:FindFirstChild("EXITDOORS"):GetChildren()) do
if a:IsA("Model") and a:FindFirstChild("DoorRoot") then
if a.DoorRoot:FindFirstChild("Esp_Highlight") then
	a.DoorRoot:FindFirstChild("Esp_Highlight").FillColor = Colorlight or Color3.fromRGB(255, 255, 255)
	a.DoorRoot:FindFirstChild("Esp_Highlight").OutlineColor = Colorlight or Color3.fromRGB(255, 255, 255)
end
if _G.EspHighlight == true and a.DoorRoot:FindFirstChild("Esp_Highlight") == nil then
	local Highlight = Instance.new("Highlight")
	Highlight.Name = "Esp_Highlight"
	Highlight.FillColor = Color3.fromRGB(255, 255, 255) 
	Highlight.OutlineColor = Color3.fromRGB(255, 255, 255) 
	Highlight.FillTransparency = 0.5
	Highlight.OutlineTransparency = 0
	Highlight.Adornee = a
	Highlight.Parent = a.DoorRoot
	elseif _G.EspHighlight == false and a.DoorRoot:FindFirstChild("Esp_Highlight") then
	a.DoorRoot:FindFirstChild("Esp_Highlight"):Destroy()
end
if a.DoorRoot:FindFirstChild("Esp_Gui") and a.DoorRoot["Esp_Gui"]:FindFirstChild("TextLabel") then
	a.DoorRoot["Esp_Gui"]:FindFirstChild("TextLabel").Text = 
	        (_G.EspName == true and "Door Exit" or "")..
            (_G.EspDistance == true and "\nDistance ("..string.format("%.1f", (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - a.DoorRoot.Position).Magnitude).."m)" or "")
    a.DoorRoot["Esp_Gui"]:FindFirstChild("TextLabel").TextSize = _G.EspGuiTextSize or 15
    a.DoorRoot["Esp_Gui"]:FindFirstChild("TextLabel").TextColor3 = _G.EspGuiTextColor or Color3.new(255, 255, 255)
end
if _G.EspGui == true and a.DoorRoot:FindFirstChild("Esp_Gui") == nil then
	GuiPlayerEsp = Instance.new("BillboardGui", a.DoorRoot)
	GuiPlayerEsp.Adornee = a.DoorRoot
	GuiPlayerEsp.Name = "Esp_Gui"
	GuiPlayerEsp.Size = UDim2.new(0, 100, 0, 150)
	GuiPlayerEsp.AlwaysOnTop = true
	GuiPlayerEsp.StudsOffset = Vector3.new(0, 3, 0)
	GuiPlayerEspText = Instance.new("TextLabel", GuiPlayerEsp)
	GuiPlayerEspText.BackgroundTransparency = 1
	GuiPlayerEspText.Font = Enum.Font.Code
	GuiPlayerEspText.Size = UDim2.new(0, 100, 0, 100)
	GuiPlayerEspText.TextSize = 15
	GuiPlayerEspText.TextColor3 = Color3.new(0,0,0) 
	GuiPlayerEspText.TextStrokeTransparency = 0.5
	GuiPlayerEspText.Text = ""
	local UIStroke = Instance.new("UIStroke")
	UIStroke.Color = Color3.new(0, 0, 0)
	UIStroke.Thickness = 1.5
	UIStroke.Parent = GuiPlayerEspText
	elseif _G.EspGui == false and a.DoorRoot:FindFirstChild("Esp_Gui") then
	a.DoorRoot:FindFirstChild("Esp_Gui"):Destroy()
end
end
end
end
end
end
end
end
task.wait()
end
    end
})

TugwarGroup:AddToggle("Esp Key", {
    Text = Translation(MainTab, "Esp Key"),
    Default = false, 
    Callback = function(Value) 
_G.DoorKey = Value
if _G.DoorKey == false then
for _, a in pairs(workspace.Effects:GetChildren()) do
if a.Name:find("DroppedKey") and a:FindFirstChild("Handle") then
for _, v in pairs(a:FindFirstChild("Handle"):GetChildren()) do
if v.Name:find("Esp_") then
v:Destroy()
end
end
end
end
end
while _G.DoorKey do
for _, a in pairs(workspace.Effects:GetChildren()) do
if a.Name:find("DroppedKey") and a:FindFirstChild("Handle") then 
if a.Handle:FindFirstChild("Esp_Highlight") then
	a.Handle:FindFirstChild("Esp_Highlight").FillColor = Colorlight or Color3.fromRGB(255, 255, 255)
	a.Handle:FindFirstChild("Esp_Highlight").OutlineColor = Colorlight or Color3.fromRGB(255, 255, 255)
end
if _G.EspHighlight == true and a.Handle:FindFirstChild("Esp_Highlight") == nil then
	local Highlight = Instance.new("Highlight")
	Highlight.Name = "Esp_Highlight"
	Highlight.FillColor = Color3.fromRGB(255, 255, 255) 
	Highlight.OutlineColor = Color3.fromRGB(255, 255, 255) 
	Highlight.FillTransparency = 0.5
	Highlight.OutlineTransparency = 0
	Highlight.Adornee = a
	Highlight.Parent = a.Handle
	elseif _G.EspHighlight == false and a.Handle:FindFirstChild("Esp_Highlight") then
	a.Handle:FindFirstChild("Esp_Highlight"):Destroy()
end
if a.Handle:FindFirstChild("Esp_Gui") and a.Handle["Esp_Gui"]:FindFirstChild("TextLabel") then
	a.Handle["Esp_Gui"]:FindFirstChild("TextLabel").Text = 
	        (_G.EspName == true and "Key" or "")..
            (_G.EspDistance == true and "\nDistance ("..string.format("%.1f", (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - a.Handle.Position).Magnitude).."m)" or "")
    a.Handle["Esp_Gui"]:FindFirstChild("TextLabel").TextSize = _G.EspGuiTextSize or 15
    a.Handle["Esp_Gui"]:FindFirstChild("TextLabel").TextColor3 = _G.EspGuiTextColor or Color3.new(255, 255, 255)
end
if _G.EspGui == true and a.Handle:FindFirstChild("Esp_Gui") == nil then
	GuiPlayerEsp = Instance.new("BillboardGui", a.Handle)
	GuiPlayerEsp.Adornee = a.Handle
	GuiPlayerEsp.Name = "Esp_Gui"
	GuiPlayerEsp.Size = UDim2.new(0, 100, 0, 150)
	GuiPlayerEsp.AlwaysOnTop = true
	GuiPlayerEsp.StudsOffset = Vector3.new(0, 3, 0)
	GuiPlayerEspText = Instance.new("TextLabel", GuiPlayerEsp)
	GuiPlayerEspText.BackgroundTransparency = 1
	GuiPlayerEspText.Font = Enum.Font.Code
	GuiPlayerEspText.Size = UDim2.new(0, 100, 0, 100)
	GuiPlayerEspText.TextSize = 15
	GuiPlayerEspText.TextColor3 = Color3.new(0,0,0) 
	GuiPlayerEspText.TextStrokeTransparency = 0.5
	GuiPlayerEspText.Text = ""
	local UIStroke = Instance.new("UIStroke")
	UIStroke.Color = Color3.new(0, 0, 0)
	UIStroke.Thickness = 1.5
	UIStroke.Parent = GuiPlayerEspText
	elseif _G.EspGui == false and a.Handle:FindFirstChild("Esp_Gui") then
	a.Handle:FindFirstChild("Esp_Gui"):Destroy()
end
end
end
task.wait()
end
    end
})

TugwarGroup:AddToggle("Hide", {
    Text = Translation(MainTab, "Esp Player Hide"),
    Default = false, 
    Callback = function(Value) 
_G.HidePlayer = Value
if _G.HidePlayer == false then
	for i, v in pairs(game.Players:GetChildren()) do
		if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") then
			for i, n in pairs(v.Character:FindFirstChild("Head"):GetChildren()) do
				if n.Name:find("Esp_") then
					n:Destroy()
				end
			end
		end
	end
end
while _G.HidePlayer do
for i, v in pairs(game.Players:GetChildren()) do
if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") then
if not v:GetAttribute("IsHider") then
	for i, n in pairs(v.Character:FindFirstChild("Head"):GetChildren()) do
		if n.Name:find("Esp_") then
			n:Destroy()
		end
	end
end
if v:GetAttribute("IsHider") then
if v.Character.Head:FindFirstChild("Esp_Highlight") then
	v.Character.Head:FindFirstChild("Esp_Highlight").FillColor = Colorlight or Color3.fromRGB(255, 255, 255)
	v.Character.Head:FindFirstChild("Esp_Highlight").OutlineColor = Colorlight or Color3.fromRGB(255, 255, 255)
end
if _G.EspHighlight == true and v.Character.Head:FindFirstChild("Esp_Highlight") == nil then
	local Highlight = Instance.new("Highlight")
	Highlight.Name = "Esp_Highlight"
	Highlight.FillColor = Color3.fromRGB(255, 255, 255) 
	Highlight.OutlineColor = Color3.fromRGB(255, 255, 255) 
	Highlight.FillTransparency = 0.5
	Highlight.OutlineTransparency = 0
	Highlight.Adornee = v.Character
	Highlight.Parent = v.Character.Head
	elseif _G.EspHighlight == false and v.Character.Head:FindFirstChild("Esp_Highlight") then
	v.Character.Head:FindFirstChild("Esp_Highlight"):Destroy()
end
if v.Character.Head:FindFirstChild("Esp_Gui") and v.Character.Head["Esp_Gui"]:FindFirstChild("TextLabel") then
	v.Character.Head["Esp_Gui"]:FindFirstChild("TextLabel").Text = 
	        v.Name.." (Hide)"..
            (_G.EspDistance == true and "\nDistance ("..string.format("%.1f", (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude).."m)" or "")..
            (_G.EspHealth == true and "\nHealth ("..string.format("%.0f", v.Humanoid.Health)..")" or "")
    v.Character.Head["Esp_Gui"]:FindFirstChild("TextLabel").TextSize = _G.EspGuiTextSize or 15
    v.Character.Head["Esp_Gui"]:FindFirstChild("TextLabel").TextColor3 = _G.EspGuiTextColor or Color3.new(255, 255, 255)
end
if _G.EspGui == true and v.Character.Head:FindFirstChild("Esp_Gui") == nil then
	GuiPlayerEsp = Instance.new("BillboardGui", v.Character.Head)
	GuiPlayerEsp.Adornee = v.Character.Head
	GuiPlayerEsp.Name = "Esp_Gui"
	GuiPlayerEsp.Size = UDim2.new(0, 100, 0, 150)
	GuiPlayerEsp.AlwaysOnTop = true
	GuiPlayerEsp.StudsOffset = Vector3.new(0, 3, 0)
	GuiPlayerEspText = Instance.new("TextLabel", GuiPlayerEsp)
	GuiPlayerEspText.BackgroundTransparency = 1
	GuiPlayerEspText.Font = Enum.Font.Code
	GuiPlayerEspText.Size = UDim2.new(0, 100, 0, 100)
	GuiPlayerEspText.TextSize = 15
	GuiPlayerEspText.TextColor3 = Color3.new(0,0,0) 
	GuiPlayerEspText.TextStrokeTransparency = 0.5
	GuiPlayerEspText.Text = ""
	local UIStroke = Instance.new("UIStroke")
	UIStroke.Color = Color3.new(0, 0, 0)
	UIStroke.Thickness = 1.5
	UIStroke.Parent = GuiPlayerEspText
	elseif _G.EspGui == false and v.Character.Head:FindFirstChild("Esp_Gui") then
	v.Character.Head:FindFirstChild("Esp_Gui"):Destroy()
end
end
end
end
task.wait()
end
    end
})

TugwarGroup:AddToggle("Hide", {
    Text = Translation(MainTab, "Esp Player Seek"),
    Default = false, 
    Callback = function(Value) 
_G.SeekPlayer = Value
if _G.SeekPlayer == false then
	for i, v in pairs(game.Players:GetChildren()) do
		if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") then
			for i, n in pairs(v.Character:FindFirstChild("Head"):GetChildren()) do
				if n.Name:find("Esp_") then
					n:Destroy()
				end
			end
		end
	end
end
while _G.SeekPlayer do
for i, v in pairs(game.Players:GetChildren()) do
if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") then
if not v:GetAttribute("IsHunter") then
for i, n in pairs(v.Character:FindFirstChild("Head"):GetChildren()) do
	if n.Name:find("Esp_") then
		n:Destroy()
	end
end
end
if v:GetAttribute("IsHunter") then
if v.Character:FindFirstChild("Esp_Highlight1") then
	v.Character:FindFirstChild("Esp_Highlight1").FillColor = Colorlight or Color3.fromRGB(255, 255, 255)
	v.Character:FindFirstChild("Esp_Highlight1").OutlineColor = Colorlight or Color3.fromRGB(255, 255, 255)
end
if _G.EspHighlight == true and v.Character:FindFirstChild("Esp_Highlight1") == nil then
	local Highlight = Instance.new("Highlight")
	Highlight.Name = "Esp_Highlight1"
	Highlight.FillColor = Color3.fromRGB(255, 255, 255) 
	Highlight.OutlineColor = Color3.fromRGB(255, 255, 255) 
	Highlight.FillTransparency = 0.5
	Highlight.OutlineTransparency = 0
	Highlight.Adornee = v.Character
	Highlight.Parent = v.Character.Head
	elseif _G.EspHighlight == false and v.Character:FindFirstChild("Esp_Highlight1") then
	v.Character:FindFirstChild("Esp_Highlight1"):Destroy()
end
if v.Character.Head:FindFirstChild("Esp_Gui1") and v.Character.Head["Esp_Gui1"]:FindFirstChild("TextLabel") then
	v.Character.Head["Esp_Gui1"]:FindFirstChild("TextLabel").Text = 
	        v.Name.." (Seek)"..
            (_G.EspDistance == true and "\nDistance ("..string.format("%.1f", (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude).."m)" or "")
    v.Character.Head["Esp_Gui1"]:FindFirstChild("TextLabel").TextSize = _G.EspGuiTextSize or 15
    v.Character.Head["Esp_Gui1"]:FindFirstChild("TextLabel").TextColor3 = _G.EspGuiTextColor or Color3.new(255, 255, 255)
end
if _G.EspGui == true and v.Character.Head:FindFirstChild("Esp_Gui1") == nil then
	local GuiPlayerEsp = Instance.new("BillboardGui", v.Character.Head)
	GuiPlayerEsp.Adornee = v.Character.Head
	GuiPlayerEsp.Name = "Esp_Gui1"
	GuiPlayerEsp.Size = UDim2.new(0, 100, 0, 150)
	GuiPlayerEsp.AlwaysOnTop = true
	GuiPlayerEsp.StudsOffset = Vector3.new(0, 3, 0)
	local GuiPlayerEspText = Instance.new("TextLabel", GuiPlayerEsp)
	GuiPlayerEspText.BackgroundTransparency = 1
	GuiPlayerEspText.Font = Enum.Font.Code
	GuiPlayerEspText.Size = UDim2.new(0, 100, 0, 100)
	GuiPlayerEspText.TextSize = 15
	GuiPlayerEspText.TextColor3 = Color3.new(0,0,0) 
	GuiPlayerEspText.TextStrokeTransparency = 0.5
	GuiPlayerEspText.Text = ""
	local UIStroke = Instance.new("UIStroke")
	UIStroke.Color = Color3.new(0, 0, 0)
	UIStroke.Thickness = 1.5
	UIStroke.Parent = GuiPlayerEspText
	elseif _G.EspGui == false and v.Character.Head:FindFirstChild("Esp_Gui1") then
	v.Character.Head:FindFirstChild("Esp_Gui1"):Destroy()
end
end
end
end
task.wait()
end
    end
})

TugwarGroup:AddDivider()

TugwarGroup:AddToggle("Auto Teleport Hide", {
    Text = Translation(MainTab, "Auto Teleport Hide"),
    Default = false, 
    Callback = function(Value) 
_G.AutoTeleportHide = Value
while _G.AutoTeleportHide do
for i, v in pairs(game.Players:GetChildren()) do
if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") then
if v:GetAttribute("IsHider") and v.Character.Humanoid.Health > 0 then
if v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.MoveDirection.Magnitude > 0 then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Character:FindFirstChild("HumanoidRootPart").CFrame * CFrame.new(0, 0, -7)
else
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Character:FindFirstChild("HumanoidRootPart").CFrame
end
break
end
end
end
task.wait()
end
    end
})

TugwarGroup:AddButton(Translation(MainTab, "Teleport Player Hide"), function()
for i, v in pairs(game.Players:GetChildren()) do
if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") then
if v:GetAttribute("IsHider") and v.Character.Humanoid.Health > 0 then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame
break
end
end
end
end)

TugwarGroup:AddButton(Translation(MainTab, "Teleport All Key"), function()
local OldCFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
for _, a in pairs(workspace.Effects:GetChildren()) do
if a.Name:find("DroppedKey") and a:FindFirstChild("Handle") then
if game.Players.LocalPlayer.Character:FindFirstChild("Head") and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
if game.Players.LocalPlayer:GetAttribute("IsHider") and game.Players.LocalPlayer.Character.Humanoid.Health > 0 then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = a:FindFirstChild("Handle").CFrame
wait(0.5)
end
end
end
end
if game.Players.LocalPlayer.Character:FindFirstChild("Head") and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = OldCFrame
end
end)

local JumpropeGroup = Tabs.Tab:AddLeftGroupbox(Translation(MainTab, "Jump Rope"))

JumpropeGroup:AddButton(Translation(MainTab, "Complete Jump Rope"), function()
if workspace:WaitForChild("JumpRope") then
local pos = workspace.JumpRope.Important.Model.LEGS.Position
Player.Character.HumanoidRootPart.CFrame = CFrame.new(pos, pos + Vector3.new(0, 0, -1))
end
end)

local GlassBridgeGroup = Tabs.Tab:AddRightGroupbox(Translation(MainTab, "Glass Bridge"))

GlassBridgeGroup:AddButton(Translation(MainTab, "Glass Bridge Vision"), function()
local GlassHolder = workspace:WaitForChild("GlassBridge"):WaitForChild("GlassHolder")
for i, v in pairs(GlassHolder:GetChildren()) do
    for k, j in pairs(v:GetChildren()) do
        if j:IsA("Model") and j.PrimaryPart then
            local Color = j.PrimaryPart:GetAttribute("exploitingisevil") and Color3.fromRGB(248, 87, 87) or Color3.fromRGB(28, 235, 87)
            j.PrimaryPart.Color = Color
            j.PrimaryPart.Transparency = 0
            j.PrimaryPart.Material = Enum.Material.Neon
        end
    end
end
end)

GlassBridgeGroup:AddButton(Translation(MainTab, "Complete Glass Bridge"), function()
if workspace:WaitForChild("GlassBridge") then
local pos = workspace.GlassBridge.End.PrimaryPart.Position + Vector3.new(0, 8, 0)
Player.Character.HumanoidRootPart.CFrame = CFrame.new(pos, pos + Vector3.new(0, 0, -1))
end
end)

local MingleGroup = Tabs.Tab:AddLeftGroupbox(Translation(MainTab, "Mingle"))

MingleGroup:AddToggle("AutoMingle", {
    Text = Translation(MainTab, "Auto Mingle"),
    Default = false, 
    Callback = function(Value) 
_G.AutoMingle = Value
while _G.AutoMingle do
for i, v in ipairs(game.Players.LocalPlayer.Character:GetChildren()) do
	if v.Name == "RemoteForQTE" then
        v:FireServer()
    end
end
task.wait()
end
    end
})

local RebelGroup = Tabs.Tab:AddRightGroupbox(Translation(MainTab, "Rebel"))

RebelGroup:AddToggle("WallCheck", {
    Text = Translation(MainTab, "WallCheck"),
    Default = false, 
    Callback = function(Value) 
_G.WallCheck = Value
    end
})

RebelGroup:AddToggle("Aimbot Guard", {
    Text = Translation(MainTab, "Aimbot Guard"),
    Default = false, 
    Callback = function(Value) 
_G.Aimbot = Value
while _G.Aimbot do
local DistanceMath, TargetNpc = math.huge, nil
for i,v in pairs(workspace.Live:GetChildren()) do
	if v.Name:find("Guard") or v.Name:find("Third") then
		if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
			if _G.WallCheck == true and not CheckWall(v:FindFirstChild("Head")) then 
				continue
			end
			local Distance = (game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position - v.HumanoidRootPart.Position).Magnitude
			if Distance < DistanceMath then
				TargetNpc, DistanceMath = v, Distance
			end
		end
	end
end
if TargetNpc then
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and TargetNpc:FindFirstChild("Head") and TargetNpc:FindFirstChild("Humanoid") then
game.Workspace.CurrentCamera.CFrame = CFrame.lookAt(game.Workspace.CurrentCamera.CFrame.Position, game.Workspace.CurrentCamera.CFrame.Position + (TargetNpc["Head"].Position - game.Workspace.CurrentCamera.CFrame.Position).unit)
end
end
task.wait()
end
    end
})

RebelGroup:AddToggle("Bring Guard", {
    Text = Translation(MainTab, "Bring Guard"),
    Default = false, 
    Callback = function(Value) 
_G.Bring = Value
while _G.Bring do
for i,v in pairs(workspace.Live:GetChildren()) do
	if v.Name:find("Guard") or v.Name:find("Third") then
		if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
			v.HumanoidRootPart.CFrame = Player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -6)
		end
	end
end
task.wait()
end
    end
})

RebelGroup:AddToggle("Inf Ammo", {
    Text = Translation(MainTab, "Inf Ammo"),
    Default = false, 
    Callback = function(Value) 
_G.InfAmmo = Value
while _G.InfAmmo do
for i, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
if v.Name == "InfoMP5Client" and v:FindFirstChild("Bullets") then
v.Bullets.Value = 999999999
end
end
task.wait()
end
    end
})

local MiscTab = "Misc"
local Misc1Group = Tabs.Tab1:AddLeftGroupbox(Translation("Tab", "Misc"))

Misc1Group:AddToggle("AutoSkip", {
    Text = Translation(MiscTab, "Auto Skip"),
    Default = false, 
    Callback = function(Value) 
_G.AutoSkip = Value
while _G.AutoSkip do
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("DialogueRemote"):FireServer("Skipped")
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("TemporaryReachedBindable"):FireServer()
task.wait(0.8)
end
    end
})

Misc1Group:AddSlider("WalkSpeed", {
    Text = Translation(MiscTab, "Speed"),
    Default = 20,
    Min = 20,
    Max = 1000,
    Rounding = 0,
    Compact = true,
    Callback = function(Value)
_G.Speed = Value
    end
})

Misc1Group:AddInput("WalkSpeed1", {
    Default = "20",
    Numeric = false,
    Text = Translation(MiscTab, "Speed"),
    Placeholder = "UserSpeed",
    Callback = function(Value)
_G.Speed = Value
    end
})

Misc1Group:AddToggle("SetSpeed", {
    Text = Translation(MiscTab, "Auto Speed"),
    Default = false, 
    Callback = function(Value) 
_G.AutoSpeed = Value
if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = _G.Speed or 50
end
    end
})

Misc1Group:AddToggle("No Cooldown Proximity", {
    Text = Translation(MiscTab, "No Cooldown Proximity"),
    Default = false, 
    Callback = function(Value) 
_G.NoCooldownProximity = Value
if _G.NoCooldownProximity == true then
for i, v in pairs(workspace:GetDescendants()) do
if v.ClassName == "ProximityPrompt" then
v.HoldDuration = 0
end
end
else
if CooldownProximity then
CooldownProximity:Disconnect()
CooldownProximity = nil
end
end
CooldownProximity = workspace.DescendantAdded:Connect(function(Cooldown)
if _G.NoCooldownProximity == true then
if Cooldown:IsA("ProximityPrompt") then
Cooldown.HoldDuration = 0
end
end
end)
    end
})

Misc1Group:AddSlider("Fly Bypass", {
    Text = Translation(MiscTab, "Fly Speed"),
    Default = 20,
    Min = 20,
    Max = 500,
    Rounding = 0,
    Compact = true,
    Callback = function(Value)
_G.SetSpeedFly = Value
    end
})

_G.SetSpeedFly = 50
Misc1Group:AddToggle("Fly", {
    Text = Translation(MiscTab, "Fly"),
    Default = false, 
    Callback = function(Value) 
_G.StartFly = Value
while _G.StartFly do
if game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyGyro") == nil then
local bg = Instance.new("BodyGyro", game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart"))
bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
bg.P = 9e4
bg.CFrame = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame
end
if game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyVelocity") == nil then
local bv = Instance.new("BodyVelocity", game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart"))
bv.Velocity = Vector3.new(0, 0, 0)
bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
end
local MoveflyPE = require(game.Players.LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule")):GetMoveVector()
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyVelocity") and game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyGyro") then
    game.Players.LocalPlayer.Character.HumanoidRootPart.BodyVelocity.MaxForce = Vector3.new(9e9,9e9,9e9)
    game.Players.LocalPlayer.Character.HumanoidRootPart.BodyGyro.MaxTorque = Vector3.new(9e9,9e9,9e9)
    game.Players.LocalPlayer.Character.HumanoidRootPart.BodyGyro.CFrame = CFrame.new(game.Players.LocalPlayer.Character.HumanoidRootPart.Position, game.Players.LocalPlayer.Character.HumanoidRootPart.Position + game.Workspace.CurrentCamera.CFrame.LookVector)
    game.Players.LocalPlayer.Character.HumanoidRootPart.BodyVelocity.Velocity = Vector3.new()
    if MoveflyPE.X > 0 then
        game.Players.LocalPlayer.Character.HumanoidRootPart.BodyVelocity.Velocity = game.Players.LocalPlayer.Character.HumanoidRootPart.BodyVelocity.Velocity + game.Workspace.CurrentCamera.CFrame.RightVector * (MoveflyPE.X * _G.SetSpeedFly)
    end
    if MoveflyPE.X < 0 then
        game.Players.LocalPlayer.Character.HumanoidRootPart.BodyVelocity.Velocity = game.Players.LocalPlayer.Character.HumanoidRootPart.BodyVelocity.Velocity + game.Workspace.CurrentCamera.CFrame.RightVector * (MoveflyPE.X * _G.SetSpeedFly)
    end
    if MoveflyPE.Z > 0 then
        game.Players.LocalPlayer.Character.HumanoidRootPart.BodyVelocity.Velocity = game.Players.LocalPlayer.Character.HumanoidRootPart.BodyVelocity.Velocity - game.Workspace.CurrentCamera.CFrame.LookVector * (MoveflyPE.Z * _G.SetSpeedFly)
    end
    if MoveflyPE.Z < 0 then
        game.Players.LocalPlayer.Character.HumanoidRootPart.BodyVelocity.Velocity = game.Players.LocalPlayer.Character.HumanoidRootPart.BodyVelocity.Velocity - game.Workspace.CurrentCamera.CFrame.LookVector * (MoveflyPE.Z * _G.SetSpeedFly)
    end
end
task.wait()
end
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
    if game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyGyro") then
        game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyGyro"):Destroy()
    end
    if game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyVelocity") then
        game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyVelocity"):Destroy()
    end
end
	end
}):AddKeyPicker("Fly", {
   Default = "R",
   Text = "Fly",
   Mode = "Toggle",
   SyncToggleState = true
})

Misc1Group:AddToggle("Noclip", {
    Text = Translation(MiscTab, "Noclip"),
    Default = false, 
    Callback = function(Value) 
_G.NoclipCharacter = Value
if _G.NoclipCharacter == false then
	if game.Players.LocalPlayer.Character ~= nil then
		for i, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
			if v:IsA("BasePart") and v.CanCollide == false then
				v.CanCollide = true
			end
		end
	end
end
while _G.NoclipCharacter do
if game.Players.LocalPlayer.Character ~= nil then
		for i, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
	end
task.wait()
end
    end
}):AddKeyPicker("NoclipCharacter", {
   Default = "G",
   Text = Translation(MiscTab, "Noclip"),
   Mode = "Toggle",
   SyncToggleState = true
})

Misc1Group:AddToggle("Inf Jump", {
    Text = Translation(MiscTab, "Inf Jump"),
    Default = false, 
    Callback = function(Value) 
_G.InfiniteJump = Value
    end
}):AddKeyPicker("InfJump", {
   Default = "J",
   Text = Translation(MiscTab, "Inf Jump"),
   Mode = "Toggle",
   SyncToggleState = true
})

Misc1Group:AddToggle("Tp", {
    Text = Translation(MiscTab, "Teleport Player"),
    Default = false, 
    Callback = function(Value) 
_G.TeleportPlayerAuto = Value
    end
}):AddKeyPicker("TpPlr", {
   Default = "G",
   Text = Translation(MiscTab, "Teleport Player"),
   Mode = "Toggle",
   SyncToggleState = true
})

Misc1Group:AddToggle("Camlock", {
    Text = Translation(MiscTab, "Camlock Player / TP"),
    Default = false, 
    Callback = function(Value) 
_G.CamlockPlayer = Value
while _G.CamlockPlayer do
local DistanceMath, TargetPlayer = math.huge, nil
for i,v in pairs(game.Players:GetChildren()) do
	if v ~= game.Players.LocalPlayer and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and v.Character then
		if v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("Humanoid") and v.Character:FindFirstChild("HumanoidRootPart") then
			local Distance = (game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position - v.Character.HumanoidRootPart.Position).Magnitude
			if Distance < DistanceMath then
				TargetPlayer, DistanceMath = v.Character, Distance
			end
		end
	end
end
if TargetPlayer then
repeat task.wait()
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and TargetPlayer:FindFirstChild("HumanoidRootPart") and TargetPlayer:FindFirstChild("Humanoid") then
if _G.TeleportPlayerAuto == true then
if TargetPlayer:FindFirstChild("Humanoid") and TargetPlayer.Humanoid.MoveDirection.Magnitude > 0 then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = TargetPlayer:FindFirstChild("HumanoidRootPart").CFrame * CFrame.new(0, 0, -7)
else
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = TargetPlayer:FindFirstChild("HumanoidRootPart").CFrame
end
elseif not _G.TeleportPlayerAuto then
game.Workspace.CurrentCamera.CFrame = CFrame.lookAt(game.Workspace.CurrentCamera.CFrame.Position, game.Workspace.CurrentCamera.CFrame.Position + (TargetPlayer.HumanoidRootPart.Position - game.Workspace.CurrentCamera.CFrame.Position).unit)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(game.Players.LocalPlayer.Character.HumanoidRootPart.Position, Vector3.new(TargetPlayer.HumanoidRootPart.Position.X, game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Y, TargetPlayer.HumanoidRootPart.Position.Z))
end
end
until _G.CamlockPlayer == false or TargetPlayer:FindFirstChild("Humanoid") and TargetPlayer.Humanoid.Health <= 0
end
task.wait()
end
    end
}):AddKeyPicker("CamlockPlr", {
   Default = "K",
   Text = Translation(MiscTab, "Camlock Player / TP"),
   Mode = "Toggle",
   SyncToggleState = true
})

function HasTool(tool)
	for _, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
		if v:IsA("Tool") and v.Name == tool then
			return true
		end
	end
	for _, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
		if v:IsA("Tool") and v.Name == tool then
			return true
		end
	end
	return false
end
Misc1Group:AddToggle("Bandage", {
	Text = Translation(MiscTab, "Auto Collect Bandage"),
	Default = false,
	Callback = function(Value)
_G.CollectBandage = Value
while _G.CollectBandage do
local OldCFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
if not HasTool("Bandage") then
repeat task.wait()
if workspace:FindFirstChild("Effects") then
for _, v in pairs(workspace:FindFirstChild("Effects"):GetChildren()) do
if v.Name == "DroppedBandage" and v:FindFirstChild("Handle") then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Handle.CFrame
break
end
end
end
until HasTool("Bandage")
task.wait(0.3)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = OldCFrame
end
task.wait()
end
	end
})

Misc1Group:AddToggle("FlashBang", {
	Text = Translation(MiscTab, "Auto Collect Flash Bang"),
	Default = false,
	Callback = function(Value)
_G.CollectFlashbang = Value
while _G.CollectFlashbang do
local OldCFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
if not HasTool("Flashbang") then
repeat task.wait()
if workspace:FindFirstChild("Effects") then
for _, v in pairs(workspace:FindFirstChild("Effects"):GetChildren()) do
if v.Name == "DroppedFlashbang" and v:FindFirstChild("Stun Grenade") then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v["Stun Grenade"].CFrame
break
end
end
end
until HasTool("Flashbang")
task.wait(0.3)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = OldCFrame
end
task.wait()
end
	end
})

Misc1Group:AddToggle("Grenade", {
	Text = Translation(MiscTab, "Auto Collect Grenade"),
	Default = false,
	Callback = function(Value)
_G.CollectGrenade = Value
while _G.CollectGrenade do
local OldCFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
if not HasTool("Grenade") then
repeat task.wait()
if workspace:FindFirstChild("Effects") then
for _, v in pairs(workspace:FindFirstChild("Effects"):GetChildren()) do
if v.Name == "DroppedGrenade" and v:FindFirstChild("Handle") then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Handle.CFrame
break
end
end
end
until HasTool("Grenade")
task.wait(0.3)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = OldCFrame
end
task.wait()
end
	end
})

Misc1Group:AddToggle("Anti Fling", {
    Text = Translation(MiscTab, "Anti Fling"),
    Default = false, 
    Callback = function(Value) 
_G.AntiFling = Value
while _G.AntiFling do
for i, v in pairs(game.Players:GetChildren()) do
    if v ~= game.Players.LocalPlayer and v.Character then
        for _, k in pairs(v.Character:GetChildren()) do
            if k:IsA("BasePart") then
                k.CanCollide = false
            end
        end
    end
end
task.wait()
end
    end
})

Misc1Group:AddToggle("Anti Banana", {
    Text = Translation(MiscTab, "Anti Banana"),
    Default = false, 
    Callback = function(Value) 
_G.AntiBanana = Value
while _G.AntiBanana do
if workspace:FindFirstChild("Effects") then
	for i, v in pairs(workspace:FindFirstChild("Effects"):GetChildren()) do
	    if v.Name:find("Banana") then
		    v:Destroy()
	    end
	end
end
task.wait()
end
    end
})


_G.PartLag = {"FootstepEffect", "BulletHole", "GroundSmokeDIFFERENT", "ARshell", "effect debris", "effect", "DroppedMP5"}
Misc1Group:AddToggle("Anti Lag", {
    Text = Translation(MiscTab, "Anti Lag"),
    Default = false, 
    Callback = function(Value) 
_G.AntiLag = Value
if _G.AntiLag == true then
local Terrain = workspace:FindFirstChildOfClass("Terrain")
Terrain.WaterWaveSize = 0
Terrain.WaterWaveSpeed = 0
Terrain.WaterReflectance = 0
Terrain.WaterTransparency = 1
game.Lighting.GlobalShadows = false
game.Lighting.FogEnd = 9e9
game.Lighting.FogStart = 9e9
for i,v in pairs(game:GetDescendants()) do
	if v:IsA("BasePart") then
		v.Material = "Plastic"
		v.Reflectance = 0
		v.BackSurface = "SmoothNoOutlines"
		v.BottomSurface = "SmoothNoOutlines"
		v.FrontSurface = "SmoothNoOutlines"
		v.LeftSurface = "SmoothNoOutlines"
		v.RightSurface = "SmoothNoOutlines"
		v.TopSurface = "SmoothNoOutlines"
	elseif v:IsA("Decal") then
		v.Transparency = 1
	elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
		v.Lifetime = NumberRange.new(0)
	end
end
for i,v in pairs(game.Lighting:GetDescendants()) do
	if v:IsA("PostEffect") then
		v.Enabled = false
	end
end
for i,v in pairs(game.Workspace:GetDescendants()) do
	if v:IsA("ForceField") or v:IsA("Sparkles") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Beam") then
		v:Destroy()
	end
end
end
while _G.AntiLag do
	for i, v in pairs(workspace:FindFirstChild("Effects"):GetChildren()) do
		if _G.AntiLag == true then
			PartLagDe(v)
		end
	end
	task.wait()
end
    end
})

local Misc2Group = Tabs.Tab1:AddRightGroupbox(Translation(MiscTab, "Settings Gui"))

_G.EspHighlight = false
Misc2Group:AddToggle("Esp Hight Light", {
    Text = Translation(MiscTab, "Esp Hight Light"),
    Default = false, 
    Callback = function(Value) 
_G.EspHighlight = Value
    end
}):AddColorPicker("Color Esp", {
     Default = Color3.new(255,255,255),
     Callback = function(Value)
_G.ColorLight = Value
     end
})

_G.EspGui = false
Misc2Group:AddToggle("Esp Gui", {
    Text = Translation(MiscTab, "Esp Gui"),
    Default = false, 
    Callback = function(Value) 
_G.EspGui = Value
    end
}):AddColorPicker("Color Esp Text", {
     Default = Color3.new(255,255,255),
     Callback = function(Value)
_G.EspGuiTextColor = Value
     end
})

Misc2Group:AddSlider("Text Size", {
    Text = Translation(MiscTab, "Text Size [ Gui ]"),
    Default = 7,
    Min = 7,
    Max = 50,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
_G.EspGuiTextSize = Value
    end
})

Misc2Group:AddDivider()

_G.EspName = false
Misc2Group:AddToggle("Esp Name", {
    Text = Translation(MiscTab, "Esp Name"),
    Default = false, 
    Callback = function(Value) 
_G.EspName = Value
    end
})

_G.EspDistance = false
Misc2Group:AddToggle("Esp Distance", {
    Text = Translation(MiscTab, "Esp Distance"),
    Default = false, 
    Callback = function(Value) 
_G.EspDistance = Value
    end
})

------------------------------------------------------------------------
local MenuGroup = Tabs["UI Settings"]:AddLeftGroupbox("Menu")
local CreditsGroup = Tabs["UI Settings"]:AddRightGroupbox("Credits")
local Info = Tabs["UI Settings"]:AddRightGroupbox("Info")

MenuGroup:AddDropdown("NotifySide", {
    Text = "Notification Side",
    Values = {"Left", "Right"},
    Default = "Right",
    Multi = false,
    Callback = function(Value)
Library:SetNotifySide(Value)
    end
})

_G.ChooseNotify = "Obsidian"
MenuGroup:AddDropdown("NotifyChoose", {
    Text = "Notification Choose",
    Values = {"Obsidian", "Roblox"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.ChooseNotify = Value
    end
})

_G.NotificationSound = true
MenuGroup:AddToggle("NotifySound", {
    Text = "Notification Sound",
    Default = true, 
    Callback = function(Value) 
_G.NotificationSound = Value 
    end
})

MenuGroup:AddSlider("Volume Notification", {
    Text = "Volume Notification",
    Default = 2,
    Min = 2,
    Max = 10,
    Rounding = 1,
    Compact = true,
    Callback = function(Value)
_G.VolumeTime = Value
    end
})

MenuGroup:AddToggle("KeybindMenuOpen", {Default = false, Text = "Open Keybind Menu", Callback = function(Value) Library.KeybindFrame.Visible = Value end})
MenuGroup:AddToggle("ShowCustomCursor", {Text = "Custom Cursor", Default = true, Callback = function(Value) Library.ShowCustomCursor = Value end})
MenuGroup:AddDivider()
MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", {Default = "RightShift", NoUI = true, Text = "Menu keybind"})
MenuGroup:AddButton("Copy Link Discord", function()
    if setclipboard then
        setclipboard("dsc.gg/dllrhub")
        Library:Notify("Copied discord link to clipboard!")
    end
end):AddButton("Copy Link", function()
    if setclipboard then
        setclipboard("guns.lol/dllr")
        Library:Notify("Copied link to clipboard!")
    end
end)
MenuGroup:AddButton("Unload", function() Library:Unload() end)
CreditsGroup:AddLabel("Dolla hub", true)
true)

Info:AddLabel("Counter [ "..game:GetService("LocalizationService"):GetCountryRegionForPlayerAsync(game.Players.LocalPlayer).." ]", true)
Info:AddLabel("Executor [ "..identifyexecutor().." ]", true)
Info:AddLabel("Job Id [ "..game.JobId.." ]", true)
Info:AddDivider()
Info:AddButton("Copy JobId", function()
    if setclipboard then
        setclipboard(tostring(game.JobId))
        Library:Notify("Copied Success")
    else
        Library:Notify(tostring(game.JobId), 10)
    end
end)

Info:AddInput("Join Job", {
    Default = "Nah",
    Numeric = false,
    Text = "Join Job",
    Placeholder = "UserJobId",
    Callback = function(Value)
_G.JobIdJoin = Value
    end
})

Info:AddButton("Join JobId", function()
game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, _G.JobIdJoin, game.Players.LocalPlayer)
end)

Info:AddButton("Copy Join JobId", function()
    if setclipboard then
        setclipboard('game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, '..game.JobId..", game.Players.LocalPlayer)")
        Library:Notify("Copied Success") 
    else
        Library:Notify(tostring(game.JobId), 10)
    end
end)

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])
SaveManager:LoadAutoloadConfig()
