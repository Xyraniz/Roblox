-- leaked by galaxy.lua ;; published by 25ms :p
local Luna = loadstring(game:HttpGet("http://you.whimper.xyz/sources/lunaUi.lua"))()
local VIM = game:GetService("VirtualInputManager")

local Window = Luna:CreateWindow({
    Name = "TheBillDevHub Blue Lock Rivals V0.3",
    Subtitle = "discord.gg/thebilldev", 
    LogoID = "",
    LoadingEnabled = false,
    LoadingTitle = "Thebilldev Hub",
    LoadingSubtitle = "by Galaxy",
    ConfigSettings = {
        RootFolder = nil,
        ConfigFolder = "Big Hub"
    },
    KeySystem = false
})

local AutoFarmTab = Window:CreateTab({
    Name = "Auto Farm",
    Icon = "agriculture", 
    ImageSource = "Material",
    ShowTitle = true
})
local StatsTab = Window:CreateTab({
	Name = "Stats",
	Icon = "view_sidebar",
	ImageSource = "Material",
	ShowTitle = true
})
local GameStatsTab = Window:CreateTab({
	Name = "Game Stats",
	Icon = "view_sidebar",
	ImageSource = "Material",
	ShowTitle = true
})
local ESPTab = Window:CreateTab({
	Name = "ESP",
	Icon = "visibility",
	ImageSource = "Material",
	ShowTitle = true
})
local StyleTab = Window:CreateTab({
	Name = "Styles",
	Icon = "brush",
	ImageSource = "Material",
	ShowTitle = true
})

local FlowTab = Window:CreateTab({
	Name = "Flow",
	Icon = "waves",
	ImageSource = "Material",
	ShowTitle = true
})
local MiscTab = Window:CreateTab({
	Name = "Misc",
	Icon = "settings",
	ImageSource = "Material",
	ShowTitle = true
})

-- went lazy and did not clean up the code but still works and this fly script is from zeltrix hub
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local flying = false
local flySpeed = 100
local maxFlySpeed = 1000
local speedIncrement = 0.4
local originalGravity = workspace.Gravity

LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    Character = newCharacter
    Humanoid = Character:WaitForChild("Humanoid")
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
end)

local function randomizeValue(value, range)
    return value + (value * (math.random(-range, range) / 100))
end

local function fly()
    while flying do
        local MoveDirection = Vector3.new()
        local cameraCFrame = workspace.CurrentCamera.CFrame

        MoveDirection = MoveDirection + (UserInputService:IsKeyDown(Enum.KeyCode.W) and cameraCFrame.LookVector or Vector3.new())
        MoveDirection = MoveDirection - (UserInputService:IsKeyDown(Enum.KeyCode.S) and cameraCFrame.LookVector or Vector3.new())
        MoveDirection = MoveDirection - (UserInputService:IsKeyDown(Enum.KeyCode.A) and cameraCFrame.RightVector or Vector3.new())
        MoveDirection = MoveDirection + (UserInputService:IsKeyDown(Enum.KeyCode.D) and cameraCFrame.RightVector or Vector3.new())
        MoveDirection = MoveDirection + (UserInputService:IsKeyDown(Enum.KeyCode.Space) and Vector3.new(0, 1, 0) or Vector3.new())
        MoveDirection = MoveDirection - (UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and Vector3.new(0, 1, 0) or Vector3.new())

        if MoveDirection.Magnitude > 0 then
            flySpeed = math.min(flySpeed + speedIncrement, maxFlySpeed)
            MoveDirection = MoveDirection.Unit * math.min(randomizeValue(flySpeed, 10), maxFlySpeed)
            HumanoidRootPart.Velocity = MoveDirection * 0.5
        else
            HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
        end

        RunService.RenderStepped:Wait()
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.F then
        flying = not flying
        if flying then
            workspace.Gravity = 0
            fly()
        else
            flySpeed = 100
            HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
            workspace.Gravity = originalGravity
        end
    end
end)
-- too lazy to do the rest of the script
local player = game.Players.LocalPlayer
local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
local ball = game.Workspace:FindFirstChild("Football")
local autoFarmEnabled = false
local autoFarmTweenEnabled = false

local function autoGoal()
    while autoGoalEnabled do
        local character = player.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        local football = character and character:FindFirstChild("Football")
        
        if football and rootPart then
            local goal = player.Team.Name == "Away" and workspace.Goals.Away or workspace.Goals.Home
            rootPart.CFrame = goal.CFrame
            
            local ShootRemote = game:GetService("ReplicatedStorage").Packages.Knit.Services.BallService.RE.Shoot
            ShootRemote:FireServer(60, nil, nil, Vector3.new(-0.6976264715194702, -0.3905344605445862, -0.6006664633750916))
        end
        task.wait()
    end
end

local function autoGoalKeeper()
	local ball
	while autoGoalKeeperEnabled do
		ball = workspace:FindFirstChild("Football")
		if ball and ball.AssemblyLinearVelocity.Magnitude > 5 then
			rootPart.CFrame = CFrame.new(
				ball.Position + (ball.AssemblyLinearVelocity * 0.1)
			)
		end
		task.wait()
	end
end

local function autoFarm()
    if not (autoFarmEnabled or autoFarmTweenEnabled) then return end

    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local RunService = game:GetService("RunService")
    local TweenService = game:GetService("TweenService")

    local LocalPlayer = Players.LocalPlayer
    local character = LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")

    local GameValues = ReplicatedStorage.GameValues
    local SlideRemote = ReplicatedStorage.Packages.Knit.Services.BallService.RE.Slide
    local ShootRemote = ReplicatedStorage.Packages.Knit.Services.BallService.RE.Shoot
    local GoalsFolder = workspace.Goals
    local AwayGoal, HomeGoal = GoalsFolder.Away, GoalsFolder.Home

    local function IsInGame()
        return GameValues.State.Value == "Playing"
    end

    local function IsScored()
        return GameValues.Scored.Value
    end

    local function IsVisitor()
        return LocalPlayer.Team.Name == "Visitor"
    end

    local function JoinGame()
        if not IsVisitor() then return end
        for _, v in ipairs(ReplicatedStorage.Teams:GetDescendants()) do
            if v:IsA("ObjectValue") and v.Value == nil then
                local args = {string.sub(v.Parent.Name, 1, #v.Parent.Name - 4), v.Name}
                ReplicatedStorage.Packages.Knit.Services.TeamService.RE.Select:FireServer(unpack(args))
            end
        end
    end

    local function StealBall()
        if not IsInGame() or IsScored() then return end
        
        local Football = workspace:FindFirstChild("Football")
        if rootPart and Football and not Football.Anchored and Football.Char.Value ~= character then
            if autoFarmEnabled then
                rootPart:PivotTo(CFrame.new(Football.Position.X, 9, Football.Position.Z))
            else
                local tween = TweenService:Create(rootPart, TweenInfo.new(0.3), {CFrame = CFrame.new(Football.Position.X, 9, Football.Position.Z)})
                tween:Play()
                tween.Completed:Wait()
            end
        end

        for _, OtherPlayer in ipairs(Players:GetPlayers()) do
            if OtherPlayer ~= LocalPlayer and OtherPlayer.Team ~= LocalPlayer.Team then
                local OtherCharacter = OtherPlayer.Character
                local OtherFootball = OtherCharacter and OtherCharacter:FindFirstChild("Football")
                local OtherHRP = OtherCharacter and OtherCharacter:FindFirstChild("HumanoidRootPart")
                
                if OtherFootball and OtherHRP and rootPart then
                    if autoFarmEnabled then
                        rootPart:PivotTo(OtherFootball.CFrame * CFrame.new(0, 3, 0))
                    else
                        local tween = TweenService:Create(rootPart, TweenInfo.new(0.3), {CFrame = OtherFootball.CFrame * CFrame.new(0, 3, 0)})
                        tween:Play()
                        tween.Completed:Wait()
                    end
                    SlideRemote:FireServer()
                    break
                end
            end
        end
    end

    JoinGame()
    if IsVisitor() and not IsInGame() then return end
    StealBall()
    
    local PlayerFootball = character and character:FindFirstChild("Football")

    if PlayerFootball then
        ShootRemote:FireServer(60, nil, nil, Vector3.new(-0.6976264715194702, -0.3905344605445862, -0.6006664633750916))
    end

    local Football = workspace:FindFirstChild("Football")
    if Football and Football.Char.Value ~= character then return end

    if Football:FindFirstChild("BodyVelocity") then
        Football.BodyVelocity:Destroy()
    end

    local Goal = LocalPlayer.Team.Name == "Away" and AwayGoal or HomeGoal
    
    if rootPart then
        rootPart:PivotTo(Goal.CFrame)
    end
    
    local BV = Instance.new("BodyVelocity")
    BV.Velocity = Vector3.new(0, 0, 0)
    BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    BV.Parent = Football
    Football.CFrame = Goal.CFrame
    task.delay(0.1, function()
        BV:Destroy()
    end)
end

local function autoSteal()
    if not IsInGame() or IsScored() then return end
        
    local Football = workspace:FindFirstChild("Football")
    if rootPart and Football and not Football.Anchored and Football.Char.Value ~= character then
        if autoFarmEnabled then
            rootPart:PivotTo(CFrame.new(Football.Position.X, 9, Football.Position.Z))
        else
            local tween = TweenService:Create(rootPart, TweenInfo.new(0.3), {CFrame = CFrame.new(Football.Position.X, 9, Football.Position.Z)})
            tween:Play()
            tween.Completed:Wait()
        end
    end

    for _, OtherPlayer in ipairs(Players:GetPlayers()) do
        if OtherPlayer ~= LocalPlayer and OtherPlayer.Team ~= LocalPlayer.Team then
            local OtherCharacter = OtherPlayer.Character
            local OtherFootball = OtherCharacter and OtherCharacter:FindFirstChild("Football")
            local OtherHRP = OtherCharacter and OtherCharacter:FindFirstChild("HumanoidRootPart")
            
            if OtherFootball and OtherHRP and rootPart then
                if autoFarmEnabled then
                    rootPart:PivotTo(OtherFootball.CFrame * CFrame.new(0, 3, 0))
                else
                    local tween = TweenService:Create(rootPart, TweenInfo.new(0.3), {CFrame = OtherFootball.CFrame * CFrame.new(0, 3, 0)})
                    tween:Play()
                    tween.Completed:Wait()
                end
                SlideRemote:FireServer()
                break
            end
        end
    end
end

local function CreateESPPart(parent, size, color)
    local esp = Instance.new("BoxHandleAdornment")
    esp.Name = "ESP"
    esp.Size = size
    esp.Color3 = color
    esp.AlwaysOnTop = true
    esp.ZIndex = 5
    esp.Transparency = 0
    esp.Adornee = parent
    esp.Parent = parent
    return esp
end

local function CreateTracer(parent)
    local tracer = Instance.new("Beam")
    local attachment0 = Instance.new("Attachment")
    local attachment1 = Instance.new("Attachment")
    tracer.AlwaysOnTop = true
    tracer.Name = "Tracer"
    tracer.FaceCamera = true
    tracer.Width0 = 0.2
    tracer.Width1 = 0.2
    tracer.Color = ColorSequence.new(Color3.fromRGB(255, 165, 0))
    
    attachment0.Parent = parent
    attachment1.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
    
    tracer.Attachment0 = attachment0
    tracer.Attachment1 = attachment1
    tracer.Parent = parent
    
    return tracer
end

local function UpdatePlayerESP()
    while PlayerESPEnabled do
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character then
                local char = player.Character
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local esp = hrp:FindFirstChild("ESP")
                    if not esp then
                        CreateESPPart(hrp, Vector3.new(2,5,2), Color3.fromRGB(255, 0, 0))
                    end
                end
            end
        end
        task.wait()
    end
end

local function UpdateTeamESP()
    while TeamESPEnabled do
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character and player.Team then
                local char = player.Character
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local esp = hrp:FindFirstChild("ESP")
                    if not esp then
                        local color = player.Team.Name == "Home" and Color3.fromRGB(0, 0, 255) or Color3.fromRGB(255, 0, 0)
                        CreateESPPart(hrp, Vector3.new(2,5,2), color)
                    end
                end
            end
        end
        task.wait()
    end
end

local function UpdateFootballESP()
    while FootballESPEnabled or TracerEnabled do
        local ball = workspace:FindFirstChild("Football")
        if ball then
            if FootballESPEnabled then
                local esp = ball:FindFirstChild("ESP")
                if not esp then
                    CreateESPPart(ball, Vector3.new(2,2,2), Color3.fromRGB(255, 165, 0))
                end
            else
                local esp = ball:FindFirstChild("ESP")
                if esp then esp:Destroy() end
            end
            
            if TracerEnabled then
                local tracer = ball:FindFirstChild("Tracer")
                if not tracer then
                    CreateTracer(ball)
                end
            else
                local tracer = ball:FindFirstChild("Tracer")
                if tracer then 
                    tracer:Destroy() 
                    ball:FindFirstChild("Attachment"):Destroy()
                end
            end
        end
        task.wait()
    end
end

local function ClearESP()
    local ball = workspace:FindFirstChild("Football")
    if ball then
        local esp = ball:FindFirstChild("ESP")
        local tracer = ball:FindFirstChild("Tracer")
        local attachment = ball:FindFirstChild("Attachment")
        
        if esp then esp:Destroy() end
        if tracer then tracer:Destroy() end
        if attachment then attachment:Destroy() end
    end
end

local function ClearPlayerESP()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local esp = hrp:FindFirstChild("ESP")
                if esp then esp:Destroy() end
            end
        end
    end
end

local function ClearTeamESP()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local esp = hrp:FindFirstChild("ESP")
                if esp then esp:Destroy() end
            end
        end
    end
end

AutoFarmTab:CreateToggle({
    Name = "Auto Farm (Teleport)",
    Description = nil,
    CurrentValue = false,
    Callback = function(Value)
        autoFarmEnabled = Value
        if Value then autoFarmTweenEnabled = false end
    end
})
AutoFarmTab:CreateToggle({
    Name = "Auto Steal",
    Description = "Enable auto steal",
    CurrentValue = false,
    Callback = function(Value)
        StealBall = Value
        if Value then
             task.spawn(autoSteal)
        else
            task.cancel(autoSteal)
        end
    end
})
AutoFarmTab:CreateToggle({
    Name = "Auto Goal",
    Description = "Automatically score goals when you have the ball", 
    CurrentValue = false,
    Callback = function(Value)
        autoGoalEnabled = Value
        if Value then
            task.spawn(autoGoal)
        else
            task.cancel(autoGoal)
        end
    end
})

AutoFarmTab:CreateToggle({
    Name = "Auto TP Ball",
    Description = "Automatically teleport to the ball",
    CurrentValue = false, 
    Callback = function(Value)
        autoTPBallEnabled = Value
        if Value then
            task.spawn(function()
                while autoTPBallEnabled do
                    if Football and rootPart then
                        rootPart.CFrame = Football.CFrame
                    end
                    task.wait()
                end
            end)
        end
    end
})

AutoFarmTab:CreateToggle({
    Name = "Auto Goal Keeper (Rarely Blocks Other Styles With Skills)",
    Description = "Automatically teleport to balls within 120 studs with prediction", 
    CurrentValue = false,
    Callback = function(Value)
        autoBallRadiusEnabled = Value
        
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")
        
        local visualRadius = Instance.new("Part")
        visualRadius.Shape = Enum.PartType.Ball
        visualRadius.Material = Enum.Material.ForceField
        visualRadius.Size = Vector3.new(120, 120, 120)
        visualRadius.Color = Color3.fromRGB(0, 170, 255)
        visualRadius.CastShadow = false
        visualRadius.Anchored = true
        visualRadius.CanCollide = false
        visualRadius.CanTouch = false
        visualRadius.CanQuery = false
        visualRadius.Transparency = 0.5
        visualRadius.Parent = workspace
        
        if Value then
            task.spawn(function()
                while autoBallRadiusEnabled do
                    if rootPart then
                        visualRadius.Position = rootPart.Position
                    end
                    task.wait()
                end
            end)
            
            task.spawn(function() 
                while autoBallRadiusEnabled do
                    local Football = workspace:FindFirstChild("Football")
                    if Football and rootPart and not Football.Anchored and Football.Char.Value ~= character then
                        local distance = (Football.Position - rootPart.Position).Magnitude
                        if distance <= 120 then
                            local ballVelocity = Football.Velocity.Unit
                            local predictedPos = Football.Position + (ballVelocity * 2)
                            
                            local lookAt = CFrame.new(predictedPos, Football.Position)
                            rootPart.CFrame = lookAt + (lookAt.LookVector * 2)
                        end
                    end
                    task.wait()
                end
            end)
        else
            visualRadius:Destroy()
        end
    end
})




AutoFarmTab:CreateSection("Special Abilities")

AutoFarmTab:CreateToggle({
	Name = "No CD",
	Description = nil,
	CurrentValue = false,
	Callback = function(Value)
		noCDEnabled = Value
		local AbilityController = require(game:GetService("ReplicatedStorage").Controllers.AbilityController)

		if Value then
			if not AbilityController._OriginalAbilityCooldown then
				AbilityController._OriginalAbilityCooldown = AbilityController.AbilityCooldown
			end

			AbilityController.AbilityCooldown = function(s, n, ...)
				return AbilityController._OriginalAbilityCooldown(s, n, 0, ...)
			end
		else
			if AbilityController._OriginalAbilityCooldown then
				AbilityController.AbilityCooldown = AbilityController._OriginalAbilityCooldown
				AbilityController._OriginalAbilityCooldown = nil
			end
		end
	end
})
AutoFarmTab:CreateToggle({
	Name = "Anti-AFK",
	Description = "Prevent being kicked for inactivity",
	CurrentValue = false,
	Callback = function(Value)
		antiAFKEnabled = Value
		if Value then
			task.spawn(antiAFK)
			Luna:Notification({
				Title = "Anti-AFK Enabled",
				Content = "You will not be kicked for inactivity",
				Icon = "check_circle",
				ImageSource = "Material"
			})
		end
	end
})

StatsTab:CreateSection("Stats")
StatsTab:CreateLabel({
    Text = "Event Currency: " .. game:GetService("Players").LocalPlayer.ProfileStats.EventCurrency.Value
})

StatsTab:CreateLabel({
    Text = "Experience: " .. game:GetService("Players").LocalPlayer.ProfileStats.Exp.Value
})

StatsTab:CreateLabel({
    Text = "Flow Spins: " .. game:GetService("Players").LocalPlayer.ProfileStats.FlowSpins.Value
})

StatsTab:CreateLabel({
    Text = "Lucky Spins: " .. game:GetService("Players").LocalPlayer.ProfileStats.GachaLuckySpins.Value
})

StatsTab:CreateLabel({
    Text = "Gacha Spins: " .. game:GetService("Players").LocalPlayer.ProfileStats.GachaSpins.Value
})

StatsTab:CreateLabel({
    Text = "Level: " .. game:GetService("Players").LocalPlayer.ProfileStats.Level.Value
})

StatsTab:CreateLabel({
    Text = "Money: " .. game:GetService("Players").LocalPlayer.ProfileStats.Money.Value
})

StatsTab:CreateLabel({
    Text = "Spins: " .. game:GetService("Players").LocalPlayer.ProfileStats.Spins.Value
})

StatsTab:CreateLabel({
    Text = "Spinwheel Spins: " .. game:GetService("Players").LocalPlayer.ProfileStats.SpinwheelSpins.Value
})
StatsTab:CreateSection("Primary Stats")
StatsTab:CreateLabel({
    Text = "Flow Bar: " .. game:GetService("Players").LocalPlayer.PlayerStats.FlowBar.Value
})

StatsTab:CreateLabel({
    Text = "Awakening Bar: " .. game:GetService("Players").LocalPlayer.PlayerStats.AwakeningBar.Value
})

StatsTab:CreateLabel({
    Text = "Flow: " .. game:GetService("Players").LocalPlayer.PlayerStats.Flow.Value
})

StatsTab:CreateLabel({
    Text = "Flow RNG: " .. game:GetService("Players").LocalPlayer.PlayerStats.FlowRNG.Value
})

StatsTab:CreateLabel({
    Text = "Has Shot: " .. tostring(game:GetService("Players").LocalPlayer.PlayerStats.HasShot.Value)
})

StatsTab:CreateLabel({
    Text = "In Awakening: " .. tostring(game:GetService("Players").LocalPlayer.PlayerStats.InAwakening.Value)
})

StatsTab:CreateLabel({
    Text = "In Flow: " .. tostring(game:GetService("Players").LocalPlayer.PlayerStats.InFlow.Value)
})

StatsTab:CreateLabel({
    Text = "Last Event Join: " .. game:GetService("Players").LocalPlayer.PlayerStats.LastEventJoin.Value
})

StatsTab:CreateLabel({
    Text = "Last Join: " .. game:GetService("Players").LocalPlayer.PlayerStats.LastJoin.Value
})

StatsTab:CreateLabel({
    Text = "Play Timer: " .. game:GetService("Players").LocalPlayer.PlayerStats.PlayTimer.Value
})

StatsTab:CreateLabel({
    Text = "Stamina: " .. game:GetService("Players").LocalPlayer.PlayerStats.Stamina.Value
})

StatsTab:CreateLabel({
    Text = "Style: " .. game:GetService("Players").LocalPlayer.PlayerStats.Style.Value
})
GameStatsTab:CreateSection("Game Stats")
GameStatsTab:CreateLabel({
    Text = "Assists: " .. game:GetService("Players").LocalPlayer.GameStats.Assists.Value
})

GameStatsTab:CreateLabel({
    Text = "Goals: " .. game:GetService("Players").LocalPlayer.GameStats.Goals.Value
})

GameStatsTab:CreateLabel({
    Text = "Ping: " .. game:GetService("Players").LocalPlayer.GameStats.Ping.Value
})

GameStatsTab:CreateLabel({
    Text = "Points: " .. game:GetService("Players").LocalPlayer.GameStats.Points.Value
})

GameStatsTab:CreateLabel({
    Text = "Saves: " .. game:GetService("Players").LocalPlayer.GameStats.Saves.Value
})

GameStatsTab:CreateLabel({
    Text = "Steals: " .. game:GetService("Players").LocalPlayer.GameStats.Steals.Value
})


ESPTab:CreateSection("ESP Options")

ESPTab:CreateToggle({
    Name = "Football ESP",
    Description = "Show football ESP overlay",
    CurrentValue = false,
    Callback = function(Value)
        FootballESPEnabled = Value
        if Value then
            task.spawn(UpdateFootballESP)
        else
            ClearESP()
        end
    end
})

ESPTab:CreateToggle({
    Name = "Tracer ESP",
    Description = "Show line to football",
    CurrentValue = false,
    Callback = function(Value)
        TracerEnabled = Value
        if Value then
            task.spawn(UpdateFootballESP)
        else
            ClearESP()
        end
    end
})

ESPTab:CreateToggle({
    Name = "Player ESP", 
    Description = "Show player ESP overlay",
    CurrentValue = false,
    Callback = function(Value)
        PlayerESPEnabled = Value
        if Value then
            task.spawn(UpdatePlayerESP)
        else
            ClearPlayerESP()
        end
    end
})

ESPTab:CreateToggle({
    Name = "Team ESP",
    Description = "Show team ESP overlay", 
    CurrentValue = false,
    Callback = function(Value)
        TeamESPEnabled = Value
        if Value then
            task.spawn(UpdateTeamESP)
        else
            ClearTeamESP()
        end
    end
})

StyleTab:CreateSection("Style Selection")
StyleTab:CreateButton({
    Name = "Nel Isagi",
    Description = "Select NelISAGGII Style :D",
    Callback = function()
    player.PlayerStats.Style.Value = "NEL Isagi"
    end

})
StyleTab:CreateButton({
    Name = "Sae",
    Description = "Sae Style Ez",
    Callback = function()
    player.PlayerStats.Style.Value = "Sae"
    end


})
StyleTab:CreateButton({
    Name = "KAISER",
    Description = "Select KAISER Style :)",
    Callback = function()
    player.PlayerStats.Style.Value = "Kaiser"
    end


})
StyleTab:CreateButton({
    Name = "Don Lorenzo",
    Description = "Select Don Lorenzo style",
    Callback = function()
        player.PlayerStats.Style.Value = "Don Lorenzo"
    end
})

StyleTab:CreateButton({
    Name = "Kunigami", 
    Description = "Select Kunigami style",
    Callback = function()
        player.PlayerStats.Style.Value = "Kunigami"
    end
})

StyleTab:CreateButton({
    Name = "Aiku",
    Description = "Select Aiku style", 
    Callback = function()
        player.PlayerStats.Style.Value = "Aiku"
    end
})

StyleTab:CreateButton({
    Name = "Karasu",
    Description = "Select Karasu style",
    Callback = function()
        player.PlayerStats.Style.Value = "Karasu"
    end
})

StyleTab:CreateButton({
    Name = "Otoya",
    Description = "Select Otoya style",
    Callback = function()
        player.PlayerStats.Style.Value = "Otoya"
    end
})

StyleTab:CreateButton({
    Name = "Bachira",
    Description = "Select Bachira style",
    Callback = function()
        player.PlayerStats.Style.Value = "Bachira"
    end
})

StyleTab:CreateButton({
    Name = "Chigiri",
    Description = "Select Chigiri style",
    Callback = function()
        player.PlayerStats.Style.Value = "Chigiri"
    end
})

StyleTab:CreateButton({
    Name = "Isagi",
    Description = "Select Isagi style",
    Callback = function()
        player.PlayerStats.Style.Value = "Isagi"
    end
})

StyleTab:CreateButton({
    Name = "Gagamaru",
    Description = "Select Gagamaru style",
    Callback = function()
        player.PlayerStats.Style.Value = "Gagamaru"
    end
})

StyleTab:CreateButton({
    Name = "King",
    Description = "Select King style",
    Callback = function()
        player.PlayerStats.Style.Value = "King"
    end
})

StyleTab:CreateButton({
    Name = "Nagi",
    Description = "Select Nagi style",
    Callback = function()
        player.PlayerStats.Style.Value = "Nagi"
    end
})

StyleTab:CreateButton({
    Name = "Rin",
    Description = "Select Rin style",
    Callback = function()
        player.PlayerStats.Style.Value = "Rin"
    end
})

StyleTab:CreateButton({
    Name = "Sae",
    Description = "Select Sae style",
    Callback = function()
        player.PlayerStats.Style.Value = "Sae"
    end
})

StyleTab:CreateButton({
    Name = "Shidou",
    Description = "Select Shidou style",
    Callback = function()
        player.PlayerStats.Style.Value = "Shidou"
    end
})

StyleTab:CreateButton({
    Name = "Reo",
    Description = "Select Reo style",
    Callback = function()
        player.PlayerStats.Style.Value = "Reo"
    end
})

StyleTab:CreateButton({
    Name = "Yukimiya",
    Description = "Select Yukimiya style",
    Callback = function()
        player.PlayerStats.Style.Value = "Yukimiya"
    end
})

StyleTab:CreateButton({
    Name = "Hiori",
    Description = "Select Hiori style",
    Callback = function()
        player.PlayerStats.Style.Value = "Hiori"
    end
})

FlowTab:CreateSection("Flow Selection")

FlowTab:CreateButton({
    Name = "Dribbler",
    Description = "Select Dribbler flow",
    Callback = function()
        if player and player:FindFirstChild("PlayerStats") and player.PlayerStats:FindFirstChild("Flow") then
            player.PlayerStats.Flow.Value = "Dribbler"
        end
    end
})

FlowTab:CreateButton({
    Name = "Prodigy",
    Description = "Select Prodigy flow",
    Callback = function()
        if player and player:FindFirstChild("PlayerStats") and player.PlayerStats:FindFirstChild("Flow") then
            player.PlayerStats.Flow.Value = "Prodigy"
        end
    end
})

FlowTab:CreateButton({
    Name = "Awakened Genius",
    Description = "Select Awakened Genius flow",
    Callback = function()
        if player and player:FindFirstChild("PlayerStats") and player.PlayerStats:FindFirstChild("Flow") then
            player.PlayerStats.Flow.Value = "Awakened Genius"
        end
    end
})

FlowTab:CreateButton({
    Name = "Snake",
    Description = "Select Snake flow",
    Callback = function()
        if player and player:FindFirstChild("PlayerStats") and player.PlayerStats:FindFirstChild("Flow") then
            player.PlayerStats.Flow.Value = "Snake"
        end
    end
})

FlowTab:CreateButton({
    Name = "Wildcard",
    Description = "Select Wildcard flow",
    Callback = function()
        if player and player:FindFirstChild("PlayerStats") and player.PlayerStats:FindFirstChild("Flow") then
            player.PlayerStats.Flow.Value = "Wildcard"
        end
    end
})

FlowTab:CreateButton({
    Name = "Demon Wings",
    Description = "Select Demon Wings flow",
    Callback = function()
        if player and player:FindFirstChild("PlayerStats") and player.PlayerStats:FindFirstChild("Flow") then
            player.PlayerStats.Flow.Value = "Demon Wings"
        end
    end
})

FlowTab:CreateButton({
    Name = "Trap",
    Description = "Select Trap flow",
    Callback = function()
        if player and player:FindFirstChild("PlayerStats") and player.PlayerStats:FindFirstChild("Flow") then
            player.PlayerStats.Flow.Value = "Trap"
        end
    end
})

FlowTab:CreateButton({
    Name = "Genius",
    Description = "Select Genius flow",
    Callback = function()
        if player and player:FindFirstChild("PlayerStats") and player.PlayerStats:FindFirstChild("Flow") then
            player.PlayerStats.Flow.Value = "Genius"
        end
    end
})

FlowTab:CreateButton({
    Name = "Chameleon",
    Description = "Select Chameleon flow",
    Callback = function()
        if player and player:FindFirstChild("PlayerStats") and player.PlayerStats:FindFirstChild("Flow") then
            player.PlayerStats.Flow.Value = "Chameleon"
        end
    end
})

FlowTab:CreateButton({
    Name = "King's Instinct",
    Description = "Select King's Instinct flow",
    Callback = function()
        if player and player:FindFirstChild("PlayerStats") and player.PlayerStats:FindFirstChild("Flow") then
            player.PlayerStats.Flow.Value = "King's Instinct"
        end
    end
})

FlowTab:CreateButton({
    Name = "Gale Burst",
    Description = "Select Gale Burst flow",
    Callback = function()
        if player and player:FindFirstChild("PlayerStats") and player.PlayerStats:FindFirstChild("Flow") then
            player.PlayerStats.Flow.Value = "Gale Burst"
        end
    end
})

FlowTab:CreateButton({
    Name = "Monster",
    Description = "Select Monster flow",
    Callback = function()
        if player and player:FindFirstChild("PlayerStats") and player.PlayerStats:FindFirstChild("Flow") then
            player.PlayerStats.Flow.Value = "Monster"
        end
    end
})

FlowTab:CreateButton({
    Name = "Puzzle",
    Description = "Select Puzzle flow",
    Callback = function()
        if player and player:FindFirstChild("PlayerStats") and player.PlayerStats:FindFirstChild("Flow") then
            player.PlayerStats.Flow.Value = "Puzzle"
        end
    end
})

FlowTab:CreateButton({
    Name = "Lightning",
    Description = "Select Lightning flow",
    Callback = function()
        if player and player:FindFirstChild("PlayerStats") and player.PlayerStats:FindFirstChild("Flow") then
            player.PlayerStats.Flow.Value = "Lightning"
        end
    end
})
MiscTab:CreateSection("Misc")
MiscTab:CreateButton({
    Name = "Teleport to Ball",
    Description = "Teleport to ball",
    Callback = function()
        local Football = workspace:FindFirstChild("Football")
        if Football then
            local character = game:GetService("Players").LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                character.HumanoidRootPart.CFrame = Football.CFrame
            end
        end
    end
})
MiscTab:CreateSection("Character Modifications")
local speedEnabled = false
MiscTab:CreateToggle({
    Name = "Speed Toggle", 
    Description = "Toggle CFrame speed (Recommended: 1.2)",
    CurrentValue = false,
    Callback = function(value)
        speedEnabled = value
        if value then
            while speedEnabled do
                local character = game.Players.LocalPlayer.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    local hrp = character.HumanoidRootPart
                    local moveDirection = character.Humanoid.MoveDirection
                    if moveDirection.Magnitude > 0 then
                        hrp.CFrame = hrp.CFrame + (moveDirection * (tonumber(speedValue) or 1.2))
                    end
                end
                task.wait()
            end
        end
    end
})

MiscTab:CreateSlider({
    Name = "Speed Value", 
    Range = {1, 10},
    Increment = 0.1,
    Suffix = "Speed",
    CurrentValue = 1,
    Callback = function(value)
        speedValue = tostring(value)
    end
})

local jumpEnabled = false
MiscTab:CreateToggle({
    Name = "Jump Power Toggle", 
    Description = "Toggle custom jump power value",
    CurrentValue = false,
    Callback = function(value)
        jumpEnabled = value
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            if value then
                while jumpEnabled do
                    if character and character:FindFirstChild("Humanoid") then
                        character.Humanoid.JumpPower = tonumber(jumpValue) or 50
                    end
                    task.wait()
                end
            else
                if character and character:FindFirstChild("Humanoid") then
                    character.Humanoid.JumpPower = 50
                end
            end
        end
    end
})

MiscTab:CreateSlider({
    Name = "Jump Power Value",
    Range = {50, 500},
    Increment = 1,
    Suffix = "Power",
    CurrentValue = 50,
    Callback = function(value)
        jumpValue = tostring(value)
        local character = game.Players.LocalPlayer.Character
        if jumpEnabled and character and character:FindFirstChild("Humanoid") then
            character.Humanoid.JumpPower = value
        end
    end
})

local fovEnabled = false
MiscTab:CreateToggle({
    Name = "FOV Toggle",
    Description = "Toggle custom camera FOV value",
    CurrentValue = false,
    Callback = function(value)
        fovEnabled = value
        if value then
            while fovEnabled do
                game.Workspace.CurrentCamera.FieldOfView = tonumber(fovValue) or 70
                task.wait()
            end
        else
            game.Workspace.CurrentCamera.FieldOfView = 70
        end
    end
})

MiscTab:CreateSlider({
    Name = "FOV Value",
    Range = {70, 120},
    Increment = 1,
    Suffix = "FOV",
    CurrentValue = 70,
    Callback = function(value)
        fovValue = tostring(value)
        if fovEnabled then
            game.Workspace.CurrentCamera.FieldOfView = value
        end
    end
})


local infiniteJumpEnabled = false
MiscTab:CreateToggle({
    Name = "Infinite Jump",
    Description = "Toggle infinite jump ability",
    CurrentValue = false,
    Callback = function(value)
        infiniteJumpEnabled = value
    end
})

game:GetService("UserInputService").JumpRequest:Connect(function()
    if infiniteJumpEnabled and game.Players.LocalPlayer.Character then
        game.Players.LocalPlayer.Character:FindFirstChild("Humanoid"):ChangeState("Jumping")
    end
end)

local flyEnabled = false
MiscTab:CreateToggle({
    Name = "Fly",
    Description = "Toggle flying ability (Press F to toggle)",
    CurrentValue = false,
    Callback = function(value)
        flyEnabled = value
        flying = value
        if value then
            workspace.Gravity = 0
            fly()
        else
            flySpeed = 100
            if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
            end
            workspace.Gravity = originalGravity
        end
    end
})

MiscTab:CreateSlider({
    Name = "Fly Speed",
    Range = {50, 1000},
    Increment = 10,
    Suffix = "Speed",
    CurrentValue = 100,
    Callback = function(value)
        flySpeed = value
    end
})




game:GetService("RunService").Heartbeat:Connect(function()
    if autoFarmEnabled or autoFarmTweenEnabled then
        autoFarm()
    end
end)
