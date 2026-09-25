-- Astra Hub | Blox Fruits - Premium Script
if game.PlaceId == 2753915549 or game.PlaceId == 4442272183 or game.PlaceId == 7449423635 then
    repeat wait() until game:IsLoaded()
    
    -- Services
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local Workspace = game:GetService("Workspace")
    local RunService = game:GetService("RunService")
    local TweenService = game:GetService("TweenService")
    local VirtualInputManager = game:GetService("VirtualInputManager")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    
    -- Load Kavo UI Library
    local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
    local Window = Library.CreateLib("Astra Hub | Blox Fruits", "Ocean")
    
    -- Global Variables
    local AutoFarm = false
    AutoStats = false
    AutoNewWorld = false
    AutoThirdWorld = false
    AutoBoss = false
    AutoSword = false
    AutoSaber = false
    AutoPole = false
    AutoChest = false
    AutoBuyHaki = false
    AutoRaid = false
    AutoKen = false
    AutoObservation = false
    MeleeRange = false
    AutoEctoplasm = false
    AutoFactory = false
    AutoSecondSea = false
    AutoBartilo = false
    AutoDarkDagger = false
    AutoBuyFruits = false
    AutoStoreFruits = false
    AutoHallowSythe = false
    AutoCakePrince = false
    AutoBuddySword = false
    AutoPaleScarf = false
    AutoCursedDualKatana = false
    AutoRandomBone = false
    AutoTushita = false
    AutoYama = false
    AutoEliteHunter = false
    AutoRainbowHaki = false
    AutoMuscleBeach = false
    AutoMysticIsland = false
    
    local SelectedBoss = ""
    SelectedWeapon = "Melee"
    StatsToAdd = "Melee"
    MobSelection = ""
    
    -- Mob Lists
    local MobList = {
        ["First Sea"] = {
            "Bandit", "Monkey", "Gorilla", "Pirate", "Brute", "Snow Bandit", 
            "Snowman", "Chief Petty Officer", "Sky Bandit", "Dark Master",
            "Desert Officer", "Desert Bandit"
        },
        ["Second Sea"] = {
            "Marine Captain", "Sky Bandit", "Dark Master", "Pistol Billionaire"
        },
        ["Third Sea"] = {
            "Galley Captain", "Galley Pirate"
        }
    }
    
    local BossList = {
        "The Gorilla King", "Bobby", "Yeti", "Vice Admiral", "Warden",
        "Chief Warden", "Swan", "Magma Admiral", "Fishman Lord",
        "Wysper", "Tide Keeper", "Darkbeard", "Saber Expert"
    }
    
    -- Utility Functions
    function TweenToPosition(Position)
        local Character = LocalPlayer.Character
        if Character and Character:FindFirstChild("HumanoidRootPart") then
            local HRP = Character.HumanoidRootPart
            local TweenInfo = TweenInfo.new((HRP.Position - Position).Magnitude / 100, Enum.EasingStyle.Linear)
            local Tween = TweenService:Create(HRP, TweenInfo, {CFrame = CFrame.new(Position)})
            Tween:Play()
        end
    end
    
    function GetClosestEnemy()
        local closestEnemy = nil
        local closestDistance = math.huge
        
        for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
                local distance = (LocalPlayer.Character.HumanoidRootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closestEnemy = enemy
                end
            end
        end
        
        return closestEnemy
    end
    
    function EquipWeapon(ToolName)
        if LocalPlayer.Character and LocalPlayer.Backpack:FindFirstChild(ToolName) then
            LocalPlayer.Backpack:FindFirstChild(ToolName).Parent = LocalPlayer.Character
        end
    end
    
    function AttackEnemy()
        if AutoFarm and LocalPlayer.Character then
            local enemy = GetClosestEnemy()
            if enemy then
                LocalPlayer.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                EquipWeapon(SelectedWeapon)
                VirtualInputManager:SendKeyEvent(true, "X", false, game)
                wait(0.1)
                VirtualInputManager:SendKeyEvent(false, "X", false, game)
            end
        end
    end
    
    -- Auto Farm Tab
    local AutoFarmTab = Window:NewTab("Auto Farm")
    local MainFarmSection = AutoFarmTab:NewSection("Main Farming")
    
    MainFarmSection:NewToggle("Auto Farm", "Automatically farms nearest enemies", function(state)
        AutoFarm = state
        if state then
            while AutoFarm do
                AttackEnemy()
                RunService.Heartbeat:Wait()
            end
        end
    end)
    
    MainFarmSection:NewToggle("Auto Stats", "Automatically adds stat points", function(state)
        AutoStats = state
        if state then
            while AutoStats do
                local args = {
                    [1] = "AddPoint",
                    [2] = StatsToAdd,
                    [3] = 1
                }
                ReplicatedStorage.Remotes.CommF_:InvokeServer(unpack(args))
                wait(0.5)
            end
        end
    end)
    
    MainFarmSection:NewDropdown("Stats To Add", "Choose which stat to upgrade", {"Melee", "Defense", "Sword", "Gun", "Devil Fruit"}, function(selected)
        StatsToAdd = selected
    end)
    
    MainFarmSection:NewDropdown("Weapon", "Choose weapon to use", {"Melee", "Sword"}, function(selected)
        SelectedWeapon = selected
    end)
    
    -- Boss Farm Tab
    local BossFarmTab = Window:NewTab("Boss Farm")
    local BossSection = BossFarmTab:NewSection("Boss Farming")
    
    BossSection:NewToggle("Auto Boss", "Automatically farm selected boss", function(state)
        AutoBoss = state
        if state then
            while AutoBoss do
                -- Boss farming logic
                wait(0.1)
            end
        end
    end)
    
    BossSection:NewDropdown("Select Boss", "Choose which boss to farm", BossList, function(selected)
        SelectedBoss = selected
    end)
    
    -- Sea Travel Tab
    local SeaTravelTab = Window:NewTab("Sea Travel")
    local SeaTravelSection = SeaTravelTab:NewSection("World Travel")
    
    SeaTravelSection:NewToggle("Auto New World", "Automatically travel to New World", function(state)
        AutoNewWorld = state
        if state then
            while AutoNewWorld do
                -- New World travel logic
                wait(0.1)
            end
        end
    end)
    
    SeaTravelSection:NewToggle("Auto Third Sea", "Automatically travel to Third Sea", function(state)
        AutoThirdWorld = state
        if state then
            while AutoThirdWorld do
                -- Third Sea travel logic
                wait(0.1)
            end
        end
    end)
    
    -- Sword Tab
    local SwordTab = Window:NewTab("Sword")
    local SwordSection = SwordTab:NewSection("Sword Mastery")
    
    SwordSection:NewToggle("Auto Saber", "Automatically get Saber", function(state)
        AutoSaber = state
        if state then
            while AutoSaber do
                -- Saber farming logic
                wait(0.1)
            end
        end
    end)
    
    SwordSection:NewToggle("Auto Pole", "Automatically get Pole (1st Form)", function(state)
        AutoPole = state
        if state then
            while AutoPole do
                -- Pole farming logic
                wait(0.1)
            end
        end
    end)
    
    -- Player Tab
    local PlayerTab = Window:NewTab("Player")
    local PlayerSection = PlayerTab:NewSection("Player Settings")
    
    PlayerSection:NewSlider("WalkSpeed", "Change walk speed", 500, 16, function(value)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = value
        end
    end)
    
    PlayerSection:NewSlider("JumpPower", "Change jump power", 350, 50, function(value)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = value
        end
    end)
    
    PlayerSection:NewToggle("Infinite Energy", "Unlimited energy", function(state)
        if state then
            LocalPlayer.Character.Energy.Value = math.huge
        end
    end)
    
    -- Misc Tab
    local MiscTab = Window:NewTab("Misc")
    local MiscSection = MiscTab:NewSection("Miscellaneous")
    
    MiscSection:NewToggle("Auto Buy Haki", "Automatically buy Haki colors", function(state)
        AutoBuyHaki = state
        if state then
            while AutoBuyHaki do
                -- Haki buying logic
                wait(1)
            end
        end
    end)
    
    MiscSection:NewToggle("Auto Chest", "Automatically collect chests", function(state)
        AutoChest = state
        if state then
            while AutoChest do
                -- Chest collection logic
                wait(0.1)
            end
        end
    end)
    
    MiscSection:NewButton("Rejoin Server", "Rejoin current server", function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
    end)
    
    MiscSection:NewButton("Server Hop", "Jump to different server", function()
        -- Server hop logic
    end)
    
    -- Combat Tab
    local CombatTab = Window:NewTab("Combat")
    local CombatSection = CombatTab:NewSection("Combat Features")
    
    CombatSection:NewToggle("Auto Click", "Automatically click for combat", function(state)
        if state then
            while wait(0.1) do
                VirtualInputManager:SendKeyEvent(true, "X", false, game)
                wait()
                VirtualInputManager:SendKeyEvent(false, "X", false, game)
            end
        end
    end)
    
    CombatSection:NewToggle("Melee Range", "Increase melee attack range", function(state)
        MeleeRange = state
        if state then
            -- Melee range modification logic
        end
    end)
    
    -- ESP Tab
    local ESPTab = Window:NewTab("ESP")
    local ESPSection = ESPTab:NewSection("ESP Features")
    
    ESPSection:NewToggle("Player ESP", "Show player locations", function(state)
        if state then
            -- Player ESP logic
        end
    end)
    
    ESPSection:NewToggle("Chest ESP", "Show chest locations", function(state)
        if state then
            -- Chest ESP logic
        end
    end)
    
    ESPSection:NewToggle("Devil Fruit ESP", "Show devil fruit locations", function(state)
        if state then
            -- Devil Fruit ESP logic
        end
    end)
    
    -- Anti AFK System
    spawn(function()
        while wait(30) do
            VirtualInputManager:SendKeyEvent(true, "W", false, game)
            wait()
            VirtualInputManager:SendKeyEvent(false, "W", false, game)
        end
    end)
    
    -- Auto Farm Loop
    spawn(function()
        while wait() do
            if AutoFarm then
                AttackEnemy()
            end
        end
    end)
    
    -- Notification
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Astra Hub",
        Text = "Loaded Successfully!",
        Duration = 5
    })
    
    print("Astra Hub | Blox Fruits Loaded Successfully")
    
else
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Error",
        Text = "Wrong Game! Join Blox Fruits.",
        Duration = 5
    })
end
