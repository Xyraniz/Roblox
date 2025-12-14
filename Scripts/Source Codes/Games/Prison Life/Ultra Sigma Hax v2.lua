--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
if getgenv().haxloaded then
    return
end

if getcustomasset or getgenv().getcustomasset then
    local getasset = getcustomasset or getgenv().getcustomasset
    
    spawn(function()
        local encoded = game:HttpGet("https://raw.githubusercontent.com/UltraFEmotes/test/refs/heads/main/welcome.txt")
        if not encoded or encoded == "" then return end
        
        writefile("Welcome.mp3", base64decode(encoded))
       task.wait(0.5)
        
        local asset_id = getasset("Welcome.mp3")
        local sound = Instance.new("Sound")
        sound.SoundId = asset_id
        sound.Volume = 1
        sound.Looped = false
        sound.Parent = workspace
        sound:Play()
        
        sound.Ended:Connect(function()
            sound:Destroy()
        end)
    end)
end
getgenv().haxloaded = true
local sextoy = Instance.new("Message")
sextoy.Parent = workspace
sextoy.Text = "ULTRA SIGMA HAX V2 >:3c"
task.wait(2)
sextoy.Text = "Made by White Cat :3c"
task.wait(1.6)
sextoy:Destroy()
local function processPart(obj)
    if obj:IsA("BasePart") then
        task.spawn(function()
            while true do
                for i = 0, 1, 0.01 do
                    obj.Color = Color3.fromHSV(i, 1, 1)
                    task.wait(0.02)
                end
            end
        end)
        obj.Transparency = 0.5
        obj.CanCollide = false
    end
end
local function recursiveProcess(obj)
    processPart(obj)
    for _, child in ipairs(obj:GetChildren()) do
        recursiveProcess(child)
    end
end
for _, v in pairs(workspace.Prison_OuterWall.prison_wall:GetChildren()) do
    recursiveProcess(v)
end
for _, v in pairs(workspace.Prison_guardtower:GetChildren()) do
    recursiveProcess(v)
end
for _, v in pairs(workspace.Prison_Fences:GetChildren()) do
    if v.Name == "fence" then
        recursiveProcess(v)
        local dmg = v:FindFirstChild("damagePart")
        if dmg then
            local ti = dmg:FindFirstChild("TouchInterest")
            if ti then
                ti:Destroy()
            end
        end
    end
end
local doors = workspace:FindFirstChild("Doors")
if doors then
    doors:Destroy()
end
task.spawn(function()
    while task.wait() do
        if game.Players.LocalPlayer and game.Players.LocalPlayer.Character then
            local hum = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.WalkSpeed = 25
                game.Players.LocalPlayer:SetAttribute("BackpackEnabled", true)
                hum.JumpHeight = 5.5
            end
            if game.Players.LocalPlayer.Character:FindFirstChild("AntiJump") then
                game.Players.LocalPlayer.Character.AntiJump:Destroy()
            end
        end
    end
end)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local ESP_ENABLED = false
local TELEPORT_COOLDOWN = 1.6
local lastTeleport = 0
local function GetBillboard(targetCharacter)
    local head = targetCharacter:FindFirstChild("Head")
    if not head then
        return nil
    end
    local billboard = head:FindFirstChild("AntigravityESP_Billboard")
    if not billboard then
        billboard = Instance.new("BillboardGui")
        billboard.Name = "AntigravityESP_Billboard"
        billboard.Adornee = head
        billboard.Size = UDim2.new(0, 200, 0, 120)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = head
        local emojiLabel = Instance.new("TextLabel")
        emojiLabel.Name = "EmojiLabel"
        emojiLabel.Size = UDim2.new(1, 0, 0.35, 0)
        emojiLabel.Position = UDim2.new(0, 0, 0, 0)
        emojiLabel.BackgroundTransparency = 1
        emojiLabel.TextColor3 = Color3.new(1, 1, 1)
        emojiLabel.TextStrokeTransparency = 0
        emojiLabel.Font = Enum.Font.GothamBold
        emojiLabel.TextSize = 24
        emojiLabel.Parent = billboard
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Name = "NameLabel"
        nameLabel.Size = UDim2.new(1, 0, 0.35, 0)
        nameLabel.Position = UDim2.new(0, 0, 0.35, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.TextColor3 = Color3.new(1, 1, 1)
        nameLabel.TextStrokeTransparency = 0
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = 14
        nameLabel.Parent = billboard
        local healthBarBG = Instance.new("Frame")
        healthBarBG.Name = "HealthBarBG"
        healthBarBG.Size = UDim2.new(0.8, 0, 0.12, 0)
        healthBarBG.Position = UDim2.new(0.1, 0, 0.75, 0)
        healthBarBG.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        healthBarBG.BorderSizePixel = 0
        healthBarBG.Parent = billboard
        local healthBarFill = Instance.new("Frame")
        healthBarFill.Name = "HealthBarFill"
        healthBarFill.Size = UDim2.new(1, 0, 1, 0)
        healthBarFill.Position = UDim2.new(0, 0, 0, 0)
        healthBarFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        healthBarFill.BorderSizePixel = 0
        healthBarFill.Parent = healthBarBG
        local healthBarCorner = Instance.new("UICorner")
        healthBarCorner.CornerRadius = UDim.new(0, 3)
        healthBarCorner.Parent = healthBarBG
        local healthBarFillCorner = Instance.new("UICorner")
        healthBarFillCorner.CornerRadius = UDim.new(0, 3)
        healthBarFillCorner.Parent = healthBarFill
    end
    return billboard
end
local function GetCham(targetCharacter)
    local cham = targetCharacter:FindFirstChild("AntigravityESP_Cham")
    if not cham then
        cham = Instance.new("Highlight")
        cham.Name = "AntigravityESP_Cham"
        cham.Adornee = targetCharacter
        cham.Parent = targetCharacter
        cham.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    end
    return cham
end
local function UpdateESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local billboard = GetBillboard(player.Character)
            local cham = GetCham(player.Character)
            if billboard and cham then
                if ESP_ENABLED then
                    billboard.Enabled = true
                    cham.Enabled = true
                    local nameLabel = billboard:FindFirstChild("NameLabel")
                    local emojiLabel = billboard:FindFirstChild("EmojiLabel")
                    local healthBarFill = billboard:FindFirstChild("HealthBarBG") and billboard.HealthBarBG:FindFirstChild("HealthBarFill")
                    local teamName = player.Team and player.Team.Name or "Neutral"
                    local displayText = player.Name
                    local emojiText = ""
                    local color = Color3.new(1, 1, 1)
                    if teamName == "Inmates" then
                        color = Color3.fromRGB(255, 170, 0)
                        displayText = displayText .. " [Inmate]"
                        local isHostile = player.Character:GetAttribute("Hostile")
                        local isTrespassing = player.Character:GetAttribute("Trespassing")
                        if isHostile then
                            emojiText = emojiText .. "💢"
                        end
                        if isTrespassing then
                            emojiText = emojiText .. "🔗"
                        end
                    elseif teamName == "Guards" then
                        color = Color3.fromRGB(0, 100, 255)
                        displayText = displayText .. " [Guards]"
                    elseif teamName == "Criminals" then
                        color = Color3.fromRGB(255, 50, 50)
                        displayText = displayText .. " [Criminals]"
                    else
                        displayText = displayText .. " [" .. teamName .. "]"
                    end
                    nameLabel.Text = displayText
                    nameLabel.TextColor3 = color
                    emojiLabel.Text = emojiText
                    cham.FillColor = color
                    cham.OutlineColor = color
                    cham.FillTransparency = 0.5
                    cham.OutlineTransparency = 0
                    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid and healthBarFill then
                        local healthPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                        healthBarFill.Size = UDim2.new(healthPercent, 0, 1, 0)
                        if healthPercent > 0.5 then
                            healthBarFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                        elseif healthPercent > 0.25 then
                            healthBarFill.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
                        else
                            healthBarFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                        end
                    end
                else
                    billboard.Enabled = false
                    cham.Enabled = false
                end
            end
        end
    end
end
local function CanTeleport()
    local now = tick()
    local delta = now - lastTeleport
    if delta < TELEPORT_COOLDOWN then
        local remaining = TELEPORT_COOLDOWN - delta
        game.StarterGui:SetCore("SendNotification", {
            Title = "TP Cooldown",
            Text = "Wait " .. string.format("%.1f", remaining) .. "s before teleporting again"
        })
        return false
    end
    lastTeleport = now
    return true
end
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Scrolling = Instance.new("ScrollingFrame")
local UIStroke = Instance.new("UIStroke")
local UICorner = Instance.new("UICorner")
local UIListLayout = Instance.new("UIListLayout")
local Title = Instance.new("TextLabel")
local Buttons = {
	{ name="CrimBaseTP", text="TP to Crim Base" },
	{ name="PrisonTP", text="TP to Prison" },
    { name ="GuardRoomTP", text="TP in Guard Room"},
	{ name="ModGguns", text="Mod All Guns" },
    { name = "GetRem", text="Get Rem (shotgun)"},
    { name = "GetM9", text="Get M9 (pistol)"},
    { name = "GetFAL", text = "Get FAL (paid/ar)"},
    { name = "GetAK", text = "Get AK47 (ar)"},
    { name = "GetM4", text = "Get M4A1 (paid/ar)"},
    { name = "ToggleESP", text = "Toggle ESP (OFF)"}
}
ScreenGui.Parent = game:WaitForChild("CoreGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Frame.Parent = ScreenGui
Frame.BackgroundTransparency = 0.7
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.Position = UDim2.new(0.35, 0, 0.25, 0)
Frame.Size = UDim2.new(0, 300, 0, 260)
UIStroke.Parent = Frame
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(255, 80, 80)
UICorner.Parent = Frame
Title.Parent = Frame
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundTransparency = 1
Title.Text = "ULTRA SIGMA HAX V2"
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 24
Title.TextColor3 = Color3.fromRGB(255, 50, 50)
Scrolling.Parent = Frame
Scrolling.Position = UDim2.new(0, 0, 0, 50)
Scrolling.Size = UDim2.new(1, 0, 1, -50)
Scrolling.BackgroundTransparency = 1
Scrolling.CanvasSize = UDim2.new(0, 0, 0, 0)
Scrolling.ScrollBarThickness = 4
Scrolling.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scrolling.ScrollingDirection = Enum.ScrollingDirection.Y
UIListLayout.Parent = Scrolling
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.FillDirection = Enum.FillDirection.Vertical
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
for _, info in ipairs(Buttons) do
	local btn = Instance.new("TextButton")
	btn.Name = info.name
	btn.Parent = Scrolling
	btn.Size = UDim2.new(0.85, 0, 0, 40)
	btn.BackgroundTransparency = 0.6
	btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	btn.Text = info.text
	btn.Font = Enum.Font.GothamBold
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextScaled = true
	Instance.new("UICorner", btn)
	btn.MouseEnter:Connect(function()
		btn.BackgroundTransparency = 0.3
	end)
	btn.MouseLeave:Connect(function()
		btn.BackgroundTransparency = 0.6
	end)
	btn.MouseButton1Click:Connect(function()
		if info.name == "ModGguns" then
            game.StarterGui:SetCore("SendNotification", {Text="Make sure you aren't holding any guns rn", Title="Modded shit idfk"})
			for i, v in pairs(LocalPlayer.Backpack:GetChildren()) do
				if v:GetAttribute("FireRate") ~= nil then
					v:SetAttribute("FireRate", 0.02)
					v:SetAttribute("AutoFire", true)
					v:SetAttribute("SpreadRadius", 0)
                    game.StarterGui:SetCore("SendNotification", {Text="Modded " .. v.Name .. " successfully!", Title="Modded shit idfk"})
				end
			end
		elseif info.name == "CrimBaseTP" then
            if CanTeleport() then
			    LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["Criminals Spawn"].SpawnLocation.CFrame
            end
		elseif info.name == "PrisonTP" then
            if CanTeleport() then
			    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(916, 100, 2369)
            end
        elseif info.name == "GuardRoomTP" then
            if CanTeleport() then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(828, 100, 2303)
            end
        elseif info.name == "GetRem" then
            if CanTeleport() then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(821, 101, 2217)
            end
        elseif info.name == "GetM9" then
            if CanTeleport() then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(813, 101, 2217)
            end
        elseif info.name == "GetFAL" then
            if CanTeleport() then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-916, 94, 2048)
            end
        elseif info.name == "GetM4" then
            if CanTeleport() then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(847, 101, 2217)
            end
        elseif info.name == "GetAK" then
            if CanTeleport() then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-931, 94, 2039)
            end
        elseif info.name == "ToggleESP" then
            ESP_ENABLED = not ESP_ENABLED
            btn.Text = "Toggle ESP (" .. (ESP_ENABLED and "ON" or "OFF") .. ")"
            UpdateESP()
		end
	end)
end

local UIS = game:GetService("UserInputService")
local dragging = false
local dragStart, startPos

Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
    end
end)

Frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

task.spawn(function()
    while true do
        for i = 0, 1, 0.01 do
            UIStroke.Color = Color3.fromHSV(i, 1, 1)
            task.wait(0.02)
        end
    end
end)
task.spawn(function()
    while true do
        for i = 0, 1, 0.01 do
            Title.TextColor3 = Color3.fromHSV(i, 1, 1)
            task.wait(0.02)
        end
    end
end)
game.StarterGui:SetCore("SendNotification", {Text = "Loaded Successfully", Title = "ULTRA SIGMA HAX V2 >:3c"})
RunService.RenderStepped:Connect(UpdateESP)
