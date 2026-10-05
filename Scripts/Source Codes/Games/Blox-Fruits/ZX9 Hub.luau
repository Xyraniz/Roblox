if _G.ZX9Loaded then error("Already Loaded!") end
_G.ZX9Loaded = true
local FactoryLoc = workspace._WorldOrigin.Locations:FindFirstChild("Factory")
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local autoAttack = false
local Settings = {Distance = 50, AttackDelay = 0}
local Modules = ReplicatedStorage:WaitForChild("Modules")
local Net = Modules:WaitForChild("Net")
local RegisterAttack = Net:WaitForChild("RE/RegisterAttack")
local RegisterHit = Net:WaitForChild("RE/RegisterHit")
local hitData = {[4] = "4676ac1a"}
local selectedWeaponType = "Melee"
local selectedStat = "Melee"
local autoStats = false
local addAmount = 1
local bountyFarm = false
local bountySettings = {FollowDistance = 20, SurroundDistance = 20}
local lastMoveTime = 0
local moveInterval = 1

Player.CharacterAdded:Connect(function(c)
	Character = c
	Humanoid = c:WaitForChild("Humanoid")
	HumanoidRootPart = c:WaitForChild("HumanoidRootPart")
	local Highlight = Instance.new("Highlight")
	Highlight.Parent = Character
	Highlight.FillColor = Color3.fromRGB(60, 179, 113)
	Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
	if not Character:FindFirstChild("HasBuso") then
		ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso")
	end
end)

local Quests = loadstring(game:HttpGet("https://raw.githubusercontent.com/CFR-Executor/resources/refs/heads/main/bfquestdumpfull"))()

local function isOnIsland(islandName)
	local map = Workspace:WaitForChild("Map")
	local island = map:FindFirstChild(islandName)
	if not island then return false end
	for _, part in ipairs(island:GetDescendants()) do
		if part:IsA("BasePart") then
			local relative = part.CFrame:PointToObjectSpace(HumanoidRootPart.Position)
			local half = part.Size / 2
			if math.abs(relative.X) <= half.X and math.abs(relative.Z) <= half.Z then
				if relative.Y >= -50 and relative.Y <= half.Y + 50 then return true end
			end
		end
	end
	return false
end

local function moveTo(position)
	local tweenInfo = TweenInfo.new((HumanoidRootPart.Position - position).Magnitude / 350, Enum.EasingStyle.Linear)
	local tween = TweenService:Create(HumanoidRootPart, tweenInfo, {CFrame = CFrame.new(position)})
	tween:Play()
end

local function loadEnemy(enemyName)
	local origin = Workspace:FindFirstChild("_WorldOrigin")
	if not origin then return nil end
	local spawns = origin:FindFirstChild("EnemySpawns")
	if not spawns then return nil end
	for _, spawn in ipairs(spawns:GetChildren()) do
		local cleanName = spawn.Name:gsub("%[Lv%.%s*%d+%]%s*", ""):gsub("%s+$","")
		if cleanName == enemyName then
			moveTo(spawn.Position + Vector3.new(0, 20, 0))
			return spawn
		end
	end
	return nil
end

local function teleportToIsland(island)
	if island == "Fishmen" or island == "Fishman" then
		if isOnIsland("Fishmen") or isOnIsland("Fishman") then
			HumanoidRootPart.CFrame = workspace.Map.TeleportSpawn.ExitPoint.CFrame
			print("Going to Island: "..island)
		else
			HumanoidRootPart.CFrame = workspace.Map.TeleportSpawn.EntrancePoint.CFrame
			print("Going to Island: "..island)
		end
	elseif island == "SkyArea1" then
		HumanoidRootPart.CFrame = workspace.Map.SkyArea2.PathwayHouse.EntrancePoint.CFrame
		print("Going to Island: "..island)
	elseif island == "SkyArea2" then
		HumanoidRootPart.CFrame = workspace.Map.SkyArea1.PathwayTemple.ExitPoint.CFrame
		print("Going to Island: "..island)
	else
		local islandModel = Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild(island)
		if islandModel and islandModel:GetPivot() then
			moveTo(islandModel:GetPivot().Position + Vector3.new(0,50,0))
		end
		print("Going to Island: "..island)
	end
end

local islandNames = {
	BanditQuest1 = "Windmill",
	MarineQuest = "MarineStart",
	JungleQuest = "Jungle",
	BuggyQuest1 = "Pirate",
	BuggyQuest2 = "Pirate",
	DesertQuest = "Desert",
	SnowQuest = "Ice",
	MarineQuest2 = "MarineBase",
	SkyQuest = "Sky",
	SkyQuest2 = "Sky",
	PrisonerQuest = "Prison",
	ImpelQuest = "Prison",
	ColosseumQuest = "Colosseum",
	MagmaQuest = "Magma",
	FishmanQuest = "Fishmen",
	SkyExp1Quest = "SkyArea1",
	SkyExp2Quest = "SkyArea2",
	FountainQuest = "Fountain"
}

local function attachFloat()
	if not HumanoidRootPart:FindFirstChild("FloatBV") then
		local bv = Instance.new("BodyVelocity")
		bv.Name = "FloatBV"
		bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
		bv.Velocity = Vector3.zero
		bv.Parent = HumanoidRootPart
	end
	if not HumanoidRootPart:FindFirstChild("StabilizerBG") then
		local bg = Instance.new("BodyGyro")
		bg.Name = "StabilizerBG"
		bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
		bg.CFrame = HumanoidRootPart.CFrame
		bg.Parent = HumanoidRootPart
	end
end

local function getQuest(level)
	local player = game:GetService("Players").LocalPlayer
	local levelObj = player:FindFirstChild("Data") and player.Data:FindFirstChild("Level")
	if not levelObj then return nil end
	local level = levelObj.Value
	local highestQuest, highestIsland
	for islandName, questList in pairs(Quests) do
		for _, quest in ipairs(questList) do
			if level >= quest.LevelReq then
				if not highestQuest or quest.LevelReq > highestQuest.LevelReq then
					highestQuest = quest
					highestIsland = islandName
				end
			end
		end
	end
	if not highestQuest then return nil end
	local questFrame = player.PlayerGui:WaitForChild("Main"):WaitForChild("Quest")
	local hasQuest = questFrame.Visible
	if force or not hasQuest then
		pcall(function()
			game.ReplicatedStorage.Remotes.CommF_:InvokeServer(unpack(highestQuest.Args))
		end)
	end
	local enemyName
	if hasQuest then
		local titleLabel = questFrame.Container.QuestTitle:FindFirstChild("Title")
		if titleLabel then
			local parsed = titleLabel.Text:match("Defeat%s+%d+%s+(.+)%s+%(%d+/%d+%)")
			if parsed then enemyName = parsed end
		end
	end
	if not enemyName and highestQuest.Task then
		for name, _ in pairs(highestQuest.Task) do
			enemyName = name
			break
		end
	end
	local island = islandNames[highestIsland] or highestIsland
	if not isOnIsland(island) then
		local islandModel = Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild(island)
		if islandModel then
			teleportToIsland(island)
		end
	end
	if enemyName then loadEnemy(enemyName) end
	return {
		quest = highestQuest,
		enemy = enemyName,
		island = island,
		levelReq = highestQuest.LevelReq,
		args = highestQuest.Args
	}
end

local function findTarget()
	local targets = {}
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			table.insert(targets, p.Character)
		end
	end
	if #targets == 0 then return nil end
	-- Select nearest
	table.sort(targets, function(a, b)
		local da = (HumanoidRootPart.Position - a.HumanoidRootPart.Position).Magnitude
		local db = (HumanoidRootPart.Position - b.HumanoidRootPart.Position).Magnitude
		return da < db
	end)
	return targets[1]
end

local function toggleAutoAttack()
	autoAttack = not autoAttack
	if autoAttack then
		task.spawn(function()
			while autoAttack do
				if not HumanoidRootPart then break end
				local enemiesInRange = {}
				for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
					local head = enemy:FindFirstChild("Head")
					if head and (HumanoidRootPart.Position - head.Position).Magnitude <= Settings.Distance then
						table.insert(enemiesInRange, {enemy, head})
					end
				end
				if bountyFarm then
					for _, p in ipairs(Players:GetPlayers()) do
						if p ~= Player and p.Character then
							local head = p.Character:FindFirstChild("Head")
							if head and (HumanoidRootPart.Position - head.Position).Magnitude <= Settings.Distance then
								table.insert(enemiesInRange, {p.Character, head})
							end
						end
					end
				end
				if #enemiesInRange >= 1 then
					local target = enemiesInRange[1]
					local args
					if #enemiesInRange >= 2 then
						local other = enemiesInRange[2]
						args = {target[2], {{other[1], other[2]}}, [4] = hitData[4]}
					else
						args = {target[2], {}, [4] = hitData[4]}
					end
					RegisterAttack:FireServer(0)
					RegisterHit:FireServer(unpack(args))
				end
				for _, tool in ipairs(Player.Backpack:GetChildren()) do
					if tool:IsA("Tool") then
						if tool.ToolTip == selectedWeaponType then
							tool.Parent = Character
						else
							tool.Parent = Player.Backpack
						end
					end
				end
				for _, tool in ipairs(Character:GetChildren()) do
					if tool:IsA("Tool") and tool.ToolTip ~= selectedWeaponType then
						tool.Parent = Player.Backpack
					end
				end
				task.wait(Settings.AttackDelay)
			end
		end)
	end
end

local SetWalkSpeed = Humanoid.WalkSpeed
local library = loadstring(game:GetObjects("rbxassetid://7657867786")[1].Source)()
local Window = library:CreateWindow({
	Name = "ZX9 Hub | Blox Fruits"
})
local MainTab = Window:CreateTab({
	Name = "Main"
})
local AutoFarmSection = MainTab:CreateSection({
	Name = "Auto Farm"
})
local BountySection = MainTab:CreateSection({
	Name = "Bounty Farm"
})
local PlayerSection = MainTab:CreateSection({
	Name = "Player"
})
local MiscSection = MainTab:CreateSection({
	Name = "Misc"
})

local weaponOptions = {"Melee","Sword"}
local weaponIndex = 1
local weaponBtn
weaponBtn = AutoFarmSection:AddButton({
	Name = "Weapon Type: " .. selectedWeaponType,
	Callback = function()
		weaponIndex = (weaponIndex % #weaponOptions) + 1
		selectedWeaponType = weaponOptions[weaponIndex]
		weaponBtn.Instance.Text = "Weapon Type: " .. selectedWeaponType
	end
})

AutoFarmSection:AddToggle({
	Name = "Auto Attack",
	CurrentValue = false,
	Flag = "AutoAttack",
	Callback = function(value)
		toggleAutoAttack()
	end
})

local autofarm = false
local info
AutoFarmSection:AddToggle({
	Name = "Auto Farm Level",
	CurrentValue = false,
	Flag = "AutoFarmLevel",
	Callback = function(value)
		autofarm = value
		if autofarm then
			info = getQuest(true)
			toggleAutoAttack()
		end
	end
})

local chestFarmEnabled = false
AutoFarmSection:AddToggle({
	Name = "Auto Farm Chests",
	CurrentValue = false,
	Flag = "AutoFarmChests",
	Callback = function(value)
		chestFarmEnabled = value
		if value then
			task.spawn(function()
				local taken = {}
				while chestFarmEnabled do
					for _, chest in ipairs(workspace:WaitForChild("ChestModels"):GetChildren()) do
						if not taken[chest] and chest:IsA("Model") then
							local pivot = chest:GetPivot()
							game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = pivot
							taken[chest] = true
							task.wait(0.1)
						end
					end
					task.wait()
				end
			end)
		end
	end
})

BountySection:AddToggle({
	Name = "Bounty Farm",
	CurrentValue = false,
	Flag = "BountyFarm",
	Callback = function(value)
		bountyFarm = value
		if value then
			if not autoAttack then
				toggleAutoAttack()
			end
		else
			if autoAttack then
				toggleAutoAttack()
			end
		end
	end
})

local orbitRadius = 10
local orbitHeight = 8
local snapTime = 1.5
local snapIndex = 1
local lastSwitch = os.clock()
local snapOffsets = {
	Vector3.new(orbitRadius, orbitHeight, 0),
	Vector3.new(0, orbitHeight, orbitRadius),
	Vector3.new(-orbitRadius, orbitHeight, 0),
	Vector3.new(0, orbitHeight, -orbitRadius)
}
local orbitDistance = 15 -- distance to start orbiting

RunService.Heartbeat:Connect(function()
	if not (autofarm or bountyFarm) then
		if HumanoidRootPart:FindFirstChild("FloatBV") then
			HumanoidRootPart.FloatBV:Destroy()
		end
		if HumanoidRootPart:FindFirstChild("StabilizerBG") then
			HumanoidRootPart.StabilizerBG:Destroy()
		end
		return
	end

	attachFloat()

	-- -------------------------
	-- AUTOFARM LOGIC
	-- -------------------------
	if autofarm then
		if not info or not info.enemy then
			info = getQuest(true)
			return
		end
		for _, bodypart in ipairs(Character:GetChildren()) do
			if bodypart:IsA("BasePart") then
				bodypart.CanCollide = false
			end
		end
		local target
		for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
			local humanoid = enemy:FindFirstChildOfClass("Humanoid")
			if enemy.Name == info.enemy and humanoid and humanoid.Health > 0 then
				target = enemy
				break
			end
		end

		if not Player.PlayerGui.Main.Quest.Visible then
			info = getQuest(true)
			return
		end

		if target and target:FindFirstChild("HumanoidRootPart") then
			local targetPos = target.HumanoidRootPart.Position
			local distance = (HumanoidRootPart.Position - targetPos).Magnitude

			if distance > orbitDistance then
				-- Move to enemy first
				moveTo(targetPos + Vector3.new(0, 10, 0)) -- slightly above to avoid ground
			else
				-- Start orbiting
				if os.clock() - lastSwitch >= snapTime then
					snapIndex = (snapIndex % #snapOffsets) + 1
					lastSwitch = os.clock()
				end
				local orbitPos = targetPos + snapOffsets[snapIndex]
				-- Smoothly move toward orbit position
				HumanoidRootPart.CFrame = CFrame.new(HumanoidRootPart.Position:Lerp(orbitPos, 0.2))
				target.HumanoidRootPart.Anchored = true
			end
		end
	end
end)

PlayerSection:AddSlider({
	Name = "WalkSpeed",
	Min = 16,
	Max = 325,
	Default = Humanoid.WalkSpeed,
	Color = Color3.fromRGB(255,255,255),
	Increment = 1,
	Callback = function(value)
		SetWalkSpeed = value
	end
})

local infJumpEnabled = false
local holding = false
PlayerSection:AddToggle({
	Name = "Infinite Jump",
	CurrentValue = false,
	Flag = "InfiniteJump",
	Callback = function(value)
		infJumpEnabled = value
	end
})

UserInputService.InputBegan:Connect(function(input, gp)
	if not gp and input.KeyCode == Enum.KeyCode.Space then
		holding = true
		task.spawn(function()
			while holding and infJumpEnabled and Player.Character do
				local humanoid = Player.Character:FindFirstChildOfClass("Humanoid")
				if humanoid then
					local anim = Instance.new("Animation")
					anim.AnimationId = "rbxassetid://9884586404"
					local animator = humanoid:FindFirstChildOfClass("Animator")
					if animator then
						local track = animator:LoadAnimation(anim)
						track:Play()
					end
					humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
				end
				task.wait(0.55)
			end
		end)
	end
end)

local waterWalk = Instance.new("Part", workspace)
waterWalk.Transparency = 1
waterWalk.Name = "WaterWalk"
waterWalk.CanCollide = false
waterWalk.Size = Vector3.new(1000, 1, 1000)
waterWalk.Anchored = true

UserInputService.InputEnded:Connect(function(input, gp)
	if not gp and input.KeyCode == Enum.KeyCode.Space then
		holding = false
	end
end)

local statOptions = {"Melee","Defense","Sword","Gun","Demon Fruit"}
local statIndex = 1
local statBtn
statBtn = PlayerSection:AddButton({
	Name = "Stat: " .. selectedStat,
	Callback = function()
		statIndex = (statIndex % #statOptions) + 1
		selectedStat = statOptions[statIndex]
		statBtn.Instance.Text = "Stat: " .. selectedStat
	end
})

PlayerSection:AddSlider({
	Name = "Stat Amount",
	Min = 1,
	Max = 10,
	Default = 1,
	Increment = 1,
	Callback = function(value)
		addAmount = value
	end
})

PlayerSection:AddToggle({
	Name = "Auto Stats",
	CurrentValue = false,
	Flag = "AutoStats",
	Callback = function(value)
		autoStats = value
	end
})

PlayerSection:AddToggle({
	Name = "Walk on Water",
	CurrentValue = false,
	Flag = "WalkOnWater",
	Callback = function(value)
		waterWalk.CanCollide = value
	end
})

RunService.Heartbeat:Connect(function(dt)
	if autoStats then
		ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", selectedStat, addAmount)
	end
	if Humanoid and Character and Character.PrimaryPart then
		local moveDir = Humanoid.MoveDirection
		if moveDir.Magnitude > 0 then
			local newCFrame = Character.PrimaryPart.CFrame + (moveDir * (SetWalkSpeed * dt))
			Character:SetPrimaryPartCFrame(newCFrame)
			Humanoid.WalkSpeed = 16
		end
	end
end)

RunService.RenderStepped:Connect(function()
	waterWalk.Position = Vector3.new(HumanoidRootPart.Position.X, -4.5, HumanoidRootPart.Position.Z)
end)

MiscSection:AddButton({
	Name = "Toggle Damage UI",
	Callback = function()
		game.ReplicatedStorage:WaitForChild("Assets"):WaitForChild("GUI"):FindFirstChild("DamageCounter").Enabled = not game.ReplicatedStorage:WaitForChild("Assets"):WaitForChild("GUI"):FindFirstChild("DamageCounter").Enabled
	end
})

MiscSection:AddButton({
	Name = "Toggle Notifications",
	Callback = function()
		game:GetService("Players").LocalPlayer.PlayerGui.Notifications.Enabled = not game:GetService("Players").LocalPlayer.PlayerGui.Notifications.Enabled
	end
})

MiscSection:AddButton({
	Name = "Redeem All Codes",
	Callback = function()
		local function redeemAll()
			local raw = game:HttpGet("https://pastebin.com/raw/cLp2LXrs")
			local codes = {}
			for code in string.gmatch(raw, "[^\r\n]+") do
				table.insert(codes, code)
			end
			local remote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Redeem")
			for _, code in ipairs(codes) do
				local ok, err = pcall(function()
					remote:InvokeServer(code)
				end)
				print("Redeeming:", code, ok, err or "")
			end
		end
		redeemAll()
	end
})

MiscSection:AddButton({
	Name = "Rejoin",
	Callback = function()
		queue_on_teleport([[ loadstring(game:HttpGet('https://pastebin.com/raw/TAxQY7uz'))() ]])
		game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, Player)
	end
})

local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Player = game.Players.LocalPlayer

local function getServers(placeId)
	local servers, cursor = {}, nil
	repeat
		local url = ("https://games.roblox.com/v1/games/%s/servers/Public?limit=100%s"):format(
			placeId,
			cursor and "&cursor="..HttpService:UrlEncode(cursor) or ""
		)
		local ok, res = pcall(function()
			return HttpService:GetAsync(url)
		end)
		if not ok then break end
		local data = HttpService:JSONDecode(res)
		for _, s in ipairs(data.data) do
			if s.id ~= game.JobId and s.playing < s.maxPlayers then
				table.insert(servers, s.id)
			end
		end
		cursor = data.nextPageCursor
	until not cursor
	return servers
end

MiscSection:AddButton({
	Name = "Server Hop",
	Callback = function()
		if not queue_on_teleport then return end
		local src = [[ loadstring(game:HttpGet('https://pastebin.com/raw/TAxQY7uz'))() ]]
		queue_on_teleport(src)
		local servers = getServers(game.PlaceId)
		if #servers > 0 then
			TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(#servers)], Player)
		else
			TeleportService:Teleport(game.PlaceId, Player)
		end
	end
})

MiscSection:AddToggle({
	Name = "Anti AFK",
	CurrentValue = false,
	Flag = "AntiAFK",
	Callback = function(value)
		if value then
			Player.Idled:Connect(function()
				game:GetService("VirtualUser"):ClickButton2(Vector2.new(0,0))
			end)
		end
	end
})

MiscSection:AddButton({
	Name = "Fast Mode",
	Callback = function()
		local Lighting = game:GetService("Lighting")
		local Terrain = workspace:FindFirstChildOfClass("Terrain")
		-- Remove textures/decals and simplify parts
		for _, obj in ipairs(workspace:GetDescendants()) do
			if obj:IsA("BasePart") then
				obj.Material = Enum.Material.SmoothPlastic
				obj.Reflectance = 0
				obj.CastShadow = false
			elseif obj:IsA("Decal") or obj:IsA("Texture") then
				obj:Destroy()
			elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
				obj.Enabled = false
			elseif obj:IsA("SurfaceAppearance") then
				obj:Destroy()
			end
		end
		-- Lighting optimizations
		Lighting.GlobalShadows = false
		Lighting.FogEnd = 9e9
		Lighting.Brightness = 1
		Lighting.EnvironmentSpecularScale = 0
		Lighting.EnvironmentDiffuseScale = 0
		-- Terrain optimizations
		if Terrain then
			Terrain.WaterWaveSize = 0
			Terrain.WaterWaveSpeed = 0
			Terrain.WaterTransparency = 1
			Terrain.WaterReflectance = 0
		end
	end
})

if game:GetService("ReplicatedStorage").Effect.Container:FindFirstChild("Death") then
	game:GetService("ReplicatedStorage").Effect.Container:FindFirstChild("Death"):Destroy()
end

local Highlight = Instance.new("Highlight")
Highlight.Parent = Character
Highlight.FillColor = Color3.fromRGB(60, 179, 113)
Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
if not Character:FindFirstChild("HasBuso") then
	ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso")
end
