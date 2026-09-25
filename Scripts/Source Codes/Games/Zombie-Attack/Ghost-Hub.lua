local _S__ = ""
if identifyexecutor then
    _S__ = select(1, identifyexecutor())
end
print(_S__)
if _S__ == "WeAreDevs" then
    game.StarterGui:SetCore("SendNotification", {Title = "Incompatible API", Text = "Experience may be degraded!", Icon = "rbxassetid://6902910134", Duration = 5, Button1 = "Okay"})
elseif _S__ == "Skisploit" then
    game.StarterGui:SetCore("SendNotification", {Title = "Incompatible API", Text = "Experience may be degraded!", Icon = "rbxassetid://6902910134", Duration = 5, Button1 = "Okay"})
end

local Library = loadstring(game:HttpGet("https://ghost-storage.7m.pl/scripts/UI_lib.lua"))()

local a = Library:Window("Ghost Hub")

local b = a:Tab("Autofarm")

local e = a:Tab("Big Head")

local c = a:Tab("Universal")

local d = a:Tab("Credits")

b:Toggle("Autofarm", function(State)
    _G.Autofarm = State
    _G.farm2 = State

        local groundDistance = 8
    local Player = game:GetService("Players").LocalPlayer
    local function getNearest()
    local nearest, dist = nil, 99999
    for _,v in pairs(game.Workspace.BossFolder:GetChildren()) do
    if(v:FindFirstChild("Head")~=nil)then
    local m =(Player.Character.Head.Position-v.Head.Position).magnitude
    if(m<dist)then
    dist = m
    nearest = v
    end
    end
    end
    for _,v in pairs(game.Workspace.enemies:GetChildren()) do
    if(v:FindFirstChild("Head")~=nil)then
    local m =(Player.Character.Head.Position-v.Head.Position).magnitude
    if(m<dist)then
    dist = m
    nearest = v
    end
    end
    end
    return nearest
    end

_G.globalTarget = nil
game:GetService("RunService").RenderStepped:Connect(function()
if(_G.farm2==true)then
local target = getNearest()
if(target~=nil)then
game:GetService("Workspace").CurrentCamera.CFrame = CFrame.new(game:GetService("Workspace").CurrentCamera.CFrame.p, target.Head.Position)
Player.Character.HumanoidRootPart.CFrame = (target.HumanoidRootPart.CFrame * CFrame.new(0, groundDistance, 9))
_G.globalTarget = target
end
end
end)
spawn(function()
while wait() do
game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
game.Players.LocalPlayer.Character.Torso.Velocity = Vector3.new(0,0,0)
end
end)
while wait() do
if(_G.farm2==true and _G.globalTarget~=nil and _G.Autofarm and _G.globalTarget:FindFirstChild("Head") and Player.Character:FindFirstChildOfClass("Tool"))then
local target = _G.globalTarget
game.ReplicatedStorage.Gun:FireServer({["Normal"] = Vector3.new(0, 0, 0), ["Direction"] = target.Head.Position, ["Name"] = Player.Character:FindFirstChildOfClass("Tool").Name, ["Hit"] = target.Head, ["Origin"] = target.Head.Position, ["Pos"] = target.Head.Position,})
wait()
end
end
end)

_G.HeadSize = 4
e:Toggle("Zombie big Head",function(State)
    _G.BigHead = State


    while _G.BigHead == true do

        for i,v in pairs(game.Workspace.enemies:GetChildren()) do

           wait()

           if v:FindFirstChild("Head") then

                v.Head.CanCollide = false

                v.Head.Size = Vector3.new(_G.HeadSize,_G.HeadSize,_G.HeadSize)

                v.Head.CFrame = game.Players.LocalPlayer.Character.Torso.CFrame*CFrame.new(0,0,-10)
                wait()
            end
        end
        wait()
    end
end)

e:Toggle("Boss big head",function(State)
    _G.Bossbighead = State


    while _G.Bossbighead == true do

        for i,v in pairs(game.Workspace.BossFolder:GetChildren()) do

           wait()

            if v:FindFirstChild("Head") then

               v.Head.CanCollide = false

               v.Head.Size = Vector3.new(_G.HeadSize,_G.HeadSize,_G.HeadSize)

               v.Head.CFrame = game.Players.LocalPlayer.Character.Torso.CFrame*CFrame.new(0,0,-8)
               wait()
            end
        end
        wait()
    end
end)

e:Slider("HeadSize", 1, 6, 4, function(value)
    _G.HeadSize = value
end)

b:Toggle("Auto Equip", function(State)
    _G.autoequip = State
    while _G.autoequip do
        for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
            if v.name == "Revolver" then
                v.Parent = game.Players.LocalPlayer.Character
            end
            if v.name == "Pistol" then
                v.Parent = game.Players.LocalPlayer.Character
            end
            if v.name == "Uzi" then
                v.Parent = game.Players.LocalPlayer.Character
            end
            if v.name == "Trench Shotgun" then
                v.Parent = game.Players.LocalPlayer.Character
            end
            if v.name == "M1 Garand" then
                v.Parent = game.Players.LocalPlayer.Character
            end
            if v.name == "Type 100" then
                v.Parent = game.Players.LocalPlayer.Character
            end
            if v.name == "M16" then
                v.Parent = game.Players.LocalPlayer.Character
            end
            if v.name == "Sniper" then
                v.Parent = game.Players.LocalPlayer.Character
            end
            if v.name == "Tactical Shotgun" then
                v.Parent = game.Players.LocalPlayer.Character
            end
            if v.name == "Thompson" then
                v.Parent = game.Players.LocalPlayer.Character
            end
            if v.name == "Blaster" then
                v.Parent = game.Players.LocalPlayer.Character
            end
            if v.name == "Machine Gun" then
                v.Parent = game.Players.LocalPlayer.Character
            end
            if v.name == "Cobra" then
                v.Parent = game.Players.LocalPlayer.Character
            end
            if v.name == "Fiery Cannon" then
                v.Parent = game.Players.LocalPlayer.Character
            end
            if v.name == "Toxic" then
                v.Parent = game.Players.LocalPlayer.Character
            end
            if v.name == "Retribution Ray" then
                v.Parent = game.Players.LocalPlayer.Character
            end
            if v.name == "Platinum Gun" then
                v.Parent = game.Players.LocalPlayer.Character
            end
            if v.name == "Scope Rifle" then
                v.Parent = game.Players.LocalPlayer.Character
            end
            if v.name == "Space Gun" then
                v.Parent = game.Players.LocalPlayer.Character
            end
            if v.name == "Rail Gun" then
                v.Parent = game.Players.LocalPlayer.Character
            end
            if v.name == "Ghost" then
                v.Parent = game.Players.LocalPlayer.Character
            end
            if v.name == "Alien Rifle" then
                v.Parent = game.Players.LocalPlayer.Character
            end
            if v.name == "Ray Gun" then
                v.Parent = game.Players.LocalPlayer.Character
            end
            if v.name == "Annihilator" then
                v.Parent = game.Players.LocalPlayer.Character
            end
            if v.name == "Biohazard" then
                v.Parent = game.Players.LocalPlayer.Character
            end
            if v.name == "Venom" then
                v.Parent = game.Players.LocalPlayer.Character
            end
            if v.name == "Golden Pistol" then
                v.Parent = game.Players.LocalPlayer.Character
            end
            if v.name == "Rainbow Blaster" then
                v.Parent = game.Players.LocalPlayer.Character
            end
            if v.name == "Hex Spitter" then
                v.Parent = game.Players.LocalPlayer.Character
            end
            if v.name == "Beam Launcher" then
                v.Parent = game.Players.LocalPlayer.Character
            end
            if v.name == "Gatling Laser" then
                v.Parent = game.Players.LocalPlayer.Character
            end
            if v.name == "Tri Laser" then
                v.Parent = game.Players.LocalPlayer.Character
            end
            if v.name == "Techno Rifle" then
                v.Parent = game.Players.LocalPlayer.Character
            end
            if v.name == "Minigun" then
                v.Parent = game.Players.LocalPlayer.Character
            end
            if v.name == "Flamethrower" then
                v.Parent = game.Players.LocalPlayer.Character
            end
            if v.name == "Pumpkin Blaster" then
                v.Parent = game.Players.LocalPlayer.Character
            end
            if v.name == "Invader Crossbow" then
                v.Parent = game.Players.LocalPlayer.Character
            end
            if v.name == "Halloween Staff" then
                v.Parent = game.Players.LocalPlayer.Character
            end
        end
        wait()
    end
end)

b:Toggle("Anti-AFK",function(State)
    _G.AntiAFK = State
    while _G.AntiAFK == true do
        local vu = game:GetService("VirtualUser")
        game:GetService("Players").LocalPlayer.Idled:connect(function()
        vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        wait(1)
        vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        end)
        wait()
    end
end)

b:Toggle("Auto get Power ups",function(State)
    _G.collectpowerup = State
    while _G.collectpowerup == true do

        for i,v in pairs(game:GetService("Workspace").Powerups:GetDescendants()) do
            if v.Name == "TouchInterest" then
                firetouchinterest(game.Players.LocalPlayer.Character.Head, v.Parent, 0)
            end
        end
        wait()
    end
end)

b:Toggle("Claim mission rewards",function(State)
    _G.claimreward = State
    while _G.claimreward == true do

a = 1

repeat

   local args = {
    [1] = "claimReward",
    [2] = a
}
game:GetService("ReplicatedStorage").RemoteEventContainer.CommunicationF:InvokeServer(unpack(args))
   a = a + 1
until( a > 100 )
end
wait()
end)

if firesignal then
firesignal(game:GetService("Players").LocalPlayer.PlayerGui.MainInterface.ButtonsHolder.Main.Menu.MouseButton1Click)
firesignal(game:GetService("Players").LocalPlayer.PlayerGui.MainInterface.ButtonsHolder.Main.Menu.MouseButton1Click)

b:Toggle("Auto buy guns",function(State)
    _G.autobuy = State
    while _G.autobuy == true do

            for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.MainInterface.MenuHolder.Main.ShopMain.ItemHolder.Primary:GetDescendants()) do
                if v.Parent.Name == "Primary" and v.owned.Visible == false then
                    local args = {
                        [1] = "BuyItem_Cash",
                        [2] = v.Name
                    }
                    
                    game:GetService("ReplicatedStorage").RemoteEventContainer.CommunicationF:InvokeServer(unpack(args))

                    local args = {
                        [1] = "EquipItem",
                        [2] = v.name
                    }
                    game:GetService("ReplicatedStorage").RemoteEventContainer.CommunicationF:InvokeServer(unpack(args))
                    wait(0.1)
                end
            end

        firesignal(game:GetService("Players").LocalPlayer.PlayerGui.MainInterface.ButtonsHolder.Main.Menu.MouseButton1Click)
        firesignal(game:GetService("Players").LocalPlayer.PlayerGui.MainInterface.ButtonsHolder.Main.Menu.MouseButton1Click)
        wait()
    end
end)

end

c:Slider("WalkSpeed", 0, 200, 16, function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)

c:Slider("JumpPower", 0, 200, 16, function(value)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
end)

c:Toggle("Fly (E toggle)",function(State)
    --skidded LOL
    sex2 = State
    local Max = 0
    local Players = game.Players
    local LP = Players.LocalPlayer
    local Mouse = LP:GetMouse()
    Mouse.KeyDown:connect(function(k)
    if k:lower() == 'e' then
    Max = Max + 1
    getgenv().Fly = false
    if sex2 then
    local T = LP.Character.UpperTorso
    local S = {
    F = 0,
    B = 0,
    L = 0,
    R = 0
    }
    local S2 = {
    F = 0,
    B = 0,
    L = 0,
    R = 0
    }
    local SPEED = 5
    local function FLY()
    getgenv().Fly = true
    local BodyGyro = Instance.new('BodyGyro', T)
    local BodyVelocity = Instance.new('BodyVelocity', T)
    BodyGyro.P = 9e4
    BodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    BodyGyro.cframe = T.CFrame
    BodyVelocity.velocity = Vector3.new(0, 0.1, 0)
    BodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
    spawn(function()
    repeat
    wait()
    LP.Character.Humanoid.PlatformStand = false
    if S.L + S.R ~= 0 or S.F + S.B ~= 0 then
    SPEED = 200
    elseif not (S.L + S.R ~= 0 or S.F + S.B ~= 0) and SPEED ~= 0 then
    SPEED = 0
    end
    if (S.L + S.R) ~= 0 or (S.F + S.B) ~= 0 then
    BodyVelocity.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (S.F + S.B)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(S.L + S.R, (S.F + S.B) * 0.2, 0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
    S2 = {
    F = S.F,
    B = S.B,
    L = S.L,
    R = S.R
    }
    elseif (S.L + S.R) == 0 and (S.F + S.B) == 0 and SPEED ~= 0 then
    BodyVelocity.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (S2.F + S2.B)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(S2.L + S2.R, (S2.F + S2.B) * 0.2, 0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
    else
    BodyVelocity.velocity = Vector3.new(0, 0.1, 0)
    end
    BodyGyro.cframe = game.Workspace.CurrentCamera.CoordinateFrame
    until not getgenv().Fly
    S = {
    F = 0,
    B = 0,
    L = 0,
    R = 0
    }
    S2 = {
    F = 0,
    B = 0,
    L = 0,
    R = 0
    }
    SPEED = 0
    BodyGyro:destroy()
    BodyVelocity:destroy()
    LP.Character.Humanoid.PlatformStand = false
    end)
    end
    Mouse.KeyDown:connect(function(k)
    if k:lower() == 'w' then
    S.F = 1
    elseif k:lower() == 's' then
    S.B = -1
    elseif k:lower() == 'a' then
    S.L = -1
    elseif k:lower() == 'd' then
    S.R = 1
    end
    end)
    Mouse.KeyUp:connect(function(k)
    if k:lower() == 'w' then
    S.F = 0
    elseif k:lower() == 's' then
    S.B = 0
    elseif k:lower() == 'a' then
    S.L = 0
    elseif k:lower() == 'd' then
    S.R = 0
    end
    end)
    FLY()
    if Max == 2 then
    getgenv().Fly = false
    Max = 0
    end
    end
    end
    end)
end)

c:Toggle("Infinite jump",function(State)
    Infinite = State
    game:GetService("UserInputService").JumpRequest:connect(function()
        if Infinite then
            game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState("Jumping")
        end
    end)
end)

d:Label("Ghost Hub")


d:Button("Copy discord link",function()
    setclipboard("https://discord.com/invite/JKzWeeCDas")
end)

local notifSound = Instance.new("Sound",workspace)
notifSound.PlaybackSpeed = 1.5
notifSound.Volume = 0.15
notifSound.SoundId = "rbxassetid://170765130"
notifSound.PlayOnRemove = true
notifSound:Destroy()
game.StarterGui:SetCore("SendNotification", {Title = "Zombie attack", Text = "Zombie attack loaded successfully!", Icon = "rbxassetid://505845268", Duration = 5, Button1 = "Okay"})
