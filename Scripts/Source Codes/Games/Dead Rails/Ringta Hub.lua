local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/hungquan99/FluentUI/master/Addons/SaveManager.lua"))()

local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/hungquan99/FluentUI/master/Addons/InterfaceManager.lua"))()

local minimizeUI = Enum.KeyCode.RightAlt

-- 🟢 Create Main UI
local Window = Fluent:CreateWindow({
    Title = "Ringta Scripts",
    SubTitle = "With BIGBACK",
    TabWidth = 160,
    Size = UDim2.fromOffset(480, 360),
    Acrylic = false,
    Theme = "Darker",
    MinimizeKey = minimizeUI
})

-- Tabs
local Tabs = {
    FarT = Window:AddTab({ Title = "Farm", Icon = "rbxassetid://121302760641013" }),
    Ma = Window:AddTab({ Title = "Main", Icon = "rbxassetid://121302760641013" }),
    Ite = Window:AddTab({ Title = "Items", Icon = "rbxassetid://121302760641013" }),
    TpT = Window:AddTab({ Title = "Teleport", Icon = "rbxassetid://121302760641013" }),
    Player = Window:AddTab({ Title = "Player", Icon = "rbxassetid://121302760641013" }),
    Misc = Window:AddTab({ Title = "Misc", Icon = "rbxassetid://121302760641013" }),
    Settings = Window:AddTab({ Title = "Setting", Icon = "rbxassetid://121302760641013" }),
}

do
    local baseUrl = "https://raw.githubusercontent.com/Shade-vex/Hutao-hub-code-pro-mode/refs/heads/main/"
    local Config = loadstring(game:HttpGet(baseUrl .. "Config.lua.txt"))()
    local Utilities = loadstring(game:HttpGet(baseUrl .. "Util.lua.txt"))()
    local ESP = loadstring(game:HttpGet(baseUrl .. "ESP.lua.txt"))()(Config, Utilities)
    local MiddleClick = loadstring(game:HttpGet(baseUrl .. "MiddleClick.lua.txt"))()
    local Aimbot = loadstring(game:HttpGet(baseUrl .. "Aimbot.lua.txt"))()
    
    ESP.Initialize()
    MiddleClick.Initialize()
    Aimbot.Initialize()

    Tabs.FarT:AddParagraph({
        Title = "Note",
        Content = "• These are toggle so you can use with configs, disabling it does not stop it.\n• Set up configs in Settings tab."
    })

    Tabs.FarT:AddSection("↳ Bonds")

    local AfBToggle = Tabs.FarT:AddToggle("AfBToggle", {Title = "Auto Farm Bonds", Description = 'Normal version of farm bonds.',Default = false })
    AfBToggle:OnChanged(function(Value)
        if Value then
            getgenv().DeadRails = {
                ["Farm"] = {
                    ["Enabled"] = true, -- Farm bond
                    ["Mode"] = "Normal", -- Normal/Nightmare
                },
            }
            AutoBondsURL = baseUrl .. "AutoBondsINF"
            loadstring(game:HttpGet(AutoBondsURL))()
        end
    end)

    local AfBToggle1 = Tabs.FarT:AddToggle("AfBToggle1", {Title = "Ultimate Auto Farm Bonds", Description = '70+ bonds per run, recommend to use.',Default = false })
    AfBToggle1:OnChanged(function(Value)
        if Value then
            AutoBondsURl = baseUrl .. "AutoBonds2.lua.txt"
            loadstring(game:HttpGet(AutoBondsURl))()
        end
    end)

    Tabs.FarT:AddSection("↳ Win")

    local AfBToggle12 = Tabs.FarT:AddToggle("AfBToggle12", {Title = "Auto Farm Bonds & Win", Description = 'Click here to start AI farm bonds & win.\nRecommend to use cowboy class.',Default = false })
    AfBToggle12:OnChanged(function(Value)
        if Value then
            AutoBondsUrL = baseUrl .. "AutoBonds3.lua.txt"
            loadstring(game:HttpGet('AutoBondsUrL'))() 
        end
    end)

    Tabs.Ma:AddSection("↳ Class")

    Tabs.Ma:AddButton({
        Title = "Get Horse Class",
        Callback = function()
            if getgenv().HorseCl then return end
            getgenv().HorseCl = true
            local args = {
                [1] = "Horse"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("RemotePromise"):WaitForChild("Remotes"):WaitForChild("C_BuyClass"):FireServer(unpack(args))
            task.wait(1)
            local args = {
                [1] = "Horse"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("RemotePromise"):WaitForChild("Remotes"):WaitForChild("C_EquipClass"):FireServer(unpack(args))            
            Fluent:Notify({
                Title = "Ringta Scripts",
                Content = "Get and equip horse class successfully!",
                Duration = 5
            })
        end
    })

    Tabs.Ma:AddSection("↳ Aimbot")

    Tabs.Ma:AddButton({
        Title = "Aimbot V1",
        Description = "• Mobile Support",
        Callback = function()
            -- Aimbot Script
            local RunService = game:GetService("RunService")
            local Cam = workspace.CurrentCamera
            local Player = game:GetService("Players").LocalPlayer

            local validNPCs = {}
            local raycastParams = RaycastParams.new()
            raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

            local function isNPC(obj)
                return obj:IsA("Model") 
                    and obj:FindFirstChild("Humanoid")
                    and obj.Humanoid.Health > 0
                    and obj:FindFirstChild("Head")
                    and obj:FindFirstChild("HumanoidRootPart")
                    and not game:GetService("Players"):GetPlayerFromCharacter(obj)
            end

            local function updateNPCs()
                local tempTable = {}
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if isNPC(obj) then
                        tempTable[obj] = true
                    end
                end
                for i = #validNPCs, 1, -1 do
                    if not tempTable[validNPCs[i]] then
                        table.remove(validNPCs, i)
                    end
                end
                for obj in pairs(tempTable) do
                    if not table.find(validNPCs, obj) then
                        table.insert(validNPCs, obj)
                    end
                end
            end

            local function handleDescendant(descendant)
                if isNPC(descendant) then
                    table.insert(validNPCs, descendant)
                    local humanoid = descendant:WaitForChild("Humanoid")
                    humanoid.Destroying:Connect(function()
                        for i = #validNPCs, 1, -1 do
                            if validNPCs[i] == descendant then
                                table.remove(validNPCs, i)
                                break
                            end
                        end
                    end)
                end
            end

            workspace.DescendantAdded:Connect(handleDescendant)

            local function predictPos(target)
                local rootPart = target:FindFirstChild("HumanoidRootPart")
                local head = target:FindFirstChild("Head")
                if not rootPart or not head then
                    return head and head.Position or rootPart and rootPart.Position
                end
                local velocity = rootPart.Velocity
                local predictionTime = 0.02
                local basePosition = rootPart.Position + velocity * predictionTime
                local headOffset = head.Position - rootPart.Position
                return basePosition + headOffset
            end

            local function getTarget()
                local nearest = nil
                local minDistance = math.huge
                local viewportCenter = Cam.ViewportSize / 2
                raycastParams.FilterDescendantsInstances = {Player.Character}
                for _, npc in ipairs(validNPCs) do
                    local predictedPos = predictPos(npc)
                    local screenPos, visible = Cam:WorldToViewportPoint(predictedPos)
                    if visible and screenPos.Z > 0 then
                        local ray = workspace:Raycast(
                            Cam.CFrame.Position,
                            (predictedPos - Cam.CFrame.Position).Unit * 1000,
                            raycastParams
                        )
                        if ray and ray.Instance:IsDescendantOf(npc) then
                            local distance = (Vector2.new(screenPos.X, screenPos.Y) - viewportCenter).Magnitude
                            if distance < minDistance then
                                minDistance = distance
                                nearest = npc
                            end
                        end
                    end
                end
                return nearest
            end

            local function aim(targetPosition)
                local currentCF = Cam.CFrame
                local targetDirection = (targetPosition - currentCF.Position).Unit
                local smoothFactor = 0.581
                local newLookVector = currentCF.LookVector:Lerp(targetDirection, smoothFactor)
                Cam.CFrame = CFrame.new(currentCF.Position, currentCF.Position + newLookVector)
            end

            local heartbeat = RunService.Heartbeat
            local lastUpdate = 0
            local UPDATE_INTERVAL = 0.4

            local aimbotEnabled = false

            heartbeat:Connect(function(dt)
                lastUpdate = lastUpdate + dt
                if lastUpdate >= UPDATE_INTERVAL then
                    updateNPCs()
                    lastUpdate = 0
                end
                if aimbotEnabled then
                    local target = getTarget()
                    if target then
                        local predictedPosition = predictPos(target)
                        aim(predictedPosition)
                    end
                end
            end)

            -- npc remove
            workspace.DescendantRemoving:Connect(function(descendant)
                if isNPC(descendant) then
                    for i = #validNPCs, 1, -1 do
                        if validNPCs[i] == descendant then
                            table.remove(validNPCs, i)
                            break
                        end
                    end
                end
            end)

            -- Windows 11 Style Dark Transparent Toggle UI with Smooth Appear/Destroy Animation
            local UIS = game:GetService("UserInputService")
            local TweenService = game:GetService("TweenService")

            -- Destroy old UI if it exists
            if game.CoreGui:FindFirstChild("CustomToggleUI") then
                local oldUI = game.CoreGui:FindFirstChild("CustomToggleUI")
                if oldUI:FindFirstChild("MainFrame") then
                    TweenService:Create(oldUI.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1, Size = UDim2.new(0, 0, 0, 0)}):Play()
                    wait(0.3)
                end
                oldUI:Destroy()
            end

            local ScreenGui = Instance.new("ScreenGui")
            ScreenGui.Name = "CustomToggleUI"
            ScreenGui.Parent = game.CoreGui

            local MainFrame = Instance.new("Frame")
            MainFrame.Name = "MainFrame"
            MainFrame.Parent = ScreenGui -- Ensure it's added before using it!
            MainFrame.Size = UDim2.new(0, 250, 0, 130)
            MainFrame.Position = UDim2.new(0.120833337 - 0.1, 0, 0.0952890813 + 0.01, 0)
            MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            MainFrame.BackgroundTransparency = 1
            MainFrame.BorderSizePixel = 0
            MainFrame.ClipsDescendants = true
            MainFrame.Active = true
            MainFrame.Draggable = true

            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(0, 12)
            UICorner.Parent = MainFrame

            local Icon = Instance.new("ImageLabel")
            Icon.Size = UDim2.new(0, 24, 0, 24)
            Icon.Position = UDim2.new(0, 5, 0, 3)
            Icon.BackgroundTransparency = 1
            Icon.Image = "rbxassetid://121302760641013" -- Replace with actual image asset ID
            Icon.Parent = MainFrame

            local Title = Instance.new("TextLabel")
            Title.Size = UDim2.new(1, 0, 0, 30)
            Title.BackgroundTransparency = 1
            Title.Text = "Aimbot V1"
            Title.TextSize = 18
            Title.Font = Enum.Font.GothamBold
            Title.TextColor3 = Color3.fromRGB(220, 220, 220)
            Title.Parent = MainFrame

            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Size = UDim2.new(0, 90, 0, 40)
            ToggleButton.Position = UDim2.new(0.5, -45, 0.5, -20)
            ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            ToggleButton.Text = "Off"
            ToggleButton.Font = Enum.Font.GothamBold
            ToggleButton.TextSize = 16
            ToggleButton.TextColor3 = Color3.fromRGB(200, 200, 200)
            ToggleButton.Parent = MainFrame

            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 20)
            ButtonCorner.Parent = ToggleButton

            local Indicator = Instance.new("Frame")
            Indicator.Size = UDim2.new(0, 34, 0, 34)
            Indicator.Position = UDim2.new(0, 4, 0.5, -17)
            Indicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            Indicator.Parent = ToggleButton
            Indicator.BorderSizePixel = 0

            local IndicatorCorner = Instance.new("UICorner")
            IndicatorCorner.CornerRadius = UDim.new(1, 0)
            IndicatorCorner.Parent = Indicator

            local DestroyButton = Instance.new("TextButton")
            DestroyButton.Size = UDim2.new(0, 90, 0, 30)
            DestroyButton.Position = UDim2.new(0.5, -45, 1, -35)
            DestroyButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            DestroyButton.Text = "Destroy UI"
            DestroyButton.Font = Enum.Font.GothamBold
            DestroyButton.TextSize = 14
            DestroyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            DestroyButton.Parent = MainFrame

            local DestroyCorner = Instance.new("UICorner")
            DestroyCorner.CornerRadius = UDim.new(0, 10)
            DestroyCorner.Parent = DestroyButton

            local toggleState = false

            local function toggle()
                toggleState = not toggleState
                aimbotEnabled = toggleState
                ToggleButton.Text = toggleState and "On" or "Off"
                local targetColor = toggleState and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(255, 50, 50)
                local targetPos = toggleState and UDim2.new(1, -38, 0.5, -17) or UDim2.new(0, 4, 0.5, -17)
                
                TweenService:Create(Indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = targetColor, Position = targetPos}):Play()
                TweenService:Create(ToggleButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = toggleState and Color3.fromRGB(80, 200, 80) or Color3.fromRGB(50, 50, 50)}):Play()
            end

            ToggleButton.MouseButton1Click:Connect(toggle)

            DestroyButton.MouseButton1Click:Connect(function()
                if MainFrame then
                    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1, Size = UDim2.new(0, 0, 0, 0)}):Play()
                    aimbotEnabled = false
                    toggleState = false
                    wait(0.3)
                    ScreenGui:Destroy()
                end
            end)

            -- Smooth appear animation
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.2}):Play()
        end
    })

    local function detectMobile()
        local UserInputService = game:GetService("UserInputService")
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled then
            return true -- Mobile detected
        end
    end

    if detectMobile() then
        local fov = 100
        Tabs.Ma:AddButton({
            Title = "Aimbot V2",
            Description = "• Mobile support",
            Callback = function()
                
                local RunService = game:GetService("RunService")
                local UserInputService = game:GetService("UserInputService")
                local Cam = workspace.CurrentCamera
                local Player = game:GetService("Players").LocalPlayer

                local FOVring = Drawing.new("Circle")
                FOVring.Visible = false
                FOVring.Thickness = 2
                FOVring.Color = Color3.fromRGB(0, 0, 0)
                FOVring.Filled = false
                FOVring.Radius = fov
                FOVring.Position = Vector2.new(Cam.ViewportSize.X / 2, Cam.ViewportSize.Y / 2)

                local isAiming = false
                local validNPCs = {}
                local raycastParams = RaycastParams.new()
                raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

                local function isNPC1(obj)
                    return obj:IsA("Model") 
                        and obj:FindFirstChild("Humanoid")
                        and obj.Humanoid.Health > 0
                        and obj:FindFirstChild("Head")
                        and obj:FindFirstChild("HumanoidRootPart")
                        and not game:GetService("Players"):GetPlayerFromCharacter(obj)
                end

                local function updateNPCs()
                    local tempTable = {}
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        if isNPC1(obj) then
                            tempTable[obj] = true
                        end
                    end
                    for i = #validNPCs, 1, -1 do
                        if not tempTable[validNPCs[i]] then
                            table.remove(validNPCs, i)
                        end
                    end
                    for obj in pairs(tempTable) do
                        if not table.find(validNPCs, obj) then
                            table.insert(validNPCs, obj)
                        end
                    end
                end

                local function handleDescendant(descendant)
                    if isNPC1(descendant) then
                        table.insert(validNPCs, descendant)
                        local humanoid = descendant:WaitForChild("Humanoid")
                        humanoid.Destroying:Connect(function()
                            for i = #validNPCs, 1, -1 do
                                if validNPCs[i] == descendant then
                                    table.remove(validNPCs, i)
                                    break
                                end
                            end
                        end)
                    end
                end

                workspace.DescendantAdded:Connect(handleDescendant)

                local GuiService = game:GetService("GuiService")

                local function updateDrawings()
                    local screenSize = GuiService:GetScreenResolution() -- Get actual screen size
                    FOVring.Position = Vector2.new(screenSize.X / 2, screenSize.Y / 2)
                    FOVring.Radius = fov * (screenSize.Y / 1080) -- Adjust scale dynamically
                end

                RunService.RenderStepped:Connect(updateDrawings)

                local function predictPos(target)
                    local rootPart = target:FindFirstChild("HumanoidRootPart")
                    local head = target:FindFirstChild("Head")
                    if not rootPart or not head then
                        return head and head.Position or rootPart and rootPart.Position
                    end
                    local velocity = rootPart.Velocity
                    local predictionTime = 0.02
                    local basePosition = rootPart.Position + velocity * predictionTime
                    local headOffset = head.Position - rootPart.Position
                    return basePosition + headOffset
                end

                local function getTarget()
                local nearest = nil
                    local minDistance = math.huge
                    local viewportCenter = Cam.ViewportSize / 2
                    raycastParams.FilterDescendantsInstances = {Player.Character}
                    for _, npc in ipairs(validNPCs) do
                        local predictedPos = predictPos(npc)
                        local screenPos, visible = Cam:WorldToViewportPoint(predictedPos)
                        if visible and screenPos.Z > 0 then
                            local ray = workspace:Raycast(
                                Cam.CFrame.Position,
                                (predictedPos - Cam.CFrame.Position).Unit * 1000,
                                raycastParams
                            )
                            if ray and ray.Instance:IsDescendantOf(npc) then
                                local distance = (Vector2.new(screenPos.X, screenPos.Y) - viewportCenter).Magnitude
                                if distance < minDistance and distance < fov then
                                    minDistance = distance
                                    nearest = npc
                                end
                            end
                        end
                    end
                    return nearest
                end

                local function aim(targetPosition)
                    local currentCF = Cam.CFrame
                    local targetDirection = (targetPosition - currentCF.Position).Unit
                    local smoothFactor = 0.581
                    local newLookVector = currentCF.LookVector:Lerp(targetDirection, smoothFactor)
                    Cam.CFrame = CFrame.new(currentCF.Position, currentCF.Position + newLookVector)
                end

                local heartbeat = RunService.Heartbeat
                local lastUpdate = 0
                local UPDATE_INTERVAL = 0.4

                heartbeat:Connect(function(dt)
                    task.wait(0.2)
                    updateDrawings()
                    lastUpdate = lastUpdate + dt
                    if lastUpdate >= UPDATE_INTERVAL then
                        updateNPCs()
                        lastUpdate = 0
                    end
                    if isAiming then
                        local target = getTarget()
                        if target then
                            local predictedPosition = predictPos(target)
                            aim(predictedPosition)
                        end
                    end
                end)

                -- Windows 11 Style Dark Transparent Toggle UI with Smooth Appear/Destroy Animation
                local UIS = game:GetService("UserInputService")
                local TweenService = game:GetService("TweenService")

                -- Destroy old UI if it exists
                if game.CoreGui:FindFirstChild("CustomToggleUI1") then
                    local oldUI = game.CoreGui:FindFirstChild("CustomToggleUI1")
                    if oldUI:FindFirstChild("MainFrame") then
                        TweenService:Create(oldUI.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1, Size = UDim2.new(0, 0, 0, 0)}):Play()
                        wait(0.3)
                    end
                    oldUI:Destroy()
                end

                local ScreenGui = Instance.new("ScreenGui")
                ScreenGui.Name = "CustomToggleUI1"
                ScreenGui.Parent = game.CoreGui

                local MainFrame = Instance.new("Frame")
                MainFrame.Name = "MainFrame"
                MainFrame.Parent = ScreenGui -- Ensure it's added before using it!
                MainFrame.Size = UDim2.new(0, 250, 0, 130)
                MainFrame.Position = UDim2.new(1, -260, 0, 20)
                MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                MainFrame.BackgroundTransparency = 1
                MainFrame.BorderSizePixel = 0
                MainFrame.ClipsDescendants = true
                MainFrame.Active = true
                MainFrame.Draggable = true

                local UICorner = Instance.new("UICorner")
                UICorner.CornerRadius = UDim.new(0, 12)
                UICorner.Parent = MainFrame

                local Icon = Instance.new("ImageLabel")
                Icon.Size = UDim2.new(0, 24, 0, 24)
                Icon.Position = UDim2.new(0, 5, 0, 3)
                Icon.BackgroundTransparency = 1
                Icon.Image = "rbxassetid://121302760641013" -- Replace with actual image asset ID
                Icon.Parent = MainFrame

                local Title = Instance.new("TextLabel")
                Title.Size = UDim2.new(1, 0, 0, 30)
                Title.BackgroundTransparency = 1
                Title.Text = "Aimbot V2"
                Title.TextSize = 18
                Title.Font = Enum.Font.GothamBold
                Title.TextColor3 = Color3.fromRGB(220, 220, 220)
                Title.Parent = MainFrame

                local ToggleButton = Instance.new("TextButton")
                ToggleButton.Size = UDim2.new(0, 90, 0, 40)
                ToggleButton.Position = UDim2.new(0.5, -45, 0.5, -20)
                ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                ToggleButton.Text = "Off"
                ToggleButton.Font = Enum.Font.GothamBold
                ToggleButton.TextSize = 16
                ToggleButton.TextColor3 = Color3.fromRGB(200, 200, 200)
                ToggleButton.Parent = MainFrame

                local ButtonCorner = Instance.new("UICorner")
                ButtonCorner.CornerRadius = UDim.new(0, 20)
                ButtonCorner.Parent = ToggleButton

                local Indicator = Instance.new("Frame")
                Indicator.Size = UDim2.new(0, 34, 0, 34)
                Indicator.Position = UDim2.new(0, 4, 0.5, -17)
                Indicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
                Indicator.Parent = ToggleButton
                Indicator.BorderSizePixel = 0

                local IndicatorCorner = Instance.new("UICorner")
                IndicatorCorner.CornerRadius = UDim.new(1, 0)
                IndicatorCorner.Parent = Indicator

                local DestroyButton = Instance.new("TextButton")
                DestroyButton.Size = UDim2.new(0, 90, 0, 30)
                DestroyButton.Position = UDim2.new(0.5, -45, 1, -35)
                DestroyButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
                DestroyButton.Text = "Destroy UI"
                DestroyButton.Font = Enum.Font.GothamBold
                DestroyButton.TextSize = 14
                DestroyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                DestroyButton.Parent = MainFrame

                local DestroyCorner = Instance.new("UICorner")
                DestroyCorner.CornerRadius = UDim.new(0, 10)
                DestroyCorner.Parent = DestroyButton

                local toggleState = false

                local function toggle()
                    toggleState = not toggleState
                    isAiming = not isAiming
                    FOVring.Visible = isAiming
                    ToggleButton.Text = toggleState and "On" or "Off"
                    local targetColor = toggleState and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(255, 50, 50)
                    local targetPos = toggleState and UDim2.new(1, -38, 0.5, -17) or UDim2.new(0, 4, 0.5, -17)
                                
                    TweenService:Create(Indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = targetColor, Position = targetPos}):Play()
                    TweenService:Create(ToggleButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = toggleState and Color3.fromRGB(80, 200, 80) or Color3.fromRGB(50, 50, 50)}):Play()
                end

                ToggleButton.MouseButton1Click:Connect(toggle)

                DestroyButton.MouseButton1Click:Connect(function()
                    if MainFrame then
                        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1, Size = UDim2.new(0, 0, 0, 0)}):Play()
                        isAiming = false
                        toggleState = false
                        wait(0.3)
                        ScreenGui:Destroy()
                    end
                end)

                -- Smooth appear animation
                TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.2}):Play()

                updateNPCs()
                workspace.DescendantRemoved:Connect(function(descendant)
                    if isNPC(descendant) then
                        for i = #validNPCs, 1, -1 do
                            if validNPCs[i] == descendant then
                                table.remove(validNPCs, i)
                                break
                            end
                        end
                    end
                end)

                game:GetService("Players").PlayerRemoving:Connect(function()
                    FOVring:Remove()
                end)
                
            end
        })
    else
        local AimToggle = Tabs.Ma:AddToggle("AimToggle", {Title = "Aimbot V2", Description = "• Hold M2 to start aiming.", Default = false })
        AimToggle:OnChanged(function()
            Aimbot.Enabled = AimToggle.Value
        end)
    end

    local Aim2Slider = Tabs.Ma:AddSlider("Aim2Slider", {
        Title = "FOV",
        Description = "FOV Aimbot V2.",
        Default = 100,
        Min = 50,
        Max = 250,
        Rounding = 1,
        Callback = function(Value)
            if detectMobile() then
                fov = Value
            else
                Aimbot.Settings.FOV = Value
            end
        end
    })

    -- 🟢 Enhanced NPC Lock Script with Draggable UI
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local VirtualInputManager = game:GetService("VirtualInputManager")
    local StarterGui = game:GetService("StarterGui")
    local RunService = game:GetService("RunService")
    local CoreGui = game:GetService("CoreGui")
    local Camera = workspace.CurrentCamera

    local player = Players.LocalPlayer

    -- UI Setup
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "Cathub_NPC_Lock_UI"
    screenGui.Parent = CoreGui

    local button = Instance.new("TextButton")
    button.Name = "NPC Lock: ON/OFF"
    button.Size = UDim2.new(0, 150, 0, 50)
    button.Position = UDim2.new(0.5, -75, 0.9, -25) -- Default position
    button.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Windows 11 Style
    button.BackgroundTransparency = 0.3
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Text = "NPC Lock: OFF"
    button.Font = Enum.Font.SourceSansSemibold
    button.TextScaled = true
    button.ZIndex = 1000

    local icon = Instance.new("ImageLabel")
    icon.Name = "Icon"
    icon.Size = UDim2.new(0, 20, 0, 20) -- Adjust size as needed
    icon.Position = UDim2.new(0, 5, 0, 5) -- Top-left corner padding
    icon.BackgroundTransparency = 1 -- Make background invisible
    icon.Image = "rbxassetid://121302760641013" -- Replace with your image ID
    icon.Parent = button
    icon.ZIndex = 1001


    button.Parent = screenGui

    local uicorner = Instance.new("UICorner")
    uicorner.CornerRadius = UDim.new(0.2, 0)
    uicorner.Parent = button

    -- 🟢 Dragging Feature (Integrated)
    local dragging, dragStart, startPos, isDragging = false, nil, nil, false
    local dragThreshold = 10

    local function startDrag(input)
        isDragging = false
        dragging = true
        dragStart = input.Position
        startPos = button.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end

    local function onDrag(input)
        if dragging then
            local delta = (input.Position - dragStart).Magnitude
            if delta > dragThreshold then
                isDragging = true
            end
            button.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + (input.Position.X - dragStart.X),
                startPos.Y.Scale, startPos.Y.Offset + (input.Position.Y - dragStart.Y)
            )
        end
    end

    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            startDrag(input)
        end
    end)

    button.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            onDrag(input)
        end
    end)

    -- 🟢 Click Animation
    button.MouseButton1Click:Connect(function()
        if isDragging then return end

        local clickTween = TweenService:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.5})
        clickTween:Play()
        task.wait(0.1)
        local resetTween = TweenService:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.3})
        resetTween:Play()
    end)

    -- 🟢 NPC Lock Logic
    local npcLock = false
    local lastTarget = nil
    local toggleLoop

    local function addPlayerHighlight()
        if player.Character then
            local highlight = player.Character:FindFirstChild("PlayerHighlightESP")
            if not highlight then
                highlight = Instance.new("Highlight")
                highlight.Name = "PlayerHighlightESP"
                highlight.FillColor = Color3.new(1, 1, 1)
                highlight.OutlineColor = Color3.new(1, 1, 1)
                highlight.FillTransparency = 0.5
                highlight.OutlineTransparency = 0
                highlight.Parent = player.Character
            end
        end
    end

    local function removePlayerHighlight()
        if player.Character and player.Character:FindFirstChild("PlayerHighlightESP") then
            player.Character.PlayerHighlightESP:Destroy()
        end
    end

    local function getClosestNPC()
        local closestNPC = nil
        local closestDistance = math.huge

        for _, object in ipairs(workspace:GetDescendants()) do
            if object:IsA("Model") then
                local humanoid = object:FindFirstChild("Humanoid") or object:FindFirstChildWhichIsA("Humanoid")
                local hrp = object:FindFirstChild("HumanoidRootPart") or object.PrimaryPart
                if humanoid and hrp and humanoid.Health > 0 and object.Name ~= "Horse" then
                    local isPlayer = false
                    for _, pl in ipairs(Players:GetPlayers()) do
                        if pl.Character == object then
                            isPlayer = true
                            break
                        end
                    end
                    if not isPlayer then
                        local distance = (hrp.Position - player.Character.HumanoidRootPart.Position).Magnitude
                        if distance < closestDistance then
                            closestDistance = distance
                            closestNPC = object
                        end
                    end
                end
            end
        end

        return closestNPC
    end

    local CamLToggle = Tabs.Ma:AddToggle("CamLToggle", {Title = "NPC Cam Lock", Default = false }) 

    CamLToggle:OnChanged(function(Value)
        if not Value then
            button.Visible = false
        else
            button.Visible = true
        end
    end)

    button.MouseButton1Click:Connect(function()
        if isDragging then return end -- Prevent accidental toggling

        npcLock = not npcLock
        button.Text = npcLock and "NPC Lock: ON" or "NPC Lock: OFF"

        local runService = game:GetService("RunService")
        local players = game:GetService("Players")
        local player = players.LocalPlayer
        local camera = workspace.CurrentCamera 

        if npcLock then
            toggleLoop = runService.RenderStepped:Connect(function()
                local npc = getClosestNPC()
                if npc and npc:FindFirstChild("Humanoid") then
                    local npcHumanoid = npc:FindFirstChild("Humanoid")
                    if npcHumanoid.Health > 0 then
                        camera.CameraSubject = npcHumanoid
                        lastTarget = npc
                        addPlayerHighlight()
                    else
                        Fluent:Notify({
                            Title = "Ringta Scripts",
                            Content = "Killed NPC",
                            SubContent = npc.Name, -- Optional
                            Duration = 1
                        })
                        lastTarget = nil
                        removePlayerHighlight()
                        if player.Character and player.Character:FindFirstChild("Humanoid") then
                            camera.CameraSubject = player.Character:FindFirstChild("Humanoid")
                        end
                    end
                else
                    if player.Character and player.Character:FindFirstChild("Humanoid") then
                        camera.CameraSubject = player.Character:FindFirstChild("Humanoid")
                    end
                    lastTarget = nil
                    removePlayerHighlight()
                end
            end)
        else
            if toggleLoop then
                toggleLoop:Disconnect()
                toggleLoop = nil
            end
            removePlayerHighlight()
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                camera.CameraSubject = player.Character:FindFirstChild("Humanoid")
            end
        end
    end)


    Tabs.Ma:AddSection("↳ ESP")

    local EspToggle = Tabs.Ma:AddToggle("EspToggle", {Title = "ESP", Description = "• ESP Items/Mobs", Default = false })
    EspToggle:OnChanged(function()
        if EspToggle.Value then
            ESP.Initialize()
            ESP.Update()
        else
            ESP.Cleanup()
        end
    end)

    Tabs.Ma:AddSection("↳ Hitbox")

    getgenv().hitboxEnabled = false
    local hitboxTransparency = 0.85 -- Semi-visible
    local hitboxColor = Color3.fromRGB(255, 0, 0) -- Red hitbox
    local hitboxSize = Vector3.new(15, 15, 15) -- Expanded size
    local originalProperties = {} -- Stores original properties
    local hitboxConnection
    local lastUpdate = 0
    local UPDATE_INTERVAL = 0.3 -- Update every 0.3s to prevent lag

    -- ✅ Target NPCs List
    local targetNPCs = {
        ["Vampire"] = true, ["Werewolf"] = true, ["Wolf"] = true,
        ["Runner"] = true, ["Walker"] = true, ["Banner"] = true, 
        ["Nikola Tesla"] = true, ["Lab Zombie"] = true, ["Captain Prescott"] = true,
        ["Zombie Soldier"] = true, ["Banker"] = true, 
        ["Outlaw"] = true, ["RifleOutlaw"] = true, ["ShotgunOutlaw"] = true, ["RevolverOutlaw"] = true, ["TurretOutlaw"] = true,
        ["Scientist Zombies"] = true, ["Scientist"] = true, ["Soldier"] = true, ["ZombieMiner"] = true, ["SkeletonMiner"] = true,
    }

    local function isTargetNPC(character)
        return character:IsA("Model") and character:FindFirstChild("Humanoid") and targetNPCs[character.Name]
    end

    -- ✅ Expand Hitbox (Both HumanoidRootPart & Head)
    local function expandHitbox(npc)
        for _, partName in ipairs({"HumanoidRootPart", "Head"}) do
            local hitboxPart = npc:FindFirstChild(partName)
            local humanoid = npc:FindFirstChild("Humanoid")

            if hitboxPart and humanoid and humanoid.Health > 0 then
                if not originalProperties[npc] then
                    originalProperties[npc] = {}
                end
                if not originalProperties[npc][partName] then
                    originalProperties[npc][partName] = {
                        Size = hitboxPart.Size,
                        Transparency = (partName == "HumanoidRootPart") and 1 or 0, -- ✅ Correct original transparency
                        Shape = hitboxPart.Shape,
                        CanCollide = hitboxPart.CanCollide
                    }
                end

                -- 🔹 Apply Hitbox Expansion
                hitboxPart.Size = hitboxSize
                hitboxPart.Transparency = hitboxTransparency -- ✅ Hitbox is always visible when enabled
                hitboxPart.Color = hitboxColor
                hitboxPart.Material = Enum.Material.ForceField
                hitboxPart.CanCollide = false -- ✅ Prevent collisions

                -- 🔹 Ensure HumanoidRootPart is a Box & Head is a Sphere
                if partName == "HumanoidRootPart" then
                    hitboxPart.Shape = Enum.PartType.Block
                else
                    hitboxPart.Shape = Enum.PartType.Ball
                end
            end
        end
    end

    -- ✅ Reset Hitbox to Default
    local function resetHitbox(npc)
        for _, partName in ipairs({"HumanoidRootPart", "Head"}) do
            local hitboxPart = npc:FindFirstChild(partName)
            if hitboxPart and originalProperties[npc] and originalProperties[npc][partName] then
                hitboxPart.Size = originalProperties[npc][partName].Size
                hitboxPart.Transparency = originalProperties[npc][partName].Transparency
                hitboxPart.Shape = originalProperties[npc][partName].Shape
                hitboxPart.Color = Color3.fromRGB(255, 255, 255)
                hitboxPart.Material = Enum.Material.Plastic
                hitboxPart.CanCollide = originalProperties[npc][partName].CanCollide
            end
        end
        originalProperties[npc] = nil
    end

    -- ✅ Remove Hitbox from Dead NPCs
    local function monitorNPCHealth(npc)
        local humanoid = npc:FindFirstChild("Humanoid")
        if humanoid then
            humanoid:GetPropertyChangedSignal("Health"):Connect(function()
                if humanoid.Health <= 0 then
                    resetHitbox(npc) -- ✅ Reset hitbox if NPC dies
                end
            end)
        end
    end

    -- ✅ Optimized NPC Update Loop (Prevents lag)
    local function updateAllNPCs()
        local currentTime = tick()
        if currentTime - lastUpdate < UPDATE_INTERVAL then return end
        lastUpdate = currentTime

        for _, npc in ipairs(workspace:GetDescendants()) do
            if isTargetNPC(npc) then
                if getgenv().hitboxEnabled then
                    expandHitbox(npc)
                    monitorNPCHealth(npc)
                else
                    resetHitbox(npc)
                end
            end
        end
    end

    local function toggleHitbox(enable)
        if enable then
            hitboxConnection = game:GetService("RunService").Stepped:Connect(updateAllNPCs)
        elseif hitboxConnection then
            hitboxConnection:Disconnect()
        end
        updateAllNPCs()
    end

    -- ✅ UI Toggle for Hitbox Expander (Now Enables Visibility Automatically)
    local HitboxToggle = Tabs.Ma:AddToggle("HitboxToggle", {
        Title = "Hitbox Expander",
        Default = false
    })
    HitboxToggle:OnChanged(function(Value)
        getgenv().hitboxEnabled = Value
        toggleHitbox(Value)
    end)

    Tabs.Ma:AddSection("↳ Kill Aura")
    if game.PlaceId == 116495829188952 then
        Tabs.Ma:AddParagraph({
            Title = "Note",
            Content = "Join main game to use this feature!"
        })
    else
        local Players = game:GetService("Players")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local workspace = game.Workspace

        local ShootRemote = ReplicatedStorage.Remotes.Weapon.Shoot
        local ReloadRemote = ReplicatedStorage.Remotes.Weapon.Reload
        local Camera = workspace.CurrentCamera or workspace:WaitForChild("Camera")
        local LocalPlayer = Players.LocalPlayer

        local AutoHeadshotEnabled = false
        local AutoReloadEnabled = true
        local GunAuraAllMobs = true
        local SEARCH_RADIUS = 1000
        local HEADSHOT_DELAY = 0.1
        local killAuraCoroutine = nil

        local Weapons = {
            ["Revolver"] = true,
            ["Rifle"] = true,
            ["Sawed-Off Shotgun"] = true,
            ["Bolt Action Rifle"] = true,
            ["Navy Revolver"] = true,
            ["Mauser"] = true,
            ["Shotgun"] = true
        }

        local function getEquippedSupportedWeapon()
            local char = LocalPlayer.Character
            if not char then return nil end
            for name, _ in pairs(Weapons) do
                local tool = char:FindFirstChild(name)
                if tool then
                    return tool
                end
            end
            return nil
        end

        local function isNPC(obj)
            if not obj:IsA("Model") then return false end
            if workspace:FindFirstChild("Horse") and obj:IsDescendantOf(workspace.Horse) then
                return false
            end
            local hum = obj:FindFirstChildOfClass("Humanoid")
            if not hum or hum.Health <= 0 then return false end
            return obj:FindFirstChild("Head")
                and obj:FindFirstChild("HumanoidRootPart")
                and not Players:GetPlayerFromCharacter(obj)
        end

        local function findAllNPCsInRange()
            local npcs = {}
            for _, obj in ipairs(workspace:GetDescendants()) do
                if isNPC(obj) then
                    local head = obj:FindFirstChild("Head")
                    local dist = (head.Position - Camera.CFrame.Position).Magnitude
                    if dist <= SEARCH_RADIUS then
                        table.insert(npcs, {
                            model = obj,
                            hum = obj.Humanoid,
                            head = head
                        })
                    end
                end
            end
            table.sort(npcs, function(a, b)
                return (a.head.Position - Camera.CFrame.Position).Magnitude < (b.head.Position - Camera.CFrame.Position).Magnitude
            end)
            return npcs
        end

        local function autoHeadshotLoop()
            while AutoHeadshotEnabled do
                local tool = getEquippedSupportedWeapon()
                if tool then
                    local npcs = GunAuraAllMobs and findAllNPCsInRange() or {}
                    for _, npc in ipairs(npcs) do
                        if npc.hum and npc.hum.Health > 0 then
                            local pelletTable = {}
                            if tool.Name:lower():find("shotgun") then
                                for i = 1, 6 do
                                    pelletTable[tostring(i)] = npc.hum
                                end
                            else
                                pelletTable["1"] = npc.hum
                            end
                            local shootArgs = {
                                workspace:GetServerTimeNow(),
                                tool,
                                CFrame.new(npc.head.Position + Vector3.new(0, 1.5, 0), npc.head.Position),
                                pelletTable
                            }
                            local success, err = pcall(function()
                                ShootRemote:FireServer(unpack(shootArgs))
                            end)
                            if not success then
                                warn("[Ringta Scripts] Failed to fire shot: " .. tostring(err))
                            end
                            if AutoReloadEnabled then
                                success, err = pcall(function()
                                    ReloadRemote:FireServer(workspace:GetServerTimeNow(), tool)
                                end)
                                if not success then
                                    warn("[Ringta Scripts] Failed to reload: " .. tostring(err))
                                end
                            end
                        end
                    end
                end
                task.wait(HEADSHOT_DELAY)
            end
        end

        local GunKillAura = Tabs.Ma:AddToggle("GunKillAura", {Title = "Gun Kill Aura", Description = "Must hold gun.", Default = false })

        GunKillAura:OnChanged(function(Value)
            AutoHeadshotEnabled = Value
            if Value then
                if not killAuraCoroutine then
                    killAuraCoroutine = task.spawn(autoHeadshotLoop)
                end
            else
                AutoHeadshotEnabled = false
                -- Coroutine will stop due to AutoHeadshotEnabled being false
            end
        end)

        local GunAuraRadius = Tabs.Ma:AddSlider("GunAuraRadius", {
            Title = "Kill Aura Radius",
            Description = "Adjust the attack range.",
            Default = 1000,
            Min = 100,
            Max = 2000,
            Rounding = 1,
            Callback = function(Value)
                local radius = tonumber(Value)
                SEARCH_RADIUS = radius or 1000 -- Fallback to default if conversion fails
            end
        })
    end

    Tabs.Ma:AddSection("↳ Melee")

    local autoClickConnection = nil

    local TacToggle = Tabs.Ma:AddToggle("TacToggle", {
        Title = "Tool Auto Click",
        Default = false
    })

    TacToggle:OnChanged(function(Value)
        local player = game.Players.LocalPlayer
        local RunService = game:GetService("RunService")
        if Value then
            autoClickConnection = RunService.RenderStepped:Connect(function()
                local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
                if tool then
                    tool:Activate()
                end
            end)
        else
            if autoClickConnection then
                autoClickConnection:Disconnect()
                autoClickConnection = nil
            end
        end
    end)









local auraScriptName = "AuraEffect" -- Tên giả định để tìm hiệu ứng, bạn có thể đổi tùy theo script tạo ra gì

local auraToggle = Tabs.Ma:AddToggle("AuraToggle", {
    Title = "Melee Aura V3",
    Default = false
})

auraToggle:OnChanged(function(Value)
    if Value then
        -- Bật: tải và chạy script từ link
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Shade-vex/Dead-Rails-V3/refs/heads/main/Melle-Aura.lua.txt"))()
    else
        -- Tắt: tìm và xóa hiệu ứng liên quan (tùy vào script tạo gì, bạn sửa lại nếu biết rõ hơn)
        local function tryDestroyIn(parent)
            for _, obj in ipairs(parent:GetChildren()) do
                if obj.Name:lower():find("aura") or obj.Name == auraScriptName then
                    obj:Destroy()
                end
            end
        end

        pcall(function()
            tryDestroyIn(game.CoreGui)
            tryDestroyIn(game.Players.LocalPlayer:WaitForChild("PlayerGui"))
            tryDestroyIn(game.Workspace)
        end)
    end
end)





    Tabs.Ma:AddSection("↳ Auto Heal")
    
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")

    local LocalPlayer = Players.LocalPlayer
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")

    local autoHealEnabled = false
    local healThreshold = 30
    local healingInProgress = false  -- Prevents multiple activations
    local priorityItem = "Snake Oil" -- Default priority

    -- Detect Mobile
    local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

    local healSlider = Tabs.Ma:AddSlider("healSlider", {
        Title = "Heal Threshold (%)",
        Description = "Heal threshold to auto heal.",
        Default = healThreshold,
        Min = 10,
        Max = 90,
        Rounding = 1,
        Callback = function(Value)
            healThreshold = Value
        end
    })

    local healDropdown = Tabs.Ma:AddDropdown("healDropdown", {
        Title = "Item Priority",
        Values = {"Snake Oil", "Bandage"},
        Multi = false,
        Default = 1,
    })
    -- Dropdown for setting healing item priority
    healDropdown:OnChanged(function(Value)
        priorityItem = Value
    end)

    -- Function to find healing items
    local function findHealingItem()
        local Backpack = LocalPlayer.Backpack
        local SnakeOil, Bandage = nil, nil

        for _, item in ipairs(Backpack:GetChildren()) do
            if item:IsA("Tool") then
                if item.Name:find("Snake Oil") then
                    SnakeOil = item
                elseif item.Name:find("Bandage") then
                    Bandage = item
                end
            end
        end
        return SnakeOil, Bandage
    end

    -- Toggle for enabling/disabling Auto-Heal
    local HealToggle = Tabs.Ma:AddToggle("HealToggle", {
        Title = "Auto Heal",
        Description = "Need bandage or snake oil.",
        Default = false
    })
    HealToggle:OnChanged(function(Value)
        autoHealEnabled = Value
    end)

    local function useSoiL()
        local args = {
            [1] = game:GetService("Players").LocalPlayer.Character:FindFirstChild("Snake Oil")
        }
        game:GetService("Players").LocalPlayer.Character:FindFirstChild("Snake Oil").Use:FireServer(unpack(args))
    end
    local function useBdage()
        game:GetService("Players").LocalPlayer.Character:FindFirstChild("Bandage").Use:FireServer()
    end

    -- Function to use healing items
    local function useHealingItem()
        if healingInProgress then return end  -- Prevent spam
        healingInProgress = true

        while autoHealEnabled and Humanoid.Health < (Humanoid.MaxHealth * (healThreshold / 100)) do
            local SnakeOil, Bandage = findHealingItem()

            if priorityItem == "Snake Oil" and SnakeOil then
                Fluent:Notify({
                    Title = "Ringta",
                    Content = "Auto Heal",
                    SubContent = "Using Snake Oil!",
                    Duration = 2
                })
                SnakeOil.Parent = Character
                task.wait(0.1)
                useSoiL()
                break -- Only use one Snake Oil

            elseif priorityItem == "Bandage" and Bandage then
                Fluent:Notify({
                    Title = "Ringta",
                    Content = "Auto Heal",
                    SubContent = "Using Bandage!",
                    Duration = 2
                })
                Bandage.Parent = Character
                task.wait(0.2)
                useBdage()

            elseif SnakeOil then
                Fluent:Notify({
                    Title = "Ringta",
                    Content = "Auto Heal",
                    SubContent = "Using Snake Oil as fallback!",
                    Duration = 2
                })
                SnakeOil.Parent = Character
                task.wait(0.1)
                useSoiL()
                break

            elseif Bandage then
                Fluent:Notify({
                    Title = "Ringta X BIGBACK",
                    Content = "Auto Heal",
                    SubContent = "Using Bandage as fallback!",
                    Duration = 2
                })
                Bandage.Parent = Character
                task.wait(0.2)
                useBdage()

            else
                break
            end
        end

        healingInProgress = false
    end

    -- Monitor health with optimized checking
    RunService.Heartbeat:Connect(function()
        if autoHealEnabled and not healingInProgress and Humanoid.Health < (Humanoid.MaxHealth * (healThreshold / 100)) then
            useHealingItem()
        end
    end)
end




--Item




    Tabs.Ite:AddSection("↳ Tesla")



Tabs.Ite:AddButton({
    Title = "Auto Spawn Tesla",
    Callback = function()
        pcall(function()
            -- Tải và chạy script từ link
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Shade-vex/bruh/refs/heads/main/Auto-Tesla-Boss.lua"))()
        end)
    end
})




    Tabs.Ite:AddSection("↳ Item")              






local MoneyToggle = Tabs.Ite:AddToggle("MoneyToggle", {
    Title = "Auto Collect Money Bag",
    Default = false
})

local Mstatus = false
local originalHoldDurations1 = {}
local runService = game:GetService("RunService")
local moneyBagConnections = {}

local function skipHoldPrompt1(prompt)
    if prompt and prompt:IsA("ProximityPrompt") and prompt.Parent and prompt.Parent.Name == "MoneyBag" then
        if not originalHoldDurations1[prompt] then
            originalHoldDurations1[prompt] = prompt.HoldDuration
        end
        prompt.HoldDuration = 0
    end
end

local function restoreMoneybagPrompts()
    for prompt, duration in pairs(originalHoldDurations1) do
        if prompt and prompt.Parent and prompt.Parent.Name == "MoneyBag" then
            prompt.HoldDuration = duration
        end
    end
    originalHoldDurations1 = {}
end

local function handleMoneyBag(v)
    if not Mstatus then return end
    if v:IsA("Model") and v.Name == "Moneybag" and v:FindFirstChild("MoneyBag") then
        local prompt = v.MoneyBag:FindFirstChildOfClass("ProximityPrompt")
        if prompt then
            skipHoldPrompt1(prompt)
        end
    end
end

local function cleanupConnections()
    for _, connection in pairs(moneyBagConnections) do
        if connection then
            connection:Disconnect()
        end
    end
    table.clear(moneyBagConnections)
end

local function collectMoneyBags()
    if not Mstatus then return end
    cleanupConnections()

    for _, v in ipairs(workspace.RuntimeItems:GetChildren()) do
        handleMoneyBag(v)
    end

    local connection = runService.Heartbeat:Connect(function()
        if not Mstatus then return end
        for _, v in ipairs(workspace.RuntimeItems:GetChildren()) do
            if v:IsA("Model") and v.Name == "Moneybag" and v:FindFirstChild("MoneyBag") then
                local prompt = v.MoneyBag:FindFirstChildOfClass("ProximityPrompt")
                if prompt and (v.MoneyBag.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= prompt.MaxActivationDistance then
                    fireproximityprompt(prompt)
                end
            end
        end
    end)

    table.insert(moneyBagConnections, connection)
end

MoneyToggle:OnChanged(function(Value)
    Mstatus = Value
    if Mstatus then
        collectMoneyBags()
    else
        cleanupConnections()
        restoreMoneybagPrompts()
    end
end)









local PsoBToggle = Tabs.Ite:AddToggle("PsoBToggle", {
    Title = "Auto Pickup Snake Oil & Bandage(s)",
    Default = false
})

local ReplicatedStorage1 = game:GetService("ReplicatedStorage")
local RuntimeItems1 = workspace:WaitForChild("RuntimeItems")
local PickUpTool = ReplicatedStorage1.Remotes.Tool.PickUpTool

local autoPickupEnabled = false

PsoBToggle:OnChanged(function(Value)
    autoPickupEnabled = Value

    if autoPickupEnabled then
        task.spawn(function()
            while autoPickupEnabled do
                for _, itemName in ipairs({"Bandage", "Snake Oil"}) do
                    local item = RuntimeItems1:FindFirstChild(itemName)
                    if item then
                        PickUpTool:FireServer(item)
                    end
                end
                task.wait(0.5) -- Giảm tải, không cần Heartbeat
            end
        end)
    end
end)




----- pickup gun

local autoCollectEnabled = false

-- Tạo Toggle mới để bật/tắt Auto Pickup Gun thông qua link script
local GunToggle = Tabs.Ite:AddToggle("GunToggle", {
    Title = "Auto Pickup Gun(s)",
    Default = false
})

-- Biến để lưu trữ hàm toggle
local toggleFunction = nil
local gunCoroutine = nil

-- Khi toggle thay đổi trạng thái
GunToggle:OnChanged(function(Value)
    autoCollectEnabled = Value
    
    if autoCollectEnabled then
        -- Sử dụng coroutine để chạy script không bị nghẽn
        gunCoroutine = coroutine.create(function()
            pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/Shade-vex/sjsnskk/refs/heads/main/pickupgun"))()
                
                if _G.ToggleAutoPickupGun then
                    toggleFunction = _G.ToggleAutoPickupGun
                    toggleFunction(true) -- Kích hoạt
                else
                    warn("⚠️ Không tìm thấy hàm _G.ToggleAutoPickupGun!")
                end
            end)
        end)
        coroutine.resume(gunCoroutine)
    else
        if toggleFunction then
            toggleFunction(false) -- Tắt nếu toggle chuyển sang false
        end
    end
end)





---- scan item

        Tabs.Ite:AddButton({
            Title = "Scan Item(s)",
            Callback = function()
                local function scanItems()
                    local itemsList = {
                        {"GoldBar", 50},
                        {"SilverBar", 25},
                        {"GoldPainting", 35},
                        {"GoldCup", 25},
                        {"SilverPocketWatch", 7},
                        {"SilverPainting", 12},
                        {"Vampire", 15},
                        {"Werewolf", 20},
                        {"GoldPlate", 20},
                        {"GoldPocketWatch", 15},
                        {"Holy Water", 20},
                        {"Painting", 5},
                        {"Banjo", 15},
                        {"Statue", 5},
                        {"SilverStatue", 20},
                        {"GoldStatue", 45},
                        {"VaseTwo", 5},
                        {"Bandage", 7},
                        {"Book", 5},
                        {"Wheel", 5},
                        {"Chair", 5},
                        {"Barrel", 5},
                        {"Rope", 5},
                        {"Helmet", 60},
                        {"ChestPlate", 70},
                        {"Rightshoulderarmor", 45},
                        {"Leftshoulderarmor", 45},
                        {"Nikola Tesla`s Head", 250}
                    }
                    
                    local StarterGui = game:GetService("StarterGui")
                    local folder = workspace.RuntimeItems
                    local totalValue = 0
                    local scannedItems = 0
                
                    for _, item in pairs(folder:GetChildren()) do
                        for _, itemData in pairs(itemsList) do
                            if item.Name == itemData[1] then
                                totalValue = totalValue + itemData[2]
                                scannedItems = scannedItems + 1
                            end
                        end
                    end

                    Fluent:Notify({
                        Title = "Ringta X BIGBACK",
                        Content = "Scanned (" .. totalValue .. "$)",
                        SubContent = "Scanned " .. scannedItems .. "/" .. #folder:GetChildren() .. " items",
                        Duration = 15
                    })
                end
                
                scanItems()
            end
        })









-- Teleport tab



if game.PlaceId == 116495829188952 then
    Tabs.TpT:AddParagraph({
        Title = "Note",
        Content = "Use these features with care!"
    })
else
    Tabs.TpT:AddSection("↳ End Game")
    
    -- Khởi tạo Toggle
    local CtimeToggle = Tabs.TpT:AddToggle("CtimeToggle", {
        Title = "Countdown",
        Description = "10 minutes countdown",
        Default = false
    })
    
    -- Tạo GUI
    local CountdownGui = Instance.new("ScreenGui")
    CountdownGui.Name = "CountdownUI"
    CountdownGui.ResetOnSpawn = false
    CountdownGui.IgnoreGuiInset = true
    CountdownGui.Parent = game:GetService("CoreGui")
    
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 150, 0, 50)
    Frame.Position = UDim2.new(0.5, -75, 0.15, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Frame.BackgroundTransparency = 0.1
    Frame.BorderSizePixel = 0
    Frame.AnchorPoint = Vector2.new(0.5, 0)
    Frame.Active = true
    Frame.Draggable = true
    Frame.Parent = CountdownGui
    Frame.Visible = false
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = Frame
    
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(255, 255, 255)
    UIStroke.Thickness = 1.5
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = Frame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = "10:00"
    Label.Font = Enum.Font.FredokaOne
    Label.TextScaled = true
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Parent = Frame
    
    local countdownTime = 10 * 60 -- 10 phút
    local running = false
    local lastTimeChecked = os.time()
    local pausedTime = nil

    local function formatTime(seconds)
        local minutes = math.floor(seconds / 60)
        local secs = seconds % 60
        return string.format("%02d:%02d", minutes, secs)
    end
    
    -- Cập nhật GUI
    local function updateCountdown()
        Label.Text = formatTime(countdownTime)
    end

    -- Hàm chạy đếm ngược
    task.spawn(function()
        while countdownTime > 0 do
            task.wait(1)
            if running then
                local now = os.time()
                local delta = now - lastTimeChecked
                countdownTime -= delta
                lastTimeChecked = now
                if countdownTime < 0 then
                    countdownTime = 0
                end
                updateCountdown()
            end
        end
    end)

    -- Toggle bật/tắt
    CtimeToggle:OnChanged(function(Value)
        Frame.Visible = Value
        if Value then
            if pausedTime then
                -- Nếu đã pause, cập nhật thời gian bị trôi đi
                local now = os.time()
                local delta = now - pausedTime
                countdownTime -= delta
                pausedTime = nil
            end
            lastTimeChecked = os.time()
            running = true
        else
            running = false
            pausedTime = os.time() -- Lưu lại thời gian khi tắt đi
        end
    end)
end



        Tabs.TpT:AddButton({
            Title = "TP To Final Destination",
            Callback = function()
                local Player = game.Players.LocalPlayer
                if not Player.Character then
                    Player.CharacterAdded:Wait()
                end
                local Character = Player.Character
                if Character and Character:FindFirstChild("HumanoidRootPart") then
                    local HRP = Character.HumanoidRootPart
                    local HUM = Character:FindFirstChildOfClass("Humanoid")
                    
                    -- Store original values
                    local originalWalkSpeed = HUM.WalkSpeed
                    
                    -- Disable any movement to prevent teleporting back
                    HUM.WalkSpeed = 0
                    
                    -- First teleport
                    HRP.CFrame = CFrame.new(-424.45, 26.06, -49040.66)
                    HRP.Anchored = true
                    
                    task.wait(0.5)
                    -- Execute anti-teleport measures
                    for _, part in pairs(Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.Velocity = Vector3.new(0, 0, 0)
                        end
                    end
                    
                    task.wait(1)
                    -- Second teleport
                    HRP.CFrame = CFrame.new(-447.38, 26.08, -48747.68)
                    
                    task.wait(0.5)
                    -- Execute anti-teleport measures
                    for _, part in pairs(Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.Velocity = Vector3.new(0, 0, 0)
                        end
                    end
                    
                    task.wait(1)
                    -- Third teleport
                    HRP.CFrame = CFrame.new(-312.17, 26.08, -48747.68)
                    
                    task.wait(0.5)
                    -- Execute anti-teleport measures
                    for _, part in pairs(Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.Velocity = Vector3.new(0, 0, 0)
                        end
                    end
                    
                    task.wait(1)
                    -- Fourth teleport
                    HRP.CFrame = CFrame.new(-424.45, 26.06, -49040.66)
                    
                    -- Wait and release character
                    task.wait(2)
                    HRP.Anchored = false
                    HUM.WalkSpeed = originalWalkSpeed
                end
            end
        })







Tabs.TpT:AddSection("↳ Train")

Tabs.TpT:AddButton({
    Title = "TP To Train",
    Callback = function()
        pcall(function()
            -- Tải và chạy script từ link
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Shade-vex/KJ/refs/heads/main/TPtotrain.txt"))()
        end)
    end
})




Tabs.TpT:AddSection("↳ Bases")

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local gameWorkspace = game:GetService("Workspace") -- Đổi tên tránh ghi đè

local teleportLocations = {
    ["Spawn"] = CFrame.new(56.6396217, 3.24999976, 29936.3516),
    ["10 KM"] = CFrame.new(-160.576843, 2.99617577, 19913.252),
    ["20 KM"] = CFrame.new(-556.92572, 2.98922157, 9956.79883),
    ["30 KM"] = CFrame.new(-569.779663, 2.99999976, 47.5958443),
    ["40 KM"] = CFrame.new(-184.494064, 3.14674306, -9899.91797),
    ["50 KM"] = CFrame.new(55.228714, 3.19885039, -19842.3789),
    ["60 KM"] = CFrame.new(-199.620743, 3.14927387, -29733.9453),
    ["70 KM"] = CFrame.new(-577.781921, 3.49909163, -39654.2148),
}

local function findClosestVehicleSeat(position)
    local closestSeat = nil
    local minDistance = math.huge

    for _, seat in ipairs(gameWorkspace:GetDescendants()) do
        if seat:IsA("VehicleSeat") then
            local distance = (position - seat.Position).Magnitude
            if distance < minDistance then
                minDistance = distance
                closestSeat = seat
            end
        end
    end
    return closestSeat
end

local function teleportToLocation(locationName)
    local Player = game.Players.LocalPlayer
    if not Player.Character then
        Player.CharacterAdded:Wait()
    end
    local Character = Player.Character
    if Character and Character:FindFirstChild("HumanoidRootPart") then
        local HRP = Character.HumanoidRootPart
        local HUM = Character:FindFirstChildOfClass("Humanoid")
        
        local originalWalkSpeed = HUM.WalkSpeed
        HUM.WalkSpeed = 0
        HRP.CFrame = teleportLocations[locationName]
        HRP.Anchored = true

        task.wait(2)

        local fseat = findClosestVehicleSeat(HRP.Position)
    
        if fseat then
            HRP.CFrame = fseat.CFrame + Vector3.new(0, 3, 0)
            task.wait(0.15)
            HRP.Anchored = false
            task.wait(0.5)
            fseat:Sit(HUM)
        else
            HRP.Anchored = false
            warn("No seat found near location: " .. locationName)
        end
        
        task.wait(1)
        HUM.WalkSpeed = originalWalkSpeed
    end
end

local dropdownValues = {}
for locationName, _ in pairs(teleportLocations) do
    table.insert(dropdownValues, locationName)
end
table.sort(dropdownValues)

local selectedLocation = dropdownValues[1]
local Dropdown = Tabs.TpT:AddDropdown("TeleportDropdown", {
    Title = "Select Base",
    Values = dropdownValues,
    Multi = false,
    Default = 1,
})

Dropdown:OnChanged(function(value)
    selectedLocation = value
end)

Tabs.TpT:AddButton({
    Title = "Teleport to Selected Base",
    Callback = function()
        if selectedLocation and teleportLocations[selectedLocation] then
            task.wait(1)
            teleportToLocation(selectedLocation)
        else
            warn("No valid base selected for teleportation.")
        end
    end
})








        Tabs.TpT:AddButton({
            Title = "TP To Tesla Lab",
            Callback = function()
                local Player = game.Players.LocalPlayer
                if not Player.Character then
                    Player.CharacterAdded:Wait()
                end
                local Character = Player.Character
                if Character and Character:FindFirstChild("HumanoidRootPart") then
                    local HRP = Character.HumanoidRootPart
                    local HUM = Character:FindFirstChildOfClass("Humanoid")
                    
                    -- Store original values
                    local originalWalkSpeed = HUM.WalkSpeed
                    
                    -- Disable movement temporarily
                    HUM.WalkSpeed = 0
                    
                    -- Step 1: Teleport to Generator model
                    local Generator = workspace:WaitForChild("TeslaLab"):WaitForChild("Generator")
                    local modelPosition = Generator:GetPivot().Position
                    HRP:PivotTo(CFrame.new(modelPosition + Vector3.new(0, 5, 0))) -- Teleport above model
                    HRP.Anchored = true -- Anchor player
                    
                    task.wait(2) -- Wait for server sync
                    
                    -- Step 2: Find closest available Chair.Seat in RuntimeItems
                    local RuntimeItems = workspace:WaitForChild("RuntimeItems")
                    local function findClosestAvailableSeat()
                        local closestSeat = nil
                        local minDistance = math.huge
                        local playerPos = HRP.Position
                        
                        for _, chair in pairs(RuntimeItems:GetChildren()) do
                            if chair:IsA("Model") and chair.Name == "Chair" then
                                local seat = chair:FindFirstChild("Seat")
                                if seat and seat:IsA("Seat") and seat.Occupant == nil then
                                    local seatPos = seat.Position
                                    local distance = (seatPos - playerPos).Magnitude
                                    if distance < minDistance then
                                        minDistance = distance
                                        closestSeat = seat
                                    end
                                end
                            end
                        end
                        return closestSeat
                    end
                    
                    -- Step 3: Teleport to seat
                    local seat = findClosestAvailableSeat()
                    if seat then
                        HRP.Anchored = true -- Anchor for seat teleport
                        HRP:PivotTo(seat.CFrame + Vector3.new(0, 3, 0)) -- Position above seat
                        
                        -- Unanchor after 0.15 seconds
                        task.delay(0.15, function()
                            if HRP and HRP.Anchored then
                                HRP.Anchored = false
                            end
                        end)
                        
                        -- Safety unanchor after 0.1 seconds
                        task.delay(0.1, function()
                            if HRP and HRP.Anchored then
                                HRP.Anchored = false
                            end
                        end)
                        
                        task.wait(0.5)
                        seat:Sit(HUM) -- Sit on the seat
                    else
                        HRP.Anchored = false -- Unanchor if no seat found
                    end
                    
                    -- Restore movement
                    task.wait(1)
                    HUM.WalkSpeed = originalWalkSpeed
                end

            end
        })




Tabs.TpT:AddButton({
    Title = "TP To Fast Castle",
    Callback = function()
        pcall(function()
            -- Tải và chạy script từ link
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Shade-vex/KJ/refs/heads/main/FASTCASTLE.txt"))()
        end)
    end
})




Tabs.TpT:AddButton({
    Title = "TP To Fort",
    Callback = function()
        pcall(function()
            -- Tải và chạy script từ link
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Shade-vex/KJ/refs/heads/main/Tpfort.lua.txt"))()
        end)
    end
})



Tabs.TpT:AddButton({
    Title = "TP To Sterling",
    Callback = function()
        pcall(function()
            -- Hook SetCore để chặn thông báo
            local originalSetCore = game:GetService("StarterGui").SetCore
            local blocked = {"SendNotification"}

            hookfunction(originalSetCore, function(self, method, ...)
                if table.find(blocked, method) then
                    return -- Chặn thông báo xuất hiện
                end
                return originalSetCore(self, method, ...)
            end)

            -- Tải và chạy script từ link
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Shade-vex/KJ/refs/heads/main/TPsterling.txt"))()
        end)
    end
})





---Player tab




Tabs.Player:AddButton({
    Title = "Tool Air Weld",
    Callback = function()
        pcall(function()
            -- Tải và chạy script từ link
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Shade-vex/DeadRails/refs/heads/main/Air-Weld.lua"))()
        end)
    end
})









do
    Tabs.Player:AddSection("↳ Noclip")

    local runService = game:GetService("RunService")
    local players = game:GetService("Players")
    local localPlayer = players.LocalPlayer

    local NcToggle = Tabs.Player:AddToggle("NcToggle", {Title = "Noclip", Default = false })
    local noClipLoop

    NcToggle:OnChanged(function(Value)
        if Value then
            noClipLoop = runService.Stepped:Connect(function()
                local character = localPlayer.Character
                if character then
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        local isDead = humanoid.Health <= 0
                        
                        for _, v in pairs(character:GetDescendants()) do
                            if v:IsA("MeshPart") or v:IsA("Part") then
                                v.CanCollide = isDead
                            end
                        end

                        local rootPart = character:FindFirstChild("HumanoidRootPart")
                        if rootPart and rootPart.Position.Y < -5 then
                            rootPart.CFrame = CFrame.new(rootPart.Position.X, 5, rootPart.Position.Z)
                        end
                    end
                end
            end)
        else
            if noClipLoop then
                noClipLoop:Disconnect()
                noClipLoop = nil
            end
            local character = localPlayer.Character
            if character then
                for _, v in pairs(character:GetDescendants()) do
                    if v:IsA("MeshPart") or v:IsA("Part") then
                        v.CanCollide = true
                    end
                end
            end
        end
    end)

    localPlayer.CharacterAdded:Connect(function()
        wait(1) -- Allow character to fully load
        if NcToggle.Value then
            NcToggle:SetValue(true) -- ✅ Reactivate Noclip if it was already enabled
        end
    end)

    local NcToggle1 = Tabs.Player:AddToggle("NcToggle1", {Title = "Noclip 2 (Recommended)", Default = false })

    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    local NoclipEnabled = false
    local NoclipConnection
    local Clip = nil
    local Baseplate

    function createBaseplate()
        if Baseplate then Baseplate:Destroy() end
        Baseplate = Instance.new("Part")
        Baseplate.Size = Vector3.new(99999, 5, 99999) -- Large enough to cover the map
        Baseplate.Position = Vector3.new(0, -5, 0) -- Placed below the map
        Baseplate.Anchored = true
        Baseplate.CanCollide = true
        Baseplate.Material = Enum.Material.SmoothPlastic
        Baseplate.Parent = game.Workspace
    end

    function noclip()
        Clip = false
        local function Nocl()
            if Clip == false and LocalPlayer.Character then
                for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                    if v:IsA("BasePart") and v.CanCollide and v.Name ~= "Baseplate" then
                        v.CanCollide = false
                    end
                end
            end
            wait(0.1)
        end
        NoclipConnection = RunService.Stepped:Connect(Nocl)
    end

    function clip()
        if NoclipConnection then NoclipConnection:Disconnect() end
        Clip = true
        if LocalPlayer.Character then
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = true
                end
            end
        end
    end

    RunService.Stepped:Connect(function()
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root and root.Position.Y < -5 then
            root.CFrame = CFrame.new(root.Position.X, 5, root.Position.Z)
        end
    end)

    NcToggle1:OnChanged(function(Value)
        if Value then
            createBaseplate()
            noclip()
        else
            clip()
        end
    end)

    local Players = game:GetService("Players")
    local player = Players.LocalPlayer

    -- Invisibility state
    local invis_on = false
    local invisChair = nil
    local savedCFrame = nil

    -- Set character transparency
    local function setTransparency(character, transparency)
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") or part:IsA("MeshPart") then
                part.Transparency = transparency
            end
        end
    end

    -- Enable invisibility
    local function turnOnInvisibility()
        if not invis_on then
            invis_on = true
            local char = player.Character or player.CharacterAdded:Wait()
            local hrp = char:WaitForChild("HumanoidRootPart")
            savedCFrame = hrp.CFrame

            wait()
            char:MoveTo(Vector3.new(-25.95, 84, 3537.55))
            wait(0.15)

            invisChair = Instance.new("Seat", workspace)
            invisChair.Anchored = false
            invisChair.CanCollide = false
            invisChair.Name = "invischair"
            invisChair.Transparency = 1
            invisChair.Position = Vector3.new(-25.95, 84, 3537.55)

            local weld = Instance.new("Weld", invisChair)
            weld.Part0 = invisChair
            weld.Part1 = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")

            wait()
            invisChair.CFrame = savedCFrame
            setTransparency(char, 0)
            hrp.Transparency = 0
        end
    end

    -- Disable invisibility
    local function turnOffInvisibility()
        if invis_on then
            invis_on = false
            local char = player.Character or player.CharacterAdded:Wait()
            local hrp = char:WaitForChild("HumanoidRootPart")

            -- Reset transparency
            setTransparency(char, 0)
            hrp.Transparency = 0

            -- Move back to original position
            if savedCFrame then
                hrp.CFrame = savedCFrame
            end

            -- Clean up seat
            if invisChair then
                invisChair:Destroy()
                invisChair = nil
            end
        end
    end

    Tabs.Player:AddSection("↳ Fly")

    local Players = game:GetService("Players")
    local UIS = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local player = Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")

    -- Fly state
    local flying = false
    local speed = 2
    local control = {f = 0, b = 0, l = 0, r = 0}
    local bodyGyro, bodyVel, flyConn

    -- Movement controls
    local function onInput(input, isProcessed)
        if isProcessed then return end
        if input.UserInputType == Enum.UserInputType.Keyboard then
            if input.KeyCode == Enum.KeyCode.W then control.f = 1 end
            if input.KeyCode == Enum.KeyCode.S then control.b = -1 end
            if input.KeyCode == Enum.KeyCode.A then control.l = -1 end
            if input.KeyCode == Enum.KeyCode.D then control.r = 1 end
        end
    end

    local function onRelease(input)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            if input.KeyCode == Enum.KeyCode.W then control.f = 0 end
            if input.KeyCode == Enum.KeyCode.S then control.b = 0 end
            if input.KeyCode == Enum.KeyCode.A then control.l = 0 end
            if input.KeyCode == Enum.KeyCode.D then control.r = 0 end
        end
    end

    -- Fly logic
    local function startFly()
        if flying then return end
        flying = true

        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.P = 9e4
        bodyGyro.Parent = hrp
        bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bodyGyro.CFrame = hrp.CFrame

        bodyVel = Instance.new("BodyVelocity")
        bodyVel.Velocity = Vector3.zero
        bodyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bodyVel.P = 9e4
        bodyVel.Parent = hrp

        UIS.InputBegan:Connect(onInput)
        UIS.InputEnded:Connect(onRelease)

        flyConn = RunService.RenderStepped:Connect(function()
            local camCF = workspace.CurrentCamera.CFrame
            bodyGyro.CFrame = camCF
            local moveVec = Vector3.zero
            if control.f + control.b ~= 0 then
                moveVec += camCF.LookVector * (control.f + control.b)
            end
            if control.l + control.r ~= 0 then
                moveVec += camCF.RightVector * (control.r + control.l)
            end
            bodyVel.Velocity = moveVec * speed + Vector3.new(0, 0.1, 0)
        end)
    end

    local function stopFly()
        flying = false
        if flyConn then flyConn:Disconnect() end
        if bodyGyro then bodyGyro:Destroy() end
        if bodyVel then bodyVel:Destroy() end
    end

    -- Add Fluent UI Toggle
    local FlyToggle = Tabs.Player:AddToggle("FlyToggle", {
        Title = "Fly",
        Description = "When turn on, you cant collect/interact anything!",
       loadstring(game:HttpGet("https://raw.githubusercontent.com/Backwoodsix/BIGBACK-DEADRAILS-Fly-Script/refs/heads/main/Lua"))()

    -- Add Fluent UI Slider for Speed
    local FlySpeedSlider = Tabs.Player:AddSlider("FlySpeedSlider", {
        Title = "Fly Speed",
        Description = "Adjust fly speed",
        Default = 50,
        Min = 1,
        Max = 500,
        Rounding = 1,
        Callback = function(Value)
            speed = Value
        end
    })


    Tabs.Player:AddSection("↳ WalkSpeed")

    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local humanoid = char:WaitForChild("Humanoid")

    -- Store original values for WalkSpeed and JumpHeight
    local originalWalkSpeed = humanoid.WalkSpeed
    local originalJumpHeight = humanoid.JumpHeight

    -- Internal states
    local walkEnabled, jumpEnabled = false, false
    local walkMultiplier, jumpMultiplier = 2, 2

    -- Slider: WalkSpeed
    local WalkSpeedSlider = Tabs.Player:AddSlider("WalkSpeedSlider", {
        Title = "WalkSpeed Multiplier",
        Description = "Adjust your WalkSpeed.",
        Default = 2,
        Min = 0,
        Max = 200,
        Rounding = 1,
        Callback = function(Value)
            walkMultiplier = Value
            if walkEnabled then
                humanoid.WalkSpeed = originalWalkSpeed * walkMultiplier
            end
        end
    })

    -- Toggle: WalkSpeed
    local WalkSpeedToggle = Tabs.Player:AddToggle("WalkSpeedToggle", {
        Title = "WalkSpeed",
        Description = "When turn on, you cant collect/interact anything!",
        Default = false
    })

    WalkSpeedToggle:OnChanged(function(Value)
        walkEnabled = Value
        if Value then
            turnOnInvisibility()
            humanoid.WalkSpeed = originalWalkSpeed * walkMultiplier
        else
            turnOffInvisibility()
            humanoid.WalkSpeed = originalWalkSpeed
        end
    end)

    Tabs.Player:AddSection("↳ JumpHeight")
    -- Slider: JumpHeight
    local JumpHeightSlider = Tabs.Player:AddSlider("JumpHeightSlider", {
        Title = "JumpHeight Multiplier",
        Description = "Adjust your JumpHeight.",
        Default = 2,
        Min = 0,
        Max = 200,
        Rounding = 1,
        Callback = function(Value)
            jumpMultiplier = Value
            if jumpEnabled then
                humanoid.JumpHeight = originalJumpHeight * jumpMultiplier
            end
        end
    })

    -- Toggle: JumpHeight
    local JumpHeightToggle = Tabs.Player:AddToggle("JumpHeightToggle", {
        Title = "JumpHeight",
        Description = "When turn on, you cant collect/interact anything!",
        Default = false
    })

    JumpHeightToggle:OnChanged(function(Value)
        jumpEnabled = Value
        if Value then
            turnOnInvisibility()
            humanoid.JumpHeight = originalJumpHeight * jumpMultiplier
        else
            turnOffInvisibility()
            humanoid.JumpHeight = originalJumpHeight
        end
    end)
end












-- Misc tab

do
    local BuildingBank = {
        Enabled = false,
        Connections = {} -- Stores event connections
    }
    
    local function send()
        if not BuildingBank.Enabled then return end
    
        local bank = workspace.Towns.MediumTownTemplate.Buildings:FindFirstChild("Bank")
        local is = bank and "+" or "-"
    
        local StarterGui = game:GetService("StarterGui")
        Fluent:Notify({
            Title = "Ringta Scripts",
            Content = "Bank : " .. is,
            SubContent = "Checked for bank...",
            Duration = 15
        })
    
        if bank then
            local valute = bank.Vault.Combination.Value
            Fluent:Notify({
                Title = "Ringta Scripts",
                Content = "Bank Combination",
                SubContent = "Combination is: " .. valute,
                Duration = 15
            })
        end
    end
    
    local function sendBuildingAlert(child)
        if not BuildingBank.Enabled then return end
    
        local StarterGui = game:GetService("StarterGui")
        Fluent:Notify({
            Title = "Ringta",
            Content = "Structure {" .. child.Name .. "}",
            SubContent = "New building has spawned!",
            Duration = 15
        })
    
        -- Auto notify if the building is a bank
        if child.Name == "Bank" then
            send()
        end
    end
    
    local function sendUnicornAlert()
        if not BuildingBank.Enabled then return end
    
        local StarterGui = game:GetService("StarterGui")
        Fluent:Notify({
            Title = "Ringta Scripts",
            Content = "Unicorn Spawned!",
            Duration = 15
        })
    end
    
    local function enableAlerts()
        local folder = workspace.RandomBuildings
        table.insert(BuildingBank.Connections, folder.ChildAdded:Connect(sendBuildingAlert))
    
        local fold2 = workspace.Towns
        table.insert(BuildingBank.Connections, fold2.ChildAdded:Connect(sendBuildingAlert))
    
        local newfold = workspace.Baseplates
        table.insert(BuildingBank.Connections, newfold.ChildAdded:Connect(function(child)
            table.insert(BuildingBank.Connections, child:WaitForChild("CenterBaseplate").Animals.ChildAdded:Connect(function(children)
                if children.Name == "Unicorn" then
                    sendUnicornAlert()
                end
            end))
        end))
    
        for _, v in pairs(newfold:GetChildren()) do
            table.insert(BuildingBank.Connections, v:WaitForChild("CenterBaseplate").Animals.ChildAdded:Connect(function(children)
                if children.Name == "Unicorn" then
                    sendUnicornAlert()
                end
            end))
        end
    end
    
    local function disableAlerts()
        for _, connection in pairs(BuildingBank.Connections) do
            if connection then
                connection:Disconnect()
            end
        end
        BuildingBank.Connections = {}
    end

    local player2 = game.Players.LocalPlayer
    local humanoid = player2.Character and player2.Character:FindFirstChildOfClass("Humanoid")
    local WSToggle = Tabs.Misc:AddToggle("WSToggle", {Title = "Speed Boost", Default = false})

    local stepIncrease = 0.2 -- Gradual speed increase
    local defaultSpeed = humanoid and humanoid.WalkSpeed or 16 -- Detect player's default speed
    local speedBoost = 1.2 -- Speed increase amount
    local boostedSpeed = defaultSpeed + speedBoost -- New speed
    local speedLoop

    WSToggle:OnChanged(function(Value)
        if humanoid then
            if Value then
                boostedSpeed = humanoid.WalkSpeed + speedBoost -- Always adjust dynamically
                speedLoop = game:GetService("RunService").RenderStepped:Connect(function()
                    if humanoid.WalkSpeed < boostedSpeed then
                        humanoid.WalkSpeed = math.min(humanoid.WalkSpeed + stepIncrease, boostedSpeed)
                    end
                end)
            else
                if speedLoop then
                    speedLoop:Disconnect()
                    speedLoop = nil
                end
                humanoid.WalkSpeed = defaultSpeed -- Reset to original speed
            end
        end
    end)

    local player3 = game:GetService("Players").LocalPlayer
    local userInputService = game:GetService("UserInputService")
    local runService = game:GetService("RunService")
    local jumpBoost = 13.5 -- Small boost to avoid anti-cheat
    local jumpConnection = nil

    local JumpBoostToggle = Tabs.Misc:AddToggle("JumpBoostToggle", {
        Title = "Jump Boost",
        Default = false
    })

    local function applyJumpBoost(character)
        local humanoid = character:WaitForChild("Humanoid")
        local rootPart = character:WaitForChild("HumanoidRootPart")

        local function onJumpRequest()
            if humanoid:GetState() == Enum.HumanoidStateType.Jumping then
                rootPart.Velocity = Vector3.new(rootPart.Velocity.X, rootPart.Velocity.Y + jumpBoost, rootPart.Velocity.Z)
            end
        end

        if JumpBoostToggle.Value then
            jumpConnection = userInputService.JumpRequest:Connect(onJumpRequest)
        else
            if jumpConnection then
                jumpConnection:Disconnect()
                jumpConnection = nil
            end
        end
    end

    JumpBoostToggle:OnChanged(function(Value)
        if player3.Character then
            applyJumpBoost(player3.Character)
        end
        player3.CharacterAdded:Connect(applyJumpBoost)
    end)
    
    local BuildingBankToggle = Tabs.Misc:AddToggle("BuildingBankToggle", {
        Title = "Building Alerts",
        Description = "• Alerts for new buildings.",
        Default = false
    })
    
    BuildingBankToggle:OnChanged(function()
        BuildingBank.Enabled = BuildingBankToggle.Value
        if BuildingBank.Enabled then
            enableAlerts()
        else
            disableAlerts()
        end
    end)

    Tabs.Misc:AddButton({
        Title = "Camera Unlocker",
        Description = "• Unlock third-person view.",
        Callback = function()
            local player = game.Players.LocalPlayer
            local camera = game.Workspace.CurrentCamera
            -- Unlocks camera from first-person to third-person and zooms out
            local function unlockCamera()
                if player.CameraMode == Enum.CameraMode.Classic and player.CameraMaxZoomDistance >= 20 then
                    Fluent:Notify({
                        Title = "Ringta Scripts",
                        Content = "Camera is already unlocked!",
                        Duration = 3
                    })
                    return
                end
                player.CameraMode = Enum.CameraMode.Classic -- Allows third-person mode
                player.CameraMinZoomDistance = 0.5 -- Ensures zooming out is possible
                player.CameraMaxZoomDistance = 50 -- Allows third-person view
                camera.CameraSubject = player.Character and player.Character:FindFirstChild("Humanoid") or camera.CameraSubject
                camera.CameraType = Enum.CameraType.Custom
                Fluent:Notify({
                    Title = "Hutao HUB",
                    Content = "Unlocked third-person view!",
                    SubContent = "Zoom camera out.",
                    Duration = 10
                })
            end
            unlockCamera()
        end
    })
    
    local fullBrightEnabled1 = false
    local autoNightLoop 

    local function applyFullBright1()
        if not fullBrightEnabled1 then return end

        local hour = game.Lighting:GetMinutesAfterMidnight() / 60
        local isNight = (hour >= 18 or hour < 6)

        if isNight then
            game.Lighting.Ambient = Color3.new(1, 1, 1)
            game.Lighting.Brightness = 10
            game.Lighting.GlobalShadows = false
        else
            game.Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
            game.Lighting.Brightness = 1
            game.Lighting.GlobalShadows = true
        end
    end

    local function enableAutoFullBright()
        if autoNightLoop then autoNightLoop:Disconnect() end
        applyFullBright1()
        autoNightLoop = game.Lighting:GetPropertyChangedSignal("ClockTime"):Connect(applyFullBright1)
    end

    local function disableFullBright()
        if autoNightLoop then
            autoNightLoop:Disconnect()
            autoNightLoop = nil
        end
        game.Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
        game.Lighting.Brightness = 1
        game.Lighting.GlobalShadows = true
    end

    local FbToggle1 = Tabs.Misc:AddToggle("FbToggle1", {Title = "Auto Full Bright", Description = "Auto full bright when night.", Default = false })
    FbToggle1:OnChanged(function(Value)
        fullBrightEnabled1 = Value
        if fullBrightEnabled1 then
            enableAutoFullBright()
        else
            disableFullBright()
        end
    end)

    local lightingg = game:GetService("Lighting")
    local runService5 = game:GetService("RunService")
    local function removeFog()
        if lightingg.FogEnd ~= 1000000 then
            lightingg.FogEnd = 1000000
        end
        if lightingg.FogStart ~= 0 then
            lightingg.FogStart = 0
        end
        if lightingg:FindFirstChild("Atmosphere") then
            local atmosphere = lightingg.Atmosphere
            if atmosphere.Density ~= 0 then
                atmosphere.Density = 0
            end
            if atmosphere.Offset ~= 0 then
                atmosphere.Offset = 0
            end
            if atmosphere.Haze ~= 0 then
                atmosphere.Haze = 0
            end
            if atmosphere.Color ~= Color3.new(1, 1, 1) then
                atmosphere.Color = Color3.new(1, 1, 1)
            end
        end
    end

    local function restoreFog()
        lightingg.FogEnd = 1000 -- Default
        lightingg.FogStart = 200 -- Default
        if lightingg:FindFirstChild("Atmosphere") then
            local atmosphere = lightingg.Atmosphere
            atmosphere.Density = 0.3
            atmosphere.Offset = 0
            atmosphere.Haze = 0.5
            atmosphere.Color = Color3.fromRGB(200, 200, 200)
        end
    end

    local noFogEnabled = false
    local fogLoop

    local NoFogToggle = Tabs.Misc:AddToggle("NoFogToggle", {
        Title = "Remove Fog",
        Default = false
    })

    NoFogToggle:OnChanged(function(Value)
        noFogEnabled = Value

        if noFogEnabled then
            removeFog()
            fogLoop = runService5.Heartbeat:Connect(function()
                removeFog()
            end)
        else
            if fogLoop then
                fogLoop:Disconnect()
                fogLoop = nil
            end
            restoreFog()
        end
    end)

    Tabs.Misc:AddSection("↳ Bypass")

    local player = game:GetService("Players").LocalPlayer
    local UserInputService = game:GetService("UserInputService")
    local StarterGui = game:GetService("StarterGui")

    local BypassBandageT = Tabs.Misc:AddToggle("BypassBandageT", {
        Title = "Bypass Bandage Delay",
        Description = "Press 'R' to instantly use bandage.",
        Default = false
    })

    getgenv().bandageBypassEnabled = false
    local bandageButton
    local bandageConnection

    local function detectMobile()
        return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled
    end

    local bandageDebounce = false
    local function useBandage()
        if bandageDebounce then return end
        bandageDebounce = true

        local character = player.Character
        if character then
            local bandage = character:FindFirstChild("Bandage")
            if bandage and bandage:IsA("Tool") then
                bandage.Use:FireServer()
            end
        end

        bandageDebounce = false
    end

    BypassBandageT:OnChanged(function(Value)
        getgenv().bandageBypassEnabled = Value

        if not Value and bandageButton then
            bandageButton:Destroy()
            bandageButton = nil
        end

        if not Value and bandageConnection then
            bandageConnection:Disconnect()
            bandageConnection = nil
        end
    end)

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if getgenv().bandageBypassEnabled and input.KeyCode == Enum.KeyCode.R then
            useBandage()
        end
    end)

    local function createMobileButton()
        if bandageButton or not getgenv().bandageBypassEnabled or not detectMobile() then return end

        bandageButton = Instance.new("TextButton")
        bandageButton.Name = "BandageButton"
        bandageButton.Size = UDim2.new(0, 85, 0, 45) -- Medium Size
        bandageButton.Position = UDim2.new(0.88, 0, 0.75, 0) -- Next to Jump Button, Good Position
        bandageButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- White Background
        bandageButton.TextColor3 = Color3.fromRGB(0, 0, 0) -- Black Text
        bandageButton.Text = "Bandage"
        bandageButton.Font = Enum.Font.GothamBold
        bandageButton.TextSize = 18
        bandageButton.BackgroundTransparency = 0.2 -- Slight Transparency
        bandageButton.BorderSizePixel = 0
        bandageButton.AutoButtonColor = true
        bandageButton.Parent = StarterGui:SetCore("TopbarEnabled", false) and StarterGui

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 12)
        corner.Parent = bandageButton

        local shadow = Instance.new("UIStroke")
        shadow.Thickness = 2
        shadow.Color = Color3.fromRGB(0, 0, 0)
        shadow.Transparency = 0.5
        shadow.Parent = bandageButton

        bandageButton.MouseButton1Click:Connect(useBandage)
    end

    bandageConnection = player.Character.ChildAdded:Connect(function(child)
        if getgenv().bandageBypassEnabled and child:IsA("Tool") and child.Name == "Bandage" then
            createMobileButton()
        end
    end)


    local ReloadToggle = Tabs.Misc:AddToggle("ReloadToggle", {Title = "Bypass Reload Delay", Default = false})
    local ReloadStatus = false
    local originalReloadTimes = {}

    local function bypassReloadDelay()
        local player = game:GetService("Players").LocalPlayer

        while ReloadStatus do
            local character = player.Character
            if character then
                for _, tool in pairs(character:GetChildren()) do
                    if tool:IsA("Tool") and tool:FindFirstChild("WeaponConfiguration") then
                        local config = tool.WeaponConfiguration
                        local reloadDuration = config:FindFirstChild("ReloadDuration")
                        
                        if reloadDuration then
                            -- Save original reload time only once
                            if not originalReloadTimes[tool] then
                                originalReloadTimes[tool] = reloadDuration.Value
                            end
                            -- Set instant reload
                            reloadDuration.Value = 0
                        end
                    end
                end
            end
            task.wait(0.1) -- Prevents excessive looping
        end
    end

    local function restoreReloadDelay()
        local player = game:GetService("Players").LocalPlayer
        local character = player.Character

        if character then
            for _, tool in pairs(character:GetChildren()) do
                if tool:IsA("Tool") and tool:FindFirstChild("WeaponConfiguration") then
                    local config = tool.WeaponConfiguration
                    local reloadDuration = config:FindFirstChild("ReloadDuration")

                    if reloadDuration and originalReloadTimes[tool] then
                        reloadDuration.Value = originalReloadTimes[tool] -- Restore original reload time
                    end
                end
            end
        end
        table.clear(originalReloadTimes) -- Clear stored values after restoring
    end

    ReloadToggle:OnChanged(function(Value)
        ReloadStatus = Value
        if ReloadStatus then
            bypassReloadDelay()
        else
            restoreReloadDelay()
        end
    end)

    -- Ensure reload time is restored if character resets
    game.Players.LocalPlayer.CharacterAdded:Connect(function()
        if not ReloadStatus then
            restoreReloadDelay()
        end
    end)

    local FireDeToggle = Tabs.Misc:AddToggle("FireDeToggle", {Title = "Bypass Fire Delay", Default = false})
    local FireStatus = false
    local originalFireTimes = {}

    local function bypassFireDelay()
        local player = game:GetService("Players").LocalPlayer

        while FireStatus do
            local character = player.Character
            if character then
                for _, tool in pairs(character:GetChildren()) do
                    if tool:IsA("Tool") and tool:FindFirstChild("WeaponConfiguration") then
                        local config = tool.WeaponConfiguration
                        local fireDuration = config:FindFirstChild("FireDelay")
                        
                        if fireDuration then
                            -- Save original fire delay only once
                            if not originalFireTimes[tool] then
                                originalFireTimes[tool] = fireDuration.Value
                            end
                            -- Set instant fire rate
                            fireDuration.Value = 0.15
                        end
                    end
                end
            end
            task.wait(0.1) -- Prevents excessive looping
        end
    end

    local function restoreFireDelay()
        local player = game:GetService("Players").LocalPlayer
        local character = player.Character

        if character then
            for _, tool in pairs(character:GetChildren()) do
                if tool:IsA("Tool") and tool:FindFirstChild("WeaponConfiguration") then
                    local config = tool.WeaponConfiguration
                    local fireDuration = config:FindFirstChild("FireDelay")

                    if fireDuration and originalFireTimes[tool] then
                        fireDuration.Value = originalFireTimes[tool] -- Restore original fire delay
                    end
                end
            end
        end
        table.clear(originalFireTimes) -- Clear stored values after restoring
    end

    FireDeToggle:OnChanged(function(Value)
        FireStatus = Value
        if FireStatus then
            bypassFireDelay()
        else
            restoreFireDelay()
        end
    end)

    -- Ensure fire delay is restored if character resets
    game.Players.LocalPlayer.CharacterAdded:Connect(function()
        if not FireStatus then
            restoreFireDelay()
        end
    end)

    local UIS = game:GetService("UserInputService")
    local SkipHoldToggle = Tabs.Misc:AddToggle("SkipHoldToggle", {Title = "Bypass Hold Prompt", Default = false})

    local function skipHoldPrompt(prompt)
        if prompt and prompt:IsA("ProximityPrompt") and prompt.HoldDuration > 0 then
            -- Store original HoldDuration if not already stored
            if prompt:GetAttribute("OriginalHold") == nil then
                prompt:SetAttribute("OriginalHold", prompt.HoldDuration)
            end
            prompt.HoldDuration = 0 -- Remove hold time
        end
    end

    local function enableSkipHold()
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then
                skipHoldPrompt(obj)
            end
        end

        -- Ensure new prompts also get modified
        local connection
        connection = workspace.DescendantAdded:Connect(function(obj)
            task.wait(0.1) -- Prevent errors
            if SkipHoldToggle.Value then
                skipHoldPrompt(obj)
            else
                connection:Disconnect() -- Stop listening if disabled
            end
        end)
    end

    local function disableSkipHold()
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then
                local originalHold = obj:GetAttribute("OriginalHold")
                if originalHold then
                    obj.HoldDuration = originalHold -- Restore original HoldDuration
                    obj:SetAttribute("OriginalHold", nil) -- Remove stored attribute
                end
            end
        end
    end

    SkipHoldToggle:OnChanged(function()
        if SkipHoldToggle.Value then
            enableSkipHold()
        else
            disableSkipHold()
        end
    end)

    Tabs.Misc:AddSection("↳ MISC")

    local FpsbfToggle1 = Tabs.Misc:AddToggle("FpsbfToggle1", {Title = "FPS Boost", Default = false })
    FpsbfToggle1:OnChanged(function(Value)
        if Value then
            for _, v in pairs(game:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.Material = Enum.Material.SmoothPlastic
                    v.Reflectance = 0
                end
            end
        end
    end)

    getgenv().antiAfkEnabled = true
    local afkConnection

    local AntiAfkToggle = Tabs.Misc:AddToggle("AntiAfkToggle", {
        Title = "Anti Idle",
        Default = true
    })

    local function startAntiAfk()
        local player = game:GetService("Players").LocalPlayer
        local virtualUser = game:GetService("VirtualUser")
        if afkConnection then afkConnection:Disconnect() end
        afkConnection = player.Idled:Connect(function()
            if getgenv().antiAfkEnabled then
                virtualUser:CaptureController()
                virtualUser:ClickButton2(Vector2.new()) -- Simulates user activity
            end
        end)
    end

    AntiAfkToggle:OnChanged(function(Value)
        getgenv().antiAfkEnabled = Value
        if Value then
            Fluent:Notify({
                Title = "Ringta",
                Content = "Anti idle is enabled!",
                Duration = 5
            })
            startAntiAfk()
        else
            Fluent:Notify({
                Title = "Ringta",
                Content = "Anti idle is disabled!",
                Duration = 5
            })
            if afkConnection then
                afkConnection:Disconnect()
                afkConnection = nil
            end
        end
    end)

end

local AexecToggle = Tabs.Settings:AddToggle("AexecToggle", {Title = "Auto Execute", Default = false })
AexecToggle:OnChanged(function(Value)
    if Value then
        task.spawn(function()
            pcall(function()
                if queue_on_teleport then
                    local SkullHubScript1 = [[
task.wait(3)
loadstring(game:HttpGet('https://raw.githubusercontent.com/hungquan99/SkullHub/main/loader.lua'))()
]]
                    queue_on_teleport(SkullHubScript1)
                end
            end)
        end)
        Fluent:Notify({
            Title = "RINGTA HUB",
            Content = "Auto execute is enabled!",
            Duration = 5
        })
    else
        Fluent:Notify({
            Title = "RINGTA SCRIPTS",
            Content = "Auto execute is disabled!",
            Duration = 5
        })
    end
end)

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- You can add indexes of elements the save manager should ignore
SaveManager:SetIgnoreIndexes({})

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
InterfaceManager:SetFolder("Ringta Scripts")
SaveManager:SetFolder("Ringta X BIGBACK/Dead Rails")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

-- Select First Tab By Default
Window:SelectTab(1)

Fluent:Notify({ Title = "Ringta Scripts", Content = "Dead Rails script loaded successfully!", Duration = 5 })
SaveManager:LoadAutoloadConfig()








------ button





-- 🟢 DRAGGABLE UI BUTTON WITH ENHANCED CLICK AND HOVER ANIMATIONS
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local ExistingUI = CoreGui:FindFirstChild("SkullHubMinimizeUI")
if ExistingUI then
    ExistingUI:Destroy()
end

-- Create Floating UI
local DragUI = Instance.new("ScreenGui")
DragUI.Name = "SkullHubMinimizeUI"
DragUI.ResetOnSpawn = false
DragUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling -- Ensures highest rendering priority
DragUI.Parent = CoreGui -- Overrides all other UI elements

-- Create Circular Button (Draggable + Clickable)
local Button = Instance.new("ImageButton")
Button.Parent = DragUI
Button.Size = UDim2.new(0, 50, 0, 50) -- Adjust size if needed
Button.Position = UDim2.new(0, 10, 1, -85) -- Initial position
Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Windows 11 Style
Button.BackgroundTransparency = 0.3 -- Semi-transparent
Button.BorderSizePixel = 0
Button.ClipsDescendants = true
Button.Image = "rbxassetid://90508203972003" -- Replace with your custom image ID
Button.ScaleType = Enum.ScaleType.Fit
Button.Active = true -- Allows drag functionality
Button.ZIndex = 1000 -- Ensure it stays on top

-- Make UI Circular
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0) -- Full circle
UICorner.Parent = Button

-- Tween Info for Animations
local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Function to simulate RightShift key press
local function SimulateKeyPress()
    VirtualInputManager:SendKeyEvent(true, minimizeUI, false, game)
    task.wait(0.1)
    VirtualInputManager:SendKeyEvent(false, minimizeUI, false, game)
end

-- Click Animation & UI Toggle (Only if NOT dragged too much)
local isDragging = false
local dragThreshold = 10 -- Allow small movement without canceling click

Button.MouseButton1Click:Connect(function()
    if isDragging then return end -- Prevent click after large dragging

    -- Enhanced Click Animation
    local tween = TweenService:Create(Button, tweenInfo, {
        BackgroundTransparency = 0.5,
        Size = UDim2.new(0, 45, 0, 45),
        Rotation = 5
    })
    tween:Play()
    task.wait(0.1)
    local tweenBack = TweenService:Create(Button, tweenInfo, {
        BackgroundTransparency = 0.3,
        Size = UDim2.new(0, 50, 0, 50),
        Rotation = 0
    })
    tweenBack:Play()

    -- Simulate RightShift to Toggle UI
    SimulateKeyPress()
end)

-- Hover Animation
Button.MouseEnter:Connect(function()
    TweenService:Create(Button, tweenInfo, {Size = UDim2.new(0, 55, 0, 55)}):Play()
end)

Button.MouseLeave:Connect(function()
    TweenService:Create(Button, tweenInfo, {Size = UDim2.new(0, 50, 0, 50)}):Play()
end)

-- Dragging Logic for PC & Mobile
local dragging, dragStart, startPos

local function StartDrag(input)
    isDragging = false -- Reset dragging state
    dragging = true
    dragStart = input.Position
    startPos = Button.Position

    input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End then
            dragging = false
        end
    end)
end

local function OnDrag(input)
    if dragging then
        local delta = (input.Position - dragStart).Magnitude
        if delta > dragThreshold then -- Only mark as dragged if movement exceeds threshold
            isDragging = true
        end
        Button.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + (input.Position.X - dragStart.X),
            startPos.Y.Scale,
            startPos.Y.Offset + (input.Position.Y - dragStart.Y)
        )
    end
end

-- Dragging Support for PC & Mobile (on the same button)
Button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        StartDrag(input)
    end
end)

Button.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        OnDrag(input)
    end
end)
