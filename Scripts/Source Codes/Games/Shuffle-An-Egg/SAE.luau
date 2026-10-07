local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local KeyframeSequenceProvider = game:GetService("KeyframeSequenceProvider")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Environment = type(getgenv) == "function" and getgenv() or _G

if type(Environment.ShuffleAnEggHub) == "table" and type(Environment.ShuffleAnEggHub.Unload) == "function" then
	pcall(Environment.ShuffleAnEggHub.Unload)
end

local Hub = {
	Running = true,
	Connections = {},
	Toggles = {},
}
Environment.ShuffleAnEggHub = Hub

local LibraryUrl = "https://raw.githubusercontent.com/PookiePepelsss/Airflow-UI/refs/heads/main/Source.luau"
local CreditsUrl = "https://raw.githubusercontent.com/Bac0nHck/Something/refs/heads/main/telegram"

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local Configs = ReplicatedStorage:WaitForChild("Configs")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Assets = ReplicatedStorage:WaitForChild("Assets")
local GlobalValues = ReplicatedStorage:FindFirstChild("GlobalValues")
local RunningEvents = GlobalValues and GlobalValues:FindFirstChild("RunningEvents")

local function getRemote(name)
	return Remotes:FindFirstChild(name) or Remotes:WaitForChild(name, 10)
end

local GameHandShake = getRemote("GameHandShake")
local PlaceEggRemote = getRemote("PlaceEgg")
local OpenEggRemote = getRemote("OpenEgg")
local EquipBestRemote = getRemote("EquipBestAnimals")
local SellAnimalRemote = getRemote("SellAnimal")
local RebirthRemote = getRemote("Rebirth")
local UpgradeRemote = getRemote("Upgrade")
local PlaytimeRemote = getRemote("PlaytimeRemote")
local DailyRemote = getRemote("DailyRewards")
local OfflineRemote = getRemote("ClaimOffline")
local FreeRewardRemote = getRemote("FreeRewardPlayTime")
local BuyDealerRemote = getRemote("BuyDealer")
local EquipDealerRemote = getRemote("EquipDealer")
local BuyCupRemote = getRemote("BuyCup")
local EquipCupRemote = getRemote("EquipCup")

local function fire(remote, ...)
	if not remote then
		return
	end
	local args = table.pack(...)
	pcall(function()
		remote:FireServer(table.unpack(args, 1, args.n))
	end)
end

local function loadModule(parent, name)
	local module = parent and (parent:FindFirstChild(name) or parent:WaitForChild(name, 10))
	if not module then
		return nil
	end
	local ok, result = pcall(require, module)
	if ok then
		return result
	end
	return nil
end

local EggsConfig = loadModule(Configs, "EggsConfig")
local AnimalsConfig = loadModule(Configs, "AnimalsConfig")
local EventConfig = loadModule(Configs, "EventConfig")
local UpgradesConfig = loadModule(Configs, "UpgradesConfig")
local RebirthConfig = loadModule(Configs, "RebirthConfig")
local TimeRewardConfig = loadModule(Configs, "TimeRewardConfig")
local DealersConfig = loadModule(Configs, "DealersConfig")
local CupsConfig = loadModule(Assets:FindFirstChild("CupSkins"), "Cups")
local ShuffleAnimations = loadModule(Shared, "CupShuffleAnimations")
local FormatNumber = loadModule(Shared:FindFirstChild("Util"), "FormatNumber")
local GameSettings = loadModule(LocalPlayer:WaitForChild("PlayerScripts"):FindFirstChild("GameClient"), "Settings")

local Suffixes = { "", "K", "M", "B", "T", "Qa", "Qi", "Sx", "Sp", "Oc", "No", "Dc" }

local function formatNumber(value)
	value = tonumber(value) or 0
	if type(FormatNumber) == "function" then
		local ok, text = pcall(FormatNumber, value)
		if ok and text ~= nil then
			return tostring(text)
		end
	end
	local index = 1
	while math.abs(value) >= 1000 and index < #Suffixes do
		value /= 1000
		index += 1
	end
	local text = string.gsub(string.format("%.2f", value), "%.?0+$", "")
	return text .. Suffixes[index]
end

local function parseAmount(text)
	text = string.gsub(tostring(text or ""), "[%s,%$]", "")
	if text == "" then
		return 0
	end
	local number, suffix = string.match(text, "^(%d*%.?%d+)(%a*)$")
	number = tonumber(number)
	if not number then
		return nil
	end
	if suffix == "" then
		return number
	end
	for index, name in ipairs(Suffixes) do
		if name ~= "" and string.lower(name) == string.lower(suffix) then
			return number * 1000 ^ (index - 1)
		end
	end
	return nil
end

local function formatTime(seconds)
	seconds = math.max(0, math.floor(tonumber(seconds) or 0))
	local hours = math.floor(seconds / 3600)
	local minutes = math.floor(seconds % 3600 / 60)
	local rest = seconds % 60
	if hours > 0 then
		return string.format("%d:%02d:%02d", hours, minutes, rest)
	end
	return string.format("%d:%02d", minutes, rest)
end

local function getMoney()
	local stats = LocalPlayer:FindFirstChild("leaderstats")
	local money = stats and stats:FindFirstChild("Money")
	return money and money.Value or 0
end

local function getValue(name, default)
	local object = LocalPlayer:FindFirstChild(name)
	if object and object:IsA("ValueBase") then
		return object.Value
	end
	return default
end

local function getBase()
	local folder = workspace:FindFirstChild("Base")
	if not folder then
		return nil
	end
	for _, base in ipairs(folder:GetChildren()) do
		if base:GetAttribute("Owner") == LocalPlayer.Name then
			return base
		end
	end
	return nil
end

local function getRoot()
	local character = LocalPlayer.Character
	return character and character:FindFirstChild("HumanoidRootPart")
end

local function getHumanoid()
	local character = LocalPlayer.Character
	return character and character:FindFirstChildOfClass("Humanoid")
end

local function toSet(list)
	local set = {}
	if type(list) == "table" then
		for _, value in ipairs(list) do
			set[value] = true
		end
	elseif type(list) == "string" then
		set[list] = true
	end
	return set
end

local function pressButton(button)
	if not button then
		return false
	end
	if type(firesignal) == "function" and pcall(firesignal, button.MouseButton1Click) then
		return true
	end
	if type(getconnections) == "function" then
		local ok, connections = pcall(getconnections, button.MouseButton1Click)
		if ok and type(connections) == "table" and #connections > 0 then
			for _, connection in ipairs(connections) do
				pcall(function()
					connection:Fire()
				end)
			end
			return true
		end
	end
	return false
end

local EggById = {}
local EggList = {}

if EggsConfig and type(EggsConfig.CONFIG) == "table" then
	for id, info in pairs(EggsConfig.CONFIG) do
		if type(info) == "table" then
			local entry = {
				Id = info.id or id,
				Name = info.name or id,
				Rarity = info.rarity or "Unknown",
				Tier = tonumber(info.tier) or 0,
			}
			EggById[id] = entry
			if not info.exclusive and (tonumber(info.rollWeight) or 0) > 0 then
				table.insert(EggList, entry)
			end
		end
	end
end

table.sort(EggList, function(a, b)
	return a.Tier < b.Tier
end)

local function getEggInfo(id)
	if EggById[id] then
		return EggById[id]
	end
	if EggsConfig and type(EggsConfig.Get) == "function" then
		local ok, info = pcall(EggsConfig.Get, id)
		if ok and type(info) == "table" then
			local entry = {
				Id = info.id or id,
				Name = info.name or id,
				Rarity = info.rarity or "Unknown",
				Tier = tonumber(info.tier) or 0,
			}
			EggById[id] = entry
			return entry
		end
	end
	return nil
end

local EggNames = {}
local RarityNames = {}
local SeenRarities = {}

for _, egg in ipairs(EggList) do
	table.insert(EggNames, egg.Name)
	if not SeenRarities[egg.Rarity] then
		SeenRarities[egg.Rarity] = true
		table.insert(RarityNames, egg.Rarity)
	end
end

local AnimalRarityNames = table.clone(RarityNames)

if AnimalsConfig and type(AnimalsConfig.CONFIG) == "table" then
	local extra = {}
	for _, info in pairs(AnimalsConfig.CONFIG) do
		if type(info) == "table" and info.rarity and not SeenRarities[info.rarity] then
			SeenRarities[info.rarity] = true
			table.insert(extra, info.rarity)
		end
	end
	table.sort(extra)
	for _, rarity in ipairs(extra) do
		table.insert(AnimalRarityNames, rarity)
	end
end

local MutationNames = {}

if EggsConfig and type(EggsConfig.MUTATIONS) == "table" then
	for _, mutation in ipairs(EggsConfig.MUTATIONS) do
		if type(mutation) == "table" and mutation.name then
			table.insert(MutationNames, mutation.name)
		end
	end
end

if #MutationNames == 0 then
	MutationNames = { "Normal", "Gold", "Diamond", "Radioactive", "Rainbow" }
end

local WeightTierNames = {}

if EggsConfig and type(EggsConfig.WEIGHT_TIERS) == "table" then
	for _, tier in ipairs(EggsConfig.WEIGHT_TIERS) do
		if type(tier) == "table" and tier.id then
			table.insert(WeightTierNames, tier.id)
		end
	end
end

local State = {
	AutoPlay = false,
	AutoPlace = false,
	AutoHatch = false,
	AutoEquip = false,
	AutoSell = false,
	AutoRebirth = false,
	AutoClaim = false,
	UpgradeBase = false,
	UpgradeZoo = false,
	BuyDealer = false,
	BuyCup = false,
	ShopSelection = nil,
}

local Filter = {
	Eggs = {},
	Rarities = {},
	Mutations = {},
	MinPrice = 0,
}

local SellFilter = {
	Rarities = {},
	Mutations = {},
	Weights = {},
	MaxValue = 0,
}

local Swaps = {
	Shuffle1 = { 2, 3 },
	Shuffle2 = { 2, 3 },
	Shuffle3 = { 1, 2 },
	Shuffle4 = { 1, 2 },
	Shuffle5 = { 1, 3 },
	Shuffle6 = { 1, 3 },
}

local Lengths = {
	Shuffle1 = 0.45,
	Shuffle2 = 0.417,
	Shuffle3 = 0.433,
	Shuffle4 = 0.433,
	Shuffle5 = 1.117,
	Shuffle6 = 1.3,
}

local ShuffleNameById = {}

if type(ShuffleAnimations) == "table" and type(ShuffleAnimations.Shuffles) == "table" then
	for name, animationId in pairs(ShuffleAnimations.Shuffles) do
		ShuffleNameById[tostring(animationId)] = name
	end
end

task.spawn(function()
	if type(ShuffleAnimations) ~= "table" or type(ShuffleAnimations.Shuffles) ~= "table" then
		return
	end
	for name, animationId in pairs(ShuffleAnimations.Shuffles) do
		local ok, sequence = pcall(function()
			return KeyframeSequenceProvider:GetKeyframeSequenceAsync(animationId)
		end)
		if ok and sequence then
			local lastFrame, lastTime = nil, -1
			for _, keyframe in ipairs(sequence:GetKeyframes()) do
				if keyframe.Time > lastTime then
					lastFrame, lastTime = keyframe, keyframe.Time
				end
			end
			if lastFrame then
				local moved = {}
				for _, pose in ipairs(lastFrame:GetDescendants()) do
					if pose:IsA("Pose") then
						local index = tonumber(string.match(pose.Name, "^Cup(%d)$"))
						if index and pose.CFrame.Position.Magnitude > 1 then
							table.insert(moved, index)
						end
					end
				end
				if #moved == 2 then
					table.sort(moved)
					Swaps[name] = moved
					Lengths[name] = lastTime
				end
			end
			pcall(function()
				sequence:Destroy()
			end)
		end
	end
end)

local function cupPositions(sequence)
	local positions = {}
	local position = 2
	for index, name in ipairs(sequence) do
		local swap = Swaps[name]
		if not swap then
			return nil, nil
		end
		positions[index] = position
		if position == swap[1] then
			position = swap[2]
		elseif position == swap[2] then
			position = swap[1]
		end
	end
	return positions, position
end

local function predictCup(sequence)
	local _, final = cupPositions(sequence)
	return final
end

local function shuffleFallback(sequence, speed)
	local rate = math.max(tonumber(speed) or 1, 0.1)
	local total = 0.8
	for _, name in ipairs(sequence) do
		total += (Lengths[name] or 1.3) / rate + 0.35
	end
	return total + 0.5
end

local FakeCupNames = { "Left", "Middle", "Right" }

local Tracker = {
	Active = false,
	Token = 0,
	Positions = {},
	Final = nil,
	Steps = 0,
	Played = 0,
	Finished = 0,
	Done = false,
	Animator = nil,
	Connection = nil,
}

local Esp = {
	Enabled = false,
	Token = 0,
	Folder = nil,
	Highlight = nil,
	Billboard = nil,
}

local function getDealer()
	local base = getBase()
	local container = base and base:FindFirstChild("DealerContainer")
	return container and container:FindFirstChild("Lucky Dealer")
end

local function getRealCup(index)
	if not index then
		return nil
	end
	local dealer = getDealer()
	local cups = dealer and dealer:FindFirstChild("Cups")
	local skin = cups and cups:FindFirstChild("SKIN")
	return skin and skin:FindFirstChild("Cup" .. tostring(index))
end

local function getFakeCup(index)
	local name = index and FakeCupNames[index]
	if not name then
		return nil
	end
	local base = getBase()
	local fake = base and base:FindFirstChild("FakeCups")
	local skin = fake and fake:FindFirstChild("SKIN")
	return skin and skin:FindFirstChild(name)
end

local function buildEsp()
	if Esp.Folder and Esp.Folder.Parent then
		return
	end
	local folder = Instance.new("Folder")
	folder.Name = "CupEsp"
	local highlight = Instance.new("Highlight")
	highlight.FillColor = Color3.fromRGB(70, 255, 120)
	highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
	highlight.FillTransparency = 0.35
	highlight.OutlineTransparency = 0
	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	highlight.Enabled = false
	highlight.Parent = folder
	local billboard = Instance.new("BillboardGui")
	billboard.Size = UDim2.fromOffset(120, 40)
	billboard.StudsOffset = Vector3.new(0, 4.5, 0)
	billboard.AlwaysOnTop = true
	billboard.LightInfluence = 0
	billboard.Enabled = false
	billboard.Parent = folder
	local label = Instance.new("TextLabel")
	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.GothamBlack
	label.Text = "EGG"
	label.TextScaled = true
	label.TextColor3 = Color3.fromRGB(70, 255, 120)
	label.TextStrokeTransparency = 0
	label.Parent = billboard
	if not pcall(function()
		folder.Parent = CoreGui
	end) then
		folder.Parent = LocalPlayer:FindFirstChildOfClass("PlayerGui")
	end
	Esp.Folder = folder
	Esp.Highlight = highlight
	Esp.Billboard = billboard
end

local function espShow(part)
	if not Esp.Enabled then
		return
	end
	buildEsp()
	Esp.Highlight.Adornee = part
	Esp.Billboard.Adornee = part
	Esp.Highlight.Enabled = part ~= nil
	Esp.Billboard.Enabled = part ~= nil
end

local function espHide()
	if Esp.Highlight then
		Esp.Highlight.Enabled = false
		Esp.Highlight.Adornee = nil
	end
	if Esp.Billboard then
		Esp.Billboard.Enabled = false
		Esp.Billboard.Adornee = nil
	end
end

local function shuffleNameOf(track)
	local animation = track.Animation
	local name = animation and ShuffleNameById[animation.AnimationId]
	if not name and Swaps[track.Name] then
		name = track.Name
	end
	return name
end

local function trackerStepStarted(step, track)
	local token = Tracker.Token
	local before = Tracker.Positions[step] or Tracker.Final
	local after = Tracker.Positions[step + 1] or Tracker.Final
	espShow(getRealCup(before))
	local markerConnection
	pcall(function()
		markerConnection = track:GetMarkerReachedSignal("CHANGE"):Connect(function()
			if Tracker.Token == token and Tracker.Active then
				espShow(getFakeCup(after) or getRealCup(after))
			end
		end)
	end)
	track.Ended:Once(function()
		if markerConnection then
			markerConnection:Disconnect()
		end
		if Tracker.Token ~= token or not Tracker.Active then
			return
		end
		Tracker.Finished += 1
		espShow(getRealCup(after))
		if Tracker.Finished >= Tracker.Steps then
			Tracker.Done = true
		end
	end)
end

local function hookAnimator()
	local dealer = getDealer()
	local controller = dealer and dealer:FindFirstChildOfClass("AnimationController")
	local animator = controller and controller:FindFirstChildOfClass("Animator")
	if not animator or animator == Tracker.Animator then
		return
	end
	if Tracker.Connection then
		Tracker.Connection:Disconnect()
	end
	Tracker.Animator = animator
	Tracker.Connection = animator.AnimationPlayed:Connect(function(track)
		if not Tracker.Active or Tracker.Played >= Tracker.Steps or not shuffleNameOf(track) then
			return
		end
		Tracker.Played += 1
		trackerStepStarted(Tracker.Played, track)
	end)
	table.insert(Hub.Connections, Tracker.Connection)
end

local function trackerStart(data)
	hookAnimator()
	local positions, final = cupPositions(data.Sequence)
	Tracker.Token += 1
	local token = Tracker.Token
	Tracker.Positions = positions or {}
	Tracker.Final = final
	Tracker.Steps = #data.Sequence
	Tracker.Played = 0
	Tracker.Finished = 0
	Tracker.Done = false
	Tracker.Active = true
	Esp.Token += 1
	if final then
		espShow(getRealCup(2))
	else
		espHide()
	end
	task.delay(shuffleFallback(data.Sequence, data.Speed), function()
		if Tracker.Token == token and Tracker.Active and not Tracker.Done then
			espShow(getRealCup(Tracker.Final))
		end
	end)
	return token
end

local function trackerReveal()
	Tracker.Active = false
	Esp.Token += 1
	local token = Esp.Token
	task.delay(1.5, function()
		if token == Esp.Token then
			espHide()
		end
	end)
end

local function setEsp(value)
	Esp.Enabled = value
	if value then
		buildEsp()
		hookAnimator()
		if Tracker.Active and Tracker.Final then
			espShow(getRealCup(Tracker.Positions[Tracker.Finished + 1] or Tracker.Final))
		end
	else
		Esp.Token += 1
		espHide()
	end
end

local Play = {
	Phase = "Idle",
	Token = 0,
	LastAction = 0,
	LastReveal = 0,
	Deadline = 0,
	Retries = 0,
	Insufficient = 0,
	PausedUntil = 0,
}

local function setPhase(phase, timeout)
	Play.Phase = phase
	Play.LastAction = os.clock()
	Play.Deadline = os.clock() + (timeout or 15)
end

local function ladderTier(eggId)
	if EggsConfig and type(EggsConfig.LadderTier) == "function" then
		local ok, tier = pcall(EggsConfig.LadderTier, eggId)
		if ok and type(tier) == "number" then
			return tier
		end
	end
	return 0
end

local function isStreakReward(eggId)
	if not getValue("IsStreakItem", false) then
		return false
	end
	local tier = ladderTier(eggId)
	return tier == 0 or getValue("BestEggTier", 0) <= tier
end

local function shouldAccept(data)
	local eggId = tostring(data.Animal or "")
	local price = tonumber(data.Price) or 0
	if price > getMoney() then
		return false
	end
	if isStreakReward(eggId) then
		return true
	end
	local info = getEggInfo(eggId)
	local mutation = tostring(data.Mutation or "")
	if mutation == "" then
		mutation = "Normal"
	end
	if next(Filter.Eggs) and not (info and Filter.Eggs[info.Name]) then
		return false
	end
	if next(Filter.Rarities) and not (info and Filter.Rarities[info.Rarity]) then
		return false
	end
	if next(Filter.Mutations) and not Filter.Mutations[mutation] then
		return false
	end
	if Filter.MinPrice > 0 and price < Filter.MinPrice then
		return false
	end
	return true
end

local function reroll()
	Play.Token += 1
	setPhase("Selecting", 15)
	fire(GameHandShake, "Select", { SpeedMultiplier = 2, StartTime = tick() })
end

local function moveToDealer(base)
	local container = base:FindFirstChild("DealerContainer")
	local spot = container and container:FindFirstChild("PlayPrompt")
	local root = getRoot()
	if not (spot and root) or (root.Position - spot.Position).Magnitude <= 12 then
		return
	end
	local dealer = container:FindFirstChild("Lucky Dealer")
	local target = spot.Position
	local focus = dealer and dealer:GetPivot().Position or target + root.CFrame.LookVector * 5
	root.AssemblyLinearVelocity = Vector3.zero
	root.CFrame = CFrame.lookAt(target, Vector3.new(focus.X, target.Y, focus.Z))
	task.wait(0.3)
end

local function startRound()
	local base = getBase()
	if not base then
		return
	end
	moveToDealer(base)
	Play.Token += 1
	Play.Retries = 0
	setPhase("Selecting", 15)
	fire(GameHandShake, "Play")
	task.wait(0.15)
	fire(GameHandShake, "Select")
end

local function exitRound()
	local gui = LocalPlayer:FindFirstChild("PlayerGui")
	local holder = gui and gui:FindFirstChild("Accept/skip")
	local panel = holder and holder:FindFirstChild("Accept/skip")
	pressButton(panel and panel:FindFirstChild("Exit"))
	fire(GameHandShake, "ExitGame")
end

local function onSelectResult(data)
	Play.Token += 1
	Play.Retries = 0
	local token = Play.Token
	setPhase("Offer", 10)
	task.delay(1.15 + math.random() * 0.35, function()
		if token ~= Play.Token or not State.AutoPlay or not Hub.Running then
			return
		end
		if shouldAccept(data) then
			Play.Token += 1
			setPhase("Accepting", 15)
			fire(GameHandShake, "StartShuffle")
		else
			reroll()
		end
	end)
end

local function onShuffleSequence(data, trackerToken)
	Play.Token += 1
	Play.Retries = 0
	Play.Insufficient = 0
	local token = Play.Token
	local cup = predictCup(data.Sequence) or math.random(1, 3)
	local fallback = shuffleFallback(data.Sequence, data.Speed)
	setPhase("Shuffling", fallback + 10)
	task.spawn(function()
		local deadline = os.clock() + fallback
		while os.clock() < deadline do
			if token ~= Play.Token or not State.AutoPlay or not Hub.Running then
				return
			end
			if trackerToken and Tracker.Token == trackerToken and Tracker.Done then
				break
			end
			task.wait(0.05)
		end
		task.wait(0.35 + math.random() * 0.3)
		if token ~= Play.Token or not State.AutoPlay or not Hub.Running then
			return
		end
		setPhase("Picking", 10)
		fire(GameHandShake, "PickCup", cup)
	end)
end

local function onReveal()
	Play.Token += 1
	Play.LastReveal = os.clock()
	setPhase("Idle")
end

local function onInsufficientFunds()
	Play.Insufficient += 1
	if Play.Insufficient >= 5 then
		Play.Insufficient = 0
		Play.Token += 1
		exitRound()
		setPhase("Idle")
		Play.PausedUntil = os.clock() + 15
		return
	end
	local token = Play.Token
	task.delay(0.6, function()
		if token == Play.Token and State.AutoPlay and Hub.Running then
			reroll()
		end
	end)
end

if GameHandShake then
	table.insert(Hub.Connections, GameHandShake.OnClientEvent:Connect(function(action, data)
		if not Hub.Running then
			return
		end
		local isShuffle = action == "ShuffleSequence" and type(data) == "table" and type(data.Sequence) == "table"
		local trackerToken
		if isShuffle then
			local ok, result = pcall(trackerStart, data)
			trackerToken = ok and result or nil
		elseif action == "RevealResult" then
			trackerReveal()
		end
		if not State.AutoPlay then
			return
		end
		if action == "SelectResult" and type(data) == "table" then
			onSelectResult(data)
		elseif isShuffle then
			onShuffleSequence(data, trackerToken)
		elseif action == "RevealResult" then
			onReveal()
		elseif action == "InsufficientFunds" then
			onInsufficientFunds()
		end
	end))
end

local function setAutoPlay(value)
	State.AutoPlay = value
	Play.Token += 1
	Play.Retries = 0
	Play.Insufficient = 0
	Play.PausedUntil = 0
	if not value and Play.Phase ~= "Idle" then
		exitRound()
	end
	Play.Phase = "Idle"
	Play.LastAction = 0
	Play.LastReveal = 0
end

local function autoPlayTick()
	if not State.AutoPlay or os.clock() < Play.PausedUntil then
		return
	end
	local now = os.clock()
	if Play.Phase == "Idle" then
		local waitTime = now - Play.LastReveal < 15 and 6.5 or 1
		if now - Play.LastAction >= waitTime then
			startRound()
		end
	elseif now >= Play.Deadline then
		Play.Token += 1
		exitRound()
		setPhase("Idle")
	elseif (Play.Phase == "Selecting" or Play.Phase == "Accepting") and now - Play.LastAction >= 4.5 and Play.Retries < 2 then
		Play.Retries += 1
		Play.LastAction = now
		if Play.Phase == "Selecting" then
			fire(GameHandShake, "Select", { SpeedMultiplier = 2, StartTime = tick() })
		else
			fire(GameHandShake, "StartShuffle")
		end
	end
end

local PendingSpots = {}

local function getEggTools()
	local tools = {}
	local function scan(container)
		if not container then
			return
		end
		for _, tool in ipairs(container:GetChildren()) do
			if tool:IsA("Tool") and not tool:FindFirstChild("IsPet") then
				local info = getEggInfo(tool.Name)
				if info then
					table.insert(tools, { Tool = tool, Id = info.Id })
				end
			end
		end
	end
	scan(LocalPlayer:FindFirstChild("Backpack"))
	scan(LocalPlayer.Character)
	return tools
end

local function getPlotFloor(base)
	local plot = base:FindFirstChild("Plot")
	if not plot then
		return nil
	end
	local best, bestArea = nil, 0
	for _, child in ipairs(plot:GetChildren()) do
		if child.Name == "Floor" and child:IsA("BasePart") then
			local area = child.Size.X * child.Size.Z
			if area > bestArea then
				best, bestArea = child, area
			end
		end
	end
	return best
end

local function findEggSpot(base)
	local floor = getPlotFloor(base)
	if not floor or floor.Size.X < 14 or floor.Size.Z < 14 then
		return nil
	end
	local spacing = ((EggsConfig and tonumber(EggsConfig.MIN_PLACE_SPACING)) or 5) + 1
	local taken = {}
	local eggs = base:FindFirstChild("Eggs")
	if eggs then
		for _, marker in ipairs(eggs:GetChildren()) do
			if marker:IsA("BasePart") then
				table.insert(taken, marker.Position)
			elseif marker:IsA("Model") then
				table.insert(taken, marker:GetPivot().Position)
			end
		end
	end
	local now = os.clock()
	for index = #PendingSpots, 1, -1 do
		local pending = PendingSpots[index]
		if now - pending.Time > 8 then
			table.remove(PendingSpots, index)
		else
			table.insert(taken, pending.Position)
		end
	end
	local root = getRoot()
	local halfX = floor.Size.X / 2 - 6
	local halfZ = floor.Size.Z / 2 - 6
	local best, bestDistance = nil, math.huge
	for x = -halfX, halfX, spacing do
		for z = -halfZ, halfZ, spacing do
			local point = floor.CFrame:PointToWorldSpace(Vector3.new(x, floor.Size.Y / 2, z))
			local free = true
			for _, position in ipairs(taken) do
				local dx, dz = position.X - point.X, position.Z - point.Z
				if dx * dx + dz * dz < spacing * spacing then
					free = false
					break
				end
			end
			if free then
				local distance = root and (root.Position - point).Magnitude or 0
				if distance < bestDistance then
					best, bestDistance = point, distance
				end
			end
		end
	end
	return best
end

local function placeEggs()
	local base = getBase()
	local humanoid = getHumanoid()
	if not (base and humanoid) then
		return
	end
	local free = (base:GetAttribute("EggCapacity") or 10) - (base:GetAttribute("Eggs") or 0)
	if free <= 0 then
		return
	end
	local placed = 0
	local equipped = false
	for _, entry in ipairs(getEggTools()) do
		if not State.AutoPlace or not Hub.Running or placed >= free then
			break
		end
		local spot = findEggSpot(base)
		if not spot then
			break
		end
		local uidObject = entry.Tool:FindFirstChild("UID")
		local uid = uidObject and uidObject.Value or entry.Tool:GetAttribute("UID")
		if entry.Tool.Parent ~= LocalPlayer.Character then
			pcall(function()
				humanoid:EquipTool(entry.Tool)
			end)
			task.wait(0.25)
		end
		equipped = true
		fire(PlaceEggRemote, entry.Id, spot, uid)
		table.insert(PendingSpots, { Position = spot, Time = os.clock() })
		placed += 1
		task.wait(0.6)
	end
	if equipped then
		pcall(function()
			humanoid:UnequipTools()
		end)
	end
end

local OpenedAt = {}

local function hatchEggs()
	local base = getBase()
	local eggs = base and base:FindFirstChild("Eggs")
	if not eggs then
		return
	end
	local serverTime = workspace:GetServerTimeNow()
	for _, marker in ipairs(eggs:GetChildren()) do
		if not State.AutoHatch or not Hub.Running then
			break
		end
		local hatchAt = marker:GetAttribute("HatchAt")
		local last = OpenedAt[marker.Name]
		if type(hatchAt) == "number" and hatchAt <= serverTime and (not last or os.clock() - last > 5) then
			OpenedAt[marker.Name] = os.clock()
			fire(OpenEggRemote, marker.Name)
			task.wait(0.4)
		end
	end
end

local EquipTracker = { Count = -1, Last = 0, Selling = false }

local function equipBest()
	if EquipTracker.Selling then
		return
	end
	local inventory = LocalPlayer:FindFirstChild("AnimalInventory")
	local count = inventory and #inventory:GetChildren() or 0
	if count == 0 then
		EquipTracker.Count = 0
		return
	end
	local now = os.clock()
	if now - EquipTracker.Last < 3 then
		return
	end
	local base = getBase()
	local hasRoom = base ~= nil and (base:GetAttribute("Used") or 0) < (base:GetAttribute("Capacity") or 0)
	if count ~= EquipTracker.Count or (hasRoom and now - EquipTracker.Last > 10) then
		EquipTracker.Count = count
		EquipTracker.Last = now
		fire(EquipBestRemote)
	end
end

local function getAnimalInfo(id)
	if AnimalsConfig and type(AnimalsConfig.Get) == "function" then
		local ok, info = pcall(AnimalsConfig.Get, id)
		if ok and type(info) == "table" then
			return info
		end
	end
	return nil
end

local function getSellValue(id, weight, mutation)
	if EggsConfig and type(EggsConfig.SellValue) == "function" then
		local ok, value = pcall(EggsConfig.SellValue, id, weight, mutation)
		if ok and type(value) == "number" then
			return value
		end
	end
	return 0
end

local function shouldSell(entry)
	local id = entry:GetAttribute("Animal")
	local info = id and getAnimalInfo(id)
	if not info then
		return false
	end
	local mutation = entry:GetAttribute("Mutation")
	local mutationName = type(mutation) == "string" and mutation ~= "" and mutation or "Normal"
	if next(SellFilter.Rarities) and not SellFilter.Rarities[info.rarity] then
		return false
	end
	if next(SellFilter.Mutations) and not SellFilter.Mutations[mutationName] then
		return false
	end
	if next(SellFilter.Weights) and not SellFilter.Weights[entry:GetAttribute("Tier")] then
		return false
	end
	if SellFilter.MaxValue > 0 and getSellValue(id, entry:GetAttribute("Weight") or 1, mutation) > SellFilter.MaxValue then
		return false
	end
	return true
end

local function hasAnimalsToSell(inventory)
	for _, entry in ipairs(inventory:GetChildren()) do
		if shouldSell(entry) then
			return true
		end
	end
	return false
end

local function autoSell()
	local inventory = LocalPlayer:FindFirstChild("AnimalInventory")
	if not inventory or not hasAnimalsToSell(inventory) then
		return
	end
	EquipTracker.Selling = true
	pcall(function()
		if State.AutoEquip then
			fire(EquipBestRemote)
			task.wait(1.5)
		end
		for _, entry in ipairs(inventory:GetChildren()) do
			if not State.AutoSell or not Hub.Running then
				break
			end
			if entry.Parent == inventory and shouldSell(entry) then
				fire(SellAnimalRemote, "SellAnimal", entry.Name)
				task.wait(0.3)
			end
		end
	end)
	EquipTracker.Count = #inventory:GetChildren()
	EquipTracker.Last = os.clock()
	EquipTracker.Selling = false
end

local function tryRebirth()
	if type(RebirthConfig) ~= "table" then
		return
	end
	local nextRebirth = RebirthConfig[getValue("Rebirth", 0) + 1]
	if type(nextRebirth) == "table" and tonumber(nextRebirth.Cost) and getMoney() >= nextRebirth.Cost then
		fire(RebirthRemote, "Rebirth")
		task.wait(2)
	end
end

local function tryUpgrade(name)
	if type(UpgradesConfig) ~= "table" or type(UpgradesConfig[name]) ~= "table" then
		return
	end
	local folder = LocalPlayer:FindFirstChild("Upgrades")
	local level = folder and folder:FindFirstChild(name)
	local price = UpgradesConfig[name][(level and level.Value or 0) + 1]
	if tonumber(price) and getMoney() >= price then
		fire(UpgradeRemote, name)
		task.wait(1)
	end
end

local RewardIndexByName = {}

if type(TimeRewardConfig) == "table" then
	for index, reward in ipairs(TimeRewardConfig) do
		if type(reward) == "table" and reward.name then
			RewardIndexByName[reward.name] = index
		end
	end
end

local PlaytimeClaimed = {}
local Daily = { Data = nil, LastRequest = 0, LastClaim = 0 }
local ClaimTimers = { Offline = 0, Free = 0 }

if DailyRemote then
	table.insert(Hub.Connections, DailyRemote.OnClientEvent:Connect(function(action, data)
		if action == "Sync" and type(data) == "table" then
			Daily.Data = data
		end
	end))
end

local function claimPlaytime()
	local gui = LocalPlayer:FindFirstChild("PlayerGui")
	local windows = gui and gui:FindFirstChild("Windows")
	local window = windows and windows:FindFirstChild("PlaytimeReward")
	local rewards = window and window:FindFirstChild("Rewards")
	if not rewards then
		return
	end
	for _, frame in ipairs(rewards:GetChildren()) do
		if frame:IsA("GuiButton") then
			local claim = frame:FindFirstChild("Claim")
			local claimed = frame:FindFirstChild("Claimed")
			if claim and claim.Visible and not (claimed and claimed.Visible) then
				if not pressButton(frame) then
					local title = frame:FindFirstChild("Title")
					local index = title and RewardIndexByName[title.Text]
					if index and not PlaytimeClaimed[index] then
						PlaytimeClaimed[index] = true
						fire(PlaytimeRemote, "Claim", index)
					end
				end
				task.wait(0.4)
			end
		end
	end
end

local function claimDaily()
	local now = os.clock()
	if not Daily.Data then
		if now - Daily.LastRequest > 15 then
			Daily.LastRequest = now
			fire(DailyRemote, "Request")
		end
		return
	end
	local today = math.floor(os.time() / 86400)
	if (tonumber(Daily.Data.LastClaimDay) or 0) < today and now - Daily.LastClaim > 120 then
		Daily.LastClaim = now
		fire(DailyRemote, "Claim")
	end
end

local function claimOffline()
	if getValue("OfflineEarnings", 0) > 0 and os.clock() - ClaimTimers.Offline > 30 then
		ClaimTimers.Offline = os.clock()
		fire(OfflineRemote)
	end
end

local function claimFreeReward()
	if getValue("FreeRewardPlayTime", true) then
		return
	end
	if getValue("GamesWon", 0) >= 10 and getValue("TimePlaying", 0) >= 25 and os.clock() - ClaimTimers.Free > 60 then
		ClaimTimers.Free = os.clock()
		fire(FreeRewardRemote)
	end
end

local function claimRewards()
	claimPlaytime()
	claimDaily()
	claimOffline()
	claimFreeReward()
end

local ShopItems = {}

local function addShopItems(kind, config)
	if type(config) ~= "table" or type(config.Skins) ~= "table" then
		return
	end
	local order, seen = {}, {}
	if type(config.Order) == "table" then
		for _, name in ipairs(config.Order) do
			if config.Skins[name] and not seen[name] then
				seen[name] = true
				table.insert(order, name)
			end
		end
	end
	local rest = {}
	for name in pairs(config.Skins) do
		if not seen[name] then
			table.insert(rest, name)
		end
	end
	table.sort(rest, function(a, b)
		return (tonumber(config.Skins[a].Price) or 0) < (tonumber(config.Skins[b].Price) or 0)
	end)
	for _, name in ipairs(rest) do
		table.insert(order, name)
	end
	for _, name in ipairs(order) do
		local skin = config.Skins[name]
		local price = tonumber(skin.Price) or 0
		local passRequired = skin.PassRequired ~= nil and skin.PassRequired ~= false
		if not passRequired and price > 0 then
			table.insert(ShopItems, { Kind = kind, Name = name, Price = price })
		end
	end
end

addShopItems("Dealer", DealersConfig)
addShopItems("Cup", CupsConfig)

local function isOwned(kind, name)
	local folder = LocalPlayer:FindFirstChild(kind == "Dealer" and "OwnedDealers" or "Cups")
	local value = folder and folder:FindFirstChild(name)
	return value ~= nil and value:IsA("ValueBase") and value.Value == true
end

local function equippedName(kind)
	return getValue(kind == "Dealer" and "EquippedDealer" or "EquippedCup", "")
end

local function skinLuck(kind, name)
	local config = kind == "Dealer" and DealersConfig or CupsConfig
	local skin = type(config) == "table" and type(config.Skins) == "table" and config.Skins[name]
	return skin and (tonumber(skin.Luck) or 1) or 0
end

local function buyItem(item)
	if isOwned(item.Kind, item.Name) then
		return true
	end
	if getMoney() < item.Price then
		return false
	end
	local buyRemote, equipRemote = BuyCupRemote, EquipCupRemote
	if item.Kind == "Dealer" then
		buyRemote, equipRemote = BuyDealerRemote, EquipDealerRemote
	end
	fire(buyRemote, item.Name)
	local deadline = os.clock() + 4
	while os.clock() < deadline and not isOwned(item.Kind, item.Name) do
		task.wait(0.2)
	end
	if not isOwned(item.Kind, item.Name) then
		return false
	end
	if skinLuck(item.Kind, item.Name) > skinLuck(item.Kind, equippedName(item.Kind)) then
		fire(equipRemote, item.Name)
	end
	return true
end

local function autoBuy(kind)
	for _, item in ipairs(ShopItems) do
		if item.Kind == kind and not isOwned(kind, item.Name) then
			if getMoney() >= item.Price then
				buyItem(item)
			end
			return
		end
	end
end

local ShopLookup = {}

local function shopOptions()
	table.clear(ShopLookup)
	local options = {}
	for _, item in ipairs(ShopItems) do
		if not isOwned(item.Kind, item.Name) then
			local label = string.format("%s %s | %s$", item.Name, item.Kind, formatNumber(item.Price))
			ShopLookup[label] = item
			table.insert(options, label)
		end
	end
	return options
end

local EventOddsText = "Unknown"

if EventConfig and type(EventConfig.Events) == "table" then
	local list, total = {}, 0
	for name, info in pairs(EventConfig.Events) do
		local weight = type(info) == "table" and not info.Custom and tonumber(info.Weight) or 0
		if weight > 0 then
			table.insert(list, { Name = name, Weight = weight })
			total += weight
		end
	end
	table.sort(list, function(a, b)
		return a.Weight > b.Weight
	end)
	local lines = {}
	for _, entry in ipairs(list) do
		table.insert(lines, string.format("%s - %.1f%%", entry.Name, entry.Weight / total * 100))
	end
	if #lines > 0 then
		EventOddsText = table.concat(lines, "\n")
	end
end

local function mostLikelyEvent()
	local bestName, bestWeight, total = nil, 0, 0
	if EventConfig and type(EventConfig.Events) == "table" then
		for name, info in pairs(EventConfig.Events) do
			local weight = type(info) == "table" and not info.Custom and tonumber(info.Weight) or 0
			total += weight
			if weight > bestWeight then
				bestName, bestWeight = name, weight
			end
		end
	end
	if not bestName or total <= 0 then
		return nil
	end
	return string.format("%s %.0f%%", bestName, bestWeight / total * 100)
end

local function nextEventText()
	local epoch = EventConfig and tonumber(EventConfig.EPOCH)
	local interval = EventConfig and tonumber(EventConfig.EVENT_INTERVAL)
	if not epoch or not interval then
		return "Next Event: unknown"
	end
	local now = os.time()
	local nextTime = epoch
	if now >= epoch then
		nextTime = epoch + (math.floor((now - epoch) / interval) + 1) * interval
	end
	local likely = mostLikelyEvent()
	return "Next Event: " .. formatTime(nextTime - now) .. (likely and " | likely " .. likely or "")
end

local function activeEventsText()
	if not RunningEvents then
		return "Active: unknown"
	end
	local now = os.time()
	local active = {}
	for _, event in ipairs(RunningEvents:GetChildren()) do
		if event:IsA("BoolValue") and event.Value and event.Name ~= "Night" then
			local text = event.Name
			local multiplier = tonumber(event:GetAttribute("Multiplier"))
			if multiplier and multiplier > 1 then
				text = text .. " x" .. multiplier
			end
			local ends = tonumber(event:GetAttribute("EndTimestamp")) or 0
			if ends > now then
				text = text .. " " .. formatTime(ends - now)
			end
			table.insert(active, text)
		end
	end
	return "Active: " .. (#active > 0 and table.concat(active, ", ") or "None")
end

local function nightText()
	local night = RunningEvents and RunningEvents:FindFirstChild("Night")
	local phase = night and night:GetAttribute("Phase")
	local state, _, finish = string.match(tostring(phase or ""), "^(%d+)|(%d+)|(%d+)$")
	finish = tonumber(finish)
	if not state or not finish then
		return "Next Night: unknown"
	end
	local left = finish - os.time()
	if state == "0" then
		return "Next Night: " .. formatTime(left)
	end
	return "Night Ends: " .. formatTime(left)
end

local PlayerDefaults = {
	WalkSpeed = 16,
	JumpPower = 50,
	Fov = 70,
}

if type(GameSettings) == "table" and type(GameSettings.Camera) == "table" and tonumber(GameSettings.Camera.NormalFOV) then
	PlayerDefaults.Fov = tonumber(GameSettings.Camera.NormalFOV)
end

do
	local humanoid = getHumanoid()
	if humanoid then
		local speed = tonumber(humanoid:GetAttribute("CameraHandler_WS")) or humanoid.WalkSpeed
		if speed > 0 then
			PlayerDefaults.WalkSpeed = math.floor(speed + 0.5)
		end
	end
end

local PlayerMods = {
	WalkSpeed = nil,
	JumpPower = nil,
	Fov = nil,
	FlySpeed = 50,
	Noclip = false,
	InfiniteJump = false,
	Fly = false,
	AntiAfk = false,
	Original = nil,
	NoclipParts = {},
	FlyVelocity = nil,
	FlyGyro = nil,
	Controls = nil,
}

local PlayerSliders = {}

local function isMovementLocked(humanoid)
	return humanoid:GetAttribute("CameraHandler_WS") ~= nil
end

local function rememberHumanoid(humanoid)
	local original = PlayerMods.Original
	if original and original.Humanoid == humanoid then
		return original
	end
	original = {
		Humanoid = humanoid,
		UseJumpPower = humanoid.UseJumpPower,
		JumpPower = tonumber(humanoid:GetAttribute("CameraHandler_JP")) or humanoid.JumpPower,
		JumpHeight = humanoid.JumpHeight,
	}
	PlayerMods.Original = original
	return original
end

local function restoreWalkSpeed()
	local humanoid = getHumanoid()
	if not humanoid then
		return
	end
	if isMovementLocked(humanoid) then
		humanoid:SetAttribute("CameraHandler_WS", PlayerDefaults.WalkSpeed)
	else
		humanoid.WalkSpeed = PlayerDefaults.WalkSpeed
	end
end

local function restoreJump()
	local humanoid = getHumanoid()
	local original = PlayerMods.Original
	if not humanoid or not original or original.Humanoid ~= humanoid then
		return
	end
	if humanoid:GetAttribute("CameraHandler_JP") ~= nil then
		humanoid:SetAttribute("CameraHandler_JP", original.JumpPower)
	else
		humanoid.JumpPower = original.JumpPower
	end
	humanoid.UseJumpPower = original.UseJumpPower
	humanoid.JumpHeight = original.JumpHeight
end

local function restoreFov()
	local camera = workspace.CurrentCamera
	if camera and (camera.CameraType == Enum.CameraType.Custom or camera.CameraType == Enum.CameraType.Track) then
		camera.FieldOfView = PlayerDefaults.Fov
	end
end

local function setWalkSpeed(value)
	if value == PlayerDefaults.WalkSpeed then
		if PlayerMods.WalkSpeed then
			PlayerMods.WalkSpeed = nil
			restoreWalkSpeed()
		end
	else
		PlayerMods.WalkSpeed = value
	end
end

local function setJumpPower(value)
	if value == PlayerDefaults.JumpPower then
		if PlayerMods.JumpPower then
			PlayerMods.JumpPower = nil
			restoreJump()
		end
	else
		PlayerMods.JumpPower = value
	end
end

local function setFov(value)
	if value == PlayerDefaults.Fov then
		if PlayerMods.Fov then
			PlayerMods.Fov = nil
			restoreFov()
		end
	else
		PlayerMods.Fov = value
	end
end

local function applyPlayerMods()
	local humanoid = getHumanoid()
	if humanoid and not isMovementLocked(humanoid) then
		if PlayerMods.WalkSpeed and humanoid.WalkSpeed ~= PlayerMods.WalkSpeed then
			humanoid.WalkSpeed = PlayerMods.WalkSpeed
		end
		if PlayerMods.JumpPower then
			rememberHumanoid(humanoid)
			if not humanoid.UseJumpPower then
				humanoid.UseJumpPower = true
			end
			if humanoid.JumpPower ~= PlayerMods.JumpPower then
				humanoid.JumpPower = PlayerMods.JumpPower
			end
		end
	end
	local camera = workspace.CurrentCamera
	if PlayerMods.Fov and camera and (camera.CameraType == Enum.CameraType.Custom or camera.CameraType == Enum.CameraType.Track) and camera.FieldOfView ~= PlayerMods.Fov then
		camera.FieldOfView = PlayerMods.Fov
	end
end

local function restoreNoclip()
	for part in pairs(PlayerMods.NoclipParts) do
		if part.Parent then
			part.CanCollide = true
		end
	end
	table.clear(PlayerMods.NoclipParts)
end

local function noclipStep()
	local character = LocalPlayer.Character
	if not character then
		return
	end
	for _, part in ipairs(character:GetChildren()) do
		if part:IsA("BasePart") and part.CanCollide then
			PlayerMods.NoclipParts[part] = true
			part.CanCollide = false
		end
	end
end

local function setNoclip(value)
	PlayerMods.Noclip = value
	if not value then
		restoreNoclip()
	end
end

local IsMobile = false

if not pcall(function()
	IsMobile = table.find({ Enum.Platform.Android, Enum.Platform.IOS }, UserInputService:GetPlatform()) ~= nil
end) then
	IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

local FlyControl = { F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0 }

local FlyKeys = {
	[Enum.KeyCode.W] = { "F", 1 },
	[Enum.KeyCode.S] = { "B", -1 },
	[Enum.KeyCode.A] = { "L", -1 },
	[Enum.KeyCode.D] = { "R", 1 },
	[Enum.KeyCode.E] = { "Q", 2 },
	[Enum.KeyCode.Q] = { "E", -2 },
}

local function getControlModule()
	if PlayerMods.Controls == nil then
		local ok, module = pcall(function()
			return require(LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
		end)
		PlayerMods.Controls = ok and module or false
	end
	return PlayerMods.Controls or nil
end

local function stopFly()
	if PlayerMods.FlyVelocity then
		PlayerMods.FlyVelocity:Destroy()
		PlayerMods.FlyVelocity = nil
	end
	if PlayerMods.FlyGyro then
		PlayerMods.FlyGyro:Destroy()
		PlayerMods.FlyGyro = nil
	end
	for key in pairs(FlyControl) do
		FlyControl[key] = 0
	end
	local humanoid = getHumanoid()
	if humanoid then
		humanoid.PlatformStand = false
	end
	local camera = workspace.CurrentCamera
	if camera and camera.CameraType == Enum.CameraType.Track then
		pcall(function()
			camera.CameraType = Enum.CameraType.Custom
		end)
	end
end

local function flyStep()
	local root, humanoid, camera = getRoot(), getHumanoid(), workspace.CurrentCamera
	if not (root and humanoid and camera) then
		return
	end
	local velocity, gyro = PlayerMods.FlyVelocity, PlayerMods.FlyGyro
	if not (velocity and velocity.Parent == root and gyro and gyro.Parent == root) then
		if velocity then
			velocity:Destroy()
		end
		if gyro then
			gyro:Destroy()
		end
		velocity = Instance.new("BodyVelocity")
		velocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
		velocity.Velocity = Vector3.zero
		velocity.Parent = root
		gyro = Instance.new("BodyGyro")
		gyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
		if IsMobile then
			gyro.P = 1000
			gyro.D = 50
		else
			gyro.P = 9e4
		end
		gyro.CFrame = root.CFrame
		gyro.Parent = root
		PlayerMods.FlyVelocity = velocity
		PlayerMods.FlyGyro = gyro
	end
	humanoid.PlatformStand = true
	gyro.CFrame = camera.CFrame
	local speed = PlayerMods.FlySpeed
	local forward = FlyControl.F + FlyControl.B
	local side = FlyControl.L + FlyControl.R
	local vertical = FlyControl.Q + FlyControl.E
	if forward ~= 0 or side ~= 0 or vertical ~= 0 then
		velocity.Velocity = (camera.CFrame.LookVector * forward + camera.CFrame.RightVector * side + camera.CFrame.UpVector * ((forward + vertical) * 0.2)) * speed
		return
	end
	local controlModule = getControlModule()
	local ok, direction = pcall(function()
		return controlModule:GetMoveVector()
	end)
	if ok and typeof(direction) == "Vector3" and direction.Magnitude > 0 then
		velocity.Velocity = (camera.CFrame.RightVector * direction.X - camera.CFrame.LookVector * direction.Z) * speed
	else
		velocity.Velocity = Vector3.zero
	end
end

local function setFly(value)
	PlayerMods.Fly = value
	if not value then
		stopFly()
		pcall(function()
			local humanoid = getHumanoid()
			if humanoid then
				humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
			end
		end)
	end
end

table.insert(Hub.Connections, UserInputService.InputBegan:Connect(function(input, processed)
	if processed or not PlayerMods.Fly then
		return
	end
	local key = FlyKeys[input.KeyCode]
	if not key then
		return
	end
	FlyControl[key[1]] = key[2]
	local camera = workspace.CurrentCamera
	if camera and camera.CameraType == Enum.CameraType.Custom then
		pcall(function()
			camera.CameraType = Enum.CameraType.Track
		end)
	end
end))

table.insert(Hub.Connections, UserInputService.InputEnded:Connect(function(input)
	local key = FlyKeys[input.KeyCode]
	if key then
		FlyControl[key[1]] = 0
	end
end))

local function resetPlayerSettings()
	for name, slider in pairs(PlayerSliders) do
		pcall(function()
			slider:Set(PlayerDefaults[name])
		end)
	end
	setWalkSpeed(PlayerDefaults.WalkSpeed)
	setJumpPower(PlayerDefaults.JumpPower)
	setFov(PlayerDefaults.Fov)
end

table.insert(Hub.Connections, RunService.Stepped:Connect(function()
	if PlayerMods.Noclip then
		pcall(noclipStep)
	end
end))

table.insert(Hub.Connections, RunService.RenderStepped:Connect(function()
	pcall(applyPlayerMods)
	if PlayerMods.Fly then
		pcall(flyStep)
	end
end))

table.insert(Hub.Connections, UserInputService.JumpRequest:Connect(function()
	if not PlayerMods.InfiniteJump then
		return
	end
	local humanoid = getHumanoid()
	if humanoid then
		humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end))

table.insert(Hub.Connections, LocalPlayer.Idled:Connect(function()
	if not PlayerMods.AntiAfk then
		return
	end
	pcall(function()
		local virtualUser = game:GetService("VirtualUser")
		virtualUser:CaptureController()
		virtualUser:ClickButton2(Vector2.new())
	end)
end))

local function stopAll()
	for _, toggle in ipairs(Hub.Toggles) do
		pcall(function()
			toggle:Set(false)
		end)
	end
	resetPlayerSettings()
end

function Hub.Unload()
	if not Hub.Running then
		return
	end
	stopAll()
	Hub.Running = false
	for _, connection in ipairs(Hub.Connections) do
		pcall(function()
			connection:Disconnect()
		end)
	end
	table.clear(Hub.Connections)
	if Esp.Folder then
		pcall(function()
			Esp.Folder:Destroy()
		end)
	end
	if Hub.Window then
		pcall(function()
			Hub.Window:Destroy()
		end)
	end
	if Environment.ShuffleAnEggHub == Hub then
		Environment.ShuffleAnEggHub = nil
	end
end

local Airflow = loadstring(game:HttpGet(LibraryUrl))()

local WindowTitle = "ShuffleAnEgg"

local Window = Airflow:CreateWindow({
	Name = WindowTitle,
	Icon = "egg",
	ToggleUIKeybind = "RightControl",
	OpenButton = { Title = WindowTitle, Icon = "egg" },
	KeepOnScreen = true,
	Loading = {
		Enabled = true,
		Title = WindowTitle,
		Text = "Starting",
		Duration = 1.2,
	},
})
Hub.Window = Window

local function getHeaderTitle()
	for _, label in ipairs(Window.Gui:GetDescendants()) do
		if label:IsA("TextLabel") and label.Text == WindowTitle and label.Parent and label.Parent.Name == "Header" then
			return label
		end
	end
	return nil
end

pcall(function()
	local title = getHeaderTitle()
	if title then
		title.Text = "SAE"
		title.Position = UDim2.fromOffset(60, 31)
	end
end)

local function notify(title, content, kind)
	pcall(function()
		Window:Notify({
			Title = title,
			Content = content,
			Type = kind or "Info",
			Duration = 3,
		})
	end)
end

local MainTab = Window:CreateTab({ Name = "Main", Icon = "house" })
local SellTab = Window:CreateTab({ Name = "Sell", Icon = "coins" })
local ShopTab = Window:CreateTab({ Name = "Shop", Icon = "shopping-cart" })
local EventsTab = Window:CreateTab({ Name = "Events", Icon = "cloud-sun" })
local PlayerTab = Window:CreateTab({ Name = "Player", Icon = "user" })
local SettingsTab = Window:CreateTab({ Name = "Settings", Icon = "settings" })

local function addToggle(tab, name, onChange, default, keepOnStop)
	local toggle = tab:CreateToggle({
		Name = name,
		CurrentValue = default == true,
		Callback = onChange,
	})
	if not keepOnStop then
		table.insert(Hub.Toggles, toggle)
	end
	return toggle
end

local FarmToggles = {}

addToggle(MainTab, "Auto Farm", function(value)
	for _, toggle in ipairs(FarmToggles) do
		toggle:Set(value)
	end
end)

MainTab:CreateLabel("---------")

table.insert(FarmToggles, addToggle(MainTab, "Auto Play", setAutoPlay))

table.insert(FarmToggles, addToggle(MainTab, "Auto Place Eggs", function(value)
	State.AutoPlace = value
end))

table.insert(FarmToggles, addToggle(MainTab, "Auto Hatch Eggs", function(value)
	State.AutoHatch = value
end))

table.insert(FarmToggles, addToggle(MainTab, "Auto Equip Best Pets", function(value)
	State.AutoEquip = value
end))

MainTab:CreateSection("Auto Play Filter")

MainTab:CreateDropdown({
	Name = "Egg",
	Options = EggNames,
	CurrentOption = {},
	MultipleOptions = true,
	Callback = function(selection)
		Filter.Eggs = toSet(selection)
	end,
})

MainTab:CreateDropdown({
	Name = "Rarity",
	Options = RarityNames,
	CurrentOption = {},
	MultipleOptions = true,
	Callback = function(selection)
		Filter.Rarities = toSet(selection)
	end,
})

MainTab:CreateDropdown({
	Name = "Mutation",
	Options = MutationNames,
	CurrentOption = {},
	MultipleOptions = true,
	Callback = function(selection)
		Filter.Mutations = toSet(selection)
	end,
})

MainTab:CreateInput({
	Name = "Min Price",
	PlaceholderText = "0, 25K, 5.5M",
	CurrentValue = "",
	Callback = function(text)
		local amount = parseAmount(text)
		if amount then
			Filter.MinPrice = amount
		else
			notify("Min Price", "Use a number like 25K or 5.5M", "Warning")
		end
	end,
})

MainTab:CreateSection("Other")

addToggle(MainTab, "Cup ESP", setEsp)

addToggle(MainTab, "Auto Rebirth", function(value)
	State.AutoRebirth = value
end)

addToggle(MainTab, "Auto Claim Rewards", function(value)
	State.AutoClaim = value
end)

addToggle(MainTab, "Auto Upgrade Base", function(value)
	State.UpgradeBase = value
end)

addToggle(MainTab, "Auto Upgrade Zoo", function(value)
	State.UpgradeZoo = value
end)

addToggle(SellTab, "Auto Sell", function(value)
	State.AutoSell = value
end)

SellTab:CreateSection("Sell Filter")

SellTab:CreateDropdown({
	Name = "Rarity",
	Options = AnimalRarityNames,
	CurrentOption = {},
	MultipleOptions = true,
	Callback = function(selection)
		SellFilter.Rarities = toSet(selection)
	end,
})

SellTab:CreateDropdown({
	Name = "Mutation",
	Options = MutationNames,
	CurrentOption = {},
	MultipleOptions = true,
	Callback = function(selection)
		SellFilter.Mutations = toSet(selection)
	end,
})

SellTab:CreateDropdown({
	Name = "Weight",
	Options = WeightTierNames,
	CurrentOption = {},
	MultipleOptions = true,
	Callback = function(selection)
		SellFilter.Weights = toSet(selection)
	end,
})

SellTab:CreateInput({
	Name = "Max Value",
	PlaceholderText = "0, 25K, 5.5M",
	CurrentValue = "",
	Callback = function(text)
		local amount = parseAmount(text)
		if amount then
			SellFilter.MaxValue = amount
		else
			notify("Max Value", "Use a number like 25K or 5.5M", "Warning")
		end
	end,
})

addToggle(ShopTab, "Auto Buy Dealer", function(value)
	State.BuyDealer = value
end)

addToggle(ShopTab, "Auto Buy Cup", function(value)
	State.BuyCup = value
end)

ShopTab:CreateSection("Buy Item")

local ShopDropdown = ShopTab:CreateDropdown({
	Name = "Item",
	Options = shopOptions(),
	MultipleOptions = false,
	Callback = function(selection)
		State.ShopSelection = selection
	end,
})

local refreshQueued = false

local function refreshShop()
	if refreshQueued then
		return
	end
	refreshQueued = true
	task.delay(0.5, function()
		refreshQueued = false
		if Hub.Running then
			local options = shopOptions()
			local keep = State.ShopSelection ~= nil and ShopLookup[State.ShopSelection] ~= nil
			if not keep then
				State.ShopSelection = nil
			end
			pcall(function()
				ShopDropdown:Refresh(options, keep)
			end)
		end
	end)
end

local function watchOwnership(folder)
	if not folder then
		return
	end
	local function watch(child)
		if child:IsA("ValueBase") then
			table.insert(Hub.Connections, child.Changed:Connect(refreshShop))
		end
	end
	for _, child in ipairs(folder:GetChildren()) do
		watch(child)
	end
	table.insert(Hub.Connections, folder.ChildAdded:Connect(function(child)
		watch(child)
		refreshShop()
	end))
end

watchOwnership(LocalPlayer:FindFirstChild("OwnedDealers"))
watchOwnership(LocalPlayer:FindFirstChild("Cups"))

ShopTab:CreateButton({
	Name = "Buy Selected",
	Icon = "shopping-cart",
	Style = "Primary",
	Callback = function()
		local item = State.ShopSelection and ShopLookup[State.ShopSelection]
		if not item then
			notify("Shop", "Pick an item first", "Warning")
			return
		end
		if isOwned(item.Kind, item.Name) then
			notify("Shop", item.Name .. " is already owned", "Info")
			refreshShop()
			return
		end
		if getMoney() < item.Price then
			notify("Shop", "Not enough cash for " .. item.Name, "Error")
			return
		end
		task.spawn(function()
			if buyItem(item) then
				notify("Shop", "Bought " .. item.Name .. " " .. item.Kind, "Success")
				State.ShopSelection = nil
				refreshShop()
			else
				notify("Shop", "Could not buy " .. item.Name, "Error")
			end
		end)
	end,
})

EventsTab:CreateLabel({
	Text = nextEventText(),
	UpdateRate = 1,
	Update = nextEventText,
})

EventsTab:CreateLabel({
	Text = activeEventsText(),
	UpdateRate = 1,
	Update = activeEventsText,
})

EventsTab:CreateLabel({
	Text = nightText(),
	UpdateRate = 1,
	Update = nightText,
})

EventsTab:CreateParagraph({
	Title = "Next Event Odds",
	Content = EventOddsText,
})

PlayerSliders.WalkSpeed = PlayerTab:CreateSlider({
	Name = "Walk Speed",
	Range = { 16, 300 },
	Increment = 1,
	CurrentValue = PlayerDefaults.WalkSpeed,
	Callback = setWalkSpeed,
})

PlayerSliders.JumpPower = PlayerTab:CreateSlider({
	Name = "Jump Power",
	Range = { 20, 500 },
	Increment = 1,
	CurrentValue = PlayerDefaults.JumpPower,
	Callback = setJumpPower,
})

PlayerSliders.Fov = PlayerTab:CreateSlider({
	Name = "FOV",
	Range = { 30, 120 },
	Increment = 1,
	CurrentValue = PlayerDefaults.Fov,
	Callback = setFov,
})

PlayerTab:CreateButton({
	Name = "Reset To Default",
	Icon = "rotate-ccw",
	Callback = function()
		resetPlayerSettings()
		notify("Player", "Speed, jump and FOV are back to default", "Success")
	end,
})

PlayerTab:CreateDivider()

addToggle(PlayerTab, "Noclip", setNoclip)

addToggle(PlayerTab, "Infinite Jump", function(value)
	PlayerMods.InfiniteJump = value
end)

addToggle(PlayerTab, "Fly", setFly)

PlayerTab:CreateSlider({
	Name = "Fly Speed",
	Range = { 10, 500 },
	Increment = 1,
	CurrentValue = PlayerMods.FlySpeed,
	Callback = function(value)
		PlayerMods.FlySpeed = value
	end,
})

addToggle(PlayerTab, "Anti AFK", function(value)
	PlayerMods.AntiAfk = value
end, true, true)

SettingsTab:CreateSection("Menu")

SettingsTab:CreateKeybind({
	Name = "Toggle UI",
	CurrentKeybind = "RightControl",
	OnChanged = function(key)
		Window:SetKeybind(key)
	end,
})

SettingsTab:CreateButton({
	Name = "Stop All",
	Icon = "square",
	Callback = function()
		stopAll()
		notify("Stopped", "Every feature is off", "Success")
	end,
})

SettingsTab:CreateButton({
	Name = "Unload UI",
	Icon = "power",
	Callback = function()
		Hub.Unload()
	end,
})

SettingsTab:CreateSection("Credits")

local CreditsLabel = SettingsTab:CreateLabel("Credits - loading...")
SettingsTab:CreateLabel("UI Library - airflowlib.lol")

task.spawn(function()
	local ok, text = pcall(function()
		return game:HttpGet(CreditsUrl)
	end)
	text = ok and type(text) == "string" and string.match(text, "^%s*(.-)%s*$") or ""
	if Hub.Running then
		CreditsLabel:Set(text ~= "" and "Credits - " .. text or "Credits - unavailable")
	end
end)

local function loop(interval, callback)
	task.spawn(function()
		while Hub.Running do
			pcall(callback)
			task.wait(interval)
		end
	end)
end

loop(0.5, autoPlayTick)

loop(1, function()
	if State.AutoHatch then
		hatchEggs()
	end
	if State.AutoPlace then
		placeEggs()
	end
	if State.AutoEquip then
		equipBest()
	end
end)

loop(3, function()
	if State.AutoSell then
		autoSell()
	end
end)

loop(2, function()
	hookAnimator()
	if State.AutoRebirth then
		tryRebirth()
	end
	if State.UpgradeBase then
		tryUpgrade("Base")
	end
	if State.UpgradeZoo then
		tryUpgrade("Tourist")
	end
	if State.AutoClaim then
		claimRewards()
	end
	if State.BuyDealer then
		autoBuy("Dealer")
	end
	if State.BuyCup then
		autoBuy("Cup")
	end
end)

notify(WindowTitle, "Loaded", "Success")
