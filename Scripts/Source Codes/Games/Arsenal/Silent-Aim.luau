local Players = cloneref(game:GetService("Players"))
local RunService = cloneref(game:GetService("RunService"))
local Drawing = Drawing or nil
local me = Players.LocalPlayer
local camera = workspace.CurrentCamera

if not hookfunction then
    return
end
if not getgc then
    return
end
if not islclosure then
    islclosure = islua or function(f) return type(f) == "function" end
end

local FOV = 150
local Chance = 75
local target = nil

if FOV > 0 and Drawing then
    local circle = Drawing.new("Circle")
    circle.Thickness = 1
    circle.NumSides = 64
    circle.Radius = FOV
    circle.Color = Color3.fromRGB(255, 255, 255)
    circle.Transparency = 0.5
    circle.Filled = false
    circle.Visible = true

    RunService.RenderStepped:Connect(function()
        circle.Position = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    end)
end

local function GetClosestPlayer()
    target = nil
    local closestDist = math.huge
    local myTeam = me.Team

    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer == me then continue end
        local otherChar = otherPlayer.Character
        if not otherChar then continue end

        local otherRoot = otherChar.HumanoidRootPart
        local otherHum = otherChar.Humanoid
        local otherHead = otherChar.Head
        if not otherRoot or not otherHead or not otherHum or otherHum.Health <= 0 then continue end
        if myTeam and otherPlayer.Team == myTeam then continue end

        local screenPos, onScreen = camera:WorldToViewportPoint(otherRoot.Position)
        if not onScreen then continue end

        local crosshairDist = (Vector2.new(screenPos.X, screenPos.Y) - camera.ViewportSize / 2).Magnitude
        if FOV > 0 and crosshairDist > FOV then continue end

        if crosshairDist < closestDist then
            closestDist = crosshairDist
            target = otherHead
        end
    end
end

RunService.RenderStepped:Connect(GetClosestPlayer)

for _, func in ipairs(getgc()) do
    if type(func) == "function" and islclosure(func) then
        local ok, info = pcall(debug.info, func, "a")
        if not ok then continue end
        if info == 2 then
            local upvalues = debug.getupvalues(func)
            local constants = debug.getconstants(func)
            if #upvalues == 2 and #constants == 17 then
                local originalFunc
                originalFunc = hookfunction(func, function(rayArg, secondArg)
                    if target and math.random(1, 100) <= Chance then
                        local myHead = me.Character.Head
                        rayArg = Ray.new(myHead.Position, target.Position - myHead.Position)
                    end
                    return originalFunc(rayArg, secondArg)
                end)
            end
        end
    end
end
