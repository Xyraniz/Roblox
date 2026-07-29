local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")
local workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
while not player do
    task.wait()
    player = Players.LocalPlayer
end

local camera = workspace.CurrentCamera
local mouse = player:GetMouse()

_G.AstraBotonesOcultos = false
local fovVisiblePreference = false
local fovRadius = 120
local fovFollowsCursor = false
local activeTouches = {}
local extraFovCircles = {}
local aimbotEnabled = false
local autoShootEnabled = false
local fullAimbotEnabled = false
local hitboxEnabled = false
local hitboxInvisible = false 
local hitboxSize = 10
local hitboxColor = Color3.fromRGB(255, 255, 255)
local teamCheckEnabled = true
local espEnabled = false
local espColor = Color3.fromRGB(255, 255, 255)
local espSettings = { Glow = true, Name = true, Health = true, Distance = true }
local gunKillEnabled = false
local knifeKillEnabled = false
local flying = false
local flySpeed = 50
local emoteWalkEnabled = false 
local currentEmoteTrack = nil
local allEmotes = {}
local filteredEmotes = {}
local currentPage = 1
local emotesPerPage = 12
local hideNameEnabled = false
local fakeNameEnabled = false
local rainbowEnabled = false
local creatorTagEnabled = false 
local spoofNameText = "Nombre falso"
local aimbotTargetPart = "Cabeza"

local UIElements = {}

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "OnyxHub_Overlays"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true 
screenGui.DisplayOrder = 999 
screenGui.Parent = player:WaitForChild("PlayerGui")

local espFolder = Instance.new("Folder")
espFolder.Name = "OnyxESPFolder"
espFolder.Parent = screenGui

local function makeDraggable(guiObject, objectToMove)
    local dragging, dragInput, dragStart, startPos
    guiObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = objectToMove.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    guiObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            objectToMove.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local WindUI
local _version = "1.6.66_V50"
local uiFileName = "OnyxHubUI_Cache_v" .. _version .. ".txt"
local timeFileName = "OnyxHubUI_Cache_v" .. _version .. "_Time.txt"

local ok, result = pcall(function()
    local cacheValido = false
    
    if isfile and isfile(timeFileName) and readfile then
        local savedTime = tonumber(readfile(timeFileName))
        if savedTime and (os.time() - savedTime) < 86400 then
            cacheValido = true
        end
    end

    if cacheValido and isfile and isfile(uiFileName) then
        return loadstring(readfile(uiFileName))()
    else
        local codigoUi = :HttpGet("https://raw.githubusercontent.com/Deang23cast/Roblox/ef71953b81a6af85ab6ea092ee2fe38360eb7fb6/Scripts/Source%20Codes/Games/Dmvs/Onyx-Hub.lua"))()
        if writefile then 
            writefile(uiFileName, codigoUi) 
            writefile(timeFileName, tostring(os.time()))
        end
        return loadstring(codigoUi)()
    end
end)

if ok and result then 
    WindUI = result 
else 
    warn("Error al cargar WindUI. Revisa el enlace de GitHub o tu conexión.") 
    return 
end

local Window = WindUI:CreateWindow({
    Title = "ONYX <font color='#6e2e7e'>HUB</font> | DUELS",
    Theme = "Violet",
    Author = "by AlexDev",
    Icon = "rbxassetid://88158601145345", 
    Folder = "OnyxHub_WindUI",
    Acrylic = false,
    Transparent = false,
    NewElements = false,
    HideSearchBar = true,
    OpenButton = {
        Title = "Open OnyxHub",
        Icon = "rbxassetid://88158601145345",
        CornerRadius = UDim.new(0, 14),
        StrokeThickness = 1.1,
        Enabled = true,
        Draggable = true,
        Scale = 0.8,
        Color = ColorSequence.new(Color3.fromRGB(0, 0, 0)) 
    },
    Topbar = { Height = 44, ButtonsType = "Default" }
})

local NotifContainer = Instance.new("Frame")
NotifContainer.Name = "AstraMinimalNotifs"
NotifContainer.Size = UDim2.new(0, 300, 0.5, 0)
NotifContainer.AnchorPoint = Vector2.new(1, 1) 
NotifContainer.Position = UDim2.new(1, -20, 1, -20) 
NotifContainer.BackgroundTransparency = 1
NotifContainer.Parent = screenGui

local layout = Instance.new("UIListLayout", NotifContainer)
layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 8)

local function showBottomMessage(text)
    task.spawn(function()
        local frame = Instance.new("Frame")
        frame.AutomaticSize = Enum.AutomaticSize.X
        frame.Size = UDim2.new(0, 0, 0, 28)
        frame.BackgroundColor3 = Color3.fromRGB(20, 21, 25)
        frame.BackgroundTransparency = 1
        frame.ClipsDescendants = true
        frame.Parent = NotifContainer

        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
        
        local padding = Instance.new("UIPadding", frame)
        padding.PaddingLeft = UDim.new(0, 12)
        padding.PaddingRight = UDim.new(0, 12)

        local stroke = Instance.new("UIStroke", frame)
        stroke.Color = Color3.fromRGB(200, 200, 200)
        stroke.Thickness = 1
        stroke.Transparency = 1

        local textLabel = Instance.new("TextLabel", frame)
        textLabel.AutomaticSize = Enum.AutomaticSize.X
        textLabel.Size = UDim2.new(0, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = text
        textLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
        textLabel.Font = Enum.Font.GothamMedium
        textLabel.TextSize = 13
        textLabel.TextTransparency = 1

        local TweenService = game:GetService("TweenService")
        TweenService:Create(frame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0.15}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.25), {Transparency = 0.5}):Play()
        TweenService:Create(textLabel, TweenInfo.new(0.25), {TextTransparency = 0}):Play()

        task.wait(2.5)

        local fadeOut = TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
        TweenService:Create(stroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
        TweenService:Create(textLabel, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        
        fadeOut:Play()
        fadeOut.Completed:Wait()
        frame:Destroy()
    end)
end

local MainSection = Window:Section({ Title = "Funciones Principales", Opened = true })
local TrollSection = Window:Section({ Title = "Configs & Extra", Opened = true })

local Tabs = {
    Inicio = MainSection:Tab({Title = "Inicio", Icon = "solar:home-bold"}),
    Aim = MainSection:Tab({Title = "Aimbot", Icon = "solar:target-bold"}),
    KillAll = MainSection:Tab({Title = "Kill All", Icon = "solar:target-bold"}),
    Vis = MainSection:Tab({Title = "Visuales", Icon = "solar:eye-bold"}),
    Mov = MainSection:Tab({Title = "Movimiento", Icon = "solar:running-bold"}),
    Farm = MainSection:Tab({Title = "AutoFarm", Icon = "solar:dollar-bold"}),
    Graficos = MainSection:Tab({Title = "Gráficos", Icon = "solar:palette-bold"}),
    Emotes = TrollSection:Tab({Title = "Animaciones", Icon = "solar:smile-circle-bold"}),
    Com = TrollSection:Tab({Title = "Comunidad", Icon = "solar:chat-line-bold"}),
    Config = TrollSection:Tab({Title = "Configuración", Icon = "solar:settings-bold"})
}

Tabs.Inicio:Section({ Title = "Registro de Actualizaciones" })

local fechaUpdate = "28 Julio 2026"

local cosasAgregadas = {
    "Apartado de animaciones corregido",
    "Kill All cuchillo"
}

local cosasArregladas = {
    "Optimizacion General",
}

local lineas = {}

if #cosasAgregadas > 0 then
    table.insert(lineas, "<font color='#00ff80'><b>Nuevo:</b></font>")
    for _, texto in ipairs(cosasAgregadas) do
        table.insert(lineas, "<font color='#00ff80'>+ " .. texto .. "</font>")
    end
    
    if #cosasArregladas > 0 then
        table.insert(lineas, "") 
    end
end

if #cosasArregladas > 0 then
    table.insert(lineas, "<font color='#f1c40f'><b>Arreglos:</b></font>")
    for _, texto in ipairs(cosasArregladas) do
        table.insert(lineas, "<font color='#f1c40f'>~ " .. texto .. "</font>")
    end
end

local textoFinal = table.concat(lineas, "\n")

Tabs.Inicio:Paragraph({ 
    Title = "Última actualización: " .. fechaUpdate, 
    Desc = textoFinal
})

Tabs.Inicio:Paragraph({ 
    Title = "Únete a nuestro Discord", 
    Desc = "Únete a nuestra comunidad oficial para soporte, actualizaciones y hablar con otros miembros.\n\ndiscord.com/invite/BQQey3cKP",
    Image = "rbxassetid://88267176037146",
    ImageSize = 80 
})

Tabs.Inicio:Button({
    Title = "Copiar enlace de Discord",
    Callback = function()
        pcall(function() setclipboard("discord.com/invite/BQQey3cKP") end)
        showBottomMessage("¡Link de Discord copiado al portapapeles!")
    end
})

local nombreEjecutor = identifyexecutor and identifyexecutor() or "Desconocido"

Tabs.Inicio:Paragraph({ 
    Title = "Ejecutor",
    Desc = "" .. tostring(nombreEjecutor)
})

Tabs.Inicio:Section({Title = "Información del Servidor"})

local gameNameStr = "Desconocido"
pcall(function() 
    gameNameStr = MarketplaceService:GetProductInfo(game.PlaceId).Name 
end)

Tabs.Inicio:Paragraph({ 
    Title = "Juego Actual", 
    Desc = gameNameStr .. "\nPlace ID: " .. game.PlaceId,
    Image = "rbxthumb://type=GameIcon&id=" .. game.GameId .. "&w=150&h=150",
    ImageSize = 48 
})

Tabs.Inicio:Section({ Title = "Juegos Soportados" })

local TPS = game:GetService("TeleportService")

local function TPSeguro_Duels(placeId, nombreJuego)
    if game.PlaceId == placeId then
        showBottomMessage("Ya estás en " .. nombreJuego .. ", buscando otro servidor...")
        pcall(function() TPS:Teleport(placeId, player) end)
    else
        showBottomMessage("Intentando ir a " .. nombreJuego .. "...")
        pcall(function() setclipboard("https://www.roblox.com/games/" .. tostring(placeId)) end)
        task.wait(0.5)
        showBottomMessage("Link copiado. Si no te hace TP, pégalo en tu navegador para entrar.")
        pcall(function() TPS:Teleport(placeId, player) end)
    end
end

Tabs.Inicio:Button({
    Title = "Murder Mystery 2",
    Callback = function() TPSeguro_Duels(142823291, "MM2") end
})

Tabs.Inicio:Button({
    Title = "Murderers VS Sheriffs (Duels)",
    Callback = function() TPSeguro_Duels(135856908115931, "Duels") end
})

Tabs.Inicio:Button({
    Title = "Murder Mystery V (MMV)",
    Callback = function() TPSeguro_Duels(74369636333825, "MMV") end
})

Tabs.Inicio:Section({Title = "Optimización"})

local Stats = game:GetService("Stats")
local statsContainer = Instance.new("Frame")
statsContainer.Size = UDim2.new(0, 150, 0, 50)
statsContainer.Position = UDim2.new(1, -170, 0, 10)
statsContainer.BackgroundTransparency = 1
statsContainer.Visible = false 
statsContainer.ZIndex = 100
statsContainer.Parent = screenGui

local fpsLabel = Instance.new("TextLabel", statsContainer)
fpsLabel.Size = UDim2.new(1, 0, 0, 25)
fpsLabel.Position = UDim2.new(0, 0, 0, 0)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Text = "FPS: --"
fpsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
fpsLabel.Font = Enum.Font.GothamBlack
fpsLabel.TextSize = 16 
fpsLabel.TextXAlignment = Enum.TextXAlignment.Right
fpsLabel.TextStrokeTransparency = 0
fpsLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

local pingLabel = Instance.new("TextLabel", statsContainer)
pingLabel.Size = UDim2.new(1, 0, 0, 25)
pingLabel.Position = UDim2.new(0, 0, 0, 25) 
pingLabel.BackgroundTransparency = 1
pingLabel.Text = "Ping: -- ms"
pingLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
pingLabel.Font = Enum.Font.GothamBlack
pingLabel.TextSize = 16
pingLabel.TextXAlignment = Enum.TextXAlignment.Right
pingLabel.TextStrokeTransparency = 0
pingLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

local showStatsEnabled = false
Tabs.Inicio:Toggle({
    Title = "Mostrar FPS y Ping",
    Callback = function(Value)
        showStatsEnabled = Value
        statsContainer.Visible = Value
    end,
})

local fpsFrames = 0
local lastStatsUpdate = tick()
RunService.RenderStepped:Connect(function()
    if not showStatsEnabled then return end 
    
    fpsFrames = fpsFrames + 1
    if tick() - lastStatsUpdate >= 1 then
        fpsLabel.Text = "FPS: " .. fpsFrames
        
        if fpsFrames >= 50 then fpsLabel.TextColor3 = Color3.fromRGB(46, 204, 113) 
        elseif fpsFrames >= 30 then fpsLabel.TextColor3 = Color3.fromRGB(241, 196, 15) 
        else fpsLabel.TextColor3 = Color3.fromRGB(231, 76, 60) end
        
        local pingValue = 0
        pcall(function() pingValue = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
        
        pingLabel.Text = "Ping: " .. tostring(pingValue) .. " ms"
        
        if pingValue < 90 then pingLabel.TextColor3 = Color3.fromRGB(46, 204, 113) 
        elseif pingValue < 150 then pingLabel.TextColor3 = Color3.fromRGB(241, 196, 15) 
        else pingLabel.TextColor3 = Color3.fromRGB(231, 76, 60) end
        
        fpsFrames = 0
        lastStatsUpdate = tick()
    end
end)

local fpsBoostEnabled = false
local autoFpsConnection = nil
local origGlobalShadows = true
local origFogEnd = 100000
local origShadowSoftness = 1

UIElements.ToggleFPS = Tabs.Graficos:Toggle({
    Title = "FPS Boost (Elimina texturas)",
    Value = false,
    Callback = function(state)
        fpsBoostEnabled = state
        local Lighting = game:GetService("Lighting")
        local Terrain = workspace:FindFirstChildOfClass("Terrain")
        
        local cacheFolder = Lighting:FindFirstChild("AstraPBRCache")
        if not cacheFolder then
            cacheFolder = Instance.new("Folder")
            cacheFolder.Name = "AstraPBRCache"
            cacheFolder.Parent = Lighting
        end

        if state then
            origGlobalShadows = Lighting.GlobalShadows
            origFogEnd = Lighting.FogEnd
            origShadowSoftness = Lighting.ShadowSoftness
            
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 9e9
            Lighting.ShadowSoftness = 0
            
            if Terrain then
                pcall(function()
                    if not Terrain:GetAttribute("OrigWaveSize") then
                        Terrain:SetAttribute("OrigWaveSize", Terrain.WaterWaveSize)
                        Terrain:SetAttribute("OrigDeco", Terrain.Decoration)
                    end
                    Terrain.WaterWaveSize = 0 Terrain.WaterWaveSpeed = 0 Terrain.WaterReflectance = 0 Terrain.WaterTransparency = 1 
                    Terrain.Decoration = false
                end)
            end
            
            local function applyLowGraphics(v)
                if not v:IsA("BasePart") and not v:IsA("Decal") and not v:IsA("Texture") and not v:IsA("SpecialMesh") and not v:IsA("Light") and not v:IsA("PostEffect") and not v:IsA("SurfaceAppearance") and not v:IsA("Clothing") then 
                    return 
                end

                pcall(function()
                    if v:IsA("ScreenGui") then return end
                    if v.Parent and v.Parent:FindFirstChild("Humanoid") then return end

                    if v:IsA("BasePart") and not v:IsA("Terrain") then 
                        if not v:GetAttribute("OrigMat") then 
                            v:SetAttribute("OrigMat", v.Material.Name)
                            v:SetAttribute("OrigCast", v.CastShadow)
                        end
                        v.Material = Enum.Material.SmoothPlastic
                        v.Reflectance = 0
                        v.CastShadow = false 
                        
                        if v:IsA("MeshPart") then
                            if not v:GetAttribute("OrigTex") then v:SetAttribute("OrigTex", v.TextureID) end
                            v.TextureID = "" 
                        end
                    elseif v:IsA("SpecialMesh") then
                        if not v:GetAttribute("OrigTex") then v:SetAttribute("OrigTex", v.TextureId) end
                        v.TextureId = "" 
                    elseif v:IsA("SurfaceAppearance") or v:IsA("BaseWrap") or v:IsA("Clothing") then 
                        if not v:GetAttribute("OrigParent") then v:SetAttribute("OrigParent", v.Parent) end
                        v.Parent = cacheFolder
                    elseif v:IsA("Decal") or v:IsA("Texture") then
                        if not v:GetAttribute("OrigTrans") then v:SetAttribute("OrigTrans", v.Transparency) end
                        v.Transparency = 1
                    elseif v:IsA("Light") or v:IsA("PostEffect") then 
                        if v:GetAttribute("OrigEnabled") == nil then v:SetAttribute("OrigEnabled", v.Enabled) end
                        v.Enabled = false
                    end
                end)
            end
            
            task.spawn(function()
                local count = 0
                for _, v in pairs(workspace:GetDescendants()) do 
                    applyLowGraphics(v) 
                    count = count + 1
                    if count % 300 == 0 then task.wait() end
                end
            end)
            
            if not autoFpsConnection then
                autoFpsConnection = workspace.DescendantAdded:Connect(function(v)
                    if fpsBoostEnabled then applyLowGraphics(v) end
                end)
            end
            showBottomMessage("FPS Boost Aplicando...")
        else
            Lighting.GlobalShadows = origGlobalShadows
            Lighting.FogEnd = origFogEnd
            Lighting.ShadowSoftness = origShadowSoftness
            
            if Terrain and Terrain:GetAttribute("OrigWaveSize") then
                pcall(function()
                    Terrain.WaterWaveSize = Terrain:GetAttribute("OrigWaveSize")
                    Terrain.Decoration = Terrain:GetAttribute("OrigDeco")
                end)
            end
            
            task.spawn(function()
                local count = 0
                for _, v in pairs(workspace:GetDescendants()) do
                    pcall(function()
                        if v:IsA("BasePart") and v:GetAttribute("OrigMat") then 
                            local matName = v:GetAttribute("OrigMat")
                            if Enum.Material[matName] then v.Material = Enum.Material[matName] end
                            v.CastShadow = v:GetAttribute("OrigCast")
                            
                            if v:IsA("MeshPart") and v:GetAttribute("OrigTex") then
                                v.TextureID = v:GetAttribute("OrigTex")
                            end
                        elseif v:IsA("SpecialMesh") and v:GetAttribute("OrigTex") then
                            v.TextureId = v:GetAttribute("OrigTex")
                        elseif (v:IsA("Decal") or v:IsA("Texture")) and v:GetAttribute("OrigTrans") then
                            v.Transparency = v:GetAttribute("OrigTrans")
                        elseif (v:IsA("Light") or v:IsA("PostEffect")) and v:GetAttribute("OrigEnabled") ~= nil then
                            v.Enabled = v:GetAttribute("OrigEnabled")
                        end
                    end)
                    count = count + 1
                    if count % 300 == 0 then task.wait() end
                end
                
                for _, v in pairs(cacheFolder:GetChildren()) do
                    pcall(function()
                        if v:GetAttribute("OrigParent") then v.Parent = v:GetAttribute("OrigParent") end
                    end)
                end
            end)

            if autoFpsConnection then autoFpsConnection:Disconnect(); autoFpsConnection = nil end
            showBottomMessage("Gráficos normales restaurados.")
        end
    end
})

Tabs.Inicio:Button({
    Title = "Cambiar de Servidor",
    Callback = function()
        showBottomMessage("Buscando servidor vacío...")
        local TPS = game:GetService("TeleportService")
        local Api = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        
        task.spawn(function()
            local success, err = pcall(function()
                local req = request or http_request or (syn and syn.request)
                if req then
                    local res = req({Url = Api, Method = "GET"})
                    if res.StatusCode == 200 then
                        local data = HttpService:JSONDecode(res.Body)
                        local servers = {}
                        if data and data.data then for _, v in pairs(data.data) do if v.playing < v.maxPlayers and v.id ~= game.JobId then table.insert(servers, v.id) end end end
                        if #servers > 0 then
                            local randomServer = servers[math.random(1, #servers)]
                            showBottomMessage("¡Servidor encontrado!...")
                            TPS:TeleportToPlaceInstance(game.PlaceId, randomServer, player)
                        else showBottomMessage("No hay servidores vacíos disponibles.") end
                    else showBottomMessage("Error de conexión con el Proxy.") end
                else showBottomMessage("Tu ejecutor no soporta HTTP Requests.") end
            end)
            if not success then warn("Error en Server Hop:", err) end
        end)
    end,
})

local macroActivo = false
local macroEquipDelay = 0.04
local macroShootDelay = 0.10

Tabs.Aim:Section({Title = "Macro (Pistola)"})
UIElements.TogMacro = Tabs.Aim:Toggle({
    Title = "Activar Macro", 
    Desc = "Dispara con un solo toque.",
    Callback = function(s) macroActivo = s end
})

UIElements.SliMacroEquip = Tabs.Aim:Slider({
    Title = "Delay al Equipar",
    Desc = "Sube esto si la pistola no alcanza a salir. (Segundos)",
    Step = 0.01,
    Value = {Min = 0.01, Max = 0.50, Default = 0.04},
    Callback = function(v) macroEquipDelay = v end
})

UIElements.SliMacroShoot = Tabs.Aim:Slider({
    Title = "Delay de Disparo",
    Desc = "Sube esto si el tiro no cuenta daño. (Segundos)",
    Step = 0.01,
    Value = {Min = 0.05, Max = 0.80, Default = 0.10},
    Callback = function(v) macroShootDelay = v end
})

local deadZoneFrame = Instance.new("Frame")
deadZoneFrame.Size = UDim2.new(0, 150, 0, 150)
deadZoneFrame.Position = UDim2.new(0.8, -75, 0.8, -75) 
deadZoneFrame.BackgroundColor3 = Color3.fromRGB(255, 50, 50) 
deadZoneFrame.BackgroundTransparency = 0.5
deadZoneFrame.Visible = false
deadZoneFrame.ZIndex = 100
deadZoneFrame.Parent = screenGui 
Instance.new("UICorner", deadZoneFrame).CornerRadius = UDim.new(0, 16)

local dzStroke = Instance.new("UIStroke", deadZoneFrame)
dzStroke.Color = Color3.fromRGB(255, 255, 255)
dzStroke.Thickness = 2
dzStroke.LineJoinMode = Enum.LineJoinMode.Round

local dzLabel = Instance.new("TextLabel", deadZoneFrame)
dzLabel.Size = UDim2.new(1, 0, 1, 0)
dzLabel.BackgroundTransparency = 1
dzLabel.Text = "ZONA MUERTA\n(Arrastrar)"
dzLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
dzLabel.Font = Enum.Font.GothamBold
dzLabel.TextSize = 14
dzLabel.TextWrapped = true

makeDraggable(deadZoneFrame, deadZoneFrame)

UIElements.TogDeadZone = Tabs.Aim:Toggle({
    Title = "Mostrar/Acomodar Zona Muerta", 
    Callback = function(s) deadZoneFrame.Visible = s end
})

UIElements.SliDeadZone = Tabs.Aim:Slider({
    Title = "Tamaño de Zona Muerta", 
    Step = 10,
    Value = {Min = 80, Max = 400, Default = 150}, 
    Callback = function(v) deadZoneFrame.Size = UDim2.new(0, v, 0, v) end
})

local function esLaPistola(item)
    if not item:IsA("Tool") then return false end
    if item:FindFirstChild("Throw", true) or item:FindFirstChild("KnifeClient", true) or item:FindFirstChild("KnifeServer", true) then return false end
    local nombre = string.lower(item.Name)
    local ignorar = {"combat", "fist", "wallet", "phone", "punch", "boombox", "radio", "knife", "blade", "cuchillo", "dagger", "kunai", "sword", "toy", "juguete", "pizza", "burger", "teddy", "balloon", "drink", "food"}
    for _, palabra in ipairs(ignorar) do if string.find(nombre, palabra) then return false end end
    return true
end

local function obtenerPistola()
    local char = player.Character
    local backpack = player:FindFirstChild("Backpack")
    if char then for _, item in ipairs(char:GetChildren()) do if esLaPistola(item) then return item end end end
    if backpack then for _, item in ipairs(backpack:GetChildren()) do if esLaPistola(item) then return item end end end
    return nil 
end

local ZONAS_SEGURAS = {
    {Centro = Vector3.new(-320.50, 280.82, 16.00), Radio = 500},
    {Centro = Vector3.new(1564.14, -155.45, 40.04), Radio = 300}
}

local function estaEnLobby()
    local char = player.Character 
    if not char then return true end
    
    if char:FindFirstChildOfClass("ForceField") then return true end
    
    if player.Team then
        local tName = string.lower(player.Team.Name)
        if string.find(tName, "lobby") or string.find(tName, "spectat") or string.find(tName, "espectador") or string.find(tName, "menu") or string.find(tName, "dead") then return true end
    end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then
        for _, zona in ipairs(ZONAS_SEGURAS) do
            local dist = (hrp.Position - zona.Centro).Magnitude
            if dist <= zona.Radio then 
                return true
            end
        end
    end
    
    return false
end

local function ejecutarAccionMacro()
    
    if estaEnLobby() then return end

    local hayEnemigos = false
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then
            local pChar = p.Character
            if pChar and pChar:FindFirstChild("Humanoid") and pChar.Humanoid.Health > 0 then
                if player.Team == nil or p.Team == nil or player.Team ~= p.Team then
                    hayEnemigos = true
                    break 
                end
            end
        end
    end

    if not hayEnemigos then return end

    local char = player.Character if not char then return end
    local hum = char:FindFirstChild("Humanoid") if not hum then return end
    local herramientaEnMano = char:FindFirstChildOfClass("Tool")
    if herramientaEnMano and not esLaPistola(herramientaEnMano) then return end

    local pistola = obtenerPistola()
    if not pistola then return end

    task.spawn(function()
        hum:UnequipTools() 
        task.wait() 
        hum:EquipTool(pistola) 
        
        task.wait(macroEquipDelay) 
        
        if pistola.Parent == char then 
            pistola:Activate() 
            
            task.wait(macroShootDelay) 
            
            pistola:Deactivate()
            hum:UnequipTools() 
        end
    end)
end

local toquesPantalla = {} 

UserInputService.InputChanged:Connect(function(input, processed)
    if input.UserInputType == Enum.UserInputType.Touch and toquesPantalla[input] then
        if (toquesPantalla[input].posicion - input.Position).Magnitude > 10 then
            toquesPantalla = {} 
        end
    end
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if processed or not macroActivo then return end
    
    if input.UserInputType == Enum.UserInputType.MouseButton1 then 
        ejecutarAccionMacro()
    elseif input.UserInputType == Enum.UserInputType.Touch then
        local pos = input.Position
        local dzPos = deadZoneFrame.AbsolutePosition
        local dzSize = deadZoneFrame.AbsoluteSize
        local tocoZonaMuerta = (pos.X >= dzPos.X) and (pos.X <= dzPos.X + dzSize.X) and (pos.Y >= dzPos.Y) and (pos.Y <= dzPos.Y + dzSize.Y)
        
        if not tocoZonaMuerta then 
            toquesPantalla[input] = {posicion = input.Position, tiempo = tick()} 
        end
    end
end)

UserInputService.InputEnded:Connect(function(input, processed)
    if not macroActivo then return end
    
    if input.UserInputType == Enum.UserInputType.Touch and toquesPantalla[input] then
        local datosToque = toquesPantalla[input] 
        local posicionFinal = input.Position
        local distanciaMovida = (datosToque.posicion - posicionFinal).Magnitude 
        local tiempoPresionado = tick() - datosToque.tiempo
        
        toquesPantalla[input] = nil
        
        if distanciaMovida < 10 and tiempoPresionado < 0.35 and tiempoPresionado > 0.03 then 
            ejecutarAccionMacro() 
        end
    end
end)

local enemyCache = {}

local function updateMyTeam() enemyCache = {} end
local function updateEnemy(p) enemyCache[p] = nil end

player:GetPropertyChangedSignal("Team"):Connect(updateMyTeam)
player:GetPropertyChangedSignal("TeamColor"):Connect(updateMyTeam)
player:GetAttributeChangedSignal("Team"):Connect(updateMyTeam)

local function setupPlayerEvents(p)
    p:GetPropertyChangedSignal("Team"):Connect(function() updateEnemy(p) end)
    p:GetPropertyChangedSignal("TeamColor"):Connect(function() updateEnemy(p) end)
    p:GetAttributeChangedSignal("Team"):Connect(function() updateEnemy(p) end)
end

for _, p in ipairs(Players:GetPlayers()) do
    if p ~= player then setupPlayerEvents(p) end
end
Players.PlayerAdded:Connect(function(p) setupPlayerEvents(p) end)
Players.PlayerRemoving:Connect(function(p) updateEnemy(p) end)

local function isEnemy(targetPlayer)
    if not teamCheckEnabled then return true end
    if targetPlayer == player then return false end
    
    if enemyCache[targetPlayer] ~= nil then return enemyCache[targetPlayer] end

    local isDiff = true
    if player.Team ~= nil and targetPlayer.Team ~= nil then
        isDiff = (player.Team ~= targetPlayer.Team)
    else
        local pAttr = player:GetAttribute("Team") or player:GetAttribute("team") 
        local tAttr = targetPlayer:GetAttribute("Team") or targetPlayer:GetAttribute("team")
        if pAttr ~= nil and tAttr ~= nil then
            isDiff = (pAttr ~= tAttr)
        elseif player.TeamColor.Name ~= "White" and player.TeamColor.Name ~= "Medium stone grey" then
            isDiff = (player.TeamColor ~= targetPlayer.TeamColor)
        end
    end
    
    enemyCache[targetPlayer] = isDiff
    return isDiff
end

Tabs.Aim:Section({Title = "Auto Shoot"})

local autoShootTargetPart = "Cabeza"

UIElements.TogAutoShoot = Tabs.Aim:Toggle({
    Title = "Auto Shoot",
    Desc = "Dispara automáticamente a la parte del cuerpo seleccionada.",
    Value = false,
    Callback = function(Value)
        task.spawn(function()
            autoShootEnabled = Value
            showBottomMessage(Value and "Auto Shoot: ACTIVADO" or "Auto Shoot: DESACTIVADO")
            if not Value then 
                pcall(function() getgenv().AstraTargetPart = nil end) 
            end
        end)
    end,
})

local autoShootCuchilloEnabled = false

UIElements.TogAutoShootCuchillo = Tabs.Aim:Toggle({
    Title = "Auto Shoot (Cuchillo)",
    Desc = "Ataca o lanza el cuchillo automáticamente.",
    Value = false,
    Callback = function(Value)
        autoShootCuchilloEnabled = Value
    end,
})

local asTargetIniciado = false
UIElements.DropAutoShootPart = Tabs.Aim:Dropdown({
    Title = "Target: Parte del cuerpo (Auto Shoot)",
    Values = {"Cabeza", "Torso", "Cuerpo Completo"},
    Value = "Cabeza",
    Callback = function(Value)
        autoShootTargetPart = Value
        if asTargetIniciado then
            showBottomMessage("AutoShoot Target: " .. Value)
        end
        asTargetIniciado = true
    end
})

local tapToShootEnabled = false
local silentAimManualEnabled = false
local silentAimTargetPart = "Cabeza"
local silentAimFovEnabled = false

UIElements.TogSilentAimManual = Tabs.Aim:Toggle({
    Title = "Silent Aim",
    Desc = "Redirige las balas al enemigo.",
    Value = false,
    Callback = function(Value)
        task.spawn(function()
            silentAimManualEnabled = Value
            showBottomMessage(Value and "Silent Aim: ACTIVADO" or "Silent: DESACTIVADO")
            if not Value and not autoShootEnabled and not autoShootAgresivoEnabled then 
                pcall(function() getgenv().AstraTargetPart = nil end) 
            end
        end)
    end,
})

local aimTargetIniciado = false
UIElements.DropSilentAimPart = Tabs.Aim:Dropdown({
    Title = "Target: Parte del cuerpo",
    Values = {"Cabeza", "Torso", "Cuerpo Completo"},
    Value = "Cabeza",
    Callback = function(Value)
        silentAimTargetPart = Value
        if aimTargetIniciado then
            showBottomMessage("Apuntando a: " .. Value)
        end
        aimTargetIniciado = true
    end
})

UIElements.TogSilentAimFOV = Tabs.Aim:Toggle({
    Title = "Silent Aim (Con FOV)",
    Desc = "Igual que el Silent Aim, pero solo afecta a los enemigos dentro del círculo.",
    Value = false,
    Callback = function(Value)
        task.spawn(function()
            silentAimFovEnabled = Value
            showBottomMessage(Value and "Silent Aim FOV: ACTIVADO" or "Silent FOV: DESACTIVADO")
            if not Value and not silentAimManualEnabled and not autoShootEnabled and not autoShootAgresivoEnabled then 
                pcall(function() getgenv().AstraTargetPart = nil end) 
            end
        end)
    end,
})

UIElements.TogShowFOV = Tabs.Aim:Toggle({
    Title = "Mostrar Círculo FOV",
    Desc = "Dibuja un círculo en pantalla para que sepas dónde funciona tu Silent Aim.",
    Value = false,
    Callback = function(Value) 
        fovVisiblePreference = Value 
    end,
})

UIElements.SliFOVSize = Tabs.Aim:Slider({
    Title = "Tamaño del FOV", 
    Step = 1,
    Value = {Min = 10, Max = 800, Default = 120}, 
    Callback = function(v) 
        fovRadius = v 
    end
})

pcall(function() getgenv().AstraTargetPart = nil end)

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()

    if not checkcaller() and getgenv().AstraTargetPart then
        local target = getgenv().AstraTargetPart
        
        local cameraOrigin = workspace.CurrentCamera.CFrame.Position
        
        if target and target.Parent then
            if method == "Raycast" and self == workspace then
                local origin, direction, p3 = ...
                
                if (origin - cameraOrigin).Magnitude < 1 then
                    return oldNamecall(self, ...)
                end

                if typeof(direction) == "Vector3" and direction.Magnitude > 5 then
                    local newDir = (target.Position - origin).Unit * 5000 
                    return oldNamecall(self, origin, newDir, p3)
                end
            elseif string.find(method, "FindPartOnRay") and self == workspace then
                local ray, p2, p3, p4 = ...
                
                if (ray.Origin - cameraOrigin).Magnitude < 1 then
                    return oldNamecall(self, ...)
                end

                if typeof(ray) == "Ray" and ray.Direction.Magnitude > 5 then
                    local newRay = Ray.new(ray.Origin, (target.Position - ray.Origin).Unit * 5000)
                    return oldNamecall(self, newRay, p2, p3, p4)
                end
            end
        else
            getgenv().AstraTargetPart = nil
        end
    end

    return oldNamecall(self, ...)
end)

local oldIndex
oldIndex = hookmetamethod(game, "__index", function(t, k)
    if not checkcaller() and t == mouse and getgenv().AstraTargetPart then
        if k == "Hit" or k == "hit" then
            return getgenv().AstraTargetPart.CFrame
        elseif k == "Target" or k == "target" then
            return getgenv().AstraTargetPart
        end
    end
    return oldIndex(t, k)
end)

task.spawn(function()
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude

    while task.wait(0.1) do
        if (autoShootEnabled or autoShootCuchilloEnabled) and not estaEnLobby() then
            local char = player.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then continue end

            local arma = char:FindFirstChildOfClass("Tool")
            if not arma or not arma:FindFirstChild("Handle") then 
                getgenv().AstraTargetPart = nil
                continue 
            end

            local esGun = esLaPistola(arma)
            
            if esGun and not autoShootEnabled then
                getgenv().AstraTargetPart = nil
                continue
            elseif not esGun and not autoShootCuchilloEnabled then
                getgenv().AstraTargetPart = nil
                continue
            end

            local myPos = char.HumanoidRootPart.Position
            local headPos = char:FindFirstChild("Head") and char.Head.Position or myPos
            
            local objetivosPotenciales = {}
            local rawPlayers = Players:GetChildren()

            for i = 1, #rawPlayers do
                local p = rawPlayers[i]
                if p:IsA("Player") and p ~= player and isEnemy(p) and p.Character then
                    local enemyHum = p.Character:FindFirstChild("Humanoid")
                    if enemyHum and enemyHum.Health > 0 then
                        
                        local partesAEscanear = {}
                        if autoShootTargetPart == "Cabeza" then partesAEscanear = {"Head"}
                        elseif autoShootTargetPart == "Torso" then partesAEscanear = {"UpperTorso", "Torso", "HumanoidRootPart"}
                        elseif autoShootTargetPart == "Cuerpo Completo" then partesAEscanear = {"Head", "UpperTorso", "LowerTorso", "Torso", "LeftArm", "RightArm", "LeftLeg", "RightLeg", "LeftUpperArm", "RightUpperArm", "LeftUpperLeg", "RightUpperLeg"} end

                        for _, partName in ipairs(partesAEscanear) do
                            local part = p.Character:FindFirstChild(partName)
                            if part and part:IsA("BasePart") then 
                                table.insert(objetivosPotenciales, {
                                    Part = part, 
                                    Dist = (part.Position - myPos).Magnitude,
                                    Char = p.Character
                                })
                            end
                        end
                    end 
                end 
            end 
            
            table.sort(objetivosPotenciales, function(a, b) return a.Dist < b.Dist end)

            local closestTargetPart = nil
            
            for _, obj in ipairs(objetivosPotenciales) do
                local part = obj.Part
                params.FilterDescendantsInstances = {char, obj.Char}
                
                local sizeX, sizeY = part.Size.X / 2.1, part.Size.Y / 2.1
                local cframe = part.CFrame
                
                local isVisible = not workspace:Raycast(headPos, cframe.Position - headPos, params)
                if not isVisible then isVisible = not workspace:Raycast(headPos, (cframe * CFrame.new(sizeX, 0, 0)).Position - headPos, params) end
                if not isVisible then isVisible = not workspace:Raycast(headPos, (cframe * CFrame.new(-sizeX, 0, 0)).Position - headPos, params) end
                if not isVisible then isVisible = not workspace:Raycast(headPos, (cframe * CFrame.new(0, sizeY, 0)).Position - headPos, params) end
                if not isVisible then isVisible = not workspace:Raycast(headPos, (cframe * CFrame.new(0, -sizeY, 0)).Position - headPos, params) end
                
                if isVisible then
                    closestTargetPart = part
                    break
                end
            end

            if closestTargetPart then
                getgenv().AstraTargetPart = closestTargetPart
                pcall(function() 
                    arma:Activate() 
                    task.delay(0.02, function() 
                        if arma.Parent == char then arma:Deactivate() end
                    end)
                end)
                task.wait(0.1) 
            else
                getgenv().AstraTargetPart = nil
            end
        end
    end
end)

task.spawn(function()
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude

    while task.wait() do
        if (silentAimManualEnabled or silentAimFovEnabled) and not estaEnLobby() then
            local char = player.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then continue end

            local closestTargetPart = nil
            local shortestDistToCenter = math.huge 
            local shortestDistanceFisica = math.huge 
            
            local myPos = char.HumanoidRootPart.Position
            local headPos = char:FindFirstChild("Head") and char.Head.Position or myPos
            
            local viewport = camera.ViewportSize
            local mousePos = Vector2.new(viewport.X / 2, viewport.Y / 2)

            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= player and isEnemy(p) and p.Character then
                    local enemyHum = p.Character:FindFirstChild("Humanoid")
                    if enemyHum and enemyHum.Health > 0 then
                        
                        local partesAEscanear = {}
                        
                        if silentAimTargetPart == "Cabeza" then
                            local head = p.Character:FindFirstChild("Head")
                            if head then table.insert(partesAEscanear, head) end
                        elseif silentAimTargetPart == "Torso" then
                            local partesClave = {"UpperTorso", "Torso", "HumanoidRootPart"}
                            for _, partName in ipairs(partesClave) do
                                local part = p.Character:FindFirstChild(partName)
                                if part and part:IsA("BasePart") then table.insert(partesAEscanear, part) end
                            end
                        elseif silentAimTargetPart == "Cuerpo Completo" then
                            for _, part in ipairs(p.Character:GetChildren()) do
                                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then table.insert(partesAEscanear, part) end
                            end
                        end

                        params.FilterDescendantsInstances = {char, p.Character}
                        
                        for _, part in ipairs(partesAEscanear) do
                            local distFisica = (part.Position - myPos).Magnitude
                            
                            local pos2D, onScreen = camera:WorldToViewportPoint(part.Position)
                            local distToCenter = (Vector2.new(pos2D.X, pos2D.Y) - mousePos).Magnitude
                            
                            local pasaFiltro = false
                            
                            if silentAimFovEnabled then
                                if onScreen and distToCenter <= fovRadius and distToCenter < shortestDistToCenter then pasaFiltro = true end
                            elseif silentAimManualEnabled then
                                if distFisica < shortestDistanceFisica then pasaFiltro = true end
                            end
                            
                            if pasaFiltro then
                                local raycastResult = workspace:Raycast(headPos, part.Position - headPos, params)
                                if not raycastResult then
                                    if silentAimFovEnabled then
                                        shortestDistToCenter = distToCenter
                                        closestTargetPart = part
                                    else
                                        shortestDistanceFisica = distFisica
                                        closestTargetPart = part
                                    end
                                end
                            end
                        end
                    end
                end
            end
            
            if closestTargetPart then
                getgenv().AstraTargetPart = closestTargetPart
            else
                if not autoShootEnabled then
                    getgenv().AstraTargetPart = nil
                end
            end
        end
    end
end)

Tabs.KillAll:Section({Title = "Kill all"})

local function esVulnerable(char)
    if not char then return false end
    
    if char:FindFirstChildOfClass("ForceField") then return false end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp and hrp.Anchored then return false end
    
    local hum = char:FindFirstChild("Humanoid")
    if hum and hum.WalkSpeed == 0 then return false end
    
    return true
end

local killAllRango = 600 

local killAllEnabled = false
Tabs.KillAll:Toggle({ 
    Title = "Activar Kill All (Riesgo de ban si te reportan)",
    Desc = "Mata a todos los enemigos con cuchillo.",
    Value = false,
    Callback = function(Value)
        killAllEnabled = Value
        if Value then
            showBottomMessage("Kill All: ACTIVADO")
            task.spawn(function()
                while killAllEnabled do
                    local myChar = player.Character
                    
                    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") or not player:FindFirstChild("Backpack") then
                        task.wait(0.5)
                        continue 
                    end
                    
                    if not estaEnLobby() and esVulnerable(myChar) then
                        local myHrp = myChar:FindFirstChild("HumanoidRootPart")
                        local myHum = myChar:FindFirstChild("Humanoid")
                        
                        if myHrp and myHum and myHum.Health > 0 then
                            local posicionOriginal = myHrp.CFrame
                            
                            for _, p in ipairs(Players:GetPlayers()) do
                                if not killAllEnabled then break end 
                                
                                if p ~= player and isEnemy(p) and p.Character then
                                    if esVulnerable(p.Character) then
                                        local enemyHum = p.Character:FindFirstChild("Humanoid")
                                        local enemyHrp = p.Character:FindFirstChild("HumanoidRootPart")

                                        if enemyHum and enemyHum.Health > 0 and enemyHrp then
                                            local distanciaAlEnemigo = (posicionOriginal.Position - enemyHrp.Position).Magnitude
                                            
                                            if distanciaAlEnemigo <= killAllRango then
                                                enemyHrp.Size = Vector3.new(30, 30, 30)
                                                enemyHrp.CanCollide = false
                                                
                                                local failSafe = 0 
                                                
                                                while killAllEnabled and p and p.Parent and enemyHum and enemyHum.Parent and enemyHum.Health > 0 and failSafe < 300 do
                                                    
                                                    myHum.PlatformStand = true 
                                                    
                                                    myHrp.CFrame = enemyHrp.CFrame * CFrame.new(0, -4, 0) * CFrame.Angles(math.rad(90), 0, 0)
                                                    
                                                    myHrp.AssemblyLinearVelocity = Vector3.zero 
                                                    
                                                    pcall(function()
                                                        local arma = myChar:FindFirstChildOfClass("Tool")
                                                        
                                                        if arma and esLaPistola(arma) then
                                                            myHum:UnequipTools()
                                                            arma = nil
                                                        end
                                                        
                                                        if not arma then
                                                            local backpack = player:FindFirstChild("Backpack")
                                                            if backpack then
                                                                for _, item in ipairs(backpack:GetChildren()) do
                                                                    if item:IsA("Tool") and not esLaPistola(item) then
                                                                        myHum:EquipTool(item)
                                                                        arma = item
                                                                        task.wait(0.1)
                                                                        break
                                                                    end
                                                                end
                                                            end
                                                        end
                                                        
                                                        if arma then
                                                            arma:Activate()
                                                        end
                                                    end)
                                                    
                                                    task.wait(0.01)
                                                    failSafe = failSafe + 1
                                                end

                                                if myHum then
                                                    myHum.PlatformStand = false
                                                end
                                                
                                                pcall(function()
                                                    local arma = myChar:FindFirstChildOfClass("Tool")
                                                    if arma then arma:Deactivate() end
                                                end)
                                            end
                                        end
                                    end
                                end
                            end

                            if killAllEnabled and myHrp then
                                myHrp.CFrame = posicionOriginal
                                task.wait(0.2) 
                            end
                        end
                    end
                    task.wait(0.1) 
                end
            end)
        else
            showBottomMessage("Kill All: DESACTIVADO")
        end
    end
})

Tabs.Aim:Section({Title = "Expandir Hitbox"})

UIElements.TogHitbox = Tabs.Aim:Toggle({
    Title = "Aumentar Hitbox",
    Desc = "Expande la caja de colisión de los enemigos para que no falles balas.",
    Value = false,
    Callback = function(s) 
        task.spawn(function()
            hitboxEnabled = s 
            if not s then
                for _, v in pairs(Players:GetPlayers()) do
                    if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        local hrp = v.Character.HumanoidRootPart
                        hrp.Size = Vector3.new(2, 2, 1)
                        hrp.Transparency = 1
                        hrp.Material = Enum.Material.Plastic
                        hrp.CanCollide = true
                        local box = hrp:FindFirstChild("AstraHitboxBox")
                        if box then box:Destroy() end
                    end
                end
            end
        end)
    end
})

UIElements.TogHbInv = Tabs.Aim:Toggle({
    Title = "Hitbox Invisible", 
    Desc = "Oculta las cajas de los enemigos.",
    Value = false,
    Callback = function(s) hitboxInvisible = s end
})

UIElements.SliHitbox = Tabs.Aim:Slider({
    Title = "Tamaño de Hitbox",
    Desc = "10 - 20 max recomendado",
    Step = 1,
    Value = {Min = 2, Max = 50, Default = 10}, 
    Callback = function(v) hitboxSize = v end
})

Tabs.Aim:Input({
    Title = "Escribir Tamaño Exacto",
    Placeholder = "Ej: 2, 12, 25...",
    Callback = function(Text)
        local num = tonumber(Text)
        if num then
            hitboxSize = num
            pcall(function() if num >= 2 and num <= 50 then UIElements.SliHitbox:Set(num) end end)
            showBottomMessage("Hitbox fijada en: " .. num)
        end
    end,
})

local hitboxesLimpias = false

task.spawn(function()
    if getgenv().AstraHitboxLoop then getgenv().AstraHitboxLoop = false task.wait(0.2) end
    getgenv().AstraHitboxLoop = true

    local function limpiarHitbox(v)
        if v and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = v.Character.HumanoidRootPart
            hrp.Size = Vector3.new(2, 2, 1) 
            hrp.Transparency = 1 
            hrp.Material = Enum.Material.Plastic 
            hrp.CanCollide = true
            local box = hrp:FindFirstChild("AstraHitboxBox") 
            if box then box:Destroy() end
        end
    end

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude

    while getgenv().AstraHitboxLoop and task.wait(0.1) do
        local enLobby = false 
        pcall(function() enLobby = estaEnLobby() end)
        
        if hitboxEnabled and not enLobby then
            hitboxesLimpias = false
            
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= player and isEnemy(v) and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                    local hrp = v.Character.HumanoidRootPart 
                    local targetSize = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                    if hrp.Size ~= targetSize then hrp.Size = targetSize end
                    if hrp.CanCollide ~= false then hrp.CanCollide = false end
                    
                    local aLaVista = false
                    if player.Character and player.Character:FindFirstChild("Head") then
                        local origin = camera.CFrame.Position 
                        if (hrp.Position - origin).Magnitude < 300 then
                            params.FilterDescendantsInstances = {player.Character, v.Character}
                            local result = workspace:Raycast(origin, hrp.Position - origin, params) 
                            aLaVista = not result 
                        end
                    end
                    
                    local targetColor = aLaVista and espColor or Color3.fromRGB(255, 50, 50)
                    local targetTrans = hitboxInvisible and 1 or (aLaVista and 0.4 or 0.8)
                    
                    if hrp.Transparency ~= targetTrans then hrp.Transparency = targetTrans end
                    if hrp.Material ~= Enum.Material.ForceField then hrp.Material = Enum.Material.ForceField end
                    if hrp.Color ~= targetColor then hrp.Color = targetColor end
                    
                    local box = hrp:FindFirstChild("AstraHitboxBox")
                    if not box then 
                        box = Instance.new("BoxHandleAdornment") 
                        box.Name = "AstraHitboxBox" 
                        box.Adornee = hrp 
                        box.AlwaysOnTop = true 
                        box.ZIndex = 5 
                        box.Parent = hrp 
                    end
                    
                    if box.Size ~= hrp.Size then box.Size = hrp.Size end
                    if box.Color3 ~= targetColor then box.Color3 = targetColor end
                    
                    local targetBoxTrans = hitboxInvisible and 1 or (aLaVista and 0.2 or 0.7)
                    if box.Transparency ~= targetBoxTrans then box.Transparency = targetBoxTrans end
                    if box.Visible ~= not hitboxInvisible then box.Visible = not hitboxInvisible end
                else 
                    limpiarHitbox(v) 
                end
            end
        else 
            if not killAllEnabled and not hitboxesLimpias then
                for _, v in pairs(Players:GetPlayers()) do 
                    if v ~= player then limpiarHitbox(v) end 
                end 
                hitboxesLimpias = true
            end
        end
    end
end)

local spoofLoop = nil
local isWorkspaceLooping = false
local originalData = {}

local function safeReplace(str, find, replace) local safeFind = find:gsub("[%-%^%$%(%)%%%.%[%]%*%+%?]", "%%%1") return (str:gsub(safeFind, replace)) end
local function processText(v, myName, myDisp)
    local parentGui = v:FindFirstAncestorWhichIsA("ScreenGui")
    if parentGui and (string.find(parentGui.Name, "WindUI") or string.find(parentGui.Name, "Onyx")) then return end

    if v:IsA("TextLabel") or v:IsA("TextBox") or v:IsA("TextButton") then
        local txt = v.Text local hasName = false
        if txt and txt ~= "" then if string.find(txt, myName, 1, true) or string.find(txt, myDisp, 1, true) then hasName = true end end
        if hasName and not originalData[v] then
            originalData[v] = { Text = txt, Color = v.TextColor3, TextTransp = v.TextTransparency, StrokeTransp = v.TextStrokeTransparency, Strokes = {} }
            for _, obj in pairs(v:GetChildren()) do if obj:IsA("UIStroke") then originalData[v].Strokes[obj] = { Enabled = obj.Enabled, Transp = obj.Transparency, Thickness = obj.Thickness } end end
        end
        if originalData[v] then
            if fakeNameEnabled or creatorTagEnabled then
                local newText = originalData[v].Text local baseName = fakeNameEnabled and spoofNameText or myDisp
                newText = string.gsub(newText, "%[VIP%] ", "") newText = string.gsub(newText, "%[VIP%]", "") newText = string.gsub(newText, "<font color=\"#bee1e7\">%[Content Creator%]</font> ", "") newText = string.gsub(newText, "%[Content Creator%] ", "") newText = string.gsub(newText, "%[Content Creator%]", "")
                local isOverheadTag = false
                if player.Character then
                    if v:IsDescendantOf(player.Character) then isOverheadTag = true
                    else local parentGui = v:FindFirstAncestorWhichIsA("BillboardGui") if parentGui and parentGui.Adornee and parentGui.Adornee:IsDescendantOf(player.Character) then isOverheadTag = true end end
                end
                local finalName = baseName
                if creatorTagEnabled and isOverheadTag then v.RichText = true finalName = '<font color="#bee1e7">[Content Creator]</font> ' .. baseName end
                newText = safeReplace(newText, myName, finalName) newText = safeReplace(newText, myDisp, finalName)
                v.Text = newText v.TextTransparency = originalData[v].TextTransp v.TextStrokeTransparency = originalData[v].StrokeTransp
                for _, obj in pairs(v:GetChildren()) do if obj:IsA("UIStroke") and originalData[v].Strokes[obj] then obj.Enabled = originalData[v].Strokes[obj].Enabled end end
                if rainbowEnabled then v.TextColor3 = Color3.fromHSV(tick() % 4 / 4, 1, 1) else v.TextColor3 = originalData[v].Color end
            elseif hideNameEnabled then
                v.Text = " " v.TextTransparency = 1 v.TextStrokeTransparency = 1
                for _, obj in pairs(v:GetChildren()) do if obj:IsA("UIStroke") then obj.Enabled = false obj.Transparency = 1 obj.Thickness = 0 end end
            else
                v.Text = originalData[v].Text
                if rainbowEnabled then v.TextColor3 = Color3.fromHSV(tick() % 4 / 4, 1, 1) else v.TextColor3 = originalData[v].Color end
                v.TextTransparency = originalData[v].TextTransp v.TextStrokeTransparency = originalData[v].StrokeTransp
                for _, obj in pairs(v:GetChildren()) do if obj:IsA("UIStroke") and originalData[v].Strokes[obj] then obj.Enabled = originalData[v].Strokes[obj].Enabled obj.Transparency = originalData[v].Strokes[obj].Transp obj.Thickness = originalData[v].Strokes[obj].Thickness end end
            end
        end
    end
end
local visualConnections = {}

local function updateSystem()
    local myName = player.Name 
    local myDisp = player.DisplayName

    task.spawn(function() 
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character then
                for _, v in pairs(p.Character:GetDescendants()) do
                    if v:IsA("TextLabel") or v:IsA("TextBox") then processText(v, myName, myDisp) end
                end
            end
        end
        local pGui = player:FindFirstChild("PlayerGui")
        if pGui then
            for _, v in pairs(pGui:GetDescendants()) do
                if v:IsA("TextLabel") or v:IsA("TextBox") then processText(v, myName, myDisp) end
            end
        end
    end)

    if hideNameEnabled or fakeNameEnabled or rainbowEnabled or creatorTagEnabled then
        if not isWorkspaceLooping then
            isWorkspaceLooping = true
            
            local function infectarTextoSeguro(v)
                local parentGui = v:FindFirstAncestorWhichIsA("ScreenGui")
                if parentGui and (string.find(parentGui.Name, "WindUI") or string.find(parentGui.Name, "Onyx")) then return end

                if v:IsA("TextLabel") or v:IsA("TextBox") or v:IsA("TextButton") then
                    processText(v, myName, myDisp) 
                    if not v:GetAttribute("AstraInfectado") then
                        v:SetAttribute("AstraInfectado", true)
                        v:GetPropertyChangedSignal("Text"):Connect(function()
                            if isWorkspaceLooping and v.Text ~= spoofNameText and v.Text ~= " " and not string.find(v.Text, spoofNameText) and not string.find(v.Text, "%[Content Creator%]") then
                                originalData[v] = nil 
                                processText(v, myName, myDisp)
                            end
                        end)
                    end
                end
            end

            local pGui = player:FindFirstChild("PlayerGui")
            if pGui then
                table.insert(visualConnections, pGui.DescendantAdded:Connect(function(nuevoObjeto) 
                    if isWorkspaceLooping and (nuevoObjeto:IsA("TextLabel") or nuevoObjeto:IsA("TextBox") or nuevoObjeto:IsA("TextButton")) then 
                        task.spawn(function() infectarTextoSeguro(nuevoObjeto) end) 
                    end 
                end))
            end
            
            local successCore, coreGui = pcall(function() return game:GetService("CoreGui") end)
            if successCore and coreGui then
                table.insert(visualConnections, coreGui.DescendantAdded:Connect(function(nuevoObjeto) 
                    if isWorkspaceLooping and (nuevoObjeto:IsA("TextLabel") or nuevoObjeto:IsA("TextBox") or nuevoObjeto:IsA("TextButton")) then 
                        task.spawn(function() infectarTextoSeguro(nuevoObjeto) end) 
                    end 
                end))
            end
        end 
    else
        isWorkspaceLooping = false
        
        for _, conn in ipairs(visualConnections) do conn:Disconnect() end
        visualConnections = {}
        
        local char = player.Character if char then local hum = char:FindFirstChild("Humanoid") if hum then hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer end end
        
        for v, data in pairs(originalData) do
            if v and v.Parent then
                v.Text = data.Text v.TextColor3 = data.Color v.TextTransparency = data.TextTransp v.TextStrokeTransparency = data.StrokeTransp
                for stroke, strokeData in pairs(data.Strokes) do if stroke and stroke.Parent then stroke.Enabled = strokeData.Enabled stroke.Transparency = strokeData.Transp stroke.Thickness = strokeData.Thickness end end
            end
        end
    end
end

UIElements.TogHideName = Tabs.Vis:Toggle({
    Title = "Ocultar mi Nombre (Visual)", 
    Desc = "Vuelve tu nombre invisible en tu pantalla.",
    Callback = function(s) hideNameEnabled = s updateSystem() showBottomMessage(s and "Nombre invisible." or "Nombre visible.") end
})

UIElements.TogFakeName = Tabs.Vis:Toggle({
    Title = "Activar Nombre Falso", 
    Desc = "Reemplaza tu nombre por uno falso (Solo tú lo ves).",
    Callback = function(s) fakeNameEnabled = s updateSystem() showBottomMessage(s and "Nombre falso activado." or "Nombre falso desactivado.") end
})

UIElements.TogTag = Tabs.Vis:Toggle({
    Title = "Tag [Content Creator]", 
    Desc = "Te pone la etiqueta de creador de contenido.",
    Callback = function(s) creatorTagEnabled = s updateSystem() pcall(function() showBottomMessage(s and "Tag de Creador activado." or "Tag de Creador desactivado.") end) end
})

Tabs.Vis:Input({Title = "Nuevo Nombre", Placeholder = "Escribe tu nombre falso...", Callback = function(t) if t ~= "" then spoofNameText = t if fakeNameEnabled then updateSystem() end showBottomMessage("Nombre guardado: " .. spoofNameText) end end})
UIElements.TogRbw = Tabs.Vis:Toggle({
    Title = "Efecto arcoíris en nombre", 
    Desc = "Hace que tu nombre brille cambiando de colores RGB.",
    Callback = function(s) rainbowEnabled = s updateSystem() end
})

Tabs.Vis:Section({Title = "Configuración de ESP"})
UIElements.TogEsp = Tabs.Vis:Toggle({
    Title = "ESP Jugadores", 
    Desc = "Te permite ver a todos los enemigos a través de las paredes.",
    Callback = function(s) espEnabled = s end
})
UIElements.ColEsp = Tabs.Vis:Colorpicker({Title = "Color del ESP", Default = Color3.fromRGB(255,255,255), Callback = function(c) espColor = c end})

Tabs.Vis:Section({Title = "Filtros de ESP"})
UIElements.TogEspGl = Tabs.Vis:Toggle({Title = "Mostrar Resplandor", Value = true, Callback = function(s) espSettings.Glow = s end})
UIElements.TogEspNm = Tabs.Vis:Toggle({Title = "Mostrar Nombre", Value = true, Callback = function(s) espSettings.Name = s end})
UIElements.TogEspHp = Tabs.Vis:Toggle({Title = "Mostrar Vida", Value = true, Callback = function(s) espSettings.Health = s end})
UIElements.TogEspDs = Tabs.Vis:Toggle({Title = "Mostrar Distancia", Value = true, Callback = function(s) espSettings.Distance = s end})

local espLinesEnabled = false
UIElements.TogEspLines = Tabs.Vis:Toggle({
    Title = "Mostrar Líneas", 
    Desc = "Dibuja una línea desde el centro de tu pantalla hasta cada enemigo.",
    Callback = function(s) espLinesEnabled = s end
})

local activeESPs = {} 
local MAX_ESP_DISTANCE = 1500 

local function cleanESP(targetPlayer)
    if activeESPs[targetPlayer] then
        if activeESPs[targetPlayer].Highlight then activeESPs[targetPlayer].Highlight:Destroy() end
        if activeESPs[targetPlayer].Billboard then activeESPs[targetPlayer].Billboard:Destroy() end
        activeESPs[targetPlayer] = nil
    end
end

task.spawn(function()
    while task.wait(0.2) do
        if espEnabled and not estaEnLobby() then
            local myChar = player.Character
            local myHead = myChar and myChar:FindFirstChild("Head")
            local myPos = myHead and myHead.Position

            for _, p in pairs(Players:GetPlayers()) do
                if p ~= player then
                    local char = p.Character
                    if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 and char:FindFirstChild("Head") and isEnemy(p) then
                        local targetHead = char.Head
                        local dist = myPos and (targetHead.Position - myPos).Magnitude or 0
                        
                        if dist <= MAX_ESP_DISTANCE then
                            if activeESPs[p] and activeESPs[p].Char ~= char then cleanESP(p) end
                            
                            if not activeESPs[p] then
                                local highlight = Instance.new("Highlight") 
                                highlight.Name = p.Name.."_Glow" 
                                highlight.FillTransparency = 0.6
                                highlight.OutlineTransparency = 1 
                                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop 
                                highlight.Adornee = char 
                                highlight.Parent = espFolder
                                
                                local billboard = Instance.new("BillboardGui") 
                                billboard.Name = p.Name.."_Tag" 
                                billboard.Size = UDim2.new(0, 200, 0, 75)
                                billboard.StudsOffset = Vector3.new(0, 3.5, 0) 
                                billboard.AlwaysOnTop = true 
                                billboard.Adornee = targetHead 
                                billboard.Parent = espFolder
                                
                                local textLabel = Instance.new("TextLabel") 
                                textLabel.Name = "Text" 
                                textLabel.Size = UDim2.new(1, 0, 1, 0) 
                                textLabel.BackgroundTransparency = 1 
                                textLabel.TextStrokeTransparency = 1
                                textLabel.RichText = true 
                                textLabel.Font = Enum.Font.SourceSansBold
                                textLabel.TextSize = 14
                                textLabel.TextYAlignment = Enum.TextYAlignment.Bottom
                                textLabel.Parent = billboard

                                local stroke = Instance.new("UIStroke")
                                stroke.Color = Color3.fromRGB(0, 0, 0)
                                stroke.Thickness = 1.2
                                stroke.Parent = textLabel
                                
                                activeESPs[p] = {Highlight = highlight, Billboard = billboard, Char = char, Text = textLabel}
                            end
                            
                            local espObj = activeESPs[p]

                            if espObj.Highlight.Enabled ~= espSettings.Glow then espObj.Highlight.Enabled = espSettings.Glow end
                            if espObj.Highlight.FillColor ~= espColor then espObj.Highlight.FillColor = espColor end
                            
                            local infoText = ""
                            
                            if espSettings.Name then 
                                local hexESP = string.format("#%02X%02X%02X", espColor.R * 255, espColor.G * 255, espColor.B * 255)
                                infoText = '<font color="' .. hexESP .. '">' .. p.Name .. '</font>' 
                            end 
                            
                            if espSettings.Health then 
                                local hp = math.floor(char.Humanoid.Health)
                                local maxHp = char.Humanoid.MaxHealth > 0 and char.Humanoid.MaxHealth or 100
                                
                                local hpColor = "#2ecc71"
                                if (hp / maxHp) <= 0.35 then hpColor = "#e74c3c"
                                elseif (hp / maxHp) <= 0.7 then hpColor = "#f1c40f" end
                                
                                local separador = infoText == "" and "" or "\n"
                                infoText = infoText .. separador .. '<font size="12" color="'.. hpColor ..'">[' .. hp .. ' HP]</font>'
                            end
                            
                            if espSettings.Distance then 
                                local separador = infoText == "" and "" or "\n"
                                infoText = infoText .. separador .. '<font size="11" color="#bdc3c7">' .. math.floor(dist) .. 'm</font>'
                            end
                            
                            if infoText ~= "" then 
                                if not espObj.Billboard.Enabled then espObj.Billboard.Enabled = true end
                                if espObj.Text.Text ~= infoText then espObj.Text.Text = infoText end
                            else 
                                if espObj.Billboard.Enabled then espObj.Billboard.Enabled = false end
                            end
                        else cleanESP(p) end
                    else cleanESP(p) end
                end
            end
        else for _, p in pairs(Players:GetPlayers()) do cleanESP(p) end end
    end
end)

local FOVCircle = Drawing.new("Circle")
FOVCircle.Filled = false
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Visible = false
FOVCircle.Thickness = 1

local tracerLines = {}

RunService.RenderStepped:Connect(function()
    local viewport = camera.ViewportSize
    local centroVector = Vector2.new(viewport.X / 2, viewport.Y / 2)
    local centroPantallaX = centroVector.X
    local centroPantallaY = centroVector.Y

    if fovVisiblePreference then
        FOVCircle.Position = centroVector
        FOVCircle.Radius = fovRadius
        FOVCircle.Visible = true
        if silentAimFovEnabled and getgenv().AstraTargetPart then
            FOVCircle.Color = Color3.fromRGB(0, 255, 0)
        else
            FOVCircle.Color = Color3.fromRGB(255, 255, 255)
        end
    else
        if FOVCircle.Visible then FOVCircle.Visible = false end
    end

    if not espEnabled or not espLinesEnabled or estaEnLobby() then
        for _, tLine in pairs(tracerLines) do 
            if tLine.Visible then tLine.Visible = false end 
        end
        return
    end

    local myChar = player.Character
    local myPos = (myChar and myChar.PrimaryPart) and myChar.PrimaryPart.Position or camera.CFrame.Position
    
    local rawPlayers = Players:GetChildren()
    
    for i = 1, #rawPlayers do
        local p = rawPlayers[i]
        
        if p:IsA("Player") and p ~= player then
            local tLine = tracerLines[p]
            if not tLine then
                tLine = Drawing.new("Line")
                tLine.Thickness = 1.5
                tLine.Transparency = 1
                tLine.Visible = false
                tracerLines[p] = tLine
            end

            local char = p.Character
            local hrp = char and char.PrimaryPart
            
            if hrp and isEnemy(p) then
                local hum = char:FindFirstChild("Humanoid")
                if hum and hum.Health > 0 then
                    local dist = (myPos - hrp.Position).Magnitude
                    
                    if dist <= MAX_ESP_DISTANCE then
                        local hrpPos, onScreen = camera:WorldToViewportPoint(hrp.Position)
                        if onScreen then
                            if tLine.From.X ~= centroPantallaX then tLine.From = Vector2.new(centroPantallaX, 0) end
                            tLine.To = Vector2.new(hrpPos.X, hrpPos.Y)
                            
                            if tLine.Color ~= espColor then tLine.Color = espColor end
                            if not tLine.Visible then tLine.Visible = true end
                            continue
                        end
                    end
                end
            end
            
            if tLine.Visible then tLine.Visible = false end
        end
    end
end)

Players.PlayerRemoving:Connect(function(p)
    if tracerLines[p] then tracerLines[p]:Remove(); tracerLines[p] = nil end
    cleanESP(p)
end)

Tabs.Mov:Section({Title = "Caminar rapido"})
local speedEnabled = false local walkSpeedValue = 50
Tabs.Mov:Toggle({
    Title = "Activar Speed Hack", 
    Desc = "Modifica tu velocidad.",
    Callback = function(s) speedEnabled = s local char = player.Character if not s and char and char:FindFirstChild("Humanoid") then char.Humanoid.WalkSpeed = 16 end end
})

Tabs.Mov:Slider({Title = "Velocidad de Caminar", Step = 1, Value = {Min = 16, Max = 250, Default = 50}, Callback = function(v) walkSpeedValue = v if speedEnabled then local char = player.Character if char and char:FindFirstChild("Humanoid") then char.Humanoid.WalkSpeed = walkSpeedValue end end end})
task.spawn(function() while task.wait(0.1) do if speedEnabled then local char = player.Character if char and char:FindFirstChild("Humanoid") then char.Humanoid.WalkSpeed = walkSpeedValue end end end end)

local noclipConnection = nil
Tabs.Mov:Toggle({Title = "Atravesar Paredes", Callback = function(s)
    if s then if not noclipConnection then noclipConnection = RunService.Stepped:Connect(function() local char = player.Character if char then for _, part in pairs(char:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = false end end end end) end
    else if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end end
end})

_G.EditFloatingButtons = true
_G.FloatingButtonsShape = "Rectángulo"
local floatingButtonsList = {}

local function createFloatingBtn(name, startPos, internalId)
    local btn = Instance.new("TextButton")
    btn.Name = internalId or name
    btn.Size = UDim2.new(0, 150, 0, 45)
    btn.Position = startPos
    btn.BackgroundColor3 = Color3.fromHex("#0a0a10")
    btn.BackgroundTransparency = 0.3 
    btn.Text = name
    btn.TextColor3 = Color3.fromHex("#f8fafc")
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 14
    btn.AutoButtonColor = false
    btn.Visible = false
    btn.ZIndex = 50
    btn.Parent = screenGui
    
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1.2
    stroke.Color = Color3.fromHex("#2a2a3d") 
    stroke.Transparency = 0.5
    stroke.Parent = btn

    btn.MouseEnter:Connect(function()
        if _G.AstraBotonesOcultos then return end
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromHex("#1a1a24"), BackgroundTransparency = 0.1}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.2), {Color = Color3.fromHex("#0076ad"), Transparency = 0}):Play()
    end)
    btn.MouseLeave:Connect(function()
        if _G.AstraBotonesOcultos then return end
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromHex("#0a0a10"), BackgroundTransparency = 0.3}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.2), {Color = Color3.fromHex("#2a2a3d"), Transparency = 0.5}):Play()
    end)

    makeDraggable(btn, btn)
    
    local dragStartPos = nil; local validClick = false
    btn.InputBegan:Connect(function(input) 
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
            dragStartPos = input.Position; validClick = true 
        end 
    end)
    btn.InputChanged:Connect(function(input) 
        if dragStartPos and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then 
            if (input.Position - dragStartPos).Magnitude > 5 then validClick = false end 
        end 
    end)
    
    table.insert(floatingButtonsList, btn)
    return btn, function() return validClick end, stroke
end

Tabs.Mov:Section({Title = "Modo Fantasma y vuelo"})

local isInvisible = false
local invisSeat = nil
local invisBg = nil
local invisBv = nil
local invisFlySpeed = 40 
local originalTransparencies = {}

local function ToggleGhostSeatMode(state)
    isInvisible = state
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local torso = char and (char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso"))
    local hum = char and char:FindFirstChild("Humanoid")
    
    if not char or not hrp or not torso or not hum then return end

    if isInvisible then
        for _, obj in pairs(char:GetDescendants()) do
            if obj:IsA("BasePart") or obj:IsA("Decal") or obj:IsA("Texture") then
                if obj.Name ~= "HumanoidRootPart" then
                    if not originalTransparencies[obj] then 
                        originalTransparencies[obj] = obj.Transparency 
                    end
                    obj.Transparency = 1
                end
            elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("BillboardGui") then
                obj.Enabled = false
            end
        end
        
        local savedCFrame = hrp.CFrame + Vector3.new(0, 1.5, 0) 
        
        hrp.CFrame = hrp.CFrame + Vector3.new(0, 3, 0)
        hum.PlatformStand = true 
        task.wait(0.05)
        
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        
        hrp.CFrame = CFrame.new(0, 5000, 0)
        hrp.Anchored = true 
        task.wait(0.05)
        
        invisSeat = Instance.new("Seat")
        invisSeat.Name = "AstraGhostSeat"
        invisSeat.Anchored = false
        invisSeat.CanCollide = false
        invisSeat.Transparency = 1
        invisSeat.Position = Vector3.new(0, 5000, 0)
        invisSeat.Parent = workspace
        
        local weld = Instance.new("Weld")
        weld.Part0 = invisSeat
        weld.Part1 = torso
        weld.Parent = invisSeat
        
        task.wait(0.05)
        
        invisSeat.CFrame = savedCFrame
        hrp.Anchored = false
        
        invisBg = Instance.new("BodyGyro")
        invisBg.P = 9e4
        invisBg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        invisBg.cframe = invisSeat.CFrame
        invisBg.Parent = invisSeat
        
        invisBv = Instance.new("BodyVelocity")
        invisBv.velocity = Vector3.zero
        invisBv.maxForce = Vector3.new(9e9, 9e9, 9e9)
        invisBv.Parent = invisSeat
    else
        if invisBg then invisBg:Destroy(); invisBg = nil end
        if invisBv then invisBv:Destroy(); invisBv = nil end
        if invisSeat then invisSeat:Destroy(); invisSeat = nil end
        
        if hum then hum.PlatformStand = false end
        
        for obj, trans in pairs(originalTransparencies) do
            if obj and obj.Parent then 
                obj.Transparency = trans 
            end
        end
        originalTransparencies = {}
        
        for _, obj in pairs(char:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("BillboardGui") then
                obj.Enabled = true
            end
        end
    end
end

local ghostBtn, getGhostClick, ghostStroke = createFloatingBtn("Fantasma: OFF", UDim2.new(0.8, -150, 0.5, 0), "BtnFantasma")

local asBtn, getAsClick, asStroke = createFloatingBtn("AutoShoot: OFF", UDim2.new(0.8, -150, 0.35, 0), "BtnAutoShoot")

asBtn.MouseButton1Click:Connect(function() 
    if not getAsClick() then return end 
    local newState = not autoShootEnabled 
    
    task.spawn(function()
        pcall(function() UIElements.TogAutoShoot:Set(newState) end)
        
        if newState then
            asBtn.Text = "AutoShoot: ON"
            asBtn.TextColor3 = Color3.fromRGB(168, 199, 250)
            asStroke.Color = Color3.fromRGB(255, 255, 255)
        else
            asBtn.Text = "AutoShoot: OFF"
            asBtn.TextColor3 = Color3.fromHex("#f8fafc")
            asStroke.Color = Color3.fromHex("#2a2a3d")
        end
    end)
end)

local saBtn, getSaClick, saStroke = createFloatingBtn("Silent Aim: OFF", UDim2.new(0.8, -150, 0.45, 0), "BtnSilentAim")

saBtn.MouseButton1Click:Connect(function() 
    if not getSaClick() then return end 
    local newState = not silentAimManualEnabled 
    
    task.spawn(function()
        pcall(function() UIElements.TogSilentAimManual:Set(newState) end)
        
        if newState then
            saBtn.Text = "Silent Aim: ON"
            saBtn.TextColor3 = Color3.fromRGB(168, 199, 250)
            saStroke.Color = Color3.fromRGB(255, 255, 255)
        else
            saBtn.Text = "Silent Aim: OFF"
            saBtn.TextColor3 = Color3.fromHex("#f8fafc")
            saStroke.Color = Color3.fromHex("#2a2a3d")
        end
    end)
end)

UIElements.ToggleAsBtn = Tabs.Aim:Toggle({
    Title = "Mostrar Botón Flotante (AutoShoot)",
    Value = false,
    Callback = function(state)
        asBtn.Visible = state
    end
})

UIElements.ToggleSaBtn = Tabs.Aim:Toggle({
    Title = "Mostrar Botón Flotante (Silent Aim)",
    Value = false,
    Callback = function(state)
        saBtn.Visible = state
    end
})

ghostBtn.MouseButton1Click:Connect(function() 
    if not getGhostClick() then return end 
    
    local newState = not isInvisible 
    task.spawn(function()
        ToggleGhostSeatMode(newState)
        
        if newState then
            ghostBtn.Text = "Fantasma: ON"
            ghostBtn.TextColor3 = Color3.fromRGB(168, 199, 250)
            ghostStroke.Color = Color3.fromRGB(255, 255, 255)
        else
            ghostBtn.Text = "Fantasma: OFF"
            ghostBtn.TextColor3 = Color3.fromHex("#f8fafc")
            ghostStroke.Color = Color3.fromHex("#2a2a3d")
        end
        
        showBottomMessage(newState and "Fantasma: ACTIVADO" or "Fantasma: DESACTIVADO")
    end)
end)

UIElements.ToggleGhost = Tabs.Mov:Toggle({
    Title = "Mostrar Botón Fantasma",
    Value = false,
    Callback = function(state)
        ghostBtn.Visible = state
        if not state and isInvisible then 
            task.spawn(function()
                ToggleGhostSeatMode(false) 
                ghostBtn.Text = "Fantasma: OFF"
                ghostBtn.TextColor3 = Color3.fromHex("#f8fafc")
                ghostStroke.Color = Color3.fromHex("#2a2a3d")
            end)
        end
    end
})

UIElements.SliderGhostSpeed = Tabs.Mov:Slider({
    Title = "Velocidad Fantasma", 
    Step = 1, 
    Value = {Min = 10, Max = 150, Default = 40}, 
    Callback = function(Value) invisFlySpeed = Value end 
})

local cachedGhostControls = nil
RunService.RenderStepped:Connect(function()
    if isInvisible and invisSeat and invisBv and invisBg then
        if not cachedGhostControls then
            local pScripts = player:FindFirstChild("PlayerScripts")
            if pScripts then 
                local pModule = pScripts:FindFirstChild("PlayerModule") 
                if pModule then 
                    local PlayerModule = require(pModule)
                    cachedGhostControls = PlayerModule:GetControls()
                end
            end
        end
        
        if cachedGhostControls then 
            local moveVector = cachedGhostControls:GetMoveVector()
            local moveDir = camera.CFrame:VectorToWorldSpace(moveVector)
            
            invisBv.Velocity = moveDir * invisFlySpeed
            invisBg.CFrame = camera.CFrame 
        end
    end
end)

player.CharacterAdded:Connect(function()
    isInvisible = false
    if invisBg then invisBg:Destroy(); invisBg = nil end
    if invisBv then invisBv:Destroy(); invisBv = nil end
    if invisSeat then invisSeat:Destroy(); invisSeat = nil end
    originalTransparencies = {}
    
    if ghostBtn then
        ghostBtn.Text = "Fantasma: OFF"
        ghostBtn.TextColor3 = Color3.fromHex("#f8fafc")
        if ghostStroke then ghostStroke.Color = Color3.fromHex("#2a2a3d") end
    end
end)

Tabs.Graficos:Section({Title = "Modos Visuales (Elige solo uno)"})

local shaderEffects = {}
local tokyowamiEffects = {}
local nightEffects = {}
local pinkEffects = {}
local nightActivo = false
local pinkActivo = false

local shaderAjustes = {
    Exposicion = 0.28,
    Sombras = 5,
    Neon = 0.45,
    LunaPos = 85,          
    Desenfoque = 2,        
    SuavidadSombras = 0.1, 
    ColorSaturacion = 0.15,
    
    PinkRosa = 0.8,
    PinkMorado = 0.7,
    PinkSaturacion = 0.4,
    PinkNeon = 0.3
}

local function ToggleNubesYAtmo(apagar, tag)
    local Lighting = game:GetService("Lighting")
    
    for _, obj in ipairs(Lighting:GetChildren()) do
        if obj:IsA("Atmosphere") then
            if apagar then
                if not obj:GetAttribute("OrigGuardado_"..tag) then
                    obj:SetAttribute("OrigDensity_"..tag, obj.Density)
                    obj:SetAttribute("OrigCapacity_"..tag, obj.Capacity)
                    obj:SetAttribute("OrigGuardado_"..tag, true)
                end
                obj.Density = 0
                obj.Capacity = 0
            else
                if obj:GetAttribute("OrigGuardado_"..tag) then
                    obj.Density = obj:GetAttribute("OrigDensity_"..tag)
                    obj.Capacity = obj:GetAttribute("OrigCapacity_"..tag)
                    obj:SetAttribute("OrigGuardado_"..tag, nil)
                end
            end
        end
    end
    
    local function checkClouds(parentObj)
        if not parentObj then return end
        for _, obj in ipairs(parentObj:GetChildren()) do
            if obj:IsA("Clouds") then
                if apagar then
                    if not obj:GetAttribute("OrigGuardado_"..tag) then
                        obj:SetAttribute("OrigEnabled_"..tag, obj.Enabled)
                        obj:SetAttribute("OrigGuardado_"..tag, true)
                    end
                    obj.Enabled = false
                else
                    if obj:GetAttribute("OrigGuardado_"..tag) then
                        obj.Enabled = obj:GetAttribute("OrigEnabled_"..tag)
                        obj:SetAttribute("OrigGuardado_"..tag, nil)
                    end
                end
            end
        end
    end
    
    checkClouds(workspace)
    checkClouds(workspace:FindFirstChildOfClass("Terrain"))
end

local function UpdatePinkHourVibe()
    if not pinkActivo then return end
    local Lighting = game:GetService("Lighting")
    
    local rosa = shaderAjustes.PinkRosa
    local morado = shaderAjustes.PinkMorado
    
    local r = math.clamp(math.floor(255 - (100 * morado)), 0, 255)
    local g = math.clamp(math.floor(255 - (155 * rosa) - (200 * morado)), 0, 255)
    local b = 255
    
    for _, effect in ipairs(pinkEffects) do
        if effect:IsA("ColorCorrectionEffect") then
            effect.TintColor = Color3.fromRGB(r, g, b)
            effect.Saturation = shaderAjustes.PinkSaturacion
            effect.Contrast = 0.05 + (0.1 * morado) + (0.05 * rosa)
        elseif effect:IsA("BloomEffect") then
            effect.Intensity = shaderAjustes.PinkNeon
        end
    end
    
    Lighting.ColorShift_Top = Color3.fromRGB(math.floor(255 - (50 * morado)), math.floor(50 + (50 * (1-rosa))), math.floor(150 + (105 * morado)))
    Lighting.ColorShift_Bottom = Color3.fromRGB(math.floor(30 + (70 * rosa)), 0, math.floor(50 + (80 * morado)))
    Lighting.OutdoorAmbient = Color3.fromRGB(math.floor(50 + (80 * rosa)), 0, math.floor(80 + (80 * morado)))
    Lighting.Ambient = Color3.fromRGB(math.floor(60 + (30 * rosa)), math.floor(20 * (1-morado)), math.floor(80 + (40 * morado)))
    
    Lighting.ExposureCompensation = 0.1 - (0.25 * morado)
end

UIElements.TogTokyowami = Tabs.Graficos:Toggle({
    Title = "Shaders Tokyowami",
    Desc = "Aplica Shaders originales.",
    Callback = function(Value)
        local Lighting = game:GetService("Lighting")

        if Value then
            if not Lighting:GetAttribute("OrigSaved") then
                Lighting:SetAttribute("OrigBright", Lighting.Brightness) Lighting:SetAttribute("OrigCSB", Lighting.ColorShift_Bottom) Lighting:SetAttribute("OrigCST", Lighting.ColorShift_Top) Lighting:SetAttribute("OrigOA", Lighting.OutdoorAmbient) Lighting:SetAttribute("OrigTime", Lighting.ClockTime) Lighting:SetAttribute("OrigFogC", Lighting.FogColor) Lighting:SetAttribute("OrigFogE", Lighting.FogEnd) Lighting:SetAttribute("OrigFogS", Lighting.FogStart) Lighting:SetAttribute("OrigExp", Lighting.ExposureCompensation) Lighting:SetAttribute("OrigShadow", Lighting.ShadowSoftness) Lighting:SetAttribute("OrigAmbient", Lighting.Ambient) Lighting:SetAttribute("OrigSaved", true)
            end

            for _, v in ipairs(tokyowamiEffects) do pcall(function() v:Destroy() end) end table.clear(tokyowamiEffects)

            local Bloom = Instance.new("BloomEffect") Bloom.Intensity = 0.1 Bloom.Threshold = 0 Bloom.Size = 100 Bloom.Parent = Lighting table.insert(tokyowamiEffects, Bloom)
            local Tropic = Instance.new("Sky") Tropic.Name = "Tropic" Tropic.SkyboxUp = "http://www.roblox.com/asset/?id=169210149" Tropic.SkyboxLf = "http://www.roblox.com/asset/?id=169210133" Tropic.SkyboxBk = "http://www.roblox.com/asset/?id=169210090" Tropic.SkyboxFt = "http://www.roblox.com/asset/?id=169210121" Tropic.StarCount = 100 Tropic.SkyboxDn = "http://www.roblox.com/asset/?id=169210108" Tropic.SkyboxRt = "http://www.roblox.com/asset/?id=169210143" Tropic.Parent = Lighting table.insert(tokyowamiEffects, Tropic)
            local Sky = Instance.new("Sky") Sky.SkyboxUp = "http://www.roblox.com/asset/?id=196263782" Sky.SkyboxLf = "http://www.roblox.com/asset/?id=196263721" Sky.SkyboxBk = "http://www.roblox.com/asset/?id=196263721" Sky.SkyboxFt = "http://www.roblox.com/asset/?id=196263721" Sky.CelestialBodiesShown = false Sky.SkyboxDn = "http://www.roblox.com/asset/?id=196263643" Sky.SkyboxRt = "http://www.roblox.com/asset/?id=196263721" Sky.Parent = Lighting table.insert(tokyowamiEffects, Sky)
            local Blur = Instance.new("BlurEffect") Blur.Size = 2 Blur.Parent = Lighting table.insert(tokyowamiEffects, Blur)
            local Inaritaisha = Instance.new("ColorCorrectionEffect") Inaritaisha.Name = "Inari taisha" Inaritaisha.Saturation = 0.05 Inaritaisha.TintColor = Color3.fromRGB(255, 224, 219) Inaritaisha.Parent = Lighting table.insert(tokyowamiEffects, Inaritaisha)
            local SunRays = Instance.new("SunRaysEffect") SunRays.Intensity = 0.05 SunRays.Parent = Lighting table.insert(tokyowamiEffects, SunRays)
            local Sunset = Instance.new("Sky") Sunset.Name = "Sunset" Sunset.SkyboxUp = "rbxassetid://323493360" Sunset.SkyboxLf = "rbxassetid://323494252" Sunset.SkyboxBk = "rbxassetid://323494035" Sunset.SkyboxFt = "rbxassetid://323494130" Sunset.SkyboxDn = "rbxassetid://323494368" Sunset.SunAngularSize = 14 Sunset.SkyboxRt = "rbxassetid://323494067" Sunset.Parent = Lighting table.insert(tokyowamiEffects, Sunset)

            Lighting.Brightness = 2.14 Lighting.ColorShift_Bottom = Color3.fromRGB(11, 0, 20) Lighting.ColorShift_Top = Color3.fromRGB(240, 127, 14) Lighting.OutdoorAmbient = Color3.fromRGB(34, 0, 49) Lighting.ClockTime = 6.7 Lighting.FogColor = Color3.fromRGB(94, 76, 106) Lighting.FogEnd = 1000 Lighting.ExposureCompensation = 0.24 Lighting.ShadowSoftness = 0 Lighting.Ambient = Color3.fromRGB(59, 33, 27)
            showBottomMessage("Tokyowami: ON")
        else
            for _, v in ipairs(tokyowamiEffects) do pcall(function() v:Destroy() end) end table.clear(tokyowamiEffects)
            if Lighting:GetAttribute("OrigSaved") then
                Lighting.Brightness = Lighting:GetAttribute("OrigBright") Lighting.ColorShift_Bottom = Lighting:GetAttribute("OrigCSB") Lighting.ColorShift_Top = Lighting:GetAttribute("OrigCST") Lighting.OutdoorAmbient = Lighting:GetAttribute("OrigOA") Lighting.ClockTime = Lighting:GetAttribute("OrigTime") Lighting.FogColor = Lighting:GetAttribute("OrigFogC") Lighting.FogEnd = Lighting:GetAttribute("OrigFogE") Lighting.ExposureCompensation = Lighting:GetAttribute("OrigExp") Lighting.ShadowSoftness = Lighting:GetAttribute("OrigShadow") Lighting.Ambient = Lighting:GetAttribute("OrigAmbient")
            end
            showBottomMessage("Tokyowami: OFF")
        end
    end
})

UIElements.TogNight = Tabs.Graficos:Toggle({
    Title = "Modo Noche",
    Desc = "Modo noche ajustable.",
    Callback = function(Value)
        local Lighting = game:GetService("Lighting")
        local Terrain = workspace:FindFirstChildOfClass("Terrain")
        nightActivo = Value

        if Value then
            if not Lighting:GetAttribute("OrigSavedNight") then
                Lighting:SetAttribute("OrigBright", Lighting.Brightness) Lighting:SetAttribute("OrigCSB", Lighting.ColorShift_Bottom) Lighting:SetAttribute("OrigCST", Lighting.ColorShift_Top) Lighting:SetAttribute("OrigOA", Lighting.OutdoorAmbient) Lighting:SetAttribute("OrigTime", Lighting.ClockTime) Lighting:SetAttribute("OrigFogC", Lighting.FogColor) Lighting:SetAttribute("OrigFogE", Lighting.FogEnd) Lighting:SetAttribute("OrigExp", Lighting.ExposureCompensation) Lighting:SetAttribute("OrigShadow", Lighting.ShadowSoftness) Lighting:SetAttribute("OrigAmbient", Lighting.Ambient) Lighting:SetAttribute("OrigSpec", Lighting.EnvironmentSpecularScale) Lighting:SetAttribute("OrigDiff", Lighting.EnvironmentDiffuseScale) Lighting:SetAttribute("OrigGlobalS", Lighting.GlobalShadows) Lighting:SetAttribute("OrigGeo", Lighting.GeographicLatitude) Lighting:SetAttribute("OrigSavedNight", true)
            end

            ToggleNubesYAtmo(true, "Night")
            
            if Terrain and not Terrain:GetAttribute("OrigWaterSavedNight") then
                Terrain:SetAttribute("OrigWaveSize", Terrain.WaterWaveSize) Terrain:SetAttribute("OrigWaveSpeed", Terrain.WaterWaveSpeed) Terrain:SetAttribute("OrigReflectance", Terrain.WaterReflectance) Terrain:SetAttribute("OrigTransparency", Terrain.WaterTransparency) Terrain:SetAttribute("OrigWaterColor", Terrain.WaterColor) Terrain:SetAttribute("OrigWaterSavedNight", true)
            end

            for _, v in ipairs(nightEffects) do pcall(function() v:Destroy() end) end table.clear(nightEffects)

            local blur = Instance.new("BlurEffect") blur.Size = shaderAjustes.Desenfoque blur.Parent = Lighting table.insert(nightEffects, blur)
            local bloom = Instance.new("BloomEffect") bloom.Intensity = shaderAjustes.Neon bloom.Size = 40 bloom.Threshold = 0.2 bloom.Parent = Lighting table.insert(nightEffects, bloom)
            local cc = Instance.new("ColorCorrectionEffect") cc.Brightness = 0.02 cc.Contrast = 0.15 cc.Saturation = shaderAjustes.ColorSaturacion cc.TintColor = Color3.fromRGB(210, 225, 255) cc.Parent = Lighting table.insert(nightEffects, cc)
            local moonRays = Instance.new("SunRaysEffect") moonRays.Intensity = 0.15 moonRays.Spread = 0.75 moonRays.Parent = Lighting table.insert(nightEffects, moonRays)
            local Tropic = Instance.new("Sky") Tropic.Name = "OnyxTokyowamiNight" Tropic.SkyboxUp = "http://www.roblox.com/asset/?id=169210149" Tropic.SkyboxLf = "http://www.roblox.com/asset/?id=169210133" Tropic.SkyboxBk = "http://www.roblox.com/asset/?id=169210090" Tropic.SkyboxFt = "http://www.roblox.com/asset/?id=169210121" Tropic.SkyboxDn = "http://www.roblox.com/asset/?id=169210108" Tropic.SkyboxRt = "http://www.roblox.com/asset/?id=169210143" Tropic.StarCount = 5000 Tropic.MoonAngularSize = 18 Tropic.Parent = Lighting table.insert(nightEffects, Tropic)

            Lighting.ClockTime = 0 
            Lighting.Brightness = 4 Lighting.EnvironmentSpecularScale = 1 Lighting.EnvironmentDiffuseScale = 1 Lighting.GlobalShadows = true 
            Lighting.GeographicLatitude = shaderAjustes.LunaPos Lighting.ShadowSoftness = shaderAjustes.SuavidadSombras Lighting.ExposureCompensation = shaderAjustes.Exposicion Lighting.OutdoorAmbient = Color3.fromRGB(50, 65, 95) 
            local s = shaderAjustes.Sombras Lighting.Ambient = Color3.fromRGB(s, s + 3, s + 10) 
            Lighting.ColorShift_Bottom = Color3.fromRGB(25, 40, 60) Lighting.ColorShift_Top = Color3.fromRGB(160, 180, 240) Lighting.FogColor = Color3.fromRGB(15, 20, 30) Lighting.FogEnd = 2500

            if Terrain then Terrain.WaterWaveSize = 0.12 Terrain.WaterWaveSpeed = 8 Terrain.WaterReflectance = 1 Terrain.WaterTransparency = 0.85 Terrain.WaterColor = Color3.fromRGB(15, 25, 45) end
            showBottomMessage("Noche: ON (Cielo despejado)")
        else
            for _, v in ipairs(nightEffects) do pcall(function() v:Destroy() end) end table.clear(nightEffects)
            if Lighting:GetAttribute("OrigSavedNight") then
                Lighting.Brightness = Lighting:GetAttribute("OrigBright") Lighting.ColorShift_Bottom = Lighting:GetAttribute("OrigCSB") Lighting.ColorShift_Top = Lighting:GetAttribute("OrigCST") Lighting.OutdoorAmbient = Lighting:GetAttribute("OrigOA") Lighting.ClockTime = Lighting:GetAttribute("OrigTime") Lighting.FogColor = Lighting:GetAttribute("OrigFogC") Lighting.FogEnd = Lighting:GetAttribute("OrigFogE") Lighting.ExposureCompensation = Lighting:GetAttribute("OrigExp") Lighting.ShadowSoftness = Lighting:GetAttribute("OrigShadow") Lighting.Ambient = Lighting:GetAttribute("OrigAmbient") Lighting.GlobalShadows = Lighting:GetAttribute("OrigGlobalS")
                if Lighting:GetAttribute("OrigGeo") then Lighting.GeographicLatitude = Lighting:GetAttribute("OrigGeo") end
                if Lighting:GetAttribute("OrigSpec") then Lighting.EnvironmentSpecularScale = Lighting:GetAttribute("OrigSpec") Lighting.EnvironmentDiffuseScale = Lighting:GetAttribute("OrigDiff") end
            end
            ToggleNubesYAtmo(false, "Night")
            if Terrain and Terrain:GetAttribute("OrigWaterSavedNight") then
                Terrain.WaterWaveSize = Terrain:GetAttribute("OrigWaveSize") Terrain.WaterWaveSpeed = Terrain:GetAttribute("OrigWaveSpeed") Terrain.WaterReflectance = Terrain:GetAttribute("OrigReflectance") Terrain.WaterTransparency = Terrain:GetAttribute("OrigTransparency") Terrain.WaterColor = Terrain:GetAttribute("OrigWaterColor")
            end
            showBottomMessage("Noche: OFF")
        end
    end
})

UIElements.TogPink = Tabs.Graficos:Toggle({
    Title = "Pink Hour",
    Desc = "Estilo Synthwave. Cielo y ambiente ajustable con los sliders.",
    Callback = function(Value)
        local Lighting = game:GetService("Lighting")
        pinkActivo = Value

        if Value then
            if not Lighting:GetAttribute("OrigSavedPink") then
                Lighting:SetAttribute("OrigBrightP", Lighting.Brightness) Lighting:SetAttribute("OrigCSBP", Lighting.ColorShift_Bottom) Lighting:SetAttribute("OrigCSTP", Lighting.ColorShift_Top) Lighting:SetAttribute("OrigOAP", Lighting.OutdoorAmbient) Lighting:SetAttribute("OrigTimeP", Lighting.ClockTime) Lighting:SetAttribute("OrigFogCP", Lighting.FogColor) Lighting:SetAttribute("OrigFogEP", Lighting.FogEnd) Lighting:SetAttribute("OrigAmbientP", Lighting.Ambient) Lighting:SetAttribute("OrigExpP", Lighting.ExposureCompensation) Lighting:SetAttribute("OrigShadowP", Lighting.ShadowSoftness) Lighting:SetAttribute("OrigSavedPink", true)
            end
            
            ToggleNubesYAtmo(true, "Pink")

            for _, v in ipairs(pinkEffects) do pcall(function() v:Destroy() end) end table.clear(pinkEffects)

            local cc = Instance.new("ColorCorrectionEffect")
            cc.Parent = Lighting
            table.insert(pinkEffects, cc)

            local bloom = Instance.new("BloomEffect") bloom.Size = 25 bloom.Threshold = 0.85 bloom.Parent = Lighting table.insert(pinkEffects, bloom)
            local blur = Instance.new("BlurEffect") blur.Size = 2 blur.Parent = Lighting table.insert(pinkEffects, blur)
            local sunRays = Instance.new("SunRaysEffect") sunRays.Intensity = 0.08 sunRays.Spread = 0.8 sunRays.Parent = Lighting table.insert(pinkEffects, sunRays)

            local sky = Instance.new("Sky") sky.Name = "AstraPinkSky" sky.SkyboxUp = "rbxassetid://323493360" sky.SkyboxLf = "rbxassetid://323494252" sky.SkyboxBk = "rbxassetid://323494035" sky.SkyboxFt = "rbxassetid://323494130" sky.SkyboxDn = "rbxassetid://323494368" sky.SkyboxRt = "rbxassetid://323494067" sky.SunAngularSize = 14 sky.StarCount = 3000 sky.Parent = Lighting table.insert(pinkEffects, sky)
            
            Lighting.Brightness = 2.0 
            Lighting.ClockTime = 6.7 
            Lighting.FogColor = Color3.fromRGB(120, 20, 150) 
            Lighting.FogEnd = 1200 
            Lighting.ShadowSoftness = 0.2 
            
            UpdatePinkHourVibe()

            showBottomMessage("Pink Hour: ON")
        else
            for _, v in ipairs(pinkEffects) do pcall(function() v:Destroy() end) end table.clear(pinkEffects)
            if Lighting:GetAttribute("OrigSavedPink") then
                Lighting.Brightness = Lighting:GetAttribute("OrigBrightP") Lighting.ColorShift_Bottom = Lighting:GetAttribute("OrigCSBP") Lighting.ColorShift_Top = Lighting:GetAttribute("OrigCSTP") Lighting.OutdoorAmbient = Lighting:GetAttribute("OrigOAP") Lighting.ClockTime = Lighting:GetAttribute("OrigTimeP") Lighting.FogColor = Lighting:GetAttribute("OrigFogCP") Lighting.FogEnd = Lighting:GetAttribute("OrigFogEP") Lighting.Ambient = Lighting:GetAttribute("OrigAmbientP") Lighting.ExposureCompensation = Lighting:GetAttribute("OrigExpP") Lighting.ShadowSoftness = Lighting:GetAttribute("OrigShadowP")
            end
            ToggleNubesYAtmo(false, "Pink")
            showBottomMessage("Pink Hour: OFF")
        end
    end
})

Tabs.Graficos:Section({Title = "Ajustes: Modo Noche"})

Tabs.Graficos:Slider({
    Title = "Claridad del Mapa",
    Desc = "Afecta solo al Modo Noche. Úsalo si está muy oscuro.",
    Step = 0.05,
    Value = {Min = 0.0, Max = 1.0, Default = 0.28},
    Callback = function(v)
        shaderAjustes.Exposicion = v
        if nightActivo then game:GetService("Lighting").ExposureCompensation = v end
    end
})

Tabs.Graficos:Slider({
    Title = "Profundidad de Sombras",
    Desc = "0 = Oscuridad total. 50 = Sombra suave y clara.",
    Step = 5,
    Value = {Min = 0, Max = 50, Default = 5},
    Callback = function(v)
        shaderAjustes.Sombras = v
        if nightActivo then game:GetService("Lighting").Ambient = Color3.fromRGB(v, v + 3, v + 10) end
    end
})

Tabs.Graficos:Slider({
    Title = "Resplandor",
    Desc = "Ajusta qué tanto brillan las armas y las luces del mapa.",
    Step = 0.05,
    Value = {Min = 0.1, Max = 1.0, Default = 0.45},
    Callback = function(v)
        shaderAjustes.Neon = v
        if nightActivo then
            for _, effect in ipairs(nightEffects) do
                if effect:IsA("BloomEffect") then effect.Intensity = v end
            end
        end
    end
})

Tabs.Graficos:Slider({
    Title = "Fondo Borroso",
    Desc = "0 = Sin borrosidad. Añade un efecto de cámara cinematográfica.",
    Step = 0.5,
    Value = {Min = 0, Max = 10, Default = 2},
    Callback = function(v)
        shaderAjustes.Desenfoque = v
        if nightActivo then
            for _, effect in ipairs(nightEffects) do
                if effect:IsA("BlurEffect") then effect.Size = v end
            end
        end
    end
})

Tabs.Graficos:Slider({
    Title = "Posición de la Luna",
    Desc = "Mueve la luna en el cielo.",
    Step = 5,
    Value = {Min = 0, Max = 360, Default = 85},
    Callback = function(v)
        shaderAjustes.LunaPos = v
        if nightActivo then game:GetService("Lighting").GeographicLatitude = v end
    end
})

Tabs.Graficos:Section({Title = "Ajustes: Pink Hour"})

Tabs.Graficos:Slider({
    Title = "Intensidad del Morado",
    Desc = "Añade oscuridad y tonos violetas al cielo y al mapa.",
    Step = 0.05,
    Value = {Min = 0.0, Max = 1.0, Default = 0.7},
    Callback = function(v)
        shaderAjustes.PinkMorado = v
        UpdatePinkHourVibe()
    end
})

Tabs.Graficos:Slider({
    Title = "Intensidad del Rosa",
    Desc = "Agrega tonos magentas y rosas a las luces.",
    Step = 0.05,
    Value = {Min = 0.0, Max = 1.0, Default = 0.8},
    Callback = function(v)
        shaderAjustes.PinkRosa = v
        UpdatePinkHourVibe()
    end
})

Tabs.Graficos:Slider({
    Title = "Saturación de Color",
    Desc = "0 = Grisáceo y apagado. 1 = Colores fluorescentes.",
    Step = 0.05,
    Value = {Min = 0.0, Max = 1.0, Default = 0.4},
    Callback = function(v)
        shaderAjustes.PinkSaturacion = v
        UpdatePinkHourVibe()
    end
})

Tabs.Graficos:Slider({
    Title = "Resplandor",
    Desc = "Haz que el cielo y los neones brillen mas.",
    Step = 0.05,
    Value = {Min = 0.0, Max = 1.0, Default = 0.3},
    Callback = function(v)
        shaderAjustes.PinkNeon = v
        if pinkActivo then
            for _, effect in ipairs(pinkEffects) do
                if effect:IsA("BloomEffect") then effect.Intensity = v end
            end
        end
    end
})

Tabs.Farm:Section({Title = "Farmeo de Evento"})
getgenv().AutoEventFarm = false
local Networking = game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Networking")
local RemoteFarm = Networking:FindFirstChild("RE/Events/CollectEventSpawnable")

Tabs.Farm:Toggle({Title = "Auto Farmear Evento", Callback = function(s)
    getgenv().AutoEventFarm = s
    if s then showBottomMessage("Auto Farm activado...")
        task.spawn(function()
            while getgenv().AutoEventFarm do
                pcall(function() if RemoteFarm then RemoteFarm:FireServer() else RemoteFarm = Networking:FindFirstChild("RE/Events/CollectEventSpawnable") end end)
                task.wait(0.05) 
            end
        end)
    else showBottomMessage("Auto Farm detenido.") end
end})

Tabs.Farm:Section({Title = "Comprador de Cajas (Con monedas)"})

local HttpService = game:GetService("HttpService")
local selectedBox = "Mythic Box #1"
local availableBoxes = {
    "Mythic Box #1", "Mythic Box #2", "Mythic Box #3", "Mythic Box #4",
    "Gun Box #1", "Gun Box #2",
    "Knife Box #1", "Knife Box #2"
}

Tabs.Farm:Dropdown({
    Title = "Selecciona la Caja",
    Values = availableBoxes,
    Value = "Mythic Box #1",
    Callback = function(Value)
        selectedBox = Value
    end
})

local function procesarCompra()
    local success, result = pcall(function()
        local args = { [1] = selectedBox }
        return game:GetService("ReplicatedStorage").Packages.Networking:FindFirstChild("RF/Shop/BuyCase"):InvokeServer(unpack(args))
    end)

    if success then
        local premio = "Desconocido (Revisa tu inventario)"
        
        if type(result) == "table" then
            premio = HttpService:JSONEncode(result)
            print("Caja abierta. Resultado:", premio)
            
            if result.Item then premio = tostring(result.Item)
            elseif result.Weapon then premio = tostring(result.Weapon)
            elseif result.Name then premio = tostring(result.Name) 
            elseif result[1] then premio = tostring(result[1]) end
        elseif result ~= nil then
            premio = tostring(result)
            print("Caja abierta. Resultado:", premio)
        end
        
        showBottomMessage("" .. string.sub(premio, 1, 35))
    else
        showBottomMessage("Error al comprar o sin dinero.")
    end
end

Tabs.Farm:Button({
    Title = "Comprar 1 Caja",
    Callback = function()
        task.spawn(function()
            procesarCompra()
        end)
    end
})

local autoBuyBoxEnabled = false
Tabs.Farm:Toggle({
    Title = "Auto Comprar Caja (Loop)",
    Callback = function(Value)
        autoBuyBoxEnabled = Value
        if Value then
            showBottomMessage("Auto-compra iniciada...")
            task.spawn(function()
                while autoBuyBoxEnabled do
                    procesarCompra()
                    task.wait(1.5)
                end
            end)
        else
            showBottomMessage("Auto-compra detenida.")
        end
    end
})

local animationData = {
    ["Old School"] = { Walk = 10921244891, Run = 10921240218, Jump = 10921242013, Fall = 10921241244, SwimIdle = 10921244018, Swim = 10921243048, Idle = 10921230744, Idle2 = 10921232093, Climb = 10921229866 },
    ["Adidas Sports"] = { Walk = 18537392113, Run = 18537384940, Jump = 18537380791, Fall = 18537367238, SwimIdle = 18537387180, Swim = 18537389531, Idle = 18537376492, Idle2 = 18537371272, Climb = 18537363391 },
    ["Adidas Community"] = { Walk = 122150855457006, Run = 82598234841035, Jump = 75290611992385, Fall = 98600215928904, SwimIdle = 109346520324160, Swim = 133308483266208, Idle = 122257458498464, Idle2 = 102357151005774, Climb = 88763136693023 },
    ["Adidas Aura"] = { Walk = 83842218823011, Run = 118320322718866, Jump = 109996626521204, Fall = 95603166884636, SwimIdle = 94922130551805, Swim = 134530128383903, Idle = 110211186840347, Idle2 = 114191137265065, Climb = 97824616490448 },
    ["Wicked Popular"] = { Walk = 92072849924640, Run = 72301599441680, Jump = 104325245285198, Fall = 121152442762481, Idle = 118832222982049, Idle2 = 76049494037641, SwimIdle = 113199415118199, Swim = 99384245425157, Climb = 131326830509784 },
    ["Elder"] = { Walk = 10921111375, Run = 10921104374, Jump = 10921107367, Fall = 10921105765, SwimIdle = 10921110146, Swim = 10921108971, Idle = 10921101664, Idle2 = 10921102574, Climb = 10921100400 },
    ["Zombie"] = { Walk = 10921355261, Run = 616163682, Jump = 10921351278, Fall = 10921350320, SwimIdle = 10921353442, Swim = 10921352344, Idle = 10921344533, Idle2 = 10921345304, Climb = 10921343576 },
    ["Mage"] = { Walk = 10921152678, Run = 10921148209, Jump = 10921149743, Fall = 10921148939, SwimIdle = 10921151661, Swim = 10921150788, Idle = 10921144709, Idle2 = 10921145797, Climb = 10921143404 },
    ["Catwalk Glam"] = { Walk = 109168724482748, Run = 81024476153754, Jump = 116936326516985, Fall = 92294537340807, SwimIdle = 98854111361360, Swim = 134591743181628, Idle = 133806214992291, Idle2 = 94970088341563, Climb = 119377220967554 },
    ["Astronaut"] = { Walk = 10921046031, Run = 10921039308, Jump = 10921042494, Fall = 10921040576, SwimIdle = 10921045006, Swim = 10921044000, Idle = 10921034824, Idle2 = 10921036806, Climb = 10921032124 },
    ['Wicked "Dancing Through Life"'] = { Walk = 73718308412641, Run = 135515454877967, Jump = 78508480717326, Fall = 78147885297412, SwimIdle = 129183123083281, Swim = 110657013921774, Idle = 92849173543269, Idle2 = 132238900951109, Climb = 129447497744818 },
    ["Werewolf"] = { Walk = 10921342074, Run = 10921336997, Fall = 10921337907, SwimIdle = 10921341319, Swim = 10921340419, Idle = 10921330408, Idle2 = 10921333667, Climb = 10921329322 },
    ["Superhero"] = { Walk = 10921298616, Run = 10921291831, Jump = 10921294559, Fall = 10921293373, SwimIdle = 10921297391, Swim = 10921295495, Idle = 10921288909, Idle2 = 10921290167, Climb = 10921286911 },
    ["Toy"] = { Walk = 10921312010, Run = 10921306285, Jump = 10921308158, Fall = 10921307241, SwimIdle = 10921310341, Swim = 10921309319, Idle = 10921301576, Climb = 10921300839 },
    ["No Boundaries"] = { Walk = 18747074203, Run = 18747070484, Jump = 18747069148, Fall = 18747062535, SwimIdle = 18747071682, Swim = 18747073181, Idle = 18747067405, Idle2 = 18747063918, Climb = 18747060903 },
    ["NFL"] = { Walk = 110358958299415, Run = 117333533048078, Jump = 119846112151352, Fall = 129773241321032, SwimIdle = 79090109939093, Swim = 132697394189921, Idle = 92080889861410, Idle2 = 74451233229259, Climb = 134630013742019 },
    ["Amazon Unboxed"] = { Walk = 90478085024465, Run = 134824450619865, Jump = 121454505477205, Fall = 94788218468396, SwimIdle = 129126268464847, Swim = 105962919001086, Idle = 98281136301627, Climb = 121145883950231 },
    ["Vampire"] = { Walk = 10921326949, Run = 10921320299, Jump = 10921322186, Fall = 10921321317, SwimIdle = 10921325443, Swim = 10921324408, Idle = 10921315373, Climb = 10921314188 },
    ["Ninja"] = { Walk = 656121766, Run = 656118852, Jump = 656117878, Fall = 656115606, SwimIdle = 656121397, Swim = 656119721, Idle = 656117400, Idle2 = 656118341, Climb = 656114359 },
    ["Robot"] = { Walk = 616095330, Run = 616091570, Jump = 616090535, Fall = 616087089, SwimIdle = 616094091, Swim = 616092998, Idle = 616088211, Idle2 = 616089559, Climb = 616086039 },
    ["Levitation"] = { Walk = 616013216, Run = 616010382, Jump = 616008936, Fall = 616005863, SwimIdle = 616012453, Swim = 616011509, Idle = 616006778, Idle2 = 616008087, Climb = 616003713 },
    ["Stylish"] = { Walk = 616146177, Run = 616140816, Jump = 616139451, Fall = 616134815, SwimIdle = 616144772, Swim = 616143378, Idle = 616136790, Idle2 = 616138447, Climb = 616133594 },
    ["Bubbly"] = { Walk = 910034870, Run = 910025107, Jump = 910016857, Fall = 910001910, SwimIdle = 910030921, Swim = 910028158, Idle = 910004836, Idle2 = 910009958, Climb = 909997997 },
    ["Cartoon"] = { Walk = 742640026, Run = 742638842, Jump = 742637942, Fall = 742637151, SwimIdle = 742639812, Swim = 742639220, Idle = 742637544, Idle2 = 742638445, Climb = 742636889 }
}

local function clearAllAnimations()
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    for _, track in pairs(hum:GetPlayingAnimationTracks()) do track:Stop(0) track:Destroy() end
    local animator = hum:FindFirstChildOfClass("Animator")
    if animator then
        for _, track in pairs(animator:GetPlayingAnimationTracks()) do track:Stop(0) track:Destroy() end
    end
    task.wait(0.1)
end

local animacionActualActiva = nil 
local misAnimacionesOriginales = nil 

local function applyCustomAnims(customData)
    if not customData then return end
    local char = player.Character
    if not char then return end
    clearAllAnimations()

    local animate = char:FindFirstChild("Animate")
    if not animate then return end
    
    if not misAnimacionesOriginales then
        local function getAnim(folderName, animName)
            local folder = animate:FindFirstChild(folderName)
            if folder then
                local anim = folder:FindFirstChild(animName)
                if anim and anim:IsA("Animation") then
                    local idStr = anim.AnimationId:match("%d+")
                    if idStr then return tonumber(idStr) end
                end
            end
            return nil
        end

        misAnimacionesOriginales = {
            Idle = getAnim("idle", "Animation1") or 507766666,
            Idle2 = getAnim("idle", "Animation2") or 507766951,
            Walk = getAnim("walk", "WalkAnim") or 507777826,
            Run = getAnim("run", "RunAnim") or 507767714,
            Jump = getAnim("jump", "JumpAnim") or 507765000,
            Climb = getAnim("climb", "ClimbAnim") or 507765644,
            Fall = getAnim("fall", "FallAnim") or 507767968,
            Swim = getAnim("swim", "Swim") or 507784897,
            SwimIdle = getAnim("swimidle", "SwimIdle") or 507785072
        }
    end

    animate.Disabled = true
    task.wait(0.1)

    local function updateAnimation(folderName, animName, animId)
        if not animId then return end
        local folder = animate:FindFirstChild(folderName)
        if folder then
            local anim = folder:FindFirstChild(animName)
            if anim and anim:IsA("Animation") then
                anim.AnimationId = "rbxassetid://" .. tostring(animId)
            end
        end
    end

    updateAnimation("idle", "Animation1", customData.Idle)
    updateAnimation("idle", "Animation2", customData.Idle2 or customData.Idle)
    updateAnimation("walk", "WalkAnim", customData.Walk)
    updateAnimation("run", "RunAnim", customData.Run)
    updateAnimation("jump", "JumpAnim", customData.Jump)
    updateAnimation("climb", "ClimbAnim", customData.Climb)
    updateAnimation("fall", "FallAnim", customData.Fall)
    updateAnimation("swim", "Swim", customData.Swim)
    updateAnimation("swimidle", "SwimIdle", customData.SwimIdle or customData.Swim)

    task.wait(0.1)
    animate.Disabled = false

    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum:ChangeState(Enum.HumanoidStateType.Landed)
        task.wait(0.05)
        hum:ChangeState(Enum.HumanoidStateType.Running)
    end
end

task.spawn(function()
    while task.wait(1) do
        if animacionActualActiva then
            local char = player.Character
            if char then
                local animate = char:FindFirstChild("Animate")
                if animate then
                    local idleFolder = animate:FindFirstChild("idle")
                    if idleFolder then
                        local anim1 = idleFolder:FindFirstChild("Animation1")
                        if anim1 then
                            local currentId = anim1.AnimationId:match("%d+")
                            if currentId ~= tostring(animacionActualActiva.Idle) then
                                applyCustomAnims(animacionActualActiva)
                            end
                        end
                    end
                end
            end
        end
    end
end)

local animList = {"Ninguno"}
for name, _ in pairs(animationData) do table.insert(animList, name) end
table.sort(animList)

Tabs.Emotes:Section({Title = "Paquetes Completos"})

local selectedBundleCompleto = "Ninguno"
Tabs.Emotes:Dropdown({
    Title = "Elegir Paquete", 
    Values = animList, 
    Value = "Ninguno", 
    Callback = function(Value) selectedBundleCompleto = Value end
})

Tabs.Emotes:Button({Title = "Aplicar Paquete Completo", Callback = function()
    if selectedBundleCompleto == "Ninguno" then return end
    task.spawn(function()
        showBottomMessage("Aplicando paquete: " .. selectedBundleCompleto)
        animacionActualActiva = animationData[selectedBundleCompleto]
        applyCustomAnims(animacionActualActiva)
    end)
end})

Tabs.Emotes:Button({Title = "Restaurar Default", Callback = function()
    task.spawn(function()
        local defaultAnims = misAnimacionesOriginales or {
            Idle = 507766666, Idle2 = 507766951, Walk = 507777826, Run = 507767714,
            Jump = 507765000, Climb = 507765644, Fall = 507767968, Swim = 507784897, SwimIdle = 507785072
        }
        animacionActualActiva = nil 
        applyCustomAnims(defaultAnims)
        showBottomMessage("Animaciones de tu avatar restauradas.")
    end)
end})

Tabs.Emotes:Section({Title = "Mezclador de Animaciones"})

local mixParts = {
    Idle = "Ninguno", Walk = "Ninguno", Run = "Ninguno", 
    Jump = "Ninguno", Fall = "Ninguno", Climb = "Ninguno"
}

Tabs.Emotes:Dropdown({Title = "Reposo", Values = animList, Value = "Ninguno", Callback = function(Value) mixParts.Idle = Value end})
Tabs.Emotes:Dropdown({Title = "Caminar", Values = animList, Value = "Ninguno", Callback = function(Value) mixParts.Walk = Value end})
Tabs.Emotes:Dropdown({Title = "Correr", Values = animList, Value = "Ninguno", Callback = function(Value) mixParts.Run = Value end})
Tabs.Emotes:Dropdown({Title = "Saltar)", Values = animList, Value = "Ninguno", Callback = function(Value) mixParts.Jump = Value end})
Tabs.Emotes:Dropdown({Title = "Caer", Values = animList, Value = "Ninguno", Callback = function(Value) mixParts.Fall = Value end})
Tabs.Emotes:Dropdown({Title = "Escalar", Values = animList, Value = "Ninguno", Callback = function(Value) mixParts.Climb = Value end})

Tabs.Emotes:Button({Title = "Combinar y Aplicar", Callback = function()
    task.spawn(function()
        local customMix = {}
        
        if mixParts.Idle ~= "Ninguno" then
            customMix.Idle = animationData[mixParts.Idle].Idle
            customMix.Idle2 = animationData[mixParts.Idle].Idle2
        end
        if mixParts.Walk ~= "Ninguno" then customMix.Walk = animationData[mixParts.Walk].Walk end
        if mixParts.Run ~= "Ninguno" then customMix.Run = animationData[mixParts.Run].Run end
        if mixParts.Jump ~= "Ninguno" then customMix.Jump = animationData[mixParts.Jump].Jump end
        if mixParts.Fall ~= "Ninguno" then customMix.Fall = animationData[mixParts.Fall].Fall end
        if mixParts.Climb ~= "Ninguno" then customMix.Climb = animationData[mixParts.Climb].Climb end

        local hasValues = false
        for _, v in pairs(customMix) do if v then hasValues = true break end end
        
        if hasValues then
            showBottomMessage("Aplicando combinación de animaciones...")
            animacionActualActiva = customMix 
            applyCustomAnims(animacionActualActiva)
        else
            showBottomMessage("Selecciona al menos una animación para combinar.")
        end
    end)
end})

Tabs.Com:Section({Title = "Reportar bug/error o alguna sugerencia"})
local reportText = ""
local lastReportTime = 0

Tabs.Com:Input({Title = "Mensaje", Placeholder = "Escribe aquí...", Callback = function(t) reportText = t end})

Tabs.Com:Button({Title = "Enviar", Callback = function()
    local tiempoActual = os.time()
    local tiempoRestante = 60 - (tiempoActual - lastReportTime)

    if tiempoRestante > 0 then
        showBottomMessage("Anti-Spam: Espera " .. tiempoRestante .. " segundos.")
        return
    end

    local texto = reportText
    if texto ~= "" and texto:match("%S") and texto ~= "TextBox" and texto ~= "Reporte enviado" and texto ~= "Escribe algo primero..." then
        showBottomMessage("Reporte enviado (simulado)")
        lastReportTime = tiempoActual
    else 
        showBottomMessage("Escribe algo primero...") 
    end
end})

Tabs.Config:Section({ Title = "Personalización de Interfaz" })

local temasDisponibles = {"Midnight", "Dark", "Rose", "Emerald", "Sky", "Violet", "Amber", "Crimson", "Monokai Pro", "Cotton Candy", "Light", "Mellowsi", "Rainbow", "Indigo", "Red", "Plant"}

local temaIniciado = false
Tabs.Config:Dropdown({
    Title = "Tema de la Interfaz",
    Values = temasDisponibles,
    Value = "Violet", 
    Callback = function(Value)
        pcall(function()
            WindUI:SetTheme(Value)
            if temaIniciado then
                showBottomMessage("Tema aplicado: " .. Value)
            end
            temaIniciado = true
        end)
    end
})

Tabs.Config:Toggle({
    Title = "Ocultar Botón Flotante",
    Callback = function(Value)
        local guisToSearch = { player:FindFirstChild("PlayerGui") }
        pcall(function() table.insert(guisToSearch, game:GetService("CoreGui")) end)

        for _, guiContainer in ipairs(guisToSearch) do
            if guiContainer then
                for _, v in pairs(guiContainer:GetDescendants()) do
                    if (v:IsA("TextLabel") or v:IsA("TextButton")) and v.Text and string.find(v.Text, "Open OnyxHub") then
                        local btnContainer = v
                        while btnContainer.Parent and not btnContainer.Parent:IsA("ScreenGui") and not btnContainer.Parent:IsA("Folder") do
                            btnContainer = btnContainer.Parent
                        end
                        
                        if btnContainer:IsA("CanvasGroup") then
                            btnContainer.GroupTransparency = Value and 1 or 0
                        else
                            local function aplicarTransparencia(obj)
                                if obj:IsA("UIStroke") then
                                    if not obj:GetAttribute("OrigTrans") then obj:SetAttribute("OrigTrans", obj.Transparency) end
                                    obj.Transparency = Value and 1 or obj:GetAttribute("OrigTrans")
                                elseif obj:IsA("TextLabel") or obj:IsA("TextButton") then
                                    if not obj:GetAttribute("OrigTxtTrans") then obj:SetAttribute("OrigTxtTrans", obj.TextTransparency) end
                                    obj.TextTransparency = Value and 1 or obj:GetAttribute("OrigTxtTrans")
                                    
                                    if not obj:GetAttribute("OrigBgTrans") then obj:SetAttribute("OrigBgTrans", obj.BackgroundTransparency) end
                                    obj.BackgroundTransparency = Value and 1 or obj:GetAttribute("OrigBgTrans")
                                elseif obj:IsA("Frame") or obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
                                    if not obj:GetAttribute("OrigBgTrans") then obj:SetAttribute("OrigBgTrans", obj.BackgroundTransparency) end
                                    obj.BackgroundTransparency = Value and 1 or obj:GetAttribute("OrigBgTrans")
                                    
                                    pcall(function()
                                        if not obj:GetAttribute("OrigImgTrans") then obj:SetAttribute("OrigImgTrans", obj.ImageTransparency) end
                                        obj.ImageTransparency = Value and 1 or obj:GetAttribute("OrigImgTrans")
                                    end)
                                end
                            end
                            
                            for _, obj in pairs(btnContainer:GetDescendants()) do
                                aplicarTransparencia(obj)
                            end
                            aplicarTransparencia(btnContainer)
                        end
                    end
                end
            end
        end
    end
})

Tabs.Config:Toggle({
    Title = "Botones Flotantes Invisibles",
    Desc = "Oculta la posicion de los botones.",
    Value = false,
    Callback = function(Value)
        _G.AstraBotonesOcultos = Value 
        local bgTrans = Value and 1 or 0.3
        local txtTrans = Value and 1 or 0
        local strTrans = Value and 1 or 0.5
        
        for _, btn in ipairs(floatingButtonsList) do
            if btn then
                btn.BackgroundTransparency = bgTrans
                btn.TextTransparency = txtTrans
                local stroke = btn:FindFirstChildOfClass("UIStroke")
                if stroke then stroke.Transparency = strTrans end
            end
        end
    end
})

Tabs.Config:Section({ Title = "Gestor de Configs" })
local configFolder = "OnyxHub_Configs_Duels_WindUI" 
if isfolder and not isfolder(configFolder) then pcall(function() makefolder(configFolder) end) end

local availableConfigs = {"Ninguna"}
local selectedConfig = "Ninguna"
local customConfigName = ""

local configDropdown = Tabs.Config:Dropdown({
    Title = "Seleccionar Configuración",
    Values = availableConfigs,
    Value = "Ninguna",
    Callback = function(Value)
        selectedConfig = Value
    end
})

local function refreshConfigs()
    local list = {}
    if listfiles then
        pcall(function()
            for _, file in ipairs(listfiles(configFolder)) do
                if file:match("%.json$") then
                    local name = file:match("([^/\\]+)%.json$")
                    if name then table.insert(list, name) end
                end
            end
        end)
    end
    if #list == 0 then table.insert(list, "Ninguna") end
    
    pcall(function()
        configDropdown:Refresh(list)
        if selectedConfig == "Ninguna" or not table.find(list, selectedConfig) then
            configDropdown:Select(list[1])
            selectedConfig = list[1]
        end
    end)
end

Tabs.Config:Button({
    Title = "Actualizar Lista",
    Callback = function()
        refreshConfigs()
        showBottomMessage("Lista de configuraciones actualizada.")
    end
})

Tabs.Config:Input({ 
    Title = "Nombre para Guardar ", 
    Placeholder = "Ej: Config 1, Config 2...", 
    Callback = function(Text) 
        customConfigName = Text 
    end 
})
Tabs.Config:Button({ Title = "Guardar Configuración", Callback = function()
    task.wait(0.1) 
    
    local finalName = customConfigName:gsub("[^%w%s%-]", "") 
    if finalName == "" then finalName = selectedConfig end
    
    if finalName == "" or finalName == "Ninguna" then
        showBottomMessage(" Escribe un nombre válido o selecciona una config para sobreescribir.")
        return
    end
    
    local path = configFolder .. "/" .. finalName .. ".json"
    
    local configData = {
        ConfigName = finalName, 
        Toggles = {
            ["Auto Shoot"] = autoShootEnabled,
            ["AutoShoot Cuchillo"] = autoShootCuchilloEnabled,
            ["Silent Aim (Manual)"] = silentAimManualEnabled,
            ["Silent Aim (FOV)"] = silentAimFovEnabled,
            ["Mostrar Círculo FOV"] = fovVisiblePreference,
            ["ESP Lineas"] = espLinesEnabled,
            ["Btn Flotante AutoShoot"] = asBtn.Visible,
            ["Btn Flotante SilentAim"] = saBtn.Visible,
            ["Btn Flotante Fantasma"] = ghostBtn.Visible,
            ["Aumentar Hitbox"] = hitboxEnabled, 
            ["Hitbox Invisible"] = hitboxInvisible, 
            ["ESP Jugadores"] = espEnabled, 
            ["Mostrar Resplandor (Glow)"] = espSettings.Glow, 
            ["Mostrar Nombre"] = espSettings.Name, 
            ["Mostrar Vida"] = espSettings.Health, 
            ["Mostrar Distancia"] = espSettings.Distance, 
            ["Emote Walk (Bailar al caminar)"] = emoteWalkEnabled, 
            ["Ocultar mi Nombre (Local)"] = hideNameEnabled, 
            ["Fly (Volar)"] = flying, 
            ["Enemies TP"] = magnetTpEnabled, 
            ["FPS Boost"] = fpsBoostEnabled
        },
        Sliders = { 
            ["Tamaño del FOV"] = fovRadius, 
            ["Tamaño de Hitbox"] = hitboxSize, 
            ["Velocidad de Vuelo"] = flySpeed,
            ["Delay Equipar Macro"] = macroEquipDelay,
            ["Delay Disparo Macro"] = macroShootDelay
        },
        Colors = { 
            ["Color de Hitbox"] = {R = hitboxColor.R, G = hitboxColor.G, B = hitboxColor.B}, 
            ["Color del ESP"] = {R = espColor.R, G = espColor.G, B = espColor.B} 
        },
        Extras = { 
            ["Parte Aimbot"] = silentAimTargetPart,
            ["Parte AutoShoot"] = autoShootTargetPart
        },
        Animaciones = {
            Paquete = selectedBundleCompleto,
            Mix = mixParts
        }
    }
    
    if writefile then 
        local sEncode, encodedData = pcall(function() return HttpService:JSONEncode(configData) end)
        if sEncode then
            pcall(function() writefile(path, encodedData) end) 
            showBottomMessage(" Guardado como: " .. finalName) 
            refreshConfigs()
            pcall(function() configDropdown:Select(finalName) end)
        else
            showBottomMessage(" Error interno al procesar los datos.")
        end
    else 
        showBottomMessage(" Error: Tu ejecutor no soporta guardar") 
    end
end})

local function secureLoadToggle(element, val) 
    if not element or val == nil then return end 
    pcall(function() element:Set(val) end) 
end

Tabs.Config:Button({ Title = " Cargar Configuración", Callback = function()
    if selectedConfig == "Ninguna" or selectedConfig == "" then
        showBottomMessage("No hay ninguna configuración seleccionada.")
        return
    end
    
    local path = configFolder .. "/" .. selectedConfig .. ".json"
    if isfile and isfile(path) then
        local success, decoded = pcall(function() return HttpService:JSONDecode(readfile(path)) end)
        if success and type(decoded) == "table" then
            
            if decoded.Toggles then
                if decoded.Toggles["Auto Shoot"] ~= nil then autoShootEnabled = decoded.Toggles["Auto Shoot"] secureLoadToggle(UIElements.TogAutoShoot, autoShootEnabled) end
                if decoded.Toggles["AutoShoot Cuchillo"] ~= nil then 
                    autoShootCuchilloEnabled = decoded.Toggles["AutoShoot Cuchillo"] 
                    secureLoadToggle(UIElements.TogAutoShootCuchillo, autoShootCuchilloEnabled) 
                end
                if decoded.Toggles["Silent Aim (Manual)"] ~= nil then silentAimManualEnabled = decoded.Toggles["Silent Aim (Manual)"] secureLoadToggle(UIElements.TogSilentAimManual, silentAimManualEnabled) end
                if decoded.Toggles["Silent Aim (FOV)"] ~= nil then silentAimFovEnabled = decoded.Toggles["Silent Aim (FOV)"] secureLoadToggle(UIElements.TogSilentAimFOV, silentAimFovEnabled) end
                if decoded.Toggles["Mostrar Círculo FOV"] ~= nil then fovVisiblePreference = decoded.Toggles["Mostrar Círculo FOV"] secureLoadToggle(UIElements.TogShowFOV, fovVisiblePreference) end
                if decoded.Toggles["ESP Lineas"] ~= nil then espLinesEnabled = decoded.Toggles["ESP Lineas"] secureLoadToggle(UIElements.TogEspLines, espLinesEnabled) end
                
                if decoded.Toggles["Btn Flotante AutoShoot"] ~= nil then secureLoadToggle(UIElements.ToggleAsBtn, decoded.Toggles["Btn Flotante AutoShoot"]) end
                if decoded.Toggles["Btn Flotante SilentAim"] ~= nil then secureLoadToggle(UIElements.ToggleSaBtn, decoded.Toggles["Btn Flotante SilentAim"]) end
                if decoded.Toggles["Btn Flotante Fantasma"] ~= nil then secureLoadToggle(UIElements.ToggleGhost, decoded.Toggles["Btn Flotante Fantasma"]) end

                if decoded.Toggles["Aumentar Hitbox"] ~= nil then hitboxEnabled = decoded.Toggles["Aumentar Hitbox"] secureLoadToggle(UIElements.TogHitbox, hitboxEnabled) end
                if decoded.Toggles["Hitbox Invisible"] ~= nil then hitboxInvisible = decoded.Toggles["Hitbox Invisible"] secureLoadToggle(UIElements.TogHbInv, hitboxInvisible) end
                if decoded.Toggles["ESP Jugadores"] ~= nil then espEnabled = decoded.Toggles["ESP Jugadores"] secureLoadToggle(UIElements.TogEsp, espEnabled) end
                if decoded.Toggles["Mostrar Resplandor (Glow)"] ~= nil then espSettings.Glow = decoded.Toggles["Mostrar Resplandor (Glow)"] secureLoadToggle(UIElements.TogEspGl, espSettings.Glow) end
                if decoded.Toggles["Mostrar Nombre"] ~= nil then espSettings.Name = decoded.Toggles["Mostrar Nombre"] secureLoadToggle(UIElements.TogEspNm, espSettings.Name) end
                if decoded.Toggles["Mostrar Vida"] ~= nil then espSettings.Health = decoded.Toggles["Mostrar Vida"] secureLoadToggle(UIElements.TogEspHp, espSettings.Health) end
                if decoded.Toggles["Mostrar Distancia"] ~= nil then espSettings.Distance = decoded.Toggles["Mostrar Distancia"] secureLoadToggle(UIElements.TogEspDs, espSettings.Distance) end
                if decoded.Toggles["Emote Walk (Bailar al caminar)"] ~= nil then emoteWalkEnabled = decoded.Toggles["Emote Walk (Bailar al caminar)"] secureLoadToggle(UIElements.TogEmoteWalk, emoteWalkEnabled) end
                if decoded.Toggles["Ocultar mi Nombre (Local)"] ~= nil then hideNameEnabled = decoded.Toggles["Ocultar mi Nombre (Local)"] secureLoadToggle(UIElements.TogHideName, hideNameEnabled) end
                if decoded.Toggles["Fly (Volar)"] ~= nil then flying = decoded.Toggles["Fly (Volar)"] secureLoadToggle(UIElements.TogFly, flying) end
                if decoded.Toggles["Enemies TP"] ~= nil then magnetTpEnabled = decoded.Toggles["Enemies TP"] secureLoadToggle(UIElements.TogIman, magnetTpEnabled) end
                if decoded.Toggles["FPS Boost"] ~= nil then fpsBoostEnabled = decoded.Toggles["FPS Boost"] secureLoadToggle(UIElements.ToggleFPS, fpsBoostEnabled) end
            end
            
            if decoded.Sliders then 
                if decoded.Sliders["Tamaño del FOV"] ~= nil then fovRadius = decoded.Sliders["Tamaño del FOV"] secureLoadToggle(UIElements.SliFOVSize, fovRadius) end
                if decoded.Sliders["Tamaño de Hitbox"] ~= nil then hitboxSize = decoded.Sliders["Tamaño de Hitbox"] secureLoadToggle(UIElements.SliHitbox, hitboxSize) end
                if decoded.Sliders["Velocidad de Vuelo"] ~= nil then flySpeed = decoded.Sliders["Velocidad de Vuelo"] secureLoadToggle(UIElements.SliFly, flySpeed) end
                if decoded.Sliders["Delay Equipar Macro"] ~= nil then macroEquipDelay = decoded.Sliders["Delay Equipar Macro"] secureLoadToggle(UIElements.SliMacroEquip, macroEquipDelay) end
                if decoded.Sliders["Delay Disparo Macro"] ~= nil then macroShootDelay = decoded.Sliders["Delay Disparo Macro"] secureLoadToggle(UIElements.SliMacroShoot, macroShootDelay) end
            end
        
            if decoded.Colors then
                if decoded.Colors["Color de Hitbox"] then
                    local cHitbox = Color3.new(decoded.Colors["Color de Hitbox"].R, decoded.Colors["Color de Hitbox"].G, decoded.Colors["Color de Hitbox"].B)
                    hitboxColor = cHitbox secureLoadToggle(UIElements.ColHitbox, cHitbox) 
                end
                if decoded.Colors["Color del ESP"] then
                    local cEsp = Color3.new(decoded.Colors["Color del ESP"].R, decoded.Colors["Color del ESP"].G, decoded.Colors["Color del ESP"].B)
                    espColor = cEsp secureLoadToggle(UIElements.ColEsp, cEsp) 
                end
            end
            
            if decoded.Extras and decoded.Extras["Parte Aimbot"] then
                silentAimTargetPart = decoded.Extras["Parte Aimbot"]
                if UIElements.DropSilentAimPart then
                    pcall(function() UIElements.DropSilentAimPart:Select(silentAimTargetPart) end)
                end
            end
           
            if decoded.Extras and decoded.Extras["Parte AutoShoot"] then
                autoShootTargetPart = decoded.Extras["Parte AutoShoot"]
                if UIElements.DropAutoShootPart then
                    pcall(function() UIElements.DropAutoShootPart:Select(autoShootTargetPart) end)
                end
            end

            if decoded.Animaciones then
                task.spawn(function()
                    task.wait(1) 
                    
                    if decoded.Animaciones.Paquete and decoded.Animaciones.Paquete ~= "Ninguno" then
                        selectedBundleCompleto = decoded.Animaciones.Paquete
                        applyCustomAnims(animationData[selectedBundleCompleto])
                        
                    elseif decoded.Animaciones.Mix then
                        mixParts = decoded.Animaciones.Mix
                        local customMix = {}
                        
                        if mixParts.Idle ~= "Ninguno" then
                            customMix.Idle = animationData[mixParts.Idle].Idle
                            customMix.Idle2 = animationData[mixParts.Idle].Idle2
                        end
                        if mixParts.Walk ~= "Ninguno" then customMix.Walk = animationData[mixParts.Walk].Walk end
                        if mixParts.Run ~= "Ninguno" then customMix.Run = animationData[mixParts.Run].Run end
                        if mixParts.Jump ~= "Ninguno" then customMix.Jump = animationData[mixParts.Jump].Jump end
                        if mixParts.Fall ~= "Ninguno" then customMix.Fall = animationData[mixParts.Fall].Fall end
                        if mixParts.Climb ~= "Ninguno" then customMix.Climb = animationData[mixParts.Climb].Climb end

                        local hasValues = false
                        for _, v in pairs(customMix) do if v then hasValues = true break end end
                        if hasValues then applyCustomAnims(customMix) end
                    end
                end)
            end
            
            showBottomMessage("'" .. selectedConfig .. "' cargada con éxito.")
        else
            showBottomMessage("Error al leer el archivo.") 
        end
    else 
        showBottomMessage("La configuración no existe.") 
    end
end})

task.spawn(function()
    task.wait(1)
    refreshConfigs()
end)

