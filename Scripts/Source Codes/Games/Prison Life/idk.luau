if not Drawing then
    task.wait(1)
    game.Players.LocalPlayer:Kick("Executor not support, use bunni/velocity")
end
if not hookmetamethod then
    task.wait(1)
    game.Players.LocalPlayer:Kick("Executor not support, use bunni/velocity")
end
if not hookfunction then
    task.wait(1)
    game.Players.LocalPlayer:Kick("Executor not support, use bunni/velocity")
end
if not getconnections then
    task.wait(1)
    game.Players.LocalPlayer:Kick("Executor not support, use bunni/velocity")
end
if not setfflag then
    task.wait(1)
    game.Players.LocalPlayer:Kick("Executor not support, use bunni/velocity")
end

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua"))()

local services = {
    Players = game:GetService("Players"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    RunService = game:GetService("RunService"),
    UserInputService = game:GetService("UserInputService"),
    TeleportService = game:GetService("TeleportService"),
    Lighting = game:GetService("Lighting"),
    TweenService = game:GetService("TweenService"),
    Debris = game:GetService("Debris"),
    HttpService = game:GetService("HttpService"),
}
local LocalPlayer = services.Players.LocalPlayer

local function NotifyToggle(name, state)
    Library:Notify(name .. (state and " Enabled" or " Disabled"), 3)
end

local camera = workspace.CurrentCamera
local currentTarget

local remotes = {
    remote = services.ReplicatedStorage:WaitForChild("GunRemotes"):WaitForChild("ShootEvent"),
    arrestremote = services.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("ArrestPlayer"),
    meleeremote = services.ReplicatedStorage:WaitForChild("meleeEvent"),
    tasedremote = services.ReplicatedStorage:WaitForChild("GunRemotes"):WaitForChild("PlayerTased"),
}

local gunarray = {}
local EffectsFolder = workspace:FindFirstChild("Effects") or Instance.new("Folder", workspace)
EffectsFolder.Name = "Effects"

local positionsinfo = {
    ["Armory"] = Vector3.new(826.2001953125, 101.46707153320312, 2294.853759765625),
    ["Inside Prison"] = Vector3.new(915.2999267578125, 101.49960327148438, 2388.000244140625),
    ["Secret Room"] = Vector3.new(701.4503173828125, 101.45552062988281, 2354.30126953125),
    ["Prison Yard"] = Vector3.new(795.7847900390625, 99.6580581665039, 2541.0048828125),
    ["Criminal Base"] = Vector3.new(-975.0344848632812, 109.82368469238281, 2057.951171875),
    ["Prison Car Spawner"] = Vector3.new(598.9443359375, 99.66586303710938, 2504.1630859375),
    ["Prison Kitchen"] = Vector3.new(924.5208129882812, 101.48553466796875, 2227.595947265625)
}

local HitSoundId = {
    Bameware = "3124331820",
    Bell = "6534947240",
    Bubble = "6534947588",
    Pick = "1347140027",
    Pop = "198598793",
    Rust = "1255040462",
    Sans = "3188795283",
    Fart = "130833677",
    Big = "5332005053",
    Vine = "5332680810",
    Bruh = "4578740568",
    Skeet = "5633695679",
    Neverlose = "6534948092",
    Fatality = "6534947869",
    Bonk = "5766898159",
    Minecraft = "4018616850"
}

local Hitsounds = {
    "Bameware", "Bubble", "Pop", "Sans", "Big", "Bruh",
    "Neverlose", "Bell", "Pick", "Rust", "Fart", "Vine",
    "Skeet", "Fatality", "Minecraft"
}

local GunShootSoundId = {
    ["AWP"] = "132602247378058",
    ["Desert Eagle"] = "82286818216627",
    ["Glock"] = "6581933860",
    ["MP40"] = "103807799095792",
    ["Ray Gun"] = "131179973",
    ["Laser"] = "94084778213749",
    ["Tank"] = "138839154527248",
    ["Galaga"] = "3038719943",
    ["Barrett Cal"] = "3383318550",
    ["Pindad SS2"] = "18620503407",
    ["Revolver"] = "120771468205926",
    ["Dart Gun"] = "5924183835",
}

local GunShootSounds = {
    "AWP",
    "Desert Eagle",
    "Glock",
    "MP40",
    "Ray Gun",
    "Laser",
    "Tank",
    "Galaga",
    "Barrett Cal",
    "Pindad SS2",
    "Revolver",
    "Dart Gun",
}

local textures = {
    CIRCLE_TEXTURE = "rbxassetid://243660364",
    STAR_TEXTURE = "rbxassetid://2273224484",
    SMOKE_TEXTURE = "rbxassetid://1084969748"
}

local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude
rayParams.IgnoreWater = true
rayParams.FilterDescendantsInstances = { LocalPlayer.Character }

local function isVisible(tPart, org)
    local result = workspace:Raycast(org, tPart.Position - org, rayParams)
    return (not result) or result.Instance:IsDescendantOf(tPart.Parent)
end

local hitEffects = {}

hitEffects.BloodSplat = function(position)
    local part = Instance.new("Part")
    part.Size = Vector3.new(1, 1, 1)
    part.Anchored = true
    part.CanCollide = false
    part.Position = position
    part.Transparency = 1
    part.CanQuery = false
    part.Parent = workspace

    local emitter = Instance.new("ParticleEmitter")
    emitter.Texture = textures.CIRCLE_TEXTURE
    emitter.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(200, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 0, 0))
    })
    emitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1.5),
        NumberSequenceKeypoint.new(0.3, 1.0),
        NumberSequenceKeypoint.new(1, 0.3)
    })
    emitter.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.6, 0.3),
        NumberSequenceKeypoint.new(1, 1)
    })
    emitter.Speed = NumberRange.new(10, 25)
    emitter.SpreadAngle = Vector2.new(180, 180)
    emitter.Lifetime = NumberRange.new(0.5, 1.0)
    emitter.Acceleration = Vector3.new(0, -50, 0)
    emitter.Drag = 2
    emitter.RotSpeed = NumberRange.new(-180, 180)
    emitter.Rotation = NumberRange.new(0, 360)
    emitter.Rate = 0
    emitter.Parent = part

    local droplets = Instance.new("ParticleEmitter")
    droplets.Texture = textures.CIRCLE_TEXTURE
    droplets.Color = ColorSequence.new(Color3.fromRGB(180, 0, 0))
    droplets.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.8),
        NumberSequenceKeypoint.new(1, 0.2)
    })
    droplets.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.1),
        NumberSequenceKeypoint.new(1, 1)
    })
    droplets.Speed = NumberRange.new(15, 35)
    droplets.SpreadAngle = Vector2.new(120, 120)
    droplets.Lifetime = NumberRange.new(0.3, 0.7)
    droplets.Acceleration = Vector3.new(0, -80, 0)
    droplets.Drag = 1
    droplets.Rate = 0
    droplets.Parent = part

    local mist = Instance.new("ParticleEmitter")
    mist.Texture = textures.SMOKE_TEXTURE
    mist.Color = ColorSequence.new(Color3.fromRGB(150, 0, 0))
    mist.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.5),
        NumberSequenceKeypoint.new(1, 3)
    })
    mist.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.4),
        NumberSequenceKeypoint.new(1, 1)
    })
    mist.Speed = NumberRange.new(2, 6)
    mist.SpreadAngle = Vector2.new(360, 360)
    mist.Lifetime = NumberRange.new(0.4, 0.8)
    mist.Rate = 0
    mist.Parent = part

    local flash = Instance.new("Part")
    flash.Size = Vector3.new(2, 2, 2)
    flash.Shape = Enum.PartType.Ball
    flash.Position = position
    flash.Anchored = true
    flash.CanCollide = false
    flash.Material = Enum.Material.Neon
    flash.Color = Color3.fromRGB(255, 0, 0)
    flash.Transparency = 0.3
    flash.CanQuery = false
    flash.Parent = workspace

    local flashTween = services.TweenService:Create(
        flash,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        { Size = Vector3.new(4, 4, 4), Transparency = 1 }
    )
    flashTween:Play()
    flashTween.Completed:Connect(function()
        flash:Destroy()
    end)

    emitter:Emit(50)
    droplets:Emit(30)
    mist:Emit(20)
    services.Debris:AddItem(part, 2)
end

hitEffects.ElectricBurst = function(position)
    local part = Instance.new("Part")
    part.Size = Vector3.new(0.5, 0.5, 0.5)
    part.Anchored = true
    part.CanCollide = false
    part.Position = position
    part.Transparency = 1
    part.CanQuery = false
    part.Parent = workspace

    local core = Instance.new("Part")
    core.Size = Vector3.new(1, 1, 1)
    core.Shape = Enum.PartType.Ball
    core.Position = position
    core.Anchored = true
    core.CanCollide = false
    core.Material = Enum.Material.Neon
    core.Color = Color3.fromRGB(100, 200, 255)
    core.Transparency = 0
    core.CanQuery = false
    core.Parent = workspace

    local coreLight = Instance.new("PointLight")
    coreLight.Brightness = 2.5
    coreLight.Range = 15
    coreLight.Color = Color3.fromRGB(100, 200, 255)
    coreLight.Parent = core

    local electric = Instance.new("ParticleEmitter")
    electric.Texture = textures.STAR_TEXTURE
    electric.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 240, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 180, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 100, 255))
    })
    electric.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.4),
        NumberSequenceKeypoint.new(0.5, 0.2),
        NumberSequenceKeypoint.new(1, 0)
    })
    electric.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.7, 0.3),
        NumberSequenceKeypoint.new(1, 1)
    })
    electric.LightEmission = 1
    electric.LightInfluence = 0
    electric.Speed = NumberRange.new(20, 40)
    electric.SpreadAngle = Vector2.new(360, 360)
    electric.Lifetime = NumberRange.new(0.1, 0.3)
    electric.Drag = 5
    electric.Rate = 0
    electric.Parent = part

    local bolts = Instance.new("ParticleEmitter")
    bolts.Texture = textures.CIRCLE_TEXTURE
    bolts.Color = ColorSequence.new(Color3.fromRGB(220, 240, 255))
    bolts.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.15),
        NumberSequenceKeypoint.new(1, 0.05)
    })
    bolts.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    bolts.LightEmission = 1
    bolts.Speed = NumberRange.new(30, 50)
    bolts.SpreadAngle = Vector2.new(360, 360)
    bolts.Lifetime = NumberRange.new(0.05, 0.15)
    bolts.Rate = 0
    bolts.Parent = part

    for _ = 1, 6 do
        local beam = Instance.new("Part")
        beam.Size = Vector3.new(0.1, 0.1, math.random(3, 6))
        beam.CFrame = CFrame.new(position) * CFrame.Angles(math.random() * math.pi * 2, math.random() * math.pi * 2, 0)
        beam.Anchored = true
        beam.CanCollide = false
        beam.Material = Enum.Material.Neon
        beam.Color = Color3.fromRGB(150, 220, 255)
        beam.Transparency = 0.2
        beam.CanQuery = false
        beam.Parent = workspace

        local beamTween = services.TweenService:Create(
            beam,
            TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            { Transparency = 1, Size = Vector3.new(0.05, 0.05, beam.Size.Z + 2) }
        )
        beamTween:Play()
        beamTween.Completed:Connect(function()
            beam:Destroy()
        end)
    end

    local coreTween = services.TweenService:Create(
        core,
        TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        { Size = Vector3.new(3, 3, 3), Transparency = 1 }
    )
    local lightTween = services.TweenService:Create(coreLight, TweenInfo.new(0.25), { Brightness = 0 })
    coreTween:Play()
    lightTween:Play()
    coreTween.Completed:Connect(function()
        core:Destroy()
    end)

    electric:Emit(70)
    bolts:Emit(40)
    services.Debris:AddItem(part, 1)
end

hitEffects.Shockwave = function(position)
    local sphere = Instance.new("Part")
    sphere.Shape = Enum.PartType.Ball
    sphere.Size = Vector3.new(1, 1, 1)
    sphere.CFrame = CFrame.new(position)
    sphere.Anchored = true
    sphere.CanCollide = false
    sphere.Transparency = 0.4
    sphere.Material = Enum.Material.ForceField
    sphere.Color = Color3.fromRGB(255, 220, 50)
    sphere.CanQuery = false
    sphere.Parent = workspace

    local innerSphere = Instance.new("Part")
    innerSphere.Shape = Enum.PartType.Ball
    innerSphere.Size = Vector3.new(0.5, 0.5, 0.5)
    innerSphere.CFrame = CFrame.new(position)
    innerSphere.Anchored = true
    innerSphere.CanCollide = false
    innerSphere.Transparency = 0.2
    innerSphere.Material = Enum.Material.Neon
    innerSphere.Color = Color3.fromRGB(255, 255, 100)
    innerSphere.CanQuery = false
    innerSphere.Parent = workspace

    local light = Instance.new("PointLight")
    light.Brightness = 3
    light.Range = 20
    light.Color = Color3.fromRGB(255, 230, 100)
    light.Parent = sphere

    local ringPart = Instance.new("Part")
    ringPart.Size = Vector3.new(0.5, 0.5, 0.5)
    ringPart.Position = position
    ringPart.Anchored = true
    ringPart.CanCollide = false
    ringPart.Transparency = 1
    ringPart.Parent = workspace

    local ringEmitter = Instance.new("ParticleEmitter")
    ringEmitter.Texture = textures.CIRCLE_TEXTURE
    ringEmitter.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 150)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 220, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 180, 0))
    })
    ringEmitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.4),
        NumberSequenceKeypoint.new(1, 0.1)
    })
    ringEmitter.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.2),
        NumberSequenceKeypoint.new(1, 1)
    })
    ringEmitter.LightEmission = 1
    ringEmitter.Speed = NumberRange.new(20, 30)
    ringEmitter.SpreadAngle = Vector2.new(360, 360)
    ringEmitter.Lifetime = NumberRange.new(0.2, 0.4)
    ringEmitter.Rate = 0
    ringEmitter.Parent = ringPart
    ringEmitter:Emit(80)

    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    local sphereTween = services.TweenService:Create(
        sphere,
        tweenInfo,
        { Size = Vector3.new(12, 12, 12), Transparency = 1 }
    )
    local innerTweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local innerTween = services.TweenService:Create(
        innerSphere,
        innerTweenInfo,
        { Size = Vector3.new(6, 6, 6), Transparency = 1 }
    )
    local lightTween = services.TweenService:Create(light, tweenInfo, { Brightness = 0, Range = 30 })

    sphereTween:Play()
    innerTween:Play()
    lightTween:Play()
    sphereTween.Completed:Connect(function()
        sphere:Destroy()
        innerSphere:Destroy()
    end)

    services.Debris:AddItem(ringPart, 1)
end

getgenv().FloatingTextIO = "67"

hitEffects.FloatingText = function(position)
    local anchorPart = Instance.new("Part")
    anchorPart.Size = Vector3.new(0.1, 0.1, 0.1)
    anchorPart.Position = position
    anchorPart.Anchored = true
    anchorPart.CanCollide = false
    anchorPart.Transparency = 1
    anchorPart.CanQuery = false
    anchorPart.Parent = workspace

    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 120, 0, 60)
    billboard.Adornee = anchorPart
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, 0, 0)
    billboard.Parent = anchorPart

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = getgenv().FloatingTextIO
    text.TextColor3 = Color3.fromRGB(255, 255, 100)
    text.TextStrokeColor3 = Color3.fromRGB(180, 50, 0)
    text.TextStrokeTransparency = 0
    text.TextScaled = false
    text.TextSize = 20
    text.Font = Enum.Font.GothamBlack
    text.Parent = billboard

    local scaleUp = services.TweenService:Create(
        billboard,
        TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        { Size = UDim2.new(0, 140, 0, 70) }
    )
    scaleUp:Play()

    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local floatTween = services.TweenService:Create(billboard, tweenInfo, { StudsOffset = Vector3.new(0, 4, 0) })
    local fadeTween = services.TweenService:Create(
        text,
        TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
        { TextTransparency = 1, TextStrokeTransparency = 1 }
    )
    task.delay(0.1, function()
        floatTween:Play()
    end)
    task.delay(0.4, function()
        fadeTween:Play()
    end)

    services.Debris:AddItem(anchorPart, 1.5)
end

hitEffects.Flash = function(position)
    local core = Instance.new("Part")
    core.Size = Vector3.new(1, 1, 1)
    core.Shape = Enum.PartType.Ball
    core.Position = position
    core.Anchored = true
    core.CanCollide = false
    core.Material = Enum.Material.Neon
    core.Color = Color3.fromRGB(255, 255, 255)
    core.Transparency = 0
    core.CanQuery = false
    core.Parent = workspace

    local glow = Instance.new("Part")
    glow.Size = Vector3.new(2, 2, 2)
    glow.Shape = Enum.PartType.Ball
    glow.Position = position
    glow.Anchored = true
    glow.CanCollide = false
    glow.Material = Enum.Material.Neon
    glow.Color = Color3.fromRGB(255, 255, 200)
    glow.Transparency = 0.5
    glow.CanQuery = false
    glow.Parent = workspace

    local light = Instance.new("PointLight")
    light.Brightness = 3.5
    light.Range = 25
    light.Color = Color3.fromRGB(255, 255, 230)
    light.Parent = core

    local coreInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    local coreTween = services.TweenService:Create(
        core,
        coreInfo,
        { Size = Vector3.new(4, 4, 4), Transparency = 1 }
    )
    local glowTween = services.TweenService:Create(
        glow,
        TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        { Size = Vector3.new(8, 8, 8), Transparency = 1 }
    )
    local lightTween = services.TweenService:Create(light, TweenInfo.new(0.2), { Brightness = 0 })

    coreTween:Play()
    glowTween:Play()
    lightTween:Play()
    coreTween.Completed:Connect(function()
        core:Destroy()
        glow:Destroy()
    end)
end

local skyboxes = {
    ["Purple Nebula"] = {
        SkyboxUp = "rbxassetid://159454288",
        SkyboxRt = "rbxassetid://159454300",
        SkyboxLf = "rbxassetid://159454286",
        SkyboxFt = "rbxassetid://159454293",
        SkyboxBk = "rbxassetid://159454299",
        SkyboxDn = "rbxassetid://159454296",
    },
    ["Christmas"] = {
        SkyboxUp = "rbxassetid://155674931",
        SkyboxRt = "rbxassetid://155657619",
        SkyboxLf = "rbxassetid://155657671",
        SkyboxFt = "rbxassetid://155657609",
        SkyboxBk = "rbxassetid://155657655",
        SkyboxDn = "rbxassetid://155674246",
    },
    ["Tattletail"] = {
        SkyboxUp = "rbxassetid://120327360847306",
        SkyboxRt = "rbxassetid://104710795412949",
        SkyboxLf = "rbxassetid://75856428387182",
        SkyboxFt = "rbxassetid://123928107244181",
        SkyboxBk = "rbxassetid://140303809601361",
        SkyboxDn = "rbxassetid://120327360847306",
    },
    ["Clouds"] = {
        SkyboxUp = "rbxassetid://225469380",
        SkyboxRt = "rbxassetid://225469372",
        SkyboxLf = "rbxassetid://225469364",
        SkyboxFt = "rbxassetid://225469359",
        SkyboxBk = "rbxassetid://225469345",
        SkyboxDn = "rbxassetid://225469349",
    },
    ["Sunrise"] = {
        SkyboxUp = "rbxassetid://600835177",
        SkyboxRt = "rbxassetid://600833862",
        SkyboxLf = "rbxassetid://600886090",
        SkyboxFt = "rbxassetid://600832720",
        SkyboxBk = "rbxassetid://600830446",
        SkyboxDn = "rbxassetid://600831635",
    },
    ["Dark Storms"] = {
        SkyboxUp = "rbxassetid://150283877",
        SkyboxRt = "rbxassetid://150283748",
        SkyboxLf = "rbxassetid://150283702",
        SkyboxFt = "rbxassetid://150283781",
        SkyboxBk = "rbxassetid://150283828",
        SkyboxDn = "rbxassetid://150283728",
    },
    ["Night Sky"] = {
        SkyboxUp = "rbxassetid://12064131",
        SkyboxRt = "rbxassetid://12064115",
        SkyboxLf = "rbxassetid://12063984",
        SkyboxFt = "rbxassetid://12064121",
        SkyboxBk = "rbxassetid://12064107",
        SkyboxDn = "rbxassetid://12064152",
    },
    ["Pink Daylight"] = {
        SkyboxUp = "rbxassetid://271077958",
        SkyboxRt = "rbxassetid://271042467",
        SkyboxLf = "rbxassetid://271042310",
        SkyboxFt = "rbxassetid://271042556",
        SkyboxBk = "rbxassetid://271042516",
        SkyboxDn = "rbxassetid://271077243",
    },
    ["Morning Glow"] = {
        SkyboxUp = "rbxassetid://1417494643",
        SkyboxRt = "rbxassetid://1417494499",
        SkyboxLf = "rbxassetid://1417494402",
        SkyboxFt = "rbxassetid://1417494253",
        SkyboxBk = "rbxassetid://1417494030",
        SkyboxDn = "rbxassetid://1417494146",
    },
    ["Setting Sun"] = {
        SkyboxUp = "rbxassetid://626460625",
        SkyboxRt = "rbxassetid://626458639",
        SkyboxLf = "rbxassetid://626473032",
        SkyboxFt = "rbxassetid://626460513",
        SkyboxBk = "rbxassetid://626460377",
        SkyboxDn = "rbxassetid://626460216",
    },
    ["Fade Blue"] = {
        SkyboxUp = "rbxassetid://153695471",
        SkyboxRt = "rbxassetid://153695383",
        SkyboxLf = "rbxassetid://153695320",
        SkyboxFt = "rbxassetid://153695452",
        SkyboxBk = "rbxassetid://153695414",
        SkyboxDn = "rbxassetid://153695352",
    },
    ["Elegant Morning"] = {
        SkyboxUp = "rbxassetid://153767288",
        SkyboxRt = "rbxassetid://153767231",
        SkyboxLf = "rbxassetid://153767200",
        SkyboxFt = "rbxassetid://153767266",
        SkyboxBk = "rbxassetid://153767241",
        SkyboxDn = "rbxassetid://153767216",
    },
    ["Neptune"] = {
        SkyboxUp = "rbxassetid://218950090",
        SkyboxRt = "rbxassetid://218957134",
        SkyboxLf = "rbxassetid://218958493",
        SkyboxFt = "rbxassetid://218954524",
        SkyboxBk = "rbxassetid://218955819",
        SkyboxDn = "rbxassetid://218953419",
    },
    ["Redshift"] = {
        SkyboxUp = "rbxassetid://401664936",
        SkyboxRt = "rbxassetid://401664901",
        SkyboxLf = "rbxassetid://401664881",
        SkyboxFt = "rbxassetid://401664960",
        SkyboxBk = "rbxassetid://401664839",
        SkyboxDn = "rbxassetid://401664862",
    },
    ["Aesthetic Night"] = {
        SkyboxUp = "rbxassetid://1045962969",
        SkyboxRt = "rbxassetid://1045964655",
        SkyboxLf = "rbxassetid://1045964655",
        SkyboxFt = "rbxassetid://1045964655",
        SkyboxBk = "rbxassetid://1045964490",
        SkyboxDn = "rbxassetid://1045964368",
    },
}

local effectNames = { "BloodSplat", "ElectricBurst", "Shockwave", "FloatingText", "Flash"}

local gunlist = {}
for _, gun in pairs(services.ReplicatedStorage.Tools.Guns:GetChildren()) do
    table.insert(gunlist, gun.Name)
end

local function getMesh(tool)
    for _, v in ipairs(tool:GetDescendants()) do
        if v:IsA("MeshPart") then
            return v
        end
    end
end

local function updateproperty(tool, property, value)
    local tool = getMesh(tool)
    if tool then
        tool[property] = value
    end
end

local function updateColor(tool, color)
    updateproperty(tool, "Color", color)
    updateproperty(tool, "TextureID", "")
end

local function updateTransparency(tool, val)
    updateproperty(tool, "Transparency", val)
end

local function updateMaterial(tool, val)
    local mesh = getMesh(tool)
    if mesh then
        mesh.Material = Enum.Material[val]
    end
end

local function removeTextureId(tool)
    local mesh = tool:FindFirstChildWhichIsA("MeshPart", true)
    if mesh then
        mesh.TextureID = ""
    end
end

local function revertTextureId(tool)
    local mesh = tool:FindFirstChildWhichIsA("MeshPart", true)
    local replicaTool = services.ReplicatedStorage.Tools.Guns:FindFirstChild(tool.Name)
    local replicaMesh = replicaTool:FindFirstChildWhichIsA("MeshPart", true)
    if not replicaMesh then
        return
    end
    mesh.TextureID = replicaMesh.TextureID
end

if services.ReplicatedStorage.Scripts:FindFirstChild("CharacterCollision") then
    services.ReplicatedStorage.Scripts:FindFirstChild("CharacterCollision"):Destroy()
end

local friends = {}
local function isFriends(userId)
    if friends[userId] ~= nil then
        return friends[userId]
    end
    local success, result = pcall(function()
        return LocalPlayer:IsFriendsWith(userId)
    end)
    friends[userId] = success and result or false
    return friends[userId]
end

local slientCircle = Drawing.new("Circle")
slientCircle.Visible = true
slientCircle.Transparency = 0
slientCircle.Color = Color3.fromRGB(255, 255, 255)
slientCircle.Thickness = 2
slientCircle.NumSides = 64
slientCircle.Filled = false
slientCircle.Radius = 100
slientCircle.Position = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)

local Window
if services.UserInputService.TouchEnabled then
    Window = Library:CreateWindow({
        Title = "Prison Life",
        Footer = "By l10 :) v1.3",
        Size = UDim2.fromOffset(360, 300),
        ToggleKeybind = Enum.KeyCode.RightControl,
        Center = true,
        AutoShow = true
    })
else
    Window = Library:CreateWindow({
        Title = "Prison Life",
        Footer = "By l10 :) v1.3",
        ToggleKeybind = Enum.KeyCode.RightControl,
        Center = true,
        AutoShow = true
    })
end

local tabs = {
    CombatTab = Window:AddTab("Combat", "swords"),
    WeaponTab = Window:AddTab("Weapons", "hammer"),
    PlayerTab = Window:AddTab("Player", "user"),
    VisualsTab = Window:AddTab("Visuals", "eye"),
    SkinsTab = Window:AddTab("Skins", "palette"),
    WorldTab = Window:AddTab("World", "globe"),
    MiscTab = Window:AddTab("Misc", "settings"),
}

local groups = {
    SilentAimGroupBox = tabs.CombatTab:AddLeftGroupbox("Silent Aim"),
    HitboxGroupBox = tabs.CombatTab:AddRightGroupbox("Hitbox"),
    CounterBox = tabs.CombatTab:AddRightGroupbox("Counter Stuff"),

    GunBox = tabs.WeaponTab:AddLeftGroupbox("Gun Mods"),
    ItemGiverBox = tabs.WeaponTab:AddRightGroupbox("Item Giver"),

    ArrestAuraBox = tabs.PlayerTab:AddLeftGroupbox("Arrest Aura"),
    MeleeAuraBox = tabs.PlayerTab:AddLeftGroupbox("Melee Aura"),
    MovementBox = tabs.PlayerTab:AddRightGroupbox("Movement"),

    ESPBox = tabs.VisualsTab:AddLeftGroupbox("ESP"),
    EffectCustizationBox = tabs.VisualsTab:AddRightGroupbox("Effect Customization"),
    FOVBox = tabs.VisualsTab:AddRightGroupbox("Camera"),

    GunCustomization = tabs.SkinsTab:AddLeftGroupbox("Gun Customization"),
    BulletCustizationBox = tabs.SkinsTab:AddRightGroupbox("Bullet Customization"),

    Teleportation = tabs.WorldTab:AddLeftGroupbox("Teleportation"),
    Environment = tabs.WorldTab:AddRightGroupbox("Environment"),
    WorldPhysics = tabs.WorldTab:AddRightGroupbox("Physics"),

    Misc = tabs.MiscTab:AddLeftGroupbox("Miscellaneous"),
}

local mods = {}
local gettinggun = false
local function getGun(toolName)
    if gettinggun == false then
        gettinggun = true

        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        
        if not (char and root) then 
            warn("Character doesnt exist possible reason: respawning")
            gettinggun = false
            return 
        end

        if char:FindFirstChild("ForceField") then
            Library:Notify(("Cannot get gun/s while you have forcefield"), 5)
            gettinggun = false
            return
        end

        if LocalPlayer.Backpack:FindFirstChild(toolName) or char:FindFirstChild(toolName) then
            warn("You already have " .. toolName)
            gettinggun = false
            return
        end

        local giver
        for _, v in ipairs(workspace:GetDescendants()) do
            if v.Name == "TouchGiver" and v:GetAttribute("ToolName") == toolName then
                giver = v:FindFirstChildWhichIsA("BasePart")
                break
            end
        end

        if not giver then
            Library:Notify(("Giver not found for: " .. toolName), 5)
            gettinggun = false
            return
        end

        local originalGiverCFrame = giver.CFrame
        local oldCharCFrame = root.CFrame

        local undergroundCFrame = originalGiverCFrame - Vector3.new(0, 15.5, 0)

        giver.CanTouch = true
        giver.CFrame = undergroundCFrame
        
        char:PivotTo(undergroundCFrame + Vector3.new(0,5,0))

        task.wait(0.25) 
        firetouchinterest(giver, root, 0)
        task.wait(0.3) 
        firetouchinterest(giver, root, 1)
        wait(0.05)
        giver.CFrame = originalGiverCFrame
        char:PivotTo(oldCharCFrame)
        wait(0.1)
        gettinggun = false
    end
end

local GunSelectDropdown = groups.ItemGiverBox:AddDropdown("GunSelectDropdown", {
    Text = "Select Gun",
    Default = "MP5",
    Multi = true,
    Values = {"M4A1", "Remington 870", "AK-47", "MP5"}
})

groups.ItemGiverBox:AddButton({
    Text = "Get Guns",
    Func = function()
        for i, v in pairs(GunSelectDropdown.Value) do
            getGun(i)
        end
    end
})

local AutoGetGun = groups.ItemGiverBox:AddToggle("AutoGetGun", {
    Text = "Auto Get Gun",
    Default = false,
    Callback = function(Value)
        NotifyToggle("Auto Get Gun", Value)
    end
})

task.spawn(function()
    while true do
        wait(1)
        if AutoGetGun.Value then
            for i, v in pairs(GunSelectDropdown.Value) do
                getGun(i)
            end

        end
    end
end)

local hitboxes = {}

local function createHitbox(char)
    if not char then
        return
    end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        return
    end
    if not hitboxes[hrp] then
        hitboxes[hrp] = { origin = hrp.Size }
    end
    hrp.CanCollide = false
    return hrp
end

local function removeHitbox(hrp)
    if hitboxes[hrp] then
        hrp.Size = hitboxes[hrp].origin
        hrp.Transparency = 1
        hrp.CanCollide = true
        hitboxes[hrp] = nil
    end
end

local function isTrue(v)
    return v == true
end

local HitboxToggle = groups.HitboxGroupBox:AddToggle("HitboxToggle", {
    Text = "Enable Hitbox Expander",
    Default = false,
    Callback = function(Value)
        Library:Notify(("Hitbox Expander: "..Value), 3)
    end
})

local function monitorPlayer(player)
    if player == LocalPlayer then
        return
    end
    player.CharacterAdded:Connect(function(char)
        task.wait(0.1)
        if HitboxToggle.Value then
            createHitbox(char)
        end
    end)
end
for _, player in pairs(services.Players:GetPlayers()) do
    monitorPlayer(player)
end
services.Players.PlayerAdded:Connect(monitorPlayer)

local hitboxsliders = {
    HitboxSizeSlider = groups.HitboxGroupBox:AddSlider("HitboxSizeSlider", {
        Text = "Hitbox Size",
        Default = 9.5,
        Min = 1,
        Max = 9.5,
        Rounding = 2
    }),
    HitboxTransparencySlider = groups.HitboxGroupBox:AddSlider("HitboxTransparencySlider", {
        Text = "Hitbox Transparency",
        Default = 0.8,
        Min = 0,
        Max = 1,
        Rounding = 2
    })
}

local hitboxcheckers = {
    HitboxTeamCheck = groups.HitboxGroupBox:AddToggle("HitboxTeamCheck", {
        Text = "Team Check",
        Default = false,
        Callback = function(Value)
            NotifyToggle("Team Check", Value)
        end
    }),
    HitboxIgnoreFriends = groups.HitboxGroupBox:AddToggle("HitboxIgnoreFriends", {
        Text = "Ignore Friends",
        Default = false,
        Callback = function(Value)
            NotifyToggle("Ignore Friends", Value)
        end
    }),
}
groups.HitboxGroupBox:AddDivider()
local HitboxIgnoreGuards = groups.HitboxGroupBox:AddToggle("HitboxIgnoreGuards", {
    Text = "Ignore Guards",
    Default = false,
    Callback = function(Value)
        NotifyToggle("Ignore Guards", Value)
    end
})
local HitboxIgnoreCriminals = groups.HitboxGroupBox:AddToggle("HitboxIgnoreCriminals", {
    Text = "Ignore Criminals",
    Default = false,
    Callback = function(Value)
        NotifyToggle("Ignore Criminals", Value)
    end
})
local HitboxIgnoreInnocent = groups.HitboxGroupBox:AddToggle("HitboxIgnoreInnocent", {
    Text = "Ignore Innocent",
    Default = false,
    Callback = function(Value)
        NotifyToggle("Ignore Innocent", Value)
    end
})
groups.HitboxGroupBox:AddDivider()
local HitboxIgnoreHostile = groups.HitboxGroupBox:AddToggle("HitboxIgnoreHostile", {
    Text = "Ignore Hostile",
    Default = false,
    Callback = function(Value)
        NotifyToggle("Ignore Hostile", Value)
    end
})
local HitboxIgnoreTrespass = groups.HitboxGroupBox:AddToggle("HitboxIgnoreTrespass", {
    Text = "Ignore Trespassing",
    Default = false,
    Callback = function(Value)
        NotifyToggle("Ignore Trespassing", Value)
    end
})
local HitboxIgnoreForceField = groups.HitboxGroupBox:AddToggle("HitboxIgnoreForceField1", {
    Text = "Ingore ForceField",
    Default = false,
    Callback = function(Value)
        NotifyToggle("Hitbox Ignore ForceField", Value)
    end
})

groups.HitboxGroupBox:AddDivider()

local TargetHitboxExpander = groups.HitboxGroupBox:AddToggle("IgnoreHostileToggle", {
    Text = "Target Hitbox Expander",
    Default = false,
    Callback = function(Value)
        NotifyToggle("Target Hitbox Expander", Value)
    end
})

local originSize
local PlayerSelecthitbox = groups.HitboxGroupBox:AddDropdown("PlayerList", {
    SpecialType = "Player",
    Text = "Select Target",
    Tooltip = "Select a player to target",
    Callback = function(Value)
        if Value and Value.Character and Value.Character:FindFirstChild("HumanoidRootPart") then
            originSize = Value.Character.HumanoidRootPart.Size
        end
    end
})
local HitboxSizeSlider2 = groups.HitboxGroupBox:AddSlider("HitboxSizeSlider2", {
    Text = "Hitbox Size",
    Default = 9.5,
    Min = 1,
    Max = 9.5,
    Rounding = 2
})
local HitboxTransparencySlider2 = groups.HitboxGroupBox:AddSlider("HitboxTransparencySlider2", {
    Text = "Hitbox Transparency",
    Default = 0.8,
    Min = 0,
    Max = 1,
    Rounding = 2
})

task.spawn(function()
    while true do
        task.wait(0.05)
        if TargetHitboxExpander.Value and PlayerSelecthitbox.Value then
            local target = PlayerSelecthitbox.Value
            if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = target.Character.HumanoidRootPart
                hrp.Size = Vector3.new(HitboxSizeSlider2.Value, HitboxSizeSlider2.Value, HitboxSizeSlider2.Value)
                hrp.Transparency = HitboxTransparencySlider2.Value
                hrp.CanCollide = false
            end
        elseif PlayerSelecthitbox.Value and originSize then
            local target = PlayerSelecthitbox.Value
            if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = target.Character.HumanoidRootPart
                hrp.Size = originSize
                hrp.Transparency = 1
                hrp.CanCollide = true
            end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.1)
        if not HitboxToggle.Value then
            for _, player in ipairs(services.Players:GetPlayers()) do
                if player == LocalPlayer then
                    continue
                end
                local char = player.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    removeHitbox(hrp)
                end
            end
            continue
        end

        for _, player in ipairs(services.Players:GetPlayers()) do
            if player == LocalPlayer then
                continue
            end
            local char = player.Character
            local humanoid = char and char:FindFirstChild("Humanoid")
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not (humanoid and humanoid.Health > 0 and hrp) then
                if hrp then
                    removeHitbox(hrp)
                end
                continue
            end

            local hostile = isTrue(char:GetAttribute("Hostile"))
            local trespassing = isTrue(char:GetAttribute("Trespassing"))

            if hitboxcheckers.HitboxIgnoreFriends.Value and isFriends(player.UserId) then
                removeHitbox(hrp)
                continue
            end
            if hitboxcheckers.HitboxTeamCheck.Value and player.Team and player.Team == LocalPlayer.Team then
                removeHitbox(hrp)
                continue
            end
            if player.Team then
                if HitboxIgnoreCriminals.Value and player.Team.Name == "Criminals" then
                    removeHitbox(hrp)
                    continue
                end
                if HitboxIgnoreGuards.Value and player.Team.Name == "Guards" then
                    removeHitbox(hrp)
                    continue
                end
                if HitboxIgnoreInnocent.Value and player.Team.Name == "Inmates" and (not hostile and not trespassing) then
                    removeHitbox(hrp)
                    continue
                end
            end
            if player.Team and player.Team.Name == "Inmates" then
                if HitboxIgnoreHostile.Value and hostile then
                    removeHitbox(hrp)
                    continue
                end
                if HitboxIgnoreTrespass.Value and trespassing then
                    removeHitbox(hrp)
                    continue
                end
            end
            if HitboxIgnoreForceField.Value and char:FindFirstChild("ForceField") then
                removeHitbox(hrp)
                continue
            end

            local hb = createHitbox(char)
            if hb then
                hb.Size = Vector3.new(hitboxsliders.HitboxSizeSlider.Value, hitboxsliders.HitboxSizeSlider.Value, hitboxsliders.HitboxSizeSlider.Value)
                hb.Transparency = hitboxsliders.HitboxTransparencySlider.Value
            end
        end
    end
end)

local SilentAimToggle = groups.SilentAimGroupBox:AddToggle("SilentAimToggle1", {
    Text = "Silent Aim Toggle",
    Default = false,
    Tooltip = "kinda works",
    Callback = function(Value)
        NotifyToggle("Silent Aim", Value)
    end
})
local BodyPartsDropdown = groups.SilentAimGroupBox:AddDropdown("materialdropdown1", {
    Text = "Select Part",
    Default = "Head",
    Values = {"Head", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "HumanoidRootPart"}
})
local HitChanceS = groups.SilentAimGroupBox:AddSlider("HitChanceRange1", {
    Text = "Hit Chance",
    Default = 100,
    Min = 1,
    Max = 100,
    Rounding = 1
})
groups.SilentAimGroupBox:AddDivider()
local SilentShowFOV = groups.SilentAimGroupBox:AddToggle("SilentShowFOV", {
    Text = "Show FOV",
    Default = false,
    Callback = function(Value)
        slientCircle.Transparency = Value and 1 or 0
        NotifyToggle("Show FOV", Value)
    end
})
local SilentFovSize = groups.SilentAimGroupBox:AddSlider("SilentFovSize", {
    Text = "FOV Size",
    Default = 100,
    Min = 10,
    Max = 500,
    Rounding = 1,
    Callback = function(Value)
        slientCircle.Radius = Value
    end
})
local FOVFOLLOWMOUSE = groups.SilentAimGroupBox:AddToggle("SilentShowFOVFollowMouse", {
    Text = "FOV follows mouse",
    Default = false,
    Callback = function(Value)
        NotifyToggle("FOV Follow Mouse", Value)
    end
})
groups.SilentAimGroupBox:AddDivider()
local SilentTeamCheck = groups.SilentAimGroupBox:AddToggle("SilentTeamCheck", {
    Text = "Team Check",
    Default = false,
    Callback = function(Value)
        NotifyToggle("Silent Aim Team Check", Value)
    end
})
local SilentWallCheck = groups.SilentAimGroupBox:AddToggle("SilentWallCheck", {
    Text = "Wall Check",
    Default = false,
    Callback = function(Value)
        NotifyToggle("Silent Aim Wall Check", Value)
    end
})

task.spawn(function()
    services.RunService.RenderStepped:Connect(function()
        if workspace.CurrentCamera then
            camera = workspace.CurrentCamera
            if FOVFOLLOWMOUSE.Value then
                local mousePos = services.UserInputService:GetMouseLocation()
                slientCircle.Position = Vector2.new(mousePos.X, mousePos.Y)
            else
                slientCircle.Position = camera.ViewportSize / 2
            end
        end
    end)
end)

groups.SilentAimGroupBox:AddDivider()

local SilentIgnoreGuards = groups.SilentAimGroupBox:AddToggle("SilentIgnoreGuards", {
    Text = "Ignore Guards",
    Default = false,
    Callback = function(Value)
        NotifyToggle("Silent Aim Ignore Guards", Value)
    end
})
local SilentIgnoreCriminals = groups.SilentAimGroupBox:AddToggle("SilentIgnoreCriminals", {
    Text = "Ignore Criminals",
    Default = false,
    Callback = function(Value)
        NotifyToggle("Silent Aim Ignore Criminals", Value)
    end
})
local SilentIgnoreInnocent = groups.SilentAimGroupBox:AddToggle("SilentIgnoreInnocent", {
    Text = "Ignore Innocent",
    Default = false,
    Callback = function(Value)
        NotifyToggle("Silent Aim Ignore Innocent", Value)
    end
})

groups.SilentAimGroupBox:AddDivider()

local SilentIgnoreHostile = groups.SilentAimGroupBox:AddToggle("SilentIgnoreHostile", {
    Text = "Ignore Hostile",
    Default = false,
    Callback = function(Value)
        NotifyToggle("Silent Aim Ignore Hostile", Value)
    end
})
local SilentIgnoreTrespass = groups.SilentAimGroupBox:AddToggle("SilentIgnoreTrespass", {
    Text = "Ignore Trespass",
    Default = false,
    Callback = function(Value)
        NotifyToggle("Silent Aim Ignore Trespass", Value)
    end
})
local SilentIgnoreForceField = groups.SilentAimGroupBox:AddToggle("SilentIgnoreForceField1", {
    Text = "Ingore ForceField",
    Default = false,
    Callback = function(Value)
        NotifyToggle("Silent Aim Ignore ForceField", Value)
    end
})

local function GetClosestPlayer()
    local closest, closestDistance = nil, math.huge
    local center = slientCircle.Position
    local origin = camera.CFrame.Position
    for _, player in pairs(services.Players:GetPlayers()) do
        if player == LocalPlayer then
            continue
        end
        if SilentTeamCheck.Value and player.Team and player.Team == LocalPlayer.Team then
            continue
        end
        if player.Team then
            if SilentIgnoreCriminals.Value and player.Team.Name == "Criminals" then
                continue
            end
            if SilentIgnoreGuards.Value and player.Team.Name == "Guards" then
                continue
            end
        end

        local character = player.Character
        if not character then
            continue
        end
        local isHostile = character:GetAttribute("Hostile") == true
        local isTrespassing = character:GetAttribute("Trespassing") == true
        if SilentIgnoreHostile.Value and player.Team and player.Team.Name == "Inmates" and isHostile then
            continue
        end
        if SilentIgnoreTrespass.Value and player.Team and player.Team.Name == "Inmates" and isTrespassing then
            continue
        end
        if SilentIgnoreInnocent.Value and player.Team and player.Team.Name == "Inmates" and (not isHostile and not isTrespassing) then
            continue
        end

        local humanoid = character:FindFirstChild("Humanoid")
        local hrp = character:FindFirstChild("HumanoidRootPart")
        local targetpart = character:FindFirstChild(BodyPartsDropdown.Value)
        if not (humanoid and hrp and humanoid.Health > 0) then
            continue
        end

        local screenPos, onscreen = camera:WorldToViewportPoint(hrp.Position)
        if not onscreen then
            continue
        end
        if SilentWallCheck.Value and not isVisible(targetpart, origin) then
            continue
        end
        if SilentIgnoreForceField.Value and character:FindFirstChild("ForceField") then
            continue
        end

        local distance = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
        if distance <= slientCircle.Radius and distance < closestDistance then
            closest = player
            closestDistance = distance
        end
    end
    return closest
end

services.RunService.Heartbeat:Connect(function()
    currentTarget = GetClosestPlayer()
end)

local GunHitEffectsTog = groups.EffectCustizationBox:AddToggle("FieldOfViewExpander", {
    Text = "Gun Hit Effect Changer",
    Default = false,
    Callback = function(Value)
        NotifyToggle("Gun Hit Effect Changer", Value)
    end
})
local GunEffectsDrop = groups.EffectCustizationBox:AddDropdown("GunEffectsDrop", {
    Text = "Gun Effect",
    Default = "BloodSplat",
    Values = effectNames
})

groups.EffectCustizationBox:AddInput("FloatingTextInput", {
    Text = "Floating Text Changer",
    Default = "67",
    Numeric = false,
    Finished = true,
    Placeholder = "Enter text here...",
    Callback = function(Value)
        getgenv().FloatingTextIO = Value
    end
})

groups.EffectCustizationBox:AddDivider()

local BulletTracerOutlineColor = Color3.fromRGB(255, 0, 0)
local BulletTracerInlineColor = Color3.fromRGB(255, 255, 255)

local function fadeBeam(beam, duration)
    local startTime = tick()

    local conn
    conn = services.RunService.RenderStepped:Connect(function()
        local alpha = math.clamp((tick() - startTime) / duration, 0, 1)

        beam.Transparency = NumberSequence.new{
            NumberSequenceKeypoint.new(0, alpha),
            NumberSequenceKeypoint.new(1, alpha)
        }

        if alpha >= 1 then
            conn:Disconnect()
        end
    end)
end

local lightningTextures = {
    ["Default"] = "",
	["Texture1"] = "rbxassetid://15507852294",
	["Texture2"] = "rbxassetid://80526693693402",
	["Texture3"] = "rbxassetid://446111271",
	["Texture4"] = "rbxassetid://15954898244",
	["Texture5"] = "rbxassetid://7216850022",
	["Texture6"] = "rbxassetid://76383295496616"
}

local lightningTextureNames = {
    "Default",
	"Texture1",
	"Texture2",
	"Texture3",
	"Texture4",
	"Texture5",
	"Texture6"
}

local fadetimeslidervalue = 0.40
local TracerTexturesDropdown

local function createTracer(frompos, topos)
    local a0 = Instance.new("Attachment")
    local a1 = Instance.new("Attachment")

    a0.WorldPosition = frompos
    a1.WorldPosition = topos

    a0.Parent = workspace.Terrain
    a1.Parent = workspace.Terrain

    local outerBeam = Instance.new("Beam")
    outerBeam.Attachment0 = a0
    outerBeam.Attachment1 = a1
    outerBeam.Color = ColorSequence.new(BulletTracerOutlineColor)
    outerBeam.Width0 = 0.055
    outerBeam.Width1 = 0.055
    outerBeam.LightInfluence = 1
    outerBeam.LightEmission = 1
    outerBeam.Brightness = 1
    outerBeam.FaceCamera = true
    outerBeam.Transparency = NumberSequence.new(0)
    outerBeam.Parent = workspace
    if TracerTexturesDropdown.Value == "Default" then
        local innerBeam = Instance.new("Beam")
        innerBeam.Attachment0 = a0
        innerBeam.Attachment1 = a1
        innerBeam.Color = ColorSequence.new(BulletTracerInlineColor)
        innerBeam.Width0 = 0.025
        innerBeam.Width1 = 0.025
        innerBeam.LightEmission = 1
        innerBeam.LightInfluence = 1
        innerBeam.Brightness = 1
        innerBeam.FaceCamera = true
        innerBeam.Transparency = NumberSequence.new(0)
        innerBeam.Parent = workspace

        task.spawn(function()
            wait(fadetimeslidervalue)
            fadeBeam(innerBeam, 0.1)
            services.Debris:AddItem(innerBeam, 0.1)
        end)
    else
        outerBeam.TextureMode = Enum.TextureMode.Stretch
        outerBeam.Texture = lightningTextures[TracerTexturesDropdown.Value]
        outerBeam.TextureLength = 0.7

        outerBeam.Width0 = 1.5
        outerBeam.Width1 = 1.5
    end
    task.spawn(function()
        wait(fadetimeslidervalue)
        fadeBeam(outerBeam, 0.1)
        services.Debris:AddItem(outerBeam, 0.1)
        services.Debris:AddItem(a0, 0.1)
        services.Debris:AddItem(a1, 0.1)
    end)
end
local deadplayersounded = {}
local HitSoundChangerToggle
local HitSoundDropdown
local HitSoundVolumeSlider
local KillSoundChangerToggle
local KillSoundDropdown
local KillSoundVolumeSlider
local tracershot = false
local targetPos, shot = nil,nil,false
local hitpart = nil
task.spawn(function()
    while true do
        task.wait(0.05)

        if shot then
            shot = false

            if typeof(targetPos) == "Vector3" and GunHitEffectsTog.Value and GunEffectsDrop.Value and hitEffects[GunEffectsDrop.Value] then
                pcall(hitEffects[GunEffectsDrop.Value], targetPos)
            end

            if typeof(targetPos) == "Vector3" and tracershot then
                local originpos
                local currentTool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Tool")

                if currentTool then
                    if table.find(gunlist, currentTool.Name) then
                        local muzzle = currentTool:FindFirstChild("Muzzle")
                        if muzzle then
                            originpos = muzzle.Position
                        end
                    end
                end

                if originpos then
                    createTracer(originpos, targetPos)
                end
            end
        end

        if hitpart then
            for i,v in pairs(services.Players:GetPlayers()) do  
                local char = v.Character
                if char then
                    local tplayer = services.Players:GetPlayerFromCharacter(char)
                    local humanoid = char:FindFirstChild("Humanoid")
                    if hitpart:IsDescendantOf(char) then
                        if HitSoundChangerToggle.Value then
                            local selected = HitSoundDropdown and HitSoundDropdown.Value
                            local soundId = selected and HitSoundId[selected]
                            local myChar = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

                            if soundId then
                                local sound = Instance.new("Sound")
                                sound.Name = "HitSound"
                                sound.SoundId = "http://www.roblox.com/asset/?id=" .. soundId
                                sound.Volume = HitSoundVolumeSlider.Value or 1
                                sound.PlayOnRemove = false
                                sound.Parent = myChar

                                sound:Play()

                                sound.Ended:Once(function()
                                    sound:Destroy()
                                end)
                            end
                        end
                        if KillSoundChangerToggle.Value then
                            local selected = KillSoundDropdown and KillSoundDropdown.Value
                            local soundId = selected and HitSoundId[selected]
                            local myChar = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                            if humanoid and humanoid.Health <= 11 and not deadplayersounded[tplayer] and soundId then
                                deadplayersounded[tplayer] = true
                                local sound = Instance.new("Sound")
                                sound.Name = "HitSound"
                                sound.SoundId = "http://www.roblox.com/asset/?id=" .. soundId
                                sound.Volume = KillSoundVolumeSlider.Value or 1
                                sound.PlayOnRemove = false
                                sound.Parent = myChar

                                sound:Play()

                                sound.Ended:Once(function()
                                    sound:Destroy()
                                end)
                            end
                        end
                    end
                end
            end
        end
        hitpart = nil
    end
end)

local oldNamecall
if type(hookmetamethod) == "function" then
    oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local m = getnamecallmethod and getnamecallmethod()
        local a = { ... }
        if self == remotes.remote and m == "FireServer" then
            local t = a[1]
            local p = (type(t) == "table" and t[1] and t[1][2]) or nil
            if typeof(p) == "Vector3" then
                targetPos = p
                shot = true
            end

            local obj = (type(t) == "table" and t[1] and t[1][3]) or nil

            local success, validObj = pcall(function()
                return obj and typeof(obj) == "Instance" and obj.Parent and obj.Name ~= "" and obj
            end)

            if success and validObj then
                hitpart = validObj
            else
                hitpart = nil
            end
        end
        return oldNamecall(self, table.unpack(a))
    end))
end

services.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(char)
        deadplayersounded[player] = nil
    end)
end)

HitSoundChangerToggle = groups.EffectCustizationBox:AddToggle("HitSoundChangerToggle", {
    Text = "Hit Sound Changer",
    Default = false,
    Callback = function(Value)
        NotifyToggle("Hit Sound Changer", Value)
    end
})

HitSoundDropdown = groups.EffectCustizationBox:AddDropdown("HitSoundDropdown", {
    Text = "Hit Sound",
    Default = Hitsounds[1],
    Values = Hitsounds
})

HitSoundVolumeSlider = groups.EffectCustizationBox:AddSlider("HitSoundVolumeSlider1", {
    Text = "Volume",
    Default = 1,
    Min = 0,
    Max = 1,
    Rounding = 4
})

groups.EffectCustizationBox:AddDivider()

local ShootSoundChangerToggle = groups.EffectCustizationBox:AddToggle("ShootSoundChangerToggle", {
    Text = "Shoot Sound Changer",
    Default = false,
    Callback = function(Value)
        NotifyToggle("Shoot Sound Changer", Value)
    end
})

local ShootSoundDropdown = groups.EffectCustizationBox:AddDropdown("ShootSoundDropdown", {
    Text = "Shoot Sound",
    Default = GunShootSounds[1],
    Values = GunShootSounds
})

local ShootSoundVolumeSlider = groups.EffectCustizationBox:AddSlider("ShootSoundVolumeSlider1", {
    Text = "Volume",
    Default = 1,
    Min = 0,
    Max = 1,
    Rounding = 4
})

groups.EffectCustizationBox:AddDivider()

KillSoundChangerToggle = groups.EffectCustizationBox:AddToggle("KillSoundChangerToggle", {
    Text = "Kill Sound Changer",
    Default = false,
    Callback = function(Value)
        NotifyToggle("Kill Sound Changer", Value)
    end
})

KillSoundDropdown = groups.EffectCustizationBox:AddDropdown("KillSoundDropdown", {
    Text = "Kill Sound",
    Default = Hitsounds[1],
    Values = Hitsounds
})

KillSoundVolumeSlider = groups.EffectCustizationBox:AddSlider("KillSoundVolumeSlider1", {
    Text = "Volume",
    Default = 1,
    Min = 0,
    Max = 1,
    Rounding = 4
})

local DefaultSound = {}

task.spawn(function()
    while true do
        task.wait(0.25)
        pcall(function()
            local character = LocalPlayer.Character
            if not character then
                return
            end

            for _, tool in pairs(character:GetChildren()) do
                if tool:IsA("Tool") then
                    if tool:FindFirstChild("Handle") then
                        for _, obj in pairs(tool:GetDescendants()) do
                            if obj:IsA("Sound") then
                                if obj.Name == "ShootSound" then
                                    if not DefaultSound[tool.Name] or DefaultSound[tool.Name] == "" then
                                        DefaultSound[tool.Name] = obj.SoundId
                                    end

                                    if ShootSoundChangerToggle.Value then
                                        local newId = GunShootSoundId[ShootSoundDropdown.Value]
                                        local targetId = newId and ("http://www.roblox.com/asset/?id=" .. newId)

                                        obj.Volume = ShootSoundVolumeSlider.Value or 1

                                        if targetId and obj.SoundId ~= targetId then
                                            obj.SoundId = targetId
                                        end
                                    else
                                        local original = DefaultSound[tool.Name]

                                        if original and obj.SoundId ~= original then
                                            obj.Volume = 0.25
                                            obj.SoundId = original
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
end)

local function didHit()
    return math.random(1, 100) <= HitChanceS.Value
end

local function getMissOffset(partPos, origin)
    local distance = (partPos - origin).Magnitude
    local scale = math.clamp(distance / 3, 3, 4)
    return Vector3.new(
        math.random(-scale, scale),
        math.random(-scale / 2, scale / 2),
        math.random(-scale, scale)
    )
end

local castRayF = filtergc("function", { Name = "castRay" }, true)
local oldCastRay
if type(castRayF) == "function" and hookfunction then
    oldCastRay = hookfunction(castRayF, function(...)
        local args = { ... }
        if SilentAimToggle.Value and currentTarget and currentTarget.Character then
            local part = currentTarget.Character:FindFirstChild(BodyPartsDropdown.Value)
            if part then
                if didHit() then
                    args[2] = part.Position
                else
                    local origin = args[1]
                    local missPart = currentTarget.Character:FindFirstChild("LeftLeg")
                        or currentTarget.Character:FindFirstChild("RightLeg")
                        or currentTarget.Character:FindFirstChild("Head")
                    if missPart and typeof(origin) == "Vector3" then
                        args[2] = missPart.Position + getMissOffset(missPart.Position, origin)
                    end
                end
            end
        end
        return oldCastRay(table.unpack(args))
    end)
end

local ArrestAuraToggle = groups.ArrestAuraBox:AddToggle("ArrestAuraToggle1", {
    Text = "Arrest Aura Toggle",
    Default = false,
    Callback = function(Value)
        NotifyToggle("Arrest Aura", Value)
    end
})
local IngoreFriendsTog = groups.ArrestAuraBox:AddToggle("IngoreFriendsTog1", {
    Text = "Ingore Friends",
    Default = false,
    Callback = function(Value)
        NotifyToggle("Ignore Friends (Arrest)", Value)
    end
})
local ArrestAuraRange = groups.ArrestAuraBox:AddSlider("ArrestAuraRange1", {
    Text = "Arrest Aura Range",
    Default = 7.5,
    Min = 1,
    Max = 7.5,
    Rounding = 1
})

local function arrestable(player)
    if not player.Character then
        return false
    end
    local humanoid = player.Character:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then
        return false
    end
    local displayname = humanoid.DisplayName
    if player.Team and player.Team.Name == "Criminals" then
        return true
    end
    if displayname:find("ð", 1, true) or displayname:find("ð¢", 1, true) then
        return true
    end
    return false
end

task.spawn(function()
    while true do
        task.wait(0.2)
        if ArrestAuraToggle.Value then
            local myChar = LocalPlayer.Character
            local myroot = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if not myroot then
                continue
            end
            for _, plr in ipairs(services.Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and arrestable(plr) then
                    if IngoreFriendsTog.Value and isFriends(plr.UserId) then
                        continue
                    end
                    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                    if hrp and (myroot.Position - hrp.Position).Magnitude <= ArrestAuraRange.Value then
                        remotes.arrestremote:InvokeServer(plr)
                    end
                end
            end
        end
    end
end)

local MeleeAuraToggle = groups.MeleeAuraBox:AddToggle("MeleeAuraToggle1", {
    Text = "Melee Aura Toggle",
    Default = false,
    Callback = function(Value)
        NotifyToggle("Melee Aura", Value)
    end
})
local IngoreFriendsTog2 = groups.MeleeAuraBox:AddToggle("IngoreFriendsTog2", {
    Text = "Ingore Friends",
    Default = false,
    Callback = function(Value)
        NotifyToggle("Ignore Friends (Melee)", Value)
    end
})
local MeleeAuraRange = groups.MeleeAuraBox:AddSlider("MeleeAuraRange1", {
    Text = "Melee Aura Range",
    Default = 4,
    Min = 1,
    Max = 9,
    Rounding = 1
})

task.spawn(function()
    while true do
        task.wait(0.2)
        if MeleeAuraToggle.Value then
            local myChar = LocalPlayer.Character
            local myroot = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if not myroot then
                continue
            end
            for _, plr in ipairs(services.Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    if IngoreFriendsTog2.Value and isFriends(plr.UserId) then
                        continue
                    end
                    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                    if hrp and (myroot.Position - hrp.Position).Magnitude <= MeleeAuraRange.Value then
                        remotes.meleeremote:FireServer(plr)
                    end
                end
            end
        end
    end
end)

local connections = {}
local antitase1 = groups.CounterBox:AddToggle("AntiTase1", {
    Text = "AntiTase",
    Default = false,
    Callback = function(Value)
        if Value then
            for _, conn in pairs(getconnections(remotes.tasedremote.OnClientEvent)) do
                conn:Disable()
                table.insert(connections, conn)
            end
        else
            for _, connection in pairs(connections) do
                connection:Enable()
            end
            connections = {}
        end
        NotifyToggle("AntiTase", Value)
    end
})

LocalPlayer.CharacterAdded:Connect(function(character)
    wait(0.1)
    if antitase1.Value == true then
        for _, conn in pairs(getconnections(remotes.tasedremote.OnClientEvent)) do
            conn:Disable()
            table.insert(connections, conn)
        end
    else
        for _, connection in pairs(connections) do
            connection:Enable()
        end
        connections = {}
    end
end)

local NoSpread = groups.GunBox:AddToggle("NoSpreadToggle", {
    Text = "No Spread",
    Default = false,
    Callback = function(Value)
        NotifyToggle("No Spread", Value)
    end
})
local MakeAutomatic = groups.GunBox:AddToggle("AutoFireToggle", {
    Text = "Auto Automatic",
    Default = false,
    Callback = function(Value)
        NotifyToggle("Auto Fire", Value)
    end
})
groups.GunBox:AddDivider()
local EnableReloadCooldown = groups.GunBox:AddToggle("EnableReloadCooldown1", {
    Text = "Enable Reload Cooldown",
    Default = false,
    Callback = function(Value)
        NotifyToggle("Enable Reload Cooldown", Value)
    end
})

local ReloadCoooldownSlider = groups.GunBox:AddSlider("ReloadCoooldownSlider1", {
    Text = "Customization",
    Default = 1,
    Min = 0,
    Max = 2,
    Rounding = 3
})

groups.GunBox:AddDivider()

local EnableFirerateAdjuster = groups.GunBox:AddToggle("EnableFirerateAdjuster1", {
    Text = "Enable Fire-rate Adjuster",
    Default = false,
    Callback = function(Value)
        NotifyToggle("Enable Fire-Rate Adjuster", Value)
    end
})

local FirerateAdjusterSlider = groups.GunBox:AddSlider("FirerateAdjusterSlider1", {
    Text = "Customization",
    Default = 0.1,
    Min = 0,
    Max = 0.8,
    Rounding = 3
})
local oldvalues = {}

local function saveattribute(tool, attribute)
    oldvalues[tool] = oldvalues[tool] or {}
    if oldvalues[tool][attribute] == nil then
        oldvalues[tool][attribute] = tool:GetAttribute(attribute)
    end
end

local function revertattribute(tool, attribute)
    if oldvalues[tool] and oldvalues[tool][attribute] ~= nil then
        tool:SetAttribute(attribute, oldvalues[tool][attribute])
        oldvalues[tool][attribute] = nil
    end
end

task.spawn(function()
    while true do
        task.wait(0.1)
        local char = LocalPlayer.Character
        local backpack = LocalPlayer:FindFirstChild("Backpack")

        local function handleTool(tool)
            if NoSpread.Value and tool:GetAttribute("SpreadRadius") ~= nil then
                saveattribute(tool, "SpreadRadius")
                tool:SetAttribute("SpreadRadius", 0)
            else
                revertattribute(tool, "SpreadRadius")
            end
            if MakeAutomatic.Value and tool:GetAttribute("AutoFire") ~= nil then
                saveattribute(tool, "AutoFire")
                tool:SetAttribute("AutoFire", true)
            else
                revertattribute(tool, "AutoFire")
            end
            if EnableReloadCooldown.Value and tool:GetAttribute("ReloadTime") ~= nil then
                saveattribute(tool, "ReloadTime")
                tool:SetAttribute("ReloadTime", ReloadCoooldownSlider.Value)
            else
                revertattribute(tool, "ReloadTime")
            end
            if EnableFirerateAdjuster.Value and tool:GetAttribute("FireRate") ~= nil then
                saveattribute(tool, "FireRate")
                tool:SetAttribute("FireRate", FirerateAdjusterSlider.Value)
            else
                revertattribute(tool, "FireRate")
            end
        end

        if char then
            for _, tool in ipairs(char:GetChildren()) do
                if tool:IsA("Tool") then
                    handleTool(tool)
                end
            end
        end
        if backpack then
            for _, tool in ipairs(backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    handleTool(tool)
                end
            end
        end
    end
end)

groups.Misc:AddToggle("EnableDesync1", {
    Text = "Enable Desync",
    Default = false,
    Callback = function(Value)
        NotifyToggle("Desync", Value)
        setfflag("NextGenReplicatorEnabledWrite4", Value and "true" or "false")
    end
})

services.Players.PlayerRejoining:Connect(function(player)
    if player == LocalPlayer then
        setfflag("NextGenReplicatorEnabledWrite4", "false")
    end
end)

groups.Teleportation:AddButton({
    Text = "Become Criminal",
    Func = function()
        LocalPlayer.Character:MoveTo(Vector3.new(-460, 54, 2215))
        Library:Notify("Teleported to Criminal Base", 3)
    end,
    DoubleClick = true
})

groups.Misc:AddButton({
    Text = "Rejoin Server",
    Func = function()
        Library:Notify("Rejoining Server...", 3)
        services.TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end,
    DoubleClick = true
})

local conn
groups.MovementBox:AddToggle("InfiniteJump1", {
    Text = "Infinite Jump",
    Default = false,
    Callback = function(Value)
        NotifyToggle("Infinite Jump", Value)
        if Value then
            if conn then
                conn:Disconnect()
            end
            conn = services.UserInputService.InputBegan:Connect(function(key, gameProcessedEvent)
                if key.KeyCode == Enum.KeyCode.Space and not gameProcessedEvent then
                    pcall(function()
                        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end)
                end
            end)
        else
            if conn then
                conn:Disconnect()
                conn = nil
            end
        end
    end
})

groups.MovementBox:AddDivider()

local WalkspeedToggle = groups.MovementBox:AddToggle("WalkspeedToggle", {
    Text = "Enable Walkspeed",
    Default = false,
    Callback = function(Value)
        NotifyToggle("Walkspeed", Value)
        if not Value and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end
})
local WalkspeedSlider = groups.MovementBox:AddSlider("WalkspeedSlider1", {
    Text = "Walkspeed Slider",
    Default = 100,
    Min = 1,
    Max = 250,
    Rounding = 1
})

groups.MovementBox:AddDivider()

local JumpPowerToggle = groups.MovementBox:AddToggle("JumpPowerToggle1", {
    Text = "Enable JumpPower",
    Default = false,
    Callback = function(Value)
        NotifyToggle("JumpPower", Value)
        if not Value and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpHeight = 7.2
        end
    end
})
local JumpPowerSlider = groups.MovementBox:AddSlider("JumpPowerSlider1", {
    Text = "Jump Power Slider",
    Default = 20,
    Min = 1,
    Max = 200,
    Rounding = 1
})

task.spawn(function()
    while true do
        task.wait(0.05)
        pcall(function()
            if WalkspeedToggle.Value and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = WalkspeedSlider.Value
            end
            if JumpPowerToggle.Value and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.JumpHeight = JumpPowerSlider.Value
            end
        end)
    end
end)

groups.MovementBox:AddDivider()

local conn2
groups.MovementBox:AddToggle("NoclipToggle1", {
    Text = "Enable Noclip",
    Default = false,
    Callback = function(Value)
        NotifyToggle("Noclip", Value)
        if Value then
            if conn2 then
                conn2:Disconnect()
            end
            conn2 = services.RunService.Heartbeat:Connect(function()
                for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end)
        else
            if conn2 then
                conn2:Disconnect()
                conn2 = nil
            end
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = true
                end
            end
        end
    end
})

groups.MovementBox:AddDivider()

local AntiJumpBypass = groups.MovementBox:AddToggle("AntiJumpBypass1", {
    Text = "Enable No Jump Cool Down",
    Default = false,
    Callback = function(Value)
        NotifyToggle("0 Jump CoolDown", Value)
    end
})

task.spawn(function()
    while true do
        task.wait(0.2)
        if AntiJumpBypass.Value then
            local aj = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("AntiJump")
            if aj then
                aj.Disabled = true
            end
        else
            local aj = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("AntiJump")
            if aj then
                aj.Disabled = false
            end
        end
    end
end)

local guncolor = Color3.fromRGB(255, 0, 0)

local GunColorCustomizationConn
local guncolortog = groups.GunCustomization:AddToggle("GunColorTog", {
    Text = "Gun Color Changer",
    Default = false,
    Callback = function(Value)
        if Value then
            if GunColorCustomizationConn then
                GunColorCustomizationConn:Disconnect()
            end
            GunColorCustomizationConn = services.RunService.RenderStepped:Connect(function()
                local char = LocalPlayer.Character
                local backpack = LocalPlayer:FindFirstChild("Backpack")
                if char then
                    for _, v in ipairs(char:GetChildren()) do
                        if v:IsA("Tool") and v.Name ~= "Taser" and table.find(gunlist, v.Name) then
                            updateColor(v, guncolor)
                        end
                    end
                end
                if backpack then
                    for _, v in ipairs(backpack:GetChildren()) do
                        if v:IsA("Tool") and v.Name ~= "Taser" and table.find(gunlist, v.Name) then
                            updateColor(v, guncolor)
                        end
                    end
                end
            end)
        else
            if GunColorCustomizationConn then
                GunColorCustomizationConn:Disconnect()
                GunColorCustomizationConn = nil
            end
            task.wait(0.01)
            local char = LocalPlayer.Character
            local backpack = LocalPlayer:FindFirstChild("Backpack")
            if char then
                for _, v in ipairs(char:GetChildren()) do
                    if v:IsA("Tool") and v.Name ~= "Taser" and table.find(gunlist, v.Name) then
                        updateColor(v, Color3.fromRGB(255, 255, 255))
                        revertTextureId(v)
                    end
                end
            end
            if backpack then
                for _, v in ipairs(backpack:GetChildren()) do
                    if v:IsA("Tool") and v.Name ~= "Taser" and table.find(gunlist, v.Name) then
                        updateColor(v, Color3.fromRGB(255, 255, 255))
                        revertTextureId(v)
                    end
                end
            end
        end
        NotifyToggle("Gun Color", Value)
    end
})
guncolortog:AddColorPicker("GunColorPicker", {
    Default = Color3.fromRGB(255, 0, 0),
    Title = "Gun Color",
    Callback = function(Value)
        guncolor = Value
    end
})

groups.GunCustomization:AddDivider()

local transgun = 0
local GunTransparencyTogleConn
groups.GunCustomization:AddToggle("GunTransparencyTogle", {
    Text = "Gun Transparency Changer",
    Default = false,
    Callback = function(Value)
        if Value then
            if GunTransparencyTogleConn then
                GunTransparencyTogleConn:Disconnect()
            end
            GunTransparencyTogleConn = services.RunService.RenderStepped:Connect(function()
                local char = LocalPlayer.Character
                local backpack = LocalPlayer:FindFirstChild("Backpack")
                if char then
                    for _, v in ipairs(char:GetChildren()) do
                        if v:IsA("Tool") and v.Name ~= "Taser" and table.find(gunlist, v.Name) then
                            updateTransparency(v, transgun)
                        end
                    end
                end
                if backpack then
                    for _, v in ipairs(backpack:GetChildren()) do
                        if v:IsA("Tool") and v.Name ~= "Taser" and table.find(gunlist, v.Name) then
                            updateTransparency(v, transgun)
                        end
                    end
                end
            end)
        else
            if GunTransparencyTogleConn then
                GunTransparencyTogleConn:Disconnect()
                GunTransparencyTogleConn = nil
            end
            task.wait(0.01)
            local char = LocalPlayer.Character
            local backpack = LocalPlayer:FindFirstChild("Backpack")
            if char then
                for _, v in ipairs(char:GetChildren()) do
                    if v:IsA("Tool") and v.Name ~= "Taser" and table.find(gunlist, v.Name) then
                        updateTransparency(v, 0)
                    end
                end
            end
            if backpack then
                for _, v in ipairs(backpack:GetChildren()) do
                    if v:IsA("Tool") and v.Name ~= "Taser" and table.find(gunlist, v.Name) then
                        updateTransparency(v, 0)
                    end
                end
            end
        end
        NotifyToggle("Gun Transparency Changer", Value)
    end
})
groups.GunCustomization:AddSlider("TransparencySlidea", {
    Text = "Transparency Slider",
    Default = 0,
    Min = 0,
    Max = 1,
    Rounding = 3,
    Callback = function(Value)
        transgun = Value
    end
})

groups.GunCustomization:AddDivider()

local materialdropdown1
local GunMaterialTogleConn
groups.GunCustomization:AddToggle("GunMaterialTogle", {
    Text = "Gun Material Changer",
    Default = false,
    Callback = function(Value)
        if Value then
            if GunMaterialTogleConn then
                GunMaterialTogleConn:Disconnect()
            end
            GunMaterialTogleConn = services.RunService.RenderStepped:Connect(function()
                local char = LocalPlayer.Character
                local backpack = LocalPlayer:FindFirstChild("Backpack")
                if char then
                    for _, v in ipairs(char:GetChildren()) do
                        if v:IsA("Tool") and v.Name ~= "Taser" and table.find(gunlist, v.Name) then
                            removeTextureId(v)
                            updateMaterial(v, materialdropdown1.Value)
                        end
                    end
                end
                if backpack then
                    for _, v in ipairs(backpack:GetChildren()) do
                        if v:IsA("Tool") and v.Name ~= "Taser" and table.find(gunlist, v.Name) then
                            removeTextureId(v)
                            updateMaterial(v, materialdropdown1.Value)
                        end
                    end
                end
            end)
        else
            if GunMaterialTogleConn then
                GunMaterialTogleConn:Disconnect()
                GunMaterialTogleConn = nil
            end
            task.wait(0.01)
            local char = LocalPlayer.Character
            local backpack = LocalPlayer:FindFirstChild("Backpack")
            if char then
                for _, v in ipairs(char:GetChildren()) do
                    if v:IsA("Tool") and v.Name ~= "Taser" and table.find(gunlist, v.Name) then
                        revertTextureId(v)
                        updateMaterial(v, "Plastic")
                    end
                end
            end
            if backpack then
                for _, v in ipairs(backpack:GetChildren()) do
                    if v:IsA("Tool") and v.Name ~= "Taser" and table.find(gunlist, v.Name) then
                        revertTextureId(v)
                        updateMaterial(v, "Plastic")
                    end
                end
            end
        end
        NotifyToggle("Gun Material Changer", Value)
    end
})

materialdropdown1 = groups.GunCustomization:AddDropdown("materialdropdown1", {
    Text = "Gun Material",
    Default = "Neon",
    Values = {
        "Neon", "Glass", "ForceField", "Plastic", "SmoothPlastic",
        "Metal", "Concrete", "Brick", "Wood", "WoodPlanks",
        "Grass", "Rock", "Sand", "Snow", "Asphalt", "Pavement"
    }
})

local BulletColorCustomization = groups.BulletCustizationBox:AddToggle("BulletColorCustomization", {
    Text = "Bullet Color Changer",
    Default = false,
    Callback = function(Value)
        NotifyToggle("Bullet Color", Value)
    end
})
local bulletcolor = Color3.fromRGB(255, 0, 0)
BulletColorCustomization:AddColorPicker("ESPColor", {
    Default = bulletcolor,
    Title = "ESP Color",
    Callback = function(Value)
        bulletcolor = Value
    end
})

groups.BulletCustizationBox:AddDivider()

local CustomMaterialBUllet = groups.BulletCustizationBox:AddToggle("CustomMaterialBUllet", {
    Text = "Bullet Material Changer",
    Default = false,
    Callback = function(Value)
        NotifyToggle("Bullet Material Changer", Value)
    end
})
local BulletMaterialDropdown = groups.BulletCustizationBox:AddDropdown("BulletMaterial", {
    Text = "Bullet Material",
    Default = "Neon",
    Values = { "Neon", "Glass", "ForceField", "Plastic", "Metal", "Concrete" }
})

groups.BulletCustizationBox:AddDivider()

local BulletHighlightToggle = groups.BulletCustizationBox:AddToggle("BulletHighlight", {
    Text = "Bullet Highlight",
    Default = false,
    Callback = function(Value)
        NotifyToggle("Bullet Highlight", Value)
    end
})
local HighlightColorBullet = Color3.fromRGB(255, 255, 255)
BulletHighlightToggle:AddColorPicker("HighlightColor", {
    Default = HighlightColorBullet,
    Title = "Highlight Color",
    Callback = function(Value)
        HighlightColorBullet = Value
    end
})
local HighlightOutlineColorBullet = Color3.fromRGB(0, 0, 0)
BulletHighlightToggle:AddColorPicker("HighlightOutlineColor", {
    Default = HighlightOutlineColorBullet,
    Title = "Outline Color",
    Callback = function(Value)
        HighlightOutlineColorBullet = Value
    end
})

groups.BulletCustizationBox:AddDivider()
local bullettransparency = 1
local CBulletTransparency = groups.BulletCustizationBox:AddToggle("bullettransparency", {
    Text = "Bullet Transparency",
    Default = false,
    Callback = function(Value)
        NotifyToggle("Bullet Transparency", Value)
    end
})

groups.BulletCustizationBox:AddSlider("bullettransparency_slider", {
    Text = "Bullet Transparency Slider",
    Default = 1,
    Min = 0,
    Max = 1,
    Rounding = 3,
    Callback = function(Value)
        bullettransparency = Value  
    end
})


groups.BulletCustizationBox:AddDivider()

local CBulletTracer = groups.BulletCustizationBox:AddToggle("CustomMaterialBUllet", {
    Text = "Bullet Tracer",
    Default = false,
    Callback = function(Value)
        NotifyToggle("Bullet Tracer", Value)
        if Value then
            tracershot = true
        else
            tracershot = false
        end
    end
})
CBulletTracer:AddColorPicker("BulletTracerOutlineColor", {
    Default = BulletTracerOutlineColor,
    Title = "Tracer Outline Color",
    Callback = function(Value)
        BulletTracerOutlineColor = Value
    end
})

CBulletTracer:AddColorPicker("BulletTracerInlineColor", {
    Default = BulletTracerInlineColor,
    Title = "Tracer Inlline Color",
    Callback = function(Value)
        BulletTracerInlineColor = Value
    end
})

groups.BulletCustizationBox:AddDivider()

TracerTexturesDropdown = groups.BulletCustizationBox:AddDropdown("TracerTexturesDropdown1", {
    Text = "Select Texture",
    Default = "Default",
    Values = lightningTextureNames
})

groups.BulletCustizationBox:AddDivider()

groups.BulletCustizationBox:AddSlider("TracerFadeTime", {
    Text = "Tracer Fade Time",
    Default = 0.4,
    Min = 0.01,
    Max = 3,
    Rounding = 3,
    Callback = function(Value)
        fadetimeslidervalue = Value
    end
})

local oldInstanceNew
if hookfunction and Instance and type(Instance.new) == "function" then
    oldInstanceNew = hookfunction(Instance.new, function(className, parent)
        local obj = oldInstanceNew(className, parent)
        if className ~= "Part" then
            return obj
        end
        task.defer(function()
            if obj and obj.Name == "RayPart" then
                local character = LocalPlayer.Character
                if character and obj:IsDescendantOf(character) then
                    if BulletColorCustomization.Value then
                        obj.Color = bulletcolor
                    end
                    if CustomMaterialBUllet.Value and Enum.Material[BulletMaterialDropdown.Value] then
                        obj.Material = Enum.Material[BulletMaterialDropdown.Value]
                    end
                    if BulletHighlightToggle.Value then
                        local highlight = Instance.new("Highlight")
                        highlight.FillColor = HighlightColorBullet
                        highlight.OutlineColor = HighlightOutlineColorBullet
                        highlight.Adornee = obj
                        highlight.Parent = obj
                    end
                    if CBulletTransparency.Value then
                        if obj.Transparency then
                            obj.Transparency = bullettransparency or 0.4
                        end
                    end
                end
            end
        end)
        return obj
    end)
end

local FieldOfViewExpander = groups.FOVBox:AddToggle("FieldOfViewExpander", {
    Text = "FOV Expander",
    Default = false,
    Callback = function(Value)
        NotifyToggle("FOV Expander", Value)
    end
})
local FovSlider = groups.FOVBox:AddSlider("FovSlider", {
    Text = "FOV slider",
    Default = 70,
    Min = 1,
    Max = 120,
    Rounding = 1
})

task.spawn(function()
    while true do
        task.wait(0.2)
        if FieldOfViewExpander.Value then
            pcall(function()
                workspace.CurrentCamera.FieldOfView = FovSlider.Value
            end)
        else
            pcall(function()
                workspace.CurrentCamera.FieldOfView = 70
            end)
        end
    end
end)

local oldzoommax = LocalPlayer.CameraMaxZoomDistance
groups.FOVBox:AddToggle("InfiniteZoom1", {
    Text = "Infinite Camera Zoom",
    Default = false,
    Callback = function(Value)
        NotifyToggle("Infinite Camera Zoom", Value)
        LocalPlayer.CameraMaxZoomDistance = Value and math.huge or oldzoommax
    end
})

local BOXESP, TRACERESP, SKELETONESP, NAMEESP, HPESP, TOOLESP = {}, {}, {}, {}, {}, {}

local function createEsp(player)
    if player == LocalPlayer then
        return
    end
    local box = Drawing.new("Square")
    box.Visible, box.Thickness, box.Filled, box.Transparency, box.Color = false, 2, false, 1, Color3.fromRGB(255, 255, 255)
    local nametext = Drawing.new("Text")
    nametext.Visible, nametext.Text, nametext.Transparency = false, player.Name, 1
    local hptext = Drawing.new("Text")
    hptext.Visible, hptext.Text, hptext.Transparency = false, "HP: 100", 1
    local tooltext = Drawing.new("Text")
    tooltext.Visible, tooltext.Text, tooltext.Transparency = false, "Tool: nil", 1
    local line = Drawing.new("Line")
    line.Visible, line.Thickness, line.Transparency, line.Color = false, 1, 1, Color3.fromRGB(255, 255, 255)
    line.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)

    BOXESP[player] = { Box = box }
    TRACERESP[player] = { Line = line }
    SKELETONESP[player] = {}
    NAMEESP[player] = { Text = nametext }
    HPESP[player] = { Text = hptext }
    TOOLESP[player] = { ToolText = tooltext }
end

local function removeEsp(player)
    if BOXESP[player] then
        BOXESP[player].Box:Remove()
        BOXESP[player] = nil
    end
    if TRACERESP[player] then
        TRACERESP[player].Line:Remove()
        TRACERESP[player] = nil
    end
    if NAMEESP[player] then
        NAMEESP[player].Text:Remove()
        NAMEESP[player] = nil
    end
    if HPESP[player] then
        HPESP[player].Text:Remove()
        HPESP[player] = nil
    end
    if TOOLESP[player] then
        TOOLESP[player].ToolText:Remove()
        TOOLESP[player] = nil
    end
    if SKELETONESP[player] then
        for _, l in pairs(SKELETONESP[player]) do
            l:Remove()
        end
        SKELETONESP[player] = nil
    end
end

services.Players.PlayerAdded:Connect(createEsp)
services.Players.PlayerRemoving:Connect(removeEsp)
for _, player in ipairs(services.Players:GetPlayers()) do
    createEsp(player)
end

local BoxESP = groups.ESPBox:AddToggle("BoxESPTog1", {
    Text = "Box ESP",
    Default = false,
    Callback = function(Value)
        NotifyToggle("Box ESP", Value)
        if not Value then
            for _, data in pairs(BOXESP) do
                data.Box.Visible = false
            end
        end
    end
})

groups.ESPBox:AddSlider("BoxTransparencySlider1", {
    Text = "Box Transparency",
    Min = 0,
    Max = 1,
    Default = 0.5,
    Rounding = 3,
    Float = true,
    Callback = function(Value)
        for _, data in pairs(BOXESP) do
            data.Box.Transparency = Value
        end
    end
})
groups.ESPBox:AddSlider("BoxThicknessSlider1", {
    Text = "Box Thickness",
    Min = 1,
    Max = 10,
    Default = 2,
    Rounding = 3,
    Callback = function(Value)
        for _, data in pairs(BOXESP) do
            data.Box.Thickness = Value
        end
    end
})

groups.ESPBox:AddDivider()

local TracerESP = groups.ESPBox:AddToggle("TracerESPTog1", {
    Text = "Tracers",
    Default = false,
    Callback = function(Value)
        NotifyToggle("Tracers", Value)
        if not Value then
            for _, data in pairs(TRACERESP) do
                data.Line.Visible = false
            end
        end
    end
})
groups.ESPBox:AddSlider("TracerTransparencySlider1", {
    Text = "Tracer Transparency",
    Min = 0,
    Max = 1,
    Default = 0.5,
    Rounding = 3,
    Float = true,
    Callback = function(Value)
        for _, data in pairs(TRACERESP) do
            data.Line.Transparency = Value
        end
    end
})
groups.ESPBox:AddSlider("TracerThicknessSlider1", {
    Text = "Tracer Thickness",
    Min = 1,
    Max = 5,
    Default = 2,
    Rounding = 3,
    Callback = function(Value)
        for _, data in pairs(TRACERESP) do
            data.Line.Thickness = Value
        end
    end
})

groups.ESPBox:AddDivider()

local SkeletonESP = groups.ESPBox:AddToggle("SkeletonESPTog1", {
    Text = "Skeleton ESP",
    Default = false,
    Callback = function(Value)
        NotifyToggle("Skeleton ESP", Value)
        if not Value then
            for _, lines in pairs(SKELETONESP) do
                for _, line in pairs(lines) do
                    line.Visible = false
                end
            end
        end
    end
})
groups.ESPBox:AddSlider("SkeletonTransparencySlider1", {
    Text = "Skeleton Transparency",
    Min = 0,
    Max = 1,
    Default = 0.5,
    Rounding = 3,
    Float = true,
    Callback = function(Value)
        for _, lines in pairs(SKELETONESP) do
            for _, line in pairs(lines) do
                line.Transparency = Value
            end
        end
    end
})
groups.ESPBox:AddSlider("SkeletonThicknessSlider1", {
    Text = "Skeleton Thickness",
    Min = 1,
    Max = 5,
    Default = 2,
    Rounding = 3,
    Callback = function(Value)
        for _, lines in pairs(SKELETONESP) do
            for _, line in pairs(lines) do
                line.Thickness = Value
            end
        end
    end
})

local function UpdateSkeleton(player)
    local char = player.Character
    if not char then
        return
    end
    local connections = {
        { "Head", "Torso" },
        { "Torso", "Left Arm" },
        { "Torso", "Right Arm" },
        { "Torso", "Left Leg" },
        { "Torso", "Right Leg" }
    }
    local lines = SKELETONESP[player]
    if #lines == 0 then
        for _ = 1, #connections do
            local l = Drawing.new("Line")
            l.Visible, l.Thickness, l.Color, l.Transparency = false, 1.5, Color3.fromRGB(255, 255, 255), 1
            table.insert(lines, l)
        end
    end
    local color = player.Team and player.TeamColor.Color or Color3.fromRGB(255, 255, 255)
    for i, connection in ipairs(connections) do
        local partA = char:FindFirstChild(connection[1])
        local partB = char:FindFirstChild(connection[2])
        local line = lines[i]
        if partA and partB and SkeletonESP.Value then
            local posA, onScreenA = camera:WorldToViewportPoint(partA.Position)
            local posB, onScreenB = camera:WorldToViewportPoint(partB.Position)
            if onScreenA and onScreenB then
                line.From = Vector2.new(posA.X, posA.Y)
                line.To = Vector2.new(posB.X, posB.Y)
                line.Color = color
                line.Visible = true
            else
                line.Visible = false
            end
        else
            line.Visible = false
        end
    end
end

groups.ESPBox:AddDivider()

local NameESP = groups.ESPBox:AddToggle("NameESP1", {
    Text = "Name ESP",
    Default = false,
    Callback = function(Value)
        NotifyToggle("Name ESP", Value)
        if not Value then
            for _, data in pairs(NAMEESP) do
                data.Text.Visible = false
            end
        end
    end
})
groups.ESPBox:AddSlider("NameESPTransparency", {
    Text = "Name Transparency",
    Min = 0,
    Max = 1,
    Default = 0.5,
    Rounding = 3,
    Float = true,
    Callback = function(Value)
        for _, data in pairs(NAMEESP) do
            data.Text.Transparency = Value
        end
    end
})

groups.ESPBox:AddDivider()

local HpEsptog = groups.ESPBox:AddToggle("HpEsptog1", {
    Text = "Health ESP",
    Default = false,
    Callback = function(Value)
        NotifyToggle("Health ESP", Value)
        if not Value then
            for _, data in pairs(HPESP) do
                data.Text.Visible = false
            end
        end
    end
})

groups.ESPBox:AddSlider("HealthESPTransparency", {
    Text = "Health Transparency",
    Min = 0,
    Max = 1,
    Default = 0.5,
    Rounding = 3,
    Float = true,
    Callback = function(Value)
        for _, data in pairs(HPESP) do
            data.Text.Transparency = Value
        end
    end
})

groups.ESPBox:AddDivider()

local ToolEsptog = groups.ESPBox:AddToggle("ToolEsptog", {
    Text = "Tool ESP",
    Default = false,
    Callback = function(Value)
        NotifyToggle("Tool ESP", Value)
        if not Value then
            for _, data in pairs(TOOLESP) do
                data.ToolText.Visible = false
            end
        end
    end
})
groups.ESPBox:AddSlider("ToolESPTransparency", {
    Text = "Tool Transparency",
    Min = 0,
    Max = 1,
    Default = 0.5,
    Rounding = 3,
    Float = true,
    Callback = function(Value)
        for _, data in pairs(TOOLESP) do
            data.ToolText.Transparency = Value
        end
    end
})

services.RunService.RenderStepped:Connect(function()
    if not (BoxESP.Value or TracerESP.Value or SkeletonESP.Value or NameESP.Value or HpEsptog.Value or ToolEsptog.Value) then
        return
    end
    for player, _ in pairs(BOXESP) do
        local char = player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then
            BOXESP[player].Box.Visible = false
            TRACERESP[player].Line.Visible = false
            NAMEESP[player].Text.Visible = false
            HPESP[player].Text.Visible = false
            TOOLESP[player].ToolText.Visible = false
            if SKELETONESP[player] then
                for _, l in pairs(SKELETONESP[player]) do
                    l.Visible = false
                end
            end
            continue
        end

        local hrp = char.HumanoidRootPart
        local humanoid = char:FindFirstChild("Humanoid")
        local pos, onscreen = camera:WorldToViewportPoint(hrp.Position)
        local color = player.Team and player.TeamColor.Color or Color3.fromRGB(255, 255, 255)
        if not onscreen then
            BOXESP[player].Box.Visible = false
            TRACERESP[player].Line.Visible = false
            NAMEESP[player].Text.Visible = false
            HPESP[player].Text.Visible = false
            TOOLESP[player].ToolText.Visible = false
            if SKELETONESP[player] then
                for _, l in pairs(SKELETONESP[player]) do
                    l.Visible = false
                end
            end
            continue
        end

        local dist = (camera.CFrame.Position - hrp.Position).Magnitude
        local scale = 1000 / dist
        local width, height = 4 * scale, 6 * scale

        if BoxESP.Value then
            local box = BOXESP[player].Box
            box.Size = Vector2.new(width, height)
            box.Position = Vector2.new(pos.X - width / 2, pos.Y - height / 2)
            box.Color = color
            box.Visible = true
        else
            BOXESP[player].Box.Visible = false
        end

        if TracerESP.Value then
            local line = TRACERESP[player].Line
            line.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
            line.To = Vector2.new(pos.X, pos.Y)
            line.Color = color
            line.Visible = true
        else
            TRACERESP[player].Line.Visible = false
        end

        if NameESP.Value then
            local nametext = NAMEESP[player].Text
            nametext.Position = Vector2.new(pos.X - nametext.TextBounds.X / 2, pos.Y - height / 2 - 20)
            nametext.Color = color
            nametext.Visible = true
        else
            NAMEESP[player].Text.Visible = false
        end

        if HpEsptog.Value and humanoid then
            local hptext = HPESP[player].Text
            hptext.Text = "HP: " .. math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
            hptext.Position = Vector2.new(pos.X - hptext.TextBounds.X / 2, pos.Y + height / 2 + 5)
            hptext.Color = color
            hptext.Visible = true
        else
            HPESP[player].Text.Visible = false
        end

        if ToolEsptog.Value then
            local tooltext = TOOLESP[player].ToolText
            local tool = char:FindFirstChildOfClass("Tool")
            tooltext.Text = tool and tool.Name or "No Tool"
            tooltext.Position = Vector2.new(pos.X - tooltext.TextBounds.X / 2, pos.Y + height / 2 + 20)
            tooltext.Color = color
            tooltext.Visible = true
        else
            TOOLESP[player].ToolText.Visible = false
        end

        if SkeletonESP.Value then
            UpdateSkeleton(player)
        elseif SKELETONESP[player] then
            for _, l in pairs(SKELETONESP[player]) do
                l.Visible = false
            end
        end
    end
end)

local PlayerDropdown = groups.Teleportation:AddDropdown("PlayerDropdown1", {
    SpecialType = "Player",
    Text = "Select Player",
    Multi = false,
    ExcludeLocalPlayer = true
})
groups.Teleportation:AddButton({
    Text = "Teleport To Player",
    Func = function()
        if PlayerDropdown.Value and PlayerDropdown.Value.Character and PlayerDropdown.Value.Character.PrimaryPart then
            LocalPlayer.Character:MoveTo(PlayerDropdown.Value.Character.PrimaryPart.Position)
            Library:Notify("Teleported to " .. PlayerDropdown.Value.Name, 3)
        end
    end
})
groups.Teleportation:AddDivider()

local LocationDropdowns12 = groups.Teleportation:AddDropdown("LocationDropdowns121", {
    Text = "Select Location",
    Default = "Armory",
    Values = { "Armory", "Inside Prison", "Secret Room", "Prison Yard", "Criminal Base", "Prison Car Spawner", "Prison Kitchen" }
})
groups.Teleportation:AddButton({
    Text = "Teleport To Location",
    Func = function()
        if LocationDropdowns12.Value then
            LocalPlayer.Character:MoveTo(positionsinfo[LocationDropdowns12.Value])
            Library:Notify("Teleported to " .. LocationDropdowns12.Value, 3)
        end
    end
})
groups.Teleportation:AddDivider()

local carContainer = workspace:WaitForChild("CarContainer")
local listcars = {}

local function refreshlist()
    for _, car in ipairs(carContainer:GetChildren()) do
        local seat = car:FindFirstChild("VehicleSeat", true)

        if seat
        and car:FindFirstChild("Wheels")
        and not seat.Occupant
        and not table.find(listcars, car) then
            table.insert(listcars, car)
        end
    end
end

local function findLocalCar()
    for _, car in pairs(carContainer:GetChildren()) do
        for _, obj in pairs(car:GetDescendants()) do
            if obj:IsA("VehicleSeat") and obj.Occupant then
                local char = obj.Occupant.Parent
                if char and char == LocalPlayer.Character then
                    return car
                end
            end
        end
    end
    return nil
end

local function flipCarVertical()
    local car = findLocalCar()
    if not car then
        return
    end
    local main = car:FindFirstChild("Body") and car.Body:FindFirstChild("Main")
    if not main then
        return
    end
    car.PrimaryPart = main
    local curCF = main.CFrame
    local x, y, z = curCF:ToEulerAnglesYXZ()
    local flipped = CFrame.new(curCF.Position) * CFrame.Angles(x + math.pi, y, z)
    car:PivotTo(flipped)
end

local function teleportCarToMe(car)
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    
    local player = Players.LocalPlayer
    local character = player.Character
    
    if not character then
        return false
    end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then
        return false
    end

    if not car or not car:IsA("Model") then
        return false
    end

    local body = car:FindFirstChild("Body")
    local main = body and body:FindFirstChild("Main")
    if not main then
        return false
    end
    
    local vehicleSeat = car:FindFirstChild("VehicleSeat", true)
    if not vehicleSeat then
        return false
    end

    local targetPos = humanoidRootPart.Position + Vector3.new(0, 3, 0) 
    local curCF = main.CFrame
    local x, y, z = curCF:ToEulerAnglesYXZ()
    local targetCFrame = CFrame.new(targetPos) * CFrame.Angles(x, y, z)

    local partData = {}
    for _, v in ipairs(car:GetDescendants()) do
        if v:IsA("BasePart") then
            table.insert(partData, {
                part = v,
                wasAnchored = v. Anchored,
                wasCanCollide = v. CanCollide
            })
            v.Anchored = true
            v.CanCollide = false
        end
    end

    car.PrimaryPart = main

    local characterParts = {}
    for _, v in ipairs(character:GetDescendants()) do
        if v:IsA("BasePart") then
            table.insert(characterParts, {part = v, wasAnCollide = v. CanCollide})
            v.CanCollide = false
        end
    end

    local success = false
    local maxAttempts = 20
    local tolerance = 5

    for attempt = 1, maxAttempts do
        pcall(function()
            car:PivotTo(targetCFrame)
        end)
        
        task.wait()
        
        local distance = (main.Position - targetPos).Magnitude
        if distance < tolerance then
            success = true
            break
        end
        
        if attempt % 5 == 0 then
            targetCFrame = CFrame. new(targetPos + Vector3.new(math.random(-2, 2), 0, math.random(-2, 2))) * CFrame. Angles(x, y, z)
        end
    end

    if not success then

    end

    task.spawn(function()
        local seatSuccess = false
        for attempt = 1, maxAttempts do
            if not character or not character:FindFirstChild("HumanoidRootPart") then
                break
            end
            
            pcall(function()
                character: PivotTo(vehicleSeat. CFrame + Vector3.new(0, 1, 0))
            end)
            
            task.wait()
            
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local seatDistance = (hrp.Position - vehicleSeat.Position).Magnitude
                if seatDistance < 3 then
                    seatSuccess = true
                    break
                end
            end
        end
        
        if not seatSuccess then
            
        end
    end)

    task.wait(0.2)

    local restoreConnection
    restoreConnection = RunService.RenderStepped:Connect(function()
        restoreConnection: Disconnect()
        
        for _, data in ipairs(characterParts) do
            if data.part and data.part. Parent then
                data.part.CanCollide = data. wasCanCollide
            end
        end
        
        for _, data in ipairs(partData) do
            if data.part and data.part.Parent then
                data. part.Anchored = data.wasAnchored
                data.part. CanCollide = data.wasCanCollide
            end
        end
    end)
    
    return success
end

local VehicleFLY = groups.Teleportation:AddToggle("VehicleFLY", {
    Text = "Vehicle Fly",
    Default = false,
    Callback = function(Value)
        NotifyToggle("Vehicle Fly", Value)
    end
})
local VehicleFLYSlider = groups.Teleportation:AddSlider("VehicleFLYSlider", {
    Text = "Height Slider",
    Default = 0,
    Min = 0,
    Max = 100,
    Rounding = 3
})

groups.Teleportation:AddDivider()

groups.Teleportation:AddButton({
    Text = "Flip Car",
    Func = function()
        Library:Notify("Flip Car Attempt", 3)
        flipCarVertical()
    end,
    DoubleClick = true
})

task.spawn(function()
    local MOVE_STEP = 1
    local TOL = 0.1
    local baseY, targetY, lastSlider = nil, nil, nil
    while true do
        task.wait()
        if not VehicleFLY.Value then
            baseY, targetY, lastSlider = nil, nil, nil
            if workspace:FindFirstChild("CarPart") then
                workspace.CarPart:Destroy()
            end
            continue
        end

        local car = findLocalCar()
        if not car then
            if workspace:FindFirstChild("CarPart") then
                workspace.CarPart:Destroy()
            end
            baseY, targetY, lastSlider = nil, nil, nil
            continue
        end

        local main = car:FindFirstChild("Body") and car.Body:FindFirstChild("Main")
        if not main then
            continue
        end
        car.PrimaryPart = main
        local curCF = main.CFrame
        local curPos = curCF.Position
        local sliderVal = VehicleFLYSlider.Value

        if not workspace:FindFirstChild("CarPart") then
            local p = Instance.new("Part")
            p.Size = Vector3.new(100, 1, 100)
            p.Name = "CarPart"
            p.Anchored = true
            p.CanCollide = true
            p.Material = Enum.Material.SmoothPlastic
            p.Color = Color3.fromRGB(100, 100, 100)
            p.Transparency = 1
            p.Parent = workspace
        end

        if not baseY then
            baseY = curPos.Y
            targetY = baseY + sliderVal
            lastSlider = sliderVal
        elseif sliderVal ~= lastSlider then
            targetY = baseY + sliderVal
            lastSlider = sliderVal
        end

        if curPos.Y < targetY - TOL then
            local x, y, z = curCF:ToEulerAnglesYXZ()
            local newY = math.min(curPos.Y + MOVE_STEP, targetY)
            car:PivotTo(CFrame.new(Vector3.new(curPos.X, newY, curPos.Z)) * CFrame.Angles(x, y, z))
        elseif curPos.Y > targetY + TOL then
            local x, y, z = curCF:ToEulerAnglesYXZ()
            local newY = math.max(curPos.Y - MOVE_STEP, targetY)
            car:PivotTo(CFrame.new(Vector3.new(curPos.X, newY, curPos.Z)) * CFrame.Angles(x, y, z))
        end
    end
end)

services.RunService.Heartbeat:Connect(function()
    pcall(function()
        local carPart = workspace:FindFirstChild("CarPart")
        if not carPart then
            return
        end
        local car = findLocalCar()
        if not car or not car:FindFirstChild("Wheels") then
            return
        end
        local wheel = car.Wheels:FindFirstChildWhichIsA("BasePart")
        if not wheel then
            return
        end
        carPart.Position = Vector3.new(wheel.Position.X, wheel.Position.Y - 1.3, wheel.Position.Z)
    end)
end)

groups.Teleportation:AddDivider()

local VehicleSPEED = groups.Teleportation:AddToggle("VehicleSPEED", {
    Text = "Vehicle Speed Modifier",
    Default = false,
    Callback = function(Value)
        NotifyToggle("Vehicle Speed Modifier", Value)
    end
})
local VehicleMaxSpeed = groups.Teleportation:AddSlider("VehicleMaxSpeed", {
    Text = "Vehicle Max Speed",
    Default = 110,
    Min = 1,
    Max = 350,
    Rounding = 3
})
local VehicleTorque = groups.Teleportation:AddSlider("VehicleTorque", {
    Text = "Vehicle Torque",
    Default = 5,
    Min = 1,
    Max = 50,
    Rounding = 3
})
local VehicleTurnSpeed = groups.Teleportation:AddSlider("VehicleTurnSpeed", {
    Text = "Vehicle Turn Speed",
    Default = 5,
    Min = 1,
    Max = 20,
    Rounding = 3
})

groups.Teleportation:AddDivider()

refreshlist()
local carlistdropdown = groups.Teleportation:AddDropdown("carlistdropdown1", {
    Text = "Car List",
    Default = "",
    Values = listcars
})

groups.Teleportation:AddButton({
    Text = "Refresh List",
    Func = function()
        Library:Notify("Refresh Car Table Attempt", 3)
        listcars = {}
        refreshlist()
        carlistdropdown:SetValues(listcars)
    end,
    DoubleClick = false
})

groups.Teleportation:AddButton({
    Text = "Bring Car",
    Func = function()
        Library:Notify("Bring Car Attempt", 3)
            if carlistdropdown.Value then
               teleportCarToMe(carlistdropdown.Value)
            end
    end,
    DoubleClick = false
})

groups.Teleportation:AddButton({
    Text = "Teleport to Car",
    Func = function()
        Library:Notify("Teleport to Car Attempt", 3)
        if carlistdropdown.Value then
            local vehicleseat = carlistdropdown.Value:FindFirstChild("VehicleSeat", true)
            if vehicleseat then
                LocalPlayer.Character:MoveTo(vehicleseat.Position)
            end
        end
    end,
    DoubleClick = false
})

services.RunService.RenderStepped:Connect(function()
    local car = findLocalCar()
    if car then
        local rwd = car:FindFirstChild("RWD")
        local lw = car:FindFirstChild("LW") and car.LW:FindFirstChild("VS")
        local rw = car:FindFirstChild("RW") and car.RW:FindFirstChild("VS")
        local vehicleseat = car:FindFirstChild("Body") and car.Body:FindFirstChild("VehicleSeat")
        if rwd and lw and rw and vehicleseat then
            if VehicleSPEED.Value then
                rwd.MaxSpeed = VehicleMaxSpeed.Value
                lw.MaxSpeed = VehicleMaxSpeed.Value
                rw.MaxSpeed = VehicleMaxSpeed.Value
                vehicleseat.MaxSpeed = VehicleMaxSpeed.Value

                rwd.Torque = VehicleTorque.Value
                lw.Torque = VehicleTorque.Value
                rw.Torque = VehicleTorque.Value
                vehicleseat.Torque = VehicleTorque.Value

                rwd.TurnSpeed = VehicleTurnSpeed.Value
                lw.TurnSpeed = VehicleTurnSpeed.Value
                rw.TurnSpeed = VehicleTurnSpeed.Value
                vehicleseat.TurnSpeed = VehicleTurnSpeed.Value
            else
                rwd.TurnSpeed = 1
                lw.TurnSpeed = 1
                rw.TurnSpeed = 1
                vehicleseat.TurnSpeed = 1
            end
        end
    end
end)

local brightnessConnection
local brightnessSlider
groups.Environment:AddToggle("BrightnessToggle", {
    Text = "Brightness",
    Default = false,
    Callback = function(Value)
        NotifyToggle("Brightness Enhancer", Value)
        if Value then
            if brightnessConnection then
                brightnessConnection:Disconnect()
            end
            brightnessConnection = services.RunService.RenderStepped:Connect(function()
                services.Lighting.Brightness = brightnessSlider.Value
            end)
        else
            if brightnessConnection then
                brightnessConnection:Disconnect()
                brightnessConnection = nil
            end
            services.Lighting.Brightness = 1
        end
    end
})
brightnessSlider = groups.Environment:AddSlider("BrightnessSlider", {
    Text = "Brightness Slider",
    Default = 1,
    Min = 0,
    Max = 10,
    Rounding = 3
})

groups.Environment:AddDivider()

local timeConnection
local timeSlider
groups.Environment:AddToggle("TimeOfDayToggle", {
    Text = "Time of Day",
    Default = false,
    Callback = function(Value)
        NotifyToggle("Time of Day", Value)
        if Value then
            if timeConnection then
                timeConnection:Disconnect()
            end
            timeConnection = services.RunService.RenderStepped:Connect(function()
                services.Lighting.ClockTime = timeSlider.Value
            end)
        else
            if timeConnection then
                timeConnection:Disconnect()
                timeConnection = nil
            end
        end
    end
})
timeSlider = groups.Environment:AddSlider("TimeSlider", {
    Text = "Time Slider",
    Default = 14,
    Min = 0,
    Max = 24,
    Rounding = 3
})

groups.Environment:AddDivider()

local outconn
local originalOutdoorAmbient = services.Lighting.OutdoorAmbient
local outamb = services.Lighting.OutdoorAmbient
local outdoorAmbientToggle = groups.Environment:AddToggle("OutdoorAmbientToggle", {
    Text = "Outdoor Ambient",
    Default = false,
    Callback = function(Value)
        NotifyToggle("Outdoor Ambient Changer", Value)
        if not Value then
            if outconn then
                outconn:Disconnect()
                outconn = nil
            end
            services.Lighting.OutdoorAmbient = originalOutdoorAmbient
        else
            if outconn then
                outconn:Disconnect()
            end
            outconn = services.RunService.Heartbeat:Connect(function()
                services.Lighting.OutdoorAmbient = outamb
            end)
        end
    end
})
outdoorAmbientToggle:AddColorPicker("OutdoorAmbientPicker", {
    Default = services.Lighting.OutdoorAmbient,
    Title = "Outdoor Ambient",
    Transparency = 0,
    Callback = function(Value)
        if outdoorAmbientToggle.Value then
            services.Lighting.OutdoorAmbient = Value
            outamb = Value
        end
    end
})

local inconn
local originalAmbient = services.Lighting.Ambient
local inamb = services.Lighting.Ambient
local ambientToggle = groups.Environment:AddToggle("AmbientToggle", {
    Text = "Ambient",
    Default = false,
    Callback = function(Value)
        NotifyToggle("Ambient Changer", Value)
        if not Value then
            if inconn then
                inconn:Disconnect()
                inconn = nil
            end
            services.Lighting.Ambient = originalAmbient
        else
            if inconn then
                inconn:Disconnect()
            end
            inconn = services.RunService.Heartbeat:Connect(function()
                services.Lighting.Ambient = inamb
            end)
        end
    end
})
ambientToggle:AddColorPicker("AmbientPicker", {
    Default = services.Lighting.Ambient,
    Title = "Ambient",
    Transparency = 0,
    Callback = function(Value)
        if ambientToggle.Value then
            services.Lighting.Ambient = Value
            inamb = Value
        end
    end
})

groups.Environment:AddDivider()

local originalFogSettings = {
    Color = services.Lighting.FogColor,
    End = services.Lighting.FogEnd,
    Start = services.Lighting.FogStart
}

local newfogsettings = {
    Color = services.Lighting.FogColor,
    End = services.Lighting.FogEnd,
    Start = services.Lighting.FogStart
}


local fogToggle = groups.Environment:AddToggle("FogToggle", {
    Text = "Fog Changer",
    Default = false,
    Callback = function(Value)
        NotifyToggle("Fog Changer", Value)
        if not Value then
            services.Lighting.FogColor = originalFogSettings.Color
            services.Lighting.FogEnd = originalFogSettings.End
            services.Lighting.FogStart = originalFogSettings.Start
        else
            services.Lighting.FogColor = newfogsettings.Color
            services.Lighting.FogEnd = newfogsettings.End
            services.Lighting.FogStart = newfogsettings.Start
        end
    end
})
fogToggle:AddColorPicker("FogColorPicker", {
    Default = services.Lighting.FogColor,
    Title = "Fog Color",
    Transparency = 0,
    Callback = function(Value)
        if Value then
            services.Lighting.FogColor = Value
            newfogsettings.Color = Value
        end
    end
})
groups.Environment:AddSlider("FogEndSlider", {
    Text = "Fog End",
    Default = services.Lighting.FogEnd,
    Min = 0,
    Max = 5000,
    Rounding = 0,
    Callback = function(Value)
        if fogToggle.Value then
            services.Lighting.FogEnd = Value
            newfogsettings.End = Value
        end
    end
})
groups.Environment:AddSlider("FogStartSlider", {
    Text = "Fog Start",
    Default = services.Lighting.FogStart,
    Min = 0,
    Max = 5000,
    Rounding = 0,
    Callback = function(Value)
        if fogToggle.Value then
            services.Lighting.FogStart = Value
            newfogsettings.Start = Value
        end
    end
})

groups.Environment:AddDivider()

local SkyboxChangerToggle = groups.Environment:AddToggle("SkyboxChangerToggle1", {
    Text = "Skybox Changer",
    Default = false,
    Callback = function(Value)
        NotifyToggle("Skybox Changer", Value)
    end
})

local SkyboxChangerDropdown = groups.Environment:AddDropdown("SkyboxChangerDropdown1", {
    Text = "Select Skybox",
    Default = "Redshift",
    Values = {"Purple Nebula","Christmas","Tattletail","Clouds","Sunrise","Dark Storms","Night Sky","Pink Daylight","Morning Glow","Setting Sun","Fade Blue","Elegant Morning","Neptune","Redshift","Aesthetic Night"}
})

task.spawn(function()
    while true do
        wait(0.05)
        if SkyboxChangerToggle.Value == true then
            if SkyboxChangerDropdown.Value then
                local skyboxinfo = skyboxes[SkyboxChangerDropdown.Value]

                if not services.Lighting:FindFirstChild("skycustom") then
                    local sky = Instance.new("Sky")
                    sky.Name = "skycustom"
                    sky.Parent = services.Lighting
                else
                    services.Lighting:FindFirstChild("skycustom").SkyboxBk = skyboxinfo.SkyboxBk
                    services.Lighting:FindFirstChild("skycustom").SkyboxDn = skyboxinfo.SkyboxDn
                    services.Lighting:FindFirstChild("skycustom").SkyboxFt = skyboxinfo.SkyboxFt
                    services.Lighting:FindFirstChild("skycustom").SkyboxLf = skyboxinfo.SkyboxLf
                    services.Lighting:FindFirstChild("skycustom").SkyboxRt = skyboxinfo.SkyboxRt
                    services.Lighting:FindFirstChild("skycustom").SkyboxUp = skyboxinfo.SkyboxUp
                end
            end
        else
            if services.Lighting:FindFirstChild("skycustom") then
                services.Lighting:FindFirstChild("skycustom"):Destroy()
            end
        end
    end
end)

groups.WorldPhysics:AddSlider("GravitySlider", {
    Text = "Gravity",
    Default = workspace.Gravity,
    Min = 0,
    Max = 200,
    Rounding = 1,
    Callback = function(Value)
        workspace.Gravity = Value
    end
})

LocalPlayer.FriendStatusChanged:Connect(function(player, status)
    local char = player.Character
    if not char then
        return
    end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        return
    end
    if status == Enum.FriendStatus.Friend then
        friends[player.UserId] = true
    else
        friends[player.UserId] = false
        if HitboxToggle.Value then
            createHitbox(char)
        end
    end
end)
