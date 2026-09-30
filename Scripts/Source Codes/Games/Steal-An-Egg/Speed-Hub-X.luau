repeat
	task.wait()
until game:IsLoaded()

local function initializeSpeedHub()
	local function createCloneRefCache()
		local cloneRefFunction = cloneref
		local cloneCache = setmetatable({}, { __mode = "v" })

		return cloneRefFunction and function(instance)
			if not instance then
				return nil
			end
			local debugId = instance:GetDebugId() or instance
			local cachedRef = cloneCache[debugId]
			if cachedRef then
				return cachedRef
			end
			local clonedRef = cloneRefFunction(instance)
			cloneCache[debugId] = clonedRef
			return clonedRef
		end or function(instance)
			return instance
		end
	end

	local cloneRef = createCloneRefCache()

	local services = setmetatable({}, { __index = function(_, serviceName)
		return cloneRef(game:GetService(serviceName))
	end })

	local players = services.Players
	local replicatedStorage = services.ReplicatedStorage
	local userInputService = services.UserInputService
	local runService = services.RunService
	local lighting = services.Lighting
	local httpService = services.HttpService
	local teleportService = services.TeleportService
	local coreGui = services.CoreGui
	local localPlayer = players.LocalPlayer
	local playerGui = localPlayer:WaitForChild("PlayerGui")
	local character = localPlayer.Character
	local humanoid = character and character:WaitForChild("Humanoid") or nil
	local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart") or nil

	local state = {
		Enabled = {
			IsTeleporting = false,
			["Bypass Anti Teleport"] = true,
			["Fast Switch Bat"] = true,
			["Auto Treadmill"] = false,
			["Auto Rift Sacrifice"] = false,
			["Auto Reroll Rift Recipe"] = false,
			["Prioritize Rift Recipe Eggs"] = false,
			["Prioritize Rift Egg"] = false,
		},
		Module = {},
		Connections = {},
		Cached = {
			Stuck = os.time(),
			JSON = {},
			Count = { WalkSpeed = 0, NoClip = 0, Fail = 0 },
			Image = {},
			Temporary = {},
			Task = {},
			BlockedEggs = {},
		},
		Stored = { Data = {}, UI = {}, StateUpdate = {} },
	}

	_G.LastAction = _G.LastAction or "Idle"
	local module = state.Module
	local connections = state.Connections
	local cached = state.Cached
	local stored = state.Stored
	local enabled = state.Enabled

	local function notifyDeveloper(arg, arg2)
		local StarterGui = game:GetService("StarterGui")
		local name = localPlayer.Name

		if name == "fanoffgteev999" or name == "KXbMrzy" or name == "blacjacqv" or name == "asuhdpas9gudhas9h" then
			StarterGui:SetCore("SendNotification", { Title = arg2 or "", Text = arg, Icon = "rbxassetid://0", Duration = 5 })
		end
	end

	local function loadRemoteLibrary(arg)
		local ok, result = pcall(function()
			return (load or loadstring)(game:HttpGet(arg))()
		end)

		if ok then
			return result
		end
	end

	local libraries = {
		SHX = loadRemoteLibrary("https://raw.githubusercontent.com/AhmadV99/Main/refs/heads/main/Library/Lib_5.5.0.lua"),
		Funcs = loadRemoteLibrary("https://raw.githubusercontent.com/AhmadV99/Main/refs/heads/main/Library/Example/FuncsV4.lua"),
	}

	local shx = libraries.SHX
	local funcs = libraries.Funcs

	local fireSignal = firesignal or getconnections and function(arg)
		for _, v7 in getconnections(arg) do
			if v7.Function then
				task.spawn(v7.Function)
			end
		end
	end or function()
	end

	local function createModules()
		local function createUtils()
			return {
				Connections = function(arg, arg2, arg3)
					local connection = nil

					connection = arg:Connect(function(...)
						if shx.Unloaded then
							if connection then
								connection:Disconnect()
							end

							return
						end

						local ok, result = pcall(arg2, ...)

						if not ok then
							notifyDeveloper(result, "")
						end
					end)

					if arg3 then
						connections[arg3] = connection
					end

					return connection
				end,
				Disconnect = function(arg)
					if connections[arg] then
						connections[arg]:Disconnect()
						connections[arg] = nil
					end
				end,
				StartLoop = function(arg, arg2)
					while not shx.Unloaded do
						if enabled[arg] then
							local ok, result = pcall(arg2)

							if not ok then
								notifyDeveloper(result, arg)
							end
						end

						task.wait(0)
					end
				end,
				Fallback = function(arg, arg2, arg3)
					local n = cached.Count[arg2] or 0

					if arg ~= nil then
						n += 1
						cached.Count[arg2] = n
					end

					if n > 1 then
						if not enabled[arg2] then
							arg3()
						end
					end
				end,
				Notify = function(arg, arg2, arg3)
					pcall(function()
						game:GetService("StarterGui"):SetCore("SendNotification", {
							Title = tostring(arg or "Notice"),
							Text = tostring(arg2 or ""),
							Icon = "rbxassetid://0",
							Duration = arg3 or 4,
						})
					end)
				end,
			}
		end

		local modules = {
			Webhook = function(arg, arg2)
				local request_ = request or syn and syn.request or http and http.request or fluxus and fluxus.request or http_request
				if not request_ then
					return
				end

				request_({
					Url = arg,
					Body = httpService:JSONEncode(arg2),
					Method = "POST",
					Headers = { ["Content-Type"] = "application/json" },
				})
			end,
			Utils = createUtils(),
		}

		local function createDebugInspector()
			local debugInspector

			debugInspector = {
				Logs = {},
				MaxLogs = 30,
				CurrentState = "IDLE_STANDBY",
				SubAction = "Initializing",
				ActiveTarget = "None",
				MovementOwner = "None",
				Timeouts = 0,
				Retries = 0,
				SuccessClaims = 0,
				Gui = nil,
				Fps = 60,
				Ping = 0,
				LastFpsUpdate = os.clock(),
				FrameCount = 0,
				Log = function(arg, arg2)
					if not arg or arg == "" then
						return
					end
					arg2 = arg2 or "INFO"
					local str = string.format("<font color=\"#888888\">[%s]</font> <font color=\"%s\"><b>[%s]</b></font> <font color=\"#EEEEEE\">%s</font>", os.date("%X"), arg2 == "STEAL" and "#00FF7F" or arg2 == "SAKURA" and "#FF69B4" or arg2 == "PLACE" and "#6495ED" or arg2 == "TREADMILL" and "#FFD700" or arg2 == "SELL" and "#FFA500" or arg2 == "FUSE" and "#BA55D3" or arg2 == "NAV" and "#00CED1" or arg2 == "ACTION" and "#00BFFF" or "#AAAAAA", arg2, tostring(arg))
					table.insert(debugInspector.Logs, 1, str)

					if #debugInspector.Logs > debugInspector.MaxLogs then
						table.remove(debugInspector.Logs)
					end
				end,
			}

			local v7 = nil

			task.spawn(function()
				while true do
					local lastAction = _G.LastAction

					if lastAction and lastAction ~= "" and lastAction ~= v7 then
						v7 = lastAction
						local str

						if string.find(lastAction, "^Steal") then
							str = "STEAL"
						elseif string.find(lastAction, "^Sakura") then
							str = "SAKURA"
						elseif string.find(lastAction, "^Place") or string.find(lastAction, "^Pen") then
							str = "PLACE"
						elseif string.find(lastAction, "^Treadmill") then
							str = "TREADMILL"
						elseif string.find(lastAction, "^SafeZone") or string.find(lastAction, "^Nav") then
							str = "NAV"
						elseif string.find(lastAction, "^Sell") then
							str = "SELL"
						else
							str = "ACTION"

							if string.find(lastAction, "^Fuse") then
								str = "FUSE"
							end
						end

						debugInspector.Log(lastAction, str)
						debugInspector.SubAction = lastAction
					end

					task.wait(0.05)
				end
			end)

			debugInspector.SetState = function(arg, arg2, arg3)
				if arg then
					debugInspector.CurrentState = tostring(arg)
				end

				if arg2 then
					debugInspector.SubAction = tostring(arg2)
					_G.LastAction = tostring(arg2)
				end

				if arg3 then
					debugInspector.ActiveTarget = tostring(arg3)
				end
			end

			debugInspector.CreateGui = function()
				if debugInspector.Gui then
					return debugInspector.Gui
				end

				local ok = pcall(function()
					return coreGui
				end) and coreGui or playerGui

				local screenGui = Instance.new("ScreenGui")
				screenGui.Name = "SHX_DebugInspector"
				screenGui.ResetOnSpawn = false
				screenGui.DisplayOrder = 9999
				screenGui.Enabled = enabled["Debug Inspector"] or false
				local frame = Instance.new("Frame")
				frame.Name = "MainFrame"
				frame.Size = UDim2.fromOffset(360, 290)
				frame.Position = UDim2.new(0.02, 0, 0.2, 0)
				frame.BackgroundColor3 = Color3.fromRGB(16, 18, 24)
				frame.BackgroundTransparency = 0.15
				frame.BorderSizePixel = 0
				frame.Active = true
				frame.Draggable = true
				frame.Parent = screenGui
				local uiCorner = Instance.new("UICorner")
				uiCorner.CornerRadius = UDim.new(0, 8)
				uiCorner.Parent = frame
				local uiStroke = Instance.new("UIStroke")
				uiStroke.Color = Color3.fromRGB(0, 206, 209)
				uiStroke.Thickness = 1.2
				uiStroke.Parent = frame
				local textLabel = Instance.new("TextLabel")
				textLabel.Size = UDim2.new(1, -20, 0, 28)
				textLabel.Position = UDim2.new(0, 10, 0, 4)
				textLabel.BackgroundTransparency = 1
				textLabel.Font = Enum.Font.GothamBold
				textLabel.TextSize = 13
				textLabel.TextColor3 = Color3.fromRGB(0, 255, 127)
				textLabel.TextXAlignment = Enum.TextXAlignment.Left
				textLabel.Text = "â¡ SPEED HUB X - DEBUG INSPECTOR"
				textLabel.Parent = frame
				local textLabel2 = Instance.new("TextLabel")
				textLabel2.Name = "StatsLabel"
				textLabel2.Size = UDim2.new(1, -20, 0, 100)
				textLabel2.Position = UDim2.new(0, 10, 0, 32)
				textLabel2.BackgroundColor3 = Color3.fromRGB(24, 28, 38)
				textLabel2.BackgroundTransparency = 0.5
				textLabel2.Font = Enum.Font.Code
				textLabel2.TextSize = 11
				textLabel2.TextColor3 = Color3.fromRGB(220, 230, 240)
				textLabel2.TextXAlignment = Enum.TextXAlignment.Left
				textLabel2.TextYAlignment = Enum.TextYAlignment.Top
				textLabel2.RichText = true
				textLabel2.Text = "Loading inspector data..."
				textLabel2.Parent = frame
				local uiCorner2 = Instance.new("UICorner")
				uiCorner2.CornerRadius = UDim.new(0, 6)
				uiCorner2.Parent = textLabel2
				local scrollingFrame = Instance.new("ScrollingFrame")
				scrollingFrame.Name = "LogBox"
				scrollingFrame.Size = UDim2.new(1, -20, 0, 116)
				scrollingFrame.Position = UDim2.new(0, 10, 0, 136)
				scrollingFrame.BackgroundColor3 = Color3.fromRGB(12, 14, 20)
				scrollingFrame.BackgroundTransparency = 0.4
				scrollingFrame.BorderSizePixel = 0
				scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
				scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
				scrollingFrame.ScrollBarThickness = 4
				scrollingFrame.Parent = frame
				local uiCorner3 = Instance.new("UICorner")
				uiCorner3.CornerRadius = UDim.new(0, 6)
				uiCorner3.Parent = scrollingFrame
				local textLabel3 = Instance.new("TextLabel")
				textLabel3.Name = "LogContent"
				textLabel3.Size = UDim2.new(1, -8, 1, 0)
				textLabel3.Position = UDim2.new(0, 4, 0, 4)
				textLabel3.BackgroundTransparency = 1
				textLabel3.Font = Enum.Font.Code
				textLabel3.TextSize = 10
				textLabel3.TextColor3 = Color3.fromRGB(180, 200, 220)
				textLabel3.TextXAlignment = Enum.TextXAlignment.Left
				textLabel3.TextYAlignment = Enum.TextYAlignment.Top
				textLabel3.AutomaticSize = Enum.AutomaticSize.Y
				textLabel3.TextWrapped = true
				textLabel3.RichText = true
				textLabel3.Text = "<font color=\"#888888\">Logs initialized.</font>"
				textLabel3.Parent = scrollingFrame
				local textButton = Instance.new("TextButton")
				textButton.Size = UDim2.new(0.48, -10, 0, 22)
				textButton.Position = UDim2.new(0, 10, 0, 258)
				textButton.BackgroundColor3 = Color3.fromRGB(40, 45, 60)
				textButton.Font = Enum.Font.GothamBold
				textButton.TextSize = 11
				textButton.TextColor3 = Color3.fromRGB(255, 100, 100)
				textButton.Text = "Clear Logs"
				textButton.Parent = frame
				local uiCorner4 = Instance.new("UICorner")
				uiCorner4.CornerRadius = UDim.new(0, 4)
				uiCorner4.Parent = textButton

				textButton.MouseButton1Click:Connect(function()
					debugInspector.Logs = {}
					textLabel3.Text = "<font color=\"#888888\">Logs cleared.</font>"
				end)

				local textButton2 = Instance.new("TextButton")
				textButton2.Size = UDim2.new(0.48, -10, 0, 22)
				textButton2.Position = UDim2.new(0.52, 0, 0, 258)
				textButton2.BackgroundColor3 = Color3.fromRGB(40, 45, 60)
				textButton2.Font = Enum.Font.GothamBold
				textButton2.TextSize = 11
				textButton2.TextColor3 = Color3.fromRGB(100, 220, 255)
				textButton2.Text = "Copy Logs"
				textButton2.Parent = frame
				local uiCorner5 = Instance.new("UICorner")
				uiCorner5.CornerRadius = UDim.new(0, 4)
				uiCorner5.Parent = textButton2

				textButton2.MouseButton1Click:Connect(function()
					local tbl6 = {}

					for _, log in ipairs(debugInspector.Logs) do
						local v8 = string.gsub(log, "<[^>]+>", "")
						table.insert(tbl6, v8)
					end

					local str = table.concat(tbl6, "\n")

					if setclipboard then
						setclipboard(str)
						notifyDeveloper("Logs copied to clipboard!", "Debug Inspector")
					end
				end)

				screenGui.Parent = ok
				debugInspector.Gui = screenGui

				task.spawn(function()
					while true do
						if screenGui and screenGui.Enabled then
							debugInspector.FrameCount = debugInspector.FrameCount + 1
							local now = os.clock()

							if now - debugInspector.LastFpsUpdate >= 1 then
								debugInspector.Fps = debugInspector.FrameCount / (now - debugInspector.LastFpsUpdate)
								debugInspector.FrameCount = 0
								debugInspector.LastFpsUpdate = now

								pcall(function()
									local serverStatsItem = game:GetService("Stats").Network.ServerStatsItem
									serverStatsItem = serverStatsItem and serverStatsItem["Data Ping"]
									debugInspector.Ping = serverStatsItem and math.round(serverStatsItem:GetValue()) or 0
								end)
							end

							textLabel2.Text = string.format([[ <b>STATE:</b> <font color="%s"><b>%s</b></font> | <b>FPS:</b> %d | <b>PING:</b> %dms
 <b>ACTION:</b> <font color="#FFFFFF">%s</font>
 <b>TARGET:</b> <font color="#FFD700">%s</font>
 <b>STATS:</b> <font color="#00FF7F">Claimed: %d</font> | <font color="#FF6B6B">Timeouts: %d</font> | <font color="#FFA500">Retries: %d</font>
 <b>LOCK OWNER:</b> <font color="#00CED1">%s</font>]], debugInspector.CurrentState == "STEALING" and "#00FF7F" or debugInspector.CurrentState == "BOSS_FIGHT" and "#FF4500" or debugInspector.CurrentState == "BOSS_PORTAL_ENTER" and "#9370DB" or debugInspector.CurrentState == "SAKURA_FARM" and "#FF69B4" or debugInspector.CurrentState == "PLACE_EGG" and "#6495ED" or debugInspector.CurrentState == "TREADMILL" and "#FFD700" or debugInspector.CurrentState == "EMERGENCY_SAFEZONE" and "#FF4500" or "#AAAAAA", debugInspector.CurrentState, debugInspector.Fps, debugInspector.Ping, debugInspector.SubAction, debugInspector.ActiveTarget, debugInspector.SuccessClaims or 0, debugInspector.Timeouts or 0, debugInspector.Retries or 0, modules.Movement and modules.Movement.GetOwner and modules.Movement.GetOwner() or "None")

							if #debugInspector.Logs == 0 then
								textLabel3.Text = "<font color=\"#888888\">No action logs yet...</font>"
							else
								textLabel3.Text = table.concat(debugInspector.Logs, "\n")
							end
						end

						task.wait(0.08)
					end
				end)

				return screenGui
			end

			debugInspector.SetVisible = function(enabled2)
				local v8 = debugInspector.CreateGui()

				if v8 then
					v8.Enabled = enabled2
				end
			end

			return debugInspector
		end

		modules.DebugInspector = createDebugInspector()

		local function createMiscModule()
			local currentCamera = workspace.CurrentCamera
			local contextActionService = services.ContextActionService
			local flag = false

			local function disableRagdollStates(arg)
				if not arg or not arg.Parent then
					return
				end

				pcall(function()
					arg:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
					arg:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
					arg:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
				end)
			end

			local function restoreRagdollRig(arg)
				if not arg or not arg.Parent then
					return
				end

				for _, descendant in ipairs(arg:GetDescendants()) do
					if (descendant:IsA("BallSocketConstraint") or descendant:IsA("HingeConstraint")) and descendant.Name:find("RagdollConstraint") then
						pcall(descendant.Destroy, descendant)
					elseif descendant:IsA("Motor6D") and not descendant.Enabled then
						descendant.Enabled = true
					end
				end
			end

			local function bindAntiKnockbackListener(arg)
				if connections.AntiKnockbackAdded then
					connections.AntiKnockbackAdded:Disconnect()
					connections.AntiKnockbackAdded = nil
				end

				connections.AntiKnockbackAdded = arg.DescendantAdded:Connect(function(descendant)
					if not enabled["Anti Knockback / Ragdoll"] then
						return
					end

					if (descendant:IsA("BallSocketConstraint") or descendant:IsA("HingeConstraint")) and descendant.Name:find("RagdollConstraint") then
						task.defer(function()
							if descendant and descendant.Parent then
								pcall(descendant.Destroy, descendant)
							end
						end)
					elseif descendant:IsA("Motor6D") then
						task.defer(function()
							if descendant and descendant.Parent and not descendant.Enabled then
								descendant.Enabled = true
							end
						end)
					end
				end)
			end

			local function installAntiRagdollHook()
				if flag or not hookfunction then
					return
				end
				flag = true

				pcall(function()
					local ReplicatedStorage = game:GetService("ReplicatedStorage")
					local remotes = modules.Game and modules.Game.Remotes
					local Remotes_

					if remotes then
						Remotes_ = remotes
					else
						Remotes_ = ReplicatedStorage:FindFirstChild("Shared") and ReplicatedStorage.Shared:FindFirstChild("Remotes") and require(ReplicatedStorage.Shared.Remotes)
					end

					local refresh = Remotes_ and Remotes_.RigSync and Remotes_.RigSync.Refresh
					if not refresh then
						return
					end
					local tbl5 = getconnections and getconnections(refresh.OnClientEvent) or {}

					for _, v7 in ipairs(tbl5) do
						local function_ = v7.Function

						if function_ and type(function_) == "function" then
							local info = debug.info and debug.info(function_, "s") or ""

							if info:find("ContentCatalog") or info:find("UGI") then
								local v8 = nil

								local function blockRagdollCommand(arg, ...)
									if enabled["Anti Knockback / Ragdoll"] and typeof(arg) == "string" then
										if arg:find("\"BeginRagdoll\"") or arg:find("\"BeginImpulse\"") then
											return
										end
									end

									return v8(arg, ...)
								end

								v8 = hookfunction
								v8 = v8(function_, blockRagdollCommand)
							end
						end
					end
				end)
			end

			local function applyAntiKnockbackToCharacter(arg)
				if not arg then
					return
				end
				local humanoid2 = arg:WaitForChild("Humanoid", 5)

				if humanoid2 then
					disableRagdollStates(humanoid2)
				end

				restoreRagdollRig(arg)
				bindAntiKnockbackListener(arg)
			end

			local function disconnectAntiKnockbackConnections()
				for _, v7 in ipairs({ "AntiKnockbackAdded", "AntiKnockbackChar" }) do
					if connections[v7] then
						connections[v7]:Disconnect()
						connections[v7] = nil
					end
				end
			end

			return {
				FreezeAndClone = function()
					if cached.Frozen then
						return
					end
					cached.Frozen = true
					cached.FrozenCFrame = currentCamera.CFrame
					cached.SavedParts = {}
					cached.SavedDecals = {}
					local archivable = character.Archivable
					character.Archivable = true
					cached.CharacterClone = character:Clone()
					character.Archivable = archivable
					cached.CharacterClone.Name = "Checkpoint"

					for _, descendant in ipairs(cached.CharacterClone:GetDescendants()) do
						if descendant:IsA("Script") or descendant:IsA("LocalScript") then
							descendant:Destroy()
						elseif descendant:IsA("BasePart") then
							descendant.Anchored = true
							descendant.CanCollide = false
							descendant.CanTouch = false
							descendant.CanQuery = false
							descendant.LocalTransparencyModifier = 0

							if descendant.Name == "HumanoidRootPart" then
								descendant.Transparency = 1
							end
						elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
							descendant.Transparency = 0
						end
					end

					local humanoid2 = cached.CharacterClone:FindFirstChildOfClass("Humanoid")

					if humanoid2 then
						humanoid2.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
					end

					cached.CharacterClone.Parent = workspace

					for _, descendant in ipairs(character:GetDescendants()) do
						if descendant:IsA("BasePart") then
							cached.SavedParts[descendant] = descendant.LocalTransparencyModifier
							descendant.LocalTransparencyModifier = 1
						elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
							cached.SavedDecals[descendant] = descendant.Transparency
							descendant.Transparency = 1
						end
					end

					currentCamera.CameraType = Enum.CameraType.Scriptable
					currentCamera.CFrame = cached.FrozenCFrame

					if connections.FreezeConnection then
						connections.FreezeConnection:Disconnect()
					end

					connections.FreezeConnection = runService.RenderStepped:Connect(function()
						if cached.Frozen and cached.FrozenCFrame then
							currentCamera.CameraType = Enum.CameraType.Scriptable
							currentCamera.CFrame = cached.FrozenCFrame
						end
					end)
				end,
				UnfreezeAndDeleteClone = function()
					if not cached.Frozen then
						return
					end
					cached.Frozen = false

					if connections.FreezeConnection then
						connections.FreezeConnection:Disconnect()
						connections.FreezeConnection = nil
					end

					local v7 = pairs
					local savedParts = cached.SavedParts or {}

					for k, savedPart in v7(savedParts) do
						if k and k.Parent and k:IsA("BasePart") then
							k.LocalTransparencyModifier = savedPart
						end
					end

					local v8 = pairs
					local savedDecals = cached.SavedDecals or {}

					for k, savedDecal in v8(savedDecals) do
						if k and k.Parent and (k:IsA("Decal") or k:IsA("Texture")) then
							k.Transparency = savedDecal
						end
					end

					cached.SavedParts = {}
					cached.SavedDecals = {}

					if cached.CharacterClone then
						cached.CharacterClone:Destroy()
						cached.CharacterClone = nil
					end

					cached.FrozenCFrame = nil
					local character2 = localPlayer.Character
					character2 = character2 and character2:FindFirstChildOfClass("Humanoid")
					currentCamera.CameraType = Enum.CameraType.Custom

					if character2 then
						currentCamera.CameraSubject = character2
					end
				end,
				EnableNoInput = function()
					if cached.NoInputEnabled then
						return
					end
					cached.NoInputEnabled = true

					if not cached.Controls then
						cached.Controls = require(localPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")):GetControls()
					end

					if cached.ScreenText then
						cached.ScreenText.Enabled = true
					else
						cached.ScreenText = Instance.new("ScreenGui")
						cached.ScreenText.Name = "NoInputWarningGui"
						cached.ScreenText.ResetOnSpawn = false
						cached.ScreenText.IgnoreGuiInset = true
						cached.ScreenText.Parent = localPlayer:WaitForChild("PlayerGui")
						cached.ScreenTextLabel = Instance.new("TextLabel")
						cached.ScreenTextLabel.Name = "WarningText"
						cached.ScreenTextLabel.Size = UDim2.fromScale(1, 0.15)
						cached.ScreenTextLabel.Position = UDim2.fromScale(0, 0.42)
						cached.ScreenTextLabel.BackgroundTransparency = 1
						cached.ScreenTextLabel.Text = "[START]"
						cached.ScreenTextLabel.TextScaled = true
						cached.ScreenTextLabel.Font = Enum.Font.GothamBold
						cached.ScreenTextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
						cached.ScreenTextLabel.TextStrokeTransparency = 0
						cached.ScreenTextLabel.Parent = cached.ScreenText
					end

					cached.Controls:Disable()

					contextActionService:BindActionAtPriority("BlockAllPlayerInput", function()
						return Enum.ContextActionResult.Sink
					end, false, 999999, Enum.UserInputType.Keyboard, Enum.UserInputType.MouseButton1, Enum.UserInputType.MouseButton2, Enum.UserInputType.MouseButton3, Enum.UserInputType.MouseMovement, Enum.UserInputType.MouseWheel, Enum.UserInputType.Touch, Enum.UserInputType.Gamepad1, Enum.UserInputType.Gamepad2, Enum.UserInputType.Gamepad3, Enum.UserInputType.Gamepad4)
				end,
				DisableNoInput = function()
					if not cached.NoInputEnabled then
						return
					end
					cached.NoInputEnabled = false
					contextActionService:UnbindAction("BlockAllPlayerInput")

					if cached.Controls then
						cached.Controls:Enable()
					end

					if cached.ScreenText then
						cached.ScreenText.Enabled = false
					end
				end,
				SetHideOwnPets = function(arg)
					local clientRenderedAssets = workspace:FindFirstChild("ClientRenderedAssets")
					if not clientRenderedAssets then
						return
					end

					for _, child in ipairs(clientRenderedAssets:GetChildren()) do
						local userId = localPlayer.UserId

						if child:GetAttribute("OwnerUserId") == userId or string.find(child.Name, tostring(localPlayer.UserId), 1, true) == 1 then
							for _, descendant in ipairs(child:GetDescendants()) do
								if descendant:IsA("BasePart") then
									descendant.LocalTransparencyModifier = arg and 1 or 0
								elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
									descendant.Transparency = arg and 1 or 0
								elseif descendant:IsA("BillboardGui") or descendant:IsA("ParticleEmitter") or descendant:IsA("Highlight") then
									descendant.Enabled = not arg
								end
							end
						end
					end
				end,
				SetHideOwnEggs = function(arg)
					for _, child in ipairs(workspace:GetChildren()) do
						if child.Name == "PlacedEggRenders" then
							for _, child2 in ipairs(child:GetChildren()) do
								local flag2 = string.find(child2.Name, tostring(localPlayer.UserId), 1, true) == 1

								if not flag2 then
									local userId = localPlayer.UserId
									flag2 = child2:GetAttribute("OwnerUserId") == userId
								end

								if flag2 then
									for _, descendant in ipairs(child2:GetDescendants()) do
										if descendant:IsA("BasePart") then
											descendant.LocalTransparencyModifier = arg and 1 or 0
										elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
											descendant.Transparency = arg and 1 or 0
										elseif descendant:IsA("BillboardGui") or descendant:IsA("ParticleEmitter") or descendant:IsA("Highlight") then
											descendant.Enabled = not arg
										end
									end
								end
							end
						end
					end
				end,
				SetHideOtherEggs = function(arg)
					for _, child in ipairs(workspace:GetChildren()) do
						if child.Name == "PlacedEggRenders" then
							for _, child2 in ipairs(child:GetChildren()) do
								local flag2 = string.find(child2.Name, tostring(localPlayer.UserId), 1, true) == 1

								if not flag2 then
									local userId = localPlayer.UserId
									flag2 = child2:GetAttribute("OwnerUserId") == userId
								end

								if not flag2 then
									for _, descendant in ipairs(child2:GetDescendants()) do
										if descendant:IsA("BasePart") then
											descendant.LocalTransparencyModifier = arg and 1 or 0
										elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
											descendant.Transparency = arg and 1 or 0
										elseif descendant:IsA("BillboardGui") or descendant:IsA("ParticleEmitter") or descendant:IsA("Highlight") then
											descendant.Enabled = not arg
										end
									end
								end
							end
						end
					end
				end,
				SetHideMoneyAnimation = function(arg)
					if not arg then
						return
					end
					local terrain = workspace:FindFirstChild("Terrain")

					if terrain then
						for _, child in ipairs(terrain:GetChildren()) do
							if child.Name == "SyncedIncomeCashAttachment" or child.Name == "SyncedIncomeCash" then
								child:Destroy()
							end
						end
					end
				end,
				ApplyReduceLag = function(arg)
					if arg then
						for _, descendant in pairs(workspace:GetDescendants()) do
							local isBasePart = descendant:IsA("BasePart")

							if isBasePart then
								isBasePart = not (descendant.Parent and descendant.Parent:FindFirstChildWhichIsA("Humanoid"))
							end

							if isBasePart then
								descendant.Material = Enum.Material.SmoothPlastic
								descendant.CastShadow = false
								descendant.Reflectance = 0
							elseif descendant:IsA("Texture") or descendant:IsA("Decal") or descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") then
								if not (localPlayer.Character and descendant:IsDescendantOf(localPlayer.Character)) then
									pcall(function()
										descendant.Transparency = 1
									end)

									pcall(function()
										descendant.Enabled = false
									end)
								end
							end
						end

						pcall(function()
							lighting.GlobalShadows = false
							lighting.FogEnd = 9e9
						end)
					end
				end,
				SetAntiKnockback = function(arg)
					disconnectAntiKnockbackConnections()
					if not arg then
						return
					end
					installAntiRagdollHook()

					if localPlayer.Character then
						applyAntiKnockbackToCharacter(localPlayer.Character)
					end

					connections.AntiKnockbackChar = localPlayer.CharacterAdded:Connect(function(character2)
						applyAntiKnockbackToCharacter(character2)
					end)
				end,
			}
		end

		modules.Misc = createMiscModule()

		local function createGameModule()
			local gameApi

			gameApi = {
				Ready = false,
				Network = nil,
				EggCmds = nil,
				AssetCmds = nil,
				PlotCmds = nil,
				Save = nil,
				BaseUpgradeClient = nil,
				AssetGenerationUtil = nil,
				AssetItemSerialization = nil,
				TreadmillUtil = nil,
				RebirthUtil = nil,
				Assets = nil,
				Rarity = nil,
				Treadmills = nil,
				Bases = nil,
				Rebirths = nil,
				Areas = nil,
				Trails = nil,
				SettingsCmds = nil,
				Remotes = nil,
				EggState = nil,
				PlotState = nil,
				Init = function()
					if replicatedStorage:FindFirstChild("Data") ~= nil or replicatedStorage:FindFirstChild("Shared") ~= nil then
						pcall(function()
							local shared = replicatedStorage:FindFirstChild("Shared")
							local data = replicatedStorage:FindFirstChild("Data")
							local client = replicatedStorage:FindFirstChild("Client")

							if shared and shared:FindFirstChild("Remotes") then
								gameApi.Remotes = require(shared.Remotes)
							end

							if shared and shared:FindFirstChild("Save") then
								gameApi.Save = require(shared.Save)
							end

							if data and data:FindFirstChild("Assets") then
								gameApi.Assets = require(data.Assets)
							end

							if data and data:FindFirstChild("Bases") then
								gameApi.Bases = require(data.Bases)
							end

							if data and data:FindFirstChild("Rarity") then
								gameApi.Rarity = require(data.Rarity)
							end

							if data and data:FindFirstChild("Treadmills") then
								gameApi.Treadmills = require(data.Treadmills)
							end

							if data and data:FindFirstChild("Areas") then
								gameApi.Areas = require(data.Areas)
							end

							if data and data:FindFirstChild("Trails") then
								gameApi.Trails = require(data.Trails)
							end

							if shared and shared:FindFirstChild("SettingsCmds") then
								gameApi.SettingsCmds = require(shared.SettingsCmds)
							end

							if client and client:FindFirstChild("EggState") then
								gameApi.EggState = require(client.EggState)
							end

							if client and client:FindFirstChild("PlotState") then
								gameApi.PlotState = require(client.PlotState)
							end
						end)

						gameApi.EggCmds = {
							GetAreaEggSnapshot = function()
								local ok, result = pcall(function()
									if gameApi.Remotes and gameApi.Remotes.EggWorld and gameApi.Remotes.EggWorld.AskFieldEggSnapshot then
										return gameApi.Remotes.EggWorld.AskFieldEggSnapshot:InvokeServer()
									end

									if gameApi.EggState and gameApi.EggState.ReadFieldEggs then
										return { Records = gameApi.EggState.ReadFieldEggs() }
									end
								end)

								return ok and type(result) == "table" and result or { Records = {} }
							end,
							GetRuntimeSnapshot = function()
								local ok, result = pcall(function()
									if gameApi.Remotes and gameApi.Remotes.EggWorld and gameApi.Remotes.EggWorld.AskLiveSnapshot then
										return gameApi.Remotes.EggWorld.AskLiveSnapshot:InvokeServer()
									end

									if gameApi.EggState and gameApi.EggState.ReadOwnedEggs then
										return gameApi.EggState.ReadOwnedEggs()
									end
								end)

								if ok and type(result) == "table" then
									if result.Records then
										return { result }
									end
									return result
								end

								return { { OwnerUserId = localPlayer.UserId, Records = {} } }
							end,
							RequestAreaEggSnapshot = function()
								local ok, result = pcall(function()
									if gameApi.EggState and gameApi.EggState.SyncFieldEggs then
										local v7 = gameApi.EggState.SyncFieldEggs()
										if type(v7) == "table" then
											return v7
										end
									elseif gameApi.Remotes and gameApi.Remotes.EggWorld and gameApi.Remotes.EggWorld.AskFieldEggSnapshot then
										return gameApi.Remotes.EggWorld.AskFieldEggSnapshot:InvokeServer()
									end
								end)

								return ok and type(result) == "table" and result or {}
							end,
							RequestRuntimeSnapshot = function()
								local ok, result = pcall(function()
									if gameApi.Remotes and gameApi.Remotes.EggWorld and gameApi.Remotes.EggWorld.AskLiveSnapshot then
										return gameApi.Remotes.EggWorld.AskLiveSnapshot:InvokeServer()
									end

									if gameApi.EggState and gameApi.EggState.SyncOwnedEggs then
										return gameApi.EggState.SyncOwnedEggs()
									end
								end)

								return ok and type(result) == "table" and result or {}
							end,
							RequestCarryAreaEgg = function(arg, arg2)
								local ok, result = pcall(function()
									if gameApi.Remotes and gameApi.Remotes.EggWorld and gameApi.Remotes.EggWorld.AskFieldEggCarry then
										return gameApi.Remotes.EggWorld.AskFieldEggCarry:InvokeServer({ Uid = arg, FirstAreaSlotKey = arg2 })
									end
									return require(game:GetService("ReplicatedStorage").Shared.Remotes).EggWorld.AskFieldEggCarry:InvokeServer({ Uid = arg, FirstAreaSlotKey = arg2 })
								end)

								return ok and result
							end,
							RequestDropHeldEgg = function(arg)
								local ok, result = pcall(function()
									if gameApi.EggState and gameApi.EggState.DropFieldEgg then
										return gameApi.EggState.DropFieldEgg(arg)
									end

									if gameApi.Remotes and gameApi.Remotes.EggWorld and gameApi.Remotes.EggWorld.AskFieldEggDrop then
										return gameApi.Remotes.EggWorld.AskFieldEggDrop:InvokeServer({ Reason = arg })
									end
								end)

								return ok and result
							end,
							RequestPlaceEgg = function(arg, arg2, arg3)
								arg3 = typeof(arg3) == "CFrame" and arg3
								local cframe

								if arg3 then
									cframe = arg3
								else
									cframe = typeof(arg2) == "CFrame" and arg2 or CFrame.new()
								end

								if gameApi.EggState and gameApi.EggState.PlantEgg then
									local ok, result = pcall(function()
										return gameApi.EggState.PlantEgg(arg, cframe)
									end)

									if ok and result == true then
										return true
									end
								end

								local ReplicatedStorage = game:GetService("ReplicatedStorage")
								local networking = ReplicatedStorage:FindFirstChild("Packages") and ReplicatedStorage.Packages:FindFirstChild("Networking")
								local rfEggWorldAskPlaceEgg = networking and networking:FindFirstChild("RF/EggWorld/AskPlaceEgg")

								if rfEggWorldAskPlaceEgg then
									local ok, result = pcall(function()
										return rfEggWorldAskPlaceEgg:InvokeServer({ Uid = arg, LocalCFrame = cframe })
									end)

									if ok and (result == true or type(result) == "table" and result.Outcome == true) then
										return true
									end
								end

								return false
							end,
							RequestHatchEgg = function(arg)
								local ok, result = pcall(function()
									if gameApi.EggState and gameApi.EggState.BeginHatch then
										return gameApi.EggState.BeginHatch(arg)
									end

									if gameApi.Remotes and gameApi.Remotes.EggWorld and gameApi.Remotes.EggWorld.AskHatch then
										return gameApi.Remotes.EggWorld.AskHatch:InvokeServer(arg)
									end
								end)

								return ok and result
							end,
							RequestCompleteHatchEgg = function(arg)
								local ok, result = pcall(function()
									if gameApi.EggState and gameApi.EggState.FinishHatch then
										return gameApi.EggState.FinishHatch(arg)
									end

									if gameApi.Remotes and gameApi.Remotes.EggWorld and gameApi.Remotes.EggWorld.AskFinishHatch then
										return gameApi.Remotes.EggWorld.AskFinishHatch:InvokeServer(arg)
									end
								end)

								return ok and result
							end,
							RequestEquipTool = function(arg)
								local ok, result = pcall(function()
									if gameApi.EggState and gameApi.EggState.WearEggTool then
										return gameApi.EggState.WearEggTool(arg)
									end

									if gameApi.Remotes and gameApi.Remotes.EggWorld and gameApi.Remotes.EggWorld.AskWearTool then
										return gameApi.Remotes.EggWorld.AskWearTool:InvokeServer(arg)
									end
								end)

								return ok and result
							end,
							RequestUnequipTool = function(arg)
								local ok, result = pcall(function()
									if gameApi.EggState and gameApi.EggState.DoffEggTool then
										return gameApi.EggState.DoffEggTool(arg)
									end

									if gameApi.Remotes and gameApi.Remotes.EggWorld and gameApi.Remotes.EggWorld.AskDoffTool then
										return gameApi.Remotes.EggWorld.AskDoffTool:InvokeServer(arg)
									end
								end)

								return ok and result
							end,
							IsLocalEggReady = function(arg)
								if gameApi.EggState and gameApi.EggState.IsReadyToHatch then
									return gameApi.EggState.IsReadyToHatch(arg)
								end
								return false
							end,
						}

						gameApi.PlotCmds = {
							GetPlotData = function()
								local localPlayer2 = localPlayer or game.Players.LocalPlayer
								local resolvePlot = gameApi.PlotState and gameApi.PlotState.ResolvePlot
								local v7 = nil

								if resolvePlot then
									v7 = gameApi.PlotState.ResolvePlot(localPlayer2)
								end

								if not v7 then
									local ok, result = pcall(function()
										return require(game:GetService("ReplicatedStorage").Client.PlotState)
									end)

									if ok and result and result.ResolvePlot then
										v7 = result.ResolvePlot(localPlayer2)
									end
								end

								if v7 and v7.CenterPoint and v7.PetArea then
									local plotFolder = v7.PlotFolder
									local toUpdate = plotFolder and plotFolder:FindFirstChild("ToUpdate")
									toUpdate = toUpdate and toUpdate:FindFirstChild("PetArea") or plotFolder and plotFolder:FindFirstChild("PetArea") or v7.PetArea

									return {
										PlotIndex = tonumber(v7.Slot) or 1,
										PlotFolder = plotFolder,
										CenterPoint = v7.CenterPoint,
										PetArea = toUpdate,
										RespawnPointCFrame = v7.RespawnPointCFrame,
									}
								end

								return nil
							end,
							GetPlotFromPart = function(arg)
								while arg and arg.Parent and arg.Parent ~= workspace.Plots do
									arg = arg.Parent
								end

								return arg
							end,
						}

						gameApi.GetPlot = gameApi.PlotCmds.GetPlotData

						gameApi.Network = setmetatable({}, { __index = function()
							return {
								FireServer = function()
								end,
								InvokeServer = function()
								end,
							}
						end })

						gameApi.Ready = gameApi.Save ~= nil and gameApi.Assets ~= nil and gameApi.Remotes ~= nil
						return gameApi.Ready
					end

					local library = replicatedStorage:FindFirstChild("Library")
					local directory = replicatedStorage:FindFirstChild("Directory")

					if library then
						pcall(function()
							gameApi.Network = require(library.Client.Network)
							gameApi.EggCmds = require(library.Client.EggCmds)
							gameApi.AssetCmds = require(library.Client.AssetCmds)
							gameApi.PlotCmds = require(library.Client.PlotCmds)
							gameApi.Save = require(library.Client.Save)
						end)
					end

					if directory then
						pcall(function()
							gameApi.Assets = require(directory.Assets)
							gameApi.Rarity = require(directory.Rarity)
							gameApi.Treadmills = require(directory.Treadmills)
							gameApi.Bases = require(directory.Bases)
							gameApi.Areas = require(directory.Areas)
						end)
					end

					gameApi.Ready = gameApi.Save ~= nil and gameApi.Assets ~= nil
					return gameApi.Ready
				end,
				GetSave = function()
					if not gameApi.Save then
						local ok, save = pcall(function()
							return require(game:GetService("ReplicatedStorage").Shared.Save)
						end)

						if not ok or not save then
							ok, save = pcall(function()
								return require(game:GetService("ReplicatedStorage").Client.Save)
							end)
						end

						if ok and save then
							gameApi.Save = save
						end
					end

					if gameApi.Save and gameApi.Save.Get then
						local ok, result = pcall(function()
							return gameApi.Save.Get()
						end)

						if ok and type(result) == "table" then
							return result
						end
					end

					if gameApi.Save and gameApi.Save.Peek then
						local ok, result = pcall(function()
							return gameApi.Save.Peek()
						end)

						if ok and type(result) == "table" then
							return result
						end
					end

					return nil
				end,
				GetSaveWait = function()
					if not gameApi.Save then
						return nil
					end
					local v7 = gameApi.GetSave()
					local n = 0

					while not v7 and n < 30 do
						task.wait(1)
						v7 = gameApi.GetSave()
						n += 1
					end

					return v7
				end,
				GetPlot = function()
					if not gameApi.PlotCmds then
						return nil
					end

					local ok, result = pcall(function()
						return gameApi.PlotCmds.GetPlotData()
					end)

					if ok and type(result) == "table" then
						return result
					end
					return nil
				end,
				GetMyUserId = function()
					return localPlayer.UserId
				end,
				GetAreas = function()
					if not gameApi.Areas or not gameApi.Areas.Directory then
						return {}
					end
					local tbl6 = {}

					for k in pairs(gameApi.Areas.Directory) do
						table.insert(tbl6, k)
					end

					table.sort(tbl6)
					return tbl6
				end,
			}

			return gameApi
		end

		modules.Game = createGameModule()

		local function createMovementModule()
			local movementManager

			movementManager = {
				CurrentOwner = nil,
				OwnerPriority = 0,
				ClaimedAt = 0,
				CanClaim = function(arg, arg2)
					local now = os.clock()
					if movementManager.CurrentOwner == nil or movementManager.CurrentOwner == arg then
						return true
					end

					if now - movementManager.ClaimedAt > 20 then
						return true
					end
					return (arg2 or 0) > movementManager.OwnerPriority
				end,
				Claim = function(currentOwner, ownerPriority)
					local now = os.clock()

					if movementManager.CurrentOwner == nil or movementManager.CurrentOwner == currentOwner then
						movementManager.CurrentOwner = currentOwner
						local v7 = movementManager
						ownerPriority = ownerPriority or 0
						v7.OwnerPriority = ownerPriority
						movementManager.ClaimedAt = now
						return true
					end

					if now - movementManager.ClaimedAt > 20 then
						movementManager.CurrentOwner = currentOwner
						local v7 = movementManager
						ownerPriority = ownerPriority or 0
						v7.OwnerPriority = ownerPriority
						movementManager.ClaimedAt = now
						return true
					end

					if movementManager.OwnerPriority < (ownerPriority or 0) then
						movementManager.CurrentOwner = currentOwner
						movementManager.OwnerPriority = ownerPriority or 0
						movementManager.ClaimedAt = now
						return true
					end

					return false
				end,
				Release = function(arg)
					if movementManager.CurrentOwner == arg then
						movementManager.CurrentOwner = nil
						movementManager.OwnerPriority = 0
						movementManager.ClaimedAt = 0
					end
				end,
				GetOwner = function()
					return movementManager.CurrentOwner
				end,
				Stop = function()
				end,
			}

			return movementManager
		end

		modules.Movement = createMovementModule()

		local function createFarmStateModule()
			local farmStateManager

			farmStateManager = {
				Eggs = {},
				EggsAt = 0,
				TargetUid = nil,
				Carrying = false,
				CarriedUid = nil,
				CarriedAssetCategory = nil,
				State = "Idle",
				LastPlaceAt = 0,
				LastReleaseAt = 0,
				CarryStartedAt = 0,
				ClaimedAt = 0,
				HatchedUids = {},
				LastSnapshotAt = 0,
				IsPlacing = false,
				GetEggCapacityStatus = function()
					local save = modules.Game and modules.Game.Save
					local eggCmds = modules.Game and modules.Game.EggCmds

					if modules.Game then
					end

					local baseUpgradeLevel = (save and save.Get and save.Get() or save and save.Peek and save.Peek() or {}).BaseUpgradeLevel or 1
					local maxPlaced = modules.PlaceEgg and modules.PlaceEgg.MaxPlaced or 30
					local getRuntimeSnapshot = eggCmds and eggCmds.GetRuntimeSnapshot and eggCmds.GetRuntimeSnapshot() or {}
					local tbl6 = {}

					for _, v7 in ipairs(getRuntimeSnapshot) do
						if v7.OwnerUserId == localPlayer.UserId then
							tbl6 = v7.Records or {}
							break
						end
					end

					local tbl7 = {}
					local n = 0

					for k, v7 in pairs(tbl6) do
						if v7.Placement == nil then
							table.insert(tbl7, k)
						else
							n += 1
						end
					end

					local n2 = #tbl7
					local flag = n >= maxPlaced

					return {
						baseLevel = baseUpgradeLevel,
						maxPlaced = maxPlaced,
						placedCount = n,
						unplacedCount = n2,
						unplacedUids = tbl7,
						isPenFull = flag,
						isInventoryFull = n2 >= 240,
						needsPlace = n2 > 0 and not flag,
					}
				end,
				RefreshEggs = function(arg)
					local flag = not arg

					if flag then
						local eggsAt = farmStateManager.EggsAt
						flag = os.clock() - eggsAt < 0.5
					end

					if flag then
						return
					end
					farmStateManager.EggsAt = os.clock()

					local ok, result = pcall(function()
						local eggCmds = modules.Game and modules.Game.EggCmds
						return eggCmds and eggCmds.RequestAreaEggSnapshot and eggCmds.RequestAreaEggSnapshot()
					end)

					if ok and type(result) == "table" then
						local records = result.Records or result
						local records2

						if type(records) == "table" and type(records.Records) == "table" then
							records2 = records.Records
						else
							records2 = records
						end

						farmStateManager.Eggs = records2 or {}
					end
				end,
				GetCarryState = function()
					if farmStateManager.Carrying then
						return true, farmStateManager.CarriedUid, farmStateManager.CarriedAssetCategory
					end
					local character2 = localPlayer.Character

					if character2 then
						for _, child in ipairs(character2:GetChildren()) do
							if child:IsA("Tool") and child:GetAttribute("ItemType") == "AssetEgg" then
								local getAttribute = child.GetAttribute
								return true, child:GetAttribute("UID"), getAttribute(child, "AssetCategory")
							end
						end
					end

					local dropHeldEgg = playerGui:FindFirstChild("DropHeldEgg")
					if dropHeldEgg and dropHeldEgg.Enabled then
						return true, farmStateManager.CarriedUid, farmStateManager.CarriedAssetCategory
					end
					return false, nil, nil
				end,
				SyncCarry = function()
					local v7, v8, v9 = farmStateManager.GetCarryState()

					if farmStateManager.OptimisticCarry then
						if v7 then
							farmStateManager.OptimisticCarry = false
							farmStateManager.Carrying = true
							farmStateManager.CarriedUid = v8
							farmStateManager.CarriedAssetCategory = v9
							return
						end

						local optimisticAt = farmStateManager.OptimisticAt

						if optimisticAt then
							local optimisticAt2 = farmStateManager.OptimisticAt
							optimisticAt = os.clock() - optimisticAt2 > 4
						end

						if optimisticAt then
							farmStateManager.OptimisticCarry = false
							farmStateManager.Carrying = false
							farmStateManager.CarriedUid = nil
							farmStateManager.CarriedAssetCategory = nil
						end

						return
					end

					farmStateManager.Carrying = v7

					if v7 then
						farmStateManager.CarriedUid = v8
						farmStateManager.CarriedAssetCategory = v9
					else
						farmStateManager.CarriedUid = nil
						farmStateManager.CarriedAssetCategory = nil
					end
				end,
			}

			return farmStateManager
		end

		modules.FarmState = createFarmStateModule()

		local function createStealModule()
			local stealManager = {}
			local farmState = modules.FarmState
			local movement = modules.Movement
			local tbl6 = { BlockedEggs = {}, Night = false }

			if modules.Game then
			end

			local Remotes_ = nil

			pcall(function()
				Remotes_ = require(game:GetService("ReplicatedStorage").Shared.Remotes)
			end)

			local tbl7 = {}

			local function getAssetDirectory()
				if next(tbl7) then
					return tbl7
				end
				local assets = modules.Game and modules.Game.Assets

				if not assets then
					pcall(function()
						local ReplicatedStorage = game:GetService("ReplicatedStorage")

						if ReplicatedStorage:FindFirstChild("Data") and ReplicatedStorage.Data:FindFirstChild("Assets") then
							assets = require(ReplicatedStorage.Data.Assets)
						elseif ReplicatedStorage:FindFirstChild("Directory") and ReplicatedStorage.Directory:FindFirstChild("Assets") then
							assets = require(ReplicatedStorage.Directory.Assets)
						end
					end)
				end

				local directory = assets and assets.Directory
				local flag

				if directory then
					flag = directory
				else
					flag = type(assets) == "table" and assets
				end

				local v7 = flag or nil

				if v7 and type(v7) == "table" then
					for k, v8 in pairs(v7) do
						tbl7[k] = v8
					end
				end

				return tbl7
			end

			local tbl8 = {
				common = 1,
				uncommon = 2,
				superrare = 2,
				rare = 3,
				epic = 4,
				legendary = 5,
				mythic = 6,
				["squishy god"] = 6,
				brainrotgod = 6,
				rainbow = 6,
				prismatic = 6,
				cosmic = 7,
				secret = 8,
				eternal = 9,
				limited = 9,
				divine = 10,
				transcendent = 10,
				titan = 11,
				["light & dark"] = 12,
				lightdark = 12,
				["light and dark"] = 12,
			}

			local tbl9 = {
				"Common",
				"Uncommon",
				"Rare",
				"Epic",
				"Legendary",
				"Mythic",
				"Cosmic",
				"Secret",
				"Eternal",
				"Divine",
				"Titan",
				"Light & Dark",
			}

			local tbl10 = {
				chicken = 1,
				dog = 1,
				duckling = 1,
				frog = 1,
				jerboa = 1,
				bird = 2,
				catfish = 2,
				fennec = 2,
				["burrowing owl"] = 3,
				camel = 3,
				chimpanzee = 3,
				dodo = 3,
				["lava gecko"] = 3,
				parrotfish = 3,
				penguin = 3,
				raccoon = 3,
				toucan = 3,
				["tung tung sahur"] = 3,
				turtle = 3,
				["bananita dolphinita"] = 4,
				bear = 4,
				centapede = 4,
				crane = 4,
				crocodile = 4,
				fox = 4,
				["lava frog"] = 4,
				swan = 4,
				swordfish = 4,
				["tob tobi tob tob"] = 4,
				["trulimero trulicina"] = 4,
				walrus = 4,
				axolotl = 5,
				["baby aurora dragon"] = 5,
				["brr brr patapim"] = 5,
				["cosmic gecko"] = 5,
				crustacia = 5,
				["flaming bull"] = 5,
				gorilla = 5,
				["lava iguana"] = 5,
				["mecha scorpio"] = 5,
				["orangutini ananassini"] = 5,
				["polar bear"] = 5,
				pterodactyl = 5,
				salamander = 5,
				scorpio = 5,
				shark = 5,
				snake = 5,
				spideron = 5,
				ankylosaurus = 6,
				["belula beluga"] = 6,
				bladehide = 6,
				["chillin chilli"] = 6,
				["cosmic gorilla"] = 6,
				froggo = 6,
				mammoth = 6,
				["mecha froggo"] = 6,
				orca = 6,
				["red panda"] = 6,
				["sabertooth tiger"] = 6,
				["sand spider"] = 6,
				scorpion = 6,
				["shadow dragon"] = 6,
				spider = 6,
				tiger = 6,
				["beluga whale"] = 7,
				bronto = 7,
				crawler = 7,
				["demon imp"] = 7,
				drilla = 7,
				hellhound = 7,
				["king mammoth"] = 7,
				koi = 7,
				["la vacca saturno saturnita"] = 7,
				leviathan = 7,
				["mangolini parrochini"] = 7,
				mantaris = 7,
				["mecha crawler"] = 7,
				rhinotaur = 7,
				["royal sphinx"] = 7,
				["snowy owl"] = 7,
				triceratops = 7,
				["whale shark"] = 7,
				["bombo croco"] = 8,
				cerberus = 8,
				["cosmic dragon"] = 8,
				["cosmic skeleton boss"] = 8,
				crocodon = 8,
				["ember dragon"] = 8,
				gargoyle = 8,
				["king snake"] = 8,
				kraken = 8,
				["mecha crocodon"] = 8,
				minotaur = 8,
				["mutant shark"] = 8,
				["scorched dragon"] = 8,
				stag = 8,
				trex = 8,
				tralaledon = 8,
				yeti = 8,
				balrog = 9,
				["el maja"] = 9,
				["eternal lunar dragon"] = 9,
				["gorilla king"] = 9,
				["ice dragon"] = 9,
				krakenoid = 9,
				["lava dragon"] = 9,
				["mecha krakenoid"] = 9,
				mosasaurus = 9,
				["oni tiger"] = 9,
				phoenix = 9,
				["strawberry elephant"] = 9,
				["void dragon"] = 9,
				["archdemon dragon"] = 10,
				dreadscale = 10,
				kitsune = 10,
				["mecha dreadscale"] = 10,
				nightflame = 10,
				unicorn = 10,
			}

			stealManager.AreaFilters = {}
			stealManager.SpecificEggFilters = {}
			stealManager.MinRarity = 7
			stealManager.SafeZone = Vector3.new(515, 74.4, -362.8)
			stealManager.Priority = "Best Rarity"

			stealManager.ParseRarity = function(arg)
				if not arg then
					return 7
				end

				if type(arg) == "number" then
					return math.clamp(math.floor(arg), 1, 12)
				end

				if type(arg) == "table" then
					arg = arg[1] or arg.Value or arg.Title or arg.Text or arg.Name
				end

				local str = tostring(arg or "7 - Cosmic")
				if str == "All" or string.find(str, "All", 1, true) then
					return 1
				end
				local v7 = string.lower(str)

				for k, v8 in pairs({
					common = 1,
					uncommon = 2,
					superrare = 2,
					rare = 3,
					epic = 4,
					legendary = 5,
					mythic = 6,
					["squishy god"] = 6,
					brainrotgod = 6,
					rainbow = 6,
					prismatic = 6,
					cosmic = 7,
					secret = 8,
					eternal = 9,
					limited = 9,
					divine = 10,
					transcendent = 10,
					titan = 11,
					["light & dark"] = 12,
					lightdark = 12,
					["light and dark"] = 12,
				}) do
					if string.find(v7, k, 1, true) then
						return v8
					end
				end

				local num = tonumber(string.match(str, "(%d+)"))
				if num then
					return math.clamp(num, 1, 12)
				end
				return 7
			end

			stealManager.GetMinRarity = function()
				local minRarity = stored.Controllers and stored.Controllers["Min Rarity"]

				if minRarity and minRarity.Get then
					local ok, result = pcall(function()
						return minRarity:Get()
					end)

					if ok and result ~= nil then
						local v7 = stealManager.ParseRarity(result)
						stealManager.MinRarity = v7
						return v7
					end
				end

				return stealManager.MinRarity or 1
			end

			stealManager.SyncFromControllers = function()
				if stored.Controllers then
					if stored.Controllers["Min Rarity"] and stored.Controllers["Min Rarity"].Get then
						pcall(function()
							stealManager.MinRarity = stealManager.ParseRarity(stored.Controllers["Min Rarity"]:Get())
						end)
					end

					if stored.Controllers["Steal Priority"] and stored.Controllers["Steal Priority"].Get then
						pcall(function()
							local v7 = stored.Controllers["Steal Priority"]:Get()

							if v7 then
								stealManager.Priority = v7
							end
						end)
					end

					if stored.Controllers["Target Areas"] and stored.Controllers["Target Areas"].Get then
						pcall(function()
							local v7 = stored.Controllers["Target Areas"]:Get()

							if v7 then
								stealManager.AreaFilters = v7
							end
						end)
					end

					if stored.Controllers["Target Specific Eggs"] and stored.Controllers["Target Specific Eggs"].Get then
						pcall(function()
							local v7 = stored.Controllers["Target Specific Eggs"]:Get()

							if v7 then
								stealManager.SpecificEggFilters = v7

								if stealManager.RebuildSpecificEggLookup then
									stealManager.RebuildSpecificEggLookup()
								end
							end
						end)
					end
				end
			end

			stealManager.IsAreaSelected = function(arg)
				if not stealManager.AreaFilters then
					return true
				end

				if stealManager.AreaFilters[arg] == true then
					return true
				end

				if stealManager.AreaFilters.All or stealManager.AreaFilters.Semua then
					return true
				end
				local n = 0

				for k, areaFilter in pairs(stealManager.AreaFilters) do
					n += 1
					if areaFilter == true and k == arg then
						return true
					end

					if type(k) == "number" and (areaFilter == arg or areaFilter == "All" or areaFilter == "Semua") then
						return true
					end
				end

				return n == 0
			end

			stealManager.GetEggDisplayName = function(arg)
				if not arg then
					return "Unknown"
				end
				local v7 = getAssetDirectory()
				if v7 and v7[arg] then
					local v8 = v7[arg]
					return v8.DisplayName or v8.Name or arg
				end
				return tostring(arg)
			end

			stealManager.GetEggRarityNumber = function(arg)
				if not arg then
					return 1
				end

				if type(arg) == "number" then
					return arg
				end

				if type(arg.RarityNumber) == "number" then
					return arg.RarityNumber
				end
				local assetCategory = arg.AssetCategory or arg.Category or arg.Name

				if not assetCategory and type(arg) == "string" then
					assetCategory = arg
				end

				if not assetCategory then
					return 1
				end
				local v7 = getAssetDirectory()
				v7 = v7 and v7[assetCategory]

				if v7 then
					if v7.Rarity and type(v7.Rarity) == "table" then
						if type(v7.Rarity.Rank) == "number" then
							return v7.Rarity.Rank
						end

						if type(v7.Rarity.RarityNumber) == "number" then
							return v7.Rarity.RarityNumber
						end
						local displayName = v7.Rarity.DisplayName or v7.Rarity.Name or v7.Rarity._id

						if displayName and type(displayName) == "string" then
							local v8 = tbl8[string.lower(displayName)]
							if v8 then
								return v8
							end
						end
					end

					if type(v7.Rank) == "number" then
						return v7.Rank
					end

					if type(v7.RarityNumber) == "number" then
						return v7.RarityNumber
					end

					if v7.Rarity and type(v7.Rarity) == "string" then
						local v8 = tbl8[string.lower(v7.Rarity)]
						if v8 then
							return v8
						end
					end
				end

				local v8 = string.lower(tostring(assetCategory))
				local v9 = tbl10[v8]
				if v9 then
					return v9
				end
				local str = v8:gsub("[%s_%-]+", "")

				for k, v10 in pairs(tbl10) do
					if str == k:gsub("[%s_%-]+", "") or string.find(v8, k, 1, true) or string.find(k, v8, 1, true) then
						return v10
					end
				end

				if arg.Rarity and type(arg.Rarity) == "string" then
					local v10 = tbl8[string.lower(arg.Rarity)]
					if v10 then
						return v10
					end
				end

				return 1
			end

			stealManager.GetEggRarityName = function(arg)
				if not arg then
					return "Common"
				end
				local v7 = getAssetDirectory()

				if v7 and v7[arg] then
					local v8 = v7[arg]

					if v8.Rarity then
						if type(v8.Rarity) == "string" then
							return v8.Rarity
						end

						if type(v8.Rarity) == "table" then
							local displayName = v8.Rarity.DisplayName or v8.Rarity.Name
							if displayName then
								return displayName
							end
						end
					end
				end

				return tbl9[stealManager.GetEggRarityNumber(arg)] or "Common"
			end

			stealManager.GetEggFormattedName = function(arg)
				if not arg then
					return "Unknown"
				end
				local assetCategory = arg.AssetCategory or arg.Category or arg.Name or "Unknown"
				local v7 = stealManager.GetEggDisplayName(assetCategory)
				local v8 = stealManager.GetEggRarityName(assetCategory)
				return string.format("%s [%s]", v7, v8)
			end

			stealManager.SpecificEggLookup = {}
			stealManager.HasSpecificEggFilters = false

			stealManager.RebuildSpecificEggLookup = function()
				local specificEggLookup = {}
				local v7 = pairs
				local specificEggFilters = stealManager.SpecificEggFilters or {}
				local n = 0
				local flag = false

				for k, specificEggFilter in v7(specificEggFilters) do
					if not (specificEggFilter == true and type(k) == "string") then
						k = nil

						if type(specificEggFilter) == "string" then
							k = specificEggFilter
						end
					end

					if k and #k > 0 then
						local v8 = string.lower(k)

						if v8 == "all" or v8 == "semua" then
							flag = true
							break
						else
							n += 1
							specificEggLookup[v8] = true
							local str = (string.match(v8, "^(.-)%s*%[") or v8):gsub("^%s*(.-)%s*$", "%1")

							if #str > 0 then
								specificEggLookup[str] = true
								specificEggLookup[str:gsub("%s+", "")] = true
							end
						end
					end
				end

				if flag or n == 0 then
					stealManager.HasSpecificEggFilters = false
					stealManager.SpecificEggLookup = {}
				else
					stealManager.HasSpecificEggFilters = true
					stealManager.SpecificEggLookup = specificEggLookup
				end
			end

			stealManager.IsSpecificEggSelected = function(arg)
				if not stealManager.HasSpecificEggFilters then
					return true
				end

				if not arg then
					return false
				end
				local assetCategory = arg.AssetCategory
				if not assetCategory then
					return false
				end
				local specificEggLookup = stealManager.SpecificEggLookup
				if not specificEggLookup then
					return true
				end
				local v7 = string.lower(assetCategory)
				if specificEggLookup[v7] or specificEggLookup[v7:gsub("%s+", "")] then
					return true
				end
				local v8 = stealManager.GetEggDisplayName(assetCategory)

				if v8 then
					local v9 = string.lower(v8)
					if specificEggLookup[v9] or specificEggLookup[v9:gsub("%s+", "")] then
						return true
					end
				end

				return false
			end

			stealManager.GetEggWeight = function(arg)
				if not arg then
					return 0
				end
				local n = tonumber(arg.AssetScale) or tonumber(arg.Scale) or 1
				local assetCategory = arg.AssetCategory and tbl7 and tbl7[arg.AssetCategory]
				local n2 = 1

				if assetCategory then
					local v7 = tbl7[arg.AssetCategory]

					if type(v7.ModelWeight) == "number" then
						n2 = v7.ModelWeight
					end
				end

				return n2 * n ^ 3
			end

			stealManager.GetEggIncome = function(arg)
				if not arg then
					return 0
				end
				local assetCategory = arg.AssetCategory and tbl7 and tbl7[arg.AssetCategory]
				local n = 0

				if assetCategory then
					n = tonumber(tbl7[arg.AssetCategory].EarningRate) or 0
				end

				if n <= 0 then
					return 0
				end
				local n2 = tonumber(arg.AssetScale) or tonumber(arg.Scale) or 1
				local n3

				if n2 <= 5 then
					n3 = n2 ^ 1.85
				else
					n3 = (n2 / 5) ^ 1.2 * 19.637875755794113
				end

				return n * n3
			end

			stealManager.CalculateEggScore = function(arg, arg2)
				local v7 = stealManager.GetEggRarityNumber(arg)
				local n = tonumber(arg.AssetScale) or tonumber(arg.Scale) or 1
				local n2 = arg.State == "Dropped" and 50000000 or 0
				local flag

				if arg.BaseMutation and arg.BaseMutation ~= "" then
					flag = true
				else
					local flag2 = type(arg.Mutations) == "table" and #arg.Mutations > 0
					flag = false

					if flag2 then
						flag = true
					end
				end

				if stealManager.Priority == "Mutation" then
					return n2 + (flag and 10000000 or 0) + v7 * 100000 + n * 1000 - arg2 * 0.1
				end

				if stealManager.Priority == "Best Weight" then
					local n3 = n2 + stealManager.GetEggWeight(arg) * 1000 + v7 * 10000
					flag = flag and 5000 or 0
					return n3 + flag - arg2 * 0.1
				end

				if stealManager.Priority == "Highest Money/Sec" then
					local n3 = n2 + stealManager.GetEggIncome(arg) * 1000 + v7 * 10000
					flag = flag and 5000
					return n3 + (flag or 0) - arg2 * 0.1
				end

				if stealManager.Priority == "Lowest Money/Sec" then
					local v8 = stealManager.GetEggIncome(arg)
					local n3 = n2 + v7 * 10000
					flag = flag and 5000 or 0
					return n3 + flag - v8 * 1000 - arg2 * 0.1
				end

				return n2 + v7 * 1000000 + (flag and 50000 or 0) + n * 1000 - arg2 * 0.1
			end

			local raycastParams = RaycastParams.new()
			raycastParams.FilterType = Enum.RaycastFilterType.Exclude

			stealManager.GetGroundPosition = function(arg)
				if not arg then
					return arg
				end

				if localPlayer.Character then
					raycastParams.FilterDescendantsInstances = { localPlayer.Character }
				end

				local hit = workspace:Raycast(Vector3.new(arg.X, arg.Y + 10, arg.Z), Vector3.new(0, -40, 0), raycastParams)
				if hit then
					local humanoid2 = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")
					return Vector3.new(arg.X, hit.Position.Y + (humanoid2 and humanoid2.HipHeight > 0 and humanoid2.HipHeight + 0.8 or 2.8), arg.Z)
				end
				return arg
			end

			stealManager.GetSafeZone = function()
				local world = workspace:FindFirstChild("World")
				local build = world and world:FindFirstChild("Build")
				build = build and build:FindFirstChild("MainMap")
				build = build and build:FindFirstChild("SpawnTarget")

				if build then
					local position

					if build:IsA("BasePart") then
						position = build.Position
					elseif build:IsA("Attachment") then
						position = build.WorldPosition
					else
						position = nil

						if build:IsA("Model") then
							position = build.PrimaryPart
							position = position and position.Position
						end
					end

					if position then
						return position + Vector3.new(0, -5, 0)
					end
				end

				local areas = world and world:FindFirstChild("Areas")
				areas = areas and areas:FindFirstChild("StartArea")

				if areas then
					if areas:IsA("BasePart") then
						return areas.Position + Vector3.new(0, 2.5, 0)
					end

					if areas:IsA("Model") then
						local primaryPart = areas.PrimaryPart
						if primaryPart then
							return primaryPart.Position + Vector3.new(0, 2.5, 0)
						end
					end
				end

				return Vector3.new(515, 74.4, -362.8)
			end

			stealManager.GetSpawnTarget = stealManager.GetSafeZone

			stealManager.IsInSafeZone = function()
				local character2 = localPlayer.Character
				character2 = character2 and character2:FindFirstChild("HumanoidRootPart")
				local separationLine = workspace.World.Areas:FindFirstChild("SeparationLine")
				local startArea = workspace.World.Areas:FindFirstChild("StartArea")
				if not character2 or not separationLine or not startArea then
					return false
				end

				if not separationLine:IsA("BasePart") or not startArea:IsA("BasePart") then
					return false
				end
				local cFrame = separationLine.CFrame
				local flag = cFrame:PointToObjectSpace(character2.Position).Z >= 0
				return cFrame:PointToObjectSpace(startArea.Position).Z >= 0 == flag
			end

			local ToolGameplayGuard = nil

			pcall(function()
				ToolGameplayGuard = require(replicatedStorage.Client.ToolGameplayGuard)
			end)

			stealManager.IsInSafeZoneArea = function()
				local ok, result = pcall(function()
					if ToolGameplayGuard and ToolGameplayGuard.IsInsideSafeZone then
						return ToolGameplayGuard.IsInsideSafeZone(localPlayer)
					end
				end)

				if ok and result ~= nil then
					return result == true
				end

				local ok2, result2 = pcall(function()
					if ToolGameplayGuard and ToolGameplayGuard.IsLocalInsideArena then
						return not ToolGameplayGuard.IsLocalInsideArena()
					end
				end)

				if ok2 and result2 ~= nil then
					return result2 == true
				end
				return stealManager.IsInSafeZone()
			end

			stealManager.IsGroundedInSafeZone = function(arg)
				local humanoidRootPart2 = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
				if not humanoidRootPart2 then
					return false
				end
				local v7 = arg or stealManager.GetSafeZone()
				local magnitude = (Vector3.new(humanoidRootPart2.Position.X, 0, humanoidRootPart2.Position.Z) - Vector3.new(v7.X, 0, v7.Z)).Magnitude
				local n = math.abs(humanoidRootPart2.Position.Y - v7.Y)
				return magnitude <= 30 and n <= 8 or stealManager.IsInSafeZoneArea() and magnitude <= 40 and n <= 8
			end

			stealManager.BaseFor = function()
				return stealManager.GetSafeZone()
			end

			stealManager.Speed = 350
			stealManager.FlightY = 78
			stealManager.Timeout = 2.5
			stealManager.IsStealing = false
			stealManager.GotEgg = false
			stealManager.ClaimHookDone = false
			stealManager.CarryHookDone = false
			stealManager.FailCounts = {}

			stealManager.EnsureAtSafeZone = function(arg)
				local humanoidRootPart2 = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
				local humanoid2 = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")
				if not humanoidRootPart2 then
					return false
				end

				if humanoid2 then
					stealManager.ResetHumanoidState(humanoid2)
				end

				local v7 = stealManager.GetSafeZone()
				local magnitude = (humanoidRootPart2.Position - v7).Magnitude
				local flag = not arg
				local flag2

				if flag then
					flag2 = magnitude <= 65 or stealManager.IsInSafeZone()
				else
					flag2 = flag
				end

				if flag2 then
					return true
				end
				_G.LastAction = string.format("Steal: Karakter di luar SafeZone (%.0f studs). Meluncur kembali via Tween...", magnitude)
				stealManager.TweenTo(Vector3.new(v7.X, stealManager.FlightY or 78, v7.Z), math.max(stealManager.Speed or 650, 750), { Owner = "Steal" })
				stealManager.TweenTo(v7, math.max(stealManager.Speed or 650, 400), { Owner = "Steal" })
				local humanoidRootPart3 = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")

				if humanoidRootPart3 then
					humanoidRootPart3.AssemblyLinearVelocity = Vector3.zero
					humanoidRootPart3.AssemblyAngularVelocity = Vector3.zero
				end

				task.wait(0.25)
				return true
			end

			stealManager.EnsureClaimHook = function()
				if stealManager.ClaimHookDone then
					return
				end

				pcall(function()
					local ReplicatedStorage = game:GetService("ReplicatedStorage")
					local EggState = ReplicatedStorage:FindFirstChild("Client") and ReplicatedStorage.Client:FindFirstChild("EggState") and require(ReplicatedStorage.Client.EggState)

					if EggState and EggState.FieldClaimed then
						EggState.FieldClaimed:Connect(function()
							farmState.ClaimedAt = os.clock()
							stealManager.GotEgg = false
							farmState.Carrying = false
							farmState.CarriedUid = nil
							farmState.CarriedAssetCategory = nil
							farmState.OptimisticCarry = false
						end)

						stealManager.ClaimHookDone = true
					end

					local networking = ReplicatedStorage:FindFirstChild("Packages") and ReplicatedStorage.Packages:FindFirstChild("Networking")

					if networking then
						for _, child in ipairs(networking:GetChildren()) do
							local isRemoteEvent = child:IsA("RemoteEvent")
							local v7

							if isRemoteEvent then
								v7 = string.find(child.Name, "Claim", 1, true) or string.find(child.Name, "FieldEggClaim", 1, true)
							else
								v7 = isRemoteEvent
							end

							if v7 then
								child.OnClientEvent:Connect(function()
									farmState.ClaimedAt = os.clock()
									stealManager.GotEgg = false
									farmState.Carrying = false
								end)
							end
						end
					end
				end)
			end

			stealManager.EnsureCarryHook = function()
				if stealManager.CarryHookDone then
					return
				end

				local function handleCarryStateUpdate(...)
					local v7 = ({ ... })[1]

					if type(v7) == "table" then
						local gotEgg = v7.IsCarrying == true
						stealManager.GotEgg = gotEgg
						farmState.Carrying = gotEgg

						if gotEgg then
							farmState.CarriedUid = tostring(v7.Uid or farmState.CarriedUid or "")

							if v7.AssetCategory then
								farmState.CarriedAssetCategory = v7.AssetCategory
							end
						else
							farmState.CarriedUid = nil
							farmState.CarriedAssetCategory = nil
							farmState.OptimisticCarry = false
						end
					end
				end

				pcall(function()
					local networking = replicatedStorage:FindFirstChild("Packages") and replicatedStorage.Packages:FindFirstChild("Networking")
					networking = networking and networking:FindFirstChild("RE/EggWorld/FieldEggCarry")

					if networking and networking:IsA("RemoteEvent") then
						networking.OnClientEvent:Connect(handleCarryStateUpdate)
					end
				end)

				pcall(function()
					local remotes = modules.Game and modules.Game.Remotes or replicatedStorage:FindFirstChild("Shared") and replicatedStorage.Shared:FindFirstChild("Remotes") and require(replicatedStorage.Shared.Remotes)

					if remotes and remotes.EggWorld and remotes.EggWorld.FieldEggCarry then
						remotes.EggWorld.FieldEggCarry.OnClientEvent:Connect(handleCarryStateUpdate)
					end
				end)

				pcall(function()
					local ReplicatedStorage = game:GetService("ReplicatedStorage")
					local eggState = modules.Game and modules.Game.EggState
					local EggState

					if eggState then
						EggState = eggState
					else
						EggState = ReplicatedStorage:FindFirstChild("Client") and ReplicatedStorage.Client:FindFirstChild("EggState") and require(ReplicatedStorage.Client.EggState)
					end

					if EggState and EggState.CarryChanged then
						EggState.CarryChanged:Connect(function(arg)
							if arg and arg.IsCarrying ~= nil then
								stealManager.GotEgg = arg.IsCarrying
								farmState.Carrying = arg.IsCarrying

								if arg.IsCarrying then
									if arg.Uid then
										farmState.CarriedUid = arg.Uid
									end

									if arg.AssetCategory then
										farmState.CarriedAssetCategory = arg.AssetCategory
									end
								else
									farmState.CarriedUid = nil
									farmState.CarriedAssetCategory = nil
									farmState.OptimisticCarry = false
								end
							end
						end)
					end
				end)

				stealManager.CarryHookDone = true
			end

			stealManager.EggInHand = function()
				local playerGui2 = playerGui or localPlayer and localPlayer:FindFirstChild("PlayerGui")
				local dropHeldEgg = playerGui2 and playerGui2:FindFirstChild("DropHeldEgg")

				if dropHeldEgg then
					local ok, result = pcall(function()
						return dropHeldEgg.Enabled
					end)

					if ok and result then
						return true
					end
				end

				return false
			end

			stealManager.IsCarryingTargetEgg = function(arg)
				if not arg or arg == "" then
					if farmState and farmState.Carrying then
						return true
					end

					if stealManager.GotEgg then
						return true
					end

					if stealManager.EggInHand() then
						return true
					end
					return false
				end

				local str = tostring(arg)
				if farmState and farmState.Carrying and farmState.CarriedUid == str then
					return true
				end

				if stealManager.GotEgg and farmState and farmState.CarriedUid == str then
					return true
				end

				local ok, result = pcall(function()
					local ReplicatedStorage = game:GetService("ReplicatedStorage")
					local eggState = modules.Game and modules.Game.EggState or ReplicatedStorage:FindFirstChild("Client") and ReplicatedStorage.Client:FindFirstChild("EggState") and require(ReplicatedStorage.Client.EggState)

					if eggState and eggState.ReadFieldEgg then
						local v7 = eggState.ReadFieldEgg(str)
						if v7 and v7.CarrierUserId == localPlayer.UserId then
							return true
						end
					end

					return false
				end)

				if ok and result then
					return true
				end

				local ok2, result2 = pcall(function()
					local eggCmds = modules.Game and modules.Game.EggCmds
					local getAreaEggSnapshot = eggCmds and eggCmds.GetAreaEggSnapshot and eggCmds.GetAreaEggSnapshot()

					if getAreaEggSnapshot and type(getAreaEggSnapshot.Records) == "table" then
						for _, record in ipairs(getAreaEggSnapshot.Records) do
							if record.CarrierUserId == localPlayer.UserId and record.Uid == str then
								return true
							end
						end
					end

					return false
				end)

				if ok2 and result2 then
					return true
				end
				local character2 = localPlayer.Character

				if character2 then
					for _, child in ipairs(character2:GetChildren()) do
						if child:IsA("Tool") and child:GetAttribute("ItemType") == "AssetEgg" then
							local attribute = child:GetAttribute("UID")
							if attribute and tostring(attribute) == str then
								return true
							end
						end
					end
				end

				local backpack = localPlayer:FindFirstChildOfClass("Backpack")

				if backpack then
					for _, child in ipairs(backpack:GetChildren()) do
						if child:IsA("Tool") and child:GetAttribute("ItemType") == "AssetEgg" then
							local attribute = child:GetAttribute("UID")
							if attribute and tostring(attribute) == str then
								return true
							end
						end
					end
				end

				return false
			end

			stealManager.ImmortalConnections = { HealthChanged = nil, CharacterRemoving = nil, StateChanged = nil }

			stealManager.GoToSafeZone = function(arg, arg2)
				local character2 = localPlayer.Character
				local humanoidRootPart2 = character2 and character2:FindFirstChild("HumanoidRootPart")
				if not humanoidRootPart2 then
					return false
				end

				if stealManager.IsNightOrWallClosed and stealManager.IsNightOrWallClosed() and (not arg or arg < 100) or not arg then
					arg = 300
				end

				local v7 = stealManager.GetSafeZone()
				if (humanoidRootPart2.Position - v7).Magnitude <= 15 then
					return true
				end
				local getPlot = modules.Game and modules.Game.GetPlot and modules.Game.GetPlot() or require(replicatedStorage.Library.Client.PlotCmds).GetPlotData()

				if modules.Treadmill and (modules.Treadmill.CheckTreadmil and modules.Treadmill.CheckTreadmil() or enabled["Auto Treadmill"]) then
					local treadmillBottom = getPlot and getPlot.PlotFolder and getPlot.PlotFolder:FindFirstChild("TreadmillBottom")

					if treadmillBottom and (humanoidRootPart2.Position - treadmillBottom.Position).Magnitude < 15 then
						modules.Treadmill.ExitToSafeZone()
						task.wait(0.2)
					end
				end

				local humanoidRootPart3 = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
				if not humanoidRootPart3 then
					return false
				end

				if getPlot and getPlot.CenterPoint then
					local n = getPlot.CenterPoint.Position + Vector3.new(0, 2.8, 0)
					local magnitude = (humanoidRootPart3.Position - n).Magnitude

					if magnitude < 75 and (humanoidRootPart3.Position - v7).Magnitude > 18 and magnitude > 6 then
						stealManager.TweenTo(n, arg, { Owner = arg2 or "SafeZone" })
						task.wait(0.1)
					end
				end

				local humanoidRootPart4 = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")

				if humanoidRootPart4 and (humanoidRootPart4.Position - v7).Magnitude > 15 then
					stealManager.TweenTo(v7, arg, { Owner = arg2 or "SafeZone" })
					task.wait(0.1)
				end

				if modules.Treadmill and modules.Treadmill.CheckTreadmil and modules.Treadmill.CheckTreadmil() then
					_G.LastAction = "SafeZone: Unstick from Treadmill"

					if modules.Treadmill.Unequip then
						modules.Treadmill.Unequip()
					end

					task.wait(0.05)
				end

				return true
			end

			stealManager.ResetHumanoidState = function(arg)
				if not arg then
					return
				end

				pcall(function()
					if arg.PlatformStand then
						arg.PlatformStand = false
					end

					if arg.Sit then
						arg.Sit = false
					end

					local state = arg:GetState()

					if state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown or state == Enum.HumanoidStateType.Physics then
						arg:ChangeState(Enum.HumanoidStateType.GettingUp)
						arg:ChangeState(Enum.HumanoidStateType.Running)
					end

					local humanoidRootPart2 = arg.Parent and arg.Parent:FindFirstChild("HumanoidRootPart")

					if humanoidRootPart2 then
						humanoidRootPart2.CanCollide = true
						humanoidRootPart2.AssemblyLinearVelocity = Vector3.zero
						humanoidRootPart2.AssemblyAngularVelocity = Vector3.zero
					end
				end)
			end

			stealManager.GetWalkSpeed = function()
				local humanoid2 = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")
				humanoid2 = humanoid2 and humanoid2.WalkSpeed
				if humanoid2 and humanoid2 > 0 then
					return humanoid2
				end
				return 16
			end

			stealManager.CachedRunAnimId = nil
			stealManager.CurrentRunTrack = nil
			stealManager.CurrentRunTracks = {}
			stealManager.RunAnimConnection = nil
			stealManager.CurrentAnimSpeed = 300

			stealManager.GetRunAnimationId = function()
				if stealManager.CachedRunAnimId and stealManager.CachedRunAnimId ~= "" then
					return stealManager.CachedRunAnimId
				end
				local character2 = localPlayer.Character
				local animate = character2 and character2:FindFirstChild("Animate")

				if animate then
					local run = animate:FindFirstChild("run")
					local animation = run and (run:FindFirstChildWhichIsA("Animation") or run:FindFirstChild("RunAnim"))
					if animation and animation.AnimationId and animation.AnimationId ~= "" then
						stealManager.CachedRunAnimId = animation.AnimationId
						return animation.AnimationId
					end
					local walk = animate:FindFirstChild("walk")

					if walk then
						walk = walk:FindFirstChildWhichIsA("Animation") or walk:FindFirstChild("WalkAnim")
					end

					if walk and walk.AnimationId and walk.AnimationId ~= "" then
						stealManager.CachedRunAnimId = walk.AnimationId
						return walk.AnimationId
					end
				end

				character2 = character2 and character2:FindFirstChildOfClass("Humanoid")
				if character2 and character2.RigType == Enum.HumanoidRigType.R6 then
					stealManager.CachedRunAnimId = "rbxassetid://180426354"
					return "rbxassetid://180426354"
				end
				stealManager.CachedRunAnimId = "rbxassetid://913376220"
				return "rbxassetid://913376220"
			end

			stealManager.StartRunAnimation = function(arg)
				if not enabled["Run Animation"] then
					return
				end
				local character2 = localPlayer.Character
				if not character2 then
					return
				end
				local humanoid2 = character2:FindFirstChildOfClass("Humanoid")
				local currentAnimSpeed = tonumber(arg) or tonumber(stealManager.Speed) or 350
				stealManager.CurrentAnimSpeed = currentAnimSpeed
				local v7 = stealManager.GetRunAnimationId()
				local flag

				if v7 then
					flag = not (stealManager.CurrentRunTrack and stealManager.CurrentRunTrack.IsPlaying)
				else
					flag = v7
				end

				if flag then
					pcall(function()
						local animation = Instance.new("Animation")
						animation.AnimationId = v7
						local animator = humanoid2 and (humanoid2:FindFirstChildOfClass("Animator") or humanoid2)

						if animator then
							local v8 = animator:LoadAnimation(animation)
							v8.Priority = Enum.AnimationPriority.Action4
							v8.Looped = true
							v8:Play(0.1)
							v8:AdjustSpeed(math.clamp(currentAnimSpeed / 60, 1, 4.5))
							stealManager.CurrentRunTrack = v8
						end

						animation:Destroy()
					end)
				end

				if not stealManager.RunAnimConnection then
					local now = os.clock()

					stealManager.RunAnimConnection = runService.RenderStepped:Connect(function()
						if not enabled["Run Animation"] then
							return
						end
						local character3 = localPlayer.Character
						if not character3 then
							return
						end
						local n = math.clamp((tonumber(stealManager.CurrentAnimSpeed) or 300) * 0.05, 10, 22)
						local n2 = (os.clock() - now) * n

						if humanoid2 and humanoid2.RigType == Enum.HumanoidRigType.R6 or character3:FindFirstChild("Torso") ~= nil then
							local torso = character3:FindFirstChild("Torso")

							if torso then
								local rootJoint = torso:FindFirstChild("RootJoint")
								local neck = torso:FindFirstChild("Neck")
								local rightShoulder = torso:FindFirstChild("Right Shoulder")
								local leftShoulder = torso:FindFirstChild("Left Shoulder")
								local rightHip = torso:FindFirstChild("Right Hip")
								local leftHip = torso:FindFirstChild("Left Hip")
								local v8 = math.sin(n2)
								local n3 = math.abs(v8) * 0.25

								if rootJoint then
									rootJoint.Transform = CFrame.new(0, n3, 0) * CFrame.Angles(0.17453292519943295, 0, -v8 * 0.08)
								end

								if neck then
									neck.Transform = CFrame.Angles(-0.087266462599716474, 0, 0)
								end

								if rightShoulder then
									rightShoulder.Transform = CFrame.Angles(v8 * 0.9, 0, 0.10471975511965978)
								end

								if leftShoulder then
									leftShoulder.Transform = CFrame.Angles(-v8 * 0.9, 0, -0.10471975511965978)
								end

								if rightHip then
									rightHip.Transform = CFrame.Angles(-v8 * 1, 0, 0)
								end

								if leftHip then
									leftHip.Transform = CFrame.Angles(v8 * 1, 0, 0)
								end
							end
						else
							local lowerTorso = character3:FindFirstChild("LowerTorso")
							local upperTorso = character3:FindFirstChild("UpperTorso")
							local head = character3:FindFirstChild("Head")
							local rightUpperArm = character3:FindFirstChild("RightUpperArm")
							local rightLowerArm = character3:FindFirstChild("RightLowerArm")
							local leftUpperArm = character3:FindFirstChild("LeftUpperArm")
							local leftLowerArm = character3:FindFirstChild("LeftLowerArm")
							local rightUpperLeg = character3:FindFirstChild("RightUpperLeg")
							local rightLowerLeg = character3:FindFirstChild("RightLowerLeg")
							local leftUpperLeg = character3:FindFirstChild("LeftUpperLeg")
							local leftLowerLeg = character3:FindFirstChild("LeftLowerLeg")
							local v8 = math.sin(n2)
							local n3 = math.abs(v8) * 0.25

							if lowerTorso then
								local root = lowerTorso:FindFirstChild("Root")

								if root then
									root.Transform = CFrame.new(0, n3, 0) * CFrame.Angles(0.17453292519943295, 0, -v8 * 0.08)
								end
							end

							if upperTorso then
								local waist = upperTorso:FindFirstChild("Waist")

								if waist then
									waist.Transform = CFrame.Angles(0.087266462599716474, 0, v8 * 0.05)
								end
							end

							if head then
								local neck = head:FindFirstChild("Neck")

								if neck then
									neck.Transform = CFrame.Angles(-0.13962634015954636, 0, 0)
								end
							end

							if rightUpperArm then
								local rightShoulder = rightUpperArm:FindFirstChild("RightShoulder")

								if rightShoulder then
									rightShoulder.Transform = CFrame.Angles(v8 * 0.9, 0, 0.10471975511965978)
								end
							end

							if rightLowerArm then
								local rightElbow = rightLowerArm:FindFirstChild("RightElbow")

								if rightElbow then
									rightElbow.Transform = CFrame.Angles(math.clamp(-v8 * 0.8, 0, 1.2), 0, 0)
								end
							end

							if leftUpperArm then
								local leftShoulder = leftUpperArm:FindFirstChild("LeftShoulder")

								if leftShoulder then
									leftShoulder.Transform = CFrame.Angles(-v8 * 0.9, 0, -0.10471975511965978)
								end
							end

							if leftLowerArm then
								local leftElbow = leftLowerArm:FindFirstChild("LeftElbow")

								if leftElbow then
									leftElbow.Transform = CFrame.Angles(math.clamp(v8 * 0.8, 0, 1.2), 0, 0)
								end
							end

							if rightUpperLeg then
								local rightHip = rightUpperLeg:FindFirstChild("RightHip")

								if rightHip then
									rightHip.Transform = CFrame.Angles(-v8 * 1, 0, 0)
								end
							end

							if rightLowerLeg then
								local rightKnee = rightLowerLeg:FindFirstChild("RightKnee")

								if rightKnee then
									rightKnee.Transform = CFrame.Angles(math.clamp(v8 * 1.2, 0, 1.4), 0, 0)
								end
							end

							if leftUpperLeg then
								local leftHip = leftUpperLeg:FindFirstChild("LeftHip")

								if leftHip then
									leftHip.Transform = CFrame.Angles(v8 * 1, 0, 0)
								end
							end

							if leftLowerLeg then
								local leftKnee = leftLowerLeg:FindFirstChild("LeftKnee")

								if leftKnee then
									leftKnee.Transform = CFrame.Angles(math.clamp(-v8 * 1.2, 0, 1.4), 0, 0)
								end
							end
						end
					end)
				end
			end

			stealManager.StopRunAnimation = function()
				if stealManager.RunAnimConnection then
					pcall(function()
						stealManager.RunAnimConnection:Disconnect()
					end)

					stealManager.RunAnimConnection = nil
				end

				local character2 = localPlayer.Character

				if character2 then
					for _, descendant in ipairs(character2:GetDescendants()) do
						if descendant:IsA("Motor6D") then
							pcall(function()
								descendant.Transform = CFrame.identity
							end)
						end
					end
				end

				if stealManager.CurrentRunTracks then
					for _, currentRunTrack in ipairs(stealManager.CurrentRunTracks) do
						pcall(function()
							if currentRunTrack.IsPlaying then
								currentRunTrack:Stop(0.15)
							end

							currentRunTrack:Destroy()
						end)
					end

					stealManager.CurrentRunTracks = {}
				end

				if stealManager.CurrentRunTrack then
					pcall(function()
						if stealManager.CurrentRunTrack.IsPlaying then
							stealManager.CurrentRunTrack:Stop(0.15)
						end

						stealManager.CurrentRunTrack:Destroy()
					end)

					stealManager.CurrentRunTrack = nil
				end
			end

			stealManager.TweenTo = function(arg, arg2, arg3)
				local tbl11 = arg3 or {}
				local character2 = localPlayer.Character
				local humanoidRootPart2 = character2 and character2:FindFirstChild("HumanoidRootPart")
				local humanoid2 = character2 and character2:FindFirstChildOfClass("Humanoid")
				if not humanoidRootPart2 then
					return false
				end

				if humanoid2 then
					stealManager.ResetHumanoidState(humanoid2)
				end

				if stealManager.ApplyAntiTpBypass then
					stealManager.ApplyAntiTpBypass()
				else
					pcall(function()
						workspace:SetAttribute("ClientObbyAntiTp", false)
					end)
				end

				local speed = arg2 or tbl11.Owner == "Steal" and (stealManager.Speed or 350) or stealManager.GetWalkSpeed()
				local position = humanoidRootPart2.Position
				local magnitude = (arg - position).Magnitude
				if magnitude <= 0.5 then
					return true
				end
				local runAnimation = enabled["Run Animation"]
				local flag

				if runAnimation then
					flag = tbl11.Owner == "Steal" or tbl11.Owner == "SafeZone"
				else
					flag = runAnimation
				end

				if flag then
					stealManager.StartRunAnimation(speed)
				end

				local n = magnitude / math.max(speed, 5)
				local now = os.clock()
				local vector = Vector3.new(arg.X - position.X, 0, arg.Z - position.Z)
				local unit = vector.Magnitude > 0.1 and vector.Unit or humanoidRootPart2.CFrame.LookVector

				pcall(function()
					for _, child in ipairs(character2:GetChildren()) do
						if child:IsA("BasePart") then
							child.CanCollide = false
						end
					end
				end)

				local n2 = 0
				local n3 = 0
				local vector2 = position
				local flag2

				while true do
					local flag3 = tbl11.Owner == "Steal" and not enabled["Auto Steal"]
					local exitTo = nil
					local midFlightStealSlotKey, now2, n4, midFlightStealInterval, midFlightStealTarget, midFlightStealSlotKey2, midFlightStealTarget2, flag4, flag5, currentRunTrack, isPlaying, checkTreadmil, humanoid3, character3, n5, v7, n6, n7, cframe

					while true do
						flag2 = false

						if flag3 then
							break
						else
							local exitTo2 = nil
							local lastHitAt, flag6, targetEggUid, flag7

							while true do
								if not (tbl11.Owner == "PlaceEgg" and not enabled["Auto Place Egg"]) then
									if not (tbl11.Owner == "Treadmill" and not enabled["Auto Treadmill"]) then
										local flag8 = tbl11.Owner == "Sell"

										if flag8 then
											flag8 = not (enabled["Auto Sell Pet"] or enabled["Auto Sell Egg"])
										end

										if not flag8 then
											if not (tbl11.Owner == "ScrambleDrone" and not enabled["Auto Farm Drones"]) then
												local flag9, flag10

												if tbl11.Owner and tbl11.Owner ~= "SafeZone" and modules.Movement then
													local v8 = modules.Movement.GetOwner()

													if not (v8 and v8 ~= tbl11.Owner) then
														flag9 = tbl11.AbortOnStealTarget and os.clock() - n2 >= 0.25

														if flag9 then
															n2 = os.clock()
															flag10 = enabled["Auto Steal"] and stealManager.PickTarget and stealManager.PickTarget() ~= nil

															if not flag10 then
																lastHitAt = tbl11.AbortOnGuardHit and stealManager.LastHitAt
																flag6 = lastHitAt and stealManager.LastHitAt > now

																if not flag6 then
																	targetEggUid = tbl11.AbortOnEggDrop and tbl11.TargetEggUid

																	if targetEggUid then
																		flag7 = not stealManager.IsCarryingTargetEgg(tbl11.TargetEggUid) and not stealManager.IsInSafeZone()

																		if not flag7 then
																			midFlightStealSlotKey = tbl11.MidFlightStealTarget and tbl11.MidFlightStealSlotKey

																			if midFlightStealSlotKey then
																				now2 = os.clock()
																				n4 = now2 - n3
																				midFlightStealInterval = tbl11.MidFlightStealInterval or 0.5

																				if midFlightStealInterval <= n4 then
																					midFlightStealTarget = tbl11.MidFlightStealTarget
																					midFlightStealSlotKey2 = tbl11.MidFlightStealSlotKey

																					task.spawn(function()
																						pcall(function()
																							local remotes = modules.Game and modules.Game.Remotes

																							if not remotes then
																								remotes = replicatedStorage:FindFirstChild("Shared") and replicatedStorage.Shared:FindFirstChild("Remotes") and require(replicatedStorage.Shared.Remotes)
																							end

																							if remotes and remotes.EggWorld and remotes.EggWorld.AskFieldEggCarry then
																								remotes.EggWorld.AskFieldEggCarry:InvokeServer({ Uid = midFlightStealTarget, FirstAreaSlotKey = midFlightStealSlotKey2 })
																							end
																						end)
																					end)

																					n3 = now2
																				end
																			end

																			midFlightStealTarget2 = tbl11.AbortOnEggGrab and tbl11.MidFlightStealTarget

																			if midFlightStealTarget2 then
																				if stealManager.IsCarryingTargetEgg(tbl11.MidFlightStealTarget) then
																					exitTo2 = 13
																					break
																				else
																					flag4 = enabled["Run Animation"] and (tbl11.Owner == "Steal" or tbl11.Owner == "SafeZone")

																					if flag4 then
																						flag5 = not stealManager.RunAnimConnection

																						if flag5 then
																							currentRunTrack = stealManager.CurrentRunTrack
																							isPlaying = currentRunTrack and stealManager.CurrentRunTrack.IsPlaying
																							flag5 = not isPlaying
																						end

																						if flag5 then
																							stealManager.StartRunAnimation(speed)
																						end
																					end

																					checkTreadmil = tbl11.Owner ~= "Treadmill" and modules.Treadmill and modules.Treadmill.CheckTreadmil and modules.Treadmill.CheckTreadmil()

																					if checkTreadmil then
																						humanoid3 = currentChar and currentChar:FindFirstChildOfClass("Humanoid")

																						if humanoid3 then
																							pcall(function()
																								humanoid3.Jump = true
																								humanoid3:ChangeState(Enum.HumanoidStateType.Jumping)
																							end)
																						end

																						pcall(function()
																							if modules.Game and modules.Game.Remotes and modules.Game.Remotes.Treadmill and modules.Game.Remotes.Treadmill.AskDoff then
																								modules.Game.Remotes.Treadmill.AskDoff:InvokeServer()
																							elseif replicatedStorage:FindFirstChild("Network") and replicatedStorage.Network:FindFirstChild("Treadmills: RequestUnequip") then
																								replicatedStorage.Network["Treadmills: RequestUnequip"]:InvokeServer()
																							end
																						end)
																					end

																					character3 = localPlayer.Character
																					character3 = character3 and character3:FindFirstChild("HumanoidRootPart")

																					if character3 then
																						n5 = math.clamp((os.clock() - now) / n, 0, 1)
																						v7 = position:Lerp(arg, n5)

																						if (v7 - vector2).Magnitude > 35 then
																							n6 = vector2 + (v7 - vector2).Unit * 35
																						else
																							n6 = v7
																						end

																						n7 = math.min(position.Y, arg.Y)

																						if not (n6.Y < n7) then
																							vector2 = n6
																						else
																							vector2 = Vector3.new(n6.X, n7, n6.Z)
																						end

																						cframe = vector.Magnitude > 0.1 and CFrame.lookAt(vector2, vector2 + unit) or CFrame.new(vector2)
																						character3.CFrame = cframe
																						character3.AssemblyLinearVelocity = Vector3.zero
																						character3.AssemblyAngularVelocity = Vector3.zero

																						if n5 >= 1 then
																							exitTo2 = 14
																							break
																						else
																							runService.Heartbeat:Wait()
																							flag3 = tbl11.Owner == "Steal"

																							if flag3 then
																								flag3 = not enabled["Auto Steal"]
																								flag2 = false
																								if not flag3 then
																									continue
																								end
																							else
																								flag2 = false
																								if not flag3 then
																									continue
																								end
																							end
																						end
																					end
																				end
																			else
																				flag4 = enabled["Run Animation"] and (tbl11.Owner == "Steal" or tbl11.Owner == "SafeZone")

																				if flag4 then
																					flag5 = not stealManager.RunAnimConnection

																					if flag5 then
																						currentRunTrack = stealManager.CurrentRunTrack
																						isPlaying = currentRunTrack and stealManager.CurrentRunTrack.IsPlaying
																						flag5 = not isPlaying
																					end

																					if flag5 then
																						stealManager.StartRunAnimation(speed)
																					end
																				end

																				checkTreadmil = tbl11.Owner ~= "Treadmill" and modules.Treadmill and modules.Treadmill.CheckTreadmil and modules.Treadmill.CheckTreadmil()

																				if checkTreadmil then
																					humanoid3 = currentChar and currentChar:FindFirstChildOfClass("Humanoid")

																					if humanoid3 then
																						pcall(function()
																							humanoid3.Jump = true
																							humanoid3:ChangeState(Enum.HumanoidStateType.Jumping)
																						end)
																					end

																					pcall(function()
																						if modules.Game and modules.Game.Remotes and modules.Game.Remotes.Treadmill and modules.Game.Remotes.Treadmill.AskDoff then
																							modules.Game.Remotes.Treadmill.AskDoff:InvokeServer()
																						elseif replicatedStorage:FindFirstChild("Network") and replicatedStorage.Network:FindFirstChild("Treadmills: RequestUnequip") then
																							replicatedStorage.Network["Treadmills: RequestUnequip"]:InvokeServer()
																						end
																					end)
																				end

																				character3 = localPlayer.Character
																				character3 = character3 and character3:FindFirstChild("HumanoidRootPart")

																				if character3 then
																					n5 = math.clamp((os.clock() - now) / n, 0, 1)
																					v7 = position:Lerp(arg, n5)

																					if (v7 - vector2).Magnitude > 35 then
																						n6 = vector2 + (v7 - vector2).Unit * 35
																					else
																						n6 = v7
																					end

																					n7 = math.min(position.Y, arg.Y)

																					if not (n6.Y < n7) then
																						vector2 = n6
																					else
																						vector2 = Vector3.new(n6.X, n7, n6.Z)
																					end

																					cframe = vector.Magnitude > 0.1 and CFrame.lookAt(vector2, vector2 + unit) or CFrame.new(vector2)
																					character3.CFrame = cframe
																					character3.AssemblyLinearVelocity = Vector3.zero
																					character3.AssemblyAngularVelocity = Vector3.zero

																					if n5 >= 1 then
																						exitTo2 = 12
																						break
																					else
																						runService.Heartbeat:Wait()
																						flag3 = tbl11.Owner == "Steal"

																						if flag3 then
																							flag3 = not enabled["Auto Steal"]
																							flag2 = false
																							if not flag3 then
																								continue
																							end
																						else
																							flag2 = false
																							if not flag3 then
																								continue
																							end
																						end
																					end
																				end
																			end
																		end
																	else
																		midFlightStealSlotKey = tbl11.MidFlightStealTarget and tbl11.MidFlightStealSlotKey

																		if midFlightStealSlotKey then
																			now2 = os.clock()
																			n4 = now2 - n3
																			midFlightStealInterval = tbl11.MidFlightStealInterval or 0.5

																			if midFlightStealInterval <= n4 then
																				midFlightStealTarget = tbl11.MidFlightStealTarget
																				midFlightStealSlotKey2 = tbl11.MidFlightStealSlotKey

																				task.spawn(function()
																					pcall(function()
																						local remotes = modules.Game and modules.Game.Remotes

																						if not remotes then
																							remotes = replicatedStorage:FindFirstChild("Shared") and replicatedStorage.Shared:FindFirstChild("Remotes") and require(replicatedStorage.Shared.Remotes)
																						end

																						if remotes and remotes.EggWorld and remotes.EggWorld.AskFieldEggCarry then
																							remotes.EggWorld.AskFieldEggCarry:InvokeServer({ Uid = midFlightStealTarget, FirstAreaSlotKey = midFlightStealSlotKey2 })
																						end
																					end)
																				end)

																				n3 = now2
																			end
																		end

																		midFlightStealTarget2 = tbl11.AbortOnEggGrab and tbl11.MidFlightStealTarget

																		if midFlightStealTarget2 then
																			if stealManager.IsCarryingTargetEgg(tbl11.MidFlightStealTarget) then
																				exitTo2 = 10
																				break
																			else
																				flag4 = enabled["Run Animation"] and (tbl11.Owner == "Steal" or tbl11.Owner == "SafeZone")

																				if flag4 then
																					flag5 = not stealManager.RunAnimConnection

																					if flag5 then
																						currentRunTrack = stealManager.CurrentRunTrack
																						isPlaying = currentRunTrack and stealManager.CurrentRunTrack.IsPlaying
																						flag5 = not isPlaying
																					end

																					if flag5 then
																						stealManager.StartRunAnimation(speed)
																					end
																				end

																				checkTreadmil = tbl11.Owner ~= "Treadmill" and modules.Treadmill and modules.Treadmill.CheckTreadmil and modules.Treadmill.CheckTreadmil()

																				if checkTreadmil then
																					humanoid3 = currentChar and currentChar:FindFirstChildOfClass("Humanoid")

																					if humanoid3 then
																						pcall(function()
																							humanoid3.Jump = true
																							humanoid3:ChangeState(Enum.HumanoidStateType.Jumping)
																						end)
																					end

																					pcall(function()
																						if modules.Game and modules.Game.Remotes and modules.Game.Remotes.Treadmill and modules.Game.Remotes.Treadmill.AskDoff then
																							modules.Game.Remotes.Treadmill.AskDoff:InvokeServer()
																						elseif replicatedStorage:FindFirstChild("Network") and replicatedStorage.Network:FindFirstChild("Treadmills: RequestUnequip") then
																							replicatedStorage.Network["Treadmills: RequestUnequip"]:InvokeServer()
																						end
																					end)
																				end

																				character3 = localPlayer.Character
																				character3 = character3 and character3:FindFirstChild("HumanoidRootPart")

																				if character3 then
																					n5 = math.clamp((os.clock() - now) / n, 0, 1)
																					v7 = position:Lerp(arg, n5)

																					if (v7 - vector2).Magnitude > 35 then
																						n6 = vector2 + (v7 - vector2).Unit * 35
																					else
																						n6 = v7
																					end

																					n7 = math.min(position.Y, arg.Y)

																					if not (n6.Y < n7) then
																						vector2 = n6
																					else
																						vector2 = Vector3.new(n6.X, n7, n6.Z)
																					end

																					cframe = vector.Magnitude > 0.1 and CFrame.lookAt(vector2, vector2 + unit) or CFrame.new(vector2)
																					character3.CFrame = cframe
																					character3.AssemblyLinearVelocity = Vector3.zero
																					character3.AssemblyAngularVelocity = Vector3.zero

																					if n5 >= 1 then
																						exitTo2 = 11
																						break
																					else
																						runService.Heartbeat:Wait()
																						flag3 = tbl11.Owner == "Steal"

																						if flag3 then
																							flag3 = not enabled["Auto Steal"]
																							flag2 = false
																							if not flag3 then
																								continue
																							end
																						else
																							flag2 = false
																							if not flag3 then
																								continue
																							end
																						end
																					end
																				end
																			end
																		else
																			exitTo2 = 9
																			break
																		end
																	end
																end
															end
														else
															lastHitAt = tbl11.AbortOnGuardHit and stealManager.LastHitAt
															flag6 = lastHitAt and stealManager.LastHitAt > now

															if not flag6 then
																targetEggUid = tbl11.AbortOnEggDrop and tbl11.TargetEggUid

																if targetEggUid then
																	flag7 = not stealManager.IsCarryingTargetEgg(tbl11.TargetEggUid) and not stealManager.IsInSafeZone()

																	if not flag7 then
																		midFlightStealSlotKey = tbl11.MidFlightStealTarget and tbl11.MidFlightStealSlotKey

																		if midFlightStealSlotKey then
																			now2 = os.clock()
																			n4 = now2 - n3
																			midFlightStealInterval = tbl11.MidFlightStealInterval or 0.5

																			if midFlightStealInterval <= n4 then
																				midFlightStealTarget = tbl11.MidFlightStealTarget
																				midFlightStealSlotKey2 = tbl11.MidFlightStealSlotKey

																				task.spawn(function()
																					pcall(function()
																						local remotes = modules.Game and modules.Game.Remotes

																						if not remotes then
																							remotes = replicatedStorage:FindFirstChild("Shared") and replicatedStorage.Shared:FindFirstChild("Remotes") and require(replicatedStorage.Shared.Remotes)
																						end

																						if remotes and remotes.EggWorld and remotes.EggWorld.AskFieldEggCarry then
																							remotes.EggWorld.AskFieldEggCarry:InvokeServer({ Uid = midFlightStealTarget, FirstAreaSlotKey = midFlightStealSlotKey2 })
																						end
																					end)
																				end)

																				n3 = now2
																			end
																		end

																		midFlightStealTarget2 = tbl11.AbortOnEggGrab and tbl11.MidFlightStealTarget

																		if midFlightStealTarget2 then
																			if stealManager.IsCarryingTargetEgg(tbl11.MidFlightStealTarget) then
																				exitTo2 = 7
																				break
																			else
																				flag4 = enabled["Run Animation"] and (tbl11.Owner == "Steal" or tbl11.Owner == "SafeZone")

																				if flag4 then
																					flag5 = not stealManager.RunAnimConnection

																					if flag5 then
																						currentRunTrack = stealManager.CurrentRunTrack
																						isPlaying = currentRunTrack and stealManager.CurrentRunTrack.IsPlaying
																						flag5 = not isPlaying
																					end

																					if flag5 then
																						stealManager.StartRunAnimation(speed)
																					end
																				end

																				checkTreadmil = tbl11.Owner ~= "Treadmill" and modules.Treadmill and modules.Treadmill.CheckTreadmil and modules.Treadmill.CheckTreadmil()

																				if checkTreadmil then
																					humanoid3 = currentChar and currentChar:FindFirstChildOfClass("Humanoid")

																					if humanoid3 then
																						pcall(function()
																							humanoid3.Jump = true
																							humanoid3:ChangeState(Enum.HumanoidStateType.Jumping)
																						end)
																					end

																					pcall(function()
																						if modules.Game and modules.Game.Remotes and modules.Game.Remotes.Treadmill and modules.Game.Remotes.Treadmill.AskDoff then
																							modules.Game.Remotes.Treadmill.AskDoff:InvokeServer()
																						elseif replicatedStorage:FindFirstChild("Network") and replicatedStorage.Network:FindFirstChild("Treadmills: RequestUnequip") then
																							replicatedStorage.Network["Treadmills: RequestUnequip"]:InvokeServer()
																						end
																					end)
																				end

																				character3 = localPlayer.Character
																				character3 = character3 and character3:FindFirstChild("HumanoidRootPart")

																				if character3 then
																					n5 = math.clamp((os.clock() - now) / n, 0, 1)
																					v7 = position:Lerp(arg, n5)

																					if (v7 - vector2).Magnitude > 35 then
																						n6 = vector2 + (v7 - vector2).Unit * 35
																					else
																						n6 = v7
																					end

																					n7 = math.min(position.Y, arg.Y)

																					if not (n6.Y < n7) then
																						vector2 = n6
																					else
																						vector2 = Vector3.new(n6.X, n7, n6.Z)
																					end

																					cframe = vector.Magnitude > 0.1 and CFrame.lookAt(vector2, vector2 + unit) or CFrame.new(vector2)
																					character3.CFrame = cframe
																					character3.AssemblyLinearVelocity = Vector3.zero
																					character3.AssemblyAngularVelocity = Vector3.zero

																					if n5 >= 1 then
																						exitTo2 = 8
																						break
																					else
																						runService.Heartbeat:Wait()
																						flag3 = tbl11.Owner == "Steal"

																						if flag3 then
																							flag3 = not enabled["Auto Steal"]
																							flag2 = false
																							if not flag3 then
																								continue
																							end
																						else
																							flag2 = false
																							if not flag3 then
																								continue
																							end
																						end
																					end
																				end
																			end
																		else
																			exitTo2 = 6
																			break
																		end
																	end
																else
																	exitTo2 = 5
																	break
																end
															end
														end
													end
												else
													flag9 = tbl11.AbortOnStealTarget and os.clock() - n2 >= 0.25

													if flag9 then
														n2 = os.clock()
														flag10 = enabled["Auto Steal"] and stealManager.PickTarget and stealManager.PickTarget() ~= nil

														if not flag10 then
															lastHitAt = tbl11.AbortOnGuardHit and stealManager.LastHitAt
															flag6 = lastHitAt and stealManager.LastHitAt > now

															if not flag6 then
																targetEggUid = tbl11.AbortOnEggDrop and tbl11.TargetEggUid

																if targetEggUid then
																	flag7 = not stealManager.IsCarryingTargetEgg(tbl11.TargetEggUid) and not stealManager.IsInSafeZone()

																	if not flag7 then
																		midFlightStealSlotKey = tbl11.MidFlightStealTarget and tbl11.MidFlightStealSlotKey

																		if midFlightStealSlotKey then
																			now2 = os.clock()
																			n4 = now2 - n3
																			midFlightStealInterval = tbl11.MidFlightStealInterval or 0.5

																			if midFlightStealInterval <= n4 then
																				midFlightStealTarget = tbl11.MidFlightStealTarget
																				midFlightStealSlotKey2 = tbl11.MidFlightStealSlotKey

																				task.spawn(function()
																					pcall(function()
																						local remotes = modules.Game and modules.Game.Remotes

																						if not remotes then
																							remotes = replicatedStorage:FindFirstChild("Shared") and replicatedStorage.Shared:FindFirstChild("Remotes") and require(replicatedStorage.Shared.Remotes)
																						end

																						if remotes and remotes.EggWorld and remotes.EggWorld.AskFieldEggCarry then
																							remotes.EggWorld.AskFieldEggCarry:InvokeServer({ Uid = midFlightStealTarget, FirstAreaSlotKey = midFlightStealSlotKey2 })
																						end
																					end)
																				end)

																				n3 = now2
																			end
																		end

																		midFlightStealTarget2 = tbl11.AbortOnEggGrab and tbl11.MidFlightStealTarget

																		if midFlightStealTarget2 then
																			if stealManager.IsCarryingTargetEgg(tbl11.MidFlightStealTarget) then
																				exitTo2 = 4
																				break
																			else
																				flag4 = enabled["Run Animation"] and (tbl11.Owner == "Steal" or tbl11.Owner == "SafeZone")

																				if flag4 then
																					flag5 = not stealManager.RunAnimConnection

																					if flag5 then
																						currentRunTrack = stealManager.CurrentRunTrack
																						isPlaying = currentRunTrack and stealManager.CurrentRunTrack.IsPlaying
																						flag5 = not isPlaying
																					end

																					if flag5 then
																						stealManager.StartRunAnimation(speed)
																					end
																				end

																				checkTreadmil = tbl11.Owner ~= "Treadmill" and modules.Treadmill and modules.Treadmill.CheckTreadmil and modules.Treadmill.CheckTreadmil()

																				if checkTreadmil then
																					humanoid3 = currentChar and currentChar:FindFirstChildOfClass("Humanoid")

																					if humanoid3 then
																						pcall(function()
																							humanoid3.Jump = true
																							humanoid3:ChangeState(Enum.HumanoidStateType.Jumping)
																						end)
																					end

																					pcall(function()
																						if modules.Game and modules.Game.Remotes and modules.Game.Remotes.Treadmill and modules.Game.Remotes.Treadmill.AskDoff then
																							modules.Game.Remotes.Treadmill.AskDoff:InvokeServer()
																						elseif replicatedStorage:FindFirstChild("Network") and replicatedStorage.Network:FindFirstChild("Treadmills: RequestUnequip") then
																							replicatedStorage.Network["Treadmills: RequestUnequip"]:InvokeServer()
																						end
																					end)
																				end

																				character3 = localPlayer.Character
																				character3 = character3 and character3:FindFirstChild("HumanoidRootPart")

																				if character3 then
																					n5 = math.clamp((os.clock() - now) / n, 0, 1)
																					v7 = position:Lerp(arg, n5)

																					if (v7 - vector2).Magnitude > 35 then
																						n6 = vector2 + (v7 - vector2).Unit * 35
																					else
																						n6 = v7
																					end

																					n7 = math.min(position.Y, arg.Y)

																					if not (n6.Y < n7) then
																						vector2 = n6
																					else
																						vector2 = Vector3.new(n6.X, n7, n6.Z)
																					end

																					cframe = vector.Magnitude > 0.1 and CFrame.lookAt(vector2, vector2 + unit) or CFrame.new(vector2)
																					character3.CFrame = cframe
																					character3.AssemblyLinearVelocity = Vector3.zero
																					character3.AssemblyAngularVelocity = Vector3.zero

																					if n5 >= 1 then
																						exitTo2 = 14
																						break
																					else
																						runService.Heartbeat:Wait()
																						flag3 = tbl11.Owner == "Steal"

																						if flag3 then
																							flag3 = not enabled["Auto Steal"]
																							flag2 = false
																							if not flag3 then
																								continue
																							end
																						else
																							flag2 = false
																							if not flag3 then
																								continue
																							end
																						end
																					end
																				end
																			end
																		else
																			exitTo2 = 3
																			break
																		end
																	end
																else
																	exitTo2 = 2
																	break
																end
															end
														end
													else
														exitTo2 = 1
														break
													end
												end
											end
										end
									end
								end

								break
							end

							if exitTo2 == 1 then
								lastHitAt = tbl11.AbortOnGuardHit and stealManager.LastHitAt
								flag6 = lastHitAt and stealManager.LastHitAt > now

								if not flag6 then
									targetEggUid = tbl11.AbortOnEggDrop and tbl11.TargetEggUid

									if targetEggUid then
										flag7 = not stealManager.IsCarryingTargetEgg(tbl11.TargetEggUid) and not stealManager.IsInSafeZone()

										if not flag7 then
											midFlightStealSlotKey = tbl11.MidFlightStealTarget and tbl11.MidFlightStealSlotKey

											if midFlightStealSlotKey then
												now2 = os.clock()
												n4 = now2 - n3
												midFlightStealInterval = tbl11.MidFlightStealInterval or 0.5

												if midFlightStealInterval <= n4 then
													midFlightStealTarget = tbl11.MidFlightStealTarget
													midFlightStealSlotKey2 = tbl11.MidFlightStealSlotKey

													task.spawn(function()
														pcall(function()
															local remotes = modules.Game and modules.Game.Remotes

															if not remotes then
																remotes = replicatedStorage:FindFirstChild("Shared") and replicatedStorage.Shared:FindFirstChild("Remotes") and require(replicatedStorage.Shared.Remotes)
															end

															if remotes and remotes.EggWorld and remotes.EggWorld.AskFieldEggCarry then
																remotes.EggWorld.AskFieldEggCarry:InvokeServer({ Uid = midFlightStealTarget, FirstAreaSlotKey = midFlightStealSlotKey2 })
															end
														end)
													end)

													n3 = now2
												end
											end

											midFlightStealTarget2 = tbl11.AbortOnEggGrab and tbl11.MidFlightStealTarget

											if midFlightStealTarget2 then
												if stealManager.IsCarryingTargetEgg(tbl11.MidFlightStealTarget) then
													exitTo = 3
													break
												else
													flag4 = enabled["Run Animation"] and (tbl11.Owner == "Steal" or tbl11.Owner == "SafeZone")

													if flag4 then
														flag5 = not stealManager.RunAnimConnection

														if flag5 then
															currentRunTrack = stealManager.CurrentRunTrack
															isPlaying = currentRunTrack and stealManager.CurrentRunTrack.IsPlaying
															flag5 = not isPlaying
														end

														if flag5 then
															stealManager.StartRunAnimation(speed)
														end
													end

													checkTreadmil = tbl11.Owner ~= "Treadmill" and modules.Treadmill and modules.Treadmill.CheckTreadmil and modules.Treadmill.CheckTreadmil()

													if checkTreadmil then
														humanoid3 = currentChar and currentChar:FindFirstChildOfClass("Humanoid")

														if humanoid3 then
															pcall(function()
																humanoid3.Jump = true
																humanoid3:ChangeState(Enum.HumanoidStateType.Jumping)
															end)
														end

														pcall(function()
															if modules.Game and modules.Game.Remotes and modules.Game.Remotes.Treadmill and modules.Game.Remotes.Treadmill.AskDoff then
																modules.Game.Remotes.Treadmill.AskDoff:InvokeServer()
															elseif replicatedStorage:FindFirstChild("Network") and replicatedStorage.Network:FindFirstChild("Treadmills: RequestUnequip") then
																replicatedStorage.Network["Treadmills: RequestUnequip"]:InvokeServer()
															end
														end)
													end

													character3 = localPlayer.Character
													character3 = character3 and character3:FindFirstChild("HumanoidRootPart")

													if character3 then
														n5 = math.clamp((os.clock() - now) / n, 0, 1)
														v7 = position:Lerp(arg, n5)

														if (v7 - vector2).Magnitude > 35 then
															n6 = vector2 + (v7 - vector2).Unit * 35
														else
															n6 = v7
														end

														n7 = math.min(position.Y, arg.Y)

														if not (n6.Y < n7) then
															vector2 = n6
														else
															vector2 = Vector3.new(n6.X, n7, n6.Z)
														end

														cframe = vector.Magnitude > 0.1 and CFrame.lookAt(vector2, vector2 + unit) or CFrame.new(vector2)
														character3.CFrame = cframe
														character3.AssemblyLinearVelocity = Vector3.zero
														character3.AssemblyAngularVelocity = Vector3.zero

														if n5 >= 1 then
															exitTo = 16
															break
														else
															runService.Heartbeat:Wait()
															flag3 = tbl11.Owner == "Steal" and not enabled["Auto Steal"]
															continue
														end
													end
												end
											else
												exitTo = 2
												break
											end
										end
									else
										exitTo = 1
										break
									end
								end
							elseif exitTo2 == 2 then
								midFlightStealSlotKey = tbl11.MidFlightStealTarget and tbl11.MidFlightStealSlotKey

								if midFlightStealSlotKey then
									now2 = os.clock()
									n4 = now2 - n3
									midFlightStealInterval = tbl11.MidFlightStealInterval or 0.5

									if midFlightStealInterval <= n4 then
										midFlightStealTarget = tbl11.MidFlightStealTarget
										midFlightStealSlotKey2 = tbl11.MidFlightStealSlotKey

										task.spawn(function()
											pcall(function()
												local remotes = modules.Game and modules.Game.Remotes

												if not remotes then
													remotes = replicatedStorage:FindFirstChild("Shared") and replicatedStorage.Shared:FindFirstChild("Remotes") and require(replicatedStorage.Shared.Remotes)
												end

												if remotes and remotes.EggWorld and remotes.EggWorld.AskFieldEggCarry then
													remotes.EggWorld.AskFieldEggCarry:InvokeServer({ Uid = midFlightStealTarget, FirstAreaSlotKey = midFlightStealSlotKey2 })
												end
											end)
										end)

										n3 = now2
									end
								end

								midFlightStealTarget2 = tbl11.AbortOnEggGrab and tbl11.MidFlightStealTarget

								if midFlightStealTarget2 then
									if stealManager.IsCarryingTargetEgg(tbl11.MidFlightStealTarget) then
										exitTo = 5
										break
									else
										flag4 = enabled["Run Animation"] and (tbl11.Owner == "Steal" or tbl11.Owner == "SafeZone")

										if flag4 then
											flag5 = not stealManager.RunAnimConnection

											if flag5 then
												currentRunTrack = stealManager.CurrentRunTrack
												isPlaying = currentRunTrack and stealManager.CurrentRunTrack.IsPlaying
												flag5 = not isPlaying
											end

											if flag5 then
												stealManager.StartRunAnimation(speed)
											end
										end

										checkTreadmil = tbl11.Owner ~= "Treadmill" and modules.Treadmill and modules.Treadmill.CheckTreadmil and modules.Treadmill.CheckTreadmil()

										if checkTreadmil then
											humanoid3 = currentChar and currentChar:FindFirstChildOfClass("Humanoid")

											if humanoid3 then
												pcall(function()
													humanoid3.Jump = true
													humanoid3:ChangeState(Enum.HumanoidStateType.Jumping)
												end)
											end

											pcall(function()
												if modules.Game and modules.Game.Remotes and modules.Game.Remotes.Treadmill and modules.Game.Remotes.Treadmill.AskDoff then
													modules.Game.Remotes.Treadmill.AskDoff:InvokeServer()
												elseif replicatedStorage:FindFirstChild("Network") and replicatedStorage.Network:FindFirstChild("Treadmills: RequestUnequip") then
													replicatedStorage.Network["Treadmills: RequestUnequip"]:InvokeServer()
												end
											end)
										end

										character3 = localPlayer.Character
										character3 = character3 and character3:FindFirstChild("HumanoidRootPart")

										if character3 then
											n5 = math.clamp((os.clock() - now) / n, 0, 1)
											v7 = position:Lerp(arg, n5)

											if (v7 - vector2).Magnitude > 35 then
												n6 = vector2 + (v7 - vector2).Unit * 35
											else
												n6 = v7
											end

											n7 = math.min(position.Y, arg.Y)

											if not (n6.Y < n7) then
												vector2 = n6
											else
												vector2 = Vector3.new(n6.X, n7, n6.Z)
											end

											cframe = vector.Magnitude > 0.1 and CFrame.lookAt(vector2, vector2 + unit) or CFrame.new(vector2)
											character3.CFrame = cframe
											character3.AssemblyLinearVelocity = Vector3.zero
											character3.AssemblyAngularVelocity = Vector3.zero

											if n5 >= 1 then
												exitTo = 13
												break
											else
												runService.Heartbeat:Wait()
												flag3 = tbl11.Owner == "Steal" and not enabled["Auto Steal"]
												continue
											end
										end
									end
								else
									exitTo = 4
									break
								end
							elseif exitTo2 == 3 then
								flag4 = enabled["Run Animation"] and (tbl11.Owner == "Steal" or tbl11.Owner == "SafeZone")

								if flag4 then
									flag5 = not stealManager.RunAnimConnection

									if flag5 then
										currentRunTrack = stealManager.CurrentRunTrack
										isPlaying = currentRunTrack and stealManager.CurrentRunTrack.IsPlaying
										flag5 = not isPlaying
									end

									if flag5 then
										stealManager.StartRunAnimation(speed)
									end
								end

								checkTreadmil = tbl11.Owner ~= "Treadmill" and modules.Treadmill and modules.Treadmill.CheckTreadmil and modules.Treadmill.CheckTreadmil()

								if checkTreadmil then
									humanoid3 = currentChar and currentChar:FindFirstChildOfClass("Humanoid")

									if humanoid3 then
										pcall(function()
											humanoid3.Jump = true
											humanoid3:ChangeState(Enum.HumanoidStateType.Jumping)
										end)
									end

									pcall(function()
										if modules.Game and modules.Game.Remotes and modules.Game.Remotes.Treadmill and modules.Game.Remotes.Treadmill.AskDoff then
											modules.Game.Remotes.Treadmill.AskDoff:InvokeServer()
										elseif replicatedStorage:FindFirstChild("Network") and replicatedStorage.Network:FindFirstChild("Treadmills: RequestUnequip") then
											replicatedStorage.Network["Treadmills: RequestUnequip"]:InvokeServer()
										end
									end)
								end

								character3 = localPlayer.Character
								character3 = character3 and character3:FindFirstChild("HumanoidRootPart")

								if character3 then
									n5 = math.clamp((os.clock() - now) / n, 0, 1)
									v7 = position:Lerp(arg, n5)

									if (v7 - vector2).Magnitude > 35 then
										n6 = vector2 + (v7 - vector2).Unit * 35
									else
										n6 = v7
									end

									n7 = math.min(position.Y, arg.Y)

									if not (n6.Y < n7) then
										vector2 = n6
									else
										vector2 = Vector3.new(n6.X, n7, n6.Z)
									end

									cframe = vector.Magnitude > 0.1 and CFrame.lookAt(vector2, vector2 + unit) or CFrame.new(vector2)
									character3.CFrame = cframe
									character3.AssemblyLinearVelocity = Vector3.zero
									character3.AssemblyAngularVelocity = Vector3.zero

									if n5 >= 1 then
										exitTo = 14
										break
									else
										runService.Heartbeat:Wait()
										flag3 = tbl11.Owner == "Steal" and not enabled["Auto Steal"]
										continue
									end
								end
							elseif exitTo2 == 4 then
								exitTo = 15
								break
							elseif exitTo2 == 5 then
								midFlightStealSlotKey = tbl11.MidFlightStealTarget and tbl11.MidFlightStealSlotKey

								if midFlightStealSlotKey then
									now2 = os.clock()
									n4 = now2 - n3
									midFlightStealInterval = tbl11.MidFlightStealInterval or 0.5

									if midFlightStealInterval <= n4 then
										midFlightStealTarget = tbl11.MidFlightStealTarget
										midFlightStealSlotKey2 = tbl11.MidFlightStealSlotKey

										task.spawn(function()
											pcall(function()
												local remotes = modules.Game and modules.Game.Remotes

												if not remotes then
													remotes = replicatedStorage:FindFirstChild("Shared") and replicatedStorage.Shared:FindFirstChild("Remotes") and require(replicatedStorage.Shared.Remotes)
												end

												if remotes and remotes.EggWorld and remotes.EggWorld.AskFieldEggCarry then
													remotes.EggWorld.AskFieldEggCarry:InvokeServer({ Uid = midFlightStealTarget, FirstAreaSlotKey = midFlightStealSlotKey2 })
												end
											end)
										end)

										n3 = now2
									end
								end

								midFlightStealTarget2 = tbl11.AbortOnEggGrab and tbl11.MidFlightStealTarget

								if midFlightStealTarget2 then
									if stealManager.IsCarryingTargetEgg(tbl11.MidFlightStealTarget) then
										exitTo = 7
										break
									else
										flag4 = enabled["Run Animation"] and (tbl11.Owner == "Steal" or tbl11.Owner == "SafeZone")

										if flag4 then
											flag5 = not stealManager.RunAnimConnection

											if flag5 then
												currentRunTrack = stealManager.CurrentRunTrack
												isPlaying = currentRunTrack and stealManager.CurrentRunTrack.IsPlaying
												flag5 = not isPlaying
											end

											if flag5 then
												stealManager.StartRunAnimation(speed)
											end
										end

										checkTreadmil = tbl11.Owner ~= "Treadmill" and modules.Treadmill and modules.Treadmill.CheckTreadmil and modules.Treadmill.CheckTreadmil()

										if checkTreadmil then
											humanoid3 = currentChar and currentChar:FindFirstChildOfClass("Humanoid")

											if humanoid3 then
												pcall(function()
													humanoid3.Jump = true
													humanoid3:ChangeState(Enum.HumanoidStateType.Jumping)
												end)
											end

											pcall(function()
												if modules.Game and modules.Game.Remotes and modules.Game.Remotes.Treadmill and modules.Game.Remotes.Treadmill.AskDoff then
													modules.Game.Remotes.Treadmill.AskDoff:InvokeServer()
												elseif replicatedStorage:FindFirstChild("Network") and replicatedStorage.Network:FindFirstChild("Treadmills: RequestUnequip") then
													replicatedStorage.Network["Treadmills: RequestUnequip"]:InvokeServer()
												end
											end)
										end

										character3 = localPlayer.Character
										character3 = character3 and character3:FindFirstChild("HumanoidRootPart")

										if character3 then
											n5 = math.clamp((os.clock() - now) / n, 0, 1)
											v7 = position:Lerp(arg, n5)

											if (v7 - vector2).Magnitude > 35 then
												n6 = vector2 + (v7 - vector2).Unit * 35
											else
												n6 = v7
											end

											n7 = math.min(position.Y, arg.Y)

											if not (n6.Y < n7) then
												vector2 = n6
											else
												vector2 = Vector3.new(n6.X, n7, n6.Z)
											end

											cframe = vector.Magnitude > 0.1 and CFrame.lookAt(vector2, vector2 + unit) or CFrame.new(vector2)
											character3.CFrame = cframe
											character3.AssemblyLinearVelocity = Vector3.zero
											character3.AssemblyAngularVelocity = Vector3.zero

											if n5 >= 1 then
												exitTo = 8
												break
											else
												runService.Heartbeat:Wait()
												flag3 = tbl11.Owner == "Steal" and not enabled["Auto Steal"]
												continue
											end
										end
									end
								else
									exitTo = 6
									break
								end
							elseif exitTo2 == 6 then
								flag4 = enabled["Run Animation"] and (tbl11.Owner == "Steal" or tbl11.Owner == "SafeZone")

								if flag4 then
									flag5 = not stealManager.RunAnimConnection

									if flag5 then
										currentRunTrack = stealManager.CurrentRunTrack
										isPlaying = currentRunTrack and stealManager.CurrentRunTrack.IsPlaying
										flag5 = not isPlaying
									end

									if flag5 then
										stealManager.StartRunAnimation(speed)
									end
								end

								checkTreadmil = tbl11.Owner ~= "Treadmill" and modules.Treadmill and modules.Treadmill.CheckTreadmil and modules.Treadmill.CheckTreadmil()

								if checkTreadmil then
									humanoid3 = currentChar and currentChar:FindFirstChildOfClass("Humanoid")

									if humanoid3 then
										pcall(function()
											humanoid3.Jump = true
											humanoid3:ChangeState(Enum.HumanoidStateType.Jumping)
										end)
									end

									pcall(function()
										if modules.Game and modules.Game.Remotes and modules.Game.Remotes.Treadmill and modules.Game.Remotes.Treadmill.AskDoff then
											modules.Game.Remotes.Treadmill.AskDoff:InvokeServer()
										elseif replicatedStorage:FindFirstChild("Network") and replicatedStorage.Network:FindFirstChild("Treadmills: RequestUnequip") then
											replicatedStorage.Network["Treadmills: RequestUnequip"]:InvokeServer()
										end
									end)
								end

								character3 = localPlayer.Character
								character3 = character3 and character3:FindFirstChild("HumanoidRootPart")

								if character3 then
									n5 = math.clamp((os.clock() - now) / n, 0, 1)
									v7 = position:Lerp(arg, n5)

									if (v7 - vector2).Magnitude > 35 then
										n6 = vector2 + (v7 - vector2).Unit * 35
									else
										n6 = v7
									end

									n7 = math.min(position.Y, arg.Y)

									if not (n6.Y < n7) then
										vector2 = n6
									else
										vector2 = Vector3.new(n6.X, n7, n6.Z)
									end

									cframe = vector.Magnitude > 0.1 and CFrame.lookAt(vector2, vector2 + unit) or CFrame.new(vector2)
									character3.CFrame = cframe
									character3.AssemblyLinearVelocity = Vector3.zero
									character3.AssemblyAngularVelocity = Vector3.zero

									if n5 >= 1 then
										exitTo = 9
										break
									else
										runService.Heartbeat:Wait()
										flag3 = tbl11.Owner == "Steal" and not enabled["Auto Steal"]
										continue
									end
								end
							elseif exitTo2 == 7 then
								exitTo = 10
								break
							elseif exitTo2 == 8 then
								exitTo = 16
								break
							elseif exitTo2 == 9 then
								flag4 = enabled["Run Animation"] and (tbl11.Owner == "Steal" or tbl11.Owner == "SafeZone")

								if flag4 then
									flag5 = not stealManager.RunAnimConnection

									if flag5 then
										currentRunTrack = stealManager.CurrentRunTrack
										isPlaying = currentRunTrack and stealManager.CurrentRunTrack.IsPlaying
										flag5 = not isPlaying
									end

									if flag5 then
										stealManager.StartRunAnimation(speed)
									end
								end

								checkTreadmil = tbl11.Owner ~= "Treadmill" and modules.Treadmill and modules.Treadmill.CheckTreadmil and modules.Treadmill.CheckTreadmil()

								if checkTreadmil then
									humanoid3 = currentChar and currentChar:FindFirstChildOfClass("Humanoid")

									if humanoid3 then
										pcall(function()
											humanoid3.Jump = true
											humanoid3:ChangeState(Enum.HumanoidStateType.Jumping)
										end)
									end

									pcall(function()
										if modules.Game and modules.Game.Remotes and modules.Game.Remotes.Treadmill and modules.Game.Remotes.Treadmill.AskDoff then
											modules.Game.Remotes.Treadmill.AskDoff:InvokeServer()
										elseif replicatedStorage:FindFirstChild("Network") and replicatedStorage.Network:FindFirstChild("Treadmills: RequestUnequip") then
											replicatedStorage.Network["Treadmills: RequestUnequip"]:InvokeServer()
										end
									end)
								end

								character3 = localPlayer.Character
								character3 = character3 and character3:FindFirstChild("HumanoidRootPart")

								if character3 then
									n5 = math.clamp((os.clock() - now) / n, 0, 1)
									v7 = position:Lerp(arg, n5)

									if (v7 - vector2).Magnitude > 35 then
										n6 = vector2 + (v7 - vector2).Unit * 35
									else
										n6 = v7
									end

									n7 = math.min(position.Y, arg.Y)

									if not (n6.Y < n7) then
										vector2 = n6
									else
										vector2 = Vector3.new(n6.X, n7, n6.Z)
									end

									cframe = vector.Magnitude > 0.1 and CFrame.lookAt(vector2, vector2 + unit) or CFrame.new(vector2)
									character3.CFrame = cframe
									character3.AssemblyLinearVelocity = Vector3.zero
									character3.AssemblyAngularVelocity = Vector3.zero

									if n5 >= 1 then
										exitTo = 11
										break
									else
										runService.Heartbeat:Wait()
										flag3 = tbl11.Owner == "Steal" and not enabled["Auto Steal"]
										continue
									end
								end
							else
								if exitTo2 == 10 then
									exitTo = 12
								elseif exitTo2 == 11 then
									exitTo = 13
								elseif exitTo2 == 12 then
									exitTo = 14
								elseif exitTo2 == 13 then
									exitTo = 15
								elseif exitTo2 == 14 then
									exitTo = 16
								end

								break
							end

							break
						end
					end

					if exitTo == 1 then
						midFlightStealSlotKey = tbl11.MidFlightStealTarget and tbl11.MidFlightStealSlotKey

						if midFlightStealSlotKey then
							now2 = os.clock()
							n4 = now2 - n3
							midFlightStealInterval = tbl11.MidFlightStealInterval or 0.5

							if midFlightStealInterval <= n4 then
								midFlightStealTarget = tbl11.MidFlightStealTarget
								midFlightStealSlotKey2 = tbl11.MidFlightStealSlotKey

								task.spawn(function()
									pcall(function()
										local remotes = modules.Game and modules.Game.Remotes

										if not remotes then
											remotes = replicatedStorage:FindFirstChild("Shared") and replicatedStorage.Shared:FindFirstChild("Remotes") and require(replicatedStorage.Shared.Remotes)
										end

										if remotes and remotes.EggWorld and remotes.EggWorld.AskFieldEggCarry then
											remotes.EggWorld.AskFieldEggCarry:InvokeServer({ Uid = midFlightStealTarget, FirstAreaSlotKey = midFlightStealSlotKey2 })
										end
									end)
								end)

								n3 = now2
							end
						end

						midFlightStealTarget2 = tbl11.AbortOnEggGrab and tbl11.MidFlightStealTarget

						if midFlightStealTarget2 then
							if stealManager.IsCarryingTargetEgg(tbl11.MidFlightStealTarget) then
								flag2 = true
								break
							else
								flag4 = enabled["Run Animation"] and (tbl11.Owner == "Steal" or tbl11.Owner == "SafeZone")

								if flag4 then
									flag5 = not stealManager.RunAnimConnection

									if flag5 then
										currentRunTrack = stealManager.CurrentRunTrack
										isPlaying = currentRunTrack and stealManager.CurrentRunTrack.IsPlaying
										flag5 = not isPlaying
									end

									if flag5 then
										stealManager.StartRunAnimation(speed)
									end
								end

								checkTreadmil = tbl11.Owner ~= "Treadmill" and modules.Treadmill and modules.Treadmill.CheckTreadmil and modules.Treadmill.CheckTreadmil()

								if checkTreadmil then
									humanoid3 = currentChar and currentChar:FindFirstChildOfClass("Humanoid")

									if humanoid3 then
										pcall(function()
											humanoid3.Jump = true
											humanoid3:ChangeState(Enum.HumanoidStateType.Jumping)
										end)
									end

									pcall(function()
										if modules.Game and modules.Game.Remotes and modules.Game.Remotes.Treadmill and modules.Game.Remotes.Treadmill.AskDoff then
											modules.Game.Remotes.Treadmill.AskDoff:InvokeServer()
										elseif replicatedStorage:FindFirstChild("Network") and replicatedStorage.Network:FindFirstChild("Treadmills: RequestUnequip") then
											replicatedStorage.Network["Treadmills: RequestUnequip"]:InvokeServer()
										end
									end)
								end

								character3 = localPlayer.Character
								character3 = character3 and character3:FindFirstChild("HumanoidRootPart")

								if character3 then
									n5 = math.clamp((os.clock() - now) / n, 0, 1)
									v7 = position:Lerp(arg, n5)

									if (v7 - vector2).Magnitude > 35 then
										n6 = vector2 + (v7 - vector2).Unit * 35
									else
										n6 = v7
									end

									n7 = math.min(position.Y, arg.Y)

									if not (n6.Y < n7) then
										vector2 = n6
									else
										vector2 = Vector3.new(n6.X, n7, n6.Z)
									end

									cframe = vector.Magnitude > 0.1 and CFrame.lookAt(vector2, vector2 + unit) or CFrame.new(vector2)
									character3.CFrame = cframe
									character3.AssemblyLinearVelocity = Vector3.zero
									character3.AssemblyAngularVelocity = Vector3.zero

									if n5 >= 1 then
										flag2 = true
										break
									else
										runService.Heartbeat:Wait()
										continue
									end
								end
							end
						else
							flag4 = enabled["Run Animation"] and (tbl11.Owner == "Steal" or tbl11.Owner == "SafeZone")

							if flag4 then
								flag5 = not stealManager.RunAnimConnection

								if flag5 then
									currentRunTrack = stealManager.CurrentRunTrack
									isPlaying = currentRunTrack and stealManager.CurrentRunTrack.IsPlaying
									flag5 = not isPlaying
								end

								if flag5 then
									stealManager.StartRunAnimation(speed)
								end
							end

							checkTreadmil = tbl11.Owner ~= "Treadmill" and modules.Treadmill and modules.Treadmill.CheckTreadmil and modules.Treadmill.CheckTreadmil()

							if checkTreadmil then
								humanoid3 = currentChar and currentChar:FindFirstChildOfClass("Humanoid")

								if humanoid3 then
									pcall(function()
										humanoid3.Jump = true
										humanoid3:ChangeState(Enum.HumanoidStateType.Jumping)
									end)
								end

								pcall(function()
									if modules.Game and modules.Game.Remotes and modules.Game.Remotes.Treadmill and modules.Game.Remotes.Treadmill.AskDoff then
										modules.Game.Remotes.Treadmill.AskDoff:InvokeServer()
									elseif replicatedStorage:FindFirstChild("Network") and replicatedStorage.Network:FindFirstChild("Treadmills: RequestUnequip") then
										replicatedStorage.Network["Treadmills: RequestUnequip"]:InvokeServer()
									end
								end)
							end

							character3 = localPlayer.Character
							character3 = character3 and character3:FindFirstChild("HumanoidRootPart")

							if character3 then
								n5 = math.clamp((os.clock() - now) / n, 0, 1)
								v7 = position:Lerp(arg, n5)

								if (v7 - vector2).Magnitude > 35 then
									n6 = vector2 + (v7 - vector2).Unit * 35
								else
									n6 = v7
								end

								n7 = math.min(position.Y, arg.Y)

								if not (n6.Y < n7) then
									vector2 = n6
								else
									vector2 = Vector3.new(n6.X, n7, n6.Z)
								end

								cframe = vector.Magnitude > 0.1 and CFrame.lookAt(vector2, vector2 + unit) or CFrame.new(vector2)
								character3.CFrame = cframe
								character3.AssemblyLinearVelocity = Vector3.zero
								character3.AssemblyAngularVelocity = Vector3.zero

								if n5 >= 1 then
									flag2 = true
									break
								else
									runService.Heartbeat:Wait()
									continue
								end
							end
						end
					elseif exitTo == 2 then
						flag4 = enabled["Run Animation"] and (tbl11.Owner == "Steal" or tbl11.Owner == "SafeZone")

						if flag4 then
							flag5 = not stealManager.RunAnimConnection

							if flag5 then
								currentRunTrack = stealManager.CurrentRunTrack
								isPlaying = currentRunTrack and stealManager.CurrentRunTrack.IsPlaying
								flag5 = not isPlaying
							end

							if flag5 then
								stealManager.StartRunAnimation(speed)
							end
						end

						checkTreadmil = tbl11.Owner ~= "Treadmill" and modules.Treadmill and modules.Treadmill.CheckTreadmil and modules.Treadmill.CheckTreadmil()

						if checkTreadmil then
							humanoid3 = currentChar and currentChar:FindFirstChildOfClass("Humanoid")

							if humanoid3 then
								pcall(function()
									humanoid3.Jump = true
									humanoid3:ChangeState(Enum.HumanoidStateType.Jumping)
								end)
							end

							pcall(function()
								if modules.Game and modules.Game.Remotes and modules.Game.Remotes.Treadmill and modules.Game.Remotes.Treadmill.AskDoff then
									modules.Game.Remotes.Treadmill.AskDoff:InvokeServer()
								elseif replicatedStorage:FindFirstChild("Network") and replicatedStorage.Network:FindFirstChild("Treadmills: RequestUnequip") then
									replicatedStorage.Network["Treadmills: RequestUnequip"]:InvokeServer()
								end
							end)
						end

						character3 = localPlayer.Character
						character3 = character3 and character3:FindFirstChild("HumanoidRootPart")

						if character3 then
							n5 = math.clamp((os.clock() - now) / n, 0, 1)
							v7 = position:Lerp(arg, n5)

							if (v7 - vector2).Magnitude > 35 then
								n6 = vector2 + (v7 - vector2).Unit * 35
							else
								n6 = v7
							end

							n7 = math.min(position.Y, arg.Y)

							if not (n6.Y < n7) then
								vector2 = n6
							else
								vector2 = Vector3.new(n6.X, n7, n6.Z)
							end

							cframe = vector.Magnitude > 0.1 and CFrame.lookAt(vector2, vector2 + unit) or CFrame.new(vector2)
							character3.CFrame = cframe
							character3.AssemblyLinearVelocity = Vector3.zero
							character3.AssemblyAngularVelocity = Vector3.zero

							if n5 >= 1 then
								flag2 = true
								break
							else
								runService.Heartbeat:Wait()
								continue
							end
						end
					elseif exitTo == 3 then
						flag2 = true
						break
					elseif exitTo == 4 then
						flag4 = enabled["Run Animation"] and (tbl11.Owner == "Steal" or tbl11.Owner == "SafeZone")

						if flag4 then
							flag5 = not stealManager.RunAnimConnection

							if flag5 then
								currentRunTrack = stealManager.CurrentRunTrack
								isPlaying = currentRunTrack and stealManager.CurrentRunTrack.IsPlaying
								flag5 = not isPlaying
							end

							if flag5 then
								stealManager.StartRunAnimation(speed)
							end
						end

						checkTreadmil = tbl11.Owner ~= "Treadmill" and modules.Treadmill and modules.Treadmill.CheckTreadmil and modules.Treadmill.CheckTreadmil()

						if checkTreadmil then
							humanoid3 = currentChar and currentChar:FindFirstChildOfClass("Humanoid")

							if humanoid3 then
								pcall(function()
									humanoid3.Jump = true
									humanoid3:ChangeState(Enum.HumanoidStateType.Jumping)
								end)
							end

							pcall(function()
								if modules.Game and modules.Game.Remotes and modules.Game.Remotes.Treadmill and modules.Game.Remotes.Treadmill.AskDoff then
									modules.Game.Remotes.Treadmill.AskDoff:InvokeServer()
								elseif replicatedStorage:FindFirstChild("Network") and replicatedStorage.Network:FindFirstChild("Treadmills: RequestUnequip") then
									replicatedStorage.Network["Treadmills: RequestUnequip"]:InvokeServer()
								end
							end)
						end

						character3 = localPlayer.Character
						character3 = character3 and character3:FindFirstChild("HumanoidRootPart")

						if character3 then
							n5 = math.clamp((os.clock() - now) / n, 0, 1)
							v7 = position:Lerp(arg, n5)

							if (v7 - vector2).Magnitude > 35 then
								n6 = vector2 + (v7 - vector2).Unit * 35
							else
								n6 = v7
							end

							n7 = math.min(position.Y, arg.Y)

							if not (n6.Y < n7) then
								vector2 = n6
							else
								vector2 = Vector3.new(n6.X, n7, n6.Z)
							end

							cframe = vector.Magnitude > 0.1 and CFrame.lookAt(vector2, vector2 + unit) or CFrame.new(vector2)
							character3.CFrame = cframe
							character3.AssemblyLinearVelocity = Vector3.zero
							character3.AssemblyAngularVelocity = Vector3.zero

							if n5 >= 1 then
								flag2 = true
								break
							else
								runService.Heartbeat:Wait()
								continue
							end
						end
					elseif exitTo == 5 then
						flag2 = true
						break
					elseif exitTo == 6 then
						flag4 = enabled["Run Animation"] and (tbl11.Owner == "Steal" or tbl11.Owner == "SafeZone")

						if flag4 then
							flag5 = not stealManager.RunAnimConnection

							if flag5 then
								currentRunTrack = stealManager.CurrentRunTrack
								isPlaying = currentRunTrack and stealManager.CurrentRunTrack.IsPlaying
								flag5 = not isPlaying
							end

							if flag5 then
								stealManager.StartRunAnimation(speed)
							end
						end

						checkTreadmil = tbl11.Owner ~= "Treadmill" and modules.Treadmill and modules.Treadmill.CheckTreadmil and modules.Treadmill.CheckTreadmil()

						if checkTreadmil then
							humanoid3 = currentChar and currentChar:FindFirstChildOfClass("Humanoid")

							if humanoid3 then
								pcall(function()
									humanoid3.Jump = true
									humanoid3:ChangeState(Enum.HumanoidStateType.Jumping)
								end)
							end

							pcall(function()
								if modules.Game and modules.Game.Remotes and modules.Game.Remotes.Treadmill and modules.Game.Remotes.Treadmill.AskDoff then
									modules.Game.Remotes.Treadmill.AskDoff:InvokeServer()
								elseif replicatedStorage:FindFirstChild("Network") and replicatedStorage.Network:FindFirstChild("Treadmills: RequestUnequip") then
									replicatedStorage.Network["Treadmills: RequestUnequip"]:InvokeServer()
								end
							end)
						end

						character3 = localPlayer.Character
						character3 = character3 and character3:FindFirstChild("HumanoidRootPart")

						if character3 then
							n5 = math.clamp((os.clock() - now) / n, 0, 1)
							v7 = position:Lerp(arg, n5)

							if (v7 - vector2).Magnitude > 35 then
								n6 = vector2 + (v7 - vector2).Unit * 35
							else
								n6 = v7
							end

							n7 = math.min(position.Y, arg.Y)

							if not (n6.Y < n7) then
								vector2 = n6
							else
								vector2 = Vector3.new(n6.X, n7, n6.Z)
							end

							cframe = vector.Magnitude > 0.1 and CFrame.lookAt(vector2, vector2 + unit) or CFrame.new(vector2)
							character3.CFrame = cframe
							character3.AssemblyLinearVelocity = Vector3.zero
							character3.AssemblyAngularVelocity = Vector3.zero

							if n5 >= 1 then
								flag2 = true
								break
							else
								runService.Heartbeat:Wait()
								continue
							end
						end
					else
						if exitTo == 7 then
							flag2 = true
						elseif exitTo == 8 then
							flag2 = true
						elseif exitTo == 9 then
							flag2 = true
						elseif exitTo == 10 then
							flag2 = true
						elseif exitTo == 11 then
							flag2 = true
						elseif exitTo == 12 then
							flag2 = true
						elseif exitTo == 13 then
							flag2 = true
						elseif exitTo == 14 then
							flag2 = true
						elseif exitTo == 15 then
							flag2 = true
						elseif exitTo == 16 then
							flag2 = true
						end

						break
					end

					break
				end

				if flag2 and humanoidRootPart2 and humanoidRootPart2.Parent then
					humanoidRootPart2.CFrame = vector.Magnitude > 0.1 and CFrame.lookAt(arg, arg + unit) or CFrame.new(arg)
					humanoidRootPart2.AssemblyLinearVelocity = Vector3.zero
					humanoidRootPart2.AssemblyAngularVelocity = Vector3.zero
					humanoidRootPart2.CanCollide = true
				end

				if humanoid2 and humanoid2.Parent then
					pcall(function()
						humanoid2:ChangeState(Enum.HumanoidStateType.Running)
					end)
				end

				if tbl11.Owner == "Steal" or tbl11.Owner == "SafeZone" then
					stealManager.StopRunAnimation()
				end

				if tbl11.Owner ~= "Treadmill" and modules.Treadmill and modules.Treadmill.CheckTreadmil and modules.Treadmill.CheckTreadmil() then
					if humanoid2 and humanoid2.Parent then
						pcall(function()
							humanoid2.Jump = true
							humanoid2:ChangeState(Enum.HumanoidStateType.Jumping)
						end)
					end

					pcall(function()
						if modules.Game and modules.Game.Remotes and modules.Game.Remotes.Treadmill and modules.Game.Remotes.Treadmill.AskDoff then
							modules.Game.Remotes.Treadmill.AskDoff:InvokeServer()
						elseif replicatedStorage:FindFirstChild("Network") and replicatedStorage.Network:FindFirstChild("Treadmills: RequestUnequip") then
							replicatedStorage.Network["Treadmills: RequestUnequip"]:InvokeServer()
						end
					end)
				end

				return flag2
			end

			stealManager.GlideTo = stealManager.TweenTo

			stealManager.ApplyAntiTpBypass = function()
				if enabled["Bypass Anti Teleport"] == false then
					return
				end

				pcall(function()
					workspace:SetAttribute("ClientObbyAntiTp", false)
				end)

				pcall(function()
					local playerScripts = localPlayer:FindFirstChild("PlayerScripts")

					if playerScripts then
						local obbyAntiTPClient = playerScripts:FindFirstChild("ObbyAntiTPClient") or playerScripts:FindFirstChild("AntiTP") or playerScripts:FindFirstChild("AntiTeleport")

						if obbyAntiTPClient and obbyAntiTPClient:IsA("LocalScript") and not obbyAntiTPClient.Disabled then
							obbyAntiTPClient.Disabled = true
						end
					end
				end)
			end

			stealManager.SafeTpPos = Vector3.new(512.7, 69, -362.5)
			stealManager.SafeXLimit = 548
			stealManager.GraceUntil = 0
			stealManager.LastHitAt = 0
			stealManager.RigSyncHookDone = false
			stealManager.BaitBlacklist = {}
			stealManager.RagdollActive = false

			stealManager.GraceActive = function()
				return os.clock() < (stealManager.GraceUntil or 0)
			end

			stealManager.EnsureRigSyncHook = function()
				if stealManager.RigSyncHookDone then
					return
				end

				pcall(function()
					local ReplicatedStorage = game:GetService("ReplicatedStorage")
					local remotes = modules.Game and modules.Game.Remotes or require(ReplicatedStorage.Shared.Remotes)

					if remotes and remotes.RigSync and remotes.RigSync.Refresh then
						remotes.RigSync.Refresh.OnClientEvent:Connect(function(arg)
							if typeof(arg) ~= "string" then
								return
							end
							local ok, result = pcall(httpService.JSONDecode, httpService, arg)
							if not ok or typeof(result) ~= "table" then
								return
							end
							local action = result.Action
							local arguments = typeof(result.Arguments) == "table" and result.Arguments or {}

							if action == "BeginImpulse" or action == "BeginRagdoll" then
								local n = tonumber(arguments[1]) or 1
								stealManager.GraceUntil = math.max(stealManager.GraceUntil or 0, os.clock() + math.clamp(n, 1, 5) + 0.5)
								stealManager.LastHitAt = os.clock()
								stealManager.RagdollActive = true
							elseif action == "EndRagdoll" then
								stealManager.RagdollActive = false
								stealManager.GraceUntil = math.max(stealManager.GraceUntil or 0, os.clock() + 1)
							end
						end)

						stealManager.RigSyncHookDone = true
					end
				end)
			end

			stealManager.GetEggTool = function()
				local character2 = localPlayer.Character

				if character2 then
					for _, child in ipairs(character2:GetChildren()) do
						if child:IsA("Tool") and (child:GetAttribute("ItemType") == "AssetEgg" or string.find(child.Name:lower(), "egg")) then
							return child
						end
					end
				end

				return nil
			end

			stealManager.UnequipAllTools = function()
				pcall(function()
					local character2 = localPlayer.Character

					if character2 then
						for _, child in ipairs(character2:GetChildren()) do
							local isTool = child:IsA("Tool")
							local flag

							if isTool then
								flag = child:GetAttribute("ItemType") == "AssetEgg" or string.find(child.Name:lower(), "egg")
							else
								flag = isTool
							end

							if flag then
								local backpack = localPlayer:FindFirstChildOfClass("Backpack")

								if backpack then
									child.Parent = backpack
								end
							end
						end
					end
				end)

				pcall(function()
					local ReplicatedStorage = game:GetService("ReplicatedStorage")
					local eggState = modules.Game and modules.Game.EggState or ReplicatedStorage:FindFirstChild("Client") and ReplicatedStorage.Client:FindFirstChild("EggState") and require(ReplicatedStorage.Client.EggState)

					if eggState and eggState.DoffEggTool then
						eggState.DoffEggTool()
					end
				end)

				pcall(function()
					local ReplicatedStorage = game:GetService("ReplicatedStorage")
					local remotes = modules.Game and modules.Game.Remotes or ReplicatedStorage:FindFirstChild("Shared") and ReplicatedStorage.Shared:FindFirstChild("Remotes") and require(ReplicatedStorage.Shared.Remotes)

					if remotes and remotes.EggWorld and remotes.EggWorld.AskDoffTool then
						remotes.EggWorld.AskDoffTool:InvokeServer()
					end
				end)
			end

			stealManager.FindDroppedFieldEgg = function(arg, arg2)
				local ReplicatedStorage = game:GetService("ReplicatedStorage")
				local eggState = modules.Game and modules.Game.EggState or ReplicatedStorage:FindFirstChild("Client") and ReplicatedStorage.Client:FindFirstChild("EggState") and require(ReplicatedStorage.Client.EggState)
				if not eggState or not eggState.ReadFieldEggs then
					return nil, math.huge
				end
				local ok, result = pcall(eggState.ReadFieldEggs)
				local v7, v8, v9 = ipairs(ok and result and (result.Records or result) or {})
				local huge = math.huge
				local v10 = nil

				for _, v11 in v7, v8, v9 do
					local flag = v11.Uid == arg
					local flag2

					if flag then
						flag2 = v11.State == "Dropped" or v11.State == "Slot"
					else
						flag2 = flag
					end

					flag2 = flag2 and (v11.CarrierUserId == nil or v11.CarrierUserId == localPlayer.UserId)

					if flag2 then
						local position = v11.BottomCFrame and v11.BottomCFrame.Position or v11.BoundsCFrame and v11.BoundsCFrame.Position

						if position then
							local magnitude = (position - arg2).Magnitude

							if magnitude < huge then
								huge = magnitude
								v10 = v11
							end
						end
					end
				end

				return v10, huge
			end

			stealManager.TeleportToSafeZone = function()
				return stealManager.GoToSafeZone and stealManager.GoToSafeZone(300, "SafeZone") or false
			end

			stealManager.PickForestBaitEgg = function(arg)
				local humanoidRootPart2 = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
				if not humanoidRootPart2 then
					return nil
				end
				local now = os.clock()
				farmState.RefreshEggs(true)
				local v7, v8, v9 = pairs(farmState.Eggs or {})
				local huge = math.huge
				local tbl11 = nil

				for _, v10 in v7, v8, v9 do
					if type(v10) == "table" and v10.Uid then
						local flag = v10.AreaId == "Forest"

						if not flag then
							flag = string.find(v10.Uid or "", "FirstArea", 1, true) ~= nil
						end

						if flag and (v10.State == "Slot" or v10.State == "Dropped") and v10.Uid ~= arg then
							local position = v10.BottomCFrame and v10.BottomCFrame.Position or v10.BoundsCFrame and v10.BoundsCFrame.Position or v10.Position or v10.CFrame and v10.CFrame.Position

							if position then
								local magnitude = (humanoidRootPart2.Position - position).Magnitude

								if stealManager.BaitBlacklist[v10.Uid] and now < stealManager.BaitBlacklist[v10.Uid] then
									magnitude += 500
								end

								if magnitude < huge then
									huge = magnitude
									tbl11 = v10
								end
							end
						end
					end
				end

				if not tbl11 then
					local areaEggSlotsClient = workspace:FindFirstChild("AreaEggSlotsClient")

					if areaEggSlotsClient then
						for _, child in ipairs(areaEggSlotsClient:GetChildren()) do
							if (child.Name:find("FirstArea", 1, true) or child.Name:find("Forest", 1, true)) and child.Name ~= arg then
								local hitbox = child:FindFirstChild("Hitbox")

								if hitbox then
									tbl11 = {
										Uid = child.Name,
										AreaId = "Forest",
										State = "Slot",
										BoundsCFrame = hitbox.CFrame,
										BottomCFrame = hitbox.CFrame,
										AssetCategory = "Egg",
									}

									huge = (humanoidRootPart2.Position - hitbox.Position).Magnitude
									break
								end
							end
						end
					end
				end

				return tbl11, huge
			end

			stealManager.TriggerForestStrike = function(arg)
				local guard = workspace:FindFirstChild("World") and workspace.World:FindFirstChild("Areas") and workspace.World.Areas:FindFirstChild("GuardAreas") and workspace.World.Areas.GuardAreas:FindFirstChild("Forest") and workspace.World.Areas.GuardAreas.Forest:FindFirstChild("Guard")
				local pivot = guard and guard:GetPivot() or CFrame.new()

				pcall(function()
					local ReplicatedStorage = game:GetService("ReplicatedStorage")
					local remotes = modules.Game and modules.Game.Remotes or require(ReplicatedStorage.Shared.Remotes)

					if remotes and remotes.GuardPatrol and remotes.GuardPatrol.ForestStrike then
						remotes.GuardPatrol.ForestStrike:FireServer({ EggUid = arg, GuardCFrame = pivot })
					end
				end)
			end

			stealManager.PickClosestEgg = stealManager.PickForestBaitEgg

			stealManager.GrabWithEggStateSpam = function(arg, arg2, arg3, arg4, arg5)
				arg3 = arg3 or 3
				local now = os.clock()
				local eggState = modules.Game and modules.Game.EggState
				local EggState

				if eggState then
					EggState = eggState
				else
					EggState = replicatedStorage:FindFirstChild("Client") and replicatedStorage.Client:FindFirstChild("EggState") and require(replicatedStorage.Client.EggState)
				end

				local remotes = modules.Game and modules.Game.Remotes
				local Remotes_2

				if remotes then
					Remotes_2 = remotes
				else
					Remotes_2 = replicatedStorage:FindFirstChild("Shared") and replicatedStorage.Shared:FindFirstChild("Remotes") and require(replicatedStorage.Shared.Remotes)
				end

				local networking = replicatedStorage:FindFirstChild("Packages") and replicatedStorage.Packages:FindFirstChild("Networking")
				local rfEggWorldAskFieldEggCarry = networking and networking:FindFirstChild("RF/EggWorld/AskFieldEggCarry")
				local flag = type(arg2) == "string" and #arg2 > 0 and arg2 or nil
				local carriedUid = tostring(arg)

				local function getCharacterRootPart()
					local character2 = localPlayer.Character
					return character2 and character2:FindFirstChild("HumanoidRootPart")
				end

				local function moveCarryToFlightPath()
					local v7 = getCharacterRootPart()
					if not v7 then
						return
					end
					local v8 = arg5 or stealManager.GetSafeZone()
					local flightY = stealManager.FlightY or 78
					local vector = Vector3.new(v8.X - v7.Position.X, 0, v8.Z - v7.Position.Z)
					local unit = vector.Magnitude > 0.1 and vector.Unit or Vector3.new(1, 0, 0)
					local vector2 = Vector3.new(v7.Position.X + unit.X * 28, flightY, v7.Position.Z + unit.Z * 28)
					v7.CFrame = CFrame.lookAt(vector2, vector2 + unit)
					v7.AssemblyLinearVelocity = Vector3.zero
					v7.AssemblyAngularVelocity = Vector3.zero
				end

				local n = 0
				local n2 = 0

				while os.clock() - now < arg3 do
					if not enabled["Auto Steal"] then
						return false
					end

					if stealManager.IsCarryingTargetEgg(carriedUid) then
						stealManager.GotEgg = true
						farmState.Carrying = true
						farmState.CarriedUid = carriedUid
						moveCarryToFlightPath()
						return true
					end

					local now2 = os.clock()

					if now2 - n > 0.3 then
						local v7 = getCharacterRootPart()

						if v7 and arg4 and (v7.Position - arg4).Magnitude > 9 then
							stealManager.TweenTo(arg4, math.max(stealManager.Speed or 650, 750), { Owner = "Steal" })
							n = now2
						else
							n = now2
						end
					end

					if EggState and EggState.CarryFieldEgg then
						local ok, result = pcall(function()
							return EggState.CarryFieldEgg(carriedUid, flag)
						end)

						if ok and result == true then
							stealManager.GotEgg = true
							farmState.Carrying = true
							farmState.CarriedUid = carriedUid
							moveCarryToFlightPath()
							return true
						end
					end

					if now2 - n2 > 0.14 then
						if rfEggWorldAskFieldEggCarry and rfEggWorldAskFieldEggCarry:IsA("RemoteFunction") then
							task.spawn(function()
								pcall(function()
									rfEggWorldAskFieldEggCarry:InvokeServer({ Uid = carriedUid, FirstAreaSlotKey = flag })
								end)

								if not flag then
									pcall(function()
										rfEggWorldAskFieldEggCarry:InvokeServer({ Uid = carriedUid })
									end)
								end
							end)
						end

						if Remotes_2 and Remotes_2.EggWorld and Remotes_2.EggWorld.AskFieldEggCarry then
							task.spawn(function()
								pcall(function()
									Remotes_2.EggWorld.AskFieldEggCarry:InvokeServer({ Uid = carriedUid, FirstAreaSlotKey = flag })
								end)

								if not flag then
									pcall(function()
										Remotes_2.EggWorld.AskFieldEggCarry:InvokeServer({ Uid = carriedUid })
									end)
								end
							end)

							n2 = now2
						else
							n2 = now2
						end
					end

					pcall(function()
						if fireproximityprompt then
							local areaEggSlotsClient = workspace:FindFirstChild("AreaEggSlotsClient")
							areaEggSlotsClient = areaEggSlotsClient and areaEggSlotsClient:FindFirstChild(carriedUid)

							if areaEggSlotsClient then
								for _, descendant in ipairs(areaEggSlotsClient:GetDescendants()) do
									if descendant:IsA("ProximityPrompt") and descendant.Enabled then
										fireproximityprompt(descendant, 0)
									end
								end
							end
						end
					end)

					task.wait(0.03)
				end

				local v7 = stealManager.IsCarryingTargetEgg(carriedUid)

				if v7 then
					stealManager.GotEgg = true
					farmState.Carrying = true
					farmState.CarriedUid = carriedUid
					moveCarryToFlightPath()
				end

				return v7
			end

			stealManager.HopTo = function(arg, arg2)
				local tbl11 = arg2 or {}
				return stealManager.TweenTo(arg, tbl11.Speed or stealManager.GetWalkSpeed(), tbl11)
			end

			stealManager.HopOnce = stealManager.HopTo

			stealManager.StartSpam = function(arg)
				stealManager.TweenTo(arg, stealManager.Speed or 350, { Owner = "Steal" })
			end

			stealManager.StopSpam = function()
			end

			stealManager.StartTeleport = stealManager.StartSpam
			stealManager.StopTeleport = stealManager.StopSpam
			stealManager.PlayRunAnimation = stealManager.StartRunAnimation

			stealManager.IsNight = function()
				local ok, result = pcall(function()
					if replicatedStorage:FindFirstChild("Shared") and replicatedStorage.Shared:FindFirstChild("Util") and replicatedStorage.Shared.Util:FindFirstChild("AreaEggCycle") then
						return require(replicatedStorage.Shared.Util.AreaEggCycle)
					end
					return require(replicatedStorage.Library.Util.AreaEggResetTimeUtil)
				end)

				if ok and type(result) == "table" then
					local serverTimeNow = workspace:GetServerTimeNow()
					if result.IsNightPhase then
						return result.IsNightPhase(serverTimeNow) == true
					end

					if result.IsNight then
						return result.IsNight(serverTimeNow) == true
					end
				end

				return false
			end

			stealManager.IsNightWallClosed = function()
				local ok, result = pcall(function()
					if replicatedStorage:FindFirstChild("Client") and replicatedStorage.Client:FindFirstChild("AreaEggResetWall") then
						return require(replicatedStorage.Client.AreaEggResetWall)
					end
					return require(replicatedStorage.Library.Client.AreaEggResetWall)
				end)

				if ok and type(result) == "table" then
					if result.IsSealed then
						return result.IsSealed() == true
					end

					if result.IsClosed then
						return result.IsClosed() == true
					end
				end

				local areas = workspace:FindFirstChild("World") and workspace.World:FindFirstChild("Areas")
				areas = areas and areas:FindFirstChild("WallStartVisual")
				if areas and areas:IsA("BasePart") and areas.Transparency < 0.9 and areas.Size.Y > 2 then
					return true
				end
				return false
			end

			stealManager.IsNightOrWallClosed = function()
				return stealManager.IsNight and stealManager.IsNight() or stealManager.IsNightWallClosed()
			end

			stealManager.WasNightOrClosed = true
			stealManager.PostResetBurstUntil = 0
			stealManager.LastWorkAt = 0
			stealManager.StealIdleGrace = 6

			stealManager.MarkWork = function()
				stealManager.LastWorkAt = os.clock()
			end

			stealManager.HasRecentWork = function()
				return os.clock() - (stealManager.LastWorkAt or 0) < (stealManager.StealIdleGrace or 6)
			end

			stealManager.IsEggAvailable = function(arg)
				if not arg then
					return false
				end
				farmState.RefreshEggs(true)
				local v7 = ipairs
				local eggs = farmState.Eggs or {}

				for _, egg in v7(eggs) do
					if egg.Uid == arg then
						if (egg.State == "Slot" or egg.State == "Dropped") and (egg.CarrierUserId == nil or egg.CarrierUserId == localPlayer.UserId) then
							return true, egg
						end
						return false, egg
					end
				end

				return false, nil
			end

			stealManager.AutoPickTrackedUid = nil
			stealManager.AutoPickLastPos = nil
			stealManager.AutoPickWasCarrying = false
			stealManager.AutoPickRecovering = false

			stealManager.IsHoldingEgg = function()
				local v7, v8 = farmState.GetCarryState()
				if v7 then
					return true, v8
				end

				if stealManager.EggInHand() then
					return true, nil
				end

				if stealManager.GetEggTool and stealManager.GetEggTool() then
					return true, nil
				end
				return false, nil
			end

			stealManager.DropCurrentEgg = function()
				stealManager.PlayerDropped = true

				pcall(function()
					local ReplicatedStorage = game:GetService("ReplicatedStorage")
					local eggState = modules.Game and modules.Game.EggState or ReplicatedStorage:FindFirstChild("Client") and ReplicatedStorage.Client:FindFirstChild("EggState") and require(ReplicatedStorage.Client.EggState)

					if eggState and eggState.DropFieldEgg then
						eggState.DropFieldEgg("Manual")
					else
						local remotes = modules.Game and modules.Game.Remotes

						if not remotes then
							remotes = ReplicatedStorage:FindFirstChild("Shared") and ReplicatedStorage.Shared:FindFirstChild("Remotes") and require(ReplicatedStorage.Shared.Remotes)
						end

						if remotes and remotes.EggWorld and remotes.EggWorld.AskFieldEggDrop then
							remotes.EggWorld.AskFieldEggDrop:InvokeServer({ Reason = "Manual" })
						end
					end
				end)

				pcall(function()
					local humanoid2 = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")

					if humanoid2 then
						stealManager.ResetHumanoidState(humanoid2)
						local getEggTool = stealManager.GetEggTool and stealManager.GetEggTool()

						if getEggTool then
							local backpack = localPlayer:FindFirstChildOfClass("Backpack")

							if backpack then
								getEggTool.Parent = backpack
							end
						end
					end
				end)

				pcall(function()
					local character2 = localPlayer.Character
					local backpack = localPlayer:FindFirstChildOfClass("Backpack")

					for _, v7 in ipairs({ character2, backpack }) do
						if v7 then
							for _, child in ipairs(v7:GetChildren()) do
								if child:IsA("Tool") and child:GetAttribute("ItemType") == "AssetEgg" then
									child.Parent = workspace
								end
							end
						end
					end
				end)

				stealManager.GotEgg = false
				farmState.Carrying = false
				farmState.CarriedUid = nil
				farmState.CarriedAssetCategory = nil
				farmState.OptimisticCarry = false
				stealManager.AutoPickWasCarrying = false
				stealManager.AutoPickTrackedUid = nil
			end

			stealManager.FireGrab = function(arg)
				if not arg or not arg.Uid then
					return
				end
				local resolveSlotKey = stealManager.ResolveSlotKey and stealManager.ResolveSlotKey(arg) or nil

				pcall(function()
					if fireproximityprompt then
						local areaEggSlotsClient = workspace:FindFirstChild("AreaEggSlotsClient")
						areaEggSlotsClient = areaEggSlotsClient and areaEggSlotsClient:FindFirstChild(arg.Uid)

						if areaEggSlotsClient then
							for _, descendant in ipairs(areaEggSlotsClient:GetDescendants()) do
								if descendant:IsA("ProximityPrompt") and descendant.Enabled then
									fireproximityprompt(descendant, 0)
								end
							end
						end
					end
				end)

				pcall(function()
					local eggCmds = modules.Game and modules.Game.EggCmds
					if Remotes_ and Remotes_.EggWorld and Remotes_.EggWorld.AskFieldEggCarry then
						return Remotes_.EggWorld.AskFieldEggCarry:InvokeServer({ Uid = arg.Uid, FirstAreaSlotKey = resolveSlotKey })
					end

					if eggCmds and eggCmds.RequestCarryAreaEgg then
						return eggCmds.RequestCarryAreaEgg(arg.Uid, resolveSlotKey)
					end
				end)
			end

			stealManager.PlayerDropped = false
			stealManager.PlayerDropHookDone = false

			stealManager.HookDropButton = function(arg)
				if not arg then
					return
				end

				local function bindDropButton(descendant)
					if descendant:IsA("GuiButton") then
						descendant.Activated:Connect(function()
							stealManager.PlayerDropped = true
						end)
					end
				end

				for _, descendant in ipairs(arg:GetDescendants()) do
					bindDropButton(descendant)
				end

				arg.DescendantAdded:Connect(bindDropButton)
			end

			stealManager.EnsurePlayerDropHook = function()
				if stealManager.PlayerDropHookDone then
					return
				end
				stealManager.PlayerDropHookDone = true
				local playerGui2 = playerGui or localPlayer and localPlayer:FindFirstChild("PlayerGui")
				local dropHeldEgg = playerGui2 and playerGui2:FindFirstChild("DropHeldEgg")

				if dropHeldEgg then
					stealManager.HookDropButton(dropHeldEgg)
				end

				if playerGui2 then
					playerGui2.ChildAdded:Connect(function(child)
						if child.Name == "DropHeldEgg" then
							stealManager.HookDropButton(child)
						end
					end)
				end

				pcall(function()
					local eggState = modules.Game and modules.Game.EggState

					if eggState and type(eggState.DropFieldEgg) == "function" then
						local dropFieldEgg = eggState.DropFieldEgg
						local flag = false

						eggState.DropFieldEgg = function(...)
							stealManager.PlayerDropped = true
							if flag then
								return
							end
							flag = true
							local ok, result = pcall(dropFieldEgg, ...)
							flag = false
							return result
						end
					end
				end)
			end

			stealManager.AutoPickStep = function()
				stealManager.EnsurePlayerDropHook()
				local humanoidRootPart2 = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
				local v7, v8 = stealManager.IsHoldingEgg()

				if v7 then
					if not stealManager.AutoPickWasCarrying then
						stealManager.PlayerDropped = false
					end

					stealManager.AutoPickWasCarrying = true
					stealManager.AutoPickRecovering = false

					if v8 then
						stealManager.AutoPickTrackedUid = v8
					elseif not stealManager.AutoPickTrackedUid then
						farmState.RefreshEggs(true)
						local v9 = ipairs
						local eggs = farmState.Eggs or {}

						for _, egg in v9(eggs) do
							if egg.CarrierUserId == localPlayer.UserId then
								stealManager.AutoPickTrackedUid = egg.Uid
								break
							end
						end
					end

					if humanoidRootPart2 then
						stealManager.AutoPickLastPos = humanoidRootPart2.Position
					end

					return
				end

				if not stealManager.AutoPickWasCarrying then
					return
				end

				if stealManager.PlayerDropped then
					stealManager.PlayerDropped = false
					stealManager.AutoPickWasCarrying = false
					stealManager.AutoPickTrackedUid = nil
					return
				end

				if stealManager.IsInSafeZone() then
					stealManager.AutoPickWasCarrying = false
					stealManager.AutoPickTrackedUid = nil
					return
				end

				local baitBlacklist = stealManager.AutoPickTrackedUid and stealManager.BaitBlacklist and stealManager.BaitBlacklist[stealManager.AutoPickTrackedUid]
				local flag

				if baitBlacklist then
					local v9 = stealManager.BaitBlacklist[stealManager.AutoPickTrackedUid]
					flag = os.clock() < v9
				else
					flag = baitBlacklist
				end

				if flag then
					stealManager.AutoPickWasCarrying = false
					stealManager.AutoPickTrackedUid = nil
					return
				end

				if enabled["Auto Steal"] and stealManager.IsStealing then
					return
				end

				if stealManager.AutoPickRecovering then
					return
				end
				stealManager.AutoPickRecovering = true
				local humanoid2 = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")

				if humanoid2 then
					stealManager.ResetHumanoidState(humanoid2)
				end

				humanoidRootPart2 = humanoidRootPart2 and humanoidRootPart2.Position or stealManager.AutoPickLastPos
				local autoPickTrackedUid = stealManager.AutoPickTrackedUid
				_G.LastAction = "Auto Pick: Recovering Dropped Egg"
				movement.Claim("AutoPick", 90)

				while true do
					if enabled["Auto Pick Dropped Egg"] and not shx.Unloaded then
						if not stealManager.IsHoldingEgg() then
							farmState.RefreshEggs(true)
							local v9, flag2

							if autoPickTrackedUid then
								local v10 = ipairs
								local eggs = farmState.Eggs or {}
								v9 = nil
								flag2 = false

								for _, egg in v10(eggs) do
									local flag3 = egg.Uid == autoPickTrackedUid and (egg.State == "Dropped" or egg.State == "Slot")
									local flag4

									if flag3 then
										flag4 = egg.CarrierUserId == nil or egg.CarrierUserId == localPlayer.UserId
									else
										flag4 = flag3
									end

									if flag4 then
										if egg.State ~= "Dropped" then
											v9 = egg
										else
											flag2 = true
											v9 = egg
										end

										break
									else
										v9 = nil
									end
								end
							else
								local v10, v11, v12 = ipairs(farmState.Eggs or {})
								flag2 = false
								local huge = math.huge
								v9 = nil

								for _, v13 in v10, v11, v12 do
									if (v13.State == "Dropped" or v13.State == "Slot") and (v13.CarrierUserId == nil or v13.CarrierUserId == localPlayer.UserId) then
										if v13.State == "Dropped" then
											flag2 = true
										end

										local position = v13.BottomCFrame and v13.BottomCFrame.Position or v13.BoundsCFrame and v13.BoundsCFrame.Position
										local magnitude = position and humanoidRootPart2 and (position - humanoidRootPart2).Magnitude or 0

										if v13.State == "Dropped" then
											magnitude -= 100
										end

										if magnitude < huge then
											huge = magnitude
											v9 = v13
										end
									end
								end
							end

							if v9 then
								local position = v9.BottomCFrame and v9.BottomCFrame.Position or v9.BoundsCFrame and v9.BoundsCFrame.Position
								local humanoidRootPart3 = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")

								if position and humanoidRootPart3 and (humanoidRootPart3.Position - position).Magnitude > 20 then
									if humanoid2 then
										stealManager.ResetHumanoidState(humanoid2)
									end

									humanoidRootPart3.CFrame = CFrame.new(position.X, position.Y + 2.8, position.Z)
									humanoidRootPart3.AssemblyLinearVelocity = Vector3.zero
									humanoidRootPart3.AssemblyAngularVelocity = Vector3.zero
								end

								stealManager.FireGrab(v9)
								stealManager.FireGrab(v9)
							end

							local flag3 = not flag2

							if flag3 then
								v9 = autoPickTrackedUid and v9
								flag3 = not v9
							end

							if not flag3 then
								task.wait()
								continue
							end
						end
					end

					break
				end

				movement.Release("AutoPick")

				if stealManager.IsHoldingEgg() then
					stealManager.GotEgg = true
					farmState.Carrying = true
					_G.LastAction = "Auto Pick: Egg Recovered"
				end

				stealManager.AutoPickWasCarrying = false
				stealManager.AutoPickRecovering = false
			end

			stealManager.IsEggInfested = function(arg)
				if not arg then
					return false
				end

				if arg.HasParasite == true then
					return true
				end

				if arg.Infested == true or arg.HasInfested == true or arg.IsInfested == true then
					return true
				end

				if arg.BaseMutation == "Parasite" or arg.BaseMutation == "MonsterParasite" then
					return true
				end

				if type(arg.Mutations) == "table" then
					for _, mutation in pairs(arg.Mutations) do
						if mutation == "Parasite" or mutation == "MonsterParasite" then
							return true
						end
					end
				end

				return false
			end

			stealManager.PickTarget = function()
				local scramble = modules.Scramble
				if (scramble and scramble.Config and scramble.Config.OrchestratorMode or "Prioritize Event") ~= "Steal Idle" and enabled["Auto Farm Drones"] and scramble and scramble.CanRun and scramble.CanRun() then
					return nil
				end
				farmState.RefreshEggs(os.clock() < (stealManager.PostResetBurstUntil or 0))
				local humanoidRootPart2 = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
				if not humanoidRootPart2 then
					return nil
				end
				local now = os.clock()

				for k, blockedEgg in pairs(tbl6.BlockedEggs) do
					if blockedEgg <= now then
						tbl6.BlockedEggs[k] = nil
					end
				end

				local tbl11 = {}
				local v7 = pairs
				local eggs = farmState.Eggs or {}

				for _, egg in v7(eggs) do
					if type(egg) == "table" and egg.Uid then
						tbl11[egg.Uid] = true
					end
				end

				for k in pairs(stealManager.FailCounts) do
					if not tbl11[k] then
						stealManager.FailCounts[k] = nil
					end
				end

				local v8 = pairs
				local eggs2 = farmState.Eggs or {}

				for _, v9 in v8(eggs2) do
					local flag = type(v9) == "table" and v9.State == "Dropped"

					if flag then
						flag = (stealManager.FailCounts[v9.Uid] or 0) < 4
					end

					if flag then
						tbl6.BlockedEggs[v9.Uid] = nil
					end
				end

				local flag = stealManager.HasSpecificEggFilters == true
				local prioritizeRiftEgg = enabled["Prioritize Rift Egg"] or enabled["Prioritize Rift Recipe Eggs"]
				local rift = modules.Rift

				if prioritizeRiftEgg and rift and rift.IsBannerDesired and not rift.IsBannerDesired() then
					prioritizeRiftEgg = false
				end

				local tbl12 = {}

				if prioritizeRiftEgg and rift then
					if rift.GetNeededRecipeEggCategories then
						pcall(function()
							tbl12 = rift.GetNeededRecipeEggCategories() or {}
						end)
					else
						local getState = rift.GetState and rift.GetState()

						if getState and getState.Requirements then
							for _, requirement in ipairs(getState.Requirements) do
								local str = tostring(type(requirement) == "table" and (requirement.Category or requirement.Id or requirement.Name) or requirement)

								if str then
									tbl12[str] = 1
								end
							end
						end
					end
				end

				local getMinRarity = stealManager.GetMinRarity and stealManager.GetMinRarity() or stealManager.MinRarity or 1
				local v9, v10, v11 = pairs(farmState.Eggs or {})
				local n = -math.huge
				local v12 = nil

				for _, v13 in v9, v10, v11 do
					local uid = type(v13) == "table" and v13.Uid
					local flag2

					if uid then
						flag2 = v13.State == "Slot" or v13.State == "Dropped"
					else
						flag2 = uid
					end

					if flag2 then
						local v14 = stealManager.IsSpecificEggSelected(v13)
						local v15 = stealManager.IsAreaSelected(v13.AreaId)
						local flag3 = stealManager.GetEggRarityNumber(v13) >= getMinRarity
						local assetCategory = prioritizeRiftEgg and v13.AssetCategory

						if assetCategory then
							assetCategory = (tbl12[tostring(v13.AssetCategory)] or 0) > 0
						end

						if flag then
							v15 = v14 and v15
						else
							v15 = flag3 and v15 or assetCategory
						end

						if v15 or assetCategory then
							local v16 = tbl6.BlockedEggs[v13.Uid]

							if not (v16 and now < v16) then
								local position = v13.BottomCFrame and v13.BottomCFrame.Position or v13.BoundsCFrame and v13.BoundsCFrame.Position or nil

								if position then
									local v17 = stealManager.CalculateEggScore(v13, (humanoidRootPart2.Position - position).Magnitude)
									local n2

									if flag and v14 then
										n2 = v17 + 5e9
									elseif assetCategory then
										n2 = v17 + 3e9
									else
										n2 = v17 + 1e9
									end

									if n < n2 then
										n = n2
										v12 = v13
									end
								end
							end
						end
					end
				end

				local flag2 = not v12

				if flag2 then
					flag2 = #(farmState.Eggs or {}) == 0
				end

				local v13

				if flag2 then
					local areaEggSlotsClient = workspace:FindFirstChild("AreaEggSlotsClient")

					if areaEggSlotsClient then
						for _, child in ipairs(areaEggSlotsClient:GetChildren()) do
							local hitbox = child:FindFirstChild("Hitbox")
							local flag3

							if hitbox then
								flag3 = not (tbl6.BlockedEggs[child.Name] and now < tbl6.BlockedEggs[child.Name])
							else
								flag3 = hitbox
							end

							if flag3 then
								local attribute = child:GetAttribute("AssetCategory") or child.Name

								local tbl13 = {
									Uid = child.Name,
									AreaId = "Unknown",
									State = "Slot",
									BoundsCFrame = hitbox.CFrame,
									BottomCFrame = hitbox.CFrame,
									AssetCategory = attribute,
								}

								local v14 = stealManager.IsSpecificEggSelected(tbl13)
								local flag4 = stealManager.GetEggRarityNumber(tbl13) >= getMinRarity
								local flag5

								if prioritizeRiftEgg then
									flag5 = (tbl12[tostring(attribute)] or 0) > 0
								else
									flag5 = prioritizeRiftEgg
								end

								if not flag then
									v14 = flag4 or flag5
								end

								if v14 then
									v12 = tbl13
									break
								end
							end
						end

						v13 = v12
					else
						v13 = v12
					end
				else
					v13 = v12
				end

				return v13
			end

			local AreaEggSlotIdentity = nil

			pcall(function()
				AreaEggSlotIdentity = require(game:GetService("ReplicatedStorage").Shared.Util.AreaEggSlotIdentity)
			end)

			stealManager.ResolveSlotKey = function(arg)
				if not arg or not arg.Uid then
					return nil
				end

				if arg.State == "Dropped" then
					return nil
				end
				local nestId = arg.NestId or string.match(arg.Uid, "(Slot_%d+)")
				local areaId = arg.AreaId or "Forest"

				if nestId and AreaEggSlotIdentity and AreaEggSlotIdentity.LooksLikeFirstAreaUid and AreaEggSlotIdentity.LooksLikeFirstAreaUid(arg.Uid) then
					local ok, result = pcall(function()
						return AreaEggSlotIdentity.SlotKey(areaId, nestId)
					end)

					if ok and result then
						return result
					end
				end

				if nestId then
					return tostring(areaId) .. ":" .. tostring(nestId)
				end
				return nil
			end

			stealManager.Collect = function(arg)
				local ok, result = pcall(function()
					if modules.Game and modules.Game.EggState and modules.Game.EggState.ReadFieldEggs then
						return modules.Game.EggState.ReadFieldEggs()
					end
					return require(game:GetService("ReplicatedStorage").Client.EggState).ReadFieldEggs()
				end)

				local v7, v8, v9 = ipairs(ok and result and (result.Records or result) or {})
				local n = 0

				for _, v10 in v7, v8, v9 do
					if v10.State == arg then
						local v11 = stealManager.ResolveSlotKey(v10)

						local ok2, result2 = pcall(function()
							if Remotes_ and Remotes_.EggWorld and Remotes_.EggWorld.AskFieldEggCarry then
								return Remotes_.EggWorld.AskFieldEggCarry:InvokeServer({ Uid = v10.Uid, FirstAreaSlotKey = v11 })
							end
							return require(game:GetService("ReplicatedStorage").Shared.Remotes).EggWorld.AskFieldEggCarry:InvokeServer({ Uid = v10.Uid, FirstAreaSlotKey = v11 })
						end)

						if ok2 and (result2 == true or type(result2) == "table" and result2.Outcome == true) then
							n += 1
						end
					end
				end

				return n
			end

			stealManager.IsActiveStealing = function()
				if not enabled["Auto Steal"] then
					return false
				end

				if stealManager.IsStealing then
					return true
				end

				if stealManager.IsNightOrWallClosed and stealManager.IsNightOrWallClosed() then
					return false
				end

				if farmState.GetCarryState() then
					return true
				end
				return stealManager.PickTarget() ~= nil
			end

			stealManager.ReturnEggToSafeZone = function(arg, arg2, arg3)
				arg2 = arg2 or stealManager.GetSafeZone()

				local function isCarryingTargetEgg()
					return stealManager.IsCarryingTargetEgg(arg.Uid)
				end

				local function isGroundedInSafeZone()
					return stealManager.IsGroundedInSafeZone and stealManager.IsGroundedInSafeZone(arg2)
				end

				if not isCarryingTargetEgg() then
					stealManager.GotEgg = false
					farmState.Carrying = false
					farmState.CarriedUid = nil
					return false
				end

				local claimedAt = farmState.ClaimedAt or 0
				os.clock()
				_G.LastAction = string.format("Steal: Memulai transit ke SafeZone (Elevasi Y=%.0f)...", stealManager.FlightY or 78)
				local n = 0
				local vector

				while enabled["Auto Steal"] do
					local humanoidRootPart2 = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
					if not humanoidRootPart2 then
						return false
					end

					if not isCarryingTargetEgg() then
						local flag = (farmState.ClaimedAt or 0) > claimedAt

						if flag then
							local claimedAt2 = farmState.ClaimedAt
							flag = os.clock() - claimedAt2 < 4
						end

						if isGroundedInSafeZone() and flag then
							stealManager.GotEgg = false
							farmState.Carrying = false
							farmState.CarriedUid = nil
							return true
						end

						n += 1

						if n > 5 then
							_G.LastAction = string.format("Steal: Recovery Gagal (%d/%d). Mengembalikan ke SafeZone...", n, 5)
							stealManager.GotEgg = false
							farmState.Carrying = false
							farmState.CarriedUid = nil
							stealManager.EnsureAtSafeZone(true)
							return false
						end

						_G.LastAction = string.format("Steal: [Recovery %d/%d] Telur terlepas! Mencari koordinat jatuhnya telur...", n, 5)
						local humanoid2 = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")

						if humanoid2 then
							stealManager.ResetHumanoidState(humanoid2)
						end

						local now = os.clock()

						while true do
							vector = nil

							if not (os.clock() - now < 0.4) then
								break
							else
								local v7 = stealManager.FindDroppedFieldEgg(arg.Uid, humanoidRootPart2.Position)

								if v7 then
									local position = v7.BottomCFrame and v7.BottomCFrame.Position or v7.BoundsCFrame and v7.BoundsCFrame.Position

									if position then
										vector = Vector3.new(position.X, position.Y + 2.5, position.Z)
										break
									else
										task.wait(0.04)
									end
								else
									task.wait(0.04)
								end
							end
						end

						if vector then
							local magnitude = (humanoidRootPart2.Position - vector).Magnitude

							if magnitude > 2.5 then
								_G.LastAction = string.format("Steal: Tween ke telur jatuh (%.1f studs)...", magnitude)
								stealManager.TweenTo(vector, math.max(stealManager.Speed or 650, 750), { Owner = "Steal" })
							end
						end

						local grabWithEggStateSpam = stealManager.GrabWithEggStateSpam
						local uid = arg.Uid
						vector = vector or humanoidRootPart2.Position

						if grabWithEggStateSpam(uid, arg3, 2, vector, arg2) or isCarryingTargetEgg() then
							_G.LastAction = string.format("Steal: [Recovery %d/%d] Re-grab Sukses via Tween! Melanjutkan transit...", n, 5)
						else
							task.wait(0.04)
						end

						continue
					end

					local flightY = stealManager.FlightY or 78
					local position = humanoidRootPart2.Position
					local vector2 = Vector3.new(arg2.X - position.X, 0, arg2.Z - position.Z)
					local magnitude = vector2.Magnitude
					local unit = magnitude > 0.1 and vector2.Unit or Vector3.new(1, 0, 0)

					if position.Y < flightY - 2 and magnitude > 15 then
						local n2 = math.min(30, magnitude * 0.5)
						stealManager.TweenTo(Vector3.new(position.X + unit.X * n2, flightY, position.Z + unit.Z * n2), math.max(stealManager.Speed or 650, 600), { Owner = "Steal", TargetEggUid = arg.Uid, AbortOnEggDrop = true })
					end

					if isCarryingTargetEgg() then
						local vector3 = Vector3.new(arg2.X, flightY, arg2.Z)

						if (Vector3.new(humanoidRootPart2.Position.X, 0, humanoidRootPart2.Position.Z) - Vector3.new(arg2.X, 0, arg2.Z)).Magnitude > 8 then
							stealManager.TweenTo(vector3, stealManager.Speed or 650, { Owner = "Steal", TargetEggUid = arg.Uid, AbortOnEggDrop = true })
						end
					end

					if isCarryingTargetEgg() then
						stealManager.TweenTo(Vector3.new(arg2.X, arg2.Y, arg2.Z), math.max(stealManager.Speed or 650, 400), { Owner = "Steal", TargetEggUid = arg.Uid, AbortOnEggDrop = true })
					end

					if isGroundedInSafeZone() then
						_G.LastAction = "Steal: Karakter mendarat di SafeZone, menunggu claim server..."
						local now = os.clock()

						while os.clock() - now < 2.5 do
							local flag = (farmState.ClaimedAt or 0) > claimedAt

							if flag then
								local claimedAt2 = farmState.ClaimedAt
								flag = os.clock() - claimedAt2 < 4
							end

							if not (flag or not isCarryingTargetEgg()) then
								task.wait(0.05)
								continue
							end
							break
						end

						local flag = (farmState.ClaimedAt or 0) > claimedAt

						if flag then
							local claimedAt2 = farmState.ClaimedAt
							flag = os.clock() - claimedAt2 < 4
						end

						if not flag and not isCarryingTargetEgg() and isGroundedInSafeZone() then
							flag = true
						end

						if flag then
							stealManager.GotEgg = false
							farmState.Carrying = false
							farmState.CarriedUid = nil
							return true
						end
					end

					task.wait(0.04)
				end

				return false
			end

			stealManager.Step = function()
				if not enabled["Auto Steal"] then
					modules.Movement.Release("Steal")
					return
				end

				if enabled["Auto Farm Drones"] and modules.Scramble and modules.Scramble.CanRun and modules.Scramble.CanRun() then
					stealManager.IsStealing = false
					stealManager.GotEgg = false
					modules.Movement.Release("Steal")
					stealManager.StopRunAnimation()
					return
				end

				if farmState.IsPlacing or modules.PlaceEgg and modules.PlaceEgg.Busy or modules.Sell and modules.Sell.IsSelling then
					return
				end

				if stealManager.IsNightOrWallClosed and stealManager.IsNightOrWallClosed() then
					stealManager.WasNightOrClosed = true
					_G.LastAction = "Steal: Night/Wall Standby (SafeZone Prepare)"
					stealManager.IsStealing = false
					stealManager.GotEgg = false
					farmState.Carrying = false
					farmState.CarriedUid = nil
					farmState.CarriedAssetCategory = nil
					farmState.OptimisticCarry = false
					modules.Movement.Release("Steal")
					stealManager.StopRunAnimation()
					if enabled["Auto Treadmill"] and modules.Treadmill and modules.Treadmill.CheckTreadmil and modules.Treadmill.CheckTreadmil() then
						return
					end
					local n = 0

					while true do
						if (not stealManager.IsInSafeZone() or modules.Treadmill and modules.Treadmill.CheckTreadmil and modules.Treadmill.CheckTreadmil()) and n < 4 then
							if not (not enabled["Auto Steal"] or not stealManager.IsNightOrWallClosed()) then
								n += 1

								if modules.Treadmill and modules.Treadmill.CheckTreadmil and modules.Treadmill.CheckTreadmil() then
									_G.LastAction = "Steal: Night Exit Treadmill (" .. tostring(n) .. ")"
									modules.Treadmill.ExitToSafeZone()
									task.wait(0.05)
								end

								_G.LastAction = "Steal: Night Go SafeZone (" .. tostring(n) .. ")"
								stealManager.GoToSafeZone(300, "SafeZone")
								task.wait(0.08)
								continue
							end
						end

						break
					end

					return
				end

				local getCapacityStatus = modules.PlaceEgg and modules.PlaceEgg.GetCapacityStatus and modules.PlaceEgg.GetCapacityStatus()
				local canPlace = getCapacityStatus and getCapacityStatus.canPlace
				getCapacityStatus = getCapacityStatus and getCapacityStatus.unplacedCount or 0
				if enabled["Auto Place Egg"] and modules.PlaceEgg and modules.PlaceEgg.Rule == "After Steal" and canPlace then
					modules.PlaceEgg.Step()
					return
				end

				if enabled["Auto Place Egg"] and modules.PlaceEgg and modules.PlaceEgg.Rule == "Egg Inventory Full" and getCapacityStatus >= 95 and canPlace then
					modules.PlaceEgg.Step()
					return
				end

				if stealManager.WasNightOrClosed then
					stealManager.WasNightOrClosed = false
					stealManager.PostResetBurstUntil = os.clock() + 20
					farmState.RefreshEggs(true)
				end

				_G.LastAction = "Steal: Scan Target Egg"
				local v7 = stealManager.PickTarget()

				if not v7 then
					_G.LastAction = "Steal: Idle (No Target)"
					stealManager.IsStealing = false
					stealManager.GotEgg = false
					modules.Movement.Release("Steal")
					stealManager.StopRunAnimation()
					local getEggTool = stealManager.GetEggTool and stealManager.GetEggTool()

					if getEggTool then
						local backpack = localPlayer:FindFirstChildOfClass("Backpack")

						if backpack then
							getEggTool.Parent = backpack
						end
					end

					if enabled["Auto Place Egg"] and modules.PlaceEgg and modules.PlaceEgg.Rule == "Steal Idle" and canPlace then
						modules.PlaceEgg.Step()
					end

					if modules.Sell and modules.Sell.Step then
						modules.Sell.Step()
					end

					if os.clock() < (stealManager.PostResetBurstUntil or 0) then
						task.wait(0.05)
					else
						task.wait(0.5)
					end

					return
				end

				if not modules.Movement.Claim("Steal", 100) then
					return
				end
				stealManager.EnsureCarryHook()
				stealManager.EnsureClaimHook()
				stealManager.EnsureRigSyncHook()
				stealManager.ApplyAntiTpBypass()

				if stored.StateUpdate["Anti Knockback / Ragdoll"] and not enabled["Anti Knockback / Ragdoll"] then
					stored.StateUpdate["Anti Knockback / Ragdoll"]:Set(true)
				end

				if modules.Treadmill and modules.Treadmill.CheckTreadmil and modules.Treadmill.CheckTreadmil() then
					_G.LastAction = "Steal: Exit Treadmill"
					modules.Treadmill.ExitToSafeZone()
				end

				stealManager.UnequipAllTools()
				stealManager.GotEgg = false
				farmState.Carrying = false
				farmState.CarriedUid = nil
				farmState.CarriedAssetCategory = nil
				farmState.OptimisticCarry = false
				local position = v7.BottomCFrame and v7.BottomCFrame.Position or v7.BoundsCFrame and v7.BoundsCFrame.Position or nil
				if not position then
					modules.Movement.Release("Steal")
					return
				end
				local areaEggSlotsClient = workspace:FindFirstChild("AreaEggSlotsClient") and workspace.AreaEggSlotsClient:FindFirstChild(v7.Uid)
				areaEggSlotsClient = areaEggSlotsClient and areaEggSlotsClient:FindFirstChild("Hitbox")
				areaEggSlotsClient = areaEggSlotsClient and areaEggSlotsClient.Position
				local vector

				if areaEggSlotsClient then
					vector = areaEggSlotsClient
				else
					vector = Vector3.new(position.X, v7.BottomCFrame and v7.BottomCFrame.Position.Y + 1.8 or position.Y + 1.8, position.Z)
				end

				local resolveSlotKey = stealManager.ResolveSlotKey and stealManager.ResolveSlotKey(v7) or nil
				local v8 = stealManager.GetSafeZone()
				stealManager.IsStealing = true
				stealManager.GotEgg = false
				farmState.ClaimedAt = 0
				local humanoidRootPart2 = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
				local humanoid2 = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")

				if not humanoidRootPart2 or not humanoid2 then
					stealManager.IsStealing = false
					modules.Movement.Release("Steal")
					return
				end

				local magnitude = (humanoidRootPart2.Position - vector).Magnitude
				_G.LastAction = string.format("Steal: Target %s [%s] (%.0f studs)", tostring(v7.AssetCategory or "Egg"), tostring(v7.AreaId), magnitude)
				stealManager.EnsureAtSafeZone()
				local humanoidRootPart3 = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")

				if not humanoidRootPart3 then
					stealManager.IsStealing = false
					modules.Movement.Release("Steal")
					return
				end

				if enabled["Auto Farm Drones"] and modules.Scramble and modules.Scramble.CanRun and modules.Scramble.CanRun() then
					stealManager.IsStealing = false
					modules.Movement.Release("Steal")
					return
				end

				local v9 = stealManager.PickForestBaitEgg(v7.Uid)
				local flag = not v9

				if flag then
					flag = v7.AreaId == "Forest"

					if not flag then
						flag = string.find(v7.Uid or "", "FirstArea", 1, true)
					end
				end

				if flag then
					v9 = v7
				end

				if not v9 then
					_G.LastAction = "Steal: Waiting for Forest Bait Egg to spawn..."
					task.wait(0.3)
					stealManager.IsStealing = false
					modules.Movement.Release("Steal")
					return
				end

				local position2 = v9.BottomCFrame and v9.BottomCFrame.Position or v9.BoundsCFrame and v9.BoundsCFrame.Position or v9.Position or v9.CFrame and v9.CFrame.Position
				local areaEggSlotsClient2 = workspace:FindFirstChild("AreaEggSlotsClient") and workspace.AreaEggSlotsClient:FindFirstChild(v9.Uid)
				areaEggSlotsClient2 = areaEggSlotsClient2 and areaEggSlotsClient2:FindFirstChild("Hitbox")
				areaEggSlotsClient2 = areaEggSlotsClient2 and areaEggSlotsClient2.Position or position2 and position2 + Vector3.new(0, 1.5, 0) or Vector3.new(595, 69, -325)
				local resolveSlotKey2 = stealManager.ResolveSlotKey and stealManager.ResolveSlotKey(v9) or nil
				local magnitude2 = (humanoidRootPart3.Position - areaEggSlotsClient2).Magnitude

				if magnitude2 > 120 then
					_G.LastAction = string.format("Steal: Jarak bait jauh (%.0f studs). Meluncur mendatar di Y=%.0f...", magnitude2, stealManager.FlightY or 78)
					stealManager.TweenTo(Vector3.new(areaEggSlotsClient2.X, stealManager.FlightY or 78, areaEggSlotsClient2.Z), math.max(stealManager.Speed or 650, 750), { Owner = "Steal" })
					stealManager.TweenTo(areaEggSlotsClient2, math.max(stealManager.Speed or 650, 450), { Owner = "Steal" })
				else
					_G.LastAction = string.format("Steal: [1/4] Snap ke Forest Bait Egg (%s)...", tostring(v9.AssetCategory or "Egg"))
					humanoidRootPart3.CFrame = CFrame.new(areaEggSlotsClient2)
				end

				humanoidRootPart3.AssemblyLinearVelocity = Vector3.zero
				humanoidRootPart3.AssemblyAngularVelocity = Vector3.zero
				task.wait(0.25)
				local now = os.clock()
				local flag2

				while true do
					flag2 = false

					if not (os.clock() - now < 2) then
						break
					else
						humanoidRootPart3.CFrame = CFrame.new(areaEggSlotsClient2)
						humanoidRootPart3.AssemblyLinearVelocity = Vector3.zero

						local ok, result = pcall(function()
							local eggState = modules.Game and modules.Game.EggState or replicatedStorage:FindFirstChild("Client") and replicatedStorage.Client:FindFirstChild("EggState") and require(replicatedStorage.Client.EggState)
							if eggState and eggState.CarryFieldEgg then
								return eggState.CarryFieldEgg(v9.Uid, resolveSlotKey2)
							end
						end)

						if result == true or stealManager.IsHoldingEgg() then
							flag2 = true
							break
						else
							task.wait(0.05)
						end
					end
				end

				if flag2 or stealManager.IsHoldingEgg() then
					_G.LastAction = "Steal: [2/4] Trigger ForestStrike (Grace Impact)..."
					stealManager.RagdollActive = false
					stealManager.TriggerForestStrike(v9.Uid)
					local now2 = os.clock()

					while os.clock() - now2 < 1.2 do
						if not (stealManager.RagdollActive or stealManager.GraceActive()) then
							task.wait(0.04)
							continue
						end
						break
					end

					if v9.Uid ~= v7.Uid then
						if stealManager.BaitBlacklist then
							stealManager.BaitBlacklist[v9.Uid] = os.clock() + 4
						end

						stealManager.DropCurrentEgg()
						stealManager.GotEgg = false
						farmState.Carrying = false
						farmState.CarriedUid = nil
					end

					_G.LastAction = string.format("Steal: [3/4] Teleport instant ke target egg %s (Jarak: %.0f studs)...", tostring(v7.AssetCategory or "Egg"), magnitude)
					humanoidRootPart3.CFrame = CFrame.new(vector)
					humanoidRootPart3.AssemblyLinearVelocity = Vector3.zero
					humanoidRootPart3.AssemblyAngularVelocity = Vector3.zero
					local humanoid3 = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")

					if humanoid3 then
						stealManager.ResetHumanoidState(humanoid3)
					end

					task.wait(0.08)
					local humanoidRootPart4 = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")

					if humanoidRootPart4 then
						local magnitude3 = (humanoidRootPart4.Position - vector).Magnitude
						local magnitude4 = (humanoidRootPart4.Position - areaEggSlotsClient2).Magnitude

						if magnitude3 > 14 then
							if magnitude3 < magnitude4 or magnitude4 > 40 then
								_G.LastAction = string.format("Steal: Teleport mendarat setengah jalan (%.0f studs tersisa). Melanjutkan via TweenTo...", magnitude3)
								stealManager.TweenTo(vector, 300, { Owner = "Steal" })
								task.wait(0.04)
							else
								humanoidRootPart4.CFrame = CFrame.new(vector)
								humanoidRootPart4.AssemblyLinearVelocity = Vector3.zero
								task.wait(0.05)
							end
						end
					end

					_G.LastAction = string.format("Steal: [4/4] Memulai grab spam untuk telur %s (UID: %s, SlotKey: %s)...", tostring(v7.AssetCategory or "Egg"), v7.Uid, tostring(resolveSlotKey))
					local gotEgg = stealManager.GrabWithEggStateSpam(v7.Uid, resolveSlotKey, math.max(stealManager.Timeout or 3.5, 3.5), vector, v8) or stealManager.GotEgg or stealManager.IsCarryingTargetEgg(v7.Uid)

					if not gotEgg then
						local n = 0

						while true do
							if not (stealManager.GotEgg or stealManager.IsCarryingTargetEgg(v7.Uid)) and n < 2 then
								local areaEggSlotsClient3 = workspace:FindFirstChild("AreaEggSlotsClient") and workspace.AreaEggSlotsClient:FindFirstChild(v7.Uid)
								local findDroppedFieldEgg = stealManager.FindDroppedFieldEgg and stealManager.FindDroppedFieldEgg(v7.Uid)

								if not areaEggSlotsClient3 and not findDroppedFieldEgg then
									_G.LastAction = "Steal: Target egg sudah tidak ada di map / dicuri player lain"
									break
								else
									local character2 = localPlayer.Character
									local humanoidRootPart5 = character2 and character2:FindFirstChild("HumanoidRootPart")
									character2 = character2 and character2:FindFirstChildOfClass("Humanoid")

									if not ((humanoidRootPart5 and (humanoidRootPart5.Position - vector).Magnitude or 999) > 35) then
										n += 1
										_G.LastAction = string.format("Steal: Timeout retry (%d/%d) - Micro-validating location...", n, 2)
										local n2 = n == 1 and 0 or 1.5707963267948966
										stealManager.TweenTo(vector + Vector3.new(math.cos(n2) * 3, 0.4, math.sin(n2) * 3), 300, { Owner = "Steal" })

										if character2 then
											pcall(function()
												character2:MoveTo(vector)
											end)
										end

										stealManager.TweenTo(vector, 300, { Owner = "Steal" })
										task.wait(0.08)
										gotEgg = stealManager.GrabWithEggStateSpam(v7.Uid, resolveSlotKey, 1.5, vector, v8) or stealManager.GotEgg or stealManager.IsCarryingTargetEgg(v7.Uid)
										continue
									end
								end
							end

							break
						end
					end

					if gotEgg then
						_G.LastAction = "Steal: Returning Egg to SafeZone..."

						if stealManager.ReturnEggToSafeZone(v7, v8, resolveSlotKey) then
							_G.LastAction = string.format("Steal: Successfully Stolen & Claimed %s!", tostring(v7.AssetCategory or "Egg"))
							stealManager.FailCounts[v7.Uid] = nil
							tbl6.BlockedEggs[v7.Uid] = os.clock() + 30

							if stealManager.BaitBlacklist then
								stealManager.BaitBlacklist[v7.Uid] = os.clock() + 30
							end

							if modules.DebugInspector then
								modules.DebugInspector.SuccessClaims = (modules.DebugInspector.SuccessClaims or 0) + 1
								modules.DebugInspector.Log(string.format("Successfully Claimed %s!", tostring(v7.AssetCategory or "Egg")), "STEAL")
							end

							if modules.WebhookManager then
								modules.WebhookManager.QueueEggSteal(v7)
							end

							for i = #farmState.Eggs, 1, -1 do
								if farmState.Eggs[i].Uid == v7.Uid then
									table.remove(farmState.Eggs, i)
									break
								end
							end

							task.wait(0.15)
							stealManager.UnequipAllTools()
							local now3 = os.clock()

							while os.clock() - now3 < 1 do
								local playerGui2 = playerGui or localPlayer and localPlayer:FindFirstChild("PlayerGui")
								playerGui2 = playerGui2 and playerGui2:FindFirstChild("DropHeldEgg")
								if not (not playerGui2 or not playerGui2.Enabled) then
									task.wait(0.05)
									continue
								end
								break
							end

							stealManager.UnequipAllTools()
							stealManager.GotEgg = false
							stealManager.IsStealing = false
							farmState.Carrying = false
							farmState.CarriedUid = nil
							farmState.CarriedAssetCategory = nil
							farmState.OptimisticCarry = false

							if modules.Sell and modules.Sell.Step then
								modules.Sell.Step()
							end

							task.wait(0.2)
						else
							_G.LastAction = "Steal: Failed to Deliver Egg. SafeZone Return..."
							stealManager.UnequipAllTools()
							stealManager.GotEgg = false
							stealManager.IsStealing = false
							farmState.Carrying = false
							farmState.CarriedUid = nil
							farmState.CarriedAssetCategory = nil
							farmState.OptimisticCarry = false
							stealManager.EnsureAtSafeZone(true)
						end
					else
						_G.LastAction = "Steal: Failed to Grab Egg (Timeout). SafeZone Return..."

						if v7 and v7.Uid then
							tbl6.BlockedEggs[v7.Uid] = os.clock() + 5

							if stealManager.BaitBlacklist then
								stealManager.BaitBlacklist[v7.Uid] = os.clock() + 5
							end
						end

						stealManager.UnequipAllTools()
						stealManager.GotEgg = false
						stealManager.IsStealing = false
						farmState.Carrying = false
						farmState.CarriedUid = nil
						farmState.CarriedAssetCategory = nil
						farmState.OptimisticCarry = false
						stealManager.EnsureAtSafeZone(true)
					end

					stealManager.IsStealing = false
					stealManager.StopRunAnimation()
					modules.Movement.Release("Steal")
					return
				end

				_G.LastAction = "Steal: Bait egg gagal diambil dalam 1.5 detik. Mencoba ulang bait..."

				if stealManager.BaitBlacklist then
					stealManager.BaitBlacklist[v9.Uid] = os.clock() + 2
				end

				stealManager.IsStealing = false
				modules.Movement.Release("Steal")
			end

			return stealManager
		end

		modules.Steal = createStealModule()

		local function createPlaceEggModule()
			local placeEggManager = {}

			if modules.Game then
			end

			placeEggManager.Busy = false
			placeEggManager.LastRun = 0
			placeEggManager.LastFinishAt = 0
			placeEggManager.Rule = "Steal Idle"
			placeEggManager.MaxPlaced = 30
			placeEggManager.FailCounts = {}
			placeEggManager.FailAt = {}
			placeEggManager.FailRetryCooldown = 45
			placeEggManager.SelectionMode = "Choose Any Egg"

			placeEggManager.GetEggWeight = function(arg)
				if modules.Steal and modules.Steal.GetEggWeight then
					local ok, result = pcall(modules.Steal.GetEggWeight, arg)
					if ok and type(result) == "number" then
						return result
					end
				end

				return 0
			end

			placeEggManager.GetEggIncome = function(arg)
				if not arg then
					return 0
				end
				local assets = modules.Game and modules.Game.Assets
				local assetCategory = arg.AssetCategory and (assets and assets.Directory or assets or {})[arg.AssetCategory]
				local n = assetCategory and tonumber(assetCategory.EarningRate) or 0
				if n <= 0 then
					return 0
				end
				local n2 = tonumber(arg.AssetScale) or tonumber(arg.Scale) or 1
				local n3

				if n2 <= 5 then
					n3 = n2 ^ 1.85
				else
					n3 = (n2 / 5) ^ 1.2 * 19.637875755794113
				end

				return n * n3
			end

			placeEggManager.SortByPriority = function(arg, arg2)
				if #arg < 2 then
					return arg
				end
				local prioritizeRiftEgg = enabled["Prioritize Rift Egg"] or enabled["Prioritize Rift Recipe Eggs"]
				local tbl6 = {}

				if prioritizeRiftEgg and modules.Rift and modules.Rift.GetMissingRequirements then
					pcall(function()
						tbl6 = modules.Rift.GetMissingRequirements()
					end)
				end

				local selectionMode = placeEggManager.SelectionMode or "Choose Any Egg"
				local getEggWeight = (selectionMode == "Highest KG" or selectionMode == "Lowest KG") and placeEggManager.GetEggWeight or placeEggManager.GetEggIncome
				local flag = selectionMode == "Highest KG" or selectionMode == "Highest Money/Sec"
				local tbl7 = {}

				local function getEggSortScore(arg3)
					if tbl7[arg3] == nil then
						local v7 = arg2 and arg2[arg3]
						local n = 0

						if selectionMode ~= "Choose Any Egg" then
							n = getEggWeight(v7) or 0

							if not flag then
								n = -n
							end
						end

						if v7 and v7.AssetCategory and tbl6[tostring(v7.AssetCategory)] then
							n += 1e12
						end

						tbl7[arg3] = n
					end

					return tbl7[arg3]
				end

				table.sort(arg, function(arg3, arg4)
					local v7 = getEggSortScore(arg3)
					local v8 = getEggSortScore(arg4)
					if v7 == v8 then
						return tostring(arg3) < tostring(arg4)
					end
					return v7 > v8
				end)

				return arg
			end

			placeEggManager.IsEggInfested = function(arg, arg2)
				if arg and arg.HasParasite == true then
					return true
				end

				if arg2 then
					local ok, result = pcall(function()
						return require(game:GetService("ReplicatedStorage").Client.EggState)
					end)

					if ok and result and result.FetchEggRecord then
						local v7 = result.FetchEggRecord(arg2)
						if v7 and v7.HasParasite == true then
							return true
						end
					end
				end

				return false
			end

			placeEggManager.LastCapCheck = 0
			placeEggManager.CachedCapacity = nil

			placeEggManager.GetCapacityStatus = function(arg)
				local now = os.clock()
				if not arg and placeEggManager.CachedCapacity and now - placeEggManager.LastCapCheck < 1.5 then
					return placeEggManager.CachedCapacity
				end
				placeEggManager.LastCapCheck = now
				local eggCmds = modules.Game and modules.Game.EggCmds
				local save = modules.Game and modules.Game.Save

				if modules.Game then
				end

				local get = save and save.Get
				local n = 1

				if get then
					local v7 = save.Get()
					local peek

					if v7 then
						peek = v7
					else
						peek = save.Peek and save.Peek()
					end

					peek = peek or {}

					if type(peek) == "table" then
						n = peek.BaseUpgradeLevel or n

						if peek.EggInventory then
						end
					end
				end

				local maxPlaced = placeEggManager.MaxPlaced or 30
				local getRuntimeSnapshot = eggCmds and eggCmds.GetRuntimeSnapshot and eggCmds.GetRuntimeSnapshot() or {}
				local tbl6 = {}

				for _, v7 in ipairs(getRuntimeSnapshot) do
					if v7.OwnerUserId == localPlayer.UserId then
						tbl6 = v7.Records or {}
						break
					end
				end

				local tbl7 = {}
				local n2 = 0

				for k, v7 in pairs(tbl6) do
					if v7.Placement == nil then
						local n3 = placeEggManager.FailCounts[k] or 0
						local flag = n3 >= 3
						local flag2

						if flag then
							flag2 = os.clock() - (placeEggManager.FailAt[k] or 0) >= (placeEggManager.FailRetryCooldown or 45)
						else
							flag2 = flag
						end

						if flag2 then
							placeEggManager.FailCounts[k] = nil
							placeEggManager.FailAt[k] = nil
							n3 = 0
						end

						if n3 < 3 then
							table.insert(tbl7, k)
						end
					else
						n2 += 1
					end
				end

				placeEggManager.SortByPriority(tbl7, tbl6)
				local flag = n2 >= maxPlaced

				local cachedCapacity = {
					baseLevel = n,
					maxPlaced = maxPlaced,
					placedCount = n2,
					unplacedUids = tbl7,
					unplacedCount = #tbl7,
					isPenFull = flag,
					canPlace = #tbl7 > 0 and not flag,
				}

				placeEggManager.CachedCapacity = cachedCapacity
				return cachedCapacity
			end

			placeEggManager.ShouldRunNow = function()
				if placeEggManager.Busy or modules.FarmState and modules.FarmState.IsPlacing then
					return true
				end

				if modules.Steal and modules.Steal.IsNightOrWallClosed and modules.Steal.IsNightOrWallClosed() then
					return false
				end

				if os.clock() - (placeEggManager.LastFinishAt or 0) < 2.5 then
					return false
				end
				local v7 = placeEggManager.GetCapacityStatus()
				if not v7 or not v7.canPlace then
					return false
				end

				if placeEggManager.Rule == "Egg Inventory Full" then
					return v7.unplacedCount >= 95
				end

				if placeEggManager.Rule == "Steal Idle" then
					return not (modules.Steal and modules.Steal.IsActiveStealing and modules.Steal.IsActiveStealing()) and v7.canPlace
				end

				if placeEggManager.Rule == "After Steal" then
					return v7.canPlace
				end
				return false
			end

			placeEggManager.GetUnplacedUids = function()
				return placeEggManager.GetCapacityStatus().unplacedUids
			end

			placeEggManager.GetPlacedWorldPositions = function(arg)
				local eggCmds = modules.Game and modules.Game.EggCmds
				local getRuntimeSnapshot = eggCmds and eggCmds.GetRuntimeSnapshot and eggCmds.GetRuntimeSnapshot() or {}

				if not getRuntimeSnapshot or #getRuntimeSnapshot == 0 then
					local ok, result = pcall(function()
						return require(game:GetService("ReplicatedStorage").Client.EggState)
					end)

					if ok and result and result.ReadOwnedEggs then
						getRuntimeSnapshot = result.ReadOwnedEggs()
					end
				end

				local tbl6 = {}
				local v7 = ipairs
				getRuntimeSnapshot = getRuntimeSnapshot or {}

				for _, v8 in v7(getRuntimeSnapshot) do
					if v8.OwnerUserId == localPlayer.UserId then
						local v9 = pairs
						local records = v8.Records or {}

						for _, record in v9(records) do
							if record.Placement ~= nil then
								local localCFrame = record.Placement.LocalCFrame or record.Placement

								if typeof(localCFrame) == "string" then
									local tbl7 = {}

									for match in string.gmatch(localCFrame, "[-0-9%.e]+") do
										table.insert(tbl7, tonumber(match))
									end

									if #tbl7 >= 3 then
										local cframe = CFrame.new(unpack(tbl7))
										table.insert(tbl6, arg.CFrame:ToWorldSpace(cframe).Position)
									end
								elseif typeof(localCFrame) == "CFrame" then
									table.insert(tbl6, arg.CFrame:ToWorldSpace(localCFrame).Position)
								end
							end
						end

						return tbl6
					end
				end

				return tbl6
			end

			placeEggManager.FindNextFreeSlot = function(arg, arg2)
				local petArea = arg.PetArea
				local centerPoint = arg.CenterPoint
				local n = petArea.Size.X * 0.5 - 3.5
				local n2 = petArea.Size.Z * 0.5 - 3.5
				local n3 = -n2

				while n3 <= n2 do
					local n4 = -n

					while n4 <= n do
						local v7 = petArea.CFrame:PointToWorldSpace(Vector3.new(n4, 0, n3))
						local flag = false

						for _, v8 in ipairs(arg2) do
							if math.sqrt((v7.X - v8.X) ^ 2 + (v7.Z - v8.Z) ^ 2) < 4.8 then
								flag = true
								break
							end
						end

						if not flag then
							return v7, centerPoint.CFrame:ToObjectSpace(CFrame.new(v7))
						end
						n4 += 5.5
					end

					n3 += 5.5
				end

				return nil
			end

			placeEggManager.Step = function()
				if placeEggManager.Busy then
					return
				end

				if modules.Steal and modules.Steal.IsNightOrWallClosed and modules.Steal.IsNightOrWallClosed() then
					return
				end

				if modules.Steal and modules.Steal.IsActiveStealing and modules.Steal.IsActiveStealing() then
					return
				end
				local v7 = placeEggManager.GetCapacityStatus()
				if v7.isPenFull or v7.unplacedCount == 0 then
					return
				end
				local plotCmds = modules.Game and modules.Game.PlotCmds
				local getPlotData = plotCmds and plotCmds.GetPlotData and plotCmds.GetPlotData()

				if not getPlotData or not getPlotData.PetArea or not getPlotData.CenterPoint then
					local ok, result = pcall(function()
						return require(game:GetService("ReplicatedStorage").Client.PlotState)
					end)

					if ok and result and result.ResolvePlot then
						local v8 = result.ResolvePlot(localPlayer)

						if v8 and v8.CenterPoint and v8.PetArea then
							getPlotData = {
								PlotIndex = tonumber(v8.Slot) or 1,
								PlotFolder = v8.PlotFolder,
								CenterPoint = v8.CenterPoint,
								PetArea = v8.PetArea,
								RespawnPointCFrame = v8.RespawnPointCFrame,
							}
						end
					end
				end

				if not getPlotData or not getPlotData.PetArea or not getPlotData.CenterPoint then
					return
				end
				local character2 = localPlayer.Character
				if not (character2 and character2:FindFirstChild("HumanoidRootPart")) then
					return
				end

				if not modules.Movement.Claim("PlaceEgg", 80) then
					return
				end

				if modules.Treadmill and modules.Treadmill.CheckTreadmil and modules.Treadmill.CheckTreadmil() then
					_G.LastAction = "PlaceEgg: Exit Treadmill"
					modules.Treadmill.ExitToSafeZone()
				end

				placeEggManager.Busy = true
				modules.FarmState.IsPlacing = true
				_G.LastAction = "PlaceEgg: Init"
				local n = getPlotData.CenterPoint and getPlotData.CenterPoint.Position + Vector3.new(0, 2.8, 0)
				local n2 = getPlotData.PetArea.Position + Vector3.new(0, 2.8, 0)

				local function moveToPetArea()
					local character3 = localPlayer.Character
					local humanoidRootPart2 = character3 and character3:FindFirstChild("HumanoidRootPart")
					local magnitude = humanoidRootPart2 and (humanoidRootPart2.Position - n2).Magnitude or 999
					local n3 = 0

					while true do
						if magnitude > 14 and n3 < 4 then
							if enabled["Auto Place Egg"] then
								_G.LastAction = "PlaceEgg: Move to PetArea Pen (" .. tostring(n3 + 1) .. ")"

								if n and humanoidRootPart2 and (humanoidRootPart2.Position - n).Magnitude > 15 and magnitude > 20 then
									modules.Steal.TweenTo(n, 200, { Owner = "PlaceEgg" })
									task.wait(0.05)
								end

								modules.Steal.TweenTo(n2, 200, { Owner = "PlaceEgg" })
								task.wait(0.1)
								local character4 = localPlayer.Character
								humanoidRootPart2 = character4 and character4:FindFirstChild("HumanoidRootPart")
								magnitude = humanoidRootPart2 and (humanoidRootPart2.Position - n2).Magnitude or 999
								n3 += 1
								continue
							end
						end

						break
					end

					return magnitude <= 18
				end

				_G.LastAction = "PlaceEgg: Move to Pen"

				if not moveToPetArea() then
					placeEggManager.Busy = false
					modules.FarmState.IsPlacing = false
					modules.Movement.Release("PlaceEgg")
					return
				end

				if modules.Treadmill and modules.Treadmill.CheckTreadmil and modules.Treadmill.CheckTreadmil() then
					_G.LastAction = "PlaceEgg: Unstick from Treadmill"

					if modules.Treadmill.Unequip then
						modules.Treadmill.Unequip()
					end

					task.wait(0.05)
				end

				local v8 = placeEggManager.GetPlacedWorldPositions(getPlotData.CenterPoint)
				local placedCount = v7.placedCount

				for _, unplacedUid in ipairs(v7.unplacedUids) do
					if enabled["Auto Place Egg"] then
						if not (v7.maxPlaced <= placedCount) then
							if modules.Steal and modules.Steal.IsNightOrWallClosed and modules.Steal.IsNightOrWallClosed() then
								_G.LastAction = "PlaceEgg: Interrupted by Night (Returning SafeZone)"
								break
							else
								local v9, v10 = placeEggManager.FindNextFreeSlot(getPlotData, v8)

								if v9 then
									local humanoidRootPart2 = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")

									if not humanoidRootPart2 or (humanoidRootPart2.Position - n2).Magnitude > 18 then
										_G.LastAction = "PlaceEgg: Lagback Detected! Returning to Pen"
										if not moveToPetArea() then
											continue
										end
									end

									if modules.Treadmill and modules.Treadmill.CheckTreadmil and modules.Treadmill.CheckTreadmil() then
										_G.LastAction = "PlaceEgg: Unstick from Treadmill"

										if modules.Treadmill.Unequip then
											modules.Treadmill.Unequip()
										end

										task.wait(0.05)
									end

									local eggCmds = modules.Game and modules.Game.EggCmds
									_G.LastAction = "PlaceEgg: Equip Tool (" .. tostring(unplacedUid) .. ")"

									if eggCmds and eggCmds.RequestEquipTool then
										pcall(function()
											eggCmds.RequestEquipTool(unplacedUid)
										end)
									end

									task.wait(0.2)
									_G.LastAction = "PlaceEgg: Request Place Egg (" .. tostring(unplacedUid) .. ")"

									local ok, result = pcall(function()
										if eggCmds and eggCmds.RequestPlaceEgg then
											return eggCmds.RequestPlaceEgg(unplacedUid, v10)
										end
										return require(game:GetService("ReplicatedStorage").Client.EggState).PlantEgg(unplacedUid, v10)
									end)

									if eggCmds and eggCmds.RequestUnequipTool then
										pcall(function()
											eggCmds.RequestUnequipTool(unplacedUid)
										end)
									end

									if ok and (result == true or type(result) == "table" and (result.Outcome == true or result.Success == true or result.Placed == true)) then
										placedCount += 1
										table.insert(v8, v9)
										placeEggManager.FailCounts[unplacedUid] = nil
										placeEggManager.FailAt[unplacedUid] = nil
									else
										placeEggManager.FailCounts[unplacedUid] = (placeEggManager.FailCounts[unplacedUid] or 0) + 1
										placeEggManager.FailAt[unplacedUid] = os.clock()

										if placeEggManager.FailCounts[unplacedUid] >= 3 then
											_G.LastAction = "PlaceEgg: Skip Failed Egg (" .. tostring(unplacedUid) .. ")"
										end
									end

									task.wait(0.15)
									continue
								end
							end
						end
					end

					break
				end

				pcall(function()
					local character3 = localPlayer.Character
					character3 = character3 and character3:FindFirstChildOfClass("Humanoid")

					if character3 then
						character3:UnequipTools()
					end
				end)

				pcall(function()
					local eggCmds = modules.Game and modules.Game.EggCmds

					if eggCmds and eggCmds.RequestRuntimeSnapshot then
						eggCmds.RequestRuntimeSnapshot()
					end
				end)

				local humanoidRootPart2 = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")

				if humanoidRootPart2 and n and (humanoidRootPart2.Position - n).Magnitude > 8 then
					_G.LastAction = "PlaceEgg: Return Center Corridor"
					modules.Steal.TweenTo(n, 120, { Owner = "PlaceEgg" })
					task.wait(0.05)
				end

				_G.LastAction = "PlaceEgg: Completed"
				placeEggManager.Busy = false
				modules.FarmState.IsPlacing = false
				placeEggManager.LastRun = os.clock()
				placeEggManager.LastFinishAt = os.clock()
				placeEggManager.CachedCapacity = nil
				modules.Movement.Release("PlaceEgg")

				if modules.Steal and modules.Steal.IsNightOrWallClosed and modules.Steal.IsNightOrWallClosed() then
					modules.Steal.GoToSafeZone(300, "SafeZone")
				elseif enabled["Auto Treadmill"] and modules.Treadmill and modules.Treadmill.CanRun and modules.Treadmill.CanRun() then
					modules.Treadmill.Step()
				end
			end

			return placeEggManager
		end

		modules.PlaceEgg = createPlaceEggModule()

		local function createTreadmillModule()
			local treadmillManager

			treadmillManager = {
				UndergroundOffset = 1000,
				OriginalPositions = {},
				OriginalProperties = {},
				IsHidden = false,
				CollectInstances = function()
					local tbl6 = {}
					local plotCmds = modules.Game and modules.Game.PlotCmds
					local getPlot = modules.Game and modules.Game.GetPlot and modules.Game.GetPlot() or plotCmds and plotCmds.GetPlotData and plotCmds.GetPlotData()
					local plotIndex = getPlot and getPlot.PlotIndex
					local clientTreadmillRenders = workspace:FindFirstChild("__ClientTreadmillRenders")

					if clientTreadmillRenders then
						if plotIndex then
							local v7 = clientTreadmillRenders:FindFirstChild("TreadmillRender_" .. tostring(plotIndex))

							if v7 then
								table.insert(tbl6, v7)
							end
						else
							for _, child in ipairs(clientTreadmillRenders:GetChildren()) do
								table.insert(tbl6, child)
							end
						end
					end

					if getPlot and getPlot.PlotFolder then
						local treadmillBottom = getPlot.PlotFolder:FindFirstChild("TreadmillBottom")

						if treadmillBottom then
							table.insert(tbl6, treadmillBottom)
						end

						local treadmillUpgrade = getPlot.PlotFolder:FindFirstChild("TreadmillUpgrade")

						if treadmillUpgrade then
							table.insert(tbl6, treadmillUpgrade)
						end

						for _, child in ipairs(getPlot.PlotFolder:GetChildren()) do
							if string.find(child.Name, "Treadmill", 1, true) and not table.find(tbl6, child) then
								table.insert(tbl6, child)
							end
						end
					end

					return tbl6
				end,
				Hide = function()
					local v7 = treadmillManager.CollectInstances()

					for _, v8 in ipairs(v7) do
						if v8 and v8.Parent then
							if v8:IsA("Model") or v8:IsA("Tool") then
								if not treadmillManager.OriginalPositions[v8] then
									treadmillManager.OriginalPositions[v8] = v8:GetPivot()
								end

								local v9 = treadmillManager.OriginalPositions[v8]

								pcall(function()
									v8:PivotTo(v9 - Vector3.new(0, treadmillManager.UndergroundOffset, 0))
								end)

								for _, descendant in ipairs(v8:GetDescendants()) do
									if descendant:IsA("BasePart") then
										if not treadmillManager.OriginalProperties[descendant] then
											treadmillManager.OriginalProperties[descendant] = { CanTouch = descendant.CanTouch, CanCollide = descendant.CanCollide }
										end

										descendant.CanTouch = false
										descendant.CanCollide = false
									end
								end
							elseif v8:IsA("BasePart") then
								if not treadmillManager.OriginalPositions[v8] then
									treadmillManager.OriginalPositions[v8] = v8.CFrame
								end

								if not treadmillManager.OriginalProperties[v8] then
									treadmillManager.OriginalProperties[v8] = { CanTouch = v8.CanTouch, CanCollide = v8.CanCollide }
								end

								v8.CFrame = treadmillManager.OriginalPositions[v8] - Vector3.new(0, treadmillManager.UndergroundOffset, 0)
								v8.CanTouch = false
								v8.CanCollide = false
							end
						end
					end

					treadmillManager.IsHidden = true
				end,
				Restore = function()
					for k, originalPosition in pairs(treadmillManager.OriginalPositions) do
						if k and k.Parent then
							pcall(function()
								if k:IsA("Model") or k:IsA("Tool") then
									k:PivotTo(originalPosition)
								elseif k:IsA("BasePart") then
									k.CFrame = originalPosition
								end
							end)

							if k:IsA("Model") or k:IsA("Tool") then
								for _, descendant in ipairs(k:GetDescendants()) do
									if descendant:IsA("BasePart") and treadmillManager.OriginalProperties[descendant] then
										local v7 = treadmillManager.OriginalProperties[descendant]
										descendant.CanTouch = v7.CanTouch
										descendant.CanCollide = v7.CanCollide
									end
								end
							elseif k:IsA("BasePart") and treadmillManager.OriginalProperties[k] then
								local v7 = treadmillManager.OriginalProperties[k]
								k.CanTouch = v7.CanTouch
								k.CanCollide = v7.CanCollide
							end
						end
					end

					treadmillManager.IsHidden = false
				end,
			}

			local MusicDirector = nil

			pcall(function()
				MusicDirector = require(game:GetService("ReplicatedStorage").Client.MusicDirector)
			end)

			local Hud = nil

			pcall(function()
				Hud = require(game:GetService("ReplicatedStorage").Client.Hud)
			end)

			local Remotes_ = nil

			pcall(function()
				Remotes_ = require(game:GetService("ReplicatedStorage").Shared.Remotes)
			end)

			local Treadmills = nil

			pcall(function()
				Treadmills = require(game:GetService("ReplicatedStorage").Data.Treadmills)
			end)

			local function checkTreadmil()
				if MusicDirector and MusicDirector.HasCustomTreadmill then
					local ok, result = pcall(MusicDirector.HasCustomTreadmill)
					if ok and result == true then
						return true
					end
				end

				if Hud and Hud.Frame then
					local ok, result = pcall(Hud.Frame, "Treadmill")
					if ok and result and result.Visible == true then
						return true
					end
				end

				if not hud and not MusicDirector then
					local assignedBeltShifted = Remotes_ and Remotes_.Treadmill and Remotes_.Treadmill.AssignedBeltShifted

					if assignedBeltShifted and getconnections then
						local directory = Treadmills and Treadmills.Directory

						if directory then
							for _, v7 in ipairs(getconnections(assignedBeltShifted.OnClientEvent)) do
								local function_ = v7.Function

								if type(function_) == "function" and debug and debug.getupvalue then
									local ok, result = pcall(debug.getupvalue, function_, 1)
									if ok and typeof(result) == "string" and directory[result] then
										return true
									end
								end
							end
						end
					end
				end

				return false
			end

			treadmillManager.CheckTreadmil = checkTreadmil
			treadmillManager.CheckTreadmill = checkTreadmil
			treadmillManager.IsOnTreadmill = checkTreadmil

			treadmillManager.CanRun = function()
				if not enabled["Auto Treadmill"] then
					return false
				end

				if modules.Steal and modules.Steal.IsNightOrWallClosed and modules.Steal.IsNightOrWallClosed() then
					return false
				end

				if enabled["Auto Steal"] then
					if modules.Steal and modules.Steal.IsActiveStealing and modules.Steal.IsActiveStealing() then
						return false
					end

					if modules.Steal and (modules.Steal.IsStealing or modules.FarmState and (modules.FarmState.Carrying or modules.FarmState.OptimisticCarry)) then
						return false
					end
					local steal = modules.Steal

					if steal then
						steal = os.clock() < (modules.Steal.PostResetBurstUntil or 0)
					end

					if steal then
						return false
					end

					if modules.Steal and modules.Steal.PickTarget and modules.Steal.PickTarget() ~= nil then
						return false
					end

					if modules.Steal and modules.Steal.HasRecentWork and modules.Steal.HasRecentWork() then
						return false
					end
				end

				if modules.FarmState and modules.FarmState.IsPlacing or modules.PlaceEgg and modules.PlaceEgg.Busy then
					return false
				end

				if enabled["Auto Place Egg"] and modules.PlaceEgg and modules.PlaceEgg.ShouldRunNow then
					if modules.PlaceEgg.ShouldRunNow() then
						return false
					end
				end

				if modules.Sell then
					if modules.Sell.IsSelling then
						return false
					end

					if enabled["Auto Sell Pet"] and modules.Sell.CollectPetUids then
						if #modules.Sell.CollectPetUids() > 0 then
							return false
						end
					end

					if enabled["Auto Sell Egg"] and modules.Sell.CollectEggUids then
						if #modules.Sell.CollectEggUids() > 0 then
							return false
						end
					end
				end

				if not modules.Movement.CanClaim("Treadmill", 40) then
					return false
				end
				return true
			end

			treadmillManager.Unequip = function()
				if not checkTreadmil() then
					return true
				end

				pcall(function()
					if Remotes_ and Remotes_.Treadmill and Remotes_.Treadmill.AskDoff then
						Remotes_.Treadmill.AskDoff:InvokeServer()
					elseif replicatedStorage:FindFirstChild("Network") and replicatedStorage.Network:FindFirstChild("Treadmills: RequestUnequip") then
						replicatedStorage.Network["Treadmills: RequestUnequip"]:InvokeServer()
					end
				end)

				local n = 0

				while checkTreadmil() and n < 30 do
					n += 1
					task.wait(0.05)

					if checkTreadmil() and n % 5 == 0 then
						pcall(function()
							if Remotes_ and Remotes_.Treadmill and Remotes_.Treadmill.AskDoff then
								Remotes_.Treadmill.AskDoff:InvokeServer()
							elseif replicatedStorage:FindFirstChild("Network") and replicatedStorage.Network:FindFirstChild("Treadmills: RequestUnequip") then
								replicatedStorage.Network["Treadmills: RequestUnequip"]:InvokeServer()
							end
						end)
					end
				end

				return not checkTreadmil()
			end

			treadmillManager.ExitTreadmill = treadmillManager.Unequip

			treadmillManager.ExitToSafeZone = function()
				modules.Movement.Release("Treadmill")
				local character2 = localPlayer.Character
				local humanoidRootPart2 = character2 and character2:FindFirstChild("HumanoidRootPart")
				local humanoid2 = character2 and character2:FindFirstChildOfClass("Humanoid")
				local plotCmds = modules.Game and modules.Game.PlotCmds
				local getPlot = modules.Game and modules.Game.GetPlot and modules.Game.GetPlot() or plotCmds and plotCmds.GetPlotData and plotCmds.GetPlotData()
				local treadmillBottom = getPlot and getPlot.PlotFolder and getPlot.PlotFolder:FindFirstChild("TreadmillBottom")
				treadmillBottom = treadmillBottom and treadmillBottom.Position
				local flag = humanoidRootPart2 and treadmillBottom and (humanoidRootPart2.Position - treadmillBottom).Magnitude < 15
				if not (checkTreadmil() or flag) then
					return
				end
				_G.LastAction = "Treadmill: Exit to SafeZone"
				treadmillManager.Unequip()
				local character3 = localPlayer.Character
				character3 = character3 and character3:FindFirstChild("HumanoidRootPart")

				if character3 and getPlot and getPlot.CenterPoint then
					character3.CFrame = CFrame.new(getPlot.CenterPoint.Position + Vector3.new(0, 2.8, 0))
					character3.AssemblyLinearVelocity = Vector3.zero
					character3.AssemblyAngularVelocity = Vector3.zero
				end

				if humanoid2 then
					pcall(function()
						humanoid2:ChangeState(Enum.HumanoidStateType.Running)
					end)
				end

				if modules.Steal and modules.Steal.StopRunAnimation and not modules.Steal.IsStealing then
					modules.Steal.StopRunAnimation()
				end

				task.wait(0.05)
			end

			task.spawn(function()
				cloneRef(game:GetService("ContextActionService"))

				local function bindTreadmillJumpExit(arg)
					if not arg or arg:GetAttribute("ControllerJumpEnabled") then
						return
					end
					local playerModule = localPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")
					rawset(require(playerModule):GetControls(), "humanoid", arg)

					arg:GetPropertyChangedSignal("Jump"):Connect(function()
						if not arg.Jump then
							return
						end

						if checkTreadmil() then
							treadmillManager.Unequip()
						end
					end)

					arg:SetAttribute("ControllerJumpEnabled", true)
				end

				while task.wait(0.5) do
					local character2 = localPlayer.Character

					if character2 then
						local humanoid2 = character2:FindFirstChildOfClass("Humanoid")

						if humanoid2 then
							pcall(bindTreadmillJumpExit, humanoid2)
						end
					end
				end
			end)

			task.spawn(function()
				local flag = false

				while task.wait(0.1) do
					local flag2 = false

					pcall(function()
						if checkTreadmil and checkTreadmil() then
							flag2 = true
						else
							local plotCmds = modules.Game and modules.Game.PlotCmds
							local getPlot = modules.Game and modules.Game.GetPlot and modules.Game.GetPlot() or plotCmds and plotCmds.GetPlotData and plotCmds.GetPlotData()
							local treadmillBottom = getPlot and getPlot.PlotFolder and getPlot.PlotFolder:FindFirstChild("TreadmillBottom")
							local humanoidRootPart2 = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")

							if treadmillBottom and humanoidRootPart2 and (humanoidRootPart2.Position - treadmillBottom.Position).Magnitude < 4.5 then
								flag2 = true
							end
						end
					end)

					if flag2 then
						local startRunAnimation = modules.Steal and modules.Steal.StartRunAnimation
						flag = true

						if startRunAnimation then
							if not modules.Steal.RunAnimConnection then
								modules.Steal.StartRunAnimation(modules.Steal.GetWalkSpeed and modules.Steal.GetWalkSpeed() or 24)
							end
						end
					elseif flag then
						local stopRunAnimation = not (modules.Steal and modules.Steal.IsStealing) and modules.Steal and modules.Steal.StopRunAnimation
						flag = false

						if stopRunAnimation then
							modules.Steal.StopRunAnimation()
						end
					end
				end
			end)

			treadmillManager.Step = function()
				if not enabled["Auto Treadmill"] then
					if checkTreadmil() then
						treadmillManager.ExitToSafeZone()
					end

					return
				end

				if not treadmillManager.CanRun() then
					if checkTreadmil() then
						treadmillManager.ExitToSafeZone()
					end

					if modules.Steal and modules.Steal.IsNightOrWallClosed and modules.Steal.IsNightOrWallClosed() then
						modules.Steal.GoToSafeZone(300, "SafeZone")
					end

					return
				end

				if not modules.Movement.Claim("Treadmill", 40) then
					return
				end
				local getPlot = modules.Game and modules.Game.GetPlot and modules.Game.GetPlot()
				local plotFolder = getPlot and getPlot.PlotFolder
				plotFolder = plotFolder and plotFolder:FindFirstChild("TreadmillBottom")
				if not plotFolder then
					modules.Movement.Release("Treadmill")
					return
				end
				local character2 = localPlayer.Character
				character2 = character2 and character2:FindFirstChild("HumanoidRootPart")
				if not character2 then
					modules.Movement.Release("Treadmill")
					return
				end
				local n = plotFolder.Position + Vector3.new(0, 2.8, 0)
				local magnitude = (character2.Position - n).Magnitude
				if magnitude <= 4.5 or checkTreadmil() then
					modules.Movement.Release("Treadmill")
					return
				end

				if not modules.Movement.Claim("Treadmill", 40) then
					return
				end
				local n2 = getPlot.CenterPoint and getPlot.CenterPoint.Position + Vector3.new(0, 2.8, 0)
				local getSafeZone = modules.Steal and modules.Steal.GetSafeZone and modules.Steal.GetSafeZone()
				local flag = n2 and (character2.Position - n2).Magnitude <= 80
				local isInSafeZoneArea = modules.Steal and modules.Steal.IsInSafeZoneArea and modules.Steal.IsInSafeZoneArea()

				if not flag and not isInSafeZoneArea and getSafeZone and magnitude > 35 then
					_G.LastAction = "Treadmill: Return to SafeZone First"
					modules.Steal.TweenTo(getSafeZone, 300, { Owner = "Treadmill" })
					task.wait(0.05)
				end

				local humanoidRootPart2 = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
				if not humanoidRootPart2 then
					return
				end

				if n2 and (humanoidRootPart2.Position - n2).Magnitude > 15 and (humanoidRootPart2.Position - n).Magnitude > 12 then
					_G.LastAction = "Treadmill: Enter Plot Corridor"
					modules.Steal.TweenTo(n2, 120, { Owner = "Treadmill" })
					task.wait(0.05)
				end

				local humanoidRootPart3 = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")

				if humanoidRootPart3 and (humanoidRootPart3.Position - n).Magnitude > 3.5 then
					_G.LastAction = "Treadmill: Move to Treadmill"
					modules.Steal.TweenTo(n, 120, { Owner = "Treadmill" })
				end

				local humanoidRootPart4 = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")

				if humanoidRootPart4 and (humanoidRootPart4.Position - n).Magnitude <= 5 then
					local lookVector = plotFolder.CFrame.LookVector
					humanoidRootPart4.CFrame = CFrame.lookAt(n, n + lookVector)
					humanoidRootPart4.AssemblyLinearVelocity = Vector3.zero
					humanoidRootPart4.AssemblyAngularVelocity = Vector3.zero
					local humanoid2 = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")

					if humanoid2 then
						pcall(function()
							humanoid2:ChangeState(Enum.HumanoidStateType.Running)
							humanoid2:Move(lookVector)
						end)
					end

					_G.LastAction = "Treadmill: Running on Treadmill"
					modules.Movement.Release("Treadmill")
				end
			end

			return treadmillManager
		end

		modules.Treadmill = createTreadmillModule()
		modules.MonsterEvents = {}

		local function createHatchModule()
			local farmState = modules.FarmState

			return { Step = function()
				if not modules.Game.EggCmds then
					return
				end

				local ok, result = pcall(function()
					local v7 = modules.Game.EggCmds.GetRuntimeSnapshot()

					for _, v8 in ipairs(v7) do
						if v8.OwnerUserId == localPlayer.UserId then
							return v8.Records
						end
					end

					return {}
				end)

				if not ok or not result then
					return
				end
				local hatchManager = {}

				for k in pairs(result) do
					hatchManager[k] = true
				end

				for k in pairs(farmState.HatchedUids) do
					if not hatchManager[k] then
						farmState.HatchedUids[k] = nil
					end
				end

				for k, v7 in pairs(result) do
					if v7.Placement and not farmState.HatchedUids[k] then
						local flag = false

						if pcall(function()
							flag = modules.Game.EggCmds.IsLocalEggReady(k)
						end) and flag then
							_G.LastAction = "Hatch: Request Hatch Egg (" .. tostring(k) .. ")"

							local ok2, result2 = pcall(function()
								return modules.Game.EggCmds.RequestHatchEgg(k)
							end)

							if ok2 and result2 == true then
								_G.LastAction = "Hatch: Complete Hatch Egg (" .. tostring(k) .. ")"

								local ok3, result3 = pcall(function()
									return modules.Game.EggCmds.RequestCompleteHatchEgg(k)
								end)

								if ok3 and result3 == true then
									farmState.HatchedUids[k] = true
								end
							end
						end
					end
				end
			end }
		end

		modules.Hatch = createHatchModule()

		local function createAutoEquipModule()
			local equipManager

			equipManager = {
				LastEquipAt = 0,
				Execute = function()
					local lastEquipAt = equipManager.LastEquipAt
					if os.clock() - lastEquipAt < 5.2 then
						return false, "cooldown"
					end
					equipManager.LastEquipAt = os.clock()
					_G.LastAction = "Equip: Request Equip Best Pets"

					local ok, result = pcall(function()
						if modules.Game and modules.Game.Remotes and modules.Game.Remotes.Haul and modules.Game.Remotes.Haul.WearBest then
							return modules.Game.Remotes.Haul.WearBest:InvokeServer()
						end

						if replicatedStorage:FindFirstChild("Network") and replicatedStorage.Network:FindFirstChild("Backpack: EquipBest") then
							return replicatedStorage.Network["Backpack: EquipBest"]:InvokeServer()
						end
					end)

					return ok and result == true
				end,
				Step = function()
					if not enabled["Auto Equip Best"] then
						return
					end
					equipManager.Execute()
				end,
			}

			return equipManager
		end

		modules.Equip = createAutoEquipModule()

		local function createFavoriteModule()
			local favoriteManager = {}
			local tbl6 = {}

			pcall(function()
				local assets = modules.Game and modules.Game.Assets or replicatedStorage:FindFirstChild("Data") and require(replicatedStorage.Data.Assets)
				local directory = assets and assets.Directory or assets

				if directory then
					for k, v7 in pairs(directory) do
						tbl6[k] = v7
					end
				end
			end)

			favoriteManager.MinRarity = 0
			favoriteManager.MutationFilter = "Off"
			favoriteManager.LastFavoriteAt = 0

			local function getFavoriteAssetDirectory()
				if next(tbl6) then
					return tbl6
				end

				pcall(function()
					local assets = modules.Game and modules.Game.Assets or replicatedStorage:FindFirstChild("Data") and require(replicatedStorage.Data.Assets)
					local directory = assets and assets.Directory
					local flag

					if directory then
						flag = directory
					else
						flag = type(assets) == "table" and assets
					end

					if flag and type(flag) == "table" then
						for k, v7 in pairs(flag) do
							tbl6[k] = v7
						end
					end
				end)

				return tbl6
			end

			favoriteManager.ResolveRarityNumber = function(arg)
				if not arg then
					return 1
				end

				if type(arg) == "number" then
					return arg
				end

				if type(arg) == "table" then
					arg = arg.AssetCategory or arg.Category or arg.Name or arg.DisplayName or arg[1]
				end

				local v7 = getFavoriteAssetDirectory()
				v7 = v7 and v7[arg]

				if v7 then
					if v7.Rarity and type(v7.Rarity) == "table" then
						if type(v7.Rarity.Rank) == "number" then
							return v7.Rarity.Rank
						end

						if type(v7.Rarity.RarityNumber) == "number" then
							return v7.Rarity.RarityNumber
						end
					end

					if type(v7.Rank) == "number" then
						return v7.Rank
					end

					if type(v7.RarityNumber) == "number" then
						return v7.RarityNumber
					end
				end

				if modules.Steal and modules.Steal.GetEggRarityNumber then
					local ok, result = pcall(modules.Steal.GetEggRarityNumber, arg)
					if ok and type(result) == "number" and result > 0 then
						return result
					end
				end

				return 1
			end

			favoriteManager.CollectUnfavoritedUids = function()
				local v7 = modules.Game.GetSave()
				if not v7 then
					return {}
				end
				local inventory = v7.Inventory or {}
				local tbl7 = {}
				local flag = favoriteManager.MinRarity and favoriteManager.MinRarity > 0
				local flag2 = favoriteManager.MutationFilter and favoriteManager.MutationFilter ~= "Off" and favoriteManager.MutationFilter ~= "None"
				if not flag and not flag2 then
					return {}
				end

				for k, v8 in pairs(inventory) do
					local ok, result = pcall(function()
						return modules.Game.AssetItemSerialization.Deserialize(v8)
					end)

					if ok and result and not result.IsFavorite and result.Category then
						local v9 = favoriteManager.ResolveRarityNumber(result.Category)
						local tbl8 = {}
						local flag3 = type(result.Mutations) == "table" and #result.Mutations > 0
						local flag4 = false

						if flag3 then
							for _, mutation in ipairs(result.Mutations) do
								table.insert(tbl8, mutation)
							end

							flag4 = true
						end

						if result.BaseMutation and result.BaseMutation ~= "" then
							flag4 = true

							if not table.find(tbl8, result.BaseMutation) then
								table.insert(tbl8, result.BaseMutation)
							end
						end

						local flag5 = true

						if flag then
							flag5 = v9 >= favoriteManager.MinRarity
						end

						local flag6 = true

						if flag2 then
							if favoriteManager.MutationFilter == "All Mutations" then
								flag6 = flag4
							else
								flag6 = table.find(tbl8, favoriteManager.MutationFilter) ~= nil
							end
						end

						if flag and flag2 then
							flag6 = flag5 and flag6
						elseif flag then
							flag6 = flag5
						else
							local flag7 = false

							if not flag2 then
								flag6 = flag7
							end
						end

						if flag6 then
							table.insert(tbl7, k)
						end
					end
				end

				return tbl7
			end

			favoriteManager.Execute = function()
				if modules.Steal and modules.Steal.IsInSafeZone and not modules.Steal.IsInSafeZone() then
					return false, "not in safezone"
				end
				local v7 = favoriteManager.CollectUnfavoritedUids()
				if #v7 == 0 then
					return false, "no pets to favorite"
				end
				local n = 0

				for _, v8 in ipairs(v7) do
					_G.LastAction = "Favorite: Set Favorite Pet (" .. tostring(v8) .. ")"

					pcall(function()
						if modules.Game and modules.Game.Remotes and modules.Game.Remotes.PetSatchel and modules.Game.Remotes.PetSatchel.WriteFavourite then
							modules.Game.Remotes.PetSatchel.WriteFavourite:FireServer(v8, true)
						elseif replicatedStorage:FindFirstChild("Network") and replicatedStorage.Network:FindFirstChild("AssetInventory: SetFavorite") then
							replicatedStorage.Network["AssetInventory: SetFavorite"]:FireServer(v8, true)
						end
					end)

					n += 1
					task.wait(0.08)
				end

				return true, n
			end

			favoriteManager.Step = function()
				if not enabled["Auto Favorite Pet"] then
					return
				end
				local lastFavoriteAt = favoriteManager.LastFavoriteAt
				if os.clock() - lastFavoriteAt < 3 then
					return
				end
				favoriteManager.LastFavoriteAt = os.clock()
				favoriteManager.Execute()
			end

			favoriteManager.LastFavEquippedAt = 0
			favoriteManager.LastUnfavEquippedAt = 0

			favoriteManager.CollectEquippedUids = function()
				local v7 = modules.Game.GetSave()
				if not v7 then
					return {}
				end
				local tbl7 = {}
				local tbl8 = {}
				local equippedAssets = v7.EquippedAssets or v7.EquippedPets or {}

				for _, equippedAsset in ipairs(equippedAssets) do
					if equippedAsset and not tbl7[equippedAsset] then
						tbl7[equippedAsset] = true
						table.insert(tbl8, equippedAsset)
					end
				end

				return tbl8
			end

			favoriteManager.SetFavoriteEquipped = function(arg)
				local v7 = modules.Game.GetSave()
				if not v7 then
					return false, "no data"
				end
				local inventory = v7.Inventory or {}
				local equippedAssets = v7.EquippedAssets or v7.EquippedPets or {}
				local tbl7 = {}
				local n = 0

				for _, equippedAsset in ipairs(equippedAssets) do
					if equippedAsset and not tbl7[equippedAsset] then
						tbl7[equippedAsset] = true
						local v8 = inventory[equippedAsset]

						if v8 and v8.IsFavorite ~= arg then
							_G.LastAction = (arg and "Favorite" or "Unfavorite") .. ": Equipped Pet (" .. tostring(equippedAsset) .. ")"

							pcall(function()
								if modules.Game and modules.Game.Remotes and modules.Game.Remotes.PetSatchel and modules.Game.Remotes.PetSatchel.WriteFavourite then
									modules.Game.Remotes.PetSatchel.WriteFavourite:FireServer(equippedAsset, arg)
								elseif replicatedStorage:FindFirstChild("Network") and replicatedStorage.Network:FindFirstChild("AssetInventory: SetFavorite") then
									replicatedStorage.Network["AssetInventory: SetFavorite"]:FireServer(equippedAsset, arg)
								end
							end)

							n += 1
							task.wait(0.08)
						end
					end
				end

				return true, n
			end

			favoriteManager.StepFavEquipped = function()
				if not enabled["Auto Favourite Equiped Pets"] then
					return
				end
				local lastFavEquippedAt = favoriteManager.LastFavEquippedAt
				if os.clock() - lastFavEquippedAt < 3 then
					return
				end
				favoriteManager.LastFavEquippedAt = os.clock()
				favoriteManager.SetFavoriteEquipped(true)
			end

			favoriteManager.StepUnfavEquipped = function()
				if not enabled["Auto UnFavourite Equiped Pets"] then
					return
				end
				local lastUnfavEquippedAt = favoriteManager.LastUnfavEquippedAt
				if os.clock() - lastUnfavEquippedAt < 3 then
					return
				end
				favoriteManager.LastUnfavEquippedAt = os.clock()
				favoriteManager.SetFavoriteEquipped(false)
			end

			return favoriteManager
		end

		modules.Favorite = createFavoriteModule()

		local function createSellModule()
			local sellManager = {}
			local tbl6 = {}

			local function getSellAssetDirectory()
				if next(tbl6) then
					return tbl6
				end

				pcall(function()
					local assets = modules.Game and modules.Game.Assets or replicatedStorage:FindFirstChild("Data") and require(replicatedStorage.Data.Assets)
					local directory = assets and assets.Directory or type(assets) == "table" and assets

					if directory and type(directory) == "table" then
						for k, v7 in pairs(directory) do
							tbl6[k] = v7
						end
					end
				end)

				return tbl6
			end

			local tbl7 = {
				common = 1,
				uncommon = 2,
				superrare = 2,
				rare = 3,
				epic = 4,
				legendary = 5,
				mythic = 6,
				["squishy god"] = 6,
				brainrotgod = 6,
				rainbow = 6,
				prismatic = 6,
				cosmic = 7,
				secret = 8,
				eternal = 9,
				limited = 9,
				divine = 10,
				transcendent = 10,
				titan = 11,
				["light & dark"] = 12,
				lightdark = 12,
				["light and dark"] = 12,
			}

			local assetEarnings = nil

			pcall(function()
				local ReplicatedStorage = game:GetService("ReplicatedStorage")
				assetEarnings = modules.Game and modules.Game.AssetEarnings or ReplicatedStorage:FindFirstChild("Shared") and ReplicatedStorage.Shared:FindFirstChild("Util") and ReplicatedStorage.Shared.Util:FindFirstChild("AssetEarnings") and require(ReplicatedStorage.Shared.Util.AssetEarnings)
			end)

			sellManager.PetRule = "Rarity Only"
			sellManager.MaxRarity = 3
			sellManager.IncomeThreshold = 0
			sellManager.BlacklistPets = {}
			sellManager.EggMaxRarity = 3
			sellManager.LastSellAt = 0
			sellManager.LastSellEggAt = 0
			sellManager.IsSelling = false

			sellManager.ParseIncome = function(arg)
				if type(arg) == "number" then
					return arg
				end

				if type(arg) ~= "string" then
					return 0
				end
				local str = string.gsub(arg, "[,%s]", ""):lower()
				if str == "" or str == "off" or str == "none" then
					return 0
				end
				local v7, v8 = string.match(str, "^([%d%.]+)([a-z]*)$")
				if not v7 then
					return tonumber(str) or 0
				end
				local n = tonumber(v7) or 0
				if v8 == "k" then
					return n * 1000
				end

				if v8 == "m" then
					return n * 1000000
				end

				if v8 == "b" then
					return n * 1e9
				end

				if v8 == "t" then
					return n * 1e12
				end

				if v8 == "qa" or v8 == "q" then
					return n * 1e15
				end

				if v8 == "qi" then
					return n * 1e18
				end

				if v8 == "sx" or v8 == "s" then
					return n * 1e21
				end

				if v8 == "sp" then
					return n * 1e24
				end

				if v8 == "oc" or v8 == "o" then
					return n * 1e27
				end

				if v8 == "n" then
					return n * 1e30
				end
				return n
			end

			sellManager.GetPetIncome = function(arg, arg2)
				if not arg or type(arg) ~= "table" then
					return 0
				end

				if assetEarnings then
					if assetEarnings.LiveRatePerSecond and arg2 then
						local ok, result = pcall(assetEarnings.LiveRatePerSecond, arg, arg2.Gamepasses, arg2.Products, localPlayer)
						if ok and type(result) == "number" and result > 0 then
							return result
						end
					end

					if assetEarnings.RatePerSecond then
						local ok, result = pcall(assetEarnings.RatePerSecond, arg)
						if ok and type(result) == "number" and result > 0 then
							return result
						end
					end
				end

				local category = arg.Category
				local v7 = getSellAssetDirectory()

				if category and v7 and v7[category] then
					local n = tonumber(v7[category].EarningRate) or 0
					local n2 = tonumber(arg.Scale) or 1
					return math.round(n * (n2 <= 5 and n2 ^ 1.85 or (n2 / 5) ^ 1.2 * 19.637875755794113))
				end

				return tonumber(arg.Income or arg.Rate or arg.BaseIncome or 0) or 0
			end

			sellManager.GetPetDisplayName = function(arg)
				local v7 = getSellAssetDirectory()
				if arg and v7 and v7[arg] then
					local v8 = v7[arg]
					return v8.DisplayName or v8.Name or arg
				end
				return tostring(arg or "Unknown")
			end

			sellManager.GetPetRarityName = function(arg)
				local v7 = getSellAssetDirectory()

				if arg and v7 and v7[arg] then
					local v8 = v7[arg]

					if v8.Rarity then
						if type(v8.Rarity) == "table" then
							return v8.Rarity.DisplayName or v8.Rarity.Name or v8.Rarity._id or "Common"
						end

						if type(v8.Rarity) == "string" then
							return v8.Rarity
						end
					end
				end

				return "Common"
			end

			sellManager.GetPetFormattedName = function(arg)
				if not arg or not arg.Category then
					return "Unknown"
				end
				local v7 = sellManager.GetPetDisplayName(arg.Category)
				local v8 = sellManager.GetPetRarityName(arg.Category)
				return string.format("%s [%s]", v7, v8)
			end

			sellManager.IsPetBlacklisted = function(arg)
				if not sellManager.BlacklistPets or next(sellManager.BlacklistPets) == nil then
					return false
				end
				local category = arg and arg.Category
				if not category then
					return false
				end
				local v7 = sellManager.GetPetFormattedName(arg)
				local v8 = sellManager.GetPetDisplayName(category)
				local v9 = string.lower(tostring(category))
				local v10 = string.lower(tostring(v7))
				local v11 = string.lower(tostring(v8))

				for k, blacklistPet in pairs(sellManager.BlacklistPets) do
					local v12

					if blacklistPet == true and type(k) == "string" then
						v12 = string.lower(k)
					else
						v12 = nil

						if type(blacklistPet) == "string" then
							v12 = string.lower(blacklistPet)
						end
					end

					if v12 then
						if v12 == v9 or v12 == v10 or v12 == v11 or string.find(v10, v12, 1, true) or string.find(v12, v9, 1, true) or string.find(v12, v11, 1, true) then
							return true
						end
					end
				end

				return false
			end

			sellManager.ResolveRarityNumber = function(arg)
				if not arg then
					return 1
				end

				if type(arg) == "number" then
					return arg
				end

				if type(arg) == "table" then
					arg = arg.AssetCategory or arg.Category or arg.Name or arg.DisplayName or arg[1]
				end

				if not arg then
					return 1
				end
				local v7 = getSellAssetDirectory()
				local v8 = v7 and v7[arg]

				if not v8 and v7 then
					local v9 = string.lower(tostring(arg))

					for k, v10 in pairs(v7) do
						if string.lower(k) == v9 or v10.DisplayName and string.lower(v10.DisplayName) == v9 then
							v8 = v10
							break
						end
					end
				end

				if v8 then
					if v8.Rarity and type(v8.Rarity) == "table" then
						if type(v8.Rarity.Rank) == "number" then
							return v8.Rarity.Rank
						end

						if type(v8.Rarity.RarityNumber) == "number" then
							return v8.Rarity.RarityNumber
						end
						local displayName = v8.Rarity.DisplayName or v8.Rarity.Name or v8.Rarity._id

						if displayName and type(displayName) == "string" then
							local v9 = tbl7[string.lower(displayName)]
							if v9 then
								return v9
							end
						end
					end

					if type(v8.Rank) == "number" then
						return v8.Rank
					end

					if type(v8.RarityNumber) == "number" then
						return v8.RarityNumber
					end

					if v8.Rarity and type(v8.Rarity) == "string" then
						local v9 = tbl7[string.lower(v8.Rarity)]
						if v9 then
							return v9
						end
					end
				end

				if modules.Steal and modules.Steal.GetEggRarityNumber then
					local ok, result = pcall(modules.Steal.GetEggRarityNumber, arg)
					if ok and type(result) == "number" and result > 0 then
						return result
					end
				end

				local v9 = tbl7[string.lower(tostring(arg))]
				if v9 then
					return v9
				end
				return 1
			end

			sellManager.CollectPetUids = function()
				local v7 = modules.Game.GetSave()
				if not v7 then
					return {}
				end
				local inventory = v7.Inventory or {}
				local equippedAssets = v7.EquippedAssets or {}
				local tbl8 = {}

				for _, equippedAsset in ipairs(equippedAssets) do
					tbl8[equippedAsset] = true
				end

				local petRule = sellManager.PetRule or "Rarity Only"

				if type(petRule) == "table" then
					petRule = petRule[1] or petRule.Value or petRule.Title or petRule.Text or "Rarity Only"
				end

				local tbl9 = {}

				for k, v8 in pairs(inventory) do
					if not tbl8[k] then
						local v9 = v8

						if type(v8) == "string" or type(v8) == "table" and not v8.Category then
							pcall(function()
								local ReplicatedStorage = game:GetService("ReplicatedStorage")
								local AssetItems = ReplicatedStorage:FindFirstChild("Shared") and ReplicatedStorage.Shared:FindFirstChild("Util") and ReplicatedStorage.Shared.Util:FindFirstChild("AssetItems") and require(ReplicatedStorage.Shared.Util.AssetItems)

								if AssetItems and AssetItems.Decode then
									v9 = AssetItems.Decode(v8)
								elseif modules.Game and modules.Game.AssetItemSerialization and modules.Game.AssetItemSerialization.Deserialize then
									v9 = modules.Game.AssetItemSerialization.Deserialize(v8)
								end
							end)
						end

						if type(v9) == "table" and v9.Category then
							if not (v9.IsFavorite == true or v9.Favorite == true or v9.Locked == true) and not v9.InFuse and not sellManager.IsPetBlacklisted(v9) then
								local v10 = sellManager.ResolveRarityNumber(v9.Category)
								local v11 = sellManager.GetPetIncome(v9, v7)
								local flag = sellManager.MaxRarity and sellManager.MaxRarity > 0 and v10 <= sellManager.MaxRarity or false
								local flag2 = sellManager.IncomeThreshold and sellManager.IncomeThreshold > 0 and v11 < sellManager.IncomeThreshold or false
								local str = tostring(petRule):lower()

								if str:find("both") then
									flag2 = flag and flag2
								elseif str:find("either") then
									flag2 = flag or flag2
								elseif not str:find("income") then
									flag2 = flag
								end

								if flag2 then
									table.insert(tbl9, k)
								end
							end
						end
					end
				end

				return tbl9
			end

			sellManager.CollectEggUids = function()
				local v7 = modules.Game.GetSave()
				local tbl8 = {}
				if not v7 then
					return tbl8
				end
				local eggInventory = v7.EggInventory

				if type(eggInventory) == "table" then
					for k, v8 in pairs(eggInventory) do
						local v9 = v8
						local flag = type(v9) == "string"

						if not flag then
							flag = type(v9) == "table"

							if flag then
								flag = not (v9.AssetCategory or v9.Category)
							end
						end

						if flag then
							pcall(function()
								local ReplicatedStorage = game:GetService("ReplicatedStorage")
								local EggRecords = ReplicatedStorage:FindFirstChild("Shared") and ReplicatedStorage.Shared:FindFirstChild("Util") and ReplicatedStorage.Shared.Util:FindFirstChild("EggRecords") and require(ReplicatedStorage.Shared.Util.EggRecords)

								if EggRecords and EggRecords.Decode then
									v9 = EggRecords.Decode(v8)
								end
							end)
						end

						if type(v9) == "table" and v9.Placement == nil then
							local assetCategory = v9.AssetCategory or v9.Category

							if assetCategory then
								local v10 = sellManager.ResolveRarityNumber(assetCategory)

								if sellManager.EggMaxRarity and sellManager.EggMaxRarity > 0 and v10 <= sellManager.EggMaxRarity then
									if not (v9.Mutations and type(v9.Mutations) == "table" and next(v9.Mutations) ~= nil) and not (v9.IsFavorite == true or v9.Favorite == true or v9.Locked == true) then
										table.insert(tbl8, k)
									end
								end
							end
						end
					end
				end

				if #tbl8 == 0 then
					local eggCmds = modules.Game and modules.Game.EggCmds
					local getRuntimeSnapshot = eggCmds and eggCmds.GetRuntimeSnapshot and eggCmds.GetRuntimeSnapshot()

					if type(getRuntimeSnapshot) == "table" then
						for _, v8 in ipairs(getRuntimeSnapshot) do
							if v8.OwnerUserId == localPlayer.UserId then
								local v9 = pairs
								local records = v8.Records or {}

								for k, record in v9(records) do
									if record.Placement == nil and (record.AssetCategory or record.Category) then
										local v10 = sellManager.ResolveRarityNumber(record.AssetCategory or record.Category)

										if sellManager.EggMaxRarity and sellManager.EggMaxRarity > 0 and v10 <= sellManager.EggMaxRarity then
											if not (record.Mutations and type(record.Mutations) == "table" and next(record.Mutations) ~= nil) and not (record.IsFavorite == true or record.Favorite == true or record.Locked == true) then
												table.insert(tbl8, k)
											end
										end
									end
								end
							end
						end
					end
				end

				return tbl8
			end

			sellManager.CanSell = function()
				if modules.FarmState and (modules.FarmState.Carrying or modules.FarmState.OptimisticCarry) then
					return false
				end

				if modules.Steal and modules.Steal.IsActiveStealing and modules.Steal.IsActiveStealing() then
					return false
				end

				if modules.Steal and modules.Steal.IsStealing then
					return false
				end
				local flag = false

				if modules.Steal and modules.Steal.IsInSafeZoneArea then
					flag = modules.Steal.IsInSafeZoneArea()
				elseif modules.Steal and modules.Steal.IsInSafeZone then
					flag = modules.Steal.IsInSafeZone()
				end

				if not flag then
					pcall(function()
						local ToolGameplayGuard = require(game:GetService("ReplicatedStorage").Client.ToolGameplayGuard)

						if ToolGameplayGuard and ToolGameplayGuard.IsLocalInsideArena then
							flag = not ToolGameplayGuard.IsLocalInsideArena()
						end
					end)
				end

				return flag == true
			end

			sellManager.FireBatchSell = function(arg, arg2)
				arg = arg or {}
				arg2 = arg2 or {}
				if #arg == 0 and #arg2 == 0 then
					return false, "empty selection"
				end
				local flag = false

				pcall(function()
					local ReplicatedStorage = game:GetService("ReplicatedStorage")
					local remotes = modules.Game and modules.Game.Remotes or ReplicatedStorage:FindFirstChild("Shared") and ReplicatedStorage.Shared:FindFirstChild("Remotes") and require(ReplicatedStorage.Shared.Remotes)

					if remotes and remotes.PetSatchel and remotes.PetSatchel.SellSelection then
						remotes.PetSatchel.SellSelection:FireServer({ Assets = arg, Eggs = arg2 })
						flag = true
						return
					end

					local networking = ReplicatedStorage:FindFirstChild("Packages") and ReplicatedStorage.Packages:FindFirstChild("Networking")
					networking = networking and networking:FindFirstChild("RE/PetSatchel/SellSelection")

					if networking then
						networking:FireServer({ Assets = arg, Eggs = arg2 })
						flag = true
						return
					end
				end)

				if not flag and #arg > 0 then
					pcall(function()
						local ReplicatedStorage = game:GetService("ReplicatedStorage")
						local remotes = modules.Game and modules.Game.Remotes or ReplicatedStorage:FindFirstChild("Shared") and ReplicatedStorage.Shared:FindFirstChild("Remotes") and require(ReplicatedStorage.Shared.Remotes)

						if remotes and remotes.PetSatchel and remotes.PetSatchel.SellEveryPet then
							remotes.PetSatchel.SellEveryPet:FireServer(arg)
							flag = true
						end
					end)
				end

				return flag
			end

			sellManager.ExecutePet = function()
				if not sellManager.CanSell() then
					return false, "not in safezone"
				end
				local v7 = sellManager.CollectPetUids()
				if #v7 == 0 then
					return false, "no sellable pets"
				end
				local debugInspector = modules.DebugInspector
				sellManager.IsSelling = true
				_G.LastAction = string.format("Sell: Selling Batch of %d Pets...", #v7)

				if debugInspector then
					debugInspector.SetState("SELLING", string.format("Batch Selling %d Pets", #v7), "SafeZone")
				end

				local n = 0

				for i = 1, #v7, 50 do
					if sellManager.CanSell() then
						local tbl8 = {}

						for i2 = i, math.min(i + 50 - 1, #v7) do
							table.insert(tbl8, v7[i2])
						end

						if sellManager.FireBatchSell(tbl8, {}) then
							n += #tbl8
						else
							pcall(function()
								local ReplicatedStorage = game:GetService("ReplicatedStorage")
								local remotes = modules.Game and modules.Game.Remotes or ReplicatedStorage:FindFirstChild("Shared") and ReplicatedStorage.Shared:FindFirstChild("Remotes") and require(ReplicatedStorage.Shared.Remotes)

								if remotes and remotes.PetSatchel and remotes.PetSatchel.SellPet then
									for _, v8 in ipairs(tbl8) do
										remotes.PetSatchel.SellPet:FireServer({ v8 })
										task.wait(0.04)
									end
								end
							end)

							n += #tbl8
						end

						if i + 50 <= #v7 then
							task.wait(0.08)
						end

						continue
					end

					break
				end

				sellManager.LastSellAt = os.clock()
				sellManager.IsSelling = false
				_G.LastAction = string.format("Sell: Finished selling %d Pets!", n)
				return true, n
			end

			sellManager.ExecuteEgg = function()
				if not sellManager.CanSell() then
					return false, "not in safezone"
				end
				local v7 = sellManager.CollectEggUids()
				if #v7 == 0 then
					return false, "no sellable eggs"
				end
				local debugInspector = modules.DebugInspector
				sellManager.IsSelling = true
				_G.LastAction = string.format("Sell: Selling Batch of %d Eggs...", #v7)

				if debugInspector then
					debugInspector.SetState("SELLING", string.format("Batch Selling %d Eggs", #v7), "SafeZone")
				end

				local n = 0

				for i = 1, #v7, 50 do
					if sellManager.CanSell() then
						local tbl8 = {}

						for i2 = i, math.min(i + 50 - 1, #v7) do
							table.insert(tbl8, v7[i2])
						end

						if sellManager.FireBatchSell({}, tbl8) then
							n += #tbl8
						end

						if i + 50 <= #v7 then
							task.wait(0.08)
						end

						continue
					end

					break
				end

				sellManager.LastSellEggAt = os.clock()
				sellManager.IsSelling = false
				_G.LastAction = string.format("Sell: Finished selling %d Eggs!", n)
				return true, n
			end

			sellManager.Step = function()
				if not sellManager.CanSell() then
					return
				end
				local now = os.clock()
				if sellManager.LastStepAt and now - sellManager.LastStepAt < 2.5 then
					return
				end
				sellManager.LastStepAt = now
				local autoSellPet = enabled["Auto Sell Pet"] and sellManager.CollectPetUids() or {}
				local autoSellEgg = enabled["Auto Sell Egg"] and sellManager.CollectEggUids() or {}
				if #autoSellPet == 0 and #autoSellEgg == 0 then
					return
				end
				sellManager.IsSelling = true
				local debugInspector = modules.DebugInspector

				if debugInspector then
					debugInspector.SetState("SELLING", string.format("Selling %d Pets & %d Eggs", #autoSellPet, #autoSellEgg), "SafeZone")
				end

				local n = math.max(#autoSellPet, #autoSellEgg)

				for i = 1, n, 50 do
					if sellManager.CanSell() then
						local tbl8 = {}

						for i2 = i, math.min(i + 50 - 1, #autoSellPet) do
							table.insert(tbl8, autoSellPet[i2])
						end

						local tbl9 = {}

						for i2 = i, math.min(i + 50 - 1, #autoSellEgg) do
							table.insert(tbl9, autoSellEgg[i2])
						end

						if #tbl8 > 0 or #tbl9 > 0 then
							sellManager.FireBatchSell(tbl8, tbl9)
						end

						if i + 50 <= n then
							task.wait(0.08)
						end

						continue
					end

					break
				end

				sellManager.LastSellAt = now
				sellManager.LastSellEggAt = now
				sellManager.IsSelling = false
				_G.LastAction = string.format("Sell: Successfully sold %d Pets & %d Eggs!", #autoSellPet, #autoSellEgg)
			end

			return sellManager
		end

		modules.Sell = createSellModule()

		local function createRebirthModule()
			local function canRunRebirth()
				if modules.Treadmill and modules.Treadmill.CheckTreadmil and modules.Treadmill.CheckTreadmil() then
					return true
				end

				if modules.Steal and modules.Steal.IsInSafeZoneArea and modules.Steal.IsInSafeZoneArea() then
					return true
				end

				if modules.Steal and not modules.Steal.IsStealing then
					return true
				end
				return false
			end

			local rebirthManager

			rebirthManager = {
				LastAt = 0,
				CanRebirth = function()
					if not canRunRebirth() then
						return false
					end
					local v7 = modules.Game.GetSave()
					if not v7 then
						return false
					end
					local v8 = modules.Game.RebirthUtil.RebirthToRequiredSpeedPower((v7.Rebirth or 0) + 1)
					if v8 == math.huge then
						return false
					end
					return (v7.SpeedPower or 0) >= v8
				end,
				ClickUI = function()
					local rebirth = playerGui:FindFirstChild("Rebirth")
					if not rebirth then
						return false
					end

					if rebirth.Enabled ~= true then
						return false
					end
					local rebirth2 = rebirth:FindFirstChild("Rebirth")
					if not rebirth2 then
						return false
					end
					local content = rebirth2:FindFirstChild("Content")
					if not content then
						return false
					end
					local rebirth3 = content:FindFirstChild("Rebirth")

					if rebirth3 and rebirth3:IsA("ImageButton") and rebirth3.Visible then
						if fireSignal then
							_G.LastAction = "Rebirth: Click Rebirth Button"

							local ok = pcall(function()
								fireSignal(rebirth3.Activated)
							end)

							local ok2 = pcall(function()
								fireSignal(rebirth3.MouseButton1Click)
							end)

							if ok or ok2 then
								return true
							end
						end

						return false
					end

					return false
				end,
				Step = function()
					if not canRunRebirth() then
						return
					end
					local lastAt = rebirthManager.LastAt
					if os.clock() - lastAt < 8 then
						return
					end
					rebirthManager.LastAt = os.clock()

					if rebirthManager.CanRebirth() then
						rebirthManager.ClickUI()
					end
				end,
			}

			return rebirthManager
		end

		modules.Rebirth = createRebirthModule()

		local function createUpgradeModule()
			local upgradeManager = { LastAt = 0, LastTreadmillAt = 0 }

			local function canRunUpgrade()
				if modules.Treadmill and modules.Treadmill.CheckTreadmil and modules.Treadmill.CheckTreadmil() then
					return true
				end

				if modules.Steal and modules.Steal.IsInSafeZoneArea and modules.Steal.IsInSafeZoneArea() then
					return true
				end

				if modules.Steal and not modules.Steal.IsStealing then
					return true
				end
				return false
			end

			upgradeManager.Step = function()
				if not canRunUpgrade() then
					return
				end
				local lastAt = upgradeManager.LastAt
				if os.clock() - lastAt < 3 then
					return
				end
				upgradeManager.LastAt = os.clock()
				local v7 = modules.Game.GetSave()
				if not v7 then
					return
				end

				if enabled["Auto Upgrade Base"] then
					local ReplicatedStorage = game:GetService("ReplicatedStorage")
					local Bases = ReplicatedStorage:FindFirstChild("Data") and ReplicatedStorage.Data:FindFirstChild("Bases") and require(ReplicatedStorage.Data.Bases)

					if Bases and Bases.BASES then
						local n = (v7.BaseUpgradeLevel or 0) + 1
						local v8 = Bases.BASES[n]
						local cost = v8 and v8.Cost

						if cost then
							cost = (v7.Money or 0) >= v8.Cost
						end

						if cost then
							pcall(function()
								if Remotes and Remotes.Homestead and Remotes.Homestead.AskBaseTierRaise then
									_G.LastAction = "Upgrade: Base Tier " .. tostring(n)
									Remotes.Homestead.AskBaseTierRaise:FireServer()
								elseif modules.Game and modules.Game.Remotes and modules.Game.Remotes.Homestead and modules.Game.Remotes.Homestead.AskBaseTierRaise then
									_G.LastAction = "Upgrade: Base Tier " .. tostring(n)
									modules.Game.Remotes.Homestead.AskBaseTierRaise:FireServer()
								end
							end)
						end
					end
				end
			end

			upgradeManager.StepTreadmill = function()
				if not canRunUpgrade() then
					return
				end
				local lastTreadmillAt = upgradeManager.LastTreadmillAt
				if os.clock() - lastTreadmillAt < 3 then
					return
				end
				upgradeManager.LastTreadmillAt = os.clock()
				local v7 = modules.Game.GetSave()
				if not v7 then
					return
				end

				if enabled["Auto Upgrade Treadmill"] then
					local ReplicatedStorage = game:GetService("ReplicatedStorage")
					local treadmills = modules.Game and modules.Game.Treadmills or ReplicatedStorage:FindFirstChild("Data") and ReplicatedStorage.Data:FindFirstChild("Treadmills") and require(ReplicatedStorage.Data.Treadmills)

					if treadmills and treadmills.GetByUpgradeLevel then
						local v8 = treadmills.GetByUpgradeLevel((v7.TreadmillUpgradeLevel or 0) + 1)
						local flag

						if v8 then
							flag = (v7.Money or 0) >= (v8.Price or 0)
						else
							flag = v8
						end

						if flag then
							pcall(function()
								if Remotes and Remotes.Treadmill and Remotes.Treadmill.AskTierRaise then
									_G.LastAction = "Upgrade: Buy " .. tostring(v8.DisplayName or v8._id)
									Remotes.Treadmill.AskTierRaise:InvokeServer(v8._id)
								elseif modules.Game and modules.Game.Remotes and modules.Game.Remotes.Treadmill and modules.Game.Remotes.Treadmill.AskTierRaise then
									_G.LastAction = "Upgrade: Buy " .. tostring(v8.DisplayName or v8._id)
									modules.Game.Remotes.Treadmill.AskTierRaise:InvokeServer(v8._id)
								end
							end)
						end
					end
				end
			end

			return upgradeManager
		end

		modules.Upgrade = createUpgradeModule()

		local function createClaimModule()
			local claimManager = { LastAt = 0 }

			local function canRunClaim()
				if modules.Treadmill and modules.Treadmill.CheckTreadmil and modules.Treadmill.CheckTreadmil() then
					return true
				end

				if modules.Steal and modules.Steal.IsInSafeZoneArea and modules.Steal.IsInSafeZoneArea() then
					return true
				end

				if modules.Steal and not modules.Steal.IsStealing then
					return true
				end
				return false
			end

			claimManager.Step = function()
				if not canRunClaim() then
					return
				end
				local lastAt = claimManager.LastAt
				if os.clock() - lastAt < 20 then
					return
				end
				claimManager.LastAt = os.clock()

				if enabled["Auto Claim"] then
					pcall(function()
						if Remotes and Remotes.AwayEarnings and Remotes.AwayEarnings.AskCollect then
							_G.LastAction = "Claim: Redeem Offline Assets"
							Remotes.AwayEarnings.AskCollect:InvokeServer()
						elseif modules.Game and modules.Game.Remotes and modules.Game.Remotes.AwayEarnings and modules.Game.Remotes.AwayEarnings.AskCollect then
							_G.LastAction = "Claim: Redeem Offline Assets"
							modules.Game.Remotes.AwayEarnings.AskCollect:InvokeServer()
						end
					end)

					pcall(function()
						if Remotes and Remotes.Codex and Remotes.Codex.AskRedeemAll then
							_G.LastAction = "Claim: Request Claim All Index"
							Remotes.Codex.AskRedeemAll:InvokeServer()
						elseif modules.Game and modules.Game.Remotes and modules.Game.Remotes.Codex and modules.Game.Remotes.Codex.AskRedeemAll then
							_G.LastAction = "Claim: Request Claim All Index"
							modules.Game.Remotes.Codex.AskRedeemAll:InvokeServer()
						end
					end)
				end
			end

			return claimManager
		end

		modules.Claim = createClaimModule()

		local function createTrailModule()
			local trailManager = { LastAt = 0 }

			local function canRunTrail()
				if modules.Treadmill and modules.Treadmill.CheckTreadmil and modules.Treadmill.CheckTreadmil() then
					return true
				end

				if modules.Steal and modules.Steal.IsInSafeZoneArea and modules.Steal.IsInSafeZoneArea() then
					return true
				end

				if modules.Steal and not modules.Steal.IsStealing then
					return true
				end
				return false
			end

			local tbl6 = {}

			pcall(function()
				local trails = modules.Game and modules.Game.Trails or replicatedStorage:FindFirstChild("Data") and require(replicatedStorage.Data.Trails)
				tbl6 = trails and trails.Directory or trails or {}
			end)

			trailManager.GetAvailableTrails = function()
				local tbl7 = {}

				for k, v7 in pairs(tbl6) do
					if type(v7) == "table" and (v7.Price or v7.Cost) then
						table.insert(tbl7, {
							Id = k,
							Name = v7.DisplayName or v7.Name or k,
							Price = v7.Price or v7.Cost or 0,
							Currency = v7.Currency or "SpeedPower",
							Order = v7.Order or v7.Price or 0,
						})
					end
				end

				table.sort(tbl7, function(arg, arg2)
					return arg.Order < arg2.Order
				end)

				return tbl7
			end

			trailManager.BuyAvailableTrails = function()
				local v7 = modules.Game.GetSave()
				if not v7 then
					return
				end
				local trailInventory = v7.TrailInventory or {}
				local speedPower = v7.SpeedPower or 0
				local money = v7.Money or 0
				local v8 = trailManager.GetAvailableTrails()

				for _, v9 in ipairs(v8) do
					local flag = false

					if type(trailInventory) == "table" then
						flag = trailInventory[v9.Id] == true or table.find(trailInventory, v9.Id) ~= nil
					end

					if not flag then
						local flag2

						if v9.Currency == "Money" then
							flag2 = money >= v9.Price
						else
							flag2 = speedPower >= v9.Price
						end

						if flag2 then
							local ok, result = pcall(function()
								local Remotes_ = require(game:GetService("ReplicatedStorage").Shared.Remotes)
								if Remotes_ and Remotes_.Trailwear and Remotes_.Trailwear.AskPurchase then
									return Remotes_.Trailwear.AskPurchase:InvokeServer(v9.Id)
								end
							end)

							if ok and result then
								_G.LastAction = "Trail: Bought " .. tostring(v9.Name)

								if type(trailInventory) == "table" then
									trailInventory[v9.Id] = true
								end
							end

							task.wait(0.2)
						end
					end
				end
			end

			trailManager.Step = function()
				if not canRunTrail() then
					return
				end

				if not enabled["Auto Buy Trail"] then
					return
				end

				if os.clock() - (trailManager.LastAt or 0) < 5 then
					return
				end
				trailManager.LastAt = os.clock()
				trailManager.BuyAvailableTrails()
			end

			return trailManager
		end

		modules.Trail = createTrailModule()

		local function createESPModule()
			local farmState = modules.FarmState
			local espManager

			espManager = {
				Folder = nil,
				Markers = {},
				GuardMarkers = {},
				Pool = {},
				LastUpdate = 0,
				GuardWarningAt = 0,
				EnsureFolder = function()
					if espManager.Folder and espManager.Folder.Parent then
						return espManager.Folder
					end
					espManager.Folder = Instance.new("Folder")
					espManager.Folder.Name = "SHX_ESP"
					espManager.Folder.Parent = workspace
					return espManager.Folder
				end,
			}

			local tbl6 = {}

			pcall(function()
				local ok, result = pcall(require, replicatedStorage.Data.Assets)

				if not (ok and result) then
					local ok2
					ok2, result = pcall(require, replicatedStorage.Directory.Assets)

					if not (ok2 and result) then
						result = modules.Game and modules.Game.Assets
					end
				end

				local directory = result and result.Directory

				if directory then
					for k, v7 in pairs(directory) do
						tbl6[k] = v7
					end
				end
			end)

			espManager.ColorForCategory = function(arg)
				local v7 = tbl6[arg]
				if v7 and v7.Rarity and v7.Rarity.Color then
					return v7.Rarity.Color
				end
				return Color3.new(1, 1, 1)
			end

			espManager.IsRare = function(arg)
				local flag = espManager.ColorForCategory(arg) ~= nil

				if flag then
					flag = (espManager.RarityNumberFor(arg) or 0) >= 6
				end

				return flag
			end

			espManager.RarityNumberFor = function(arg)
				local v7 = tbl6[arg]
				if v7 and v7.Rarity and v7.Rarity.RarityNumber then
					return v7.Rarity.RarityNumber
				end
				return 1
			end

			espManager.UpdateEggMarkers = function()
				if not enabled["ESP Eggs"] and not enabled["ESP Rare Eggs"] then
					if next(espManager.Markers) or #espManager.Pool > 0 then
						for k, marker in pairs(espManager.Markers) do
							if marker.Part then
								marker.Part:Destroy()
							end

							espManager.Markers[k] = nil
						end

						for _, v7 in ipairs(espManager.Pool) do
							if v7.Part then
								v7.Part:Destroy()
							end
						end

						espManager.Pool = {}
					end

					return
				end

				farmState.RefreshEggs()
				local tbl7 = {}
				local v7 = espManager.EnsureFolder()
				local v8 = ipairs
				local eggs = farmState.Eggs or {}

				for _, egg in v8(eggs) do
					local color = espManager.IsRare(egg.AssetCategory)

					if enabled["ESP Eggs"] or enabled["ESP Rare Eggs"] and color then
						local position = egg.BottomCFrame and egg.BottomCFrame.Position or nil

						if position then
							tbl7[egg.Uid] = true
							local tbl8 = espManager.Markers[egg.Uid]
							local text = string.format("%s | %s", egg.AssetCategory or "?", egg.State or "?")
							local color2 = color and Color3.new(1, 0.5, 0) or Color3.new(1, 1, 1)
							color = color and Color3.new(1, 0.4, 0) or Color3.new(0.2, 0.8, 1)

							if not tbl8 or not tbl8.Part or not tbl8.Part.Parent then
								if #espManager.Pool > 0 then
									tbl8 = table.remove(espManager.Pool)
									tbl8.Part.Parent = v7
									tbl8.Marker.Enabled = true
								else
									local part = Instance.new("Part")
									part.Name = "SHXEggPart"
									part.Size = Vector3.new(4, 4, 4)
									part.Transparency = 0.6
									part.CanCollide = false
									part.CanQuery = false
									part.CanTouch = false
									part.Anchored = true
									part.Parent = v7
									local billboardGui = Instance.new("BillboardGui")
									billboardGui.Name = "EggMarker"
									billboardGui.AlwaysOnTop = true
									billboardGui.Size = UDim2.fromOffset(120, 28)
									billboardGui.StudsOffset = Vector3.new(0, 2.5, 0)
									billboardGui.MaxDistance = 400
									local frame = Instance.new("Frame")
									frame.Size = UDim2.fromScale(1, 1)
									frame.BackgroundColor3 = Color3.new(0, 0, 0)
									frame.BackgroundTransparency = 0.35
									frame.BorderSizePixel = 0
									frame.Parent = billboardGui
									local textLabel = Instance.new("TextLabel")
									textLabel.Size = UDim2.fromScale(1, 1)
									textLabel.BackgroundTransparency = 1
									textLabel.Font = Enum.Font.GothamBold
									textLabel.TextScaled = true
									textLabel.Parent = frame
									billboardGui.Adornee = part
									billboardGui.Parent = part
									tbl8 = { Part = part, Marker = billboardGui, Label = textLabel }
								end

								espManager.Markers[egg.Uid] = tbl8
							end

							if tbl8 and tbl8.Part then
								tbl8.Part.CFrame = CFrame.new(position)
								tbl8.Part.Color = color

								if tbl8.Label and tbl8.Label.Text ~= text then
									tbl8.Label.Text = text
									tbl8.Label.TextColor3 = color2
								end
							end
						end
					end
				end

				for k, marker in pairs(espManager.Markers) do
					if not tbl7[k] then
						if marker.Marker then
							marker.Marker.Enabled = false
						end

						if marker.Part then
							marker.Part.Parent = nil
						end

						table.insert(espManager.Pool, marker)
						espManager.Markers[k] = nil
					end
				end
			end

			espManager.UpdateGuards = function()
				if not enabled["ESP Guards"] and not enabled["Guard Warning"] then
					for k, guardMarker in pairs(espManager.GuardMarkers) do
						if guardMarker.Parent then
							guardMarker:Destroy()
						end

						espManager.GuardMarkers[k] = nil
					end

					return
				end

				local guardAreas = workspace:FindFirstChild("World") and workspace.World:FindFirstChild("Areas") and workspace.World.Areas:FindFirstChild("GuardAreas")
				if not guardAreas then
					return
				end

				for _, child in ipairs(guardAreas:GetChildren()) do
					if child:IsA("Model") then
						local guard = child:FindFirstChild("Guard")

						if guard and guard:IsA("Model") then
							guard:FindFirstChild("HumanoidRootPart")
							local attribute = guard:GetAttribute("GuardState") or "Sleeping"
							local attribute2 = guard:GetAttribute("TargetPlayer") or ""
							local highlight = espManager.GuardMarkers[child.Name]

							if enabled["ESP Guards"] then
								if not highlight or not highlight.Parent then
									highlight = Instance.new("Highlight")
									highlight.Name = "Guard_" .. child.Name
									highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
									highlight.FillTransparency = 0.7
									highlight.Parent = espManager.EnsureFolder()
									espManager.GuardMarkers[child.Name] = highlight
								end

								highlight.Adornee = guard

								if attribute == "Chasing" then
									highlight.FillColor = Color3.new(1, 0.2, 0.2)
									highlight.OutlineColor = Color3.new(1, 0.2, 0.2)
								elseif attribute == "Waking" or attribute == "ReturningHome" then
									highlight.FillColor = Color3.new(1, 0.8, 0.1)
									highlight.OutlineColor = Color3.new(1, 0.8, 0.1)
								else
									highlight.FillColor = Color3.new(0.2, 1, 0.3)
									highlight.OutlineColor = Color3.new(0.2, 1, 0.3)
								end
							else
								if highlight and highlight.Parent then
									highlight:Destroy()
								end

								espManager.GuardMarkers[child.Name] = nil
							end

							if enabled["Guard Warning"] and attribute2 == tostring(localPlayer.UserId) then
								local guardWarningAt = espManager.GuardWarningAt

								if os.clock() - guardWarningAt > 2 then
									espManager.GuardWarningAt = os.clock()
									notifyDeveloper("Guard is chasing you! RUN!", "Guard Warning")
								end

								farmState.SyncCarry()

								if farmState.Carrying and enabled["Auto Drop Egg"] then
									pcall(function()
										modules.Game.EggCmds.RequestDropHeldAreaEgg("PlayerRequest")
									end)

									farmState.SyncCarry()
								end
							end
						end
					end
				end
			end

			espManager.Step = function()
				local lastUpdate = espManager.LastUpdate
				if os.clock() - lastUpdate < 1 then
					return
				end
				espManager.LastUpdate = os.clock()
				espManager.UpdateEggMarkers()
				espManager.UpdateGuards()
			end

			return espManager
		end

		modules.ESP = createESPModule()

		local function createWebhookManager()
			local webhookManagerState = { Url = "", EggStealEnabled = false, MinRarity = 1 }

			local tbl6 = {
				Common = 13421772,
				Uncommon = 5635925,
				Rare = 5592575,
				Epic = 11141290,
				Legendary = 16755200,
				Mythic = 16733525,
				Cosmic = 10040319,
				Secret = 16711782,
				Eternal = 65535,
				Divine = 16766720,
			}

			local function formatWeight(arg)
				if not arg then
					return "0 Kg"
				end
				local integerPart, fractionalPart = math.modf(math.round(arg * 100) / 100)
				local str = tostring(math.abs(integerPart)):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
				local str2

				if math.abs(fractionalPart) > 0.001 then
					str2 = str .. string.format("%.2f", math.abs(fractionalPart)):sub(2)
				else
					str2 = str
				end

				return str2 .. " Kg"
			end

			webhookManagerState.SendPayload = function(arg)
				local url = webhookManagerState.Url

				if not url or url == "" then
					url = enabled["Discord Webhook URL"] or ""
				end

				if not url or url == "" then
					return
				end
				local n = tbl6[arg.rarityName] or 65416
				local n2 = tonumber(arg.scale) or 1
				local str = type(arg.scale) == "number" and string.format("%.2fx", arg.scale)

				if not str then
					str = tostring(arg.scale or "1.0x")
				end

				local n3 = 1

				pcall(function()
					local assets = modules.Game and modules.Game.Assets or replicatedStorage:FindFirstChild("Data") and require(replicatedStorage.Data.Assets)
					local directory = assets and assets.Directory or assets or {}

					if directory[arg.petCategory] and directory[arg.petCategory].ModelWeight then
						n3 = directory[arg.petCategory].ModelWeight
					end
				end)

				local v7 = formatWeight(n3 * n2 ^ 3)
				local str2 = "0/s"

				pcall(function()
					local assets = modules.Game and modules.Game.Assets or replicatedStorage:FindFirstChild("Data") and require(replicatedStorage.Data.Assets)
					local n4 = (assets and assets.Directory or assets or {})[arg.petCategory]
					n4 = n4 and tonumber(n4.EarningRate) or 0

					if n4 > 0 then
						local n5

						if n2 <= 5 then
							n5 = n2 ^ 1.85
						else
							n5 = (n2 / 5) ^ 1.2 * 19.637875755794113
						end

						local tbl7 = {}

						if arg.mutation and arg.mutation ~= "" and arg.mutation ~= "None" then
							for match in string.gmatch(tostring(arg.mutation), "[^,%s]+") do
								table.insert(tbl7, match)
							end
						end

						local getSave = modules.Game and modules.Game.GetSave and modules.Game.GetSave() or {}
						local Mutations = nil

						pcall(function()
							if replicatedStorage:FindFirstChild("Shared") and replicatedStorage.Shared:FindFirstChild("Modules") and replicatedStorage.Shared.Modules:FindFirstChild("Mutations") then
								Mutations = require(replicatedStorage.Shared.Modules.Mutations)
							elseif replicatedStorage:FindFirstChild("Data") and replicatedStorage.Data:FindFirstChild("Mutations") then
								Mutations = require(replicatedStorage.Data.Mutations)
							end
						end)

						local rebirthUtil = modules.Game and modules.Game.RebirthUtil
						local getTotalMutationsEarningMulti = Mutations and Mutations.GetTotalMutationsEarningMulti and Mutations.GetTotalMutationsEarningMulti(tbl7) or 1
						local rebirthToMultiplier = rebirthUtil and rebirthUtil.RebirthToMultiplier

						if rebirthToMultiplier then
							rebirthToMultiplier = math.max(1, rebirthUtil.RebirthToMultiplier(getSave.Rebirth or 0))
						end

						local n6 = math.max(math.round(n4 * n5 * getTotalMutationsEarningMulti * (rebirthToMultiplier or 1)), 1)

						if n6 >= 1e12 then
							str2 = string.format("%.2fT/s", n6 / 1e12)
						elseif n6 >= 1e9 then
							str2 = string.format("%.2fB/s", n6 / 1e9)
						elseif n6 >= 1000000 then
							str2 = string.format("%.2fM/s", n6 / 1000000)
						elseif n6 >= 1000 then
							str2 = string.format("%.1fK/s", n6 / 1000)
						else
							str2 = string.format("%d/s", n6)
						end
					end
				end)

				local tbl7 = { username = "Speed Hub X" }
				local embeds = {}
				local tbl8 = { title = "**Speed Hub X | Egg Successfully Stolen**", type = "rich", color = n }
				local fields = {}
				local tbl9 = { name = "** -> Profile : ** \n", value = "> Username : || " .. localPlayer.Name .. " ||", inline = false }

				local tbl10 = {
					name = "** -> Egg Info : ** \n",
					value = "> Pet Name : ``" .. tostring(arg.petName) .. "``" .. "\n> Rarity : ``" .. tostring(arg.rarityName) .. "``" .. "\n> Weight : ``" .. str .. " (" .. v7 .. ")``" .. "\n> Mutation : ``" .. tostring(arg.mutation) .. "``" .. "\n> Area : ``" .. tostring(arg.areaId) .. "``",
					inline = false,
				}

				fields[1] = tbl9
				fields[2] = tbl10
				fields[3] = { name = "** -> Pet Predictor : ** \n", value = "> Income : ``" .. str2 .. "``", inline = false }
				tbl8.fields = fields

				tbl8.thumbnail = {
					url = "https://cdn.discordapp.com/attachments/1386384052197527602/1538148901868019712/2130c04f38ddf3049b5b24a2d73971f5.png?ex=6a81a04b&is=6a804ecb&hm=05b7e14a3b99f37e87fdacdb879654cdcd62916b90e9a47ad0e46e43b6d28717&",
				}

				tbl8.footer = {
					text = "Speed Hub X â¢ Steal An Egg",
					icon_url = "https://cdn.discordapp.com/attachments/1386384052197527602/1538148901868019712/2130c04f38ddf3049b5b24a2d73971f5.png?ex=6a81a04b&is=6a804ecb&hm=05b7e14a3b99f37e87fdacdb879654cdcd62916b90e9a47ad0e46e43b6d28717&",
				}

				tbl8.timestamp = DateTime.now():ToIsoDate()
				embeds[1] = tbl8
				tbl7.embeds = embeds

				task.spawn(function()
					pcall(modules.Webhook, url, tbl7)
				end)
			end

			webhookManagerState.QueueEggSteal = function(arg)
				local eggStealEnabled = webhookManagerState.EggStealEnabled or enabled["Webhook Egg Steal"]
				local url = webhookManagerState.Url

				if not url or url == "" then
					url = enabled["Discord Webhook URL"] or ""
				end

				if not eggStealEnabled or not url or url == "" or not arg then
					return
				end
				local getEggRarityNumber = modules.Steal and modules.Steal.GetEggRarityNumber
				local n = 1

				if getEggRarityNumber then
					n = modules.Steal.GetEggRarityNumber(arg)
				end

				if n < (webhookManagerState.MinRarity or 1) then
					return
				end
				local assetCategory = arg.AssetCategory or "Unknown"
				local getEggDisplayName = modules.Steal and modules.Steal.GetEggDisplayName and modules.Steal.GetEggDisplayName(assetCategory) or tostring(assetCategory)
				local getEggRarityName = modules.Steal and modules.Steal.GetEggRarityName and modules.Steal.GetEggRarityName(assetCategory) or "Common"
				local n2 = tonumber(arg.AssetScale) or tonumber(arg.Scale) or 1
				local baseMutation

				if arg.BaseMutation and arg.BaseMutation ~= "" then
					baseMutation = arg.BaseMutation
				else
					local flag = type(arg.Mutations) == "table" and #arg.Mutations > 0
					baseMutation = "None"

					if flag then
						baseMutation = table.concat(arg.Mutations, ", ")
					end
				end

				webhookManagerState.SendPayload({
					petCategory = assetCategory,
					petName = getEggDisplayName,
					rarityName = getEggRarityName,
					rarityNum = n,
					scale = n2,
					mutation = baseMutation,
					areaId = arg.AreaId or "Unknown",
					nestId = arg.NestId or "Unknown",
					timestamp = os.time(),
				})
			end

			webhookManagerState.Step = function()
			end

			return webhookManagerState
		end

		modules.WebhookManager = createWebhookManager()

		local function createPetPredictor()
			local petPredictor = { ShowOnlyPlaced = true, SortMode = "Income", Paragraph = nil }
			local assets = modules.Game and modules.Game.Assets
			local Assets

			if assets then
				Assets = assets
			else
				Assets = replicatedStorage:FindFirstChild("Data") and require(replicatedStorage.Data.Assets)
			end

			local save = modules.Game and modules.Game.Save
			local Save

			if save then
				Save = save
			else
				Save = replicatedStorage:FindFirstChild("Shared") and require(replicatedStorage.Shared.Save)
			end

			local Mutations = nil

			pcall(function()
				if replicatedStorage:FindFirstChild("Shared") and replicatedStorage.Shared:FindFirstChild("Modules") and replicatedStorage.Shared.Modules:FindFirstChild("Mutations") then
					Mutations = require(replicatedStorage.Shared.Modules.Mutations)
				elseif replicatedStorage:FindFirstChild("Data") and replicatedStorage.Data:FindFirstChild("Mutations") then
					Mutations = require(replicatedStorage.Data.Mutations)
				end
			end)

			local rebirthUtil = modules.Game and modules.Game.RebirthUtil
			local MonetizationEntitlements = nil

			pcall(function()
				if replicatedStorage:FindFirstChild("Shared") and replicatedStorage.Shared:FindFirstChild("Util") and replicatedStorage.Shared.Util:FindFirstChild("MonetizationEntitlements") then
					MonetizationEntitlements = require(replicatedStorage.Shared.Util.MonetizationEntitlements)
				end
			end)

			local function formatPetWeight(arg)
				if not arg then
					return "0 Kg"
				end
				local integerPart, fractionalPart = math.modf(math.round(arg * 100) / 100)
				local str = tostring(math.abs(integerPart)):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")

				if math.abs(fractionalPart) > 0.001 then
					str ..= string.format("%.2f", math.abs(fractionalPart)):sub(2)
				end

				return str .. " Kg"
			end

			local function formatIncomeRate(arg)
				if not arg or arg == 0 then
					return "0/s"
				end

				if arg >= 1e12 then
					return string.format("%.2fT/s", arg / 1e12)
				end

				if arg >= 1e9 then
					return string.format("%.2fB/s", arg / 1e9)
				end

				if arg >= 1000000 then
					return string.format("%.2fM/s", arg / 1000000)
				end

				if arg >= 1000 then
					return string.format("%.1fK/s", arg / 1000)
				end
				return string.format("%d/s", arg)
			end

			local function formatRemainingTime(arg)
				if arg <= 0 then
					return "READY"
				end
				local n = math.floor(arg / 3600)
				local n2 = math.floor(arg % 3600 / 60)
				local n3 = math.floor(arg % 60)
				if n > 0 then
					return string.format("%02dh %02dm %02ds", n, n2, n3)
				end
				return string.format("%02dm %02ds", n2, n3)
			end

			local function calculatePetIncome(arg, arg2, arg3, arg4)
				local n = (Assets and Assets.Directory or Assets or {})[arg]
				n = n and tonumber(n.EarningRate) or 0
				local n2 = arg2 or 1
				local n3

				if n2 <= 5 then
					n3 = n2 ^ 1.85
				else
					n3 = (n2 / 5) ^ 1.2 * 19.637875755794113
				end

				local getTotalMutationsEarningMulti = Mutations and Mutations.GetTotalMutationsEarningMulti

				if getTotalMutationsEarningMulti then
					getTotalMutationsEarningMulti = Mutations.GetTotalMutationsEarningMulti(arg3 or {})
				end

				getTotalMutationsEarningMulti = getTotalMutationsEarningMulti or 1
				local rebirthToMultiplier = rebirthUtil and rebirthUtil.RebirthToMultiplier

				if rebirthToMultiplier then
					rebirthToMultiplier = math.max(1, rebirthUtil.RebirthToMultiplier(arg4 and arg4.Rebirth or 0))
				end

				rebirthToMultiplier = rebirthToMultiplier or 1
				local getAssetMoneyAdditiveRebirthBonu = MonetizationEntitlements and MonetizationEntitlements.GetAssetMoneyAdditiveRebirthBonus

				if getAssetMoneyAdditiveRebirthBonu then
					getAssetMoneyAdditiveRebirthBonu = MonetizationEntitlements.GetAssetMoneyAdditiveRebirthBonus(arg4 and arg4.Gamepasses, arg4 and arg4.Products)
				end

				return math.max(math.round(n * n3 * getTotalMutationsEarningMulti * (rebirthToMultiplier + (getAssetMoneyAdditiveRebirthBonu or 0))), 1), n, n3, getTotalMutationsEarningMulti
			end

			local function getEggHatchStatus(arg, arg2)
				local placement = arg.Placement
				if not placement then
					return { IsPlaced = false, RemainingSeconds = 0, IsReady = false, StatusStr = "INVENTORY" }
				end

				if placement.ReadyAt ~= nil then
					return { IsPlaced = true, RemainingSeconds = 0, IsReady = true, StatusStr = "READY TO HATCH" }
				end
				local v7 = (Assets and Assets.Directory or Assets or {})[arg.AssetCategory]
				local growthTime = v7 and v7.Egg and v7.Egg.GrowthTime or 60
				local assetScale = arg.AssetScale or 1
				local n

				if assetScale <= 2 then
					n = 1
				elseif assetScale <= 6 then
					n = (assetScale / 2) ^ 1.389
				else
					n = math.min((assetScale / 6) ^ 0.72 * 4.6, 20)
				end

				local n2 = math.max(0, growthTime * n - arg2 - placement.PlacedAt + (placement.GrowthCreditSeconds or 0) + (placement.NightGrowthCreditSeconds or 0))
				local flag = n2 <= 0

				return {
					IsPlaced = true,
					RemainingSeconds = n2,
					IsReady = flag,
					StatusStr = flag and "READY TO HATCH" or formatRemainingTime(n2),
				}
			end

			petPredictor.GetForecastText = function()
				local get = Save.Get and Save.Get() or Save.Peek and Save.Peek() or {}
				if not get or not get.EggInventory then
					return "No egg inventory data available."
				end
				local serverTimeNow = workspace:GetServerTimeNow()
				local tbl6 = {}

				for k, v7 in pairs(get.EggInventory) do
					if not petPredictor.ShowOnlyPlaced or v7.Placement ~= nil then
						local assetCategory = v7.AssetCategory or "Unknown"
						local n = tonumber(v7.AssetScale) or 1
						local mutations = v7.Mutations or {}
						local baseMutation = v7.BaseMutation or mutations[1] or "None"
						local v8 = Assets.Directory[assetCategory]
						local rarity = v8 and v8.Rarity
						local displayName = rarity and (rarity.DisplayName or rarity.Name) or "Common"
						rarity = rarity and rarity.RarityNumber or 1
						local v9 = formatPetWeight((v8 and v8.ModelWeight or 1) * n ^ 3)
						local v10 = calculatePetIncome(assetCategory, n, mutations, get)
						local v11 = getEggHatchStatus(v7, serverTimeNow)

						if baseMutation == "Rainbow" then
							baseMutation = "Rainbow (+3x)"
						elseif baseMutation == "Golden" then
							baseMutation = "Golden (+2.5x)"
						elseif baseMutation == "Silver" then
							baseMutation = "Silver (+1.2x)"
						elseif baseMutation == "None" or baseMutation == "" then
							baseMutation = "Normal"
						end

						table.insert(tbl6, {
							Uid = k,
							Category = assetCategory,
							RarityName = displayName,
							RarityNumber = rarity,
							ScaleStr = string.format("%.2fx", n),
							KgStr = v9,
							MutDisplay = baseMutation,
							FinalRate = v10,
							IncomeStr = formatIncomeRate(v10),
							Growth = v11,
						})
					end
				end

				if #tbl6 == 0 then
					return petPredictor.ShowOnlyPlaced and "No placed eggs in your pen." or "No eggs in inventory."
				end

				if petPredictor.SortMode == "Income" then
					table.sort(tbl6, function(arg, arg2)
						return arg.FinalRate > arg2.FinalRate
					end)
				elseif petPredictor.SortMode == "Rarity" then
					table.sort(tbl6, function(arg, arg2)
						if arg.RarityNumber ~= arg2.RarityNumber then
							return arg.RarityNumber > arg2.RarityNumber
						end
						return arg.FinalRate > arg2.FinalRate
					end)
				elseif petPredictor.SortMode == "Time" then
					table.sort(tbl6, function(arg, arg2)
						return arg.Growth.RemainingSeconds < arg2.Growth.RemainingSeconds
					end)
				end

				local tbl7 = {
					[10] = "#FF1493",
					[9] = "#FF4500",
					[8] = "#FFFFFF",
					[7] = "#BA55D3",
					[6] = "#FF3366",
					[5] = "#FFA500",
					[4] = "#9932CC",
					[3] = "#1E90FF",
					[2] = "#32CD32",
					"#D3D3D3",
				}

				local tbl8 = {}
				table.insert(tbl8, string.format("<font color=\"#AAAAAA\">Total Tracked Eggs:</font> <b><font color=\"#00FF7F\">%d</font></b>", #tbl6))
				table.insert(tbl8, "<font color=\"#444455\">ââââââââââââââââââââââââââââââââââââââ</font>")

				for _, v7 in ipairs(tbl6) do
					local str = tbl7[v7.RarityNumber] or "#FFFFFF"
					local str2

					if v7.BaseMutation == "Rainbow" then
						str2 = "#FF69B4"
					elseif v7.BaseMutation == "Golden" then
						str2 = "#FFD700"
					else
						str2 = "#CCCCCC"

						if v7.BaseMutation == "Silver" then
							str2 = "#C0C0C0"
						end
					end

					local str3

					if v7.Growth.IsReady then
						str3 = "#00FF7F"
					else
						str3 = "#888899"

						if v7.Growth.IsPlaced then
							str3 = "#FFD700"
						end
					end

					table.insert(tbl8, string.format("â¢ <b><font color=\"%s\">[%s] %s</font></b> <font color=\"#FFD700\">(%s / %s)</font>", str, v7.RarityName, v7.Category, v7.ScaleStr, v7.KgStr))
					table.insert(tbl8, string.format("  <font color=\"%s\">%s</font> | <b><font color=\"#00FF7F\">%s</font></b> | <font color=\"%s\">%s</font>", str2, v7.MutDisplay, v7.IncomeStr, str3, v7.Growth.StatusStr))
				end

				return table.concat(tbl8, "\n")
			end

			petPredictor.UpdateParagraph = function()
				if not petPredictor.Paragraph then
					return
				end
				local v7 = petPredictor.GetForecastText()
				local str = string.format("Pet Predictor (%s)", petPredictor.ShowOnlyPlaced and "Pen Only" or "All Eggs")

				pcall(function()
					petPredictor.Paragraph:Set({ str, v7 })
				end)
			end

			return petPredictor
		end

		modules.PetPredictor = createPetPredictor()

		local function createFusePredictor()
			local fusePredictor = { Paragraph = nil }
			local assets = modules.Game and modules.Game.Assets
			local Assets

			if assets then
				Assets = assets
			else
				Assets = replicatedStorage:FindFirstChild("Data") and require(replicatedStorage.Data.Assets)
			end

			local save = modules.Game and modules.Game.Save
			local Save

			if save then
				Save = save
			else
				Save = replicatedStorage:FindFirstChild("Shared") and require(replicatedStorage.Shared.Save)
			end

			local Mutations = nil

			pcall(function()
				if replicatedStorage:FindFirstChild("Shared") and replicatedStorage.Shared:FindFirstChild("Modules") and replicatedStorage.Shared.Modules:FindFirstChild("Mutations") then
					Mutations = require(replicatedStorage.Shared.Modules.Mutations)
				elseif replicatedStorage:FindFirstChild("Data") and replicatedStorage.Data:FindFirstChild("Mutations") then
					Mutations = require(replicatedStorage.Data.Mutations)
				end
			end)

			local rebirthUtil = modules.Game and modules.Game.RebirthUtil
			local MonetizationEntitlements = nil

			pcall(function()
				if replicatedStorage:FindFirstChild("Shared") and replicatedStorage.Shared:FindFirstChild("Util") and replicatedStorage.Shared.Util:FindFirstChild("MonetizationEntitlements") then
					MonetizationEntitlements = require(replicatedStorage.Shared.Util.MonetizationEntitlements)
				end
			end)

			local tbl6 = {
				{ name = "Normal", min = 0.85, max = 1.05, baseWeight = 2000, color = "#CCCCCC" },
				{ name = "Large", min = 1.45, max = 1.55, baseWeight = 250, color = "#00FF7F" },
				{ name = "Giant", min = 1.9, max = 2.1, baseWeight = 125, color = "#1E90FF" },
				{ name = "Huge", min = 2.85, max = 3.15, baseWeight = 62.5, color = "#FFD700" },
				{ name = "Gigantic", min = 3.8, max = 4.2, baseWeight = 31.25, color = "#FF4500" },
				{ name = "Titan", min = 5.8, max = 6.2, baseWeight = 15.625, color = "#FF1493" },
				{ name = "Colossal", min = 9.5, max = 12.5, baseWeight = 3, color = "#BA55D3" },
			}

			local function formatFuseWeight(arg)
				if not arg then
					return "0 Kg"
				end
				local integerPart, fractionalPart = math.modf(math.round(arg * 100) / 100)
				local str = tostring(math.abs(integerPart)):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")

				if math.abs(fractionalPart) > 0.001 then
					str ..= string.format("%.2f", math.abs(fractionalPart)):sub(2)
				end

				return str .. " Kg"
			end

			local function formatFuseIncomeRate(arg)
				if not arg or arg == 0 then
					return "0/s"
				end

				if arg >= 1e12 then
					return string.format("%.2fT/s", arg / 1e12)
				end

				if arg >= 1e9 then
					return string.format("%.2fB/s", arg / 1e9)
				end

				if arg >= 1000000 then
					return string.format("%.2fM/s", arg / 1000000)
				end

				if arg >= 1000 then
					return string.format("%.1fK/s", arg / 1000)
				end
				return string.format("%d/s", arg)
			end

			local function estimateAverageWeight(arg, arg2, arg3)
				return math.exp(math.log(arg) / 0.69314718055994529 * math.log((arg2 + arg3) / 2) / 0.69314718055994529 * 0.6)
			end

			local function calculateFuseIncome(arg, arg2, arg3, arg4)
				local v7 = (Assets and Assets.Directory or Assets or {})[arg]
				local n = v7 and tonumber(v7.EarningRate) or 0
				arg2 = arg2 or 1
				local n2

				if arg2 <= 5 then
					n2 = arg2 ^ 1.85
				else
					n2 = (arg2 / 5) ^ 1.2 * 19.637875755794113
				end

				local getTotalMutationsEarningMulti = Mutations and Mutations.GetTotalMutationsEarningMulti

				if getTotalMutationsEarningMulti then
					getTotalMutationsEarningMulti = Mutations.GetTotalMutationsEarningMulti(arg3 or {})
				end

				getTotalMutationsEarningMulti = getTotalMutationsEarningMulti or 1
				local rebirthToMultiplier = rebirthUtil and rebirthUtil.RebirthToMultiplier

				if rebirthToMultiplier then
					rebirthToMultiplier = math.max(1, rebirthUtil.RebirthToMultiplier(arg4 and arg4.Rebirth or 0))
				end

				rebirthToMultiplier = rebirthToMultiplier or 1
				local getAssetMoneyAdditiveRebirthBonu = MonetizationEntitlements and MonetizationEntitlements.GetAssetMoneyAdditiveRebirthBonus

				if getAssetMoneyAdditiveRebirthBonu then
					getAssetMoneyAdditiveRebirthBonu = MonetizationEntitlements.GetAssetMoneyAdditiveRebirthBonus(arg4 and arg4.Gamepasses, arg4 and arg4.Products)
				end

				return math.max(math.round(n * n2 * getTotalMutationsEarningMulti * (rebirthToMultiplier + (getAssetMoneyAdditiveRebirthBonu or 0))), 1), n, n2, getTotalMutationsEarningMulti
			end

			fusePredictor.GetForecastText = function()
				local get = Save.Get and Save.Get() or Save.Peek and Save.Peek() or {}
				if not get then
					return "<font color=\"#888899\">No player save data available.</font>"
				end
				local fusionSlots = get.FusionSlots or {}
				local inventory = get.Inventory or {}
				local tbl7 = {}

				for _, fusionSlot in ipairs(fusionSlots) do
					local v7 = inventory[fusionSlot]

					if v7 then
						table.insert(tbl7, v7)
					end
				end

				if #tbl7 == 0 and get.PrivateFusionSlots then
					for _, privateFusionSlot in ipairs(get.PrivateFusionSlots) do
						local v7 = inventory[privateFusionSlot]

						if v7 then
							table.insert(tbl7, v7)
						end
					end
				end

				if #tbl7 == 0 then
					return "<font color=\"#888899\">No pets currently inside Fuse Machine.\nInsert 3 pets of the same species to predict results.</font>"
				end
				local tbl8 = {}
				local category = tbl7[1] and tbl7[1].Category or "Unknown"
				local rarity = Assets.Directory[category]
				local modelWeight = rarity and rarity.ModelWeight or 1
				rarity = rarity and rarity.Rarity

				if rarity then
					rarity = rarity.DisplayName or rarity.Name
				end

				local str = rarity or "Common"
				table.insert(tbl8, string.format("<b><font color=\"#FFD700\">â¡ FUSE MACHINE STATUS (%d/3 Pets)</font></b>", #tbl7))
				table.insert(tbl8, "<font color=\"#444455\">ââââââââââââââââââââââââââââââââââââââ</font>")
				table.insert(tbl8, string.format("â¢ <b>Species:</b> <font color=\"#FFFFFF\">[%s] %s</font>", str, category))
				local n = 0
				local n2 = 0
				local str2 = "Normal"

				for i, v7 in ipairs(tbl7) do
					local n3 = tonumber(v7.Scale) or 1
					n += n3
					local v8 = formatFuseWeight(modelWeight * n3 ^ 3)
					local str3 = (v7.Mutations or {})[1] or "Normal"

					if str3 ~= "Normal" then
						n2 += 1

						if str3 == "Rainbow" or str3 == "Golden" and str2 ~= "Rainbow" or str3 == "Silver" and str2 == "Normal" then
							str2 = str3
						end
					end

					table.insert(tbl8, string.format("  <font color=\"#AAAAAA\">Pet #%d:</font> <font color=\"#FFD700\">%.2fx (%s)</font> | <font color=\"#CCCCCC\">%s</font>", i, n3, v8, str3))
				end

				if #tbl7 < 3 then
					table.insert(tbl8, "")
					table.insert(tbl8, string.format("<font color=\"#E67E22\">â ï¸ Waiting for %d more pet(s) to calculate final odds.</font>", 3 - #tbl7))
					return table.concat(tbl8, "\n")
				end

				local n3 = n / 3
				table.insert(tbl8, "")
				table.insert(tbl8, string.format("â¢ <b>Average Scale:</b> <font color=\"#00FF7F\"><b>%.2fx (%s)</b></font>", n3, formatFuseWeight(modelWeight * n3 ^ 3)))
				local tbl9 = {}
				local n4 = 0

				for _, v7 in ipairs(tbl6) do
					local n5 = v7.baseWeight * estimateAverageWeight(n3, v7.min, v7.max)
					n4 += n5
					table.insert(tbl9, { tier = v7, weight = n5 })
				end

				table.insert(tbl8, "")
				table.insert(tbl8, "<b><font color=\"#6495ED\">ð Predicted Scale Tier Probabilities:</font></b>")

				for _, v7 in ipairs(tbl9) do
					local n5 = v7.weight / n4 * 100

					if n5 >= 0.5 then
						local tier = v7.tier
						local n6 = modelWeight * tier.max ^ 3
						table.insert(tbl8, string.format("  <font color=\"%s\">â¢ %-8s</font> <font color=\"#AAAAAA\">(%.2fx - %.2fx / %s - %s):</font> <b><font color=\"%s\">%.1f%%</font></b>", tier.color, tier.name, tier.min, tier.max, formatFuseWeight(modelWeight * tier.min ^ 3), formatFuseWeight(n6), n5 >= 20 and "#00FF7F" or "#FFD700", n5))
					end
				end

				local n5 = n3 * 0.95
				local n6 = n3 * 1.55
				local v7 = calculateFuseIncome(category, n5, str2 ~= "Normal" and { str2 } or {}, get)
				local v8 = calculateFuseIncome(category, n6, str2 ~= "Normal" and { str2 } or {}, get)
				table.insert(tbl8, "")
				table.insert(tbl8, string.format("â¢ <b>Predicted Mutation:</b> <font color=\"#FFD700\">%s</font>", str2))
				table.insert(tbl8, string.format("â¢ <b>Estimated Income:</b> <b><font color=\"#00FF7F\">%s</font></b> ~ <b><font color=\"#00FF7F\">%s</font></b>", formatFuseIncomeRate(v7), formatFuseIncomeRate(v8)))
				return table.concat(tbl8, "\n")
			end

			fusePredictor.UpdateParagraph = function()
				if not fusePredictor.Paragraph then
					return
				end
				local v7 = fusePredictor.GetForecastText()

				pcall(function()
					fusePredictor.Paragraph:Set({ "Fuse Predictor", v7 })
				end)
			end

			return fusePredictor
		end

		modules.FusePredictor = createFusePredictor()

		local function createFuseModule()
			local fuseManager = {
				PriorityMode = "Lowest Rarity First",
				MaxRarity = 0,
				SpecificSpecies = {},
				SkipMutations = true,
				EjectIncomplete = false,
				LastFuseAt = 0,
				IsFusing = false,
			}

			local tbl6 = {}

			pcall(function()
				local assets = modules.Game and modules.Game.Assets or replicatedStorage:FindFirstChild("Data") and require(replicatedStorage.Data.Assets)
				local directory = assets and assets.Directory or assets

				if directory then
					for k, v7 in pairs(directory) do
						tbl6[k] = v7
					end
				end
			end)

			local function getFuseAssetDirectory()
				if next(tbl6) then
					return tbl6
				end

				pcall(function()
					local assets = modules.Game and modules.Game.Assets or replicatedStorage:FindFirstChild("Data") and require(replicatedStorage.Data.Assets)
					local directory = assets and assets.Directory or type(assets) == "table" and assets

					if directory and type(directory) == "table" then
						for k, v7 in pairs(directory) do
							tbl6[k] = v7
						end
					end
				end)

				return tbl6
			end

			fuseManager.ResolveRarityNumber = function(arg)
				if not arg then
					return 1
				end

				if type(arg) == "number" then
					return arg
				end

				if type(arg) == "table" then
					arg = arg.AssetCategory or arg.Category or arg.Name or arg.DisplayName or arg[1]
				end

				local v7 = getFuseAssetDirectory()
				v7 = v7 and v7[arg]

				if v7 then
					if v7.Rarity and type(v7.Rarity) == "table" then
						if type(v7.Rarity.Rank) == "number" then
							return v7.Rarity.Rank
						end

						if type(v7.Rarity.RarityNumber) == "number" then
							return v7.Rarity.RarityNumber
						end
					end

					if type(v7.Rank) == "number" then
						return v7.Rank
					end

					if type(v7.RarityNumber) == "number" then
						return v7.RarityNumber
					end
				end

				if modules.Steal and modules.Steal.GetEggRarityNumber then
					local ok, result = pcall(modules.Steal.GetEggRarityNumber, arg)
					if ok and type(result) == "number" and result > 0 then
						return result
					end
				end

				return 1
			end

			fuseManager.GetFuseryRemotes = function()
				if modules.Game and modules.Game.Remotes and modules.Game.Remotes.Fusery then
					return modules.Game.Remotes.Fusery
				end

				local ok, result = pcall(function()
					return require(replicatedStorage.Shared.Remotes)
				end)

				if ok and result and result.Fusery then
					return result.Fusery
				end
				return nil
			end

			fuseManager.IsPetEligible = function(arg, arg2, arg3)
				if not arg2 or type(arg2) ~= "table" or not arg2.Category then
					return false
				end

				if arg2.IsFavorite then
					return false
				end

				if arg2.InFuse then
					return false
				end

				if arg3 and arg3[arg] then
					return false
				end
				local displayName = tbl6[arg2.Category]
				if displayName and displayName.CannotFuse == true then
					return false
				end

				if fuseManager.SkipMutations then
					if type(arg2.Mutations) == "table" and #arg2.Mutations > 0 then
						return false
					end

					if arg2.BaseMutation and arg2.BaseMutation ~= "" and arg2.BaseMutation ~= "Normal" then
						return false
					end
				end

				if fuseManager.MaxRarity and fuseManager.MaxRarity > 0 then
					if fuseManager.MaxRarity < fuseManager.ResolveRarityNumber(arg2.Category) then
						return false
					end
				end

				if #fuseManager.SpecificSpecies > 0 or fuseManager.PriorityMode == "Specific Species Only" then
					local category = arg2.Category

					if displayName then
						displayName = displayName.DisplayName or displayName.Name
					end

					displayName = displayName or category
					local flag = false

					for _, specificSpecy in ipairs(fuseManager.SpecificSpecies) do
						if specificSpecy == category or specificSpecy == displayName or string.find(specificSpecy, category, 1, true) or string.find(specificSpecy, displayName, 1, true) then
							flag = true
							break
						end
					end

					if not flag then
						return false
					end
				end

				return true
			end

			fuseManager.Execute = function()
				if fuseManager.IsFusing then
					return false, "busy"
				end
				local lastFuseAt = fuseManager.LastFuseAt
				if os.clock() - lastFuseAt < 1.8 then
					return false, "cooldown"
				end
				local v7 = fuseManager.GetFuseryRemotes()
				if not v7 then
					return false, "no fusery remotes"
				end
				local getSave = modules.Game and modules.Game.GetSave and modules.Game.GetSave()
				if not getSave then
					return false, "no save data"
				end

				if getSave.FusionInfoAcknowledged == false then
					pcall(function()
						if v7.ConfirmBriefing then
							v7.ConfirmBriefing:InvokeServer()
						end
					end)
				end

				local getSave2

				if getSave.FusionEggReward then
					pcall(function()
						if v7.FinishReveal then
							v7.FinishReveal:InvokeServer()
						end
					end)

					task.wait(0.3)
					getSave2 = modules.Game and modules.Game.GetSave and modules.Game.GetSave() or getSave
				else
					getSave2 = getSave
				end

				if getSave2.FusionLocked then
					return false, "fusion locked"
				end
				local v8, v9, v10 = pairs(getSave2.EggInventory or {})
				local n = 0

				for k in v8, v9, v10 do
					n += 1
				end

				if n >= 100 then
					return false, "egg inventory full"
				end
				local inventory = getSave2.Inventory or {}
				local tbl7 = {}

				if type(getSave2.EquippedPets) == "table" then
					for _, equippedPet in ipairs(getSave2.EquippedPets) do
						tbl7[equippedPet] = true
					end
				end

				local fusionSlots = getSave2.FusionSlots or getSave2.PrivateFusionSlots or {}
				local tbl8 = {}
				local category = nil

				for _, fusionSlot in ipairs(fusionSlots) do
					if fusionSlot and inventory[fusionSlot] then
						local v11 = inventory[fusionSlot]

						if type(v11) == "string" or type(v11) == "table" and not v11.Category then
							pcall(function()
								if modules.Game and modules.Game.AssetItemSerialization and modules.Game.AssetItemSerialization.Deserialize then
									v11 = modules.Game.AssetItemSerialization.Deserialize(v11)
								end
							end)
						end

						if type(v11) == "table" and v11.Category then
							table.insert(tbl8, fusionSlot)
							category = category or v11.Category
						end
					end
				end

				fuseManager.IsFusing = true
				fuseManager.LastFuseAt = os.clock()

				local ok, result = pcall(function()
					if #tbl8 == 3 then
						_G.LastAction = string.format("Fuse: Fusing 3x %s", tostring(category or "Pets"))
						local response, v11 = v7.BeginFuse:InvokeServer()

						if response then
							task.wait(0.25)

							if v7.FinishReveal then
								v7.FinishReveal:InvokeServer()
							end

							if modules.FusePredictor and modules.FusePredictor.UpdateParagraph then
								modules.FusePredictor.UpdateParagraph()
							end

							return true, "fused"
						end

						return false, tostring(v11)
					end

					if #tbl8 > 0 and #tbl8 < 3 and category then
						local n2 = 3 - #tbl8
						local tbl9 = {}

						for k, v11 in pairs(inventory) do
							if not table.find(tbl8, k) then
								local v12 = v11

								if type(v11) == "string" or type(v11) == "table" and not v11.Category then
									pcall(function()
										if modules.Game and modules.Game.AssetItemSerialization and modules.Game.AssetItemSerialization.Deserialize then
											v12 = modules.Game.AssetItemSerialization.Deserialize(v11)
										end
									end)
								end

								if fuseManager.IsPetEligible(k, v12, tbl7) and v12.Category == category then
									table.insert(tbl9, { uid = k, item = v12, scale = tonumber(v12.Scale) or 1 })
								end
							end
						end

						if n2 <= #tbl9 then
							table.sort(tbl9, function(arg, arg2)
								return arg.scale < arg2.scale
							end)

							for i = 1, n2 do
								local v11 = tbl9[i]
								local v12 = tostring
								local uid = v11.uid
								_G.LastAction = string.format("Fuse: Loading %s (%s)", tostring(category), v12(uid))
								v7.LoadPet:InvokeServer(v11.uid)
								table.insert(tbl8, v11.uid)
								task.wait(0.15)
							end

							if #tbl8 == 3 then
								_G.LastAction = string.format("Fuse: Fusing 3x %s", tostring(category))

								if v7.BeginFuse:InvokeServer() then
									task.wait(0.25)

									if v7.FinishReveal then
										v7.FinishReveal:InvokeServer()
									end

									if modules.FusePredictor and modules.FusePredictor.UpdateParagraph then
										modules.FusePredictor.UpdateParagraph()
									end

									return true, "fused"
								end
							end
						elseif fuseManager.EjectIncomplete then
							for _, v11 in ipairs(tbl8) do
								_G.LastAction = string.format("Fuse: Ejecting incomplete slot %s", tostring(v11))
								v7.EjectPet:InvokeServer(v11)
								task.wait(0.15)
							end

							return true, "ejected incomplete"
						end

						return false, "waiting for more matching pets"
					end

					local tbl9 = {}

					for k, v11 in pairs(inventory) do
						local v12 = v11

						if type(v11) == "string" or type(v11) == "table" and not v11.Category then
							pcall(function()
								if modules.Game and modules.Game.AssetItemSerialization and modules.Game.AssetItemSerialization.Deserialize then
									v12 = modules.Game.AssetItemSerialization.Deserialize(v11)
								end
							end)
						end

						if fuseManager.IsPetEligible(k, v12, tbl7) then
							local category2 = v12.Category

							if not tbl9[category2] then
								tbl9[category2] = { category = category2, rarityNum = fuseManager.ResolveRarityNumber(category2), pets = {} }
							end

							table.insert(tbl9[category2].pets, { uid = k, item = v12, scale = tonumber(v12.Scale) or 1 })
						end
					end

					local tbl10 = {}

					for _, v11 in pairs(tbl9) do
						if #v11.pets >= 3 then
							table.insert(tbl10, v11)
						end
					end

					if #tbl10 == 0 then
						return false, "no 3x matching pets available"
					end

					if fuseManager.PriorityMode == "Lowest Rarity First" then
						table.sort(tbl10, function(arg, arg2)
							if arg.rarityNum == arg2.rarityNum then
								return #arg.pets > #arg2.pets
							end
							return arg.rarityNum < arg2.rarityNum
						end)
					elseif fuseManager.PriorityMode == "Highest Rarity First" then
						table.sort(tbl10, function(arg, arg2)
							if arg.rarityNum == arg2.rarityNum then
								return #arg.pets > #arg2.pets
							end
							return arg.rarityNum > arg2.rarityNum
						end)
					elseif fuseManager.PriorityMode == "Most Duplicates First" then
						table.sort(tbl10, function(arg, arg2)
							if #arg.pets == #arg2.pets then
								return arg.rarityNum < arg2.rarityNum
							end
							return #arg.pets > #arg2.pets
						end)
					end

					local v11 = tbl10[1]
					if not v11 or #v11.pets < 3 then
						return false, "no valid group"
					end

					table.sort(v11.pets, function(arg, arg2)
						return arg.scale < arg2.scale
					end)

					local n2 = 0

					for i = 1, 3 do
						local v12 = v11.pets[i]
						local v13 = tostring
						local uid = v12.uid
						_G.LastAction = string.format("Fuse: Loading %s (%s)", tostring(v11.category), v13(uid))

						if v7.LoadPet:InvokeServer(v12.uid) ~= false then
							n2 += 1
						end

						task.wait(0.15)
					end

					if n2 >= 3 then
						_G.LastAction = string.format("Fuse: Fusing 3x %s", tostring(v11.category))
						local response, v12 = v7.BeginFuse:InvokeServer()

						if response then
							task.wait(0.25)

							if v7.FinishReveal then
								v7.FinishReveal:InvokeServer()
							end

							if modules.FusePredictor and modules.FusePredictor.UpdateParagraph then
								modules.FusePredictor.UpdateParagraph()
							end

							return true, string.format("Fused 3x %s", v11.category)
						end

						return false, tostring(v12 or "begin fuse failed")
					end

					return false, "could not load 3 pets"
				end)

				fuseManager.IsFusing = false
				return ok, result
			end

			fuseManager.Step = function()
				if not enabled["Auto Fuse Machine"] then
					return
				end
				fuseManager.Execute()
			end

			return fuseManager
		end

		modules.Fuse = createFuseModule()
		modules.AntiTrap = {}

		local function createScrambleModule()
			local steal = modules.Steal
			local farmState = modules.FarmState
			local treadmill = modules.Treadmill
			local utils = modules.Utils

			local scrambleManager = {
				Snapshot = nil,
				LastSnapshotFetch = 0,
				SnapshotInterval = 1.8,
				LastDroneScan = 0,
				LastBatSwing = 0,
				NextBatType = "Original",
				LastShopBuyAt = 0,
				IsFarmingDrone = false,
				CurrentTargetDrone = nil,
				CurrentTargetInfo = "None",
				StatusParagraph = nil,
				ShopParagraph = nil,
				DroneESPFolder = nil,
				DropsESPFolder = nil,
				Config = {
					TweenSpeed = 300,
					AttackDistance = 3.5,
					BatSwingInterval = 0.72,
					FastSwitchBat = true,
					FastSwitchDelay = 40,
					PriorityTarget = "Closest",
					OrchestratorMode = "Prioritize Event",
					ShopReserve = 0,
					SelectedShopItems = {},
				},
				ActiveDrops = {},
				ActiveDrones = {},
				ESPObjects = {},
				CachedOrigBat = nil,
				CachedScramBat = nil,
			}

			local function parseCFrameValue(arg)
				if typeof(arg) == "CFrame" then
					return arg
				end

				if type(arg) == "string" then
					local components = {}

					for match in string.gmatch(arg, "[-0-9%.e]+") do
						table.insert(components, tonumber(match))
					end

					if #components >= 12 then
						return CFrame.new(unpack(components))
					end

					if #components >= 3 then
						return CFrame.new(components[1], components[2], components[3])
					end
				end

				return nil
			end

			local function normalizeDroneTier(arg)
				local str = tostring(arg or ""):lower()
				if str:find("aug") then
					return "AugmentedDrone", 3
				end

				if str:find("react") then
					return "ReactorDrone", 2
				end

				if str:find("scrap") then
					return "ScrapDrone", 1
				end
				return "ScrapDrone", 1
			end

			local function getScrambleRemotes()
				local ReplicatedStorage = game:GetService("ReplicatedStorage")
				local remotes = modules.Game and modules.Game.Remotes

				if not remotes then
					remotes = ReplicatedStorage:FindFirstChild("Shared") and ReplicatedStorage.Shared:FindFirstChild("Remotes") and require(ReplicatedStorage.Shared.Remotes)
				end

				if remotes and remotes.Scramble then
					return remotes.Scramble
				end
				local networking = ReplicatedStorage:FindFirstChild("Packages") and ReplicatedStorage.Packages:FindFirstChild("Networking")

				if networking then
					return {
						Request = networking:FindFirstChild("RF/Scramble/Request"),
						Collect = networking:FindFirstChild("RE/Scramble/Collect"),
						Drones = networking:FindFirstChild("RE/Scramble/Drones"),
						Drops = networking:FindFirstChild("RE/Scramble/Drops"),
						RemoveDrops = networking:FindFirstChild("RE/Scramble/RemoveDrops"),
						State = networking:FindFirstChild("RE/Scramble/State"),
						Effect = networking:FindFirstChild("RE/Scramble/Effect"),
					}
				end

				return nil
			end

			scrambleManager.GetSnapshot = function(arg)
				local now = os.clock()
				if not arg and scrambleManager.Snapshot and now - scrambleManager.LastSnapshotFetch < scrambleManager.SnapshotInterval then
					return scrambleManager.Snapshot
				end
				local v7 = getScrambleRemotes()

				if v7 and v7.Request then
					local ok, snapshot = pcall(function()
						return v7.Request:InvokeServer("Snapshot")
					end)

					if ok and type(snapshot) == "table" then
						scrambleManager.Snapshot = snapshot
						scrambleManager.LastSnapshotFetch = now

						if snapshot.Drones and snapshot.Drones.Upserts then
							scrambleManager.ActiveDrones = snapshot.Drones.Upserts
						end

						local activeDrops = {}

						if snapshot.Drops then
							for _, drop in ipairs(snapshot.Drops) do
								if drop and drop.Id then
									activeDrops[drop.Id] = drop
								end
							end
						end

						scrambleManager.ActiveDrops = activeDrops
						return snapshot
					end
				end

				return scrambleManager.Snapshot
			end

			scrambleManager.IsEventActive = function()
				local v7 = scrambleManager.GetSnapshot()
				if not v7 or not v7.Window then
					return false
				end
				return v7.Window.Active == true
			end

			scrambleManager.ReleaseMovement = function()
				scrambleManager.IsFarmingDrone = false
				scrambleManager.CurrentTargetDrone = nil
				scrambleManager.CurrentTargetInfo = "None"
				scrambleManager.CachedOrigBat = nil
				scrambleManager.CachedScramBat = nil

				if modules.Movement then
					modules.Movement.Release("ScrambleDrone")
				end
			end

			scrambleManager.CanRun = function()
				if not enabled["Auto Farm Drones"] then
					return false
				end

				if steal and steal.IsNightOrWallClosed and steal.IsNightOrWallClosed() then
					return false
				end
				local orchestratorMode = scrambleManager.Config.OrchestratorMode or "Prioritize Event"
				if orchestratorMode == "Prioritize Event" then
					return scrambleManager.IsEventActive()
				end

				if orchestratorMode == "Steal Idle" then
					if not scrambleManager.IsEventActive() then
						return false
					end
					local value = farmState and farmState.GetCarryState and select(1, farmState.GetCarryState())
					if steal and (steal.IsStealing or value) then
						return false
					end

					if enabled["Auto Steal"] and steal and steal.PickTarget and steal.PickTarget() ~= nil then
						return false
					end
					return true
				end

				return false
			end

			local function matchesSelectedItem(arg, arg2)
				if not arg2 or #arg2 == 0 then
					return false
				end
				local str = tostring(arg.Id or ""):lower()
				local str2 = tostring(arg.Label or ""):lower()

				for _, v7 in ipairs(arg2) do
					local str3 = tostring(v7):lower()
					if str3 == str or str3 == str2 then
						return true
					end

					if str ~= "" and str3:find(str, 1, true) then
						return true
					end

					if str2 ~= "" and str3:find(str2, 1, true) then
						return true
					end

					if str == "mutationconsumable" and (str3:find("mutation") or str3:find("scrambled")) then
						return true
					end

					if str == "limitedtimeexperimentpet" and (str3:find("experiment") or str3:find("001")) then
						return true
					end

					if str == "nibbles013" and (str3:find("nibbles") or str3:find("013")) then
						return true
					end

					if str == "cashbooster" and str3:find("cash") then
						return true
					end

					if str == "speedboost" and str3:find("speed") then
						return true
					end

					if str == "treadmillbooster" and str3:find("treadmill") then
						return true
					end
				end

				return false
			end

			scrambleManager.StepAutoShop = function(arg)
				local flag = not arg
				if flag and not enabled["Auto Buy Scramble Shop"] then
					return
				end
				local now = os.clock()
				if flag and now - scrambleManager.LastShopBuyAt < 2 then
					return
				end
				scrambleManager.LastShopBuyAt = now
				local v7 = scrambleManager.GetSnapshot(true)
				if not v7 or not v7.Shop or not v7.State then
					return
				end
				local n = (v7.State.Samples or 0) - (scrambleManager.Config.SampleReserve or scrambleManager.Config.ShopReserve or 0)
				if n <= 0 then
					return
				end
				local selectedShopItems = scrambleManager.Config.SelectedShopItems or {}
				if #selectedShopItems == 0 then
					return
				end
				local v8 = getScrambleRemotes()
				if not v8 or not v8.Request then
					return
				end

				for _, v9 in ipairs(v7.Shop) do
					local label = v9.Label or v9.Id

					if matchesSelectedItem(v9, selectedShopItems) then
						if v9.Price <= n then
							local v10 = (v7.State.ShopPurchases or {})[v9.Id]

							if not v9.PurchaseLimit or (v10 and v10.Count or 0) < v9.PurchaseLimit then
								local ok, result = pcall(function()
									return v8.Request:InvokeServer("Shop", v9.Id, { Quote = v9.Quote, Sequence = v7.State.ShopSequence or 0 })
								end)

								if ok and result and result.Ok then
									n -= v9.Price

									if result.Snapshot and result.Snapshot.State then
										v7.State.ShopSequence = result.Snapshot.State.ShopSequence
										v7.State.Samples = result.Snapshot.State.Samples
										v7.State.ShopPurchases = result.Snapshot.State.ShopPurchases
										scrambleManager.Snapshot = result.Snapshot
									else
										v7.State.ShopSequence = (v7.State.ShopSequence or 0) + 1
									end

									utils.Notify("Scramble Shop", string.format("Purchased %s for %d Samples!", label, v9.Price), 3)
									task.wait(0.25)
								end
							end
						end
					end
				end
			end

			scrambleManager.StepShop = scrambleManager.StepAutoShop

			scrambleManager.SafeApproach = function(arg, arg2)
				local character2 = localPlayer.Character
				if not (character2 and character2:FindFirstChild("HumanoidRootPart")) then
					return false
				end
				local n = math.max(arg2 or 300, 50)
				local autoSteal = scrambleManager.Config.OrchestratorMode == "Steal Idle" and enabled["Auto Steal"]

				if (steal.IsInSafeZone and steal.IsInSafeZone() or steal.IsInSafeZoneArea and steal.IsInSafeZoneArea()) and steal.GetSafeZone then
					local v7 = steal.GetSafeZone()

					if v7 then
						steal.TweenTo(v7, n, { Owner = "ScrambleDrone", AbortOnStealTarget = autoSteal })
					end
				end

				return steal.TweenTo(arg, n, { Owner = "ScrambleDrone", AbortOnStealTarget = autoSteal })
			end

			local function classifyBatTool(scramBat, arg)
				if not (scramBat and scramBat:IsA("Tool")) then
					return
				end
				local attribute = scramBat:GetAttribute("GearName")
				local flag = scramBat:GetAttribute("IsBat") == true
				local str = scramBat.Name:lower()

				if attribute == "The Scrambler" or str:find("the scrambler") or str:find("scrambler") then
					if not arg.scramBat then
						arg.scramBat = scramBat
					end
				elseif flag or attribute == "Bat" or attribute and attribute:lower():find("bat") or str:find("bat") then
					if attribute ~= "The Scrambler" and not str:find("scrambler") then
						if not arg.origBat then
							arg.origBat = scramBat
						end
					end
				end
			end

			local function findBatTools()
				local character2 = localPlayer and localPlayer.Character
				local backpack = localPlayer and localPlayer:FindFirstChildOfClass("Backpack")
				local cachedOrigBat = scrambleManager.CachedOrigBat
				local cachedScramBat = scrambleManager.CachedScramBat
				if cachedOrigBat and cachedOrigBat.Parent and (cachedOrigBat.Parent == character2 or cachedOrigBat.Parent == backpack) and cachedScramBat and cachedScramBat.Parent and (cachedScramBat.Parent == character2 or cachedScramBat.Parent == backpack) then
					return cachedOrigBat, cachedScramBat
				end
				local tbl6 = { origBat = nil, scramBat = nil }

				if character2 then
					for _, child in ipairs(character2:GetChildren()) do
						classifyBatTool(child, tbl6)
					end
				end

				if backpack then
					for _, child in ipairs(backpack:GetChildren()) do
						classifyBatTool(child, tbl6)
					end
				end

				scrambleManager.CachedOrigBat = tbl6.origBat
				scrambleManager.CachedScramBat = tbl6.scramBat
				return tbl6.origBat, tbl6.scramBat
			end

			scrambleManager.GetLiveDronePos = function(arg)
				local snapshot = scrambleManager.Snapshot
				if not snapshot or not snapshot.Drones or not snapshot.Drones.Upserts then
					return nil
				end

				for _, upsert in ipairs(snapshot.Drones.Upserts) do
					if (upsert.Id or tostring(upsert)) == arg then
						local n = tonumber(upsert.Health) or 0
						if n <= 0 then
							return nil
						end
						local position = parseCFrameValue(upsert.CFrame)
						position = position and position.Position
						if position then
							return position, n
						end
						return nil
					end
				end

				return nil
			end

			scrambleManager.SwingBat = function(arg, arg2)
				local v7, v8 = findBatTools()

				if scrambleManager.Config.FastSwitchBat ~= false and v7 ~= nil and v8 ~= nil then
					local fastSwitchDelay = scrambleManager.Config.FastSwitchDelay or 40
					local n = fastSwitchDelay >= 1 and fastSwitchDelay / 1000 or fastSwitchDelay
					local n2 = math.clamp(n * 0.5, 0.02, 0.04)
					local flag = scrambleManager.NextBatType == "Scrambler" and v8 or v7
					scrambleManager.NextBatType = flag == v8 and "Original" or "Scrambler"

					if flag.Parent ~= arg then
						arg2:EquipTool(flag)
						task.wait(n2)
					end

					pcall(function()
						flag:Activate()

						if flag:GetAttribute("GearName") == "The Scrambler" then
							local ReplicatedStorage = game:GetService("ReplicatedStorage")
							local remotes = modules.Game and modules.Game.Remotes or ReplicatedStorage:FindFirstChild("Shared") and ReplicatedStorage.Shared:FindFirstChild("Remotes") and require(ReplicatedStorage.Shared.Remotes)

							if remotes and remotes.ToolTrigger and remotes.ToolTrigger.Trigger then
								remotes.ToolTrigger.Trigger:FireServer(flag)
							end
						end
					end)

					scrambleManager.LastBatSwing = os.clock()
					task.wait(n)
				else
					local v9 = v7 or v8

					if not v9 then
						local backpack = localPlayer:FindFirstChildOfClass("Backpack")

						if backpack then
							for _, child in ipairs(backpack:GetChildren()) do
								local isTool = child:IsA("Tool")

								if isTool then
									isTool = child:GetAttribute("IsBat") == true or child:GetAttribute("GearName") == "The Scrambler" or child.Name:lower():find("bat")
								end

								if isTool then
									v9 = child
									break
								end
							end
						end
					end

					if v9 and v9.Parent ~= arg then
						arg2:EquipTool(v9)
						task.wait(0.03)
					end

					local batSwingInterval = scrambleManager.Config.BatSwingInterval or scrambleManager.Config.SwingInterval or 0.65
					local flag

					if v9 then
						local lastBatSwing = scrambleManager.LastBatSwing
						flag = os.clock() - lastBatSwing >= batSwingInterval
					else
						flag = v9
					end

					if flag then
						scrambleManager.LastBatSwing = os.clock()

						pcall(function()
							v9:Activate()

							if v9:GetAttribute("GearName") == "The Scrambler" then
								local ReplicatedStorage = game:GetService("ReplicatedStorage")
								local remotes = modules.Game and modules.Game.Remotes or ReplicatedStorage:FindFirstChild("Shared") and ReplicatedStorage.Shared:FindFirstChild("Remotes") and require(ReplicatedStorage.Shared.Remotes)

								if remotes and remotes.ToolTrigger and remotes.ToolTrigger.Trigger then
									remotes.ToolTrigger.Trigger:FireServer(v9)
								end
							end
						end)
					end

					task.wait(0.05)
				end
			end

			scrambleManager.StepDrones = function()
				if not enabled["Auto Farm Drones"] then
					return false
				end

				if not scrambleManager.IsEventActive() then
					scrambleManager.ReleaseMovement()
					return false
				end

				if scrambleManager.Config.OrchestratorMode == "Steal Idle" and enabled["Auto Steal"] then
					local value = farmState and farmState.GetCarryState and select(1, farmState.GetCarryState())
					if steal and (steal.IsStealing or value) then
						scrambleManager.ReleaseMovement()
						return false
					end

					if steal and steal.PickTarget and steal.PickTarget() ~= nil then
						scrambleManager.ReleaseMovement()
						return false
					end
				end

				local v7 = scrambleManager.GetSnapshot()
				if not v7 or not v7.Drones or not v7.Drones.Upserts then
					scrambleManager.ReleaseMovement()
					return false
				end
				local character2 = localPlayer.Character
				local humanoidRootPart2 = character2 and character2:FindFirstChild("HumanoidRootPart")
				character2 = character2 and character2:FindFirstChildOfClass("Humanoid")
				if not humanoidRootPart2 or not character2 or character2.Health <= 0 then
					scrambleManager.ReleaseMovement()
					return false
				end
				local priorityTarget = scrambleManager.Config.PriorityTarget or "Closest"
				local tbl6 = {}

				for _, upsert in ipairs(v7.Drones.Upserts) do
					local n = tonumber(upsert.Health) or 0

					if n > 0 then
						local v8, v9 = normalizeDroneTier(upsert.Attributes and upsert.Attributes.ScrambleTier or "ScrapDrone")
						local flag = priorityTarget == "Augmented Only" and v8 ~= "AugmentedDrone"
						local flag2 = true

						if flag then
							flag2 = false
						end

						if priorityTarget == "Reactor Only" and v8 ~= "ReactorDrone" then
							flag2 = false
						end

						if priorityTarget == "Scrap Only" and v8 ~= "ScrapDrone" then
							flag2 = false
						end

						if flag2 then
							local position = parseCFrameValue(upsert.CFrame)
							position = position and position.Position

							if position then
								local magnitude = (humanoidRootPart2.Position - position).Magnitude

								table.insert(tbl6, {
									drone = upsert,
									id = upsert.Id or tostring(upsert),
									pos = position,
									dist = magnitude,
									hp = n,
									tier = v8,
									rank = v9,
								})
							end
						end
					end
				end

				if #tbl6 == 0 then
					scrambleManager.CurrentTargetDrone = nil
					scrambleManager.CurrentTargetInfo = "No target drones"
					scrambleManager.ReleaseMovement()
					return false
				end

				local id = scrambleManager.CurrentTargetDrone and scrambleManager.CurrentTargetDrone.Id
				local v8 = nil

				if id then
					v8 = nil

					for _, v9 in ipairs(tbl6) do
						if v9.id == scrambleManager.CurrentTargetDrone.Id then
							v8 = nil

							if v9.dist <= 18 then
								v8 = v9
							end

							break
						else
							v8 = nil
						end
					end
				end

				if not v8 then
					if priorityTarget == "Closest" then
						table.sort(tbl6, function(arg, arg2)
							return arg.dist < arg2.dist
						end)
					elseif priorityTarget == "Lowest HP" then
						table.sort(tbl6, function(arg, arg2)
							if arg.hp == arg2.hp then
								return arg.dist < arg2.dist
							end
							return arg.hp < arg2.hp
						end)
					elseif priorityTarget == "Augmented First" then
						table.sort(tbl6, function(arg, arg2)
							if arg.rank == arg2.rank then
								return arg.dist < arg2.dist
							end
							return arg.rank > arg2.rank
						end)
					elseif priorityTarget == "Reactor First" then
						local tbl7 = { ReactorDrone = 3, AugmentedDrone = 2, ScrapDrone = 1 }

						table.sort(tbl6, function(arg, arg2)
							local n = tbl7[arg.tier] or 0
							local n2 = tbl7[arg2.tier] or 0
							if n == n2 then
								return arg.dist < arg2.dist
							end
							return n > n2
						end)
					elseif priorityTarget == "Scrap First" then
						table.sort(tbl6, function(arg, arg2)
							if arg.rank == arg2.rank then
								return arg.dist < arg2.dist
							end
							return arg.rank < arg2.rank
						end)
					else
						table.sort(tbl6, function(arg, arg2)
							return arg.dist < arg2.dist
						end)
					end

					v8 = tbl6[1]
				end

				local magnitude = (humanoidRootPart2.Position - v8.pos).Magnitude
				local tier = v8.tier
				local hp = v8.hp
				scrambleManager.CurrentTargetDrone = v8.drone
				scrambleManager.CurrentTargetInfo = string.format("%s (HP: %d) [%.0f studs]", tier, hp, magnitude)
				if modules.Movement and not modules.Movement.Claim("ScrambleDrone", 80) then
					return false
				end

				if treadmill and treadmill.CheckTreadmil and treadmill.CheckTreadmil() then
					if treadmill.Unequip then
						treadmill.Unequip()
					end
				end

				scrambleManager.IsFarmingDrone = true
				local attackDistance = scrambleManager.Config.AttackDistance or 3.5
				local id2 = v8.id
				local now = os.clock()

				while true do
					if enabled["Auto Farm Drones"] and scrambleManager.IsEventActive() then
						local character3 = localPlayer.Character
						local humanoidRootPart3 = character3 and character3:FindFirstChild("HumanoidRootPart")
						local humanoid2 = character3 and character3:FindFirstChildOfClass("Humanoid")

						if not (not humanoidRootPart3 or not humanoid2 or humanoid2.Health <= 0) then
							if not (steal and steal.IsNightOrWallClosed and steal.IsNightOrWallClosed()) then
								if not (scrambleManager.Config.OrchestratorMode == "Steal Idle" and enabled["Auto Steal"] and steal.PickTarget and steal.PickTarget() ~= nil) then
									local v9, v10 = scrambleManager.GetLiveDronePos(id2)

									if v9 then
										local v11 = v9
										local n = (humanoidRootPart3.Position - v11) * Vector3.new(1, 0, 1)
										local vector = n.Magnitude < 0.1 and Vector3.new(0, 0, attackDistance) or n.Unit * attackDistance
										local vector2 = Vector3.new(v11.X + vector.X, v11.Y, v11.Z + vector.Z)
										local magnitude2 = (humanoidRootPart3.Position - vector2).Magnitude
										scrambleManager.CurrentTargetInfo = string.format("%s (HP: %d) [%.0f studs]", tier, v10, magnitude2)

										if magnitude2 > 5.5 then
											_G.LastAction = string.format("Scramble: Approaching %s (%.0fm)", tier, magnitude2)
											scrambleManager.SafeApproach(vector2, scrambleManager.Config.TweenSpeed or 300)
										else
											_G.LastAction = string.format("Scramble: Attacking %s (HP: %d)", tier, v10)

											pcall(function()
												for _, child in ipairs(character3:GetChildren()) do
													if child:IsA("BasePart") then
														child.CanCollide = false
													end
												end

												local vector3 = Vector3.new(humanoidRootPart3.Position.X, v11.Y, humanoidRootPart3.Position.Z)
												local vector4 = Vector3.new(v11.X, vector3.Y, v11.Z)
												humanoidRootPart3.CFrame = (vector4 - vector3).Magnitude > 0.1 and CFrame.lookAt(vector3, vector4) or CFrame.new(vector3)
												humanoidRootPart3.AssemblyLinearVelocity = Vector3.zero
												humanoidRootPart3.AssemblyAngularVelocity = Vector3.zero
											end)

											scrambleManager.SwingBat(character3, humanoid2)
										end

										if os.clock() - now > 12 then
											break
										else
											runService.Heartbeat:Wait()
											continue
										end
									end
								end
							end
						end
					end

					break
				end

				return true
			end

			scrambleManager.Step = function()
				if enabled["Auto Buy Scramble Shop"] and scrambleManager.StepAutoShop then
					scrambleManager.StepAutoShop()
				end

				if enabled["Auto Farm Drones"] then
					scrambleManager.StepDrones()
				end
			end

			local function getOrCreateWorkspaceFolder(name)
				local folder = workspace:FindFirstChild(name)

				if not folder then
					folder = Instance.new("Folder")
					folder.Name = name
					folder.Parent = workspace
				end

				return folder
			end

			scrambleManager.ClearDroneESP = function()
				if scrambleManager.DroneESPFolder then
					pcall(function()
						scrambleManager.DroneESPFolder:ClearAllChildren()
					end)
				end
			end

			scrambleManager.ClearDropsESP = function()
				if scrambleManager.DropsESPFolder then
					pcall(function()
						scrambleManager.DropsESPFolder:ClearAllChildren()
					end)
				end
			end

			scrambleManager.UpdateDroneESP = function()
				if not enabled["ESP Scramble Drones"] then
					scrambleManager.ClearDroneESP()
					return
				end
				scrambleManager.DroneESPFolder = getOrCreateWorkspaceFolder("NoLag_DroneESP")
				local droneESPFolder = scrambleManager.DroneESPFolder
				local v7 = scrambleManager.GetSnapshot()
				if not v7 or not v7.Drones or not v7.Drones.Upserts then
					scrambleManager.ClearDroneESP()
					return
				end
				local character2 = localPlayer.Character
				character2 = character2 and character2:FindFirstChild("HumanoidRootPart")
				character2 = character2 and character2.Position
				local tbl6 = {}

				for _, upsert in ipairs(v7.Drones.Upserts) do
					local n = tonumber(upsert.Health) or 0

					if n > 0 then
						local v8 = parseCFrameValue(upsert.CFrame)

						if v8 then
							local name = tostring(upsert.Id or "DroneESP")
							tbl6[name] = true
							local v9 = normalizeDroneTier(upsert.Attributes and upsert.Attributes.ScrambleTier or "ScrapDrone")
							local magnitude = character2 and (character2 - v8.Position).Magnitude or 0
							local v10 = droneESPFolder:FindFirstChild(name)
							local part, textLabel

							if not v10 then
								part = Instance.new("Part")
								part.Name = name
								part.Anchored = true
								part.CanCollide = false
								part.Transparency = 1
								part.Size = Vector3.new(4, 4, 4)
								local billboardGui = Instance.new("BillboardGui")
								billboardGui.Name = "BB"
								billboardGui.Adornee = part
								billboardGui.Size = UDim2.new(0, 150, 0, 45)
								billboardGui.StudsOffset = Vector3.new(0, 3, 0)
								billboardGui.AlwaysOnTop = true
								billboardGui.Parent = part
								textLabel = Instance.new("TextLabel")
								textLabel.Name = "TL"
								textLabel.Size = UDim2.new(1, 0, 1, 0)
								textLabel.BackgroundTransparency = 1
								textLabel.TextStrokeTransparency = 0
								textLabel.TextScaled = true
								textLabel.Parent = billboardGui
								part.Parent = droneESPFolder
							else
								local bb = v10:FindFirstChild("BB")

								if bb then
									part = v10
									textLabel = bb:FindFirstChild("TL")
								else
									part = v10
									textLabel = bb
								end
							end

							part.CFrame = v8

							if textLabel then
								local color = v9 == "AugmentedDrone" and Color3.fromRGB(255, 60, 60) or v9 == "ReactorDrone" and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(80, 255, 120)

								if textLabel.TextColor3 ~= color then
									textLabel.TextColor3 = color
								end

								textLabel.Text = string.format("%s\nHP: %d | %.0fm", v9, n, magnitude)
							end
						end
					end
				end

				for _, child in ipairs(droneESPFolder:GetChildren()) do
					if not tbl6[child.Name] then
						child:Destroy()
					end
				end
			end

			scrambleManager.UpdateDropsESP = function()
				if not enabled["ESP Scramble Drops"] then
					scrambleManager.ClearDropsESP()
					return
				end
				scrambleManager.DropsESPFolder = getOrCreateWorkspaceFolder("NoLag_DropsESP")
				local dropsESPFolder = scrambleManager.DropsESPFolder
				local v7 = scrambleManager.GetSnapshot()
				if not v7 or not v7.Drops then
					scrambleManager.ClearDropsESP()
					return
				end
				local tbl6 = {}

				for _, drop in ipairs(v7.Drops) do
					local name = tostring(drop.Id or drop.Position and tostring(drop.Position) or "Drop")
					tbl6[name] = true
					local position = drop.Position or drop.Origin

					if position then
						local part = dropsESPFolder:FindFirstChild(name)
						local textLabel

						if not part then
							part = Instance.new("Part")
							part.Name = name
							part.Anchored = true
							part.CanCollide = false
							part.Transparency = 1
							part.Size = Vector3.new(2, 2, 2)
							local billboardGui = Instance.new("BillboardGui")
							billboardGui.Name = "BB"
							billboardGui.Adornee = part
							billboardGui.Size = UDim2.new(0, 100, 0, 30)
							billboardGui.AlwaysOnTop = true
							billboardGui.Parent = part
							textLabel = Instance.new("TextLabel")
							textLabel.Name = "TL"
							textLabel.Size = UDim2.new(1, 0, 1, 0)
							textLabel.BackgroundTransparency = 1
							textLabel.TextStrokeTransparency = 0
							textLabel.TextScaled = true
							textLabel.Parent = billboardGui
							part.Parent = dropsESPFolder
						else
							textLabel = part:FindFirstChild("BB")
							textLabel = textLabel and textLabel:FindFirstChild("TL")
						end

						part.Position = position

						if textLabel then
							if drop.Kind == "Part" then
								local color = Color3.fromRGB(255, 170, 0)

								if textLabel.TextColor3 ~= color then
									textLabel.TextColor3 = color
								end

								textLabel.Text = tostring(drop.PartId or "Part")
							else
								local color = Color3.fromRGB(0, 255, 180)

								if textLabel.TextColor3 ~= color then
									textLabel.TextColor3 = color
								end

								textLabel.Text = "Samples"
							end
						end
					end
				end

				for _, child in ipairs(dropsESPFolder:GetChildren()) do
					if not tbl6[child.Name] then
						child:Destroy()
					end
				end
			end

			scrambleManager.GetTelemetryText = function()
				local v7 = scrambleManager.GetSnapshot()
				if not v7 then
					return "Loading Dr. Scramble Outbreak telemetry..."
				end
				local state = v7.State or {}
				local window = v7.Window or {}
				local serverTimeNow = workspace:GetServerTimeNow()
				local str

				if window.Active == true and window.EndsAt then
					local n = math.max(0, math.ceil(window.EndsAt - serverTimeNow))
					str = string.format("<font color=\"#00FF88\">ACTIVE (Ends in %dm %ds)</font>", n // 60, n % 60)
				elseif window.NextAt then
					local n = math.max(0, math.ceil(window.NextAt - serverTimeNow))
					str = string.format("<font color=\"#FFD83D\">STANDBY (Starts in %dm %ds)</font>", n // 60, n % 60)
				else
					str = "<font color=\"#AAAAAA\">Standby</font>"
				end

				local samples = state.Samples or 0
				local upserts = v7.Drones and v7.Drones.Upserts
				local n = 0
				local n2 = 0
				local n3 = 0
				local n4 = 0

				if upserts then
					for _, upsert in ipairs(v7.Drones.Upserts) do
						if (tonumber(upsert.Health) or 0) > 0 then
							n += 1
							local scrambleTier = upsert.Attributes and upsert.Attributes.ScrambleTier or ""

							if scrambleTier:find("Aug") then
								n3 += 1
							elseif scrambleTier:find("React") then
								n2 += 1
							else
								n4 += 1
							end
						end
					end
				end

				local priorityTarget = scrambleManager.Config.PriorityTarget or "Closest"
				local tbl6 = {}
				local str2 = string.format("<b>Samples Balance:</b> <font color=\"#00FF88\">%s</font>", tostring(samples))
				local str3 = string.format("<b>Event Window:</b> %s", str)
				local str4 = string.format("<b>Active Drones:</b> <font color=\"#6495ED\">%d</font> (Aug: %d, React: %d, Scrap: %d)", n, n3, n2, n4)
				local str5 = string.format("<b>Priority Target:</b> <font color=\"#FFD83D\">%s</font>", tostring(priorityTarget))
				local format = string.format
				local currentTargetInfo = scrambleManager.CurrentTargetInfo or "None"
				local v8 = table.pack(format("<b>Target Drone:</b> %s", currentTargetInfo))
				tbl6[1] = str2
				tbl6[2] = str3
				tbl6[3] = str4
				tbl6[4] = str5

				do
					local values = table.pack(table.unpack(v8, 1, v8.n))
					table.move(values, 1, values.n, 5, tbl6)
				end

				return table.concat(tbl6, "\n")
			end

			scrambleManager.GetShopTelemetryText = function()
				local v7 = scrambleManager.GetSnapshot()
				if not v7 or not v7.Shop then
					return "Loading Shop data..."
				end
				local samples = v7.State and v7.State.Samples or 0
				local tbl6 = {}
				local str = string.format("<b>Available Samples:</b> <font color=\"#00FF88\">%s</font>", tostring(samples))
				local str2 = string.format("<b>Reserve Samples:</b> %s", tostring(scrambleManager.Config.ShopReserve or 0))
				tbl6[1] = str
				tbl6[2] = str2
				tbl6[3] = ""
				tbl6[4] = "<b>Catalog Items:</b>"

				for _, v8 in ipairs(v7.Shop) do
					table.insert(tbl6, string.format("  â¢ <b>%s</b>%s: %s", v8.Label or v8.Id, v8.PurchaseLimit and string.format(" (Limit: %d)", v8.PurchaseLimit) or "", samples >= v8.Price and string.format("<font color=\"#00FF88\">%d Samples</font>", v8.Price) or string.format("<font color=\"#FF5555\">%d Samples</font>", v8.Price)))
				end

				return table.concat(tbl6, "\n")
			end

			task.spawn(function()
				while true do
					if enabled["Auto Farm Drones"] and scrambleManager.IsFarmingDrone then
						pcall(scrambleManager.GetSnapshot, true)
						task.wait(0.2)
						continue
					end

					task.wait(0.5)
				end
			end)

			return scrambleManager
		end

		modules.Scramble = createScrambleModule()

		local function createRiftModule()
			local riftManager = {
				State = nil,
				LastStateFetch = 0,
				LastSacrificeAt = 0,
				LastRerollAt = 0,
				StatusParagraph = nil,
				Config = { DesiredBanners = {} },
				CachedPets = nil,
				LastPetsFetch = 0,
				CachedUnplacedEggs = nil,
				CachedPlacedEggs = nil,
				LastEggsFetch = 0,
				CachedNeededEggCategories = nil,
				LastNeededFetch = 0,
			}

			local function notifyRift(arg, arg2)
				if notifyDeveloper then
					notifyDeveloper(arg2, arg)
				elseif Utils and Utils.Notify then
					Utils.Notify(arg, arg2, 4)
				end
			end

			local tbl6 = {}

			pcall(function()
				local assets = modules.Game and modules.Game.Assets
				local Assets

				if assets then
					Assets = assets
				else
					Assets = replicatedStorage:FindFirstChild("Data") and require(replicatedStorage.Data.Assets)
				end

				local directory = Assets and Assets.Directory or Assets

				if directory then
					for k, v7 in pairs(directory) do
						tbl6[k] = v7
					end
				end
			end)

			local function getRiftRemotes()
				local ReplicatedStorage = game:GetService("ReplicatedStorage")
				local remotes = modules.Game and modules.Game.Remotes or ReplicatedStorage:FindFirstChild("Shared") and ReplicatedStorage.Shared:FindFirstChild("Remotes") and require(ReplicatedStorage.Shared.Remotes)
				if remotes and remotes.Rift then
					return remotes.Rift
				end
				local networking = ReplicatedStorage:FindFirstChild("Packages") and ReplicatedStorage.Packages:FindFirstChild("Networking")

				if networking then
					return {
						AskState = networking:FindFirstChild("RF/Rift/AskState"),
						AskTradeIn = networking:FindFirstChild("RF/Rift/AskTradeIn"),
						AskRefresh = networking:FindFirstChild("RF/Rift/AskRefresh"),
						AskFinishReveal = networking:FindFirstChild("RF/Rift/AskFinishReveal"),
						BannerRotated = networking:FindFirstChild("RE/Rift/BannerRotated"),
					}
				end

				return nil
			end

			riftManager.GetState = function(arg)
				local now = os.clock()
				if not arg and riftManager.State and now - riftManager.LastStateFetch < 2 then
					return riftManager.State
				end
				local v7 = getRiftRemotes()

				if v7 and v7.AskState then
					local ok, state = pcall(function()
						return v7.AskState:InvokeServer()
					end)

					if ok and type(state) == "table" then
						riftManager.State = state
						riftManager.LastStateFetch = now
						return state
					end
				end

				return riftManager.State
			end

			riftManager.IsUnlocked = function()
				local v7 = riftManager.GetState()
				return v7 and v7.Unlocked == true
			end

			riftManager.IsBannerDesired = function()
				local desiredBanners = riftManager.Config and riftManager.Config.DesiredBanners or cached and cached.Settings and cached.Settings.DesiredRiftBanners or {}
				if not desiredBanners or #desiredBanners == 0 then
					return true
				end
				local v7 = riftManager.GetState()
				if not v7 then
					return false
				end
				local str = tostring(v7.BannerId or ""):lower()
				local str2 = tostring(v7.BannerDisplayName or ""):lower()

				for _, desiredBanner in ipairs(desiredBanners) do
					local str3 = tostring(desiredBanner):lower()
					if str3 == str or str3 == str2 or str ~= "" and str3:find(str, 1, true) or str2 ~= "" and str3:find(str2, 1, true) then
						return true
					end
				end

				return false
			end

			riftManager.InvalidateCache = function()
				riftManager.CachedPets = nil
				riftManager.LastPetsFetch = 0
				riftManager.CachedUnplacedEggs = nil
				riftManager.CachedPlacedEggs = nil
				riftManager.LastEggsFetch = 0
				riftManager.CachedNeededEggCategories = nil
				riftManager.LastNeededFetch = 0
			end

			local function getRiftSaveData()
				local getSave = modules.Game and modules.Game.GetSave and modules.Game.GetSave()

				if not getSave then
					pcall(function()
						local Save = require(game:GetService("ReplicatedStorage").Shared.Save)

						if Save and Save.Get then
							getSave = Save.Get() or Save.Peek and Save.Peek() or {}
						end
					end)
				end

				if getSave and type(getSave) == "table" then
					return getSave.Data or getSave
				end
				return {}
			end

			riftManager.GetAllInventoryPets = function(arg)
				local now = os.clock()
				if not arg and riftManager.CachedPets and now - riftManager.LastPetsFetch < 0.75 then
					return riftManager.CachedPets
				end
				local v7 = getRiftSaveData()
				local cachedPets = {}
				local tbl7 = {}

				if v7 then
					local equippedAssets = v7.EquippedAssets or v7.EquippedPets or {}

					for _, equippedAsset in pairs(equippedAssets) do
						if type(equippedAsset) == "string" then
							tbl7[equippedAsset] = true
						elseif type(equippedAsset) == "table" and (equippedAsset.UID or equippedAsset.Uid or equippedAsset.Id) then
							tbl7[equippedAsset.UID or equippedAsset.Uid or equippedAsset.Id] = true
						end
					end

					local AssetItems = nil

					pcall(function()
						AssetItems = require(game:GetService("ReplicatedStorage").Shared.Util.AssetItems)
					end)

					local inventory = v7.Inventory or v7.Slots or v7.Pets or {}

					for k, v8 in pairs(inventory) do
						if AssetItems and AssetItems.Decode and (type(v8) == "string" or type(v8) == "table" and not v8.Category) then
							local ok, result = pcall(AssetItems.Decode, v8)

							if ok and result then
								v8 = result
							end
						end

						if type(v8) == "table" then
							local str = tostring(v8.Category or v8.DisplayName or "")

							table.insert(cachedPets, {
								Uid = k,
								Category = str,
								DisplayName = tostring(v8.DisplayName or str),
								Weight = tonumber(v8.Weight) or 0,
								Scale = tonumber(v8.Scale) or 1,
								Favorite = v8.Favorite == true or v8.IsFavorite == true,
								Equipped = tbl7[k] == true,
								InFuse = v8.InFuse == true,
								Source = "Save",
							})
						end
					end
				end

				local function collectPetTool(arg2)
					if not (arg2 and arg2:IsA("Tool")) then
						return
					end
					local attribute = arg2:GetAttribute("UID")
					local attribute2 = arg2:GetAttribute("Category") or arg2:GetAttribute("DisplayName")

					if attribute and attribute2 then
						local flag = false

						for _, cachedPet in ipairs(cachedPets) do
							if cachedPet.Uid == attribute then
								flag = true
								break
							end
						end

						if not flag then
							table.insert(cachedPets, {
								Uid = attribute,
								Category = tostring(attribute2),
								DisplayName = tostring(arg2:GetAttribute("DisplayName") or attribute2),
								Weight = tonumber(arg2:GetAttribute("Weight")) or 0,
								Scale = tonumber(arg2:GetAttribute("Scale")) or 1,
								Favorite = arg2:GetAttribute("Favorite") == true,
								Equipped = tbl7[attribute] == true,
								InFuse = false,
								Source = "Tool",
							})
						end
					end
				end

				local localPlayer2 = localPlayer or players.LocalPlayer

				if localPlayer2 and localPlayer2.Character then
					for _, child in ipairs(localPlayer2.Character:GetChildren()) do
						collectPetTool(child)
					end
				end

				if localPlayer2 and localPlayer2:FindFirstChild("Backpack") then
					for _, child in ipairs(localPlayer2.Backpack:GetChildren()) do
						collectPetTool(child)
					end
				end

				riftManager.CachedPets = cachedPets
				riftManager.LastPetsFetch = now
				return cachedPets
			end

			riftManager.GetAllEggs = function(arg)
				local now = os.clock()
				if not arg and riftManager.CachedUnplacedEggs and now - riftManager.LastEggsFetch < 0.75 then
					return riftManager.CachedUnplacedEggs, riftManager.CachedPlacedEggs
				end
				local v7 = getRiftSaveData()
				local cachedUnplacedEggs = {}
				local cachedPlacedEggs = {}

				if v7 and v7.EggInventory then
					for k, v8 in pairs(v7.EggInventory) do
						if type(v8) == "table" and v8.AssetCategory then
							local str = tostring(v8.AssetCategory)

							if v8.Placement then
								table.insert(cachedPlacedEggs, { Uid = k, Category = str })
							else
								table.insert(cachedUnplacedEggs, { Uid = k, Category = str })
							end
						end
					end
				end

				local localPlayer2 = localPlayer or players.LocalPlayer

				if localPlayer2 and localPlayer2:FindFirstChild("Backpack") then
					for _, child in ipairs(localPlayer2.Backpack:GetChildren()) do
						if child:IsA("Tool") and child:GetAttribute("AssetCategory") then
							local attribute = child:GetAttribute("UID") or child.Name
							local str = tostring(child:GetAttribute("AssetCategory"))
							local flag = false

							for _, cachedUnplacedEgg in ipairs(cachedUnplacedEggs) do
								if cachedUnplacedEgg.Uid == attribute then
									flag = true
									break
								end
							end

							if not flag then
								table.insert(cachedUnplacedEggs, { Uid = attribute, Category = str })
							end
						end
					end
				end

				riftManager.CachedUnplacedEggs = cachedUnplacedEggs
				riftManager.CachedPlacedEggs = cachedPlacedEggs
				riftManager.LastEggsFetch = now
				return cachedUnplacedEggs, cachedPlacedEggs
			end

			riftManager.GetMissingRequirements = function()
				local v7 = riftManager.GetState()
				if not v7 or not v7.Requirements then
					return {}
				end
				local tbl7 = {}
				local v8 = riftManager.GetAllInventoryPets()

				for _, requirement in ipairs(v7.Requirements) do
					local str = tostring(type(requirement) == "table" and (requirement.Category or requirement.Id or requirement.Name) or requirement)
					local flag = false

					for _, v9 in ipairs(v8) do
						if (v9.Category == str or v9.DisplayName == str) and not v9.Favorite and not v9.Equipped and not v9.InFuse then
							flag = true
							break
						end
					end

					if not flag then
						tbl7[str] = true
					end
				end

				return tbl7
			end

			riftManager.GetNeededRecipeEggCategories = function(arg)
				local now = os.clock()
				if not arg and riftManager.CachedNeededEggCategories and now - riftManager.LastNeededFetch < 0.5 then
					return riftManager.CachedNeededEggCategories
				end
				local v7 = riftManager.GetState()
				if not v7 or not v7.Requirements then
					return {}
				end
				local tbl7 = {}

				for _, requirement in ipairs(v7.Requirements) do
					local str = tostring(type(requirement) == "table" and (requirement.Category or requirement.Id or requirement.Name) or requirement)
					tbl7[str] = (tbl7[str] or 0) + 1
				end

				local getAllInventoryPets = riftManager.GetAllInventoryPets and riftManager.GetAllInventoryPets() or {}

				for _, getAllInventoryPet in ipairs(getAllInventoryPets) do
					local category = getAllInventoryPet.Category or getAllInventoryPet.DisplayName

					if category and tbl7[category] and tbl7[category] > 0 then
						if not getAllInventoryPet.Favorite and not getAllInventoryPet.Equipped and not getAllInventoryPet.InFuse then
							tbl7[category] = tbl7[category] - 1
						end
					end
				end

				local tbl8 = {}
				local tbl9 = {}

				if riftManager.GetAllEggs then
					tbl8, tbl9 = riftManager.GetAllEggs()
				end

				local v8 = ipairs
				tbl8 = tbl8 or {}

				for _, v9 in v8(tbl8) do
					local category = v9.Category

					if category and tbl7[category] and tbl7[category] > 0 then
						tbl7[category] = tbl7[category] - 1
					end
				end

				local v9 = ipairs
				tbl9 = tbl9 or {}

				for _, v10 in v9(tbl9) do
					local category = v10.Category

					if category and tbl7[category] and tbl7[category] > 0 then
						tbl7[category] = tbl7[category] - 1
					end
				end

				pcall(function()
					local character2 = localPlayer and localPlayer.Character

					if character2 then
						for _, child in ipairs(character2:GetChildren()) do
							if child:IsA("Tool") and child:GetAttribute("AssetCategory") then
								local str = tostring(child:GetAttribute("AssetCategory"))

								if tbl7[str] and tbl7[str] > 0 then
									tbl7[str] = tbl7[str] - 1
								end
							end
						end
					end
				end)

				local cachedNeededEggCategories = {}

				for k, v10 in pairs(tbl7) do
					if v10 > 0 then
						cachedNeededEggCategories[k] = v10
					end
				end

				riftManager.CachedNeededEggCategories = cachedNeededEggCategories
				riftManager.LastNeededFetch = now
				return cachedNeededEggCategories
			end

			riftManager.FindEligiblePetsForRecipe = function(arg)
				if not arg or #arg == 0 then
					return nil
				end
				local v7 = riftManager.GetAllInventoryPets()
				local tbl7 = {}
				local tbl8 = {}

				for _, v8 in ipairs(arg) do
					local v9 = tostring
					v8 = type(v8) == "table" and (v8.Category or v8.Id or v8.Name) or v8
					local v10 = v9(v8)
					local huge = math.huge
					local v11 = nil

					for _, v12 in ipairs(v7) do
						if not tbl7[v12.Uid] and not v12.Equipped and not v12.Favorite and not v12.InFuse then
							if v12.Category == v10 or v12.DisplayName == v10 then
								local n = tonumber(v12.Weight) or 0

								if n < huge then
									huge = n
									v11 = v12
								end
							end
						end
					end

					if v11 then
						tbl7[v11.Uid] = true
						table.insert(tbl8, v11.Uid)
						continue
					end

					return nil
				end

				return #tbl8 == #arg and tbl8 or nil
			end

			riftManager.StepSacrifice = function(arg)
				local flag = not arg
				if flag and not enabled["Auto Rift Sacrifice"] then
					return
				end

				if flag and riftManager.IsBannerDesired and not riftManager.IsBannerDesired() then
					return
				end
				local now = os.clock()
				if flag and now - riftManager.LastSacrificeAt < 2 then
					return
				end
				riftManager.LastSacrificeAt = now
				local v7 = riftManager.GetState(arg)
				if not v7 then
					return
				end
				local requirements = v7.Requirements or {}
				if #requirements == 0 then
					return
				end
				local v8 = riftManager.FindEligiblePetsForRecipe(requirements)

				if v8 and #v8 == #requirements then
					local v9 = getRiftRemotes()

					if v9 and v9.AskTradeIn then
						_G.LastAction = "Rift: Trading in sacrifice pets..."

						local ok, result = pcall(function()
							return v9.AskTradeIn:InvokeServer(v8)
						end)

						if ok and result == true then
							task.wait(0.3)

							if v9.AskFinishReveal then
								pcall(function()
									v9.AskFinishReveal:InvokeServer()
								end)
							end

							riftManager.GetState(true)
							riftManager.InvalidateCache()
							notifyRift("The Rift", "Trade-In successful! Rift Egg received.")
							_G.LastAction = "Rift: Sacrifice Successful! Egg received."
							return true
						end
					end
				end
			end

			riftManager.StepReroll = function(arg)
				local flag = not arg
				if flag and not enabled["Auto Reroll Rift Recipe"] then
					return
				end

				if flag and riftManager.IsBannerDesired and not riftManager.IsBannerDesired() then
					return
				end
				local now = os.clock()
				if flag and now - riftManager.LastRerollAt < 2.5 then
					return
				end
				riftManager.LastRerollAt = now
				local v7 = riftManager.GetState()
				local flag2 = not v7
				local flag3

				if flag2 then
					flag3 = flag2
				else
					flag3 = (v7.FreeRefreshesRemaining or 0) <= 0
				end

				if flag3 then
					return
				end
				local v8 = riftManager.FindEligiblePetsForRecipe(v7.Requirements or {})

				if arg or not v8 then
					local v9 = getRiftRemotes()

					if v9 and v9.AskRefresh then
						_G.LastAction = "Rift: Rerolling sacrifice recipe..."

						local ok, result = pcall(function()
							return v9.AskRefresh:InvokeServer()
						end)

						if ok and result == true then
							task.wait(0.4)
							riftManager.GetState(true)
							riftManager.InvalidateCache()
							local v10 = riftManager.GetState()
							notifyRift("The Rift", string.format("Recipe rerolled! (%d free refreshes left)", v10 and v10.FreeRefreshesRemaining or 0))
							return true
						end
					end
				end
			end

			riftManager.Step = function()
				if enabled["Auto Rift Sacrifice"] then
					if riftManager.StepSacrifice() then
						return
					end
				end

				if enabled["Auto Reroll Rift Recipe"] then
					riftManager.StepReroll()
				end
			end

			riftManager.GetTelemetryText = function()
				local v7 = riftManager.GetState()
				if not v7 then
					return "Loading The Rift telemetry..."
				end
				local bannerDisplayName = v7.BannerDisplayName or v7.BannerId or "Unknown"
				local bannerId = v7.BannerId or ""
				local n = tonumber(v7.SecondsUntilRotation) or 0
				local str = n > 0 and string.format("%dm %ds", math.floor(n / 60), math.floor(n % 60)) or "Rotating soon..."
				local freeRefreshesRemaining = v7.FreeRefreshesRemaining or 0
				local str2 = string.format("%d / %d", v7.PityCount or 0, v7.PityThreshold or 50)
				local requirements = v7.Requirements or {}
				local str3 = riftManager.FindEligiblePetsForRecipe(requirements)
				local v8 = riftManager.GetAllInventoryPets()
				local v9, v10 = riftManager.GetAllEggs()
				local tbl7 = {}

				for _, requirement in ipairs(requirements) do
					local str4 = tostring(type(requirement) == "table" and (requirement.Category or requirement.Id or requirement.Name) or requirement)
					local n2 = 0
					local n3 = 0

					for _, v11 in ipairs(v8) do
						if v11.Category == str4 or v11.DisplayName == str4 then
							if v11.Favorite or v11.Equipped or v11.InFuse then
								n2 += 1
							else
								n3 += 1
							end
						end
					end

					local n4 = 0

					for _, v11 in ipairs(v9) do
						if v11.Category == str4 then
							n4 += 1
						end
					end

					local n5 = 0

					for _, v11 in ipairs(v10) do
						if v11.Category == str4 then
							n5 += 1
						end
					end

					local str5, str6

					if n3 > 0 then
						str5 = string.format("(Ready: %d Pet)", n3)
						str6 = "#00FF88"
					elseif n5 > 0 then
						str5 = string.format("(%d Egg in Pen - Growing)", n5)
						str6 = "#FFD83D"
					elseif n4 > 0 then
						str5 = string.format("(%d Egg in Inventory - Needs Hatch)", n4)
						str6 = "#00E5FF"
					else
						str6 = "#FF5555"
						str5 = "(Missing)"

						if n2 > 0 then
							str6 = "#FFAA00"
							str5 = string.format("(%d Pet Favorited/Equipped)", n2)
						end
					end

					table.insert(tbl7, string.format("  â¢ %s: <font color=\"%s\"><b>%s</b></font>", str4, str6, str5))
				end

				local flag = true

				if riftManager.IsBannerDesired then
					flag = riftManager.IsBannerDesired()
				end

				local desiredBanners = riftManager.Config and riftManager.Config.DesiredBanners or cached and cached.Settings and cached.Settings.DesiredRiftBanners or {}
				local str4 = ""

				if #desiredBanners > 0 then
					if flag then
						str4 = " <font color=\"#00FF88\">[DESIRED]</font>"
					else
						str4 = " <font color=\"#FF5555\">[NOT DESIRED - IDLE]</font>"
					end
				end

				str3 = str3 and "<font color=\"#00FF88\"><b>READY TO TRADE-IN! (All Pets Ready)</b></font>" or "<font color=\"#FFD83D\">Collecting / Hatching Recipe Pets...</font>"

				if not flag and #desiredBanners > 0 then
					str3 = "<font color=\"#FFAA00\">Suspended (Banner not in Desired Banners)</font>"
				end

				local tbl8 = {}
				local str5 = string.format("<b> Banner:</b> <font color=\"#6495ED\">%s</font> [%s]%s", bannerDisplayName, bannerId, str4)
				local str6 = string.format("<b> Banner Rotation:</b> %s", str)
				local str7 = string.format("<b> Pity Progress:</b> <font color=\"#FFD83D\">%s</font>", str2)
				local str8 = string.format("<b> Free Rerolls Left:</b> <font color=\"#00FF88\">%d</font>", freeRefreshesRemaining)
				local str9 = string.format("<b> Status:</b> %s", str3)
				tbl8[1] = str5
				tbl8[2] = str6
				tbl8[3] = str7
				tbl8[4] = str8
				tbl8[5] = str9
				tbl8[6] = "<b> Current Recipe Requirements:</b>"

				for _, v11 in ipairs(tbl7) do
					table.insert(tbl8, v11)
				end

				return table.concat(tbl8, "\n")
			end

			return riftManager
		end

		modules.Rift = createRiftModule()
		return modules
	end

	module.Modules = createModules()
	local controller = {}
	local modules = module.Modules
	local utils = modules.Utils
	local misc = modules.Misc
	local game_ = modules.Game
	local movement = modules.Movement
	local farmState = modules.FarmState
	local farmState2 = modules.FarmState
	local steal = modules.Steal
	local placeEgg = modules.PlaceEgg
	local treadmill = modules.Treadmill
	local hatch = modules.Hatch
	local equip = modules.Equip
	local favorite = modules.Favorite
	local fuse = modules.Fuse
	local sell = modules.Sell
	local rebirth = modules.Rebirth
	local upgrade = modules.Upgrade
	local claim = modules.Claim
	local esp = modules.ESP
	local webhookManager = modules.WebhookManager
	local petPredictor = modules.PetPredictor
	local fusePredictor = modules.FusePredictor
	local trail = modules.Trail
	local scramble = modules.Scramble
	local rift = modules.Rift

	local function createOrchestrator()
		return {
			LastPhysicalTick = 0,
			Tick = function()
				local debugInspector = modules.DebugInspector

				if enabled["Auto Pick Dropped Egg"] and steal.AutoPickWasCarrying and not enabled["Auto Steal"] then
					if not (steal.IsNightWallClosed and steal.IsNightWallClosed()) then
						if debugInspector then
							debugInspector.SetState("AUTO_PICK", "Recovering Dropped Egg (Night)", "AutoPick")
						end

						return
					end
				end

				if steal.IsNightOrWallClosed and steal.IsNightOrWallClosed() then
					steal.WasNightOrClosed = true
					steal.IsStealing = false
					steal.GotEgg = false

					if farmState2 then
						farmState2.Carrying = false
						farmState2.CarriedUid = nil
						farmState2.CarriedAssetCategory = nil
						farmState2.OptimisticCarry = false
					end

					movement.Release("Steal")
					steal.StopRunAnimation()

					if treadmill and treadmill.CheckTreadmil and treadmill.CheckTreadmil() then
						if treadmill.Unequip then
							treadmill.Unequip()
						end
					end

					local getSafeZone = steal.GetSafeZone and steal.GetSafeZone()
					local character2 = localPlayer.Character
					character2 = character2 and character2:FindFirstChild("HumanoidRootPart")

					if (character2 and getSafeZone and (character2.Position - getSafeZone).Magnitude or 999) > 30 then
						if debugInspector then
							debugInspector.SetState("EMERGENCY_SAFEZONE", "Night / Barrier Evacuation", "SafeZone")
						end

						steal.GoToSafeZone(300, "SafeZone")
					elseif debugInspector then
						debugInspector.SetState("SAFEZONE_STANDBY", "Night SafeZone Standby", "SafeZone")
					end

					return
				end

				if enabled["Auto Farm Drones"] and scramble and scramble.CanRun and scramble.CanRun() then
					if debugInspector then
						debugInspector.SetState("SCRAMBLE_EVENT", "Dr. Scramble Event", scramble.CurrentTargetInfo or "Drone")
					end

					scramble.Step()
					return
				end

				if scramble and enabled["Auto Buy Scramble Shop"] and scramble.StepAutoShop then
					scramble.StepAutoShop()
				end

				if rift and (enabled["Auto Rift Sacrifice"] or enabled["Auto Reroll Rift Recipe"]) and rift.Step then
					rift.Step()
				end

				if enabled["Auto Steal"] then
					local v7, v8 = farmState2.GetCarryState()

					if v7 or steal.IsStealing then
						steal.MarkWork()

						if debugInspector then
							debugInspector.SetState("STEALING", "Carrying Egg to SafeZone", tostring(v8 or "Egg"))
						end

						steal.Step()
						return
					end

					local v9 = steal.PickTarget()

					if v9 ~= nil then
						steal.MarkWork()

						if debugInspector then
							debugInspector.SetState("STEALING", "Moving to Egg Nest", steal.GetEggFormattedName(v9))
						end

						steal.Step()
						return
					end

					local character2 = localPlayer.Character
					local humanoid2 = character2 and character2:FindFirstChildOfClass("Humanoid")

					if humanoid2 and character2:FindFirstChildOfClass("Tool") then
						pcall(function()
							humanoid2:UnequipTools()
						end)
					end
				end

				if enabled["Auto Place Egg"] and placeEgg.ShouldRunNow and placeEgg.ShouldRunNow() then
					if debugInspector then
						debugInspector.SetState("PLACE_EGG", "Placing Eggs into Pen", "Plot Pen")
					end

					placeEgg.Step()
					return
				end

				if sell and sell.CanSell and sell.CanSell() then
					if (enabled["Auto Sell Pet"] or enabled["Auto Sell Egg"]) and sell.Step then
						sell.Step()
					end
				end

				if enabled["Auto Treadmill"] then
					if treadmill.CanRun and treadmill.CanRun() then
						if not (treadmill.CheckTreadmil and treadmill.CheckTreadmil()) and debugInspector then
							debugInspector.SetState("TREADMILL", "Training on Treadmill", "Treadmill")
						end

						treadmill.Step()
						return
					end
				end

				if debugInspector then
					debugInspector.SetState("IDLE_STANDBY", "Idle Standby", "None")
				end

				if steal.IsNightOrWallClosed and steal.IsNightOrWallClosed() then
					local getSafeZone = steal.GetSafeZone and steal.GetSafeZone()
					local character2 = localPlayer.Character
					local humanoidRootPart2 = character2 and character2:FindFirstChild("HumanoidRootPart")

					if humanoidRootPart2 and getSafeZone and (humanoidRootPart2.Position - getSafeZone).Magnitude > 15 then
						steal.GoToSafeZone(300, "SafeZone")
					end
				end
			end,
		}
	end

	modules.Orchestrator = createOrchestrator()
	local orchestrator = modules.Orchestrator

	controller.LoadLibrary = function()
		local v7 = shx:CreateWindow({
			Title = "Speed Hub X | Steal An Egg 1.2.2 | discord.gg/speedhubx",
			Description = "",
			["Tab Width"] = 130,
			SaveSystem = { Enable = true, File = "StealAnEgg" },
			Security = { Asset = true, NoVim = false, NoIcon = false },
			Key = "KZgN0t5pK6hBaqVLAMLg27aqXNDb8v",
			Key1 = "c9RkyXAjNpJc9u1fexvw1cbxYTWvMy",
			Key2 = "Xp8712WzbaRn8EtrLnXk8gDdzQB8jF",
			Key3 = "wixUQtibEtmkTQ7WpSFGq4YfBuqJQy",
			Key4 = "KbSf6UWZ6vndbgp8Vh9EHdM0dU8DFf",
			Key5 = "mP3tTRKYwhNKLkpFCdVuj922xqTgJp",
			Key6 = "heMGEmHXFUaiTaStAihwTfwgSJguUwQQxdE",
			Key7 = "khEXYXSHSJpDabFqudKJWEWbEyzXYgLmgTF",
			Key8 = "MLGkWCxxHaqhumMpSmpvJMuiUEpeqUAYvxN",
		})

		local tbl5 = {
			Home = v7:CreateTab({ Name = "Home", Icon = "rbxassetid://10734942198" }),
			Farm = v7:CreateTab({ Name = "Farm", Icon = "rbxassetid://10723345518" }),
			Progression = v7:CreateTab({ Name = "Progress", Icon = "rbxassetid://10734961809" }),
			Predictor = v7:CreateTab({ Name = "Predictor", Icon = "rbxassetid://10723415903" }),
			ESP = v7:CreateTab({ Name = "ESP", Icon = "rbxassetid://10747373176" }),
			Miscellaneous = v7:CreateTab({ Name = "Misc", Icon = "rbxassetid://11447063791" }),
			Settings = v7:CreateTab({ Name = "Settings", Icon = "rbxassetid://10734950309" }),
		}

		funcs:Button(tbl5.Home:AddSection("Discord", true), "Discord Invite", "Copy invite link", function()
			setclipboard("https://discord.gg/speedhubx")
		end)

		local v8 = tbl5.Predictor:AddSection("Pet Predictor")
		petPredictor.Paragraph = v8:AddParagraph({ "Pet Predictor", "Loading pet predictions..." })

		funcs:Dropdown(v8, "Egg Scope", "Select which eggs to inspect", false, { "Placed Eggs (In Pen)", "All Eggs (Inc. Inventory)" }, { "Placed Eggs (In Pen)" }, true, function(arg)
			petPredictor.ShowOnlyPlaced = arg == "Placed Eggs (In Pen)"
			petPredictor.UpdateParagraph()
		end)

		funcs:Dropdown(v8, "Sort Pets By", "Sort order for predicted pet list", false, { "Income (Highest)", "Rarity (Highest)", "Time (Ready Soon)" }, { "Income (Highest)" }, true, function(arg)
			if arg == "Income (Highest)" then
				petPredictor.SortMode = "Income"
			elseif arg == "Rarity (Highest)" then
				petPredictor.SortMode = "Rarity"
			elseif arg == "Time (Ready Soon)" then
				petPredictor.SortMode = "Time"
			end

			petPredictor.UpdateParagraph()
		end)

		funcs:Button(v8, "Refresh Pets", "Recalculate pet predictions & growth timers now", function()
			petPredictor.UpdateParagraph()
			notifyDeveloper("Pet predictions refreshed!", "Pet Predictor")
		end)

		task.spawn(function()
			task.wait(2.5)
			petPredictor.UpdateParagraph()
		end)

		local v9 = tbl5.Predictor:AddSection("Fuse Predictor")
		fusePredictor.Paragraph = v9:AddParagraph({ "Fuse Predictor", "Detecting fuse machine status..." })

		funcs:Button(v9, "Refresh Fuse Predictor", "Recalculate fuse machine odds & countdown now", function()
			fusePredictor.UpdateParagraph()
			notifyDeveloper("Fuse predictor updated!", "Fuse Predictor")
		end)

		task.spawn(function()
			task.wait(3)
			fusePredictor.UpdateParagraph()
		end)

		local v10 = tbl5.Farm:AddSection("Automation Steal")
		v10:AddSeperator({ " - [ Master Switch ] - " })

		funcs:Toggle(v10, "Auto Steal", "Automatically steal eggs from areas", false, true, function(arg)
			enabled["Auto Steal"] = arg

			if not arg then
				steal.StopSpam()
				steal.StopRunAnimation()
				steal.IsStealing = false
				steal.GotEgg = false
				farmState.State = "Idle"
				farmState.TargetUid = nil
				farmState.Carrying = false
				farmState.CarriedUid = nil
				farmState.CarriedAssetCategory = nil
				farmState.OptimisticCarry = false
				movement.Release("Steal")
			end
		end)

		v10:AddSeperator({ " - [ Target & Filter Config ] - " })
		local tbl6 = {}

		if game_.Init() then
			local v11 = game_.GetAreas()

			for _, v12 in ipairs(v11) do
				table.insert(tbl6, v12)
			end
		else
			tbl6 = {
				"Forest",
				"Lake",
				"Desert",
				"Jungle",
				"Snow",
				"Volcano",
				"Abyss Ocean",
				"Prehistoric",
				"Cosmic",
			}
		end

		funcs:Dropdown(v10, "Target Areas", "Select one or multiple areas (empty = all)", true, tbl6, {}, true, function(areaFilters)
			steal.AreaFilters = areaFilters
		end)

		funcs:Dropdown(v10, "Min Rarity", "Only steal eggs with rarity >= this", false, {
			"All",
			"1 - Common",
			"2 - Uncommon",
			"3 - Rare",
			"4 - Epic",
			"5 - Legendary",
			"6 - Mythic",
			"7 - Cosmic",
			"8 - Secret",
			"9 - Eternal",
			"10 - Divine",
			"11 - Titan",
			"12 - Light & Dark",
		}, { "7 - Cosmic" }, true, function(arg)
			steal.MinRarity = steal.ParseRarity(arg)
		end)

		local tbl7 = {}

		pcall(function()
			local ok, result = pcall(require, replicatedStorage.Data.Assets)

			if not (ok and result) then
				local ok2
				ok2, result = pcall(require, replicatedStorage.Directory.Assets)

				if not (ok2 and result) then
					result = modules.Game and modules.Game.Assets
				end
			end

			local directory = result and result.Directory or type(result) == "table" and result or {}

			if next(directory) then
				local tbl8 = {}

				for k, v11 in pairs(directory) do
					if type(v11) == "table" then
						local rarity = v11.Rarity
						local displayName

						if rarity then
							displayName = rarity.DisplayName or rarity.Name
						else
							displayName = rarity
						end

						displayName = displayName or "Common"
						local rarityNumber = rarity and rarity.RarityNumber or 1

						table.insert(tbl8, {
							formatted = string.format("%s [%s]", v11.DisplayName or v11.Name or k, displayName),
							rNum = rarityNumber,
							name = v11.DisplayName or v11.Name or k,
						})
					end
				end

				table.sort(tbl8, function(arg, arg2)
					if arg.rNum == arg2.rNum then
						return arg.name < arg2.name
					end
					return arg.rNum < arg2.rNum
				end)

				for _, v11 in ipairs(tbl8) do
					table.insert(tbl7, v11.formatted)
				end
			end
		end)

		if #tbl7 == 0 then
			tbl7 = {
				"Chicken [Common]",
				"Dog [Common]",
				"Duckling [Common]",
				"Frog [Common]",
				"Jerboa [Common]",
				"Bird [Uncommon]",
				"Catfish [Uncommon]",
				"Fennec [Uncommon]",
				"Burrowing Owl [Rare]",
				"Camel [Rare]",
				"Chimpanzee [Rare]",
				"Dodo [Rare]",
				"Lava Gecko [Rare]",
				"Parrotfish [Rare]",
				"Penguin [Rare]",
				"Raccoon [Rare]",
				"Toucan [Rare]",
				"Tung Tung Sahur [Rare]",
				"Turtle [Rare]",
				"Bananita Dolphinita [Epic]",
				"Bear [Epic]",
				"Centapede [Epic]",
				"Crane [Epic]",
				"Crocodile [Epic]",
				"Fox [Epic]",
				"Lava frog [Epic]",
				"Swan [Epic]",
				"Swordfish [Epic]",
				"Tob Tobi Tob Tob [Epic]",
				"Trulimero Trulicina [Epic]",
				"Walrus [Epic]",
				"Axolotl [Legendary]",
				"Baby Aurora Dragon [Legendary]",
				"Brr Brr Patapim [Legendary]",
				"Cosmic Gecko [Legendary]",
				"Crustacia [Legendary]",
				"Flaming Bull [Legendary]",
				"Gorilla [Legendary]",
				"Lava Iguana [Legendary]",
				"Mecha Scorpio [Legendary]",
				"Orangutini Ananassini [Legendary]",
				"Polar Bear [Legendary]",
				"Pterodactyl [Legendary]",
				"Salamander [Legendary]",
				"Scorpio [Legendary]",
				"Shark [Legendary]",
				"Snake [Legendary]",
				"Spideron [Legendary]",
				"Ankylosaurus [Mythic]",
				"Belula Beluga [Mythic]",
				"Bladehide [Mythic]",
				"Chillin Chilli [Mythic]",
				"Cosmic Gorilla [Mythic]",
				"Froggo [Mythic]",
				"Mammoth [Mythic]",
				"Mecha Froggo [Mythic]",
				"Orca [Mythic]",
				"Red Panda [Mythic]",
				"Sabertooth Tiger [Mythic]",
				"Sand Spider [Mythic]",
				"Scorpion [Mythic]",
				"Shadow Dragon [Mythic]",
				"Spider [Mythic]",
				"Tiger [Mythic]",
				"Beluga Whale [Cosmic]",
				"Bronto [Cosmic]",
				"Crawler [Cosmic]",
				"Demon Imp [Cosmic]",
				"Drilla [Cosmic]",
				"Hellhound [Cosmic]",
				"King Mammoth [Cosmic]",
				"Koi [Cosmic]",
				"La Vacca Saturno Saturnita [Cosmic]",
				"Leviathan [Cosmic]",
				"Mangolini Parrochini [Cosmic]",
				"Mantaris [Cosmic]",
				"Mecha Crawler [Cosmic]",
				"Rhinotaur [Cosmic]",
				"Royal Sphinx [Cosmic]",
				"Snowy Owl [Cosmic]",
				"Triceratops [Cosmic]",
				"Whale Shark [Cosmic]",
				"Bombo Croco [Secret]",
				"Cerberus [Secret]",
				"Cosmic Dragon [Secret]",
				"Cosmic Skeleton Boss [Secret]",
				"Crocodon [Secret]",
				"Ember Dragon [Secret]",
				"Gargoyle [Secret]",
				"King Snake [Secret]",
				"Kraken [Secret]",
				"Mecha Crocodon [Secret]",
				"Minotaur [Secret]",
				"Mutant Shark [Secret]",
				"Scorched Dragon [Secret]",
				"Stag [Secret]",
				"TRex [Secret]",
				"Tralaledon [Secret]",
				"Yeti [Secret]",
				"Balrog [Eternal]",
				"El Maja [Eternal]",
				"Eternal Lunar Dragon [Eternal]",
				"Gorilla King [Eternal]",
				"Ice Dragon [Eternal]",
				"Krakenoid [Eternal]",
				"Lava Dragon [Eternal]",
				"Mecha Krakenoid [Eternal]",
				"Mosasaurus [Eternal]",
				"Oni Tiger [Eternal]",
				"Phoenix [Eternal]",
				"Strawberry Elephant [Eternal]",
				"Void Dragon [Eternal]",
				"Archdemon Dragon [Divine]",
				"Dreadscale [Divine]",
				"Kitsune [Divine]",
				"Mecha Dreadscale [Divine]",
				"Nightflame [Divine]",
				"Unicorn [Divine]",
			}
		end

		funcs:Dropdown(v10, "Target Specific Eggs", "Target only selected eggs (Empty = All)", true, tbl7, {}, true, function(specificEggFilters)
			steal.SpecificEggFilters = specificEggFilters or {}

			if steal.RebuildSpecificEggLookup then
				steal.RebuildSpecificEggLookup()
			end
		end)

		funcs:Dropdown(v10, "Steal Priority", "Select target egg priority when stealing", false, { "Best Rarity", "Best Weight", "Mutation", "Highest Money/Sec", "Lowest Money/Sec" }, { "Best Rarity" }, true, function(priority)
			steal.Priority = priority or "Best Rarity"
		end)

		funcs:Toggle(v10, "Prioritize Rift Recipe Eggs", "Prioritize eggs needed for active Rift recipe, but ignore eggs already in backpack, pen, or pet inventory", false, true, function(arg)
			enabled["Prioritize Rift Recipe Eggs"] = arg
			enabled["Prioritize Rift Egg"] = arg
		end)

		v10:AddSeperator({ " - [ Movement & Speed ] - " })

		funcs:Textbox(v10, "Tween Speed", "Speed of linear tween movement (Default: 350 studs/s)", tostring(steal.Speed or 350), true, function(arg)
			local speed = tonumber(arg)

			if speed and speed >= 50 and speed <= 1000 then
				steal.Speed = speed
			else
				steal.Speed = 350
			end
		end)

		funcs:Textbox(v10, "Steal Timeout", "Main egg grab timeout in seconds (Default: 2.5s)", tostring(steal.Timeout or 2.5), true, function(arg)
			local timeout = tonumber(arg)

			if timeout and timeout > 0 then
				steal.Timeout = timeout
			else
				steal.Timeout = 2.5
			end
		end)

		funcs:Toggle(v10, "Run Animation", "Play natural running animation matching tween speed", true, true, function(arg)
			enabled["Run Animation"] = arg

			if not arg then
				steal.StopRunAnimation()
			end
		end)

		v10:AddSeperator({ " - [ Misc ] - " })

		stored.StateUpdate["Anti Knockback / Ragdoll"] = funcs:Toggle(v10, "Anti Knockback / Ragdoll", "", false, true, function(arg)
			enabled["Anti Knockback / Ragdoll"] = arg
			misc.SetAntiKnockback(arg)
		end)

		funcs:Toggle(v10, "Auto Pick Dropped Egg", "Instantly re-grab the egg if a guard knocks it out of your hands (best paired with Anti Knockback / Ragdoll)", false, true, function(arg)
			enabled["Auto Pick Dropped Egg"] = arg
		end)

		funcs:Toggle(v10, "Instant Prompt", "", false, true, function(arg)
			enabled["Instant Prompt"] = arg

			if arg then
				pcall(function()
					for _, descendant in ipairs(workspace:GetDescendants()) do
						if descendant:IsA("ProximityPrompt") then
							descendant.HoldDuration = 0
						end
					end
				end)
			end
		end)

		local v11 = tbl5.Farm:AddSection("Automation Place Egg")
		v11:AddSeperator({ " - [ Pen Placement ] - " })

		funcs:Toggle(v11, "Auto Place Egg", "Place all unplaced eggs into the pen", false, true, function(arg)
			enabled["Auto Place Egg"] = arg

			if not arg then
				movement.Release("PlaceEgg")
				placeEgg.PendingUids = {}
			end
		end)

		funcs:Dropdown(v11, "Place Egg Rule", "Select condition for placing eggs into pen", false, { "Egg Inventory Full", "After Steal", "Steal Idle" }, { "Steal Idle" }, true, function(rule)
			placeEgg.Rule = rule or "Steal Idle"
		end)

		funcs:Dropdown(v11, "Place Egg Priority", "", false, { "Choose Any Egg", "Highest KG", "Lowest KG", "Highest Money/Sec", "Lowest Money/Sec" }, { "Choose Any Egg" }, true, function(selectionMode)
			placeEgg.SelectionMode = selectionMode or "Choose Any Egg"
		end)

		funcs:Textbox(v11, "Max Placed Eggs", "Maximum eggs to place into pen (Default: 30)", tostring(placeEgg.MaxPlaced or 30), true, function(arg)
			placeEgg.MaxPlaced = tonumber(arg) or 30
		end)

		local v12 = tbl5.Farm:AddSection("Automation Treadmill")
		v12:AddSeperator({ " - [ Treadmill Automation ] - " })

		funcs:Toggle(v12, "Auto Treadmill", "Train on treadmill for Speed Power", false, true, function(arg)
			enabled["Auto Treadmill"] = arg

			if not arg then
				treadmill.ExitToSafeZone()
			end
		end)

		funcs:Button(v12, "Exit From Treadmill", "Clear treadmill effects & jump off", function()
			treadmill.ExitToSafeZone()
			notifyDeveloper("Exited from treadmill & effects cleared!", "Treadmill")
		end)

		local v13 = tbl5.Farm:AddSection("Automation Hatch & Equip")

		funcs:Toggle(v13, "Auto Hatch", "Automatically hatch ready eggs", false, true, function(arg)
			enabled["Auto Hatch"] = arg
		end)

		funcs:Toggle(v13, "Auto Equip Best", "Automatically equip best pets", false, true, function(arg)
			enabled["Auto Equip Best"] = arg
		end)

		local v14 = tbl5.Farm:AddSection("Automation Favorite")
		v14:AddSeperator({ " - [ Auto Favorite Pet ] - " })

		funcs:Toggle(v14, "Auto Favorite Pet", "Auto lock pets matching rarity & mutation filters", false, true, function(arg)
			enabled["Auto Favorite Pet"] = arg

			if arg then
				task.spawn(favorite.Execute)
			end
		end)

		funcs:Dropdown(v14, "Favorite Min Rarity", "Favorite pets with rarity >= this (select Off for mutation only)", false, {
			"Off",
			"1 - Common",
			"2 - Uncommon",
			"3 - Rare",
			"4 - Epic",
			"5 - Legendary",
			"6 - Mythic",
			"7 - Cosmic",
			"8 - Secret",
			"9 - Eternal",
			"10 - Divine",
			"11 - Titan",
			"12 - Light & Dark",
		}, { "Off" }, true, function(arg)
			if type(arg) == "table" then
				arg = arg[1] or arg.Value or arg.Title or arg.Text or arg.Name
			end

			local str = tostring(arg or "")

			if str == "Off" or string.find(str, "Off", 1, true) then
				favorite.MinRarity = 0
			else
				favorite.MinRarity = tonumber(string.match(str, "^(%d+)")) or 0
			end
		end)

		funcs:Dropdown(v14, "Favorite Mutation", "Favorite pets with this mutation (select Off for rarity only)", false, {
			"Off",
			"All Mutations",
			"Rainbow",
			"Golden",
			"Silver",
			"Celestial",
			"Voidtouched",
			"Heavenly",
			"Plasma",
			"Dawnbound",
			"Bloodmoon",
			"Magma",
			"Shocked",
			"Frozen",
			"Zombified",
			"Alpha",
			"Twisted",
			"Pollinated",
			"HoneyGlazed",
			"Candy",
			"Choc",
			"Windstruck",
			"Burnt",
			"Wet",
			"Chilled",
			"Scared",
		}, { "Off" }, true, function(mutationFilter)
			favorite.MutationFilter = mutationFilter or "Off"
		end)

		funcs:Button(v14, "Favorite Pets Now", "Lock matching pets immediately", function()
			local v15, v16 = favorite.Execute()
			notifyDeveloper(v15 and "Successfully favorited " .. tostring(v16) .. " pets!" or "Failed: " .. tostring(v16), "Auto Favorite Pet")
		end)

		v14:AddSeperator({ " - [ Equipped Pets ] - " })

		funcs:Toggle(v14, "Auto Favourite Equiped Pets", "Auto favourite all currently equipped pets", false, true, function(arg)
			enabled["Auto Favourite Equiped Pets"] = arg
		end)

		funcs:Toggle(v14, "Auto UnFavourite Equiped Pets", "Auto unfavourite all currently equipped pets", false, true, function(arg)
			enabled["Auto UnFavourite Equiped Pets"] = arg
		end)

		funcs:Button(v14, "Favourite Equipped Now", "Favourite all equipped pets immediately", function()
			local v15, v16 = favorite.SetFavoriteEquipped(true)
			notifyDeveloper(v15 and "Favourited " .. tostring(v16) .. " equipped pets!" or "Failed: " .. tostring(v16), "Auto Favourite Equiped Pets")
		end)

		funcs:Button(v14, "UnFavourite Equipped Now", "Unfavourite all equipped pets immediately", function()
			local v15, v16 = favorite.SetFavoriteEquipped(false)
			notifyDeveloper(v15 and "Unfavourited " .. tostring(v16) .. " equipped pets!" or "Failed: " .. tostring(v16), "Auto UnFavourite Equiped Pets")
		end)

		local v15 = tbl5.Farm:AddSection("Automation Fuse Machine")
		local tbl8 = {}

		pcall(function()
			local assets = modules.Game and modules.Game.Assets or replicatedStorage:FindFirstChild("Data") and require(replicatedStorage.Data.Assets)
			assets = assets and assets.Directory or assets or {}

			if next(assets) then
				local tbl9 = {}

				for k, asset in pairs(assets) do
					if type(asset) == "table" and asset.CannotFuse ~= true then
						local rarity = asset.Rarity
						local displayName = rarity and (rarity.DisplayName or rarity.Name) or "Common"
						rarity = rarity and rarity.RarityNumber or 1

						table.insert(tbl9, {
							formatted = string.format("%s [%s]", asset.DisplayName or asset.Name or k, displayName),
							rNum = rarity,
							name = asset.DisplayName or asset.Name or k,
							category = k,
						})
					end
				end

				table.sort(tbl9, function(arg, arg2)
					if arg.rNum == arg2.rNum then
						return arg.name < arg2.name
					end
					return arg.rNum < arg2.rNum
				end)

				for _, v16 in ipairs(tbl9) do
					table.insert(tbl8, v16.formatted)
				end
			end
		end)

		v15:AddSeperator({ " - [ Fuse Machine ] - " })

		funcs:Toggle(v15, "Auto Fuse Machine", "", false, true, function(arg)
			enabled["Auto Fuse Machine"] = arg

			if arg then
				task.spawn(fuse.Execute)
			end
		end)

		funcs:Dropdown(v15, "Fuse Priority Mode", "Order in which pet categories are chosen to fuse", false, { "Lowest Rarity First", "Highest Rarity First", "Most Duplicates First", "Specific Species Only" }, { "Lowest Rarity First" }, true, function(priorityMode)
			fuse.PriorityMode = priorityMode or "Lowest Rarity First"
		end)

		funcs:Dropdown(v15, "Max Rarity to Fuse", "Only fuse pets with rarity <= this", false, {
			"All",
			"1 - Common",
			"2 - Uncommon",
			"3 - Rare",
			"4 - Epic",
			"5 - Legendary",
			"6 - Mythic",
			"7 - Cosmic",
			"8 - Secret",
			"9 - Eternal",
			"10 - Divine",
			"11 - Titan",
			"12 - Light & Dark",
		}, { "All" }, true, function(arg)
			if arg == "All" then
				fuse.MaxRarity = 0
			else
				fuse.MaxRarity = tonumber((arg or "0"):match("^(%d+)")) or 0
			end
		end)

		funcs:Dropdown(v15, "Specific Species to Fuse", "Select specific pet species to auto fuse (empty = all allowed)", true, tbl8, {}, true, function(specificSpecies)
			fuse.SpecificSpecies = specificSpecies or {}
		end)

		funcs:Toggle(v15, "Skip Mutated Pets", "Do not fuse pets with special mutations (Rainbow, Golden, Silver, etc.)", true, true, function(skipMutations)
			fuse.SkipMutations = skipMutations
		end)

		funcs:Toggle(v15, "Eject Incomplete Slots", "Auto-eject pets in machine if <3 matching pets exist", false, true, function(ejectIncomplete)
			fuse.EjectIncomplete = ejectIncomplete
		end)

		local v16 = tbl5.Farm:AddSection("Dr. Scramble Outbreak")
		v16:AddSeperator({ " - [ Event Telemetry & Status ] - " })
		local v17 = v16:AddParagraph({ "Dr. Scramble Outbreak Telemetry", "Loading event data..." })
		scramble.StatusParagraph = v17

		task.spawn(function()
			while task.wait(2.5) do
				if scramble and scramble.GetSnapshot then
					scramble.GetSnapshot(true)

					if scramble.GetTelemetryText then
						pcall(function()
							v17:Set({ Title = "Dr. Scramble Outbreak Telemetry", Content = scramble.GetTelemetryText() })
						end)
					end
				end
			end
		end)

		v16:AddSeperator({ " - [ Drone Hunting ] - " })

		funcs:Toggle(v16, "Auto Farm Drones", "Hunt and destroy event drones across biomes", false, true, function(arg)
			enabled["Auto Farm Drones"] = arg

			if not arg and modules.Movement then
				modules.Movement.Release("ScrambleDrone")
			end
		end)

		funcs:Toggle(v16, "Fast Switch Bat Attack", "Rapidly alternate between normal bat and The Scrambler to double DPS", true, true, function(fastSwitchBat)
			enabled["Fast Switch Bat"] = fastSwitchBat

			if scramble then
				scramble.FastSwitchBat = fastSwitchBat
			end
		end)

		funcs:Textbox(v16, "Fast Switch Delay (ms)", "Delay between bat switches in milliseconds (Default: 40ms, range 10-100ms)", tostring(scramble and scramble.FastSwitchDelay or 40), true, function(arg)
			local num = tonumber(arg)

			if num then
				local fastSwitchDelay = math.clamp(math.floor(num), 10, 100)

				if scramble then
					scramble.FastSwitchDelay = fastSwitchDelay
				end
			end
		end)

		funcs:Dropdown(v16, "Orchestrator Mode", "Priority when hunting drones vs stealing eggs", false, { "Prioritize Event", "Steal Idle" }, { "Prioritize Event" }, true, function(arg)
			scramble.Config.OrchestratorMode = type(arg) == "table" and arg[1] or arg or "Prioritize Event"
		end)

		funcs:Dropdown(v16, "Priority Target", "Select drone targeting priority strategy", false, {
			"Closest",
			"Augmented First",
			"Reactor First",
			"Scrap First",
			"Lowest HP",
			"Augmented Only",
			"Reactor Only",
			"Scrap Only",
		}, { "Closest" }, true, function(arg)
			local priorityTarget = type(arg) == "table" and arg[1] or arg

			if scramble then
				scramble.Config.PriorityTarget = priorityTarget or "Closest"
			end
		end)

		funcs:Textbox(v16, "Drone Tween Speed", "Linear flight speed toward drones (Default: 300)", tostring(scramble.Config.TweenSpeed or 300), true, function(arg)
			local num = tonumber(arg)

			if num then
				scramble.Config.TweenSpeed = math.clamp(num, 50, 600)
			end
		end)

		funcs:Textbox(v16, "Drone Attack Distance", "Horizontal distance to drone when attacking (Default: 3.5)", tostring(scramble.Config.AttackDistance or 3.5), true, function(arg)
			local num = tonumber(arg)

			if num then
				scramble.Config.AttackDistance = math.clamp(num, 1, 10)
			end
		end)

		funcs:Textbox(v16, "Bat Swing Interval", "Bat swing interval delay in seconds (Default: 0.65s)", tostring(scramble.Config.BatSwingInterval or 0.65), true, function(arg)
			local num = tonumber(arg)

			if num then
				scramble.Config.BatSwingInterval = math.clamp(num, 0.2, 1.5)
			end
		end)

		local v18 = tbl5.Farm:AddSection("Dr. Scramble Event Shop")
		v18:AddSeperator({ " - [ Shop Catalog & Balance ] - " })
		local v19 = v18:AddParagraph({ "Scramble Event Shop", "Loading shop catalog..." })
		scramble.ShopParagraph = v19

		task.spawn(function()
			while true do
				if scramble.FetchSnapshot then
					scramble.FetchSnapshot(true)

					if scramble.GetShopTelemetryText then
						v19:Set({ Title = "Scramble Event Shop", Content = scramble.GetShopTelemetryText() })
					end
				end

				task.wait(2.5)
			end
		end)

		v18:AddSeperator({ " - [ Auto Purchase Settings ] - " })

		funcs:Toggle(v18, "Auto Buy Scramble Shop", "Automatically buy selected items when having enough Samples", false, true, function(arg)
			enabled["Auto Buy Scramble Shop"] = arg
		end)

		funcs:Dropdown(v18, "Select Items to Buy", "Choose which items to buy automatically", true, {
			"Scrambled (Mutation Consumable) [475 Samples]",
			"Experiment #001 (Egg) [6500 Samples]",
			"Nibbles #013 (Egg) [2950 Samples]",
			"2x Cash Booster [275 Samples]",
			"1.25x Speed Booster [375 Samples]",
			"2x Treadmill Booster [375 Samples]",
		}, {}, true, function(selectedShopItems)
			scramble.Config.SelectedShopItems = selectedShopItems or {}
		end)

		funcs:Textbox(v18, "Sample Reserve", "Keep at least this many Samples unspent (e.g. 0, 500, 1k)", "0", true, function(arg)
			local str = tostring(arg or ""):gsub(",", ""):gsub(" ", "")
			local sampleReserve

			if str:lower():find("k") then
				sampleReserve = (tonumber(str:lower():gsub("k", "")) or 0) * 1000
			elseif str:lower():find("m") then
				sampleReserve = (tonumber(str:lower():gsub("m", "")) or 0) * 1000000
			else
				sampleReserve = tonumber(str) or 0
			end

			if sampleReserve < 0 then
				sampleReserve = 0
			end

			scramble.Config.SampleReserve = sampleReserve
			scramble.Config.ShopReserve = sampleReserve
		end)

		funcs:Button(v18, "Buy Selected Items Now", "Attempt immediate purchase of selected items once", function()
			local stepAutoShop = scramble

			if scramble then
				stepAutoShop = scramble.StepAutoShop or scramble.StepShop
			end

			if stepAutoShop then
				(scramble.StepAutoShop or scramble.StepShop)(true)

				if scramble.GetShopTelemetryText then
					v19:Set({ Title = "Scramble Event Shop", Content = scramble.GetShopTelemetryText() })
				end
			end
		end)

		local v20 = tbl5.Farm:AddSection("The Rift")
		v20:AddSeperator({ " - [ Rift Machine Telemetry ] - " })
		local v21 = v20:AddParagraph({ "Rift Machine Status", "Querying Rift status..." })

		if rift then
			rift.StatusParagraph = v21
		end

		funcs:Button(v20, "Refresh Rift Status", "Query server for active banner, requirements, and pity count", function()
			if rift and rift.GetState then
				rift.GetState(true)

				if rift.GetTelemetryText then
					pcall(function()
						v21:Set({ Title = "Rift Machine Status", Content = rift.GetTelemetryText() })
					end)
				end
			end

			notifyDeveloper("Rift status updated.", "The Rift")
		end)

		funcs:Dropdown(v20, "Desired Banners", "Only prioritize steal & sacrifice when one of these banners is active (empty = all)", true, { "Riftborn (Verdant)", "Riftbeasts (Umbral)", "Shattered Rift (Radiant)" }, {}, true, function(arg)
			local desiredBanners = arg or {}

			if rift and rift.Config then
				rift.Config.DesiredBanners = desiredBanners
			end

			if rift and rift.StatusParagraph and rift.GetTelemetryText then
				pcall(function()
					v21:Set({ Title = "Rift Machine Status", Content = rift.GetTelemetryText() })
				end)
			end
		end)

		v20:AddSeperator({ " - [ Automation & Sacrifice ] - " })

		funcs:Toggle(v20, "Auto Rift Sacrifice", "Automatically trade in 3 required sacrifice pets when available in inventory", false, true, function(arg)
			enabled["Auto Rift Sacrifice"] = arg
		end)

		funcs:Toggle(v20, "Auto Reroll Rift Recipe", "Automatically use free refreshes if missing required sacrifice pets", false, true, function(arg)
			enabled["Auto Reroll Rift Recipe"] = arg
		end)

		funcs:Button(v20, "Reroll Recipe Now", "Use a free refresh immediately to get a new sacrifice recipe", function()
			if rift and rift.StepReroll then
				rift.StepReroll(true)

				if rift.GetTelemetryText then
					pcall(function()
						v21:Set({ Title = "Rift Machine Status", Content = rift.GetTelemetryText() })
					end)
				end
			end
		end)

		funcs:Button(v20, "Trade-In Now", "Attempt immediate trade-in with current inventory pets", function()
			if rift and rift.StepSacrifice then
				rift.StepSacrifice(true)

				if rift.GetTelemetryText then
					pcall(function()
						v21:Set({ Title = "Rift Machine Status", Content = rift.GetTelemetryText() })
					end)
				end
			end
		end)

		local v22 = tbl5.Farm:AddSection("Automation Sell")

		local tbl9 = {
			"Off",
			"1 - Common",
			"2 - Uncommon",
			"3 - Rare",
			"4 - Epic",
			"5 - Legendary",
			"6 - Mythic",
			"7 - Cosmic",
			"8 - Secret",
			"9 - Eternal",
			"10 - Divine",
			"11 - Titan",
			"12 - Light & Dark",
		}

		local tbl10 = {}

		pcall(function()
			local ok, result = pcall(require, replicatedStorage.Data.Assets)

			if not (ok and result) then
				local ok2
				ok2, result = pcall(require, replicatedStorage.Directory.Assets)

				if not (ok2 and result) then
					result = modules.Game and modules.Game.Assets
				end
			end

			local directory = result and result.Directory or type(result) == "table" and result or {}

			if next(directory) then
				local tbl11 = {}

				for k, v23 in pairs(directory) do
					if type(v23) == "table" then
						local rarity = v23.Rarity
						local displayName = rarity and (rarity.DisplayName or rarity.Name) or "Common"

						if rarity then
							rarity = rarity.Rank or rarity.RarityNumber
						end

						rarity = rarity or 1

						table.insert(tbl11, {
							formatted = string.format("%s [%s]", v23.DisplayName or v23.Name or k, displayName),
							rNum = rarity,
							name = v23.DisplayName or v23.Name or k,
						})
					end
				end

				table.sort(tbl11, function(arg, arg2)
					if arg.rNum == arg2.rNum then
						return arg.name < arg2.name
					end
					return arg.rNum < arg2.rNum
				end)

				for _, v23 in ipairs(tbl11) do
					table.insert(tbl10, v23.formatted)
				end
			end
		end)

		if #tbl10 == 0 then
			tbl10 = {
				"Chicken [Common]",
				"Dog [Common]",
				"Duckling [Common]",
				"Frog [Common]",
				"Jerboa [Common]",
				"Bird [Uncommon]",
				"Catfish [Uncommon]",
				"Fennec [Uncommon]",
				"Burrowing Owl [Rare]",
				"Camel [Rare]",
				"Chimpanzee [Rare]",
				"Dodo [Rare]",
				"Lava Gecko [Rare]",
				"Parrotfish [Rare]",
				"Penguin [Rare]",
				"Raccoon [Rare]",
				"Toucan [Rare]",
				"Tung Tung Sahur [Rare]",
				"Turtle [Rare]",
				"Bananita Dolphinita [Epic]",
				"Bear [Epic]",
				"Centapede [Epic]",
				"Crane [Epic]",
				"Crocodile [Epic]",
				"Fox [Epic]",
				"Lava frog [Epic]",
				"Swan [Epic]",
				"Swordfish [Epic]",
				"Tob Tobi Tob Tob [Epic]",
				"Trulimero Trulicina [Epic]",
				"Walrus [Epic]",
				"Axolotl [Legendary]",
				"Baby Aurora Dragon [Legendary]",
				"Brr Brr Patapim [Legendary]",
				"Cosmic Gecko [Legendary]",
				"Crustacia [Legendary]",
				"Flaming Bull [Legendary]",
				"Gorilla [Legendary]",
				"Lava Iguana [Legendary]",
				"Mecha Scorpio [Legendary]",
				"Orangutini Ananassini [Legendary]",
				"Polar Bear [Legendary]",
				"Pterodactyl [Legendary]",
				"Salamander [Legendary]",
				"Scorpio [Legendary]",
				"Shark [Legendary]",
				"Snake [Legendary]",
				"Spideron [Legendary]",
				"Ankylosaurus [Mythic]",
				"Belula Beluga [Mythic]",
				"Bladehide [Mythic]",
				"Chillin Chilli [Mythic]",
				"Cosmic Gorilla [Mythic]",
				"Froggo [Mythic]",
				"Mammoth [Mythic]",
				"Mecha Froggo [Mythic]",
				"Orca [Mythic]",
				"Red Panda [Mythic]",
				"Sabertooth Tiger [Mythic]",
				"Sand Spider [Mythic]",
				"Scorpion [Mythic]",
				"Shadow Dragon [Mythic]",
				"Spider [Mythic]",
				"Tiger [Mythic]",
				"Beluga Whale [Cosmic]",
				"Bronto [Cosmic]",
				"Crawler [Cosmic]",
				"Demon Imp [Cosmic]",
				"Drilla [Cosmic]",
				"Hellhound [Cosmic]",
				"King Mammoth [Cosmic]",
				"Koi [Cosmic]",
				"La Vacca Saturno Saturnita [Cosmic]",
				"Leviathan [Cosmic]",
				"Mangolini Parrochini [Cosmic]",
				"Mantaris [Cosmic]",
				"Mecha Crawler [Cosmic]",
				"Rhinotaur [Cosmic]",
				"Royal Sphinx [Cosmic]",
				"Snowy Owl [Cosmic]",
				"Triceratops [Cosmic]",
				"Whale Shark [Cosmic]",
				"Bombo Croco [Secret]",
				"Cerberus [Secret]",
				"Cosmic Dragon [Secret]",
				"Cosmic Skeleton Boss [Secret]",
				"Crocodon [Secret]",
				"Ember Dragon [Secret]",
				"Gargoyle [Secret]",
				"King Snake [Secret]",
				"Kraken [Secret]",
				"Mecha Crocodon [Secret]",
				"Minotaur [Secret]",
				"Mutant Shark [Secret]",
				"Scorched Dragon [Secret]",
				"Stag [Secret]",
				"TRex [Secret]",
				"Tralaledon [Secret]",
				"Yeti [Secret]",
				"Balrog [Eternal]",
				"El Maja [Eternal]",
				"Eternal Lunar Dragon [Eternal]",
				"Gorilla King [Eternal]",
				"Ice Dragon [Eternal]",
				"Krakenoid [Eternal]",
				"Lava Dragon [Eternal]",
				"Mecha Krakenoid [Eternal]",
				"Mosasaurus [Eternal]",
				"Oni Tiger [Eternal]",
				"Phoenix [Eternal]",
				"Strawberry Elephant [Eternal]",
				"Void Dragon [Eternal]",
				"Aetheron [Divine]",
				"ArchAngel [Divine]",
				"Archdemon Dragon [Divine]",
				"Cthulhu [Divine]",
				"Dreadscale [Divine]",
				"Kitsune [Divine]",
				"Luminous Cthulhu [Divine]",
				"Mecha Dreadscale [Divine]",
				"Nightflame [Divine]",
				"Shattered Colossus [Divine]",
				"Unicorn [Divine]",
				"World Burner [Divine]",
			}
		end

		local function parseRarityFilter(arg)
			if not arg then
				return 0
			end

			if type(arg) == "table" then
				arg = arg[1] or arg.Value or arg.Title or arg.Text or arg.Name
			end

			local str = tostring(arg or "")
			if str == "Off" or string.find(str, "Off", 1, true) then
				return 0
			end
			local num = tonumber(string.match(str, "^(%d+)"))
			if num then
				return num
			end

			return ({
				common = 1,
				uncommon = 2,
				superrare = 2,
				rare = 3,
				epic = 4,
				legendary = 5,
				mythic = 6,
				["squishy god"] = 6,
				brainrotgod = 6,
				rainbow = 6,
				prismatic = 6,
				cosmic = 7,
				secret = 8,
				eternal = 9,
				limited = 9,
				divine = 10,
				transcendent = 10,
				titan = 11,
				["light & dark"] = 12,
				lightdark = 12,
				["light and dark"] = 12,
			})[string.lower(str)] or 0
		end

		v22:AddSeperator({ " - [ Pet Sell ] - " })

		funcs:Toggle(v22, "Auto Sell Pet", "Auto sell pets matching rarity / income rules", false, true, function(arg)
			enabled["Auto Sell Pet"] = arg
		end)

		funcs:Dropdown(v22, "Sell Pet Rule", "Select condition mode to sell pets (Rarity, Income, or Both)", false, { "Rarity Only", "Income Threshold Only", "Both (Rarity & Income)", "Either (Rarity or Income)" }, { "Rarity Only" }, true, function(arg)
			local title

			if type(arg) == "table" then
				title = arg[1] or arg.Value or arg.Title or arg.Text or arg.Name
			else
				title = arg
			end

			sell.PetRule = tostring(title or "Rarity Only")
		end)

		funcs:Dropdown(v22, "Pet Max Rarity", "Rule 1: Sell pets with rarity <= this", false, tbl9, { "3 - Rare" }, true, function(arg)
			sell.MaxRarity = parseRarityFilter(arg)
		end)

		funcs:Textbox(v22, "Pet Income Threshold", "Rule 2: Sell if income < this (e.g. 10m, 10M, 10000000 | 0 = Off)", "0", true, function(arg)
			sell.IncomeThreshold = sell.ParseIncome(arg)
		end)

		funcs:Dropdown(v22, "Blacklist Sell Pets", "Never sell these specific pets even if they match rules", true, tbl10, {}, true, function(blacklistPets)
			sell.BlacklistPets = blacklistPets or {}
		end)

		funcs:Button(v22, "Sell Pets Now", "Sell pets once (matching active rules & ignoring blacklist)", function()
			local v23, v24 = sell.ExecutePet()
			notifyDeveloper(v23 and "Successfully sold " .. tostring(v24) .. " pets!" or "Failed: " .. tostring(v24), "Auto Sell Pet")
		end)

		v22:AddSeperator({ " - [ Egg Sell ] - " })

		funcs:Toggle(v22, "Auto Sell Egg", "Auto sell unplaced eggs matching rarity filter", false, true, function(arg)
			enabled["Auto Sell Egg"] = arg
		end)

		funcs:Dropdown(v22, "Egg Max Rarity", "Sell eggs with rarity <= this", false, tbl9, { "3 - Rare" }, true, function(arg)
			sell.EggMaxRarity = parseRarityFilter(arg)
		end)

		funcs:Button(v22, "Sell Eggs Now", "Sell unplaced eggs once (matching filter)", function()
			local v23, v24 = sell.ExecuteEgg()
			notifyDeveloper(v23 and "Successfully sold " .. tostring(v24) .. " eggs!" or "Failed: " .. tostring(v24), "Auto Sell Egg")
		end)

		local v23 = tbl5.Progression:AddSection("Automation Progression")

		funcs:Toggle(v23, "Auto Buy Trail", "Automatically buy available trails when affordable", false, true, function(arg)
			enabled["Auto Buy Trail"] = arg
		end)

		funcs:Toggle(v23, "Auto Upgrade Base", "Automatically upgrade base when money is available", false, true, function(arg)
			enabled["Auto Upgrade Base"] = arg
		end)

		funcs:Toggle(v23, "Auto Upgrade Treadmill", "Automatically upgrade treadmill when money is available", false, true, function(arg)
			enabled["Auto Upgrade Treadmill"] = arg
		end)

		funcs:Toggle(v23, "Auto Claim", "Claim offline money & index rewards", false, true, function(arg)
			enabled["Auto Claim"] = arg
		end)

		local esp2 = tbl5.ESP:AddSection("ESP")

		funcs:Toggle(esp2, "ESP Eggs", "Display markers for all area eggs", false, true, function(arg)
			enabled["ESP Eggs"] = arg
		end)

		funcs:Toggle(esp2, "ESP Rare Eggs", "Highlight high tier eggs (>= Mythic)", false, true, function(arg)
			enabled["ESP Rare Eggs"] = arg
		end)

		funcs:Toggle(esp2, "ESP Guards", "Highlight guard outlines based on state", false, true, function(arg)
			enabled["ESP Guards"] = arg
		end)

		funcs:Toggle(esp2, "ESP Scramble Drones", "3D Highlights & health bars for active event drones", false, true, function(arg)
			enabled["ESP Scramble Drones"] = arg

			if not arg and scramble and scramble.ClearDroneESP then
				scramble.ClearDroneESP()
			end
		end)

		funcs:Toggle(esp2, "ESP Scramble Drops", "3D Markers with distance for dropped mutant samples", false, true, function(arg)
			enabled["ESP Scramble Drops"] = arg

			if not arg and scramble and scramble.ClearDropsESP then
				scramble.ClearDropsESP()
			end
		end)

		local v24 = tbl5.ESP:AddSection("Guard Safety")

		funcs:Toggle(v24, "Guard Warning", "Alert when a guard is chasing you", false, true, function(arg)
			enabled["Guard Warning"] = arg
		end)

		funcs:Toggle(v24, "Auto Drop Egg", "Automatically drop held egg if chased by guard", false, true, function(arg)
			enabled["Auto Drop Egg"] = arg
		end)

		local Server = tbl5.Miscellaneous:AddSection("Server")
		Server:AddSeperator({ " - [ Ping ] - " })

		funcs:Textbox(Server, "Set Ping", "", "500", true, function(arg)
			enabled["Set Ping"] = tonumber(arg)
		end)

		funcs:Toggle(Server, "Enable Set Ping", "", false, true, function(arg)
			enabled["Enable Set Ping"] = arg

			task.spawn(function()
				if enabled["Enable Set Ping"] then
					settings():GetService("NetworkSettings").IncomingReplicationLag = math.clamp(enabled["Set Ping"] * 0.0006, 0, 1)
				else
					settings():GetService("NetworkSettings").IncomingReplicationLag = 0
				end
			end)
		end)

		Server:AddSeperator({ " - [ Job Server ] - " })

		funcs:Textbox(Server, "Job ID", "", "", true, function(arg)
			enabled["Job ID"] = arg
		end)

		funcs:Button(Server, "Join Job ID", "", function()
			services.TeleportService:TeleportToPlaceInstance(game.PlaceId, enabled["Job ID"], localPlayer)
		end)

		Server:AddSeperator({ " - [ Other ] - " })

		funcs:Toggle(Server, "Auto Execute Script", "", false, true, function(arg)
			enabled["Auto Execute Script"] = arg

			if enabled["Auto Execute Script"] then
				queue_on_teleport(" loadstring(game:HttpGet(\"https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua\", true))() ")
			else
				queue_on_teleport("")
			end
		end)

		funcs:Toggle(Server, "Auto Execute Script When Reconnected", "this means when you reconnectd and then execute the speed hub x script without manually executing, and you must enable 'Auto Reconnect' first, it is useful for farmers ugphone or somethings", true, true, function(arg)
			enabled["Auto Execute Script When Reconnected"] = arg
		end)

		funcs:Toggle(Server, "Auto Reconnect", "", false, true, function(arg)
			enabled["Auto Reconnect"] = arg
		end)

		task.spawn(function()
			utils.Connections(coreGui:FindFirstChild("RobloxPromptGui"):FindFirstChild("promptOverlay").ChildAdded, function(arg)
				if enabled["Auto Reconnect"] and arg.Name == "ErrorPrompt" then
					task.delay(2, function()
						if enabled["Auto Execute Script When Reconnected"] then
							queue_on_teleport("                  loadstring(game:HttpGet(\"https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua\", true))()\n                ")
						end

						teleportService:Teleport(game.PlaceId, localPlayer)
					end)
				end
			end)
		end)

		local Player = tbl5.Miscellaneous:AddSection("Player")
		Player:AddSeperator({ " - [ Local Player ] - " })

		funcs:Toggle(Player, "No Clip", "", false, true, function(arg)
			enabled["No Clip"] = arg

			utils.Fallback(arg, "No Clip", function()
				local character2 = localPlayer and localPlayer.Character

				for _, child in pairs(character2:GetChildren()) do
					if child:IsA("BasePart") then
						child.CanCollide = true
					end
				end
			end)
		end)

		funcs:Toggle(Player, "Infinite Jump", "", false, true, function(arg)
			enabled["Infinite Jump"] = arg

			utils.Connections(userInputService.JumpRequest, function()
				local character2 = localPlayer and localPlayer.Character
				character2 = character2 and character2:FindFirstChild("Humanoid")

				if character2 and enabled["Infinite Jump"] then
					character2:ChangeState("Jumping")
				end
			end)
		end)

		local Performance = tbl5.Miscellaneous:AddSection("Performance")
		Performance:AddSeperator({ " - [ Graphics & FPS ] - " })

		funcs:Toggle(Performance, "Reduce Lag", "Simplify materials, remove shadows & clutter to boost FPS", false, true, function(arg)
			enabled["Reduce Lag"] = arg
			misc.ApplyReduceLag(arg)
		end)

		funcs:Toggle(Performance, "Hide Own Pets", "Hide your equipped pets locally to reduce lag", false, true, function(arg)
			enabled["Hide Own Pets"] = arg
			misc.SetHideOwnPets(arg)
		end)

		funcs:Toggle(Performance, "Hide Own Eggs", "Hide your placed eggs locally to reduce lag", false, true, function(arg)
			enabled["Hide Own Eggs"] = arg
			misc.SetHideOwnEggs(arg)
		end)

		funcs:Toggle(Performance, "Hide Other Eggs", "Hide other players' placed eggs to boost FPS", false, true, function(arg)
			enabled["Hide Other Eggs"] = arg
			misc.SetHideOtherEggs(arg)
		end)

		funcs:Toggle(Performance, "Hide Money Animation", "Hide floating money popup text that rises from pets", false, true, function(arg)
			enabled["Hide Money Animation"] = arg

			if arg then
				misc.SetHideMoneyAnimation(true)
			end
		end)

		funcs:Toggle(Performance, "Show Screen White", "Disable 3D rendering to drastically reduce CPU/GPU usage", false, true, function(arg)
			runService:Set3dRenderingEnabled(not arg)
		end)

		funcs:Toggle(Performance, "Show Screen Black", "Set lighting exposure to minimum for power saving", false, true, function(arg)
			lighting.ExposureCompensation = arg and -10 or 0
		end)

		Performance:AddSeperator({ " - [ Game Settings ] - " })
		local settingsCmds = nil

		pcall(function()
			settingsCmds = modules.Game and modules.Game.SettingsCmds or replicatedStorage:FindFirstChild("Shared") and require(replicatedStorage.Shared.SettingsCmds)
		end)

		local function readGameSetting(arg, arg2)
			if settingsCmds and settingsCmds.Flag then
				local ok, result = pcall(function()
					return settingsCmds.Flag(arg)
				end)

				if ok and result ~= nil then
					return result
				end
			end

			return arg2 or false
		end

		local function writeGameSetting(arg, arg2)
			if settingsCmds and settingsCmds.Write then
				pcall(function()
					settingsCmds.Write(arg, arg2)
				end)
			else
				pcall(function()
					local Remotes_ = require(game:GetService("ReplicatedStorage").Shared.Remotes)

					if Remotes_ and Remotes_.Preferences and Remotes_.Preferences.AskWrite then
						Remotes_.Preferences.AskWrite:InvokeServer(arg, arg2)
					end
				end)
			end
		end

		funcs:Toggle(Performance, "Hide Other Pets", "Hide other players' pets via game settings", readGameSetting("HideOtherPets", false), true, function(arg)
			enabled["Hide Other Pets (Game)"] = arg
			writeGameSetting("HideOtherPets", arg)
		end)

		funcs:Toggle(Performance, "Disable Video", "Disable treadmill video frames via game settings", readGameSetting("DisableVideos", false), true, function(arg)
			enabled["Disable Video (Game)"] = arg
			writeGameSetting("DisableVideos", arg)
		end)

		funcs:Toggle(Performance, "Music", "Toggle in-game background music via game settings", readGameSetting("Music", true), true, function(arg)
			enabled["Music (Game)"] = arg
			writeGameSetting("Music", arg)
		end)

		tbl5.Miscellaneous:AddSection("Misc"):AddSeperator({ " - [ Utilities ] - " })
		local Webhook = tbl5.Settings:AddSection("Webhook")

		funcs:Textbox(Webhook, "Discord Webhook URL", "Paste your Discord webhook URL here", "", true, function(url)
			modules.WebhookManager.Url = url or ""
		end)

		funcs:Toggle(Webhook, "Webhook Egg Steal", "Send Discord notification when an egg is stolen (sent on idle)", false, true, function(eggStealEnabled)
			enabled["Webhook Egg Steal"] = eggStealEnabled
			modules.WebhookManager.EggStealEnabled = eggStealEnabled
		end)

		funcs:Dropdown(Webhook, "Webhook Min Rarity", "Only send notification for eggs with rarity >= this", false, {
			"All",
			"1 - Common",
			"2 - Uncommon",
			"3 - Rare",
			"4 - Epic",
			"5 - Legendary",
			"6 - Mythic",
			"7 - Cosmic",
			"8 - Secret",
			"9 - Eternal",
			"10 - Divine",
			"11 - Titan",
			"12 - Light & Dark",
		}, { "All" }, true, function(arg)
			if type(arg) == "table" then
				arg = arg[1] or arg.Value or arg.Title or arg.Text
			end

			local str = tostring(arg or "All")

			if str == "All" or string.find(str, "All", 1, true) then
				modules.WebhookManager.MinRarity = 1
			else
				modules.WebhookManager.MinRarity = tonumber(string.match(str, "(%d+)")) or 1
			end
		end)

		funcs:Button(Webhook, "Test Webhook", "Send a test notification to verify URL", function()
			if not modules.WebhookManager.Url or modules.WebhookManager.Url == "" then
				notifyDeveloper("Please paste Webhook URL first!", "Webhook")
				return
			end

			modules.WebhookManager.SendPayload({
				petCategory = "Phoenix",
				petName = "Phoenix",
				rarityName = "Eternal",
				rarityNum = 9,
				scale = 1,
				mutation = "Rainbow",
				areaId = "Volcano",
				nestId = 1,
				timestamp = os.time(),
			})

			notifyDeveloper("Test webhook sent!", "Webhook")
		end)

		funcs:Button(tbl5.Settings:AddSection("Reset Config"), "Reset Script Config", "", function()
			for _, v25 in next, { "Speed_Hub", "SpeedHubX", "Speed Hub X", "Speed Hub", "Speed_Hub_X" }, nil do
				if isfolder(v25) then
					delfolder(v25)
				end
			end
		end)

		task.spawn(shx.AddSettingUi, shx, v7)
	end

	controller.LoadFunction = function()
		local function startFeatureLoop(arg, arg2)
			task.spawn(function()
				utils.StartLoop(arg, arg2)
			end)
		end

		startFeatureLoop("No Clip", function()
			local character2 = localPlayer and localPlayer.Character
			if not character2 then
				task.wait(0.5)
				return
			end

			for _, child in pairs(character2:GetChildren()) do
				if child:IsA("BasePart") and child.CanCollide then
					child.CanCollide = false
				end
			end

			task.wait(0.1)
		end)

		task.spawn(function()
			while not shx.Unloaded do
				local ok, result = pcall(orchestrator.Tick)

				if not ok and _G.DebugMode then
					warn("[Orchestrator Error] " .. tostring(result))
				end

				if treadmill and treadmill.CheckTreadmil and treadmill.CheckTreadmil() then
					task.wait(0.4)
				else
					task.wait(0.04)
				end
			end
		end)

		startFeatureLoop("Auto Pick Dropped Egg", function()
			if not game_.Ready then
				return
			end
			steal.AutoPickStep()
			task.wait()
		end)

		startFeatureLoop("Auto Hatch", function()
			if not game_.Ready then
				return
			end
			hatch.Step()
			task.wait(2)
		end)

		startFeatureLoop("Auto Equip Best", function()
			if not game_.Ready then
				return
			end
			equip.Step()
			task.wait(6)
		end)

		startFeatureLoop("Auto Favorite Pet", function()
			if not game_.Ready then
				return
			end
			favorite.Step()
			task.wait(3)
		end)

		startFeatureLoop("Auto Favourite Equiped Pets", function()
			if not game_.Ready then
				return
			end
			favorite.StepFavEquipped()
			task.wait(3)
		end)

		startFeatureLoop("Auto UnFavourite Equiped Pets", function()
			if not game_.Ready then
				return
			end
			favorite.StepUnfavEquipped()
			task.wait(3)
		end)

		startFeatureLoop("Auto Fuse Machine", function()
			if not game_.Ready then
				return
			end
			fuse.Step()
			task.wait(2)
		end)

		startFeatureLoop("Auto Rebirth", function()
			if not game_.Ready then
				return
			end
			rebirth.Step()
			task.wait(3)
		end)

		startFeatureLoop("Auto Upgrade Base", function()
			if not game_.Ready then
				return
			end
			upgrade.Step()
			task.wait(3)
		end)

		startFeatureLoop("Auto Upgrade Treadmill", function()
			if not game_.Ready then
				return
			end
			upgrade.StepTreadmill()
			task.wait(3)
		end)

		startFeatureLoop("Auto Buy Trail", function()
			if not game_.Ready then
				return
			end

			if trail and trail.Step then
				trail.Step()
			end

			task.wait(5)
		end)

		startFeatureLoop("Auto Claim", function()
			if not game_.Ready then
				return
			end
			claim.Step()
			task.wait(5)
		end)

		enabled["ESP Loop"] = true

		startFeatureLoop("ESP Loop", function()
			if not game_.Ready then
				return
			end
			esp.Step()

			if scramble then
				if scramble.UpdateDroneESP then
					scramble.UpdateDroneESP()
				end

				if scramble.UpdateDropsESP then
					scramble.UpdateDropsESP()
				end
			end

			task.wait(1)
		end)

		task.spawn(function()
			local clientRenderedAssets = workspace:FindFirstChild("ClientRenderedAssets")

			if clientRenderedAssets then
				utils.Connections(clientRenderedAssets.ChildAdded, function(arg)
					if not enabled["Hide Own Pets"] then
						return
					end
					task.wait(0.05)
					local userId = localPlayer.UserId

					if arg:GetAttribute("OwnerUserId") == userId or string.find(arg.Name, tostring(localPlayer.UserId), 1, true) == 1 then
						for _, descendant in ipairs(arg:GetDescendants()) do
							if descendant:IsA("BasePart") then
								descendant.LocalTransparencyModifier = 1
							elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
								descendant.Transparency = 1
							elseif descendant:IsA("BillboardGui") or descendant:IsA("ParticleEmitter") or descendant:IsA("Highlight") then
								descendant.Enabled = false
							end
						end

						local connection = arg.DescendantAdded:Connect(function(descendant)
							if not enabled["Hide Own Pets"] then
								return
							end

							if descendant:IsA("BasePart") then
								descendant.LocalTransparencyModifier = 1
							elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
								descendant.Transparency = 1
							elseif descendant:IsA("BillboardGui") or descendant:IsA("ParticleEmitter") or descendant:IsA("Highlight") then
								descendant.Enabled = false
							end
						end)

						arg.Destroying:Connect(function()
							if connection then
								connection:Disconnect()
								connection = nil
							end
						end)
					end
				end)
			end
		end)

		task.spawn(function()
			for _, child in ipairs(workspace:GetChildren()) do
				if child.Name == "PlacedEggRenders" then
					utils.Connections(child.ChildAdded, function(arg)
						task.wait(0.05)
						local flag = string.find(arg.Name, tostring(localPlayer.UserId), 1, true) == 1
						local flag2

						if flag then
							flag2 = flag
						else
							local userId = localPlayer.UserId
							flag2 = arg:GetAttribute("OwnerUserId") == userId
						end

						if flag2 and enabled["Hide Own Eggs"] or not flag2 and enabled["Hide Other Eggs"] then
							for _, descendant in ipairs(arg:GetDescendants()) do
								if descendant:IsA("BasePart") then
									descendant.LocalTransparencyModifier = 1
								elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
									descendant.Transparency = 1
								elseif descendant:IsA("BillboardGui") or descendant:IsA("ParticleEmitter") or descendant:IsA("Highlight") then
									descendant.Enabled = false
								end
							end

							local connection = arg.DescendantAdded:Connect(function(descendant)
								if not (flag2 and enabled["Hide Own Eggs"] or not flag2 and enabled["Hide Other Eggs"]) then
									return
								end

								if descendant:IsA("BasePart") then
									descendant.LocalTransparencyModifier = 1
								elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
									descendant.Transparency = 1
								elseif descendant:IsA("BillboardGui") or descendant:IsA("ParticleEmitter") or descendant:IsA("Highlight") then
									descendant.Enabled = false
								end
							end)

							arg.Destroying:Connect(function()
								if connection then
									connection:Disconnect()
									connection = nil
								end
							end)
						end
					end)
				end
			end
		end)

		task.spawn(function()
			local terrain = workspace:FindFirstChild("Terrain")

			if terrain then
				utils.Connections(terrain.ChildAdded, function(arg)
					if not enabled["Hide Money Animation"] then
						return
					end

					if arg.Name == "SyncedIncomeCashAttachment" or arg.Name == "SyncedIncomeCash" then
						arg:Destroy()
					end
				end)
			end
		end)

		startFeatureLoop("Webhook Dispatcher", function()
			if webhookManager then
				webhookManager.Step()
			end

			task.wait(1)
		end)

		startFeatureLoop("Pet Predictions Loop", function()
			if petPredictor and petPredictor.Paragraph then
				petPredictor.UpdateParagraph()
			end

			task.wait(15)
		end)

		startFeatureLoop("Fuse Predictor Loop", function()
			if fusePredictor and fusePredictor.Paragraph then
				fusePredictor.UpdateParagraph()
			end

			task.wait(10)
		end)

		startFeatureLoop("Auto Treadmill", function()
			if not game_.Ready then
				return
			end

			if enabled["Auto Treadmill"] and treadmill and treadmill.Step and treadmill.CanRun and treadmill.CanRun() then
				treadmill.Step()
			end

			if treadmill.IsOnTreadmill() and not treadmill.CanRun() then
				treadmill.ExitTreadmill()
			end

			task.wait(2)
		end)

		startFeatureLoop("Auto Sell Pet", function()
			if not game_.Ready then
				return
			end

			if sell and sell.CanSell and sell.CanSell() then
				sell.Step()
			end

			task.wait(2)
		end)

		startFeatureLoop("Auto Sell Egg", function()
			if not game_.Ready then
				return
			end

			if sell and sell.CanSell and sell.CanSell() then
				sell.Step()
			end

			task.wait(2)
		end)

		task.spawn(function()
			pcall(function()
				for _, descendant in ipairs(workspace:GetDescendants()) do
					if descendant:IsA("ProximityPrompt") and enabled["Instant Prompt"] then
						descendant.HoldDuration = 0
					end
				end
			end)

			workspace.DescendantAdded:Connect(function(descendant)
				if enabled["Instant Prompt"] and descendant:IsA("ProximityPrompt") then
					descendant.HoldDuration = 0
				end
			end)
		end)

		task.spawn(function()
			while not shx.Unloaded do
				if scramble and scramble.StatusParagraph and scramble.GetTelemetryText then
					pcall(function()
						scramble.StatusParagraph:Set({ Title = "Dr. Scramble Outbreak Telemetry", Content = scramble.GetTelemetryText() })
					end)
				end

				if scramble and scramble.ShopParagraph and scramble.GetShopTelemetryText then
					pcall(function()
						scramble.ShopParagraph:Set({ Title = "Scramble Event Shop", Content = scramble.GetShopTelemetryText() })
					end)
				end

				if rift and rift.StatusParagraph and rift.GetTelemetryText then
					pcall(function()
						rift.StatusParagraph:Set({ Title = "Rift Machine Status", Content = rift.GetTelemetryText() })
					end)
				end

				task.wait(3)
			end
		end)

		startFeatureLoop("Auto Buy Scramble Shop", function()
			if not game_.Ready then
				return
			end

			if scramble and scramble.StepAutoShop then
				scramble.StepAutoShop()
			end

			task.wait(2)
		end)

		startFeatureLoop("Auto Rift", function()
			if not game_.Ready then
				return
			end

			if rift and (enabled["Auto Rift Sacrifice"] or enabled["Auto Reroll Rift Recipe"]) and rift.Step then
				rift.Step()
			end

			task.wait(2.5)
		end)
	end

	controller.Dependency = function()
		utils.Connections(localPlayer.CharacterAdded, function(arg)
			character = arg
			humanoid = character:WaitForChild("Humanoid")
			humanoidRootPart = character:WaitForChild("HumanoidRootPart")
		end, "Dependency_001")

		task.spawn(function()
			local v7, v8 = game_.Init()
			if not v7 then
				notifyDeveloper("Game API failed to load: " .. tostring(v8), "Speed Hub X")
				return
			end
			task.wait(1)
			if not game_.GetSaveWait() then
				notifyDeveloper("Player data failed to load", "Speed Hub X")
				return
			end

			pcall(function()
				game_.EggCmds.RequestAreaEggSnapshot()
				game_.EggCmds.RequestRuntimeSnapshot()
			end)

			notifyDeveloper("Game API ready!", "Speed Hub X")
		end)
	end

	controller:Dependency()
	controller:LoadFunction()
	controller:LoadLibrary()
end

task.spawn(pcall, function()
	local function createCloneRefCache()
		local cloneRefFunction = cloneref
		local cloneCache = setmetatable({}, { __mode = "v" })

		return cloneRefFunction and function(instance)
			if not instance then
				return nil
			end
			local debugId = instance:GetDebugId() or instance
			local cachedRef = cloneCache[debugId]
			if cachedRef then
				return cachedRef
			end
			local clonedRef = cloneRefFunction(instance)
			cloneCache[debugId] = clonedRef
			return clonedRef
		end or function(instance)
			return instance
		end
	end

	local cloneRef = createCloneRefCache()
	cloneRef(game:GetService("ContentProvider"))
	local localPlayer = cloneRef(game:GetService("Players")).LocalPlayer

	local function repairHumanoid()
		local character = localPlayer.Character
		if not character then
			return false
		end
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
		local animate = character:FindFirstChild("Animate")
		local currentCamera = workspace.CurrentCamera
		if not humanoid or not humanoidRootPart then
			return false
		end

		if humanoid:GetAttribute("__Index") == true then
			return true
		end
		local archivable = character.Archivable
		character.Archivable = true

		local ok, cameraSubject = pcall(function()
			return humanoid:Clone()
		end)

		character.Archivable = archivable
		if not ok or not cameraSubject then
			return false
		end
		local walkSpeed = humanoid.WalkSpeed
		local jumpPower = humanoid.JumpPower
		local jumpHeight = humanoid.JumpHeight
		local useJumpPower = humanoid.UseJumpPower
		local hipHeight = humanoid.HipHeight
		local autoRotate = humanoid.AutoRotate
		local maxHealth = humanoid.MaxHealth
		local health = humanoid.Health
		cameraSubject.Name = "Humanoid"
		cameraSubject:SetAttribute("__Index", true)
		cameraSubject.Parent = character
		humanoid:Destroy()
		cameraSubject.WalkSpeed = walkSpeed
		cameraSubject.JumpPower = jumpPower
		cameraSubject.JumpHeight = jumpHeight
		cameraSubject.UseJumpPower = useJumpPower
		cameraSubject.HipHeight = hipHeight
		cameraSubject.AutoRotate = autoRotate
		cameraSubject.MaxHealth = maxHealth
		cameraSubject.Health = math.min(health, maxHealth)

		for _, v7 in ipairs(Enum.HumanoidStateType:GetEnumItems()) do
			pcall(cameraSubject.SetStateEnabled, cameraSubject, v7, true)
		end

		humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
		humanoidRootPart.AssemblyAngularVelocity = Vector3.zero

		if currentCamera then
			currentCamera.CameraType = Enum.CameraType.Custom
			currentCamera.CameraSubject = cameraSubject
		end

		if animate then
			animate.Disabled = true
			task.wait()
			animate.Disabled = false
		end

		task.defer(function()
			if cameraSubject.Parent then
				cameraSubject:ChangeState(Enum.HumanoidStateType.Running)
			end
		end)

		return true
	end

	task.spawn(function()
		while task.wait(0.1) do
			local character = localPlayer.Character

			if character then
				local humanoid = character:FindFirstChild("Humanoid")

				if humanoid and not humanoid:GetAttribute("__Index") then
					pcall(repairHumanoid)
				end
			end
		end
	end)

	task.spawn(function()
		while task.wait(0.1) do
			local character = localPlayer.Character

			if character then
				local antiCollisionHighSeedPushBack = character:FindFirstChild("AntiCollisionHighSeedPushBack", true)

				if antiCollisionHighSeedPushBack then
					antiCollisionHighSeedPushBack.Disabled = true
					antiCollisionHighSeedPushBack:Destroy()
				end
			end
		end
	end)
end)
task.spawn(initializeSpeedHub)
