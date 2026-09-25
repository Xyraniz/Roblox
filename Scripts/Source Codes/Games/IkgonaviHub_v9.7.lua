local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local Camera = Workspace.CurrentCamera
local GuiService = game:GetService("GuiService")

local DrawingLib = nil
pcall(function() DrawingLib = Drawing end)
if not DrawingLib then
	DrawingLib = {
		new = function()
			return setmetatable({
				Visible = false, Transparency = 1, Color = Color3.new(1,1,1),
				Thickness = 1, Size = 0, Position = Vector2.zero,
				From = Vector2.zero, To = Vector2.zero, Text = "",
				Center = false, Outline = false, Filled = false, Radius = 0,
			}, {
				__index = function(t, k)
					if k == "Remove" or k == "Destroy" then return function() end end
					return rawget(t, k)
				end,
			})
		end,
	}
end
local Drawing = DrawingLib

local _ikg_real_getgenv = getgenv
local _ikg_store = rawget(_G, "__IKG_STORE")
if type(_ikg_store) ~= "table" then
	_ikg_store = {}
	pcall(rawset, _G, "__IKG_STORE", _ikg_store)
end
pcall(function()
	local env = _ikg_real_getgenv()
	for _, key in ipairs({
		"SilentAim","AutoShot","TriggerBot","KillAll","AntiKillAll",
		"Tool2Macro","ESP","Hitbox","Movement","Unique","Keybinds","HubTheme","Streamer","AnimMix","AutoFarm"
	}) do
		local v = env[key]
		if type(v) == "table" and type(_ikg_store[key]) ~= "table" then
			local copy = {}
			for kk, vv in pairs(v) do copy[kk] = vv end
			_ikg_store[key] = copy
		end
	end
end)
local function getgenv()
	local real = _ikg_real_getgenv()
	return setmetatable({}, {
		__index = function(_, k)
			if _ikg_store[k] ~= nil then return _ikg_store[k] end
			local ok, v = pcall(function() return real[k] end)
			if ok then return v end
			return nil
		end,
		__newindex = function(_, k, v)
			_ikg_store[k] = v
			pcall(function() real[k] = v end)
		end,
	})
end

getgenv().SilentAim = getgenv().SilentAim or {
	Enabled = false, FOV = math.huge, Prediction = 100, Part = "Head", WallCheck = true
}
getgenv().AutoShot = getgenv().AutoShot or { Enabled = false, Delay = 0.12, WallCheck = true }
getgenv().TriggerBot = getgenv().TriggerBot or { Enabled = false, WallCheck = true }
getgenv().SilentAim.WallCheck = true
getgenv().AutoShot.WallCheck = true
getgenv().TriggerBot.WallCheck = true
getgenv().KillAll = getgenv().KillAll or {
	Enabled = false, Speed = 16, CycleWait = 9, ClickSpam = 10,
	BehindOffset = 3.5, UnderOffset = 5.5, HitboxSize = 8
}
getgenv().AntiKillAll = getgenv().AntiKillAll or { Enabled = false }
getgenv().Tool2Macro = getgenv().Tool2Macro or { Enabled = false }
getgenv().ESP = getgenv().ESP or {
	Enabled = false, Chams = false, Boxes = false, Tracers = false,
	Names = true, Distance = false, TracerOrigin = "Bottom",
	Color = Color3.fromRGB(232, 145, 42),
	OutlineColor = Color3.fromRGB(255, 190, 90),
	TextColor = Color3.fromRGB(255, 245, 230),
	Thickness = 1.5,
	ChamsFill = 0.55,
	TeamCheck = true,
}
getgenv().Hitbox = getgenv().Hitbox or { Enabled = false, Size = 2, Transparency = 0.95 }
getgenv().Movement = getgenv().Movement or {
	Speed = 16, JumpPower = 50, Noclip = false, AutoFarm = false,
	Ghost = false, InfJump = false, Fullbright = false, FOV = 70,
	Fly = false, FlySpeed = 50,
}
getgenv().SafeMode = (getgenv().SafeMode == nil) and false or getgenv().SafeMode
getgenv().AutoFarm = getgenv().AutoFarm or {
	Enabled = false,
	SpamRate = 60,
	BurstSize = 10,
	BurstGap = 0.015,
	SmartCollect = true,
	CollectRange = 35,
	CollectSpeed = 42,
	TpCollect = false,
	TpGap = 0.35,
	OnlyWhenAlive = true,
	PauseOnKillAll = true,
	StatusText = true,
	DoubleFire = true,
	MaxRate = 150,
}
getgenv().Unique = getgenv().Unique or {
	EnemyRadar = false, SoftWalk = false, MatchInfo = true, AntiSit = false,
	AutoRespawn = false, NoFallDamage = false, ZoomLock = false, EspHealth = false,
	AutoSprint = false, ClickTP = false, LowGravity = false, NoClipCam = false,
	MagnetTP = false, MagnetGap = 0.12, FpsBoost = false, ShowStats = false,
	TouchFarm = true, -- firetouchinterest en SpawnablesClient
}
getgenv().Keybinds = getgenv().Keybinds or {}
getgenv().HubTheme = getgenv().HubTheme or {
	Accent = Color3.fromRGB(232, 145, 42),
	AccentLight = Color3.fromRGB(255, 190, 90),
	Name = "Amber Core",
	FontName = "GothamBold",
	TextSize = 14,
	Outline = true,
}
getgenv().Streamer = getgenv().Streamer or {
	Mode = false, Mode100 = false, NoRankTag = false, CustomName = "",
}
getgenv().AnimMix = getgenv().AnimMix or {
	Pack = "Yours",
	Idle = nil, Walk = nil, Run = nil, Jump = nil, Fall = nil, Climb = nil, Swim = nil,
}
getgenv()._IKG_OriginalAnims = getgenv()._IKG_OriginalAnims or nil

local function detectDevice()
	local touch = UserInputService.TouchEnabled
	local kb = UserInputService.KeyboardEnabled
	local tenFoot = false
	pcall(function() tenFoot = GuiService:IsTenFootInterface() end)
	if tenFoot then return "Console" end
	if touch and not kb then return "Mobile" end
	return "PC"
end
local DEVICE = detectDevice()
getgenv().IkgDevice = DEVICE

local function resolveDrawingFont()
	local name = (getgenv().HubTheme and getgenv().HubTheme.FontName) or "UI"
	local map = {
		UI = 0, System = 0, Gotham = 0, GothamBold = 0,
		Plex = 1, Monospace = 2, Mono = 2,
	}
	local id = map[name] or 0
	pcall(function()
		if Drawing and Drawing.Fonts then
			if name == "Plex" and Drawing.Fonts.Plex then id = Drawing.Fonts.Plex end
			if (name == "Monospace" or name == "Mono") and Drawing.Fonts.Monospace then id = Drawing.Fonts.Monospace end
			if (name == "UI" or name == "Gotham" or name == "GothamBold") and Drawing.Fonts.UI then id = Drawing.Fonts.UI end
			if name == "System" and Drawing.Fonts.System then id = Drawing.Fonts.System end
		end
	end)
	return id
end

local function applyThemeToDrawingText(obj)
	if not obj then return end
	pcall(function()
		obj.Font = resolveDrawingFont()
		obj.Size = (getgenv().HubTheme and getgenv().HubTheme.TextSize) or 14
		if obj.Outline ~= nil then
			obj.Outline = getgenv().HubTheme and getgenv().HubTheme.Outline ~= false
		end
	end)
end

local function resolveGuiFont()
	local name = (getgenv().HubTheme and getgenv().HubTheme.FontName) or "GothamBold"
	local ok, font = pcall(function() return Enum.Font[name] end)
	if ok and font then return font end
	return Enum.Font.GothamBold
end

local function isEnemy(player)
	if player == LocalPlayer then return false end
	local myGame = LocalPlayer:GetAttribute("Game")
	local targetGame = player:GetAttribute("Game")
	if myGame and targetGame and myGame ~= targetGame then return false end
	local myTeam = LocalPlayer:GetAttribute("Team")
	local targetTeam = player:GetAttribute("Team")
	if myTeam and targetTeam then return myTeam ~= targetTeam end
	if LocalPlayer.Team and player.Team then return LocalPlayer.Team ~= player.Team end
	return false
end

local function isTargetVisible(targetPart)
	-- WallCheck siempre activo (Silent / AutoShot / Trigger)
	if not targetPart then return false end
	local origin = Camera.CFrame.Position
	local direction = targetPart.Position - origin
	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	local ignoreList = { LocalPlayer.Character }
	if targetPart.Parent then table.insert(ignoreList, targetPart.Parent) end
	raycastParams.FilterDescendantsInstances = ignoreList
	raycastParams.IgnoreWater = true
	local result = Workspace:Raycast(origin, direction, raycastParams)
	if not result then return true end
	if result.Instance:IsDescendantOf(targetPart.Parent) then return true end
	return false
end

local function resolveAimPart(char)
	if not char then return nil end
	local name = getgenv().SilentAim.Part or "Head"
	local part = char:FindFirstChild(name)
	if part and part:IsA("BasePart") then return part end
	return char:FindFirstChild("Head")
		or char:FindFirstChild("HumanoidRootPart")
		or char:FindFirstChild("UpperTorso")
		or char:FindFirstChild("Torso")
end

local function getClosest()
	local targetPart, targetPlayer, closest = nil, nil, math.huge
	local Cam = Workspace.CurrentCamera
	if not Cam then return nil, nil end
	local fov = getgenv().SilentAim.FOV or math.huge
	local unlimited = (not fov) or fov >= 5000
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character and isEnemy(p) then
			local char = p.Character
			local hrp = char:FindFirstChild("HumanoidRootPart")
			local part = resolveAimPart(char)
			local hum = char:FindFirstChildOfClass("Humanoid")
			if part and hrp and hum and hum.Health > 0 then
				if isTargetVisible(part) then
					local score
					if unlimited then
						local screenPos, onScreen = Cam:WorldToViewportPoint(part.Position)
						if onScreen and screenPos.Z > 0 then
							score = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Cam.ViewportSize.X / 2, Cam.ViewportSize.Y / 2)).Magnitude
						else
							score = 5000 + (Cam.CFrame.Position - part.Position).Magnitude
						end
					else
						local screenPos, onScreen = Cam:WorldToViewportPoint(part.Position)
						if onScreen and screenPos.Z > 0 then
							local mouseDist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Cam.ViewportSize.X / 2, Cam.ViewportSize.Y / 2)).Magnitude
							if mouseDist <= fov then score = mouseDist end
						end
					end
					if score and score < closest then
						closest = score
						targetPart = part
						targetPlayer = p
					end
				end
			end
		end
	end
	return targetPart, targetPlayer
end

local function isVisibleFromHRP(targetPart, myHRP)
	if not targetPart or not myHRP then return false end
	local origin = myHRP.Position + Vector3.new(0, 1.5, 0)
	local goal = targetPart.Position
	local dir = goal - origin
	if dir.Magnitude < 1 then return true end
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = { LocalPlayer.Character, targetPart.Parent }
	params.IgnoreWater = true
	local hit = Workspace:Raycast(origin, dir, params)
	if not hit then return true end
	if targetPart.Parent and hit.Instance:IsDescendantOf(targetPart.Parent) then return true end
	return false
end

local function getClosestForAutoShot()
	local targetPart, targetPlayer, closest = nil, nil, math.huge
	local myChar = LocalPlayer.Character
	if not myChar then return nil, nil end
	local myHRP = myChar:FindFirstChild("HumanoidRootPart")
	local myHum = myChar:FindFirstChildOfClass("Humanoid")
	if not myHRP or not myHum or myHum.Health <= 0 then return nil, nil end
	local doWall = true -- WallCheck always ON
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character and isEnemy(p) then
			local char = p.Character
			local hrp = char:FindFirstChild("HumanoidRootPart")
			local hum = char:FindFirstChildOfClass("Humanoid")
			local aimPart = resolveAimPart(char)
			if hrp and hum and hum.Health > 0 and aimPart and aimPart:IsA("BasePart") then
				if not doWall or isVisibleFromHRP(aimPart, myHRP) then
					local dist = (myHRP.Position - aimPart.Position).Magnitude
					if dist < closest then
						closest = dist
						targetPart = aimPart
						targetPlayer = p
					end
				end
			end
		end
	end
	return targetPart, targetPlayer
end

local fovCircle = nil
pcall(function()
	fovCircle = Drawing.new("Circle")
	fovCircle.Thickness = 1.5
	fovCircle.Color = Color3.fromRGB(232, 145, 42)
	fovCircle.Filled = false
	fovCircle.Visible = false
end)
if not fovCircle then fovCircle = Drawing.new("Circle") end

local _saMouse = nil
local _saCachePart, _saCachePlr, _saCacheUntil = nil, nil, 0
local _saBurstUntil = 0

getgenv()._IKG_SilentBurst = function(sec)
	_saBurstUntil = tick() + (sec or 0.2)
end

local function silentAimWanted()
	if tick() < _saBurstUntil then return true end
	local sa = getgenv().SilentAim
	if sa and sa.Enabled then return true end
	return false
end

local function getSilentTargetCached()
	local now = tick()
	if _saCachePart and _saCachePlr and now < _saCacheUntil then
		if _saCachePart.Parent then
			local hum = _saCachePlr.Character and _saCachePlr.Character:FindFirstChildOfClass("Humanoid")
			if hum and hum.Health > 0 then return _saCachePart, _saCachePlr end
		end
	end
	local part, plr = getClosest()
	_saCachePart, _saCachePlr = part, plr
	_saCacheUntil = now + 0.16
	return part, plr
end

if hookmetamethod and checkcaller then
	pcall(function() _saMouse = LocalPlayer:GetMouse() end)
	local oldIndex
	oldIndex = hookmetamethod(game, "__index", function(self, index)
		if index ~= "Hit" then return oldIndex(self, index) end
		if checkcaller() then return oldIndex(self, index) end
		if not _saMouse then pcall(function() _saMouse = LocalPlayer:GetMouse() end) end
		if self ~= _saMouse or not silentAimWanted() then return oldIndex(self, index) end
		local targetPart = getSilentTargetCached()
		if targetPart and targetPart.Parent then
			return CFrame.new(targetPart.Position)
		end
		return oldIndex(self, index)
	end)
end

RunService.RenderStepped:Connect(function()
	pcall(function()
		if not fovCircle then return end
		local sa = getgenv().SilentAim
		local cam = Workspace.CurrentCamera
		if not cam then return end
		local fov = (sa and sa.FOV) or 0
		if not sa or not sa.Enabled or (type(fov) == "number" and fov >= 5000) then
			fovCircle.Visible = false
		else
			fovCircle.Visible = true
			fovCircle.Radius = fov
			fovCircle.Position = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
			fovCircle.Color = getgenv().HubTheme.Accent
		end
	end)
end)

local function initSystems()
	local function getAndEquipTool2Safe()
		if getgenv().KillAll.Enabled then return nil end
		local char = LocalPlayer.Character
		if not char then return nil end
		local humanoid = char:FindFirstChildOfClass("Humanoid")
		if not humanoid then return nil end
		local backpack = LocalPlayer:FindFirstChild("Backpack")
		if not backpack then return nil end
		local tools = {}
		for _, item in ipairs(backpack:GetChildren()) do
			if item:IsA("Tool") then table.insert(tools, item) end
		end
		for _, item in ipairs(char:GetChildren()) do
			if item:IsA("Tool") then
				local seen = false
				for _, t in ipairs(tools) do if t == item then seen = true break end end
				if not seen then table.insert(tools, item) end
			end
		end
		local targetTool = tools[2]
		if not targetTool then return nil end
		local equipped = char:FindFirstChildOfClass("Tool")
		if equipped == targetTool then return targetTool end
		pcall(function()
			if equipped and equipped ~= targetTool then humanoid:UnequipTools() end
			humanoid:EquipTool(targetTool)
		end)
		task.wait(0.02)
		return char:FindFirstChildOfClass("Tool") == targetTool and targetTool or targetTool
	end

	local function forceUnequip()
		local char = LocalPlayer.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if hum then hum:UnequipTools() end
	end

	local cachedTool1, tool1NameLock = nil, nil

	local function collectAllTools()
		local list = {}
		local backpack = LocalPlayer:FindFirstChild("Backpack")
		local char = LocalPlayer.Character
		if backpack then
			for _, item in ipairs(backpack:GetChildren()) do
				if item:IsA("Tool") then table.insert(list, item) end
			end
		end
		if char then
			for _, item in ipairs(char:GetChildren()) do
				if item:IsA("Tool") then
					local seen = false
					for _, t in ipairs(list) do if t == item then seen = true break end end
					if not seen then table.insert(list, item) end
				end
			end
		end
		return list, backpack, char
	end

	local function refreshToolCache()
		local list, backpack = collectAllTools()
		local bpFirst = nil
		if backpack then
			for _, item in ipairs(backpack:GetChildren()) do
				if item:IsA("Tool") then bpFirst = item break end
			end
		end
		if tool1NameLock then
			for _, t in ipairs(list) do
				if t.Name == tool1NameLock then cachedTool1 = t break end
			end
		end
		if not cachedTool1 or not cachedTool1.Parent then
			cachedTool1 = bpFirst or list[1]
			if cachedTool1 then tool1NameLock = cachedTool1.Name end
		end
		return cachedTool1
	end

	local function stripToTool1Only()
		local char = LocalPlayer.Character
		local backpack = LocalPlayer:FindFirstChild("Backpack")
		if not char or not backpack then return nil end
		if not cachedTool1 or not cachedTool1.Parent then refreshToolCache() end
		local tool1 = cachedTool1
		if not tool1 then return nil end
		for _, item in ipairs(char:GetChildren()) do
			if item:IsA("Tool") and item ~= tool1 then
				pcall(function() item.Parent = backpack end)
			end
		end
		local hum = char:FindFirstChildOfClass("Humanoid")
		local equipped = char:FindFirstChildOfClass("Tool")
		if equipped and equipped ~= tool1 then
			pcall(function()
				if hum then hum:UnequipTools() end
				equipped.Parent = backpack
			end)
		end
		if tool1.Parent ~= char then
			pcall(function()
				if hum then hum:UnequipTools() end
				tool1.Parent = char
			end)
		end
		return (tool1.Parent == char) and tool1 or nil
	end

	local function hookCharToolGuard(char)
		if not char then return end
		char.ChildAdded:Connect(function(child)
			if not getgenv().KillAll.Enabled then return end
			if child:IsA("Tool") and cachedTool1 and child ~= cachedTool1 then
				task.defer(function()
					local bp = LocalPlayer:FindFirstChild("Backpack")
					if bp then pcall(function() child.Parent = bp end) end
					stripToTool1Only()
				end)
			end
		end)
	end
	if LocalPlayer.Character then hookCharToolGuard(LocalPlayer.Character) end
	LocalPlayer.CharacterAdded:Connect(function(char)
		cachedTool1, tool1NameLock = nil, nil
		hookCharToolGuard(char)
	end)

	local _stripAcc = 0
	RunService.Heartbeat:Connect(function(dt)
		if not getgenv().KillAll.Enabled then return end
		_stripAcc = _stripAcc + dt
		if _stripAcc < 0.25 then return end
		_stripAcc = 0
		stripToTool1Only()
	end)

	local function fireTool1Soft(tool1, enemyHum)
		if not tool1 then return end
		pcall(function() tool1:Activate() end)
		-- Duels / MM: Remote Kill / ThrowKill en el tool o Handle
		if enemyHum then
			pcall(function()
				local handle = tool1:FindFirstChild("Handle")
				local killEv = tool1:FindFirstChild("Kill")
					or tool1:FindFirstChild("ThrowKill")
					or (handle and handle:FindFirstChild("Kill"))
					or (handle and handle:FindFirstChild("ThrowKill"))
				if killEv and killEv:IsA("RemoteEvent") then
					killEv:FireServer(enemyHum)
				elseif killEv and killEv:IsA("RemoteFunction") then
					killEv:InvokeServer(enemyHum)
				end
			end)
		end
	end

	local function getSortedEnemies()
		local m = LocalPlayer:GetAttribute("Map")
		local gm = LocalPlayer:GetAttribute("Game")
		local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		local list = {}
		for _, v in ipairs(Players:GetPlayers()) do
			if v ~= LocalPlayer and isEnemy(v) then
				local c = v.Character
				local h = c and c:FindFirstChildOfClass("Humanoid")
				local er = c and c:FindFirstChild("HumanoidRootPart")
				local sameMap = (m == nil or v:GetAttribute("Map") == m)
				local sameGame = (gm == nil or v:GetAttribute("Game") == gm)
				if h and h.Health > 0 and er and sameMap and sameGame then
					local dist = myHRP and (myHRP.Position - er.Position).Magnitude or 0
					table.insert(list, { Player = v, Char = c, Hum = h, Root = er, Dist = dist })
				end
			end
		end
		table.sort(list, function(a, b) return a.Dist < b.Dist end)
		return list
	end

	task.spawn(function()
		while true do
			if not getgenv().KillAll.Enabled or getgenv().AntiKillAll.Enabled then
				task.wait(0.2)
			else
				refreshToolCache()
				stripToTool1Only()
				local character = LocalPlayer.Character
				local rootPart = character and character:FindFirstChild("HumanoidRootPart")
				local myHum = character and character:FindFirstChildOfClass("Humanoid")
				if rootPart and myHum and myHum.Health > 0 then
					local originalCFrame = rootPart.CFrame
					local spam = math.clamp(getgenv().KillAll.ClickSpam or 15, 5, 40)
					local underDist = getgenv().KillAll.UnderOffset or 5.5
					local enemies = getSortedEnemies()
					local maxN = math.min(#enemies, 6)
					local lockedY = nil
					local function goUnder(enemyRoot)
						if not enemyRoot or not rootPart then return end
						local ep = enemyRoot.Position
						local velY = 0
						pcall(function() velY = enemyRoot.AssemblyLinearVelocity.Y end)
						local targetY
						if velY > 4 or (lockedY and ep.Y > lockedY + underDist + 1.5) then
							targetY = lockedY or (ep.Y - underDist)
						else
							targetY = ep.Y - underDist
							lockedY = targetY
						end
						local underPos = Vector3.new(ep.X, targetY, ep.Z)
						rootPart.CFrame = CFrame.new(underPos, Vector3.new(ep.X, underPos.Y + 2, ep.Z))
						rootPart.AssemblyLinearVelocity = Vector3.zero
					end
					for ei = 1, maxN do
						local info = enemies[ei]
						if not getgenv().KillAll.Enabled then break end
						local c = info.Player.Character
						local h = c and c:FindFirstChildOfClass("Humanoid")
						local enemyRoot = c and c:FindFirstChild("HumanoidRootPart")
						if h and h.Health > 0 and enemyRoot then
							lockedY = nil
							local tool1 = stripToTool1Only()
							if tool1 then
								pcall(function() goUnder(enemyRoot) end)
								task.wait(0.02)
								for i = 1, spam do
									if not getgenv().KillAll.Enabled then break end
									h = c and c:FindFirstChildOfClass("Humanoid")
									enemyRoot = c and c:FindFirstChild("HumanoidRootPart")
									if not h or h.Health <= 0 or not enemyRoot then break end
									pcall(function() goUnder(enemyRoot) end)
									if i == 1 then tool1 = stripToTool1Only() or tool1 end
									fireTool1Soft(tool1, h)
									task.wait(0.028)
								end
								task.wait(0.04)
							end
						end
					end
					pcall(function()
						if rootPart and rootPart.Parent then rootPart.CFrame = originalCFrame end
					end)
				end
				if getgenv().KillAll.Enabled then
					local waitSec = getgenv().KillAll.CycleWait or 9
					local t0 = tick()
					while getgenv().KillAll.Enabled and (tick() - t0) < waitSec do
						task.wait(0.25)
					end
				end
			end
		end
	end)

	local autoShotBusy = false
	task.spawn(function()
		while true do
			local delay = math.clamp(tonumber(getgenv().AutoShot.Delay) or 0.1, 0.04, 1.5)
			task.wait(delay)
			if getgenv().AutoShot.Enabled and not getgenv().KillAll.Enabled and not autoShotBusy then
				local myChar = LocalPlayer.Character
				local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
				local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
				if myHum and myHRP and myHum.Health > 0 then
					local targetPart, targetPlayer = getClosestForAutoShot()
					if targetPart and targetPlayer and targetPlayer.Character then
						local tHum = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
						if tHum and tHum.Health > 0 then
							autoShotBusy = true
							if getgenv()._IKG_SilentBurst then getgenv()._IKG_SilentBurst(0.22) end
							local tool2 = getAndEquipTool2Safe()
							if tool2 then
								pcall(function() tool2:Activate() end)
								task.wait(0.035)
								pcall(function() tool2:Activate() end)
								task.wait(0.02)
								pcall(function() tool2:Activate() end)
							end
							task.wait(0.04)
							autoShotBusy = false
						end
					end
				end
			end
		end
	end)

	local triggerBusy = false
	RunService.RenderStepped:Connect(function()
		if not getgenv().TriggerBot.Enabled or getgenv().KillAll.Enabled or triggerBusy then return end
		local mouse = LocalPlayer:GetMouse()
		local target = mouse.Target
		if not target then return end
		local character = target:FindFirstAncestorOfClass("Model")
		if not character then return end
		local player = Players:GetPlayerFromCharacter(character)
		if not player or player == LocalPlayer or not isEnemy(player) then return end
		local hum = character:FindFirstChildOfClass("Humanoid")
		if not hum or hum.Health <= 0 then return end
		local part = resolveAimPart(character) or character:FindFirstChild("HumanoidRootPart")
		if getgenv().TriggerBot.WallCheck and part and not isTargetVisible(part) then return end
		triggerBusy = true
		task.spawn(function()
			if getgenv()._IKG_SilentBurst then getgenv()._IKG_SilentBurst(0.18) end
			local tool2 = getAndEquipTool2Safe()
			if tool2 then
				pcall(function() tool2:Activate() end)
				task.wait(0.06)
				forceUnequip()
			end
			task.wait(0.12)
			triggerBusy = false
		end)
	end)

	task.spawn(function()
		while true do
			task.wait(0.1)
			if getgenv().AntiKillAll.Enabled then
				local char = LocalPlayer.Character
				local hrp = char and char:FindFirstChild("HumanoidRootPart")
				if hrp then
					pcall(function()
						hrp.CFrame = CFrame.new(hrp.Position.X, -500, hrp.Position.Z)
						hrp.AssemblyLinearVelocity = Vector3.new(0, -200, 0)
					end)
				end
			end
		end
	end)

	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if not gameProcessed and input.UserInputType == Enum.UserInputType.MouseButton1 then
			if getgenv().Tool2Macro.Enabled and not getgenv().KillAll.Enabled then
				task.spawn(function()
					local tool2 = getAndEquipTool2Safe()
					if tool2 then
						tool2:Activate()
						task.wait(0.05)
						forceUnequip()
					end
				end)
			end
		end
		if not gameProcessed and getgenv().Movement.InfJump then
			if input.KeyCode == Enum.KeyCode.Space then
				local char = LocalPlayer.Character
				local hum = char and char:FindFirstChildOfClass("Humanoid")
				local hrp = char and char:FindFirstChild("HumanoidRootPart")
				if hum and hrp and hum.Health > 0 then
					hrp.Velocity = Vector3.new(hrp.Velocity.X, getgenv().Movement.JumpPower or 50, hrp.Velocity.Z)
				end
			end
		end
	end)

	local espFolder = Instance.new("Folder")
	espFolder.Name = "IKG_ESP_HL"
	espFolder.Parent = CoreGui
	local espDrawings = {}

	local function removeEsp(p)
		if espDrawings[p] then
			for _, obj in pairs(espDrawings[p]) do
				if typeof(obj) == "Instance" then
					pcall(function() obj:Destroy() end)
				elseif type(obj) == "table" and obj.Remove then
					pcall(function() obj:Remove() end)
				elseif type(obj) == "userdata" then
					pcall(function() if obj.Remove then obj:Remove() end end)
				end
			end
			espDrawings[p] = nil
		end
	end

	RunService.RenderStepped:Connect(function()
		if getgenv().Hitbox.Enabled then
			for _, p in ipairs(Players:GetPlayers()) do
				if p ~= LocalPlayer and isEnemy(p) and p.Character then
					local hrp = p.Character:FindFirstChild("HumanoidRootPart")
					if hrp then
						hrp.Size = Vector3.new(getgenv().Hitbox.Size, getgenv().Hitbox.Size, getgenv().Hitbox.Size)
						hrp.Transparency = getgenv().Hitbox.Transparency
						hrp.CanCollide = false
					end
				end
			end
		end

		local localChar = LocalPlayer.Character
		if localChar then
			local hum = localChar:FindFirstChildOfClass("Humanoid")
			if hum then
				if getgenv().Movement.Speed and hum.WalkSpeed ~= getgenv().Movement.Speed then
					hum.WalkSpeed = getgenv().Movement.Speed
				end
				if getgenv().Movement.JumpPower and hum.UseJumpPower then
					hum.JumpPower = getgenv().Movement.JumpPower
				end
			end
			if getgenv().Movement.Noclip then
				for _, part in ipairs(localChar:GetDescendants()) do
					if part:IsA("BasePart") then part.CanCollide = false end
				end
			end
			if getgenv().Movement.Ghost then
				local humG = localChar:FindFirstChildOfClass("Humanoid")
				if humG and humG.WalkSpeed < 50 then humG.WalkSpeed = 50 end
				for _, part in ipairs(localChar:GetDescendants()) do
					if part:IsA("BasePart") then
						pcall(function()
							if part.LocalTransparencyModifier < 0.4 then
								part.LocalTransparencyModifier = 0.45
							end
						end)
					end
				end
			end
		end

		local cam = Workspace.CurrentCamera
		if getgenv().Movement.FOV and cam then
			pcall(function()
				if cam.FieldOfView ~= getgenv().Movement.FOV then
					cam.FieldOfView = getgenv().Movement.FOV
				end
			end)
		end
		if getgenv().Movement.Fullbright then
			pcall(function()
				Lighting.Brightness = 3
				Lighting.FogEnd = 100000
				Lighting.GlobalShadows = false
			end)
		end

		if not cam then return end
		for _, p in ipairs(Players:GetPlayers()) do
			local shouldShow = p ~= LocalPlayer and getgenv().ESP.Enabled and isEnemy(p)
				and p.Character and p.Character:FindFirstChild("HumanoidRootPart")
			local hum = shouldShow and p.Character:FindFirstChildOfClass("Humanoid")
			if shouldShow and hum then
				if not espDrawings[p] then
					local box, tracer, name, dist = nil, nil, nil, nil
					pcall(function()
						box = Drawing.new("Square")
						box.Visible = false; box.Filled = false; box.Thickness = 1.5
						box.Color = getgenv().HubTheme.Accent
						tracer = Drawing.new("Line")
						tracer.Visible = false; tracer.Thickness = 1.5
						tracer.Color = getgenv().HubTheme.Accent
						name = Drawing.new("Text")
						name.Visible = false; name.Size = (getgenv().HubTheme and getgenv().HubTheme.TextSize) or 14
						name.Center = true
						name.Outline = getgenv().HubTheme and getgenv().HubTheme.Outline ~= false
						pcall(function() name.Font = resolveDrawingFont() end)
						name.Color = Color3.fromRGB(255, 245, 230)
						dist = Drawing.new("Text")
						dist.Visible = false; dist.Size = 12; dist.Center = true; dist.Outline = true
						dist.Color = Color3.fromRGB(210, 200, 180)
					end)
					local hl = Instance.new("Highlight")
					hl.Name = "IKG_HL_" .. p.UserId
					hl.FillColor = getgenv().HubTheme.Accent
					hl.OutlineColor = getgenv().HubTheme.AccentLight
					hl.FillTransparency = 0.55
					hl.OutlineTransparency = 0.2
					hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
					hl.Enabled = false
					hl.Parent = espFolder
					espDrawings[p] = { Box = box, Tracer = tracer, Name = name, Distance = dist, Highlight = hl }
				end
				local visuals = espDrawings[p]
				local hrp = p.Character.HumanoidRootPart
				if visuals.Highlight and visuals.Highlight.Parent then
					visuals.Highlight.Adornee = p.Character
				end
				local pos, onScreen = cam:WorldToViewportPoint(hrp.Position)
				if onScreen and pos.Z > 0 then
					local topPos = cam:WorldToViewportPoint((hrp.CFrame * CFrame.new(0, 3, 0)).Position)
					local bottomPos = cam:WorldToViewportPoint((hrp.CFrame * CFrame.new(0, -3.5, 0)).Position)
					local height = math.max(math.abs(topPos.Y - bottomPos.Y), 8)
					local width = height / 2
					if visuals.Box then
						if getgenv().ESP.Boxes then
							visuals.Box.Visible = true
							visuals.Box.Size = Vector2.new(width, height)
							visuals.Box.Position = Vector2.new(pos.X - width / 2, topPos.Y)
							visuals.Box.Color = getgenv().HubTheme.Accent
						else visuals.Box.Visible = false end
					end
					if visuals.Tracer then
						if getgenv().ESP.Tracers then
							visuals.Tracer.Visible = true
							local originPoint = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y)
							if getgenv().ESP.TracerOrigin == "Top" then
								originPoint = Vector2.new(cam.ViewportSize.X / 2, 0)
							elseif getgenv().ESP.TracerOrigin == "Center" then
								originPoint = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
							end
							visuals.Tracer.From = originPoint
							visuals.Tracer.To = Vector2.new(pos.X, bottomPos.Y)
							visuals.Tracer.Color = getgenv().HubTheme.Accent
						else visuals.Tracer.Visible = false end
					end
					if visuals.Name then
						if getgenv().ESP.Names then
							visuals.Name.Visible = true
							local label = p.Name
							if getgenv().Unique.EspHealth and hum then
								label = string.format("%s  [%d HP]", p.Name, math.floor(hum.Health))
							end
							visuals.Name.Text = label
							visuals.Name.Position = Vector2.new(pos.X, topPos.Y - 18)
						else visuals.Name.Visible = false end
					end
					if visuals.Distance then
						if getgenv().ESP.Distance then
							local originPos = cam.CFrame.Position
							if localChar and localChar:FindFirstChild("HumanoidRootPart") then
								originPos = localChar.HumanoidRootPart.Position
							end
							local d = math.floor((originPos - hrp.Position).Magnitude)
							visuals.Distance.Visible = true
							visuals.Distance.Text = d .. " studs"
							visuals.Distance.Position = Vector2.new(pos.X, bottomPos.Y + 2)
						else visuals.Distance.Visible = false end
					end
					if visuals.Highlight then
						visuals.Highlight.Enabled = getgenv().ESP.Chams and true or false
						if getgenv().ESP.Chams then
							visuals.Highlight.FillColor = getgenv().HubTheme.Accent
							visuals.Highlight.OutlineColor = getgenv().HubTheme.AccentLight
						end
					end
				else
					if visuals.Box then visuals.Box.Visible = false end
					if visuals.Tracer then visuals.Tracer.Visible = false end
					if visuals.Name then visuals.Name.Visible = false end
					if visuals.Distance then visuals.Distance.Visible = false end
					if visuals.Highlight then
						visuals.Highlight.Enabled = getgenv().ESP.Chams and true or false
					end
				end
			else
				removeEsp(p)
			end
		end
	end)

	RunService.Heartbeat:Connect(function(dt)
		if not getgenv().Unique.SoftWalk then return end
		if getgenv().KillAll.Enabled or getgenv().AntiKillAll.Enabled then return end
		local char = LocalPlayer.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if not hrp or not hum or hum.Health <= 0 or hum.Sit then return end
		local move = hum.MoveDirection
		if move.Magnitude > 0.1 then
			local speed = math.clamp(getgenv().Movement.Speed or 16, 1, 40)
			hrp.CFrame = hrp.CFrame + move.Unit * speed * dt
		end
	end)

	RunService.Heartbeat:Connect(function()
		if not getgenv().Unique.AntiSit then return end
		local char = LocalPlayer.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if hum then
			pcall(function() hum.Sit = false; hum.PlatformStand = false end)
		end
	end)

	local radarText, matchText = nil, nil
	pcall(function()
		radarText = Drawing.new("Text")
		radarText.Size = ((getgenv().HubTheme and getgenv().HubTheme.TextSize) or 14) + 2
		radarText.Center = false
		radarText.Outline = true
		radarText.Color = Color3.fromRGB(120, 255, 180)
		radarText.Position = Vector2.new(18, 80); radarText.Visible = false
		pcall(function() radarText.Font = resolveDrawingFont() end)
		matchText = Drawing.new("Text")
		matchText.Size = (getgenv().HubTheme and getgenv().HubTheme.TextSize) or 14
		matchText.Center = false
		matchText.Outline = true
		matchText.Color = Color3.fromRGB(180, 200, 255)
		matchText.Position = Vector2.new(18, 102); matchText.Visible = false
		pcall(function() matchText.Font = resolveDrawingFont() end)
	end)

	RunService.RenderStepped:Connect(function()
		pcall(function()
			if getgenv().Unique.EnemyRadar and radarText then
				local alive, total = 0, 0
				for _, p in ipairs(Players:GetPlayers()) do
					if p ~= LocalPlayer and isEnemy(p) then
						total = total + 1
						local hum = p.Character and p.Character:FindFirstChildOfClass("Humanoid")
						if hum and hum.Health > 0 then alive = alive + 1 end
					end
				end
				radarText.Text = string.format("Enemigos vivos: %d / %d", alive, total)
				radarText.Visible = true
			elseif radarText then radarText.Visible = false end

			if getgenv().Unique.MatchInfo and matchText then
				local g = LocalPlayer:GetAttribute("Game")
				local m = LocalPlayer:GetAttribute("Map")
				local t = LocalPlayer:GetAttribute("Team")
				matchText.Text = string.format("Game: %s  |  Map: %s  |  Team: %s",
					g and tostring(g) or "Lobby", m and tostring(m) or "-", t and tostring(t) or "-")
				matchText.Visible = true
			elseif matchText then matchText.Visible = false end
		end)
	end)

	task.spawn(function()
		while true do
			task.wait(0.4)
			if getgenv().Unique.AutoRespawn then
				local char = LocalPlayer.Character
				local hum = char and char:FindFirstChildOfClass("Humanoid")
				if hum and hum.Health <= 0 then
					pcall(function()
						if LocalPlayer.Character then LocalPlayer.Character:BreakJoints() end
					end)
					task.wait(0.5)
				end
			end
		end
	end)

	RunService.Heartbeat:Connect(function()
		if not getgenv().Unique.NoFallDamage then return end
		local char = LocalPlayer.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		if hrp and hrp.AssemblyLinearVelocity.Y < -80 then
			pcall(function()
				hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, -20, hrp.AssemblyLinearVelocity.Z)
			end)
		end
	end)

	RunService.Heartbeat:Connect(function()
		if not getgenv().Unique.AutoSprint then return end
		local char = LocalPlayer.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if not hum or hum.Health <= 0 then return end
		if getgenv().Movement.Ghost then return end
		if hum.MoveDirection.Magnitude > 0.1 then
			local spd = math.max(getgenv().Movement.Speed or 16, 24)
			if hum.WalkSpeed < spd then hum.WalkSpeed = spd end
		end
	end)

	UserInputService.InputBegan:Connect(function(input, gp)
		if gp or not getgenv().Unique.ClickTP then return end
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
		local char = LocalPlayer.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		if not hrp then return end
		local mouse = LocalPlayer:GetMouse()
		if mouse.Hit then
			pcall(function()
				hrp.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
			end)
		end
	end)

	RunService.Heartbeat:Connect(function()
		if not getgenv().Unique.LowGravity then return end
		local char = LocalPlayer.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		if not hrp then return end
		local v = hrp.AssemblyLinearVelocity
		if v.Y < -1 then
			hrp.AssemblyLinearVelocity = Vector3.new(v.X, v.Y * 0.85, v.Z)
		elseif v.Y > 1 and v.Y < 80 then
			hrp.AssemblyLinearVelocity = Vector3.new(v.X, v.Y + 0.35, v.Z)
		end
	end)

	Players.PlayerRemoving:Connect(function(p) removeEsp(p) end)

	RunService.RenderStepped:Connect(function()
		if not getgenv().Streamer then return end
		if getgenv().Streamer.Mode100 then
			if espDrawings then
				for _, visuals in pairs(espDrawings) do
					if visuals.Box then pcall(function() visuals.Box.Visible = false end) end
					if visuals.Tracer then pcall(function() visuals.Tracer.Visible = false end) end
					if visuals.Name then pcall(function() visuals.Name.Visible = false end) end
					if visuals.Distance then pcall(function() visuals.Distance.Visible = false end) end
					if visuals.Highlight then pcall(function() visuals.Highlight.Enabled = false end) end
				end
			end
			pcall(function()
				if fovCircle then fovCircle.Visible = false end
				if radarText then radarText.Visible = false end
				if matchText then matchText.Visible = false end
			end)
		end
	end)

	task.spawn(function()
		while true do
			task.wait(0.35)
			if getgenv().Streamer and getgenv().Streamer.NoRankTag then
				for _, p in ipairs(Players:GetPlayers()) do
					local char = p.Character
					if char then
						for _, d in ipairs(char:GetDescendants()) do
							if d:IsA("BillboardGui") and d.Name ~= "IKG_CustomName" then
								local n = string.lower(d.Name)
								if n:find("rank") or n:find("tag") or n:find("overhead")
									or n:find("name") or n:find("title") or n:find("badge")
									or d.StudsOffset.Y > 1.5 then
									pcall(function() d.Enabled = false end)
								end
							end
						end
					end
				end
			end
		end
	end)

	local function applyCustomName(char)
		if not char then return end
		local head = char:FindFirstChild("Head")
		if not head then return end
		local existing = head:FindFirstChild("IKG_CustomName")
		local text = getgenv().Streamer and getgenv().Streamer.CustomName or ""
		if not text or text == "" then
			if existing then existing:Destroy() end
			return
		end
		if not existing then
			existing = Instance.new("BillboardGui")
			existing.Name = "IKG_CustomName"
			existing.Size = UDim2.new(0, 200, 0, 40)
			existing.StudsOffset = Vector3.new(0, 2.8, 0)
			existing.AlwaysOnTop = true
			existing.Adornee = head
			existing.Parent = head
			local label = Instance.new("TextLabel")
			label.Name = "Label"
			label.BackgroundTransparency = 1
			label.Size = UDim2.new(1, 0, 1, 0)
			label.Font = Enum.Font.GothamBold
			label.TextSize = 16
			label.TextColor3 = Color3.fromRGB(255, 200, 120)
			label.TextStrokeTransparency = 0.3
			label.Parent = existing
		end
		local label = existing:FindFirstChild("Label")
		if label then label.Text = text end
	end
	task.spawn(function()
		while true do
			task.wait(0.5)
			if LocalPlayer.Character then applyCustomName(LocalPlayer.Character) end
		end
	end)
	LocalPlayer.CharacterAdded:Connect(function(char)
		task.wait(0.5)
		applyCustomName(char)
	end)

	local ANIM_FOLDERS = { "idle", "walk", "run", "jump", "fall", "climb", "swim", "swimidle" }

	local function extractId(animId)
		if not animId then return nil end
		local s = tostring(animId)
		local id = s:match("(%d+)")
		return id
	end

	local function readAnimateMap(char)
		local animate = char and char:FindFirstChild("Animate")
		if not animate then return nil end
		local map = {}
		for _, folderName in ipairs(ANIM_FOLDERS) do
			local folder = animate:FindFirstChild(folderName)
			if folder then
				for _, child in ipairs(folder:GetChildren()) do
					if child:IsA("Animation") then
						local id = extractId(child.AnimationId)
						if id then
							map[folderName] = id
							break
						end
					end
				end
			end
		end
		return map
	end

	local function writeAnimateMap(char, map)
		if not char or not map then return false end
		local animate = char:FindFirstChild("Animate")
		if not animate then return false end
		for folderName, id in pairs(map) do
			if id then
				local folder = animate:FindFirstChild(folderName)
				if folder then
					for _, child in ipairs(folder:GetChildren()) do
						if child:IsA("Animation") then
							pcall(function()
								child.AnimationId = "http://www.roblox.com/asset/?id=" .. tostring(id)
							end)
						end
					end
				end
			end
		end
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then
			pcall(function()
				for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
					track:Stop(0)
				end
			end)
		end
		pcall(function()
			if animate:IsA("LocalScript") then
				animate.Disabled = true
				task.wait(0.03)
				animate.Disabled = false
			end
		end)
		return true
	end

	local function ensureOriginalCaptured(char)
		if getgenv()._IKG_OriginalAnims then return end
		local map = readAnimateMap(char)
		if map and (map.idle or map.walk or map.run) then
			getgenv()._IKG_OriginalAnims = map
		end
	end

	local function packToMap(pack)
		if not pack then return nil end
		return {
			idle = pack.Idle,
			walk = pack.Walk,
			run = pack.Run,
			jump = pack.Jump,
			fall = pack.Fall,
			climb = pack.Climb,
			swim = pack.Swim,
			swimidle = pack.Swim,
		}
	end

	local function applyCurrentAnims()
		local char = LocalPlayer.Character
		if not char then return end
		ensureOriginalCaptured(char)
		local packName = (getgenv().AnimMix and getgenv().AnimMix.Pack) or "Yours"
		if packName == "Yours" or packName == "Default" then
			if getgenv()._IKG_OriginalAnims then
				writeAnimateMap(char, getgenv()._IKG_OriginalAnims)
			end
			return
		end
		local m = getgenv().AnimMix
		if not m or not m.Idle then return end
		writeAnimateMap(char, packToMap(m))
	end

	getgenv()._IKG_ApplyAnimMix = applyCurrentAnims
	getgenv()._IKG_CaptureAnims = function()
		local char = LocalPlayer.Character
		if char then
			getgenv()._IKG_OriginalAnims = nil
			ensureOriginalCaptured(char)
		end
	end

	task.spawn(function()
		local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
		task.wait(0.8)
		ensureOriginalCaptured(char)
	end)

	LocalPlayer.CharacterAdded:Connect(function(char)
		task.wait(0.7)
		ensureOriginalCaptured(char)
		pcall(applyCurrentAnims)
		task.wait(1.2)
		pcall(applyCurrentAnims)
	end)

	-- âââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââ
	--  AUTO FARM  Â·  CollectEventSpawnable spam + smart collection
	-- âââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââââ
	local _afFired = 0
	local _afLastReset = tick()
	local _afFps = 0
	local _afEvent = nil
	local _afStatus = nil
	local _afBusy = false

	pcall(function()
		_afStatus = Drawing.new("Text")
		_afStatus.Size = ((getgenv().HubTheme and getgenv().HubTheme.TextSize) or 14) + 1
		_afStatus.Center = false
		_afStatus.Outline = true
		_afStatus.Color = Color3.fromRGB(255, 200, 90)
		_afStatus.Position = Vector2.new(18, 124)
		_afStatus.Visible = false
		pcall(function() _afStatus.Font = resolveDrawingFont() end)
	end)

	local function resolveCollectEvent()
		if _afEvent and typeof(_afEvent) == "Instance" and _afEvent.Parent then
			return _afEvent
		end
		_afEvent = nil
		local ok, ev = pcall(function()
			local RS = game:GetService("ReplicatedStorage")
			local packages = RS:FindFirstChild("Packages")
			-- exact Cobalt path used by generated code
			local exact = RS:FindFirstChild("Packages")
			if exact then
				local net = exact:FindFirstChild("Networking")
				if net then
					local node = net:FindFirstChild("RE/Events/CollectEventSpawnable")
					if node then return node end
					-- sometimes nested folders RE -> Events -> CollectEventSpawnable
					local re = net:FindFirstChild("RE") or net:FindFirstChild("Events")
					if re then
						local events = re:FindFirstChild("Events") or re
						local c = events and events:FindFirstChild("CollectEventSpawnable")
						if c then return c end
					end
					for _, d in ipairs(net:GetDescendants()) do
						if d.Name == "CollectEventSpawnable" then return d end
					end
				end
				for _, d in ipairs(exact:GetDescendants()) do
					if d.Name == "CollectEventSpawnable" then return d end
				end
			end
			-- last-resort full RS scan (limited depth via GetDescendants)
			for _, d in ipairs(RS:GetDescendants()) do
				if d.Name == "CollectEventSpawnable" then return d end
			end
			return nil
		end)
		if ok and ev then
			_afEvent = ev
			return ev
		end
		return nil
	end

	local function fireOneCollect(ev)
		if not ev then return false end
		local ok = pcall(function()
			if typeof(ev) == "Instance" and ev:IsA("RemoteEvent") then
				ev:FireServer()
				if getgenv().AutoFarm and getgenv().AutoFarm.DoubleFire then
					ev:FireServer()
				end
			elseif typeof(ev) == "Instance" and ev:IsA("RemoteFunction") then
				ev:InvokeServer()
			elseif type(ev) == "table" or typeof(ev) == "Instance" then
				if type(ev.FireServer) == "function" then
					ev:FireServer()
				elseif type(ev.fire) == "function" then
					ev:fire()
				elseif type(ev.InvokeServer) == "function" then
					ev:InvokeServer()
				end
			end
		end)
		return ok
	end

	local function fireCollectBurst(n)
		local ev = resolveCollectEvent()
		if not ev then return 0 end
		local fired = 0
		n = math.clamp(tonumber(n) or 1, 1, 40)
		for _ = 1, n do
			if fireOneCollect(ev) then
				fired = fired + 1
				_afFired = _afFired + 1
			end
		end
		return fired
	end

	local function isAutoFarmActive()
		local af = getgenv().AutoFarm
		if not af or not af.Enabled then return false end
		if af.PauseOnKillAll and getgenv().KillAll and getgenv().KillAll.Enabled then return false end
		if af.OnlyWhenAlive then
			local char = LocalPlayer.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			if not hum or hum.Health <= 0 then return false end
		end
		-- keep legacy flag in sync
		getgenv().Movement.AutoFarm = true
		return true
	end

	task.spawn(function()
		while true do
			if not isAutoFarmActive() then
				task.wait(0.12)
			else
				local af = getgenv().AutoFarm
				local maxR = math.clamp(tonumber(af.MaxRate) or 150, 20, 250)
				local rate = math.clamp(tonumber(af.SpamRate) or 60, 5, maxR)
				local burst = math.clamp(tonumber(af.BurstSize) or 10, 1, 32)
				local gap = math.clamp(tonumber(af.BurstGap) or 0.015, 0.005, 0.15)
				local targetGap = math.max(0.005, burst / rate)
				gap = math.min(gap, targetGap)
				fireCollectBurst(burst)
				task.wait(gap)
			end
		end
	end)

	-- FPS / counter updater
	task.spawn(function()
		while true do
			task.wait(1)
			local now = tick()
			local dt = now - _afLastReset
			if dt > 0 then
				_afFps = math.floor(_afFired / dt + 0.5)
			end
			_afFired = 0
			_afLastReset = now
		end
	end)

	-- Smart collect: approach nearby spawnable parts / models if present
	local function findNearbySpawnable(maxDist)
		local char = LocalPlayer.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		if not hrp then return nil end
		local best, bestDist = nil, maxDist or 28
		local roots = {
			Workspace,
			Workspace:FindFirstChild("Spawnables"),
			Workspace:FindFirstChild("Collectibles"),
			Workspace:FindFirstChild("Pickups"),
			Workspace:FindFirstChild("Items"),
		}
		for _, root in ipairs(roots) do
			if root then
				for _, obj in ipairs(root:GetDescendants()) do
					if obj:IsA("BasePart") then
						local n = string.lower(obj.Name)
						if n:find("spawn") or n:find("collect") or n:find("pickup")
							or n:find("coin") or n:find("gem") or n:find("orb")
							or n:find("crate") or n:find("chest") or n:find("drop") then
							local d = (obj.Position - hrp.Position).Magnitude
							if d < bestDist and d > 1.5 then
								bestDist = d
								best = obj
							end
						end
					end
				end
			end
		end
		return best, bestDist
	end

	local _afLastTp = 0
	RunService.Heartbeat:Connect(function(dt)
		local af = getgenv().AutoFarm
		if not af or not af.Enabled or not af.SmartCollect then return end
		if af.PauseOnKillAll and getgenv().KillAll and getgenv().KillAll.Enabled then return end
		if getgenv().AntiKillAll and getgenv().AntiKillAll.Enabled then return end
		local char = LocalPlayer.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if not hrp or not hum or hum.Health <= 0 or hum.Sit then return end
		local target = findNearbySpawnable(af.CollectRange or 35)
		if not target then return end
		local dir = (target.Position - hrp.Position)
		local dist = dir.Magnitude
		if af.TpCollect and dist > 4 and (tick() - _afLastTp) >= (tonumber(af.TpGap) or 0.35) then
			_afLastTp = tick()
			pcall(function()
				hrp.CFrame = CFrame.new(target.Position + Vector3.new(0, 2.5, 0))
				hrp.AssemblyLinearVelocity = Vector3.zero
			end)
			fireCollectBurst(4)
			return
		end
		if dist > 2 then
			local spd = math.clamp(tonumber(af.CollectSpeed) or 42, 10, 100)
			local step = dir.Unit * spd * dt
			step = Vector3.new(step.X, 0, step.Z)
			hrp.CFrame = hrp.CFrame + step
		end
	end)

	-- Status overlay
	RunService.RenderStepped:Connect(function()
		pcall(function()
			if not _afStatus then return end
			local af = getgenv().AutoFarm
			if af and af.Enabled and af.StatusText then
				local active = isAutoFarmActive()
				_afStatus.Text = string.format(
					"AutoFarm: %s  Â·  %d/s  Â·  event %s",
					active and "ON" or "PAUSED",
					_afFps,
					_afEvent and "OK" or "SEARCHING"
				)
				_afStatus.Color = active and Color3.fromRGB(120, 255, 140) or Color3.fromRGB(255, 180, 80)
				_afStatus.Visible = true
			else
				_afStatus.Visible = false
			end
		end)
	end)

	-- Keep Movement.AutoFarm mirrored
	task.spawn(function()
		while true do
			task.wait(0.5)
			local af = getgenv().AutoFarm
			if af then
				getgenv().Movement.AutoFarm = af.Enabled and true or false
			end
		end
	end)

	getgenv()._IKG_FireCollect = fireCollectBurst
	getgenv()._IKG_ResolveCollectEvent = resolveCollectEvent

	-- ========== Touch Farm (SpawnablesClient / firetouchinterest) ==========
	task.spawn(function()
		while true do
			local af = getgenv().AutoFarm
			local u = getgenv().Unique
			if not af or not af.Enabled or not u or u.TouchFarm == false then
				task.wait(0.25)
			else
				if af.PauseOnKillAll and getgenv().KillAll and getgenv().KillAll.Enabled then
					task.wait(0.2)
				else
					local char = LocalPlayer.Character
					local hrp = char and char:FindFirstChild("HumanoidRootPart")
					local containers = {
						Workspace:FindFirstChild("SpawnablesClient"),
						Workspace:FindFirstChild("Spawnables"),
						Workspace:FindFirstChild("Collectibles"),
					}
					if hrp and firetouchinterest then
						for _, container in ipairs(containers) do
							if container then
								for _, obj in ipairs(container:GetChildren()) do
									local touchPart = obj:FindFirstChild("Touch") or obj:FindFirstChildWhichIsA("BasePart")
									if touchPart and touchPart:IsA("BasePart") then
										pcall(function()
											firetouchinterest(hrp, touchPart, 0)
											firetouchinterest(hrp, touchPart, 1)
										end)
									end
								end
							end
						end
					end
					task.wait(0.4)
				end
			end
		end
	end)

	-- ========== Fly ==========
	local flyBV, flyBG = nil, nil
	RunService.RenderStepped:Connect(function()
		local mv = getgenv().Movement
		if not mv or not mv.Fly then
			if flyBV then pcall(function() flyBV:Destroy() end) flyBV = nil end
			if flyBG then pcall(function() flyBG:Destroy() end) flyBG = nil end
			return
		end
		local char = LocalPlayer.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if not hrp or not hum then return end
		if not flyBV or not flyBV.Parent then
			flyBV = Instance.new("BodyVelocity")
			flyBV.MaxForce = Vector3.new(1e5, 1e5, 1e5)
			flyBV.Velocity = Vector3.zero
			flyBV.Parent = hrp
		end
		if not flyBG or not flyBG.Parent then
			flyBG = Instance.new("BodyGyro")
			flyBG.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
			flyBG.P = 3000
			flyBG.Parent = hrp
		end
		local cam = Workspace.CurrentCamera
		local spd = math.clamp(tonumber(mv.FlySpeed) or 50, 10, 200)
		local dir = Vector3.zero
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
			dir = dir - Vector3.new(0, 1, 0)
		end
		if dir.Magnitude > 0 then dir = dir.Unit * spd else dir = Vector3.zero end
		flyBV.Velocity = dir
		flyBG.CFrame = cam.CFrame
		hum.PlatformStand = true
	end)
	-- cleanup PlatformStand when fly off
	task.spawn(function()
		local wasFly = false
		while true do
			task.wait(0.2)
			local on = getgenv().Movement and getgenv().Movement.Fly
			if wasFly and not on then
				local char = LocalPlayer.Character
				local hum = char and char:FindFirstChildOfClass("Humanoid")
				if hum then pcall(function() hum.PlatformStand = false end) end
			end
			wasFly = on and true or false
		end
	end)

	-- ========== Magnet / Enemies TP (cerca del enemigo, no kill) ==========
	local _magLast = 0
	RunService.Heartbeat:Connect(function()
		local u = getgenv().Unique
		if not u or not u.MagnetTP then return end
		if getgenv().KillAll and getgenv().KillAll.Enabled then return end
		if tick() - _magLast < (tonumber(u.MagnetGap) or 0.12) then return end
		local myChar = LocalPlayer.Character
		local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
		if not myHRP then return end
		local best, bestD = nil, 200
		for _, p in ipairs(Players:GetPlayers()) do
			if isEnemy(p) and p.Character then
				local er = p.Character:FindFirstChild("HumanoidRootPart")
				local hum = p.Character:FindFirstChildOfClass("Humanoid")
				if er and hum and hum.Health > 0 then
					local d = (myHRP.Position - er.Position).Magnitude
					if d < bestD then bestD, best = d, er end
				end
			end
		end
		if best then
			_magLast = tick()
			pcall(function()
				local behind = best.CFrame * CFrame.new(0, 0, 3)
				myHRP.CFrame = CFrame.new(behind.Position, best.Position)
			end)
		end
	end)

	-- ========== FPS Boost (suave: sombras/fog/terreno) ==========
	local _fpsBoostApplied = false
	local _fpsOrig = {}
	task.spawn(function()
		while true do
			task.wait(0.5)
			local want = getgenv().Unique and getgenv().Unique.FpsBoost
			if want and not _fpsBoostApplied then
				_fpsBoostApplied = true
				pcall(function()
					_fpsOrig.GlobalShadows = Lighting.GlobalShadows
					_fpsOrig.FogEnd = Lighting.FogEnd
					_fpsOrig.ShadowSoftness = Lighting.ShadowSoftness
					Lighting.GlobalShadows = false
					Lighting.FogEnd = 9e9
					Lighting.ShadowSoftness = 0
					local Terrain = Workspace:FindFirstChildOfClass("Terrain")
					if Terrain then
						Terrain.Decoration = false
						Terrain.WaterWaveSize = 0
						Terrain.WaterReflectance = 0
					end
				end)
			elseif not want and _fpsBoostApplied then
				_fpsBoostApplied = false
				pcall(function()
					if _fpsOrig.GlobalShadows ~= nil then Lighting.GlobalShadows = _fpsOrig.GlobalShadows end
					if _fpsOrig.FogEnd then Lighting.FogEnd = _fpsOrig.FogEnd end
					if _fpsOrig.ShadowSoftness then Lighting.ShadowSoftness = _fpsOrig.ShadowSoftness end
				end)
			end
		end
	end)

	-- ========== FPS / Ping overlay ==========
	local statsText = nil
	pcall(function()
		statsText = Drawing.new("Text")
		statsText.Size = 14
		statsText.Center = false
		statsText.Outline = true
		statsText.Color = Color3.fromRGB(120, 255, 160)
		statsText.Position = Vector2.new(18, 58)
		statsText.Visible = false
	end)
	local _fpsFrames, _fpsLast, _fpsVal = 0, tick(), 0
	RunService.RenderStepped:Connect(function()
		_fpsFrames = _fpsFrames + 1
		if tick() - _fpsLast >= 1 then
			_fpsVal = _fpsFrames
			_fpsFrames = 0
			_fpsLast = tick()
		end
		if not statsText then return end
		local show = getgenv().Unique and getgenv().Unique.ShowStats
		if not show or (getgenv().Streamer and getgenv().Streamer.Mode100) then
			statsText.Visible = false
			return
		end
		local ping = 0
		pcall(function()
			ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
		end)
		statsText.Text = string.format("FPS: %d  |  Ping: %d ms", _fpsVal, ping)
		statsText.Visible = true
		if _fpsVal >= 50 then statsText.Color = Color3.fromRGB(46, 204, 113)
		elseif _fpsVal >= 30 then statsText.Color = Color3.fromRGB(241, 196, 15)
		else statsText.Color = Color3.fromRGB(231, 76, 60) end
	end)

	getgenv()._IKG_ApplyFonts = function()
		pcall(function()
			if radarText then applyThemeToDrawingText(radarText) end
			if matchText then applyThemeToDrawingText(matchText) end
			if _afStatus then applyThemeToDrawingText(_afStatus) end
			if espDrawings then
				for _, visuals in pairs(espDrawings) do
					if visuals.Name then applyThemeToDrawingText(visuals.Name) end
					if visuals.Distance then applyThemeToDrawingText(visuals.Distance) end
				end
			end
		end)
	end

	RunService.RenderStepped:Connect(function()
		pcall(function()
			if not getgenv().HubTheme then return end
			if radarText then
				radarText.Size = (getgenv().HubTheme.TextSize or 14) + 2
				radarText.Outline = getgenv().HubTheme.Outline ~= false
			end
			if matchText then
				matchText.Size = getgenv().HubTheme.TextSize or 14
				matchText.Outline = getgenv().HubTheme.Outline ~= false
			end
			if _afStatus then
				_afStatus.Size = (getgenv().HubTheme.TextSize or 14) + 1
				_afStatus.Outline = getgenv().HubTheme.Outline ~= false
			end
		end)
	end)
end

local WindUI
do
	local ok, lib = pcall(function()
		return loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
	end)
	if not ok or not lib then
		error("[Ikgonavi] WindUI failed to load: " .. tostring(lib))
	end
	WindUI = lib
end

local Window = WindUI:CreateWindow({
	Title = "Ikgonavi Hub  Â·  v9.7",
	Author = "Amber Core",
	Folder = "IkgonaviHub",
	Icon = "swords",
	Theme = "Amber",
	Size = UDim2.fromOffset(840, 600),
	MinSize = Vector2.new(640, 440),
	Transparent = true,
	Resizable = true,
	SideBarWidth = 205,
	HideSearchBar = false,
	ToggleKey = Enum.KeyCode.RightShift,
	NewElements = true,
	OpenButton = {
		Title = "IKG",
		Enabled = true,
		Draggable = true,
		OnlyMobile = false,
		CornerRadius = UDim.new(1, 0),
	},
	Topbar = {
		Height = 48,
		ButtonsType = "Mac",
	},
})

pcall(function()
	Window:Tag({
		Title = "v9.7",
		Icon = "sparkles",
		Color = Color3.fromHex("#3f210d"),
		Border = true,
	})
end)
pcall(function()
	Window:Tag({
		Title = tostring(DEVICE),
		Icon = "monitor",
		Color = Color3.fromHex("#1a3a2a"),
		Border = true,
	})
end)

local HomeTab = Window:Tab({ Title = "Home", Icon = "house" })
local CombatTab = Window:Tab({ Title = "Combat", Icon = "swords" })
local VisualsTab = Window:Tab({ Title = "Visuals", Icon = "eye" })
local MovementTab = Window:Tab({ Title = "Movement", Icon = "person-standing" })
local FarmTab = Window:Tab({ Title = "Farm", Icon = "sprout" })
local WorldTab = Window:Tab({ Title = "World", Icon = "globe" })
local PlayerTab = Window:Tab({ Title = "Player", Icon = "user" })
local SettingsTab = Window:Tab({ Title = "Settings", Icon = "settings" })

-- ââââââââââââââââââââââââââââ HOME ââââââââââââââââââââââââââââ
HomeTab:Section({ Title = "Welcome" })
HomeTab:Paragraph({
	Title = "Ikgonavi Hub v9.7",
	Desc = "WindUI Â· Amber Core Â· " .. tostring(DEVICE) .. " Â· AutoFarm Â· Silent Â· ESP Â· Anims",
})
HomeTab:Paragraph({
	Title = "Quick Start",
	Desc = "Farm = CollectEvent spam Â· Combat = Silent/AutoShot/KillAll Â· RightShift = UI Â· Settings = save config",
})

HomeTab:Section({ Title = "Quick Toggles" })
HomeTab:Toggle({
	Title = "Match Info Overlay",
	Desc = "Game / Map / Team en pantalla",
	Value = getgenv().Unique.MatchInfo,
	Flag = "MatchInfo",
	Callback = function(v) getgenv().Unique.MatchInfo = v end,
})
HomeTab:Toggle({
	Title = "Enemy Radar",
	Desc = "Contador enemigos vivos",
	Value = getgenv().Unique.EnemyRadar,
	Flag = "HomeRadar",
	Callback = function(v) getgenv().Unique.EnemyRadar = v end,
})
HomeTab:Toggle({
	Title = "Quick Auto Farm",
	Desc = "Atajo CollectEvent farm",
	Value = (getgenv().AutoFarm and getgenv().AutoFarm.Enabled) or false,
	Flag = "QuickAutoFarm",
	Callback = function(v)
		getgenv().AutoFarm.Enabled = v
		getgenv().Movement.AutoFarm = v
		if v then
			WindUI:Notify({ Title = "Auto Farm", Content = "ON Â· tab Farm para ajustes", Duration = 2 })
		end
	end,
})
HomeTab:Toggle({
	Title = "Quick Silent Aim",
	Desc = "Atajo Silent Aim",
	Value = getgenv().SilentAim.Enabled,
	Flag = "QuickSA",
	Callback = function(v) getgenv().SilentAim.Enabled = v end,
})
HomeTab:Toggle({
	Title = "Quick ESP Master",
	Desc = "Atajo ESP",
	Value = getgenv().ESP.Enabled,
	Flag = "QuickESP",
	Callback = function(v) getgenv().ESP.Enabled = v end,
})
HomeTab:Toggle({
	Title = "Quick Noclip",
	Value = getgenv().Movement.Noclip,
	Flag = "QuickNoclip",
	Callback = function(v) getgenv().Movement.Noclip = v end,
})

HomeTab:Section({ Title = "UI & Links" })
HomeTab:Keybind({
	Title = "Toggle UI Key",
	Desc = "Abrir / cerrar el hub",
	Value = "RightShift",
	Flag = "HideUIKey",
	Callback = function(key)
		if Enum.KeyCode[key] then
			Window:SetToggleKey(Enum.KeyCode[key])
		end
	end,
})
HomeTab:Button({
	Title = "Copy Discord Invite",
	Icon = "link",
	Callback = function()
		pcall(function()
			if setclipboard then setclipboard("https://discord.gg/S3AZJDwRWQ") end
		end)
		WindUI:Notify({ Title = "Discord", Content = "Link copiado", Duration = 2 })
	end,
})
HomeTab:Button({
	Title = "UI Ready Notify",
	Icon = "bell",
	Callback = function()
		WindUI:Notify({
			Title = "Ikgonavi v9.7",
			Content = "Amber Â· " .. tostring(DEVICE) .. " Â· todo listo",
			Icon = "check",
			Duration = 3,
		})
	end,
})
HomeTab:Paragraph({
	Title = "Status",
	Desc = "Anim: " .. tostring((getgenv().AnimMix and getgenv().AnimMix.Pack) or "Yours")
		.. " Â· Theme: " .. tostring((getgenv().HubTheme and getgenv().HubTheme.Name) or "Amber")
		.. " Â· Device: " .. tostring(DEVICE),
})

CombatTab:Section({ Title = "Aim & Shot" })
CombatTab:Paragraph({
	Title = "Combat Core",
	Desc = "Silent Aim hookea Mouse.Hit Â· AutoShot usa Tool 2 Â· Kill All usa Tool 1 debajo del enemigo.",
})
CombatTab:Toggle({
	Title = "Silent Aim",
	Desc = "Mouse.Hit Â· WallCheck siempre ON",
	Value = getgenv().SilentAim.Enabled,
	Flag = "SilentAim",
	Callback = function(v)
		getgenv().SilentAim.Enabled = v
		getgenv().SilentAim.WallCheck = true
	end,
})
CombatTab:Dropdown({
	Title = "Silent Aim Part",
	Values = { "Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", "Left Leg", "Right Leg", "LeftLowerLeg", "RightLowerLeg", "LeftFoot", "RightFoot" },
	Value = getgenv().SilentAim.Part or "Head",
	Flag = "SilentAimPart",
	Callback = function(v) getgenv().SilentAim.Part = v end,
})
CombatTab:Slider({
	Title = "Silent FOV",
	Desc = "5000+ = full screen",
	Step = 5,
	Value = {
		Min = 20,
		Max = 5000,
		Default = (function()
			local f = getgenv().SilentAim.FOV
			if type(f) ~= "number" or f >= 5000 then return 5000 end
			return math.clamp(f, 20, 5000)
		end)(),
	},
	Flag = "SilentFOV",
	Callback = function(v)
		getgenv().SilentAim.FOV = (v >= 4990) and math.huge or v
	end,
})
CombatTab:Toggle({
	Title = "Auto Shot",
	Desc = "Tool 2 Â· WallCheck siempre ON Â· keep tool",
	Value = getgenv().AutoShot.Enabled,
	Flag = "AutoShot",
	Callback = function(v)
		getgenv().AutoShot.WallCheck = true
		if v and getgenv().KillAll.Enabled then
			getgenv().KillAll.Enabled = false
			WindUI:Notify({ Title = "Kill All", Content = "Desactivado (conflicto con Auto Shot)", Duration = 2 })
		end
		getgenv().AutoShot.Enabled = v
	end,
})
CombatTab:Slider({
	Title = "Auto Shot Delay",
	Step = 0.01,
	Value = { Min = 0.04, Max = 0.8, Default = getgenv().AutoShot.Delay or 0.12 },
	Flag = "ASDelay",
	Callback = function(v) getgenv().AutoShot.Delay = v end,
})
CombatTab:Toggle({
	Title = "Triggerbot",
	Desc = "Aim on enemy Â· Tool 2 + Silent",
	Value = getgenv().TriggerBot.Enabled,
	Flag = "TriggerBot",
	Callback = function(v) getgenv().TriggerBot.Enabled = v end,
})
CombatTab:Toggle({
	Title = "Tool 2 Macro",
	Desc = "Equip Â· click Â· unequip",
	Value = getgenv().Tool2Macro.Enabled,
	Flag = "Tool2Macro",
	Callback = function(v) getgenv().Tool2Macro.Enabled = v end,
})

CombatTab:Section({ Title = "Kill All" })
CombatTab:Toggle({
	Title = "Kill All",
	Desc = "Debajo enemigo Â· CD 9s Â· Tool 1",
	Value = getgenv().KillAll.Enabled,
	Flag = "KillAll",
	Callback = function(v)
		if v then
			getgenv().AntiKillAll.Enabled = false
			getgenv().AutoShot.Enabled = false
		end
		getgenv().KillAll.Enabled = v
	end,
})
CombatTab:Toggle({
	Title = "Anti Kill All",
	Desc = "Void TP Â· die and leave",
	Value = getgenv().AntiKillAll.Enabled,
	Flag = "AntiKillAll",
	Callback = function(v)
		if v then getgenv().KillAll.Enabled = false end
		getgenv().AntiKillAll.Enabled = v
	end,
})
CombatTab:Slider({
	Title = "KillAll Cycle Wait",
	Step = 1,
	Value = { Min = 3, Max = 20, Default = getgenv().KillAll.CycleWait or 9 },
	Flag = "KACycle",
	Callback = function(v) getgenv().KillAll.CycleWait = v end,
})
CombatTab:Slider({
	Title = "KillAll Click Spam",
	Step = 1,
	Value = { Min = 5, Max = 40, Default = getgenv().KillAll.ClickSpam or 10 },
	Flag = "KASpam",
	Callback = function(v) getgenv().KillAll.ClickSpam = v end,
})

CombatTab:Section({ Title = "Hitbox & Utility" })
CombatTab:Toggle({
	Title = "Hitbox",
	Desc = "Expand enemy HRP",
	Value = getgenv().Hitbox.Enabled,
	Flag = "Hitbox",
	Callback = function(v) getgenv().Hitbox.Enabled = v end,
})
CombatTab:Slider({
	Title = "Hitbox Size",
	Step = 0.5,
	Value = { Min = 1, Max = 25, Default = getgenv().Hitbox.Size or 2 },
	Flag = "HitboxSize",
	Callback = function(v) getgenv().Hitbox.Size = v end,
})
CombatTab:Toggle({
	Title = "Anti Sit",
	Value = getgenv().Unique.AntiSit,
	Flag = "AntiSit",
	Callback = function(v) getgenv().Unique.AntiSit = v end,
})
CombatTab:Toggle({
	Title = "Enemy Radar",
	Value = getgenv().Unique.EnemyRadar,
	Flag = "EnemyRadar",
	Callback = function(v) getgenv().Unique.EnemyRadar = v end,
})
CombatTab:Toggle({
	Title = "Auto Respawn",
	Value = getgenv().Unique.AutoRespawn,
	Flag = "AutoRespawn",
	Callback = function(v) getgenv().Unique.AutoRespawn = v end,
})
CombatTab:Toggle({
	Title = "No Fall Damage",
	Value = getgenv().Unique.NoFallDamage,
	Flag = "NoFall",
	Callback = function(v) getgenv().Unique.NoFallDamage = v end,
})

VisualsTab:Section({ Title = "ESP Master" })
VisualsTab:Paragraph({
	Title = "Enemy Visuals",
	Desc = "Solo enemigos (team / game). Elige color abajo.",
})
VisualsTab:Toggle({
	Title = "ESP Master",
	Desc = "Activa todo el sistema ESP",
	Value = getgenv().ESP.Enabled,
	Flag = "ESP",
	Callback = function(v) getgenv().ESP.Enabled = v end,
})
local espColorPresets = {
	{ Name = "Amber", Color = Color3.fromRGB(232, 145, 42), Outline = Color3.fromRGB(255, 190, 90) },
	{ Name = "Red", Color = Color3.fromRGB(255, 55, 55), Outline = Color3.fromRGB(255, 140, 140) },
	{ Name = "Lime", Color = Color3.fromRGB(80, 255, 100), Outline = Color3.fromRGB(180, 255, 180) },
	{ Name = "Cyan", Color = Color3.fromRGB(60, 220, 255), Outline = Color3.fromRGB(160, 240, 255) },
	{ Name = "Pink", Color = Color3.fromRGB(255, 90, 180), Outline = Color3.fromRGB(255, 170, 220) },
	{ Name = "Purple", Color = Color3.fromRGB(170, 90, 255), Outline = Color3.fromRGB(210, 170, 255) },
	{ Name = "White", Color = Color3.fromRGB(245, 245, 255), Outline = Color3.fromRGB(200, 200, 220) },
	{ Name = "Gold", Color = Color3.fromRGB(255, 200, 50), Outline = Color3.fromRGB(255, 230, 120) },
}
VisualsTab:Dropdown({
	Title = "ESP Color",
	Values = (function()
		local t = {}
		for _, p in ipairs(espColorPresets) do table.insert(t, p.Name) end
		return t
	end)(),
	Value = "Amber",
	Flag = "ESPColor",
	Callback = function(name)
		for _, p in ipairs(espColorPresets) do
			if p.Name == name then
				getgenv().ESP.Color = p.Color
				getgenv().ESP.OutlineColor = p.Outline
				getgenv().HubTheme.Accent = p.Color
				getgenv().HubTheme.AccentLight = p.Outline
				pcall(function() if fovCircle then fovCircle.Color = p.Color end end)
				WindUI:Notify({ Title = "ESP", Content = "Color: " .. name, Duration = 1.5 })
				break
			end
		end
	end,
})
VisualsTab:Slider({
	Title = "ESP Thickness",
	Step = 0.5,
	Value = { Min = 1, Max = 4, Default = getgenv().ESP.Thickness or 1.5 },
	Flag = "ESPThick",
	Callback = function(v) getgenv().ESP.Thickness = v end,
})
VisualsTab:Slider({
	Title = "Chams Fill",
	Step = 0.05,
	Value = { Min = 0.1, Max = 0.9, Default = getgenv().ESP.ChamsFill or 0.55 },
	Flag = "ESPChamsFill",
	Callback = function(v) getgenv().ESP.ChamsFill = v end,
})
VisualsTab:Section({ Title = "ESP Layers" })
VisualsTab:Toggle({
	Title = "Boxes",
	Desc = "Caja 2D alrededor del enemigo",
	Value = getgenv().ESP.Boxes,
	Flag = "ESPBoxes",
	Callback = function(v) getgenv().ESP.Boxes = v end,
})
VisualsTab:Toggle({
	Title = "Tracers",
	Desc = "LÃ­nea desde origen al pie",
	Value = getgenv().ESP.Tracers,
	Flag = "ESPTracers",
	Callback = function(v) getgenv().ESP.Tracers = v end,
})
VisualsTab:Toggle({
	Title = "Names",
	Desc = "Nombre sobre la cabeza",
	Value = getgenv().ESP.Names,
	Flag = "ESPNames",
	Callback = function(v) getgenv().ESP.Names = v end,
})
VisualsTab:Toggle({
	Title = "Distance",
	Desc = "Distancia en studs",
	Value = getgenv().ESP.Distance,
	Flag = "ESPDistance",
	Callback = function(v) getgenv().ESP.Distance = v end,
})
VisualsTab:Toggle({
	Title = "Chams (Highlight)",
	Desc = "Highlight AlwaysOnTop",
	Value = getgenv().ESP.Chams,
	Flag = "ESPChams",
	Callback = function(v) getgenv().ESP.Chams = v end,
})
VisualsTab:Toggle({
	Title = "ESP Health",
	Desc = "HP junto al nombre",
	Value = getgenv().Unique.EspHealth,
	Flag = "EspHealth",
	Callback = function(v) getgenv().Unique.EspHealth = v end,
})
VisualsTab:Dropdown({
	Title = "Tracer Origin",
	Values = { "Bottom", "Center", "Top" },
	Value = getgenv().ESP.TracerOrigin or "Bottom",
	Flag = "TracerOrigin",
	Callback = function(v) getgenv().ESP.TracerOrigin = v end,
})
VisualsTab:Button({
	Title = "Enable Full ESP Pack",
	Icon = "eye",
	Callback = function()
		getgenv().ESP.Enabled = true
		getgenv().ESP.Boxes = true
		getgenv().ESP.Tracers = true
		getgenv().ESP.Names = true
		getgenv().ESP.Distance = true
		getgenv().ESP.Chams = true
		getgenv().Unique.EspHealth = true
		WindUI:Notify({ Title = "ESP", Content = "Full pack ON", Duration = 2 })
	end,
})
VisualsTab:Button({
	Title = "Disable All ESP",
	Icon = "eye-off",
	Callback = function()
		getgenv().ESP.Enabled = false
		getgenv().ESP.Boxes = false
		getgenv().ESP.Tracers = false
		getgenv().ESP.Names = false
		getgenv().ESP.Distance = false
		getgenv().ESP.Chams = false
		WindUI:Notify({ Title = "ESP", Content = "All off", Duration = 2 })
	end,
})

VisualsTab:Section({ Title = "Streamer (tambiÃ©n en Player)" })
VisualsTab:Toggle({
	Title = "Streamer Mode",
	Desc = "Oculta botÃ³n flotante",
	Value = getgenv().Streamer.Mode,
	Flag = "StreamerMode",
	Callback = function(v) getgenv().Streamer.Mode = v end,
})
VisualsTab:Toggle({
	Title = "Streamer Mode 100%",
	Desc = "Oculta UI + ESP + drawings",
	Value = getgenv().Streamer.Mode100,
	Flag = "Streamer100",
	Callback = function(v) getgenv().Streamer.Mode100 = v end,
})
VisualsTab:Toggle({
	Title = "No Rank Tag",
	Value = getgenv().Streamer.NoRankTag,
	Flag = "NoRankTag",
	Callback = function(v) getgenv().Streamer.NoRankTag = v end,
})
VisualsTab:Input({
	Title = "Custom Name (solo tÃº)",
	Value = getgenv().Streamer.CustomName or "",
	Flag = "CustomName",
	Callback = function(t) getgenv().Streamer.CustomName = t or "" end,
})

MovementTab:Section({ Title = "Speed & Jump" })
MovementTab:Paragraph({
	Title = "Movement",
	Desc = "Soft Walk no toca WalkSpeed (CFrame). Ghost = transparencia local + speed 50. Farm estÃ¡ en tab Farm.",
})
MovementTab:Slider({
	Title = "WalkSpeed",
	Step = 1,
	Value = { Min = 1, Max = 100, Default = getgenv().Movement.Speed or 16 },
	Flag = "WalkSpeed",
	Callback = function(v)
		getgenv().Movement.Speed = v
		local char = LocalPlayer.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if hum then hum.WalkSpeed = v end
	end,
})
MovementTab:Slider({
	Title = "JumpPower",
	Step = 1,
	Value = { Min = 10, Max = 150, Default = getgenv().Movement.JumpPower or 50 },
	Flag = "JumpPower",
	Callback = function(v)
		getgenv().Movement.JumpPower = v
		local char = LocalPlayer.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.UseJumpPower = true
			hum.JumpPower = v
		end
	end,
})
MovementTab:Slider({
	Title = "Camera FOV",
	Step = 1,
	Value = { Min = 40, Max = 120, Default = getgenv().Movement.FOV or 70 },
	Flag = "CamFOV",
	Callback = function(v) getgenv().Movement.FOV = v end,
})
MovementTab:Toggle({
	Title = "Soft Walk",
	Desc = "CFrame speed (no toca WalkSpeed)",
	Value = getgenv().Unique.SoftWalk,
	Flag = "SoftWalk",
	Callback = function(v) getgenv().Unique.SoftWalk = v end,
})
MovementTab:Toggle({
	Title = "Noclip",
	Value = getgenv().Movement.Noclip,
	Flag = "Noclip",
	Callback = function(v) getgenv().Movement.Noclip = v end,
})
MovementTab:Toggle({
	Title = "Ghost Mode",
	Desc = "Transparencia local Â· Speed 50",
	Value = getgenv().Movement.Ghost,
	Flag = "Ghost",
	Callback = function(v)
		getgenv().Movement.Ghost = v
		local char = LocalPlayer.Character
		if char then
			local hum = char:FindFirstChildOfClass("Humanoid")
			for _, part in ipairs(char:GetDescendants()) do
				if part:IsA("BasePart") then
					pcall(function()
						part.LocalTransparencyModifier = v and 0.45 or 0
					end)
				end
			end
			if hum then
				hum.WalkSpeed = v and 50 or (getgenv().Movement.Speed or 16)
			end
		end
	end,
})
MovementTab:Toggle({
	Title = "Infinite Jump",
	Value = getgenv().Movement.InfJump,
	Flag = "InfJump",
	Callback = function(v) getgenv().Movement.InfJump = v end,
})
MovementTab:Toggle({
	Title = "Auto Sprint",
	Value = getgenv().Unique.AutoSprint,
	Flag = "AutoSprint",
	Callback = function(v) getgenv().Unique.AutoSprint = v end,
})
MovementTab:Toggle({
	Title = "Click TP",
	Value = getgenv().Unique.ClickTP,
	Flag = "ClickTP",
	Callback = function(v) getgenv().Unique.ClickTP = v end,
})
MovementTab:Toggle({
	Title = "Low Gravity",
	Value = getgenv().Unique.LowGravity,
	Flag = "LowGravity",
	Callback = function(v) getgenv().Unique.LowGravity = v end,
})
MovementTab:Toggle({
	Title = "Fullbright",
	Value = getgenv().Movement.Fullbright,
	Flag = "Fullbright",
	Callback = function(v) getgenv().Movement.Fullbright = v end,
})
MovementTab:Section({ Title = "Fly & Magnet" })
MovementTab:Toggle({
	Title = "Fly",
	Desc = "WASD + Space/Ctrl Â· BodyVelocity",
	Value = getgenv().Movement.Fly or false,
	Flag = "Fly",
	Callback = function(v) getgenv().Movement.Fly = v end,
})
MovementTab:Slider({
	Title = "Fly Speed",
	Step = 1,
	Value = { Min = 10, Max = 150, Default = getgenv().Movement.FlySpeed or 50 },
	Flag = "FlySpeed",
	Callback = function(v) getgenv().Movement.FlySpeed = v end,
})
MovementTab:Toggle({
	Title = "Magnet TP (Enemies)",
	Desc = "Se pega detrÃ¡s del enemigo mÃ¡s cercano",
	Value = getgenv().Unique.MagnetTP or false,
	Flag = "MagnetTP",
	Callback = function(v) getgenv().Unique.MagnetTP = v end,
})
MovementTab:Slider({
	Title = "Magnet Gap (s)",
	Step = 0.01,
	Value = { Min = 0.05, Max = 0.5, Default = getgenv().Unique.MagnetGap or 0.12 },
	Flag = "MagnetGap",
	Callback = function(v) getgenv().Unique.MagnetGap = v end,
})
MovementTab:Section({ Title = "Performance" })
MovementTab:Toggle({
	Title = "FPS Boost",
	Desc = "Sombras/fog/terreno light",
	Value = getgenv().Unique.FpsBoost or false,
	Flag = "FpsBoost",
	Callback = function(v) getgenv().Unique.FpsBoost = v end,
})
MovementTab:Toggle({
	Title = "Show FPS / Ping",
	Value = getgenv().Unique.ShowStats or false,
	Flag = "ShowStats",
	Callback = function(v) getgenv().Unique.ShowStats = v end,
})
FarmTab:Section({ Title = "CollectEvent Farm" })
FarmTab:Paragraph({
	Title = "Cobalt CollectEventSpawnable",
	Desc = "Spam RE + smart collect. Ajusta rate segÃºn el server.",
})
FarmTab:Toggle({
	Title = "Touch Farm (Spawnables)",
	Desc = "firetouchinterest en SpawnablesClient / Spawnables",
	Value = getgenv().Unique.TouchFarm ~= false,
	Flag = "TouchFarm",
	Callback = function(v) getgenv().Unique.TouchFarm = v end,
})
FarmTab:Toggle({
	Title = "Auto Farm",
	Desc = "Spam CollectEvent + touch farm si ON",
	Value = (getgenv().AutoFarm and getgenv().AutoFarm.Enabled) or getgenv().Movement.AutoFarm or false,
	Flag = "AutoFarm",
	Callback = function(v)
		getgenv().AutoFarm.Enabled = v
		getgenv().Movement.AutoFarm = v
		if v then
			local ev = getgenv()._IKG_ResolveCollectEvent and getgenv()._IKG_ResolveCollectEvent()
			WindUI:Notify({
				Title = "Auto Farm",
				Content = ev and "Event encontrado Â· spamming" or "Buscando eventâ¦",
				Duration = 2.5,
			})
		end
	end,
})
FarmTab:Slider({
	Title = "Spam Rate (evt/s)",
	Step = 1,
	Value = { Min = 5, Max = 200, Default = (getgenv().AutoFarm and getgenv().AutoFarm.SpamRate) or 60 },
	Flag = "AFSpamRate",
	Callback = function(v)
		getgenv().AutoFarm.SpamRate = v
		local burst = getgenv().AutoFarm.BurstSize or 10
		getgenv().AutoFarm.BurstGap = math.max(0.005, burst / math.max(v, 1))
	end,
})
FarmTab:Slider({
	Title = "Burst Size",
	Step = 1,
	Value = { Min = 1, Max = 32, Default = (getgenv().AutoFarm and getgenv().AutoFarm.BurstSize) or 10 },
	Flag = "AFBurst",
	Callback = function(v)
		getgenv().AutoFarm.BurstSize = v
		local rate = getgenv().AutoFarm.SpamRate or 60
		getgenv().AutoFarm.BurstGap = math.max(0.005, v / math.max(rate, 1))
	end,
})
FarmTab:Toggle({
	Title = "Double Fire",
	Desc = "2x FireServer por tick (mas agresivo)",
	Value = getgenv().AutoFarm and getgenv().AutoFarm.DoubleFire ~= false,
	Flag = "AFDouble",
	Callback = function(v) getgenv().AutoFarm.DoubleFire = v end,
})
FarmTab:Toggle({
	Title = "Smart Collect",
	Desc = "Acercarse a spawnables cercanos",
	Value = getgenv().AutoFarm and getgenv().AutoFarm.SmartCollect ~= false,
	Flag = "AFSmart",
	Callback = function(v) getgenv().AutoFarm.SmartCollect = v end,
})
FarmTab:Toggle({
	Title = "TP Collect",
	Desc = "Teleport al item cercano (rapido)",
	Value = getgenv().AutoFarm and getgenv().AutoFarm.TpCollect == true,
	Flag = "AFTpCollect",
	Callback = function(v) getgenv().AutoFarm.TpCollect = v end,
})
FarmTab:Slider({
	Title = "TP Collect Gap",
	Step = 0.05,
	Value = { Min = 0.1, Max = 1.5, Default = (getgenv().AutoFarm and getgenv().AutoFarm.TpGap) or 0.35 },
	Flag = "AFTpGap",
	Callback = function(v) getgenv().AutoFarm.TpGap = v end,
})
FarmTab:Slider({
	Title = "Collect Range",
	Step = 1,
	Value = { Min = 8, Max = 120, Default = (getgenv().AutoFarm and getgenv().AutoFarm.CollectRange) or 35 },
	Flag = "AFRange",
	Callback = function(v) getgenv().AutoFarm.CollectRange = v end,
})
FarmTab:Slider({
	Title = "Collect Speed",
	Step = 1,
	Value = { Min = 10, Max = 100, Default = (getgenv().AutoFarm and getgenv().AutoFarm.CollectSpeed) or 42 },
	Flag = "AFSpeed",
	Callback = function(v) getgenv().AutoFarm.CollectSpeed = v end,
})
FarmTab:Toggle({
	Title = "Only When Alive",
	Value = getgenv().AutoFarm and getgenv().AutoFarm.OnlyWhenAlive ~= false,
	Flag = "AFAlive",
	Callback = function(v) getgenv().AutoFarm.OnlyWhenAlive = v end,
})
FarmTab:Toggle({
	Title = "Pause on Kill All",
	Value = getgenv().AutoFarm and getgenv().AutoFarm.PauseOnKillAll ~= false,
	Flag = "AFPauseKA",
	Callback = function(v) getgenv().AutoFarm.PauseOnKillAll = v end,
})
FarmTab:Toggle({
	Title = "Farm Status Overlay",
	Desc = "Contador evt/s en pantalla",
	Value = getgenv().AutoFarm and getgenv().AutoFarm.StatusText ~= false,
	Flag = "AFStatus",
	Callback = function(v) getgenv().AutoFarm.StatusText = v end,
})
FarmTab:Button({
	Title = "Force Resolve Event",
	Icon = "search",
	Callback = function()
		local ev = getgenv()._IKG_ResolveCollectEvent and getgenv()._IKG_ResolveCollectEvent()
		if ev then
			WindUI:Notify({
				Title = "Auto Farm",
				Content = "Event OK: " .. tostring(ev:GetFullName()),
				Duration = 3,
			})
		else
			WindUI:Notify({
				Title = "Auto Farm",
				Content = "No se encontrÃ³ CollectEventSpawnable",
				Duration = 3,
			})
		end
	end,
})
FarmTab:Button({
	Title = "Manual Burst x16",
	Icon = "zap",
	Callback = function()
		local n = 0
		if getgenv()._IKG_FireCollect then
			n = getgenv()._IKG_FireCollect(16) or 0
		end
		WindUI:Notify({
			Title = "Auto Farm",
			Content = "Burst enviado: " .. tostring(n),
			Duration = 1.5,
		})
	end,
})

FarmTab:Section({ Title = "Presets" })
FarmTab:Button({
	Title = "Preset: Safe (20/s)",
	Icon = "shield",
	Callback = function()
		getgenv().AutoFarm.SpamRate = 20
		getgenv().AutoFarm.BurstSize = 4
		getgenv().AutoFarm.BurstGap = 0.2
		getgenv().AutoFarm.SmartCollect = true
		getgenv().AutoFarm.Enabled = true
		getgenv().Movement.AutoFarm = true
		WindUI:Notify({ Title = "Farm", Content = "Safe preset ON", Duration = 2 })
	end,
})
FarmTab:Button({
	Title = "Preset: Balanced (45/s)",
	Icon = "gauge",
	Callback = function()
		getgenv().AutoFarm.SpamRate = 45
		getgenv().AutoFarm.BurstSize = 8
		getgenv().AutoFarm.BurstGap = 0.018
		getgenv().AutoFarm.SmartCollect = true
		getgenv().AutoFarm.Enabled = true
		getgenv().Movement.AutoFarm = true
		WindUI:Notify({ Title = "Farm", Content = "Balanced preset ON", Duration = 2 })
	end,
})
FarmTab:Button({
	Title = "Preset: Aggressive (90/s)",
	Icon = "flame",
	Callback = function()
		getgenv().AutoFarm.SpamRate = 90
		getgenv().AutoFarm.BurstSize = 12
		getgenv().AutoFarm.BurstGap = 0.012
		getgenv().AutoFarm.DoubleFire = true
		getgenv().AutoFarm.SmartCollect = true
		getgenv().AutoFarm.Enabled = true
		getgenv().Movement.AutoFarm = true
		WindUI:Notify({ Title = "Farm", Content = "Aggressive preset ON", Duration = 2 })
	end,
})
FarmTab:Button({
	Title = "Preset: Nuke (150/s + TP)",
	Icon = "bomb",
	Callback = function()
		getgenv().AutoFarm.SpamRate = 150
		getgenv().AutoFarm.BurstSize = 20
		getgenv().AutoFarm.BurstGap = 0.008
		getgenv().AutoFarm.DoubleFire = true
		getgenv().AutoFarm.SmartCollect = true
		getgenv().AutoFarm.TpCollect = true
		getgenv().AutoFarm.TpGap = 0.2
		getgenv().AutoFarm.CollectRange = 80
		getgenv().AutoFarm.Enabled = true
		getgenv().Movement.AutoFarm = true
		WindUI:Notify({ Title = "Farm", Content = "NUKE preset ON", Duration = 2 })
	end,
})

WorldTab:Section({ Title = "Lighting" })
WorldTab:Paragraph({
	Title = "World Visuals",
	Desc = "Sombras realistas + fog + sky presets. No afectan a otros jugadores.",
})
local realisticOn = false
WorldTab:Toggle({
	Title = "Realistic Shadows",
	Desc = "Future / soft lighting",
	Value = false,
	Flag = "RealisticLight",
	Callback = function(v)
		realisticOn = v
		pcall(function()
			if v then
				Lighting.GlobalShadows = true
				Lighting.ShadowSoftness = 0.2
				Lighting.Brightness = 2.2
				Lighting.Ambient = Color3.fromRGB(70, 70, 85)
				Lighting.OutdoorAmbient = Color3.fromRGB(110, 110, 130)
				Lighting.EnvironmentDiffuseScale = 1
				Lighting.EnvironmentSpecularScale = 1
				Lighting.ExposureCompensation = 0.15
				pcall(function() Lighting.Technology = Enum.Technology.Future end)
			else
				Lighting.ShadowSoftness = 0.5
				Lighting.Brightness = 1
				Lighting.Ambient = Color3.fromRGB(128, 128, 128)
				Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
				Lighting.ExposureCompensation = 0
			end
		end)
	end,
})
WorldTab:Toggle({
	Title = "Atmospheric Fog",
	Value = false,
	Flag = "Fog",
	Callback = function(v)
		pcall(function()
			if v then
				Lighting.FogEnd = 600
				Lighting.FogStart = 50
				Lighting.FogColor = Color3.fromRGB(180, 190, 210)
			else
				Lighting.FogEnd = 100000
				Lighting.FogStart = 0
			end
		end)
	end,
})

WorldTab:Section({ Title = "Sky Presets" })
local skyPresets = {
	{ Name = "Atardecer", SkyboxBk = "rbxassetid://6444884337", SkyboxDn = "rbxassetid://6444884785", SkyboxFt = "rbxassetid://6444884337", SkyboxLf = "rbxassetid://6444884337", SkyboxRt = "rbxassetid://6444884337", SkyboxUp = "rbxassetid://6412503613", Ambient = Color3.fromRGB(180, 120, 90), Outdoor = Color3.fromRGB(200, 140, 100) },
	{ Name = "Noche", SkyboxBk = "rbxassetid://12064107", SkyboxDn = "rbxassetid://12064152", SkyboxFt = "rbxassetid://12064121", SkyboxLf = "rbxassetid://12064115", SkyboxRt = "rbxassetid://12064124", SkyboxUp = "rbxassetid://12064131", Ambient = Color3.fromRGB(40, 45, 70), Outdoor = Color3.fromRGB(30, 35, 60) },
	{ Name = "Dia limpio", SkyboxBk = "rbxassetid://591058823", SkyboxDn = "rbxassetid://591059876", SkyboxFt = "rbxassetid://591058104", SkyboxLf = "rbxassetid://591057843", SkyboxRt = "rbxassetid://591057772", SkyboxUp = "rbxassetid://591058833", Ambient = Color3.fromRGB(140, 150, 170), Outdoor = Color3.fromRGB(160, 170, 190) },
	{ Name = "Infierno", SkyboxBk = "rbxassetid://159454299", SkyboxDn = "rbxassetid://159454296", SkyboxFt = "rbxassetid://159454293", SkyboxLf = "rbxassetid://159454286", SkyboxRt = "rbxassetid://159454300", SkyboxUp = "rbxassetid://159454288", Ambient = Color3.fromRGB(120, 50, 30), Outdoor = Color3.fromRGB(150, 60, 40) },
	{ Name = "Invierno", SkyboxBk = "rbxassetid://150939022", SkyboxDn = "rbxassetid://150939025", SkyboxFt = "rbxassetid://150939027", SkyboxLf = "rbxassetid://150939029", SkyboxRt = "rbxassetid://150939031", SkyboxUp = "rbxassetid://150939034", Ambient = Color3.fromRGB(160, 175, 200), Outdoor = Color3.fromRGB(180, 190, 210) },
	{ Name = "Default", Reset = true },
}
WorldTab:Dropdown({
	Title = "Sky",
	Values = (function()
		local t = {}
		for _, p in ipairs(skyPresets) do table.insert(t, p.Name) end
		return t
	end)(),
	Value = "Default",
	Flag = "SkyPreset",
	Callback = function(name)
		for _, preset in ipairs(skyPresets) do
			if preset.Name == name then
				pcall(function()
					local existing = Lighting:FindFirstChildOfClass("Sky")
					if existing then existing:Destroy() end
					if preset.Reset then
						Lighting.Ambient = Color3.fromRGB(128, 128, 128)
						Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
						return
					end
					local sky = Instance.new("Sky")
					sky.SkyboxBk = preset.SkyboxBk
					sky.SkyboxDn = preset.SkyboxDn
					sky.SkyboxFt = preset.SkyboxFt
					sky.SkyboxLf = preset.SkyboxLf
					sky.SkyboxRt = preset.SkyboxRt
					sky.SkyboxUp = preset.SkyboxUp
					sky.Parent = Lighting
					if preset.Ambient then Lighting.Ambient = preset.Ambient end
					if preset.Outdoor then Lighting.OutdoorAmbient = preset.Outdoor end
				end)
				break
			end
		end
	end,
})


-- ââââââââââââââââââââââââââââ PLAYER ââââââââââââââââââââââââââââ
PlayerTab:Section({ Title = "Character" })
PlayerTab:Toggle({
	Title = "Anti Sit",
	Desc = "Bloquea sit / platform stand",
	Value = getgenv().Unique.AntiSit,
	Flag = "PAntiSit",
	Callback = function(v) getgenv().Unique.AntiSit = v end,
})
PlayerTab:Toggle({
	Title = "Auto Respawn",
	Desc = "BreakJoints al morir",
	Value = getgenv().Unique.AutoRespawn,
	Flag = "PAutoRespawn",
	Callback = function(v) getgenv().Unique.AutoRespawn = v end,
})
PlayerTab:Toggle({
	Title = "No Fall Damage",
	Desc = "Limita velocidad de caÃ­da",
	Value = getgenv().Unique.NoFallDamage,
	Flag = "PNoFall",
	Callback = function(v) getgenv().Unique.NoFallDamage = v end,
})
PlayerTab:Toggle({
	Title = "Auto Sprint",
	Desc = "Sube WalkSpeed al moverte",
	Value = getgenv().Unique.AutoSprint,
	Flag = "PAutoSprint",
	Callback = function(v) getgenv().Unique.AutoSprint = v end,
})
PlayerTab:Toggle({
	Title = "Click TP",
	Desc = "Click izquierdo = teleport",
	Value = getgenv().Unique.ClickTP,
	Flag = "PClickTP",
	Callback = function(v) getgenv().Unique.ClickTP = v end,
})
PlayerTab:Toggle({
	Title = "Low Gravity",
	Desc = "Suaviza gravedad",
	Value = getgenv().Unique.LowGravity,
	Flag = "PLowGrav",
	Callback = function(v) getgenv().Unique.LowGravity = v end,
})

PlayerTab:Section({ Title = "Camera & Vision" })
PlayerTab:Slider({
	Title = "Camera FOV",
	Step = 1,
	Value = { Min = 40, Max = 120, Default = getgenv().Movement.FOV or 70 },
	Flag = "PCamFOV",
	Callback = function(v) getgenv().Movement.FOV = v end,
})
PlayerTab:Toggle({
	Title = "Fullbright",
	Value = getgenv().Movement.Fullbright,
	Flag = "PFullbright",
	Callback = function(v) getgenv().Movement.Fullbright = v end,
})
PlayerTab:Toggle({
	Title = "Zoom Lock",
	Desc = "Flag reservado",
	Value = getgenv().Unique.ZoomLock,
	Flag = "PZoomLock",
	Callback = function(v) getgenv().Unique.ZoomLock = v end,
})

PlayerTab:Section({ Title = "Info Overlays" })
PlayerTab:Toggle({
	Title = "Enemy Radar",
	Value = getgenv().Unique.EnemyRadar,
	Flag = "PRadar",
	Callback = function(v) getgenv().Unique.EnemyRadar = v end,
})
PlayerTab:Toggle({
	Title = "Match Info",
	Value = getgenv().Unique.MatchInfo,
	Flag = "PMatchInfo",
	Callback = function(v) getgenv().Unique.MatchInfo = v end,
})
PlayerTab:Toggle({
	Title = "ESP Health in Names",
	Value = getgenv().Unique.EspHealth,
	Flag = "PEspHP",
	Callback = function(v) getgenv().Unique.EspHealth = v end,
})

PlayerTab:Section({ Title = "Streamer Tools" })
PlayerTab:Toggle({
	Title = "Streamer Mode",
	Desc = "Oculta botÃ³n flotante",
	Value = getgenv().Streamer.Mode,
	Flag = "PStreamMode",
	Callback = function(v) getgenv().Streamer.Mode = v end,
})
PlayerTab:Toggle({
	Title = "Streamer Mode 100%",
	Desc = "Oculta UI + ESP + drawings",
	Value = getgenv().Streamer.Mode100,
	Flag = "PStream100",
	Callback = function(v) getgenv().Streamer.Mode100 = v end,
})
PlayerTab:Toggle({
	Title = "Hide Rank Tags",
	Value = getgenv().Streamer.NoRankTag,
	Flag = "PNoRank",
	Callback = function(v) getgenv().Streamer.NoRankTag = v end,
})
PlayerTab:Input({
	Title = "Custom Name (solo tÃº)",
	Value = getgenv().Streamer.CustomName or "",
	Flag = "PCustomName",
	Callback = function(t) getgenv().Streamer.CustomName = t or "" end,
})

SettingsTab:Section({ Title = "Theme" })
SettingsTab:Dropdown({
	Title = "WindUI Theme",
	Values = (function()
		local names = {}
		pcall(function()
			for name in pairs(WindUI:GetThemes()) do
				table.insert(names, name)
			end
		end)
		if #names == 0 then
			names = { "Amber", "Dark", "Light", "Rose", "Violet", "Emerald", "Indigo", "Sky" }
		end
		table.sort(names)
		return names
	end)(),
	Value = "Amber",
	Flag = "UITheme",
	Callback = function(selected)
		pcall(function() WindUI:SetTheme(selected) end)
		getgenv().HubTheme.Name = selected
		local accents = {
			Amber = { Color3.fromRGB(232, 145, 42), Color3.fromRGB(255, 190, 90) },
			Dark = { Color3.fromRGB(120, 140, 255), Color3.fromRGB(180, 195, 255) },
			Light = { Color3.fromRGB(60, 100, 200), Color3.fromRGB(120, 150, 230) },
			Rose = { Color3.fromRGB(244, 100, 140), Color3.fromRGB(255, 160, 190) },
			Violet = { Color3.fromRGB(160, 100, 255), Color3.fromRGB(200, 160, 255) },
			Emerald = { Color3.fromRGB(40, 200, 140), Color3.fromRGB(100, 240, 180) },
			Indigo = { Color3.fromRGB(90, 110, 255), Color3.fromRGB(150, 165, 255) },
			Sky = { Color3.fromRGB(50, 180, 255), Color3.fromRGB(120, 210, 255) },
		}
		local a = accents[selected]
		if a then
			getgenv().HubTheme.Accent = a[1]
			getgenv().HubTheme.AccentLight = a[2]
		end
		WindUI:Notify({ Title = "Theme", Content = "Aplicado: " .. tostring(selected), Duration = 1.5 })
	end,
})

SettingsTab:Section({ Title = "Typography / Letras" })
SettingsTab:Paragraph({
	Title = "Fuentes bonitas",
	Desc = "Aplica a ESP names, radar, match info y farm status. No cambia el texto del juego (Roblox no lo permite).",
})
SettingsTab:Dropdown({
	Title = "Font Style",
	Values = { "GothamBold", "Gotham", "UI", "System", "Plex", "Monospace" },
	Value = (getgenv().HubTheme and getgenv().HubTheme.FontName) or "GothamBold",
	Flag = "UIFontStyle",
	Callback = function(name)
		getgenv().HubTheme.FontName = name
		WindUI:Notify({ Title = "Font", Content = "Estilo: " .. tostring(name), Duration = 1.5 })
	end,
})
SettingsTab:Slider({
	Title = "Text Size",
	Step = 1,
	Value = { Min = 11, Max = 22, Default = (getgenv().HubTheme and getgenv().HubTheme.TextSize) or 14 },
	Flag = "UITextSize",
	Callback = function(v) getgenv().HubTheme.TextSize = v end,
})
SettingsTab:Toggle({
	Title = "Text Outline",
	Desc = "Borde negro en textos ESP/overlays",
	Value = getgenv().HubTheme and getgenv().HubTheme.Outline ~= false,
	Flag = "UITextOutline",
	Callback = function(v) getgenv().HubTheme.Outline = v end,
})
SettingsTab:Button({
	Title = "Apply Font to overlays now",
	Icon = "type",
	Callback = function()
		pcall(function()
			if getgenv()._IKG_ApplyFonts then getgenv()._IKG_ApplyFonts() end
		end)
		WindUI:Notify({ Title = "Font", Content = "Aplicado a overlays", Duration = 1.5 })
	end,
})

SettingsTab:Section({ Title = "Animations" })
local movementPacks = {
	{ Name = "Yours", Keep = true },
	{ Name = "R15 Classic", Idle = "507766388", Walk = "507777826", Run = "507767714", Jump = "507765000", Fall = "507767968", Climb = "507765644", Swim = "507784897" },
	{ Name = "Ninja", Idle = "656117400", Walk = "656118341", Run = "656118852", Jump = "656117878", Fall = "656117177", Climb = "656114359", Swim = "656119721" },
	{ Name = "Robot", Idle = "616006778", Walk = "616010313", Run = "616010803", Jump = "616008936", Fall = "616008211", Climb = "616005863", Swim = "616011509" },
	{ Name = "Zombie", Idle = "616158929", Walk = "616163682", Run = "616168032", Jump = "616161997", Fall = "616157476", Climb = "616156119", Swim = "616165109" },
	{ Name = "Stylish", Idle = "616136790", Walk = "616140816", Run = "616146177", Jump = "616139451", Fall = "616134815", Climb = "616133594", Swim = "616143378" },
	{ Name = "SuperHero", Idle = "616111295", Walk = "616113536", Run = "616117076", Jump = "616115533", Fall = "616110087", Climb = "616118421", Swim = "616119360" },
	{ Name = "Toy", Idle = "782841498", Walk = "782843345", Run = "782842708", Jump = "782847020", Fall = "782846423", Climb = "782843869", Swim = "782845736" },
	{ Name = "Cartoony", Idle = "742637544", Walk = "742640026", Run = "742638842", Jump = "742637942", Fall = "742637151", Climb = "742636889", Swim = "742640855" },
	{ Name = "Elder", Idle = "845397899", Walk = "845403856", Run = "845386501", Jump = "845398858", Fall = "845396048", Climb = "845392038", Swim = "845403029" },
	{ Name = "Pirate", Idle = "750781874", Walk = "750785693", Run = "750783738", Jump = "750782230", Fall = "750780687", Climb = "750779899", Swim = "750786920" },
	{ Name = "Knight", Idle = "657595757", Walk = "657552015", Run = "657564596", Jump = "658409194", Fall = "657600338", Climb = "658360781", Swim = "657560551" },
	{ Name = "Vampire", Idle = "1083445855", Walk = "1083473930", Run = "1083465853", Jump = "1083455352", Fall = "1083443587", Climb = "1083439238", Swim = "1083480673" },
	{ Name = "Werewolf", Idle = "1083195517", Walk = "1083178339", Run = "1083216692", Jump = "1083218792", Fall = "1083189019", Climb = "1083182000", Swim = "1083222527" },
	{ Name = "Astronaut", Idle = "891621366", Walk = "891633237", Run = "891636393", Jump = "891627522", Fall = "891617961", Climb = "891616865", Swim = "891638092" },
}
SettingsTab:Dropdown({
	Title = "Movement Pack",
	Desc = "Yours = tus animaciones compradas / avatar",
	Values = (function()
		local t = {}
		for _, p in ipairs(movementPacks) do table.insert(t, p.Name) end
		return t
	end)(),
	Value = "Yours",
	Flag = "AnimPack",
	Callback = function(name)
		getgenv().AnimMix.Pack = name or "Yours"
		if name == "Yours" then
			getgenv().AnimMix.Idle = nil
			getgenv().AnimMix.Walk = nil
			getgenv().AnimMix.Run = nil
			getgenv().AnimMix.Jump = nil
			getgenv().AnimMix.Fall = nil
			getgenv().AnimMix.Climb = nil
			getgenv().AnimMix.Swim = nil
			if getgenv()._IKG_ApplyAnimMix then pcall(getgenv()._IKG_ApplyAnimMix) end
			WindUI:Notify({ Title = "Anims", Content = "Tus animaciones (avatar)", Duration = 2 })
			return
		end
		for _, pack in ipairs(movementPacks) do
			if pack.Name == name and not pack.Keep then
				getgenv().AnimMix.Idle = pack.Idle
				getgenv().AnimMix.Walk = pack.Walk
				getgenv().AnimMix.Run = pack.Run
				getgenv().AnimMix.Jump = pack.Jump
				getgenv().AnimMix.Fall = pack.Fall
				getgenv().AnimMix.Climb = pack.Climb
				getgenv().AnimMix.Swim = pack.Swim
				if getgenv()._IKG_ApplyAnimMix then pcall(getgenv()._IKG_ApplyAnimMix) end
				WindUI:Notify({ Title = "Anims", Content = "Pack: " .. name, Duration = 2 })
				break
			end
		end
	end,
})
SettingsTab:Button({
	Title = "Re-capture my animations",
	Icon = "refresh-cw",
	Callback = function()
		pcall(function()
			if getgenv()._IKG_CaptureAnims then getgenv()._IKG_CaptureAnims() end
			getgenv().AnimMix.Pack = "Yours"
			if getgenv()._IKG_ApplyAnimMix then getgenv()._IKG_ApplyAnimMix() end
			WindUI:Notify({ Title = "Anims", Content = "Animaciones de tu avatar guardadas", Duration = 2 })
		end)
	end,
})

SettingsTab:Section({ Title = "Config" })
SettingsTab:Button({
	Title = "Save Config",
	Icon = "save",
	Callback = function()
		pcall(function()
			if Window.ConfigManager then
				local cfg = Window.ConfigManager:Config("default")
				cfg:Save()
				WindUI:Notify({ Title = "Config", Content = "Guardado", Duration = 2 })
			end
		end)
	end,
})
SettingsTab:Button({
	Title = "Load Config",
	Icon = "folder-open",
	Callback = function()
		pcall(function()
			if Window.ConfigManager then
				local cfg = Window.ConfigManager:Config("default")
				cfg:Load()
				WindUI:Notify({ Title = "Config", Content = "Cargado", Duration = 2 })
			end
		end)
	end,
})

SettingsTab:Section({ Title = "Safety / Reset" })
SettingsTab:Button({
	Title = "Disable All Combat",
	Icon = "shield-off",
	Callback = function()
		getgenv().SilentAim.Enabled = false
		getgenv().AutoShot.Enabled = false
		getgenv().TriggerBot.Enabled = false
		getgenv().KillAll.Enabled = false
		getgenv().AntiKillAll.Enabled = false
		getgenv().Tool2Macro.Enabled = false
		getgenv().Hitbox.Enabled = false
		WindUI:Notify({ Title = "Safety", Content = "Combat OFF", Duration = 2 })
	end,
})
SettingsTab:Button({
	Title = "Disable All Movement Hacks",
	Icon = "footprints",
	Callback = function()
		getgenv().Movement.Noclip = false
		getgenv().Movement.Ghost = false
		getgenv().Movement.InfJump = false
		getgenv().Unique.SoftWalk = false
		getgenv().Unique.ClickTP = false
		getgenv().Unique.LowGravity = false
		getgenv().Movement.Speed = 16
		local char = LocalPlayer.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if hum then hum.WalkSpeed = 16 end
		WindUI:Notify({ Title = "Safety", Content = "Movement reset", Duration = 2 })
	end,
})
SettingsTab:Button({
	Title = "Stop Auto Farm",
	Icon = "square",
	Callback = function()
		if getgenv().AutoFarm then getgenv().AutoFarm.Enabled = false end
		getgenv().Movement.AutoFarm = false
		WindUI:Notify({ Title = "Farm", Content = "Auto Farm stopped", Duration = 2 })
	end,
})

SettingsTab:Section({ Title = "About" })
SettingsTab:Paragraph({
	Title = "Ikgonavi Hub v9.7",
	Desc = "Amber Core Â· WindUI Â· Device: " .. tostring(DEVICE) .. " Â· Tabs: Home Combat Visuals Movement Farm World Player Settings",
})
SettingsTab:Paragraph({
	Title = "Tips",
	Desc = "RightShift = UI Â· Config save/load en esta tab Â· Farm tab para CollectEvent Â· ESP full pack en Visuals",
})
SettingsTab:Button({
	Title = "Copy Discord",
	Icon = "link",
	Callback = function()
		pcall(function()
			if setclipboard then setclipboard("https://discord.gg/S3AZJDwRWQ") end
		end)
		WindUI:Notify({ Title = "Discord", Content = "Copiado", Duration = 2 })
	end,
})

initSystems()

WindUI:Notify({
	Title = "Ikgonavi Hub",
	Content = "v9.7 Â· Amber Â· " .. tostring(DEVICE) .. " Â· UI upgraded + AutoFarm",
	Icon = "check",
	Duration = 4,
})
