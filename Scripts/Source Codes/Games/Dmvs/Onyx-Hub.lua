

-- ==========================================
--  AUTO-DETECCIÓN DE JUEGO (CADENERO MAESTRO) 
-- ==========================================
local MM2_PLACE_ID = 142823291
local MMV_PLACE_ID = 80625849508539
local MMV2_PLACE_ID = 117973911105557
local DUELS_BIMO_PLACE_ID = 116817810725116
if game.PlaceId == MM2_PLACE_ID or game.PlaceId == MMV_PLACE_ID or game.PlaceId == MMV2_PLACE_ID then
    local s, e = pcall(function() loadstring(game:HttpGet("https://gist.githubusercontent.com/AnyDevPA/909c52fbab698ea6681c35e59faad3d6/raw/AstraHub%20(MM2)%20VPS.lua"))() end)
    if not s then warn("El link de MM2 se cayó:", e) end
    return 
elseif game.PlaceId == DUELS_BIMO_PLACE_ID then
    -- Script DUELS
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")
local workspace = game:GetService("Workspace")

--  FIX: Asegurarnos 100% de que seas TÚ y no un random
local player = Players.LocalPlayer
while not player do
    task.wait()
    player = Players.LocalPlayer
end

local camera = workspace.CurrentCamera
local mouse = player:GetMouse()

-- ==========================================
--  FUNCIÓN MAESTRA DE CONEXIÓN SEGURA 
-- ==========================================
local function AstraRequest(ruta)
    return nil
end





-- ==========================================
--  VARIABLES GLOBALES DE CONFIGURACIÓN 
-- ==========================================
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

local UIElements = {} -- Tabla para guardar referencias

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

-- ==========================================
-- INICIALIZACIÓN WINDUI (CON CACHÉ 24HRS)
-- ==========================================
local WindUI
local _version = "1.6.66"
local uiFileName = "WindUI_Cache_v" .. _version .. ".txt"
local timeFileName = "WindUI_Cache_v" .. _version .. "_Time.txt"

local ok, result = pcall(function()
    local cacheValido = false
    
    -- Revisar la expiración del caché
    if isfile and isfile(timeFileName) and readfile then
        local savedTime = tonumber(readfile(timeFileName))
        if savedTime and (os.time() - savedTime) < 86400 then -- 24 horas
            cacheValido = true
        end
    end

    if cacheValido and isfile and isfile(uiFileName) then
        -- Cargar desde almacenamiento local (Instantáneo)
        return loadstring(readfile(uiFileName))()
    else
        -- Descargar y guardar para la próxima vez (o forzar update)
        local codigoUi = game:HttpGet("https://github.com/Footagesus/WindUI/releases/download/" .. _version .. "/main.lua")
        
        if writefile then 
            writefile(uiFileName, codigoUi) 
            writefile(timeFileName, tostring(os.time())) -- Guardamos el nuevo tiempo
        end
        return loadstring(codigoUi)()
    end
end)

if ok and result then 
    WindUI = result 
else 
    warn("Error al cargar WindUI") 
    return 
end

local Window = WindUI:CreateWindow({
    Title = "ONYXHUB | DUELS <font color='#FFD700'>[v1.5]</font>",
    Theme = "Midnight",
    Author = "by AlexDev",
    Folder = "OnyxHub_WindUI",
    Icon = "rbxassetid://88304008295495",
    Acrylic = false,
    Transparent = false,
    NewElements = true,
    HideSearchBar = false,
    OpenButton = {
        Title = "Open OnyxHub",
        CornerRadius = UDim.new(1),
        StrokeThickness = 1,
        Enabled = true,
        Draggable = true,
        Scale = 0.8,
        Color = ColorSequence.new(Color3.fromHex("#110070"), Color3.fromHex("#300364"))
    },
    Topbar = { Height = 44, ButtonsType = "Default" }
})

WindUI:SetTheme("Midnight")


-- ==========================================
--  CONTADOR DE USUARIOS EN EL TOPBAR (WINDUI)
-- ==========================================
task.spawn(function()
    local myName = game:GetService("HttpService"):UrlEncode(player.Name)
    
    while task.wait(5) do
        pcall(function()
            local myJobId = game.JobId
            local respuesta = AstraRequest("/ping?user=" .. myName .. "&jobid=" .. myJobId)
            
            if respuesta and tonumber(respuesta) then
                -- Construimos el texto: Título + Versión + Contador (con espacio y color verde)
                local tituloDinamico = "ONYXHUB | DUELS <font color='#FFD700'>[v1.5.2]</font>   <font color='#00ff80'>|  Activos: " .. respuesta .. "</font>"
                
                -- Actualizamos el texto de la barra superior en tiempo real
                if Window.SetTitle then
                    Window:SetTitle(tituloDinamico)
                end
            end
        end)
    end
end)



-- ==========================================
-- 🔥 SISTEMA DE NOTIFICACIONES MINIMALISTA (DERECHA Y SIN SONIDO)
-- ==========================================
local NotifContainer = Instance.new("Frame")
NotifContainer.Name = "AstraMinimalNotifs"
NotifContainer.Size = UDim2.new(0, 300, 0.5, 0)
-- Lo anclamos a la esquina inferior derecha
NotifContainer.AnchorPoint = Vector2.new(1, 1) 
NotifContainer.Position = UDim2.new(1, -20, 1, -20) 
NotifContainer.BackgroundTransparency = 1
NotifContainer.Parent = screenGui

local layout = Instance.new("UIListLayout", NotifContainer)
layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
layout.HorizontalAlignment = Enum.HorizontalAlignment.Right -- Alineado a la derecha
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 8) -- Separación entre notificaciones

local function showBottomMessage(text)
    task.spawn(function()
        -- 1. Contenedor de la notificación
        local frame = Instance.new("Frame")
        frame.AutomaticSize = Enum.AutomaticSize.X
        frame.Size = UDim2.new(0, 0, 0, 28)
        frame.BackgroundColor3 = Color3.fromRGB(20, 21, 25) -- Gris oscuro elegante
        frame.BackgroundTransparency = 1
        frame.ClipsDescendants = true
        frame.Parent = NotifContainer

        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6) -- Esquinas ligeramente redondeadas
        
        -- Padding para que el texto no pegue en los bordes
        local padding = Instance.new("UIPadding", frame)
        padding.PaddingLeft = UDim.new(0, 12)
        padding.PaddingRight = UDim.new(0, 12)

        -- Borde sutil
        local stroke = Instance.new("UIStroke", frame)
        stroke.Color = Color3.fromRGB(200, 200, 200)
        stroke.Thickness = 1
        stroke.Transparency = 1

        -- 2. El texto
        local textLabel = Instance.new("TextLabel", frame)
        textLabel.AutomaticSize = Enum.AutomaticSize.X
        textLabel.Size = UDim2.new(0, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = text
        textLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
        textLabel.Font = Enum.Font.GothamMedium
        textLabel.TextSize = 13
        textLabel.TextTransparency = 1

        -- 3. Animación de entrada suave
        local TweenService = game:GetService("TweenService")
        TweenService:Create(frame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0.15}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.25), {Transparency = 0.5}):Play()
        TweenService:Create(textLabel, TweenInfo.new(0.25), {TextTransparency = 0}):Play()

        -- 4. Tiempo de espera (2.5 segundos)
        task.wait(2.5)

        -- 5. Animación de salida (Desvanecimiento)
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
    Vis = MainSection:Tab({Title = "Visuales", Icon = "solar:eye-bold"}),
    Mov = MainSection:Tab({Title = "Movimiento", Icon = "solar:running-bold"}),
    Farm = MainSection:Tab({Title = "AutoFarm", Icon = "solar:dollar-bold"}),
    Graficos = MainSection:Tab({Title = "Gráficos", Icon = "solar:palette-bold"}), -- 🔥 NUEVA PESTAÑA AQUÍ
    Emotes = TrollSection:Tab({Title = "Animaciones", Icon = "solar:smile-circle-bold"}),
    Com = TrollSection:Tab({Title = "Comunidad", Icon = "solar:chat-line-bold"}),
    Config = TrollSection:Tab({Title = "Configuración", Icon = "solar:settings-bold"})
}
-- ==========================================
-- PESTAÑA INICIO
-- ==========================================
Tabs.Inicio:Section({Title = "Perfil del Jugador"})

local execName = "Desconocido"
pcall(function() execName = identifyexecutor and identifyexecutor() or "Desconocido" end)

UIElements.PerfilParagraph = Tabs.Inicio:Paragraph({ 
    Title = "Perfil " .. player.DisplayName, 
    Desc = "Usuario: @" .. player.Name .. "\nID: " .. player.UserId .. "\nEdad de la cuenta: " .. player.AccountAge .. " días",
    Image = "rbxthumb://type=AvatarHeadShot&id=" .. player.UserId .. "&w=420&h=420",
    ImageSize = 48 
})


Tabs.Inicio:Paragraph({ 
    Title = "Sistema", 
    Desc = "Ejecutor actual: " .. execName
})

Tabs.Inicio:Section({Title = "Información del Servidor"})

-- Se carga de forma directa (como en MM2)
local gameNameStr = "Desconocido"
pcall(function() 
    gameNameStr = MarketplaceService:GetProductInfo(game.PlaceId).Name 
end)

Tabs.Inicio:Paragraph({ 
    Title = "Juego Actual", 
    Desc = gameNameStr .. "\nPlace ID: " .. game.PlaceId,
    Image = "rbxthumb://type=GameIcon&id=" .. game.GameId .. "&w=150&h=150", --  Extrae la foto oficial del juego
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
        -- Copiamos el link por si Roblox bloquea el TP por seguridad
        pcall(function() setclipboard("https://www.roblox.com/games/" .. tostring(placeId)) end)
        task.wait(0.5)
        showBottomMessage("Link copiado. Si no te hace TP, pégalo en tu navegador para entrar.")
        -- Intentamos el TP de todos modos
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
    Callback = function() TPSeguro_Duels(117973911105557, "MMV") end
})


Tabs.Inicio:Section({Title = "Optimización"})

local Stats = game:GetService("Stats")
local statsContainer = Instance.new("Frame")
statsContainer.Size = UDim2.new(0, 150, 0, 50)
statsContainer.Position = UDim2.new(1, -170, 0, 10) -- Esquina superior derecha, sin estorbar
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
fpsLabel.Font = Enum.Font.GothamBlack -- Fuente más gruesa y moderna
fpsLabel.TextSize = 16 
fpsLabel.TextXAlignment = Enum.TextXAlignment.Right
fpsLabel.TextStrokeTransparency = 0 -- Borde negro al 100% para que resalte
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
        
        -- Colores más agradables a la vista (Verde esmeralda, amarillo brillante y rojo suave)
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
            -- 1. APAGAR ILUMINACIÓN GLOBAL
            origGlobalShadows = Lighting.GlobalShadows
            origFogEnd = Lighting.FogEnd
            origShadowSoftness = Lighting.ShadowSoftness
            
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 9e9
            Lighting.ShadowSoftness = 0
            
            -- 2. APAGAR TERRENO Y AGUA (Con protección pcall)
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
            
            -- 3. MODO PLASTILINA SEGURO (Anti-Crasheo Ultra Rápido)
            local function applyLowGraphics(v)
                -- 🔥 FILTRO ULTRA RÁPIDO: Si el objeto no es visual, lo ignoramos al instante sin gastar CPU
                if not v:IsA("BasePart") and not v:IsA("Decal") and not v:IsA("Texture") and not v:IsA("SpecialMesh") and not v:IsA("Light") and not v:IsA("PostEffect") and not v:IsA("SurfaceAppearance") and not v:IsA("Clothing") then 
                    return 
                end

                pcall(function() -- Evita que un error detenga todo el proceso
                    if v:IsA("ScreenGui") then return end
                    -- Protegemos a los avatares para que no pierdan la ropa o se rompan
                    if v.Parent and v.Parent:FindFirstChild("Humanoid") then return end

                    if v:IsA("BasePart") and not v:IsA("Terrain") then 
                        if not v:GetAttribute("OrigMat") then 
                            v:SetAttribute("OrigMat", v.Material.Name)
                            v:SetAttribute("OrigCast", v.CastShadow)
                        end
                        v.Material = Enum.Material.SmoothPlastic
                        v.Reflectance = 0
                        v.CastShadow = false 
                        
                        -- Elimina las texturas 3D
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
            
            -- Aplicamos en un hilo separado con pausas milimétricas para evitar crasheos (Timeout)
            task.spawn(function()
                local count = 0
                for _, v in pairs(workspace:GetDescendants()) do 
                    applyLowGraphics(v) 
                    count = count + 1
                    if count % 300 == 0 then task.wait() end -- Pausa cada 300 partes
                end
            end)
            
            if not autoFpsConnection then
                autoFpsConnection = workspace.DescendantAdded:Connect(function(v)
                    if fpsBoostEnabled then applyLowGraphics(v) end
                end)
            end
            showBottomMessage("FPS Boost Aplicando...")
        else
            -- =====================================
            -- RESTAURAR ABSOLUTAMENTE TODO 
            -- =====================================
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

-- ==========================================
-- PESTAÑA AIMBOT
-- ==========================================
task.wait() -- <--- AÑADIR ESTO AQUÍ

local macroActivo = false
Tabs.Aim:Section({Title = "Macro (Pistola)"})
UIElements.TogMacro = Tabs.Aim:Toggle({
    Title = "Activar Macro", 
    Desc = "Dispara con un solo toque.",
    Callback = function(s) macroActivo = s end
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

local function estaEnLobby()
    local char = player.Character if not char then return true end
    if char:FindFirstChildOfClass("ForceField") then return true end
    if player.Team then
        local tName = string.lower(player.Team.Name)
        if string.find(tName, "lobby") or string.find(tName, "spectat") or string.find(tName, "espectador") or string.find(tName, "menu") or string.find(tName, "dead") then return true end
    end
    return false
end

local function ejecutarAccionMacro()
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
        task.wait(0.01) 
        if pistola.Parent == char then 
            pistola:Activate() 
            task.wait(0.01) 
            hum:UnequipTools() 
        end
    end)
end

local toquesPantalla = {} 
UserInputService.InputBegan:Connect(function(input, processed)
    if processed or not macroActivo then return end
    
    if input.UserInputType == Enum.UserInputType.MouseButton1 then 
        ejecutarAccionMacro()
    elseif input.UserInputType == Enum.UserInputType.Touch then
        local pos = input.Position
        local dzPos = deadZoneFrame.AbsolutePosition
        local dzSize = deadZoneFrame.AbsoluteSize
        local tocoZonaMuerta = (pos.X >= dzPos.X) and (pos.X <= dzPos.X + dzSize.X) and (pos.Y >= dzPos.Y) and (pos.Y <= dzPos.Y + dzSize.Y)
        if not tocoZonaMuerta then toquesPantalla[input] = {posicion = input.Position, tiempo = tick()} end
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
        if distanciaMovida < 10 and tiempoPresionado < 0.35 and tiempoPresionado > 0.03 then ejecutarAccionMacro() end
    end
end)

-- ==========================================
-- 🚀 OPTIMIZACIÓN EXTREMA: CACHÉ DE ENEMIGOS
-- ==========================================
local enemyCache = {}
local lastCacheUpdate = 0

local function isEnemy(targetPlayer)
    if not teamCheckEnabled then return true end
    if targetPlayer == player then return false end
    
    -- Refrescamos la memoria cada 1 segundo para no saturar el procesador
    if tick() - lastCacheUpdate > 1 then
        enemyCache = {}
        lastCacheUpdate = tick()
    end
    
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


-- ==========================================
-- AUTO SHOOT (SILENT AIM POR RAYCAST - EXTREMO)
-- ==========================================
Tabs.Aim:Section({Title = "Auto Shoot"})

local autoShootAgresivoEnabled = false

UIElements.TogAutoShoot = Tabs.Aim:Toggle({
    Title = "Auto Shoot (Normal - Cabeza/Torso)",
    Desc = "Dispara automáticamente al torso o cabeza sin fallar.",
    Callback = function(Value)
        autoShootEnabled = Value
        showBottomMessage(Value and "Auto Shoot Normal: ACTIVADO" or "Auto Shoot Normal: DESACTIVADO")
        if not Value and not autoShootAgresivoEnabled then getgenv().AstraTargetPart = nil end
    end,
})

UIElements.TogAutoShootAgr = Tabs.Aim:Toggle({
    Title = "Auto Shoot (Agresivo - Hitbox Completa)",
    Desc = "Dispara a cualquier píxel visible del cuerpo del enemigo.",
    Callback = function(Value)
        autoShootAgresivoEnabled = Value
        showBottomMessage(Value and "Auto Shoot Agresivo: ACTIVADO" or "Auto Shoot Agresivo: DESACTIVADO")
        if not Value and not autoShootEnabled then getgenv().AstraTargetPart = nil end
    end,
})


local tapToShootEnabled = false

local silentAimManualEnabled = false

local silentAimTargetPart = "Cabeza" -- Valor por defecto

local silentAimFovEnabled = false


UIElements.TogSilentAimManual = Tabs.Aim:Toggle({
    Title = "Silent Aim",
    Desc = "Redirige las balas al enemigo.",
    Callback = function(Value)
        silentAimManualEnabled = Value
        showBottomMessage(Value and "Silent Aim: ACTIVADO" or "Silent: DESACTIVADO")
        if not Value and not autoShootEnabled and not autoShootAgresivoEnabled then getgenv().AstraTargetPart = nil end
    end,
})

local aimTargetIniciado = false -- Seguro anti-spam inicial
UIElements.DropSilentAimPart = Tabs.Aim:Dropdown({
    Title = "Target: Parte del cuerpo",
    Values = {"Cabeza", "Torso", "Cuerpo Completo"},
    Value = "Cabeza",
    Callback = function(Value)
        silentAimTargetPart = Value
        -- Solo lanza la notificación si no es la primera vez que carga
        if aimTargetIniciado then
            showBottomMessage("Apuntando a: " .. Value)
        end
        aimTargetIniciado = true
    end
})

UIElements.TogSilentAimFOV = Tabs.Aim:Toggle({
    Title = "Silent Aim (Con FOV)",
    Desc = "Igual que el Silent Aim, pero solo afecta a los enemigos dentro del círculo.",
    Callback = function(Value)
        silentAimFovEnabled = Value
        showBottomMessage(Value and "Silent Aim FOV: ACTIVADO" or "Silent FOV: DESACTIVADO")
        if not Value and not silentAimManualEnabled and not autoShootEnabled and not autoShootAgresivoEnabled then getgenv().AstraTargetPart = nil end
    end,
})

UIElements.TogShowFOV = Tabs.Aim:Toggle({
    Title = "Mostrar Círculo FOV",
    Desc = "Dibuja un círculo en pantalla para que sepas dónde funciona tu Silent Aim.",
    Callback = function(Value) fovVisiblePreference = Value end,
})

UIElements.SliFOVSize = Tabs.Aim:Slider({
    Title = "Tamaño del FOV", 
    Step = 1,
    Value = {Min = 10, Max = 800, Default = 120}, 
    Callback = function(v) 
        fovRadius = v 
    end
})

getgenv().AstraTargetPart = nil

-- 1. EL HOOK DE RAYCAST (OPTIMIZACIÓN EXTREMA ANTI-TIRONES)
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()

    if not checkcaller() and getgenv().AstraTargetPart then
        local target = getgenv().AstraTargetPart
        
        if target and target.Parent then
            if method == "Raycast" and self == workspace then
                -- Leemos las variables directamente sin empaquetarlas en una tabla
                local origin, direction, p3 = ...
                if typeof(direction) == "Vector3" and direction.Magnitude > 20 then
                    local newDir = (target.Position - origin).Unit * 5000 
                    return oldNamecall(self, origin, newDir, p3)
                end
                
            elseif string.find(method, "FindPartOnRay") and self == workspace then
                local ray, p2, p3, p4 = ...
                if typeof(ray) == "Ray" and ray.Direction.Magnitude > 20 then
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

-- 2. BUCLE PRINCIPAL (Con selector Normal / Agresivo)
task.spawn(function()
    -- 1. OPTIMIZACIÓN CLAVE: Creamos los parámetros del Raycast UNA SOLA VEZ fuera del bucle
    -- Esto elimina los tirones de FPS y la fuga de memoria por completo.
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude

    while task.wait(0.1) do
        if autoShootEnabled or autoShootAgresivoEnabled then
            local char = player.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then continue end

            local arma = char:FindFirstChildOfClass("Tool")
            if not arma or not arma:FindFirstChild("Handle") then 
                getgenv().AstraTargetPart = nil
                continue 
            end

            local closestTargetPart = nil
            local shortestDistance = math.huge
            local myPos = char.HumanoidRootPart.Position
            local headPos = char:FindFirstChild("Head") and char.Head.Position or myPos

            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= player and isEnemy(p) and p.Character then
                    local enemyHum = p.Character:FindFirstChild("Humanoid")
                    if enemyHum and enemyHum.Health > 0 then
                        
                        -- Filtro para exclusión
                        params.FilterDescendantsInstances = {char, p.Character}
                        
                        -- FUNCIÓN LIGERA: Evitamos crear tablas temporales
                        local function ProcesarParte(part)
                            local dist = (part.Position - myPos).Magnitude
                            if dist < shortestDistance then
                                local size = part.Size
                                local offsets = {
                                    Vector3.new(0, 0, 0), Vector3.new(size.X/2.1, 0, 0), 
                                    Vector3.new(-size.X/2.1, 0, 0), Vector3.new(0, size.Y/2.1, 0), 
                                    Vector3.new(0, -size.Y/2.1, 0)
                                }
                                local isVisible = false
                                for _, offset in ipairs(offsets) do
                                    if not workspace:Raycast(headPos, (part.CFrame * offset) - headPos, params) then
                                        isVisible = true
                                        break 
                                    end
                                end
                                if isVisible then
                                    shortestDistance = dist
                                    closestTargetPart = part
                                end
                            end
                        end

                        if autoShootAgresivoEnabled then
                            -- AGRESIVO
                            for _, part in ipairs(p.Character:GetChildren()) do
                                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then 
                                    ProcesarParte(part)
                                end
                            end
                        else
                            -- NORMAL
                            local partesClave = {"Head", "HumanoidRootPart", "UpperTorso", "Torso"}
                            for _, partName in ipairs(partesClave) do
                                local part = p.Character:FindFirstChild(partName)
                                if part and part:IsA("BasePart") then 
                                    ProcesarParte(part)
                                end
                            end
                        end
                    end -- Cierra el if de la vida del enemigo
                end -- Cierra el if de la comprobación del enemigo
            end -- Cierra el for loop de los jugadores
            
            -- Ejecución del disparo
            if closestTargetPart then
                getgenv().AstraTargetPart = closestTargetPart
                
                pcall(function() 
                    arma:Activate() 
                    -- FIX: Simulamos soltar el clic una fracción de segundo después
                    -- para que el script del arma se reinicie y no se atasque.
                    task.delay(0.05, function() 
                        if arma.Parent == char then
                            arma:Deactivate() 
                        end
                    end)
                end)
                
                -- 3. AJUSTE DE VELOCIDAD: Lo bajé de 0.4 a 0.2 para que reaccione más rápido
                task.wait(0.2) 
            else
                getgenv().AstraTargetPart = nil
            end
        end
    end
end)

task.spawn(function()
    -- OPTIMIZACIÓN: Creamos el RaycastParams afuera del bucle para no causar lag
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude

    while task.wait(0.1) do
        if silentAimManualEnabled or silentAimFovEnabled then
            local char = player.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then continue end

            local closestTargetPart = nil
            local shortestDistToCenter = math.huge -- Para el FOV
            local shortestDistanceFisica = math.huge -- Para el Manual
            
            local myPos = char.HumanoidRootPart.Position
            local headPos = char:FindFirstChild("Head") and char.Head.Position or myPos

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
                            
                            -- CÁLCULO PARA EL FOV EN PANTALLA
                            local pos2D, onScreen = camera:WorldToViewportPoint(part.Position)
                            local distToCenter = (Vector2.new(pos2D.X, pos2D.Y) - Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)).Magnitude
                            
                            local pasaFiltro = false
                            
                            -- Determinamos si cumple con las reglas del FOV o del Aim normal
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
                if not autoShootEnabled and not autoShootAgresivoEnabled then
                    getgenv().AstraTargetPart = nil
                end
            end
        end
    end
end)

-- ==========================================
-- HITBOX EXPANDER
-- ==========================================
Tabs.Aim:Section({Title = "Hitbox Expander"})

UIElements.TogHitbox = Tabs.Aim:Toggle({
    Title = "Aumentar Hitbox",
    Desc = "Expande la caja de colisión de los enemigos para que no falles ninguna bala.",
    Callback = function(s) 
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
    end
})

UIElements.TogHbInv = Tabs.Aim:Toggle({
    Title = "Hitbox Invisible", 
    Desc = "Oculta las cajas gigantes de los enemigos.",
    Callback = function(s) hitboxInvisible = s end
})

UIElements.SliHitbox = Tabs.Aim:Slider({
    Title = "Tamaño de Hitbox (Slider)", 
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

UIElements.ColHitbox = Tabs.Aim:Colorpicker({Title = "Color de Hitbox", Default = Color3.fromRGB(255,255,255), Callback = function(c) hitboxColor = c end})

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

    -- 🚀 OPTIMIZACIÓN: Creamos el RaycastParams UNA SOLA VEZ afuera del bucle
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude

    while getgenv().AstraHitboxLoop and task.wait(0.1) do
        local enLobby = false 
        pcall(function() enLobby = estaEnLobby() end)
        
        if hitboxEnabled and not enLobby then
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= player and isEnemy(v) and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                    local hrp = v.Character.HumanoidRootPart 
                    local targetSize = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                    if hrp.Size ~= targetSize then hrp.Size = targetSize end
                    if hrp.CanCollide ~= false then hrp.CanCollide = false end
                    
                    local aLaVista = false
                    if player.Character and player.Character:FindFirstChild("Head") then
                        local origin = camera.CFrame.Position 
                        params.FilterDescendantsInstances = {player.Character, v.Character}
                        local result = workspace:Raycast(origin, hrp.Position - origin, params) 
                        aLaVista = not result 
                    end
                    
                    local targetColor = aLaVista and hitboxColor or Color3.fromRGB(255, 50, 50)
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
            for _, v in pairs(Players:GetPlayers()) do if v ~= player then limpiarHitbox(v) end end 
        end
    end
end)

-- ==========================================
-- IMÁN DE ENEMIGOS (MAGNET TP LOCAL) 
-- ==========================================
Tabs.Aim:Section({Title = "TP enemigos"})

local magnetTpEnabled = false
local distFrente = -2 
local maxMagnetDistance = 100 

UIElements.TogIman = Tabs.Aim:Toggle({
    Title = "Enemies TP",
    Desc = "Teletransporta temporalmente a los enemigos justo enfrente de ti.",
    Callback = function(Value)
        magnetTpEnabled = Value
        if Value then
            showBottomMessage("Activado.")
            task.spawn(function()
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= player and isEnemy(p) and p.Character then
                        local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            local viejo = hrp:FindFirstChild("AstraPosBackup")
                            if viejo then viejo:Destroy() end
                            local backup = Instance.new("CFrameValue")
                            backup.Name = "AstraPosBackup"
                            backup.Value = hrp.CFrame
                            backup.Parent = hrp
                        end
                    end
                end
            end)
        else
            showBottomMessage("Desactivado")
            task.spawn(function()
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= player and isEnemy(p) and p.Character then
                        local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            local backup = hrp:FindFirstChild("AstraPosBackup")
                            if backup then hrp.CFrame = backup.Value backup:Destroy() end
                        end
                    end
                end
            end)
        end
    end,
})

UIElements.SliImanDist = Tabs.Aim:Slider({
    Title = "Rango del TP (Distancia)", 
    Step = 10,
    Value = {Min = 10, Max = 500, Default = 100}, 
    Callback = function(v) maxMagnetDistance = v end
})

-- 🚀 OPTIMIZACIÓN: Cambiado de RenderStepped a Heartbeat para no asfixiar la gráfica
RunService.Heartbeat:Connect(function()
    if not magnetTpEnabled then return end
    local miChar = player.Character if not miChar then return end
    local miHrp = miChar:FindFirstChild("HumanoidRootPart") local miHum = miChar:FindFirstChild("Humanoid")
    if not miHrp or not miHum or miHum.Health <= 0 then return end
    
    for _, targetPlayer in pairs(Players:GetPlayers()) do
        if targetPlayer ~= player and isEnemy(targetPlayer) then
            local enemyChar = targetPlayer.Character
            if enemyChar then
                local enemyHrp = enemyChar:FindFirstChild("HumanoidRootPart") local enemyHum = enemyChar:FindFirstChild("Humanoid")
                if enemyHrp and enemyHum and enemyHum.Health > 0 then
                    local distancia = (miHrp.Position - enemyHrp.Position).Magnitude
                    if distancia <= maxMagnetDistance then 
                        enemyHrp.CFrame = miHrp.CFrame * CFrame.new(0, 0, distFrente) 
                    end
                end
            end
        end
    end
end)






-- ==========================================
-- PESTAÑA VISUALES (ESP & SPOOFER)
-- ==========================================
task.wait() -- <--- AÑADIR ESTO AQUÍ
Tabs.Vis:Section({Title = "Opciones Visuales"})

local spoofLoop = nil
local isWorkspaceLooping = false
local originalData = {}

local function safeReplace(str, find, replace) local safeFind = find:gsub("[%-%^%$%(%)%%%.%[%]%*%+%?]", "%%%1") return (str:gsub(safeFind, replace)) end
local function processText(v, myName, myDisp)
    -- 🔥 ANTI-LAG: Evitamos que el sistema hackee los textos del propio Hub
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
local visualConnections = {} -- 🚀 Nueva tabla para guardar eventos

local function updateSystem()
    local myName = player.Name 
    local myDisp = player.DisplayName

    -- Escaneo de un solo toque (Súper ligero)
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

            -- 🚀 OPTIMIZACIÓN: Solo vigilamos lo que "aparece nuevo", no escaneamos lo viejo infinitamente.
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
UIElements.TogEspGl = Tabs.Vis:Toggle({Title = "Mostrar Resplandor", Callback = function(s) espSettings.Glow = s end})
UIElements.TogEspNm = Tabs.Vis:Toggle({Title = "Mostrar Nombre", Callback = function(s) espSettings.Name = s end})
UIElements.TogEspHp = Tabs.Vis:Toggle({Title = "Mostrar Vida", Callback = function(s) espSettings.Health = s end})
UIElements.TogEspDs = Tabs.Vis:Toggle({Title = "Mostrar Distancia", Callback = function(s) espSettings.Distance = s end})

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
    while task.wait(0.2) do -- Ligero para el CPU, pero rápido visualmente
        if espEnabled then
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
                                -- 🚀 AQUÍ ESTÁ LA MAGIA: Transparencia de relleno al 1 = Solo el puro borde
                                highlight.FillTransparency = 1 
                                highlight.OutlineTransparency = 0 
                                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop 
                                highlight.Adornee = char 
                                highlight.Parent = espFolder
                                
                                local billboard = Instance.new("BillboardGui") 
                                billboard.Name = p.Name.."_Tag" 
                                billboard.Size = UDim2.new(0, 200, 0, 50) 
                                billboard.StudsOffset = Vector3.new(0, 3.5, 0) 
                                billboard.AlwaysOnTop = true 
                                billboard.Adornee = targetHead 
                                billboard.Parent = espFolder
                                
                                local textLabel = Instance.new("TextLabel") 
                                textLabel.Name = "Text" 
                                textLabel.Size = UDim2.new(1, 0, 1, 0) 
                                textLabel.BackgroundTransparency = 1 
                                textLabel.TextStrokeTransparency = 0 
                                textLabel.Font = Enum.Font.GothamBold 
                                textLabel.TextSize = 12 
                                textLabel.Parent = billboard
                                
                                activeESPs[p] = {Highlight = highlight, Billboard = billboard, Char = char, Text = textLabel}
                            end
                            
                            local espObj = activeESPs[p]
                            
                            -- Solo actualizar si es necesario
                            if espObj.Highlight.Enabled ~= espSettings.Glow then espObj.Highlight.Enabled = espSettings.Glow end
                            if espObj.Highlight.OutlineColor ~= espColor then espObj.Highlight.OutlineColor = espColor end
                            if espObj.Text.TextColor3 ~= espColor then espObj.Text.TextColor3 = espColor end
                            
                            local infoText = ""
                            if espSettings.Name then infoText = p.Name end 
                            if espSettings.Health then infoText = infoText .. (infoText == "" and "" or " | ") .. math.floor(char.Humanoid.Health) .. " HP" end
                            if espSettings.Distance then infoText = infoText .. (infoText == "" and "" or " | ") .. math.floor(dist) .. "m" end
                            
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

-- ==========================================
-- DIBUJADO EN PANTALLA 2D (Círculo FOV y Tracers)
-- ==========================================
local FOVCircle = Drawing.new("Circle")
FOVCircle.Position = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
FOVCircle.Radius = fovRadius
FOVCircle.Filled = false
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Visible = false
FOVCircle.Thickness = 1

local tracerLines = {}

RunService.RenderStepped:Connect(function()
    -- 1. Actualizar Círculo FOV
    if fovVisiblePreference then
        FOVCircle.Position = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
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

    -- 2. 🚀 LÍNEAS TRACERS ULTRA OPTIMIZADAS
    if not espEnabled or not espLinesEnabled then
        for _, tLine in pairs(tracerLines) do 
            if tLine.Visible then tLine.Visible = false end 
        end
        return
    end

    local myChar = player.Character
    local myPos = (myChar and myChar.PrimaryPart) and myChar.PrimaryPart.Position or camera.CFrame.Position
    
    -- OPTIMIZACIÓN 1: Calculamos el centro de la pantalla UNA sola vez por frame
    local centroPantallaX = camera.ViewportSize.X / 2

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then
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
                    local hrpPos, onScreen = camera:WorldToViewportPoint(hrp.Position)
                    
                    -- OPTIMIZACIÓN 2: Solo calculamos la raíz cuadrada (Magnitude) si el enemigo está en la pantalla
                    if onScreen then
                        local dist = (myPos - hrp.Position).Magnitude
                        
                        if dist <= MAX_ESP_DISTANCE then
                            -- OPTIMIZACIÓN 3: Evitamos mandar info a la gráfica si ya tiene esos valores
                            if tLine.From.X ~= centroPantallaX then tLine.From = Vector2.new(centroPantallaX, 0) end
                            tLine.To = Vector2.new(hrpPos.X, hrpPos.Y)
                            if tLine.Color ~= espColor then tLine.Color = espColor end
                            if not tLine.Visible then tLine.Visible = true end
                            continue -- Saltamos al siguiente jugador rápido
                        end
                    end
                end
            end
            
            -- Si el enemigo murió, se salió de la pantalla o es de tu equipo, lo apagamos (si no estaba apagado ya)
            if tLine.Visible then tLine.Visible = false end
        end
    end
end)

Players.PlayerRemoving:Connect(function(p)
    if tracerLines[p] then tracerLines[p]:Remove(); tracerLines[p] = nil end
    cleanESP(p)
end)



-- ==========================================
-- PESTAÑA MOVIMIENTO
-- ==========================================
task.wait() -- <--- AÑADIR ESTO AQUÍ
Tabs.Mov:Section({Title = "Movimiento del Jugador"})
local bg, bv
local Controls

-- FIX: Lo cargamos en segundo plano para que NUNCA congele la interfaz
task.spawn(function()
    local PlayerModule = require(player:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"))
    Controls = PlayerModule:GetControls()
end)

UIElements.TogFly = Tabs.Mov:Toggle({Title = "Fly (Volar)", Callback = function(s)
    flying = s
    if flying then
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local hrp = char.HumanoidRootPart bg = Instance.new("BodyGyro") bg.P = 9e4 bg.maxTorque = Vector3.new(9e9, 9e9, 9e9) bg.cframe = hrp.CFrame bg.Parent = hrp
            bv = Instance.new("BodyVelocity") bv.velocity = Vector3.new(0, 0, 0) bv.maxForce = Vector3.new(9e9, 9e9, 9e9) bv.Parent = hrp
            if char:FindFirstChild("Humanoid") then char.Humanoid.PlatformStand = true end
        end
    else
        if bg then bg:Destroy() end if bv then bv:Destroy() end
        local char = player.Character if char and char:FindFirstChild("Humanoid") then char.Humanoid.PlatformStand = false end
    end
end})
UIElements.SliFly = Tabs.Mov:Slider({Title = "Velocidad de Vuelo", Step = 1, Value = {Min = 10, Max = 200, Default = 50}, Callback = function(v) flySpeed = v end})

RunService.RenderStepped:Connect(function()
    if flying and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and Controls then
        local moveVector = Controls:GetMoveVector() 
        local moveDir = camera.CFrame:VectorToWorldSpace(moveVector)
        if bv and bg then bv.Velocity = moveDir * flySpeed bg.CFrame = camera.CFrame end
    end
end)

Tabs.Mov:Section({Title = "Speed Hack (Caminar Rápido)"})
local speedEnabled = false local walkSpeedValue = 50
Tabs.Mov:Toggle({
    Title = "Activar Speed Hack", 
    Desc = "Modifica tu velocidad.",
    Callback = function(s) speedEnabled = s local char = player.Character if not s and char and char:FindFirstChild("Humanoid") then char.Humanoid.WalkSpeed = 16 end end
})

Tabs.Mov:Slider({Title = "Velocidad de Caminar", Step = 1, Value = {Min = 16, Max = 250, Default = 50}, Callback = function(v) walkSpeedValue = v if speedEnabled then local char = player.Character if char and char:FindFirstChild("Humanoid") then char.Humanoid.WalkSpeed = walkSpeedValue end end end})
task.spawn(function() while task.wait(0.1) do if speedEnabled then local char = player.Character if char and char:FindFirstChild("Humanoid") then char.Humanoid.WalkSpeed = walkSpeedValue end end end end)

local lagBtn = Instance.new("TextButton")
lagBtn.Size = UDim2.new(0, 120, 0, 42) lagBtn.Position = UDim2.new(0.05, 0, 0.6, 0) lagBtn.BackgroundColor3 = Color3.fromRGB(20, 24, 30) lagBtn.BackgroundTransparency = 0.2 lagBtn.Text = "" lagBtn.AutoButtonColor = false lagBtn.Visible = false lagBtn.ZIndex = 50 lagBtn.Parent = screenGui
Instance.new("UICorner", lagBtn).CornerRadius = UDim.new(1, 0)
local lagStroke = Instance.new("UIStroke", lagBtn) lagStroke.Thickness = 1.5 lagStroke.Color = Color3.fromRGB(68, 71, 70) lagStroke.Transparency = 0.4
local lagGrad = Instance.new("UIGradient", lagBtn) lagGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 40, 50)), ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 18, 22))}) lagGrad.Rotation = 45
local lagIcon = Instance.new("TextLabel", lagBtn) lagIcon.Size = UDim2.new(0, 30, 1, 0) lagIcon.Position = UDim2.new(0, 12, 0, 0) lagIcon.BackgroundTransparency = 1 lagIcon.Text = "" lagIcon.Font = Enum.Font.Gotham lagIcon.TextSize = 16
local lagText = Instance.new("TextLabel", lagBtn) lagText.Size = UDim2.new(1, -45, 1, 0) lagText.Position = UDim2.new(0, 42, 0, 0) lagText.BackgroundTransparency = 1 lagText.Text = "Fake Lag" lagText.TextColor3 = Color3.fromRGB(227, 227, 227) lagText.Font = Enum.Font.Montserrat lagText.TextSize = 13 lagText.TextXAlignment = Enum.TextXAlignment.Left
makeDraggable(lagBtn, lagBtn)

local isLagging = false local lagStartPos = nil
lagBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then lagStartPos = lagBtn.AbsolutePosition TweenService:Create(lagBtn, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 110, 0, 38)}):Play() end
end)
lagBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        TweenService:Create(lagBtn, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 120, 0, 42)}):Play()
        if lagStartPos then
            local currentPos = lagBtn.AbsolutePosition local distanciaMoved = (Vector2.new(lagStartPos.X, lagStartPos.Y) - Vector2.new(currentPos.X, currentPos.Y)).Magnitude
            if distanciaMoved < 5 then
                isLagging = not isLagging
                if isLagging then pcall(function() settings():GetService("NetworkSettings").IncomingReplicationLag = 9999 end) TweenService:Create(lagStroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(168, 199, 250), Transparency = 0}):Play() TweenService:Create(lagText, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(168, 199, 250)}):Play() pcall(function() showBottomMessage("Fake lag activado") end)
                else pcall(function() settings():GetService("NetworkSettings").IncomingReplicationLag = 0 end) TweenService:Create(lagStroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(68, 71, 70), Transparency = 0.4}):Play() TweenService:Create(lagText, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(227, 227, 227)}):Play() pcall(function() showBottomMessage("Fake lag apagado") end) end
            end
        end
    end
end)
Tabs.Mov:Toggle({Title = "Mostrar Botón de Fake Lag", Callback = function(s) lagBtn.Visible = s if not s and isLagging then isLagging = false pcall(function() settings():GetService("NetworkSettings").IncomingReplicationLag = 0 end) TweenService:Create(lagStroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(68, 71, 70), Transparency = 0.4}):Play() TweenService:Create(lagText, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(227, 227, 227)}):Play() end end})

local noclipConnection = nil
Tabs.Mov:Toggle({Title = "Noclip (Atravesar Paredes)", Callback = function(s)
    if s then if not noclipConnection then noclipConnection = RunService.Stepped:Connect(function() local char = player.Character if char then for _, part in pairs(char:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = false end end end end) end
    else if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end end
end})


-- ==========================================
-- PESTAÑA GRÁFICOS (SHADERS Y OPTIMIZACIÓN)
-- ==========================================
Tabs.Graficos:Section({Title = "Modos Visuales (Elige solo uno)"})

local shaderEffects = {}
local tokyowamiEffects = {}
local nightEffects = {}
local pinkEffects = {}
local nightActivo = false
local pinkActivo = false

local shaderAjustes = {
    -- Ajustes Noche
    Exposicion = 0.28,
    Sombras = 5,
    Neon = 0.45,
    LunaPos = 85,          
    Desenfoque = 2,        
    SuavidadSombras = 0.1, 
    ColorSaturacion = 0.15,
    
    -- Ajustes Pink Hour (Vaporwave)
    PinkRosa = 0.8,       -- Intensidad del Rosa
    PinkMorado = 0.7,     -- Intensidad del Morado
    PinkSaturacion = 0.4, -- Saturación
    PinkNeon = 0.3        -- Resplandor
}

-- 🔥 FUNCIÓN MAESTRA PARA ANIQUILAR NUBES Y ATMÓSFERA (OPTIMIZADA ANTI-FREEZE) 🔥
local function ToggleNubesYAtmo(apagar, tag)
    local Lighting = game:GetService("Lighting")
    
    -- Las atmósferas solo existen dentro de Lighting, no hay que buscar en todo el mapa
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
    
    -- Las nubes solo están sueltas en Workspace o Terrain, esto evita escanear 50,000 partes a lo loco
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

-- 🔥 FUNCIÓN QUE ACTUALIZA EL PINK HOUR EN TIEMPO REAL 🔥
local function UpdatePinkHourVibe()
    if not pinkActivo then return end
    local Lighting = game:GetService("Lighting")
    
    local rosa = shaderAjustes.PinkRosa
    local morado = shaderAjustes.PinkMorado
    
    -- Matemáticas para mezclar rosa y morado sin romper el RGB
    local r = math.clamp(math.floor(255 - (100 * morado)), 0, 255)
    local g = math.clamp(math.floor(255 - (155 * rosa) - (200 * morado)), 0, 255)
    local b = 255
    
    -- 1. Actualizar Efectos
    for _, effect in ipairs(pinkEffects) do
        if effect:IsA("ColorCorrectionEffect") then
            effect.TintColor = Color3.fromRGB(r, g, b)
            effect.Saturation = shaderAjustes.PinkSaturacion
            effect.Contrast = 0.05 + (0.1 * morado) + (0.05 * rosa)
        elseif effect:IsA("BloomEffect") then
            effect.Intensity = shaderAjustes.PinkNeon
        end
    end
    
    -- 2. Actualizar Iluminación del Mundo (Para que el 3D también cambie de color)
    Lighting.ColorShift_Top = Color3.fromRGB(math.floor(255 - (50 * morado)), math.floor(50 + (50 * (1-rosa))), math.floor(150 + (105 * morado)))
    Lighting.ColorShift_Bottom = Color3.fromRGB(math.floor(30 + (70 * rosa)), 0, math.floor(50 + (80 * morado)))
    Lighting.OutdoorAmbient = Color3.fromRGB(math.floor(50 + (80 * rosa)), 0, math.floor(80 + (80 * morado)))
    Lighting.Ambient = Color3.fromRGB(math.floor(60 + (30 * rosa)), math.floor(20 * (1-morado)), math.floor(80 + (40 * morado)))
    
    -- Si hay más morado, oscurecemos ligeramente la cámara para darle vibra nocturna
    Lighting.ExposureCompensation = 0.1 - (0.25 * morado)
end

-- ==========================================
-- 1. SHADERS TOKYOWAMI SHRINE (AESTHETIC)
-- ==========================================
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

-- ==========================================
-- 2. SHADERS NOCTURNOS (CUSTOM PBR)
-- ==========================================
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

-- ==========================================
-- 3. SHADER PINK HOUR 🌸 (MORADO AESTHETIC VIBE)
-- ==========================================
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

            -- Creamos los efectos base (se colorean en UpdatePinkHourVibe)
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
            
            -- Llama a la función que colorea de inmediato
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

-- ==========================================
-- 🎚️ SECCIÓN: AJUSTES MODO NOCHE PBR
-- ==========================================
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

-- ==========================================
-- 🎚️ SECCIÓN: AJUSTES PINK HOUR (VAPORWAVE)
-- ==========================================
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

-- ==========================================
-- PESTAÑA AUTO FARM
-- ==========================================
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


-- ==========================================
-- COMPRADOR DE CAJAS (TIENDA) - CON DETECCIÓN DE ARMA
-- ==========================================
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

-- Función para leer la respuesta del servidor
local function procesarCompra()
    local success, result = pcall(function()
        local args = { [1] = selectedBox }
        return game:GetService("ReplicatedStorage").Packages.Networking:FindFirstChild("RF/Shop/BuyCase"):InvokeServer(unpack(args))
    end)

    if success then
        -- Dependiendo de cómo esté programado el juego, el resultado puede ser una tabla o un texto.
        local premio = "Desconocido (Revisa tu inventario)"
        
        if type(result) == "table" then
            -- Convertimos la tabla a texto para poder leerla en consola
            premio = HttpService:JSONEncode(result)
            print("Caja abierta. Resultado:", premio)
            
            -- Intentamos adivinar si el arma viene en algún índice común
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
        procesarCompra()
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
                    task.wait(1.5) -- Pausa obligatoria para evitar kick
                end
            end)
        else
            showBottomMessage("Auto-compra detenida.")
        end
    end
})

-- ==========================================
-- PESTAÑA EMOTES Y ANIMACIONES (BUSCADOR ZERO-LAG)
-- ==========================================
local floatEmoteBtn = Instance.new("ImageButton") floatEmoteBtn.Size = UDim2.new(0, 50, 0, 50) floatEmoteBtn.Position = UDim2.new(0.8, -60, 0.6, 0) floatEmoteBtn.BackgroundColor3 = Color3.fromRGB(30, 31, 34) floatEmoteBtn.Image = "rbxassetid://84732211934298" floatEmoteBtn.ImageColor3 = Color3.fromRGB(138, 43, 226) floatEmoteBtn.Visible = false floatEmoteBtn.ZIndex = 50 floatEmoteBtn.Parent = screenGui
Instance.new("UICorner", floatEmoteBtn).CornerRadius = UDim.new(1, 0) local feStroke = Instance.new("UIStroke", floatEmoteBtn) feStroke.Thickness = 2 feStroke.Color = Color3.fromRGB(138, 43, 226)
makeDraggable(floatEmoteBtn, floatEmoteBtn)

local emoteMenu = Instance.new("Frame") emoteMenu.Size = UDim2.new(0, 300, 0, 370) emoteMenu.Position = UDim2.new(0.5, -150, 0.5, -185) emoteMenu.BackgroundTransparency = 1 emoteMenu.Visible = false emoteMenu.ZIndex = 55 emoteMenu.Parent = screenGui makeDraggable(emoteMenu, emoteMenu)
local emTitle = Instance.new("TextLabel", emoteMenu) emTitle.Size = UDim2.new(1, -40, 0, 25) emTitle.Position = UDim2.new(0, 10, 0, 0) emTitle.BackgroundTransparency = 1 emTitle.Text = "Emotes | Duelos" emTitle.TextColor3 = Color3.fromRGB(138, 43, 226) emTitle.Font = Enum.Font.GothamBold emTitle.TextSize = 14 emTitle.TextXAlignment = Enum.TextXAlignment.Left emTitle.ZIndex = 56
local emClose = Instance.new("TextButton", emoteMenu) emClose.Size = UDim2.new(0, 25, 0, 25) emClose.Position = UDim2.new(1, -30, 0, 0) emClose.BackgroundColor3 = Color3.fromRGB(30, 31, 34) emClose.Text = "X" emClose.TextColor3 = Color3.fromRGB(255, 80, 80) emClose.Font = Enum.Font.GothamBold emClose.TextSize = 12 emClose.ZIndex = 56 Instance.new("UICorner", emClose).CornerRadius = UDim.new(0, 16)
local emSearchBg = Instance.new("Frame", emoteMenu) emSearchBg.Size = UDim2.new(1, -20, 0, 30) emSearchBg.Position = UDim2.new(0, 10, 0, 30) emSearchBg.BackgroundColor3 = Color3.fromRGB(30, 31, 34) emSearchBg.ZIndex = 56 Instance.new("UICorner", emSearchBg).CornerRadius = UDim.new(0, 16) local emSearchStroke = Instance.new("UIStroke", emSearchBg) emSearchStroke.Color = Color3.fromRGB(138, 43, 226) emSearchStroke.Thickness = 1 emSearchStroke.Transparency = 0.5
local emSearchBox = Instance.new("TextBox", emSearchBg) emSearchBox.Size = UDim2.new(1, -20, 1, 0) emSearchBox.Position = UDim2.new(0, 10, 0, 0) emSearchBox.BackgroundTransparency = 1 emSearchBox.PlaceholderText = "Buscar (Ej: Dance, Floss)..." emSearchBox.Text = "" emSearchBox.TextColor3 = Color3.fromRGB(227, 227, 227) emSearchBox.PlaceholderColor3 = Color3.fromRGB(196, 199, 197) emSearchBox.Font = Enum.Font.Montserrat emSearchBox.TextSize = 11 emSearchBox.TextXAlignment = Enum.TextXAlignment.Left emSearchBox.ZIndex = 57
local wheelBg = Instance.new("Frame", emoteMenu) wheelBg.Size = UDim2.new(0, 240, 0, 240) wheelBg.Position = UDim2.new(0.5, -120, 0, 70) wheelBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0) wheelBg.BackgroundTransparency = 0.15 wheelBg.ZIndex = 55 Instance.new("UICorner", wheelBg).CornerRadius = UDim.new(1, 0) local wheelStroke = Instance.new("UIStroke", wheelBg) wheelStroke.Thickness = 2 wheelStroke.Color = Color3.fromRGB(138, 43, 226)
local centerText = Instance.new("TextLabel", wheelBg) centerText.Size = UDim2.new(0, 120, 0, 50) centerText.Position = UDim2.new(0.5, -60, 0.5, -25) centerText.BackgroundTransparency = 1 centerText.Text = "Toca un cuadro para bailar" centerText.TextColor3 = Color3.fromRGB(227, 227, 227) centerText.Font = Enum.Font.GothamBold centerText.TextSize = 11 centerText.TextWrapped = true centerText.ZIndex = 56
local pageContainer = Instance.new("Frame", emoteMenu) pageContainer.Size = UDim2.new(0, 160, 0, 35) pageContainer.Position = UDim2.new(0.5, -80, 1, -40) pageContainer.BackgroundColor3 = Color3.fromRGB(30, 31, 34) pageContainer.ZIndex = 56 Instance.new("UICorner", pageContainer).CornerRadius = UDim.new(1, 0) local pageStroke = Instance.new("UIStroke", pageContainer) pageStroke.Color = Color3.fromRGB(138, 43, 226) pageStroke.Thickness = 1.5
local pageLbl = Instance.new("TextLabel", pageContainer) pageLbl.Size = UDim2.new(0, 80, 1, 0) pageLbl.Position = UDim2.new(0.5, -40, 0, 0) pageLbl.BackgroundTransparency = 1 pageLbl.Text = "1 / 1" pageLbl.TextColor3 = Color3.fromRGB(227, 227, 227) pageLbl.Font = Enum.Font.GothamBold pageLbl.TextSize = 11 pageLbl.ZIndex = 57
local btnPrev = Instance.new("TextButton", pageContainer) btnPrev.Size = UDim2.new(0, 25, 0, 25) btnPrev.Position = UDim2.new(0, 8, 0.5, -12.5) btnPrev.BackgroundColor3 = Color3.fromRGB(19, 19, 20) btnPrev.Text = "<" btnPrev.TextColor3 = Color3.fromRGB(138, 43, 226) btnPrev.Font = Enum.Font.GothamBold btnPrev.ZIndex = 57 Instance.new("UICorner", btnPrev).CornerRadius = UDim.new(1, 0)
local btnNext = Instance.new("TextButton", pageContainer) btnNext.Size = UDim2.new(0, 25, 0, 25) btnNext.Position = UDim2.new(1, -33, 0.5, -12.5) btnNext.BackgroundColor3 = Color3.fromRGB(19, 19, 20) btnNext.Text = ">" btnNext.TextColor3 = Color3.fromRGB(138, 43, 226) btnNext.Font = Enum.Font.GothamBold btnNext.ZIndex = 57 Instance.new("UICorner", btnNext).CornerRadius = UDim.new(1, 0)

local function renderEmotes()
    for _, child in pairs(wheelBg:GetChildren()) do if child:IsA("ImageButton") then child:Destroy() end end
    local totalEmotes = #filteredEmotes if totalEmotes == 0 then pageLbl.Text = "0 / 0" return end
    local maxPages = math.ceil(totalEmotes / emotesPerPage) if currentPage > maxPages then currentPage = maxPages end if currentPage < 1 then currentPage = 1 end
    pageLbl.Text = currentPage .. " / " .. maxPages
    local startIndex = (currentPage - 1) * emotesPerPage + 1 local endIndex = math.min(currentPage * emotesPerPage, totalEmotes)
    for i = startIndex, endIndex do
        local emote = filteredEmotes[i] local orderIndex = i - startIndex 
        local btn = Instance.new("ImageButton") btn.Size = UDim2.new(0, 42, 0, 42) btn.AnchorPoint = Vector2.new(0.5, 0.5) local angle = math.rad((orderIndex * 30) - 90) btn.Position = UDim2.new(0.5, math.cos(angle) * 90, 0.5, math.sin(angle) * 90) btn.BackgroundColor3 = Color3.fromRGB(19, 19, 20) btn.ZIndex = 57 btn.Parent = wheelBg Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 16)
        local icon = Instance.new("ImageLabel") icon.Size = UDim2.new(1, -6, 1, -6) icon.Position = UDim2.new(0, 3, 0, 3) icon.BackgroundTransparency = 1 icon.Image = "rbxthumb://type=Asset&id=" .. emote.id .. "&w=150&h=150" icon.ZIndex = 58 icon.Parent = btn
        btn.Activated:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(138, 43, 226)}):Play() task.wait(0.1) TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(19, 19, 20)}):Play()
            centerText.Text = emote.name local char = player.Character if not char or not char:FindFirstChild("Humanoid") then return end char.Humanoid:UnequipTools() if currentEmoteTrack then currentEmoteTrack:Stop() end
            local success, objects = pcall(function() return game:GetObjects("rbxassetid://" .. emote.id) end)
            if success and objects then
                local realAnimId = nil for _, obj in pairs(objects) do if obj:IsA("Animation") then realAnimId = obj.AnimationId break elseif obj:FindFirstChildOfClass("Animation", true) then realAnimId = obj:FindFirstChildOfClass("Animation", true).AnimationId break end end
                if realAnimId then local animator = char.Humanoid:FindFirstChild("Animator") or Instance.new("Animator", char.Humanoid) local anim = Instance.new("Animation") anim.AnimationId = realAnimId local ok, track = pcall(function() return animator:LoadAnimation(anim) end) if ok then currentEmoteTrack = track currentEmoteTrack.Priority = Enum.AnimationPriority.Action currentEmoteTrack.Looped = true currentEmoteTrack:Play() end end
            end
        end)
    end
end
emClose.Activated:Connect(function() emoteMenu.Visible = false end)
btnPrev.Activated:Connect(function() if currentPage > 1 then currentPage = currentPage - 1 renderEmotes() end end)
btnNext.Activated:Connect(function() local maxPages = math.ceil(#filteredEmotes / emotesPerPage) if currentPage < maxPages then currentPage = currentPage + 1 renderEmotes() end end)
emSearchBox.Changed:Connect(function(prop) if prop == "Text" then local text = string.lower(emSearchBox.Text) filteredEmotes = {} if text == "" then filteredEmotes = allEmotes else for _, emote in pairs(allEmotes) do if string.find(string.lower(emote.name), text) then table.insert(filteredEmotes, emote) end end end currentPage = 1 renderEmotes() end end)

UIElements.TogEmoteWalk = Tabs.Emotes:Toggle({Title = "Emote Walk (Bailar al caminar)", Callback = function(s) emoteWalkEnabled = s showBottomMessage(s and "Emote Walk: ACTIVADO" or "Emote Walk: DESACTIVADO") end})
Tabs.Emotes:Toggle({Title = "Mostrar Ruleta de Emotes", Callback = function(s) floatEmoteBtn.Visible = s if not s then emoteMenu.Visible = false end end})
Tabs.Emotes:Button({Title = "Detener emote Actual", Callback = function() if currentEmoteTrack then currentEmoteTrack:Stop() currentEmoteTrack = nil centerText.Text = "Toca un cuadro para bailar" showBottomMessage("Baile detenido.") end end})

floatEmoteBtn.MouseButton1Click:Connect(function() emoteMenu.Visible = not emoteMenu.Visible if emoteMenu.Visible then if #allEmotes == 0 then showBottomMessage("Usa el botón de descargar datos primero.") return end if #filteredEmotes == 0 then filteredEmotes = allEmotes end renderEmotes() end end)
RunService.Stepped:Connect(function() if player.Character and player.Character:FindFirstChild("Humanoid") then if currentEmoteTrack and currentEmoteTrack.IsPlaying and player.Character.Humanoid.MoveDirection.Magnitude > 0 then if not emoteWalkEnabled then currentEmoteTrack:Stop() currentEmoteTrack = nil centerText.Text = "Baile detenido (Movimiento)" end end end end)

-- ========================================================
-- 🔥 NUEVO SISTEMA DE ANIMACIONES: BUSCADOR ZERO-LAG 🔥
-- ========================================================
local MisAnimacionesOriginales = nil 
local paqueteActivo = nil 
ultimoTipoAplicado = "Paquete" 
local BaseAnimacionesGlobal = {} 

local MasterAnimList = {} 

local Traducciones = {["Elder Animation Package"] = "Paquete de Anciano", ["Zombie Animation Pack"] = "Paquete de Zombi", ["Ninja Animation Package"] = "Paquete de Ninja", ["Vampire Animation Pack"] = "Paquete de Vampiro", ["Superhero Animation Pack"] = "Paquete de Superhéroe", ["Robot Animation Pack"] = "Paquete de Robot", ["Mage Animation Package"] = "Paquete de Mago", ["Knight Animation Package"] = "Paquete de Caballero", ["Pirate Animation Package"] = "Paquete de Pirata", ["Astronaut Animation Pack"] = "Paquete de Astronauta", ["Werewolf Animation Pack"] = "Paquete de Hombre Lobo", ["Toy Animation Pack"] = "Paquete de Juguete", ["Bubbly Animation Package"] = "Paquete Burbujeante", ["Cartoony Animation Package"] = "Paquete Animado (Caricatura)", ["Stylish Animation Pack"] = "Paquete Estiloso", ["Oldschool Animation Pack"] = "Paquete Vieja Escuela", ["Levitation Animation Pack"] = "Paquete de Levitación", ["Glow Motion"] = "Movimiento Brillante (Glow)", ["Rthro Animation Package"] = "Paquete Rthro (Default)"}

local fullPackDrop
local mixDrops = {}

-- Movimos esto hacia arriba para que el buscador pueda "recordar" tus elecciones
local mixSeleccionado = {idle = nil, walk = nil, run = nil, jump = nil, fall = nil, climb = nil}
local partesMixer = {{id = "idle", nom = "Reposo"}, {id = "walk", nom = "Caminar"}, {id = "run", nom = "Correr"}, {id = "jump", nom = "Saltar"}, {id = "fall", nom = "Caer"}, {id = "climb", nom = "Escalar"}}

Tabs.Emotes:Section({ Title = "Descarga de Datos" })
Tabs.Emotes:Button({
    Title = " Descargar Bases de Datos",
    Callback = function()
        if #MasterAnimList > 0 then showBottomMessage("Los datos ya están listos.") return end
        
        showBottomMessage("Descargando bases de datos (Espera unos segundos)")
        
        task.spawn(function()
            local jsonE, jsonA = "", ""
            pcall(function()
                local req = (syn and syn.request) or (http and http.request) or http_request or request
                if req then
                    jsonE = req({Url = "https://raw.githubusercontent.com/7yd7/sniper-Emote/refs/heads/test/EmoteSniper.json", Method = "GET"}).Body
                    jsonA = req({Url = "https://raw.githubusercontent.com/7yd7/sniper-Emote/refs/heads/test/AnimationSniper.json", Method = "GET"}).Body
                else
                    jsonE = game:HttpGetAsync("https://raw.githubusercontent.com/7yd7/sniper-Emote/refs/heads/test/EmoteSniper.json")
                    jsonA = game:HttpGetAsync("https://raw.githubusercontent.com/7yd7/sniper-Emote/refs/heads/test/AnimationSniper.json")
                end
            end)

            if jsonE and jsonE ~= "" then
                local sE, decE = pcall(function() return HttpService:JSONDecode(jsonE) end)
                if sE and decE and decE.data then allEmotes = decE.data filteredEmotes = allEmotes end
            end
            jsonE = nil 
            
            if jsonA and jsonA ~= "" then
                local sA, decA = pcall(function() return HttpService:JSONDecode(jsonA) end)
                if sA and decA and decA.data then
                    MasterAnimList = {}
                    for _, item in pairs(decA.data) do
                        if item.name and item.bundledItems then 
                            local nombreTraducido = Traducciones[item.name] or item.name 
                            BaseAnimacionesGlobal[nombreTraducido] = item.bundledItems 
                            table.insert(MasterAnimList, nombreTraducido) 
                        end
                    end
                    table.sort(MasterAnimList)
                    
                    local top25 = {}
                    for i = 1, math.min(#MasterAnimList, 25) do table.insert(top25, MasterAnimList[i]) end
                    
                    pcall(function()
                        if fullPackDrop then fullPackDrop:Refresh(top25) fullPackDrop:Select(top25[1]) end
                        for _, drop in ipairs(mixDrops) do drop:Refresh(top25) drop:Select(top25[1]) end
                    end)
                end
            end
            jsonA = nil 
            
            showBottomMessage("¡Bases de datos listas!")
        end)
    end
})

Tabs.Emotes:Section({Title = "Buscador de Animaciones"})

-- Variables de estado para la paginación
local animPage = 1
local animMaxPerPage = 10
local currentFilteredAnims = {}
local lastSearchText = ""

-- Función para decidir qué lista usar (La completa o la filtrada)
local function getActiveList()
    if lastSearchText == "" then
        return MasterAnimList
    else
        return currentFilteredAnims
    end
end

-- Función maestra que inyecta la página actual a los Dropdowns
local function updateAnimDropdowns()
    local list = getActiveList()
    local resultadosMostrados = {}
    
    local startIndex = (animPage - 1) * animMaxPerPage + 1
    local endIndex = math.min(animPage * animMaxPerPage, #list)
    
    for i = startIndex, endIndex do
        table.insert(resultadosMostrados, list[i])
    end
    
    if #resultadosMostrados == 0 then 
        table.insert(resultadosMostrados, "No se encontraron resultados") 
    end

    pcall(function()
        -- 1. Actualiza el paquete completo
        if fullPackDrop then 
            fullPackDrop:Refresh(resultadosMostrados) 
            fullPackDrop:Select(resultadosMostrados[1]) 
        end
        
        -- 2. Actualiza el mezclador protegiendo selecciones previas
        for i, drop in ipairs(mixDrops) do 
            local estadoId = partesMixer[i].id
            local seleccionActual = mixSeleccionado[estadoId]
            
            local resultadosDrop = {}
            for _, v in ipairs(resultadosMostrados) do table.insert(resultadosDrop, v) end
            
            if seleccionActual and seleccionActual ~= "Usa el buscador..." and seleccionActual ~= "No se encontraron resultados" then
                local yaEsta = false
                for _, v in ipairs(resultadosDrop) do
                    if v == seleccionActual then yaEsta = true break end
                end
                if not yaEsta then table.insert(resultadosDrop, seleccionActual) end
            end
            
            drop:Refresh(resultadosDrop) 
            if seleccionActual and seleccionActual ~= "Usa el buscador..." then
                drop:Select(seleccionActual)
            else
                drop:Select("Usa el buscador...")
            end
        end
    end)
end

-- Input de búsqueda corregido
Tabs.Emotes:Input({
    Title = "Buscar Animación",
    Placeholder = "Ej: Zombie, Ninja, Cartoony...",
    Callback = function(Text)
        if #MasterAnimList == 0 then 
            -- Si WindUI dispara esto al iniciar (con texto vacío), lo ignoramos silenciosamente
            if Text ~= "" then
                showBottomMessage("Descarga los datos primero")
            end
            return 
        end
        
        lastSearchText = string.lower(Text)
        currentFilteredAnims = {}
        animPage = 1 -- Reset de página en cada búsqueda nueva
        
        if lastSearchText ~= "" then
            for _, name in ipairs(MasterAnimList) do
                if string.find(string.lower(name), lastSearchText) then
                    table.insert(currentFilteredAnims, name)
                end
            end
        end
        
        updateAnimDropdowns()
        
        local list = getActiveList()
        local totalPages = math.max(1, math.ceil(#list / animMaxPerPage))
        -- Solo mostramos el mensaje de página si el usuario realmente buscó algo
        if Text ~= "" then
            showBottomMessage("Página " .. animPage .. " de " .. totalPages)
        end
    end
})

-- Controles de Paginación
Tabs.Emotes:Button({
    Title = "⬅️ Página Anterior",
    Callback = function()
        local list = getActiveList()
        if #list == 0 then return end

        if animPage > 1 then
            animPage = animPage - 1
            updateAnimDropdowns()
            showBottomMessage("Página " .. animPage .. " de " .. math.ceil(#list / animMaxPerPage))
        else
            showBottomMessage("Ya estás en la primera página")
        end
    end
})

Tabs.Emotes:Button({
    Title = "Página Siguiente ➡️",
    Callback = function()
        local list = getActiveList()
        if #list == 0 then return end
        
        local totalPages = math.ceil(#list / animMaxPerPage)
        if animPage < totalPages then
            animPage = animPage + 1
            updateAnimDropdowns()
            showBottomMessage("Página " .. animPage .. " de " .. totalPages)
        else
            showBottomMessage("Ya estás en la última página")
        end
    end
})

local function ExtraerAnimacionesDePaquete(bundledItems)
    local bundleData = {}
    for _, idGrup in pairs(bundledItems) do
        local listaIds = type(idGrup) == "table" and idGrup or {idGrup}
        for _, assetId in pairs(listaIds) do
            local idLimpio = tostring(assetId):match("%d+")
            if idLimpio then
                local s, objects = pcall(function() return game:GetObjects("rbxassetid://" .. idLimpio) end)
                if s and objects then
                    local function searchTree(parent, topCategory)
                        for _, child in ipairs(parent:GetChildren()) do if child:IsA("Animation") then local cat = topCategory and string.lower(topCategory) or string.lower(parent.Name) if not bundleData[cat] then bundleData[cat] = {} end bundleData[cat][child.Name] = child.AnimationId elseif #child:GetChildren() > 0 then local nextCat = topCategory if parent.Name == "R15Anim" then nextCat = child.Name end searchTree(child, nextCat) end end
                    end
                    for _, obj in pairs(objects) do searchTree(obj, obj.Name) pcall(function() obj:Destroy() end) end
                end
            end
        end
    end
    return bundleData
end

local function inyectarPaquete(bundleAInyectar)
    local char = player.Character if not char then return end
    local animate = char:FindFirstChild("Animate") local hum = char:FindFirstChild("Humanoid") if not animate or not hum then return end
    animate.Disabled = true local animator = hum:FindFirstChild("Animator") if animator then for _, track in pairs(animator:GetPlayingAnimationTracks()) do track:Stop(0) end end
    if bundleAInyectar then
        for estado, datosAnim in pairs(bundleAInyectar) do
            local estadoObj = animate:FindFirstChild(estado)
            if estadoObj then
                local idComodin = nil if type(datosAnim) == "table" then for _, id in pairs(datosAnim) do idComodin = id break end else idComodin = datosAnim end
                if idComodin then for _, descendiente in ipairs(estadoObj:GetDescendants()) do if descendiente:IsA("Animation") then local idEspecifico = nil if type(datosAnim) == "table" then idEspecifico = datosAnim[descendiente.Name] end descendiente.AnimationId = idEspecifico or idComodin end end end
            end
        end
    end
    local estadoViejo = hum:GetState() hum:ChangeState(Enum.HumanoidStateType.Landed) task.wait(0.05) hum:ChangeState(estadoViejo) animate.Disabled = false
end

Tabs.Emotes:Section({Title = "Paquetes Completos"})
local selectedBundleCompleto = nil
fullPackDrop = Tabs.Emotes:Dropdown({Title = "Elegir Paquete", Values = {"Usa el buscador de arriba..."}, Value = "Usa el buscador de arriba...", Callback = function(Value) selectedBundleCompleto = Value end})
Tabs.Emotes:Button({Title = "Aplicar Paquete", Callback = function()
    if not selectedBundleCompleto or selectedBundleCompleto == "Usa el buscador de arriba..." then showBottomMessage("Usa el buscador primero.") return end
    ultimoTipoAplicado = "Paquete" local bundledItems = BaseAnimacionesGlobal[selectedBundleCompleto] if not bundledItems then return end
    local char = player.Character local animate = char and char:FindFirstChild("Animate")
    if animate and not MisAnimacionesOriginales then MisAnimacionesOriginales = {} for _, estado in pairs({"idle", "walk", "run", "jump", "fall", "climb", "swim", "swimidle"}) do if animate:FindFirstChild(estado) then MisAnimacionesOriginales[estado] = {} for _, obj in pairs(animate[estado]:GetChildren()) do if obj:IsA("Animation") then MisAnimacionesOriginales[estado][obj.Name] = obj.AnimationId end end end end end
    task.spawn(function() local paqueteExtraido = ExtraerAnimacionesDePaquete(bundledItems) if paqueteExtraido then paqueteActivo = paqueteExtraido inyectarPaquete(paqueteExtraido) end end)
end})
Tabs.Emotes:Button({Title = "Restaurar Default", Callback = function()
    ultimoTipoAplicado = "Ninguno" if not MisAnimacionesOriginales then showBottomMessage("Ya tienes tus animaciones originales.") return end
    task.spawn(function() paqueteActivo = nil inyectarPaquete(MisAnimacionesOriginales) end)
end})

Tabs.Emotes:Section({Title = "Mezclador de Animaciones"})
for _, parte in ipairs(partesMixer) do local dp = Tabs.Emotes:Dropdown({Title = parte.nom, Values = {"Usa el buscador..."}, Value = "Usa el buscador...", Callback = function(Value) mixSeleccionado[parte.id] = Value end}) table.insert(mixDrops, dp) end

Tabs.Emotes:Button({Title = "Combinar animaciones", Callback = function()
    ultimoTipoAplicado = "Mix" local tieneAlgo = false for k, v in pairs(mixSeleccionado) do if v and v ~= "Usa el buscador..." then tieneAlgo = true break end end
    if not tieneAlgo then showBottomMessage("Elige al menos una animación.") return end
    local char = player.Character local animate = char and char:FindFirstChild("Animate")
    if animate and not MisAnimacionesOriginales then MisAnimacionesOriginales = {} for _, estado in pairs({"idle", "walk", "run", "jump", "fall", "climb", "swim", "swimidle"}) do if animate:FindFirstChild(estado) then MisAnimacionesOriginales[estado] = {} for _, obj in pairs(animate[estado]:GetChildren()) do if obj:IsA("Animation") then MisAnimacionesOriginales[estado][obj.Name] = obj.AnimationId end end end end end
    task.spawn(function()
        local mixFinal = {}
        for estadoId, nombrePaquete in pairs(mixSeleccionado) do if nombrePaquete and nombrePaquete ~= "Usa el buscador..." then local bundledItems = BaseAnimacionesGlobal[nombrePaquete] if bundledItems then local paqueteExtraido = ExtraerAnimacionesDePaquete(bundledItems) if paqueteExtraido and paqueteExtraido[estadoId] then mixFinal[estadoId] = paqueteExtraido[estadoId] end end end end
        local logramosArmar = false for k,v in pairs(mixFinal) do logramosArmar = true break end if logramosArmar then paqueteActivo = mixFinal inyectarPaquete(mixFinal) end
    end)
end})

getgenv().AstraGetSavedAnimations = function() return {Tipo = ultimoTipoAplicado, Paquete = selectedBundleCompleto, Mix = mixSeleccionado} end
getgenv().AstraApplySavedAnimations = function(animData)
    if not animData or animData.Tipo == "Ninguno" then return end
    local char = player.Character local animate = char and char:FindFirstChild("Animate")
    if animate and not MisAnimacionesOriginales then MisAnimacionesOriginales = {} for _, estado in pairs({"idle", "walk", "run", "jump", "fall", "climb", "swim", "swimidle"}) do if animate:FindFirstChild(estado) then MisAnimacionesOriginales[estado] = {} for _, obj in pairs(animate[estado]:GetChildren()) do if obj:IsA("Animation") then MisAnimacionesOriginales[estado][obj.Name] = obj.AnimationId end end end end end
    task.spawn(function()
        local intentos = 0 while #MasterAnimList == 0 and intentos < 50 do task.wait(0.1) intentos = intentos + 1 end
        if animData.Tipo == "Mix" and animData.Mix then mixSeleccionado = animData.Mix ultimoTipoAplicado = "Mix" local mixFinal = {} local logramosArmar = false
            for estadoId, nombrePaquete in pairs(mixSeleccionado) do if nombrePaquete and nombrePaquete ~= "Cargando base de datos..." then local bundledItems = BaseAnimacionesGlobal[nombrePaquete] if bundledItems then local paqueteExtraido = ExtraerAnimacionesDePaquete(bundledItems) if paqueteExtraido and paqueteExtraido[estadoId] then mixFinal[estadoId] = paqueteExtraido[estadoId] logramosArmar = true end end end end
            if logramosArmar then paqueteActivo = mixFinal inyectarPaquete(mixFinal) end
        elseif animData.Tipo == "Paquete" and animData.Paquete then selectedBundleCompleto = animData.Paquete ultimoTipoAplicado = "Paquete"
            local bundledItems = BaseAnimacionesGlobal[selectedBundleCompleto] if bundledItems then local paqueteExtraido = ExtraerAnimacionesDePaquete(bundledItems) if paqueteExtraido then paqueteActivo = paqueteExtraido inyectarPaquete(paqueteExtraido) end end
        end
    end)
end
player.CharacterAdded:Connect(function(newChar)
    if paqueteActivo then task.spawn(function() local animate = newChar:WaitForChild("Animate", 5) if animate and not MisAnimacionesOriginales then MisAnimacionesOriginales = {} for _, estado in pairs({"idle", "walk", "run", "jump", "fall", "climb", "swim", "swimidle"}) do if animate:FindFirstChild(estado) then MisAnimacionesOriginales[estado] = {} for _, obj in pairs(animate[estado]:GetChildren()) do if obj:IsA("Animation") then MisAnimacionesOriginales[estado][obj.Name] = obj.AnimationId end end end end end newChar:WaitForChild("Humanoid", 5) task.wait(0.5) inyectarPaquete(paqueteActivo) end) end
end)

-- ==========================================
-- PESTAÑA COMUNIDAD
-- ==========================================
Tabs.Com:Section({Title = "Reportar bug/error o alguna sugerencia"})
local reportText = ""
Tabs.Com:Input({Title = "Mensaje", Placeholder = "Escribe aquí...", Callback = function(t) reportText = t end})
Tabs.Com:Button({Title = "Enviar", Callback = function()
    local texto = reportText
    if texto ~= "" and texto:match("%S") and texto ~= "TextBox" and texto ~= "¡Enviado con éxito!" and texto ~= "Escribe algo..." then
        local Http = game:GetService("HttpService") local urlText = Http:UrlEncode(texto) local myName = Http:UrlEncode(player.Name)
        task.spawn(function() pcall(function() AstraRequest("/reporte?user=" .. myName .. "&texto=" .. urlText) end) end)
        showBottomMessage("¡Enviado con éxito!")
    else showBottomMessage("Escribe algo...") end
end})

Tabs.Com:Section({Title = "Redes"})
Tabs.Com:Button({Title = "Grupo de WhatsApp", Callback = function() pcall(function() setclipboard("https://chat.whatsapp.com/Cf0nBeKHRaXAg3o7zGccqi?s=cl&p=a&ilr=4&amv=2") game:GetService("StarterGui"):SetCore("SendNotification", {Title = "¡Link Copiado!", Text = "Pégalo en tu navegador o en WhatsApp para unirte.", Duration = 4}) end) end})





Tabs.Config:Section({ Title = "Personalización de Interfaz" })

-- 🎨 SELECTOR DE TEMAS 
local temasDisponibles = {"Midnight", "Dark", "Rose", "Emerald", "Sky", "Violet", "Amber", "Crimson", "Monokai Pro", "Cotton Candy", "Light", "Mellowsi", "Rainbow", "Indigo", "Red", "Plant"}

local temaIniciado = false -- Seguro anti-spam inicial
Tabs.Config:Dropdown({
    Title = "Tema de la Interfaz",
    Values = temasDisponibles,
    Value = "Midnight", 
    Callback = function(Value)
        pcall(function()
            WindUI:SetTheme(Value)
            -- Solo lanza la notificación si el usuario lo cambia manualmente
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
                        
                        -- Subimos hasta la caja principal
                        local btnContainer = v
                        while btnContainer.Parent and not btnContainer.Parent:IsA("ScreenGui") and not btnContainer.Parent:IsA("Folder") do
                            btnContainer = btnContainer.Parent
                        end
                        
                        if btnContainer:IsA("CanvasGroup") then
                            btnContainer.GroupTransparency = Value and 1 or 0
                        else
                            -- Función inteligente que "recuerda" la transparencia original
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
                            
                            -- Aplicamos a todo lo de adentro
                            for _, obj in pairs(btnContainer:GetDescendants()) do
                                aplicarTransparencia(obj)
                            end
                            -- Aplicamos a la caja contenedora
                            aplicarTransparencia(btnContainer)
                        end
                    end
                end
            end
        end
    end
})

-- ==========================================
-- PESTAÑA FINAL: CONFIGURACIÓN (SISTEMA ILIMITADO)
-- ==========================================
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
                    -- Extraemos solo el nombre del archivo sin la ruta ni el .json
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
    
    -- Si el usuario escribió un nombre, usamos ese. Si no, sobreescribimos el seleccionado en el dropdown.
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
            ["Mostrar Círculo FOV"] = fovVisiblePreference, ["Silent Aim (FOV)"] = aimbotEnabled, ["Auto Shoot (Sin FOV)"] = autoShootEnabled, ["Aimbot Full (Sin FOV)"] = fullAimbotEnabled, ["Aumentar Hitbox"] = hitboxEnabled, ["Hitbox Invisible"] = hitboxInvisible, ["ESP Jugadores"] = espEnabled, ["Mostrar Resplandor (Glow)"] = espSettings.Glow, ["Mostrar Nombre"] = espSettings.Name, ["Mostrar Vida"] = espSettings.Health, ["Mostrar Distancia"] = espSettings.Distance, ["Emote Walk (Bailar al caminar)"] = emoteWalkEnabled, ["Ocultar mi Nombre (Local)"] = hideNameEnabled, ["Fly (Volar)"] = flying, ["Enemies TP"] = magnetTpEnabled, ["FPS Boost"] = fpsBoostEnabled
        },
        Sliders = { ["Tamaño del FOV"] = fovRadius, ["Tamaño de Hitbox"] = hitboxSize, ["Velocidad de Vuelo"] = flySpeed },
        Colors = { ["Color de Hitbox"] = {R = hitboxColor.R, G = hitboxColor.G, B = hitboxColor.B}, ["Color del ESP"] = {R = espColor.R, G = espColor.G, B = espColor.B} },
        Extras = { ["Parte Aimbot"] = aimbotTargetPart },
        Animaciones = getgenv().AstraGetSavedAnimations and getgenv().AstraGetSavedAnimations() or nil
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
            
            -- Toggles
            if decoded.Toggles then
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
            
            -- Sliders
            if decoded.Sliders then 
                if decoded.Sliders["Tamaño de Hitbox"] ~= nil then hitboxSize = decoded.Sliders["Tamaño de Hitbox"] secureLoadToggle(UIElements.SliHitbox, hitboxSize) end
                if decoded.Sliders["Velocidad de Vuelo"] ~= nil then flySpeed = decoded.Sliders["Velocidad de Vuelo"] secureLoadToggle(UIElements.SliFly, flySpeed) end
            end
            
            -- Colores
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
            
            if decoded.Animaciones and getgenv().AstraApplySavedAnimations then getgenv().AstraApplySavedAnimations(decoded.Animaciones) end
            
            showBottomMessage("✅ '" .. selectedConfig .. "' cargada con éxito.")
        else 
            showBottomMessage("❌ Error al leer el archivo.") 
        end
    else 
        showBottomMessage("❌ La configuración no existe.") 
    end
end})

-- Cargar la lista al iniciar el script
task.spawn(function()
    task.wait(1)
    refreshConfigs()
end)


-- ==========================================
-- 🔥 FIX DEFINITIVO: VRAM CACHE (PRECARGA SEGURA)
-- ==========================================
task.spawn(function()
    task.wait(2) -- Dejamos que WindUI acomode todos sus elementos primero
    
    local core = pcall(function() return game:GetService("CoreGui") end) and game:GetService("CoreGui")
    local pGui = player:FindFirstChild("PlayerGui")
    local windUI = (core and core:FindFirstChild("OnyxHub_WindUI")) or (pGui and pGui:FindFirstChild("OnyxHub_WindUI"))
    
    if windUI then
        local mainCanvas = windUI:FindFirstChildWhichIsA("CanvasGroup", true)
        
        if mainCanvas then
            -- Guardamos su estado original
            local estadoTransparencia = mainCanvas.GroupTransparency
            local estadoVisible = mainCanvas.Visible
            
            -- Encendemos el menú de forma invisible (0.99) para forzar el renderizado en la RAM
            mainCanvas.GroupTransparency = 0.99 
            mainCanvas.Visible = true 
            
            -- Le damos tiempo a Roblox para procesar los gráficos sin laggear el juego
            task.wait(1.5) 
            
            -- Lo regresamos a la normalidad para que la librería WindUI retome el control
            mainCanvas.GroupTransparency = estadoTransparencia
            mainCanvas.Visible = estadoVisible
        end
    end
end)


print("OnyxHub Cargado Exitosamente!")
