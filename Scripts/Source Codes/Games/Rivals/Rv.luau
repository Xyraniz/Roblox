local myScriptCode = [[
if _G.__rivals_loaded then
    warn("[rivals] already running — blocked duplicate execution.")
    return
end
_G.__rivals_loaded = true

local VirtualInputManager = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")

local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local CACHE_FILE = "rivals_settings.json"
local ESP_BOX_COLOR = Color3.fromRGB(255, 255, 255)

local DefaultSettings = {
    ESP_Enabled = true,
    ESP_Highlight = true,
    ESP_Name = true,
    ESP_Studs = true,
    ESP_Tracer = false,
    ESP_BoxTransparency = 0.5,
    ESP_MaxDistance = 500,
    Aimbot_Enabled = true,
    Aimbot_FOVRadius = 100,
    Aimbot_WallCheck = false,
    Aimbot_Smoothness = 1,
    Triggerbot_Enabled = true,
    Triggerbot_MaxDistance = 1000,
    Triggerbot_FOVRadius = 50,
    InfJump_Enabled = false,
    DeviceSpoofer_Active = nil,
}

local function loadSettings()
    local ok, result = pcall(function()
        if isfile and isfile(CACHE_FILE) then
            local raw = readfile(CACHE_FILE)
            local decoded = HttpService:JSONDecode(raw)
            for k, v in pairs(DefaultSettings) do
                if decoded[k] == nil then decoded[k] = v end
            end
            return decoded
        end
    end)
    if ok and result then return result end
    local t = {}
    for k, v in pairs(DefaultSettings) do t[k] = v end
    return t
end

local SERIALIZABLE_TYPES = { boolean = true, number = true, string = true }

local function saveSettings(s)
    pcall(function()
        if writefile then
            local clean = {}
            for k, v in pairs(s) do
                if SERIALIZABLE_TYPES[typeof(v)] or v == nil then
                    clean[k] = v
                end
            end
            writefile(CACHE_FILE, HttpService:JSONEncode(clean))
        end
    end)
end

local Settings = loadSettings()

if Settings.ESP_Tracer == nil and Settings.ESP_Snapline ~= nil then
    Settings.ESP_Tracer = Settings.ESP_Snapline
end
Settings.ESP_Snapline = nil
Settings.Triggerbot_MaxDistance = 1000

local SetControlsRemote = nil
pcall(function()
    SetControlsRemote = ReplicatedStorage
        :WaitForChild("Remotes", 5)
        :WaitForChild("Replication", 5)
        :WaitForChild("Fighter", 5)
        :WaitForChild("SetControls", 5)
end)

local function spoofDevice(deviceValue)
    if not SetControlsRemote then return end
    pcall(function() SetControlsRemote:FireServer(deviceValue) end)
end

local function reapplySpooferOnLoad()
    if Settings.DeviceSpoofer_Active then
        task.wait(1.5)
        spoofDevice(Settings.DeviceSpoofer_Active)
    end
end

LocalPlayer.CharacterAdded:Connect(function(character)
    character.ChildAdded:Connect(function(child)
        if child.Name == "HumanoidRootPart" then
            reapplySpooferOnLoad()
        end
    end)
end)

if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
    reapplySpooferOnLoad()
end

local function isVoteScreenActive()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return false end
    local mainGui = playerGui:FindFirstChild("MainGUI")
    if not mainGui then return false end
    local mainFrame = mainGui:FindFirstChild("MainFrame")
    if not mainFrame then return false end
    local di1 = mainFrame:FindFirstChild("DuelInterface")
    if not di1 then return false end
    local di2 = di1:FindFirstChild("DuelInterface")
    if not di2 then return false end
    local voting = di2:FindFirstChild("Voting")
    if not voting then return false end
    if voting.Visible then return true end
    local maps = voting:FindFirstChild("Maps")
    if not maps then return false end
    if maps.Visible then return true end
    local mapsList = maps:FindFirstChild("MapsList")
    return mapsList ~= nil
end

local function isInActiveRound()
    local character = LocalPlayer.Character
    if not character then return false end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return false end
    if not character:FindFirstChild("HumanoidRootPart") then return false end
    if isVoteScreenActive() then return false end
    return true
end

local function purgeStartupBlurs()
    for _, v in ipairs(Lighting:GetChildren()) do
        if v:IsA("BlurEffect") and v.Name == "StartupBlur" then
            v:Destroy()
        end
    end
end

local function ShowStartup()
    purgeStartupBlurs()
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    local oldStartup = playerGui:FindFirstChild("StartupOverlay")
    if oldStartup then oldStartup:Destroy() end

    local startupGui = Instance.new("ScreenGui")
    startupGui.Name = "StartupOverlay"
    startupGui.ResetOnSpawn = false
    startupGui.IgnoreGuiInset = true
    startupGui.DisplayOrder = 1000
    startupGui.Parent = playerGui

    local lightingBlur = Instance.new("BlurEffect")
    lightingBlur.Name = "StartupBlur"
    lightingBlur.Size = 18
    lightingBlur.Parent = Lighting

    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.fromScale(1, 1)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.18
    overlay.BorderSizePixel = 0
    overlay.Parent = startupGui

    local card = Instance.new("Frame")
    card.AnchorPoint = Vector2.new(0.5, 0.5)
    card.Position = UDim2.fromScale(0.5, 0.5)
    card.Size = UDim2.fromOffset(430, 210)
    card.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    card.BorderSizePixel = 0
    card.Parent = overlay
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 14)

    local cardStroke = Instance.new("UIStroke")
    cardStroke.Color = Color3.fromRGB(45, 45, 45)
    cardStroke.Thickness = 1
    cardStroke.Transparency = 0.15
    cardStroke.Parent = card

    local title = Instance.new("TextLabel")
    title.AnchorPoint = Vector2.new(0.5, 0.5)
    title.Position = UDim2.new(0.5, 0, 0.36, 0)
    title.Size = UDim2.new(1, -40, 0, 40)
    title.BackgroundTransparency = 1
    title.Text = "Rivals Controls"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 25
    title.Font = Enum.Font.GothamBold
    title.Parent = card

    local subtitle = Instance.new("TextLabel")
    subtitle.AnchorPoint = Vector2.new(0.5, 0.5)
    subtitle.Position = UDim2.new(0.5, 0, 0.55, 0)
    subtitle.Size = UDim2.new(1, -40, 0, 28)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = isMobile
        and "Press the UI button to open the menu"
        or  "Press Right Control to open the menu"
    subtitle.TextColor3 = Color3.fromRGB(165, 165, 165)
    subtitle.TextSize = 16
    subtitle.Font = Enum.Font.GothamMedium
    subtitle.Parent = card

    local line = Instance.new("Frame")
    line.AnchorPoint = Vector2.new(0.5, 0.5)
    line.Position = UDim2.new(0.5, 0, 0.70, 0)
    line.Size = UDim2.new(0.72, 0, 0, 1)
    line.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    line.BorderSizePixel = 0
    line.Parent = card

    local credit = Instance.new("TextLabel")
    credit.AnchorPoint = Vector2.new(0.5, 0.5)
    credit.Position = UDim2.new(0.5, 0, 0.84, 0)
    credit.Size = UDim2.new(1, -40, 0, 25)
    credit.BackgroundTransparency = 1
    credit.Text = "by yes.dev"
    credit.TextColor3 = Color3.fromRGB(125, 125, 125)
    credit.TextSize = 14
    credit.Font = Enum.Font.GothamMedium
    credit.Parent = card

    task.delay(3, function()
        if not startupGui.Parent then purgeStartupBlurs() return end
        local fade = TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(overlay,  fade, { BackgroundTransparency = 1 }):Play()
        TweenService:Create(card,     fade, { BackgroundTransparency = 1 }):Play()
        TweenService:Create(title,    fade, { TextTransparency = 1 }):Play()
        TweenService:Create(subtitle, fade, { TextTransparency = 1 }):Play()
        TweenService:Create(credit,   fade, { TextTransparency = 1 }):Play()
        TweenService:Create(line,     fade, { BackgroundTransparency = 1 }):Play()
        task.wait(0.5)
        purgeStartupBlurs()
        if startupGui.Parent then startupGui:Destroy() end
    end)
end

ShowStartup()

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MenuGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local BackgroundFrame = Instance.new("Frame")
BackgroundFrame.Size = UDim2.fromScale(1, 1)
BackgroundFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BackgroundFrame.BackgroundTransparency = 0.45
BackgroundFrame.BorderSizePixel = 0
BackgroundFrame.Visible = false
BackgroundFrame.ZIndex = 100
BackgroundFrame.Parent = ScreenGui

local MenuFrame = Instance.new("Frame")
MenuFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MenuFrame.Size = UDim2.fromOffset(390, 0)
MenuFrame.Position = UDim2.fromScale(0.5, 0.5)
MenuFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MenuFrame.BorderSizePixel = 0
MenuFrame.Visible = false
MenuFrame.ZIndex = 101
MenuFrame.Parent = ScreenGui
Instance.new("UICorner", MenuFrame).CornerRadius = UDim.new(0, 14)

local MenuStroke = Instance.new("UIStroke")
MenuStroke.Color = Color3.fromRGB(42, 42, 42)
MenuStroke.Thickness = 1
MenuStroke.Transparency = 0.1
MenuStroke.Parent = MenuFrame

local MenuTitle = Instance.new("TextLabel")
MenuTitle.Size = UDim2.new(1, -40, 0, 42)
MenuTitle.Position = UDim2.new(0, 20, 0, 12)
MenuTitle.BackgroundTransparency = 1
MenuTitle.Text = "Rivals Controls"
MenuTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
MenuTitle.Font = Enum.Font.GothamBold
MenuTitle.TextSize = 25
MenuTitle.TextXAlignment = Enum.TextXAlignment.Left
MenuTitle.ZIndex = 102
MenuTitle.Parent = MenuFrame

local MenuSubtitle = Instance.new("TextLabel")
MenuSubtitle.Size = UDim2.new(1, -40, 0, 20)
MenuSubtitle.Position = UDim2.new(0, 20, 0, 45)
MenuSubtitle.BackgroundTransparency = 1
MenuSubtitle.Text = "Triggerbot, ESP and Aimbot"
MenuSubtitle.TextColor3 = Color3.fromRGB(105, 105, 105)
MenuSubtitle.Font = Enum.Font.GothamMedium
MenuSubtitle.TextSize = 13
MenuSubtitle.TextXAlignment = Enum.TextXAlignment.Left
MenuSubtitle.ZIndex = 102
MenuSubtitle.Parent = MenuFrame

local ToggleContainer = Instance.new("Frame")
ToggleContainer.Size = UDim2.new(1, -30, 0, 0)
ToggleContainer.Position = UDim2.new(0, 15, 0, 70)
ToggleContainer.BackgroundTransparency = 1
ToggleContainer.BorderSizePixel = 0
ToggleContainer.AutomaticSize = Enum.AutomaticSize.Y
ToggleContainer.ZIndex = 103
ToggleContainer.Parent = MenuFrame

local ToggleList = Instance.new("UIListLayout")
ToggleList.Padding = UDim.new(0, 5)
ToggleList.SortOrder = Enum.SortOrder.LayoutOrder
ToggleList.HorizontalAlignment = Enum.HorizontalAlignment.Center
ToggleList.Parent = ToggleContainer

local SYNC_DURATION = 0.22
local SYNC_TWEEN    = TweenInfo.new(SYNC_DURATION, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

local toggleButtons  = {}
local espChildren    = {}
local aimbotChildren = {}
local updateFOVVisual   = nil
local updateFOVPosition = nil

local function makeCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = parent
    return c
end

local function makeIndicator(parent)
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.fromOffset(9, 9)
    indicator.Position = UDim2.new(1, -23, 0.5, -4.5)
    indicator.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    indicator.BorderSizePixel = 0
    indicator.ZIndex = parent.ZIndex + 1
    indicator.Parent = parent
    makeCorner(indicator, 5)
    return indicator
end

local function recalcMenuHeight()
    task.defer(function()
        task.wait(0.05)
        local h = ToggleContainer.AbsoluteSize.Y
        if h > 0 then
            MenuFrame.Size = UDim2.new(0, 390, 0, 70 + h + 15)
        end
    end)
end

local function updateAllSubToggles()
    for _, update in ipairs(espChildren)    do update() end
    for _, update in ipairs(aimbotChildren) do update() end
    if updateFOVPosition then updateFOVPosition() end
end

local function createMasterToggle(name, getState, setState, order)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -6, 0, 39)
    button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    button.BorderSizePixel = 0
    button.Text = ""
    button.AutoButtonColor = false
    button.LayoutOrder = order
    button.ZIndex = 104
    button.Parent = ToggleContainer
    makeCorner(button, 9)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -45, 1, 0)
    label.Position = UDim2.new(0, 14, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(235, 235, 235)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 15
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 105
    label.Parent = button

    local indicator = makeIndicator(button)

    local function updateVisual()
        indicator.BackgroundColor3 = getState()
            and Color3.fromRGB(0, 190, 85)
            or  Color3.fromRGB(100, 100, 100)
    end

    button.MouseButton1Click:Connect(function()
        setState(not getState())
        updateVisual()
        updateAllSubToggles()
        saveSettings(Settings)
    end)

    updateVisual()
    toggleButtons[button] = updateVisual
    return button
end

local function createChildGroup(masterGetter, order)
    local group = Instance.new("Frame")
    group.Size = UDim2.new(1, -8, 0, 0)
    group.BackgroundTransparency = 1
    group.BorderSizePixel = 0
    group.AutomaticSize = Enum.AutomaticSize.Y
    group.LayoutOrder = order
    group.ZIndex = 103
    group.Parent = ToggleContainer

    local branch = Instance.new("Frame")
    branch.Size = UDim2.new(0, 2, 1, 0)
    branch.Position = UDim2.new(0, 22, 0, 0)
    branch.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    branch.BorderSizePixel = 0
    branch.ZIndex = 104
    branch.Parent = group
    makeCorner(branch, 1)

    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -48, 0, 0)
    content.Position = UDim2.new(0, 42, 0, 0)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.AutomaticSize = Enum.AutomaticSize.Y
    content.ZIndex = 105
    content.Parent = group

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 4)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = content

    return { Group = group, Branch = branch, Content = content, MasterGetter = masterGetter }
end

local function createChildToggle(name, getState, setState, masterGetter, list, parentGroup, order)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 32)
    button.BackgroundColor3 = Color3.fromRGB(23, 23, 23)
    button.BorderSizePixel = 0
    button.Text = ""
    button.AutoButtonColor = false
    button.LayoutOrder = order
    button.ZIndex = 105
    button.Parent = parentGroup.Content
    makeCorner(button, 8)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -42, 1, 0)
    label.Position = UDim2.new(0, 14, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(205, 205, 205)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 106
    label.Parent = button

    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.fromOffset(8, 8)
    indicator.Position = UDim2.new(1, -20, 0.5, -4)
    indicator.BackgroundColor3 = Color3.fromRGB(95, 95, 95)
    indicator.BorderSizePixel = 0
    indicator.ZIndex = 106
    indicator.Parent = button
    makeCorner(indicator, 4)

    local function updateVisual()
        local masterEnabled = masterGetter()
        if not masterEnabled then
            button.BackgroundColor3    = Color3.fromRGB(16, 16, 16)
            label.TextColor3           = Color3.fromRGB(65, 65, 65)
            indicator.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            parentGroup.Branch.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
        else
            button.BackgroundColor3    = Color3.fromRGB(23, 23, 23)
            label.TextColor3           = Color3.fromRGB(205, 205, 205)
            indicator.BackgroundColor3 = getState()
                and Color3.fromRGB(0, 190, 85)
                or  Color3.fromRGB(95, 95, 95)
            parentGroup.Branch.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        end
    end

    button.MouseButton1Click:Connect(function()
        if not masterGetter() then return end
        setState(not getState())
        updateVisual()
        saveSettings(Settings)
    end)

    updateVisual()
    toggleButtons[button] = updateVisual
    table.insert(list, updateVisual)
    return button
end

local function createChildSlider(name, getMaster, parentGroup, order)
    local wrapper = Instance.new("Frame")
    wrapper.Size = UDim2.new(1, 0, 0, 47)
    wrapper.BackgroundTransparency = 1
    wrapper.BorderSizePixel = 0
    wrapper.LayoutOrder = order
    wrapper.ZIndex = 105
    wrapper.Parent = parentGroup.Content

    local content = Instance.new("Frame")
    content.Size = UDim2.fromScale(1, 1)
    content.BackgroundTransparency = 1
    content.ZIndex = 105
    content.Parent = wrapper

    local sliderLabel = Instance.new("TextLabel")
    sliderLabel.Size = UDim2.new(1, 0, 0, 18)
    sliderLabel.BackgroundTransparency = 1
    sliderLabel.Text = name .. ": " .. tostring(Settings.Aimbot_FOVRadius)
    sliderLabel.TextColor3 = Color3.fromRGB(205, 205, 205)
    sliderLabel.Font = Enum.Font.GothamMedium
    sliderLabel.TextSize = 13
    sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    sliderLabel.ZIndex = 106
    sliderLabel.Parent = content

    local sliderLine = Instance.new("Frame")
    sliderLine.Size = UDim2.new(1, -12, 0, 4)
    sliderLine.Position = UDim2.new(0, 6, 0, 29)
    sliderLine.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
    sliderLine.BorderSizePixel = 0
    sliderLine.ZIndex = 105
    sliderLine.Parent = content
    makeCorner(sliderLine, 2)

    local sliderHandle = Instance.new("TextButton")
    sliderHandle.Size = UDim2.fromOffset(16, 16)
    sliderHandle.Position = UDim2.new(0, -8, 0, 23)
    sliderHandle.BackgroundColor3 = Color3.fromRGB(170, 170, 170)
    sliderHandle.BorderSizePixel = 0
    sliderHandle.Text = ""
    sliderHandle.AutoButtonColor = false
    sliderHandle.ZIndex = 107
    sliderHandle.Parent = content
    makeCorner(sliderHandle, 8)

    local sliderDragging = false

    local function updateSliderVisual()
        local enabled = getMaster()
        if enabled then
            sliderLabel.TextColor3        = Color3.fromRGB(205, 205, 205)
            sliderLine.BackgroundColor3   = Color3.fromRGB(65, 65, 65)
            sliderHandle.BackgroundColor3 = Color3.fromRGB(175, 175, 175)
            parentGroup.Branch.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        else
            sliderLabel.TextColor3        = Color3.fromRGB(65, 65, 65)
            sliderLine.BackgroundColor3   = Color3.fromRGB(35, 35, 35)
            sliderHandle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            parentGroup.Branch.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
        end
    end

    local function updateSliderPosition()
        local lineWidth = sliderLine.AbsoluteSize.X
        if lineWidth > 0 then
            local alpha = math.clamp(Settings.Aimbot_FOVRadius / 500, 20 / 500, 1)
            sliderHandle.Position = UDim2.new(0, alpha * lineWidth - 8, 0, 23)
        end
        sliderLabel.Text = name .. ": " .. tostring(Settings.Aimbot_FOVRadius)
    end

    sliderHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and getMaster() then
            sliderDragging = true
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            sliderDragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if not sliderDragging or not getMaster() then
            sliderDragging = false
            return
        end
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            local mouseX     = input.Position.X
            local lineStartX = sliderLine.AbsolutePosition.X
            local lineWidth  = sliderLine.AbsoluteSize.X
            if lineWidth > 0 then
                local relative     = math.clamp(mouseX - lineStartX, 0, lineWidth)
                local rawValue     = (relative / lineWidth) * 500
                local snappedValue = math.floor((rawValue + 2.5) / 5) * 5
                Settings.Aimbot_FOVRadius = math.clamp(snappedValue, 20, 500)
                sliderLabel.Text = name .. ": " .. tostring(Settings.Aimbot_FOVRadius)
                sliderHandle.Position = UDim2.new(0, relative - 8, 0, 23)
                saveSettings(Settings)
            end
        end
    end)

    task.defer(updateSliderPosition)
    task.defer(updateSliderVisual)
    return wrapper, updateSliderVisual, updateSliderPosition
end

createMasterToggle("Triggerbot",
    function() return Settings.Triggerbot_Enabled end,
    function(v) Settings.Triggerbot_Enabled = v end, 1)

createMasterToggle("Inf Jump",
    function() return Settings.InfJump_Enabled end,
    function(v) Settings.InfJump_Enabled = v end, 2)

createMasterToggle("ESP Master",
    function() return Settings.ESP_Enabled end,
    function(v) Settings.ESP_Enabled = v end, 3)

local espGroup = createChildGroup(function() return Settings.ESP_Enabled end, 4)

createChildToggle("Highlight",
    function() return Settings.ESP_Highlight end,
    function(v) Settings.ESP_Highlight = v end,
    function() return Settings.ESP_Enabled end,
    espChildren, espGroup, 1)

createChildToggle("Name",
    function() return Settings.ESP_Name end,
    function(v) Settings.ESP_Name = v end,
    function() return Settings.ESP_Enabled end,
    espChildren, espGroup, 2)

createChildToggle("Studs",
    function() return Settings.ESP_Studs end,
    function(v) Settings.ESP_Studs = v end,
    function() return Settings.ESP_Enabled end,
    espChildren, espGroup, 3)

createChildToggle("Tracer",
    function() return Settings.ESP_Tracer end,
    function(v) Settings.ESP_Tracer = v end,
    function() return Settings.ESP_Enabled end,
    espChildren, espGroup, 4)

createMasterToggle("Aimbot",
    function() return Settings.Aimbot_Enabled end,
    function(v) Settings.Aimbot_Enabled = v end, 5)

local aimbotGroup = createChildGroup(function() return Settings.Aimbot_Enabled end, 6)

createChildToggle("Wall Check",
    function() return Settings.Aimbot_WallCheck end,
    function(v) Settings.Aimbot_WallCheck = v end,
    function() return Settings.Aimbot_Enabled end,
    aimbotChildren, aimbotGroup, 1)

local _, fovVisual, fovPosition = createChildSlider("Aimbot FOV",
    function() return Settings.Aimbot_Enabled end,
    aimbotGroup, 2)

updateFOVVisual   = fovVisual
updateFOVPosition = fovPosition
table.insert(aimbotChildren, updateFOVVisual)

updateAllSubToggles()

local SPOOFER_DEVICES = {
    { label = "PC  (Mouse & Keyboard)", value = "MouseKeyboard" },
    { label = "Console  (Gamepad)",      value = "Gamepad"       },
    { label = "Mobile  (Touch)",         value = "Touch"         },
    { label = "VR",                      value = "VR"            },
}

local spooferExpanded   = false
local activeDeviceValue = Settings.DeviceSpoofer_Active
local deviceDotUpdaters = {}

local DRAWER_ROW_H = 32
local DRAWER_GAP   = 4
local DRAWER_PAD_T = 6
local DRAWER_PAD_B = 4

local function drawerTargetHeight()
    local n = #SPOOFER_DEVICES
    return DRAWER_PAD_T + n * DRAWER_ROW_H + (n - 1) * DRAWER_GAP + DRAWER_PAD_B
end

local spooferWrapper = Instance.new("Frame")
spooferWrapper.Size = UDim2.new(1, -6, 0, 0)
spooferWrapper.BackgroundTransparency = 1
spooferWrapper.BorderSizePixel = 0
spooferWrapper.AutomaticSize = Enum.AutomaticSize.Y
spooferWrapper.LayoutOrder = 7
spooferWrapper.ZIndex = 103
spooferWrapper.Parent = ToggleContainer

local wrapperLayout = Instance.new("UIListLayout")
wrapperLayout.Padding = UDim.new(0, 0)
wrapperLayout.SortOrder = Enum.SortOrder.LayoutOrder
wrapperLayout.Parent = spooferWrapper

local spooferHeader = Instance.new("TextButton")
spooferHeader.Size = UDim2.new(1, 0, 0, 39)
spooferHeader.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
spooferHeader.BorderSizePixel = 0
spooferHeader.Text = ""
spooferHeader.AutoButtonColor = false
spooferHeader.LayoutOrder = 1
spooferHeader.ZIndex = 104
spooferHeader.Parent = spooferWrapper
makeCorner(spooferHeader, 9)

local spooferLabel = Instance.new("TextLabel")
spooferLabel.Size = UDim2.new(1, -50, 1, 0)
spooferLabel.Position = UDim2.new(0, 14, 0, 0)
spooferLabel.BackgroundTransparency = 1
spooferLabel.Text = "Device Spoofer"
spooferLabel.TextColor3 = Color3.fromRGB(235, 235, 235)
spooferLabel.Font = Enum.Font.GothamBold
spooferLabel.TextSize = 15
spooferLabel.TextXAlignment = Enum.TextXAlignment.Left
spooferLabel.ZIndex = 105
spooferLabel.Parent = spooferHeader

local arrowLabel = Instance.new("TextLabel")
arrowLabel.Size = UDim2.fromOffset(24, 24)
arrowLabel.Position = UDim2.new(1, -30, 0.5, -12)
arrowLabel.AnchorPoint = Vector2.new(0, 0)
arrowLabel.BackgroundTransparency = 1
arrowLabel.Text = "▲"
arrowLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
arrowLabel.Font = Enum.Font.GothamBold
arrowLabel.TextSize = 12
arrowLabel.TextXAlignment = Enum.TextXAlignment.Center
arrowLabel.TextYAlignment = Enum.TextYAlignment.Center
arrowLabel.Rotation = 0
arrowLabel.ZIndex = 106
arrowLabel.Parent = spooferHeader

local spooferDrawer = Instance.new("Frame")
spooferDrawer.Size = UDim2.new(1, 0, 0, 0)
spooferDrawer.BackgroundTransparency = 1
spooferDrawer.BorderSizePixel = 0
spooferDrawer.ClipsDescendants = true
spooferDrawer.AutomaticSize = Enum.AutomaticSize.None
spooferDrawer.LayoutOrder = 2
spooferDrawer.ZIndex = 103
spooferDrawer.Parent = spooferWrapper

local drawerInner = Instance.new("Frame")
drawerInner.Size = UDim2.new(1, 0, 0, 0)
drawerInner.Position = UDim2.new(0, 0, 0, DRAWER_PAD_T)
drawerInner.BackgroundTransparency = 1
drawerInner.BorderSizePixel = 0
drawerInner.AutomaticSize = Enum.AutomaticSize.Y
drawerInner.ZIndex = 104
drawerInner.Parent = spooferDrawer

local drawerLayout = Instance.new("UIListLayout")
drawerLayout.Padding = UDim.new(0, DRAWER_GAP)
drawerLayout.SortOrder = Enum.SortOrder.LayoutOrder
drawerLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
drawerLayout.Parent = drawerInner

local function refreshDeviceDots()
    for _, fn in ipairs(deviceDotUpdaters) do fn() end
end

local function createDeviceRow(deviceLabel, deviceValue, rowOrder)
    local row = Instance.new("TextButton")
    row.Size = UDim2.new(1, -8, 0, DRAWER_ROW_H)
    row.BackgroundColor3 = Color3.fromRGB(23, 23, 23)
    row.BorderSizePixel = 0
    row.Text = ""
    row.AutoButtonColor = false
    row.LayoutOrder = rowOrder
    row.ZIndex = 105
    row.Parent = drawerInner
    makeCorner(row, 8)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -42, 1, 0)
    lbl.Position = UDim2.new(0, 14, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = deviceLabel
    lbl.TextColor3 = Color3.fromRGB(205, 205, 205)
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 106
    lbl.Parent = row

    local dot = Instance.new("Frame")
    dot.Size = UDim2.fromOffset(8, 8)
    dot.Position = UDim2.new(1, -20, 0.5, -4)
    dot.BorderSizePixel = 0
    dot.ZIndex = 106
    dot.Parent = row
    makeCorner(dot, 4)

    local function updateVisual()
        dot.BackgroundColor3 = (activeDeviceValue == deviceValue)
            and Color3.fromRGB(0, 190, 85)
            or  Color3.fromRGB(60, 60, 60)
    end

    row.MouseButton1Click:Connect(function()
        if activeDeviceValue == deviceValue then
            activeDeviceValue = nil
            Settings.DeviceSpoofer_Active = nil
            pcall(function()
                if SetControlsRemote then
                    SetControlsRemote:FireServer("MouseKeyboard")
                end
            end)
        else
            activeDeviceValue = deviceValue
            Settings.DeviceSpoofer_Active = deviceValue
            spoofDevice(deviceValue)
        end
        refreshDeviceDots()
        saveSettings(Settings)
    end)

    updateVisual()
    table.insert(deviceDotUpdaters, updateVisual)
end

for i, device in ipairs(SPOOFER_DEVICES) do
    createDeviceRow(device.label, device.value, i)
end

local drawerAnimating = false

local function getContainerHeightWith(extraH)
    local baseH = 0
    for _, child in ipairs(ToggleContainer:GetChildren()) do
        if (child:IsA("Frame") or child:IsA("TextButton")) and child ~= spooferWrapper then
            baseH = baseH + child.AbsoluteSize.Y + 5
        end
    end
    return baseH + spooferHeader.AbsoluteSize.Y + extraH
end

local function openDrawer()
    if drawerAnimating then return end
    drawerAnimating = true
    spooferDrawer.Visible = true
    local drawerH = drawerTargetHeight()
    local menuH   = 70 + getContainerHeightWith(drawerH) + 15
    TweenService:Create(spooferDrawer, SYNC_TWEEN, { Size = UDim2.new(1, 0, 0, drawerH) }):Play()
    TweenService:Create(MenuFrame, SYNC_TWEEN, { Size = UDim2.new(0, 390, 0, menuH) }):Play()
    TweenService:Create(arrowLabel, SYNC_TWEEN, { Rotation = 180 }):Play()
    task.delay(SYNC_DURATION, function() drawerAnimating = false end)
end

local function closeDrawer()
    if drawerAnimating then return end
    drawerAnimating = true
    local menuH = 70 + getContainerHeightWith(0) + 15
    TweenService:Create(spooferDrawer, SYNC_TWEEN, { Size = UDim2.new(1, 0, 0, 0) }):Play()
    TweenService:Create(MenuFrame, SYNC_TWEEN, { Size = UDim2.new(0, 390, 0, menuH) }):Play()
    TweenService:Create(arrowLabel, SYNC_TWEEN, { Rotation = 0 }):Play()
    task.delay(SYNC_DURATION, function()
        spooferDrawer.Visible = false
        drawerAnimating = false
    end)
end

spooferHeader.MouseButton1Click:Connect(function()
    spooferExpanded = not spooferExpanded
    if spooferExpanded then openDrawer() else closeDrawer() end
end)

task.defer(function()
    task.wait(0.1)
    local h = ToggleContainer.AbsoluteSize.Y
    if h > 0 then
        MenuFrame.Size = UDim2.new(0, 390, 0, 70 + h + 15)
    end
end)

local teamCache     = {}
local teamCacheTime = {}
local TEAM_CACHE_DURATION = 0.15

local function normalizeTeamValue(value)
    if value == nil then return nil end
    local valueType = typeof(value)
    if valueType == "Instance"   then return value end
    if valueType == "Color3"     then return string.format("color:%.4f:%.4f:%.4f", value.R, value.G, value.B) end
    if valueType == "BrickColor" then return "brick:" .. value.Name end
    if valueType == "string"     then return value == "" and nil or "string:" .. value end
    if valueType == "number"     then return "number:" .. tostring(value) end
    if valueType == "boolean"    then return "boolean:" .. tostring(value) end
    return nil
end

local function isTeamName(name)
    if typeof(name) ~= "string" then return false end
    local lowered = string.gsub(string.lower(name), "[%s_%-]", "")
    return lowered == "team" or lowered == "teamid" or lowered == "teamidentifier"
        or lowered == "teamindex" or lowered == "teamcolor" or lowered == "teamcolour"
        or string.find(lowered, "teamid", 1, true) ~= nil
end

local function getTeamFromAttributes(container)
    if not container then return nil end
    local ok, attrs = pcall(function() return container:GetAttributes() end)
    if not ok or not attrs then return nil end
    for name, value in pairs(attrs) do
        if isTeamName(name) then
            local n = normalizeTeamValue(value)
            if n ~= nil then return n end
        end
    end
    return nil
end

local function getTeamFromValues(container)
    if not container then return nil end
    local ok, children = pcall(function() return container:GetChildren() end)
    if not ok or not children then return nil end
    for _, object in ipairs(children) do
        if isTeamName(object.Name) then
            local n = normalizeTeamValue(object.Value)
            if n then return n end
        end
    end
    return nil
end

local function getRivalsTeamSignature(player)
    if not player then return nil end
    local now = os.clock()
    if teamCache[player] ~= nil and teamCacheTime[player]
        and now - teamCacheTime[player] < TEAM_CACHE_DURATION then
        return teamCache[player]
    end
    local signature = player.Team
        or getTeamFromAttributes(player)
        or getTeamFromValues(player)
        or (player.Character and getTeamFromAttributes(player.Character))
        or (player.Character and getTeamFromValues(player.Character))
    if not signature then
        local ok, tc = pcall(function() return player.TeamColor end)
        if ok and tc then
            local colorName = tc.Name
            if colorName and colorName ~= "Medium stone grey" then
                signature = "brick:" .. colorName
            end
        end
    end
    teamCache[player]     = signature
    teamCacheTime[player] = now
    return signature
end

local function clearTeamCache(player)
    teamCache[player]     = nil
    teamCacheTime[player] = nil
end

Players.PlayerAdded:Connect(function(player)
    clearTeamCache(player)
    player:GetPropertyChangedSignal("Team"):Connect(function() clearTeamCache(player) end)
    player:GetPropertyChangedSignal("TeamColor"):Connect(function() clearTeamCache(player) end)
    player.CharacterAdded:Connect(function() clearTeamCache(player) end)
end)

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        player:GetPropertyChangedSignal("Team"):Connect(function() clearTeamCache(player) end)
        player:GetPropertyChangedSignal("TeamColor"):Connect(function() clearTeamCache(player) end)
        player.CharacterAdded:Connect(function() clearTeamCache(player) end)
    end
end

Players.PlayerRemoving:Connect(function(player) clearTeamCache(player) end)

local function isTeammate(player)
    if not player or player == LocalPlayer then return true end
    local ok1, lTeam = pcall(function() return LocalPlayer.Team end)
    local ok2, pTeam = pcall(function() return player.Team end)
    if ok1 and ok2 and lTeam and pTeam then return lTeam == pTeam end
    local ls = getRivalsTeamSignature(LocalPlayer)
    local ts = getRivalsTeamSignature(player)
    if ls ~= nil and ts ~= nil then
        if typeof(ls) == "Instance" and typeof(ts) == "Instance" then return ls == ts end
        return tostring(ls) == tostring(ts)
    end
    local ok3, ltc = pcall(function() return LocalPlayer.TeamColor end)
    local ok4, ptc = pcall(function() return player.TeamColor end)
    if ok3 and ok4 and ltc and ptc then
        local lc = ltc.Name
        local tc = ptc.Name
        if lc ~= "Medium stone grey" and tc ~= "Medium stone grey" then return lc == tc end
    end
    return false
end

local function isEnemy(player)
    if not player or player == LocalPlayer then return false end
    return not isTeammate(player)
end

local cachedEnemies     = {}
local enemyCacheTime    = 0
local ENEMY_CACHE_TTL   = 0.08

local function getEnemies()
    local now = os.clock()
    if now - enemyCacheTime < ENEMY_CACHE_TTL then return cachedEnemies end
    local result = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and isEnemy(player) then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                table.insert(result, player)
            end
        end
    end
    cachedEnemies  = result
    enemyCacheTime = now
    return result
end

Players.PlayerRemoving:Connect(function()
    enemyCacheTime = 0
end)
Players.PlayerAdded:Connect(function()
    enemyCacheTime = 0
end)

local function getCrosshairPosition()
    if not Camera then return Vector2.new(0, 0) end
    if UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter then
        local vp = Camera.ViewportSize
        return Vector2.new(vp.X / 2, vp.Y / 2)
    end
    return UserInputService:GetMouseLocation()
end

local function worldToScreen(position)
    if not Camera then return nil, false end
    local ok, result = pcall(function() return Camera:WorldToScreenPoint(position) end)
    if not ok or not result then return nil, false end
    return Vector2.new(result.X, result.Y), result.Z > 0
end

local sharedRaycastParams = RaycastParams.new()
sharedRaycastParams.FilterType = Enum.RaycastFilterType.Blacklist

local function buildRaycastBlacklist()
    local blacklist = {}
    if LocalPlayer.Character then table.insert(blacklist, LocalPlayer.Character) end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            table.insert(blacklist, player.Character)
        end
    end
    return blacklist
end

local raycastBlacklistDirty = true
local raycastBlacklistTime  = 0

local function getSharedRaycastParams(targetCharacter)
    local now = os.clock()
    if raycastBlacklistDirty or now - raycastBlacklistTime > 0.5 then
        local blacklist = {}
        if LocalPlayer.Character then table.insert(blacklist, LocalPlayer.Character) end
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character ~= targetCharacter then
                table.insert(blacklist, player.Character)
            end
        end
        sharedRaycastParams.FilterDescendantsInstances = blacklist
        raycastBlacklistDirty = false
        raycastBlacklistTime  = now
    end
    return sharedRaycastParams
end

Players.PlayerAdded:Connect(function()   raycastBlacklistDirty = true end)
Players.PlayerRemoving:Connect(function() raycastBlacklistDirty = true end)

local function hasLineOfSight(targetPart)
    if not targetPart or not Camera then return false end
    local partParent = targetPart.Parent
    if not partParent then return false end
    local cameraPos = Camera.CFrame.Position
    local ok_pos, targetPos = pcall(function() return targetPart.Position end)
    if not ok_pos then return false end
    local offset   = targetPos - cameraPos
    local distance = offset.Magnitude
    if distance <= 0 then return false end
    local params = getSharedRaycastParams(partParent)
    local ok, rayResult = pcall(function()
        return workspace:Raycast(cameraPos, offset.Unit * distance, params)
    end)
    if not ok then return true end
    if not rayResult or not rayResult.Instance then return true end
    return rayResult.Instance:IsDescendantOf(partParent)
end

UserInputService.JumpRequest:Connect(function()
    if Settings.InfJump_Enabled then
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end
end)

local lockedTarget = nil

local function getAimTarget()
    local crosshair  = getCrosshairPosition()
    local localChar  = LocalPlayer.Character
    if not localChar then return nil end
    local localRoot = localChar:FindFirstChild("HumanoidRootPart")
    if not localRoot then return nil end

    if lockedTarget then
        if not isEnemy(lockedTarget) then
            lockedTarget = nil
        else
            local character = lockedTarget.Character
            local head      = character and character:FindFirstChild("Head")
            local humanoid  = character and character:FindFirstChildOfClass("Humanoid")
            if head and humanoid and humanoid.Health > 0 then
                local dist = (localRoot.Position - head.Position).Magnitude
                if dist > Settings.Triggerbot_MaxDistance then
                    lockedTarget = nil
                elseif Settings.Aimbot_WallCheck and not hasLineOfSight(head) then
                    lockedTarget = nil
                else
                    return head
                end
            else
                lockedTarget = nil
            end
        end
    end

    local bestPlayer
    local bestDist = math.huge

    for _, player in ipairs(getEnemies()) do
        local character = player.Character
        if not character then continue end
        local head = character:FindFirstChild("Head")
        if not head then continue end
        local dist3d = (localRoot.Position - head.Position).Magnitude
        if dist3d > Settings.Triggerbot_MaxDistance then continue end
        local screenPos, onScreen = worldToScreen(head.Position)
        if screenPos and onScreen then
            local dist2d = (screenPos - crosshair).Magnitude
            if dist2d <= Settings.Aimbot_FOVRadius then
                if Settings.Aimbot_WallCheck and not hasLineOfSight(head) then continue end
                if dist2d < bestDist then
                    bestDist   = dist2d
                    bestPlayer = player
                end
            end
        end
    end

    if bestPlayer then
        lockedTarget = bestPlayer
        return bestPlayer.Character:FindFirstChild("Head")
    end

    return nil
end

local function forceAimAtHead(head)
    if not head or not head.Parent or not Camera then return false end
    local character = LocalPlayer.Character
    if not character then return false end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return false end
    local ok, headPos = pcall(function() return head.Position end)
    if not ok then return false end
    local camPos = Camera.CFrame.Position
    Camera.CFrame = CFrame.lookAt(camPos, headPos, Vector3.new(0, 1, 0))
    local rootPos = rootPart.Position
    rootPart.CFrame = CFrame.lookAt(rootPos, Vector3.new(headPos.X, rootPos.Y, headPos.Z), Vector3.new(0, 1, 0))
    return true
end

local function updateLockedBody()
    if not Settings.Aimbot_Enabled or not lockedTarget then return end
    if not isEnemy(lockedTarget) then lockedTarget = nil return end

    local character = lockedTarget.Character
    local head      = character and character:FindFirstChild("Head")
    local humanoid  = character and character:FindFirstChildOfClass("Humanoid")

    if not character or not head or not humanoid or humanoid.Health <= 0 then
        lockedTarget = nil return
    end

    local localChar = LocalPlayer.Character
    if localChar then
        local localRoot = localChar:FindFirstChild("HumanoidRootPart")
        if localRoot then
            local ok, headPos = pcall(function() return head.Position end)
            if ok and (localRoot.Position - headPos).Magnitude > Settings.Triggerbot_MaxDistance then
                lockedTarget = nil return
            end
        end
    end

    if Settings.Aimbot_WallCheck and not hasLineOfSight(head) then
        lockedTarget = nil return
    end

    forceAimAtHead(head)
end

local HITBOX_PARTS = {
    "Head", "UpperTorso", "LowerTorso", "HumanoidRootPart",
    "LeftUpperArm", "RightUpperArm", "LeftLowerArm", "RightLowerArm",
    "LeftUpperLeg", "RightUpperLeg", "LeftLowerLeg", "RightLowerLeg",
}

local function getHitboxScreenBounds(part)
    if not Camera or not part or not part.Parent then return nil end
    local ok, cf, size = pcall(function()
        return part.CFrame, part.Size * 0.5
    end)
    if not ok or not cf or not size then return nil end

    local sx, sy = size.X, size.Y
    local sz = size.Z
    local corners = {
        cf * Vector3.new( sx,  sy,  sz), cf * Vector3.new(-sx,  sy,  sz),
        cf * Vector3.new( sx, -sy,  sz), cf * Vector3.new(-sx, -sy,  sz),
        cf * Vector3.new( sx,  sy, -sz), cf * Vector3.new(-sx,  sy, -sz),
        cf * Vector3.new( sx, -sy, -sz), cf * Vector3.new(-sx, -sy, -sz),
    }

    local minX, minY =  math.huge,  math.huge
    local maxX, maxY = -math.huge, -math.huge
    local anyOnScreen = false

    for _, corner in ipairs(corners) do
        local ok2, result = pcall(function() return Camera:WorldToScreenPoint(corner) end)
        if ok2 and result and result.Z > 0 then
            anyOnScreen = true
            if result.X < minX then minX = result.X end
            if result.Y < minY then minY = result.Y end
            if result.X > maxX then maxX = result.X end
            if result.Y > maxY then maxY = result.Y end
        end
    end

    if not anyOnScreen then return nil end
    return minX, minY, maxX, maxY
end

local function shouldFire()
    if not Camera then return false end
    if not isInActiveRound() then return false end

    if Settings.Aimbot_Enabled and lockedTarget and isEnemy(lockedTarget) then
        local character = lockedTarget.Character
        local head      = character and character:FindFirstChild("Head")
        local humanoid  = character and character:FindFirstChildOfClass("Humanoid")

        if head and humanoid and humanoid.Health > 0 then
            local los = hasLineOfSight(head)
            if los then
                local aimed = forceAimAtHead(head)
                if aimed then return true end
            else
                lockedTarget = nil
            end
        else
            lockedTarget = nil
        end
    end

    if not Settings.Triggerbot_Enabled then return false end

    local crosshair = getCrosshairPosition()
    local cx, cy    = crosshair.X, crosshair.Y
    local camPos    = Camera.CFrame.Position

    for _, player in ipairs(getEnemies()) do
        local character = player.Character
        if not character then continue end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.Health <= 0 then continue end
        local root = character:FindFirstChild("HumanoidRootPart")
        if not root or not root.Parent then continue end
        local ok_rp, rootPos = pcall(function() return root.Position end)
        if not ok_rp then continue end
        if (rootPos - camPos).Magnitude > Settings.Triggerbot_MaxDistance then continue end

        for _, partName in ipairs(HITBOX_PARTS) do
            local part = character:FindFirstChild(partName)
            if part then
                if not hasLineOfSight(part) then continue end
                local minX, minY, maxX, maxY = getHitboxScreenBounds(part)
                if minX and cx >= minX and cx <= maxX and cy >= minY and cy <= maxY then
                    return true
                end
            end
        end
    end

    return false
end

local tracerLines = {}

local function getTracerLine(player)
    if tracerLines[player] then return tracerLines[player] end
    local ok, result = pcall(function()
        local d = Drawing.new("Line")
        d.Thickness = 1.5
        d.Color = Color3.fromRGB(255, 255, 255)
        d.Transparency = 1
        d.Visible = false
        return d
    end)
    if ok and result then
        tracerLines[player] = result
        return result
    end
    return nil
end

local function removeTracerLine(player)
    local line = tracerLines[player]
    if line then
        pcall(function() line.Visible = false line:Remove() end)
        tracerLines[player] = nil
    end
end

local function hideTracerLines()
    for _, line in pairs(tracerLines) do
        pcall(function() line.Visible = false end)
    end
end

Players.PlayerRemoving:Connect(function(player)
    removeTracerLine(player)
    clearTeamCache(player)
    enemyCacheTime = 0
    raycastBlacklistDirty = true
end)

local function updateTracer()
    if not Settings.ESP_Enabled or not Settings.ESP_Tracer or MenuFrame.Visible then
        hideTracerLines() return
    end
    local localCharacter = LocalPlayer.Character
    local localRoot = localCharacter and localCharacter:FindFirstChild("HumanoidRootPart")
    if not localRoot or not Camera then hideTracerLines() return end

    local vp = Camera.ViewportSize
    local origin = Vector2.new(vp.X / 2, vp.Y / 2)
    local seen   = {}

    for _, player in ipairs(getEnemies()) do
        local character = player.Character
        local humanoid  = character and character:FindFirstChildOfClass("Humanoid")
        local root      = character and character:FindFirstChild("HumanoidRootPart")
        if humanoid and humanoid.Health > 0 and root then
            local ok_rp, rootPos = pcall(function() return root.Position end)
            if ok_rp and (rootPos - localRoot.Position).Magnitude <= 1000 then
                local head      = character:FindFirstChild("Head")
                local ok_hp, targetPos = pcall(function()
                    return head and head.Position or root.Position
                end)
                if ok_hp then
                    local ok_sp, sp = pcall(function() return Camera:WorldToViewportPoint(targetPos) end)
                    if ok_sp and sp.Z > 0 then
                        local line = getTracerLine(player)
                        if line then
                            line.From    = origin
                            line.To      = Vector2.new(sp.X, sp.Y)
                            line.Visible = true
                            seen[player] = true
                        end
                    end
                end
            end
        end
    end

    for player, line in pairs(tracerLines) do
        if not seen[player] then
            pcall(function() line.Visible = false end)
        end
    end
end

local circleDraw = nil
pcall(function()
    if Drawing then
        circleDraw           = Drawing.new("Circle")
        circleDraw.Thickness = 2
        circleDraw.Color     = Color3.fromRGB(255, 0, 0)
        circleDraw.Filled    = false
        circleDraw.Visible   = false
    end
end)

local function updateCircle()
    if not circleDraw then return end
    if Settings.Aimbot_Enabled and not MenuFrame.Visible then
        circleDraw.Position = getCrosshairPosition()
        circleDraw.Radius   = Settings.Aimbot_FOVRadius
        circleDraw.Visible  = true
    else
        circleDraw.Visible = false
    end
end

local tabHeld = false

local function holdTab()
    if not tabHeld then
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Tab, false, game)
        tabHeld = true
    end
end

local function releaseTab()
    if tabHeld then
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Tab, false, game)
        tabHeld = false
    end
end

local AutoclickActive = false

local function closeMenu()
    if not MenuFrame.Visible then return end
    MenuFrame.Visible       = false
    BackgroundFrame.Visible = false
    AutoclickActive         = false
    releaseTab()
end

local function openMenu()
    if MenuFrame.Visible then return end
    MenuFrame.Visible       = true
    BackgroundFrame.Visible = true
    lockedTarget            = nil
    AutoclickActive         = false
    hideTracerLines()
    updateAllSubToggles()
    recalcMenuHeight()
    holdTab()
end

BackgroundFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        closeMenu()
    end
end)

if isMobile then
    local mobileGui = Instance.new("ScreenGui")
    mobileGui.Name = "MobileToggleGui"
    mobileGui.ResetOnSpawn = false
    mobileGui.IgnoreGuiInset = true
    mobileGui.DisplayOrder = 1001
    mobileGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.fromOffset(44, 44)
    toggleBtn.Position = UDim2.new(1, -60, 1, -60)
    toggleBtn.AnchorPoint = Vector2.new(1, 1)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Text = "<>"
    toggleBtn.TextColor3 = Color3.fromRGB(210, 210, 210)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 14
    toggleBtn.AutoButtonColor = false
    toggleBtn.ZIndex = 200
    toggleBtn.Parent = mobileGui

    makeCorner(toggleBtn, 12)

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(55, 55, 55)
    btnStroke.Thickness = 1
    btnStroke.Transparency = 0.2
    btnStroke.Parent = toggleBtn

    toggleBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            TweenService:Create(toggleBtn,
                TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                { BackgroundColor3 = Color3.fromRGB(35, 35, 35) }):Play()
        end
    end)
    toggleBtn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            TweenService:Create(toggleBtn,
                TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                { BackgroundColor3 = Color3.fromRGB(18, 18, 18) }):Play()
        end
    end)
    toggleBtn.MouseButton1Click:Connect(function()
        if MenuFrame.Visible then closeMenu() else openMenu() end
    end)
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        if MenuFrame.Visible then closeMenu() else openMenu() end
    end
end)

local function removeESPObjects(character)
    if not character then return end
    for _, name in ipairs({ "ESP_Highlight", "ESP_Billboard", "ESP_HealthBar", "HealthBackground", "HealthOutline" }) do
        local obj = character:FindFirstChild(name)
        if obj then obj:Destroy() end
    end
end

local ESP_GUI_WIDTH     = 220
local ESP_GUI_HEIGHT    = 58
local HEALTH_BAR_WIDTH  = 120
local HEALTH_BAR_HEIGHT = 7

local function createESPBillboard(character, head)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_Billboard"
    billboard.Adornee = head
    billboard.AlwaysOnTop = true
    billboard.LightInfluence = 0
    billboard.MaxDistance = Settings.ESP_MaxDistance
    billboard.Size = UDim2.fromOffset(ESP_GUI_WIDTH, ESP_GUI_HEIGHT)
    billboard.StudsOffsetWorldSpace = Vector3.new(0, 2.7, 0)
    billboard.ClipsDescendants = false
    billboard.Parent = character

    local healthOutline = Instance.new("Frame")
    healthOutline.Name = "HealthOutline"
    healthOutline.Position = UDim2.fromOffset((ESP_GUI_WIDTH - HEALTH_BAR_WIDTH) / 2 - 1, 1)
    healthOutline.Size = UDim2.fromOffset(HEALTH_BAR_WIDTH + 2, HEALTH_BAR_HEIGHT + 2)
    healthOutline.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    healthOutline.BackgroundTransparency = 0.15
    healthOutline.BorderSizePixel = 0
    healthOutline.ZIndex = 5
    healthOutline.Parent = billboard
    makeCorner(healthOutline, 4)

    local healthBackground = Instance.new("Frame")
    healthBackground.Name = "HealthBackground"
    healthBackground.Position = UDim2.fromOffset(1, 1)
    healthBackground.Size = UDim2.fromOffset(HEALTH_BAR_WIDTH, HEALTH_BAR_HEIGHT)
    healthBackground.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    healthBackground.BorderSizePixel = 0
    healthBackground.ZIndex = 6
    healthBackground.Parent = healthOutline
    makeCorner(healthBackground, 3)

    local healthBar = Instance.new("Frame")
    healthBar.Name = "ESP_HealthBar"
    healthBar.Position = UDim2.fromOffset(0, 0)
    healthBar.Size = UDim2.fromOffset(HEALTH_BAR_WIDTH, HEALTH_BAR_HEIGHT)
    healthBar.BackgroundColor3 = Color3.fromRGB(0, 220, 80)
    healthBar.BorderSizePixel = 0
    healthBar.ZIndex = 7
    healthBar.Parent = healthBackground
    makeCorner(healthBar, 3)

    local infoLabel = Instance.new("TextLabel")
    infoLabel.Name = "ESP_Info"
    infoLabel.Position = UDim2.fromOffset(0, 14)
    infoLabel.Size = UDim2.fromOffset(ESP_GUI_WIDTH, 22)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Font = Enum.Font.GothamBold
    infoLabel.TextSize = 14
    infoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    infoLabel.TextStrokeTransparency = 0.45
    infoLabel.TextXAlignment = Enum.TextXAlignment.Center
    infoLabel.TextYAlignment = Enum.TextYAlignment.Center
    infoLabel.Text = ""
    infoLabel.ZIndex = 8
    infoLabel.Parent = billboard

    return billboard
end

local function updateESP()
    if not Settings.ESP_Enabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                removeESPObjects(player.Character)
            end
        end
        return
    end

    local localCharacter = LocalPlayer.Character
    local localRoot = localCharacter and localCharacter:FindFirstChild("HumanoidRootPart")
    if not localRoot or not Camera then return end

    local allPlayers = Players:GetPlayers()
    for _, player in ipairs(allPlayers) do
        if player == LocalPlayer then continue end
        local character = player.Character
        if not character then continue end

        if not isEnemy(player) then removeESPObjects(character) continue end

        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local root     = character:FindFirstChild("HumanoidRootPart")
        local head     = character:FindFirstChild("Head")

        if not humanoid or humanoid.Health <= 0 or not root or not head then
            removeESPObjects(character) continue
        end

        local ok_rp, rootPos = pcall(function() return root.Position end)
        if not ok_rp then removeESPObjects(character) continue end

        local distance = (rootPos - localRoot.Position).Magnitude
        if distance > Settings.ESP_MaxDistance then removeESPObjects(character) continue end

        local highlight = character:FindFirstChild("ESP_Highlight")
        if Settings.ESP_Highlight then
            if not highlight then
                highlight = Instance.new("Highlight")
                highlight.Name = "ESP_Highlight"
                highlight.Adornee = character
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                highlight.Parent = character
            end
            highlight.FillColor           = ESP_BOX_COLOR
            highlight.FillTransparency    = Settings.ESP_BoxTransparency
            highlight.OutlineColor        = ESP_BOX_COLOR
            highlight.OutlineTransparency = 0
            highlight.Enabled             = true
        elseif highlight then
            highlight:Destroy()
        end

        local billboard = character:FindFirstChild("ESP_Billboard")
        if not billboard or not billboard:IsA("BillboardGui") then
            if billboard then billboard:Destroy() end
            billboard = createESPBillboard(character, head)
        end

        billboard.Adornee               = head
        billboard.AlwaysOnTop           = true
        billboard.LightInfluence        = 0
        billboard.MaxDistance           = Settings.ESP_MaxDistance
        billboard.Size                  = UDim2.fromOffset(ESP_GUI_WIDTH, ESP_GUI_HEIGHT)
        billboard.StudsOffsetWorldSpace = Vector3.new(0, 2.7, 0)
        billboard.Enabled               = true

        local healthOutline    = billboard:FindFirstChild("HealthOutline")
        local healthBackground = healthOutline and healthOutline:FindFirstChild("HealthBackground")
        local healthBar        = healthBackground and healthBackground:FindFirstChild("ESP_HealthBar")

        if not healthOutline or not healthBackground or not healthBar then
            billboard:Destroy()
            billboard        = createESPBillboard(character, head)
            healthOutline    = billboard:FindFirstChild("HealthOutline")
            healthBackground = healthOutline and healthOutline:FindFirstChild("HealthBackground")
            healthBar        = healthBackground and healthBackground:FindFirstChild("ESP_HealthBar")
        end

        local healthPercent = math.clamp(humanoid.Health / math.max(humanoid.MaxHealth, 1), 0, 1)

        if healthBar then
            healthBar.Size = UDim2.fromOffset(
                math.max(0, math.floor(HEALTH_BAR_WIDTH * healthPercent)),
                HEALTH_BAR_HEIGHT)
            if healthPercent > 0.6 then
                healthBar.BackgroundColor3 = Color3.fromRGB(0, 220, 80)
            elseif healthPercent > 0.3 then
                healthBar.BackgroundColor3 = Color3.fromRGB(255, 190, 0)
            else
                healthBar.BackgroundColor3 = Color3.fromRGB(235, 45, 45)
            end
        end

        local infoLabel = billboard:FindFirstChild("ESP_Info")
        if infoLabel then
            local showName  = Settings.ESP_Name
            local showStuds = Settings.ESP_Studs
            if showName and showStuds then
                infoLabel.Text    = player.Name .. " | " .. string.format("%.1f studs", distance)
                infoLabel.Visible = true
            elseif showName then
                infoLabel.Text    = player.Name
                infoLabel.Visible = true
            elseif showStuds then
                infoLabel.Text    = string.format("%.1f studs", distance)
                infoLabel.Visible = true
            else
                infoLabel.Text    = ""
                infoLabel.Visible = false
            end
        end
    end
end

task.spawn(function()
    while true do
        if AutoclickActive and not isVoteScreenActive() then
            if not Camera then Camera = workspace.CurrentCamera end
            if Camera then
                local vp = Camera.ViewportSize
                if vp then
                    local cx = vp.X / 2
                    local cy = vp.Y / 2
                    VirtualInputManager:SendMouseButtonEvent(cx, cy, 0, true,  game, 0)
                    VirtualInputManager:SendMouseButtonEvent(cx, cy, 0, false, game, 0)
                end
            end
        end
        task.wait()
    end
end)

task.spawn(function()
    RunService.RenderStepped:Connect(function()
        if not Camera then Camera = workspace.CurrentCamera end
        if not Camera then return end
        if not LocalPlayer.Character then return end

        updateCircle()
        updateTracer()

        if MenuFrame.Visible then
            AutoclickActive = false
            return
        end

        if Settings.Aimbot_Enabled then
            if lockedTarget then
                updateLockedBody()
            else
                local targetHead = getAimTarget()
                if targetHead then forceAimAtHead(targetHead) end
            end
        else
            lockedTarget = nil
        end

        if Settings.Triggerbot_Enabled then
            AutoclickActive = shouldFire()
        else
            AutoclickActive = false
        end
    end)
end)

task.spawn(function()
    while task.wait(0.15) do
        pcall(updateESP)
    end
end)

print("Script loaded. " .. (isMobile and "Tap <> button" or "Right Control") .. " opens menu. Cache: " .. CACHE_FILE)
]]

local SCRIPT_FILE = "rivals_main.lua"
pcall(function()
    if writefile then
        writefile(SCRIPT_FILE, myScriptCode)
    end
end)

local fn, compileErr = loadstring(myScriptCode)
if not fn then
    warn("[rivals] loadstring compile error: " .. tostring(compileErr))
else
    local success, runErr = pcall(fn)
    if not success then
        warn("[rivals] runtime error: " .. tostring(runErr))
    end
end

local queueFunc = queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)
if queueFunc then
    queueFunc([[
        task.wait(2)
        local SCRIPT_FILE = "rivals_main.lua"
        local code = nil
        pcall(function()
            if isfile and isfile(SCRIPT_FILE) then
                code = readfile(SCRIPT_FILE)
            end
        end)
        if code and loadstring then
            local fn, ce = loadstring(code)
            if not fn then
                warn("[rivals/queue] compile error: " .. tostring(ce))
            else
                local ok, e = pcall(fn)
                if not ok then warn("[rivals/queue] runtime error: " .. tostring(e)) end
            end
        else
            warn("rivals_main.lua not found on teleport — script did not persist.")
        end
        local qf = queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)
        if qf then
            qf([=[
                task.wait(2)
                local SCRIPT_FILE = "rivals_main.lua"
                local code = nil
                pcall(function()
                    if isfile and isfile(SCRIPT_FILE) then
                        code = readfile(SCRIPT_FILE)
                    end
                end)
                if code and loadstring then
                    local fn, ce = loadstring(code)
                    if not fn then
                        warn("[rivals/queue2] compile error: " .. tostring(ce))
                    else
                        local ok, e = pcall(fn)
                        if not ok then warn("[rivals/queue2] runtime error: " .. tostring(e)) end
                    end
                end
                local qf2 = queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)
                if qf2 then
                    local ok_rf, queueCode = pcall(function()
                        return readfile("rivals_queue.lua")
                    end)
                    if ok_rf and queueCode then
                        qf2(queueCode)
                    else
                        warn("[rivals/queue2] rivals_queue.lua not found — persistence chain ended.")
                    end
                end
            ]=])
            pcall(function()
                if writefile then
                    writefile("rivals_queue.lua", [=[
                        task.wait(2)
                        local SCRIPT_FILE = "rivals_main.lua"
                        local code = nil
                        pcall(function()
                            if isfile and isfile(SCRIPT_FILE) then
                                code = readfile(SCRIPT_FILE)
                            end
                        end)
                        if code and loadstring then
                            local fn, ce = loadstring(code)
                            if not fn then
                                warn("[rivals/queuefile] compile error: " .. tostring(ce))
                            else
                                local ok, e = pcall(fn)
                                if not ok then warn("[rivals/queuefile] runtime error: " .. tostring(e)) end
                            end
                        end
                        local qf = queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)
                        if qf then
                            local ok_rf, queueCode = pcall(function()
                                return readfile("rivals_queue.lua")
                            end)
                            if ok_rf and queueCode then
                                qf(queueCode)
                            else
                                warn("[rivals/queuefile] rivals_queue.lua missing — persistence chain ended.")
                            end
                        end
                    ]=])
                end
            end)
            print("Re-queued for next server.")
        end
    ]])
    print("Queued for next server. Script saved to " .. SCRIPT_FILE)
else
    print("Warning: executor does not support queue_on_teleport.")
end
