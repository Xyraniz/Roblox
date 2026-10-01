repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local Player = Players.LocalPlayer

while not Player do
    task.wait()
    Player = Players.LocalPlayer
end

local playerGui = Player:WaitForChild("PlayerGui")

local Library = { Flags = {}, Keybinds = {} }
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function createParrySender()
    local playerData = require(ReplicatedStorage.Packages.Replion).Client:WaitReplion("Data")
    local serverInfo = require(ReplicatedStorage.ServerInfo)
    local universeIds = require(ReplicatedStorage.Shared.UniverseIds)
    local noobParry = not serverInfo.isDungeonsMatchServer()
        and game.PlaceId ~= universeIds.RankedMatches.PlaceId
        and game.PlaceId ~= universeIds.RankedMatchesNoAbility.PlaceId
        and not serverInfo.isMedalServer()
        and not serverInfo.isClanWarServer()
        and not serverInfo.isTournamentMatchServer()
        and require(ReplicatedStorage.Common.Utils).FFlag.GetInstantFFlag("NoobParryEnabled", true)
    local parryFunction = require(ReplicatedStorage.Controllers["SwordsController \012"].PRY)
    local encoder = debug.getupvalue(parryFunction, 4)
    local hash = debug.getupvalue(parryFunction, 8)
    local remote, key, timeKey
    local timeHash = {}
    local durations = {1.5, 1.25, 1, 0.75, 0.625}
    local signal = require(ReplicatedStorage.Packages.Signal).new()
    signal:Connect(parryFunction)

    local function capture(event, eventHash, eventKey, proof, duration, direction, targets, aim, flag)
        if eventHash == hash and type(eventKey) == "string" and type(proof) == "string"
            and type(duration) == "number" and typeof(direction) == "CFrame"
            and type(targets) == "table" and type(aim) == "table" and type(flag) == "boolean" then
            remote, key = event, eventKey
        end
    end
    local fireServer
    fireServer = hookfunction(Instance.new("RemoteEvent").FireServer, newcclosure(function(event, ...)
        if not remote and not checkcaller() then
            capture(event, ...)
        end
        return fireServer(event, ...)
    end))

    return function(direction, targets, aim)
        local duration = durations[(playerData:Get("timesParried") or 0) + 1] or 0.5
        if noobParry then
            local kills = playerData:Get("TotalStats.Kills") or 0
            duration = kills < 20 and duration * kills / 20 or duration
        end
        if not key then
            signal:Fire(duration, direction, targets, aim, false)
            return true
        end
        timeKey = timeKey or encoder(key, "TIME")
        local stamp = tostring(math.floor(workspace:GetServerTimeNow() * 100))
        table.clear(timeHash)
        for index = 1, #stamp do
            timeHash[index] = string.char(bit32.bxor(
                (string.byte(stamp, index) + index) % 256,
                string.byte(timeKey, (index - 1) % #timeKey + 1)
            ))
        end
        fireServer(remote, hash, key, table.concat(timeHash), duration, direction, targets, aim, false)
        return true
    end
end

local sendParry = createParrySender()

local ConnectionsManager = {}
local AutoParry = {}
local FinishersController = require(game.ReplicatedStorage.Controllers.FinishersController)
local RunService = game:GetService("RunService")
local VirtualInputManager = Instance.new("VirtualInputManager")
local balls = workspace:WaitForChild("Balls")
local UserInputService = game:GetService("UserInputService")
local touchEnabled = UserInputService.TouchEnabled
local ReplicatedInstances = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("ReplicatedInstances")
local Swords = require(ReplicatedInstances:WaitForChild("Swords"))

local SavedSwordModel = Swords:GetSword(Player:GetAttribute("CurrentlyEquippedSword"))

local PlayParry, SetSword, BlockKeybind, RealBallPosition, TrackedBall
do
    PlayParry = nil
    local swordsController
    SetSword = function(name)
        if not swordsController then
            for _, connection in getconnections(ReplicatedStorage.Remotes.ParrySuccess.OnClientEvent) do
                local values = connection.Function and (getupvalues or debug.getupvalues)(connection.Function)
                if type(values) == "table" then
                    for _, value in values do
                        if type(value) == "table" and type(rawget(value, "SetSword")) == "function" then
                            swordsController = value
                            break
                        end
                    end
                end
                if swordsController then
                    break
                end
            end
        end

        if swordsController then
            swordsController:SetSword(name)
        end
    end

    do
        local net = ReplicatedStorage.Packages._Index["sleitnick_net@0.1.0"].net
        BlockKeybind = playerGui.Settings.Frame.Frame["Keybinds/Block"].Keybind1.TextBox.Text or playerGui.Settings.Frame.Frame["Keybinds/Block"].Keybind2.TextBox.Text or playerGui.Settings.Frame.Frame["Keybinds/Block"].Keybind3.TextBox.Text
        RealBallPosition = nil
        TrackedBall = nil

        for _, child in net:GetChildren() do
            if child:IsA("UnreliableRemoteEvent") and child.Name ~= "URE/ReplicateBallPosition" then
                ConnectionsManager["Real Ball Position"] = child.OnClientEvent:Connect(function(arg, arg2)
                    if not arg or not arg.Parent then
                        if arg == TrackedBall then
                            TrackedBall = nil
                            RealBallPosition = nil
                        end

                        return
                    end

                    TrackedBall = arg
                    RealBallPosition = arg2
                end)
            end
        end
    end
end

for _, connection in getconnections(ReplicatedStorage.Remotes.FireSwordInfo.OnClientEvent) do
    connection:Disable()
    connection:Disconnect()
end

for _, connection in getconnections(ReplicatedStorage.Remotes.ParrySuccessAll.OnClientEvent) do
    if connection and connection.Function then
        PlayParry = connection.Function
        connection:Disable()
        connection:Disconnect()
    end
end

local emotes = { storage = { current = nil, Trove = nil } }

for _, child in game:GetService("ReplicatedStorage").Misc.Emotes:GetChildren() do
    if child:IsA("Animation") and child:GetAttribute("EmoteName") then
        emotes.storage[child:GetAttribute("EmoteName")] = child
    end
end


if isfile("Aries/fav_emotes.json") then
    local json = readfile("Aries/fav_emotes.json")
    data = game:GetService("HttpService"):JSONDecode(json)
else
    data = {}
end

local function saveFavoriteEmotes()
    writefile("Aries/fav_emotes.json", game:GetService("HttpService"):JSONEncode(data))
end

local wheelSlots
if isfile("Aries/wheel_slots.json") then
    wheelSlots = game:GetService("HttpService"):JSONDecode(readfile("Aries/wheel_slots.json"))
else
    wheelSlots = {}
end

local function saveWheelSlots()
    writefile("Aries/wheel_slots.json", game:GetService("HttpService"):JSONEncode(wheelSlots))
end

AutoParry.Client_Ball = function()
    for _, child in workspace.Balls:GetChildren() do
        if not child:GetAttribute("realBall") then
            return child
        end
    end
end

AutoParry.Get_Ball = function()
    for _, child in balls:GetChildren() do
        if child:GetAttribute("realBall") then
            return child
        end
    end
end

AutoParry.Get_Balls = function()
    local list = {}

    for _, child in balls:GetChildren() do
        if child:GetAttribute("realBall") then
            table.insert(list, child)
        end
    end

    return list
end

AutoParry.Get_Crosshair_Target = function()
    local currentCamera = workspace.CurrentCamera
    local alive = workspace.Alive
    if not alive then
        return false
    end
    local viewportSize = currentCamera.ViewportSize
    local vector2 = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
    local huge = math.huge
    local target = nil

    for _, child in alive:GetChildren() do
        if child ~= Player.Character and child.PrimaryPart then
            local screenPoint, onScreen = currentCamera:WorldToScreenPoint(child.PrimaryPart.Position)

            if onScreen then
                local magnitude = (Vector2.new(screenPoint.X, screenPoint.Y) - vector2).Magnitude

                if magnitude < huge then
                    target = { Character = child, Screen_Data = { screenPoint.X, screenPoint.Y } }
                    huge = magnitude
                end
            end
        end
    end

    return target
end

do
    local chosen = nil

    AutoParry.Closest_Aim = function()
        local alive = workspace.Alive
        if Player.Character.Parent ~= alive then
            return false
        end
        local bestLookDot = -math.huge
        local currentCamera = workspace.CurrentCamera
        local closestCharacter = nil

        for _, child in alive:GetChildren() do
            if child ~= Player.Character and child.PrimaryPart then
                child:FindFirstChildOfClass("Humanoid")
                local dot = currentCamera.CFrame.LookVector:Dot((child.PrimaryPart.Position - currentCamera.CFrame.Position).Unit)
                local screenPoint, onScreen = currentCamera:WorldToViewportPoint(child.PrimaryPart.Position)

                if onScreen and dot > bestLookDot then
                    bestLookDot = dot
                    closestCharacter = child
                end
            end
        end

        chosen = closestCharacter
        return chosen
    end
end

AutoParry.Force_Target = function()
    local currentCamera = workspace.CurrentCamera
    local alive = workspace.Alive
    if not alive then
        return false
    end
    local huge = math.huge
    local target = nil

    for _, child in alive:GetChildren() do
        if child ~= Player.Character and child.PrimaryPart then
            local screenPoint, onScreen = currentCamera:WorldToScreenPoint(child.PrimaryPart.Position)

            if onScreen then
                local magnitude = (Player.Character.PrimaryPart.Position - child.PrimaryPart.Position).Magnitude

                if magnitude < huge then
                    target = { Character = child, Screen_Data = { screenPoint.X, screenPoint.Y } }
                    huge = magnitude
                end
            end
        end
    end

    if not target then
        return false
    end
    return target
end

AutoParry.FFA = function()
    local currentCamera = workspace.CurrentCamera
    local alive = workspace.Alive
    if not alive then
        return false
    end
    local ball = AutoParry.Get_Ball()
    if not ball then
        Last_FFA_Target = nil
        return false
    end

    if not ball:FindFirstChild("zoomies") then
        return false
    end
    local attribute = ball:GetAttribute("target")

    if attribute ~= Last_FFA_Target then
        Last_FFA_Target = nil
    end

    local targets = {}

    for _, child in alive:GetChildren() do
        if child ~= Player.Character and child.PrimaryPart then
            local screenPoint, onScreen = currentCamera:WorldToScreenPoint(child.PrimaryPart.Position)

            if onScreen and child.Name ~= attribute and child ~= Last_FFA_Target then
                table.insert(targets, { Character = child, Screen_Data = { screenPoint.X, screenPoint.Y } })
            end
        end
    end

    if #targets < 1 then
        return false
    end
    local picked = targets[math.random(1, #targets)]
    Last_FFA_Target = picked.Character.Name
    return picked
end

AutoParry.select_target_by_mouse = function()
    local list = {}

    for _, child in workspace.Alive:GetChildren() do
        if child.Name ~= Player.Name and child.PrimaryPart then
            table.insert(list, child)
        end
    end

    local currentCamera = workspace.CurrentCamera
    local mouseLocation = UserInputService:GetMouseLocation()
    local direction = currentCamera:ScreenPointToRay(mouseLocation.X, mouseLocation.Y).Direction
    local bestMouseDot = -math.huge
    local chosen = nil

    for _, entry in list do
        local dot = direction:Dot((entry.PrimaryPart.Position - currentCamera.CFrame.Position).Unit)

        if bestMouseDot < dot then
            bestMouseDot = dot
            chosen = entry
        end
    end

    return chosen
end

AutoParry.Parry_Data = function(arg)
    if touchEnabled then
        Vector2_Mouse_Location = {
            workspace.CurrentCamera.ViewportSize.X / 2,
            workspace.CurrentCamera.ViewportSize.Y / 2,
        }
    else
        local mouseLocation = UserInputService:GetMouseLocation()
        Vector2_Mouse_Location = { mouseLocation.X, mouseLocation.Y }
    end

    local screenPositions = {}

    for _, child in workspace.Alive:GetChildren() do
        screenPositions[child.Name] = workspace.CurrentCamera:WorldToScreenPoint(child.HumanoidRootPart.Position)
    end

    if arg == "Camera" then
        local parryPayload = {}
        local cframe = CFrame.new(workspace.CurrentCamera.CFrame.Position, workspace.CurrentCamera.CFrame.Position + workspace.CurrentCamera.CFrame.LookVector)
        local mouseLocation2 = Vector2_Mouse_Location
        parryPayload[1] = 0
        parryPayload[2] = cframe
        parryPayload[3] = screenPositions
        parryPayload[4] = mouseLocation2
        return parryPayload
    end

    if arg == "Random" then
        local parryPayload2 = {}
        local cframe = CFrame.new(workspace.CurrentCamera.CFrame.Position, Vector3.new(math.random(-3000, 3000), math.random(-3000, 3000), math.random(-3000, 3000)))
        local mouseLocation3 = Vector2_Mouse_Location
        parryPayload2[1] = 0
        parryPayload2[2] = cframe
        parryPayload2[3] = screenPositions
        parryPayload2[4] = mouseLocation3
        return parryPayload2
    end

    if arg == "Backwards" then
        local n41 = -workspace.CurrentCamera.CFrame.LookVector * 10000
        local parryPayload3 = {}
        local cframe = CFrame.new(workspace.CurrentCamera.CFrame.Position, workspace.CurrentCamera.CFrame.Position + Vector3.new(n41.X, 100, n41.Z))
        local mouseLocation4 = Vector2_Mouse_Location
        parryPayload3[1] = 0
        parryPayload3[2] = cframe
        parryPayload3[3] = screenPositions
        parryPayload3[4] = mouseLocation4
        return parryPayload3
    end

    if arg == "High" then
        local parryPayload4 = {}
        local cframe = CFrame.new(workspace.CurrentCamera.CFrame.Position, workspace.CurrentCamera.CFrame.Position + Vector3.new(0, 10000, 0))
        local mouseLocation5 = Vector2_Mouse_Location
        parryPayload4[1] = 0
        parryPayload4[2] = cframe
        parryPayload4[3] = screenPositions
        parryPayload4[4] = mouseLocation5
        return parryPayload4
    end

    if arg == "Dot" then
        local crosshairTarget = AutoParry.Get_Crosshair_Target()

        if crosshairTarget then
            local screenData = crosshairTarget.Screen_Data

            return {
                0,
                CFrame.new(Player.Character.PrimaryPart.Position, crosshairTarget.Character.PrimaryPart.Position + Vector3.new(0, 1.75, 0)),
                screenPositions,
                screenData,
            }
        end

        local keypoints = {}
        local constant = 0
        local cframe = CFrame.new(workspace.CurrentCamera.CFrame.Position, workspace.CurrentCamera.CFrame.Position + workspace.CurrentCamera.CFrame.LookVector)
        local mouseLocation6 = Vector2_Mouse_Location
        keypoints[1] = constant
        keypoints[2] = cframe
        keypoints[3] = screenPositions
        keypoints[4] = mouseLocation6
        return keypoints
    end

    if arg == "Dot Pointer" then
        local currentCamera = workspace.CurrentCamera
        local mouseTarget = AutoParry.select_target_by_mouse()
        local position = mouseTarget and mouseTarget.PrimaryPart and mouseTarget.PrimaryPart.Position or Player.Character.PrimaryPart.Position + currentCamera.CFrame.LookVector * 1000
        local mouseLocation7 = Vector2_Mouse_Location

        return {
            0,
            CFrame.lookAt(Player.Character.PrimaryPart.Position, position + Vector3.new(0, 2, 0)),
            screenPositions,
            mouseLocation7,
        }
    end

    if arg == "Closest" then
        local forcedTarget = AutoParry.Force_Target()

        if forcedTarget then
            local screenData = forcedTarget.Screen_Data

            return {
                0,
                CFrame.new(Player.Character.PrimaryPart.Position, forcedTarget.Character.PrimaryPart.Position),
                screenPositions,
                screenData,
            }
        end

        local parryPayload5 = {}
        local cframe = CFrame.new(workspace.CurrentCamera.CFrame.Position, workspace.CurrentCamera.CFrame.Position + workspace.CurrentCamera.CFrame.LookVector)
        local mouseLocation8 = Vector2_Mouse_Location
        parryPayload5[1] = 0
        parryPayload5[2] = cframe
        parryPayload5[3] = screenPositions
        parryPayload5[4] = mouseLocation8
        return parryPayload5
    end

    if arg == "FFA" then
        local ffaTarget = AutoParry.FFA()

        if ffaTarget then
            local screenData = ffaTarget.Screen_Data

            return {
                0,
                CFrame.new(Player.Character.PrimaryPart.Position, ffaTarget.Character.PrimaryPart.Position),
                screenPositions,
                screenData,
            }
        end

        local parryPayload6 = {}
        local cframe = CFrame.new(workspace.CurrentCamera.CFrame.Position, workspace.CurrentCamera.CFrame.Position + workspace.CurrentCamera.CFrame.LookVector)
        local mouseLocation9 = Vector2_Mouse_Location
        parryPayload6[1] = 0
        parryPayload6[2] = cframe
        parryPayload6[3] = screenPositions
        parryPayload6[4] = mouseLocation9
        return parryPayload6
    end

    return arg
end

do
    AutoParry.Parry = function(arg)
        if Library.Flags.Parry_Options == "Hardware" then
            mouse1click()
            return
        end

        if Library.Flags.Parry_Options == "Keyboard" then
            return AutoParry.Animation_Fix()
        end

        local parryData = AutoParry.Parry_Data(arg)
        return sendParry(parryData[2], parryData[3], parryData[4])
    end
end

do
    AutoParry.Animation_Fix = function()
        local identity = getthreadidentity()
        if identity ~= 8 then
            setthreadidentity(8)
        end
        local ok, message = pcall(function()
            VirtualInputManager:SendKeyEvent(true, BlockKeybind, false, game)
            VirtualInputManager:SendKeyEvent(false, BlockKeybind, false, game)
        end)
        if identity ~= 8 then
            setthreadidentity(identity)
        end
        if not ok then
            error(message, 0)
        end
    end
end

local BypassCooldown = false
do
    local animationController = require(ReplicatedStorage.Controllers.AnimationController)
    local swordApi = require(ReplicatedStorage.Shared.SwordAPI)
    local LastPlayed = 0

    AutoParry.Parry_Animation = function()
        local character = Player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
        if not animator then
            return
        end

        local attribute = character:GetAttribute("CurrentlyEquippedSword") or Player:GetAttribute("CurrentlyEquippedSword")
        if not attribute then
            return
        end
        local swordInfo = Swords:GetSword(attribute)
        if not swordInfo or character ~= Player.Character then
            return
        end

        for _, track in animationController:GetPlayingAnimationTracks(animator) do
            if track:GetAttribute("GrabParry") or track:GetAttribute("Parry") or track.Name == "GrabParry" or track.Name == "Grab" or track.Name == "Parry" or track.Name == "SuccessParry" or track.Name == "Success" then
                track:Stop(track:GetAttribute("StopFadeTime") or 0.1)
            end
        end

        for _, animation in swordApi:GetAnimations(character, {"Parry", "GrabParry"}, swordInfo.AnimationType, swordInfo.SwordType) do
            local track = animationController:LoadAnimation(animator, animation, true)
            local speed = track:GetAttribute("PlaySpeed") or 1
            track:Play(track:GetAttribute("PlayFadeTime") or 0.1, track:GetAttribute("PlayWeight") or 1, speed)
            character:SetAttribute("ParryTime", math.max(character:GetAttribute("ParryTime") or 0, track.Length == 0 and 1 or (track.Length - track.TimePosition) * speed))
        end
    end

    AutoParry.Play_Animation = function()
        if os.clock() - LastPlayed >= 1 or BypassCooldown then
            LastPlayed = os.clock()
            BypassCooldown = false
            AutoParry.Parry_Animation()
        end
    end
end

local CurveDataByBall = {}
local LastParry, Parried
do
    local chosen = nil

    AutoParry.Closest_Player = function()
        local alive = workspace.Alive
        if (Player.Character or Player.CharacterAdded:Wait()).Parent ~= alive then
            return false
        end
        local huge = math.huge
        local closestCharacter = nil

        for _, child in alive:GetChildren() do
            if child and child.Name ~= Player.Name then
                local distance = Player:DistanceFromCharacter(child.HumanoidRootPart.Position)

                if distance < huge then
                    huge = distance
                    closestCharacter = child
                end
            end
        end

        chosen = closestCharacter
        return chosen
    end

    AutoParry.Linear_Interpolation = function(arg, arg2, arg3)
        return arg + (arg2 - arg) * arg3
    end

    AutoParry.Get_Ping = function()
        local ok, value = pcall(function()
            return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
        end)
        return ok and value or Player:GetNetworkPing() * 1000
    end

    AutoParry.Get_Curve = function(ball)
        if CurveDataByBall[ball] then
            return CurveDataByBall[ball]
        end

        local data = {
            Curving = 0,
            Lerp_Radians = 0,
            Last_Warping = 0,
            Dot = 0,
            Flips = 0,
            Flip_Time = 0,
            Backward_Dot = 0,
            Backward_Flips = 0,
            Backward_Flip_Time = 0,
            Returned = false,
            Target_Count = 0,
        }
        CurveDataByBall[ball] = data

        local function update()
            local from = ball:GetAttribute("from")
            local clone = AutoParry.Encrypted_Clone()
            local name = clone and clone.Name

            if from == Player.Name and data.First_Hit then
                data.Returned = true
            elseif from and from ~= "" and from ~= Player.Name and from ~= name then
                data.First_Hit = data.First_Hit or from
                data.Returned = false
            end
        end

        data.From = ball:GetAttributeChangedSignal("from"):Connect(update)
        data.Target = ball:GetAttributeChangedSignal("target"):Connect(function()
            Parried = false
            data.Target_Count += 1
            data.Triggerbot_Parried = false
            if AutoParry.Triggerbot then
                AutoParry.Triggerbot(ball, true)
            end
        end)
        update()
        return data
    end

    local function Targeted_Ball()
        for _, ball in AutoParry.Get_Balls() do
            if ball:GetAttribute("target") == Player.Name then
                return ball
            end
        end
    end

    function AutoParry.Is_Curved(Ball)
        Ball = Ball or Targeted_Ball()
        local Character = Player.Character
        local PrimaryPart = Character and Character.PrimaryPart

        if not Ball or not PrimaryPart or Ball:GetAttribute("target") ~= Player.Name then
            return false
        end

        local Zoomies = Ball:FindFirstChild("zoomies")
        if not Zoomies then
            return false
        end

        local Velocity = Zoomies.VectorVelocity
        local Ball_Position = Ball == TrackedBall and RealBallPosition or Ball.Position
        local Offset = PrimaryPart.Position - Ball_Position
        local Speed = Velocity.Magnitude
        local Distance = Offset.Magnitude

        if Speed < 0.001 or Distance < 0.001 then
            return false
        end

        local Curve_Data = AutoParry.Get_Curve(Ball)
        local Ball_Direction = Velocity.Unit
        local Direction = Offset.Unit
        local Dot = Direction:Dot(Ball_Direction)
        local Speed_Threshold = math.min(Speed / 100, 40)
        local Direction_Difference = Ball_Direction - Velocity
        local Dot_Difference = Direction_Difference.Magnitude > 0.001 and math.clamp(Dot - Direction:Dot(Direction_Difference.Unit), -1, 1) or Dot
        local Pings = AutoParry.Get_Ping()
        local Dot_Threshold = 0.5 - Pings / 1000
        local Angle_Threshold = 20 * math.max(Dot, 0)
        local Reach_Time = math.max(0, Distance / Speed - Pings / 1000)
        local Ball_Distance_Threshold = 15 - math.min(Distance / 1000, 15) + Angle_Threshold + Speed_Threshold
        local Singularity = PrimaryPart:FindFirstChild("SingularityCape")
        local Radians = math.rad(math.asin(math.clamp(Dot, -1, 1)))
        local Time = os.clock()

        if not Singularity and math.sign(Dot) ~= math.sign(Curve_Data.Dot) then
            if Time - Curve_Data.Flip_Time < 0.2 then
                Curve_Data.Flips += 1
            else
                Curve_Data.Flips = 0
            end

            Curve_Data.Flip_Time = Time
        end

        Curve_Data.Dot = Dot
        Curve_Data.Lerp_Radians = AutoParry.Linear_Interpolation(Curve_Data.Lerp_Radians, Radians, 0.8)

        if Speed > 100 and Reach_Time > Pings / 10 then
            Ball_Distance_Threshold = math.max(Ball_Distance_Threshold - 15, 15)
        end

        if Curve_Data.Flips >= 5 then
            return false
        end

        if Dot < 0 then
            return true
        end

        if Distance < Ball_Distance_Threshold then
            return false
        end

        if Dot_Difference < Dot_Threshold then
            return true
        end

        if Curve_Data.Lerp_Radians < 0.018 then
            Curve_Data.Last_Warping = tick()
        end

        if tick() - Curve_Data.Last_Warping < Reach_Time / 1.5 then
            return true
        end

        if Distance > Ball_Distance_Threshold and tick() - Curve_Data.Curving < Reach_Time / 1.5 then
            return true
        end
        return Dot < Dot_Threshold
    end

    AutoParry.Encrypted_Clone = function()
        for _, child in workspace.Alive:GetChildren() do
            if child and child.Name and child.Name:find("ENCRYPTED CLONE", 1, true) then
                return child
            end
        end
    end

    function AutoParry.Is_Curved2(Ball)
        if game.PlaceId == 15264892126 then
            return false
        end
        local Alive = workspace.Alive
        local Count = #Alive:GetChildren()

        if game.PlaceId == 13772394625 and Count > 2 then
            return false
        end

        local Showdown = workspace:FindFirstChild("ShowdownActive")
        if not Showdown then
            return false
        end
        Ball = Ball or Targeted_Ball()
        local Character = Player.Character
        local PrimaryPart = Character and Character.PrimaryPart

        if not Ball or not PrimaryPart or Ball:GetAttribute("target") ~= Player.Name then
            return false
        end

        local Zoomies = Ball:FindFirstChild("zoomies")
        if not Zoomies then
            return false
        end

        local Ball_Position = Ball == TrackedBall and RealBallPosition or Ball.Position
        local Velocity = Zoomies.VectorVelocity
        local Offset = PrimaryPart.Position - Ball_Position
        local Distance = Offset.Magnitude

        if Distance < 0.001 or Velocity.Magnitude < 0.001 then
            return false
        end

        local Curve_Data = AutoParry.Get_Curve(Ball)
        local Dot = Offset.Unit:Dot(Velocity.Unit)
        local Time = os.clock()

        if math.sign(Dot) ~= math.sign(Curve_Data.Backward_Dot) then
            if Time - Curve_Data.Backward_Flip_Time < 0.2 then
                Curve_Data.Backward_Flips += 1
            else
                Curve_Data.Backward_Flips = 0
            end

            Curve_Data.Backward_Flip_Time = Time
        end

        Curve_Data.Backward_Dot = Dot

        local From = Ball:GetAttribute("from")
        local Clone = AutoParry.Encrypted_Clone()
        local Name = Clone and Clone.Name

        if Name and Curve_Data.First_Hit and Curve_Data.First_Hit ~= Name and From == Name and not Curve_Data.Returned and game.PlaceId == 15234596844 and Count > 2 then
            return false
        end

        AutoParry.Is_Curved(Ball)

        local Look_Vector = workspace.CurrentCamera.CFrame.LookVector
        local Camera_Direction = Vector3.new(Look_Vector.X, 0, Look_Vector.Z)
        if Camera_Direction.Magnitude > 0 and Camera_Direction.Unit:Dot((Ball_Position - PrimaryPart.Position).Unit) >= 0 and Dot >= 0 then
            return false
        end

        local Predicted_Distance = (Offset + Velocity * 0.15).Magnitude
        return (game.PlaceId == 15234596844 or Count == 2) and Time - LastParry > 0.5 and Predicted_Distance > Distance + 15.5 and Curve_Data.Backward_Flips < 6
    end

    AutoParry.Get_Entity_Properties = function()
        AutoParry.Closest_Player()
        if not chosen then
            return false
        end

        return {
            Velocity = chosen.HumanoidRootPart.AssemblyLinearVelocity,
            Direction = (Player.Character.HumanoidRootPart.Position - chosen.HumanoidRootPart.Position).Unit,
            Distance = (Player.Character.HumanoidRootPart.Position - chosen.HumanoidRootPart.Position).Magnitude,
        }
    end
end

local saveFavoriteSwords, favoriteSword, favoriteExplosion, lastEquipped
local ownedItems, originalFindItems, emoteGrid, saveLastExplosion, lastExplosion
do
    local HttpService

    do
        AutoParry.Get_Ball_Properties = function(arg, arg2)
            if not arg2 then
                return false
            end
            local zoomies = arg2:FindFirstChild("zoomies")
            if not zoomies then
                return false
            end
            local vectorVelocity = zoomies.VectorVelocity
            local position

            if arg2 == TrackedBall and RealBallPosition then
                position = RealBallPosition
            else
                position = arg2.Position
            end

            local unit = (Player.Character.HumanoidRootPart.Position - position).Unit

            return {
                Speed = vectorVelocity.Magnitude,
                Velocity = vectorVelocity,
                Direction = unit,
                Distance = (Player.Character.HumanoidRootPart.Position - position).Magnitude,
                Dot = unit:Dot(vectorVelocity.Unit),
            }
        end

        AutoParry.Spam_Service = function(arg)
            local ball = arg.Ball
            if not ball then
                return false
            end
            local zoomies = ball:FindFirstChild("zoomies")
            if not zoomies then
                return false
            end
            local vectorVelocity = zoomies.VectorVelocity
            local magnitude = vectorVelocity.Magnitude
            local position

            if ball == TrackedBall and RealBallPosition then
                position = RealBallPosition
            else
                position = ball.Position
            end

            local dot = (Player.Character.HumanoidRootPart.Position - position).Unit:Dot(vectorVelocity.Unit)
            local spamDistanceThreshold = arg.Ping + math.min(magnitude / 5.8, 100)
            if arg.Entity_Properties.Distance > spamDistanceThreshold or arg.Ball_Properties.Distance > spamDistanceThreshold then
                return 0
            end
            local directionPenalty = 5 - math.min(magnitude / 5, 5)
            return spamDistanceThreshold - math.clamp(dot, -1, 0) * directionPenalty
        end

        if not isfolder("Aries") then
            makefolder("Aries")
        end

        HttpService = game:GetService("HttpService")

        do
            local function loadFavoriteCosmetics()
                if not isfile("Aries/fav_swords.json") then
                    writefile("Aries/fav_swords.json", HttpService:JSONEncode({ FavoriteSword = {}, FavoriteExplosion = {}, LastEquipped = nil }))
                end

                return HttpService:JSONDecode(readfile("Aries/fav_swords.json"))
            end

            saveFavoriteSwords = function(arg, arg2, arg3)
                writefile("Aries/fav_swords.json", HttpService:JSONEncode({ FavoriteSword = arg, FavoriteExplosion = arg2, LastEquipped = arg3 }))
            end

            local savedSwords = loadFavoriteCosmetics()
            favoriteSword = savedSwords.FavoriteSword or {}
            favoriteExplosion = savedSwords.FavoriteExplosion or {}
            lastEquipped = savedSwords.LastEquipped
        end
    end

    ownedItems = {}
    originalFindItems = nil
    emoteGrid = {}
    getgenv().FinisherEquipped = getgenv().FinisherEquipped or {}
    getgenv().Selected_Finisher = getgenv().Selected_Finisher or false

    saveLastExplosion = function(arg)
        writefile("Aries/last_explosion.json", HttpService:JSONEncode({ last = arg }))
    end

    do
        local function loadLastExplosion()
            if isfile("Aries/last_explosion.json") then
                return HttpService:JSONDecode(readfile("Aries/last_explosion.json")).last
            end
        end

        lastExplosion = loadLastExplosion() or ""
    end
end

local function findExplosionController()
    local function findVfxControllerModule()
        local controllers = ReplicatedStorage:FindFirstChild("Controllers")
        if controllers then
            local vfx = controllers:FindFirstChild("VFXController")
            if vfx then
                if vfx:IsA("ModuleScript") then
                    return vfx
                end

                local nested = vfx:FindFirstChild("VFXController")
                if nested and nested:IsA("ModuleScript") then
                    return nested
                end
            end
        end

        for _, descendant in ReplicatedStorage:GetDescendants() do
            if descendant.Name == "VFXController" and descendant:IsA("ModuleScript") then
                return descendant
            end
        end
    end

    local scriptModule = findVfxControllerModule()
    if not scriptModule then
        return nil
    end

    local ok, result = pcall(require, scriptModule)
    if ok and type(result) == "table" and type(result.PlayExplosion) == "function" then
        return result
    end
end

local TitleData, titleList, titleButtons, TextChatService, colorToHex
local chatTag, selectedTitle, titleButtonState, emoteWheelSlots, emoteMenuEntries, explosionController
local Parry_Abilities, Ignored_VFX, InfinityBall, TornadoTime, Parries, SpeedDivisorMultiplier
local IsMobile, byteUi

do
    local TweenService, window

    do
        TitleData = require(ReplicatedStorage.Shared.TitleData)
        titleList = playerGui.Settings.Frame.Frame:WaitForChild("SettingTitles"):WaitForChild("TitleList")
        titleButtons = {}
        TextChatService = game:GetService("TextChatService")

        colorToHex = function(arg)
            return string.format("#%02X%02X%02X", arg.R * 255, arg.G * 255, arg.B * 255)
        end

        chatTag = nil
        selectedTitle = nil
        titleButtonState = {}
        emoteWheelSlots = {}
        emoteMenuEntries = {}
        explosionController = findExplosionController()

        AutoParry.Play_Emote_Animation = function(current)
            local emote = emotes.storage[current]
            if not emote then
                return false
            end
            local Trove = require(ReplicatedStorage.Packages.Trove)
            local EmotesShared = require(ReplicatedStorage.Shared.EmotesShared)
            emotes.storage.Trove = Trove.new()
            EmotesShared:Play(Player.Character, emotes.storage.Trove, emote.Name, true, workspace:GetServerTimeNow())
            emotes.storage.current = current
        end

        AutoParry.Play_Wheel_Emote_Animations = function(arg)
            local emote = emotes.storage[arg]
            if not emote then
                return false
            end
            local Trove = require(ReplicatedStorage.Packages.Trove)
            local EmotesShared = require(ReplicatedStorage.Shared.EmotesShared)
            local character = Player.Character
            if not character then
                return
            end
            local humanoid = character:FindFirstChildWhichIsA("Humanoid")
            if not humanoid then
                return
            end

            for _, track in humanoid.Animator:GetPlayingAnimationTracks() do
                local animation = track.Animation

                if animation and animation.Parent == ReplicatedStorage.Misc.Emotes then
                    track:Stop()
                end
            end

            if emotes.storage.Trove then
                emotes.storage.Trove:Destroy()
                emotes.storage.Trove = nil
            end

            emotes.storage.Trove = Trove.new()

            if ConnectionsManager["Emote Wheel Heartbeat"] then
                ConnectionsManager["Emote Wheel Heartbeat"]:Disconnect()
                ConnectionsManager["Emote Wheel Heartbeat"] = nil
            end

            if ConnectionsManager["Emote Wheel Jumping"] then
                ConnectionsManager["Emote Wheel Jumping"]:Disconnect()
                ConnectionsManager["Emote Wheel Jumping"] = nil
            end

            if ConnectionsManager["Emote Connection Death"] then
                ConnectionsManager["Emote Connection Death"]:Disconnect()
                ConnectionsManager["Emote Connection Death"] = nil
            end

            if ConnectionsManager["Emote Character Added"] then
                ConnectionsManager["Emote Character Added"]:Disconnect()
                ConnectionsManager["Emote Character Added"] = nil
            end

            local function stopWheelEmote()
                character = Player.Character
                if not character then
                    return
                end
                humanoid = character:FindFirstChildWhichIsA("Humanoid")
                if not humanoid then
                    return
                end

                for _, track in humanoid.Animator:GetPlayingAnimationTracks() do
                    local animation = track.Animation

                    if animation and animation.Parent == ReplicatedStorage.Misc.Emotes then
                        track:Stop()
                    end
                end

                if emotes.storage.Trove then
                    emotes.storage.Trove:Destroy()
                    emotes.storage.Trove = nil
                end
            end

            local function bindWheelEmoteCharacter(arg2)
                character = arg2
                humanoid = character:WaitForChild("Humanoid")

                if ConnectionsManager["Emote Wheel Jumping"] then
                    ConnectionsManager["Emote Wheel Jumping"]:Disconnect()
                    ConnectionsManager["Emote Wheel Jumping"] = nil
                end

                if ConnectionsManager["Emote Connection Death"] then
                    ConnectionsManager["Emote Connection Death"]:Disconnect()
                    ConnectionsManager["Emote Connection Death"] = nil
                end

                ConnectionsManager["Emote Wheel Jumping"] = humanoid.Jumping:Connect(function()
                    stopWheelEmote()
                end)

                ConnectionsManager["Emote Connection Death"] = humanoid.Died:Connect(function()
                    stopWheelEmote()
                end)
            end

            ConnectionsManager["Emote Wheel Heartbeat"] = RunService.Heartbeat:Connect(function()
                character = Player.Character
                if not character then
                    return
                end
                humanoid = character:FindFirstChildWhichIsA("Humanoid")
                if not humanoid then
                    return
                end

                if humanoid.MoveDirection.Magnitude > 0 then
                    stopWheelEmote()
                end
            end)

            ConnectionsManager["Emote Character Added"] = Player.CharacterAdded:Connect(function(character2)
                if emotes.storage.Trove then
                    emotes.storage.Trove:Destroy()
                    emotes.storage.Trove = nil
                end

                bindWheelEmoteCharacter(character2)
            end)

            bindWheelEmoteCharacter(character)
            EmotesShared:Play(character, emotes.storage.Trove, emote.Name, true, workspace:GetServerTimeNow())
        end

        Parry_Abilities = {
            "Calming Deflection",
            "Raging Deflection",
            "Rapture",
            "Aerodynamic Slash",
            "Forcefield",
            "Infinity",
            "Fracture",
            "Death Slash",
            "Slashes of Fury",
        }

        Ignored_VFX = {
            "BallEmit",
            "Upgrade",
            "Arch2",
            "MaxHook",
            "Wave",
            "Totem",
            "TotemRange",
            "InfinityFX",
            "maxTransmission",
            "transmissionpart",
            "Tornado",
            "Barrier",
            "GUARDIAN_DRAGON",
            "DRAGON_POSITIONER",
            "SpiritDeflect",
            "Vanity",
            "Platform",
            "Swap",
            "MaxBlink",
        }

        InfinityBall = false
        TornadoTime = nil
        LastParry = 0
        Parried = false
        Parries = 0
        SpeedDivisorMultiplier = 1.1
        TweenService = game:GetService("TweenService")

        do
            local HttpService2 = game:GetService("HttpService")
            IsMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled

            window = {
                CurrentTabs = { left = nil, right = nil },
                Tabs = {},
                ActiveKeybindToggle = nil,
                WaitingForKey = false,
                Widgets = {},
            }

            if not isfolder("Aries") then
                makefolder("Aries")
            end

            if not isfolder("Aries/Presets") then
                makefolder("Aries/Presets")
            end

            Library.save_flags = function()
                local json = HttpService2:JSONEncode(Library.Flags)
                writefile("Aries/" .. game.GameId .. ".lua", json)
            end

            Library.load_flags = function()
                if not isfile("Aries/" .. game.GameId .. ".lua") then
                    Library.save_flags()
                    return
                end
                local fileText = readfile("Aries/" .. game.GameId .. ".lua")
                if not fileText then
                    Library.save_flags()
                    return
                end
                Library.Flags = HttpService2:JSONDecode(fileText)
            end

            Library.load_flags()

            Library.save_preset = function(arg, arg2, arg3)
                local json = HttpService2:JSONEncode(arg3)
                writefile("Aries/Presets/" .. arg2 .. ".json", json)
            end

            Library.load_preset = function(arg, arg2)
                local str10 = "Aries/Presets/" .. arg2 .. ".json"
                if not isfile(str10) then
                    return nil
                end
                return (HttpService2:JSONDecode(readfile(str10)))
            end
        end
    end

    Library.list_presets = function()
        local list = {}

        for _, presetPath in listfiles("Aries/Presets") do
            local match = presetPath:match("Aries[/\\]Presets[/\\](.+)%.json")

            if match then
                table.insert(list, match)
            end
        end

        return list
    end

    Library.applyDefaults = function(_, defaults, options)
        options = options or {}

        for key, defaultValue in defaults do
            if options[key] == nil then
                options[key] = defaultValue
            end
        end

        return options
    end

    do
        local ok, result = pcall(function()
            return loadstring(game:HttpGet("https://raw.githubusercontent.com/mstudio45/lucide-roblox-direct/refs/heads/main/source.lua"))()
        end)

        local function isDirectIconUrl(value, allowAssetId)
            if typeof(value) ~= "string" then
                return false
            end

            return value:match("^content://")
                or value:match("^rbxasset://%x+/")
                or (allowAssetId == true and value:match("^rbxassetid://"))
        end

        local function isCustomIconUrl(value)
            return typeof(value) == "string"
                and (value:match("^rbxasset://textures/")
                    or value:match("roblox%.com/asset/%?id=")
                    or value:match("rbxthumb://type="))
        end

        Library.GetIcon = function(arg, arg2)
            if not ok or not result then
                return
            end
            local ok2, result2 = pcall(result.GetAsset, arg2)
            if not ok2 then
                return
            end
            return result2
        end

        Library.GetCustomIcon = function(arg, arg2)
            if not arg2 then
                return nil
            end

            if tonumber(arg2) then
                arg2 = string.format("rbxassetid://%s", tostring(arg2))
            end

            if isDirectIconUrl(arg2, true) then
                return { Url = arg2, ImageRectOffset = Vector2.zero, ImageRectSize = Vector2.zero }
            end

            if isCustomIconUrl(arg2) then
                return { Url = arg2, ImageRectOffset = Vector2.zero, ImageRectSize = Vector2.zero, Custom = true }
            end
            local icon = Library:GetIcon(arg2)
            if icon then
                return icon
            end
            return nil
        end
    end

    if IsMobile then
        Library["1"] = Instance.new("ScreenGui", game:GetService("CoreGui"))
        Library["1"].Name = "Mobile_Gui"
        Library["1"].ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        Library["2"] = Instance.new("TextButton", Library["1"])
        Library["2"].BorderSizePixel = 0
        Library["2"].Modal = false
        Library["2"].AutoButtonColor = false
        Library["2"]["TextSize"] = 14
        Library["2"]["TextColor3"] = Color3.fromRGB(0, 0, 0)
        Library["2"].BackgroundColor3 = Color3.fromRGB(28, 29, 34)
        Library["2"]["FontFace"] = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
        Library["2"]["Size"] = UDim2.new(0, 122, 0, 38)
        Library["2"].Name = "Mobile"
        Library["2"].BorderColor3 = Color3.fromRGB(0, 0, 0)
        Library["2"].Text = ""
        Library["2"]["Position"] = UDim2.new(1, -4, 0.918, -5)
        Library.Dragging = true
        Library["3"] = Instance.new("UICorner", Library["2"])
        Library["3"]["CornerRadius"] = UDim.new(0, 13)
        Library["4"] = Instance.new("ImageLabel", Library["2"])
        Library["4"].ZIndex = 0
        Library["4"].BorderSizePixel = 0
        Library["4"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Library["4"].ImageTransparency = 0.2
        Library["4"]["AnchorPoint"] = Vector2.new(0.5, 0.5)
        Library["4"].Image = "rbxassetid://17183270335"
        Library["4"]["Size"] = UDim2.new(0, 140, 0, 58)
        Library["4"].BorderColor3 = Color3.fromRGB(0, 0, 0)
        Library["4"].BackgroundTransparency = 1
        Library["4"].Name = "Shadow"
        Library["4"].Position = UDim2.new(0.5, 0, 0.5, 0)
        Library["5"] = Instance.new("ImageLabel", Library["2"])
        Library["5"].BorderSizePixel = 0
        Library["5"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
        Library["5"].AnchorPoint = Vector2.new(0.5, 0.5)
        Library["5"]["Image"] = "rbxassetid://10709810463"
        Library["5"].Size = UDim2.new(0, 15, 0, 15)
        Library["5"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
        Library["5"]["BackgroundTransparency"] = 1
        Library["5"].Name = "Icon"
        Library["5"]["Position"] = UDim2.new(0.5, 0, 0.5, 0)

        getgenv().MobileDrag = getgenv().MobileDrag or {
            Dragging = false,
            DragStart = nil,
            StartPosition = nil,
            DragInput = nil,
        }

        do
            local mobileDrag = getgenv().MobileDrag
            local UserInputService2 = game:GetService("UserInputService")

            Library["2"].InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    mobileDrag.Dragging = true
                    mobileDrag.DragStart = input.Position
                    mobileDrag.StartPosition = Library["2"].Position

                    input.Changed:Connect(function()
                        if input.UserInputState == Enum.UserInputState.End then
                            mobileDrag.Dragging = false
                        end
                    end)
                end
            end)

            Library["2"].InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                    mobileDrag.DragInput = input
                end
            end)

            UserInputService2.InputChanged:Connect(function(input)
                if input == mobileDrag.DragInput and mobileDrag.Dragging then
                    local n41 = input.Position - mobileDrag.DragStart
                    Library["2"].Position = UDim2.new(mobileDrag.StartPosition.X.Scale, mobileDrag.StartPosition.X.Offset + n41.X, mobileDrag.StartPosition.Y.Scale, mobileDrag.StartPosition.Y.Offset + n41.Y)
                end
            end)
        end

        Library["2"].InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then
                return
            end

            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                if window["1"].Enabled then
                    local scaleGoal = { Scale = 0 }
                    local tween = TweenService:Create(window["4"], TweenInfo.new(0.65, Enum.EasingStyle.Back, Enum.EasingDirection.InOut), scaleGoal)
                    tween:Play()
                    tween.Completed:Wait()
                    window["1"].Enabled = false
                else
                    window["1"].Enabled = true
                    window["4"].Scale = 0
                    TweenService:Create(window["4"], TweenInfo.new(0.65, Enum.EasingStyle.Back, Enum.EasingDirection.InOut), { Scale = 0.8 }):Play()
                end
            end
        end)

        Library["2"].TouchTap:Connect(function()
            if window["1"].Enabled then
                local scaleGoal = { Scale = 0 }
                local tween = TweenService:Create(window["4"], TweenInfo.new(0.65, Enum.EasingStyle.Back, Enum.EasingDirection.InOut), scaleGoal)
                tween:Play()
                tween.Completed:Wait()
                window["1"].Enabled = false
            else
                window["1"].Enabled = true
                window["4"].Scale = 0
                TweenService:Create(window["4"], TweenInfo.new(0.65, Enum.EasingStyle.Back, Enum.EasingDirection.InOut), { Scale = 0.8 }):Play()
            end
        end)
    end

    byteUi = game:GetService("CoreGui"):FindFirstChild("Byte_UI")

    Library.new = function()
        window["1"] = Instance.new("ScreenGui", playerGui)
        window["1"].IgnoreGuiInset = true
        window["1"].ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
        window["1"].Name = "Byte_UI"
        window["1"].ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        window["1"].ResetOnSpawn = false
        window["2"] = Instance.new("Frame", window["1"])
        window["2"].BorderSizePixel = 0
        window["2"].BackgroundColor3 = Color3.fromRGB(10, 11, 16)
        window["2"].AnchorPoint = Vector2.new(0.5, 0.5)
        window["2"].Size = UDim2.new(0, 718, 0, 440)
        window["2"].Position = UDim2.new(0.5, 0, 0.5, 0)
        window["2"]["Name"] = "Main_Menu_Window"
        window["2"]:SetAttribute("fadeOriginal_BackgroundTransparency", 0)
        window["3"] = Instance.new("UICorner", window["2"])
        window["3"].CornerRadius = UDim.new(0, 14)

        if IsMobile then
            window["4"] = Instance.new("UIScale", window["2"])
            window["4"].Scale = 0.8
            window._targetScale = 0.8
        else
            window["4"] = Instance.new("UIScale", window["2"])
            window["4"].Scale = 1
            window._targetScale = 1
        end

        window["5"] = Instance.new("Frame", window["2"])
        window["5"].BorderSizePixel = 0
        window["5"].BackgroundColor3 = Color3.fromRGB(14, 15, 20)
        window["5"]["Size"] = UDim2.new(0, 180, 1, -32)
        window["5"].Position = UDim2.new(-0.03755, 0, 0, 16)
        window["5"].Name = "left_panel"
        window["5"].BackgroundTransparency = 0
        window["5"]:SetAttribute("fadeOriginal_BackgroundTransparency", 0)
        window.TabContainer = Instance.new("Frame", window["5"])
        window.TabContainer.BackgroundTransparency = 1
        window["TabContainer"].Size = UDim2.new(1, 0, 0, 274)
        window.TabContainer.Position = UDim2.new(0, 0, 0, 90)
        window["TabContainer"].Name = "TabContainer"
        local uiListLayout = Instance.new("UIListLayout", window.TabContainer)
        uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        uiListLayout.Padding = UDim.new(0, 6)
        uiListLayout.FillDirection = Enum.FillDirection.Vertical
        window["6"] = Instance.new("UICorner", window["5"])
        window["6"].CornerRadius = UDim.new(0, 14)
        window["7"] = Instance.new("UIShadow", window["5"])
        window["7"].Transparency = 0.55
        window["7"]:SetAttribute("fadeOriginal_Transparency", 0.55)
        window["8"] = Instance.new("ImageLabel", window["5"])
        window["8"]["BorderSizePixel"] = 0
        window["8"]["ScaleType"] = Enum.ScaleType.Fit
        window["8"]["Image"] = "rbxassetid://84194878517331"
        window["8"].Size = UDim2.new(0, 144, 0, 36)
        window["8"].BackgroundTransparency = 1
        window["8"].Name = "IMG_Logo"
        window["8"].Position = UDim2.new(0, 18, 0, 14)
        window["8"]:SetAttribute("fadeOriginal_ImageTransparency", 0)
        window["8"]:SetAttribute("fadeOriginal_BackgroundTransparency", 1)
        window["9"] = Instance.new("Frame", window["5"])
        window["9"].BorderSizePixel = 0
        window["9"].BackgroundColor3 = Color3.fromRGB(21, 21, 26)
        window["9"].Size = UDim2.new(0, 158, 0, 32)
        window["9"]["Position"] = UDim2.new(0, 0, 1, -44)
        window["9"].Name = "UserCard"
        window["9"]["BackgroundTransparency"] = 1
        window["9"]:SetAttribute("fadeOriginal_BackgroundTransparency", 1)
        window["a"] = Instance.new("TextLabel", window["9"])
        window.a.TextTruncate = Enum.TextTruncate.AtEnd
        window.a["TextSize"] = 12
        window.a.TextXAlignment = Enum.TextXAlignment.Left
        window.a.FontFace = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
        window.a["TextColor3"] = Color3.fromRGB(243, 243, 247)
        window["a"].BackgroundTransparency = 1
        window.a["Size"] = UDim2.new(0, 90, 0, 13)
        window.a.Text = "Byteverserys"
        window.a["Name"] = "Name"
        window.a.Position = UDim2.new(0, 57, 0, 0)
        window.a:SetAttribute("fadeOriginal_TextTransparency", 0)
        window["a"]:SetAttribute("fadeOriginal_BackgroundTransparency", 1)
        window.b = Instance.new("TextLabel", window["9"])
        window["b"].TextSize = 10
        window.b["TextXAlignment"] = Enum.TextXAlignment.Left
        window.b.FontFace = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
        window.b.TextColor3 = Color3.fromRGB(143, 143, 154)
        window.b.BackgroundTransparency = 1
        window.b.Size = UDim2.new(0, 96, 0, 11)
        window.b.Text = "Till:  Lifetime"
        window.b.Name = "Expiry"
        window.b["Position"] = UDim2.new(0, 57, 0, 15)
        window.b:SetAttribute("fadeOriginal_TextTransparency", 0)
        window["b"]:SetAttribute("fadeOriginal_BackgroundTransparency", 1)
        window.c = Instance.new("ImageLabel", window["9"])
        window.c.BorderSizePixel = 0
        window["c"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
        window.c["Image"] = "rbxthumb://type=AvatarHeadShot&id=7329993111&w=48&h=48"
        window["c"].Size = UDim2.new(0, 32, 0, 31)
        window.c.BackgroundTransparency = 1
        window.c.Name = "IMG_Avatar"
        window.c["Position"] = UDim2.new(0.09494, 0, 0.01989, 0)
        window.c:SetAttribute("fadeOriginal_ImageTransparency", 0)
        window.c:SetAttribute("fadeOriginal_BackgroundTransparency", 1)
        window.d = Instance.new("UICorner", window.c)
        window.d.CornerRadius = UDim.new(1, 0)
        window["1e"] = Instance.new("Frame", window["2"])
        window["1e"].BorderSizePixel = 0
        window["1e"].BackgroundColor3 = Color3.fromRGB(27, 27, 34)
        window["1e"].Size = UDim2.new(1, -158, 0, 62)
        window["1e"].Position = UDim2.new(0, 158, 0, 0)
        window["1e"].Name = "top_bar_content"
        window["1e"]["BackgroundTransparency"] = 1
        window["1e"]:SetAttribute("fadeOriginal_BackgroundTransparency", 1)
        window["1f"] = Instance.new("Frame", window["1e"])
        window["1f"]["BorderSizePixel"] = 0
        window["1f"]["BackgroundColor3"] = Color3.fromRGB(14, 15, 20)
        window["1f"].Size = UDim2.new(0, 200, 0, 34)
        window["1f"].Position = UDim2.new(0, 8, 0, 23)
        window["1f"].Name = "search"
        window["1f"]["BackgroundTransparency"] = 0
        window["1f"]:SetAttribute("fadeOriginal_BackgroundTransparency", 0)
        window["c71"] = Instance.new("UICorner", window["1f"])
        window["c71"]["CornerRadius"] = UDim.new(0, 10)
        window["21"] = Instance.new("UIStroke", window["1f"])
        window["21"].Transparency = 0.55
        window["21"].Color = Color3.fromRGB(47, 47, 58)
        window["21"]:SetAttribute("fadeOriginal_Transparency", 0.55)
        window["22"] = Instance.new("ImageLabel", window["1f"])
        window["22"].BorderSizePixel = 0
        window["22"]["ScaleType"] = Enum.ScaleType.Fit
        window["22"].ImageTransparency = 0
        window["22"].Image = "rbxassetid://109659294248163"
        window["22"].Size = UDim2.new(0, 14, 0, 14)
        window["22"].BackgroundTransparency = 1
        window["22"].Name = "IMG_SearchIcon"
        window["22"].Position = UDim2.new(0, 12, 0, 10)
        window["22"]:SetAttribute("fadeOriginal_ImageTransparency", 0)
        window["22"]:SetAttribute("fadeOriginal_BackgroundTransparency", 1)
        window["23"] = Instance.new("TextLabel", window["1f"])
        window["23"].TextSize = 12
        window["23"].TextXAlignment = Enum.TextXAlignment.Left
        window["23"]["FontFace"] = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
        window["23"]["TextColor3"] = Color3.fromRGB(143, 143, 154)
        window["23"].BackgroundTransparency = 1
        window["23"]["Size"] = UDim2.new(0, 160, 0, 34)
        window["23"]["Text"] = "Search..."
        window["23"].Name = "Placeholder"
        window["23"].Position = UDim2.new(0, 28, 0, 0)
        window["23"]:SetAttribute("fadeOriginal_TextTransparency", 0)
        window["23"]:SetAttribute("fadeOriginal_BackgroundTransparency", 1)
        window["24"] = Instance.new("TextBox", window["1f"])
        window["24"].SelectionStart = 1
        window["24"].Name = "Input"
        window["24"].TextXAlignment = Enum.TextXAlignment.Left
        window["24"].ZIndex = 2
        window["24"].TextSize = 12
        window["24"].TextColor3 = Color3.fromRGB(243, 243, 247)
        window["24"]["FontFace"] = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
        window["24"].ClearTextOnFocus = false
        window["24"].Size = UDim2.new(0, 160, 0, 34)
        window["24"].Position = UDim2.new(0, 28, 0, 0)
        window["24"].Text = ""
        window["24"].BackgroundTransparency = 1
        window["24"]:SetAttribute("fadeOriginal_TextTransparency", 0)
        window["24"]:SetAttribute("fadeOriginal_BackgroundTransparency", 1)
        window["25"] = Instance.new("UIStroke", window["1f"])
        window["25"].Transparency = 1
        window["25"].Color = Color3.fromRGB(125, 109, 247)
        window["25"]:SetAttribute("fadeOriginal_Transparency", 1)
        window["26"] = Instance.new("Frame", window["1e"])
        window["26"].BorderSizePixel = 0
        window["26"].BackgroundColor3 = Color3.fromRGB(14, 15, 20)
        window["26"].Size = UDim2.new(0, 100, 0, 34)
        window["26"].AnchorPoint = Vector2.new(1, 0)
        window["26"]["Position"] = UDim2.new(1, -7, 0, 23)
        window["26"]["Name"] = "LegitPvP_Button"
        window["26"]["BackgroundTransparency"] = 0
        window["26"]:SetAttribute("fadeOriginal_BackgroundTransparency", 0)
        window["27"] = Instance.new("UICorner", window["26"])
        window["27"].CornerRadius = UDim.new(0, 10)
        window["28"] = Instance.new("TextLabel", window["26"])
        window["28"].AutomaticSize = Enum.AutomaticSize.X
        window["28"]["TextSize"] = 12
        window["28"].TextXAlignment = Enum.TextXAlignment.Left
        window["28"].FontFace = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
        window["28"].TextColor3 = Color3.fromRGB(243, 243, 247)
        window["28"].BackgroundTransparency = 1
        window["28"]["Size"] = UDim2.new(0, 0, 0, 34)
        window["28"].Text = "Config 1"
        window["28"].Name = "Label"
        window["28"].Position = UDim2.new(0, 12, 0, 0)
        window["28"]:SetAttribute("fadeOriginal_TextTransparency", 0)
        window["28"]:SetAttribute("fadeOriginal_BackgroundTransparency", 1)
        window["28"]:GetPropertyChangedSignal("TextBounds"):Connect(function()
            local scale = window["4"].Scale
            if scale > 0 then
                window["26"].Size = UDim2.new(0, math.max(100, window["28"].TextBounds.X / scale + 54), 0, 34)
            end
        end)
        window["29"] = Instance.new("ImageLabel", window["26"])
        window["29"].BorderSizePixel = 0
        window["29"].ScaleType = Enum.ScaleType.Fit
        window["29"].Image = "rbxassetid://10723386277"
        window["29"]["Size"] = UDim2.new(0, 16, 0, 16)
        window["29"].BackgroundTransparency = 1
        window["29"].Name = "IMG_FolderIcon"
        window["29"].Position = UDim2.new(1, -30, 0, 9)
        window["29"]:SetAttribute("fadeOriginal_ImageTransparency", 0)
        window["29"]:SetAttribute("fadeOriginal_BackgroundTransparency", 1)
        window["2a"] = Instance.new("TextButton", window["26"])
        window["2a"].AutoButtonColor = false
        window["2a"].ZIndex = 3
        window["2a"].BackgroundTransparency = 1
        window["2a"].Size = UDim2.new(1, 0, 1, 0)
        window["2a"].Text = ""
        window["2a"].Name = "Hit"
        window["2a"]:SetAttribute("fadeOriginal_TextTransparency", 0)
        window["2a"]:SetAttribute("fadeOriginal_BackgroundTransparency", 1)
        window.Indicator = Instance.new("ImageLabel", window["5"])
        window.Indicator.BorderSizePixel = 0
        window.Indicator.Image = "rbxassetid://90362801488029"
        window.Indicator.Size = UDim2.new(0, 3, 0, 15)
        window.Indicator.BackgroundTransparency = 1
        window.Indicator.Name = "IMG_Indicator"
        window.Indicator.Position = UDim2.new(0, 0, 0, 93)
        window["e"] = Instance.new("Frame", window["5"])
        window.e.BorderSizePixel = 0
        window.e.BackgroundColor3 = Color3.fromRGB(23, 24, 32)
        window["e"].Size = UDim2.new(1, -26, 0, 23)
        window.e.Position = UDim2.new(0, 8, 0, 90)
        window.e.Name = "Highlight"
        window.e.Visible = true
        window["e"].ZIndex = 0
        window["e"]:SetAttribute("fadeOriginal_BackgroundTransparency", 0)
        window.f = Instance.new("UICorner", window.e)
        window["10"] = Instance.new("UIStroke", window.e)
        window["10"].Transparency = 0.55
        window["10"].Color = Color3.fromRGB(47, 47, 58)
        window["10"]:SetAttribute("fadeOriginal_Transparency", 0.55)
        window.ef = Instance.new("Frame", window["2"])
        window["ef"].Visible = false
        window.ef.ZIndex = 60
        window.ef.BorderSizePixel = 0
        window.ef["BackgroundColor3"] = Color3.fromRGB(10, 11, 16)
        window.ef.Size = UDim2.new(0, 236, 0, 490)
        window.ef.Position = UDim2.new(0, 737, 0, 3)
        window.ef.Name = "name_config_window"
        window.ef:SetAttribute("fadeOriginal_BackgroundTransparency", 0)
        window.ef:SetAttribute("fadeOriginal_LayoutOrder", 3)
        window["ef"]:SetAttribute("fadeIsolated", true)
        window["ef"].ClipsDescendants = true
        window.f0 = Instance.new("UICorner", window.ef)
        window.f0.CornerRadius = UDim.new(0, 12)
        window["f1"] = Instance.new("UIStroke", window.ef)
        window.f1.Transparency = 0.4
        window.f1["Color"] = Color3.fromRGB(47, 47, 58)
        window.f1:SetAttribute("fadeOriginal_Transparency", 0.4)
        window.f2 = Instance.new("ImageLabel", window["ef"])
        window.f2["ZIndex"] = 61
        window.f2.ScaleType = Enum.ScaleType.Fit
        window["f2"].ImageColor3 = Color3.fromRGB(151, 151, 162)
        window.f2.Image = "rbxassetid://70621328130295"
        window.f2.Size = UDim2.new(0, 18, 0, 18)
        window["f2"].BackgroundTransparency = 1
        window.f2["Name"] = "IMG_CloudIcon"
        window.f2.Position = UDim2.new(0, 14, 0, 15)
        window.f2:SetAttribute("fadeOriginal_ImageTransparency", 0)
        window.f2:SetAttribute("fadeOriginal_BackgroundTransparency", 1)
        window.f3 = Instance.new("TextLabel", window.ef)
        window.f3["ZIndex"] = 61
        window.f3.TextSize = 14
        window.f3["TextXAlignment"] = Enum.TextXAlignment.Left
        window.f3.FontFace = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
        window.f3.TextColor3 = Color3.fromRGB(243, 243, 247)
        window["f3"]["BackgroundTransparency"] = 1
        window.f3.Size = UDim2.new(0, 120, 0, 24)
        window.f3.Text = "Presets"
        window["f3"].Name = "Title"
        window.f3.Position = UDim2.new(0, 40, 0, 12)
        window.f3:SetAttribute("fadeOriginal_TextTransparency", 0)
        window["f3"]:SetAttribute("fadeOriginal_BackgroundTransparency", 1)
        window.f4 = Instance.new("Frame", window.ef)
        window.f4.ZIndex = 61
        window["f4"].BorderSizePixel = 0
        window.f4.BackgroundColor3 = Color3.fromRGB(25, 24, 43)
        window.f4.Size = UDim2.new(0, 26, 0, 26)
        window.f4["Position"] = UDim2.new(0, 196, 0, 11)
        window.f4.Name = "AddButton"
        window.f4:SetAttribute("fadeOriginal_BackgroundTransparency", 0)
        window["f5"] = Instance.new("UICorner", window.f4)
        window.f5.CornerRadius = UDim.new(0, 7)
        window.f6 = Instance.new("ImageLabel", window.f4)
        window["f6"]["ZIndex"] = 61
        window.f6["ScaleType"] = Enum.ScaleType.Fit
        window["f6"].ImageColor3 = Color3.fromRGB(243, 243, 247)
        window.f6["Image"] = "rbxassetid://101123124881873"
        window.f6["Size"] = UDim2.new(0, 14, 0, 14)
        window.f6["BackgroundTransparency"] = 1
        window.f6.Name = "IMG_Add"
        window.f6["Position"] = UDim2.new(0, 6, 0, 6)
        window.f6:SetAttribute("fadeOriginal_ImageTransparency", 0)
        window.f6:SetAttribute("fadeOriginal_BackgroundTransparency", 1)
        window.f7 = Instance.new("TextButton", window.f4)
        window.f7.AutoButtonColor = false
        window.f7.ZIndex = 62
        window["f7"]["BackgroundTransparency"] = 1
        window.f7.Size = UDim2.new(1, 0, 1, 0)
        window.f7.Text = ""
        window.f7.Name = "Hit"
        window["f7"]:SetAttribute("fadeOriginal_TextTransparency", 0)
        window.f7:SetAttribute("fadeOriginal_BackgroundTransparency", 1)
        window.f8 = Instance.new("UIStroke", window["f4"])
        window.f8.Transparency = 1
        window["f8"]["Color"] = Color3.fromRGB(85, 85, 101)
        window.f8:SetAttribute("fadeOriginal_Transparency", 1)
        window.f9 = Instance.new("Frame", window.ef)
        window.f9.ZIndex = 61
        window.f9.BorderSizePixel = 0
        window.f9.BackgroundColor3 = Color3.fromRGB(25, 24, 34)
        window.f9.Size = UDim2.new(0, 174, 0, 34)
        window.f9.Position = UDim2.new(0, 14, 0, 39)
        window["f9"].Name = "PresetSearch"
        window.f9:SetAttribute("fadeOriginal_BackgroundTransparency", 0)
        window.fa = Instance.new("UICorner", window.f9)
        window["fb"] = Instance.new("ImageLabel", window.f9)
        window["fb"]["ZIndex"] = 56
        window["fb"].ScaleType = Enum.ScaleType.Fit
        window.fb.ImageColor3 = Color3.fromRGB(151, 151, 162)
        window.fb.Image = "rbxassetid://72296609649861"
        window.fb.Size = UDim2.new(0, 14, 0, 14)
        window.fb.BackgroundTransparency = 1
        window.fb["Name"] = "IMG_SearchIcon"
        window.fb["Position"] = UDim2.new(0, 10, 0, 10)
        window.fb:SetAttribute("fadeOriginal_ImageTransparency", 0)
        window["fb"]:SetAttribute("fadeOriginal_BackgroundTransparency", 1)
        window["fc"] = Instance.new("TextBox", window.f9)
        window.fc.Name = "Input"
        window.fc.TextXAlignment = Enum.TextXAlignment.Left
        window.fc.PlaceholderColor3 = Color3.fromRGB(121, 121, 132)
        window.fc.ZIndex = 61
        window.fc["TextSize"] = 12
        window.fc.TextColor3 = Color3.fromRGB(243, 243, 247)
        window.fc.FontFace = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
        window["fc"]["ClearTextOnFocus"] = false
        window.fc.PlaceholderText = "Search"
        window["fc"].Size = UDim2.new(0, 130, 0, 34)
        window.fc.Position = UDim2.new(0, 32, 0, 0)
        window.fc.Text = ""
        window.fc.BackgroundTransparency = 1
        window.fc:SetAttribute("fadeOriginal_TextTransparency", 0)
        window["fc"]:SetAttribute("fadeOriginal_BackgroundTransparency", 1)
        window.fd = Instance.new("Frame", window.ef)
        window["fd"].ZIndex = 61
        window.fd.BorderSizePixel = 0
        window.fd.BackgroundColor3 = Color3.fromRGB(25, 24, 34)
        window.fd.Size = UDim2.new(0, 30, 0, 34)
        window.fd.Position = UDim2.new(0, 192, 0, 50)
        window["fd"].Name = "SortButton"
        window.fd:SetAttribute("fadeOriginal_BackgroundTransparency", 0)
        window.fe = Instance.new("UICorner", window.fd)
        window["ff"] = Instance.new("ImageLabel", window.fd)
        window.ff.ZIndex = 61
        window["ff"].ScaleType = Enum.ScaleType.Fit
        window.ff.ImageColor3 = Color3.fromRGB(151, 151, 162)
        window.ff.Image = "rbxassetid://117405374619280"
        window.ff["Size"] = UDim2.new(0, 14, 0, 14)
        window["ff"].BackgroundTransparency = 1
        window.ff["Name"] = "IMG_SortIcon"
        window.ff["Position"] = UDim2.new(0, 8, 0, 10)
        window.ff:SetAttribute("fadeOriginal_ImageTransparency", 0)
        window["ff"]:SetAttribute("fadeOriginal_BackgroundTransparency", 1)
        window["100"] = Instance.new("TextButton", window.fd)
        window["100"]["AutoButtonColor"] = false
        window["100"]["ZIndex"] = 62
        window["100"].BackgroundTransparency = 1
        window["100"].Size = UDim2.new(1, 0, 1, 0)
        window["100"].Text = ""
        window["100"].Name = "Hit"
        window["100"]:SetAttribute("fadeOriginal_TextTransparency", 0)
        window["100"]:SetAttribute("fadeOriginal_BackgroundTransparency", 1)
        window["101"] = Instance.new("UIStroke", window.fd)
        window["101"]["Thickness"] = 1
        window["101"]["Color"] = Color3.fromRGB(85, 85, 101)
        window["101"]:SetAttribute("fadeOriginal_Transparency", 1)
        window["kpw"] = Instance.new("Frame", window["1"])
        window.kpw.BorderSizePixel = 0
        window.kpw.BackgroundColor3 = Color3.fromRGB(9, 10, 15)
        window.kpw["ZIndex"] = 90
        window.kpw.Size = UDim2.new(0, 150, 0, 76)
        window["kpw"].Position = UDim2.new(0, 250, 0, 200)
        window.kpw.Name = "KeybindWindow"
        window.kpw.Visible = false
        window.kpw.ClipsDescendants = true
        window.kpw:SetAttribute("fadeIsolated", true)
        window.kpw_c = Instance.new("UICorner", window.kpw)
        window.kpw_c.CornerRadius = UDim.new(0, 10)
        window.kpw_s = Instance.new("UIStroke", window["kpw"])
        window["kpw_s"]["Thickness"] = 0.45
        window.kpw_s.Color = Color3.fromRGB(48, 48, 58)
        window.kpw_sh = Instance.new("UIStroke", window["kpw"])
        window.kpw_sh.Transparency = 1
        window.kpw_sh:SetAttribute("fadeOriginal_Transparency", 1)
        window.kpw_nbf = Instance.new("Frame", window["kpw"])
        window.kpw_nbf.BorderSizePixel = 0
        window.kpw_nbf.BackgroundColor3 = Color3.fromRGB(22, 23, 31)
        window["kpw_nbf"]["ZIndex"] = 56
        window["kpw_nbf"]["Size"] = UDim2.new(0, 134, 0, 26)
        window["kpw_nbf"]["Position"] = UDim2.new(0, 8, 0, 8)
        window.kpw_nbf.Name = "NewBind"
        window.kpw_nbf_c = Instance.new("UICorner", window["kpw_nbf"])
        window.kpw_nbf_c.CornerRadius = UDim.new(0, 7)
        window.kpw_nbf_s = Instance.new("UIStroke", window["kpw_nbf"])
        window.kpw_nbf_s.Transparency = 1
        window.kpw_nbf_s.Color = Color3.fromRGB(125, 109, 247)
        window.kpw_nbf_i = Instance.new("ImageLabel", window.kpw_nbf)
        window.kpw_nbf_i.BorderSizePixel = 0
        window.kpw_nbf_i.ScaleType = Enum.ScaleType.Fit
        window.kpw_nbf_i["ImageColor3"] = Color3.fromRGB(138, 138, 148)
        window.kpw_nbf_i.Image = "rbxassetid://122878673716704"
        window.kpw_nbf_i.ZIndex = 56
        window.kpw_nbf_i.Size = UDim2.new(0, 12, 0, 12)
        window.kpw_nbf_i.BackgroundTransparency = 1
        window.kpw_nbf_i.Name = "IMG_BindIcon"
        window.kpw_nbf_i.Position = UDim2.new(0, 9, 0, 7)
        window.kpw_nbf_p = Instance.new("TextLabel", window.kpw_nbf)
        window.kpw_nbf_p.TextSize = 12
        window["kpw_nbf_p"].TextXAlignment = Enum.TextXAlignment.Left
        window.kpw_nbf_p.FontFace = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
        window.kpw_nbf_p["TextColor3"] = Color3.fromRGB(138, 138, 148)
        window["kpw_nbf_p"].BackgroundTransparency = 1
        window.kpw_nbf_p.ZIndex = 56
        window.kpw_nbf_p.Size = UDim2.new(0, 82, 0, 26)
        window.kpw_nbf_p["Text"] = "New bind"
        window.kpw_nbf_p["Name"] = "Placeholder"
        window["kpw_nbf_p"].Position = UDim2.new(0, 27, 0, 0)
        window.kpw_nbf_pp = Instance.new("ImageLabel", window.kpw_nbf)
        window["kpw_nbf_pp"]["BorderSizePixel"] = 0
        window.kpw_nbf_pp["ScaleType"] = Enum.ScaleType.Fit
        window.kpw_nbf_pp.ImageColor3 = Color3.fromRGB(138, 138, 148)
        window.kpw_nbf_pp.Image = "rbxassetid://101123124881873"
        window.kpw_nbf_pp["ZIndex"] = 57
        window.kpw_nbf_pp.Size = UDim2.new(0, 12, 0, 12)
        window.kpw_nbf_pp.BackgroundTransparency = 1
        window.kpw_nbf_pp["Name"] = "IMG_Plus"
        window["kpw_nbf_pp"].Position = UDim2.new(0, 116, 0, 7)
        window.kpw_nbf_h = Instance.new("TextButton", window.kpw_nbf)
        window["kpw_nbf_h"]["AutoButtonColor"] = false
        window.kpw_nbf_h.ZIndex = 57
        window.kpw_nbf_h["BackgroundTransparency"] = 1
        window.kpw_nbf_h.Size = UDim2.new(1, 0, 1, 0)
        window.kpw_nbf_h.Text = ""
        window.kpw_nbf_h["Name"] = "Hit"
        window.kpw_tb = Instance.new("Frame", window.kpw)
        window.kpw_tb.BorderSizePixel = 0
        window.kpw_tb.BackgroundColor3 = Color3.fromRGB(41, 43, 54)
        window.kpw_tb.ZIndex = 56
        window.kpw_tb.Size = UDim2.new(0, 65, 0, 26)
        window.kpw_tb.Position = UDim2.new(0, 8, 0, 42)
        window.kpw_tb.Name = "ToggleButton"
        window.kpw_tb_c = Instance.new("UICorner", window.kpw_tb)
        window.kpw_tb_c.CornerRadius = UDim.new(0, 7)
        window.kpw_tb_s = Instance.new("UIStroke", window.kpw_tb)
        window["kpw_tb_s"].Transparency = 1
        window.kpw_tb_s.Color = Color3.fromRGB(84, 84, 100)
        window["kpw_tb_h"] = Instance.new("TextButton", window.kpw_tb)
        window["kpw_tb_h"].AutoButtonColor = false
        window["kpw_tb_h"].ZIndex = 57
        window["kpw_tb_h"]["BackgroundTransparency"] = 1
        window.kpw_tb_h.Size = UDim2.new(1, 0, 1, 0)
        window.kpw_tb_h.Text = ""
        window.kpw_tb_h.Name = "Hit"
        window.kpw_hb = Instance.new("Frame", window.kpw)
        window.kpw_hb.BorderSizePixel = 0
        window.kpw_hb.BackgroundColor3 = Color3.fromRGB(41, 43, 54)
        window.kpw_hb.ZIndex = 57
        window.kpw_hb.Size = UDim2.new(0, 65, 0, 26)
        window.kpw_hb["Position"] = UDim2.new(0, 77, 0, 42)
        window["kpw_hb"].Name = "HoldButton"
        window.kpw_hb_c = Instance.new("UICorner", window.kpw_hb)
        window["kpw_hb_c"]["CornerRadius"] = UDim.new(0, 7)
        window.kpw_hb_s = Instance.new("UIStroke", window.kpw_hb)
        window.kpw_hb_s.Transparency = 1
        window.kpw_hb_s.Color = Color3.fromRGB(84, 84, 100)
        window.kpw_hb_h = Instance.new("TextButton", window.kpw_hb)
        window.kpw_hb_h.AutoButtonColor = false
        window["kpw_hb_h"].ZIndex = 57
        window.kpw_hb_h["BackgroundTransparency"] = 1
        window.kpw_hb_h["Size"] = UDim2.new(1, 0, 1, 0)
        window.kpw_hb_h["Text"] = ""
        window.kpw_hb_h["Name"] = "Hit"
        window.kpw_ms = Instance.new("Frame", window.kpw)
        window.kpw_ms["BorderSizePixel"] = 0
        window["kpw_ms"].BackgroundColor3 = Color3.fromRGB(125, 104, 246)
        window.kpw_ms.ZIndex = 56
        window.kpw_ms["Size"] = UDim2.new(0, 65, 0, 26)
        window.kpw_ms.Position = UDim2.new(0, 8, 0, 42)
        window.kpw_ms.Name = "ModeSelection"
        window.kpw_ms_c = Instance.new("UICorner", window.kpw_ms)
        window.kpw_ms_c["CornerRadius"] = UDim.new(0, 7)
        window.kpw_tl = Instance.new("TextLabel", window.kpw)
        window.kpw_tl["TextSize"] = 12
        window.kpw_tl["TextXAlignment"] = Enum.TextXAlignment.Center
        window.kpw_tl.FontFace = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
        window["kpw_tl"].TextColor3 = Color3.fromRGB(34, 29, 72)
        window.kpw_tl.BackgroundTransparency = 1
        window.kpw_tl.ZIndex = 56
        window.kpw_tl.Size = UDim2.new(0, 65, 0, 26)
        window.kpw_tl["Text"] = "Toggle"
        window.kpw_tl["Name"] = "ToggleLabel"
        window["kpw_tl"]["Position"] = UDim2.new(0, 8, 0, 42)
        window.kpw_hl = Instance.new("TextLabel", window["kpw"])
        window.kpw_hl.TextSize = 12
        window.kpw_hl.TextXAlignment = Enum.TextXAlignment.Center
        window.kpw_hl.FontFace = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
        window["kpw_hl"].TextColor3 = Color3.fromRGB(244, 244, 248)
        window.kpw_hl["BackgroundTransparency"] = 1
        window.kpw_hl["ZIndex"] = 57
        window.kpw_hl.Size = UDim2.new(0, 65, 0, 26)
        window.kpw_hl.Text = "Hold"
        window["kpw_hl"].Name = "HoldLabel"
        window.kpw_hl.Position = UDim2.new(0, 77, 0, 42)

        local function getInputKey(arg)
            if arg.UserInputType == Enum.UserInputType.Keyboard then
                return arg.KeyCode
            end

            if arg.UserInputType == Enum.UserInputType.MouseButton1 then
                return Enum.UserInputType.MouseButton1
            end

            if arg.UserInputType == Enum.UserInputType.MouseButton2 then
                return Enum.UserInputType.MouseButton2
            end

            if arg.UserInputType == Enum.UserInputType.MouseButton3 then
                return Enum.UserInputType.MouseButton3
            end
            return nil
        end

        local function formatKeyName(arg)
            if typeof(arg) == "EnumItem" then
                if arg.EnumType == Enum.UserInputType then
                    if arg == Enum.UserInputType.MouseButton1 then
                        return "M1"
                    end

                    if arg == Enum.UserInputType.MouseButton2 then
                        return "M2"
                    end

                    if arg == Enum.UserInputType.MouseButton3 then
                        return "M3"
                    end
                end

                return (arg.Name:gsub("Left", "L"):gsub("Right", "R"):gsub("Control", "Ctrl"):gsub("Shift", "Shf"))
            end

            return "None"
        end

        local modifierKeys = { Enum.KeyCode.LeftControl, Enum.KeyCode.RightControl, Enum.KeyCode.LeftAlt, Enum.KeyCode.RightAlt }

        window.kpw_nbf_h.MouseButton1Click:Connect(function()
            if not window.ActiveKeybindToggle then
                return
            end
            window.WaitingForKey = true
            window.kpw_nbf_p.Text = "Press a key..."
            window["kpw_nbf_p"].TextColor3 = Color3.fromRGB(125, 109, 247)
            TweenService:Create(window.kpw_nbf_s, TweenInfo.new(0.2), { Transparency = 0 }):Play()
        end)

        window.kpw_tb_h.MouseButton1Click:Connect(function()
            if not window.ActiveKeybindToggle then
                return
            end
            window.ActiveKeybindToggle.KeybindMode = "toggle"

            if Library.Keybinds[window.ActiveKeybindToggle] then
                Library.Keybinds[window.ActiveKeybindToggle].mode = "toggle"
            end

            if window.ActiveKeybindToggle.flag and Library.Flags[window.ActiveKeybindToggle.flag .. "_keybind"] then
                Library.Flags[window.ActiveKeybindToggle.flag .. "_keybind"].mode = "toggle"
                Library.save_flags()
            end

            TweenService:Create(window["kpw_ms"], TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Position = UDim2.new(0, 8, 0, 42) }):Play()
            window.kpw_tl.TextColor3 = Color3.fromRGB(34, 29, 72)
            window.kpw_hl.TextColor3 = Color3.fromRGB(244, 244, 248)
        end)

        window.kpw_hb_h.MouseButton1Click:Connect(function()
            if not window.ActiveKeybindToggle then
                return
            end
            window.ActiveKeybindToggle.KeybindMode = "hold"

            if Library.Keybinds[window.ActiveKeybindToggle] then
                Library.Keybinds[window.ActiveKeybindToggle].mode = "hold"
            end

            if window.ActiveKeybindToggle.flag and Library.Flags[window.ActiveKeybindToggle.flag .. "_keybind"] then
                Library.Flags[window.ActiveKeybindToggle.flag .. "_keybind"].mode = "hold"
                Library.save_flags()
            end

            TweenService:Create(window.kpw_ms, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Position = UDim2.new(0, 77, 0, 42) }):Play()
            window.kpw_tl.TextColor3 = Color3.fromRGB(244, 244, 248)
            window.kpw_hl.TextColor3 = Color3.fromRGB(34, 29, 72)
        end)

        UserInputService.InputBegan:Connect(function(input)
            if not window.WaitingForKey then
                return
            end

            if input.KeyCode == Enum.KeyCode.End then
                window.WaitingForKey = false
                local activeKeybindToggle = window.ActiveKeybindToggle

                if activeKeybindToggle then
                    activeKeybindToggle.Keybind = nil
                    activeKeybindToggle.KeybindName = nil
                    Library.Keybinds[activeKeybindToggle] = nil

                    if activeKeybindToggle.flag then
                        Library.Flags[activeKeybindToggle.flag .. "_keybind"] = nil
                        Library.save_flags()
                    end

                    if activeKeybindToggle["72_text"] then
                        activeKeybindToggle["72_text"].Text = "Â·Â·Â·"
                        activeKeybindToggle["72_text"].TextColor3 = Color3.fromRGB(138, 138, 148)
                    end

                    if activeKeybindToggle["73_s"] then
                        TweenService:Create(activeKeybindToggle["73_s"], TweenInfo.new(0.2), { Transparency = 1 }):Play()
                    end
                end

                window.kpw_nbf_p.Text = "New bind"
                window.kpw_nbf_p.TextColor3 = Color3.fromRGB(138, 138, 148)
                TweenService:Create(window.kpw_nbf_s, TweenInfo.new(0.2), { Transparency = 1 }):Play()
                return
            end

            local pressedKey = getInputKey(input)
            if pressedKey == nil then
                return
            end

            if table.find(modifierKeys, pressedKey) then
                return
            end
            window.WaitingForKey = false
            local activeKeybindToggle = window.ActiveKeybindToggle
            if not activeKeybindToggle then
                return
            end
            activeKeybindToggle.Keybind = pressedKey
            activeKeybindToggle.KeybindName = formatKeyName(pressedKey)

            if not activeKeybindToggle.KeybindMode then
                activeKeybindToggle.KeybindMode = "toggle"
            end

            Library.Keybinds[activeKeybindToggle] = { key = pressedKey, mode = activeKeybindToggle.KeybindMode, flag = activeKeybindToggle.flag }

            if activeKeybindToggle.flag then
                Library.Flags[activeKeybindToggle.flag .. "_keybind"] = {
                    keyName = pressedKey.Name,
                    keyType = pressedKey.EnumType == Enum.KeyCode and "KeyCode" or "UserInputType",
                    displayName = formatKeyName(pressedKey),
                    mode = activeKeybindToggle.KeybindMode,
                }

                Library.save_flags()
            end

            window["kpw_nbf_p"].Text = formatKeyName(pressedKey)
            window.kpw_nbf_p.TextColor3 = Color3.fromRGB(243, 243, 247)
            TweenService:Create(window.kpw_nbf_s, TweenInfo.new(0.2), { Transparency = 1 }):Play()

            if activeKeybindToggle["72_text"] then
                activeKeybindToggle["72_text"].Text = formatKeyName(pressedKey)
                activeKeybindToggle["72_text"].TextColor3 = Color3.fromRGB(125, 109, 247)
            end

            if activeKeybindToggle["73_s"] then
                TweenService:Create(activeKeybindToggle["73_s"], TweenInfo.new(0.2), { Transparency = 0 }):Play()
            end
        end)

        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then
                return
            end

            if window.WaitingForKey then
                return
            end
            local pressedKey = getInputKey(input)
            if pressedKey == nil then
                return
            end

            for k, keybind in pairs(Library.Keybinds) do
                if keybind.key == pressedKey and k.flag then
                    if keybind.mode == "toggle" then
                        if not k._keybindHeld then
                            k._keybindHeld = true

                            pcall(function()
                                k:Toggle()
                            end)
                        end
                    elseif keybind.mode == "hold" then
                        k._keybindHeld = true

                        pcall(function()
                            k:Toggle(true)
                        end)
                    end
                end
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            local pressedKey = getInputKey(input)
            if pressedKey == nil then
                return
            end

            for k, keybind in pairs(Library.Keybinds) do
                if keybind.key == pressedKey and k.flag then
                    if keybind.mode == "toggle" then
                        k._keybindHeld = false
                    elseif keybind.mode == "hold" then
                        k._keybindHeld = false

                        pcall(function()
                            k:Toggle(false)
                        end)
                    end
                end
            end
        end)

        window.cpw = Instance.new("Frame", window["1"])
        window.cpw.BorderSizePixel = 0
        window.cpw.BackgroundColor3 = Color3.fromRGB(9, 10, 15)
        window.cpw.ZIndex = 90
        window.cpw.Size = UDim2.new(0, 150, 0, 200)
        window.cpw.Position = UDim2.new(0, 500, 0, 200)
        window.cpw.Position = UDim2.new(-0.04, 1098, 0.286, 240)
        window.cpw.Name = "color_picker_window"
        window.cpw.Visible = false
        window.cpw.ClipsDescendants = true
        window.cpw:SetAttribute("fadeIsolated", true)
        window.cpw_c = Instance.new("UICorner", window.cpw)
        window.cpw_c["CornerRadius"] = UDim.new(0, 10)
        window.cpw_s = Instance.new("UIStroke", window.cpw)
        window.cpw_s.Transparency = 0.45
        window.cpw_s.Color = Color3.fromRGB(48, 48, 58)
        window.cpw_sh = Instance.new("UIShadow", window.cpw)
        window.cpw_sh.Transparency = 1
        window.cpw_sh:SetAttribute("fadeOriginal_Transparency", 1)
        window.cpw_pal = Instance.new("Frame", window.cpw)
        window.cpw_pal.BackgroundColor3 = Color3.fromRGB(0, 110, 255)
        window.cpw_pal.BorderSizePixel = 0
        window.cpw_pal.ClipsDescendants = true
        window.cpw_pal.Position = UDim2.new(0, 10, 0, 10)
        window.cpw_pal["Size"] = UDim2.new(0, 106, 0, 106)
        window.cpw_pal.ZIndex = 51
        window.cpw_pal.Name = "Palette"
        Instance.new("UICorner", window.cpw_pal).CornerRadius = UDim.new(0, 6)
        window.cpw_pal_w = Instance.new("Frame", window.cpw_pal)
        window.cpw_pal_w.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        window.cpw_pal_w.BorderSizePixel = 0
        window.cpw_pal_w.Size = UDim2.new(1, 0, 1, 0)
        window.cpw_pal_w.ZIndex = 51
        window.cpw_pal_w["Name"] = "WhiteOverlay"
        Instance.new("UICorner", window.cpw_pal_w).CornerRadius = UDim.new(0, 6)
        local numberSequence = NumberSequence.new
        local new = NumberSequenceKeypoint.new
        local constant = 1
        Instance.new("UIGradient", window.cpw_pal_w).Transparency = numberSequence({ NumberSequenceKeypoint.new(0, 0), new(constant, 1) })
        window.cpw_pal_b = Instance.new("Frame", window.cpw_pal)
        window.cpw_pal_b["BackgroundColor3"] = Color3.fromRGB(0, 0, 0)
        window.cpw_pal_b.BorderSizePixel = 0
        window.cpw_pal_b.Size = UDim2.new(1, 0, 1, 0)
        window.cpw_pal_b.ZIndex = 51
        window.cpw_pal_b.Name = "BlackOverlay"
        Instance.new("UICorner", window.cpw_pal_b).CornerRadius = UDim.new(0, 6)
        local uiGradient = Instance.new("UIGradient", window.cpw_pal_b)
        uiGradient.Rotation = 90
        local new2 = NumberSequenceKeypoint.new
        uiGradient.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), new2(1, 0) })
        window.cpw_pal_sel = Instance.new("Frame", window.cpw_pal)
        window.cpw_pal_sel["BackgroundTransparency"] = 1
        window.cpw_pal_sel["BorderSizePixel"] = 0
        window.cpw_pal_sel.Position = UDim2.new(0.9, 0, 0, 0)
        window.cpw_pal_sel["Size"] = UDim2.new(0, 10, 0, 10)
        window.cpw_pal_sel.ZIndex = 52
        window.cpw_pal_sel["Name"] = "Selector"
        Instance.new("UICorner", window.cpw_pal_sel).CornerRadius = UDim.new(0, 4)
        local instance2 = Instance.new("UIStroke", window.cpw_pal_sel)
        instance2.Color = Color3.fromRGB(255, 255, 255)
        instance2.Transparency = 0
        instance2.Thickness = 2
        window.cpw_hue = Instance.new("Frame", window.cpw)
        window.cpw_hue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        window.cpw_hue.BorderSizePixel = 0
        window.cpw_hue.Position = UDim2.new(0, 124, 0, 10)
        window.cpw_hue.Size = UDim2.new(0, 12, 0, 106)
        window.cpw_hue.ZIndex = 51
        window.cpw_hue.Name = "HueStrip"
        Instance.new("UICorner", window.cpw_hue).CornerRadius = UDim.new(0, 5)
        local uiGradient2 = Instance.new("UIGradient", window.cpw_hue)
        local colorSequence = ColorSequence.new
        local keypoints = {}
        local keypoint = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0))
        local keypoint2 = ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0))
        local keypoint3 = ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0))
        local keypoint4 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255))
        local keypoint5 = ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255))
        local keypoint6 = ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255))
        keypoints[1] = keypoint
        keypoints[2] = keypoint2
        keypoints[3] = keypoint3
        keypoints[4] = keypoint4
        keypoints[5] = keypoint5
        keypoints[6] = keypoint6

        do
            local values = table.pack(ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)))
            table.move(values, 1, values.n, 7, keypoints)
        end

        uiGradient2.Color = colorSequence(keypoints)
        uiGradient2.Rotation = 90
        window.cpw_hue_k = Instance.new("Frame", window.cpw_hue)
        window.cpw_hue_k["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
        window.cpw_hue_k.BorderSizePixel = 0
        window.cpw_hue_k.Position = UDim2.new(0, 0, 0, 0)
        window.cpw_hue_k.Size = UDim2.new(0, 12, 0, 9)
        window.cpw_hue_k["ZIndex"] = 52
        window.cpw_hue_k["Name"] = "Knob"
        Instance.new("UICorner", window.cpw_hue_k).CornerRadius = UDim.new(0, 4)
        local instance3 = Instance.new("UIStroke", window.cpw_hue_k)
        instance3.Color = Color3.fromRGB(31, 30, 38)
        instance3.Transparency = 0
        instance3.Thickness = 2
        window.cpw_alpha = Instance.new("Frame", window.cpw)
        window.cpw_alpha.BackgroundColor3 = Color3.fromRGB(42, 42, 52)
        window.cpw_alpha["BorderSizePixel"] = 0
        window.cpw_alpha.ClipsDescendants = true
        window.cpw_alpha.Position = UDim2.new(0, 10, 0, 124)
        window.cpw_alpha.Size = UDim2.new(0, 126, 0, 10)
        window.cpw_alpha.ZIndex = 51
        window.cpw_alpha.Name = "AlphaBar"
        Instance.new("UICorner", window.cpw_alpha).CornerRadius = UDim.new(0, 6)
        local imageLabel = Instance.new("ImageLabel", window.cpw_alpha)
        imageLabel.Name = "Checkers"
        imageLabel.BackgroundTransparency = 1
        imageLabel.BorderSizePixel = 0
        imageLabel.Image = "rbxassetid://18274452449"
        imageLabel.ImageColor3 = Color3.fromRGB(255, 255, 255)
        imageLabel.ImageTransparency = 0.6
        imageLabel.ScaleType = Enum.ScaleType.Tile
        imageLabel.TileSize = UDim2.new(0, 6, 0, 6)
        imageLabel.Size = UDim2.new(1, 0, 1, 0)
        imageLabel.ZIndex = 51
        window.cpw_alpha_ramp = Instance.new("Frame", window.cpw_alpha)
        window.cpw_alpha_ramp.BackgroundColor3 = Color3.fromRGB(28, 108, 221)
        window.cpw_alpha_ramp.BorderSizePixel = 0
        window.cpw_alpha_ramp.Size = UDim2.new(1, 0, 1, 0)
        window.cpw_alpha_ramp.ZIndex = 51
        window.cpw_alpha_ramp["Name"] = "Ramp"
        Instance.new("UICorner", window.cpw_alpha_ramp).CornerRadius = UDim.new(0, 6)
        local numberSequence2 = NumberSequence.new
        local new3 = NumberSequenceKeypoint.new
        local constant2 = 1
        local constant3 = 0
        Instance.new("UIGradient", window.cpw_alpha_ramp).Transparency = numberSequence2({ NumberSequenceKeypoint.new(0, 1), new3(constant2, constant3) })
        window.cpw_alpha_k = Instance.new("Frame", window.cpw_alpha)
        window.cpw_alpha_k.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        window.cpw_alpha_k.BorderSizePixel = 0
        window.cpw_alpha_k.Position = UDim2.new(0.93, 0, 0, 0)
        window.cpw_alpha_k["Size"] = UDim2.new(0, 9, 0, 10)
        window.cpw_alpha_k.ZIndex = 52
        window.cpw_alpha_k.Name = "Knob"
        Instance.new("UICorner", window.cpw_alpha_k).CornerRadius = UDim.new(0, 4)
        local instance4 = Instance.new("UIStroke", window.cpw_alpha_k)
        instance4.Color = Color3.fromRGB(30, 30, 38)
        instance4.Transparency = 0
        instance4.Thickness = 2
        window.cpw_hex = Instance.new("Frame", window.cpw)
        window.cpw_hex.BorderSizePixel = 0
        window.cpw_hex.BackgroundColor3 = Color3.fromRGB(22, 23, 31)
        window.cpw_hex.Position = UDim2.new(0, 10, 0, 142)
        window.cpw_hex.Size = UDim2.new(0, 126, 0, 24)
        window.cpw_hex.ZIndex = 51
        window.cpw_hex["Name"] = "HexField"
        Instance.new("UICorner", window.cpw_hex).CornerRadius = UDim.new(0, 6)
        window.cpw_hex_v = Instance.new("TextBox", window.cpw_hex)
        window.cpw_hex_v["BackgroundTransparency"] = 1
        window.cpw_hex_v["Position"] = UDim2.new(0, 9, 0, 0)
        window.cpw_hex_v["Size"] = UDim2.new(0, 108, 0, 24)
        window.cpw_hex_v.ZIndex = 51
        window.cpw_hex_v["FontFace"] = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
        window.cpw_hex_v.Text = "1C6CDDFF"
        window.cpw_hex_v.TextColor3 = Color3.fromRGB(244, 244, 248)
        window.cpw_hex_v["TextSize"] = 11
        window.cpw_hex_v.TextXAlignment = Enum.TextXAlignment.Left
        window.cpw_hex_v["ClearTextOnFocus"] = false
        window.cpw_hex_v.Name = "Value"
        window.ColorPickerState = { hue = 0.6, saturation = 0.87, value = 0.87, alpha = 1, isOpen = false, currentTarget = nil }
        local colorPickerState = window.ColorPickerState

        local function getColorPickerColor()
            return Color3.fromHSV(colorPickerState.hue, colorPickerState.saturation, colorPickerState.value)
        end

        local function getColorPickerHex()
            local color13 = getColorPickerColor()
            return string.format("%02X%02X%02X%02X", math.floor(color13.R * 255 + 0.5), math.floor(color13.G * 255 + 0.5), math.floor(color13.B * 255 + 0.5), math.floor(colorPickerState.alpha * 255 + 0.5))
        end

        local function refreshColorPicker()
            local sampledColor = getColorPickerColor()
            TweenService:Create(window.cpw_pal, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { BackgroundColor3 = Color3.fromHSV(colorPickerState.hue, 1, 1) }):Play()
            local constant4 = 0
            TweenService:Create(window.cpw_pal_sel, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Position = UDim2.new(math.min(colorPickerState.saturation, 0.92), constant4, math.min(1 - colorPickerState.value, 0.92), 0) }):Play()
            local constant5 = 0
            TweenService:Create(window.cpw_hue_k, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Position = UDim2.new(0, 0, math.min(colorPickerState.hue, 0.92), constant5) }):Play()
            local constant6 = 0
            local constant7 = 0
            TweenService:Create(window.cpw_alpha_k, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Position = UDim2.new(math.min(colorPickerState.alpha, 0.93), constant6, constant7, 0) }):Play()
            TweenService:Create(window.cpw_alpha_ramp, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { BackgroundColor3 = sampledColor }):Play()
            window.cpw_hex_v.Text = getColorPickerHex()

            if colorPickerState.currentTarget then
                TweenService:Create(colorPickerState.currentTarget.swatch, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { BackgroundColor3 = sampledColor }):Play()

                if colorPickerState.currentTarget.callback then
                    colorPickerState.currentTarget.callback(sampledColor)
                end

                if colorPickerState.currentTarget.flag then
                    Library.Flags[colorPickerState.currentTarget.flag] = sampledColor
                    Library.save_flags()
                end
            end
        end

        local function closeColorPicker()
            colorPickerState.isOpen = false
            colorPickerState.currentTarget = nil
            TweenService:Create(window.cpw_sh, TweenInfo.new(0.2), { Transparency = 1 }):Play()
            local tween = TweenService:Create(window.cpw, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Size = UDim2.new(0, 0, 0, 0) })

            tween.Completed:Once(function()
                window.cpw.Visible = false
            end)

            tween:Play()
        end

        window.closeColorPicker = closeColorPicker

        window.openColorPicker = function(arg, arg2, arg3)
            if window.cpw.Visible and colorPickerState.currentTarget and colorPickerState.currentTarget.swatch == arg then
                closeColorPicker()
                return
            end
            colorPickerState.isOpen = true
            colorPickerState.currentTarget = { swatch = arg, callback = arg2, flag = arg3 }
            local colorPickerState = colorPickerState
            local colorPickerState2 = colorPickerState
            local colorPickerState3 = colorPickerState
            local hue, saturation, brightness = arg.BackgroundColor3:ToHSV()
            colorPickerState.hue = hue
            colorPickerState2.saturation = saturation
            colorPickerState3.value = brightness
            colorPickerState.alpha = 1
            local absolutePosition = arg.AbsolutePosition
            local absolutePosition2 = window["1"].AbsolutePosition
            window.cpw.Position = UDim2.new(0, absolutePosition.X - absolutePosition2.X - 150 - 8, 0, absolutePosition.Y - absolutePosition2.Y - (178 - arg.AbsoluteSize.Y) / 2)
            window.cpw.Size = UDim2.new(0, 0, 0, 0)
            window.cpw.Visible = true
            TweenService:Create(window.cpw_sh, TweenInfo.new(0.2), { Transparency = 0.55 }):Play()
            TweenService:Create(window.cpw, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Size = UDim2.new(0, 150, 0, 178) }):Play()
            refreshColorPicker()
        end

        local flag25 = false
        local textButton = Instance.new("TextButton", window.cpw_pal)
        textButton.AutoButtonColor = false
        textButton.ZIndex = 53
        textButton.BackgroundTransparency = 1
        textButton.Size = UDim2.new(1, 0, 1, 0)
        textButton.Text = ""
        textButton.Name = "Hit"

        local function updateColorPickerSV(arg)
            local absolutePosition = window.cpw_pal.AbsolutePosition
            local absoluteSize = window.cpw_pal.AbsoluteSize
            local constant4 = 0
            colorPickerState.saturation = math.clamp((arg.X - absolutePosition.X) / math.max(1, absoluteSize.X), constant4, 1)
            colorPickerState.value = 1 - math.clamp((arg.Y - absolutePosition.Y) / math.max(1, absoluteSize.Y), 0, 1)
            refreshColorPicker()
        end

        textButton.MouseButton1Down:Connect(function()
            flag25 = true
            updateColorPickerSV(UserInputService:GetMouseLocation())
        end)

        UserInputService.InputChanged:Connect(function(input)
            if flag25 and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                updateColorPickerSV(input.Position)
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                flag25 = false
            end
        end)

        local flag26 = false
        local textButton2 = Instance.new("TextButton", window.cpw_hue)
        textButton2.AutoButtonColor = false
        textButton2.ZIndex = 53
        textButton2.BackgroundTransparency = 1
        textButton2.Size = UDim2.new(1, 0, 1, 0)
        textButton2.Text = ""
        textButton2.Name = "Hit"

        local function updateColorPickerHue(arg)
            local constant4 = 0
            colorPickerState.hue = math.clamp((arg.Y - window.cpw_hue.AbsolutePosition.Y) / math.max(1, window.cpw_hue.AbsoluteSize.Y), constant4, 0.999)
            refreshColorPicker()
        end

        textButton2.MouseButton1Down:Connect(function()
            flag26 = true
            updateColorPickerHue(UserInputService:GetMouseLocation())
        end)

        UserInputService.InputChanged:Connect(function(input)
            if flag26 and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                updateColorPickerHue(input.Position)
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                flag26 = false
            end
        end)

        local flag27 = false
        local textButton3 = Instance.new("TextButton", window.cpw_alpha)
        textButton3.AutoButtonColor = false
        textButton3.ZIndex = 53
        textButton3.BackgroundTransparency = 1
        textButton3.Size = UDim2.new(1, 0, 1, 0)
        textButton3.Text = ""
        textButton3.Name = "Hit"

        local function updateColorPickerAlpha(arg)
            colorPickerState.alpha = math.clamp((arg.X - window.cpw_alpha.AbsolutePosition.X) / math.max(1, window.cpw_alpha.AbsoluteSize.X), 0, 1)
            refreshColorPicker()
        end

        textButton3.MouseButton1Down:Connect(function()
            flag27 = true
            updateColorPickerAlpha(UserInputService:GetMouseLocation())
        end)

        UserInputService.InputChanged:Connect(function(input)
            if flag27 and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                updateColorPickerAlpha(input.Position)
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                flag27 = false
            end
        end)

        window.cpw_hex_v.FocusLost:Connect(function()
            local match, capture2, capture3, capture4 = window.cpw_hex_v.Text:gsub("#", ""):upper():match("^(%x%x)(%x%x)(%x%x)(%x?%x?)$")

            if match then
                local tonumber = tonumber
                local constant4 = 16
                local color = Color3.fromRGB(tonumber(match, 16), tonumber(capture2, 16), tonumber(capture3, constant4))
                local colorPickerState = colorPickerState
                local colorPickerState2 = colorPickerState
                local colorPickerState3 = colorPickerState
                local hue, saturation, brightness = color:ToHSV()
                colorPickerState.hue = hue
                colorPickerState2.saturation = saturation
                colorPickerState3.value = brightness
                local colorPickerState4 = colorPickerState
                local alpha

                if capture4 ~= "" then
                    alpha = tonumber(capture4, 16) / 255
                else
                    alpha = 1
                end

                colorPickerState4.alpha = alpha
            end

            refreshColorPicker()
        end)

        UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if window.cpw.Visible and colorPickerState.isOpen and colorPickerState.currentTarget then
                    local position = input.Position
                    local absolutePosition = window.cpw.AbsolutePosition
                    local absoluteSize = window.cpw.AbsoluteSize
                    local absolutePosition2 = colorPickerState.currentTarget.swatch.AbsolutePosition
                    local absoluteSize2 = colorPickerState.currentTarget.swatch.AbsoluteSize

                    if not (position.X >= absolutePosition.X and position.X <= absolutePosition.X + absoluteSize.X and position.Y >= absolutePosition.Y and position.Y <= absolutePosition.Y + absoluteSize.Y) and not (position.X >= absolutePosition2.X - 8 and position.X <= absolutePosition2.X + absoluteSize2.X + 8 and position.Y >= absolutePosition2.Y - 8 and position.Y <= absolutePosition2.Y + absoluteSize2.Y + 8) then
                        closeColorPicker()
                    end
                end
            end
        end)

        window["2b"] = Instance.new("Frame", window["2"])
        window["2b"]["BorderSizePixel"] = 0
        window["2b"]["BackgroundColor3"] = Color3.fromRGB(27, 27, 34)
        window["2b"].Size = UDim2.new(1, -158, 0, 22)
        window["2b"].Position = UDim2.new(0, 158, 0, 62)
        window["2b"].Name = "breadcrumb"
        window["2b"].BackgroundTransparency = 1
        window["2b"]:SetAttribute("fadeOriginal_BackgroundTransparency", 1)
        window["2c"] = Instance.new("ImageLabel", window["2b"])
        window["2c"].BorderSizePixel = 0
        window["2c"]["ScaleType"] = Enum.ScaleType.Fit
        local icon = Library:GetIcon("chevron-right")
        local n2c = window["2c"]

        if icon then
            n2c.Image = icon.Url
            n2c.ImageRectOffset = icon.ImageRectOffset
            n2c.ImageRectSize = icon.ImageRectSize
        end

        window["2c"]["Size"] = UDim2.new(0, 15, 0, 15)
        window["2c"].BackgroundTransparency = 1
        window["2c"]["Name"] = "IMG_BreadcrumbIcon"
        window["2c"].Position = UDim2.new(0, 8, 0, 3)
        window["2c"]:SetAttribute("fadeOriginal_ImageTransparency", 0)
        window["2c"]:SetAttribute("fadeOriginal_BackgroundTransparency", 1)
        window["2d"] = Instance.new("TextLabel", window["2b"])
        window["2d"]["TextSize"] = 12
        window["2d"]["TextXAlignment"] = Enum.TextXAlignment.Left
        window["2d"]["FontFace"] = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
        window["2d"].TextColor3 = Color3.fromRGB(143, 143, 154)
        window["2d"].BackgroundTransparency = 1
        window["2d"].Size = UDim2.new(0, 48, 0, 22)
        window["2d"].Text = "Blatant"
        window["2d"].Name = "Section"
        window["2d"].Position = UDim2.new(0, 25, 0, 0)
        window["2d"]:SetAttribute("fadeOriginal_TextTransparency", 0)
        window["2d"]:SetAttribute("fadeOriginal_BackgroundTransparency", 1)
        window["2e"] = Instance.new("TextLabel", window["2b"])
        window["2e"]["TextSize"] = 18
        window["2e"].FontFace = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
        window["2e"].TextColor3 = Color3.fromRGB(106, 106, 117)
        window["2e"].BackgroundTransparency = 1
        window["2e"]["Size"] = UDim2.new(0, 25, 0, 26)
        window["2e"]["Text"] = ""
        window["2e"].Name = "Arrow"
        window["2e"].Position = UDim2.new(0, 72, 0, -4)
        window["2e"]:SetAttribute("fadeOriginal_TextTransparency", 0)
        window["2e"]:SetAttribute("fadeOriginal_BackgroundTransparency", 1)
        window["2f"] = Instance.new("ImageLabel", window["2e"])
        window["2f"].BorderSizePixel = 0
        window["2f"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        window["2f"].Image = "rbxassetid://10709768347"
        window["2f"].Size = UDim2.new(0, 13, 0, 13)
        window["2f"]["BackgroundTransparency"] = 1
        window["2f"].Position = UDim2.new(0.28, 0, 0.30769, 0)
        window["2f"]:SetAttribute("fadeOriginal_ImageTransparency", 0)
        window["2f"]:SetAttribute("fadeOriginal_BackgroundTransparency", 1)
        window["31"] = Instance.new("TextLabel", window["2b"])
        window["31"].TextSize = 12
        window["31"].TextXAlignment = Enum.TextXAlignment.Left
        window["31"].FontFace = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
        window["31"].TextColor3 = Color3.fromRGB(207, 207, 216)
        window["31"]["BackgroundTransparency"] = 1
        window["31"].Size = UDim2.new(0, 120, 0, 22)
        window["31"]["Text"] = "Automation"
        window["31"].Name = "Element"
        window["31"]["Position"] = UDim2.new(0, 91, 0, 0)
        window["31"]:SetAttribute("fadeOriginal_TextTransparency", 0)
        window["31"]:SetAttribute("fadeOriginal_BackgroundTransparency", 1)
        window["30"] = Instance.new("UIAspectRatioConstraint", window["2f"])
        local n2d = window["2d"]
        local n2e = window["2e"]
        local n312 = window["31"]

        local function updateHeaderLayout()
            local targetScale = window._targetScale or 1

            if targetScale <= 0 then
                targetScale = 1
            end

            local titleWidth = math.max(math.ceil(n2d.TextBounds.X / targetScale), 1)
            n2d.Size = UDim2.new(0, titleWidth, 0, 22)
            n2d.Position = UDim2.new(0, 25, 0, 0)
            local dividerOffset = 25 + titleWidth + 2
            n2e.Position = UDim2.new(0, dividerOffset, 0, -4)
            local sectionOffset = dividerOffset + 20 + 4
            local constant4 = 1
            n312.Size = UDim2.new(0, math.max(math.ceil(n312.TextBounds.X / targetScale), constant4), 0, 22)
            n312.Position = UDim2.new(0, sectionOffset, 0, 0)
        end

        n2d:GetPropertyChangedSignal("TextBounds"):Connect(updateHeaderLayout)
        n312:GetPropertyChangedSignal("TextBounds"):Connect(updateHeaderLayout)
        task.defer(updateHeaderLayout)
        window["32"] = Instance.new("TextLabel", window["2"])
        window["32"].TextSize = 13
        window["32"].TextXAlignment = Enum.TextXAlignment.Left
        window["32"]["FontFace"] = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
        window["32"].TextColor3 = Color3.fromRGB(243, 243, 247)
        window["32"].BackgroundTransparency = 1
        window["32"]["Size"] = UDim2.new(0, 200, 0, 16)
        window["32"].Text = "Auto Parry"
        window["32"].Name = "MainTitle"
        window["32"].Position = UDim2.new(0, 166, 0, 92)
        window["32"]:SetAttribute("fadeOriginal_TextTransparency", 0)
        window["32"]:SetAttribute("fadeOriginal_BackgroundTransparency", 1)
        window["33"] = Instance.new("TextLabel", window["2"])
        window["33"].TextSize = 13
        window["33"].TextXAlignment = Enum.TextXAlignment.Left
        window["33"].FontFace = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
        window["33"].TextColor3 = Color3.fromRGB(243, 243, 247)
        window["33"]["BackgroundTransparency"] = 1
        window["33"].Size = UDim2.new(0, 200, 0, 16)
        window["33"].Text = "Extras"
        window["33"].Name = "ExtraTitle"
        window["33"].Position = UDim2.new(0, 444, 0, 92)
        window["33"]:SetAttribute("fadeOriginal_TextTransparency", 0)
        window["33"]:SetAttribute("fadeOriginal_BackgroundTransparency", 1)
        local UserInputService2 = game:GetService("UserInputService")
        local n1 = window["1"]
        local n42 = window["4"]
        local tween = TweenService:Create(n42, TweenInfo.new(0.65, Enum.EasingStyle.Back, Enum.EasingDirection.InOut), { Scale = 1 })
        local tween2 = TweenService:Create(n42, TweenInfo.new(0.65, Enum.EasingStyle.Back, Enum.EasingDirection.InOut), { Scale = 0 })

        UserInputService2.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then
                return
            end

            if input.KeyCode == Enum.KeyCode.RightControl or input.KeyCode == Enum.KeyCode.Insert or input.KeyCode == Enum.KeyCode.RightAlt or input.KeyCode == Enum.KeyCode.LeftAlt then
                if n1.Enabled then
                    tween2:Play()
                    tween2.Completed:Wait()
                    n1.Enabled = false
                else
                    n1.Enabled = true
                    tween:Play()
                end
            end
        end)

        local n210 = window["2"]
        local flag28 = false
        local position = nil
        local position2 = nil

        n210.Active = true
        n210.Selectable = true

        local function beginWindowDrag(arg)
            flag28 = true
            position = arg.Position
            position2 = n210.Position
        end

        local function endWindowDrag()
            flag28 = false
        end

        n210.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                beginWindowDrag(input)
            end
        end)

        n210.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                endWindowDrag()
            end
        end)

        UserInputService2.InputChanged:Connect(function(input)
            if flag28 and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local n41 = input.Position - position
                n210.Position = UDim2.new(position2.X.Scale, position2.X.Offset + n41.X, position2.Y.Scale, position2.Y.Offset + n41.Y)
            end
        end)

        local function playUiTween(arg, arg2)
            local tween3 = TweenService:Create(arg, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), arg2)
            tween3:Play()
            return tween3
        end

        window["2a"].MouseButton1Click:Connect(function()
            local ef = window.ef
            ef.Visible = not ef.Visible

            if ef.Visible then
                if window.RefreshPresets then
                    window.RefreshPresets()
                    local size = ef.Size
                    ef.Size = UDim2.new(0, 236, 0, 0)
                    playUiTween(ef, { Size = size })
                else
                    playUiTween(ef, { Size = UDim2.new(0, 236, 0, 490) })
                end
            else
                playUiTween(ef, { Size = UDim2.new(0, 0, 0, 0) })
            end
        end)

        local n242 = window["24"]
        local widget = window["23"]
        local n252 = window["25"]
        local n41 = 0
        local scrollingFrame = Instance.new("ScrollingFrame", window["2"])
        scrollingFrame.BorderSizePixel = 0
        scrollingFrame.BackgroundTransparency = 1
        scrollingFrame.Size = UDim2.new(0, 264, 0, 322)
        scrollingFrame.Position = UDim2.new(0, 166, 0, 118)
        scrollingFrame.ScrollBarThickness = 2
        scrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 90)
        scrollingFrame.ClipsDescendants = true
        scrollingFrame.Visible = false
        scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        scrollingFrame.Name = "SearchScrollLeft"
        local uiListLayout2 = Instance.new("UIListLayout", scrollingFrame)
        uiListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
        uiListLayout2.Padding = UDim.new(0, 10)
        local scrollingFrame2 = Instance.new("ScrollingFrame", window["2"])
        scrollingFrame2.BorderSizePixel = 0
        scrollingFrame2.BackgroundTransparency = 1
        scrollingFrame2.Size = UDim2.new(0, 264, 0, 322)
        scrollingFrame2.Position = UDim2.new(0, 444, 0, 118)
        scrollingFrame2.ScrollBarThickness = 2
        scrollingFrame2.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 90)
        scrollingFrame2.ClipsDescendants = true
        scrollingFrame2.Visible = false
        scrollingFrame2.CanvasSize = UDim2.new(0, 0, 0, 0)
        scrollingFrame2.Name = "SearchScrollRight"
        local uiListLayout3 = Instance.new("UIListLayout", scrollingFrame2)
        uiListLayout3.SortOrder = Enum.SortOrder.LayoutOrder
        uiListLayout3.Padding = UDim.new(0, 10)

        uiListLayout2:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, uiListLayout2.AbsoluteContentSize.Y)
        end)

        uiListLayout3:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            scrollingFrame2.CanvasSize = UDim2.new(0, 0, 0, uiListLayout3.AbsoluteContentSize.Y)
        end)

        local function getSearchLabel(arg)
            local label = arg:FindFirstChild("Label", true)
            if label and label:IsA("TextLabel") then
                return label.Text
            end
            return arg.Name
        end

        n242.Focused:Connect(function()
            TweenService:Create(n252, TweenInfo.new(0.2), { Transparency = 0 }):Play()
        end)

        n242.FocusLost:Connect(function()
            TweenService:Create(n252, TweenInfo.new(0.2), { Transparency = 1 }):Play()
        end)

        n242:GetPropertyChangedSignal("Text"):Connect(function()
            local lowered = string.lower(n242.Text)
            n41 += 1

            if lowered == "" then
                widget.Visible = true
                scrollingFrame.Visible = false
                scrollingFrame2.Visible = false

                for _, tab in window.Tabs do
                    local allContainers = tab.AllContainers

                    if not allContainers then
                        allContainers = { { container = tab.ContentContainer, section = tab.Section or "left" } }
                    end

                    for _, container in allContainers do
                        if container.container.Parent ~= window["2"] then
                            container.container.Parent = window["2"]
                        end

                        for _, child in container.container:GetChildren() do
                            if child:IsA("GuiObject") then
                                child.Visible = true
                            end
                        end

                        local section = container.section
                        container.container.Visible = tab == window.CurrentTabs[section]
                        container.container.Position = UDim2.new(0, section == "right" and 444 or 166, 0, 118)
                    end
                end
            else
                widget.Visible = false
                scrollingFrame.Visible = true
                scrollingFrame2.Visible = true
                local layoutOrder = 0
                local layoutOrder2 = 0

                for _, tab in window.Tabs do
                    local allContainers = tab.AllContainers
                    local items

                    if allContainers then
                        items = allContainers
                    else
                        items = { { container = tab.ContentContainer, section = tab.Section or "left" } }
                    end

                    for _, presetRow in items do
                        local flag29 = false

                        for _, child in presetRow.container:GetChildren() do
                            if child:IsA("GuiObject") then
                                local callResult = getSearchLabel(child)

                                if string.find(string.lower(callResult), lowered) then
                                    child.Visible = true
                                    flag29 = true
                                else
                                    child.Visible = false
                                end
                            end
                        end

                        if flag29 then
                            if presetRow.section == "right" then
                                presetRow.container.Parent = scrollingFrame2
                                presetRow.container.LayoutOrder = layoutOrder
                                layoutOrder += 1
                            else
                                presetRow.container.Parent = scrollingFrame
                                presetRow.container.LayoutOrder = layoutOrder2
                                layoutOrder2 += 1
                            end

                            presetRow.container.Position = UDim2.new(0, 0, 0, 0)
                            presetRow.container.Visible = true
                        else
                            presetRow.container.Visible = false

                            if presetRow.container.Parent ~= window["2"] then
                                presetRow.container.Parent = window["2"]
                            end
                        end
                    end
                end
            end
        end)

        local widget2 = window["ef"]
        local fc = window.fc
        local n100 = window["100"]
        local ff = window.ff
        local f7 = window.f7
        local n282 = window["28"]
        local TweenService = game:GetService("TweenService")
        local configProfiles = { "Legit PvP", "Rage HVH" }
        local color = Color3.fromRGB(25, 24, 43)
        local color2 = Color3.fromRGB(31, 30, 39)
        local color3 = Color3.fromRGB(31, 30, 39)
        local color4 = Color3.fromRGB(150, 150, 161)
        local color5 = Color3.fromRGB(243, 243, 247)
        local color6 = Color3.fromRGB(120, 120, 131)
        local color7 = Color3.fromRGB(150, 150, 161)
        local color8 = Color3.fromRGB(120, 120, 131)
        local color9 = Color3.fromRGB(224, 82, 76)
        local color10 = Color3.fromRGB(125, 109, 247)
        local color11 = Color3.fromRGB(150, 150, 161)
        local color12 = Color3.fromRGB(125, 109, 247)
        local list = {}
        local passed = nil
        local flag29 = false
        local flag30 = true
        local imageLabel2 = Instance.new("ImageLabel")
        imageLabel2.Name = "indicator"
        imageLabel2.BackgroundTransparency = 1
        imageLabel2.BorderSizePixel = 0
        imageLabel2.Size = UDim2.new(0, 3, 0, 18)
        imageLabel2.Image = "rbxassetid://90362801488029"
        imageLabel2.ImageColor3 = color10
        imageLabel2.ZIndex = 62

        local function snapshotFlags()
            local items = {}

            for k, flagValue in Library.Flags do
                if type(flagValue) == "table" then
                    local items2 = {}

                    for k2, entry in flagValue do
                        items2[k2] = entry
                    end

                    items[k] = items2
                else
                    items[k] = flagValue
                end
            end

            return items
        end

        local function restoreFlags(arg)
            if not arg then
                return
            end

            for k in pairs(Library.Flags) do
                if k ~= "__lastPreset" then
                    Library.Flags[k] = nil
                end
            end

            for k, passedValue in arg do
                Library.Flags[k] = passedValue
            end
        end

        local function serializeFlags(arg)
            local items = {}

            for k, value in pairs(arg) do
                if k ~= "__lastPreset" then
                    if typeof(value) == "Color3" then
                        items[k] = { __type = "Color3", R = value.R, G = value.G, B = value.B }
                    else
                        items[k] = value
                    end
                end
            end

            return items
        end

        local function deserializeFlags(arg)
            if not arg then
                return {}
            end
            local items = {}

            for k, value in pairs(arg) do
                if type(value) == "table" and value.__type == "Color3" then
                    items[k] = Color3.new(value.R or 0, value.G or 0, value.B or 0)
                elseif type(value) == "table" and value.R ~= nil and value.G ~= nil and value.B ~= nil and value.A == nil and value.__type == nil and value.keyName == nil then
                    items[k] = Color3.new(value.R, value.G, value.B)
                else
                    items[k] = value
                end
            end

            return items
        end

        local function saveAllPresets()
            if flag30 then
                return
            end

            for _, entry in list do
                local callResult = serializeFlags(entry.flags or {})
                Library:save_preset(entry.name, callResult)
            end

            if passed then
                Library.Flags.__lastPreset = passed.name
            else
                Library.Flags.__lastPreset = nil
            end

            Library.save_flags()
        end

        local function refreshPresets()
            local lowered = string.lower(fc.Text or "")
            local list2 = {}

            for _, entry in list do
                if lowered == "" or string.find(string.lower(entry.name), lowered, 1, true) then
                    table.insert(list2, entry)
                end
            end

            if flag29 then
                table.sort(list2, function(arg, arg2)
                    return string.lower(arg.name) < string.lower(arg2.name)
                end)
            end

            for _, entry in list do
                entry.row.Visible = false
            end

            for k, entry in list2 do
                entry.row.Visible = true
                entry.row.Position = UDim2.new(0, 14, 0, 98 + (k - 1) * 42)
            end

            widget2.Size = UDim2.new(0, 236, 0, math.max(300, 98 + #list2 * 42 + 14))
        end

        window.RefreshPresets = refreshPresets

        local function refreshPresetSelection()
            for _, entry in list do
                local flag31 = entry == passed
                TweenService:Create(entry.row, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { BackgroundColor3 = flag31 and color3 or color }):Play()
                entry.nameLabel.FontFace = Font.new("rbxasset://fonts/families/Montserrat.json", flag31 and Enum.FontWeight.SemiBold or Enum.FontWeight.Medium, Enum.FontStyle.Normal)
                entry.nameLabel.TextColor3 = flag31 and color5 or color4
                entry.editIcon.ImageColor3 = flag31 and color7 or color6
                entry.deleteIcon.ImageColor3 = flag31 and color9 or color8
            end

            if passed and imageLabel2.Parent ~= nil then
                imageLabel2.Parent = passed.row
                imageLabel2.Position = UDim2.new(0, 0, 0, 8)
                n282.Text = passed.name
            end
        end

        local function applyPreset(arg)
            if passed == arg then
                return
            end

            if passed then
                passed.flags = snapshotFlags()
            end

            passed = arg
            window.ApplyingPreset = true

            for k, value in pairs(Library.Flags) do
                if k ~= "__lastPreset" and type(value) == "boolean" then
                    Library.Flags[k] = false
                end
            end

            for _, widget in ipairs(window.Widgets) do
                widget()
            end

            restoreFlags(arg.flags)

            for _, widget in ipairs(window.Widgets) do
                widget()
            end

            window.ApplyingPreset = false
            refreshPresetSelection()
            saveAllPresets()
        end

        local function createPresetRow(text2, flags, arg)
            local frame = Instance.new("Frame")
            frame.Name = "Config_" .. text2:gsub("%s", "_")
            frame.Parent = widget2
            frame.BackgroundTransparency = 0
            frame.BackgroundColor3 = color
            frame.BorderSizePixel = 0
            frame.Position = UDim2.new(0, 14, 0, 98)
            frame.Size = UDim2.new(0, 208, 0, 34)
            frame.ZIndex = 61
            Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
            local textLabel = Instance.new("TextLabel")
            textLabel.Name = "Name"
            textLabel.Parent = frame
            textLabel.BackgroundTransparency = 1
            textLabel.Position = UDim2.new(0, 14, 0, 0)
            textLabel.Size = UDim2.new(0, 130, 0, 34)
            textLabel.ZIndex = 61
            textLabel.FontFace = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
            textLabel.Text = text2
            textLabel.TextColor3 = color4
            textLabel.TextSize = 12
            textLabel.TextXAlignment = Enum.TextXAlignment.Left
            textLabel.TextTruncate = Enum.TextTruncate.AtEnd
            local imageLabel3 = Instance.new("ImageLabel")
            imageLabel3.Name = "IMG_Edit"
            imageLabel3.Parent = frame
            imageLabel3.BackgroundTransparency = 1
            imageLabel3.Position = UDim2.new(0, 150, 0, 9)
            imageLabel3.Size = UDim2.new(0, 16, 0, 16)
            imageLabel3.ZIndex = 61
            imageLabel3.Image = "rbxassetid://131819263664272"
            imageLabel3.ImageColor3 = color6
            imageLabel3.ScaleType = Enum.ScaleType.Fit
            local imageLabel4 = Instance.new("ImageLabel")
            imageLabel4.Name = "IMG_Delete"
            imageLabel4.Parent = frame
            imageLabel4.BackgroundTransparency = 1
            imageLabel4.Position = UDim2.new(0, 178, 0, 9)
            imageLabel4.Size = UDim2.new(0, 16, 0, 16)
            imageLabel4.ZIndex = 61
            imageLabel4.Image = "rbxassetid://126010725826757"
            imageLabel4.ImageColor3 = color8
            imageLabel4.ScaleType = Enum.ScaleType.Fit
            local presetRecord = { name = text2 }
            presetRecord.flags = flags or snapshotFlags()
            presetRecord.row = frame
            presetRecord.nameLabel = textLabel
            presetRecord.editIcon = imageLabel3
            presetRecord.deleteIcon = imageLabel4
            table.insert(list, presetRecord)
            local textButton4 = Instance.new("TextButton")
            textButton4.Name = "Hit_Select"
            textButton4.Parent = frame
            textButton4.AutoButtonColor = false
            textButton4.BackgroundTransparency = 1
            textButton4.Size = UDim2.new(0, 144, 1, 0)
            textButton4.Position = UDim2.new(0, 0, 0, 0)
            textButton4.ZIndex = 62
            textButton4.Text = ""

            textButton4.MouseEnter:Connect(function()
                if presetRecord ~= passed then
                    local backgroundColor = { BackgroundColor3 = color2 }
                    TweenService:Create(frame, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), backgroundColor):Play()
                end
            end)

            textButton4.MouseLeave:Connect(function()
                if presetRecord ~= passed then
                    local backgroundColor = { BackgroundColor3 = color }
                    TweenService:Create(frame, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), backgroundColor):Play()
                end
            end)

            textButton4.MouseButton1Click:Connect(function()
                applyPreset(presetRecord)
            end)

            local textButton5 = Instance.new("TextButton")
            textButton5.Name = "Hit_Edit"
            textButton5.Parent = frame
            textButton5.AutoButtonColor = false
            textButton5.BackgroundTransparency = 1
            textButton5.Size = UDim2.new(0, 24, 0, 24)
            textButton5.Position = UDim2.new(0, 146, 0, 5)
            textButton5.ZIndex = 63
            textButton5.Text = ""

            textButton5.MouseButton1Click:Connect(function()
                local textBox = Instance.new("TextBox")
                textBox.Parent = frame
                textBox.BackgroundColor3 = color3
                textBox.BorderSizePixel = 0
                textBox.Position = UDim2.new(0, 10, 0, 5)
                textBox.Size = UDim2.new(0, 132, 0, 24)
                textBox.ZIndex = 64
                textBox.FontFace = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
                textBox.Text = presetRecord.name
                textBox.TextColor3 = color5
                textBox.TextSize = 12
                textBox.TextXAlignment = Enum.TextXAlignment.Left
                textBox.ClearTextOnFocus = false
                Instance.new("UICorner", textBox).CornerRadius = UDim.new(0, 6)
                textBox:CaptureFocus()

                textBox.FocusLost:Connect(function()
                    local name = textBox.Text:gsub("^%s+", ""):gsub("%s+$", "")

                    if name ~= "" then
                        local name2 = presetRecord.name
                        presetRecord.name = name
                        textLabel.Text = name

                        if presetRecord == passed then
                            n282.Text = name
                        end

                        if name2 ~= name then
                            pcall(function()
                                delfile("Aries/Presets/" .. name2 .. ".json")
                            end)
                        end
                    end

                    textBox:Destroy()
                    refreshPresets()
                    saveAllPresets()
                end)
            end)

            local textButton6 = Instance.new("TextButton")
            textButton6.Name = "Hit_Delete"
            textButton6.Parent = frame
            textButton6.AutoButtonColor = false
            textButton6.BackgroundTransparency = 1
            textButton6.Size = UDim2.new(0, 24, 0, 24)
            textButton6.Position = UDim2.new(0, 174, 0, 5)
            textButton6.ZIndex = 63
            textButton6.Text = ""

            textButton6.MouseButton1Click:Connect(function()
                if #list <= 1 then
                    return
                end

                for k, entry in list do
                    if entry == presetRecord then
                        table.remove(list, k)
                        break
                    end
                end

                pcall(function()
                    delfile("Aries/Presets/" .. presetRecord.name .. ".json")
                end)

                if imageLabel2.Parent == frame then
                    imageLabel2.Parent = nil
                end

                frame:Destroy()

                if passed == presetRecord then
                    passed = nil

                    if list[1] then
                        applyPreset(list[1])
                    else
                        n282.Text = "Config 1"
                    end
                end

                refreshPresets()
                saveAllPresets()
            end)

            if arg then
                passed = presetRecord
            end

            refreshPresets()
            refreshPresetSelection()
            saveAllPresets()
            return presetRecord
        end

        local presetNames = Library:list_presets()

        if #presetNames > 0 then
            table.sort(presetNames, function(arg, arg2)
                return arg < arg2
            end)

            for _, entry in presetNames do
                local loadedPreset = Library:load_preset(entry)

                if loadedPreset then
                    createPresetRow(entry, deserializeFlags(loadedPreset), false)
                end
            end
        else
            for k, entry in configProfiles do
                createPresetRow(entry, nil, k == 1)
            end
        end

        flag30 = false

        fc:GetPropertyChangedSignal("Text"):Connect(function()
            refreshPresets()
        end)

        n100.MouseButton1Click:Connect(function()
            flag29 = not flag29
            TweenService:Create(ff, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { ImageColor3 = flag29 and color12 or color11 }):Play()
            refreshPresets()
        end)

        f7.MouseButton1Click:Connect(function()
            local str10 = "Config " .. tostring(#list + 1)
            local constant4 = 1

            local function presetNameExists(arg)
                for _, entry in list do
                    if entry.name == arg then
                        return true
                    end
                end

                return false
            end

            local str11 = str10

            while presetNameExists(str11) do
                constant4 += 1
                str11 = str10 .. " (" .. constant4 .. ")"
            end

            local callResult = createPresetRow(str11, snapshotFlags(), true)
            applyPreset(callResult)
        end)

        refreshPresets()
        refreshPresetSelection()
        return window
    end

    Library.Create_Tab = function(arg, arg2)
        local tab = { Hover = false, Active = false, Section = "left" }

        local options = Library:applyDefaults({
            name = "Preview Tab",
            section_name = "Fallback",
            section = "left",
            icon = "rbxassetid://83752373575368",
        }, arg2 or {})

        tab.Section = string.lower(options.section or "left")
        table.insert(window.Tabs, tab)

        if not window.CurrentTabs[tab.Section] then
            window.CurrentTabs[tab.Section] = tab
        end

        if window.CurrentTabs[tab.Section] == tab then
            if tab.Section == "right" then
                window["33"].Text = options.name
            else
                window["31"].Text = options.section_name or "Fallback"
                window["2d"].Text = options.name
                window["32"]["Text"] = options.name
            end
        end

        tab["12"] = Instance.new("Frame", window.TabContainer)
        tab["12"].BorderSizePixel = 0
        tab["12"].BackgroundColor3 = Color3.fromRGB(21, 21, 26)
        tab["12"]["Size"] = UDim2.new(1, 0, 0, 25)
        tab["12"]["Position"] = UDim2.new(0, 0, 0, 90)
        tab["12"]["Name"] = options.name
        tab["12"].BackgroundTransparency = 1
        tab["12"]:SetAttribute("fadeOriginal_BackgroundTransparency", 1)
        tab["13"] = Instance.new("ImageLabel", tab["12"])
        tab["13"].ZIndex = 2
        tab["13"]["BorderSizePixel"] = 0
        tab["13"].ScaleType = Enum.ScaleType.Fit
        tab["13"].ImageColor3 = Color3.fromRGB(143, 143, 154)
        local customIcon = Library:GetCustomIcon(options.icon)

        if customIcon then
            local n132 = tab["13"]
            n132.Image = customIcon.Url
            n132.ImageRectOffset = customIcon.ImageRectOffset or Vector2.zero
            n132.ImageRectSize = customIcon.ImageRectSize or Vector2.zero
        end

        tab["13"].Size = UDim2.new(0, 14, 0, 14)
        tab["13"].BackgroundTransparency = 1
        tab["13"].Name = "IMG_Icon"
        tab["13"].Position = UDim2.new(0, 22, 0, 6)
        tab["13"]:SetAttribute("fadeOriginal_ImageTransparency", 0)
        tab["13"]:SetAttribute("fadeOriginal_BackgroundTransparency", 1)
        tab["14"] = Instance.new("TextLabel", tab["12"])
        tab["14"]["ZIndex"] = 2
        tab["14"]["TextSize"] = 12
        tab["14"].TextXAlignment = Enum.TextXAlignment.Left
        tab["14"].FontFace = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
        tab["14"].TextColor3 = Color3.fromRGB(143, 143, 154)
        tab["14"]["BackgroundTransparency"] = 1
        tab["14"].Size = UDim2.new(1, -50, 0, 26)
        tab["14"]["Text"] = options.name
        tab["14"]["Name"] = "Label"
        tab["14"].Position = UDim2.new(0, 43, 0, 0)
        tab["14"].TextScaled = true
        local uiTextSizeConstraint = Instance.new("UITextSizeConstraint", tab["14"])
        uiTextSizeConstraint.MaxTextSize = 12
        uiTextSizeConstraint.MinTextSize = 7
        tab["14"]:SetAttribute("fadeOriginal_TextTransparency", 0)
        tab["14"]:SetAttribute("fadeOriginal_BackgroundTransparency", 1)
        tab["15"] = Instance.new("TextButton", tab["12"])
        tab["15"].AutoButtonColor = false
        tab["15"].ZIndex = 3
        tab["15"]["BackgroundTransparency"] = 1
        tab["15"]["Size"] = UDim2.new(1, 0, 1, 0)
        tab["15"]["Text"] = ""
        tab["15"].Name = "Hit"
        tab["15"]:SetAttribute("fadeOriginal_TextTransparency", 0)
        tab["15"]:SetAttribute("fadeOriginal_BackgroundTransparency", 1)

        if window.CurrentTabs[tab.Section] == tab then
            if tab.Section == "right" then
                window["33"].Text = options.name
            else
                window["31"].Text = options.section_name or "Fallback"
                window["2d"].Text = options.name
                window["32"].Text = options.name
            end
        end

        tab.ContentContainer = Instance.new("Frame", window["2"])
        tab.ContentContainer.BorderSizePixel = 0
        tab.ContentContainer.BackgroundColor3 = Color3.fromRGB(14, 15, 20)
        tab.ContentContainer.AutomaticSize = Enum.AutomaticSize.Y
        tab.ContentContainer.Size = UDim2.new(0, 264, 0, 0)
        tab.ContentContainer.Position = UDim2.new(0, tab.Section == "right" and 444 or 166, 0, 118)
        tab.ContentContainer.Name = options.name .. "_content"
        tab.ContentContainer:SetAttribute("fadeOriginal_BackgroundTransparency", 0)
        tab.ContentContainer.Visible = window.CurrentTabs[tab.Section] == tab
        Instance.new("UICorner", tab.ContentContainer).CornerRadius = UDim.new(0, 10)
        local shadow = Instance.new("UIShadow", tab.ContentContainer)
        shadow.Transparency = 0.55
        shadow:SetAttribute("fadeOriginal_Transparency", 0.55)
        local layoutOrder = Enum.SortOrder.LayoutOrder
        Instance.new("UIListLayout", tab.ContentContainer).SortOrder = layoutOrder
        tab.AllContainers = { { container = tab.ContentContainer, section = tab.Section } }

        tab.Activate = function()
            if not tab.Active then
                local items = {}

                for _, container in tab.AllContainers do
                    items[container.section] = true
                end

                for k in pairs(items) do
                    if window.CurrentTabs[k] ~= nil and window.CurrentTabs[k] ~= tab then
                        window.CurrentTabs[k]:Deactivate()
                    end
                end

                tab.Active = true

                for _, container in tab.AllContainers do
                    window.CurrentTabs[container.section] = tab
                    container.container.Visible = true
                end
            end
        end

        tab.Deactivate = function()
            if tab.Active then
                tab.Active = false
                tab.Hover = false

                for _, container in tab.AllContainers do
                    container.container.Visible = false
                end
            end
        end

        tab["15"].MouseEnter:Connect(function()
            tab.Hover = true

            if not tab.Active then
                if not window.e.Visible then
                    window["e"].Visible = true
                end

                tab["13"].ImageColor3 = Color3.fromRGB(200, 200, 200)
                tab["14"].TextColor3 = Color3.fromRGB(255, 255, 255)
            end
        end)

        tab["15"].MouseLeave:Connect(function()
            local currentTab = window.CurrentTabs[tab.Section]

            if currentTab and currentTab ~= tab then
                currentTab.Active = false
                currentTab["13"].ImageColor3 = Color3.fromRGB(143, 143, 154)
                currentTab["14"].TextColor3 = Color3.fromRGB(143, 143, 154)
            end

            tab.Hover = false

            if not tab.Active then
                tab["13"].ImageColor3 = Color3.fromRGB(143, 143, 154)
                tab["14"].TextColor3 = Color3.fromRGB(143, 143, 154)
            end
        end)

        tab["15"].MouseButton1Click:Connect(function()
            local items = {}

            for _, container in tab.AllContainers do
                items[container.section] = true
            end

            for k in pairs(items) do
                local currentTab = window.CurrentTabs[k]

                if currentTab and currentTab ~= tab then
                    currentTab.Active = false

                    if currentTab.AllContainers then
                        for _, container in currentTab.AllContainers do
                            container.container.Visible = false
                        end
                    else
                        currentTab.ContentContainer.Visible = false
                    end

                    currentTab["13"].ImageColor3 = Color3.fromRGB(143, 143, 154)
                    currentTab["14"].TextColor3 = Color3.fromRGB(143, 143, 154)
                end
            end

            tab.Active = true

            for _, container in tab.AllContainers do
                container.container.Visible = true
                window.CurrentTabs[container.section] = tab
            end

            tab["13"].ImageColor3 = Color3.fromRGB(255, 255, 255)
            tab["14"].TextColor3 = Color3.fromRGB(255, 255, 255)

            if not window.e.Visible then
                window["e"].Visible = true
            end

            if tab.Section == "right" then
                window["33"].Text = options.name
            else
                window["31"].Text = options.section_name or "Fallback"
                window["2d"].Text = options.name
                window["32"].Text = options.name
            end

            local targetScale = window._targetScale or 1

            if targetScale <= 0 then
                targetScale = 1
            end

            local y = tab["12"].AbsoluteSize.Y
            local y2 = tab["12"].AbsolutePosition.Y
            local y3 = window["5"].AbsolutePosition.Y
            local n41 = (y2 - y3 + (y - window.Indicator.AbsoluteSize.Y) / 2) / targetScale
            TweenService:Create(window.Indicator, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Position = UDim2.new(0, 0, 0, n41) }):Play()
            local e = window.e
            local n42 = (y2 - y3 + (y - e.AbsoluteSize.Y) / 2) / targetScale
            TweenService:Create(e, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Position = UDim2.new(0, 8, 0, n42) }):Play()
        end)

        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then
                return
            end

            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                if tab.Hover then
                    tab:Activate()
                end
            end
        end)

        if window.CurrentTabs[tab.Section] == tab then
            tab:Activate()
            tab["13"].ImageColor3 = Color3.fromRGB(255, 255, 255)
            tab["14"].TextColor3 = Color3.fromRGB(255, 255, 255)
        end

        tab.Create_Toggle = function(arg3, arg4)
            local activeKeybindToggle = { State = false, flag = arg4.flag, Keybind = nil, WaitingForKey = false }
            activeKeybindToggle["70"] = Instance.new("Frame", arg4.tab and arg4.tab.ContentContainer or tab.ContentContainer)
            activeKeybindToggle["70"].BackgroundColor3 = Color3.fromRGB(39, 39, 47)
            activeKeybindToggle["70"].Size = UDim2.new(1, 0, 0, 38)
            activeKeybindToggle["70"]["Name"] = "AutoTotem_enable"
            activeKeybindToggle["70"].LayoutOrder = 0
            activeKeybindToggle["70"].BackgroundTransparency = 1
            activeKeybindToggle["70"]:SetAttribute("staggerBase", UDim2.new(0, 0, 0, 0))
            activeKeybindToggle["70"]:SetAttribute("fadeOriginal_BackgroundTransparency", 1)
            activeKeybindToggle["71"] = Instance.new("TextLabel", activeKeybindToggle["70"])
            activeKeybindToggle["71"].TextSize = 12
            activeKeybindToggle["71"].TextXAlignment = Enum.TextXAlignment.Left
            activeKeybindToggle["71"]["FontFace"] = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
            activeKeybindToggle["71"].TextColor3 = Color3.fromRGB(143, 143, 154)
            activeKeybindToggle["71"].BackgroundTransparency = 1
            activeKeybindToggle["71"]["Size"] = UDim2.new(0, 200, 0, 38)
            activeKeybindToggle["71"].Text = arg4.name
            activeKeybindToggle["71"].Name = "Label"
            activeKeybindToggle["71"].Position = UDim2.new(0, 14, 0, 0)
            activeKeybindToggle["71"]:SetAttribute("fadeOriginal_TextTransparency", 0)
            activeKeybindToggle["71"]:SetAttribute("fadeOriginal_BackgroundTransparency", 1)
            activeKeybindToggle["72"] = Instance.new("Frame", activeKeybindToggle["70"])
            activeKeybindToggle["72"].BorderSizePixel = 0
            activeKeybindToggle["72"].BackgroundColor3 = Color3.fromRGB(22, 23, 31)
            activeKeybindToggle["72"].AnchorPoint = Vector2.new(1, 0.5)
            activeKeybindToggle["72"].AutomaticSize = Enum.AutomaticSize.X
            activeKeybindToggle["72"].Size = UDim2.new(0, 0, 0, 22)
            activeKeybindToggle["72"].Position = UDim2.new(1, -52, 0.5, 0)
            activeKeybindToggle["72"].Name = "KeybindBadge"
            activeKeybindToggle["72"]:SetAttribute("fadeOriginal_BackgroundTransparency", 0)
            activeKeybindToggle["72_c"] = Instance.new("UICorner", activeKeybindToggle["72"])
            activeKeybindToggle["72_c"].CornerRadius = UDim.new(0, 7)
            activeKeybindToggle["72_p"] = Instance.new("UIPadding", activeKeybindToggle["72"])
            activeKeybindToggle["72_p"].PaddingLeft = UDim.new(0, 6)
            activeKeybindToggle["72_p"].PaddingRight = UDim.new(0, 6)
            activeKeybindToggle["72_text"] = Instance.new("TextLabel", activeKeybindToggle["72"])
            activeKeybindToggle["72_text"].TextSize = 12
            activeKeybindToggle["72_text"].FontFace = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
            activeKeybindToggle["72_text"].TextColor3 = Color3.fromRGB(138, 138, 148)
            activeKeybindToggle["72_text"].BackgroundTransparency = 1
            activeKeybindToggle["72_text"].AutomaticSize = Enum.AutomaticSize.X
            activeKeybindToggle["72_text"].Size = UDim2.new(0, 0, 1, 0)
            activeKeybindToggle["72_text"].TextTruncate = Enum.TextTruncate.AtEnd
            activeKeybindToggle["72_text"]["Text"] = "Â·Â·Â·"
            activeKeybindToggle["72_text"].Name = "Text"
            activeKeybindToggle["72_max"] = Instance.new("UISizeConstraint", activeKeybindToggle["72_text"])
            activeKeybindToggle["72_max"].MaxSize = Vector2.new(48, 22)
            activeKeybindToggle["73"] = Instance.new("TextButton", activeKeybindToggle["70"])
            activeKeybindToggle["73"].AutoButtonColor = false
            activeKeybindToggle["73"]["ZIndex"] = 4
            activeKeybindToggle["73"].BackgroundTransparency = 1
            activeKeybindToggle["73"]["Size"] = UDim2.new(0, 44, 0, 26)
            activeKeybindToggle["73"]["Text"] = ""
            activeKeybindToggle["73"]["Name"] = "Keybind_Hit"
            activeKeybindToggle["73"].Position = UDim2.new(1, -52, 0.5, 0)
            activeKeybindToggle["73"].AnchorPoint = Vector2.new(1, 0.5)
            activeKeybindToggle["73"]:SetAttribute("fadeOriginal_TextTransparency", 0)
            activeKeybindToggle["73"]:SetAttribute("fadeOriginal_BackgroundTransparency", 1)
            activeKeybindToggle["73_c"] = Instance.new("UICorner", activeKeybindToggle["73"])
            activeKeybindToggle["73_c"].CornerRadius = UDim.new(0, 7)
            activeKeybindToggle["73_s"] = Instance.new("UIStroke", activeKeybindToggle["73"])
            activeKeybindToggle["73_s"].Transparency = 1
            activeKeybindToggle["73_s"]["Color"] = Color3.fromRGB(125, 109, 247)
            activeKeybindToggle["74"] = Instance.new("Frame", activeKeybindToggle["70"])
            activeKeybindToggle["74"].BorderSizePixel = 0
            activeKeybindToggle["74"]["BackgroundColor3"] = Color3.fromRGB(37, 37, 47)
            activeKeybindToggle["74"].AnchorPoint = Vector2.new(1, 0.5)
            activeKeybindToggle["74"].Size = UDim2.new(0, 30, 0, 17)
            activeKeybindToggle["74"].Position = UDim2.new(1, -12, 0.5, 0)
            activeKeybindToggle["74"].Name = "Toggle"
            activeKeybindToggle["74"]:SetAttribute("fadeOriginal_BackgroundTransparency", 0)
            activeKeybindToggle["75"] = Instance.new("UICorner", activeKeybindToggle["74"])
            activeKeybindToggle["75"].CornerRadius = UDim.new(1, 0)
            activeKeybindToggle["76"] = Instance.new("Frame", activeKeybindToggle["74"])
            activeKeybindToggle["76"].BorderSizePixel = 0
            activeKeybindToggle["76"].BackgroundColor3 = Color3.fromRGB(64, 64, 76)
            activeKeybindToggle["76"].Size = UDim2.new(0, 13, 0, 13)
            activeKeybindToggle["76"].Position = UDim2.new(0, 2, 0, 2)
            activeKeybindToggle["76"].Name = "Knob"
            activeKeybindToggle["76"]:SetAttribute("fadeOriginal_BackgroundTransparency", 0)
            activeKeybindToggle["77"] = Instance.new("UICorner", activeKeybindToggle["76"])
            activeKeybindToggle["77"].CornerRadius = UDim.new(1, 0)
            activeKeybindToggle["78"] = Instance.new("UIShadow", activeKeybindToggle["76"])
            activeKeybindToggle["78"].Transparency = 0.75
            activeKeybindToggle["78"]:SetAttribute("fadeOriginal_Transparency", 0.75)
            activeKeybindToggle["79"] = Instance.new("TextButton", activeKeybindToggle["70"])
            activeKeybindToggle["79"].AutoButtonColor = false
            activeKeybindToggle["79"].ZIndex = 2
            activeKeybindToggle["79"].BackgroundTransparency = 1
            activeKeybindToggle["79"].Size = UDim2.new(1, 0, 1, 0)
            activeKeybindToggle["79"]["Text"] = ""
            activeKeybindToggle["79"]["Name"] = "Hit"
            activeKeybindToggle["79"]:SetAttribute("fadeOriginal_TextTransparency", 0)
            activeKeybindToggle["79"]:SetAttribute("fadeOriginal_BackgroundTransparency", 1)

            if Library.Flags[activeKeybindToggle.flag] then
                TweenService:Create(activeKeybindToggle["74"], TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(125, 109, 247) }):Play()

                TweenService:Create(activeKeybindToggle["76"], TweenInfo.new(0.2), {
                    Position = UDim2.new(0, 15, 0, 2),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                }):Play()
            else
                TweenService:Create(activeKeybindToggle["74"], TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(37, 37, 47) }):Play()
                TweenService:Create(activeKeybindToggle["76"], TweenInfo.new(0.2), { Position = UDim2.new(0, 2, 0, 2), BackgroundColor3 = Color3.fromRGB(64, 64, 76) }):Play()
            end

            activeKeybindToggle.Toggle = function(arg5, arg6)
                if Library.Flags[arg5.flag] == nil then
                    Library.Flags[arg5.flag] = false
                end

                if arg6 == nil then
                    Library.Flags[arg5.flag] = not Library.Flags[arg5.flag]
                else
                    Library.Flags[arg5.flag] = arg6
                end

                if arg5._activeTweens then
                    for _, activeTween in arg5._activeTweens do
                        activeTween:Cancel()
                    end
                end

                arg5._activeTweens = {}
                local n74 = activeKeybindToggle["74"]
                local n76 = activeKeybindToggle["76"]
                if not n74 or not n76 then
                    return
                end

                if Library.Flags[arg5.flag] then
                    local tween = TweenService:Create(n74, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(125, 109, 247) })
                    local tween2 = TweenService:Create(n76, TweenInfo.new(0.2), { Position = UDim2.new(0, 15, 0, 2), BackgroundColor3 = Color3.fromRGB(255, 255, 255) })
                    tween:Play()
                    tween2:Play()
                    table.insert(arg5._activeTweens, tween)
                    table.insert(arg5._activeTweens, tween2)
                else
                    local tween = TweenService:Create(n74, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(37, 37, 47) })
                    local tween2 = TweenService:Create(n76, TweenInfo.new(0.2), { Position = UDim2.new(0, 2, 0, 2), BackgroundColor3 = Color3.fromRGB(64, 64, 76) })
                    tween:Play()
                    tween2:Play()
                    table.insert(arg5._activeTweens, tween)
                    table.insert(arg5._activeTweens, tween2)
                end

                if not window.ApplyingPreset then
                    pcall(Library.save_flags)
                end

                if arg4.callback then
                    arg4.callback(Library.Flags[arg5.flag])
                end
            end

            if Library.Flags[activeKeybindToggle.flag] == nil then
                Library.Flags[activeKeybindToggle.flag] = false
            end

            activeKeybindToggle:Toggle(Library.Flags[activeKeybindToggle.flag])

            activeKeybindToggle["79"].MouseButton1Click:Connect(function()
                activeKeybindToggle:Toggle()
            end)

            activeKeybindToggle["73"].MouseButton1Click:Connect(function()
                if window.kpw then
                    local kpw = window.kpw

                    if not kpw.Visible then
                        window.ActiveKeybindToggle = activeKeybindToggle
                        window.WaitingForKey = false
                        kpw.Size = UDim2.new(0, 0, 0, 0)
                        kpw.Visible = true
                        local absolutePosition = activeKeybindToggle["70"].AbsolutePosition
                        local absolutePosition2 = window["1"].AbsolutePosition
                        local absoluteSize = activeKeybindToggle["70"].AbsoluteSize
                        kpw.Position = UDim2.new(0, absolutePosition.X - absolutePosition2.X + absoluteSize.X - 52 - 20 - 5 - 150, 0, absolutePosition.Y - absolutePosition2.Y + (absoluteSize.Y - 76) / 2)

                        if activeKeybindToggle.Keybind then
                            window.kpw_nbf_p.Text = activeKeybindToggle.KeybindName or "New bind"
                            window["kpw_nbf_p"].TextColor3 = Color3.fromRGB(243, 243, 247)
                            TweenService:Create(window.kpw_nbf_s, TweenInfo.new(0.2), { Transparency = 0 }):Play()
                        else
                            window.kpw_nbf_p.Text = "New bind"
                            window["kpw_nbf_p"].TextColor3 = Color3.fromRGB(138, 138, 148)
                            TweenService:Create(window.kpw_nbf_s, TweenInfo.new(0.2), { Transparency = 1 }):Play()
                        end

                        if (activeKeybindToggle.KeybindMode or "toggle") == "toggle" then
                            window.kpw_ms.Position = UDim2.new(0, 8, 0, 42)
                            window["kpw_tl"].TextColor3 = Color3.fromRGB(34, 29, 72)
                            window.kpw_hl.TextColor3 = Color3.fromRGB(244, 244, 248)
                        else
                            window.kpw_ms.Position = UDim2.new(0, 77, 0, 42)
                            window["kpw_tl"].TextColor3 = Color3.fromRGB(244, 244, 248)
                            window["kpw_hl"].TextColor3 = Color3.fromRGB(34, 29, 72)
                        end

                        TweenService:Create(kpw, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Size = UDim2.new(0, 150, 0, 76) }):Play()
                    else
                        window.WaitingForKey = false
                        TweenService:Create(window.kpw_nbf_s, TweenInfo.new(0.2), { Transparency = 1 }):Play()
                        local tween = TweenService:Create(kpw, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Size = UDim2.new(0, 0, 0, 0) })

                        tween.Completed:Once(function()
                            kpw.Visible = false
                        end)

                        tween:Play()
                    end
                end
            end)

            activeKeybindToggle["73"].MouseButton2Click:Connect(function()
                if activeKeybindToggle.Keybind then
                    activeKeybindToggle.Keybind = nil
                    activeKeybindToggle.KeybindName = nil
                    Library.Keybinds[activeKeybindToggle] = nil

                    if activeKeybindToggle.flag then
                        Library.Flags[activeKeybindToggle.flag .. "_keybind"] = nil
                        Library.save_flags()
                    end

                    if activeKeybindToggle["72_text"] then
                        activeKeybindToggle["72_text"].Text = "Â·Â·Â·"
                        activeKeybindToggle["72_text"].TextColor3 = Color3.fromRGB(138, 138, 148)
                    end

                    if activeKeybindToggle["73_s"] then
                        local transparency = { Transparency = 1 }
                        TweenService:Create(activeKeybindToggle["73_s"], TweenInfo.new(0.2), transparency):Play()
                    end
                end
            end)

            if activeKeybindToggle.flag and Library.Flags[activeKeybindToggle.flag .. "_keybind"] then
                local savedKeybind = Library.Flags[activeKeybindToggle.flag .. "_keybind"]
                local keyCode

                if savedKeybind.keyType == "KeyCode" then
                    keyCode = Enum.KeyCode[savedKeybind.keyName]
                else
                    keyCode = nil

                    if savedKeybind.keyType == "UserInputType" then
                        keyCode = Enum.UserInputType[savedKeybind.keyName]
                    end
                end

                if keyCode then
                    activeKeybindToggle.Keybind = keyCode
                    activeKeybindToggle.KeybindName = savedKeybind.displayName or keyCode.Name
                    activeKeybindToggle.KeybindMode = savedKeybind.mode or "toggle"
                    Library.Keybinds[activeKeybindToggle] = { key = keyCode, mode = activeKeybindToggle.KeybindMode, flag = activeKeybindToggle.flag }

                    if activeKeybindToggle["72_text"] then
                        activeKeybindToggle["72_text"].Text = activeKeybindToggle.KeybindName
                        activeKeybindToggle["72_text"].TextColor3 = Color3.fromRGB(125, 109, 247)
                    end

                    if activeKeybindToggle["73_s"] then
                        activeKeybindToggle["73_s"].Transparency = 0
                    end
                end
            end

            if activeKeybindToggle.flag then
                table.insert(window.Widgets, function()
                    pcall(function()
                        activeKeybindToggle:Toggle(Library.Flags[activeKeybindToggle.flag] == true)
                    end)
                end)
            end

            return activeKeybindToggle
        end

        tab.Create_Slider = function(arg3, arg4)
            local options2 = Library:applyDefaults({ name = "Slider", min = 0, max = 100, default = 50, callback = nil, tab = nil, flag = nil }, arg4 or {})
            local sliderState = { MouseDown = false, Hover = false, Connection = nil, flag = options2.flag }
            sliderState["6c"] = Instance.new("Frame", options2.tab and options2.tab.ContentContainer or tab.ContentContainer)
            sliderState["6c"]["BorderSizePixel"] = 0
            sliderState["6c"].BackgroundColor3 = Color3.fromRGB(14, 15, 20)
            sliderState["6c"].AutomaticSize = Enum.AutomaticSize.Y
            sliderState["6c"]["Size"] = UDim2.new(0, 264, 0, 0)
            sliderState["6c"]["Position"] = UDim2.new(0, 0, 0, 0)
            sliderState["6c"]["Name"] = "AutoTotem_main"
            sliderState["6c"]:SetAttribute("pageToken", 22)
            sliderState["6c"]:SetAttribute("fadeOriginal_BackgroundTransparency", 0)
            sliderState["6d"] = Instance.new("UICorner", sliderState["6c"])
            sliderState["6d"].CornerRadius = UDim.new(0, 10)
            sliderState["6e"] = Instance.new("UIShadow", sliderState["6c"])
            sliderState["6e"].Transparency = 0.55
            sliderState["6e"]:SetAttribute("fadeOriginal_Transparency", 0.55)
            sliderState["6f"] = Instance.new("UIListLayout", sliderState["6c"])
            sliderState["6f"].SortOrder = Enum.SortOrder.LayoutOrder
            sliderState["7a"] = Instance.new("Frame", sliderState["6c"])
            sliderState["7a"].BorderSizePixel = 0
            sliderState["7a"]["BackgroundColor3"] = Color3.fromRGB(39, 39, 47)
            sliderState["7a"].Size = UDim2.new(1, 0, 0, 1)
            sliderState["7a"].Name = "Divider_3"
            sliderState["7a"].LayoutOrder = 3
            sliderState["7a"].BackgroundTransparency = 0
            sliderState["7a"]:SetAttribute("staggerBase", UDim2.new(0, 0, 0, 0))
            sliderState["7a"]:SetAttribute("fadeOriginal_BackgroundTransparency", 0)
            sliderState["7b"] = Instance.new("Frame", sliderState["6c"])
            sliderState["7b"].Size = UDim2.new(1, 0, 0, 38)
            sliderState["7b"].Name = "AutoTotem_health"
            sliderState["7b"].LayoutOrder = 4
            sliderState["7b"].BackgroundTransparency = 1
            sliderState["7b"]:SetAttribute("staggerBase", UDim2.new(0, 0, 0, 0))
            sliderState["7b"]:SetAttribute("fadeOriginal_BackgroundTransparency", 1)
            sliderState["7c"] = Instance.new("TextLabel", sliderState["7b"])
            sliderState["7c"].TextSize = 12
            sliderState["7c"].TextXAlignment = Enum.TextXAlignment.Left
            sliderState["7c"].FontFace = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
            sliderState["7c"]["TextColor3"] = Color3.fromRGB(143, 143, 154)
            sliderState["7c"].BackgroundTransparency = 1
            sliderState["7c"].Size = UDim2.new(0, 200, 0, 38)
            sliderState["7c"].Text = options2.name
            sliderState["7c"]["Name"] = "Label"
            sliderState["7c"].Position = UDim2.new(0, 14, 0, 0)
            sliderState["7c"]:SetAttribute("fadeOriginal_TextTransparency", 0)
            sliderState["7c"]:SetAttribute("fadeOriginal_BackgroundTransparency", 1)
            sliderState["7d"] = Instance.new("TextLabel", sliderState["7b"])
            sliderState["7d"].TextSize = 12
            sliderState["7d"].TextXAlignment = Enum.TextXAlignment.Right
            sliderState["7d"]["FontFace"] = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
            sliderState["7d"]["TextColor3"] = Color3.fromRGB(243, 243, 247)
            sliderState["7d"]["BackgroundTransparency"] = 1
            sliderState["7d"].AnchorPoint = Vector2.new(1, 0.5)
            sliderState["7d"]["Size"] = UDim2.new(0, 49, 0, 38)
            sliderState["7d"].Text = tostring((options2.default or 100) .. "%")
            sliderState["7d"].Name = "Value"
            sliderState["7d"].Position = UDim2.new(1, -95, 0.5, 0)
            sliderState["7d"]:SetAttribute("fadeOriginal_TextTransparency", 0)
            sliderState["7d"]:SetAttribute("fadeOriginal_BackgroundTransparency", 1)
            sliderState["7e"] = Instance.new("Frame", sliderState["7b"])
            sliderState["7e"]["BorderSizePixel"] = 0
            sliderState["7e"].BackgroundColor3 = Color3.fromRGB(53, 53, 63)
            sliderState["7e"].AnchorPoint = Vector2.new(1, 0.5)
            sliderState["7e"].Size = UDim2.new(0, 75, 0, 4)
            sliderState["7e"].Position = UDim2.new(1, -12, 0.5, 0)
            sliderState["7e"]["Name"] = "Slider"
            sliderState["7e"]:SetAttribute("fadeOriginal_BackgroundTransparency", 0)
            sliderState["7f"] = Instance.new("UICorner", sliderState["7e"])
            sliderState["7f"].CornerRadius = UDim.new(0, 2)
            sliderState["80"] = Instance.new("Frame", sliderState["7e"])
            sliderState["80"].BorderSizePixel = 0
            sliderState["80"].BackgroundColor3 = Color3.fromRGB(125, 109, 247)
            local n41 = ((options2.default or 100) - (options2.min or 0)) / ((options2.max or 100) - (options2.min or 0))
            sliderState["80"].Size = UDim2.fromScale(n41, 1)
            sliderState["80"].Name = "Fill"
            sliderState["80"]:SetAttribute("fadeOriginal_BackgroundTransparency", 0)
            sliderState["81"] = Instance.new("UICorner", sliderState["80"])
            sliderState["81"].CornerRadius = UDim.new(0, 2)
            sliderState["82"] = Instance.new("Frame", sliderState["7e"])
            sliderState["82"].BorderSizePixel = 0
            sliderState["82"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            sliderState["82"].AnchorPoint = Vector2.new(0.5, 0.5)
            sliderState["82"]["Size"] = UDim2.new(0, 10, 0, 10)
            sliderState["82"].Position = UDim2.new(n41, 0, 0.5, 0)
            sliderState["82"]["Name"] = "Knob"
            sliderState["82"]:SetAttribute("fadeOriginal_BackgroundTransparency", 0)
            sliderState["83"] = Instance.new("UICorner", sliderState["82"])
            sliderState["83"].CornerRadius = UDim.new(1, 0)
            sliderState["84"] = Instance.new("UIStroke", sliderState["82"])
            sliderState["84"].Thickness = 2
            sliderState["84"].Color = Color3.fromRGB(31, 31, 39)
            sliderState["84"]:SetAttribute("fadeOriginal_Transparency", 0)
            sliderState["85"] = Instance.new("TextButton", sliderState["7b"])
            sliderState["85"].AutoButtonColor = false
            sliderState["85"].ZIndex = 3
            sliderState["85"].BackgroundTransparency = 1
            sliderState["85"].Size = UDim2.new(0, 91, 0, 26)
            sliderState["85"]["Text"] = ""
            sliderState["85"].Name = "Hit"
            sliderState["85"].Position = UDim2.new(1, -95, 0.5, -13)
            sliderState["85"]:SetAttribute("fadeOriginal_TextTransparency", 0)
            sliderState["85"]:SetAttribute("fadeOriginal_BackgroundTransparency", 1)
            sliderState["86"] = Instance.new("Frame", sliderState["6c"])
            sliderState["86"].BorderSizePixel = 0
            sliderState["86"].BackgroundColor3 = Color3.fromRGB(39, 39, 47)
            sliderState["86"]["Size"] = UDim2.new(1, 0, 0, 1)
            sliderState["86"].Name = "Divider_5"
            sliderState["86"].LayoutOrder = 5
            sliderState["86"].BackgroundTransparency = 0
            sliderState["86"]:SetAttribute("staggerBase", UDim2.new(0, 0, 0, 0))
            sliderState["86"]:SetAttribute("fadeOriginal_BackgroundTransparency", 0)

            sliderState.SetValue = function(arg5, arg6, arg7)
                if arg6 == nil then
                    local n42 = math.clamp(((arg7 or UserInputService:GetMouseLocation()).X - sliderState["7e"].AbsolutePosition.X) / sliderState["7e"].AbsoluteSize.X, 0, 1)
                    local rounded = math.round((options2.max - options2.min) * n42 + options2.min)
                    sliderState["7d"].Text = tostring(rounded) .. "%"
                    sliderState["82"].Position = UDim2.new(n42, 0, 0.5, 0)
                    sliderState["80"].Size = UDim2.fromScale(n42, 1)
                else
                    sliderState["7d"].Text = tostring(arg6) .. "%"
                    local n42 = (arg6 - options2.min) / (options2.max - options2.min)
                    sliderState["80"].Size = UDim2.fromScale(n42, 1)
                    sliderState["82"].Position = UDim2.new(n42, 0, 0.5, 0)
                end

                if sliderState.flag then
                    Library.Flags[sliderState.flag] = sliderState:GetValue()

                    if not window.ApplyingPreset then
                        Library.save_flags()
                    end
                end

                if options2.callback then
                    options2.callback(sliderState:GetValue())
                end
            end

            sliderState.GetValue = function()
                return (tonumber(sliderState["7d"].Text:match("%-?%d+")))
            end

            sliderState["85"].MouseEnter:Connect(function()
                sliderState.Hover = true
            end)

            sliderState["85"].MouseLeave:Connect(function()
                sliderState.Hover = false
            end)

            local flag25 = false

            sliderState["85"].MouseButton1Down:Connect(function()
                flag25 = true
                sliderState:SetValue(nil, UserInputService:GetMouseLocation())
            end)

            UserInputService.InputChanged:Connect(function(input)
                if flag25 and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    sliderState:SetValue(nil, input.Position)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    flag25 = false
                end
            end)

            if sliderState.flag then
                if Library.Flags[sliderState.flag] ~= nil then
                    sliderState:SetValue(Library.Flags[sliderState.flag])
                else
                    Library.Flags[sliderState.flag] = options2.default or 39
                end
            end

            if sliderState.flag then
                table.insert(window.Widgets, function()
                    if Library.Flags[sliderState.flag] ~= nil then
                        sliderState:SetValue(Library.Flags[sliderState.flag])
                    end
                end)
            end

            return sliderState
        end

        tab.Create_Dropdown = function(arg3, arg4)
            local options2 = Library:applyDefaults({
                name = "Dropdown",
                options = { "Option 1", "Option 2", "Option 3" },
                default = nil,
                callback = nil,
                flag = nil,
                tab = nil,
            }, arg4 or {})

            local currentDropdown = {
                Selected = options2.flag and Library.Flags[options2.flag] or options2.default or options2.options[1],
                flag = options2.flag,
                Open = false,
            }

            currentDropdown.d70 = Instance.new("Frame", options2.tab and options2.tab.ContentContainer or tab.ContentContainer)
            currentDropdown.d70["BackgroundColor3"] = Color3.fromRGB(39, 39, 47)
            currentDropdown.d70.Size = UDim2.new(1, 0, 0, 38)
            currentDropdown.d70.Name = options2.name .. "_dropdown"
            currentDropdown.d70.LayoutOrder = 0
            currentDropdown.d70.BackgroundTransparency = 1
            currentDropdown.d70:SetAttribute("staggerBase", UDim2.new(0, 0, 0, 0))
            currentDropdown.d70:SetAttribute("fadeOriginal_BackgroundTransparency", 1)
            currentDropdown.d71 = Instance.new("TextLabel", currentDropdown.d70)
            currentDropdown.d71.TextSize = 12
            currentDropdown.d71.TextXAlignment = Enum.TextXAlignment.Left
            currentDropdown.d71["FontFace"] = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
            currentDropdown.d71["TextColor3"] = Color3.fromRGB(143, 143, 154)
            currentDropdown.d71.BackgroundTransparency = 1
            currentDropdown.d71["Size"] = UDim2.new(0, 120, 0, 38)
            currentDropdown.d71["Text"] = options2.name
            currentDropdown.d71.Name = "Label"
            currentDropdown.d71.Position = UDim2.new(0, 14, 0, 0)
            currentDropdown.d71:SetAttribute("fadeOriginal_TextTransparency", 0)
            currentDropdown.d71:SetAttribute("fadeOriginal_BackgroundTransparency", 1)
            currentDropdown.d72 = Instance.new("Frame", currentDropdown.d70)
            currentDropdown.d72["BorderSizePixel"] = 0
            currentDropdown.d72["BackgroundColor3"] = Color3.fromRGB(39, 39, 47)
            currentDropdown.d72.AnchorPoint = Vector2.new(1, 0.5)
            currentDropdown.d72.Size = UDim2.new(0, 80, 0, 22)
            currentDropdown.d72.Position = UDim2.new(1, -12, 0.5, 0)
            currentDropdown.d72["Name"] = "DropdownButton"
            currentDropdown.d72:SetAttribute("fadeOriginal_BackgroundTransparency", 0)
            currentDropdown.d72_c = Instance.new("UICorner", currentDropdown.d72)
            currentDropdown.d72_c.CornerRadius = UDim.new(0, 6)
            currentDropdown.d72_sh = Instance.new("UIShadow", currentDropdown.d72)
            currentDropdown.d72_sh.Transparency = 0.55
            currentDropdown.d72_sh:SetAttribute("fadeOriginal_Transparency", 0.55)
            currentDropdown.d73 = Instance.new("TextLabel", currentDropdown.d72)
            currentDropdown.d73.TextSize = 11
            currentDropdown.d73["TextXAlignment"] = Enum.TextXAlignment.Left
            currentDropdown.d73.FontFace = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
            currentDropdown.d73.TextColor3 = Color3.fromRGB(243, 243, 247)
            currentDropdown.d73.BackgroundTransparency = 1
            currentDropdown.d73.Size = UDim2.new(1, -26, 1, 0)
            currentDropdown.d73.Text = currentDropdown.Selected
            currentDropdown.d73.Name = "Value"
            currentDropdown.d73.Position = UDim2.new(0, 8, 0, 0)
            currentDropdown.d73.TextTruncate = Enum.TextTruncate.AtEnd
            currentDropdown.d73:SetAttribute("fadeOriginal_TextTransparency", 0)
            currentDropdown.d73:SetAttribute("fadeOriginal_BackgroundTransparency", 1)
            currentDropdown.d74 = Instance.new("ImageLabel", currentDropdown.d72)
            currentDropdown.d74.BorderSizePixel = 0
            currentDropdown.d74["ScaleType"] = Enum.ScaleType.Fit
            currentDropdown.d74.Image = "rbxassetid://10709790948"
            currentDropdown.d74.ImageColor3 = Color3.fromRGB(143, 143, 154)
            currentDropdown.d74.Size = UDim2.new(0, 10, 0, 10)
            currentDropdown.d74.BackgroundTransparency = 1
            currentDropdown.d74.Name = "IMG_Caret"
            currentDropdown.d74.Position = UDim2.new(1, -15, 0, 6)
            currentDropdown.d74:SetAttribute("fadeOriginal_ImageTransparency", 0)
            currentDropdown.d74:SetAttribute("fadeOriginal_BackgroundTransparency", 1)
            currentDropdown.d72_s = Instance.new("UIStroke", currentDropdown.d72)
            currentDropdown.d72_s.Transparency = 1
            currentDropdown.d72_s.Color = Color3.fromRGB(70, 70, 86)
            currentDropdown.d72_s:SetAttribute("fadeOriginal_Transparency", 1)
            currentDropdown.d75 = Instance.new("TextButton", currentDropdown.d72)
            currentDropdown.d75.AutoButtonColor = false
            currentDropdown.d75.ZIndex = 3
            currentDropdown.d75.BackgroundTransparency = 1
            currentDropdown.d75["Size"] = UDim2.new(1, 0, 1, 0)
            currentDropdown.d75.Text = ""
            currentDropdown.d75.Name = "Hit"
            currentDropdown.d75:SetAttribute("fadeOriginal_TextTransparency", 0)
            currentDropdown.d75:SetAttribute("fadeOriginal_BackgroundTransparency", 1)

            currentDropdown.d73:GetPropertyChangedSignal("TextBounds"):Connect(function()
                local n41 = math.clamp(math.ceil(currentDropdown.d73.TextBounds.X) + 34, 58, 150)
                TweenService:Create(currentDropdown.d72, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Size = UDim2.new(0, n41, 0, 22) }):Play()
            end)

            if not window.DropdownPopup then
                window.DropdownPopup = Instance.new("Frame", window["1"])
                window.DropdownPopup.BorderSizePixel = 0
                window.DropdownPopup.BackgroundColor3 = Color3.fromRGB(14, 15, 20)
                window.DropdownPopup.ClipsDescendants = true
                window.DropdownPopup.ZIndex = 52
                window.DropdownPopup.Size = UDim2.new(0, 139, 0, 0)
                window.DropdownPopup.Position = UDim2.new(0, 500, 0, 200)
                window.DropdownPopup.Name = "dropdown_popup"
                window.DropdownPopup.Visible = false
                window.DropdownPopup:SetAttribute("fadeIsolated", true)
                Instance.new("UICorner", window.DropdownPopup).CornerRadius = UDim.new(0, 10)
                local uiStroke = Instance.new("UIStroke", window.DropdownPopup)
                uiStroke.Transparency = 0.4
                uiStroke.Color = Color3.fromRGB(47, 47, 58)
                uiStroke:SetAttribute("fadeOriginal_Transparency", 0.4)

                window.DropdownPopupData = {
                    window = window.DropdownPopup,
                    currentAnchor = nil,
                    currentCallback = nil,
                    currentDropdown = nil,
                }

                window.closeDropdownPopup = function()
                    local dropdownPopupData = window.DropdownPopupData

                    if dropdownPopupData.currentDropdown then
                        dropdownPopupData.currentDropdown.Open = false
                        TweenService:Create(dropdownPopupData.currentDropdown.d74, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Rotation = 0 }):Play()
                    end

                    dropdownPopupData.currentAnchor = nil
                    dropdownPopupData.currentCallback = nil
                    dropdownPopupData.currentDropdown = nil
                    local dropdownPopup = window.DropdownPopup
                    local tween = TweenService:Create(dropdownPopup, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Size = UDim2.new(0, dropdownPopup.AbsoluteSize.X, 0, 0) })

                    tween.Completed:Once(function()
                        dropdownPopup.Visible = false
                    end)

                    tween:Play()
                end

                UserInputService.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        if window.DropdownPopup.Visible and window.DropdownPopupData.currentAnchor then
                            local position = input.Position
                            local absolutePosition = window.DropdownPopup.AbsolutePosition
                            local absoluteSize = window.DropdownPopup.AbsoluteSize
                            local absolutePosition2 = window.DropdownPopupData.currentAnchor.AbsolutePosition
                            local absoluteSize2 = window.DropdownPopupData.currentAnchor.AbsoluteSize

                            if not (position.X >= absolutePosition.X and position.X <= absolutePosition.X + absoluteSize.X and position.Y >= absolutePosition.Y and position.Y <= absolutePosition.Y + absoluteSize.Y) and not (position.X >= absolutePosition2.X - 4 and position.X <= absolutePosition2.X + absoluteSize2.X + 4 and position.Y >= absolutePosition2.Y - 4 and position.Y <= absolutePosition2.Y + absoluteSize2.Y + 4) then
                                window.closeDropdownPopup()
                            end
                        end
                    end
                end)
            end

            local function toggleDropdownPopup()
                local dropdownPopup = window.DropdownPopup
                local d72 = currentDropdown.d72
                if dropdownPopup.Visible and window.DropdownPopupData.currentAnchor == d72 then
                    window.closeDropdownPopup()
                    return
                end

                if dropdownPopup.Visible then
                    dropdownPopup.Visible = false

                    if window.DropdownPopupData.currentDropdown then
                        window.DropdownPopupData.currentDropdown.Open = false
                        window.DropdownPopupData.currentDropdown.d74.Rotation = 0
                    end
                end

                currentDropdown.Open = true
                window.DropdownPopupData.currentAnchor = d72

                window.DropdownPopupData.currentCallback = function(selected)
                    currentDropdown.Selected = selected
                    currentDropdown.d73.Text = selected

                    if currentDropdown.flag then
                        Library.Flags[currentDropdown.flag] = selected
                        Library.save_flags()
                    end

                    if options2.callback then
                        options2.callback(selected)
                    end
                end

                window.DropdownPopupData.currentDropdown = currentDropdown
                TweenService:Create(currentDropdown.d74, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Rotation = 180 }):Play()

                for _, child in dropdownPopup:GetChildren() do
                    if child:IsA("Frame") or child:IsA("TextButton") then
                        child:Destroy()
                    end
                end

                local n41 = 139

                for _, option in options2.options do
                    n41 = math.max(n41, #option * 7 + 54)
                end

                local n42 = math.min(n41, 240)
                local list = {}

                for k, option in options2.options do
                    local flag25 = option == currentDropdown.Selected
                    local frame = Instance.new("Frame", dropdownPopup)
                    frame.Name = "Option_" .. option
                    frame.BackgroundColor3 = Color3.fromRGB(39, 39, 47)
                    frame.BackgroundTransparency = flag25 and 0 or 1
                    frame.BorderSizePixel = 0
                    frame.Position = UDim2.new(0, 5, 0, 6 + (k - 1) * 26)
                    frame.Size = UDim2.new(0, n42 - 10, 0, 26)
                    frame.ZIndex = 53
                    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

                    if flag25 then
                        local imageLabel = Instance.new("ImageLabel", frame)
                        imageLabel.Name = "IMG_Check"
                        imageLabel.AnchorPoint = Vector2.new(0, 0.5)
                        imageLabel.BackgroundTransparency = 1
                        imageLabel.Position = UDim2.new(0, 9, 0.5, 0)
                        imageLabel.Size = UDim2.new(0, 12, 0, 12)
                        imageLabel.ZIndex = 53
                        imageLabel.Image = "rbxassetid://86817768619372"
                        imageLabel.ImageColor3 = Color3.fromRGB(246, 246, 250)
                        imageLabel.ScaleType = Enum.ScaleType.Fit
                        imageLabel.ImageTransparency = 1
                    end

                    local textLabel = Instance.new("TextLabel", frame)
                    textLabel.Name = "Label"
                    textLabel.BackgroundTransparency = 1
                    textLabel.Position = UDim2.new(0, 30, 0, 0)
                    textLabel.Size = UDim2.new(0, n42 - 46, 0, 26)
                    textLabel.ZIndex = 53
                    textLabel.FontFace = Font.new("rbxasset://fonts/families/Montserrat.json", flag25 and Enum.FontWeight.SemiBold or Enum.FontWeight.Medium, Enum.FontStyle.Normal)
                    textLabel.Text = option
                    textLabel.TextColor3 = flag25 and Color3.fromRGB(246, 246, 250) or Color3.fromRGB(132, 132, 143)
                    textLabel.TextSize = 12
                    textLabel.TextXAlignment = Enum.TextXAlignment.Left
                    textLabel.TextTransparency = 1
                    local textButton = Instance.new("TextButton", frame)
                    textButton.AutoButtonColor = false
                    textButton.ZIndex = 54
                    textButton.BackgroundTransparency = 1
                    textButton.Size = UDim2.new(1, 0, 1, 0)
                    textButton.Text = ""

                    if not flag25 then
                        textButton.MouseEnter:Connect(function()
                            TweenService:Create(frame, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { BackgroundTransparency = 0 }):Play()
                        end)

                        textButton.MouseLeave:Connect(function()
                            TweenService:Create(frame, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { BackgroundTransparency = 1 }):Play()
                        end)
                    end

                    textButton.MouseButton1Click:Connect(function()
                        local currentCallback = window.DropdownPopupData.currentCallback
                        window.closeDropdownPopup()

                        if currentCallback then
                            currentCallback(option)
                        end
                    end)

                    table.insert(list, { row = frame, label = textLabel, selected = flag25 })
                end

                local absolutePosition = d72.AbsolutePosition
                local absolutePosition2 = window["1"].AbsolutePosition
                local absoluteSize = d72.AbsoluteSize
                local n43 = 12 + #options2.options * 26
                dropdownPopup.Position = UDim2.new(0, absolutePosition.X - absolutePosition2.X + absoluteSize.X - n42, 0, absolutePosition.Y - absolutePosition2.Y + absoluteSize.Y + 4)
                dropdownPopup.Size = UDim2.new(0, n42, 0, math.floor(n43 * 0.72))
                dropdownPopup.Visible = true
                TweenService:Create(dropdownPopup, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Size = UDim2.new(0, n42, 0, n43) }):Play()

                for k, entry in list do
                    task.delay(k * 0.025, function()
                        local textTransparency = { TextTransparency = 0 }
                        TweenService:Create(entry.label, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), textTransparency):Play()

                        if entry.selected then
                            local imgCheck = entry.row:FindFirstChild("IMG_Check")

                            if imgCheck then
                                TweenService:Create(imgCheck, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { ImageTransparency = 0 }):Play()
                            end
                        end
                    end)
                end
            end

            currentDropdown.d75.MouseEnter:Connect(function()
                TweenService:Create(currentDropdown.d72_s, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Transparency = 0.35 }):Play()
            end)

            currentDropdown.d75.MouseLeave:Connect(function()
                TweenService:Create(currentDropdown.d72_s, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Transparency = 1 }):Play()
            end)

            currentDropdown.d75.MouseButton1Click:Connect(function()
                toggleDropdownPopup()
            end)

            if currentDropdown.flag then
                Library.Flags[currentDropdown.flag] = currentDropdown.Selected
            end

            currentDropdown.SetValue = function(arg5, selected)
                currentDropdown.Selected = selected
                currentDropdown.d73.Text = selected

                if currentDropdown.flag then
                    Library.Flags[currentDropdown.flag] = selected
                end

                if options2.callback then
                    options2.callback(selected)
                end
            end

            currentDropdown.GetValue = function()
                return currentDropdown.Selected
            end

            if currentDropdown.flag then
                table.insert(window.Widgets, function()
                    if Library.Flags[currentDropdown.flag] ~= nil then
                        currentDropdown:SetValue(Library.Flags[currentDropdown.flag])
                    end
                end)
            end

            return currentDropdown
        end

        tab.Create_ColorPicker = function(arg3, arg4)
            local options2 = Library:applyDefaults({
                name = "ColorPicker",
                default = Color3.fromRGB(255, 255, 255),
                callback = nil,
                flag = nil,
                tab = nil,
            }, arg4 or {})

            local function getInitialColor()
                if options2.flag and Library.Flags[options2.flag] then
                    local savedFlag = Library.Flags[options2.flag]
                    if typeof(savedFlag) == "table" then
                        return Color3.new(savedFlag.R or 1, savedFlag.G or 1, savedFlag.B or 1)
                    end

                    if typeof(savedFlag) == "Color3" then
                        return savedFlag
                    end
                end

                return options2.default or Color3.fromRGB(255, 255, 255)
            end

            local colorState = { Color = getInitialColor(), flag = options2.flag }
            colorState.cp0 = Instance.new("Frame", options2.tab and options2.tab.ContentContainer or tab.ContentContainer)
            colorState.cp0["BackgroundColor3"] = Color3.fromRGB(39, 39, 47)
            colorState.cp0.Size = UDim2.new(1, 0, 0, 38)
            colorState.cp0.Name = options2.name .. "_colorpicker"
            colorState.cp0.LayoutOrder = 0
            colorState.cp0.BackgroundTransparency = 1
            colorState.cp0:SetAttribute("staggerBase", UDim2.new(0, 0, 0, 0))
            colorState.cp0:SetAttribute("fadeOriginal_BackgroundTransparency", 1)
            colorState.cp1 = Instance.new("TextLabel", colorState.cp0)
            colorState.cp1["TextSize"] = 12
            colorState.cp1.TextXAlignment = Enum.TextXAlignment.Left
            colorState.cp1.FontFace = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
            colorState.cp1.TextColor3 = Color3.fromRGB(143, 143, 154)
            colorState.cp1["BackgroundTransparency"] = 1
            colorState.cp1.Size = UDim2.new(0, 120, 0, 38)
            colorState.cp1.Text = options2.name
            colorState.cp1["Name"] = "Label"
            colorState.cp1.Position = UDim2.new(0, 14, 0, 0)
            colorState.cp1:SetAttribute("fadeOriginal_TextTransparency", 0)
            colorState.cp1:SetAttribute("fadeOriginal_BackgroundTransparency", 1)
            colorState.cp2 = Instance.new("Frame", colorState.cp0)
            colorState.cp2["BorderSizePixel"] = 0
            colorState.cp2.BackgroundColor3 = colorState.Color
            colorState.cp2.AnchorPoint = Vector2.new(1, 0.5)
            colorState.cp2.Size = UDim2.new(0, 16, 0, 16)
            colorState.cp2.Position = UDim2.new(1, -12, 0.5, 0)
            colorState.cp2.Name = "ColorSwatch"
            colorState.cp2:SetAttribute("fadeOriginal_BackgroundTransparency", 0)
            Instance.new("UICorner", colorState.cp2).CornerRadius = UDim.new(0, 4)
            colorState.cp3 = Instance.new("TextButton", colorState.cp0)
            colorState.cp3.AutoButtonColor = false
            colorState.cp3.ZIndex = 3
            colorState.cp3["BackgroundTransparency"] = 1
            colorState.cp3.Size = UDim2.new(0, 24, 0, 24)
            colorState.cp3.Position = UDim2.new(1, -32, 0.5, -12)
            colorState.cp3["Text"] = ""
            colorState.cp3.Name = "Hit"
            colorState.cp3:SetAttribute("fadeOriginal_TextTransparency", 0)
            colorState.cp3:SetAttribute("fadeOriginal_BackgroundTransparency", 1)
            colorState.cp2_s = Instance.new("UIStroke", colorState.cp2)
            colorState.cp2_s.Transparency = 1
            colorState.cp2_s.Color = Color3.fromRGB(70, 70, 86)

            colorState.cp3.MouseEnter:Connect(function()
                TweenService:Create(colorState.cp2_s, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Transparency = 0.35 }):Play()
            end)

            colorState.cp3.MouseLeave:Connect(function()
                local transparency = { Transparency = 1 }
                TweenService:Create(colorState.cp2_s, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), transparency):Play()
            end)

            colorState.cp3.MouseButton1Click:Connect(function()
                window.openColorPicker(colorState.cp2, function(color)
                    colorState.Color = color

                    if options2.callback then
                        options2.callback(color)
                    end
                end, colorState.flag)
            end)

            if colorState.flag then
                Library.Flags[colorState.flag] = colorState.Color
            end

            colorState.SetColor = function(arg5, color)
                colorState.Color = color
                colorState.cp2.BackgroundColor3 = color

                if colorState.flag then
                    Library.Flags[colorState.flag] = color
                end

                if options2.callback then
                    options2.callback(color)
                end
            end

            colorState.GetColor = function()
                return colorState.Color
            end

            if colorState.flag then
                table.insert(window.Widgets, function()
                    local color = Library.Flags[colorState.flag]

                    if color then
                        if typeof(color) == "table" then
                            color = Color3.new(color.R or 1, color.G or 1, color.B or 1)
                        end

                        colorState:SetColor(color)
                    end
                end)
            end

            return colorState
        end

        tab.Create_TextBox = function(arg3, arg4)
            local options2 = Library:applyDefaults({
                name = "TextBox",
                default = "...",
                placeholder = "Enter text...",
                callback = nil,
                flag = nil,
                tab = nil,
                clearOnFocus = false,
                numeric = false,
            }, arg4 or {})

            local textState = { Value = options2.flag and Library.Flags[options2.flag] or options2.default or "", flag = options2.flag }
            textState.t70 = Instance.new("Frame", options2.tab and options2.tab.ContentContainer or tab.ContentContainer)
            textState.t70["BackgroundColor3"] = Color3.fromRGB(39, 39, 47)
            textState.t70["Size"] = UDim2.new(1, 0, -0.088, 57)
            textState.t70["Name"] = options2.name .. "_textbox"
            textState.t70.LayoutOrder = 0
            textState.t70.BackgroundTransparency = 1
            textState.t70:SetAttribute("staggerBase", UDim2.new(0, 0, 0, 0))
            textState.t70:SetAttribute("fadeOriginal_BackgroundTransparency", 1)
            textState.t70_div = Instance.new("Frame", textState.t70)
            textState.t70_div.BorderSizePixel = 0
            textState.t70_div.BackgroundColor3 = Color3.fromRGB(39, 39, 47)
            textState.t70_div.Size = UDim2.new(1, 0, 0, 1)
            textState.t70_div.Position = UDim2.new(0, 0, 0, 0)
            textState.t70_div.Name = "Divider"
            textState.t70_div.BackgroundTransparency = 0
            textState.t70_div:SetAttribute("staggerBase", UDim2.new(0, 0, 0, 0))
            textState.t70_div:SetAttribute("fadeOriginal_BackgroundTransparency", 0)
            textState.t71 = Instance.new("TextLabel", textState.t70)
            textState.t71.TextSize = 12
            textState.t71.TextXAlignment = Enum.TextXAlignment.Center
            textState.t71["FontFace"] = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
            textState.t71["TextColor3"] = Color3.fromRGB(143, 143, 154)
            textState.t71.BackgroundTransparency = 1
            textState.t71.Size = UDim2.new(1, 0, 0, 14)
            textState.t71.Text = ""
            textState.t71.Name = "Label"
            textState.t71.Position = UDim2.new(0, 0, 0, 6)
            textState.t71:SetAttribute("fadeOriginal_TextTransparency", 0)
            textState.t71:SetAttribute("fadeOriginal_BackgroundTransparency", 1)
            textState.t72 = Instance.new("Frame", textState.t70)
            textState.t72["BorderSizePixel"] = 0
            textState.t72.BackgroundColor3 = Color3.fromRGB(39, 39, 47)
            textState.t72.Size = UDim2.new(1, -28, 0, 24)
            textState.t72.Position = UDim2.new(0, 14, 0, 12)
            textState.t72.Name = "InputFrame"
            textState.t72:SetAttribute("fadeOriginal_BackgroundTransparency", 0)
            textState.t72_c = Instance.new("UICorner", textState.t72)
            textState.t72_c.CornerRadius = UDim.new(0, 6)
            textState.t72_sh = Instance.new("UIShadow", textState.t72)
            textState.t72_sh.Transparency = 0.55
            textState.t72_sh:SetAttribute("fadeOriginal_Transparency", 0.55)
            textState.t72_s = Instance.new("UIStroke", textState.t72)
            textState.t72_s.Transparency = 1
            textState.t72_s.Color = Color3.fromRGB(70, 70, 86)
            textState.t72_s:SetAttribute("fadeOriginal_Transparency", 1)
            textState.t73 = Instance.new("TextBox", textState.t72)
            textState.t73.TextSize = 11
            textState.t73.TextXAlignment = Enum.TextXAlignment.Center
            textState.t73.FontFace = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
            textState.t73.TextColor3 = Color3.fromRGB(243, 243, 247)
            textState.t73["BackgroundTransparency"] = 1
            textState.t73.Size = UDim2.new(1, -16, 1, 0)
            textState.t73.Text = textState.Value
            textState.t73.PlaceholderText = options2.placeholder
            textState.t73.PlaceholderColor3 = Color3.fromRGB(132, 132, 143)
            textState.t73["Name"] = "Input"
            textState.t73.Position = UDim2.new(0, 8, 0, 0)
            textState.t73.TextTruncate = Enum.TextTruncate.AtEnd
            textState.t73.ClearTextOnFocus = options2.clearOnFocus
            textState.t73.ZIndex = 2

            if options2.numeric then
                textState.t73.Numeric = true
            end

            textState.t73:SetAttribute("fadeOriginal_TextTransparency", 0)
            textState.t73:SetAttribute("fadeOriginal_BackgroundTransparency", 1)
            local flag25 = false

            textState.t73.Focused:Connect(function()
                flag25 = true
                local transparency = { Transparency = 0 }
                TweenService:Create(textState.t72_s, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), transparency):Play()
            end)

            textState.t73.FocusLost:Connect(function()
                flag25 = false
                TweenService:Create(textState.t72_s, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Transparency = 1 }):Play()
                textState.Value = textState.t73.Text

                if textState.flag then
                    Library.Flags[textState.flag] = textState.Value
                    Library.save_flags()

                end

                if options2.callback then
                    options2.callback(textState.Value)
                end
            end)

            textState.t73.MouseEnter:Connect(function()
                TweenService:Create(textState.t72_s, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Transparency = 0.35 }):Play()
            end)

            textState.t73.MouseLeave:Connect(function()
                if not flag25 then
                    TweenService:Create(textState.t72_s, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Transparency = 1 }):Play()
                end
            end)

            if textState.flag and Library.Flags[textState.flag] == nil then
                Library.Flags[textState.flag] = textState.Value
            end

            if textState.flag and Library.Flags[textState.flag] and Library.Flags[textState.flag] ~= "" and options2.callback then
                task.defer(function()
                    options2.callback(Library.Flags[textState.flag])
                end)
            end

            textState.SetValue = function(arg5, value)
                textState.Value = value
                textState.t73.Text = value

                if textState.flag then
                    Library.Flags[textState.flag] = value
                end

                if options2.callback then
                    options2.callback(value)
                end
            end

            textState.GetValue = function()
                return textState.Value
            end

            if textState.flag then
                table.insert(window.Widgets, function()
                    if Library.Flags[textState.flag] ~= nil then
                        textState:SetValue(Library.Flags[textState.flag])
                    end
                end)
            end

            return textState
        end

        tab.Create_Section = function(arg3, arg4, arg5)
            local passed

            if arg4 == "left" or arg4 == "right" then
                passed = nil
            else
                local section = arg5 or tab.Section

                if section then
                    passed = arg4
                    arg4 = section
                else
                    passed = arg4
                    arg4 = "left"
                end
            end

            local section = { section = arg4, Tab = tab, title = passed }
            local str10 = "_wrapper_" .. arg4
            local columnX = arg4 == "right" and 444 or 166
            local columnW = 264

            local function fitHeight(frame, layout)
                local function apply()
                    frame.Size = UDim2.new(0, columnW, 0, layout.AbsoluteContentSize.Y)
                end

                layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(apply)
                apply()
            end

            if not tab[str10] then
                if tab.ContentContainer then
                    tab.ContentContainer.Visible = false

                    for index = #tab.AllContainers, 1, -1 do
                        if tab.AllContainers[index].container == tab.ContentContainer then
                            table.remove(tab.AllContainers, index)
                        end
                    end
                end

                tab[str10] = Instance.new("Frame", window["2"])
                tab[str10].BorderSizePixel = 0
                tab[str10].BackgroundTransparency = 1
                tab[str10].Size = UDim2.new(0, columnW, 0, 0)
                tab[str10].Position = UDim2.new(0, columnX, 0, 118)
                tab[str10].Name = (tab["12"].Name or "Tab") .. "_" .. arg4 .. "_wrapper"
                local uiListLayout = Instance.new("UIListLayout", tab[str10])
                uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                uiListLayout.Padding = UDim.new(0, 10)
                fitHeight(tab[str10], uiListLayout)

                if not window.CurrentTabs[arg4] then
                    window.CurrentTabs[arg4] = tab
                end

                tab[str10].Visible = window.CurrentTabs[arg4] == tab
                table.insert(tab.AllContainers, { container = tab[str10], section = arg4 })
            end

            local value = tab[str10]

            if passed then
                section.MainTitle = Instance.new("TextLabel", value)
                section.MainTitle.TextSize = 13
                section.MainTitle.TextXAlignment = Enum.TextXAlignment.Left
                section.MainTitle.FontFace = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
                section.MainTitle.TextColor3 = Color3.fromRGB(243, 243, 247)
                section.MainTitle.BackgroundTransparency = 1
                section.MainTitle.Size = UDim2.new(0, 200, 0, 16)
                section.MainTitle.Text = passed
                section.MainTitle.Name = "MainTitle"
                section.MainTitle:SetAttribute("fadeOriginal_TextTransparency", 0)
                section.MainTitle:SetAttribute("fadeOriginal_BackgroundTransparency", 1)
            end

            section.ContentContainer = Instance.new("Frame", value)
            section.ContentContainer.BorderSizePixel = 0
            section.ContentContainer.BackgroundColor3 = Color3.fromRGB(14, 15, 20)
            section.ContentContainer.Size = UDim2.new(0, columnW, 0, 0)
            section.ContentContainer.Name = (tab["12"].Name or "Tab") .. "_" .. arg4 .. "_content"
            section.ContentContainer:SetAttribute("fadeOriginal_BackgroundTransparency", 0)
            section.ContentContainer.Visible = true
            Instance.new("UICorner", section.ContentContainer).CornerRadius = UDim.new(0, 10)
            local shadow = Instance.new("UIShadow", section.ContentContainer)
            shadow.Transparency = 0.55
            shadow:SetAttribute("fadeOriginal_Transparency", 0.55)
            local layoutOrder2 = Enum.SortOrder.LayoutOrder
            local contentLayout = Instance.new("UIListLayout", section.ContentContainer)
            contentLayout.SortOrder = layoutOrder2
            contentLayout.Padding = UDim.new(0, 2)
            fitHeight(section.ContentContainer, contentLayout)

            section.Create_Toggle = function(arg6, arg7)
                local options2 = arg7 or {}
                options2.tab = section
                return tab:Create_Toggle(options2)
            end

            section.Create_Slider = function(arg6, arg7)
                local options2 = arg7 or {}
                options2.tab = section
                return tab:Create_Slider(options2)
            end

            section.Create_Dropdown = function(arg6, arg7)
                local options2 = arg7 or {}
                options2.tab = section
                return tab:Create_Dropdown(options2)
            end

            section.Create_ColorPicker = function(arg6, arg7)
                local options2 = arg7 or {}
                options2.tab = section
                return tab:Create_ColorPicker(options2)
            end

            section.Create_TextBox = function(arg6, arg7)
                local options2 = arg7 or {}
                options2.tab = section
                return tab:Create_TextBox(options2)
            end

            return section
        end

        return tab
    end
end

Library.Notify = function(arg, text2, arg2, arg3)
    local n41 = arg3 or 4
    local screenGui = { ["1"] = Instance.new("ScreenGui") }
    screenGui["1"].Name = "Zenthra Notification"
    screenGui["1"].ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui["1"].Parent = playerGui
    screenGui["2"] = Instance.new("Frame", screenGui["1"])
    screenGui["2"].Name = "Notifications"
    screenGui["2"].Size = UDim2.new(0, 230, 0, 400)
    screenGui["2"].Position = UDim2.new(1, -16, 1, -16)
    screenGui["2"].AnchorPoint = Vector2.new(1, 1)
    screenGui["2"].BackgroundTransparency = 1
    screenGui["2"].ZIndex = 10
    local uiListLayout = Instance.new("UIListLayout", screenGui["2"])
    uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    uiListLayout.Padding = UDim.new(0, 8)
    screenGui["4"] = Instance.new("Frame")
    screenGui["4"].Size = UDim2.fromOffset(230, 52)
    screenGui["4"].BackgroundTransparency = 1
    screenGui["4"].ZIndex = 10
    local frame = Instance.new("Frame", screenGui["4"])
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 38)
    frame.ZIndex = 10
    frame.Position = UDim2.fromOffset(260, 0)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
    local frame2 = Instance.new("Frame", frame)
    frame2.Position = UDim2.fromOffset(12, 14)
    frame2.Size = UDim2.fromOffset(24, 24)
    frame2.BackgroundColor3 = Color3.fromRGB(47, 47, 50)
    frame2.ZIndex = 11
    Instance.new("UICorner", frame2).CornerRadius = UDim.new(0, 6)
    local textLabel = Instance.new("TextLabel", frame2)
    textLabel.BackgroundTransparency = 1
    textLabel.Size = UDim2.fromScale(1, 1)
    textLabel.Font = Enum.Font.GothamBold
    textLabel.Text = "i"
    textLabel.TextSize = 12
    textLabel.TextColor3 = Color3.fromRGB(236, 236, 236)
    textLabel.ZIndex = 12
    local textLabel2 = Instance.new("TextLabel", frame)
    textLabel2.BackgroundTransparency = 1
    textLabel2.Position = UDim2.fromOffset(46, 12)
    textLabel2.Size = UDim2.new(1, -58, 0, 14)
    textLabel2.Font = Enum.Font.GothamBold
    textLabel2.Text = text2
    textLabel2.TextSize = 12
    textLabel2.TextColor3 = Color3.fromRGB(236, 236, 236)
    textLabel2.TextXAlignment = Enum.TextXAlignment.Left
    textLabel2.ZIndex = 11
    local frame3 = Instance.new("Frame", frame)
    frame3.Name = "track"
    frame3.Position = UDim2.fromOffset(46, 34)
    frame3.Size = UDim2.new(1, -60, 0, 3)
    frame3.BackgroundColor3 = Color3.fromRGB(56, 56, 59)
    frame3.BorderSizePixel = 0
    frame3.ZIndex = 11
    Instance.new("UICorner", frame3).CornerRadius = UDim.new(0, 2)
    local frame4 = Instance.new("Frame", frame3)
    frame4.Name = "fill"
    frame4.Size = UDim2.fromScale(1, 1)
    frame4.BackgroundColor3 = Color3.fromRGB(236, 236, 236)
    frame4.BorderSizePixel = 0
    frame4.ZIndex = 12
    Instance.new("UICorner", frame4).CornerRadius = UDim.new(0, 2)
    local clone = screenGui["4"]:Clone()
    clone.Parent = screenGui["2"]
    clone.Visible = true
    local frame5 = clone:FindFirstChildOfClass("Frame")
    local track = frame5:FindFirstChild("track")
    track = track and track:FindFirstChild("fill")

    if track then
        game:GetService("TweenService"):Create(track, TweenInfo.new(n41, Enum.EasingStyle.Linear), { Size = UDim2.new(0, 0, 1, 0) }):Play()
    end

    game:GetService("TweenService"):Create(frame5, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Position = UDim2.fromOffset(0, 0) }):Play()

    task.delay(n41, function()
        local tween = game:GetService("TweenService"):Create(frame5, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Position = UDim2.fromOffset(260, 0) })
        tween:Play()

        tween.Completed:Once(function()
            local tween2 = game:GetService("TweenService"):Create(clone, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.fromOffset(230, 0) })
            tween2:Play()

            tween2.Completed:Once(function()
                clone:Destroy()
            end)
        end)
    end)
end

local Got_Phantomed = false

local parryAccuracySlider, parryTypeDropdown, parryRangeSlider, visualsTab, right

do
    do
        local configsTab

        do
            do
                local blatantTab

                do
                    Library.new()

                    blatantTab = Library:Create_Tab({
                        name = "Blatant",
                        section_name = "Automation",
                        icon = "shield-check",
                    })

                    do
                        local left = blatantTab:Create_Section("left")
                        local autoParry, triggerbot
                        local autoParryTriggerbot, triggerbotAutoParry
                        local nextParry = 0
                        local pendingBall, pendingTarget

                        AutoParry.Triggerbot = function(ball, changed)
                            if not Library.Flags.Triggerbot then
                                return
                            end

                            if pendingBall and not pendingBall.Parent then
                                pendingBall = nil
                                nextParry = 0
                            end

                            if not ball then
                                for _, child in AutoParry.Get_Balls() do
                                    AutoParry.Triggerbot(child)
                                end
                                return
                            end

                            if changed and pendingBall == ball then
                                pendingBall = nil
                                nextParry = 0
                            end

                            if not ball.Parent or not ball:GetAttribute("realBall") or ball:GetAttribute("target") ~= Player.Name then
                                return
                            end

                            local data = AutoParry.Get_Curve(ball)
                            if data.Triggerbot_Parried or os.clock() < nextParry then
                                return
                            end

                            local character = Player.Character
                            local primaryPart = character and character.PrimaryPart
                            local humanoid = character and character:FindFirstChildOfClass("Humanoid")

                            if not primaryPart or character.Parent ~= workspace.Alive or not humanoid or humanoid.Health <= 0 then
                                return
                            end

                            if character:GetAttribute("Stunned") or character:GetAttribute("DoNotParry") or character:GetAttribute("IsInvisible") then
                                return
                            end

                            if primaryPart:FindFirstChild("Shield") or primaryPart:FindFirstChild("MaxShield") or primaryPart:FindFirstChild("SingularityCape") then
                                return
                            end

                            local hotbar = Player.PlayerGui:FindFirstChild("Hotbar")
                            local block = hotbar and hotbar:FindFirstChild("Block")
                            local gradient = block and block:FindFirstChildWhichIsA("UIGradient")

                            if gradient and gradient.Offset.Y < 0.49 then
                                return
                            end

                            pendingBall = ball
                            pendingTarget = data.Target_Count
                            LastParry = os.clock()
                            nextParry = LastParry + 1.3
                            AutoParry.Play_Animation()
                            AutoParry.Parry(Library.Flags.Parry_Type)
                        end

                        autoParry = left:Create_Toggle({
                            name = "Auto Parry",
                            flag = "AutoParry",
                            callback = function(arg)
                                if Library.Flags.Auto_Parry_Notification then
                                    Library:Notify("AP = " .. tostring(arg and "Enabled" or "Disabled"), 5)
                                end

                                if arg then
                                    if triggerbot and Library.Flags.Triggerbot then
                                        autoParryTriggerbot = true
                                        triggerbotAutoParry = nil
                                        triggerbot:Toggle(false)
                                    end
                                    ConnectionsManager["Auto Parry"] = RunService.PreSimulation:Connect(function()
                                        local alive = workspace.Alive
                                        if (Player.Character or Player.CharacterAdded:Wait()).Parent ~= alive then
                                            return
                                        end
                                        local ball = AutoParry.Get_Ball()

                                        for _, ball2 in AutoParry.Get_Balls() do
                                            if not ball2 then
                                                return
                                            end
                                            local zoomies = ball2:FindFirstChild("zoomies")
                                            if not zoomies then
                                                return
                                            end
                                            getgenv().Time_View = os.clock() - LastParry
                                            local n41 = os.clock() - LastParry

                                            local maxShield = Player.Character.PrimaryPart:FindFirstChild("MaxShield")
                                            local tornado = workspace.Runtime:FindFirstChild("Tornado")
                                            local abilities = Player.Character and Player.Character:FindFirstChild("Abilities")
                                            local hotbar = Player:FindFirstChild("PlayerGui") and Player.PlayerGui:FindFirstChild("Hotbar")
                                            local visible = hotbar and hotbar:FindFirstChild("Ability") and hotbar.Ability:FindFirstChild("Duration") and hotbar.Ability.Duration.Visible
                                            local infinity = abilities and abilities:FindFirstChild("Infinity")
                                            infinity = infinity and infinity.Enabled
                                            infinity = visible and infinity and InfinityBall
                                            abilities = abilities and abilities:FindFirstChild("Time Hole")
                                            abilities = abilities and abilities.Enabled
                                            local singularityCape = Player.Character.PrimaryPart:FindFirstChild("SingularityCape")
                                            local uiGradient = Player.PlayerGui.Hotbar.Block.UIGradient
                                            getgenv().Parry_Cooldown = uiGradient
                                            local uiGradient2 = Player.PlayerGui.Hotbar.Ability.UIGradient
                                            local attribute = ball2:GetAttribute("target")
                                            ball:GetAttribute("target")
                                            local magnitude = zoomies.VectorVelocity.Magnitude
                                            local value = AutoParry.Get_Ping()
                                            local n42 = math.clamp(value / 10, 10, 16) + magnitude / (2.3497562749127492 + math.clamp(magnitude, 0, 425) * 0.002) * SpeedDivisorMultiplier
                                            local n43 = n42 + Library.Flags.Parry_Range or 0
                                            local position

                                            if ball2 == TrackedBall and RealBallPosition then
                                                position = RealBallPosition
                                            else
                                                position = ball2.Position
                                            end

                                            local magnitude2 = (Player.Character.PrimaryPart.Position - position).Magnitude
                                            local curved = AutoParry.Is_Curved(ball2)
                                            local curvedMore = AutoParry.Is_Curved2(ball2)
                                            if infinity or visible and abilities then
                                                Parries = 0
                                                return
                                            end

                                            if visible and maxShield or singularityCape then
                                                Parries = 0
                                                return
                                            end

                                            if attribute == Player.Name and tornado then
                                                local n44 = (tornado:GetAttribute("TornadoTime") or 1) + 0.314159

                                                if TornadoTime then
                                                    if tick() - TornadoTime < n44 then
                                                        return
                                                    end
                                                    game:GetService("Debris"):AddItem(tornado, 0)
                                                    TornadoTime = nil
                                                end
                                            end

                                            if attribute == Player.Name and getgenv().Cooldown_Protection and n41 > 0.5 and (uiGradient.Offset.Y <= 0.4 and magnitude2 <= n42 or uiGradient.Offset.Y > 0 and uiGradient.Offset.Y <= -0.15) then
                                                for _, abilityName in Parry_Abilities do
                                                    if Player.Character.Abilities[abilityName].Enabled then
                                                        Parried = true
                                                        ReplicatedStorage.Remotes.AbilityButtonPress:Fire()
                                                        return
                                                    end
                                                end
                                            end

                                            if attribute == Player.Name and uiGradient2.Offset.Y == 0.5 and magnitude2 <= n42 and getgenv().Auto_Ability and n41 > 0.5 then
                                                for _, abilityName in Parry_Abilities do
                                                    if Player.Character.Abilities[abilityName].Enabled then
                                                        Parried = true
                                                        ReplicatedStorage.Remotes.AbilityButtonPress:Fire()
                                                        return
                                                    end
                                                end
                                            end

                                            if attribute == Player.Name and curved then
                                                return
                                            end

                                            if attribute == Player.Name and n41 > 0.5 and curvedMore and game.PlaceId ~= 15264892126 then
                                                return
                                            end

                                            if Library.Flags.Phantom_Detection and attribute == Player.Name and Got_Phantomed then
                                                return
                                            end

                                            if attribute == Player.Name and magnitude2 <= n43 and not Parried then
                                                AutoParry.Play_Animation()
                                                AutoParry.Parry(Library.Flags.Parry_Type)
                                                LastParry = os.clock()
                                                Parried = true
                                                local now3 = os.clock()

                                                task.spawn(function()
                                                    local n44 = math.clamp(value / 10, 5, 17)
                                                    local ballProperties = AutoParry:Get_Ball_Properties(ball2)
                                                    if not ballProperties then
                                                        return
                                                    end
                                                    local entityProperties = AutoParry:Get_Entity_Properties()
                                                    if not entityProperties then
                                                        return
                                                    end
                                                    local spamResult = AutoParry.Spam_Service({ Ball = ball2, Ball_Properties = ballProperties, Entity_Properties = entityProperties, Ping = n44 })
                                                    if not spamResult or spamResult == 0 then
                                                        return
                                                    end

                                                    while true do
                                                        RunService.Heartbeat:Wait()
                                                        if not (os.clock() - now3 >= 0.65 or not Parried) then
                                                            continue
                                                        end
                                                        break
                                                    end

                                                    Parried = false
                                                    if Parries >= 7 then
                                                        return false
                                                    end
                                                    Parries += 1

                                                    task.delay(0.5, function()
                                                        if Parries > 0 then
                                                            Parries -= 1
                                                        end
                                                    end)

                                                    ConnectionsManager.Prevent_AP_Parry_When_Manual_Parried = uiGradient:GetPropertyChangedSignal("Offset"):Once(function()
                                                        if uiGradient.Offset.Y < 0.5 and magnitude2 > spamResult then
                                                            Parried = true
                                                            now3 = os.clock()
                                                        end
                                                    end)
                                                end)
                                            end
                                        end
                                    end)
                                else
                                    if ConnectionsManager["Auto Parry"] then
                                        ConnectionsManager["Auto Parry"]:Disconnect()
                                        ConnectionsManager["Auto Parry"] = nil
                                    end
                                    if autoParryTriggerbot then
                                        autoParryTriggerbot = nil
                                        triggerbot:Toggle(true)
                                    end
                                end
                            end,
                        })

                        left:Create_Toggle({
                            name = "AP Notification",
                            flag = "Auto_Parry_Notification",
                            callback = function(autoParryNotification)
                                Library.Flags.Auto_Parry_Notification = autoParryNotification
                            end,
                        })

                        triggerbot = blatantTab:Create_Section("Triggerbot", "left"):Create_Toggle({
                            name = "Triggerbot",
                            flag = "Triggerbot",
                            callback = function(arg)
                                for _, name in {"Triggerbot", "Triggerbot Cooldown", "Triggerbot Success"} do
                                    if ConnectionsManager[name] then
                                        ConnectionsManager[name]:Disconnect()
                                        ConnectionsManager[name] = nil
                                    end
                                end

                                pendingBall = nil
                                nextParry = 0

                                for _, ball in AutoParry.Get_Balls() do
                                    AutoParry.Get_Curve(ball).Triggerbot_Parried = false
                                end

                                if not arg then
                                    if triggerbotAutoParry then
                                        triggerbotAutoParry = nil
                                        autoParry:Toggle(true)
                                    end
                                    return
                                end

                                autoParryTriggerbot = nil
                                if Library.Flags.AutoParry then
                                    triggerbotAutoParry = true
                                    autoParry:Toggle(false)
                                end

                                ConnectionsManager["Triggerbot Cooldown"] = ReplicatedStorage.Remotes.VisualCD.OnClientEvent:Connect(function(block, active, duration)
                                    if not block then
                                        return
                                    end

                                    nextParry = active and os.clock() + (tonumber(duration) or 1.3) or pendingBall and nextParry or 0
                                    if not active then
                                        AutoParry.Triggerbot()
                                    end
                                end)
                                ConnectionsManager["Triggerbot Success"] = ReplicatedStorage.Remotes.ParrySuccess.OnClientEvent:Connect(function()
                                    local data = pendingBall and CurveDataByBall[pendingBall]

                                    if data and data.Target_Count == pendingTarget then
                                        data.Triggerbot_Parried = true
                                    end

                                    pendingBall = nil
                                    nextParry = 0
                                end)
                                ConnectionsManager["Triggerbot"] = RunService.PreSimulation:Connect(function()
                                    AutoParry.Triggerbot()
                                end)
                                AutoParry.Triggerbot()
                            end,
                        })
                    end
                end

                local right2 = blatantTab:Create_Section("right")

                right2:Create_Toggle({
                    name = "Auto Spam",
                    flag = "Auto_Spam",
                    callback = function(arg)
                        if arg then
                            ConnectionsManager["Auto Spam"] = RunService.PostSimulation:Connect(function()
                                if not Library.Flags.AutoParry then
                                    return
                                end
                                local alive = workspace.Alive
                                local character = Player.Character or Player.CharacterAdded:Wait()
                                if character.Parent ~= alive then
                                    return
                                end
                                local ball = AutoParry.Get_Ball()
                                if not ball then
                                    return
                                end

                                if not ball:FindFirstChild("zoomies") then
                                    return
                                end
                                local n41 = math.clamp(AutoParry.Get_Ping() / 10, 10, 16.5)
                                local ballProperties = AutoParry:Get_Ball_Properties(ball)
                                if not ballProperties then
                                    return
                                end
                                local entityProperties = AutoParry:Get_Entity_Properties()
                                if not entityProperties then
                                    return
                                end
                                local spamResult = AutoParry.Spam_Service({ Ball = ball, Ball_Properties = ballProperties, Entity_Properties = entityProperties, Ping = n41 })
                                if not spamResult or spamResult == 0 then
                                    return
                                end
                                local hotbar = Player:FindFirstChild("PlayerGui") and Player.PlayerGui:FindFirstChild("Hotbar")
                                character = character and character:FindFirstChild("Abilities")
                                local visible = hotbar and hotbar:FindFirstChild("Ability") and hotbar.Ability:FindFirstChild("Duration") and hotbar.Ability.Duration.Visible
                                local infinity = character and character:FindFirstChild("Infinity")
                                infinity = infinity and infinity.Enabled
                                infinity = visible and infinity and InfinityBall
                                character = character and character:FindFirstChild("Time Hole")
                                character = character and character.Enabled
                                if infinity then
                                    Parries = 0
                                    return
                                end

                                if not (visible and character) then
                                    local position

                                    if ball == TrackedBall and RealBallPosition then
                                        position = RealBallPosition
                                    else
                                        position = ball.Position
                                    end

                                    if (Player.Character.PrimaryPart.Position - position).Magnitude <= spamResult and Parries >= tonumber(Library.Flags.Clashing_Threshold) then
                                        if IsMobile then
                                            AutoParry.Parry_Animation()
                                        end

                                        if not IsMobile then
                                            AutoParry.Animation_Fix()
                                        end

                                        AutoParry.Parry(Library.Flags.Parry_Type)
                                    end

                                    return
                                end

                                Parries = 0
                                return
                            end)
                        elseif ConnectionsManager["Auto Spam"] then
                            ConnectionsManager["Auto Spam"]:Disconnect()
                            ConnectionsManager["Auto Spam"] = nil
                        end
                    end,
                })

                if IsMobile then
                    right2:Create_Toggle({
                        name = "Manual Spam",
                        flag = "Manual_Spam",
                        callback = function(arg)
                            if arg then
                                local screenGui = Instance.new("ScreenGui")
                                screenGui.Name = "ManualSpamUI"
                                screenGui.ResetOnSpawn = false
                                screenGui.Parent = game.CoreGui
                                local frame = Instance.new("Frame")
                                frame.Name = "MainFrame"
                                frame.Position = UDim2.new(0, 20, 0, 20)
                                frame.Size = UDim2.new(0, 200, 0, 100)
                                frame.BackgroundColor3 = Color3.fromRGB(10, 10, 39)
                                frame.BackgroundTransparency = 0
                                frame.BorderSizePixel = 0
                                frame.Active = true
                                frame.Parent = screenGui
                                local uiCorner = Instance.new("UICorner")
                                uiCorner.CornerRadius = UDim.new(0, 12)
                                uiCorner.Parent = frame
                                local uiStroke = Instance.new("UIStroke")
                                uiStroke.Thickness = 2
                                uiStroke.Color = Color3.new(0, 0, 0)
                                uiStroke.Parent = frame
                                local textButton = Instance.new("TextButton")
                                textButton.Name = "ClashModeButton"
                                textButton.Text = "Start"
                                textButton.Size = UDim2.new(0, 160, 0, 40)
                                textButton.Position = UDim2.new(0.5, -80, 0.5, -20)
                                textButton.BackgroundTransparency = 1
                                textButton.BorderSizePixel = 0
                                textButton.Font = Enum.Font.GothamSemibold
                                textButton.TextColor3 = Color3.new(1, 1, 1)
                                textButton.TextSize = 22
                                textButton.Parent = frame
                                local flag25 = false
                                local dragInput, dragStart, dragPosition
                                local dragged = false

                                local function beginDrag(input)
                                    if dragInput or input.UserInputType ~= Enum.UserInputType.Touch and input.UserInputType ~= Enum.UserInputType.MouseButton1 then
                                        return
                                    end

                                    dragInput = input
                                    dragStart = input.Position
                                    dragPosition = frame.Position
                                    dragged = false
                                end

                                frame.InputBegan:Connect(beginDrag)
                                textButton.InputBegan:Connect(beginDrag)
                                ConnectionsManager["Manual Spam Drag"] = UserInputService.InputChanged:Connect(function(input)
                                    if not dragInput or input ~= dragInput and not (dragInput.UserInputType == Enum.UserInputType.MouseButton1 and input.UserInputType == Enum.UserInputType.MouseMovement) then
                                        return
                                    end

                                    local delta = input.Position - dragStart
                                    dragged = dragged or delta.Magnitude > 6
                                    if dragged then
                                        frame.Position = UDim2.new(dragPosition.X.Scale, dragPosition.X.Offset + delta.X, dragPosition.Y.Scale, dragPosition.Y.Offset + delta.Y)
                                    end
                                end)
                                ConnectionsManager["Manual Spam Drag End"] = UserInputService.InputEnded:Connect(function(input)
                                    if input == dragInput then
                                        dragInput = nil
                                    end
                                end)

                                textButton.MouseButton1Click:Connect(function()
                                    if dragged then
                                        return
                                    end
                                    flag25 = not flag25
                                    textButton.Text = flag25 and "Stop" or "Start"

                                    if flag25 then
                                        ConnectionsManager["Manual Spam UI"] = RunService.PostSimulation:Connect(function()
                                            if Player.Character.Parent ~= workspace.Alive then
                                                return
                                            end
                                            AutoParry.Parry(Library.Flags.Parry_Type)

                                            if IsMobile then
                                                AutoParry.Play_Animation()
                                            end
                                        end)
                                    elseif ConnectionsManager["Manual Spam UI"] then
                                        ConnectionsManager["Manual Spam UI"]:Disconnect()
                                        ConnectionsManager["Manual Spam UI"] = nil
                                    end
                                end)
                            else
                                if game:GetService("CoreGui"):FindFirstChild("ManualSpamUI") then
                                    game:GetService("CoreGui"):FindFirstChild("ManualSpamUI"):Destroy()
                                end

                                for _, name in {"Manual Spam Drag", "Manual Spam Drag End"} do
                                    if ConnectionsManager[name] then
                                        ConnectionsManager[name]:Disconnect()
                                        ConnectionsManager[name] = nil
                                    end
                                end

                                if ConnectionsManager["Manual Spam UI"] then
                                    ConnectionsManager["Manual Spam UI"]:Disconnect()
                                    ConnectionsManager["Manual Spam UI"] = nil
                                end
                            end
                        end,
                    })
                else
                    right2:Create_Toggle({
                        name = "Manual Spam",
                        flag = "Manual_Spam",
                        callback = function(arg)
                            if arg then
                                ConnectionsManager["Manual Spam"] = RunService.PostSimulation:Connect(function()
                                    local alive = workspace.Alive
                                    if (Player.Character or Player.CharacterAdded:Wait()).Parent ~= alive then
                                        return
                                    end
                                    local ball = AutoParry.Get_Ball()
                                    if not ball then
                                        return
                                    end

                                    if not ball:FindFirstChild("zoomies") then
                                        return
                                    end

                                    AutoParry.Animation_Fix()
                                    AutoParry.Parry(Library.Flags.Parry_Type)
                                end)
                            elseif ConnectionsManager["Manual Spam"] then
                                ConnectionsManager["Manual Spam"]:Disconnect()
                                ConnectionsManager["Manual Spam"] = nil
                            end
                        end,
                    })
                end
            end

            configsTab = Library:Create_Tab({
                name = "Configs",
                section_name = "Automation",
                icon = "file-cog",
            })

            do
                local left = configsTab:Create_Section("left")

                parryAccuracySlider = left:Create_Slider({
                    name = "Parry Accuracy",
                    flag = "Parry_Accuracy",
                    min = 1,
                    max = 100,
                    default = 72,
                    callback = function(parryAccuracy)
                        if Library.Flags.Phantom_Detection then
                            SpeedDivisorMultiplier = 0.8 + (parryAccuracy - 1) * 0.024747474747474751
                        else
                            SpeedDivisorMultiplier = 0.8 + (parryAccuracy - 1) * 0.0030303030303030303
                        end

                        Library.Flags.Parry_Accuracy = parryAccuracy
                    end,
                })

                parryTypeDropdown = left:Create_Dropdown({
                    name = "Parry Type",
                    options = {
                        "Camera",
                        "High",
                        "FFA",
                        "Dot",
                        "Dot Pointer",
                        "Closest",
                        "Random",
                        "Backwards",
                    },
                    default = "Camera",
                    flag = "Parry_Type",
                    callback = function(parryType)
                        Library.Flags.Parry_Type = parryType
                    end,
                })
            end
        end

        do
            do
                local right2 = configsTab:Create_Section("right")

                parryRangeSlider = right2:Create_Slider({
                    name = "Parry Range",
                    flag = "Parry_Range",
                    min = 0,
                    max = 10,
                    default = 0,
                    callback = function(parryRange)
                        Library.Flags.Parry_Range = parryRange
                    end,
                })

                right2:Create_Dropdown({
                    name = "Clashing Threshold",
                    options = { "1", "2", "3" },
                    default = "1",
                    flag = "Clashing_Threshold",
                    callback = function(clashingThreshold)
                        Library.Flags.Clashing_Threshold = clashingThreshold
                    end,
                })
            end

            configsTab:Create_Section("Parry Options", "left"):Create_Dropdown({
                name = "Parry Options",
                options = { "Remote", "Hardware", "Keyboard" },
                default = "Remote",
                flag = "Parry_Options",
                callback = function(parryOptions)
                    Library.Flags.Parry_Options = parryOptions
                end,
            })

            visualsTab = Library:Create_Tab({
                name = "Visuals",
                section_name = "Render",
                icon = "rbxassetid://79435149356304",
            })

            do
                local left = visualsTab:Create_Section("left")

                left:Create_Toggle({
                    name = "No Render",
                    flag = "No_Render",
                    callback = function(arg)
                        if arg then
                            if Library.Flags.No_Render_Notification then
                                Library:Notify("No Render = Enabled", 5)
                            end

                            ConnectionsManager["No Render"] = workspace:WaitForChild("Runtime").ChildAdded:Connect(function(child)
                                if child.Name:find("PortalFor_") or child.Name:find("WaypointFor_") then
                                    return
                                end

                                if table.find(Ignored_VFX, child.Name) then
                                    return
                                end
                                game:GetService("Debris"):AddItem(child, 0)
                            end)
                        else
                            if Library.Flags.No_Render_Notification then
                                Library:Notify("No Render = Disabled", 5)
                            end

                            if ConnectionsManager["No Render"] then
                                ConnectionsManager["No Render"]:Disconnect()
                                ConnectionsManager["No Render"] = nil
                            end
                        end
                    end,
                })

                left:Create_Toggle({
                    name = "No_Render Notify",
                    flag = "No_Render_Notification",
                    callback = function(noRenderNotification)
                        Library.Flags.No_Render_Notification = noRenderNotification
                    end,
                })
            end
        end
    end

    right = visualsTab:Create_Section("right")

    do
        local categoryLists = { Sword = {}, Explosion = {} }
        local str10 = nil
        getgenv().Sword_Name = getgenv().Sword_Name or "Base Sword"
        getgenv().FinisherEquipped = getgenv().FinisherEquipped or {}
        getgenv().Selected_Finisher = getgenv().Selected_Finisher or false
        local HoverInfoController = require(ReplicatedStorage.Controllers.HoverInfoController)
        local Utils = require(ReplicatedStorage.Common.Utils)
        local EmoteController = require(ReplicatedStorage.Controllers.EmoteController)
        local SecretAwakenData = require(ReplicatedStorage.Shared.SecretAwakenData)

        right:Create_Toggle({
            name = "Unlock All",
            flag = "Unlock_All",
            callback = function(unlockAll)
                Library.Flags.Unlock_All = unlockAll
                local Shared = require(ReplicatedStorage.Shared.Inventory.Shared)

                if unlockAll then
                    task.spawn(function()
                        local InventoryController = require(ReplicatedStorage.Controllers.Trading.InventoryController)
                        local ShopController = require(ReplicatedStorage.Controllers.UI.ShopController)
                        local favorite = Player.PlayerGui.Shop.Holder.Favorite

                        if not SavedSwordModel then
                            local attribute = Player:GetAttribute("CurrentlyEquippedSword")

                            if attribute then
                                SavedSwordModel = Swords:GetSword(attribute)
                            end
                        end

                        if lastEquipped then
                            local sword2 = Swords:GetSword(lastEquipped)

                            if sword2 then
                                local name = sword2.Name
                                getgenv().Sword_Name = name
                                Swords:EquipSwordTo(Player.Character, getgenv().Sword_Name)
                                SetSword(getgenv().Sword_Name)
                                Player:SetAttribute("CurrentlyEquippedSword", getgenv().Sword_Name)
                            end
                        end

                        str10 = lastExplosion

                        if not explosionController or type(explosionController.PlayExplosion) ~= "function" then
                            explosionController = findExplosionController()
                        end

                        if explosionController and type(explosionController.PlayExplosion) == "function" and not explosionController.__byte_explosion_hooked then
                            local playExplosion = explosionController.PlayExplosion
                            explosionController.__byte_explosion_hooked = true

                            explosionController.PlayExplosion = function(arg, arg2, arg3, arg4, arg5, arg6, arg7)
                                if str10 and str10 ~= "" then
                                    if arg7 and arg6 == Player.Character then
                                        arg2 = str10
                                    end
                                end

                                return playExplosion(arg, arg2, arg3, arg4, arg5, arg6, arg7)
                            end
                        end

                        originalFindItems = hookfunction(Shared.FindItems, function(arg, arg2, arg3, arg4, arg5)
                            local ok, result = pcall(originalFindItems, arg, arg2, arg3, arg4, arg5)

                            if string.find(tostring(arg3), "Abilit", 1, true) then
                                ok = ok and type(result) == "table"
                                if ok then
                                    return result
                                end
                                return {}
                            end

                            if ok and type(result) == "table" and #result > 0 then
                                return result
                            end

                            if arg4 ~= nil then
                                return { arg4 }
                            end
                            return {}
                        end)

                        local ItemInfo = require(ReplicatedStorage.Shared.ItemInfo)
                        local client = require(ReplicatedStorage.Shared.Inventory).Client

                        for k in categoryLists do
                            getgenv().Category = k
                            local virtualItems = ShopController._virtualItems[k]

                            if virtualItems then
                                getgenv().Shop_Lists = virtualItems
                                ShopController._loadInventoryPage(k)

                                while task.wait() do
                                    local voidGuardian = k ~= "Sword" or ShopController._virtualItems.Sword and ShopController._virtualItems.Sword["Witch's Curse"] and ShopController._virtualItems.Sword["Void Hammer"] and ShopController._virtualItems.Sword.Penguin and ShopController._virtualItems.Sword["Corrupted Fan"] and ShopController._virtualItems.Sword["Cyber Scythe"] and ShopController._virtualItems.Sword["Void Guardian"]

                                    if voidGuardian then
                                        voidGuardian = k ~= "Explosion"

                                        if not voidGuardian then
                                            voidGuardian = ShopController._virtualItems.Explosion and ShopController._virtualItems.Explosion["Zap Burst"] and ShopController._virtualItems.Explosion["Zero Point Implosion"] and ShopController._virtualItems.Explosion["Zombie Annihilation"] and ShopController._virtualItems.Explosion["Beach Party"] and ShopController._virtualItems.Explosion["Bad Luck Explosion"] and ShopController._virtualItems.Explosion["Brutality Affection Explosion"] and ShopController._virtualItems.Explosion["Chrome Dracula"] and ShopController._virtualItems.Explosion["Coated Candy"] and ShopController._virtualItems.Explosion["Crystal Strawberry Explosion"] and ShopController._virtualItems.Explosion["Deathwarden Flame Explosion"] and ShopController._virtualItems.Explosion["Deathwarden Star Explosion"] and ShopController._virtualItems.Explosion["Divine Ruin Lore"]
                                        end
                                    end

                                    if not voidGuardian then
                                        continue
                                    end
                                    break
                                end

                                local list2 = {}

                                for _, entry in virtualItems do
                                    table.insert(list2, entry)
                                end

                                for _, shopItem in list2 do
                                    if shopItem.Name ~= "Base Sword" and not shopItem.OwnsItem:Get() then
                                        ownedItems[shopItem] = {
                                            OwnsItem = shopItem.OwnsItem:Get(),
                                            Section = shopItem.Section,
                                            ForceHide = shopItem.ForceHide,
                                            Category = k,
                                        }

                                        local name = client:ItemToKey(k, shopItem.Item) or shopItem.Name
                                        shopItem.InventoryKey = name
                                        shopItem.Key = name
                                        shopItem.OwnsItem:Set(true)
                                        shopItem.Section = "Owned"
                                        shopItem.ForceHide = false

                                        if string.find(shopItem.Name, "Awakened") then
                                            shopItem.ForceHide = true
                                        end

                                        virtualItems[name] = shopItem
                                        local inventoryPage = ShopController._inventoryPages[k]

                                        if inventoryPage then
                                            inventoryPage.MarkDirty(shopItem, false, true)
                                        end
                                    end
                                end
                            end
                        end

                        task.defer(function()
                            for _, favoriteSwordName in favoriteSword do
                                local favoriteState = InventoryController:GetFavoriteState("Sword", favoriteSwordName)

                                if favoriteState then
                                    favoriteState:Set(true)
                                end

                                local chosen = nil

                                for _, virtualItem in ShopController._virtualItems.Sword do
                                    if virtualItem.Name == favoriteSwordName then
                                        chosen = virtualItem
                                        break
                                    else
                                        chosen = nil
                                    end
                                end

                                if chosen then
                                    local favorited = chosen.UI and chosen.UI:FindFirstChild("Favorited")

                                    if favorited then
                                        favorited.Visible = true
                                    end

                                    chosen.IsFavorited = true
                                    chosen._OriginalName_ = chosen._OriginalName_ or chosen.Name_
                                    chosen.Name_ = "#" .. chosen._OriginalName_
                                    local sword2 = ShopController._inventoryPages.Sword

                                    if sword2 then
                                        sword2.MarkDirty(chosen, false, true)
                                    end
                                end
                            end

                            for _, favoriteExplosionName in favoriteExplosion do
                                local favoriteState = InventoryController:GetFavoriteState("Explosion", favoriteExplosionName)

                                if favoriteState then
                                    favoriteState:Set(true)
                                end

                                local chosen = nil

                                for _, virtualItem in ShopController._virtualItems.Explosion do
                                    if virtualItem.Name == favoriteExplosionName then
                                        chosen = virtualItem
                                        break
                                    else
                                        chosen = nil
                                    end
                                end

                                if chosen then
                                    local favorited = chosen.UI and chosen.UI:FindFirstChild("Favorited")

                                    if favorited then
                                        favorited.Visible = true
                                    end

                                    chosen.IsFavorited = true
                                    chosen._OriginalName_ = chosen._OriginalName_ or chosen.Name_
                                    chosen.Name_ = "#" .. chosen._OriginalName_
                                    local explosion = ShopController._inventoryPages.Explosion

                                    if explosion then
                                        explosion.MarkDirty(chosen, false, true)
                                    end
                                end
                            end
                        end)

                        local shop = Player:WaitForChild("PlayerGui"):WaitForChild("Shop")
                        local buyButton = shop.Holder.InfoBG.BuyButton
                        local finisher = shop.Holder.InfoBG.Equips.Finisher

                        ConnectionsManager["Unlock All"] = buyButton.Activated:Connect(function()
                            local selectedItem = ShopController._selectedItem
                            if not selectedItem then
                                return
                            end
                            local type_ = selectedItem.type
                            local name = selectedItem.name

                            if type_ == "Sword" then
                                local equipAccessory = shop.Holder.InfoBG.Equips.EquipAccessory
                                local collection = require(ReplicatedInstances:WaitForChild("SwordAccessories")):GetCollection()

                                local function getInventoryItem(arg, arg2)
                                    return require(ReplicatedStorage.Controllers.InventoryController):GetItem(arg, arg2)
                                end

                                local items3 = {}

                                local function cacheAccessoryState(arg)
                                    if items3[arg] == nil then
                                        items3[arg] = collection[arg]
                                    end
                                end

                                local function isAccessoryEquipped(arg)
                                    return collection[arg] ~= nil
                                end

                                local function refreshAccessoryButton()
                                    local selectedItem2 = ShopController._selectedItem
                                    if not selectedItem2 then
                                        equipAccessory.Visible = false
                                        return
                                    end

                                    if selectedItem2.type ~= "Sword" then
                                        equipAccessory.Visible = false
                                        return
                                    end
                                    local data3 = selectedItem2.data
                                    if not data3 then
                                        equipAccessory.Visible = false
                                        return
                                    end

                                    if not data3.AccessoryToggleable then
                                        equipAccessory.Visible = false
                                        return
                                    end

                                    if data3.AccessoryUnlockable then
                                        local Sword = getInventoryItem("Sword", selectedItem2.name)
                                        if not Sword then
                                            equipAccessory.Visible = false
                                            return
                                        end

                                        if not (Sword.HasAccessory and Sword.HasAccessory:Get()) then
                                            equipAccessory.Visible = false
                                            return
                                        end
                                    end

                                    local name2 = selectedItem2.name
                                    if not (Player:GetAttribute("CurrentlyEquippedSword") == name2) then
                                        equipAccessory.Visible = false
                                        return
                                    end
                                    cacheAccessoryState(selectedItem2.name)
                                    if items3[selectedItem2.name] == nil then
                                        equipAccessory.Visible = false
                                        return
                                    end

                                    if Library.Flags.Unlock_All then
                                        equipAccessory.Visible = true
                                    else
                                        equipAccessory.Visible = true
                                    end

                                    local catalogItem2 = isAccessoryEquipped(selectedItem2.name)
                                    equipAccessory.HoverImage = "rbxassetid://14783051124"
                                    equipAccessory.ImageColor3 = Color3.new(1, 1, 1)
                                    equipAccessory.Image = catalogItem2 and "rbxassetid://15452502387" or "rbxassetid://15452544682"
                                    equipAccessory.Label.Text = catalogItem2 and "UNEQUIP ACCESSORY" or "EQUIP ACCESSORY"
                                end

                                local accessoryToggleable = selectedItem.data.AccessoryToggleable
                                local catalogItem = isAccessoryEquipped(selectedItem.name)

                                if accessoryToggleable then
                                    task.defer(function()
                                        equipAccessory.Visible = true
                                        equipAccessory.ImageColor3 = Color3.new(1, 1, 1)
                                        equipAccessory.Image = catalogItem and "rbxassetid://15452502387" or "rbxassetid://15452544682"
                                        equipAccessory.Label.Text = catalogItem and "UNEQUIP ACCESSORY" or "EQUIP ACCESSORY"
                                    end)
                                else
                                    equipAccessory.Visible = false
                                end

                                if selectedItem.data.HasFinisher then
                                    task.defer(function()
                                        finisher.Visible = true
                                        finisher.HoverImage = "rbxassetid://14783051124"
                                        finisher.ImageColor3 = Color3.new(1, 1, 1)
                                        local name2 = selectedItem.name

                                        if Player:GetAttribute("CurrentlyEquippedSword") == name2 then
                                            local name3 = selectedItem.name

                                            if getgenv().FinisherEquipped[name3] then
                                                finisher.Image = "rbxassetid://15452502387"
                                                finisher.Label.Text = "UNEQUIP"
                                            else
                                                finisher.Image = "rbxassetid://15452544682"
                                                finisher.Label.Text = "EQUIP"
                                            end
                                        else
                                            finisher.Visible = false
                                        end
                                    end)
                                end

                                buyButton.PriceTag.TextLabel.Text = "Equipped"
                                local sword2 = Swords:GetSword(name)
                                local name2 = sword2.Name
                                getgenv().Sword_Name = name2
                                Player:SetAttribute("CurrentlyEquippedSword", sword2.Name)
                                Swords:EquipSwordTo(Player.Character, sword2.Name)
                                SetSword(sword2.Name)

                                for _, child in Player.Character:GetChildren() do
                                    if child:IsA("Model") and child.Name ~= sword2.Name then
                                        child:Destroy()
                                    end
                                end

                                if table.find(favoriteSword, sword2.Name) then
                                    lastEquipped = sword2.Name
                                    saveFavoriteSwords(favoriteSword, favoriteExplosion, lastEquipped)
                                end

                                local selectedItem2 = ShopController._selectedItem

                                if selectedItem2 and selectedItem2.type == "Sword" then
                                    local data3 = selectedItem2.data

                                    if data3 and data3.HasFinisher then
                                        finisher.Visible = true
                                        finisher.HoverImage = "rbxassetid://14783051124"
                                        finisher.ImageColor3 = Color3.new(1, 1, 1)

                                        if Player:GetAttribute("CurrentlyEquippedSword") == name then
                                            if getgenv().FinisherEquipped[name] then
                                                finisher.Image = "rbxassetid://15452502387"
                                                finisher.Label.Text = "UNEQUIP"
                                            else
                                                finisher.Image = "rbxassetid://15452544682"
                                                finisher.Label.Text = "EQUIP"
                                            end
                                        end
                                    else
                                        finisher.Visible = false
                                    end
                                else
                                    finisher.Visible = false
                                end

                                refreshAccessoryButton()
                            end

                            if type_ == "Explosion" then
                                buyButton.PriceTag.TextLabel.Text = "Equipped"
                                str10 = name
                                saveLastExplosion(name)
                                lastExplosion = name

                                if table.find(favoriteSword, name) then
                                    saveFavoriteSwords(favoriteSword, favoriteExplosion, lastEquipped)
                                end
                            end
                        end)

                        for _, connection in getconnections(favorite.Activated) do
                            if connection and connection.Function then
                                connection:Disable()
                            end
                        end

                        ConnectionsManager["Favorite Button Activated"] = favorite.Activated:Connect(function()
                            local selectedItem = ShopController._selectedItem
                            getgenv().Selected_Item = selectedItem
                            if not selectedItem then
                                return
                            end

                            if not ({ Sword = true, Explosion = true })[selectedItem.type] then
                                return
                            end
                            local type_ = selectedItem.type
                            local chosen = nil

                            for _, virtualItem in ShopController._virtualItems[type_] do
                                if virtualItem.Name == selectedItem.name then
                                    chosen = virtualItem
                                    break
                                else
                                    chosen = nil
                                end
                            end

                            if not chosen then
                                return
                            end
                            local favoriteState = InventoryController:GetFavoriteState(selectedItem.type, selectedItem.name)
                            local isFavorited = not favoriteState:Get()
                            favoriteState:Set(isFavorited)
                            chosen.IsFavorited = isFavorited

                            if isFavorited then
                                favorite.Image = "rbxassetid://15697987058"
                                favorite.HoverImage = "rbxassetid://15697983062"
                            else
                                favorite.Image = "rbxassetid://15697981750"
                                favorite.HoverImage = "rbxassetid://15697987058"
                            end

                            if isFavorited then
                                chosen._OriginalName_ = chosen._OriginalName_ or chosen.Name_
                                chosen.Name_ = "#" .. chosen._OriginalName_
                            elseif chosen._OriginalName_ then
                                chosen.Name_ = chosen._OriginalName_
                            end

                            local inventoryPage = ShopController._inventoryPages[type_]

                            if inventoryPage then
                                inventoryPage.MarkDirty(nil, false, true)
                            end

                            if selectedItem.type == "Sword" then
                                if isFavorited then
                                    if not table.find(favoriteSword, selectedItem.name) then
                                        table.insert(favoriteSword, selectedItem.name)
                                    end
                                else
                                    for k, favoriteSwordName in favoriteSword do
                                        if favoriteSwordName == selectedItem.name then
                                            table.remove(favoriteSword, k)

                                            if lastEquipped == selectedItem.name then
                                                lastEquipped = nil
                                            end

                                            break
                                        end
                                    end
                                end
                            end

                            if selectedItem.type == "Explosion" then
                                if isFavorited then
                                    if not table.find(favoriteExplosion, selectedItem.name) then
                                        table.insert(favoriteExplosion, selectedItem.name)
                                    end
                                else
                                    for k, favoriteExplosionName in favoriteExplosion do
                                        if favoriteExplosionName == selectedItem.name then
                                            table.remove(favoriteExplosion, k)
                                            break
                                        end
                                    end
                                end
                            end

                            saveFavoriteSwords(favoriteSword, favoriteExplosion, lastEquipped)
                        end)

                        local delete = shop.Holder.InfoBG.Delete
                        local DeleteItemPromptController = require(ReplicatedStorage.Controllers.DeleteItemPromptController)

                        ConnectionsManager["Shop Item Selected"] = ShopController.itemSelected:Connect(function()
                            task.defer(function()
                                local selectedItem = ShopController._selectedItem
                                if not selectedItem then
                                    return
                                end
                                local name = selectedItem.name
                                if not name then
                                    return
                                end
                                getgenv().Selected_Sword = name

                                if selectedItem and (selectedItem.type == "Sword" and name ~= "Base Sword" or selectedItem.type == "Explosion" and name ~= "Explosion Normal") then
                                    delete.Visible = true
                                end

                                local attribute = Player:GetAttribute("CurrentlyEquippedSword")

                                if table.find(favoriteSword, selectedItem.name) then
                                    favorite.Image = "rbxassetid://15697987058"
                                    favorite.HoverImage = "rbxassetid://15697983062"
                                end

                                if table.find(favoriteExplosion, selectedItem.name) then
                                    favorite.Image = "rbxassetid://15697987058"
                                    favorite.HoverImage = "rbxassetid://15697983062"
                                end

                                if selectedItem.type == "Sword" then
                                    if name == attribute then
                                        buyButton.PriceTag.TextLabel.Text = "Equipped"
                                    else
                                        buyButton.PriceTag.TextLabel.Text = "Equip"

                                    end
                                end

                                if selectedItem.type == "Explosion" then
                                    if name == lastExplosion then
                                        buyButton.PriceTag.TextLabel.Text = "Equipped"
                                    else
                                        buyButton.PriceTag.TextLabel.Text = "Equip"
                                    end
                                end

                                for k in categoryLists do
                                    local virtualItems = ShopController._virtualItems[k]

                                    if virtualItems then
                                        for _, shopItem in virtualItems do
                                            if not shopItem.OwnsItem:Get() then
                                                shop.Holder.InfoBG.Delete.Visible = false
                                            end
                                        end
                                    end
                                end

                                local selectedItem2 = ShopController._selectedItem

                                if selectedItem2 and selectedItem2.type == "Sword" then
                                    local name2 = selectedItem2.name
                                    local data3 = selectedItem2.data

                                    if data3 and data3.HasFinisher then
                                        finisher.Visible = true
                                        finisher.HoverImage = "rbxassetid://14783051124"
                                        finisher.ImageColor3 = Color3.new(1, 1, 1)

                                        if Player:GetAttribute("CurrentlyEquippedSword") == name2 then
                                            if getgenv().FinisherEquipped[name2] then
                                                finisher.Image = "rbxassetid://15452502387"
                                                finisher.Label.Text = "UNEQUIP"
                                            else
                                                finisher.Image = "rbxassetid://15452544682"
                                                finisher.Label.Text = "EQUIP"
                                            end
                                        end
                                    else
                                        finisher.Visible = false
                                    end
                                else
                                    finisher.Visible = false
                                end
                            end)
                        end)

                        for _, connection in getconnections(finisher.Activated) do
                            if connection and connection.Function then
                                connection:Disable()
                            end
                        end

                        ConnectionsManager["Finisher Button Activated"] = finisher.Activated:Connect(function()
                            local selectedItem = ShopController._selectedItem
                            if not selectedItem then
                                return
                            end
                            local name = selectedItem.name
                            if selectedItem.type ~= "Sword" then
                                return
                            end

                            if getgenv().FinisherEquipped[name] then
                                local constant3 = false
                                getgenv().FinisherEquipped[name] = constant3
                                finisher.Image = "rbxassetid://15452544682"
                                finisher.Label.Text = "EQUIP"
                                local constant4 = false
                                getgenv().Selected_Finisher = constant4
                            else
                                for k in getgenv().FinisherEquipped do
                                    local constant5 = false
                                    getgenv().FinisherEquipped[k] = constant5
                                end

                                getgenv().FinisherEquipped[name] = true
                                getgenv().Selected_Finisher = name
                                finisher.Image = "rbxassetid://15452502387"
                                finisher.Label.Text = "UNEQUIP"
                            end
                        end)

                        local client2 = require(ReplicatedStorage.Shared.Inventory).Client

                        ConnectionsManager["Delete Button Activated"] = delete.Activated:Connect(function()
                            local selectedItem = ShopController._selectedItem
                            if not selectedItem then
                                return
                            end
                            local type_ = selectedItem.type
                            local name = selectedItem.name
                            if not name then
                                return
                            end

                            DeleteItemPromptController:PromptConfirmation({
                                PromptType = "Single",
                                Description = "Are you sure you want to delete x1 " .. name .. "? This cannot be undone.",
                            }, function(arg)
                                if not arg then
                                    return
                                end

                                if type_ == "Sword" and getgenv().Sword_Name == name then
                                    getgenv().Sword_Name = "Base Sword"
                                    local sword2 = Swords:GetSword("Base Sword")

                                    if sword2 then
                                        Swords:EquipSwordTo(Player.Character, sword2.Name)
                                    end

                                    if SetSword then
                                        SetSword(sword2.Name)
                                    end
                                end

                                local virtualItems = ShopController._virtualItems[type_]
                                if not virtualItems then
                                    return
                                end

                                for k, entry in virtualItems do
                                    if entry.Name == name then
                                        local inventoryPage = ShopController._inventoryPages[type_]

                                        if inventoryPage and inventoryPage.Scroll then
                                            inventoryPage.Scroll.RemoveInstance("Owned", entry)
                                            inventoryPage.Scroll.RemoveInstance("Unowned", entry)
                                        end

                                        if entry.Trove then
                                            entry.Trove:Destroy()
                                        end

                                        virtualItems[k] = nil
                                        break
                                    end
                                end

                                ShopController._selectedItem = nil
                                buyButton.Visible = false
                                shop.Holder.Favorite.Visible = false
                                shop.Holder.InfoBG.Delete.Visible = false
                                shop.Holder.InfoBG.Equips.EquipAccessory.Visible = false
                                shop.Holder.InfoBG.Equips.Finisher.Visible = false
                            end)
                        end)

                        local equipAccessory = shop.Holder.InfoBG.Equips.EquipAccessory
                        local collection = require(ReplicatedInstances:WaitForChild("SwordAccessories")):GetCollection()

                        local function getInventoryItem(arg, arg2)
                            return require(ReplicatedStorage.Controllers.InventoryController):GetItem(arg, arg2)
                        end

                        local function captureAndDisableSignalHandler(arg)
                            if typeof(arg) ~= "RBXScriptSignal" then
                                return nil
                            end
                            local capturedHandler = nil

                            for _, connection in getconnections(arg) do
                                capturedHandler = connection.Function
                                connection:Disable()
                            end

                            return capturedHandler
                        end

                        local items2 = {}

                        local function cacheAccessoryState(arg)
                            if items2[arg] == nil then
                                items2[arg] = collection[arg]
                            end
                        end

                        local function isAccessoryEquipped(arg)
                            return collection[arg] ~= nil
                        end

                        local function toggleSwordAccessory(arg)
                            cacheAccessoryState(arg)

                            if isAccessoryEquipped(arg) then
                                collection[arg] = nil
                            else
                                collection[arg] = items2[arg]
                            end

                            task.defer(function()
                                Swords:EquipSwordTo(Player.Character or Player.CharacterAdded:Wait(), arg)
                            end)
                        end

                        local function refreshAccessoryButton()
                            local selectedItem = ShopController._selectedItem
                            if not selectedItem then
                                equipAccessory.Visible = false
                                return
                            end

                            if selectedItem.type ~= "Sword" then
                                equipAccessory.Visible = false
                                return
                            end
                            local data3 = selectedItem.data
                            if not data3 then
                                equipAccessory.Visible = false
                                return
                            end

                            if not data3.AccessoryToggleable then
                                equipAccessory.Visible = false
                                return
                            end

                            if data3.AccessoryUnlockable then
                                local Sword = getInventoryItem("Sword", selectedItem.name)
                                if not Sword then
                                    equipAccessory.Visible = false
                                    return
                                end

                                if not (Sword.HasAccessory and Sword.HasAccessory:Get()) then
                                    equipAccessory.Visible = false
                                    return
                                end
                            end

                            local name = selectedItem.name
                            if not (Player:GetAttribute("CurrentlyEquippedSword") == name) then
                                equipAccessory.Visible = false
                                return
                            end
                            cacheAccessoryState(selectedItem.name)
                            if items2[selectedItem.name] == nil then
                                equipAccessory.Visible = false
                                return
                            end

                            if Library.Flags.Unlock_All then
                                equipAccessory.Visible = true
                            else
                                equipAccessory.Visible = true
                            end

                            local catalogItem = isAccessoryEquipped(selectedItem.name)
                            equipAccessory.HoverImage = "rbxassetid://14783051124"
                            equipAccessory.ImageColor3 = Color3.new(1, 1, 1)
                            equipAccessory.Image = catalogItem and "rbxassetid://15452502387" or "rbxassetid://15452544682"
                            equipAccessory.Label.Text = catalogItem and "UNEQUIP ACCESSORY" or "EQUIP ACCESSORY"
                        end

                        Player.PlayerGui.Shop.Holder.InfoBG.SecretUpgrade.Visible = false

                        ConnectionsManager["Refresh Accessory Button"] = ShopController.itemSelected:Connect(function()
                            task.defer(refreshAccessoryButton)
                        end)

                        local activated = captureAndDisableSignalHandler(equipAccessory.Activated)

                        equipAccessory.Activated:Connect(function(...)
                            local selectedItem = ShopController._selectedItem

                            if not selectedItem or selectedItem.type ~= "Sword" then
                                if activated then
                                    return activated(...)
                                end
                                return
                            end

                            if not selectedItem.data or not selectedItem.data.AccessoryToggleable then
                                if activated then
                                    return activated(...)
                                end
                                return
                            end

                            toggleSwordAccessory(selectedItem.name)
                            refreshAccessoryButton()
                        end)

                        local secretUpgrade = Player.PlayerGui.Shop.Holder.InfoBG.SecretUpgrade
                        local secretUpgrade2 = Player.PlayerGui.SecretUpgrade

                        ConnectionsManager["Secret Awaken Button"] = secretUpgrade.Activated:Connect(function()
                            local selectedItem = ShopController._selectedItem
                            if not selectedItem then
                                return
                            end
                            local name = selectedItem.name
                            if selectedItem.type ~= "Sword" then
                                return
                            end
                            secretUpgrade2.Black.Visible = true
                            secretUpgrade2.Main.Visible = true
                            local swordIcon = Utils.Icons:GetSwordIcon("Awakened " .. name)
                            secretUpgrade2.Main.template1.vector.Image = Swords:GetSword(name).Icon

                            secretUpgrade2.Main.template2.vector.Image = swordIcon
                            secretUpgrade2.Main.template2.customs.c3.Visible = true
                            local requirement = SecretAwakenData.Requirement
                            local fill = secretUpgrade2.Main.Progress.Fill
                            secretUpgrade2.Main.Progress.Progress.Text = requirement .. " / " .. requirement
                            fill.Size = UDim2.fromScale(math.min(requirement / requirement, 1), 1)
                            return
                        end)

                        ConnectionsManager["Secret Awaken Button"] = secretUpgrade2.Main.Upgrade.Activated:Connect(function()
                            local selectedItem = ShopController._selectedItem
                            if not selectedItem then
                                return
                            end
                            local type_ = selectedItem.type
                            local name = selectedItem.name
                            local virtualItems = ShopController._virtualItems[type_]

                            if virtualItems then
                                for k, entry in virtualItems do
                                    if entry.Name == name then
                                        local inventoryPage = ShopController._inventoryPages[type_]

                                        if inventoryPage and inventoryPage.Scroll then
                                            inventoryPage.Scroll.RemoveInstance("Owned", entry)
                                            inventoryPage.Scroll.RemoveInstance("Unowned", entry)
                                        end

                                        if entry.Trove then
                                            entry.Trove:Destroy()
                                        end

                                        virtualItems[k] = nil
                                        break
                                    end
                                end
                            end

                            local str11 = "Awakened " .. name

                            for _, shopEntry in getgenv().Shop_Lists do
                                getgenv().Values = shopEntry

                                if shopEntry.Name == str11 then
                                    shopEntry.ForceHide = false
                                    local sword2 = shopEntry.Sword
                                    getgenv().Sword_Value = sword2
                                    local item = shopEntry.Item
                                    shopEntry.InventoryKey = client:ItemToKey(getgenv().Category, item) or shopEntry.Name
                                    local inventoryKey = shopEntry.InventoryKey
                                    getgenv().InventoryKey = inventoryKey
                                    break
                                end
                            end

                            secretUpgrade.Visible = false
                            secretUpgrade2.Black.Visible = false
                            secretUpgrade2.Main.Visible = false

                            ShopController:Select({
                                type = "Sword",
                                name = "Awakened " .. name,
                                data = getgenv().Sword_Value,
                                key = getgenv().InventoryKey,
                            })

                            ShopController:Open("Shop")
                        end)

                        titleButtonState = {}
                        titleButtons = {}

                        for _, child in titleList:GetChildren() do
                            if child:IsA("ImageButton") or child:IsA("Frame") then
                                local label = child:FindFirstChild("TextLabel")

                                titleButtonState[child] = {
                                    Name = child.Name,
                                    Visible = child.Visible,
                                    LabelText = label and label.Text or nil,
                                    LabelColor = label and label.TextColor3 or nil,
                                    LayoutOrder = child.LayoutOrder,
                                }
                            end
                        end

                        for _, child in titleList:GetChildren() do
                            if child:IsA("ImageButton") or child:IsA("Frame") then
                                table.insert(titleButtons, child)
                            end
                        end

                        table.sort(titleButtons, function(arg, arg2)
                            return arg.LayoutOrder < arg2.LayoutOrder
                        end)

                        for k, titleInfo in TitleData do
                            local titleButton = titleButtons[k + 1]

                            if titleButton then
                                local textLabel = titleButton:FindFirstChild("TextLabel")

                                if textLabel then
                                    textLabel.Text = titleInfo.Tag.Text
                                    textLabel.TextColor3 = titleInfo.Tag.Color
                                end

                                titleButton.Name = titleInfo.Name
                                titleButton.Visible = true
                                continue
                            end

                            break
                        end

                        for _, titleButton in titleButtons do
                            if titleButton:IsA("ImageButton") then
                                ConnectionsManager["Titles Row"] = titleButton.Activated:Connect(function()
                                    selectedTitle = titleButton
                                    local n41 = titleButton.LayoutOrder - 1
                                    local titleInfo = TitleData[n41]

                                    if n41 == 0 then
                                        chatTag = nil
                                    else
                                        chatTag = { Text = titleInfo.Tag.Text, Color = titleInfo.Tag.Color }
                                    end

                                    for _, titleButton2 in titleButtons do
                                        local selected = titleButton2:FindFirstChild("Selected")

                                        if selected then
                                            selected.Visible = titleButton2 == selectedTitle
                                        end
                                    end
                                end)
                            end
                        end

                        if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
                            TextChatService.OnIncomingMessage = function(arg)
                                local textSource = arg.TextSource

                                if textSource and textSource.UserId == Player.UserId then
                                    local textChatMessageProperties = Instance.new("TextChatMessageProperties")

                                    if chatTag then
                                        local text2 = chatTag.Text
                                        local displayName = Player.DisplayName
                                        textChatMessageProperties.PrefixText = string.format("<font color=\"%s\">[%s]</font> <font color=\"%s\">%s</font>", colorToHex(chatTag.Color), text2, colorToHex(chatTag.Color), displayName)
                                    else
                                        textChatMessageProperties.PrefixText = Player.DisplayName
                                    end

                                    return textChatMessageProperties
                                end
                            end
                        end

                        local emoteWheel = game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("EmoteWheel", 10)
                        local holder = emoteWheel.Wheel.Holder
                        local content = emoteWheel:WaitForChild("List", 10):WaitForChild("Content", 10)
                        local children = ReplicatedStorage:WaitForChild("Misc", 10):WaitForChild("Emotes", 10):GetChildren()
                        getgenv().Emotes_Datas = children
                        emoteWheelSlots = {}

                        for i = 1, 5 do
                            emoteWheelSlots[i] = {}

                            for i2 = 1, 8 do
                                local n41 = i2 + (i - 1) * 8
                                local slotButton = holder:FindFirstChild(tostring(i2))

                                if slotButton then
                                    emoteWheelSlots[i][i2] = {
                                        GlobalSlot = n41,
                                        EmoteId = slotButton:GetAttribute("EmoteId"),
                                        EmoteName = slotButton:GetAttribute("EmoteName"),
                                        Icon = slotButton.Image,
                                    }
                                end
                            end
                        end

                        emoteMenuEntries = {}

                        for _, child in Player.PlayerGui.EmoteWheel.Menu.Content:GetChildren() do
                            if child:IsA("ImageButton") then
                                local num = tonumber(child.Name)

                                if num then
                                    local vector = child:FindFirstChild("Vector")
                                    local title = child:FindFirstChild("Title")

                                    emoteMenuEntries[num] = {
                                        EmoteId = child:GetAttribute("EmoteId"),
                                        EmoteName = child:GetAttribute("EmoteName"),
                                        Icon = child.Image,
                                        GlobalSlot = child:GetAttribute("GlobalSlot"),
                                        VectorImage = vector and vector.Image or nil,
                                        TitleText = title and title.Text or nil,
                                    }
                                end
                            end
                        end

                        local EmoteWheelController = require(ReplicatedStorage.Controllers.EmoteWheelController)

                        local function updateEmoteWheelSlot(arg)
                            if not Library.Flags.Unlock_All then
                                return
                            end
                            local n41 = arg + ((EmoteWheelController.page or 1) - 1) * 8
                            local slotButton = holder:FindFirstChild(tostring(arg))
                            if not slotButton then
                                return
                            end
                            local attribute = slotButton:GetAttribute("EmoteId")
                            local attribute2 = slotButton:GetAttribute("EmoteName")
                            local image = slotButton.Image

                            if not attribute or attribute == "" then
                                wheelSlots[tostring(n41)] = nil
                            else
                                wheelSlots[tostring(n41)] = { EmoteId = attribute, EmoteName = attribute2, Icon = image }
                            end

                            saveWheelSlots()
                        end

                        local n41 = 1

                        for _, child in holder:GetChildren() do
                            if child and child:IsA("ImageButton") then
                                local num = tonumber(child.Name)

                                ConnectionsManager["Emote Wheel Slot"] = child.Activated:Connect(function()
                                    n41 = num
                                    updateEmoteWheelSlot(num)
                                end)
                            end
                        end

                        local constant = 1
                        local content2 = Player.PlayerGui.EmoteWheel.Menu.Content

                        for _, child in content2:GetChildren() do
                            if child and child:IsA("ImageButton") then
                                local num = tonumber(child.Name)

                                ConnectionsManager["Emote Wheel Slot Mobile"] = child.Activated:Connect(function()
                                    constant = num
                                    updateEmoteWheelSlot(num)
                                end)
                            end
                        end

                        for _, child in holder:GetChildren() do
                            if child:IsA("ImageButton") then
                                local text2 = wheelSlots[tostring(tonumber(child.Name) + ((EmoteWheelController.page or 1) - 1) * 8)]

                                if text2 then
                                    child.Image = text2.Icon
                                    child:SetAttribute("EmoteId", text2.EmoteId)
                                    child:SetAttribute("EmoteName", text2.EmoteName)
                                    child:SetAttribute("Icon", text2.Icon)
                                    local label = content2:FindFirstChild(tostring(constant))

                                    if label then
                                        label.Vector.Image = text2.Icon
                                        label.Title.Text = text2.EmoteName
                                        label:SetAttribute("EmoteId", text2.EmoteId)
                                        label:SetAttribute("EmoteName", text2.EmoteName)
                                        updateEmoteWheelSlot(constant)
                                    end
                                end
                            else
                                local emote = children[global_slot]

                                if emote then
                                    child.Image = emote:GetAttribute("Icon")
                                    child:SetAttribute("EmoteId", emote.Name)
                                    child:SetAttribute("EmoteName", emote:GetAttribute("EmoteName") or emote.Name)
                                    child:SetAttribute("Icon", emote:GetAttribute("Icon"))
                                end
                            end
                        end

                        ConnectionsManager["Emote Wheel Refresh"] = game:GetService("Players").LocalPlayer.CharacterAppearanceLoaded:Connect(function()
                            local page = EmoteWheelController.page or 1

                            for _, child in holder:GetChildren() do
                                if child:IsA("ImageButton") then
                                    local text2 = wheelSlots[tostring(tonumber(child.Name) + (page - 1) * 8)]

                                    if text2 then
                                        child.Image = text2.Icon
                                        child:SetAttribute("EmoteId", text2.EmoteId)
                                        child:SetAttribute("EmoteName", text2.EmoteName)
                                        child:SetAttribute("Icon", text2.Icon)
                                        local label = content2:FindFirstChild(tostring(constant))

                                        if label then
                                            label.Vector.Image = text2.Icon
                                            label.Title.Text = text2.EmoteName
                                            label:SetAttribute("EmoteId", text2.EmoteId)
                                            label:SetAttribute("EmoteName", text2.EmoteName)
                                            updateEmoteWheelSlot(constant)
                                        end
                                    end
                                else
                                    local emote = children[global_slot]

                                    if emote then
                                        child.Image = emote:GetAttribute("Icon")
                                        child:SetAttribute("EmoteId", emote.Name)
                                        child:SetAttribute("EmoteName", emote:GetAttribute("EmoteName") or emote.Name)
                                        child:SetAttribute("Icon", emote:GetAttribute("Icon"))
                                    end
                                end
                            end
                        end)

                        local function refreshEmoteWheelPage()
                            if not Library.Flags.Unlock_All then
                                return
                            end
                            local page = EmoteWheelController.page or 1

                            for _, child in holder:GetChildren() do
                                if child:IsA("ImageButton") then
                                    local text2 = wheelSlots[tostring(tonumber(child.Name) + (page - 1) * 8)]

                                    if text2 and text2.EmoteId and text2.Icon then
                                        child.Image = text2.Icon
                                        child:SetAttribute("EmoteId", text2.EmoteId)
                                        child:SetAttribute("EmoteName", text2.EmoteName or text2.EmoteId)
                                        child:SetAttribute("Icon", text2.Icon)
                                        local label = content2:FindFirstChild(tostring(constant))

                                        if label then
                                            label.Vector.Image = text2.Icon
                                            label.Title.Text = text2.EmoteName
                                            label:SetAttribute("EmoteId", text2.EmoteId)
                                            label:SetAttribute("EmoteName", text2.EmoteName)
                                            updateEmoteWheelSlot(constant)
                                        end
                                    end
                                else
                                    local wheelSlot = emoteWheelSlots[page] and emoteWheelSlots[page][slot]

                                    if wheelSlot then
                                        child.Image = wheelSlot.Icon
                                        child:SetAttribute("EmoteId", wheelSlot.EmoteId)
                                        child:SetAttribute("EmoteName", wheelSlot.EmoteName)
                                        child:SetAttribute("Icon", wheelSlot.Icon)
                                    end
                                end
                            end
                        end

                        local wheel = emoteWheel.Wheel

                        for _, connection in getconnections(wheel.Pages.Next.Activated) do
                            if connection and connection.Function then
                                connection:Disable()
                            end
                        end

                        for _, connection in getconnections(wheel.Pages.Previous.Activated) do
                            if connection and connection.Function then
                                connection:Disable()
                            end
                        end

                        ConnectionsManager["Wheel.Pages.Next.Activated"] = wheel.Pages.Next.Activated:Connect(function()
                            EmoteWheelController.page = EmoteWheelController.page % 5 + 1
                            EmoteWheelController:updatePage()
                            refreshEmoteWheelPage()
                        end)

                        ConnectionsManager["Wheel.Pages.Previous.Activated"] = wheel.Pages.Previous.Activated:Connect(function()
                            EmoteWheelController.page = EmoteWheelController.page <= 1 and 5 or EmoteWheelController.page - 1
                            EmoteWheelController:updatePage()
                            refreshEmoteWheelPage()
                        end)

                        local pointer = emoteWheel.Wheel.Center.Pointer

                        ConnectionsManager.Pointer = pointer:GetPropertyChangedSignal("Rotation"):Connect(function()
                            local n42 = math.clamp(math.round((pointer.Rotation + 90) / 45), 1, 8)
                            n41 = n42
                            updateEmoteWheelSlot(n42)
                        end)

                        local localPlayer2 = game:GetService("Players").LocalPlayer
                        local template = localPlayer2.PlayerGui.EmoteWheel.List.Content.UIGridLayout:FindFirstChild("TEMPLATE")
                        local searchInput = localPlayer2.PlayerGui.EmoteWheel.List.SearchFrame.SearchBG.SearchInput
                        local list = {}
                        local folder = content:FindFirstChild("Folder")

                        if folder then
                            folder.Parent = ReplicatedStorage
                        end

                        local uiGridLayout = content:FindFirstChildWhichIsA("UIGridLayout")

                        emoteGrid = {
                            LayoutCellPadding = uiGridLayout.CellPadding,
                            LayoutCellSize = uiGridLayout.CellSize,
                            FillDirectionMaxCells = uiGridLayout.FillDirectionMaxCells,
                            SortOrder = uiGridLayout.SortOrder,
                            ScrollingDirection = content.ScrollingDirection,
                            AutomaticCanvasSize = content.AutomaticCanvasSize,
                            TemplateVisible = template.Visible,
                            Entries = {},
                        }

                        for _, child in content:GetChildren() do
                            if child:IsA("Frame") or child:IsA("ImageButton") or child:IsA("ImageLabel") then
                                table.insert(emoteGrid.Entries, child:Clone())
                            end
                        end

                        uiGridLayout.CellPadding = UDim2.fromOffset(8, 8)
                        uiGridLayout.CellSize = UDim2.fromScale(0.4, 0.4)
                        uiGridLayout.FillDirectionMaxCells = 2
                        uiGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
                        content.ScrollingDirection = Enum.ScrollingDirection.Y
                        content.AutomaticCanvasSize = Enum.AutomaticSize.Y

                        table.sort(children, function(arg, arg2)
                            local attribute = arg:GetAttribute("EmoteName") or arg.Name
                            local attribute2 = arg2:GetAttribute("EmoteName") or arg2.Name
                            local n42 = data[attribute] and 1 or 0
                            local n43 = data[attribute2] and 1 or 0
                            if n42 ~= n43 then
                                return n42 > n43
                            end
                            return attribute < attribute2
                        end)

                        local constant2 = 1

                        for _, child in children do
                            local attribute = child:GetAttribute("EmoteName") or child.Name

                            if data[attribute] then
                                local slotButton = content2:FindFirstChild(tostring(constant2))

                                if slotButton then
                                    local vector = slotButton:FindFirstChild("Vector")
                                    local title = slotButton:FindFirstChild("Title")

                                    if vector then
                                        vector.Image = child:GetAttribute("Icon")
                                    end

                                    if title then
                                        title.Text = attribute
                                    end

                                    slotButton:SetAttribute("EmoteId", child.Name)
                                    slotButton:SetAttribute("EmoteName", attribute)
                                    constant2 += 1
                                    continue
                                end
                            else
                                continue
                            end

                            break
                        end

                        local lock = Player.PlayerGui.EmoteWheel.List.Content.UIGridLayout.TEMPLATE.Lock

                        for k, child in children do
                            local clone = template:Clone()
                            clone.Name = "Emote_" .. k
                            clone.LayoutOrder = k
                            local clone2 = lock:Clone()
                            clone2.Parent = clone
                            local emoteSlotNames = { "Emote1", "Emote2", "Emote3", "Emote4", "Emote5", "Emote6", "Emote7" }

                            if table.find(emoteSlotNames, child.Name) then
                                clone2.Visible = true
                            else
                                clone2.Visible = false
                            end

                            local attribute = child:GetAttribute("Icon")
                            local attribute2 = child:GetAttribute("EmoteName")
                            local vector = clone:FindFirstChild("Vector")

                            if vector then
                                vector.Image = attribute
                                vector.Size = UDim2.fromScale(0.9, 0.9)
                                vector.SizeConstraint = Enum.SizeConstraint.RelativeYY
                            end

                            local itemName = clone:FindFirstChild("ItemName")

                            if itemName then
                                itemName.Text = attribute2
                            end

                            local favorite2 = clone:FindFirstChild("Favorite")

                            if favorite2 then
                                favorite2.Visible = true
                            end

                            local delete2 = clone:FindFirstChild("Delete")

                            if delete2 then
                                if table.find(emoteSlotNames, child.Name) then
                                    delete2.Visible = false
                                else
                                    delete2.Visible = true

                                    for _, connection in getconnections(delete2.Activated) do
                                        if connection and connection.Function then
                                            connection:Disable()
                                        end
                                    end

                                    ConnectionsManager["Emotes Delete Prompt"] = delete2.Activated:Connect(function()
                                        DeleteItemPromptController:PromptConfirmation({
                                            PromptType = "Single",
                                            Description = "Are you sure you want to delete x1 " .. attribute2 .. "? This cannot be undone.",
                                        }, function(arg)
                                            if arg then
                                                clone:Destroy()
                                            end
                                        end)
                                    end)
                                end
                            end

                            clone:SetAttribute("EmoteId", child.Name)
                            clone:SetAttribute("EmoteName", attribute2)
                            table.insert(list, clone)

                            ConnectionsManager["Emote Entry"] = clone.Activated:Connect(function()
                                local slotButton = holder:FindFirstChild(tostring(n41))

                                if slotButton then
                                    slotButton.Image = attribute
                                    slotButton:SetAttribute("EmoteId", child.Name)
                                    slotButton:SetAttribute("EmoteName", attribute2)
                                    updateEmoteWheelSlot(n41)
                                    local label = content2:FindFirstChild(tostring(constant))

                                    if label then
                                        label.Vector.Image = attribute
                                        label.Title.Text = attribute2
                                        label:SetAttribute("EmoteId", child.Name)
                                        label:SetAttribute("EmoteName", attribute2)
                                        updateEmoteWheelSlot(constant)
                                    end
                                end
                            end)

                            ConnectionsManager["Hover Info Tip"] = clone.MouseEnter:Connect(function()
                                Player.PlayerGui.HoverInfo.Item.Visible = true
                                local flag25 = table.find(emoteSlotNames, child.Name) ~= nil
                                local HoverInfoController = HoverInfoController
                                local add = HoverInfoController.Add
                                local name2 = { IsCustom = false, Name = child.Name }
                                name2.Description = child:GetAttribute("Description")
                                name2.TradeLock = flag25 and { Type = "Permanent" } or nil
                                add(HoverInfoController, clone, "Emote", name2)
                            end)

                            ConnectionsManager["Hover Info Tip Hide"] = clone.MouseLeave:Connect(function()
                                Player.PlayerGui.HoverInfo.Item.Visible = false
                            end)

                            ConnectionsManager["Hover Info Mobile"] = clone.InputBegan:Connect(function(input)
                                if input.UserInputType == Enum.UserInputType.Touch then
                                    Player.PlayerGui.HoverInfo.Item.Visible = true
                                    HoverInfoController:Add(clone, "Emote", { IsCustom = false, Name = child.Name, Description = child:GetAttribute("Description") })
                                end
                            end)

                            ConnectionsManager["Hover Info Mobile End"] = clone.InputEnded:Connect(function(input)
                                if input.UserInputType == Enum.UserInputType.Touch then
                                    Player.PlayerGui.HoverInfo.Item.Visible = false
                                end
                            end)

                            local favoriteState = InventoryController:GetFavoriteState("Emote", attribute2)

                            if data[attribute2] then
                                favoriteState:Set(true)
                                favorite2.Image = "rbxassetid://15697987058"
                                favorite2.HoverImage = "rbxassetid://15697983062"
                            else
                                favoriteState:Set(false)
                                favorite2.Image = "rbxassetid://15697981750"
                                favorite2.HoverImage = "rbxassetid://15697987058"
                            end

                            ConnectionsManager["Favorite Button"] = favorite2.Activated:Connect(function()
                                local flag25 = not favoriteState:Get()
                                favoriteState:Set(flag25)

                                if flag25 then
                                    favorite2.Image = "rbxassetid://15697987058"
                                    favorite2.HoverImage = "rbxassetid://15697983062"
                                    data[attribute2] = true
                                else
                                    favorite2.Image = "rbxassetid://15697981750"
                                    favorite2.HoverImage = "rbxassetid://15697987058"
                                    data[attribute2] = nil
                                end

                                saveFavoriteEmotes()

                                table.sort(list, function(arg, arg2)
                                    local attribute3 = arg:GetAttribute("EmoteName")
                                    local attribute4 = arg2:GetAttribute("EmoteName")
                                    local n42 = data[attribute3] and 1 or 0
                                    local n43 = data[attribute4] and 1 or 0
                                    if n42 ~= n43 then
                                        return n42 > n43
                                    end
                                    return attribute3 < attribute4
                                end)

                                for k2, presetRow in list do
                                    presetRow.LayoutOrder = k2
                                end
                            end)

                            clone.Parent = content
                        end

                        ConnectionsManager["SearchBox Text Change"] = searchInput:GetPropertyChangedSignal("Text"):Connect(function()
                            local str11 = string.lower(searchInput.Text):gsub("^%s*(.-)%s*$", "%1")

                            for _, entry in list do
                                local attribute2 = string.lower(entry:GetAttribute("EmoteName") or "")
                                entry.Visible = str11 == "" or string.find(attribute2, str11, 1, true) ~= nil
                            end
                        end)

                        for _, child in children do
                            if child:IsA("Animation") and child:GetAttribute("EmoteName") then
                                emotes.storage[child.Name] = child
                            end
                        end

                        EmoteController.Play = function(arg, arg2)
                            AutoParry.Play_Wheel_Emote_Animations(arg2)
                        end

                        local localPlayer3 = Players.LocalPlayer
                        local deleteItems = playerGui:WaitForChild("Shop").Holder.DeleteItems

                        local function findVirtualItem(arg, arg2)
                            local virtualItems = ShopController._virtualItems[arg]
                            if not virtualItems then
                                return nil
                            end

                            for k, value in pairs(virtualItems) do
                                if value and (value.Name == arg2 or k == arg2) then
                                    return value
                                end
                            end

                            return nil
                        end

                        local categoryLists2 = { Sword = {}, Explosion = {} }

                        local function removeVirtualUnlock(arg, arg2)
                            if arg == "Sword" and getgenv().Sword_Name == arg2 then
                                getgenv().Sword_Name = "Base Sword"
                                getgenv().FinisherEquipped[arg2] = nil
                                getgenv().Selected_Finisher = getgenv().FinisherEquipped["Base Sword"] and "Base Sword" or false
                                local sword2 = Swords:GetSword("Base Sword")

                                if sword2 then
                                    pcall(function()
                                        Swords:EquipSwordTo(localPlayer3.Character, sword2.Name)
                                    end)

                                    if SetSword then
                                        pcall(function()
                                            SetSword(sword2.Name)
                                        end)
                                    end
                                end
                            elseif getgenv().FinisherEquipped then
                                getgenv().FinisherEquipped[arg2] = nil
                            end

                            local callResult = findVirtualItem(arg, arg2)

                            if callResult then
                                callResult.OwnsItem:Set(false)
                                callResult.Section = "Unowned"
                                local inventoryPage = ShopController._inventoryPages[arg]

                                if inventoryPage and inventoryPage.Scroll then
                                    pcall(function()
                                        inventoryPage.Scroll.RemoveInstance("Owned", callResult)
                                    end)

                                    pcall(function()
                                        inventoryPage.Scroll.AddInstance("Unowned", callResult)
                                    end)

                                    inventoryPage.MarkDirty(arg, false, true)
                                end
                            end

                            categoryLists2[arg] = categoryLists2[arg] or {}
                            categoryLists2[arg][arg2] = true
                            ShopController._selectedItem = nil
                        end

                        local client3 = require(ReplicatedStorage.Shared.Inventory).Client

                        local function ownsInventoryItem(arg, arg2)
                            local ok, result = pcall(function()
                                return client3:FindItemsWithKey(arg, arg2)
                            end)

                            return ok and result and #result > 0
                        end

                        local function isProtectedDefaultItem(arg)
                            return arg == "Base Sword" or arg == "Explosion Normal"
                        end

                        local function refreshVirtualItem(arg)
                            if not arg then
                                return
                            end

                            pcall(function()
                                arg.ForceHide = false
                            end)

                            pcall(function()
                                arg.InDeleteMulti:Set(0)
                            end)

                            pcall(function()
                                arg.Section = "Owned"
                            end)

                            local inventoryPage = ShopController._inventoryPages[arg.type or arg.Type]
                            arg.OwnsItem:Set(true)

                            if inventoryPage and inventoryPage.MarkDirty then
                                pcall(function()
                                    inventoryPage.MarkDirty(arg, false, true)
                                end)
                            end
                        end

                        local function clearMultiDelete()
                            ShopController._multiDelete = nil

                            pcall(function()
                                ShopController:_updateMultiDeleteVisbility()
                            end)

                            pcall(function()
                                ShopController:_updateMultiDelete()
                            end)
                        end

                        local addToMultiDelete = ShopController._addToMultiDelete

                        ShopController._addToMultiDelete = function(arg, arg2, arg3)
                            if not Library.Flags.Unlock_All then
                                return addToMultiDelete(arg, arg2, arg3)
                            end

                            if ownsInventoryItem(arg2, arg3) then
                                return addToMultiDelete(arg, arg2, arg3)
                            end

                            if isProtectedDefaultItem(arg3) then
                                return
                            end

                            if not arg._multiDelete or not arg._multiDelete[arg2] then
                                return
                            end
                            local markedDelete = arg._multiDelete[arg2][arg3]
                            if markedDelete and #markedDelete >= 1 then
                                return
                            end
                            arg._multiDelete[arg2][arg3] = arg._multiDelete[arg2][arg3] or {}
                            table.insert(arg._multiDelete[arg2][arg3], arg3)
                            local virtualItems = arg._virtualItems[arg2] and arg._virtualItems[arg2][arg3]

                            if virtualItems then
                                if virtualItems.InDeleteMulti then
                                    pcall(function()
                                        virtualItems.InDeleteMulti:Set(#arg._multiDelete[arg2][arg3])
                                    end)
                                end

                                pcall(function()
                                    virtualItems.ForceHide = true
                                    local inventoryPage = ShopController._inventoryPages[arg2]

                                    if inventoryPage then
                                        inventoryPage.MarkDirty(virtualItems, false, true)
                                    end
                                end)
                            end

                            arg:_updateMultiDelete()
                        end

                        local updateMultiDelete = ShopController._updateMultiDelete
                        local scrollingFrame = shop.Holder.DeleteItems.List.ContentsCanvas.ScrollingFrame

                        ShopController._updateMultiDelete = function(arg)
                            if not Library.Flags.Unlock_All or not arg._multiDelete then
                                return updateMultiDelete(arg)
                            end

                            for _, child in ipairs(scrollingFrame:GetChildren()) do
                                if child:IsA("GuiObject") and child:GetAttribute("_FakeEntry") then
                                    local attribute = child:GetAttribute("_FakeType")
                                    local name = child.Name

                                    if not attribute or not arg._multiDelete[attribute] or not arg._multiDelete[attribute][name] or #arg._multiDelete[attribute][name] <= 0 then
                                        child:Destroy()
                                    end
                                end
                            end

                            for k, value in pairs(arg._multiDelete) do
                                for k2, value in pairs(value) do
                                    if not (#value <= 0) then
                                        local label = scrollingFrame:FindFirstChild(k2)

                                        if label and not label:GetAttribute("_FakeEntry") then
                                            label = nil
                                        end

                                        if not label then
                                            local template2 = scrollingFrame:FindFirstChild("UIListLayout") and scrollingFrame.UIListLayout:FindFirstChild("Template")

                                            if template2 then
                                                local clone = template2:Clone()
                                                clone.Name = k2
                                                clone.Visible = true
                                                clone:SetAttribute("_FakeEntry", true)
                                                clone:SetAttribute("_FakeType", k)
                                                clone:SetAttribute("InventoryType", k)

                                                local function removeOneVirtualDelete()
                                                    if not arg._multiDelete or not arg._multiDelete[k] or not arg._multiDelete[k][k2] then
                                                        return
                                                    end
                                                    table.remove(arg._multiDelete[k][k2], 1)

                                                    if #arg._multiDelete[k][k2] <= 0 then
                                                        arg._multiDelete[k][k2] = nil
                                                        clone:Destroy()
                                                        refreshVirtualItem(arg._virtualItems[k] and arg._virtualItems[k][k2])
                                                    end

                                                    local virtualItems = arg._virtualItems[k] and arg._virtualItems[k][k2]

                                                    if virtualItems and virtualItems.InDeleteMulti then
                                                        pcall(function()
                                                            virtualItems.InDeleteMulti:Set(arg._multiDelete[k] and arg._multiDelete[k][k2] and #arg._multiDelete[k][k2] or 0)
                                                        end)
                                                    end

                                                    arg:_updateMultiDelete()
                                                end

                                                clone.Button.Activated:Connect(removeOneVirtualDelete)
                                                clone.Button.Item.Activated:Connect(removeOneVirtualDelete)
                                                clone.Parent = scrollingFrame
                                                label = clone
                                            end
                                        end

                                        if label then
                                            local itemInfo = ItemInfo[k] and ItemInfo[k][k2]
                                            label.Button.Label.Text = itemInfo and itemInfo.DisplayName or k2
                                            label.Button.Item.Label.Text = "x" .. #value

                                            if itemInfo and itemInfo.Icon then
                                                pcall(function()
                                                    label.Button.Item.Vector.Image = itemInfo.Icon
                                                end)
                                            end
                                        end
                                    end
                                end
                            end

                            updateMultiDelete(arg)
                        end

                        local originalDeleteHandler = nil
                        local originalCancelHandler = nil
                        local delete2 = shop.Holder.DeleteItems.List.Buttons.Delete
                        local cancel = shop.Holder.DeleteItems.List.Buttons.Cancel

                        for _, connection in getconnections(delete2.Activated) do
                            if connection and connection.Function then
                                originalDeleteHandler = connection.Function
                                connection:Disable()
                                break
                            end
                        end

                        for _, connection in getconnections(cancel.Activated) do
                            if connection and connection.Function then
                                originalCancelHandler = connection.Function
                                connection:Disable()
                                break
                            end
                        end

                        ConnectionsManager["Multi Delete Confirm"] = delete2.Activated:Connect(function()
                            if not Library.Flags.Unlock_All or not ShopController._multiDelete then
                                if originalDeleteHandler then
                                    return originalDeleteHandler()
                                end
                                return
                            end

                            local list2 = {}
                            local list3 = {}
                            local constant3 = 0
                            local n42 = 0

                            for k, value in pairs(ShopController._multiDelete) do
                                for k2, value in pairs(value) do
                                    if not (#value <= 0) then
                                        if not ownsInventoryItem(k, k2) then
                                            table.insert(list2, { type = k, name = k2 })
                                            constant3 += 1
                                        else
                                            list3[k] = list3[k] or {}

                                            for _, value in ipairs(value) do
                                                table.insert(list3[k], value)
                                            end

                                            n42 += #value
                                        end
                                    end
                                end
                            end

                            if constant3 + n42 == 0 then
                                clearMultiDelete()
                                return
                            end

                            DeleteItemPromptController:PromptConfirmation({
                                PromptType = "Single",
                                Description = "Are you sure you want to delete x" .. constant3 + n42 .. " items? This cannot be undone.",
                            }, function(arg)
                                if arg then
                                    for _, entry in list2 do
                                        removeVirtualUnlock(entry.type, entry.name)
                                    end

                                    buyButton.Visible = false
                                    shop.Holder.Favorite.Visible = false
                                    shop.Holder.InfoBG.Delete.Visible = false
                                    shop.Holder.InfoBG.Equips.EquipAccessory.Visible = false
                                    shop.Holder.InfoBG.Equips.Finisher.Visible = false
                                    clearMultiDelete()
                                    ShopController._selectedItem = nil
                                else
                                    for _, entry in list2 do
                                        refreshVirtualItem(ShopController._virtualItems[entry.type] and ShopController._virtualItems[entry.type][entry.name])
                                    end
                                end
                            end)
                        end)

                        ConnectionsManager["Multi Delete Cancel"] = cancel.Activated:Connect(function()
                            if not Library.Flags.Unlock_All then
                                if originalCancelHandler then
                                    return originalCancelHandler()
                                end
                                return
                            end

                            if ShopController._multiDelete then
                                for k, value in pairs(ShopController._multiDelete) do
                                    for k2, value in pairs(value) do
                                        if #value > 0 then
                                            refreshVirtualItem(ShopController._virtualItems[k] and ShopController._virtualItems[k][k2])

                                            task.defer(function()
                                                refreshVirtualItem(ShopController._virtualItems[k] and ShopController._virtualItems[k][k2])
                                            end)
                                        end
                                    end
                                end
                            end

                            clearMultiDelete()
                        end)
                    end)
                else
                    if SavedSwordModel then
                        local name = SavedSwordModel.Name
                        getgenv().Sword_Name = name
                        Player:SetAttribute("CurrentlyEquippedSword", SavedSwordModel.Name)
                        Swords:EquipSwordTo(Player.Character, SavedSwordModel.Name)
                        SetSword(SavedSwordModel.Name)
                    end

                    str10 = ""
                    if emoteGrid.TemplateVisible ~= nil then
                        local emoteWheel = game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("EmoteWheel")
                        local holder = emoteWheel.Wheel.Holder
                        local content = emoteWheel:WaitForChild("List"):WaitForChild("Content")
                        local template = game:GetService("Players").LocalPlayer.PlayerGui.EmoteWheel.List.Content.UIGridLayout:FindFirstChild("TEMPLATE")
                        local items = {}
                        local folder = ReplicatedStorage:FindFirstChild("Folder")

                        if folder then
                            folder.Parent = content
                        end

                        local uiGridLayout = content:FindFirstChildWhichIsA("UIGridLayout")

                        if uiGridLayout then
                            uiGridLayout.CellPadding = emoteGrid.LayoutCellPadding or UDim2.new(0, 8, 0, 8)
                            uiGridLayout.CellSize = emoteGrid.LayoutCellSize or UDim2.new(0.400000006, 0, 0.400000006, 0)
                            uiGridLayout.FillDirectionMaxCells = emoteGrid.FillDirectionMaxCells or 0
                            uiGridLayout.SortOrder = emoteGrid.SortOrder or Enum.SortOrder.LayoutOrder
                            content.ScrollingDirection = emoteGrid.ScrollingDirection or Enum.ScrollingDirection.Y
                            content.AutomaticCanvasSize = emoteGrid.AutomaticCanvasSize or Enum.AutomaticSize.Y
                        end

                        template.Visible = emoteGrid.TemplateVisible

                        for _, child in content:GetChildren() do
                            if child:IsA("Frame") or child:IsA("ImageButton") or child:IsA("ImageLabel") then
                                child:Destroy()
                            end
                        end

                        if emoteGrid.Entries then
                            for _, emoteEntry in emoteGrid.Entries do
                                emoteEntry:Clone().Parent = content
                            end
                        end

                        table.clear(items)
                        local page = require(ReplicatedStorage.Controllers.EmoteWheelController).page or 1

                        for _, child in holder:GetChildren() do
                            if child:IsA("ImageButton") then
                                local num = tonumber(child.Name)
                                local wheelSlot = emoteWheelSlots[page] and emoteWheelSlots[page][num]

                                if wheelSlot then
                                    child.Image = wheelSlot.Icon
                                    child:SetAttribute("EmoteId", wheelSlot.EmoteId)
                                    child:SetAttribute("EmoteName", wheelSlot.EmoteName)
                                    child:SetAttribute("Icon", wheelSlot.Icon)
                                    child:SetAttribute("GlobalSlot", wheelSlot.GlobalSlot)
                                end
                            end
                        end

                        if ConnectionsManager["Emote Wheel Refresh"] then
                            ConnectionsManager["Emote Wheel Refresh"]:Disconnect()
                            ConnectionsManager["Emote Wheel Refresh"] = nil
                        end

                        for _, child in Player.PlayerGui.EmoteWheel.Menu.Content:GetChildren() do
                            if child:IsA("ImageButton") then
                                local number = emoteMenuEntries[tonumber(child.Name)]

                                if number then
                                    child.Image = number.Icon
                                    child:SetAttribute("EmoteId", number.EmoteId)
                                    child:SetAttribute("EmoteName", number.EmoteName)
                                    child:SetAttribute("Icon", number.Icon)
                                    child:SetAttribute("GlobalSlot", number.GlobalSlot)
                                    local vector = child:FindFirstChild("Vector")
                                    local title = child:FindFirstChild("Title")

                                    if vector and number.VectorImage then
                                        vector.Image = number.VectorImage
                                    end

                                    if title and number.TitleText then
                                        title.Text = number.TitleText
                                    end
                                end
                            end
                        end
                        emoteGrid.TemplateVisible = nil
                    end

                    titleButtons = {}

                    for _, child in titleList:GetChildren() do
                        if child:IsA("ImageButton") or child:IsA("Frame") then
                            table.insert(titleButtons, child)
                        end
                    end

                    for _, titleButton in titleButtons do
                        if titleButton and titleButtonState[titleButton] then
                            titleButton.Name = titleButtonState[titleButton].Name
                            titleButton.Visible = titleButtonState[titleButton].Visible
                            titleButton.LayoutOrder = titleButtonState[titleButton].LayoutOrder
                            local textLabel = titleButton:FindFirstChild("TextLabel")

                            if textLabel then
                                textLabel.Text = titleButtonState[titleButton].LabelText
                                textLabel.TextColor3 = titleButtonState[titleButton].LabelColor
                            end

                            local selected = titleButton:FindFirstChild("Selected")

                            if selected then
                                selected.Visible = false
                            end
                        end
                    end

                    if originalFindItems then
                        hookfunction(Shared.FindItems, originalFindItems)
                    end

                    local ShopController = require(ReplicatedStorage.Controllers.UI.ShopController)

                    for k, ownedItem in ownedItems do
                        if k then
                            k.OwnsItem:Set(ownedItem.OwnsItem)
                            k.Section = "Unowned"
                            local inventoryPage = ShopController._inventoryPages[ownedItem.Category]

                            if inventoryPage and inventoryPage.MarkDirty then
                                inventoryPage.MarkDirty(k, false, true)
                            end
                        end

                        ownedItems[k] = nil
                    end

                    Player.PlayerGui.Shop.Holder.InfoBG.Delete.Visible = false
                    local attribute = Player:GetAttribute("CurrentlyEquippedSword")
                    local selectedItem = ShopController._selectedItem
                    if not selectedItem then
                        return
                    end
                    local buyButton = Player.PlayerGui.Shop.Holder.InfoBG.BuyButton

                    if selectedItem.name == attribute then
                        buyButton.PriceTag.TextLabel.Text = "Equipped"
                    else
                        buyButton.PriceTag.TextLabel.Text = "Equip"
                    end

                    if ConnectionsManager["Accessory Listener"] then
                        ConnectionsManager["Accessory Listener"]:Disconnect()
                        ConnectionsManager["Accessory Listener"] = nil
                    end
                end
            end,
        })
    end
end

local billboards

do
    ConnectionsManager["Weapon Animation Fixer"] = Player.CharacterAdded:Connect(function(character)
        for _, connection in getconnections(character:GetAttributeChangedSignal("CurrentlyEquippedSword")) do
            if connection then
                connection:Disable()
            end
        end

        ConnectionsManager["Weapon Attribute"] = character:GetAttributeChangedSignal("CurrentlyEquippedSword"):Connect(function()
            if not Library.Flags.Unlock_All then
                return
            end
            local attribute = character:GetAttribute("CurrentlyEquippedSword")
            local swordName = getgenv().Sword_Name

            if attribute ~= swordName then
                character:SetAttribute("CurrentlyEquippedSword", swordName)
            end

            if swordName then
                Swords:EquipSwordTo(character, swordName)
                SetSword(swordName)
            end
        end)
    end)

    ConnectionsManager["Infinity Ball"] = ReplicatedStorage.Remotes.InfinityBall.OnClientEvent:Connect(function(arg, arg2)
        InfinityBall = arg2
    end)

    ConnectionsManager["Parry Animation Fix"] = ReplicatedStorage.Remotes.ParrySuccess.OnClientEvent:Connect(function()
        BypassCooldown = true
        local character = Player.Character
        local humanoid = character and character:FindFirstChild("Humanoid")
        local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")

        if animator then
            for _, track in animator:GetPlayingAnimationTracks() do
                if track:GetAttribute("GrabParry") or track:GetAttribute("Parry") or track.Name == "GrabParry" or track.Name == "Grab" then
                    track:Stop(track:GetAttribute("StopFadeTime") or 0.1)
                end
            end
        end
    end)

    ConnectionsManager["Weapon Changer Event"] = ReplicatedStorage.Remotes.ParrySuccessAll.OnClientEvent:Connect(function(...)
        local varargs = { ... }
        local name = Player.Name

        if tostring(varargs[4]) == name then
            local sword2 = Swords:GetSword(Player:GetAttribute("CurrentlyEquippedSword"))

            if sword2 and sword2.SlashName then
                varargs[1] = sword2.SlashName
                varargs[3] = sword2.Name
            end
        end

        return PlayParry(unpack(varargs))
    end)

    billboards = {}

    AutoParry.Apply = function(arg, arg2)
        for k, passedValue in arg2 do
            arg[k] = passedValue
        end
    end

    AutoParry.Billboard = function(arg, arg2)
        if arg == Player then
            return
        end
        local head = (arg2 or arg.Character or arg.CharacterAdded:Wait()):WaitForChild("Head")
        local billboardGui = Instance.new("BillboardGui")

        AutoParry.Apply(billboardGui, {
            Adornee = head,
            Size = UDim2.new(0, 200, 0, 50),
            StudsOffset = Vector3.new(0, 3, 0),
            AlwaysOnTop = true,
            Parent = head,
        })

        local textLabel = Instance.new("TextLabel")

        AutoParry.Apply(textLabel, {
            Size = UDim2.new(1, 0, 1, 0),
            Text = "",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 15,
            TextWrapped = false,
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Center,
            TextYAlignment = Enum.TextYAlignment.Center,
            Parent = billboardGui,
        })

        billboards[arg] = textLabel
    end

    do
        local passiveAbilities = {
            "Quad Jump",
            "Luck",
            "Reaper",
            "Misfortune",
            "Martyrdom",
            "Golden Ball",
            "Tact",
            "Scopophobia",
            "Bounty",
            "Qi-Charge",
            "Guardian Angel",
            "Virus",
        }

        local chargeAbilities = {
            ["Guardian Angel"] = { ChargeAttr = "GuardianAngelParriesLeft", MaxCharges = 2 },
            ["Quantum Arena"] = { ChargeAttr = "QuantumArenaCharge", MaxCharges = 3 },
            Necromancer = { ChargeAttr = "NecromancersLeft", MaxCharges = 3 },
            Blink = { ChargeAttr = "BlinkLeft", MaxCharges = 3 },
        }

        GetChargeInfo = function(arg, arg2)
            local chargeInfo = chargeAbilities[arg2]
            if not chargeInfo then
                return nil
            end
            local playerFromCharacter = game.Players:GetPlayerFromCharacter(arg)
            local passed = nil

            if arg:GetAttribute(chargeInfo.ChargeAttr) ~= nil then
                passed = arg
            end

            if not (not passed and playerFromCharacter and playerFromCharacter:GetAttribute(chargeInfo.ChargeAttr) ~= nil) then
                playerFromCharacter = passed
            end

            if not playerFromCharacter then
                local abilities = arg:FindFirstChild("Abilities")

                if abilities and abilities:GetAttribute(chargeInfo.ChargeAttr) ~= nil then
                    playerFromCharacter = abilities
                end
            end

            playerFromCharacter = playerFromCharacter or arg
            local attribute = playerFromCharacter:GetAttribute(chargeInfo.ChargeAttr) or 0
            local maxCharges = chargeInfo.MaxCharges or 2

            if chargeInfo.MaxChargesAttr then
                maxCharges = playerFromCharacter:GetAttribute(chargeInfo.MaxChargesAttr) or maxCharges
            end

            local n41 = nil

            if chargeInfo.NextUseAttr then
                local attribute2 = playerFromCharacter:GetAttribute(chargeInfo.NextUseAttr)
                n41 = nil

                if attribute2 then
                    local n42 = attribute2 - workspace:GetServerTimeNow()
                    n41 = nil

                    if n42 > 0 then
                        n41 = tick() + n42
                    end
                end
            end

            return { Charges = attribute, MaxCharges = maxCharges, CDEnd = n41 }
        end

        local abilityStart = {}
        local abilityCooldown = {}
        local abilityEnds = {}
        local abilityDuration = {}
        local abilityActive = {}
        local Abilities = require(game:GetService("ReplicatedStorage").Shared.Abilities)
        local dribbleUses = {}
        local dribbleCooldowns = {}

        ConnectionsManager["Dribble Event Monitor"] = workspace.Alive.DescendantAdded:Connect(function(descendant)
            if descendant.Name ~= "DRIBBLE_IMMUNITY" then
                return
            end
            local model = descendant:FindFirstAncestorOfClass("Model")
            local playerFromCharacter = model and Players:GetPlayerFromCharacter(model)
            if not playerFromCharacter then
                return
            end

            if dribbleUses[playerFromCharacter] == nil then
                dribbleUses[playerFromCharacter] = 3
            end

            dribbleUses[playerFromCharacter] = math.max(dribbleUses[playerFromCharacter] - 1, 0)
            local cooldown = Abilities.getAbilityCooldown(playerFromCharacter, "Dribble")

            if cooldown and cooldown > 0 then
                dribbleCooldowns[playerFromCharacter] = dribbleCooldowns[playerFromCharacter] or {}
                table.insert(dribbleCooldowns[playerFromCharacter], workspace:GetServerTimeNow() + cooldown)
            end
        end)

        local dragonUses = {}
        local dragonReady = {}

        ConnectionsManager["Dragon Spirit Event Monitor"] = workspace.Runtime.ChildAdded:Connect(function(child)
            if child.Name ~= "GUARDIAN_DRAGON" then
                return
            end

            for _, player in Players:GetPlayers() do
                if player:GetAttribute("EquippedAbility") == "Dragon Spirit" then
                    if dragonUses[player] == nil then
                        dragonUses[player] = 3
                    end

                    dragonUses[player] = math.max(dragonUses[player] - 1, 0)
                    local cooldown = Abilities.getAbilityCooldown(player, "Dragon Spirit")

                    if cooldown and cooldown > 0 then
                        local serverTimeNow = workspace:GetServerTimeNow()

                        if not dragonReady[player] or dragonReady[player] <= serverTimeNow then
                            dragonReady[player] = serverTimeNow + cooldown - 1
                        end
                    end
                end
            end
        end)

        local activeAbility = {}

        right:Create_Toggle({
            name = "Ability ESP",
            flag = "Ability_ESP",
            callback = function(arg)
                if arg then
                    ConnectionsManager["Ability ESP"] = RunService.Heartbeat:Connect(function()
                        local alive = workspace.Alive
                        local dataAbilities = ReplicatedStorage.Misc.DataAbilities

                        for k, dribbleTimes in dribbleCooldowns do
                            if dribbleUses[k] and dribbleUses[k] < 3 then
                                local serverTimeNow = workspace:GetServerTimeNow()

                                for i = #dribbleTimes, 1, -1 do
                                    if dribbleTimes[i] <= serverTimeNow then
                                        dribbleUses[k] = math.min(dribbleUses[k] + 1, 3)
                                        table.remove(dribbleTimes, i)
                                    end
                                end
                            end
                        end

                        for k, dragonReadyAt in dragonReady do
                            if dragonUses[k] and dragonUses[k] < 3 then
                                local serverTimeNow = workspace:GetServerTimeNow()

                                if dragonReadyAt <= serverTimeNow then
                                    dragonUses[k] = math.min(dragonUses[k] + 1, 3)

                                    if dragonUses[k] < 3 then
                                        dragonReady[k] = serverTimeNow + Abilities.getAbilityCooldown(k, "Dragon Spirit")
                                    else
                                        dragonReady[k] = nil
                                    end
                                end
                            end
                        end

                        for _, player in Players:GetPlayers() do
                            if player and player ~= Player and player.Character then
                                local attribute = player.Character:GetAttribute("AbilityActive") or false
                                local flag25 = abilityActive[player]

                                if flag25 == nil then
                                    flag25 = false
                                end

                                local attribute2, billboard, parent, abilityImage, attribute3, attribute4, upgrades, n41, flag26, cooldownEnds, flag27, chargeInfo, str10, n42, dribbleTimes, nextReady, n43, dragonLeft, n44, dragonReadyAt, n45, chargeInfo2, n46, character, abilityEnd, n47, startedAt, cooldownEnds2, n48, flag28

                                if attribute == flag25 then
                                    attribute2 = player:GetAttribute("EquippedAbility")
                                    billboard = billboards[player]

                                    if billboard then
                                        parent = billboard.Parent
                                        abilityImage = parent:FindFirstChild("AbilityImage")

                                        if player.Character.Parent == alive then
                                            billboard.Visible = true

                                            if attribute2 then
                                                attribute3 = dataAbilities:FindFirstChild(attribute2)
                                                attribute4 = attribute3 and attribute3:GetAttribute("Icon")
                                                attribute3 = attribute3 and attribute3:GetAttribute("Icon1")
                                                upgrades = player:FindFirstChild("Upgrades")
                                                upgrades = upgrades and upgrades:FindFirstChild(attribute2)
                                                upgrades = upgrades and upgrades.Value
                                                n41 = upgrades or 0

                                                if 0 < n41 then
                                                    flag26 = attribute3 and attribute3 ~= ""

                                                    if flag26 then
                                                        attribute4 = attribute3
                                                    end
                                                end

                                                cooldownEnds = abilityCooldown[player]
                                                flag27 = not player.Character:GetAttribute("AbilityActive") and not cooldownEnds
                                                chargeInfo = chargeAbilities[attribute2]

                                                if table.find(passiveAbilities, attribute2) then
                                                    str10 = "Passive"
                                                elseif attribute2 == "Dribble" then
                                                    n42 = dribbleUses[player] or 3
                                                    str10 = string.format("%d/%d Uses", n42, 3)
                                                    dribbleTimes = dribbleCooldowns[player]
                                                    nextReady = dribbleTimes and dribbleTimes[1]

                                                    if nextReady then
                                                        n43 = dribbleTimes[1] - workspace:GetServerTimeNow()

                                                        if n43 > 0 then
                                                            str10 ..= string.format(" (%.1fs)", n43)
                                                        end
                                                    end
                                                elseif attribute2 == "Dragon Spirit" then
                                                    dragonLeft = dragonUses[player]
                                                    n44 = dragonLeft or 3
                                                    str10 = string.format("%d/%d Charges", n44, 3)
                                                    dragonReadyAt = dragonReady[player]

                                                    if dragonReadyAt then
                                                        n45 = dragonReadyAt - workspace:GetServerTimeNow()

                                                        if n45 > 0 then
                                                            str10 ..= string.format(" (%.1fs)", n45)
                                                        end
                                                    end
                                                elseif chargeInfo then
                                                    chargeInfo2 = GetChargeInfo(player.Character, attribute2)

                                                    if chargeInfo2 then
                                                        str10 = string.format("%d/%d Charges", chargeInfo2.Charges, chargeInfo2.MaxCharges)

                                                        if chargeInfo2.CDEnd then
                                                            n46 = chargeInfo2.CDEnd - workspace:GetServerTimeNow()

                                                            if 0 < n46 then
                                                                str10 ..= string.format(" (%.1fs)", n46)
                                                            end
                                                        end
                                                    else
                                                        str10 = "Charged"
                                                    end
                                                else
                                                    character = player.Character

                                                    if character:GetAttribute("AbilityActive") then
                                                        abilityEnd = abilityEnds[player]

                                                        if abilityEnd then
                                                            n47 = abilityEnd - workspace:GetServerTimeNow()

                                                            if n47 > 0 then
                                                                str10 = string.format("ACTIVE %.1fs", n47)
                                                            else
                                                                str10 = "No Active CD"
                                                            end
                                                        else
                                                            startedAt = abilityStart[player]
                                                            str10 = ""

                                                            if startedAt then
                                                                str10 = string.format("ACTIVE %.1fs", workspace:GetServerTimeNow() - startedAt)
                                                            end
                                                        end
                                                    else
                                                        cooldownEnds2 = abilityCooldown[player]

                                                        if cooldownEnds2 then
                                                            n48 = cooldownEnds2 - workspace:GetServerTimeNow()

                                                            if n48 > 0 then
                                                                str10 = string.format("%.1fs", n48)
                                                            else
                                                                abilityCooldown[player] = nil
                                                                str10 = "Ready"
                                                            end
                                                        else
                                                            str10 = ""

                                                            if flag27 then
                                                                str10 = "Ready"
                                                            end
                                                        end
                                                    end
                                                end

                                                billboard.Text = player.DisplayName .. " [" .. attribute2 .. " | " .. str10 .. "]"

                                                if not abilityImage then
                                                    abilityImage = Instance.new("ImageLabel")
                                                    abilityImage.Name = "AbilityImage"
                                                    abilityImage.BackgroundTransparency = 1
                                                    abilityImage.Size = UDim2.new(0, 30, 0, 31)
                                                    abilityImage.Parent = parent
                                                    abilityImage.Position = UDim2.new(0.5, -31, 0, 0)
                                                end

                                                abilityImage.Position = UDim2.new(0.5, -15, 0, -billboard.TextBounds.Y)
                                                flag28 = attribute4 and attribute4 ~= ""

                                                if flag28 then
                                                    abilityImage.Image = attribute4
                                                    abilityImage.Visible = true
                                                else
                                                    abilityImage.Visible = false
                                                end
                                            else
                                                billboard.Visible = false
                                                billboard.Text = player.DisplayName

                                                if abilityImage then
                                                    abilityImage.Visible = false
                                                end
                                            end
                                        else
                                            billboard.Visible = false

                                            if abilityImage then
                                                abilityImage.Visible = false
                                            end
                                        end
                                    end
                                else
                                    player:GetAttribute("EquippedAbility")

                                    if attribute then
                                        local attribute5 = player:GetAttribute("EquippedAbility")

                                        if not attribute5 then
                                            abilityActive[player] = attribute
                                        else
                                            local cooldown = Abilities.getAbilityCooldown(player, attribute5)
                                            local serverTimeNow = workspace:GetServerTimeNow()
                                            abilityStart[player] = serverTimeNow
                                            activeAbility[player] = attribute5
                                            local duration = abilityDuration[attribute5]

                                            if duration then
                                                abilityEnds[player] = serverTimeNow + duration
                                            else
                                                abilityEnds[player] = nil
                                            end

                                            if cooldown and cooldown > 0 then
                                                abilityCooldown[player] = serverTimeNow + cooldown
                                                abilityActive[player] = attribute
                                                attribute2 = player:GetAttribute("EquippedAbility")
                                                billboard = billboards[player]

                                                if billboard then
                                                    parent = billboard.Parent
                                                    abilityImage = parent:FindFirstChild("AbilityImage")

                                                    if player.Character.Parent == alive then
                                                        billboard.Visible = true

                                                        if attribute2 then
                                                            attribute3 = dataAbilities:FindFirstChild(attribute2)
                                                            attribute4 = attribute3 and attribute3:GetAttribute("Icon")
                                                            attribute3 = attribute3 and attribute3:GetAttribute("Icon1")
                                                            upgrades = player:FindFirstChild("Upgrades")
                                                            upgrades = upgrades and upgrades:FindFirstChild(attribute2)
                                                            upgrades = upgrades and upgrades.Value
                                                            n41 = upgrades or 0

                                                            if 0 < n41 then
                                                                flag26 = attribute3 and attribute3 ~= ""

                                                                if flag26 then
                                                                    attribute4 = attribute3
                                                                end
                                                            end

                                                            cooldownEnds = abilityCooldown[player]
                                                            flag27 = not player.Character:GetAttribute("AbilityActive") and not cooldownEnds
                                                            chargeInfo = chargeAbilities[attribute2]

                                                            if table.find(passiveAbilities, attribute2) then
                                                                str10 = "Passive"
                                                            elseif attribute2 == "Dribble" then
                                                                n42 = dribbleUses[player] or 3
                                                                str10 = string.format("%d/%d Uses", n42, 3)
                                                                dribbleTimes = dribbleCooldowns[player]
                                                                nextReady = dribbleTimes and dribbleTimes[1]

                                                                if nextReady then
                                                                    n43 = dribbleTimes[1] - workspace:GetServerTimeNow()

                                                                    if n43 > 0 then
                                                                        str10 ..= string.format(" (%.1fs)", n43)
                                                                    end
                                                                end
                                                            elseif attribute2 == "Dragon Spirit" then
                                                                dragonLeft = dragonUses[player]
                                                                n44 = dragonLeft or 3
                                                                str10 = string.format("%d/%d Charges", n44, 3)
                                                                dragonReadyAt = dragonReady[player]

                                                                if dragonReadyAt then
                                                                    n45 = dragonReadyAt - workspace:GetServerTimeNow()

                                                                    if n45 > 0 then
                                                                        str10 ..= string.format(" (%.1fs)", n45)
                                                                    end
                                                                end
                                                            elseif chargeInfo then
                                                                chargeInfo2 = GetChargeInfo(player.Character, attribute2)

                                                                if chargeInfo2 then
                                                                    str10 = string.format("%d/%d Charges", chargeInfo2.Charges, chargeInfo2.MaxCharges)

                                                                    if chargeInfo2.CDEnd then
                                                                        n46 = chargeInfo2.CDEnd - workspace:GetServerTimeNow()

                                                                        if 0 < n46 then
                                                                            str10 ..= string.format(" (%.1fs)", n46)
                                                                        end
                                                                    end
                                                                else
                                                                    str10 = "Charged"
                                                                end
                                                            else
                                                                character = player.Character

                                                                if character:GetAttribute("AbilityActive") then
                                                                    abilityEnd = abilityEnds[player]

                                                                    if abilityEnd then
                                                                        n47 = abilityEnd - workspace:GetServerTimeNow()

                                                                        if n47 > 0 then
                                                                            str10 = string.format("ACTIVE %.1fs", n47)
                                                                        else
                                                                            str10 = "No Active CD"
                                                                        end
                                                                    else
                                                                        startedAt = abilityStart[player]
                                                                        str10 = ""

                                                                        if startedAt then
                                                                            str10 = string.format("ACTIVE %.1fs", workspace:GetServerTimeNow() - startedAt)
                                                                        end
                                                                    end
                                                                else
                                                                    cooldownEnds2 = abilityCooldown[player]

                                                                    if cooldownEnds2 then
                                                                        n48 = cooldownEnds2 - workspace:GetServerTimeNow()

                                                                        if n48 > 0 then
                                                                            str10 = string.format("%.1fs", n48)
                                                                        else
                                                                            abilityCooldown[player] = nil
                                                                            str10 = "Ready"
                                                                        end
                                                                    else
                                                                        str10 = ""

                                                                        if flag27 then
                                                                            str10 = "Ready"
                                                                        end
                                                                    end
                                                                end
                                                            end

                                                            billboard.Text = player.DisplayName .. " [" .. attribute2 .. " | " .. str10 .. "]"

                                                            if not abilityImage then
                                                                abilityImage = Instance.new("ImageLabel")
                                                                abilityImage.Name = "AbilityImage"
                                                                abilityImage.BackgroundTransparency = 1
                                                                abilityImage.Size = UDim2.new(0, 30, 0, 31)
                                                                abilityImage.Parent = parent
                                                                abilityImage.Position = UDim2.new(0.5, -31, 0, 0)
                                                            end

                                                            abilityImage.Position = UDim2.new(0.5, -15, 0, -billboard.TextBounds.Y)
                                                            flag28 = attribute4 and attribute4 ~= ""

                                                            if flag28 then
                                                                abilityImage.Image = attribute4
                                                                abilityImage.Visible = true
                                                            else
                                                                abilityImage.Visible = false
                                                            end
                                                        else
                                                            billboard.Visible = false
                                                            billboard.Text = player.DisplayName

                                                            if abilityImage then
                                                                abilityImage.Visible = false
                                                            end
                                                        end
                                                    else
                                                        billboard.Visible = false

                                                        if abilityImage then
                                                            abilityImage.Visible = false
                                                        end
                                                    end
                                                end
                                            else
                                                abilityActive[player] = attribute
                                                attribute2 = player:GetAttribute("EquippedAbility")
                                                billboard = billboards[player]

                                                if billboard then
                                                    parent = billboard.Parent
                                                    abilityImage = parent:FindFirstChild("AbilityImage")

                                                    if player.Character.Parent == alive then
                                                        billboard.Visible = true

                                                        if attribute2 then
                                                            attribute3 = dataAbilities:FindFirstChild(attribute2)
                                                            attribute4 = attribute3 and attribute3:GetAttribute("Icon")
                                                            attribute3 = attribute3 and attribute3:GetAttribute("Icon1")
                                                            upgrades = player:FindFirstChild("Upgrades")
                                                            upgrades = upgrades and upgrades:FindFirstChild(attribute2)
                                                            upgrades = upgrades and upgrades.Value
                                                            n41 = upgrades or 0

                                                            if 0 < n41 then
                                                                flag26 = attribute3 and attribute3 ~= ""

                                                                if flag26 then
                                                                    attribute4 = attribute3
                                                                end
                                                            end

                                                            cooldownEnds = abilityCooldown[player]
                                                            flag27 = not player.Character:GetAttribute("AbilityActive") and not cooldownEnds
                                                            chargeInfo = chargeAbilities[attribute2]

                                                            if table.find(passiveAbilities, attribute2) then
                                                                str10 = "Passive"
                                                            elseif attribute2 == "Dribble" then
                                                                n42 = dribbleUses[player] or 3
                                                                str10 = string.format("%d/%d Uses", n42, 3)
                                                                dribbleTimes = dribbleCooldowns[player]
                                                                nextReady = dribbleTimes and dribbleTimes[1]

                                                                if nextReady then
                                                                    n43 = dribbleTimes[1] - workspace:GetServerTimeNow()

                                                                    if n43 > 0 then
                                                                        str10 ..= string.format(" (%.1fs)", n43)
                                                                    end
                                                                end
                                                            elseif attribute2 == "Dragon Spirit" then
                                                                dragonLeft = dragonUses[player]
                                                                n44 = dragonLeft or 3
                                                                str10 = string.format("%d/%d Charges", n44, 3)
                                                                dragonReadyAt = dragonReady[player]

                                                                if dragonReadyAt then
                                                                    n45 = dragonReadyAt - workspace:GetServerTimeNow()

                                                                    if n45 > 0 then
                                                                        str10 ..= string.format(" (%.1fs)", n45)
                                                                    end
                                                                end
                                                            elseif chargeInfo then
                                                                chargeInfo2 = GetChargeInfo(player.Character, attribute2)

                                                                if chargeInfo2 then
                                                                    str10 = string.format("%d/%d Charges", chargeInfo2.Charges, chargeInfo2.MaxCharges)

                                                                    if chargeInfo2.CDEnd then
                                                                        n46 = chargeInfo2.CDEnd - workspace:GetServerTimeNow()

                                                                        if 0 < n46 then
                                                                            str10 ..= string.format(" (%.1fs)", n46)
                                                                        end
                                                                    end
                                                                else
                                                                    str10 = "Charged"
                                                                end
                                                            else
                                                                character = player.Character

                                                                if character:GetAttribute("AbilityActive") then
                                                                    abilityEnd = abilityEnds[player]

                                                                    if abilityEnd then
                                                                        n47 = abilityEnd - workspace:GetServerTimeNow()

                                                                        if n47 > 0 then
                                                                            str10 = string.format("ACTIVE %.1fs", n47)
                                                                        else
                                                                            str10 = "No Active CD"
                                                                        end
                                                                    else
                                                                        startedAt = abilityStart[player]
                                                                        str10 = ""

                                                                        if startedAt then
                                                                            str10 = string.format("ACTIVE %.1fs", workspace:GetServerTimeNow() - startedAt)
                                                                        end
                                                                    end
                                                                else
                                                                    cooldownEnds2 = abilityCooldown[player]

                                                                    if cooldownEnds2 then
                                                                        n48 = cooldownEnds2 - workspace:GetServerTimeNow()

                                                                        if n48 > 0 then
                                                                            str10 = string.format("%.1fs", n48)
                                                                        else
                                                                            abilityCooldown[player] = nil
                                                                            str10 = "Ready"
                                                                        end
                                                                    else
                                                                        str10 = ""

                                                                        if flag27 then
                                                                            str10 = "Ready"
                                                                        end
                                                                    end
                                                                end
                                                            end

                                                            billboard.Text = player.DisplayName .. " [" .. attribute2 .. " | " .. str10 .. "]"

                                                            if not abilityImage then
                                                                abilityImage = Instance.new("ImageLabel")
                                                                abilityImage.Name = "AbilityImage"
                                                                abilityImage.BackgroundTransparency = 1
                                                                abilityImage.Size = UDim2.new(0, 30, 0, 31)
                                                                abilityImage.Parent = parent
                                                                abilityImage.Position = UDim2.new(0.5, -31, 0, 0)
                                                            end

                                                            abilityImage.Position = UDim2.new(0.5, -15, 0, -billboard.TextBounds.Y)
                                                            flag28 = attribute4 and attribute4 ~= ""

                                                            if flag28 then
                                                                abilityImage.Image = attribute4
                                                                abilityImage.Visible = true
                                                            else
                                                                abilityImage.Visible = false
                                                            end
                                                        else
                                                            billboard.Visible = false
                                                            billboard.Text = player.DisplayName

                                                            if abilityImage then
                                                                abilityImage.Visible = false
                                                            end
                                                        end
                                                    else
                                                        billboard.Visible = false

                                                        if abilityImage then
                                                            abilityImage.Visible = false
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    else
                                        local startedAt2 = abilityStart[player]
                                        local abilityName = activeAbility[player]

                                        if startedAt2 and abilityName then
                                            local n49 = workspace:GetServerTimeNow() - startedAt2
                                            local duration2 = abilityDuration[abilityName]

                                            if duration2 then
                                                abilityDuration[abilityName] = (duration2 + n49) / 2
                                            else
                                                abilityDuration[abilityName] = n49
                                            end
                                        end

                                        abilityStart[player] = nil
                                        abilityEnds[player] = nil
                                        activeAbility[player] = nil
                                        abilityActive[player] = attribute
                                        attribute2 = player:GetAttribute("EquippedAbility")
                                        billboard = billboards[player]

                                        if billboard then
                                            parent = billboard.Parent
                                            abilityImage = parent:FindFirstChild("AbilityImage")

                                            if player.Character.Parent == alive then
                                                billboard.Visible = true

                                                if attribute2 then
                                                    attribute3 = dataAbilities:FindFirstChild(attribute2)
                                                    attribute4 = attribute3 and attribute3:GetAttribute("Icon")
                                                    attribute3 = attribute3 and attribute3:GetAttribute("Icon1")
                                                    upgrades = player:FindFirstChild("Upgrades")
                                                    upgrades = upgrades and upgrades:FindFirstChild(attribute2)
                                                    upgrades = upgrades and upgrades.Value
                                                    n41 = upgrades or 0

                                                    if 0 < n41 then
                                                        flag26 = attribute3 and attribute3 ~= ""

                                                        if flag26 then
                                                            attribute4 = attribute3
                                                        end
                                                    end

                                                    cooldownEnds = abilityCooldown[player]
                                                    flag27 = not player.Character:GetAttribute("AbilityActive") and not cooldownEnds
                                                    chargeInfo = chargeAbilities[attribute2]

                                                    if table.find(passiveAbilities, attribute2) then
                                                        str10 = "Passive"
                                                    elseif attribute2 == "Dribble" then
                                                        n42 = dribbleUses[player] or 3
                                                        str10 = string.format("%d/%d Uses", n42, 3)
                                                        dribbleTimes = dribbleCooldowns[player]
                                                        nextReady = dribbleTimes and dribbleTimes[1]

                                                        if nextReady then
                                                            n43 = dribbleTimes[1] - workspace:GetServerTimeNow()

                                                            if n43 > 0 then
                                                                str10 ..= string.format(" (%.1fs)", n43)
                                                            end
                                                        end
                                                    elseif attribute2 == "Dragon Spirit" then
                                                        dragonLeft = dragonUses[player]
                                                        n44 = dragonLeft or 3
                                                        str10 = string.format("%d/%d Charges", n44, 3)
                                                        dragonReadyAt = dragonReady[player]

                                                        if dragonReadyAt then
                                                            n45 = dragonReadyAt - workspace:GetServerTimeNow()

                                                            if n45 > 0 then
                                                                str10 ..= string.format(" (%.1fs)", n45)
                                                            end
                                                        end
                                                    elseif chargeInfo then
                                                        chargeInfo2 = GetChargeInfo(player.Character, attribute2)

                                                        if chargeInfo2 then
                                                            str10 = string.format("%d/%d Charges", chargeInfo2.Charges, chargeInfo2.MaxCharges)

                                                            if chargeInfo2.CDEnd then
                                                                n46 = chargeInfo2.CDEnd - workspace:GetServerTimeNow()

                                                                if 0 < n46 then
                                                                    str10 ..= string.format(" (%.1fs)", n46)
                                                                end
                                                            end
                                                        else
                                                            str10 = "Charged"
                                                        end
                                                    else
                                                        character = player.Character

                                                        if character:GetAttribute("AbilityActive") then
                                                            abilityEnd = abilityEnds[player]

                                                            if abilityEnd then
                                                                n47 = abilityEnd - workspace:GetServerTimeNow()

                                                                if n47 > 0 then
                                                                    str10 = string.format("ACTIVE %.1fs", n47)
                                                                else
                                                                    str10 = "No Active CD"
                                                                end
                                                            else
                                                                startedAt = abilityStart[player]
                                                                str10 = ""

                                                                if startedAt then
                                                                    str10 = string.format("ACTIVE %.1fs", workspace:GetServerTimeNow() - startedAt)
                                                                end
                                                            end
                                                        else
                                                            cooldownEnds2 = abilityCooldown[player]

                                                            if cooldownEnds2 then
                                                                n48 = cooldownEnds2 - workspace:GetServerTimeNow()

                                                                if n48 > 0 then
                                                                    str10 = string.format("%.1fs", n48)
                                                                else
                                                                    abilityCooldown[player] = nil
                                                                    str10 = "Ready"
                                                                end
                                                            else
                                                                str10 = ""

                                                                if flag27 then
                                                                    str10 = "Ready"
                                                                end
                                                            end
                                                        end
                                                    end

                                                    billboard.Text = player.DisplayName .. " [" .. attribute2 .. " | " .. str10 .. "]"

                                                    if not abilityImage then
                                                        abilityImage = Instance.new("ImageLabel")
                                                        abilityImage.Name = "AbilityImage"
                                                        abilityImage.BackgroundTransparency = 1
                                                        abilityImage.Size = UDim2.new(0, 30, 0, 31)
                                                        abilityImage.Parent = parent
                                                        abilityImage.Position = UDim2.new(0.5, -31, 0, 0)
                                                    end

                                                    abilityImage.Position = UDim2.new(0.5, -15, 0, -billboard.TextBounds.Y)
                                                    flag28 = attribute4 and attribute4 ~= ""

                                                    if flag28 then
                                                        abilityImage.Image = attribute4
                                                        abilityImage.Visible = true
                                                    else
                                                        abilityImage.Visible = false
                                                    end
                                                else
                                                    billboard.Visible = false
                                                    billboard.Text = player.DisplayName

                                                    if abilityImage then
                                                        abilityImage.Visible = false
                                                    end
                                                end
                                            else
                                                billboard.Visible = false

                                                if abilityImage then
                                                    abilityImage.Visible = false
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end)
                else
                    for _, abilityName in billboards do
                        abilityName.Visible = false
                        local abilityImage = abilityName.Parent:FindFirstChild("AbilityImage")

                        if abilityImage then
                            abilityImage.Visible = false
                        end
                    end

                    if ConnectionsManager["Ability ESP"] then
                        ConnectionsManager["Ability ESP"]:Disconnect()
                        ConnectionsManager["Ability ESP"] = nil
                    end
                end
            end,
        })
    end
end

do
    do
        local slotNumber

        do
            slotNumber = nil

            do
                local callResult = nil

                AutoParry.Default_Avatar = function()
                    if callResult then
                        return callResult
                    end

                    local ok, result = pcall(function()
                        return Players:GetHumanoidDescriptionFromUserId(Player.UserId)
                    end)

                    if ok and result then
                        callResult = result
                    end

                    return callResult
                end
            end
        end

        AutoParry.Weld_Accessory = function(arg, arg2)
            local handle = arg:FindFirstChild("Handle")
            if not handle then
                return
            end
            local attachment = handle:FindFirstChildOfClass("Attachment")
            if not attachment then
                return
            end
            local attachment2 = arg2:FindFirstChild(attachment.Name, true)

            if not attachment2 then
                return
            end

            local weld = Instance.new("Weld")
            weld.Name = "AccessoryWeld"
            weld.Part0 = handle
            weld.Part1 = attachment2.Parent
            weld.C0 = attachment.CFrame
            weld.C1 = attachment2.CFrame
            weld.Parent = handle
            handle.Anchored = false
        end

        AutoParry.Apply_Avatar = function(parent)
            local humanoid = parent:WaitForChild("Humanoid")
            if parent:GetAttribute("Applied") == slotNumber then
                return
            end
            parent:SetAttribute("Applied", slotNumber)

            local ok, result = pcall(function()
                return Players:GetHumanoidDescriptionFromUserId(slotNumber)
            end)

            if not ok or not result then
                parent:SetAttribute("Applied", nil)
                return
            end

            local function getMeshId(arg)
                if arg:IsA("MeshPart") then
                    return arg.MeshId
                end
                local specialMesh = arg:FindFirstChildOfClass("SpecialMesh")
                return specialMesh and specialMesh.MeshId or ""
            end

            local attribute = Player:GetAttribute("CurrentlyEquippedSword")

            for _, child in parent:GetChildren() do
                if child:IsA("Accessory") then
                    if child ~= attribute then
                        child:Destroy()
                    end
                elseif child:IsA("Shirt") or child:IsA("Pants") or child:IsA("ShirtGraphic") or child:IsA("BodyColors") or child:IsA("CharacterMesh") then
                    child:Destroy()
                end
            end

            local ok2, result2 = pcall(function()
                return Players:CreateHumanoidModelFromDescription(result, humanoid.RigType)
            end)

            if not ok2 or not result2 then
                parent:SetAttribute("Applied", nil)
                return
            end

            local function copyAttachments(arg, parent2)
                for _, child in ipairs(arg:GetChildren()) do
                    if child:IsA("Attachment") then
                        local matched = parent2:FindFirstChild(child.Name)

                        if matched then
                            matched.CFrame = child.CFrame
                            matched.Position = child.Position
                            matched.Orientation = child.Orientation
                            matched.Axis = child.Axis
                            matched.SecondaryAxis = child.SecondaryAxis
                        else
                            child:Clone().Parent = parent2
                        end
                    end
                end
            end

            for _, child in result2:GetChildren() do
                if child:IsA("BasePart") and child.Name ~= "HumanoidRootPart" then
                    local label = parent:FindFirstChild(child.Name)

                    if label then
                        if getMeshId(child) ~= getMeshId(label) then
                            local specialMesh = label:FindFirstChildOfClass("SpecialMesh")

                            if specialMesh then
                                specialMesh:Destroy()
                            end

                            local specialMesh2 = child:FindFirstChildOfClass("SpecialMesh")

                            if specialMesh2 then
                                specialMesh2:Clone().Parent = label
                            end

                            if child:IsA("MeshPart") and label:IsA("MeshPart") then
                                label.MeshId = child.MeshId
                                label.TextureID = child.TextureID
                                copyAttachments(child, label)
                            end
                        end
                    end
                elseif child:IsA("CharacterMesh") then
                    child:Clone().Parent = parent
                end
            end

            for _, child in result2:GetChildren() do
                if child:IsA("Shirt") or child:IsA("Pants") or child:IsA("ShirtGraphic") or child:IsA("BodyColors") then
                    child:Clone().Parent = parent
                elseif child:IsA("Accessory") then
                    local clone = child:Clone()
                    humanoid:AddAccessory(clone)
                    AutoParry.Weld_Accessory(clone, parent)
                end
            end

            local head = parent:FindFirstChild("Head")
            local head2 = result2:FindFirstChild("Head")

            if head and head2 then
                local decal = head:FindFirstChildOfClass("Decal")
                local decal2 = head2:FindFirstChildOfClass("Decal")

                if decal2 then
                    if decal then
                        decal.Texture = decal2.Texture
                    else
                        decal2:Clone().Parent = head
                    end
                elseif decal then
                    decal:Destroy()
                end
            end

            result2:Destroy()
        end

        do
            local Appearance = visualsTab:Create_Section("Appearance", "left")

            Appearance:Create_Toggle({
                name = "Avatar Changer",
                flag = "Avatar_Changer",
                callback = function(arg)
                    if arg then
                        if slotNumber then
                            AutoParry.Apply_Avatar(Player.Character or Player.CharacterAdded:Wait())

                            ConnectionsManager["Kill Feed Manager"] = Player.PlayerGui.KillFeed.Frame.ChildAdded:Connect(function(child)
                                local holder = child:FindFirstChild("Holder")
                                if not holder then
                                    return
                                end
                                holder.Left.Vector.Image = "rbxthumb://type=AvatarHeadShot&id=" .. slotNumber .. "&w=100&h=100"
                            end)
                        end

                        ConnectionsManager["Avatar Changer"] = Player.CharacterAppearanceLoaded:Connect(function()
                            AutoParry.Apply_Avatar(Player.Character or Player.CharacterAdded:Wait())
                        end)
                    else
                        local character = Player.Character or Player.CharacterAdded:Wait()
                        character:SetAttribute("Applied", nil)
                        local defaultAvatar = AutoParry.Default_Avatar()

                        if defaultAvatar then
                            local ok, result = pcall(function()
                                return Players:CreateHumanoidModelFromDescription(defaultAvatar, character.Humanoid.RigType)
                            end)

                            if ok and result then
                                local list = {}

                                for _, child in result:GetChildren() do
                                    if child:IsA("Accessory") then
                                        table.insert(list, child:Clone())
                                    end
                                end

                                for _, child in character:GetChildren() do
                                    if child:IsA("Shirt") or child:IsA("Pants") or child:IsA("ShirtGraphic") or child:IsA("Accessory") or child:IsA("BodyColors") or child:IsA("CharacterMesh") then
                                        child:Destroy()
                                    end
                                end

                                local function getMeshId(arg2)
                                    if arg2:IsA("MeshPart") then
                                        return arg2.MeshId
                                    end
                                    local specialMesh = arg2:FindFirstChildOfClass("SpecialMesh")
                                    return specialMesh and specialMesh.MeshId or ""
                                end

                                for _, child in result:GetChildren() do
                                    if child:IsA("BasePart") and child.Name ~= "HumanoidRootPart" then
                                        local label = character:FindFirstChild(child.Name)

                                        if label then
                                            if getMeshId(child) ~= getMeshId(label) then
                                                local specialMesh = label:FindFirstChildOfClass("SpecialMesh")

                                                if specialMesh then
                                                    specialMesh:Destroy()
                                                end

                                                local specialMesh2 = child:FindFirstChildOfClass("SpecialMesh")

                                                if specialMesh2 then
                                                    specialMesh2:Clone().Parent = label
                                                end

                                                if child:IsA("MeshPart") and label:IsA("MeshPart") then
                                                    label.MeshId = child.MeshId
                                                    label.TextureID = child.TextureID
                                                    label.Size = child.Size
                                                end
                                            end
                                        end
                                    elseif child:IsA("CharacterMesh") then
                                        child:Clone().Parent = character
                                    end
                                end

                                for _, child in result:GetChildren() do
                                    if child:IsA("Shirt") or child:IsA("Pants") or child:IsA("ShirtGraphic") or child:IsA("BodyColors") then
                                        child:Clone().Parent = character
                                    end
                                end

                                for _, entry in list do
                                    entry.Parent = character
                                    local handle = entry:FindFirstChild("Handle")

                                    if handle then
                                        local attachment = handle:FindFirstChildWhichIsA("Attachment", true)

                                        if attachment then
                                            local attachment2 = character:FindFirstChild(attachment.Name, true)

                                            if attachment2 then
                                                local weld = Instance.new("Weld")
                                                weld.Part0 = handle
                                                weld.Part1 = attachment2.Parent
                                                weld.C0 = attachment.CFrame
                                                weld.C1 = attachment2.CFrame
                                                weld.Parent = handle
                                            end
                                        end
                                    end
                                end

                                result:Destroy()
                            end
                        end

                        if ConnectionsManager["Avatar Changer"] then
                            ConnectionsManager["Avatar Changer"]:Disconnect()
                            ConnectionsManager["Avatar Changer"] = nil
                        end

                        if ConnectionsManager["Kill Feed Manager"] then
                            ConnectionsManager["Kill Feed Manager"]:Disconnect()
                            ConnectionsManager["Kill Feed Manager"] = nil
                        end
                    end
                end,
            })

            Appearance:Create_TextBox({
                name = "",
                placeholder = "...",
                default = "",
                flag = "Avatar_Saver",
                callback = function(arg)
                    if not arg or arg == "" then
                        Player.Character:SetAttribute("Applied", nil)
                        return
                    end
                    local num = tonumber(arg)

                    if not num then
                        local ok

                        repeat
                            task.wait()

                            ok, num = pcall(function()
                                return Players:GetUserIdFromNameAsync(arg)
                            end)
                        until ok
                    end

                    slotNumber = num

                    if Library.Flags.Avatar_Changer then
                        AutoParry.Apply_Avatar(Player.Character)

                        ConnectionsManager["Kill Feed Manager"] = Player.PlayerGui.KillFeed.Frame.ChildAdded:Connect(function(child)
                            local holder = child:FindFirstChild("Holder")
                            if not holder then
                                return
                            end
                            holder.Left.Vector.Image = "rbxthumb://type=AvatarHeadShot&id=" .. slotNumber .. "&w=100&h=100"
                        end)
                    end
                end,
            })
        end

        ConnectionsManager["Encrypted Clone Detection"] = workspace.Alive.ChildAdded:Connect(function(child)
            if child.Name:find("ENCRYPTED CLONE", 1, true) then
                if Library.Flags.Avatar_Changer then
                    local ok, result = pcall(function()
                        return Players:GetHumanoidDescriptionFromUserId(slotNumber)
                    end)

                    if ok and result then
                        local ok2, result2 = pcall(function()
                            return Players:CreateHumanoidModelFromDescription(result, child.Humanoid.RigType)
                        end)

                        if ok2 and result2 then
                            AutoParry.Apply_Avatar(child)
                        end
                    end
                end
            end
        end)
    end

    do
        local items = {}
        local FFlags = visualsTab:Create_Section("FFlags", "right")

        FFlags:Create_Toggle({
            name = "FFlags",
            flag = "FFlags_Toggle",
            callback = function(arg)
                if not arg then
                    if next(items) == nil then
                        return
                    end

                    for k, entry in items do
                        if getfflag(k) then
                            setfflag(k, entry)
                        end
                    end

                    table.clear(items)
                end
            end,
        })

        FFlags:Create_TextBox({
            name = "",
            placeholder = "...",
            default = "",
            flag = "FFlags_Saver",
            callback = function(arg)
                if not Library.Flags.FFlags_Toggle then
                    return
                end

                if arg == "" then
                    return
                end
                local n41 = 0

                for match, match2 in arg:gmatch("\"([^\"]+)\"%s*:%s*([^,%}%]]+)") do
                    local str10 = match2:gsub("^%s+", ""):gsub("%s+$", "")

                    if str10 == "true" then
                        str10 = "True"
                    elseif str10 == "false" then
                        str10 = "False"
                    elseif str10:match("^\".*\"$") then
                        str10 = str10:sub(2, -2)
                    end

                    local str11 = match:gsub("^DFInt", ""):gsub("^DFFlag", ""):gsub("^FString", ""):gsub("^FLog", ""):gsub("^FFlag", ""):gsub("^DFint", ""):gsub("^FInt", "")

                    if getfflag(str11) then
                        if items[str11] == nil then
                            items[str11] = tostring(getfflag(str11))
                        end

                        setfflag(str11, tostring(str10))
                        n41 += 1
                    elseif getfflag(match) then
                        if items[match] == nil then
                            items[match] = tostring(getfflag(match))
                        end

                        setfflag(match, tostring(str10))
                        n41 += 1
                    end
                end

                Library:Notify(("Applied %d FFlags."):format(n41), 5)
            end,
        })
    end
end

do
    local Devices = visualsTab:Create_Section("Devices", "left")

    Devices:Create_Toggle({
        name = "Auto Rejoin",
        flag = "Device_Spoofer_Toggle",
        callback = function(deviceSpooferToggle)
            Library.Flags.Device_Spoofer_Toggle = deviceSpooferToggle

            if deviceSpooferToggle then
                if Library.Flags.Device_Saved ~= "" then
                    Library:Notify("Apply Device Spoofer by rejoin", 5)
                end
            end
        end,
    })

    Devices:Create_Dropdown({
        name = "Device",
        options = { "PC", "Mobile", "Console" },
        default = "PC",
        flag = "Device_Spoofer_Saver",
        callback = function(deviceSaved)
            if deviceSaved == "Mobile" then
                deviceSaved = "Phone"
            end

            Library.Flags.Device_Saved = deviceSaved

            if writefile then
                writefile("Aries/Device_Spoofer_Device.txt", deviceSaved)
                writefile("Aries/air2.txt", "loadstring(game:HttpGet(\"https://gist.githubusercontent.com/Strvstys/7c189e78a6bc2d2b5eb013a7c1f25685/raw/b2a6dd94d98df3e1b74e791cce1765815cda95b1/tz.luau\"))()")
            end

            if Library.Flags.Device_Spoofer_Toggle then
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, Player)
            end

            pcall(queue_on_teleport, "loadstring(readfile(\"Aries/air2.txt\"))()")
        end,
    })
end

local protectionTab

do
    protectionTab = Library:Create_Tab({
        name = "Protection",
        section_name = "Settings",
        icon = "shield-half",
    })

    do
        local left = protectionTab:Create_Section("left")

        left:Create_Toggle({
            name = "Cooldown Protection",
            flag = "Cooldown_Protection",
            callback = function(cooldownProtection)
                getgenv().Cooldown_Protection = cooldownProtection
            end,
        })

        left:Create_Toggle({
            name = "Phantom Protection",
            flag = "Phantom_Detection",
            callback = function(phantomDetection)
                Library.Flags.Phantom_Detection = phantomDetection
                local parryAccuracy = Library.Flags.Parry_Accuracy

                if phantomDetection then
                    SpeedDivisorMultiplier = 0.8 + (parryAccuracy - 1) * 0.024747474747474751
                    parryAccuracySlider:SetValue(90)
                    parryRangeSlider:SetValue(0)
                else
                    SpeedDivisorMultiplier = 0.8 + (parryAccuracy - 1) * 0.0030303030303030303
                end
            end,
        })
    end
end

do
    local right2 = protectionTab:Create_Section("right")

    right2:Create_Toggle({
        name = "Auto Ability",
        flag = "Auto_Ability",
        callback = function(autoAbility)
            getgenv().Auto_Ability = autoAbility
        end,
    })

    right2:Create_Toggle({
        name = "Dribble Preclick",
        flag = "Dribble_Preclick",
        callback = function(arg)
            if arg then
                local now3 = 0

                ConnectionsManager["Dribble Monitor"] = workspace.Alive.DescendantAdded:Connect(function(descendant)
                    if descendant.Name == "DRIBBLE_IMMUNITY" then
                        if descendant.Parent == Player.Character then
                            return
                        end
                        now3 = tick()
                    end
                end)

                local function bindDribbleHighlight(character)
                    if ConnectionsManager["Dribble Highlight"] then
                        ConnectionsManager["Dribble Highlight"]:Disconnect()
                        ConnectionsManager["Dribble Highlight"] = nil
                    end

                    ConnectionsManager["Dribble Highlight"] = character.DescendantAdded:Connect(function(descendant)
                        if descendant.Name == "FAKE_HIGHLIGHT" then
                            if Library.Flags.AutoParry and arg and tick() - now3 <= 1 and not AutoParry.Is_Curved() then
                                AutoParry.Play_Animation()
                                AutoParry.Parry(Library.Flags.Parry_Type)
                            end
                        end
                    end)
                end

                if Player.Character then
                    bindDribbleHighlight(Player.Character)
                end

                ConnectionsManager["Character Added"] = Player.CharacterAdded:Connect(bindDribbleHighlight)
            else
                if ConnectionsManager["Dribble Monitor"] then
                    ConnectionsManager["Dribble Monitor"]:Disconnect()
                    ConnectionsManager["Dribble Monitor"] = nil
                end

                if ConnectionsManager["Dribble Highlight"] then
                    ConnectionsManager["Dribble Highlight"]:Disconnect()
                    ConnectionsManager["Dribble Highlight"] = nil
                end

                if ConnectionsManager["Character Added"] then
                    ConnectionsManager["Character Added"]:Disconnect()
                    ConnectionsManager["Character Added"] = nil
                end
            end
        end,
    })
end

protectionTab:Create_Section("Movements", "left"):Create_Toggle({
    name = "Anti Double Jump",
    flag = "Anti_Double_Jump",
    callback = function(arg)
        local ContextActionService = game:GetService("ContextActionService")

        if arg then
            local humanoid = (Player.Character or Player.CharacterAdded:Wait()):WaitForChild("Humanoid")
            local flag25 = false
            local flag26 = false

            ConnectionsManager["Anti Double Jump State"] = humanoid.StateChanged:Connect(function(old, new)
                if new == Enum.HumanoidStateType.Jumping then
                    flag25 = true

                elseif new == Enum.HumanoidStateType.Landed or new == Enum.HumanoidStateType.Running then
                    flag25 = false
                    flag26 = false
                end
            end)

            ConnectionsManager["Anti Double Jump Input"] = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed then
                    return
                end

                if input.KeyCode == Enum.KeyCode.Space and flag25 and not flag26 then
                    flag26 = true
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        else
            if ConnectionsManager["Anti Double Jump State"] then
                ConnectionsManager["Anti Double Jump State"]:Disconnect()
                ConnectionsManager["Anti Double Jump State"] = nil
            end

            if ConnectionsManager["Anti Double Jump Input"] then
                ConnectionsManager["Anti Double Jump Input"]:Disconnect()
                ConnectionsManager["Anti Double Jump Input"] = nil
            end

            ContextActionService:UnbindAction("BlockAirJump")
        end
    end,
})

ConnectionsManager["Infinity Ball"] = ReplicatedStorage.Remotes.InfinityBall.OnClientEvent:Connect(function(arg, arg2)
    InfinityBall = arg2
end)

ConnectionsManager["Parry Animation Fix"] = ReplicatedStorage.Remotes.ParrySuccess.OnClientEvent:Connect(function()
    BypassCooldown = true
    local character = Player.Character
    local humanoid = character and character:FindFirstChild("Humanoid")
    local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")

    if animator then
        for _, track in animator:GetPlayingAnimationTracks() do
            if track:GetAttribute("GrabParry") or track:GetAttribute("Parry") or track.Name == "GrabParry" or track.Name == "Grab" then
                track:Stop(track:GetAttribute("StopFadeTime") or 0.1)
            end
        end
    end
end)

ConnectionsManager["Keybinds Parry Types"] = UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then
        return
    end
    local keyCode = input.KeyCode
    local parryType

    local flag25 = keyCode == Enum.KeyCode.Z or keyCode == Enum.KeyCode.One
    parryType = nil

    if flag25 then
        parryType = Library.Flags.Parry_Type == "Backwards" and "Camera" or "Backwards"
    end

    if keyCode == Enum.KeyCode.X or keyCode == Enum.KeyCode.Two then
        parryType = Library.Flags.Parry_Type == "Dot Pointer" and "Camera" or "Dot Pointer"
    end

    if keyCode == Enum.KeyCode.C or keyCode == Enum.KeyCode.Three then
        parryType = Library.Flags.Parry_Type == "Dot" and "Camera" or "Dot"
    end

    if keyCode == Enum.KeyCode.Four then
        parryType = Library.Flags.Parry_Type == "FFA" and "Camera" or "FFA"
    end

    if parryType then
        Library.Flags.Parry_Type = parryType
        parryTypeDropdown:SetValue(Library.Flags.Parry_Type)

        if Library.Flags.Auto_Parry_Notification then
            Library:Notify("Parry Type = " .. tostring(Library.Flags.Parry_Type), 3)
        end
    end
end)

ConnectionsManager["Is Curved Event"] = ReplicatedStorage.Remotes.ParrySuccessAll.OnClientEvent:Connect(function(arg, arg2)
    local character = Player.Character
    local primaryPart = character and character.PrimaryPart
    if not primaryPart then
        return
    end

    for _, ball in AutoParry.Get_Balls() do
        if not ball then
            return
        end
        local zoomies = ball:FindFirstChild("zoomies")
        if not zoomies then
            return
        end
        local magnitude = zoomies.VectorVelocity.Magnitude
        local position

        if ball == TrackedBall and RealBallPosition then
            position = RealBallPosition
        else
            position = ball.Position
        end

        local magnitude2 = (primaryPart.Position - position).Magnitude
        if magnitude < 0.001 or magnitude2 < 0.001 then
            continue
        end
        local dot = (primaryPart.Position - position).Unit:Dot(zoomies.VectorVelocity.Unit)
        local value = AutoParry.Get_Ping()
        local n41 = math.min(magnitude / 100, 40)
        local n42 = magnitude2 / magnitude - value / 1000
        local flag25 = magnitude > 100
        local n43 = 40 * math.max(dot, 0)
        local n44 = 15 - math.min(magnitude2 / 1000, 15) + n43 + n41

        if flag25 and n42 > value / 10 then
            n44 = math.max(n44 - 15, 15)
        end

        if arg2 ~= primaryPart and magnitude2 > n44 then
            AutoParry.Get_Curve(ball).Curving = tick()
        end
    end
end)

ReplicatedStorage.Remotes.Phantom.OnClientEvent:Connect(function(arg, arg2)
    if arg2.Name == Player.Name then
        Got_Phantomed = true

        task.delay(0.35, function()
            Got_Phantomed = false
        end)
    end
end)

ConnectionsManager["Phantom Detection"] = workspace.Runtime.ChildAdded:Connect(function(child)
    local name = child.Name

    if Library.Flags.Phantom_Detection and (name == "maxTransmission" or name == "transmissionpart") then
        local weldConstraint = child:FindFirstChildWhichIsA("WeldConstraint")

        if weldConstraint then
            local character = Player.Character or Player.CharacterAdded:Wait()

            if character and weldConstraint.Part1 and weldConstraint.Part1:IsDescendantOf(character) then
                local clientBall = AutoParry.Client_Ball()

                if clientBall and clientBall:GetAttribute("highlighted") then
                    Got_Phantomed = true

                    task.delay(0.35, function()
                        Got_Phantomed = false
                    end)
                end

                weldConstraint:Destroy()

                if clientBall then
                    local humanoid = character:FindFirstChild("Humanoid")
                    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                    local flag25 = false
                    local flag26 = false
                    local now3 = os.clock()

                    ConnectionsManager["Phantom Loop"] = RunService.Heartbeat:Connect(function()
                        if not clientBall or not clientBall.Parent then
                            return
                        end

                        if not clientBall:GetAttribute("highlighted") then
                            if ConnectionsManager["Phantom Loop"] then
                                ConnectionsManager["Phantom Loop"]:Disconnect()
                            end

                            if humanoid then
                                task.delay(5, function()
                                    Got_Phantomed = false
                                end)
                            end

                            clientBall = nil
                            return
                        end

                        if humanoid and humanoidRootPart and clientBall then
                            if not flag25 then
                                flag25 = true
                                now3 = os.clock()
                            end

                            if flag25 and not flag26 and os.clock() - now3 >= 0.1 then
                                flag26 = true
                                local abilities = character:FindFirstChild("Abilities")

                                if abilities then
                                    local flag27 = false

                                    for _, abilityName in {
                                        "Calming Deflection",
                                        "Raging Deflection",
                                        "Rapture",
                                        "Aerodynamic Slash",
                                        "Forcefield",
                                        "Infinity",
                                        "Fracture",
                                        "Invisibility",
                                        "Singularity",
                                        "Ninja Dash",
                                        "Phantom",
                                        "Quantum Arena",
                                    }, nil, nil do
                                        local ability = abilities:FindFirstChild(abilityName)
                                        if ability and ability.Enabled then
                                            flag27 = true
                                            break
                                        end
                                    end

                                    if flag27 then
                                        if getgenv().Parry_Cooldown.Offset.Y < 0.5 then
                                            ReplicatedStorage.Remotes.AbilityButtonPress:Fire()
                                        end
                                    end
                                end
                            end
                        end
                    end)

                    task.delay(3, function()
                        if ConnectionsManager["Phantom Loop"] and ConnectionsManager["Phantom Loop"].Connected then
                            ConnectionsManager["Phantom Loop"]:Disconnect()
                            clientBall = nil
                            Got_Phantomed = false
                        end
                    end)
                end
            end
        end
    end
end)

workspace.Runtime.ChildAdded:Connect(function(child)
    if child.Name == "Tornado" then
        TornadoTime = tick()

        ConnectionsManager["Tornado Time"] = child:GetAttributeChangedSignal("TornadoTime"):Connect(function()
            TornadoTime = tick()
        end)

        ConnectionsManager["Tornado Destroying"] = child.Destroying:Connect(function()
            TornadoTime = nil
        end)
    end
end)

workspace.Balls.ChildAdded:Connect(function(child)
    if child:GetAttribute("realBall") then
        getgenv().Time_View = 5
        Real_Count = 0
        FirstHitIsReal = false
        AutoParry.Get_Curve(child)
        if AutoParry.Triggerbot then
            AutoParry.Triggerbot(child)
        end
    end
end)

for _, ball in AutoParry.Get_Balls() do
    AutoParry.Get_Curve(ball)
end

ConnectionsManager["Ball Added"] = ReplicatedStorage.Remotes.BallAdded.OnClientEvent:Connect(function()
    Color_Applied = false
    getgenv().Time_View = 5
    Real_Count = 0
    FirstHitIsReal = false
    Last_Parry2 = 0
end)

ConnectionsManager["Ball Removed"] = workspace.Balls.ChildRemoved:Connect(function(child)
    local data = CurveDataByBall[child]
    if data then
        data.From:Disconnect()
        data.Target:Disconnect()
        CurveDataByBall[child] = nil
    end

    Color_Applied = false
    getgenv().Time_View = 5
    Real_Count = 0
    FirstHitIsReal = false
    Last_Parry2 = 0
    Last_FFA_Target = nil
end)

ConnectionsManager["Finisher Connection"] = ReplicatedStorage.Remotes.Killed.OnClientEvent:Connect(function()
    if not workspace.ShowdownActive.Value then
        return
    end

    for _, child in workspace.Alive:GetChildren() do
        if child == Player.Name then
            continue
        end
        local n41 = (Player.Character.HumanoidRootPart.Position + child.HumanoidRootPart.Position) / 2
        local cframe = CFrame.new(n41, n41 + (Player.Character.HumanoidRootPart.Position - child.HumanoidRootPart.Position).Unit)
        if not getgenv().Selected_Finisher then
            return
        end
        local character = Player.Character
        local workspace = workspace
        local getServerTimeNow = workspace.GetServerTimeNow
        FinishersController:PlayFinisher(getgenv().Selected_Finisher, character, child, cframe, getServerTimeNow(workspace))
    end
end)

task.spawn(function()
    for _, player in Players:GetPlayers() do
        if player ~= Player then
            AutoParry.Billboard(player)
        end

        player.CharacterAdded:Connect(function(character)
            AutoParry.Billboard(player, character)
        end)
    end

    Players.PlayerAdded:Connect(function(player)
        if player ~= Player then
            player.CharacterAdded:Connect(function(character)
                AutoParry.Billboard(player, character)
            end)
        end
    end)

    Players.PlayerRemoving:Connect(function(player)
        billboards[player] = nil
    end)
end)

if byteUi then
    for _, connection in ConnectionsManager do
        connection:Disconnect()
    end

    byteUi:Destroy()
end
