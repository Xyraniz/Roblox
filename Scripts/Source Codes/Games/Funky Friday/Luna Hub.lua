-- Uri Hub | Funky Friday
-- Rem'in "True Humanizer" Sürümü (Real Time Delay Logic) 💙
-- Sürüm: vFinal_TimeBased

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local gamename = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
local player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local Window = Fluent:CreateWindow({
    Title = "Luna Hub  |",
    SubTitle = gamename,
    TabWidth = 130,
    Size = UDim2.fromOffset(490, 400),
    Acrylic = true,
    Theme = "Amethyst",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Updates = Window:AddTab({ Title = "Home", Icon = "home" }),
    Main = Window:AddTab({ Title = "Main", Icon = "play" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- // GLOBAL DEĞİŞKENLER //
local Side = nil
_G.auto = false
_G.Delay = 0
_G.Mode = "Static"
_G.softnessEnabled = true -- Humanizer varsayılan AÇIK

-- // YENİ ZAMAN HESAPLAYICI (GERÇEK MS) //
-- Bu fonksiyon artık "Mesafe" değil "Saniye" döndürür.
local function getRealTimeDelay()
    if not _G.softnessEnabled then return 0 end
    
    local rand = math.random(1, 100)
    
    if rand <= 75 then
        -- %75 SICK (Mükemmel)
        -- 0 saniye ile 0.035 saniye arası (0-35ms)
        return math.random(0, 30) / 1000 
    else
        -- %25 GOOD (İyi)
        -- 0.060 saniye ile 0.090 saniye arası (60-90ms)
        -- Bu gecikme, notayı "Sick" alanından çıkarıp "Good" alanına sokar.
        return math.random(35, 55) / 1000 
    end
end

-- Taraf Kontrolü
function CheckSide()
    local rootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    local closestDist = math.huge
    local detectedSide = "Left" 

    local stages = workspace.Map:FindFirstChild("Stages")
    if stages then
        for _, stage in pairs(stages:GetChildren()) do
            local teams = stage:FindFirstChild("Teams")
            if teams then
                local left = teams:FindFirstChild("Left")
                local right = teams:FindFirstChild("Right")
                
                if left then
                    local dist = (rootPart.Position - left.Position).Magnitude
                    if dist < closestDist then closestDist = dist; detectedSide = "Left" end
                end
                if right then
                    local dist = (rootPart.Position - right.Position).Magnitude
                    if dist < closestDist then closestDist = dist; detectedSide = "Right" end
                end
            end
        end
    end
    Side = detectedSide
end

-- Sütunları Güvenli Bul
local function setupColumns(side)
    local columns = {}
    local gui = player.PlayerGui:FindFirstChild("Window")
    if not gui then return {} end 
    local gameUI = gui:FindFirstChild("Game")
    if not gameUI then return {} end

    pcall(function()
        local ap = gameUI.Fields[side].Inner
        for i = 1, 9 do
            local lane = ap:FindFirstChild("Lane"..i)
            if lane and lane:FindFirstChild("Notes") then
                columns[i] = lane.Notes
            end
        end
    end)
    return columns
end

-- // ARAYÜZ //
local Toggle = Tabs.Main:AddToggle("Toggle", {
    Title = "Auto Player",
    Description = "Smart Delay System",
    Default = false
})

local SoftnessToggle = Tabs.Main:AddToggle("SoftnessToggle", {
    Title = "Humanizer (Softness)",
    Description = "75% Sick / 25% Good (Real Time)",
    Default = true
})

SoftnessToggle:OnChanged(function() _G.softnessEnabled = SoftnessToggle.Value end)

-- // MOTOR (ENGINE) //
local function autoplay()
    CheckSide()
    
    local keymap = {}
    local gui = player.PlayerGui:FindFirstChild("Window")
    if not gui or not gui:FindFirstChild("Game") then return end

    pcall(function()
        local inner = gui.Game.Fields[Side].Inner
        for i=1, 9 do
            local laneLabel = inner["Lane"..i].Labels.Label.Text.text
            keymap[i] = Enum.KeyCode[laneLabel]
        end
    end)

    local columns = setupColumns(Side)
    if not columns or #columns == 0 then return end

    local trackedNotes = {}     
    local activeLongNotes = {}
    
    local connection
    connection = RunService.PreRender:Connect(function()
        if not _G.auto then 
            connection:Disconnect() 
            return 
        end
        
        if not player.PlayerGui:FindFirstChild("Window") then return end

        -- Tetiklenme noktasını "Perfect" çizgisine çok yakın (0.85) alıyoruz.
        -- Gecikmeyi bunun üzerine ekleyeceğiz.
        local baseThreshold = 0.35 

        for colNum, column in pairs(columns) do
            if not column.Parent then break end

            local children = column:GetChildren()
            for i = 1, #children do
                local note = children[i]
                if note:IsA("GuiObject") then
                    local noteY = note.Position.Y.Scale
                    
                    if not trackedNotes[note] and noteY > baseThreshold then
                        trackedNotes[note] = true 
                        
                        -- ZAMANLAMA HESABI:
                        -- Hemen basmak yerine, hesaplanan "insan gecikmesi" kadar bekle.
                        local humanDelay = getRealTimeDelay()
                        
                        task.delay(humanDelay, function()
                            -- Gecikme süresi dolduğunda nota hala geçerliyse bas
                            if note.Parent then 
                                VirtualInputManager:SendKeyEvent(true, keymap[colNum], false, game)
                                
                                if #note:GetChildren() == 2 then
                                    activeLongNotes[note] = {col = colNum, key = keymap[colNum]}
                                else
                                    -- Kısa notayı hızlı bırak (0.025s)
                                    task.delay(0.025, function() 
                                        if not activeLongNotes[note] then
                                            VirtualInputManager:SendKeyEvent(false, keymap[colNum], false, game)
                                        end
                                    end)
                                end
                            end
                        end)
                    end
                end
            end
        end

        for note, data in pairs(activeLongNotes) do
            -- Uzun notaları bırakırken acele etme, miss olmasın
            if not note.Parent or note.Position.Y.Scale > 0.98 then 
                VirtualInputManager:SendKeyEvent(false, data.key, false, game)
                activeLongNotes[note] = nil
            end
        end
        
        for note in pairs(trackedNotes) do
            if not note.Parent then trackedNotes[note] = nil end
        end
    end)
end

Toggle:OnChanged(function()
    if Toggle.Value then
        _G.auto = true
        autoplay() 
    else
        _G.auto = false
    end
end)

-- // DİĞER KISIMLAR //
Tabs.Main:AddKeybind("Keybind", { Title = "Auto Player Keybind", Mode = "Toggle", Default = "Insert", Callback = function() Toggle:SetValue(not Toggle.Value) end })
Tabs.Main:AddKeybind("SoftnessKeybind", { Title = "Toggle Humanizer", Mode = "Toggle", Default = "P", Callback = function() SoftnessToggle:SetValue(not SoftnessToggle.Value) end })

Tabs.Main:AddSection("Adjustments")
Tabs.Main:AddDropdown("Dropdown", { Title = "Delay Mode", Values = {"Static", "Random"}, Multi = false, Default = 1, Callback = function(Value) _G.Mode = Value end })
Tabs.Main:AddSlider("Slider", { Title = "Note ms Delay", Description = "More = Later", Default = 0, Min = -0.4, Max = 0.4, Rounding = 2, Callback = function(Value) _G.Delay = Value end })

local Timer = Tabs.Updates:AddParagraph({Title = "Time: 00:00:00"})
local st = os.time()
task.spawn(function()
    while true do
        local et = os.difftime(os.time(), st)
        Timer:SetTitle(string.format("Time: %02d:%02d:%02d", math.floor(et/3600), math.floor((et%3600)/60), et%60))
        task.wait(1)
    end
end)

Tabs.Updates:AddButton({ Title = "Discord Server", Callback = function() setclipboard("https://discord.com"); Fluent:Notify({Title = "Uri Hub", Content = "Copied", Duration = 2}) end })
Tabs.Updates:AddButton({ Title = "Run Infinite Yield", Callback = function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end })

game:GetService('VirtualUser'):CaptureController()
player.Idled:connect(function() game:GetService('VirtualUser'):ClickButton2(Vector2.new()) end)

local SongSelector = player.PlayerGui.GameGui.Windows.SongSelector
SongSelector:GetPropertyChangedSignal("Visible"):Connect(function()
    if not SongSelector.Visible then
        task.wait(1.5)
        CheckSide()
        if Toggle.Value then
            _G.auto = false; task.wait(0.1); _G.auto = true; autoplay()
        end
    end
end)

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("UriHub")
SaveManager:SetFolder("UriHub/FunkyFriday")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)
Fluent:Notify({ Title = "Uri Hub", Content = "Time-Based Humanizer Active!\nExpect real delays. 💙", Duration = 5 })
