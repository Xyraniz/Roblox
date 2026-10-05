local q = game:GetService("Players")
local o = game:GetService("RunService")
local R = game:GetService("UserInputService")
local s = game:GetService("ReplicatedStorage")
local A = game:GetService("TweenService")
local z = game:GetService("MarketplaceService")
local b = game:GetService("HttpService")
local P = game:GetService("Workspace")
local J = false
local W = false
local E = q["LocalPlayer"]
while not E do
    task["wait"]()
    E = q["LocalPlayer"]
end
local L = P["CurrentCamera"]
local T = E:GetMouse()
_G["AstraBotonesOcultos"] = false
local X = false
local c = -694762 - (-694882)
local G = false
local f = {}
local t = {}
local i = false
local d = false
local K = false
local M = false
local V = false
local Q = 10
local a = Color3["fromRGB"](948600085 % 8949055, 255, 1194634299 % 6986164)
local y = true
local k = false
local r = Color3["fromRGB"]((-656692 + -178054) - (-843775 + 8774), 255, -143931 - (-144186))
local D = {["Glow"] = true, ["Name"] = true, ["Health"] = true, ["Distance"] = true}
local B = false
local v = false
local S = false
local H = ((-280777 + -627715) - (-405455)) - (-503087)
local l = false
local Y = nil
local O = {}
local g = {}
local h = (2852568992 - (-705653)) % 14125122
local x = -520525 - ((803364 + -890259) + -433642)
local F = false
local j = false
local U = false
local n = false
local w = "Nombre falso"
local N = "Cabeza"
local e = false
local p = nil
local u = nil
local C = {}
local I = Instance["new"]("ScreenGui")
I["Name"] = "OnyxHub_Overlays"
I["ResetOnSpawn"] = false
I["IgnoreGuiInset"] = true
I["DisplayOrder"] = 999
I["Parent"] = E:WaitForChild("PlayerGui")
local Z = Instance["new"]("Folder")
Z["Name"] = "OnyxESPFolder"
Z["Parent"] = I
local function m(q, o)
    local s, A, z, b
    q["InputBegan"]:Connect(
        function(q)
            if
                q["UserInputType"] == Enum["UserInputType"]["MouseButton1"] or
                    q["UserInputType"] == Enum["UserInputType"]["Touch"]
             then
                s = true
                z = q["Position"]
                b = o["Position"]
                q["Changed"]:Connect(
                    function()
                        if q["UserInputState"] == Enum["UserInputState"]["End"] then
                            s = false
                        end
                    end
                )
            end
        end
    )
    q["InputChanged"]:Connect(
        function(q)
            if
                q["UserInputType"] == Enum["UserInputType"]["MouseMovement"] or
                    q["UserInputType"] == Enum["UserInputType"]["Touch"]
             then
                A = q
            end
        end
    )
    R["InputChanged"]:Connect(
        function(q)
            if q == A and s then
                local R = q["Position"] - z
                o["Position"] =
                    UDim2["new"](b["X"]["Scale"], b["X"]["Offset"] + R["X"], b["Y"]["Scale"], b["Y"]["Offset"] + R["Y"])
            end
        end
    )
end
local q9 = "1.6.66"
local o9 =
    (loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/download/" .. (q9 .. "/main.lua"))))()
if not o9 then
    warn("Error al cargar WindUI. Revisa el enlace de GitHub o tu conexiÃ³n.")
    return
end
local R9 =
    o9:CreateWindow(
    {
        ["Title"] = "Astra<font color='#FF6347'>HUB</font> | DUELS",
        ["Theme"] = "Red",
        ["Background"] = "rbxassetid://79848056200179",
        ["Author"] = "by Yisushub,Fabnx1 and Matzz",
        ["Icon"] = "rbxassetid://71399142562360",
        ["Folder"] = "AstraHub_WindUI",
        ["Acrylic"] = false,
        ["Transparent"] = false,
        ["NewElements"] = false,
        ["HideSearchBar"] = true,
        ["OpenButton"] = {
            ["Title"] = "Open AstraHub",
            ["Icon"] = "rbxassetid://71399142562360",
            ["CornerRadius"] = UDim["new"](
                ((1482936371 % ((683731 + (383601 + 91921053463 % 419737745)) % 13613172) + -817230) - (-354543)) -
                    451084,
                (1685405312 - 228700) % (3598761313 % 14026901)
            ),
            ["StrokeThickness"] = 1.1,
            ["Enabled"] = true,
            ["Draggable"] = true,
            ["Scale"] = .8,
            ["Color"] = ColorSequence["new"](Color3["fromRGB"]((890901 + 187548168) % 8193003, 0, -63051 + 63051))
        },
        ["Topbar"] = {["Height"] = 44, ["ButtonsType"] = "Default"}
    }
)
local s9 = Instance["new"]("Frame")
s9["Name"] = "AstraMinimalNotifs"
s9["Size"] = UDim2["new"](214713513 % 2941281, 454592 - (723371 - 269079), 0.5, (930873131 - 184003) % 3943598)
s9["AnchorPoint"] = Vector2["new"](-1724947, (-6357 - 570174) + 576532)
s9["Position"] =
    UDim2["new"](
    937559 + -937558,
    (-148861 - (-896843)) - 748002,
    -775150 - (-775151),
    -923960 + ((324121 + -1137780) + 1737599)
)
s9["BackgroundTransparency"] = 1
s9["Parent"] = I
local A9 = Instance["new"]("UIListLayout", s9)
A9["VerticalAlignment"] = Enum["VerticalAlignment"]["Bottom"]
A9["HorizontalAlignment"] = Enum["HorizontalAlignment"]["Right"]
A9["SortOrder"] = Enum["SortOrder"]["LayoutOrder"]
A9["Padding"] = UDim["new"](1052142728 % 6535048, -1009750 + 1009758)
local function z9(q)
    task["spawn"](
        function()
            local o = Instance["new"]("Frame")
            o["AutomaticSize"] = Enum["AutomaticSize"]["X"]
            o["Size"] =
                UDim2["new"]((544697 + 434853) - 979550, (944088 + -1884610) + 940522, 0, 84378 + (730871 + -815221))
            o["BackgroundColor3"] = Color3["fromRGB"](2125760020 % 10220000, 21, 2626113040 % 11174949)
            o["BackgroundTransparency"] = 1
            o["ClipsDescendants"] = true
            o["Parent"] = s9
            ;(Instance["new"]("UICorner", o))["CornerRadius"] =
                UDim["new"](
                221447 - 221447,
                (8865681218 % (28917752880 % (87032 + 125098783)) - (-550460 + 21125945) % 1577881) % 1205664
            )
            local R = Instance["new"]("UIPadding", o)
            R["PaddingLeft"] = UDim["new"](-699750 - (-699750), (46904735334 % 212260281) % 3639886)
            R["PaddingRight"] = UDim["new"](580240 - 580240, 390477 + (-1008289 - (-617824)))
            local s = Instance["new"]("UIStroke", o)
            s["Color"] = Color3["fromRGB"](793867 - ((511932 - (-116005)) + 165730), 200, 578735840 % 3444855)
            s["Thickness"] = (130053442478 % (525438 + 1056865093)) % 16181503
            s["Transparency"] = 1
            local A = Instance["new"]("TextLabel", o)
            A["AutomaticSize"] = Enum["AutomaticSize"]["X"]
            A["Size"] =
                UDim2["new"](
                839360720 % 7630552,
                0,
                (-553820 - ((-1072278 - (-479347)) + -191496)) + ((-19126 + -1023126) - (-811646)),
                ((719266 + 758397265) - 406952) % 4238601
            )
            A["BackgroundTransparency"] = 1
            A["Text"] = q
            A["TextColor3"] = Color3["fromRGB"](-323690 - (-323930), 240, 184930265 % 5283715)
            A["Font"] = Enum["Font"]["GothamMedium"]
            A["TextSize"] = -1050484595 % ((-160392 + 3656454087) % 15724512)
            A["TextTransparency"] = (698447 + -160541) + (((-923616 + 1705197) + -1554112) + 234626)
            local z = game:GetService("TweenService")
            ;(z:Create(
                o,
                TweenInfo["new"](
                    1038470906.5 % 4615426.25,
                    Enum["EasingStyle"]["Quint"],
                    Enum["EasingDirection"]["Out"]
                ),
                {["BackgroundTransparency"] = .15}
            )):Play()
            ;(z:Create(s, TweenInfo["new"](629063 + -629062.75), {["Transparency"] = 0.5})):Play()
            ;(z:Create(A, TweenInfo["new"](553567.25 - 553567), {["TextTransparency"] = -589092 - (-589092)})):Play()
            task["wait"](((263151489.0 - 8020) - 189966127 % 1252219) % 15427200.5)
            local b =
                z:Create(
                o,
                TweenInfo["new"](.3, Enum["EasingStyle"]["Quad"], Enum["EasingDirection"]["In"]),
                {["BackgroundTransparency"] = 1}
            )
            ;(z:Create(s, TweenInfo["new"](.3), {["Transparency"] = 1})):Play()
            ;(z:Create(A, TweenInfo["new"](.3), {["TextTransparency"] = 1})):Play()
            b:Play()
            b["Completed"]:Wait()
            o:Destroy()
        end
    )
end
local b9 = R9:Section({["Title"] = "Funciones Principales", ["Opened"] = true})
local P9 = R9:Section({["Title"] = "Configs & Extra", ["Opened"] = true})
local J9 = {
    ["Inicio"] = b9:Tab({["Title"] = "Discord", ["Icon"] = "solar:home-bold"}),
    ["Aim"] = b9:Tab({["Title"] = "Aimbot", ["Icon"] = "solar:target-bold"}),
    ["KillAll"] = b9:Tab({["Title"] = "Kill All", ["Icon"] = "solar:fire-bold"}),
    ["Farm"] = b9:Tab({["Title"] = "Farm", ["Icon"] = "lucide:swords"}),
    ["Vis"] = b9:Tab({["Title"] = "Visuales", ["Icon"] = "solar:eye-bold"}),
    ["Graficos"] = b9:Tab({["Title"] = "GrÃ¡ficos", ["Icon"] = "solar:palette-bold"}),
    ["Emotes"] = P9:Tab({["Title"] = "Animaciones", ["Icon"] = "solar:smile-circle-bold"}),
    ["Config"] = P9:Tab({["Title"] = "ConfiguraciÃ³n", ["Icon"] = "solar:settings-bold"})
}
J9["Inicio"]:Section({["Title"] = "Registro de Actualizaciones"})
local W9 = "18 de Agosto 2026"
local E9 = {"Apartado de Auto Farm, kill all"}
local L9 = {"Kill all,Auto farm,Hitbox,Macro"}
local T9 = {}
if #E9 > -333380 - (-333380) then
    table["insert"](T9, "<font color='#00ff80'><b>Nuevo:</b></font>")
    for q, o in ipairs(E9) do
        table["insert"](T9, "<font color='#00ff80'>+ " .. (o .. "</font>"))
    end
    if #L9 > -956358 + (3206534790 % (830236 + 13103939) - 718182) then
        table["insert"](T9, "")
    end
end
if #L9 > 0 then
    table["insert"](T9, "<font color='#f1c40f'><b>Arreglos:</b></font>")
    for q, o in ipairs(L9) do
        table["insert"](T9, "<font color='#f1c40f'>~ " .. (o .. "</font>"))
    end
end
local X9 = table["concat"](T9, "\n")
J9["Inicio"]:Paragraph({["Title"] = "Ãltima actualizaciÃ³n: " .. W9, ["Desc"] = X9})
J9["Inicio"]:Paragraph(
    {
        ["Title"] = "Ãnete a nuestro Discord",
        ["Desc"] = "Ãnete a nuestra comunidad oficial para soporte, actualizaciones y hablar con otros miembros.\n\ndiscord.com/invite/BQQey3cKP",
        ["Image"] = "rbxassetid://88267176037146",
        ["ImageSize"] = 80
    }
)
J9["Inicio"]:Button(
    {
        ["Title"] = "Copiar enlace de Discord",
        ["Callback"] = function()
            pcall(
                function()
                    setclipboard("discord.com/invite/BQQey3cKP")
                end
            )
            z9("Â¡Link de Discord copiado al portapapeles!")
        end
    }
)
J9["KillAll"]:Section({["Title"] = "Opciones de AniquilaciÃ³n"})
J9["KillAll"]:Toggle(
    {["Title"] = "Activar Kill All", ["Value"] = false, ["Callback"] = function(q)
            e = q
            if q then
                z9("Kill All: ACTIVADO")
                ejecutarBucleKillAll()
            else
                z9("Kill All: DESACTIVADO")
                p = nil
            end
        end}
)
local c9 = identifyexecutor and identifyexecutor() or "Desconocido"
J9["Inicio"]:Paragraph({["Title"] = "Ejecutor", ["Desc"] = "" .. tostring(c9)})
J9["Inicio"]:Section({["Title"] = "InformaciÃ³n del Servidor"})
local G9 = "Desconocido"
pcall(
    function()
        G9 = (z:GetProductInfo(game["PlaceId"]))["Name"]
    end
)
J9["Inicio"]:Paragraph(
    {
        ["Title"] = "Juego Actual",
        ["Desc"] = G9 .. ("\nPlace ID: " .. game["PlaceId"]),
        ["Image"] = "rbxthumb://type=GameIcon&id=" .. (game["GameId"] .. "&w=150&h=150"),
        ["ImageSize"] = 48
    }
)
J9["Inicio"]:Section({["Title"] = "Juegos Soportados"})
local f9 = game:GetService("TeleportService")
local function t9(q, o)
    if game["PlaceId"] == q then
        z9("Ya estÃ¡s en " .. (o .. ", buscando otro servidor..."))
        pcall(
            function()
                f9:Teleport(q, E)
            end
        )
    else
        z9("Intentando ir a " .. (o .. "..."))
        pcall(
            function()
                setclipboard("https://www.roblox.com/games/" .. tostring(q))
            end
        )
        task["wait"](59208 + (590557 + -649764.5))
        z9("Link copiado. Si no te hace TP, pÃ©galo en tu navegador para entrar.")
        pcall(
            function()
                f9:Teleport(q, E)
            end
        )
    end
end
J9["Inicio"]:Button(
    {["Title"] = "Murder Mystery 2", ["Callback"] = function()
            t9(39251930515 % 157698013, "MM2")
        end}
)
J9["Inicio"]:Button(
    {["Title"] = "Murderers VS Sheriffs (Duels)", ["Callback"] = function()
            t9(29888522751938003 % 135856921661288, "Duels")
        end}
)
J9["Inicio"]:Button(
    {
        ["Title"] = "Murder Mystery V (MMV)",
        ["Callback"] = function()
            t9(
                ((2764688460 - 284658) % 11191667 - 346011) +
                    (74369637539482 - (((76950 + 272939) + (-922226 + 455400)) - (-1038636))),
                "MMV"
            )
        end
    }
)
J9["Inicio"]:Section({["Title"] = "OptimizaciÃ³n"})
local i9 = game:GetService("Stats")
local d9 = Instance["new"]("Frame")
d9["Size"] =
    UDim2["new"](
    720419 - (659510 - (-60909)),
    1643009450 % (164340428 % (648737 + (18854260 - 285451))),
    0,
    (96993 + 2196102825) % 9590392
)
d9["Position"] =
    UDim2["new"](
    -1612345,
    266367258 % (3343161887 % ((755428 + (496239512118 % (-907210 + 2077290069) - (-453006))) % 30953784)) - 570540,
    0,
    121859650 % 902664
)
d9["BackgroundTransparency"] = 1
d9["Visible"] = false
d9["ZIndex"] = -961199 - (-961299)
d9["Parent"] = I
local K9 = Instance["new"]("TextLabel", d9)
K9["Size"] = UDim2["new"](280705 + -280704, 0, 0, ((-165279 + 337275) + -581963) - (-409992))
K9["Position"] = UDim2["new"](830257 - 1067148715 % ((999668 - 54912) + 5183511), 0, 0, 935637 + -935637)
K9["BackgroundTransparency"] = (378156 + 248386662) % 5076833
K9["Text"] = "FPS: --"
K9["TextColor3"] = Color3["fromRGB"](-308645, -422281 - (-422536), -472733 + 472988)
K9["Font"] = Enum["Font"]["GothamBlack"]
K9["TextSize"] = 16
K9["TextXAlignment"] = Enum["TextXAlignment"]["Right"]
K9["TextStrokeTransparency"] = 0
K9["TextStrokeColor3"] =
    Color3["fromRGB"](-825828 - (-825828), (328794 + -529826) - (346663 + -547695), (17619474824 % 89503464) % 5485420)
local M9 = Instance["new"]("TextLabel", d9)
M9["Size"] =
    UDim2["new"](
    73900 - 73899,
    0,
    1470978366 % (2222003288 % 22322752 - (-852479)),
    618028 + (-871085 - ((473287 + (-914192 - (-906817))) - 718994))
)
M9["Position"] = UDim2["new"](447552 - 447552, 644928 + (844616 + -1489544), 0, 358695 + -358670)
M9["BackgroundTransparency"] = (110171 + 116937) + -227107
M9["Text"] = "Ping: -- ms"
M9["TextColor3"] = Color3["fromRGB"](164019 - 163764, 255, (11424 - 455118) + (-74393 - (-518342)))
M9["Font"] = Enum["Font"]["GothamBlack"]
M9["TextSize"] = 16
M9["TextXAlignment"] = Enum["TextXAlignment"]["Right"]
M9["TextStrokeTransparency"] = 0
M9["TextStrokeColor3"] = Color3["fromRGB"](520403779 % 14064967, 0, (78928349007 % (9884998937 % 353509204)) % 9180553)
local V9 = false
J9["Inicio"]:Toggle(
    {["Title"] = "Mostrar FPS y Ping", ["Callback"] = function(q)
            V9 = q
            d9["Visible"] = q
        end}
)
local Q9 = 0
local a9 = tick()
o["RenderStepped"]:Connect(
    function()
        if not V9 then
            return
        end
        Q9 = Q9 + 362728990 % (3408866559 % 18009300)
        if tick() - a9 >= 1 then
            K9["Text"] = "FPS: " .. Q9
            if Q9 >= 50 then
                K9["TextColor3"] =
                    Color3["fromRGB"](
                    (-708953 + (117860787 - 143696)) % 495797,
                    204,
                    (52051682895 % 1001006098) % 4185656
                )
            elseif Q9 >= 30 then
                K9["TextColor3"] = Color3["fromRGB"](40672 + -40431, 196, -527869 + 527884)
            else
                K9["TextColor3"] = Color3["fromRGB"](1447661171 % 13160554, 76, 764660 + (1009688 + -1774288))
            end
            local q = (-123806 - 81346) - (-205152)
            pcall(
                function()
                    q = math["floor"](i9["Network"]["ServerStatsItem"]["Data Ping"]:GetValue())
                end
            )
            M9["Text"] = "Ping: " .. (tostring(q) .. " ms")
            if q < 90 then
                M9["TextColor3"] = Color3["fromRGB"]((331108 + 274999) + -606061, 204, -720694 - (-720807))
            elseif q < 150 then
                M9["TextColor3"] =
                    Color3["fromRGB"](
                    931401 % (499913 + -406797),
                    -802969 - (318899 + (-109003 - 1013061)),
                    816633 + -816618
                )
            else
                M9["TextColor3"] =
                    Color3["fromRGB"](-443785 - (-444016), 1314925371 % (-294916 + 13061181), 1347217488 % 13208014)
            end
            Q9 = 0
            a9 = tick()
        end
    end
)
local y9 = false
local k9 = nil
local r9 = true
local D9 = 344075 + (664191 + -908266)
local B9 = 1
C["ToggleFPS"] =
    J9["Graficos"]:Toggle(
    {
        ["Title"] = "FPS Boost (Elimina texturas)",
        ["Value"] = false,
        ["Callback"] = function(q)
            y9 = q
            local o = game:GetService("Lighting")
            local R = P:FindFirstChildOfClass("Terrain")
            local s = o:FindFirstChild("AstraPBRCache")
            if not s then
                s = Instance["new"]("Folder")
                s["Name"] = "AstraPBRCache"
                s["Parent"] = o
            end
            if q then
                r9 = o["GlobalShadows"]
                D9 = o["FogEnd"]
                B9 = o["ShadowSoftness"]
                o["GlobalShadows"] = false
                o["FogEnd"] = 9000000000
                o["ShadowSoftness"] = 789136 + (-514109 + -275027)
                if R then
                    pcall(
                        function()
                            if not R:GetAttribute("OrigWaveSize") then
                                R:SetAttribute("OrigWaveSize", R["WaterWaveSize"])
                                R:SetAttribute("OrigDeco", R["Decoration"])
                            end
                            R["WaterWaveSize"] = 0
                            R["WaterWaveSpeed"] = 0
                            R["WaterReflectance"] = -729610 - (-729610)
                            R["WaterTransparency"] =
                                2288144897 % ((260289 - ((65706719111 % 1825309604) % 10110364 + -1100959)) + 10499397) -
                                230962
                            R["Decoration"] = false
                        end
                    )
                end
                local function q(q)
                    if
                        not q:IsA("BasePart") and
                            (not q:IsA("Decal") and
                                (not q:IsA("Texture") and
                                    (not q:IsA("SpecialMesh") and
                                        (not q:IsA("Light") and
                                            (not q:IsA("PostEffect") and
                                                (not q:IsA("SurfaceAppearance") and not q:IsA("Clothing")))))))
                     then
                        return
                    end
                    pcall(
                        function()
                            if q:IsA("ScreenGui") then
                                return
                            end
                            if q["Parent"] and q["Parent"]:FindFirstChild("Humanoid") then
                                return
                            end
                            if q:IsA("BasePart") and not q:IsA("Terrain") then
                                if not q:GetAttribute("OrigMat") then
                                    q:SetAttribute("OrigMat", q["Material"]["Name"])
                                    q:SetAttribute("OrigCast", q["CastShadow"])
                                end
                                q["Material"] = Enum["Material"]["SmoothPlastic"]
                                q["Reflectance"] = (1314523 - 284913) - 1029610
                                q["CastShadow"] = false
                                if q:IsA("MeshPart") then
                                    if not q:GetAttribute("OrigTex") then
                                        q:SetAttribute("OrigTex", q["TextureID"])
                                    end
                                    q["TextureID"] = ""
                                end
                            elseif q:IsA("SpecialMesh") then
                                if not q:GetAttribute("OrigTex") then
                                    q:SetAttribute("OrigTex", q["TextureId"])
                                end
                                q["TextureId"] = ""
                            elseif q:IsA("SurfaceAppearance") or q:IsA("BaseWrap") or q:IsA("Clothing") then
                                if not q:GetAttribute("OrigParent") then
                                    q:SetAttribute("OrigParent", q["Parent"])
                                end
                                q["Parent"] = s
                            elseif q:IsA("Decal") or q:IsA("Texture") then
                                if not q:GetAttribute("OrigTrans") then
                                    q:SetAttribute("OrigTrans", q["Transparency"])
                                end
                                q["Transparency"] = 1
                            elseif q:IsA("Light") or q:IsA("PostEffect") then
                                if q:GetAttribute("OrigEnabled") == nil then
                                    q:SetAttribute("OrigEnabled", q["Enabled"])
                                end
                                q["Enabled"] = false
                            end
                        end
                    )
                end
                task["spawn"](
                    function()
                        local o = (-283922 + 402315) - 118393
                        for R, s in pairs(P:GetDescendants()) do
                            q(s)
                            o = o + ((513469 - (-43760)) - 557228)
                            if
                                o % (2650391676 % 14249416) ==
                                    332877109 % (((816549 + -1835512) + 3809368530) % 19878906)
                             then
                                task["wait"]()
                            end
                        end
                    end
                )
                if not k9 then
                    k9 =
                        P["DescendantAdded"]:Connect(
                        function(o)
                            if y9 then
                                q(o)
                            end
                        end
                    )
                end
                z9("FPS Boost Aplicando...")
            else
                o["GlobalShadows"] = r9
                o["FogEnd"] = D9
                o["ShadowSoftness"] = B9
                if R and R:GetAttribute("OrigWaveSize") then
                    pcall(
                        function()
                            R["WaterWaveSize"] = R:GetAttribute("OrigWaveSize")
                            R["Decoration"] = R:GetAttribute("OrigDeco")
                        end
                    )
                end
                task["spawn"](
                    function()
                        local q = 0
                        for o, R in pairs(P:GetDescendants()) do
                            pcall(
                                function()
                                    if R:IsA("BasePart") and R:GetAttribute("OrigMat") then
                                        local q = R:GetAttribute("OrigMat")
                                        if Enum["Material"][q] then
                                            R["Material"] = Enum["Material"][q]
                                        end
                                        R["CastShadow"] = R:GetAttribute("OrigCast")
                                        if R:IsA("MeshPart") and R:GetAttribute("OrigTex") then
                                            R["TextureID"] = R:GetAttribute("OrigTex")
                                        end
                                    elseif R:IsA("SpecialMesh") and R:GetAttribute("OrigTex") then
                                        R["TextureId"] = R:GetAttribute("OrigTex")
                                    elseif (R:IsA("Decal") or R:IsA("Texture")) and R:GetAttribute("OrigTrans") then
                                        R["Transparency"] = R:GetAttribute("OrigTrans")
                                    elseif
                                        (R:IsA("Light") or R:IsA("PostEffect")) and R:GetAttribute("OrigEnabled") ~= nil
                                     then
                                        R["Enabled"] = R:GetAttribute("OrigEnabled")
                                    end
                                end
                            )
                            q = q + (-421386 - (-421387))
                            if q % (636690731 % 3767399) == ((52836503758688 % 279558240199) % 1264996479) % 14429608 then
                                task["wait"]()
                            end
                        end
                        for q, o in pairs(s:GetChildren()) do
                            pcall(
                                function()
                                    if o:GetAttribute("OrigParent") then
                                        o["Parent"] = o:GetAttribute("OrigParent")
                                    end
                                end
                            )
                        end
                    end
                )
                if k9 then
                    k9:Disconnect()
                    k9 = nil
                end
                z9("GrÃ¡ficos normales restaurados.")
            end
        end
    }
)
J9["Inicio"]:Button(
    {
        ["Title"] = "Cambiar de Servidor",
        ["Callback"] = function()
            z9("Buscando servidor vacÃ­o...")
            local q = game:GetService("TeleportService")
            local o =
                "https://games.roblox.com/v1/games/" .. (game["PlaceId"] .. "/servers/Public?sortOrder=Asc&limit=100")
            task["spawn"](
                function()
                    local R, s =
                        pcall(
                        function()
                            local R = request or http_request or (syn and syn["request"])
                            if R then
                                local s = R({["Url"] = o, ["Method"] = "GET"})
                                if s["StatusCode"] == 200 then
                                    local o = b:JSONDecode(s["Body"])
                                    local R = {}
                                    if o and o["data"] then
                                        for q, o in pairs(o["data"]) do
                                            if o["playing"] < o["maxPlayers"] and o["id"] ~= game["JobId"] then
                                                table["insert"](R, o["id"])
                                            end
                                        end
                                    end
                                    if #R > -113684 - (-349775 - (-236091)) then
                                        local o = R[math["random"](-748331, #R)]
                                        z9("Â¡Servidor encontrado!...")
                                        q:TeleportToPlaceInstance(game["PlaceId"], o, E)
                                    else
                                        z9("No hay servidores vacÃ­os disponibles.")
                                    end
                                else
                                    z9("Error de conexiÃ³n con el Proxy.")
                                end
                            else
                                z9("Tu ejecutor no soporta HTTP Requests.")
                            end
                        end
                    )
                    if not R then
                        warn("Error en Server Hop:", s)
                    end
                end
            )
        end
    }
)
local v9 = false
local S9 = .04
local H9 = .1
J9["Aim"]:Section({["Title"] = "Macro (Pistola)"})
C["TogMacro"] =
    J9["Aim"]:Toggle(
    {["Title"] = "Activar Macro", ["Desc"] = "Dispara con un solo toque.", ["Callback"] = function(q)
            v9 = q
        end}
)
C["SliMacroEquip"] =
    J9["Aim"]:Slider(
    {
        ["Title"] = "Delay al Equipar",
        ["Desc"] = "Sube esto si la pistola no alcanza a salir. (Segundos)",
        ["Step"] = .01,
        ["Value"] = {["Min"] = .01, ["Max"] = 0.5, ["Default"] = .04},
        ["Callback"] = function(q)
            S9 = q
        end
    }
)
C["SliMacroShoot"] =
    J9["Aim"]:Slider(
    {
        ["Title"] = "Delay de Disparo",
        ["Desc"] = "Sube esto si el tiro no cuenta daÃ±o. (Segundos)",
        ["Step"] = .01,
        ["Value"] = {["Min"] = .05, ["Max"] = .8, ["Default"] = .1},
        ["Callback"] = function(q)
            H9 = q
        end
    }
)
local l9 = Instance["new"]("Frame")
l9["Size"] = UDim2["new"](344189 - 344189, 150, -780123 - (-780123), 304106 - 303956)
l9["Position"] = UDim2["new"](.8, -75, .8, -673584 - (-673509))
l9["BackgroundColor3"] = Color3["fromRGB"](((-275602 + -134635) + -277123) - (-687615), 50, 2094045746 % 9694656)
l9["BackgroundTransparency"] = 0.5
l9["Visible"] = false
l9["ZIndex"] = 100
l9["Parent"] = I
;(Instance["new"]("UICorner", l9))["CornerRadius"] = UDim["new"](310396800 % 1478080, -186273 - (-186289))
local Y9 = Instance["new"]("UIStroke", l9)
Y9["Color"] = Color3["fromRGB"](-1396099, 255, -30047 - (-30302))
Y9["Thickness"] = -342594 - (-342596)
Y9["LineJoinMode"] = Enum["LineJoinMode"]["Round"]
local O9 = Instance["new"]("TextLabel", l9)
O9["Size"] = UDim2["new"](861049 + (-860086 - 962), 0, 1, 687636510 % 6251241)
O9["BackgroundTransparency"] = 1
O9["Text"] = "ZONA MUERTA\n(Arrastrar)"
O9["TextColor3"] = Color3["fromRGB"](406421 - (650922 + -244756), 255, -976735 + (36442 + 71388543 % 2609185))
O9["Font"] = Enum["Font"]["GothamBold"]
O9["TextSize"] = 14
O9["TextWrapped"] = true
m(l9, l9)
C["TogDeadZone"] =
    J9["Aim"]:Toggle(
    {["Title"] = "Mostrar/Acomodar Zona Muerta", ["Callback"] = function(q)
            l9["Visible"] = q
        end}
)
C["SliDeadZone"] =
    J9["Aim"]:Slider(
    {
        ["Title"] = "TamaÃ±o de Zona Muerta",
        ["Step"] = 10,
        ["Value"] = {["Min"] = 80, ["Max"] = 400, ["Default"] = 150},
        ["Callback"] = function(q)
            l9["Size"] = UDim2["new"](984317 + -984317, q, 0, q)
        end
    }
)
local function g9(q)
    if not q:IsA("Tool") then
        return false
    end
    if q:FindFirstChild("Throw", true) or q:FindFirstChild("KnifeClient", true) or q:FindFirstChild("KnifeServer", true) then
        return false
    end
    local o = string["lower"](q["Name"])
    local R = {
        "combat",
        "fist",
        "wallet",
        "phone",
        "punch",
        "boombox",
        "radio",
        "knife",
        "blade",
        "cuchillo",
        "dagger",
        "kunai",
        "sword",
        "toy",
        "juguete",
        "pizza",
        "burger",
        "teddy",
        "balloon",
        "drink",
        "food"
    }
    for q, R in ipairs(R) do
        if string["find"](o, R) then
            return false
        end
    end
    return true
end
local function h9()
    local q = E["Character"]
    local o = E:FindFirstChild("Backpack")
    if q then
        for q, o in ipairs(q:GetChildren()) do
            if g9(o) then
                return o
            end
        end
    end
    if o then
        for q, o in ipairs(o:GetChildren()) do
            if g9(o) then
                return o
            end
        end
    end
    return nil
end
local x9 = {
    {["Centro"] = Vector3["new"](-971385.5, 280.82, -981788.0 - (-981804)), ["Radio"] = 500},
    {["Centro"] = Vector3["new"](1564.14, -155.45, 40.04), ["Radio"] = 300}
}
local function F9()
    local q = E["Character"]
    if not q then
        return true
    end
    if q:FindFirstChildOfClass("ForceField") then
        return true
    end
    if E["Team"] then
        local q = string["lower"](E["Team"]["Name"])
        if
            string["find"](q, "lobby") or string["find"](q, "spectat") or string["find"](q, "espectador") or
                string["find"](q, "menu") or
                string["find"](q, "dead")
         then
            return true
        end
    end
    local o = q:FindFirstChild("HumanoidRootPart")
    if o then
        for q, R in ipairs(x9) do
            local s = (o["Position"] - R["Centro"])["Magnitude"]
            if s <= R["Radio"] then
                return true
            end
        end
    end
    return false
end
local function j9()
    if F9() then
        return
    end
    local o = false
    for q, R in pairs(q:GetPlayers()) do
        if R ~= E then
            local q = R["Character"]
            if q and (q:FindFirstChild("Humanoid") and q["Humanoid"]["Health"] > -357081 + 357081) then
                if E["Team"] == nil or R["Team"] == nil or E["Team"] ~= R["Team"] then
                    o = true
                    break
                end
            end
        end
    end
    if not o then
        return
    end
    local R = E["Character"]
    if not R then
        return
    end
    local s = R:FindFirstChild("Humanoid")
    if not s then
        return
    end
    local A = R:FindFirstChildOfClass("Tool")
    if A and not g9(A) then
        return
    end
    local z = h9()
    if not z then
        return
    end
    task["spawn"](
        function()
            s:UnequipTools()
            task["wait"]()
            s:EquipTool(z)
            task["wait"](S9)
            if z["Parent"] == R then
                z:Activate()
                task["wait"](H9)
                z:Deactivate()
                s:UnequipTools()
            end
        end
    )
end
local U9 = {}
R["InputChanged"]:Connect(
    function(q, o)
        if q["UserInputType"] == Enum["UserInputType"]["Touch"] and U9[q] then
            if (U9[q]["posicion"] - q["Position"])["Magnitude"] > 10 then
                U9 = {}
            end
        end
    end
)
R["InputBegan"]:Connect(
    function(q, o)
        if o or not v9 then
            return
        end
        if q["UserInputType"] == Enum["UserInputType"]["MouseButton1"] then
            j9()
        elseif q["UserInputType"] == Enum["UserInputType"]["Touch"] then
            local o = q["Position"]
            local R = l9["AbsolutePosition"]
            local s = l9["AbsoluteSize"]
            local A =
                (o["X"] >= R["X"]) and
                ((o["X"] <= R["X"] + s["X"]) and ((o["Y"] >= R["Y"]) and (o["Y"] <= R["Y"] + s["Y"])))
            if not A then
                U9[q] = {["posicion"] = q["Position"], ["tiempo"] = tick()}
            end
        end
    end
)
R["InputEnded"]:Connect(
    function(q, o)
        if not v9 then
            return
        end
        if q["UserInputType"] == Enum["UserInputType"]["Touch"] and U9[q] then
            local o = U9[q]
            local R = q["Position"]
            local s = (o["posicion"] - R)["Magnitude"]
            local A = tick() - o["tiempo"]
            U9[q] = nil
            if s < 10 and (A < .35 and A > .03) then
                j9()
            end
        end
    end
)
local n9 = {}
local function w9()
    n9 = {}
end
local function N9(q)
    n9[q] = nil
end
(E:GetPropertyChangedSignal("Team")):Connect(w9)
;(E:GetPropertyChangedSignal("TeamColor")):Connect(w9)
;(E:GetAttributeChangedSignal("Team")):Connect(w9)
local function e9(q)
    (q:GetPropertyChangedSignal("Team")):Connect(
        function()
            N9(q)
        end
    )
    ;(q:GetPropertyChangedSignal("TeamColor")):Connect(
        function()
            N9(q)
        end
    )
    ;(q:GetAttributeChangedSignal("Team")):Connect(
        function()
            N9(q)
        end
    )
end
for q, o in ipairs(q:GetPlayers()) do
    if o ~= E then
        e9(o)
    end
end
q["PlayerAdded"]:Connect(
    function(q)
        e9(q)
    end
)
q["PlayerRemoving"]:Connect(
    function(q)
        N9(q)
    end
)
local function p9(q)
    if not y then
        return true
    end
    if q == E then
        return false
    end
    if n9[q] ~= nil then
        return n9[q]
    end
    local o = true
    if E["Team"] ~= nil and q["Team"] ~= nil then
        o = (E["Team"] ~= q["Team"])
    else
        local R = E:GetAttribute("Team") or E:GetAttribute("team")
        local s = q:GetAttribute("Team") or q:GetAttribute("team")
        if R ~= nil and s ~= nil then
            o = (R ~= s)
        elseif E["TeamColor"]["Name"] ~= "White" and E["TeamColor"]["Name"] ~= "Medium stone grey" then
            o = (E["TeamColor"] ~= q["TeamColor"])
        end
    end
    n9[q] = o
    return o
end
J9["Aim"]:Section({["Title"] = "Auto Shoot"})
local u9 = "Cabeza"
C["TogAutoShoot"] =
    J9["Aim"]:Toggle(
    {
        ["Title"] = "Auto Shoot",
        ["Desc"] = "Dispara automÃ¡ticamente a la parte del cuerpo seleccionada.",
        ["Value"] = false,
        ["Callback"] = function(q)
            task["spawn"](
                function()
                    d = q
                    z9(q and "Auto Shoot: ACTIVADO" or "Auto Shoot: DESACTIVADO")
                    if not q then
                        pcall(
                            function()
                                (getgenv())["AstraTargetPart"] = nil
                            end
                        )
                    end
                end
            )
        end
    }
)
local C9 = false
C["TogAutoShootCuchillo"] =
    J9["Aim"]:Toggle(
    {
        ["Title"] = "Auto Shoot (Cuchillo)",
        ["Desc"] = "Ataca o lanza el cuchillo automÃ¡ticamente.",
        ["Value"] = false,
        ["Callback"] = function(q)
            C9 = q
        end
    }
)
local I9 = false
C["DropAutoShootPart"] =
    J9["Aim"]:Dropdown(
    {
        ["Title"] = "Target: Parte del cuerpo (Auto Shoot)",
        ["Values"] = {"Cabeza", "Torso", "Cuerpo Completo"},
        ["Value"] = "Cabeza",
        ["Callback"] = function(q)
            u9 = q
            if I9 then
                z9("AutoShoot Target: " .. q)
            end
            I9 = true
        end
    }
)
local Z9 = false
local m9 = false
local qK = "Cabeza"
local oK = false
C["TogSilentAimManual"] =
    J9["Aim"]:Toggle(
    {
        ["Title"] = "Silent Aim",
        ["Desc"] = "Redirige las balas al enemigo.",
        ["Value"] = false,
        ["Callback"] = function(q)
            task["spawn"](
                function()
                    m9 = q
                    z9(q and "Silent Aim: ACTIVADO" or "Silent: DESACTIVADO")
                    if not q and (not d and not autoShootAgresivoEnabled) then
                        pcall(
                            function()
                                (getgenv())["AstraTargetPart"] = nil
                            end
                        )
                    end
                end
            )
        end
    }
)
local RK = false
C["DropSilentAimPart"] =
    J9["Aim"]:Dropdown(
    {
        ["Title"] = "Target: Parte del cuerpo",
        ["Values"] = {"Cabeza", "Torso", "Cuerpo Completo"},
        ["Value"] = "Cabeza",
        ["Callback"] = function(q)
            qK = q
            if RK then
                z9("Apuntando a: " .. q)
            end
            RK = true
        end
    }
)
C["TogSilentAimFOV"] =
    J9["Aim"]:Toggle(
    {
        ["Title"] = "Silent Aim (Con FOV)",
        ["Desc"] = "Igual que el Silent Aim, pero solo afecta a los enemigos dentro del cÃ­rculo.",
        ["Value"] = false,
        ["Callback"] = function(q)
            task["spawn"](
                function()
                    oK = q
                    z9(q and "Silent Aim FOV: ACTIVADO" or "Silent FOV: DESACTIVADO")
                    if not q and (not m9 and (not d and not autoShootAgresivoEnabled)) then
                        pcall(
                            function()
                                (getgenv())["AstraTargetPart"] = nil
                            end
                        )
                    end
                end
            )
        end
    }
)
C["TogShowFOV"] =
    J9["Aim"]:Toggle(
    {
        ["Title"] = "Mostrar CÃ­rculo FOV",
        ["Desc"] = "Dibuja un cÃ­rculo en pantalla para que sepas dÃ³nde funciona tu Silent Aim.",
        ["Value"] = false,
        ["Callback"] = function(q)
            X = q
        end
    }
)
C["SliFOVSize"] =
    J9["Aim"]:Slider(
    {
        ["Title"] = "TamaÃ±o del FOV",
        ["Step"] = 1,
        ["Value"] = {
            ["Min"] = 10,
            ["Max"] = -2429566210 % (11868243 - (-758864 - (874561 - 1042350))),
            ["Default"] = 120
        },
        ["Callback"] = function(q)
            c = q
        end
    }
)
pcall(
    function()
        (getgenv())["AstraTargetPart"] = nil
    end
)
local sK
sK =
    hookmetamethod(
    game,
    "__namecall",
    function(q, ...)
        local o = getnamecallmethod()
        if not checkcaller() and (getgenv())["AstraTargetPart"] then
            local R = (getgenv())["AstraTargetPart"]
            local s = P["CurrentCamera"]["CFrame"]["Position"]
            if R and R["Parent"] then
                if o == "Raycast" and q == P then
                    local o, A, z = ...
                    if (o - s)["Magnitude"] < 1 then
                        return sK(q, ...)
                    end
                    if typeof(A) == "Vector3" and A["Magnitude"] > (-1515302 - (-726896)) + (1022496 - 234085) then
                        local s = (R["Position"] - o)["Unit"] * (769562 - (928890 - 164328))
                        return sK(q, o, s, z)
                    end
                elseif string["find"](o, "FindPartOnRay") and q == P then
                    local o, A, z, b = ...
                    if (o["Origin"] - s)["Magnitude"] < 1 then
                        return sK(q, ...)
                    end
                    if typeof(o) == "Ray" and o["Direction"]["Magnitude"] > (173366 + 234770) + -408131 then
                        local s =
                            Ray["new"](o["Origin"], (R["Position"] - o["Origin"])["Unit"] * (1371111028 % 5619287))
                        return sK(q, s, A, z, b)
                    end
                end
            else
                (getgenv())["AstraTargetPart"] = nil
            end
        end
        return sK(q, ...)
    end
)
local AK
AK =
    hookmetamethod(
    game,
    "__index",
    function(q, o)
        if not checkcaller() and (q == T and (getgenv())["AstraTargetPart"]) then
            if o == "Hit" or o == "hit" then
                return (getgenv())["AstraTargetPart"]["CFrame"]
            elseif o == "Target" or o == "target" then
                return (getgenv())["AstraTargetPart"]
            end
        end
        return AK(q, o)
    end
)
task["spawn"](
    function()
        local o = RaycastParams["new"]()
        o["FilterType"] = Enum["RaycastFilterType"]["Exclude"]
        while task["wait"](.1) do
            if (d or C9) and not F9() then
                local R = E["Character"]
                if not R or not R:FindFirstChild("HumanoidRootPart") then
                    continue
                end
                local s = R:FindFirstChildOfClass("Tool")
                if not s or not s:FindFirstChild("Handle") then
                    (getgenv())["AstraTargetPart"] = nil
                    continue
                end
                local A = g9(s)
                if A and not d then
                    (getgenv())["AstraTargetPart"] = nil
                    continue
                elseif not A and not C9 then
                    (getgenv())["AstraTargetPart"] = nil
                    continue
                end
                local z = R["HumanoidRootPart"]["Position"]
                local b = R:FindFirstChild("Head") and R["Head"]["Position"] or z
                local J = {}
                local W = q:GetChildren()
                for q = 1, #W, ((-1939032 - (-939899)) + 394367) - (-604767) do
                    local o = W[q]
                    if o:IsA("Player") and (o ~= E and (p9(o) and o["Character"])) then
                        local q = o["Character"]:FindFirstChild("Humanoid")
                        if q and q["Health"] > 452857251 % (-1008204 + 2968625) then
                            local q = {}
                            if u9 == "Cabeza" then
                                q = {"Head"}
                            elseif u9 == "Torso" then
                                q = {"UpperTorso", "Torso", "HumanoidRootPart"}
                            elseif u9 == "Cuerpo Completo" then
                                q = {
                                    "Head",
                                    "UpperTorso",
                                    "LowerTorso",
                                    "Torso",
                                    "LeftArm",
                                    "RightArm",
                                    "LeftLeg",
                                    "RightLeg",
                                    "LeftUpperArm",
                                    "RightUpperArm",
                                    "LeftUpperLeg",
                                    "RightUpperLeg"
                                }
                            end
                            for q, R in ipairs(q) do
                                local s = o["Character"]:FindFirstChild(R)
                                if s and s:IsA("BasePart") then
                                    table["insert"](
                                        J,
                                        {
                                            ["Part"] = s,
                                            ["Dist"] = (s["Position"] - z)["Magnitude"],
                                            ["Char"] = o["Character"]
                                        }
                                    )
                                end
                            end
                        end
                    end
                end
                table["sort"](
                    J,
                    function(q, o)
                        return q["Dist"] < o["Dist"]
                    end
                )
                local L = nil
                for q, s in ipairs(J) do
                    local A = s["Part"]
                    o["FilterDescendantsInstances"] = {R, s["Char"]}
                    local z, J = A["Size"]["X"] / 2.1, A["Size"]["Y"] / 2.1
                    local W = A["CFrame"]
                    local E = not P:Raycast(b, W["Position"] - b, o)
                    if not E then
                        E =
                            not P:Raycast(
                            b,
                            (W * CFrame["new"](z, -758939 - (-758939), 60434927 % 297709))["Position"] - b,
                            o
                        )
                    end
                    if not E then
                        E = not P:Raycast(b, (W * CFrame["new"](-z, 0, 177700 + -177700))["Position"] - b, o)
                    end
                    if not E then
                        E =
                            not P:Raycast(
                            b,
                            (W *
                                CFrame["new"](
                                    2569576035 % ((-176585 + 4623792766) % 24523611),
                                    J,
                                    (108882974165 % (42917409891 % (41829264983 % (-101846 + 589257297) - 352517))) %
                                        2437747
                                ))["Position"] - b,
                            o
                        )
                    end
                    if not E then
                        E =
                            not P:Raycast(
                            b,
                            (W * CFrame["new"](282168 - 282168, -J, 155989 + -155989))["Position"] - b,
                            o
                        )
                    end
                    if E then
                        L = A
                        break
                    end
                end
                if L then
                    (getgenv())["AstraTargetPart"] = L
                    pcall(
                        function()
                            s:Activate()
                            task["delay"](
                                .02,
                                function()
                                    if s["Parent"] == R then
                                        s:Deactivate()
                                    end
                                end
                            )
                        end
                    )
                    task["wait"](.1)
                else
                    (getgenv())["AstraTargetPart"] = nil
                end
            end
        end
    end
)
task["spawn"](
    function()
        local o = RaycastParams["new"]()
        o["FilterType"] = Enum["RaycastFilterType"]["Exclude"]
        while task["wait"]() do
            if (m9 or oK) and not F9() then
                local R = E["Character"]
                if not R or not R:FindFirstChild("HumanoidRootPart") then
                    continue
                end
                local s = nil
                local A = math["huge"]
                local z = math["huge"]
                local b = R["HumanoidRootPart"]["Position"]
                local J = R:FindFirstChild("Head") and R["Head"]["Position"] or b
                local W = L["ViewportSize"]
                local T = Vector2["new"](W["X"] / (1033036 - 1033034), W["Y"] / (168139 + -168137))
                for q, W in ipairs(q:GetPlayers()) do
                    if W ~= E and (p9(W) and W["Character"]) then
                        local q = W["Character"]:FindFirstChild("Humanoid")
                        if q and q["Health"] > (-114405 - 742404) - (-856809) then
                            local q = {}
                            if qK == "Cabeza" then
                                local o = W["Character"]:FindFirstChild("Head")
                                if o then
                                    table["insert"](q, o)
                                end
                            elseif qK == "Torso" then
                                local o = {"UpperTorso", "Torso", "HumanoidRootPart"}
                                for o, R in ipairs(o) do
                                    local s = W["Character"]:FindFirstChild(R)
                                    if s and s:IsA("BasePart") then
                                        table["insert"](q, s)
                                    end
                                end
                            elseif qK == "Cuerpo Completo" then
                                for o, R in ipairs(W["Character"]:GetChildren()) do
                                    if R:IsA("BasePart") and R["Name"] ~= "HumanoidRootPart" then
                                        table["insert"](q, R)
                                    end
                                end
                            end
                            o["FilterDescendantsInstances"] = {R, W["Character"]}
                            for q, R in ipairs(q) do
                                local W = (R["Position"] - b)["Magnitude"]
                                local E, X = L:WorldToViewportPoint(R["Position"])
                                local G = (Vector2["new"](E["X"], E["Y"]) - T)["Magnitude"]
                                local f = false
                                if oK then
                                    if X and (G <= c and G < A) then
                                        f = true
                                    end
                                elseif m9 then
                                    if W < z then
                                        f = true
                                    end
                                end
                                if f then
                                    local q = P:Raycast(J, R["Position"] - J, o)
                                    if not q then
                                        if oK then
                                            A = G
                                            s = R
                                        else
                                            z = W
                                            s = R
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                if s then
                    (getgenv())["AstraTargetPart"] = s
                else
                    if not d then
                        (getgenv())["AstraTargetPart"] = nil
                    end
                end
            end
        end
    end
)
J9["Aim"]:Section({["Title"] = "Expandir Hitbox"})
local zK = false
local bK = false
local PK = 15
local JK = Vector3["new"](PK, PK, PK)
local WK = -242108 - (-242108)
C["TogHitbox"] =
    J9["Aim"]:Toggle(
    {
        ["Title"] = "Activar Hitbox",
        ["Desc"] = "Hitbox expandida",
        ["Value"] = false,
        ["Callback"] = function(o)
            task["spawn"](
                function()
                    zK = o
                    if not o then
                        for q, o in ipairs(q:GetPlayers()) do
                            pcall(
                                function()
                                    if o["Character"] and o["Character"]:FindFirstChild("GhostHitbox") then
                                        o["Character"]["GhostHitbox"]:Destroy()
                                    end
                                end
                            )
                        end
                    end
                end
            )
        end
    }
)
C["TogHitboxInvisible"] =
    J9["Aim"]:Toggle(
    {["Title"] = "Hitbox Invisible", ["Desc"] = "Oculta la hitbox ", ["Value"] = false, ["Callback"] = function(q)
            bK = q
        end}
)
J9["Aim"]:Slider(
    {["Title"] = "TamaÃ±o Hitbox", ["Value"] = {["Min"] = 1, ["Max"] = 20, ["Default"] = 15}, ["Callback"] = function(q)
            PK = q
            JK = Vector3["new"](q, q, q)
        end}
)
o["Heartbeat"]:Connect(
    function()
        if not zK then
            return
        end
        for q, o in ipairs(q:GetPlayers()) do
            if o ~= LocalPlayer and (o["Character"] and p9(o)) then
                local q = o["Character"]
                local R = q:FindFirstChild("HumanoidRootPart")
                local s = q:FindFirstChild("Humanoid")
                if R and (s and s["Health"] > 482950116 % 7317426) then
                    if not q:FindFirstChild("GhostHitbox") then
                        local o = Instance["new"]("Part")
                        o["Name"] = "GhostHitbox"
                        o["Size"] = Vector3["new"](PK, PK, PK)
                        o["Transparency"] = bK and 367375 - (1085688 - 718314) or .7
                        o["CanCollide"] = false
                        o["Massless"] = true
                        o["CFrame"] = R["CFrame"]
                        o["Parent"] = q
                        local s = Instance["new"]("WeldConstraint")
                        s["Part0"] = R
                        s["Part1"] = o
                        s["Parent"] = o
                    else
                        local o = q:FindFirstChild("GhostHitbox")
                        if o then
                            o["Size"] = Vector3["new"](PK, PK, PK)
                            o["Transparency"] = bK and (592510 - 35683503 % 3500491) - (-86084) or .7
                        end
                    end
                end
            end
        end
    end
)
local EK = nil
local LK = false
local TK = {}
local function XK(q, o, R)
    local s = o:gsub("[%-%^%$%(%)%%%.%[%]%*%+%?]", "%%%1")
    return (q:gsub(s, R))
end
local function cK(q, o, R)
    local s = q:FindFirstAncestorWhichIsA("ScreenGui")
    if s and (string["find"](s["Name"], "WindUI") or string["find"](s["Name"], "Onyx")) then
        return
    end
    if q:IsA("TextLabel") or q:IsA("TextBox") or q:IsA("TextButton") then
        local s = q["Text"]
        local A = false
        if s and s ~= "" then
            if
                string["find"](s, o, (684792 - 208411) - 476380, true) or
                    string["find"](s, R, 559981 - (1573724 - 1013744), true)
             then
                A = true
            end
        end
        if A and not TK[q] then
            TK[q] = {
                ["Text"] = s,
                ["Color"] = q["TextColor3"],
                ["TextTransp"] = q["TextTransparency"],
                ["StrokeTransp"] = q["TextStrokeTransparency"],
                ["Strokes"] = {}
            }
            for o, R in pairs(q:GetChildren()) do
                if R:IsA("UIStroke") then
                    TK[q]["Strokes"][R] = {
                        ["Enabled"] = R["Enabled"],
                        ["Transp"] = R["Transparency"],
                        ["Thickness"] = R["Thickness"]
                    }
                end
            end
        end
        if TK[q] then
            if j or n then
                local s = TK[q]["Text"]
                local A = j and w or R
                s = string["gsub"](s, "%[VIP%] ", "")
                s = string["gsub"](s, "%[VIP%]", "")
                s = string["gsub"](s, '<font color="#bee1e7">%[Content Creator%]</font> ', "")
                s = string["gsub"](s, "%[Content Creator%] ", "")
                s = string["gsub"](s, "%[Content Creator%]", "")
                local z = false
                if E["Character"] then
                    if q:IsDescendantOf(E["Character"]) then
                        z = true
                    else
                        local o = q:FindFirstAncestorWhichIsA("BillboardGui")
                        if o and (o["Adornee"] and o["Adornee"]:IsDescendantOf(E["Character"])) then
                            z = true
                        end
                    end
                end
                local b = A
                if n and z then
                    q["RichText"] = true
                    b = '<font color="#bee1e7">[Content Creator]</font> ' .. A
                end
                s = XK(s, o, b)
                s = XK(s, R, b)
                q["Text"] = s
                q["TextTransparency"] = TK[q]["TextTransp"]
                q["TextStrokeTransparency"] = TK[q]["StrokeTransp"]
                for o, R in pairs(q:GetChildren()) do
                    if R:IsA("UIStroke") and TK[q]["Strokes"][R] then
                        R["Enabled"] = TK[q]["Strokes"][R]["Enabled"]
                    end
                end
                if U then
                    q["TextColor3"] =
                        Color3["fromHSV"](
                        (tick() % (534254228 % 4770127)) / (13568974 % 4522990),
                        (681096 + -1118519) + (((970233 + -544809) - (7728 + (211570 + -112198))) - (-119100)),
                        707035 - 707034
                    )
                else
                    q["TextColor3"] = TK[q]["Color"]
                end
            elseif F then
                q["Text"] = " "
                q["TextTransparency"] = 1
                q["TextStrokeTransparency"] = 1
                for q, o in pairs(q:GetChildren()) do
                    if o:IsA("UIStroke") then
                        o["Enabled"] = false
                        o["Transparency"] = -313925 - (-313926)
                        o["Thickness"] = -40076 + (-577849 + 617925)
                    end
                end
            else
                q["Text"] = TK[q]["Text"]
                if U then
                    q["TextColor3"] =
                        Color3["fromHSV"]((tick() % (-632612 - (-632616))) / (-672330 + 672334), 1, -422048 + 422049)
                else
                    q["TextColor3"] = TK[q]["Color"]
                end
                q["TextTransparency"] = TK[q]["TextTransp"]
                q["TextStrokeTransparency"] = TK[q]["StrokeTransp"]
                for o, R in pairs(q:GetChildren()) do
                    if R:IsA("UIStroke") and TK[q]["Strokes"][R] then
                        R["Enabled"] = TK[q]["Strokes"][R]["Enabled"]
                        R["Transparency"] = TK[q]["Strokes"][R]["Transp"]
                        R["Thickness"] = TK[q]["Strokes"][R]["Thickness"]
                    end
                end
            end
        end
    end
end
local GK = {}
local function fK()
    local o = E["Name"]
    local R = E["DisplayName"]
    task["spawn"](
        function()
            for q, s in pairs(q:GetPlayers()) do
                if s["Character"] then
                    for q, s in pairs(s["Character"]:GetDescendants()) do
                        if s:IsA("TextLabel") or s:IsA("TextBox") then
                            cK(s, o, R)
                        end
                    end
                end
            end
            local s = E:FindFirstChild("PlayerGui")
            if s then
                for q, s in pairs(s:GetDescendants()) do
                    if s:IsA("TextLabel") or s:IsA("TextBox") then
                        cK(s, o, R)
                    end
                end
            end
        end
    )
    if F or j or U or n then
        if not LK then
            LK = true
            local function q(q)
                local s = q:FindFirstAncestorWhichIsA("ScreenGui")
                if s and (string["find"](s["Name"], "WindUI") or string["find"](s["Name"], "Onyx")) then
                    return
                end
                if q:IsA("TextLabel") or q:IsA("TextBox") or q:IsA("TextButton") then
                    cK(q, o, R)
                    if not q:GetAttribute("AstraInfectado") then
                        q:SetAttribute("AstraInfectado", true)
                        ;(q:GetPropertyChangedSignal("Text")):Connect(
                            function()
                                if
                                    LK and
                                        (q["Text"] ~= w and
                                            (q["Text"] ~= " " and
                                                (not string["find"](q["Text"], w) and
                                                    not string["find"](q["Text"], "%[Content Creator%]"))))
                                 then
                                    TK[q] = nil
                                    cK(q, o, R)
                                end
                            end
                        )
                    end
                end
            end
            local s = E:FindFirstChild("PlayerGui")
            if s then
                table["insert"](
                    GK,
                    s["DescendantAdded"]:Connect(
                        function(o)
                            if LK and (o:IsA("TextLabel") or o:IsA("TextBox") or o:IsA("TextButton")) then
                                task["spawn"](
                                    function()
                                        q(o)
                                    end
                                )
                            end
                        end
                    )
                )
            end
            local A, z =
                pcall(
                function()
                    return game:GetService("CoreGui")
                end
            )
            if A and z then
                table["insert"](
                    GK,
                    z["DescendantAdded"]:Connect(
                        function(o)
                            if LK and (o:IsA("TextLabel") or o:IsA("TextBox") or o:IsA("TextButton")) then
                                task["spawn"](
                                    function()
                                        q(o)
                                    end
                                )
                            end
                        end
                    )
                )
            end
        end
    else
        LK = false
        for q, o in ipairs(GK) do
            o:Disconnect()
        end
        GK = {}
        local q = E["Character"]
        if q then
            local o = q:FindFirstChild("Humanoid")
            if o then
                o["DisplayDistanceType"] = Enum["HumanoidDisplayDistanceType"]["Viewer"]
            end
        end
        for q, o in pairs(TK) do
            if q and q["Parent"] then
                q["Text"] = o["Text"]
                q["TextColor3"] = o["Color"]
                q["TextTransparency"] = o["TextTransp"]
                q["TextStrokeTransparency"] = o["StrokeTransp"]
                for q, o in pairs(o["Strokes"]) do
                    if q and q["Parent"] then
                        q["Enabled"] = o["Enabled"]
                        q["Transparency"] = o["Transp"]
                        q["Thickness"] = o["Thickness"]
                    end
                end
            end
        end
    end
end
C["TogHideName"] =
    J9["Vis"]:Toggle(
    {
        ["Title"] = "Ocultar mi Nombre (Visual)",
        ["Desc"] = "Vuelve tu nombre invisible en tu pantalla.",
        ["Callback"] = function(q)
            F = q
            fK()
            z9(q and "Nombre invisible." or "Nombre visible.")
        end
    }
)
C["TogFakeName"] =
    J9["Vis"]:Toggle(
    {
        ["Title"] = "Activar Nombre Falso",
        ["Desc"] = "Reemplaza tu nombre por uno falso (Solo tÃº lo ves).",
        ["Callback"] = function(q)
            j = q
            fK()
            z9(q and "Nombre falso activado." or "Nombre falso desactivado.")
        end
    }
)
C["TogTag"] =
    J9["Vis"]:Toggle(
    {
        ["Title"] = "Tag [Content Creator]",
        ["Desc"] = "Te pone la etiqueta de creador de contenido.",
        ["Callback"] = function(q)
            n = q
            fK()
            pcall(
                function()
                    z9(q and "Tag de Creador activado." or "Tag de Creador desactivado.")
                end
            )
        end
    }
)
J9["Vis"]:Input(
    {["Title"] = "Nuevo Nombre", ["Placeholder"] = "Escribe tu nombre falso...", ["Callback"] = function(q)
            if q ~= "" then
                w = q
                if j then
                    fK()
                end
                z9("Nombre guardado: " .. w)
            end
        end}
)
C["TogRbw"] =
    J9["Vis"]:Toggle(
    {
        ["Title"] = "Efecto arcoÃ­ris en nombre",
        ["Desc"] = "Hace que tu nombre brille cambiando de colores RGB.",
        ["Callback"] = function(q)
            U = q
            fK()
        end
    }
)
J9["Vis"]:Section({["Title"] = "ConfiguraciÃ³n de ESP"})
C["TogEsp"] =
    J9["Vis"]:Toggle(
    {
        ["Title"] = "ESP Jugadores",
        ["Desc"] = "Te permite ver a todos los enemigos a travÃ©s de las paredes.",
        ["Callback"] = function(q)
            k = q
        end
    }
)
C["ColEsp"] =
    J9["Vis"]:Colorpicker(
    {
        ["Title"] = "Color del ESP",
        ["Default"] = Color3["fromRGB"](891541 + -891286, 255, 91480812 % 4356217),
        ["Callback"] = function(q)
            r = q
        end
    }
)
J9["Vis"]:Section({["Title"] = "Filtros de ESP"})
C["TogEspGl"] =
    J9["Vis"]:Toggle(
    {["Title"] = "Mostrar Resplandor", ["Value"] = true, ["Callback"] = function(q)
            D["Glow"] = q
        end}
)
C["TogEspNm"] =
    J9["Vis"]:Toggle(
    {["Title"] = "Mostrar Nombre", ["Value"] = true, ["Callback"] = function(q)
            D["Name"] = q
        end}
)
C["TogEspHp"] =
    J9["Vis"]:Toggle(
    {["Title"] = "Mostrar Vida", ["Value"] = true, ["Callback"] = function(q)
            D["Health"] = q
        end}
)
C["TogEspDs"] =
    J9["Vis"]:Toggle(
    {["Title"] = "Mostrar Distancia", ["Value"] = true, ["Callback"] = function(q)
            D["Distance"] = q
        end}
)
local tK = false
C["TogEspLines"] =
    J9["Vis"]:Toggle(
    {
        ["Title"] = "Mostrar LÃ­neas",
        ["Desc"] = "Dibuja una lÃ­nea desde el centro de tu pantalla hasta cada enemigo.",
        ["Callback"] = function(q)
            tK = q
        end
    }
)
local iK = {}
local dK = 989254 + (-1026919 - (-39165))
local function KK(q)
    if iK[q] then
        if iK[q]["Highlight"] then
            iK[q]["Highlight"]:Destroy()
        end
        if iK[q]["Billboard"] then
            iK[q]["Billboard"]:Destroy()
        end
        iK[q] = nil
    end
end
task["spawn"](
    function()
        while task["wait"](.2) do
            if k and not F9() then
                local o = E["Character"]
                local R = o and o:FindFirstChild("Head")
                local s = R and R["Position"]
                for q, o in pairs(q:GetPlayers()) do
                    if o ~= E then
                        local q = o["Character"]
                        if
                            q and
                                (q:FindFirstChild("Humanoid") and
                                    (q["Humanoid"]["Health"] > 357447304 % (-220038124 % 9726744) and
                                        (q:FindFirstChild("Head") and p9(o))))
                         then
                            local R = q["Head"]
                            local A = s and (R["Position"] - s)["Magnitude"] or 213819 - (-743658 - (-957477))
                            if A <= dK then
                                if iK[o] and iK[o]["Char"] ~= q then
                                    KK(o)
                                end
                                if not iK[o] then
                                    local s = Instance["new"]("Highlight")
                                    s["Name"] = o["Name"] .. "_Glow"
                                    s["FillTransparency"] = .6
                                    s["OutlineTransparency"] = 1
                                    s["DepthMode"] = Enum["HighlightDepthMode"]["AlwaysOnTop"]
                                    s["Adornee"] = q
                                    s["Parent"] = Z
                                    local A = Instance["new"]("BillboardGui")
                                    A["Name"] = o["Name"] .. "_Tag"
                                    A["Size"] = UDim2["new"](279931 - 279931, -751378 - (-751578), 0, 961516 + -961441)
                                    A["StudsOffset"] =
                                        Vector3["new"](1034440 - 1034440, -590753.5 - (-590757), 261851 - 261851)
                                    A["AlwaysOnTop"] = true
                                    A["Adornee"] = R
                                    A["Parent"] = Z
                                    local z = Instance["new"]("TextLabel")
                                    z["Name"] = "Text"
                                    z["Size"] =
                                        UDim2["new"](
                                        (708231 - 880337) + (276757 - 104650),
                                        0,
                                        1,
                                        (310603250400 % (302470336800 % 2291493318 - 843568)) % 10861871
                                    )
                                    z["BackgroundTransparency"] = -1367488539 % (11714818 - (-716896))
                                    z["TextStrokeTransparency"] = 340960 - (961179 + ((-1077424 - (-630232)) - 173028))
                                    z["RichText"] = true
                                    z["Font"] = Enum["Font"]["SourceSansBold"]
                                    z["TextSize"] = -147174 - (-147188)
                                    z["TextYAlignment"] = Enum["TextYAlignment"]["Bottom"]
                                    z["Parent"] = A
                                    local b = Instance["new"]("UIStroke")
                                    b["Color"] =
                                        Color3["fromRGB"](
                                        -571554,
                                        -828514 - (-1772261 - (-943747)),
                                        (16673305293 % 211087982 - (-46071)) % 8687032
                                    )
                                    b["Thickness"] = 1.2
                                    b["Parent"] = z
                                    iK[o] = {["Highlight"] = s, ["Billboard"] = A, ["Char"] = q, ["Text"] = z}
                                end
                                local s = iK[o]
                                if s["Highlight"]["Enabled"] ~= D["Glow"] then
                                    s["Highlight"]["Enabled"] = D["Glow"]
                                end
                                if s["Highlight"]["FillColor"] ~= r then
                                    s["Highlight"]["FillColor"] = r
                                end
                                local z = ""
                                if D["Name"] then
                                    local q =
                                        string["format"](
                                        "#%02X%02X%02X",
                                        r["R"] * ((327006 + 2781749499) % 12531875),
                                        r["G"] * (1290814230 % 13038525),
                                        r["B"] *
                                            (94747579 %
                                                ((1557397 - (321963 - 165257)) - 1378761308 % (5124080 - (-594413))))
                                    )
                                    z = '<font color="' .. (q .. ('">' .. (o["Name"] .. "</font>")))
                                end
                                if D["Health"] then
                                    local o = math["floor"](q["Humanoid"]["Health"])
                                    local R =
                                        q["Humanoid"]["MaxHealth"] >
                                        ((2340109975 % 12643646 - (-303056)) - ((391031 - (-264163)) + -345996)) +
                                            -1029323 and
                                        q["Humanoid"]["MaxHealth"] or
                                        2112846250 % (264876173 % 13339757)
                                    local s = "#2ecc71"
                                    if (o / R) <= .35 then
                                        s = "#e74c3c"
                                    elseif (o / R) <= .7 then
                                        s = "#f1c40f"
                                    end
                                    local A = z == "" and "" or "\n"
                                    z =
                                        z ..
                                        (A .. ('<font size="12" color="' .. (s .. ('">[' .. (o .. " HP]</font>")))))
                                end
                                if D["Distance"] then
                                    local q = z == "" and "" or "\n"
                                    z =
                                        z ..
                                        (q .. ('<font size="11" color="#bdc3c7">' .. (math["floor"](A) .. "m</font>")))
                                end
                                if z ~= "" then
                                    if not s["Billboard"]["Enabled"] then
                                        s["Billboard"]["Enabled"] = true
                                    end
                                    if s["Text"]["Text"] ~= z then
                                        s["Text"]["Text"] = z
                                    end
                                else
                                    if s["Billboard"]["Enabled"] then
                                        s["Billboard"]["Enabled"] = false
                                    end
                                end
                            else
                                KK(o)
                            end
                        else
                            KK(o)
                        end
                    end
                end
            else
                for q, o in pairs(q:GetPlayers()) do
                    KK(o)
                end
            end
        end
    end
)
local MK = Drawing["new"]("Circle")
MK["Filled"] = false
MK["Color"] = Color3["fromRGB"](808767 + -808512, 255, (14794271383 % 77059208 - 581094) % (465246 + 4919133))
MK["Visible"] = false
MK["Thickness"] = 1
local VK = {}
o["RenderStepped"]:Connect(
    function()
        local o = L["ViewportSize"]
        local R =
            Vector2["new"](o["X"] / (2057144498 % 15584428), o["Y"] / (1482443414 % 16463760 - (294821 - (-410191))))
        local s = R["X"]
        local A = R["Y"]
        if X then
            MK["Position"] = R
            MK["Radius"] = c
            MK["Visible"] = true
            if oK and (getgenv())["AstraTargetPart"] then
                MK["Color"] = Color3["fromRGB"](479490 - 479490, 255, 89620 - 89620)
            else
                MK["Color"] =
                    Color3["fromRGB"](
                    627963 - (1663717 - 752626159 % 15031803),
                    -752867 + (1194355 - 441233),
                    80407 - 80152
                )
            end
        else
            if MK["Visible"] then
                MK["Visible"] = false
            end
        end
        if not k or not tK or F9() then
            for q, o in pairs(VK) do
                if o["Visible"] then
                    o["Visible"] = false
                end
            end
            return
        end
        local z = E["Character"]
        local b = (z and z["PrimaryPart"]) and z["PrimaryPart"]["Position"] or L["CFrame"]["Position"]
        local P = q:GetChildren()
        for q = 1, #P, 1 do
            local o = P[q]
            if o:IsA("Player") and o ~= E then
                local q = VK[o]
                if not q then
                    q = Drawing["new"]("Line")
                    q["Thickness"] = 1.5
                    q["Transparency"] = 1
                    q["Visible"] = false
                    VK[o] = q
                end
                local R = o["Character"]
                local A = R and R["PrimaryPart"]
                if A and p9(o) then
                    local o = R:FindFirstChild("Humanoid")
                    if o and o["Health"] > 0 then
                        local o = (b - A["Position"])["Magnitude"]
                        if o <= dK then
                            local o, R = L:WorldToViewportPoint(A["Position"])
                            if R then
                                if q["From"]["X"] ~= s then
                                    q["From"] = Vector2["new"](s, 941376870 % 11075022)
                                end
                                q["To"] = Vector2["new"](o["X"], o["Y"])
                                if q["Color"] ~= r then
                                    q["Color"] = r
                                end
                                if not q["Visible"] then
                                    q["Visible"] = true
                                end
                                continue
                            end
                        end
                    end
                end
                if q["Visible"] then
                    q["Visible"] = false
                end
            end
        end
    end
)
q["PlayerRemoving"]:Connect(
    function(q)
        if VK[q] then
            VK[q]:Remove()
            VK[q] = nil
        end
        KK(q)
    end
)
_G["EditFloatingButtons"] = true
_G["FloatingButtonsShape"] = "RectÃ¡ngulo"
local QK = {}
local function aK(q, o, R)
    local s = Instance["new"]("TextButton")
    s["Name"] = R or q
    s["Size"] = UDim2["new"](94561425 % 540351, 150, (484506 - 705640) - (-221134), 605353 + -605308)
    s["Position"] = o
    s["BackgroundColor3"] = Color3["fromHex"]("#0a0a10")
    s["BackgroundTransparency"] = .3
    s["Text"] = q
    s["TextColor3"] = Color3["fromHex"]("#f8fafc")
    s["Font"] = Enum["Font"]["GothamMedium"]
    s["TextSize"] = 14
    s["AutoButtonColor"] = false
    s["Visible"] = false
    s["ZIndex"] = -69373 - (-69423)
    s["Parent"] = I
    local z = Instance["new"]("UICorner", s)
    z["CornerRadius"] = UDim["new"](((1267810 - (-141821)) - 521241) + -888390, 1789219848 % 7581440)
    local b = Instance["new"]("UIStroke")
    b["Thickness"] = 1.2
    b["Color"] = Color3["fromHex"]("#2a2a3d")
    b["Transparency"] = 536055.5 - (1426481089 % 10036091 - 820112)
    b["Parent"] = s
    s["MouseEnter"]:Connect(
        function()
            if _G["AstraBotonesOcultos"] then
                return
            end
            (A:Create(
                s,
                TweenInfo["new"](.2),
                {["BackgroundColor3"] = Color3["fromHex"]("#1a1a24"), ["BackgroundTransparency"] = .1}
            )):Play()
            ;(A:Create(b, TweenInfo["new"](.2), {["Color"] = Color3["fromHex"]("#0076ad"), ["Transparency"] = 0})):Play()
        end
    )
    s["MouseLeave"]:Connect(
        function()
            if _G["AstraBotonesOcultos"] then
                return
            end
            (A:Create(
                s,
                TweenInfo["new"](.2),
                {["BackgroundColor3"] = Color3["fromHex"]("#0a0a10"), ["BackgroundTransparency"] = .3}
            )):Play()
            ;(A:Create(b, TweenInfo["new"](.2), {["Color"] = Color3["fromHex"]("#2a2a3d"), ["Transparency"] = 0.5})):Play(

            )
        end
    )
    m(s, s)
    local P = nil
    local J = false
    s["InputBegan"]:Connect(
        function(q)
            if
                q["UserInputType"] == Enum["UserInputType"]["MouseButton1"] or
                    q["UserInputType"] == Enum["UserInputType"]["Touch"]
             then
                P = q["Position"]
                J = true
            end
        end
    )
    s["InputChanged"]:Connect(
        function(q)
            if
                P and
                    (q["UserInputType"] == Enum["UserInputType"]["MouseMovement"] or
                        q["UserInputType"] == Enum["UserInputType"]["Touch"])
             then
                if (q["Position"] - P)["Magnitude"] > -896515 + (1445468 - 548948) then
                    J = false
                end
            end
        end
    )
    table["insert"](QK, s)
    return s, function()
        return J
    end, b
end
local yK = false
local kK = nil
local rK = nil
local DK = nil
local BK = 40
local vK = {}
local function SK(q)
    yK = q
    local o = E["Character"]
    local R = o and o:FindFirstChild("HumanoidRootPart")
    local s = o and (o:FindFirstChild("UpperTorso") or o:FindFirstChild("Torso"))
    local A = o and o:FindFirstChild("Humanoid")
    if not o or not R or not s or not A then
        return
    end
    if yK then
        for q, o in pairs(o:GetDescendants()) do
            if o:IsA("BasePart") or o:IsA("Decal") or o:IsA("Texture") then
                if o["Name"] ~= "HumanoidRootPart" then
                    if not vK[o] then
                        vK[o] = o["Transparency"]
                    end
                    o["Transparency"] = 1
                end
            elseif o:IsA("ParticleEmitter") or o:IsA("Trail") or o:IsA("BillboardGui") then
                o["Enabled"] = false
            end
        end
        local q = R["CFrame"] + Vector3["new"](355588 + (-809864 + 454276), 1.5, 548990 - 548990)
        R["CFrame"] = R["CFrame"] + Vector3["new"](-46289 - (-46289), 3, 1212408626 % 8478382)
        A["PlatformStand"] = true
        task["wait"](.05)
        R["AssemblyLinearVelocity"] = Vector3["zero"]
        R["AssemblyAngularVelocity"] = Vector3["zero"]
        R["CFrame"] = CFrame["new"](-581298 - (-616678 - (-35380)), 5000, (765252 + (384325 + -2141858)) + 992281)
        R["Anchored"] = true
        task["wait"](.05)
        kK = Instance["new"]("Seat")
        kK["Name"] = "AstraGhostSeat"
        kK["Anchored"] = false
        kK["CanCollide"] = false
        kK["Transparency"] = 1
        kK["Position"] =
            Vector3["new"](696535 + ((386687 - 146318) - 936904), (547118 - 645003) - (-102885), -129584 - (-129584))
        kK["Parent"] = P
        local z = Instance["new"]("Weld")
        z["Part0"] = kK
        z["Part1"] = s
        z["Parent"] = kK
        task["wait"](.05)
        kK["CFrame"] = q
        R["Anchored"] = false
        rK = Instance["new"]("BodyGyro")
        rK["P"] = 90000
        rK["maxTorque"] = Vector3["new"]((5789 + 2145057154144.0) % 9012899409.0, 9000000000, 96833 + 8999903167.0)
        rK["cframe"] = kK["CFrame"]
        rK["Parent"] = kK
        DK = Instance["new"]("BodyVelocity")
        DK["velocity"] = Vector3["zero"]
        DK["maxForce"] =
            Vector3["new"](
            (-212928 + (-708036 + 9000863454.0)) - (590914 + (331135 - 979559)),
            (2.5064463469307e+14 % 1856627033740.0) % (412014 + 9012330288.0),
            1711505301462.0 % 9007964558.0
        )
        DK["Parent"] = kK
    else
        if rK then
            rK:Destroy()
            rK = nil
        end
        if DK then
            DK:Destroy()
            DK = nil
        end
        if kK then
            kK:Destroy()
            kK = nil
        end
        if A then
            A["PlatformStand"] = false
        end
        for q, o in pairs(vK) do
            if q and q["Parent"] then
                q["Transparency"] = o
            end
        end
        vK = {}
        for q, o in pairs(o:GetDescendants()) do
            if o:IsA("ParticleEmitter") or o:IsA("Trail") or o:IsA("BillboardGui") then
                o["Enabled"] = true
            end
        end
    end
end
local HK, lK, YK =
    aK(
    "Fantasma: OFF",
    UDim2["new"](
        .8,
        -97756 - (-97606),
        417587 + ((589550.5 - (757696 + -637370)) - 886811),
        -234920 - (80486 + -315406)
    ),
    "BtnFantasma"
)
local OK, gK, hK =
    aK(
    "AutoShoot: OFF",
    UDim2["new"](.8, 960619 + ((-1667390 - (-64896)) - (-807239 - (416099 + -581613))), .35, -373921 + 373921),
    "BtnAutoShoot"
)
OK["MouseButton1Click"]:Connect(
    function()
        if not gK() then
            return
        end
        local q = not d
        task["spawn"](
            function()
                pcall(
                    function()
                        C["TogAutoShoot"]:Set(q)
                    end
                )
                if q then
                    OK["Text"] = "AutoShoot: ON"
                    OK["TextColor3"] =
                        Color3["fromRGB"](
                        (-110140 - ((358889 - (138790 + -227137)) + 108881)) - (180035 + -846460),
                        199,
                        507519106 % 4879989
                    )
                    hK["Color"] = Color3["fromRGB"](410307852 % 8045247, 255, 84209601 % 2159214)
                else
                    OK["Text"] = "AutoShoot: OFF"
                    OK["TextColor3"] = Color3["fromHex"]("#f8fafc")
                    hK["Color"] = Color3["fromHex"]("#2a2a3d")
                end
            end
        )
    end
)
local xK, FK, jK =
    aK("Silent Aim: OFF", UDim2["new"](.8, 674740 - (-917 + 675807), .45, 2415713138 % 12139262), "BtnSilentAim")
xK["MouseButton1Click"]:Connect(
    function()
        if not FK() then
            return
        end
        local q = not m9
        task["spawn"](
            function()
                pcall(
                    function()
                        C["TogSilentAimManual"]:Set(q)
                    end
                )
                if q then
                    xK["Text"] = "Silent Aim: ON"
                    xK["TextColor3"] = Color3["fromRGB"]((-873082 - (-455349)) + 417901, 199, 624369 + -624119)
                    jK["Color"] =
                        Color3["fromRGB"](
                        57393439 % ((-654803 + 2061329) - 680030),
                        (677953 - 735958) - (-58260),
                        186132 + -185877
                    )
                else
                    xK["Text"] = "Silent Aim: OFF"
                    xK["TextColor3"] = Color3["fromHex"]("#f8fafc")
                    jK["Color"] = Color3["fromHex"]("#2a2a3d")
                end
            end
        )
    end
)
C["ToggleAsBtn"] =
    J9["Aim"]:Toggle(
    {["Title"] = "Mostrar BotÃ³n Flotante (AutoShoot)", ["Value"] = false, ["Callback"] = function(q)
            OK["Visible"] = q
        end}
)
C["ToggleSaBtn"] =
    J9["Aim"]:Toggle(
    {["Title"] = "Mostrar BotÃ³n Flotante (Silent Aim)", ["Value"] = false, ["Callback"] = function(q)
            xK["Visible"] = q
        end}
)
HK["MouseButton1Click"]:Connect(
    function()
        if not lK() then
            return
        end
        local q = not yK
        task["spawn"](
            function()
                SK(q)
                if q then
                    HK["Text"] = "Fantasma: ON"
                    HK["TextColor3"] =
                        Color3["fromRGB"](
                        718590124 % (15764497 - 475349),
                        (820711 + (-568545 - 561911)) + 309944,
                        -923457 - (-719740 - ((-842718 + 313846) - (-732839)))
                    )
                    YK["Color"] =
                        Color3["fromRGB"](
                        471489 + (508822 - 980056),
                        -748429 + ((684035 + (43440 + -195136)) + 216345),
                        135254 + (943689 + -1078688)
                    )
                else
                    HK["Text"] = "Fantasma: OFF"
                    HK["TextColor3"] = Color3["fromHex"]("#f8fafc")
                    YK["Color"] = Color3["fromHex"]("#2a2a3d")
                end
                z9(q and "Fantasma: ACTIVADO" or "Fantasma: DESACTIVADO")
            end
        )
    end
)
local UK = nil
o["RenderStepped"]:Connect(
    function()
        if yK and (kK and (DK and rK)) then
            if not UK then
                local q = E:FindFirstChild("PlayerScripts")
                if q then
                    local o = q:FindFirstChild("PlayerModule")
                    if o then
                        local q = require(o)
                        UK = q:GetControls()
                    end
                end
            end
            if UK then
                local q = UK:GetMoveVector()
                local o = L["CFrame"]:VectorToWorldSpace(q)
                DK["Velocity"] = o * BK
                rK["CFrame"] = L["CFrame"]
            end
        end
    end
)
E["CharacterAdded"]:Connect(
    function()
        yK = false
        if rK then
            rK:Destroy()
            rK = nil
        end
        if DK then
            DK:Destroy()
            DK = nil
        end
        if kK then
            kK:Destroy()
            kK = nil
        end
        vK = {}
        if HK then
            HK["Text"] = "Fantasma: OFF"
            HK["TextColor3"] = Color3["fromHex"]("#f8fafc")
            if YK then
                YK["Color"] = Color3["fromHex"]("#2a2a3d")
            end
        end
    end
)
J9["Graficos"]:Section({["Title"] = "Modos Visuales (Elige solo uno)"})
local nK = {}
local wK = {}
local NK = {}
local eK = {}
local pK = false
local uK = false
local CK = {
    ["Exposicion"] = .28,
    ["Sombras"] = 5,
    ["Neon"] = .45,
    ["LunaPos"] = (941336 + -1759731) - (-818480),
    ["Desenfoque"] = 2,
    ["SuavidadSombras"] = .1,
    ["ColorSaturacion"] = .15,
    ["PinkRosa"] = .8,
    ["PinkMorado"] = .7,
    ["PinkSaturacion"] = .4,
    ["PinkNeon"] = .3
}
local function IK(q, o)
    local R = game:GetService("Lighting")
    for R, s in ipairs(R:GetChildren()) do
        if s:IsA("Atmosphere") then
            if q then
                if not s:GetAttribute("OrigGuardado_" .. o) then
                    s:SetAttribute("OrigDensity_" .. o, s["Density"])
                    s:SetAttribute("OrigCapacity_" .. o, s["Capacity"])
                    s:SetAttribute("OrigGuardado_" .. o, true)
                end
                s["Density"] = (222873 + (-285532 - 776331)) + 838990
                s["Capacity"] = 733738 + (-986093 - (-252355))
            else
                if s:GetAttribute("OrigGuardado_" .. o) then
                    s["Density"] = s:GetAttribute("OrigDensity_" .. o)
                    s["Capacity"] = s:GetAttribute("OrigCapacity_" .. o)
                    s:SetAttribute("OrigGuardado_" .. o, nil)
                end
            end
        end
    end
    local function s(R)
        if not R then
            return
        end
        for R, s in ipairs(R:GetChildren()) do
            if s:IsA("Clouds") then
                if q then
                    if not s:GetAttribute("OrigGuardado_" .. o) then
                        s:SetAttribute("OrigEnabled_" .. o, s["Enabled"])
                        s:SetAttribute("OrigGuardado_" .. o, true)
                    end
                    s["Enabled"] = false
                else
                    if s:GetAttribute("OrigGuardado_" .. o) then
                        s["Enabled"] = s:GetAttribute("OrigEnabled_" .. o)
                        s:SetAttribute("OrigGuardado_" .. o, nil)
                    end
                end
            end
        end
    end
    s(P)
    s(P:FindFirstChildOfClass("Terrain"))
end
local function ZK()
    if not uK then
        return
    end
    local q = game:GetService("Lighting")
    local o = CK["PinkRosa"]
    local R = CK["PinkMorado"]
    local s =
        math["clamp"](
        math["floor"](769612440 % 3018087 - ((226426684 % 9434441) * R)),
        -360228 - (-360228),
        573181 - 572926
    )
    local A =
        math["clamp"](
        math["floor"]((513989643 % 3893859 - ((-978992 - (-979147)) * o)) - (((764711 - 774020) + 9509) * R)),
        1011661 - ((2876554150 % 13440698 + 1328688) - 561805),
        -59540 - (-59795)
    )
    local z = 47974 + ((268545 + -1119088) + 2690122391 % 12059729)
    for q, b in ipairs(eK) do
        if b:IsA("ColorCorrectionEffect") then
            b["TintColor"] = Color3["fromRGB"](s, A, z)
            b["Saturation"] = CK["PinkSaturacion"]
            b["Contrast"] = (.05 + (.1 * R)) + (.05 * o)
        elseif b:IsA("BloomEffect") then
            b["Intensity"] = CK["PinkNeon"]
        end
    end
    q["ColorShift_Top"] =
        Color3["fromRGB"](
        math["floor"]((-592496 + 592751) - ((-358297 - (-358347)) * R)),
        math["floor"]((427463 + (64949 - 492362)) + ((-851673 - (-851723)) * ((726848 - 726847) - o))),
        math["floor"]((444601 - (259345 + 1087052004 % 8110947)) + ((13512524 % 13512419) * R))
    )
    q["ColorShift_Bottom"] =
        Color3["fromRGB"](
        math["floor"]((744124002 % 4426644 + -447780) + ((-141756 + 141826) * o)),
        -823839 - (-823839),
        math["floor"]((631042 + -630992) + ((322926968 % 3628392) * R))
    )
    q["OutdoorAmbient"] =
        Color3["fromRGB"](
        math["floor"](1058893690 % 6496280 + ((102000031 % (((-1716034 - (-879735)) + 1991711846) % 10628798)) * o)),
        0,
        math["floor"]((770335 + -770255) + (((-865683 - (-190790 + -3009)) - (-671964)) * R))
    )
    q["Ambient"] =
        Color3["fromRGB"](
        math["floor"]((-660773 - (-660833)) + (((1390630 - 690720) + -699880) * o)),
        math["floor"]((1259946716 % 5779572) * ((-225710 + (1093499 - 867788)) - R)),
        math["floor"]((-728449 - (-728529)) + (((-399511 + 100778485) % (-533155 + 1601016)) * R))
    )
    q["ExposureCompensation"] = .1 - ((((809843 + 125693371444.75) % (87603178292.25 % 724040793.25)) % 3182685.25) * R)
end
C["TogTokyowami"] =
    J9["Graficos"]:Toggle(
    {
        ["Title"] = "Shaders Tokyowami",
        ["Desc"] = "Aplica Shaders originales.",
        ["Callback"] = function(q)
            local o = game:GetService("Lighting")
            if q then
                if not o:GetAttribute("OrigSaved") then
                    o:SetAttribute("OrigBright", o["Brightness"])
                    o:SetAttribute("OrigCSB", o["ColorShift_Bottom"])
                    o:SetAttribute("OrigCST", o["ColorShift_Top"])
                    o:SetAttribute("OrigOA", o["OutdoorAmbient"])
                    o:SetAttribute("OrigTime", o["ClockTime"])
                    o:SetAttribute("OrigFogC", o["FogColor"])
                    o:SetAttribute("OrigFogE", o["FogEnd"])
                    o:SetAttribute("OrigFogS", o["FogStart"])
                    o:SetAttribute("OrigExp", o["ExposureCompensation"])
                    o:SetAttribute("OrigShadow", o["ShadowSoftness"])
                    o:SetAttribute("OrigAmbient", o["Ambient"])
                    o:SetAttribute("OrigSaved", true)
                end
                for q, o in ipairs(wK) do
                    pcall(
                        function()
                            o:Destroy()
                        end
                    )
                end
                table["clear"](wK)
                local q = Instance["new"]("BloomEffect")
                q["Intensity"] = .1
                q["Threshold"] = 0
                q["Size"] = 100
                q["Parent"] = o
                table["insert"](wK, q)
                local R = Instance["new"]("Sky")
                R["Name"] = "Tropic"
                R["SkyboxUp"] = "http://www.roblox.com/asset/?id=169210149"
                R["SkyboxLf"] = "http://www.roblox.com/asset/?id=169210133"
                R["SkyboxBk"] = "http://www.roblox.com/asset/?id=169210090"
                R["SkyboxFt"] = "http://www.roblox.com/asset/?id=169210121"
                R["StarCount"] = -628604 - (-628704)
                R["SkyboxDn"] = "http://www.roblox.com/asset/?id=169210108"
                R["SkyboxRt"] = "http://www.roblox.com/asset/?id=169210143"
                R["Parent"] = o
                table["insert"](wK, R)
                local s = Instance["new"]("Sky")
                s["SkyboxUp"] = "http://www.roblox.com/asset/?id=196263782"
                s["SkyboxLf"] = "http://www.roblox.com/asset/?id=196263721"
                s["SkyboxBk"] = "http://www.roblox.com/asset/?id=196263721"
                s["SkyboxFt"] = "http://www.roblox.com/asset/?id=196263721"
                s["CelestialBodiesShown"] = false
                s["SkyboxDn"] = "http://www.roblox.com/asset/?id=196263643"
                s["SkyboxRt"] = "http://www.roblox.com/asset/?id=196263721"
                s["Parent"] = o
                table["insert"](wK, s)
                local A = Instance["new"]("BlurEffect")
                A["Size"] = 2
                A["Parent"] = o
                table["insert"](wK, A)
                local z = Instance["new"]("ColorCorrectionEffect")
                z["Name"] = "Inari taisha"
                z["Saturation"] = .05
                z["TintColor"] = Color3["fromRGB"](-617027 - (-617282), 224, 1475728603 % 11529128)
                z["Parent"] = o
                table["insert"](wK, z)
                local b = Instance["new"]("SunRaysEffect")
                b["Intensity"] = .05
                b["Parent"] = o
                table["insert"](wK, b)
                local P = Instance["new"]("Sky")
                P["Name"] = "Sunset"
                P["SkyboxUp"] = "rbxassetid://323493360"
                P["SkyboxLf"] = "rbxassetid://323494252"
                P["SkyboxBk"] = "rbxassetid://323494035"
                P["SkyboxFt"] = "rbxassetid://323494130"
                P["SkyboxDn"] = "rbxassetid://323494368"
                P["SunAngularSize"] = 14
                P["SkyboxRt"] = "rbxassetid://323494067"
                P["Parent"] = o
                table["insert"](wK, P)
                o["Brightness"] = 2.14
                o["ColorShift_Bottom"] = Color3["fromRGB"](-1838153, 12989790 % (7064719 - 569824), 942494 + -942474)
                o["ColorShift_Top"] =
                    Color3["fromRGB"](
                    (414390 + 536619) + -950769,
                    (-629704 + 1078442047) % 4346017,
                    (-196852 - (-15339)) - (767730 + ((814024 + (-749908 - 712821)) + (-199726 - 100826)))
                )
                o["OutdoorAmbient"] = Color3["fromRGB"](653240 - 653206, 0, -409191 - (-370867 - 38373))
                o["ClockTime"] = 6.7
                o["FogColor"] = Color3["fromRGB"](-261342, 76, 52044 + -51938)
                o["FogEnd"] = 1000
                o["ExposureCompensation"] = .24
                o["ShadowSoftness"] = (157947 - (-391784)) + (-872023 + 322292)
                o["Ambient"] = Color3["fromRGB"](-319655 - (-319714), 33, -903283 + 903310)
                z9("Tokyowami: ON")
            else
                for q, o in ipairs(wK) do
                    pcall(
                        function()
                            o:Destroy()
                        end
                    )
                end
                table["clear"](wK)
                if o:GetAttribute("OrigSaved") then
                    o["Brightness"] = o:GetAttribute("OrigBright")
                    o["ColorShift_Bottom"] = o:GetAttribute("OrigCSB")
                    o["ColorShift_Top"] = o:GetAttribute("OrigCST")
                    o["OutdoorAmbient"] = o:GetAttribute("OrigOA")
                    o["ClockTime"] = o:GetAttribute("OrigTime")
                    o["FogColor"] = o:GetAttribute("OrigFogC")
                    o["FogEnd"] = o:GetAttribute("OrigFogE")
                    o["ExposureCompensation"] = o:GetAttribute("OrigExp")
                    o["ShadowSoftness"] = o:GetAttribute("OrigShadow")
                    o["Ambient"] = o:GetAttribute("OrigAmbient")
                end
                z9("Tokyowami: OFF")
            end
        end
    }
)
C["TogNight"] =
    J9["Graficos"]:Toggle(
    {
        ["Title"] = "Modo Noche",
        ["Desc"] = "Modo noche ajustable.",
        ["Callback"] = function(q)
            local o = game:GetService("Lighting")
            local R = P:FindFirstChildOfClass("Terrain")
            pK = q
            if q then
                if not o:GetAttribute("OrigSavedNight") then
                    o:SetAttribute("OrigBright", o["Brightness"])
                    o:SetAttribute("OrigCSB", o["ColorShift_Bottom"])
                    o:SetAttribute("OrigCST", o["ColorShift_Top"])
                    o:SetAttribute("OrigOA", o["OutdoorAmbient"])
                    o:SetAttribute("OrigTime", o["ClockTime"])
                    o:SetAttribute("OrigFogC", o["FogColor"])
                    o:SetAttribute("OrigFogE", o["FogEnd"])
                    o:SetAttribute("OrigExp", o["ExposureCompensation"])
                    o:SetAttribute("OrigShadow", o["ShadowSoftness"])
                    o:SetAttribute("OrigAmbient", o["Ambient"])
                    o:SetAttribute("OrigSpec", o["EnvironmentSpecularScale"])
                    o:SetAttribute("OrigDiff", o["EnvironmentDiffuseScale"])
                    o:SetAttribute("OrigGlobalS", o["GlobalShadows"])
                    o:SetAttribute("OrigGeo", o["GeographicLatitude"])
                    o:SetAttribute("OrigSavedNight", true)
                end
                IK(true, "Night")
                if R and not R:GetAttribute("OrigWaterSavedNight") then
                    R:SetAttribute("OrigWaveSize", R["WaterWaveSize"])
                    R:SetAttribute("OrigWaveSpeed", R["WaterWaveSpeed"])
                    R:SetAttribute("OrigReflectance", R["WaterReflectance"])
                    R:SetAttribute("OrigTransparency", R["WaterTransparency"])
                    R:SetAttribute("OrigWaterColor", R["WaterColor"])
                    R:SetAttribute("OrigWaterSavedNight", true)
                end
                for q, o in ipairs(NK) do
                    pcall(
                        function()
                            o:Destroy()
                        end
                    )
                end
                table["clear"](NK)
                local q = Instance["new"]("BlurEffect")
                q["Size"] = CK["Desenfoque"]
                q["Parent"] = o
                table["insert"](NK, q)
                local s = Instance["new"]("BloomEffect")
                s["Intensity"] = CK["Neon"]
                s["Size"] = (310105 + 1749266301) % 8691612
                s["Threshold"] = .2
                s["Parent"] = o
                table["insert"](NK, s)
                local A = Instance["new"]("ColorCorrectionEffect")
                A["Brightness"] = .02
                A["Contrast"] = .15
                A["Saturation"] = CK["ColorSaturacion"]
                A["TintColor"] =
                    Color3["fromRGB"](
                    -782079 - (-782289),
                    (1008870 - 558832) - 449813,
                    3149493315 % (6972373560 % 28753875)
                )
                A["Parent"] = o
                table["insert"](NK, A)
                local z = Instance["new"]("SunRaysEffect")
                z["Intensity"] = .15
                z["Spread"] = (2469778976.75 - (-318584)) % 15438109.75
                z["Parent"] = o
                table["insert"](NK, z)
                local b = Instance["new"]("Sky")
                b["Name"] = "OnyxTokyowamiNight"
                b["SkyboxUp"] = "http://www.roblox.com/asset/?id=169210149"
                b["SkyboxLf"] = "http://www.roblox.com/asset/?id=169210133"
                b["SkyboxBk"] = "http://www.roblox.com/asset/?id=169210090"
                b["SkyboxFt"] = "http://www.roblox.com/asset/?id=169210121"
                b["SkyboxDn"] = "http://www.roblox.com/asset/?id=169210108"
                b["SkyboxRt"] = "http://www.roblox.com/asset/?id=169210143"
                b["StarCount"] = (780500 + 258809100) % 1573240
                b["MoonAngularSize"] = (324118 - 112387) - (610744 + -399031)
                b["Parent"] = o
                table["insert"](NK, b)
                o["ClockTime"] = 979539 + (-767230 + -212309)
                o["Brightness"] = -366541 - (-366545)
                o["EnvironmentSpecularScale"] = (808269 + (-978652 - (-697730 + 590301))) + (283509 - 220554)
                o["EnvironmentDiffuseScale"] = 1
                o["GlobalShadows"] = true
                o["GeographicLatitude"] = CK["LunaPos"]
                o["ShadowSoftness"] = CK["SuavidadSombras"]
                o["ExposureCompensation"] = CK["Exposicion"]
                o["OutdoorAmbient"] =
                    Color3["fromRGB"](
                    267287 - 267237,
                    (887539 - 292584690 % 1767566) - (-48826),
                    (-288806 + 73165) + 215736
                )
                local P = CK["Sombras"]
                o["Ambient"] = Color3["fromRGB"](P, P + (487968 - 487965), P + ((-213055 + -88978) - (-302043)))
                o["ColorShift_Bottom"] =
                    Color3["fromRGB"](3398064208 % 14030145, -938597 - (-938637), -511234 - (-511294))
                o["ColorShift_Top"] = Color3["fromRGB"](98577 + -98417, 180, 2795196204 % 13701941)
                o["FogColor"] =
                    Color3["fromRGB"](
                    -836816 - (-836831),
                    ((18215919772775 % 133940654979) % (-906489 + 2093841269)) % (10263955 - 782405),
                    -511588 - (-511618)
                )
                o["FogEnd"] = 2500
                if R then
                    R["WaterWaveSize"] = .12
                    R["WaterWaveSpeed"] = ((-459455 - (-357291)) - (-858114)) + -755942
                    R["WaterReflectance"] = -621125 - (-621126)
                    R["WaterTransparency"] = .85
                    R["WaterColor"] = Color3["fromRGB"](-57444 - (-57459), 25, 501031389 % 4912072)
                end
                z9("Noche: ON (Cielo despejado)")
            else
                for q, o in ipairs(NK) do
                    pcall(
                        function()
                            o:Destroy()
                        end
                    )
                end
                table["clear"](NK)
                if o:GetAttribute("OrigSavedNight") then
                    o["Brightness"] = o:GetAttribute("OrigBright")
                    o["ColorShift_Bottom"] = o:GetAttribute("OrigCSB")
                    o["ColorShift_Top"] = o:GetAttribute("OrigCST")
                    o["OutdoorAmbient"] = o:GetAttribute("OrigOA")
                    o["ClockTime"] = o:GetAttribute("OrigTime")
                    o["FogColor"] = o:GetAttribute("OrigFogC")
                    o["FogEnd"] = o:GetAttribute("OrigFogE")
                    o["ExposureCompensation"] = o:GetAttribute("OrigExp")
                    o["ShadowSoftness"] = o:GetAttribute("OrigShadow")
                    o["Ambient"] = o:GetAttribute("OrigAmbient")
                    o["GlobalShadows"] = o:GetAttribute("OrigGlobalS")
                    if o:GetAttribute("OrigGeo") then
                        o["GeographicLatitude"] = o:GetAttribute("OrigGeo")
                    end
                    if o:GetAttribute("OrigSpec") then
                        o["EnvironmentSpecularScale"] = o:GetAttribute("OrigSpec")
                        o["EnvironmentDiffuseScale"] = o:GetAttribute("OrigDiff")
                    end
                end
                IK(false, "Night")
                if R and R:GetAttribute("OrigWaterSavedNight") then
                    R["WaterWaveSize"] = R:GetAttribute("OrigWaveSize")
                    R["WaterWaveSpeed"] = R:GetAttribute("OrigWaveSpeed")
                    R["WaterReflectance"] = R:GetAttribute("OrigReflectance")
                    R["WaterTransparency"] = R:GetAttribute("OrigTransparency")
                    R["WaterColor"] = R:GetAttribute("OrigWaterColor")
                end
                z9("Noche: OFF")
            end
        end
    }
)
C["TogPink"] =
    J9["Graficos"]:Toggle(
    {
        ["Title"] = "Pink Hour",
        ["Desc"] = "Estilo Synthwave. Cielo y ambiente ajustable con los sliders.",
        ["Callback"] = function(q)
            local o = game:GetService("Lighting")
            uK = q
            if q then
                if not o:GetAttribute("OrigSavedPink") then
                    o:SetAttribute("OrigBrightP", o["Brightness"])
                    o:SetAttribute("OrigCSBP", o["ColorShift_Bottom"])
                    o:SetAttribute("OrigCSTP", o["ColorShift_Top"])
                    o:SetAttribute("OrigOAP", o["OutdoorAmbient"])
                    o:SetAttribute("OrigTimeP", o["ClockTime"])
                    o:SetAttribute("OrigFogCP", o["FogColor"])
                    o:SetAttribute("OrigFogEP", o["FogEnd"])
                    o:SetAttribute("OrigAmbientP", o["Ambient"])
                    o:SetAttribute("OrigExpP", o["ExposureCompensation"])
                    o:SetAttribute("OrigShadowP", o["ShadowSoftness"])
                    o:SetAttribute("OrigSavedPink", true)
                end
                IK(true, "Pink")
                for q, o in ipairs(eK) do
                    pcall(
                        function()
                            o:Destroy()
                        end
                    )
                end
                table["clear"](eK)
                local q = Instance["new"]("ColorCorrectionEffect")
                q["Parent"] = o
                table["insert"](eK, q)
                local R = Instance["new"]("BloomEffect")
                R["Size"] = (1560042717 % (6913529964 % 57258984)) % 690758
                R["Threshold"] = .85
                R["Parent"] = o
                table["insert"](eK, R)
                local s = Instance["new"]("BlurEffect")
                s["Size"] = 2
                s["Parent"] = o
                table["insert"](eK, s)
                local A = Instance["new"]("SunRaysEffect")
                A["Intensity"] = .08
                A["Spread"] = .8
                A["Parent"] = o
                table["insert"](eK, A)
                local z = Instance["new"]("Sky")
                z["Name"] = "AstraPinkSky"
                z["SkyboxUp"] = "rbxassetid://323493360"
                z["SkyboxLf"] = "rbxassetid://323494252"
                z["SkyboxBk"] = "rbxassetid://323494035"
                z["SkyboxFt"] = "rbxassetid://323494130"
                z["SkyboxDn"] = "rbxassetid://323494368"
                z["SkyboxRt"] = "rbxassetid://323494067"
                z["SunAngularSize"] = 14
                z["StarCount"] = -984934 + (-866306 + (2391239 - 536999))
                z["Parent"] = o
                table["insert"](eK, z)
                o["Brightness"] = (1256653 - 362336) + -894315.0
                o["ClockTime"] = 6.7
                o["FogColor"] = Color3["fromRGB"](183979 + -183859, 20, (-1212502 - (-178500)) - (-1034152))
                o["FogEnd"] = -732380 - (-733580)
                o["ShadowSoftness"] = .2
                ZK()
                z9("Pink Hour: ON")
            else
                for q, o in ipairs(eK) do
                    pcall(
                        function()
                            o:Destroy()
                        end
                    )
                end
                table["clear"](eK)
                if o:GetAttribute("OrigSavedPink") then
                    o["Brightness"] = o:GetAttribute("OrigBrightP")
                    o["ColorShift_Bottom"] = o:GetAttribute("OrigCSBP")
                    o["ColorShift_Top"] = o:GetAttribute("OrigCSTP")
                    o["OutdoorAmbient"] = o:GetAttribute("OrigOAP")
                    o["ClockTime"] = o:GetAttribute("OrigTimeP")
                    o["FogColor"] = o:GetAttribute("OrigFogCP")
                    o["FogEnd"] = o:GetAttribute("OrigFogEP")
                    o["Ambient"] = o:GetAttribute("OrigAmbientP")
                    o["ExposureCompensation"] = o:GetAttribute("OrigExpP")
                    o["ShadowSoftness"] = o:GetAttribute("OrigShadowP")
                end
                IK(false, "Pink")
                z9("Pink Hour: OFF")
            end
        end
    }
)
J9["Graficos"]:Section({["Title"] = "Ajustes: Modo Noche"})
J9["Graficos"]:Slider(
    {
        ["Title"] = "Claridad del Mapa",
        ["Desc"] = "Afecta solo al Modo Noche. Ãsalo si estÃ¡ muy oscuro.",
        ["Step"] = .05,
        ["Value"] = {["Min"] = -956847.0 - (-956847), ["Max"] = (-571124 + 113681.0) - (-457444), ["Default"] = .28},
        ["Callback"] = function(q)
            CK["Exposicion"] = q
            if pK then
                (game:GetService("Lighting"))["ExposureCompensation"] = q
            end
        end
    }
)
J9["Graficos"]:Slider(
    {
        ["Title"] = "Profundidad de Sombras",
        ["Desc"] = "0 = Oscuridad total. 50 = Sombra suave y clara.",
        ["Step"] = 5,
        ["Value"] = {["Min"] = (36564089 - 930725) % 913676, ["Max"] = 331300 + (-696509 - (-365259)), ["Default"] = 5},
        ["Callback"] = function(q)
            CK["Sombras"] = q
            if pK then
                (game:GetService("Lighting"))["Ambient"] =
                    Color3["fromRGB"](q, q + 3, q + (-122795 + (-251589 + 374394)))
            end
        end
    }
)
J9["Graficos"]:Slider(
    {
        ["Title"] = "Resplandor",
        ["Desc"] = "Ajusta quÃ© tanto brillan las armas y las luces del mapa.",
        ["Step"] = .05,
        ["Value"] = {["Min"] = .1, ["Max"] = -34666.0 - (-34667), ["Default"] = .45},
        ["Callback"] = function(q)
            CK["Neon"] = q
            if pK then
                for o, R in ipairs(NK) do
                    if R:IsA("BloomEffect") then
                        R["Intensity"] = q
                    end
                end
            end
        end
    }
)
J9["Graficos"]:Slider(
    {
        ["Title"] = "Fondo Borroso",
        ["Desc"] = "0 = Sin borrosidad. AÃ±ade un efecto de cÃ¡mara cinematogrÃ¡fica.",
        ["Step"] = (-666315 + 360174.5) - (624774 + -930915),
        ["Value"] = {
            ["Min"] = 0,
            ["Max"] = -253411 - (-253421),
            ["Default"] = (-971656 - (-1633963 - (-846246))) - (-183941)
        },
        ["Callback"] = function(q)
            CK["Desenfoque"] = q
            if pK then
                for o, R in ipairs(NK) do
                    if R:IsA("BlurEffect") then
                        R["Size"] = q
                    end
                end
            end
        end
    }
)
J9["Graficos"]:Slider(
    {
        ["Title"] = "PosiciÃ³n de la Luna",
        ["Desc"] = "Mueve la luna en el cielo.",
        ["Step"] = -885007 - (-885012),
        ["Value"] = {["Min"] = -561321 - (-561321), ["Max"] = 360, ["Default"] = (1942904426 - (-115283)) % 10675932},
        ["Callback"] = function(q)
            CK["LunaPos"] = q
            if pK then
                (game:GetService("Lighting"))["GeographicLatitude"] = q
            end
        end
    }
)
J9["Graficos"]:Section({["Title"] = "Ajustes: Pink Hour"})
J9["Graficos"]:Slider(
    {
        ["Title"] = "Intensidad del Morado",
        ["Desc"] = "AÃ±ade oscuridad y tonos violetas al cielo y al mapa.",
        ["Step"] = .05,
        ["Value"] = {["Min"] = 0, ["Max"] = 1, ["Default"] = .7},
        ["Callback"] = function(q)
            CK["PinkMorado"] = q
            ZK()
        end
    }
)
J9["Graficos"]:Slider(
    {
        ["Title"] = "Intensidad del Rosa",
        ["Desc"] = "Agrega tonos magentas y rosas a las luces.",
        ["Step"] = .05,
        ["Value"] = {["Min"] = 0, ["Max"] = 876253 + (-505334.0 - 370918), ["Default"] = .8},
        ["Callback"] = function(q)
            CK["PinkRosa"] = q
            ZK()
        end
    }
)
J9["Graficos"]:Slider(
    {
        ["Title"] = "SaturaciÃ³n de Color",
        ["Desc"] = "0 = GrisÃ¡ceo y apagado. 1 = Colores fluorescentes.",
        ["Step"] = .05,
        ["Value"] = {["Min"] = 742946695 % (9659218.0 - 708053), ["Max"] = 1, ["Default"] = .4},
        ["Callback"] = function(q)
            CK["PinkSaturacion"] = q
            ZK()
        end
    }
)
J9["Graficos"]:Slider(
    {
        ["Title"] = "Resplandor",
        ["Desc"] = "Haz que el cielo y los neones brillen mas.",
        ["Step"] = .05,
        ["Value"] = {["Min"] = 0, ["Max"] = 1, ["Default"] = .3},
        ["Callback"] = function(q)
            CK["PinkNeon"] = q
            if uK then
                for o, R in ipairs(eK) do
                    if R:IsA("BloomEffect") then
                        R["Intensity"] = q
                    end
                end
            end
        end
    }
)
local mK = {
    ["Old School"] = {
        ["Walk"] = 10921244891,
        ["Run"] = ((749941 + 667166160412) - (-630685)) % ((2790074295205 - 70718) % 10941483410),
        ["Jump"] = 10921242013,
        ["Fall"] = 10920499796 - (-741448),
        ["SwimIdle"] = ((592534 + (10920859842 - 190039)) - 372149) - (-353830),
        ["Swim"] = 10921495736 - (-641245 + 893933),
        ["Idle"] = 10921230744,
        ["Idle2"] = (10920976254 - (-577588)) - 321749,
        ["Climb"] = 10921229866
    },
    ["Adidas Sports"] = {
        ["Walk"] = 18537392113,
        ["Run"] = 18537384940,
        ["Jump"] = 18537380791,
        ["Fall"] = (18535571340 - (-503274 - (1427723 - ((341114339 - 174385) % 9184637 - 190686)))) - (-782600),
        ["SwimIdle"] = 18537387180,
        ["Swim"] = (-549361 + 1436568) + 18536502324,
        ["Idle"] = 18536778389 - (-598103),
        ["Idle2"] = 18537371272,
        ["Climb"] = 18537363391
    },
    ["Adidas Community"] = {
        ["Walk"] = 122150855457006,
        ["Run"] = -818386 + (82598235390683 - (-268738)),
        ["Jump"] = 75290611992385,
        ["Fall"] = 11930627236912704 % (98600225189896 - 15031),
        ["SwimIdle"] = (((-1270331 - (-500830)) + (-922187 - (-518146 - 149101))) + 10715959211144553) % 109346522575216,
        ["Swim"] = 133308482297641 - (-968567),
        ["Idle"] = 122257458498464,
        ["Idle2"] = 102357151005774,
        ["Climb"] = 88763136693023
    },
    ["Adidas Aura"] = {
        ["Walk"] = 83842218823011,
        ["Run"] = 23309105949984710 % (-1094 + 118320334834083),
        ["Jump"] = (-602591 + 655940) + (-210473 + 109996626678328),
        ["Fall"] = 95603166884636,
        ["SwimIdle"] = 94922130551805,
        ["Swim"] = 134530128383903,
        ["Idle"] = 110211186840347,
        ["Idle2"] = ((284373 + (-374085 + -515888)) - (-125301)) + ((-1540544 - (-605442 + -132782)) + 114191138547684),
        ["Climb"] = 97824616490448
    },
    ["Wicked Popular"] = {
        ["Walk"] = 92072849924640,
        ["Run"] = 72301599441680,
        ["Jump"] = 104325245285198,
        ["Fall"] = 121152442295910 - (-466571),
        ["Idle"] = 118832222982049,
        ["Idle2"] = 76049494037641,
        ["SwimIdle"] = 24790672304166737 % (6905165049017941 % ((113199429281567 - 1035046) - 319672896 % 1385339)),
        ["Swim"] = 99384245425157,
        ["Climb"] = 131326830509784
    },
    ["Elder"] = {
        ["Walk"] = 10920960999 - (-150376),
        ["Run"] = (-236550 + 10920378595) - (-962329),
        ["Jump"] = 10921075450 - (-31917),
        ["Fall"] = 10920339757 - (-766008),
        ["SwimIdle"] = 10920881634 - (-131763 + -96749),
        ["Swim"] = 10921108971,
        ["Idle"] = 1858821558703 % (174980623101 % 10936420058),
        ["Idle2"] = (796956 + (317054991174 - (-337596))) % 10933393684,
        ["Climb"] = (-492334 + 1497400) + 10920095334
    },
    ["Zombie"] = {
        ["Walk"] = 10921355261,
        ["Run"] = -6160 + (-656205 + 616826047),
        ["Jump"] = 10921351278,
        ["Fall"] = 896551080695 % (10933965984 - 265609),
        ["SwimIdle"] = 10921353442,
        ["Swim"] = 10921352344,
        ["Idle"] = 10921344533,
        ["Idle2"] = (601163194739 - (-920777)) % (2789655646485 % 10939863043) - (-642190),
        ["Climb"] = (-46405 + 1957345234385) % 10934965418
    },
    ["Mage"] = {
        ["Walk"] = 828912 + (22085 + 10920301681),
        ["Run"] = 10921148209,
        ["Jump"] = 10921149743,
        ["Fall"] = 10921148939,
        ["SwimIdle"] = 10921151661,
        ["Swim"] = 10921150788,
        ["Idle"] = 10921144709,
        ["Idle2"] = 10921145797,
        ["Climb"] = 10921030055 - (-113349)
    },
    ["Catwalk Glam"] = {
        ["Walk"] = 109168724377491 - (-105257),
        ["Run"] = 81024476153754,
        ["Jump"] = 116936326516985,
        ["Fall"] = 92294537340807,
        ["SwimIdle"] = 98854110541879 - (-819481),
        ["Swim"] = 134591743181628,
        ["Idle"] = 133806214992291,
        ["Idle2"] = 94970087938816 - (-402747),
        ["Climb"] = 119377220803248 - (-33933 + -130373)
    },
    ["Astronaut"] = {
        ["Walk"] = 10921046031,
        ["Run"] = 10921039308,
        ["Jump"] = 10920634643 - (-407851),
        ["Fall"] = 716415 + (10921293578 - (1113602 - (-775108 + (-28045418241 % 355126501) % 2679438))),
        ["SwimIdle"] = 10921045006,
        ["Swim"] = 10921044000,
        ["Idle"] = 10920951818 - (-83006),
        ["Idle2"] = 10920088525 - (-948281),
        ["Climb"] = (546318933978 - 543652) % (1870076547318 % 10936176886)
    },
    ['Wicked "Dancing Through Life"'] = {
        ["Walk"] = 73718308412641,
        ["Run"] = 135515454877967,
        ["Jump"] = 78508480717326,
        ["Fall"] = 78147884741423 - (-555989),
        ["SwimIdle"] = 129183123083281,
        ["Swim"] = 110657013921774,
        ["Idle"] = 92849173543269,
        ["Idle2"] = (19042404050305419 - (-204802)) % 132238917129784,
        ["Climb"] = 129447497744818
    },
    ["Werewolf"] = {
        ["Walk"] = 10921342074,
        ["Run"] = 2469330457547 % (10926040611 - (-222147)),
        ["Fall"] = 10921337907,
        ["SwimIdle"] = 10921341319,
        ["Swim"] = 10921340419,
        ["Idle"] = -732734 + (600584 + 754730868990) % 10938373624,
        ["Idle2"] = 10921333667,
        ["Climb"] = 10921100774 - (-228548)
    },
    ["Superhero"] = {
        ["Walk"] = 10921298616,
        ["Run"] = 10921291831,
        ["Jump"] = 10920512373 - (-782186),
        ["Fall"] = 10921293373,
        ["SwimIdle"] = 10921297391,
        ["Swim"] = 10920564922 - (-730573),
        ["Idle"] = -332560 + (10922269155 - 647686),
        ["Idle2"] = 10921870330 -
            (((-110342 - (((66352 - 815000) - (-697780)) - (-144577 + (980724 - (322351 + (273288 + -412529)))))) -
                859893) +
                1753676583 % (744953 + 7295552)),
        ["Climb"] = 10921286911
    },
    ["Toy"] = {
        ["Walk"] = 10921312010,
        ["Run"] = 10920820818 - (-485467),
        ["Jump"] = 10921308158,
        ["Fall"] = 10921307241,
        ["SwimIdle"] = 10921310341,
        ["Swim"] = ((427904354073584 - (-923256)) % (652953 + 1945019148599)) % 10927102529,
        ["Idle"] = 10921301576,
        ["Climb"] = 10920649338 - (-651501)
    },
    ["No Boundaries"] = {
        ["Walk"] = 18747074203,
        ["Run"] = 18747070484,
        ["Jump"] = (-266160 - (-251870)) + 18747083438,
        ["Fall"] = 18747062535,
        ["SwimIdle"] = 18747071682,
        ["Swim"] = 18747073181,
        ["Idle"] = 18747067405,
        ["Idle2"] = 18747063918,
        ["Climb"] = 18746821504 - (-239399)
    },
    ["NFL"] = {
        ["Walk"] = 361295 + (3310769155782037 % (110358972795758 - 473488) - 498087),
        ["Run"] = 117333533048078,
        ["Jump"] = 119846112151352,
        ["Fall"] = 129773241321032,
        ["SwimIdle"] = 6248119303906733 % (79090117294945 - (-576435)),
        ["Swim"] = 132697394189921,
        ["Idle"] = 92080889245616 - (-615794),
        ["Idle2"] = ((152931 - (-970977)) - (-507067 - (-853317))) + 74451232451601,
        ["Climb"] = 134630013742019
    },
    ["Amazon Unboxed"] = {
        ["Walk"] = 90478084550987 - (-575643 + 102165),
        ["Run"] = 134824449627994 - (-991871),
        ["Jump"] = 121454505477205,
        ["Fall"] = 94788218468396,
        ["SwimIdle"] = 129126268464847,
        ["Swim"] = 105962917967008 - (-900527 - 133551),
        ["Idle"] = 24865128819885423 % ((1025465472103268524 % 4619213838327693) % 98281145461888),
        ["Climb"] = 121145883950231
    },
    ["Vampire"] = {
        ["Walk"] = 10921326949,
        ["Run"] = 10920540041 - (-535053 - 245205),
        ["Jump"] = (249933608972460 % 1213269961502) % 10930423434 - (-1035376),
        ["Fall"] = 10921321317,
        ["SwimIdle"] = 10921325443,
        ["Swim"] = 10920784731 - (-539677),
        ["Idle"] = 10921315373,
        ["Climb"] = 10921314188
    },
    ["Ninja"] = {
        ["Walk"] = 656121766,
        ["Run"] = 656118852,
        ["Jump"] = 86247059574 % (669485285 - (48518 - (-757535))),
        ["Fall"] = 656115606,
        ["SwimIdle"] = 656121397,
        ["Swim"] = 656119721,
        ["Idle"] = 656117400,
        ["Idle2"] = 656118341,
        ["Climb"] = 656114359
    },
    ["Robot"] = {
        ["Walk"] = 616934459 - (-811303 + (187892013 % 1056573 - (-771840))),
        ["Run"] = 616461183 - (39291 + 330322),
        ["Jump"] = 616090535,
        ["Fall"] = 616087089,
        ["SwimIdle"] = 71985462123 % (626401862 - 354774),
        ["Swim"] = (180922 + 104322722968) % 632358603,
        ["Idle"] = 616088211,
        ["Idle2"] = 616089559,
        ["Climb"] = 616086039
    },
    ["Levitation"] = {
        ["Walk"] = 616013216,
        ["Run"] = 616010382,
        ["Jump"] = 615583726 - (-425210),
        ["Fall"] = 616005863,
        ["SwimIdle"] = (192609 + 187353) + 615632491,
        ["Swim"] = 616011509,
        ["Idle"] = 615358898 - (-647880),
        ["Idle2"] = 615386980 - (-621107),
        ["Climb"] = 616003713
    },
    ["Stylish"] = {
        ["Walk"] = 615116551 - (-1029626),
        ["Run"] = 616140816,
        ["Jump"] = ((762007 + -63518) + 121429) + 615319533,
        ["Fall"] = 616134815,
        ["SwimIdle"] = 616144772,
        ["Swim"] = 616143378,
        ["Idle"] = 68269757352 % (158170581168 % 630199623),
        ["Idle2"] = 88340954963 % (-678380 + 618458778),
        ["Climb"] = (-1108221 - (-836804)) + 616405011
    },
    ["Bubbly"] = {
        ["Walk"] = (23958787949 - 948579) % 921912180,
        ["Run"] = 910025107,
        ["Jump"] = 910016857,
        ["Fall"] = 909248280 - ((-786676 + (141983 + 532760)) + -641697),
        ["SwimIdle"] = 910030921,
        ["Swim"] = ((-444981 - (-21798)) - (-639666)) + (-279546 + 910091221),
        ["Idle"] = 910004836,
        ["Idle2"] = 910009958,
        ["Climb"] = 909997997
    },
    ["Cartoon"] = {
        ["Walk"] = 742640026,
        ["Run"] = 742040605 - (-598237),
        ["Jump"] = 742637942,
        ["Fall"] = 742637151,
        ["SwimIdle"] = 742639812,
        ["Swim"] = 742639220,
        ["Idle"] = 742298308 - (-291703 - 47533),
        ["Idle2"] = (489294 + -1265686) + (742874937 - (-539900)),
        ["Climb"] = (1010050 + 740812835) - (-814004)
    }
}
local function q0()
    local q = E["Character"]
    if not q then
        return
    end
    local o = q:FindFirstChildOfClass("Humanoid")
    if not o then
        return
    end
    for q, o in pairs(o:GetPlayingAnimationTracks()) do
        o:Stop(1308118248 % 12112206)
        o:Destroy()
    end
    local R = o:FindFirstChildOfClass("Animator")
    if R then
        for q, o in pairs(R:GetPlayingAnimationTracks()) do
            o:Stop((1511464474 % 6801693 - 920244) + -568384)
            o:Destroy()
        end
    end
    task["wait"](.1)
end
local o0 = nil
local R0 = nil
local function s0(q)
    if not q then
        return
    end
    local o = E["Character"]
    if not o then
        return
    end
    q0()
    local R = o:FindFirstChild("Animate")
    if not R then
        return
    end
    if not R0 then
        local function q(q, o)
            local s = R:FindFirstChild(q)
            if s then
                local q = s:FindFirstChild(o)
                if q and q:IsA("Animation") then
                    local o = q["AnimationId"]:match("%d+")
                    if o then
                        return tonumber(o)
                    end
                end
            end
            return nil
        end
        R0 = {
            ["Idle"] = q("idle", "Animation1") or 507766666,
            ["Idle2"] = q("idle", "Animation2") or 507052342 - (278201 + -992810),
            ["Walk"] = q("walk", "WalkAnim") or (4326384554643 % 28651603583 - (-1211704 - (-337836))) % 511583877,
            ["Run"] = q("run", "RunAnim") or -509179314,
            ["Jump"] = q("jump", "JumpAnim") or 507765000,
            ["Climb"] = q("climb", "ClimbAnim") or -508971152,
            ["Fall"] = q("fall", "FallAnim") or 507767968,
            ["Swim"] = q("swim", "Swim") or 98895014803 % (521582555 - (-1005033 + 2020234)),
            ["SwimIdle"] = q("swimidle", "SwimIdle") or (889889 - 130706303 % 940371) + 507830288
        }
    end
    R["Disabled"] = true
    task["wait"](.1)
    local function s(q, o, s)
        if not s then
            return
        end
        local A = R:FindFirstChild(q)
        if A then
            local q = A:FindFirstChild(o)
            if q and q:IsA("Animation") then
                q["AnimationId"] = "rbxassetid://" .. tostring(s)
            end
        end
    end
    s("idle", "Animation1", q["Idle"])
    s("idle", "Animation2", q["Idle2"] or q["Idle"])
    s("walk", "WalkAnim", q["Walk"])
    s("run", "RunAnim", q["Run"])
    s("jump", "JumpAnim", q["Jump"])
    s("climb", "ClimbAnim", q["Climb"])
    s("fall", "FallAnim", q["Fall"])
    s("swim", "Swim", q["Swim"])
    s("swimidle", "SwimIdle", q["SwimIdle"] or q["Swim"])
    task["wait"](.1)
    R["Disabled"] = false
    local A = o:FindFirstChildOfClass("Humanoid")
    if A then
        A:ChangeState(Enum["HumanoidStateType"]["Landed"])
        task["wait"](.05)
        A:ChangeState(Enum["HumanoidStateType"]["Running"])
    end
end
task["spawn"](
    function()
        while task["wait"](719867 + -719866) do
            if o0 then
                local q = E["Character"]
                if q then
                    local o = q:FindFirstChild("Animate")
                    if o then
                        local q = o:FindFirstChild("idle")
                        if q then
                            local o = q:FindFirstChild("Animation1")
                            if o then
                                local q = o["AnimationId"]:match("%d+")
                                if q ~= tostring(o0["Idle"]) then
                                    s0(o0)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
)
local A0 = {"Ninguno"}
for q, o in pairs(mK) do
    table["insert"](A0, q)
end
table["sort"](A0)
J9["Emotes"]:Section({["Title"] = "Paquetes Completos"})
local z0 = "Ninguno"
J9["Emotes"]:Dropdown(
    {["Title"] = "Elegir Paquete", ["Values"] = A0, ["Value"] = "Ninguno", ["Callback"] = function(q)
            z0 = q
        end}
)
J9["Emotes"]:Button(
    {
        ["Title"] = "Aplicar Paquete Completo",
        ["Callback"] = function()
            if z0 == "Ninguno" then
                return
            end
            task["spawn"](
                function()
                    z9("Aplicando paquete: " .. z0)
                    o0 = mK[z0]
                    s0(o0)
                end
            )
        end
    }
)
J9["Emotes"]:Button(
    {
        ["Title"] = "Restaurar Default",
        ["Callback"] = function()
            task["spawn"](
                function()
                    local q =
                        R0 or
                        {
                            ["Idle"] = 507766666,
                            ["Idle2"] = 507766951,
                            ["Walk"] = 507777826,
                            ["Run"] = 35148336554 % (113764622154 % 524329639),
                            ["Jump"] = (36246901776 - (-554414)) % 510567017,
                            ["Climb"] = 507765644,
                            ["Fall"] = 86013335282 % (96946828189 % 518450185),
                            ["Swim"] = (807302 + 506333968) - (-304516 + -339111),
                            ["SwimIdle"] = 507785072
                        }
                    o0 = nil
                    s0(q)
                    z9("Animaciones de tu avatar restauradas.")
                end
            )
        end
    }
)
J9["Emotes"]:Section({["Title"] = "Mezclador de Animaciones"})
local b0 = {
    ["Idle"] = "Ninguno",
    ["Walk"] = "Ninguno",
    ["Run"] = "Ninguno",
    ["Jump"] = "Ninguno",
    ["Fall"] = "Ninguno",
    ["Climb"] = "Ninguno"
}
J9["Emotes"]:Dropdown(
    {["Title"] = "Reposo", ["Values"] = A0, ["Value"] = "Ninguno", ["Callback"] = function(q)
            b0["Idle"] = q
        end}
)
J9["Emotes"]:Dropdown(
    {["Title"] = "Caminar", ["Values"] = A0, ["Value"] = "Ninguno", ["Callback"] = function(q)
            b0["Walk"] = q
        end}
)
J9["Emotes"]:Dropdown(
    {["Title"] = "Correr", ["Values"] = A0, ["Value"] = "Ninguno", ["Callback"] = function(q)
            b0["Run"] = q
        end}
)
J9["Emotes"]:Dropdown(
    {["Title"] = "Saltar)", ["Values"] = A0, ["Value"] = "Ninguno", ["Callback"] = function(q)
            b0["Jump"] = q
        end}
)
J9["Emotes"]:Dropdown(
    {["Title"] = "Caer", ["Values"] = A0, ["Value"] = "Ninguno", ["Callback"] = function(q)
            b0["Fall"] = q
        end}
)
J9["Emotes"]:Dropdown(
    {["Title"] = "Escalar", ["Values"] = A0, ["Value"] = "Ninguno", ["Callback"] = function(q)
            b0["Climb"] = q
        end}
)
J9["Emotes"]:Button(
    {
        ["Title"] = "Combinar y Aplicar",
        ["Callback"] = function()
            task["spawn"](
                function()
                    local q = {}
                    if b0["Idle"] ~= "Ninguno" then
                        q["Idle"] = mK[b0["Idle"]]["Idle"]
                        q["Idle2"] = mK[b0["Idle"]]["Idle2"]
                    end
                    if b0["Walk"] ~= "Ninguno" then
                        q["Walk"] = mK[b0["Walk"]]["Walk"]
                    end
                    if b0["Run"] ~= "Ninguno" then
                        q["Run"] = mK[b0["Run"]]["Run"]
                    end
                    if b0["Jump"] ~= "Ninguno" then
                        q["Jump"] = mK[b0["Jump"]]["Jump"]
                    end
                    if b0["Fall"] ~= "Ninguno" then
                        q["Fall"] = mK[b0["Fall"]]["Fall"]
                    end
                    if b0["Climb"] ~= "Ninguno" then
                        q["Climb"] = mK[b0["Climb"]]["Climb"]
                    end
                    local o = false
                    for q, R in pairs(q) do
                        if R then
                            o = true
                            break
                        end
                    end
                    if o then
                        z9("Aplicando combinaciÃ³n de animaciones...")
                        o0 = q
                        s0(o0)
                    else
                        z9("Selecciona al menos una animaciÃ³n para combinar.")
                    end
                end
            )
        end
    }
)
J9["Config"]:Section({["Title"] = "PersonalizaciÃ³n de Interfaz"})
local P0 = {
    "Midnight",
    "Dark",
    "Rose",
    "Emerald",
    "Sky",
    "Violet",
    "Amber",
    "Crimson",
    "Monokai Pro",
    "Cotton Candy",
    "Light",
    "Mellowsi",
    "Rainbow",
    "Indigo",
    "Red",
    "Plant"
}
local J0 = false
J9["Config"]:Dropdown(
    {
        ["Title"] = "Tema de la Interfaz",
        ["Values"] = P0,
        ["Value"] = "Red",
        ["Callback"] = function(q)
            pcall(
                function()
                    o9:SetTheme(q)
                    if J0 then
                        z9("Tema aplicado: " .. q)
                    end
                    J0 = true
                end
            )
        end
    }
)
J9["Config"]:Toggle(
    {
        ["Title"] = "Ocultar BotÃ³n Flotante",
        ["Callback"] = function(q)
            local o = {E:FindFirstChild("PlayerGui")}
            pcall(
                function()
                    table["insert"](o, game:GetService("CoreGui"))
                end
            )
            for o, R in ipairs(o) do
                if R then
                    for o, R in pairs(R:GetDescendants()) do
                        if
                            (R:IsA("TextLabel") or R:IsA("TextButton")) and
                                (R["Text"] and string["find"](R["Text"], "Open OnyxHub"))
                         then
                            local o = R
                            while o["Parent"] and (not o["Parent"]:IsA("ScreenGui") and not o["Parent"]:IsA("Folder")) do
                                o = o["Parent"]
                            end
                            if o:IsA("CanvasGroup") then
                                o["GroupTransparency"] =
                                    q and -491931 or
                                    855483615 %
                                        (5197724 -
                                            (((1084390917 % (3704928455 % 27345901 - 12538) - 945009) + 136915) +
                                                -303862))
                            else
                                local function R(o)
                                    if o:IsA("UIStroke") then
                                        if not o:GetAttribute("OrigTrans") then
                                            o:SetAttribute("OrigTrans", o["Transparency"])
                                        end
                                        o["Transparency"] =
                                            q and (215803 - 519071) - (1047348 + -1350617) or
                                            o:GetAttribute("OrigTrans")
                                    elseif o:IsA("TextLabel") or o:IsA("TextButton") then
                                        if not o:GetAttribute("OrigTxtTrans") then
                                            o:SetAttribute("OrigTxtTrans", o["TextTransparency"])
                                        end
                                        o["TextTransparency"] = q and 1 or o:GetAttribute("OrigTxtTrans")
                                        if not o:GetAttribute("OrigBgTrans") then
                                            o:SetAttribute("OrigBgTrans", o["BackgroundTransparency"])
                                        end
                                        o["BackgroundTransparency"] = q and -1040005 or o:GetAttribute("OrigBgTrans")
                                    elseif o:IsA("Frame") or o:IsA("ImageLabel") or o:IsA("ImageButton") then
                                        if not o:GetAttribute("OrigBgTrans") then
                                            o:SetAttribute("OrigBgTrans", o["BackgroundTransparency"])
                                        end
                                        o["BackgroundTransparency"] =
                                            q and (-714968 - (-927163)) - 212194 or o:GetAttribute("OrigBgTrans")
                                        pcall(
                                            function()
                                                if not o:GetAttribute("OrigImgTrans") then
                                                    o:SetAttribute("OrigImgTrans", o["ImageTransparency"])
                                                end
                                                o["ImageTransparency"] = q and 1 or o:GetAttribute("OrigImgTrans")
                                            end
                                        )
                                    end
                                end
                                for q, o in pairs(o:GetDescendants()) do
                                    R(o)
                                end
                                R(o)
                            end
                        end
                    end
                end
            end
        end
    }
)
J9["Config"]:Toggle(
    {
        ["Title"] = "Botones Flotantes Invisibles",
        ["Desc"] = "Oculta la posicion de los botones.",
        ["Value"] = false,
        ["Callback"] = function(q)
            _G["AstraBotonesOcultos"] = q
            local o = q and 1 or .3
            local R = q and 1 or 0
            local s = q and 1 or 0.5
            for q, A in ipairs(QK) do
                if A then
                    A["BackgroundTransparency"] = o
                    A["TextTransparency"] = R
                    local q = A:FindFirstChildOfClass("UIStroke")
                    if q then
                        q["Transparency"] = s
                    end
                end
            end
        end
    }
)
J9["Config"]:Section({["Title"] = "Gestor de Configs"})
local W0 = "OnyxHub_Configs_Duels_WindUI"
if isfolder and not isfolder(W0) then
    pcall(
        function()
            makefolder(W0)
        end
    )
end
local E0 = {"Ninguna"}
local L0 = "Ninguna"
local T0 = ""
local X0 =
    J9["Config"]:Dropdown(
    {["Title"] = "Seleccionar ConfiguraciÃ³n", ["Values"] = E0, ["Value"] = "Ninguna", ["Callback"] = function(q)
            L0 = q
        end}
)
local function c0()
    local q = {}
    if listfiles then
        pcall(
            function()
                for o, R in ipairs(listfiles(W0)) do
                    if R:match("%.json$") then
                        local o = R:match("([^/\\]+)%.json$")
                        if o then
                            table["insert"](q, o)
                        end
                    end
                end
            end
        )
    end
    if #q == (1847683615 - ((-727259 + 1122802) - 956330)) % (9851027 - 323994) then
        table["insert"](q, "Ninguna")
    end
    pcall(
        function()
            X0:Refresh(q)
            if L0 == "Ninguna" or not table["find"](q, L0) then
                X0:Select(q[-827529 - (-827530)])
                L0 = q[1]
            end
        end
    )
end
J9["Config"]:Button(
    {["Title"] = "Actualizar Lista", ["Callback"] = function()
            c0()
            z9("Lista de configuraciones actualizada.")
        end}
)
J9["Config"]:Input(
    {["Title"] = "Nombre para Guardar ", ["Placeholder"] = "Ej: Config 1, Config 2...", ["Callback"] = function(q)
            T0 = q
        end}
)
J9["Config"]:Button(
    {
        ["Title"] = "Guardar ConfiguraciÃ³n",
        ["Callback"] = function()
            task["wait"](.1)
            local q = T0:gsub("[^%w%s%-]", "")
            if q == "" then
                q = L0
            end
            if q == "" or q == "Ninguna" then
                z9(" Escribe un nombre vÃ¡lido o selecciona una config para sobreescribir.")
                return
            end
            local o = W0 .. ("/" .. (q .. ".json"))
            local R = {
                ["ConfigName"] = q,
                ["Toggles"] = {
                    ["Auto Shoot"] = d,
                    ["AutoShoot Cuchillo"] = C9,
                    ["Silent Aim (Manual)"] = m9,
                    ["Silent Aim (FOV)"] = oK,
                    ["Mostrar CÃ­rculo FOV"] = X,
                    ["ESP Lineas"] = tK,
                    ["Btn Flotante AutoShoot"] = OK["Visible"],
                    ["Btn Flotante SilentAim"] = xK["Visible"],
                    ["Btn Flotante Fantasma"] = HK["Visible"],
                    ["Aumentar Hitbox"] = zK,
                    ["Hitbox Invisible"] = bK,
                    ["ESP Jugadores"] = k,
                    ["Mostrar Resplandor (Glow)"] = D["Glow"],
                    ["Mostrar Nombre"] = D["Name"],
                    ["Mostrar Vida"] = D["Health"],
                    ["Mostrar Distancia"] = D["Distance"],
                    ["Emote Walk (Bailar al caminar)"] = l,
                    ["Ocultar mi Nombre (Local)"] = F,
                    ["Fly (Volar)"] = S,
                    ["Enemies TP"] = magnetTpEnabled,
                    ["FPS Boost"] = y9
                },
                ["Sliders"] = {
                    ["TamaÃ±o del FOV"] = c,
                    ["TamaÃ±o de Hitbox"] = PK,
                    ["Velocidad de Vuelo"] = H,
                    ["Delay Equipar Macro"] = S9,
                    ["Delay Disparo Macro"] = H9
                },
                ["Colors"] = {
                    ["Color de Hitbox"] = {["R"] = a["R"], ["G"] = a["G"], ["B"] = a["B"]},
                    ["Color del ESP"] = {["R"] = r["R"], ["G"] = r["G"], ["B"] = r["B"]}
                },
                ["Extras"] = {["Parte Aimbot"] = qK, ["Parte AutoShoot"] = u9},
                ["Animaciones"] = {["Paquete"] = z0, ["Mix"] = b0}
            }
            if writefile then
                local s, A =
                    pcall(
                    function()
                        return b:JSONEncode(R)
                    end
                )
                if s then
                    pcall(
                        function()
                            writefile(o, A)
                        end
                    )
                    z9(" Guardado como: " .. q)
                    c0()
                    pcall(
                        function()
                            X0:Select(q)
                        end
                    )
                else
                    z9(" Error interno al procesar los datos.")
                end
            else
                z9(" Error: Tu ejecutor no soporta guardar")
            end
        end
    }
)
local function G0(q, o)
    if not q or o == nil then
        return
    end
    pcall(
        function()
            q:Set(o)
        end
    )
end
J9["Config"]:Button(
    {
        ["Title"] = " Cargar ConfiguraciÃ³n",
        ["Callback"] = function()
            if L0 == "Ninguna" or L0 == "" then
                z9("No hay ninguna configuraciÃ³n seleccionada.")
                return
            end
            local q = W0 .. ("/" .. (L0 .. ".json"))
            if isfile and isfile(q) then
                local o, R =
                    pcall(
                    function()
                        return b:JSONDecode(readfile(q))
                    end
                )
                if o and type(R) == "table" then
                    if R["Toggles"] then
                        if R["Toggles"]["Auto Shoot"] ~= nil then
                            d = R["Toggles"]["Auto Shoot"]
                            G0(C["TogAutoShoot"], d)
                        end
                        if R["Toggles"]["AutoShoot Cuchillo"] ~= nil then
                            C9 = R["Toggles"]["AutoShoot Cuchillo"]
                            G0(C["TogAutoShootCuchillo"], C9)
                        end
                        if R["Toggles"]["Silent Aim (Manual)"] ~= nil then
                            m9 = R["Toggles"]["Silent Aim (Manual)"]
                            G0(C["TogSilentAimManual"], m9)
                        end
                        if R["Toggles"]["Silent Aim (FOV)"] ~= nil then
                            oK = R["Toggles"]["Silent Aim (FOV)"]
                            G0(C["TogSilentAimFOV"], oK)
                        end
                        if R["Toggles"]["Mostrar CÃ­rculo FOV"] ~= nil then
                            X = R["Toggles"]["Mostrar CÃ­rculo FOV"]
                            G0(C["TogShowFOV"], X)
                        end
                        if R["Toggles"]["ESP Lineas"] ~= nil then
                            tK = R["Toggles"]["ESP Lineas"]
                            G0(C["TogEspLines"], tK)
                        end
                        if R["Toggles"]["Btn Flotante AutoShoot"] ~= nil then
                            G0(C["ToggleAsBtn"], R["Toggles"]["Btn Flotante AutoShoot"])
                        end
                        if R["Toggles"]["Btn Flotante SilentAim"] ~= nil then
                            G0(C["ToggleSaBtn"], R["Toggles"]["Btn Flotante SilentAim"])
                        end
                        if R["Toggles"]["Btn Flotante Fantasma"] ~= nil then
                            G0(C["ToggleGhost"], R["Toggles"]["Btn Flotante Fantasma"])
                        end
                        if R["Toggles"]["Aumentar Hitbox"] ~= nil then
                            zK = R["Toggles"]["Aumentar Hitbox"]
                            G0(C["TogHitbox"], zK)
                        end
                        if R["Toggles"]["Hitbox Invisible"] ~= nil then
                            bK = R["Toggles"]["Hitbox Invisible"]
                            G0(C["TogHbInv"], bK)
                        end
                        if R["Toggles"]["ESP Jugadores"] ~= nil then
                            k = R["Toggles"]["ESP Jugadores"]
                            G0(C["TogEsp"], k)
                        end
                        if R["Toggles"]["Mostrar Resplandor (Glow)"] ~= nil then
                            D["Glow"] = R["Toggles"]["Mostrar Resplandor (Glow)"]
                            G0(C["TogEspGl"], D["Glow"])
                        end
                        if R["Toggles"]["Mostrar Nombre"] ~= nil then
                            D["Name"] = R["Toggles"]["Mostrar Nombre"]
                            G0(C["TogEspNm"], D["Name"])
                        end
                        if R["Toggles"]["Mostrar Vida"] ~= nil then
                            D["Health"] = R["Toggles"]["Mostrar Vida"]
                            G0(C["TogEspHp"], D["Health"])
                        end
                        if R["Toggles"]["Mostrar Distancia"] ~= nil then
                            D["Distance"] = R["Toggles"]["Mostrar Distancia"]
                            G0(C["TogEspDs"], D["Distance"])
                        end
                        if R["Toggles"]["Emote Walk (Bailar al caminar)"] ~= nil then
                            l = R["Toggles"]["Emote Walk (Bailar al caminar)"]
                            G0(C["TogEmoteWalk"], l)
                        end
                        if R["Toggles"]["Ocultar mi Nombre (Local)"] ~= nil then
                            F = R["Toggles"]["Ocultar mi Nombre (Local)"]
                            G0(C["TogHideName"], F)
                        end
                        if R["Toggles"]["Fly (Volar)"] ~= nil then
                            S = R["Toggles"]["Fly (Volar)"]
                            G0(C["TogFly"], S)
                        end
                        if R["Toggles"]["Enemies TP"] ~= nil then
                            magnetTpEnabled = R["Toggles"]["Enemies TP"]
                            G0(C["TogIman"], magnetTpEnabled)
                        end
                        if R["Toggles"]["FPS Boost"] ~= nil then
                            y9 = R["Toggles"]["FPS Boost"]
                            G0(C["ToggleFPS"], y9)
                        end
                    end
                    if R["Sliders"] then
                        if R["Sliders"]["TamaÃ±o del FOV"] ~= nil then
                            c = R["Sliders"]["TamaÃ±o del FOV"]
                            G0(C["SliFOVSize"], c)
                        end
                        if R["Sliders"]["TamaÃ±o de Hitbox"] ~= nil then
                            PK = R["Sliders"]["TamaÃ±o de Hitbox"]
                            G0(C["SliHitbox"], PK)
                        end
                        if R["Sliders"]["Velocidad de Vuelo"] ~= nil then
                            H = R["Sliders"]["Velocidad de Vuelo"]
                            G0(C["SliFly"], H)
                        end
                        if R["Sliders"]["Delay Equipar Macro"] ~= nil then
                            S9 = R["Sliders"]["Delay Equipar Macro"]
                            G0(C["SliMacroEquip"], S9)
                        end
                        if R["Sliders"]["Delay Disparo Macro"] ~= nil then
                            H9 = R["Sliders"]["Delay Disparo Macro"]
                            G0(C["SliMacroShoot"], H9)
                        end
                    end
                    if R["Colors"] then
                        if R["Colors"]["Color de Hitbox"] then
                            local q =
                                Color3["new"](
                                R["Colors"]["Color de Hitbox"]["R"],
                                R["Colors"]["Color de Hitbox"]["G"],
                                R["Colors"]["Color de Hitbox"]["B"]
                            )
                            a = q
                            G0(C["ColHitbox"], q)
                        end
                        if R["Colors"]["Color del ESP"] then
                            local q =
                                Color3["new"](
                                R["Colors"]["Color del ESP"]["R"],
                                R["Colors"]["Color del ESP"]["G"],
                                R["Colors"]["Color del ESP"]["B"]
                            )
                            r = q
                            G0(C["ColEsp"], q)
                        end
                    end
                    if R["Extras"] and R["Extras"]["Parte Aimbot"] then
                        qK = R["Extras"]["Parte Aimbot"]
                        if C["DropSilentAimPart"] then
                            pcall(
                                function()
                                    C["DropSilentAimPart"]:Select(qK)
                                end
                            )
                        end
                    end
                    if R["Extras"] and R["Extras"]["Parte AutoShoot"] then
                        u9 = R["Extras"]["Parte AutoShoot"]
                        if C["DropAutoShootPart"] then
                            pcall(
                                function()
                                    C["DropAutoShootPart"]:Select(u9)
                                end
                            )
                        end
                    end
                    if R["Animaciones"] then
                        task["spawn"](
                            function()
                                task["wait"]((-255906 + 1003670229) % 13559653)
                                if R["Animaciones"]["Paquete"] and R["Animaciones"]["Paquete"] ~= "Ninguno" then
                                    z0 = R["Animaciones"]["Paquete"]
                                    s0(mK[z0])
                                elseif R["Animaciones"]["Mix"] then
                                    b0 = R["Animaciones"]["Mix"]
                                    local q = {}
                                    if b0["Idle"] ~= "Ninguno" then
                                        q["Idle"] = mK[b0["Idle"]]["Idle"]
                                        q["Idle2"] = mK[b0["Idle"]]["Idle2"]
                                    end
                                    if b0["Walk"] ~= "Ninguno" then
                                        q["Walk"] = mK[b0["Walk"]]["Walk"]
                                    end
                                    if b0["Run"] ~= "Ninguno" then
                                        q["Run"] = mK[b0["Run"]]["Run"]
                                    end
                                    if b0["Jump"] ~= "Ninguno" then
                                        q["Jump"] = mK[b0["Jump"]]["Jump"]
                                    end
                                    if b0["Fall"] ~= "Ninguno" then
                                        q["Fall"] = mK[b0["Fall"]]["Fall"]
                                    end
                                    if b0["Climb"] ~= "Ninguno" then
                                        q["Climb"] = mK[b0["Climb"]]["Climb"]
                                    end
                                    local o = false
                                    for q, R in pairs(q) do
                                        if R then
                                            o = true
                                            break
                                        end
                                    end
                                    if o then
                                        s0(q)
                                    end
                                end
                            end
                        )
                    end
                    z9("'" .. (L0 .. "' cargada con Ã©xito."))
                else
                    z9("Error al leer el archivo.")
                end
            else
                z9("La configuraciÃ³n no existe.")
            end
        end
    }
)
task["spawn"](
    function()
        task["wait"](153944612 % 4948099 + -553542)
        c0()
    end
)
local f0 = nil
local function t0()
    if F9() then
        return nil
    end
    local o = E:GetAttribute("Map")
    local R = E:GetAttribute("Game")
    for q, s in ipairs(q:GetPlayers()) do
        if s ~= E and p9(s) then
            local q = s["Character"]
            local A = q and q:FindFirstChildOfClass("Humanoid")
            local z = q and q:FindFirstChild("HumanoidRootPart")
            if
                A and
                    (A["Health"] > (-143173 - (-31203 + -605623)) - 493653 and
                        (z and (s:GetAttribute("Map") == o and s:GetAttribute("Game") == R)))
             then
                return z
            end
        end
    end
    return nil
end
local function i0()
    if F9() then
        return
    end
    local o = E:GetAttribute("Map")
    local R = E:GetAttribute("Game")
    for q, s in ipairs(q:GetPlayers()) do
        if s ~= E and (p9(s) and (s:GetAttribute("Map") == o and (s:GetAttribute("Game") == R and s["Character"]))) then
            local q = s["Character"]:FindFirstChild("HumanoidRootPart")
            local o = s["Character"]:FindFirstChild("Humanoid")
            if q and (o and o["Health"] > 603028 - 603028) then
                pcall(
                    function()
                        q["Size"] =
                            Vector3["new"](
                            (-401662 - ((178243 - 881185) - (-450511))) + 149241,
                            (347626 - (((-170047 + -1681911) - (-651436)) - (-601121 + -76604))) + (-151608 + -718805),
                            115057 + -115047
                        )
                        q["Transparency"] = .8
                        q["CanCollide"] = false
                    end
                )
            end
        end
    end
end
function ejecutarBucleKillAll()
    if f0 then
        return
    end
    task["spawn"](
        function()
            f0 = true
            while e do
                task["wait"](.05)
                if e and not F9() then
                    i0()
                    local o = nil
                    if p and p["Parent"] then
                        local R = p["Parent"]:FindFirstChildOfClass("Humanoid")
                        local s = q:GetPlayerFromCharacter(p["Parent"])
                        local A = E:GetAttribute("Map")
                        local z = E:GetAttribute("Game")
                        if
                            R and
                                (R["Health"] > 0 and
                                    (s and (s:GetAttribute("Map") == A and s:GetAttribute("Game") == z)))
                         then
                            o = p
                        end
                    end
                    if not o then
                        o = t0()
                        p = o
                    end
                    if o then
                        local q = E["Character"]
                        if q and q:FindFirstChild("HumanoidRootPart") then
                            local R = q["HumanoidRootPart"]
                            local s = E:FindFirstChildOfClass("Backpack")
                            local A = q:FindFirstChildOfClass("Tool") or (s and s:FindFirstChildOfClass("Tool"))
                            if A then
                                if A["Parent"] == s then
                                    A["Parent"] = q
                                    task["wait"](.02)
                                end
                                local z = A:FindFirstChild("Handle")
                                local b =
                                    A:FindFirstChild("Kill") or (z and z:FindFirstChild("Kill")) or
                                    A:FindFirstChild("ThrowKill") or
                                    (z and z:FindFirstChild("ThrowKill"))
                                local P = o["Parent"]:FindFirstChildOfClass("Humanoid")
                                pcall(
                                    function()
                                        local q = R["CFrame"]
                                        R["CFrame"] =
                                            CFrame["new"](
                                            o["Position"] +
                                                Vector3["new"](
                                                    234795 + (963320 + (1919782155 % (7813364 - (-949753)) + -1857647)),
                                                    0,
                                                    4171175708.0 %
                                                        ((5996399979.5 - 1011796828 % 10008215) %
                                                            (27697735.5 - (-504840)))
                                                ),
                                            o["Position"]
                                        )
                                        if P and P["Health"] > -614552 - (-13718 + -600834) then
                                            if b and b:IsA("RemoteEvent") then
                                                b:FireServer(P)
                                            end
                                            A:Activate()
                                        else
                                            R["CFrame"] = q
                                            p = nil
                                        end
                                    end
                                )
                            end
                        end
                    else
                        p = nil
                    end
                else
                    p = nil
                end
            end
            f0 = nil
        end
    )
end
J9["Farm"]:Section({["Title"] = "Opciones de RecolecciÃ³n"})
J9["Farm"]:Toggle(
    {
        ["Title"] = "Auto Farm",
        ["Value"] = false,
        ["Callback"] = function(q)
            J = q
            if J and not W then
                W = true
                task["spawn"](
                    function()
                        local q = P:WaitForChild("SpawnablesClient")
                        while J do
                            for q, o in ipairs(q:GetChildren()) do
                                if not J then
                                    break
                                end
                                local R = o:FindFirstChild("Touch")
                                if R and (E["Character"] and E["Character"]:FindFirstChild("HumanoidRootPart")) then
                                    pcall(
                                        function()
                                            firetouchinterest(E["Character"]["HumanoidRootPart"], R, 751605 - 751605)
                                            firetouchinterest(
                                                E["Character"]["HumanoidRootPart"],
                                                R,
                                                110508 + (-660869 + 550362)
                                            )
                                        end
                                    )
                                end
                            end
                            task["wait"](.45)
                        end
                        W = false
                    end
                )
            end
        end
    }
)
