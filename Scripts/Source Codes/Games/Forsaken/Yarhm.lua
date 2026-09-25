-- Yet Another Random Hub Menu 1.21 by Aetherion

if not game:IsLoaded() then
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "Script loading",
		Text = "Waiting for the game to finish loading!",
		Duration = 5
	})
	game.Loaded:Wait()
end
-- Instances:

local Converted = {
	["_YARHM"] = Instance.new("ScreenGui");
	["_FUNCTIONS"] = Instance.new("ModuleScript");
	["_Flee the Facility"] = Instance.new("LocalScript");
	["_Universal"] = Instance.new("LocalScript");
	["_DraggableObject"] = Instance.new("ModuleScript");
	["_ClickAndHold"] = Instance.new("ModuleScript");
	["_Spring"] = Instance.new("ModuleScript");
	["_Init"] = Instance.new("LocalScript");
	["_Forsaken"] = Instance.new("LocalScript");
	["_Murder Mystery 2"] = Instance.new("LocalScript");
	["_ESPIndicator"] = Instance.new("ModuleScript");
	["_Bezier"] = Instance.new("ModuleScript");
	["_PointSave"] = Instance.new("ModuleScript");
	["_Theme"] = Instance.new("ModuleScript");
	["_FlyUtility"] = Instance.new("ModuleScript");
	["_Open"] = Instance.new("TextButton");
	["_InitOpen"] = Instance.new("LocalScript");
	["_OnClick"] = Instance.new("LocalScript");
	["_Resizer"] = Instance.new("LocalScript");
	["_UICorner"] = Instance.new("UICorner");
	["_UIPadding"] = Instance.new("UIPadding");
	["_DropdownFrameSample"] = Instance.new("Frame");
	["_UICorner1"] = Instance.new("UICorner");
	["_UIGradient"] = Instance.new("UIGradient");
	["_UIStroke"] = Instance.new("UIStroke");
	["_UIGradient1"] = Instance.new("UIGradient");
	["_ScrollingFrame"] = Instance.new("ScrollingFrame");
	["_UIListLayout"] = Instance.new("UIListLayout");
	["_Sample"] = Instance.new("TextButton");
	["_UIPadding1"] = Instance.new("UIPadding");
	["_UICorner2"] = Instance.new("UICorner");
	["_UIPadding2"] = Instance.new("UIPadding");
	["_themedColor"] = Instance.new("StringValue");
	["_ListButton"] = Instance.new("TextButton");
	["_UICorner3"] = Instance.new("UICorner");
	["_Notifications"] = Instance.new("Frame");
	["_UIListLayout1"] = Instance.new("UIListLayout");
	["_UIPadding3"] = Instance.new("UIPadding");
	["_Placeholder"] = Instance.new("Frame");
	["_UICorner4"] = Instance.new("UICorner");
	["_TextLabel"] = Instance.new("TextLabel");
	["_TextBoxPlaceholder"] = Instance.new("Frame");
	["_UIListLayout2"] = Instance.new("UIListLayout");
	["_TextButton"] = Instance.new("TextButton");
	["_UICorner5"] = Instance.new("UICorner");
	["_UIPadding4"] = Instance.new("UIPadding");
	["_TextBox"] = Instance.new("TextBox");
	["_UICorner6"] = Instance.new("UICorner");
	["_FloatingButton"] = Instance.new("TextButton");
	["_Keybinding"] = Instance.new("LocalScript");
	["_Invisible"] = Instance.new("LocalScript");
	["_UIPadding5"] = Instance.new("UIPadding");
	["_UICorner7"] = Instance.new("UICorner");
	["_UIStroke1"] = Instance.new("UIStroke");
	["_Lock"] = Instance.new("TextLabel");
	["_UIScale"] = Instance.new("UIScale");
	["_Ripple"] = Instance.new("Frame");
	["_UICorner8"] = Instance.new("UICorner");
	["_UIScale1"] = Instance.new("UIScale");
	["_Dropdown"] = Instance.new("Frame");
	["_TextLabel1"] = Instance.new("TextLabel");
	["_UIListLayout3"] = Instance.new("UIListLayout");
	["_UIPadding6"] = Instance.new("UIPadding");
	["_Frame"] = Instance.new("TextButton");
	["_UIPadding7"] = Instance.new("UIPadding");
	["_UICorner9"] = Instance.new("UICorner");
	["_AddCustomModule"] = Instance.new("Frame");
	["_UICorner10"] = Instance.new("UICorner");
	["_UIStroke2"] = Instance.new("UIStroke");
	["_UIGradient2"] = Instance.new("UIGradient");
	["_UIGradient3"] = Instance.new("UIGradient");
	["_UIScale2"] = Instance.new("UIScale");
	["_TextLabel2"] = Instance.new("TextLabel");
	["_TextBox1"] = Instance.new("TextBox");
	["_UICorner11"] = Instance.new("UICorner");
	["_UIPadding8"] = Instance.new("UIPadding");
	["_TextLabel3"] = Instance.new("TextLabel");
	["_Add"] = Instance.new("TextButton");
	["_LocalScript"] = Instance.new("LocalScript");
	["_UICorner12"] = Instance.new("UICorner");
	["_UIPadding9"] = Instance.new("UIPadding");
	["_UIStroke3"] = Instance.new("UIStroke");
	["_Cancel"] = Instance.new("TextButton");
	["_LocalScript1"] = Instance.new("LocalScript");
	["_UICorner13"] = Instance.new("UICorner");
	["_UIPadding10"] = Instance.new("UIPadding");
	["_UIStroke4"] = Instance.new("UIStroke");
	["_themedColor1"] = Instance.new("StringValue");
	["_Menu"] = Instance.new("Frame");
	["_UICorner14"] = Instance.new("UICorner");
	["_UIStroke5"] = Instance.new("UIStroke");
	["_UIGradient4"] = Instance.new("UIGradient");
	["_Animator"] = Instance.new("LocalScript");
	["_HubCredits"] = Instance.new("TextLabel");
	["_HubDesc"] = Instance.new("TextLabel");
	["_HubName"] = Instance.new("TextLabel");
	["_CanvasGroup"] = Instance.new("CanvasGroup");
	["_UICorner15"] = Instance.new("UICorner");
	["_ImageLabel"] = Instance.new("ImageLabel");
	["_Opener"] = Instance.new("TextButton");
	["_TextLabel4"] = Instance.new("TextLabel");
	["_CloseArea"] = Instance.new("TextButton");
	["_CloseOpen"] = Instance.new("LocalScript");
	["_Frame1"] = Instance.new("Frame");
	["_UICorner16"] = Instance.new("UICorner");
	["_themedColor2"] = Instance.new("StringValue");
	["_TextLabel5"] = Instance.new("TextLabel");
	["_UICorner17"] = Instance.new("UICorner");
	["_AllowForSpring"] = Instance.new("BindableEvent");
	["_themedColor3"] = Instance.new("StringValue");
	["_UIGradient5"] = Instance.new("UIGradient");
	["_Area"] = Instance.new("CanvasGroup");
	["_Area1"] = Instance.new("ScrollingFrame");
	["_TextLabel6"] = Instance.new("TextLabel");
	["_TextLabel7"] = Instance.new("TextLabel");
	["_UICorner18"] = Instance.new("UICorner");
	["_List"] = Instance.new("CanvasGroup");
	["_AutoSetup"] = Instance.new("LocalScript");
	["_UICorner19"] = Instance.new("UICorner");
	["_ScrollingFrame1"] = Instance.new("ScrollingFrame");
	["_UIListLayout4"] = Instance.new("UIListLayout");
	["_UIPadding11"] = Instance.new("UIPadding");
	["_UIPadding12"] = Instance.new("UIPadding");
	["_UIStroke6"] = Instance.new("UIStroke");
	["_UIGradient6"] = Instance.new("UIGradient");
	["_AddCustomModule1"] = Instance.new("TextButton");
	["_LocalScript2"] = Instance.new("LocalScript");
	["_UICorner20"] = Instance.new("UICorner");
	["_UIPadding13"] = Instance.new("UIPadding");
	["_UIStroke7"] = Instance.new("UIStroke");
	["_themedColor4"] = Instance.new("StringValue");
	["_themedColor5"] = Instance.new("StringValue");
	["_themedColor6"] = Instance.new("StringValue");
	["_UIScale3"] = Instance.new("UIScale");
	["_Stub"] = Instance.new("Frame");
	["_themedColor7"] = Instance.new("StringValue");
	["_Stub1"] = Instance.new("Frame");
	["_themedColor8"] = Instance.new("StringValue");
	["_Toggle"] = Instance.new("Frame");
	["_TextLabel8"] = Instance.new("TextLabel");
	["_UIListLayout5"] = Instance.new("UIListLayout");
	["_Frame2"] = Instance.new("Frame");
	["_Frame3"] = Instance.new("Frame");
	["_UICorner21"] = Instance.new("UICorner");
	["_Toggler"] = Instance.new("TextButton");
	["_UICorner22"] = Instance.new("UICorner");
	["_ImageLabel1"] = Instance.new("ImageLabel");
	["_UIPadding14"] = Instance.new("UIPadding");
	["_Modules"] = Instance.new("Folder");
	["_NotificationSample"] = Instance.new("Frame");
	["_UICorner23"] = Instance.new("UICorner");
	["_UIStroke8"] = Instance.new("UIStroke");
	["_UIGradient7"] = Instance.new("UIGradient");
	["_ImageLabel2"] = Instance.new("ImageLabel");
	["_TextLabel9"] = Instance.new("TextLabel");
	["_UITextSizeConstraint"] = Instance.new("UITextSizeConstraint");
	["_Close"] = Instance.new("ImageButton");
	["_UICorner24"] = Instance.new("UICorner");
	["_UIStroke9"] = Instance.new("UIStroke");
	["_UIScale4"] = Instance.new("UIScale");
	["_themedColor9"] = Instance.new("StringValue");
	["_Dialog"] = Instance.new("Frame");
	["_UICorner25"] = Instance.new("UICorner");
	["_UIGradient8"] = Instance.new("UIGradient");
	["_UIPadding15"] = Instance.new("UIPadding");
	["_UIStroke10"] = Instance.new("UIStroke");
	["_UIGradient9"] = Instance.new("UIGradient");
	["_DialogTitle"] = Instance.new("TextLabel");
	["_UIListLayout6"] = Instance.new("UIListLayout");
	["_DialogDesc"] = Instance.new("TextLabel");
	["_UITextSizeConstraint1"] = Instance.new("UITextSizeConstraint");
	["_Options"] = Instance.new("Frame");
	["_UIListLayout7"] = Instance.new("UIListLayout");
	["_OptionPlaceholder"] = Instance.new("TextButton");
	["_UIPadding16"] = Instance.new("UIPadding");
	["_UICorner26"] = Instance.new("UICorner");
	["_UIStroke11"] = Instance.new("UIStroke");
	["_UIGradient10"] = Instance.new("UIGradient");
	["_themedColor10"] = Instance.new("StringValue");
	["_OnSelect"] = Instance.new("BindableEvent");
	["_UIScale5"] = Instance.new("UIScale");
	["_themedColor11"] = Instance.new("StringValue");
	["_Range"] = Instance.new("Frame");
	["_TextLabel10"] = Instance.new("TextLabel");
	["_UIListLayout8"] = Instance.new("UIListLayout");
	["_UIPadding17"] = Instance.new("UIPadding");
	["_Frame4"] = Instance.new("Frame");
	["_UIPadding18"] = Instance.new("UIPadding");
	["_UICorner27"] = Instance.new("UICorner");
	["_Track"] = Instance.new("Frame");
	["_UICorner28"] = Instance.new("UICorner");
	["_Ball"] = Instance.new("TextButton");
	["_BallProgress"] = Instance.new("TextLabel");
	["_UIPadding19"] = Instance.new("UIPadding");
	["_themedColor12"] = Instance.new("StringValue");
	["_UICorner29"] = Instance.new("UICorner");
	["_UIPadding20"] = Instance.new("UIPadding");
	["_TrackProgress"] = Instance.new("TextLabel");
	["_themedColor13"] = Instance.new("StringValue");
	["_UISizeConstraint"] = Instance.new("UISizeConstraint");
	["_FloatingButtonSetting"] = Instance.new("Frame");
	["_ControlBarContainer"] = Instance.new("Frame");
	["_ControlBar"] = Instance.new("Frame");
	["_UIListLayout9"] = Instance.new("UIListLayout");
	["_Visibility"] = Instance.new("TextButton");
	["_LocalScript3"] = Instance.new("LocalScript");
	["_UICorner30"] = Instance.new("UICorner");
	["_UIPadding21"] = Instance.new("UIPadding");
	["_Event"] = Instance.new("BindableEvent");
	["_themedColor14"] = Instance.new("StringValue");
	["_Lock1"] = Instance.new("TextButton");
	["_LocalScript4"] = Instance.new("LocalScript");
	["_UICorner31"] = Instance.new("UICorner");
	["_UIPadding22"] = Instance.new("UIPadding");
	["_Event1"] = Instance.new("BindableEvent");
	["_themedColor15"] = Instance.new("StringValue");
	["_Exit"] = Instance.new("TextButton");
	["_LocalScript5"] = Instance.new("LocalScript");
	["_UICorner32"] = Instance.new("UICorner");
	["_UIPadding23"] = Instance.new("UIPadding");
	["_UIAspectRatioConstraint"] = Instance.new("UIAspectRatioConstraint");
	["_themedColor16"] = Instance.new("StringValue");
	["_UIListLayout10"] = Instance.new("UIListLayout");
	["_Tip"] = Instance.new("TextLabel");
	["_UIStroke12"] = Instance.new("UIStroke");
	["_UIScale6"] = Instance.new("UIScale");
	["_FloatingButtons"] = Instance.new("Frame");
	["_FloatingButtons1"] = Instance.new("Frame");
}

-- Properties:

Converted["_YARHM"].DisplayOrder = 3
Converted["_YARHM"].IgnoreGuiInset = true
Converted["_YARHM"].ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
Converted["_YARHM"].ResetOnSpawn = false
Converted["_YARHM"].ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Converted["_YARHM"].Name = "YARHM"
Converted["_YARHM"].Parent = game:GetService("CoreGui")

Converted["_Open"].Font = Enum.Font.Gotham
Converted["_Open"].Text = "Triple-click this region to open YARHM."
Converted["_Open"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Open"].TextScaled = true
Converted["_Open"].TextSize = 14
Converted["_Open"].TextTransparency = 1
Converted["_Open"].TextWrapped = true
Converted["_Open"].AnchorPoint = Vector2.new(0.5, 0.5)
Converted["_Open"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Open"].BackgroundTransparency = 1
Converted["_Open"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Open"].BorderSizePixel = 0
Converted["_Open"].Position = UDim2.new(0.499372631, 0, 0.06341701, 0)
Converted["_Open"].Selectable = false
Converted["_Open"].Size = UDim2.new(0, 493, 0, 50)
Converted["_Open"].Visible = false
Converted["_Open"].Name = "Open"
Converted["_Open"].Parent = Converted["_YARHM"]

Converted["_UICorner"].Parent = Converted["_Open"]

Converted["_UIPadding"].PaddingBottom = UDim.new(0, 10)
Converted["_UIPadding"].PaddingLeft = UDim.new(0, 20)
Converted["_UIPadding"].PaddingRight = UDim.new(0, 20)
Converted["_UIPadding"].PaddingTop = UDim.new(0, 10)
Converted["_UIPadding"].Parent = Converted["_Open"]

Converted["_DropdownFrameSample"].AnchorPoint = Vector2.new(0.5, 0)
Converted["_DropdownFrameSample"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_DropdownFrameSample"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_DropdownFrameSample"].BorderSizePixel = 0
Converted["_DropdownFrameSample"].Size = UDim2.new(0, 108, 0, 239)
Converted["_DropdownFrameSample"].Visible = false
Converted["_DropdownFrameSample"].Name = "DropdownFrameSample"
Converted["_DropdownFrameSample"].Parent = Converted["_YARHM"]

Converted["_UICorner1"].Parent = Converted["_DropdownFrameSample"]

Converted["_UIGradient"].Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(36.00000165402889, 36.00000165402889, 36.00000165402889)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(68.00000354647636, 68.00000354647636, 68.00000354647636))
}
Converted["_UIGradient"].Rotation = 68
Converted["_UIGradient"].Parent = Converted["_DropdownFrameSample"]

Converted["_UIStroke"].Color = Color3.fromRGB(255, 255, 255)
Converted["_UIStroke"].Thickness = 2
Converted["_UIStroke"].Parent = Converted["_DropdownFrameSample"]

Converted["_UIGradient1"].Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(111.00000098347664, 111.00000098347664, 111.00000098347664)),
	ColorSequenceKeypoint.new(0.6401384472846985, Color3.fromRGB(114.23875719308853, 114.23875719308853, 114.23875719308853)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
}
Converted["_UIGradient1"].Rotation = -107
Converted["_UIGradient1"].Parent = Converted["_UIStroke"]

Converted["_ScrollingFrame"].AutomaticCanvasSize = Enum.AutomaticSize.XY
Converted["_ScrollingFrame"].CanvasSize = UDim2.new(0, 0, 0, 0)
Converted["_ScrollingFrame"].ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
Converted["_ScrollingFrame"].ScrollBarThickness = 0
Converted["_ScrollingFrame"].Active = true
Converted["_ScrollingFrame"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_ScrollingFrame"].BackgroundTransparency = 1
Converted["_ScrollingFrame"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_ScrollingFrame"].BorderSizePixel = 0
Converted["_ScrollingFrame"].Size = UDim2.new(1, 0, 1, 0)
Converted["_ScrollingFrame"].Parent = Converted["_DropdownFrameSample"]

Converted["_UIListLayout"].Padding = UDim.new(0, 5)
Converted["_UIListLayout"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIListLayout"].Parent = Converted["_ScrollingFrame"]

Converted["_Sample"].Font = Enum.Font.Unknown
Converted["_Sample"].Text = "This can fit a lot of text, probably."
Converted["_Sample"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Sample"].TextScaled = true
Converted["_Sample"].TextSize = 14
Converted["_Sample"].TextWrapped = true
Converted["_Sample"].BackgroundColor3 = Color3.fromRGB(22.000000588595867, 22.000000588595867, 22.000000588595867)
Converted["_Sample"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Sample"].BorderSizePixel = 0
Converted["_Sample"].Size = UDim2.new(1, 0, 0, 35)
Converted["_Sample"].Visible = false
Converted["_Sample"].Name = "Sample"
Converted["_Sample"].Parent = Converted["_ScrollingFrame"]

Converted["_UIPadding1"].PaddingBottom = UDim.new(0, 7)
Converted["_UIPadding1"].PaddingLeft = UDim.new(0, 7)
Converted["_UIPadding1"].PaddingRight = UDim.new(0, 7)
Converted["_UIPadding1"].PaddingTop = UDim.new(0, 7)
Converted["_UIPadding1"].Parent = Converted["_Sample"]

Converted["_UICorner2"].Parent = Converted["_Sample"]

Converted["_UIPadding2"].PaddingBottom = UDim.new(0, 7)
Converted["_UIPadding2"].PaddingLeft = UDim.new(0, 7)
Converted["_UIPadding2"].PaddingRight = UDim.new(0, 7)
Converted["_UIPadding2"].PaddingTop = UDim.new(0, 7)
Converted["_UIPadding2"].Parent = Converted["_DropdownFrameSample"]

Converted["_themedColor"].Value = "backgroundColorCSQ"
Converted["_themedColor"].Name = "themedColor"
Converted["_themedColor"].Parent = Converted["_DropdownFrameSample"]

Converted["_ListButton"].Font = Enum.Font.Gotham
Converted["_ListButton"].Text = "Placeholder"
Converted["_ListButton"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_ListButton"].TextSize = 14
Converted["_ListButton"].TextWrapped = true
Converted["_ListButton"].AnchorPoint = Vector2.new(0.5, 0.5)
Converted["_ListButton"].BackgroundColor3 = Color3.fromRGB(49.00000087916851, 49.00000087916851, 49.00000087916851)
Converted["_ListButton"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_ListButton"].BorderSizePixel = 0
Converted["_ListButton"].Position = UDim2.new(0.0450000018, 0, 0.112000003, 0)
Converted["_ListButton"].Size = UDim2.new(1, 0, 0, 50)
Converted["_ListButton"].Visible = false
Converted["_ListButton"].Name = "ListButton"
Converted["_ListButton"].Parent = Converted["_YARHM"]

Converted["_UICorner3"].Parent = Converted["_ListButton"]

Converted["_Notifications"].AnchorPoint = Vector2.new(1, 0.5)
Converted["_Notifications"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Notifications"].BackgroundTransparency = 1
Converted["_Notifications"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Notifications"].BorderSizePixel = 0
Converted["_Notifications"].Position = UDim2.new(0.99000001, 0, 0.5, 0)
Converted["_Notifications"].Size = UDim2.new(0, 242, 1, 0)
Converted["_Notifications"].Name = "Notifications"
Converted["_Notifications"].Parent = Converted["_YARHM"]

Converted["_UIListLayout1"].Padding = UDim.new(0, 10)
Converted["_UIListLayout1"].HorizontalAlignment = Enum.HorizontalAlignment.Center
Converted["_UIListLayout1"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIListLayout1"].VerticalAlignment = Enum.VerticalAlignment.Bottom
Converted["_UIListLayout1"].Parent = Converted["_Notifications"]

Converted["_UIPadding3"].PaddingBottom = UDim.new(0, 10)
Converted["_UIPadding3"].PaddingLeft = UDim.new(0, 10)
Converted["_UIPadding3"].Parent = Converted["_Notifications"]

Converted["_Placeholder"].AnchorPoint = Vector2.new(0.5, 0)
Converted["_Placeholder"].BackgroundColor3 = Color3.fromRGB(31.000001952052116, 31.000001952052116, 31.000001952052116)
Converted["_Placeholder"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Placeholder"].BorderSizePixel = 0
Converted["_Placeholder"].Position = UDim2.new(0.0450000018, 0, 0.112000003, 0)
Converted["_Placeholder"].Visible = false
Converted["_Placeholder"].Name = "Placeholder"
Converted["_Placeholder"].Parent = Converted["_Notifications"]

Converted["_UICorner4"].Parent = Converted["_Placeholder"]

Converted["_TextLabel"].Font = Enum.Font.Gotham
Converted["_TextLabel"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel"].TextScaled = true
Converted["_TextLabel"].TextSize = 14
Converted["_TextLabel"].TextWrapped = true
Converted["_TextLabel"].TextXAlignment = Enum.TextXAlignment.Left
Converted["_TextLabel"].AnchorPoint = Vector2.new(0.5, 0.5)
Converted["_TextLabel"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel"].BackgroundTransparency = 1
Converted["_TextLabel"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_TextLabel"].BorderSizePixel = 0
Converted["_TextLabel"].Position = UDim2.new(0.5, 0, 0.5, 0)
Converted["_TextLabel"].Size = UDim2.new(0.899999976, 0, 0.800000012, 0)
Converted["_TextLabel"].Parent = Converted["_Placeholder"]

Converted["_TextBoxPlaceholder"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextBoxPlaceholder"].BackgroundTransparency = 1
Converted["_TextBoxPlaceholder"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_TextBoxPlaceholder"].BorderSizePixel = 0
Converted["_TextBoxPlaceholder"].Size = UDim2.new(1, 0, 0, 50)
Converted["_TextBoxPlaceholder"].Visible = false
Converted["_TextBoxPlaceholder"].Name = "TextBoxPlaceholder"
Converted["_TextBoxPlaceholder"].Parent = Converted["_YARHM"]

Converted["_UIListLayout2"].Padding = UDim.new(0, 5)
Converted["_UIListLayout2"].FillDirection = Enum.FillDirection.Horizontal
Converted["_UIListLayout2"].HorizontalAlignment = Enum.HorizontalAlignment.Center
Converted["_UIListLayout2"].Parent = Converted["_TextBoxPlaceholder"]

Converted["_TextButton"].Font = Enum.Font.Gotham
Converted["_TextButton"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextButton"].TextScaled = true
Converted["_TextButton"].TextSize = 14
Converted["_TextButton"].TextWrapped = true
Converted["_TextButton"].BackgroundColor3 = Color3.fromRGB(22.000000588595867, 22.000000588595867, 22.000000588595867)
Converted["_TextButton"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_TextButton"].BorderSizePixel = 0
Converted["_TextButton"].Position = UDim2.new(0.292333364, 0, 1.67999995, 0)
Converted["_TextButton"].Size = UDim2.new(0, 50, 0, 50)
Converted["_TextButton"].Parent = Converted["_TextBoxPlaceholder"]

Converted["_UICorner5"].Parent = Converted["_TextButton"]

Converted["_UIPadding4"].PaddingBottom = UDim.new(0, 5)
Converted["_UIPadding4"].PaddingLeft = UDim.new(0, 5)
Converted["_UIPadding4"].PaddingRight = UDim.new(0, 5)
Converted["_UIPadding4"].PaddingTop = UDim.new(0, 5)
Converted["_UIPadding4"].Parent = Converted["_TextButton"]

Converted["_TextBox"].Font = Enum.Font.Gotham
Converted["_TextBox"].PlaceholderText = "Placeholder"
Converted["_TextBox"].Text = ""
Converted["_TextBox"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextBox"].TextSize = 14
Converted["_TextBox"].TextWrapped = true
Converted["_TextBox"].BackgroundColor3 = Color3.fromRGB(22.000000588595867, 22.000000588595867, 22.000000588595867)
Converted["_TextBox"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_TextBox"].BorderSizePixel = 0
Converted["_TextBox"].Size = UDim2.new(0.800000012, 0, 0, 50)
Converted["_TextBox"].Parent = Converted["_TextBoxPlaceholder"]

Converted["_UICorner6"].Parent = Converted["_TextBox"]

Converted["_FloatingButton"].Font = Enum.Font.Unknown
Converted["_FloatingButton"].Text = "Shoot into murderer"
Converted["_FloatingButton"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_FloatingButton"].TextScaled = true
Converted["_FloatingButton"].TextSize = 14
Converted["_FloatingButton"].TextWrapped = true
Converted["_FloatingButton"].AutoButtonColor = false
Converted["_FloatingButton"].AnchorPoint = Vector2.new(0.5, 0.5)
Converted["_FloatingButton"].BackgroundColor3 = Color3.fromRGB(31.000000052154064, 31.000000052154064, 31.000000052154064)
Converted["_FloatingButton"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_FloatingButton"].BorderSizePixel = 0
Converted["_FloatingButton"].ClipsDescendants = true
Converted["_FloatingButton"].Position = UDim2.new(0, 125, 0, 40)
Converted["_FloatingButton"].Size = UDim2.new(0, 50, 0, 100)
Converted["_FloatingButton"].Visible = false
Converted["_FloatingButton"].Name = "FloatingButton"
Converted["_FloatingButton"].Parent = Converted["_YARHM"]

Converted["_UIPadding5"].PaddingBottom = UDim.new(0, 5)
Converted["_UIPadding5"].PaddingLeft = UDim.new(0, 5)
Converted["_UIPadding5"].PaddingRight = UDim.new(0, 5)
Converted["_UIPadding5"].PaddingTop = UDim.new(0, 5)
Converted["_UIPadding5"].Parent = Converted["_FloatingButton"]

Converted["_UICorner7"].Parent = Converted["_FloatingButton"]

Converted["_UIStroke1"].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
Converted["_UIStroke1"].Color = Color3.fromRGB(255, 255, 255)
Converted["_UIStroke1"].Parent = Converted["_FloatingButton"]

Converted["_Lock"].Font = Enum.Font.Gotham
Converted["_Lock"].Text = "Ã°Å¸ââ"
Converted["_Lock"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Lock"].TextScaled = true
Converted["_Lock"].TextSize = 14
Converted["_Lock"].TextWrapped = true
Converted["_Lock"].AnchorPoint = Vector2.new(0.5, 0.5)
Converted["_Lock"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Lock"].BackgroundTransparency = 1
Converted["_Lock"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Lock"].BorderSizePixel = 0
Converted["_Lock"].Position = UDim2.new(1, -10, 1, -10)
Converted["_Lock"].Size = UDim2.new(0, 20, 0, 20)
Converted["_Lock"].ZIndex = 999999999
Converted["_Lock"].Name = "Lock"
Converted["_Lock"].Parent = Converted["_FloatingButton"]

Converted["_UIScale"].Scale = 1.0000000116860974e-07
Converted["_UIScale"].Parent = Converted["_Lock"]

Converted["_Ripple"].AnchorPoint = Vector2.new(0.5, 0.5)
Converted["_Ripple"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Ripple"].BackgroundTransparency = 1
Converted["_Ripple"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Ripple"].BorderSizePixel = 0
Converted["_Ripple"].Size = UDim2.new(0, 100, 0, 100)
Converted["_Ripple"].Name = "Ripple"
Converted["_Ripple"].Parent = Converted["_FloatingButton"]

Converted["_UICorner8"].CornerRadius = UDim.new(1, 0)
Converted["_UICorner8"].Parent = Converted["_Ripple"]

Converted["_UIScale1"].Parent = Converted["_FloatingButton"]

Converted["_Dropdown"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Dropdown"].BackgroundTransparency = 1
Converted["_Dropdown"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Dropdown"].BorderSizePixel = 0
Converted["_Dropdown"].Size = UDim2.new(1, 0, 0, 35)
Converted["_Dropdown"].Visible = false
Converted["_Dropdown"].Name = "Dropdown"
Converted["_Dropdown"].Parent = Converted["_YARHM"]

Converted["_TextLabel1"].Font = Enum.Font.Unknown
Converted["_TextLabel1"].Text = "Loop walkspeed and FOV"
Converted["_TextLabel1"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel1"].TextScaled = true
Converted["_TextLabel1"].TextSize = 14
Converted["_TextLabel1"].TextWrapped = true
Converted["_TextLabel1"].TextXAlignment = Enum.TextXAlignment.Left
Converted["_TextLabel1"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel1"].BackgroundTransparency = 1
Converted["_TextLabel1"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_TextLabel1"].BorderSizePixel = 0
Converted["_TextLabel1"].Size = UDim2.new(0.699999988, 0, 1, 0)
Converted["_TextLabel1"].Parent = Converted["_Dropdown"]

Converted["_UIListLayout3"].Padding = UDim.new(0, 15)
Converted["_UIListLayout3"].FillDirection = Enum.FillDirection.Horizontal
Converted["_UIListLayout3"].HorizontalAlignment = Enum.HorizontalAlignment.Center
Converted["_UIListLayout3"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIListLayout3"].Parent = Converted["_Dropdown"]

Converted["_UIPadding6"].PaddingLeft = UDim.new(0.0700000003, 0)
Converted["_UIPadding6"].PaddingRight = UDim.new(0.0700000003, 0)
Converted["_UIPadding6"].Parent = Converted["_Dropdown"]

Converted["_Frame"].Font = Enum.Font.Gotham
Converted["_Frame"].Text = "Select..."
Converted["_Frame"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Frame"].TextScaled = true
Converted["_Frame"].TextWrapped = true
Converted["_Frame"].Active = false
Converted["_Frame"].BackgroundColor3 = Color3.fromRGB(31.000001952052116, 31.000001952052116, 31.000001952052116)
Converted["_Frame"].BackgroundTransparency = -0.03999999910593033
Converted["_Frame"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Frame"].BorderSizePixel = 0
Converted["_Frame"].Selectable = false
Converted["_Frame"].Size = UDim2.new(0.400000006, 0, 1, 0)
Converted["_Frame"].Name = "Frame"
Converted["_Frame"].Parent = Converted["_Dropdown"]

Converted["_UIPadding7"].PaddingBottom = UDim.new(0, 7)
Converted["_UIPadding7"].PaddingLeft = UDim.new(0, 7)
Converted["_UIPadding7"].PaddingRight = UDim.new(0, 7)
Converted["_UIPadding7"].PaddingTop = UDim.new(0, 7)
Converted["_UIPadding7"].Parent = Converted["_Frame"]

Converted["_UICorner9"].Parent = Converted["_Frame"]

Converted["_AddCustomModule"].AnchorPoint = Vector2.new(0.5, 0.5)
Converted["_AddCustomModule"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_AddCustomModule"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_AddCustomModule"].BorderSizePixel = 0
Converted["_AddCustomModule"].ClipsDescendants = true
Converted["_AddCustomModule"].Position = UDim2.new(0.5, 0, -0.5, 0)
Converted["_AddCustomModule"].Size = UDim2.new(0, 440, 0, 268)
Converted["_AddCustomModule"].ZIndex = 3
Converted["_AddCustomModule"].Name = "AddCustomModule"
Converted["_AddCustomModule"].Parent = Converted["_YARHM"]

Converted["_UICorner10"].Parent = Converted["_AddCustomModule"]

Converted["_UIStroke2"].Color = Color3.fromRGB(255, 255, 255)
Converted["_UIStroke2"].Thickness = 2
Converted["_UIStroke2"].Parent = Converted["_AddCustomModule"]

Converted["_UIGradient2"].Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(53.00000064074993, 53.00000064074993, 53.00000064074993)),
	ColorSequenceKeypoint.new(0.15224914252758026, Color3.fromRGB(50.69031357765198, 50.69031357765198, 50.69031357765198)),
	ColorSequenceKeypoint.new(0.4723183512687683, Color3.fromRGB(255, 255, 255)),
	ColorSequenceKeypoint.new(0.7577854990959167, Color3.fromRGB(50.13314567506313, 50.13314567506313, 50.13314567506313)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(48.000000938773155, 48.000000938773155, 48.000000938773155))
}
Converted["_UIGradient2"].Rotation = 62
Converted["_UIGradient2"].Parent = Converted["_UIStroke2"]

Converted["_UIGradient3"].Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(36.00000165402889, 36.00000165402889, 36.00000165402889)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(68.00000354647636, 68.00000354647636, 68.00000354647636))
}
Converted["_UIGradient3"].Rotation = 68
Converted["_UIGradient3"].Parent = Converted["_AddCustomModule"]

Converted["_UIScale2"].Parent = Converted["_AddCustomModule"]

Converted["_TextLabel2"].Font = Enum.Font.Gotham
Converted["_TextLabel2"].Text = "Add a module"
Converted["_TextLabel2"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel2"].TextScaled = true
Converted["_TextLabel2"].TextSize = 14
Converted["_TextLabel2"].TextWrapped = true
Converted["_TextLabel2"].AnchorPoint = Vector2.new(0.5, 0.5)
Converted["_TextLabel2"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel2"].BackgroundTransparency = 1
Converted["_TextLabel2"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_TextLabel2"].BorderSizePixel = 0
Converted["_TextLabel2"].Position = UDim2.new(0.352256238, 0, 0.133915231, 0)
Converted["_TextLabel2"].Size = UDim2.new(0.619047642, 0, 0.125920027, 0)
Converted["_TextLabel2"].Parent = Converted["_AddCustomModule"]

Converted["_TextBox1"].ClearTextOnFocus = false
Converted["_TextBox1"].Font = Enum.Font.Gotham
Converted["_TextBox1"].PlaceholderText = "Custom module link"
Converted["_TextBox1"].Text = ""
Converted["_TextBox1"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextBox1"].TextScaled = true
Converted["_TextBox1"].TextSize = 14
Converted["_TextBox1"].TextWrapped = true
Converted["_TextBox1"].AnchorPoint = Vector2.new(0.5, 0.5)
Converted["_TextBox1"].BackgroundColor3 = Color3.fromRGB(22.000000588595867, 22.000000588595867, 22.000000588595867)
Converted["_TextBox1"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_TextBox1"].BorderSizePixel = 0
Converted["_TextBox1"].Position = UDim2.new(0.499648541, 0, 0.500059664, 0)
Converted["_TextBox1"].Size = UDim2.new(0.804988742, 0, 0.544776142, 0)
Converted["_TextBox1"].Parent = Converted["_AddCustomModule"]

Converted["_UICorner11"].Parent = Converted["_TextBox1"]

Converted["_UIPadding8"].PaddingBottom = UDim.new(0, 10)
Converted["_UIPadding8"].PaddingLeft = UDim.new(0, 10)
Converted["_UIPadding8"].PaddingRight = UDim.new(0, 10)
Converted["_UIPadding8"].PaddingTop = UDim.new(0, 10)
Converted["_UIPadding8"].Parent = Converted["_TextBox1"]

Converted["_TextLabel3"].Font = Enum.Font.GothamBold
Converted["_TextLabel3"].Text = "ONLY ADD MODULES YOU TRUST!"
Converted["_TextLabel3"].TextColor3 = Color3.fromRGB(255, 0, 0)
Converted["_TextLabel3"].TextScaled = true
Converted["_TextLabel3"].TextSize = 14
Converted["_TextLabel3"].TextWrapped = true
Converted["_TextLabel3"].AnchorPoint = Vector2.new(0.5, 0.5)
Converted["_TextLabel3"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel3"].BackgroundTransparency = 1
Converted["_TextLabel3"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_TextLabel3"].BorderSizePixel = 0
Converted["_TextLabel3"].Position = UDim2.new(0.499648541, 0, 0.833542168, 0)
Converted["_TextLabel3"].Size = UDim2.new(0.619047642, 0, 0.0550245307, 0)
Converted["_TextLabel3"].Parent = Converted["_AddCustomModule"]

Converted["_Add"].Font = Enum.Font.Gotham
Converted["_Add"].Text = "Add"
Converted["_Add"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Add"].TextScaled = true
Converted["_Add"].TextSize = 14
Converted["_Add"].TextWrapped = true
Converted["_Add"].AnchorPoint = Vector2.new(0.5, 0.5)
Converted["_Add"].BackgroundColor3 = Color3.fromRGB(50.00000461935997, 50.00000461935997, 50.00000461935997)
Converted["_Add"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Add"].BorderSizePixel = 0
Converted["_Add"].Position = UDim2.new(0.108492024, 0, 0.927298486, 0)
Converted["_Add"].Size = UDim2.new(0.163265288, 0, 0.0858208984, 0)
Converted["_Add"].Name = "Add"
Converted["_Add"].Parent = Converted["_AddCustomModule"]

Converted["_UICorner12"].Parent = Converted["_Add"]

Converted["_UIPadding9"].PaddingBottom = UDim.new(0, 5)
Converted["_UIPadding9"].PaddingLeft = UDim.new(0, 5)
Converted["_UIPadding9"].PaddingRight = UDim.new(0, 5)
Converted["_UIPadding9"].PaddingTop = UDim.new(0, 5)
Converted["_UIPadding9"].Parent = Converted["_Add"]

Converted["_UIStroke3"].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
Converted["_UIStroke3"].Color = Color3.fromRGB(255, 255, 255)
Converted["_UIStroke3"].Parent = Converted["_Add"]

Converted["_Cancel"].Font = Enum.Font.Gotham
Converted["_Cancel"].Text = "Cancel"
Converted["_Cancel"].TextColor3 = Color3.fromRGB(255, 0, 0)
Converted["_Cancel"].TextScaled = true
Converted["_Cancel"].TextSize = 14
Converted["_Cancel"].TextWrapped = true
Converted["_Cancel"].AnchorPoint = Vector2.new(0.5, 0.5)
Converted["_Cancel"].BackgroundColor3 = Color3.fromRGB(50.00000461935997, 50.00000461935997, 50.00000461935997)
Converted["_Cancel"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Cancel"].BorderSizePixel = 0
Converted["_Cancel"].Position = UDim2.new(0.899875283, 0, 0.931029797, 0)
Converted["_Cancel"].Size = UDim2.new(0.163265288, 0, 0.0858208984, 0)
Converted["_Cancel"].Name = "Cancel"
Converted["_Cancel"].Parent = Converted["_AddCustomModule"]

Converted["_UICorner13"].Parent = Converted["_Cancel"]

Converted["_UIPadding10"].PaddingBottom = UDim.new(0, 5)
Converted["_UIPadding10"].PaddingLeft = UDim.new(0, 5)
Converted["_UIPadding10"].PaddingRight = UDim.new(0, 5)
Converted["_UIPadding10"].PaddingTop = UDim.new(0, 5)
Converted["_UIPadding10"].Parent = Converted["_Cancel"]

Converted["_UIStroke4"].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
Converted["_UIStroke4"].Color = Color3.fromRGB(255, 0, 0)
Converted["_UIStroke4"].Parent = Converted["_Cancel"]

Converted["_themedColor1"].Value = "backgroundColorCSQ"
Converted["_themedColor1"].Name = "themedColor"
Converted["_themedColor1"].Parent = Converted["_AddCustomModule"]

Converted["_Menu"].AnchorPoint = Vector2.new(0.5, 0)
Converted["_Menu"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Menu"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Menu"].BorderSizePixel = 0
Converted["_Menu"].Position = UDim2.new(0.5, 0, 0.0500000007, 0)
Converted["_Menu"].Size = UDim2.new(0, 441, 0, 268)
Converted["_Menu"].Name = "Menu"
Converted["_Menu"].Parent = Converted["_YARHM"]

Converted["_UICorner14"].CornerRadius = UDim.new(0, 16)
Converted["_UICorner14"].Parent = Converted["_Menu"]

Converted["_UIStroke5"].Color = Color3.fromRGB(255, 255, 255)
Converted["_UIStroke5"].Thickness = 2
Converted["_UIStroke5"].Parent = Converted["_Menu"]

Converted["_UIGradient4"].Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(53.00000064074993, 53.00000064074993, 53.00000064074993)),
	ColorSequenceKeypoint.new(0.15224914252758026, Color3.fromRGB(50.69031357765198, 50.69031357765198, 50.69031357765198)),
	ColorSequenceKeypoint.new(0.4723183512687683, Color3.fromRGB(255, 0, 4.000000236555934)),
	ColorSequenceKeypoint.new(0.7577854990959167, Color3.fromRGB(50.13314567506313, 50.13314567506313, 50.13314567506313)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(48.000000938773155, 48.000000938773155, 48.000000938773155))
}
Converted["_UIGradient4"].Rotation = 180
Converted["_UIGradient4"].Parent = Converted["_UIStroke5"]

Converted["_HubCredits"].Font = Enum.Font.GothamBold
Converted["_HubCredits"].Text = "made and open sourced by imperial"
Converted["_HubCredits"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_HubCredits"].TextScaled = true
Converted["_HubCredits"].TextSize = 14
Converted["_HubCredits"].TextTransparency = 0.699999988079071
Converted["_HubCredits"].TextWrapped = true
Converted["_HubCredits"].TextXAlignment = Enum.TextXAlignment.Right
Converted["_HubCredits"].AnchorPoint = Vector2.new(0.5, 0.5)
Converted["_HubCredits"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_HubCredits"].BackgroundTransparency = 1
Converted["_HubCredits"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_HubCredits"].BorderSizePixel = 0
Converted["_HubCredits"].Position = UDim2.new(0.785926819, 0, 0.160157606, 0)
Converted["_HubCredits"].Size = UDim2.new(0.316320807, 0, 0.0585099049, 0)
Converted["_HubCredits"].Visible = false
Converted["_HubCredits"].Name = "HubCredits"
Converted["_HubCredits"].Parent = Converted["_Menu"]

Converted["_HubDesc"].Font = Enum.Font.GothamBold
Converted["_HubDesc"].Text = "yet another random hub menu"
Converted["_HubDesc"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_HubDesc"].TextSize = 14
Converted["_HubDesc"].TextWrapped = true
Converted["_HubDesc"].TextXAlignment = Enum.TextXAlignment.Right
Converted["_HubDesc"].AnchorPoint = Vector2.new(0.5, 0.5)
Converted["_HubDesc"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_HubDesc"].BackgroundTransparency = 1
Converted["_HubDesc"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_HubDesc"].BorderSizePixel = 0
Converted["_HubDesc"].Position = UDim2.new(0.708829343, 0, 0.116141364, 0)
Converted["_HubDesc"].Size = UDim2.new(0.470515788, 0, 0.082417585, 0)
Converted["_HubDesc"].Name = "HubDesc"
Converted["_HubDesc"].Parent = Converted["_Menu"]

Converted["_HubName"].Font = Enum.Font.GothamBold
Converted["_HubName"].RichText = true
Converted["_HubName"].Text = "YARHM "
Converted["_HubName"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_HubName"].TextScaled = true
Converted["_HubName"].TextSize = 14
Converted["_HubName"].TextWrapped = true
Converted["_HubName"].TextXAlignment = Enum.TextXAlignment.Left
Converted["_HubName"].AnchorPoint = Vector2.new(0.5, 0.5)
Converted["_HubName"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_HubName"].BackgroundTransparency = 1
Converted["_HubName"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_HubName"].BorderSizePixel = 0
Converted["_HubName"].Position = UDim2.new(0.186153606, 0, 0.112410031, 0)
Converted["_HubName"].Size = UDim2.new(0.259631485, 0, 0.0824175924, 0)
Converted["_HubName"].Name = "HubName"
Converted["_HubName"].Parent = Converted["_Menu"]

Converted["_CanvasGroup"].GroupTransparency = 1
Converted["_CanvasGroup"].AnchorPoint = Vector2.new(0.5, 0.5)
Converted["_CanvasGroup"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_CanvasGroup"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_CanvasGroup"].BorderSizePixel = 0
Converted["_CanvasGroup"].Interactable = false
Converted["_CanvasGroup"].Position = UDim2.new(0.5, 0, 0.5, 0)
Converted["_CanvasGroup"].Size = UDim2.new(1, 0, 1, 0)
Converted["_CanvasGroup"].Visible = false
Converted["_CanvasGroup"].ZIndex = 999999998
Converted["_CanvasGroup"].Parent = Converted["_Menu"]

Converted["_UICorner15"].CornerRadius = UDim.new(0, 16)
Converted["_UICorner15"].Parent = Converted["_CanvasGroup"]

Converted["_ImageLabel"].Image = "rbxassetid://17864987433"
-- Converted["_ImageLabel"].ImageContent = Content{SourceType=Uri, Uri=rbxassetid://17864987433}
Converted["_ImageLabel"].AnchorPoint = Vector2.new(0.5, 0.5)
Converted["_ImageLabel"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_ImageLabel"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_ImageLabel"].BorderSizePixel = 0
Converted["_ImageLabel"].Position = UDim2.new(0.5, 0, 0.5, 0)
Converted["_ImageLabel"].Size = UDim2.new(0, 50, 0, 50)
Converted["_ImageLabel"].Visible = false
Converted["_ImageLabel"].ZIndex = 3
Converted["_ImageLabel"].Parent = Converted["_CanvasGroup"]

Converted["_Opener"].Font = Enum.Font.SourceSans
Converted["_Opener"].Text = ""
Converted["_Opener"].TextColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Opener"].TextSize = 14
Converted["_Opener"].AutoButtonColor = false
Converted["_Opener"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Opener"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Opener"].BorderSizePixel = 0
Converted["_Opener"].Size = UDim2.new(1, 0, 1, 0)
Converted["_Opener"].Name = "Opener"
Converted["_Opener"].Parent = Converted["_CanvasGroup"]

Converted["_TextLabel4"].Font = Enum.Font.GothamBold
Converted["_TextLabel4"].Text = "Yet Another Random Hub Menu"
Converted["_TextLabel4"].TextColor3 = Color3.fromRGB(255, 69.00000348687172, 67.00000360608101)
Converted["_TextLabel4"].TextScaled = true
Converted["_TextLabel4"].TextSize = 14
Converted["_TextLabel4"].TextWrapped = true
Converted["_TextLabel4"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel4"].BackgroundTransparency = 1
Converted["_TextLabel4"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_TextLabel4"].BorderSizePixel = 0
Converted["_TextLabel4"].Position = UDim2.new(0.204081595, 0, 0.447761208, 0)
Converted["_TextLabel4"].Size = UDim2.new(0, 260, 0, 27)
Converted["_TextLabel4"].ZIndex = 3
Converted["_TextLabel4"].Parent = Converted["_CanvasGroup"]

Converted["_CloseArea"].Text = ""
Converted["_CloseArea"].AnchorPoint = Vector2.new(0.5, 0.5)
Converted["_CloseArea"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_CloseArea"].BackgroundTransparency = 1
Converted["_CloseArea"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_CloseArea"].BorderSizePixel = 0
Converted["_CloseArea"].Position = UDim2.new(0.5, 0, 0.00295135868, 0)
Converted["_CloseArea"].Size = UDim2.new(0.326999992, 0, 0.184, 0)
Converted["_CloseArea"].Name = "CloseArea"
Converted["_CloseArea"].Parent = Converted["_Menu"]

Converted["_Frame1"].AnchorPoint = Vector2.new(0.5, 0.5)
Converted["_Frame1"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Frame1"].BackgroundTransparency = 0.6499999761581421
Converted["_Frame1"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Frame1"].BorderSizePixel = 0
Converted["_Frame1"].Position = UDim2.new(0.5, 0, 0.699999988, 0)
Converted["_Frame1"].Size = UDim2.new(0.699999988, 0, 0.100000001, 0)
Converted["_Frame1"].Parent = Converted["_CloseArea"]

Converted["_UICorner16"].CornerRadius = UDim.new(0, 9999)
Converted["_UICorner16"].Parent = Converted["_Frame1"]

Converted["_themedColor2"].Value = "accentColor"
Converted["_themedColor2"].Name = "themedColor"
Converted["_themedColor2"].Parent = Converted["_Frame1"]

Converted["_TextLabel5"].Font = Enum.Font.Gotham
Converted["_TextLabel5"].Text = "Tap here to minimize."
Converted["_TextLabel5"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel5"].TextSize = 15
Converted["_TextLabel5"].TextWrapped = true
Converted["_TextLabel5"].AnchorPoint = Vector2.new(0.5, 0.5)
Converted["_TextLabel5"].BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Converted["_TextLabel5"].BackgroundTransparency = 0.4000000059604645
Converted["_TextLabel5"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_TextLabel5"].BorderSizePixel = 0
Converted["_TextLabel5"].Position = UDim2.new(0.5, 0, 0.680000007, 0)
Converted["_TextLabel5"].Size = UDim2.new(1.39999998, 0, 0.740999997, 0)
Converted["_TextLabel5"].Parent = Converted["_CloseArea"]

Converted["_UICorner17"].Parent = Converted["_TextLabel5"]

Converted["_AllowForSpring"].Name = "AllowForSpring"
Converted["_AllowForSpring"].Parent = Converted["_CloseArea"]

Converted["_themedColor3"].Value = "backgroundColorCSQ"
Converted["_themedColor3"].Name = "themedColor"
Converted["_themedColor3"].Parent = Converted["_Menu"]

Converted["_UIGradient5"].Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(36.00000165402889, 36.00000165402889, 36.00000165402889)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(68.00000354647636, 68.00000354647636, 68.00000354647636))
}
Converted["_UIGradient5"].Offset = Vector2.new(0, 0.5)
Converted["_UIGradient5"].Rotation = 68
Converted["_UIGradient5"].Parent = Converted["_Menu"]

Converted["_Area"].AnchorPoint = Vector2.new(0.5, 0.5)
Converted["_Area"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Area"].BackgroundTransparency = 1
Converted["_Area"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Area"].BorderSizePixel = 0
Converted["_Area"].Position = UDim2.new(0.659600496, 0, 0.60637325, 0)
Converted["_Area"].Size = UDim2.new(0.643815279, 0, 0.783582091, 0)
Converted["_Area"].Name = "Area"
Converted["_Area"].Parent = Converted["_Menu"]

Converted["_Area1"].AutomaticCanvasSize = Enum.AutomaticSize.Y
Converted["_Area1"].CanvasSize = UDim2.new(0, 0, 0, 0)
Converted["_Area1"].ScrollBarThickness = 0
Converted["_Area1"].AnchorPoint = Vector2.new(0.5, 0.5)
Converted["_Area1"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Area1"].BackgroundTransparency = 1
Converted["_Area1"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Area1"].BorderSizePixel = 0
Converted["_Area1"].Position = UDim2.new(0.5, 0, 0.5, 0)
Converted["_Area1"].Selectable = false
Converted["_Area1"].Size = UDim2.new(1, 0, 1, 0)
Converted["_Area1"].Name = "Area"
Converted["_Area1"].Parent = Converted["_Area"]

Converted["_TextLabel6"].Font = Enum.Font.GothamBold
Converted["_TextLabel6"].Text = "3 years of keyless! Ã°Å¸Å½â°"
Converted["_TextLabel6"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel6"].TextSize = 14
Converted["_TextLabel6"].AnchorPoint = Vector2.new(0.5, 0.5)
Converted["_TextLabel6"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel6"].BackgroundTransparency = 1
Converted["_TextLabel6"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_TextLabel6"].BorderSizePixel = 0
Converted["_TextLabel6"].Position = UDim2.new(0.4923051, 0, 0.46438089, 0)
Converted["_TextLabel6"].Size = UDim2.new(0, 200, 0, 50)
Converted["_TextLabel6"].Parent = Converted["_Area1"]

Converted["_TextLabel7"].Font = Enum.Font.GothamBold
Converted["_TextLabel7"].Text = "YARHM"
Converted["_TextLabel7"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel7"].TextScaled = true
Converted["_TextLabel7"].TextSize = 14
Converted["_TextLabel7"].TextWrapped = true
Converted["_TextLabel7"].AnchorPoint = Vector2.new(0.5, 0.5)
Converted["_TextLabel7"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel7"].BackgroundTransparency = 1
Converted["_TextLabel7"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_TextLabel7"].BorderSizePixel = 0
Converted["_TextLabel7"].Position = UDim2.new(0.491272807, 0, 0.363785654, 0)
Converted["_TextLabel7"].Size = UDim2.new(0, 135, 0, 33)
Converted["_TextLabel7"].Parent = Converted["_Area1"]

Converted["_UICorner18"].Parent = Converted["_Area"]

Converted["_List"].AnchorPoint = Vector2.new(0, 0.5)
Converted["_List"].BackgroundColor3 = Color3.fromRGB(22.000000588595867, 22.000000588595867, 22.000000588595867)
Converted["_List"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_List"].BorderSizePixel = 0
Converted["_List"].Position = UDim2.new(0, 0, 0.606999993, 0)
Converted["_List"].Size = UDim2.new(0.315405339, 0, 0.785387993, 0)
Converted["_List"].Name = "List"
Converted["_List"].Parent = Converted["_Menu"]

Converted["_UICorner19"].CornerRadius = UDim.new(0, 16)
Converted["_UICorner19"].Parent = Converted["_List"]

Converted["_ScrollingFrame1"].AutomaticCanvasSize = Enum.AutomaticSize.Y
Converted["_ScrollingFrame1"].CanvasSize = UDim2.new(0, 0, 0, 0)
Converted["_ScrollingFrame1"].ScrollBarThickness = 2
Converted["_ScrollingFrame1"].VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Left
Converted["_ScrollingFrame1"].Active = true
Converted["_ScrollingFrame1"].AnchorPoint = Vector2.new(0.5, 0.5)
Converted["_ScrollingFrame1"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_ScrollingFrame1"].BackgroundTransparency = 1
Converted["_ScrollingFrame1"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_ScrollingFrame1"].BorderSizePixel = 0
Converted["_ScrollingFrame1"].Position = UDim2.new(0.478333294, 0, 0.408619136, 0)
Converted["_ScrollingFrame1"].Size = UDim2.new(1, 0, 0.795258284, 0)
Converted["_ScrollingFrame1"].Parent = Converted["_List"]

Converted["_UIListLayout4"].Padding = UDim.new(0, 3)
Converted["_UIListLayout4"].HorizontalAlignment = Enum.HorizontalAlignment.Center
Converted["_UIListLayout4"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIListLayout4"].Parent = Converted["_ScrollingFrame1"]

Converted["_UIPadding11"].PaddingLeft = UDim.new(0, 4)
Converted["_UIPadding11"].Parent = Converted["_ScrollingFrame1"]

Converted["_UIPadding12"].PaddingBottom = UDim.new(0, 10)
Converted["_UIPadding12"].PaddingLeft = UDim.new(0, 10)
Converted["_UIPadding12"].PaddingRight = UDim.new(0, 10)
Converted["_UIPadding12"].PaddingTop = UDim.new(0, 10)
Converted["_UIPadding12"].Parent = Converted["_List"]

Converted["_UIStroke6"].Color = Color3.fromRGB(255, 255, 255)
Converted["_UIStroke6"].Thickness = 0
Converted["_UIStroke6"].Parent = Converted["_List"]

Converted["_UIGradient6"].Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(111.00000098347664, 111.00000098347664, 111.00000098347664)),
	ColorSequenceKeypoint.new(0.6401384472846985, Color3.fromRGB(114.23875719308853, 114.23875719308853, 114.23875719308853)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
}
Converted["_UIGradient6"].Rotation = -44
Converted["_UIGradient6"].Parent = Converted["_UIStroke6"]

Converted["_AddCustomModule1"].Font = Enum.Font.Gotham
Converted["_AddCustomModule1"].Text = "+"
Converted["_AddCustomModule1"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_AddCustomModule1"].TextScaled = true
Converted["_AddCustomModule1"].TextSize = 14
Converted["_AddCustomModule1"].TextWrapped = true
Converted["_AddCustomModule1"].AnchorPoint = Vector2.new(1, 1)
Converted["_AddCustomModule1"].BackgroundColor3 = Color3.fromRGB(50.00000461935997, 50.00000461935997, 50.00000461935997)
Converted["_AddCustomModule1"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_AddCustomModule1"].BorderSizePixel = 0
Converted["_AddCustomModule1"].Position = UDim2.new(1, 0, 1, 0)
Converted["_AddCustomModule1"].Size = UDim2.new(0.215681866, 0, 0.142528668, 0)
Converted["_AddCustomModule1"].Visible = false
Converted["_AddCustomModule1"].Name = "AddCustomModule"
Converted["_AddCustomModule1"].Parent = Converted["_List"]

Converted["_UICorner20"].Parent = Converted["_AddCustomModule1"]

Converted["_UIPadding13"].PaddingLeft = UDim.new(0, 1)
Converted["_UIPadding13"].Parent = Converted["_AddCustomModule1"]

Converted["_UIStroke7"].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
Converted["_UIStroke7"].Color = Color3.fromRGB(255, 255, 255)
Converted["_UIStroke7"].Parent = Converted["_AddCustomModule1"]

Converted["_themedColor4"].Value = "secondaryColor"
Converted["_themedColor4"].Name = "themedColor"
Converted["_themedColor4"].Parent = Converted["_UIStroke7"]

Converted["_themedColor5"].Value = "primaryColor"
Converted["_themedColor5"].Name = "themedColor"
Converted["_themedColor5"].Parent = Converted["_AddCustomModule1"]

Converted["_themedColor6"].Value = "primaryColor"
Converted["_themedColor6"].Name = "themedColor"
Converted["_themedColor6"].Parent = Converted["_List"]

Converted["_UIScale3"].Parent = Converted["_Menu"]

Converted["_Stub"].BackgroundColor3 = Color3.fromRGB(22.000000588595867, 22.000000588595867, 22.000000588595867)
Converted["_Stub"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Stub"].BorderSizePixel = 0
Converted["_Stub"].Position = UDim2.new(0, 0, 0.214000002, 0)
Converted["_Stub"].Size = UDim2.new(0.0340136066, 0, 0.055970151, 0)
Converted["_Stub"].ZIndex = -9999
Converted["_Stub"].Name = "Stub"
Converted["_Stub"].Parent = Converted["_Menu"]

Converted["_themedColor7"].Value = "primaryColor"
Converted["_themedColor7"].Name = "themedColor"
Converted["_themedColor7"].Parent = Converted["_Stub"]

Converted["_Stub1"].AnchorPoint = Vector2.new(1, 1)
Converted["_Stub1"].BackgroundColor3 = Color3.fromRGB(22.000000588595867, 22.000000588595867, 22.000000588595867)
Converted["_Stub1"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Stub1"].BorderSizePixel = 0
Converted["_Stub1"].Position = UDim2.new(0.315192729, 0, 1, 0)
Converted["_Stub1"].Size = UDim2.new(0.0453514755, 0, 0.074626863, 0)
Converted["_Stub1"].ZIndex = -9999
Converted["_Stub1"].Name = "Stub"
Converted["_Stub1"].Parent = Converted["_Menu"]

Converted["_themedColor8"].Value = "primaryColor"
Converted["_themedColor8"].Name = "themedColor"
Converted["_themedColor8"].Parent = Converted["_Stub1"]

Converted["_Toggle"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Toggle"].BackgroundTransparency = 1
Converted["_Toggle"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Toggle"].BorderSizePixel = 0
Converted["_Toggle"].Size = UDim2.new(1, 0, 0, 35)
Converted["_Toggle"].Visible = false
Converted["_Toggle"].Name = "Toggle"
Converted["_Toggle"].Parent = Converted["_YARHM"]

Converted["_TextLabel8"].Font = Enum.Font.Unknown
Converted["_TextLabel8"].Text = "Loop walkspeed and FOV"
Converted["_TextLabel8"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel8"].TextScaled = true
Converted["_TextLabel8"].TextSize = 14
Converted["_TextLabel8"].TextWrapped = true
Converted["_TextLabel8"].TextXAlignment = Enum.TextXAlignment.Left
Converted["_TextLabel8"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel8"].BackgroundTransparency = 1
Converted["_TextLabel8"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_TextLabel8"].BorderSizePixel = 0
Converted["_TextLabel8"].Size = UDim2.new(0.699999988, 0, 0, 25)
Converted["_TextLabel8"].Parent = Converted["_Toggle"]

Converted["_UIListLayout5"].Padding = UDim.new(0, 25)
Converted["_UIListLayout5"].FillDirection = Enum.FillDirection.Horizontal
Converted["_UIListLayout5"].HorizontalAlignment = Enum.HorizontalAlignment.Center
Converted["_UIListLayout5"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIListLayout5"].VerticalAlignment = Enum.VerticalAlignment.Center
Converted["_UIListLayout5"].Parent = Converted["_Toggle"]

Converted["_Frame2"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Frame2"].BackgroundTransparency = 1
Converted["_Frame2"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Frame2"].BorderSizePixel = 0
Converted["_Frame2"].Size = UDim2.new(0.200000003, 0, 1, 0)
Converted["_Frame2"].Parent = Converted["_Toggle"]

Converted["_Frame3"].AnchorPoint = Vector2.new(0.5, 0.5)
Converted["_Frame3"].BackgroundColor3 = Color3.fromRGB(46.000001057982445, 46.000001057982445, 46.000001057982445)
Converted["_Frame3"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Frame3"].BorderSizePixel = 0
Converted["_Frame3"].Position = UDim2.new(0.5, 0, 0.5, 0)
Converted["_Frame3"].Size = UDim2.new(0, 89, 1, 0)
Converted["_Frame3"].Parent = Converted["_Frame2"]

Converted["_UICorner21"].CornerRadius = UDim.new(1, 0)
Converted["_UICorner21"].Parent = Converted["_Frame3"]

Converted["_Toggler"].Font = Enum.Font.SourceSans
Converted["_Toggler"].Text = ""
Converted["_Toggler"].TextColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Toggler"].TextSize = 14
Converted["_Toggler"].AnchorPoint = Vector2.new(0.5, 0.5)
Converted["_Toggler"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Toggler"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Toggler"].BorderSizePixel = 0
Converted["_Toggler"].Position = UDim2.new(0.300000012, 0, 0.5, 0)
Converted["_Toggler"].Size = UDim2.new(0.449438214, 0, 0.800000012, 0)
Converted["_Toggler"].Name = "Toggler"
Converted["_Toggler"].Parent = Converted["_Frame3"]

Converted["_UICorner22"].CornerRadius = UDim.new(1, 0)
Converted["_UICorner22"].Parent = Converted["_Toggler"]

Converted["_ImageLabel1"].Image = "rbxassetid://10002373478"
Converted["_ImageLabel1"].ImageColor3 = Color3.fromRGB(255, 0, 4.000000236555934)
-- Converted["_ImageLabel1"].ImageContent = Content{SourceType=Uri, Uri=rbxassetid://10002373478}
Converted["_ImageLabel1"].AnchorPoint = Vector2.new(0.5, 0.5)
Converted["_ImageLabel1"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_ImageLabel1"].BackgroundTransparency = 1
Converted["_ImageLabel1"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_ImageLabel1"].BorderSizePixel = 0
Converted["_ImageLabel1"].Position = UDim2.new(0.5, 0, 0.5, 0)
Converted["_ImageLabel1"].Size = UDim2.new(0, 20, 0, 20)
Converted["_ImageLabel1"].Parent = Converted["_Toggler"]

Converted["_UIPadding14"].PaddingRight = UDim.new(0.0700000003, 0)
Converted["_UIPadding14"].Parent = Converted["_Toggle"]

Converted["_Modules"].Name = "Modules"
Converted["_Modules"].Parent = Converted["_YARHM"]

Converted["_NotificationSample"].AnchorPoint = Vector2.new(0.5, 0)
Converted["_NotificationSample"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_NotificationSample"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_NotificationSample"].BorderSizePixel = 0
Converted["_NotificationSample"].ClipsDescendants = true
Converted["_NotificationSample"].Position = UDim2.new(0.5, 0, 0, 10)
Converted["_NotificationSample"].Size = UDim2.new(0, 400, 0, 50)
Converted["_NotificationSample"].Visible = false
Converted["_NotificationSample"].ZIndex = 5
Converted["_NotificationSample"].Name = "NotificationSample"
Converted["_NotificationSample"].Parent = Converted["_YARHM"]

Converted["_UICorner23"].CornerRadius = UDim.new(0, 10)
Converted["_UICorner23"].Parent = Converted["_NotificationSample"]

Converted["_UIStroke8"].Color = Color3.fromRGB(255, 255, 255)
Converted["_UIStroke8"].Thickness = 1.600000023841858
Converted["_UIStroke8"].Parent = Converted["_NotificationSample"]

Converted["_UIGradient7"].Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(46.000001057982445, 46.000001057982445, 46.000001057982445)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(12.000000234693289, 12.000000234693289, 12.000000234693289))
}
Converted["_UIGradient7"].Parent = Converted["_NotificationSample"]

Converted["_ImageLabel2"].Image = "rbxassetid://11780939099"
-- Converted["_ImageLabel2"].ImageContent = Content{SourceType=Uri, Uri=rbxassetid://11780939099}
Converted["_ImageLabel2"].ScaleType = Enum.ScaleType.Fit
Converted["_ImageLabel2"].AnchorPoint = Vector2.new(0.5, 0.5)
Converted["_ImageLabel2"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_ImageLabel2"].BackgroundTransparency = 1
Converted["_ImageLabel2"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_ImageLabel2"].BorderSizePixel = 0
Converted["_ImageLabel2"].Position = UDim2.new(0.100000001, 0, 0.5, 0)
Converted["_ImageLabel2"].Size = UDim2.new(0.0799999982, 0, 0.639999986, 0)
Converted["_ImageLabel2"].Parent = Converted["_NotificationSample"]

Converted["_TextLabel9"].Font = Enum.Font.Gotham
Converted["_TextLabel9"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel9"].TextScaled = true
Converted["_TextLabel9"].TextSize = 14
Converted["_TextLabel9"].TextWrapped = true
Converted["_TextLabel9"].TextXAlignment = Enum.TextXAlignment.Left
Converted["_TextLabel9"].AnchorPoint = Vector2.new(0.5, 0.5)
Converted["_TextLabel9"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel9"].BackgroundTransparency = 1
Converted["_TextLabel9"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_TextLabel9"].BorderSizePixel = 0
Converted["_TextLabel9"].Position = UDim2.new(0.5, 0, 0.5, 0)
Converted["_TextLabel9"].Size = UDim2.new(0.600000024, 0, 0.600000024, 0)
Converted["_TextLabel9"].Parent = Converted["_NotificationSample"]

Converted["_UITextSizeConstraint"].MaxTextSize = 30
Converted["_UITextSizeConstraint"].Parent = Converted["_TextLabel9"]

Converted["_Close"].Image = "rbxassetid://10002373478"
-- Converted["_Close"].ImageContent = Content{SourceType=Uri, Uri=rbxassetid://10002373478}
Converted["_Close"].ScaleType = Enum.ScaleType.Fit
Converted["_Close"].Active = false
Converted["_Close"].AnchorPoint = Vector2.new(0.5, 0.5)
Converted["_Close"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Close"].BackgroundTransparency = 1
Converted["_Close"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Close"].BorderSizePixel = 0
Converted["_Close"].Position = UDim2.new(0.899999976, 0, 0.5, 0)
Converted["_Close"].Selectable = false
Converted["_Close"].Size = UDim2.new(0.0799999982, 0, 0.639999986, 0)
Converted["_Close"].Name = "Close"
Converted["_Close"].Parent = Converted["_NotificationSample"]

Converted["_UICorner24"].Parent = Converted["_Close"]

Converted["_UIStroke9"].Color = Color3.fromRGB(255, 255, 255)
Converted["_UIStroke9"].Parent = Converted["_Close"]

Converted["_UIScale4"].Scale = 0.800000011920929
Converted["_UIScale4"].Parent = Converted["_NotificationSample"]

Converted["_themedColor9"].Value = "backgroundColorCSQ"
Converted["_themedColor9"].Name = "themedColor"
Converted["_themedColor9"].Parent = Converted["_NotificationSample"]

Converted["_Dialog"].AnchorPoint = Vector2.new(0.5, 1)
Converted["_Dialog"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Dialog"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Dialog"].BorderSizePixel = 0
Converted["_Dialog"].Position = UDim2.new(0.499000013, 0, 0.984000027, 0)
Converted["_Dialog"].Size = UDim2.new(0, 313, 0, 147)
Converted["_Dialog"].Visible = false
Converted["_Dialog"].ZIndex = 5
Converted["_Dialog"].Name = "Dialog"
Converted["_Dialog"].Parent = Converted["_YARHM"]

Converted["_UICorner25"].Parent = Converted["_Dialog"]

Converted["_UIGradient8"].Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(36.00000165402889, 36.00000165402889, 36.00000165402889)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(68.00000354647636, 68.00000354647636, 68.00000354647636))
}
Converted["_UIGradient8"].Rotation = -133
Converted["_UIGradient8"].Parent = Converted["_Dialog"]

Converted["_UIPadding15"].PaddingBottom = UDim.new(0, 15)
Converted["_UIPadding15"].PaddingLeft = UDim.new(0, 15)
Converted["_UIPadding15"].PaddingRight = UDim.new(0, 15)
Converted["_UIPadding15"].PaddingTop = UDim.new(0, 15)
Converted["_UIPadding15"].Parent = Converted["_Dialog"]

Converted["_UIStroke10"].Color = Color3.fromRGB(255, 255, 255)
Converted["_UIStroke10"].Thickness = 2
Converted["_UIStroke10"].Parent = Converted["_Dialog"]

Converted["_UIGradient9"].Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(111.00000098347664, 111.00000098347664, 111.00000098347664)),
	ColorSequenceKeypoint.new(0.6401384472846985, Color3.fromRGB(114.23875719308853, 114.23875719308853, 114.23875719308853)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
}
Converted["_UIGradient9"].Rotation = -107
Converted["_UIGradient9"].Parent = Converted["_UIStroke10"]

Converted["_DialogTitle"].Font = Enum.Font.Unknown
Converted["_DialogTitle"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_DialogTitle"].TextScaled = true
Converted["_DialogTitle"].TextSize = 14
Converted["_DialogTitle"].TextWrapped = true
Converted["_DialogTitle"].TextXAlignment = Enum.TextXAlignment.Right
Converted["_DialogTitle"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_DialogTitle"].BackgroundTransparency = 1
Converted["_DialogTitle"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_DialogTitle"].BorderSizePixel = 0
Converted["_DialogTitle"].Size = UDim2.new(0.997416437, 0, 0.16459392, 0)
Converted["_DialogTitle"].Name = "DialogTitle"
Converted["_DialogTitle"].Parent = Converted["_Dialog"]

Converted["_UIListLayout6"].Padding = UDim.new(0, 3)
Converted["_UIListLayout6"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIListLayout6"].Parent = Converted["_Dialog"]

Converted["_DialogDesc"].Font = Enum.Font.Unknown
Converted["_DialogDesc"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_DialogDesc"].TextScaled = true
Converted["_DialogDesc"].TextSize = 14
Converted["_DialogDesc"].TextWrapped = true
Converted["_DialogDesc"].TextXAlignment = Enum.TextXAlignment.Left
Converted["_DialogDesc"].TextYAlignment = Enum.TextYAlignment.Top
Converted["_DialogDesc"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_DialogDesc"].BackgroundTransparency = 1
Converted["_DialogDesc"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_DialogDesc"].BorderSizePixel = 0
Converted["_DialogDesc"].Position = UDim2.new(0, 0, 0.187079012, 0)
Converted["_DialogDesc"].Size = UDim2.new(0.997416437, 0, 0.604575336, 0)
Converted["_DialogDesc"].Name = "DialogDesc"
Converted["_DialogDesc"].Parent = Converted["_Dialog"]

Converted["_UITextSizeConstraint1"].MaxTextSize = 20
Converted["_UITextSizeConstraint1"].MinTextSize = 5
Converted["_UITextSizeConstraint1"].Parent = Converted["_DialogDesc"]

Converted["_Options"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Options"].BackgroundTransparency = 1
Converted["_Options"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Options"].BorderSizePixel = 0
Converted["_Options"].Position = UDim2.new(0, 0, 0.82045126, 0)
Converted["_Options"].Size = UDim2.new(0.997436285, 0, 0.241758227, 0)
Converted["_Options"].Name = "Options"
Converted["_Options"].Parent = Converted["_Dialog"]

Converted["_UIListLayout7"].Padding = UDim.new(0, 10)
Converted["_UIListLayout7"].FillDirection = Enum.FillDirection.Horizontal
Converted["_UIListLayout7"].HorizontalAlignment = Enum.HorizontalAlignment.Center
Converted["_UIListLayout7"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIListLayout7"].Parent = Converted["_Options"]

Converted["_OptionPlaceholder"].Font = Enum.Font.GothamBold
Converted["_OptionPlaceholder"].RichText = true
Converted["_OptionPlaceholder"].Text = "aaaaaaaaaaa"
Converted["_OptionPlaceholder"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_OptionPlaceholder"].TextScaled = true
Converted["_OptionPlaceholder"].TextSize = 100
Converted["_OptionPlaceholder"].TextWrapped = true
Converted["_OptionPlaceholder"].BackgroundColor3 = Color3.fromRGB(36.00000165402889, 36.00000165402889, 36.00000165402889)
Converted["_OptionPlaceholder"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_OptionPlaceholder"].BorderSizePixel = 0
Converted["_OptionPlaceholder"].Size = UDim2.new(0.532000005, -5, 1.00899994, 0)
Converted["_OptionPlaceholder"].Visible = false
Converted["_OptionPlaceholder"].Name = "OptionPlaceholder"
Converted["_OptionPlaceholder"].Parent = Converted["_Options"]

Converted["_UIPadding16"].PaddingBottom = UDim.new(0, 1)
Converted["_UIPadding16"].PaddingLeft = UDim.new(0, 15)
Converted["_UIPadding16"].PaddingRight = UDim.new(0, 15)
Converted["_UIPadding16"].PaddingTop = UDim.new(0, 1)
Converted["_UIPadding16"].Parent = Converted["_OptionPlaceholder"]

Converted["_UICorner26"].Parent = Converted["_OptionPlaceholder"]

Converted["_UIStroke11"].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
Converted["_UIStroke11"].Color = Color3.fromRGB(255, 255, 255)
Converted["_UIStroke11"].Thickness = 2
Converted["_UIStroke11"].Parent = Converted["_OptionPlaceholder"]

Converted["_UIGradient10"].Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(111.00000098347664, 111.00000098347664, 111.00000098347664)),
	ColorSequenceKeypoint.new(0.6401384472846985, Color3.fromRGB(114.23875719308853, 114.23875719308853, 114.23875719308853)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
}
Converted["_UIGradient10"].Rotation = -107
Converted["_UIGradient10"].Parent = Converted["_UIStroke11"]

Converted["_themedColor10"].Value = "primaryColor"
Converted["_themedColor10"].Name = "themedColor"
Converted["_themedColor10"].Parent = Converted["_OptionPlaceholder"]

Converted["_OnSelect"].Name = "OnSelect"
Converted["_OnSelect"].Parent = Converted["_Dialog"]

Converted["_UIScale5"].Parent = Converted["_Dialog"]

Converted["_themedColor11"].Value = "backgroundColorCSQ"
Converted["_themedColor11"].Name = "themedColor"
Converted["_themedColor11"].Parent = Converted["_Dialog"]

Converted["_Range"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Range"].BackgroundTransparency = 1
Converted["_Range"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Range"].BorderSizePixel = 0
Converted["_Range"].Size = UDim2.new(1, 0, 0, 35)
Converted["_Range"].Visible = false
Converted["_Range"].Name = "Range"
Converted["_Range"].Parent = Converted["_YARHM"]

Converted["_TextLabel10"].Font = Enum.Font.Unknown
Converted["_TextLabel10"].Text = "something something idk lol"
Converted["_TextLabel10"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel10"].TextScaled = true
Converted["_TextLabel10"].TextSize = 58
Converted["_TextLabel10"].TextWrapped = true
Converted["_TextLabel10"].TextXAlignment = Enum.TextXAlignment.Left
Converted["_TextLabel10"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TextLabel10"].BackgroundTransparency = 1
Converted["_TextLabel10"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_TextLabel10"].BorderSizePixel = 0
Converted["_TextLabel10"].Position = UDim2.new(-0.0633024424, 0, 0.685714304, 0)
Converted["_TextLabel10"].Size = UDim2.new(0, 125, 0, 25)
Converted["_TextLabel10"].Parent = Converted["_Range"]

Converted["_UIListLayout8"].HorizontalFlex = Enum.UIFlexAlignment.Fill
Converted["_UIListLayout8"].Padding = UDim.new(0, 15)
Converted["_UIListLayout8"].VerticalFlex = Enum.UIFlexAlignment.SpaceAround
Converted["_UIListLayout8"].FillDirection = Enum.FillDirection.Horizontal
Converted["_UIListLayout8"].HorizontalAlignment = Enum.HorizontalAlignment.Center
Converted["_UIListLayout8"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIListLayout8"].VerticalAlignment = Enum.VerticalAlignment.Center
Converted["_UIListLayout8"].Parent = Converted["_Range"]

Converted["_UIPadding17"].Parent = Converted["_Range"]

Converted["_Frame4"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Frame4"].BackgroundTransparency = 1
Converted["_Frame4"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Frame4"].BorderSizePixel = 0
Converted["_Frame4"].Size = UDim2.new(0.400000006, 0, 1, 0)
Converted["_Frame4"].Parent = Converted["_Range"]

Converted["_UIPadding18"].PaddingBottom = UDim.new(0, 7)
Converted["_UIPadding18"].PaddingLeft = UDim.new(0, 7)
Converted["_UIPadding18"].PaddingRight = UDim.new(0, 7)
Converted["_UIPadding18"].PaddingTop = UDim.new(0, 7)
Converted["_UIPadding18"].Parent = Converted["_Frame4"]

Converted["_UICorner27"].Parent = Converted["_Frame4"]

Converted["_Track"].AnchorPoint = Vector2.new(0.5, 0.5)
Converted["_Track"].BackgroundColor3 = Color3.fromRGB(22.000000588595867, 22.000000588595867, 22.000000588595867)
Converted["_Track"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Track"].BorderSizePixel = 0
Converted["_Track"].Position = UDim2.new(0.5, 0, 0.5, 0)
Converted["_Track"].Size = UDim2.new(1, 0, 1.20000005, 0)
Converted["_Track"].Name = "Track"
Converted["_Track"].Parent = Converted["_Frame4"]

Converted["_UICorner28"].CornerRadius = UDim.new(0, 6)
Converted["_UICorner28"].Parent = Converted["_Track"]

Converted["_Ball"].Font = Enum.Font.SourceSans
Converted["_Ball"].Text = ""
Converted["_Ball"].TextColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Ball"].TextSize = 14
Converted["_Ball"].AnchorPoint = Vector2.new(0, 0.5)
Converted["_Ball"].BackgroundColor3 = Color3.fromRGB(197.0000034570694, 0, 0)
Converted["_Ball"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Ball"].BorderSizePixel = 0
Converted["_Ball"].Interactable = false
Converted["_Ball"].Position = UDim2.new(1.32920917e-07, 0, 0.5, 0)
Converted["_Ball"].Size = UDim2.new(0.0599999987, 0, 1, 0)
Converted["_Ball"].Name = "Ball"
Converted["_Ball"].Parent = Converted["_Track"]

Converted["_BallProgress"].Font = Enum.Font.GothamBold
Converted["_BallProgress"].Text = "0"
Converted["_BallProgress"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_BallProgress"].TextScaled = true
Converted["_BallProgress"].TextSize = 14
Converted["_BallProgress"].TextTransparency = 1
Converted["_BallProgress"].TextWrapped = true
Converted["_BallProgress"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_BallProgress"].BackgroundTransparency = 1
Converted["_BallProgress"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_BallProgress"].BorderSizePixel = 0
Converted["_BallProgress"].Size = UDim2.new(1, 0, 1, 0)
Converted["_BallProgress"].Name = "BallProgress"
Converted["_BallProgress"].Parent = Converted["_Ball"]

Converted["_UIPadding19"].PaddingBottom = UDim.new(0, 2)
Converted["_UIPadding19"].PaddingTop = UDim.new(0, 1)
Converted["_UIPadding19"].Parent = Converted["_Ball"]

Converted["_themedColor12"].Value = "accentColor"
Converted["_themedColor12"].Name = "themedColor"
Converted["_themedColor12"].Parent = Converted["_Ball"]

Converted["_UICorner29"].CornerRadius = UDim.new(1, 0)
Converted["_UICorner29"].Parent = Converted["_Ball"]

Converted["_UIPadding20"].PaddingBottom = UDim.new(0, 6)
Converted["_UIPadding20"].PaddingLeft = UDim.new(0, 6)
Converted["_UIPadding20"].PaddingRight = UDim.new(0, 6)
Converted["_UIPadding20"].PaddingTop = UDim.new(0, 6)
Converted["_UIPadding20"].Parent = Converted["_Track"]

Converted["_TrackProgress"].Font = Enum.Font.GothamBold
Converted["_TrackProgress"].Text = "0"
Converted["_TrackProgress"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TrackProgress"].TextScaled = true
Converted["_TrackProgress"].TextSize = 14
Converted["_TrackProgress"].TextTransparency = 1
Converted["_TrackProgress"].TextWrapped = true
Converted["_TrackProgress"].TextXAlignment = Enum.TextXAlignment.Right
Converted["_TrackProgress"].AnchorPoint = Vector2.new(1, 0.5)
Converted["_TrackProgress"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_TrackProgress"].BackgroundTransparency = 1
Converted["_TrackProgress"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_TrackProgress"].BorderSizePixel = 0
Converted["_TrackProgress"].Position = UDim2.new(1, 0, 0.5, 0)
Converted["_TrackProgress"].Size = UDim2.new(0, 35, 1, 0)
Converted["_TrackProgress"].Name = "TrackProgress"
Converted["_TrackProgress"].Parent = Converted["_Track"]

Converted["_themedColor13"].Value = "primaryColor"
Converted["_themedColor13"].Name = "themedColor"
Converted["_themedColor13"].Parent = Converted["_Track"]

Converted["_UISizeConstraint"].Parent = Converted["_Frame4"]

Converted["_FloatingButtonSetting"].AnchorPoint = Vector2.new(0.5, 0.5)
Converted["_FloatingButtonSetting"].BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Converted["_FloatingButtonSetting"].BackgroundTransparency = 0.5
Converted["_FloatingButtonSetting"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_FloatingButtonSetting"].BorderSizePixel = 0
Converted["_FloatingButtonSetting"].Position = UDim2.new(0.5, 0, 0.5, 0)
Converted["_FloatingButtonSetting"].Size = UDim2.new(1, 0, 1, 0)
Converted["_FloatingButtonSetting"].Visible = false
Converted["_FloatingButtonSetting"].ZIndex = 10
Converted["_FloatingButtonSetting"].Name = "FloatingButtonSetting"
Converted["_FloatingButtonSetting"].Parent = Converted["_YARHM"]

Converted["_ControlBarContainer"].AnchorPoint = Vector2.new(0.5, 1)
Converted["_ControlBarContainer"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_ControlBarContainer"].BackgroundTransparency = 1
Converted["_ControlBarContainer"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_ControlBarContainer"].BorderSizePixel = 0
Converted["_ControlBarContainer"].Position = UDim2.new(0.5, 0, 1, -50)
Converted["_ControlBarContainer"].Size = UDim2.new(1, 0, 0, 40)
Converted["_ControlBarContainer"].Name = "ControlBarContainer"
Converted["_ControlBarContainer"].Parent = Converted["_FloatingButtonSetting"]

Converted["_ControlBar"].AnchorPoint = Vector2.new(0.5, 1)
Converted["_ControlBar"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_ControlBar"].BackgroundTransparency = 1
Converted["_ControlBar"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_ControlBar"].BorderSizePixel = 0
Converted["_ControlBar"].Position = UDim2.new(0.5, 0, 1, -30)
Converted["_ControlBar"].Size = UDim2.new(1, 0, 0, 40)
Converted["_ControlBar"].Name = "ControlBar"
Converted["_ControlBar"].Parent = Converted["_ControlBarContainer"]

Converted["_UIListLayout9"].Padding = UDim.new(0, 5)
Converted["_UIListLayout9"].FillDirection = Enum.FillDirection.Horizontal
Converted["_UIListLayout9"].HorizontalAlignment = Enum.HorizontalAlignment.Center
Converted["_UIListLayout9"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIListLayout9"].Parent = Converted["_ControlBar"]

Converted["_Visibility"].Font = Enum.Font.Gotham
Converted["_Visibility"].Text = "Toggle visibility"
Converted["_Visibility"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Visibility"].TextScaled = true
Converted["_Visibility"].TextSize = 14
Converted["_Visibility"].TextWrapped = true
Converted["_Visibility"].BackgroundColor3 = Color3.fromRGB(46.000001057982445, 46.000001057982445, 46.000001057982445)
Converted["_Visibility"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Visibility"].BorderSizePixel = 0
Converted["_Visibility"].Size = UDim2.new(0, 200, 1, 0)
Converted["_Visibility"].Name = "Visibility"
Converted["_Visibility"].Parent = Converted["_ControlBar"]

Converted["_UICorner30"].CornerRadius = UDim.new(0, 16)
Converted["_UICorner30"].Parent = Converted["_Visibility"]

Converted["_UIPadding21"].PaddingBottom = UDim.new(0, 7)
Converted["_UIPadding21"].PaddingLeft = UDim.new(0, 7)
Converted["_UIPadding21"].PaddingRight = UDim.new(0, 7)
Converted["_UIPadding21"].PaddingTop = UDim.new(0, 7)
Converted["_UIPadding21"].Parent = Converted["_Visibility"]

Converted["_Event"].Parent = Converted["_Visibility"]

Converted["_themedColor14"].Value = "primaryColor"
Converted["_themedColor14"].Name = "themedColor"
Converted["_themedColor14"].Parent = Converted["_Visibility"]

Converted["_Lock1"].Font = Enum.Font.Gotham
Converted["_Lock1"].Text = "Toggle lock"
Converted["_Lock1"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Lock1"].TextScaled = true
Converted["_Lock1"].TextSize = 14
Converted["_Lock1"].TextWrapped = true
Converted["_Lock1"].BackgroundColor3 = Color3.fromRGB(46.000001057982445, 46.000001057982445, 46.000001057982445)
Converted["_Lock1"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Lock1"].BorderSizePixel = 0
Converted["_Lock1"].Size = UDim2.new(0, 200, 1, 0)
Converted["_Lock1"].Name = "Lock"
Converted["_Lock1"].Parent = Converted["_ControlBar"]

Converted["_UICorner31"].CornerRadius = UDim.new(0, 16)
Converted["_UICorner31"].Parent = Converted["_Lock1"]

Converted["_UIPadding22"].PaddingBottom = UDim.new(0, 7)
Converted["_UIPadding22"].PaddingLeft = UDim.new(0, 7)
Converted["_UIPadding22"].PaddingRight = UDim.new(0, 7)
Converted["_UIPadding22"].PaddingTop = UDim.new(0, 7)
Converted["_UIPadding22"].Parent = Converted["_Lock1"]

Converted["_Event1"].Parent = Converted["_Lock1"]

Converted["_themedColor15"].Value = "primaryColor"
Converted["_themedColor15"].Name = "themedColor"
Converted["_themedColor15"].Parent = Converted["_Lock1"]

Converted["_Exit"].Font = Enum.Font.GothamBold
Converted["_Exit"].Text = "X"
Converted["_Exit"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Exit"].TextScaled = true
Converted["_Exit"].TextSize = 14
Converted["_Exit"].TextWrapped = true
Converted["_Exit"].BackgroundColor3 = Color3.fromRGB(46.000001057982445, 0, 0)
Converted["_Exit"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Exit"].BorderSizePixel = 0
Converted["_Exit"].Size = UDim2.new(1, 0, 1, 0)
Converted["_Exit"].Name = "Exit"
Converted["_Exit"].Parent = Converted["_ControlBar"]

Converted["_UICorner32"].CornerRadius = UDim.new(0, 16)
Converted["_UICorner32"].Parent = Converted["_Exit"]

Converted["_UIPadding23"].PaddingBottom = UDim.new(0, 7)
Converted["_UIPadding23"].PaddingLeft = UDim.new(0, 7)
Converted["_UIPadding23"].PaddingRight = UDim.new(0, 7)
Converted["_UIPadding23"].PaddingTop = UDim.new(0, 7)
Converted["_UIPadding23"].Parent = Converted["_Exit"]

Converted["_UIAspectRatioConstraint"].Parent = Converted["_Exit"]

Converted["_themedColor16"].Value = "secondaryColor"
Converted["_themedColor16"].Name = "themedColor"
Converted["_themedColor16"].Parent = Converted["_Exit"]

Converted["_UIListLayout10"].Padding = UDim.new(0, 5)
Converted["_UIListLayout10"].HorizontalAlignment = Enum.HorizontalAlignment.Center
Converted["_UIListLayout10"].SortOrder = Enum.SortOrder.LayoutOrder
Converted["_UIListLayout10"].Parent = Converted["_ControlBarContainer"]

Converted["_Tip"].Font = Enum.Font.GothamBold
Converted["_Tip"].Text = "Drag the button around to resize!"
Converted["_Tip"].TextColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Tip"].TextScaled = true
Converted["_Tip"].TextSize = 14
Converted["_Tip"].TextWrapped = true
Converted["_Tip"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_Tip"].BackgroundTransparency = 1
Converted["_Tip"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_Tip"].BorderSizePixel = 0
Converted["_Tip"].Size = UDim2.new(1, 0, 0, 10)
Converted["_Tip"].Name = "Tip"
Converted["_Tip"].Parent = Converted["_ControlBarContainer"]

Converted["_UIStroke12"].Parent = Converted["_Tip"]

Converted["_UIScale6"].Parent = Converted["_ControlBarContainer"]

Converted["_FloatingButtons"].AnchorPoint = Vector2.new(0.5, 0.5)
Converted["_FloatingButtons"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_FloatingButtons"].BackgroundTransparency = 1
Converted["_FloatingButtons"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_FloatingButtons"].BorderSizePixel = 0
Converted["_FloatingButtons"].Position = UDim2.new(0.5, 0, 0.5, 0)
Converted["_FloatingButtons"].Size = UDim2.new(1, 0, 1, 0)
Converted["_FloatingButtons"].ZIndex = 3
Converted["_FloatingButtons"].Name = "FloatingButtons"
Converted["_FloatingButtons"].Parent = Converted["_FloatingButtonSetting"]

Converted["_FloatingButtons1"].AnchorPoint = Vector2.new(0.5, 0.5)
Converted["_FloatingButtons1"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Converted["_FloatingButtons1"].BackgroundTransparency = 1
Converted["_FloatingButtons1"].BorderColor3 = Color3.fromRGB(0, 0, 0)
Converted["_FloatingButtons1"].BorderSizePixel = 0
Converted["_FloatingButtons1"].Position = UDim2.new(0.5, 0, 0.5, 0)
Converted["_FloatingButtons1"].Size = UDim2.new(1, 0, 1, 0)
Converted["_FloatingButtons1"].ZIndex = 3
Converted["_FloatingButtons1"].Name = "FloatingButtons"
Converted["_FloatingButtons1"].Parent = Converted["_YARHM"]

-- Routine Module Scripts:

local routine_module_scripts = {}

do -- Routine Module: StarterGui.YARHM.FUNCTIONS
    local script = Instance.new("ModuleScript")
    script.Name = "FUNCTIONS"
    script.Parent = Converted["_YARHM"]
    local function module_script()

		local FUNCTIONSmodule = {}
		FUNCTIONSmodule.__v = "1.21"
		
		local ts = game:GetService("TweenService")
		local https = game:GetService("HttpService")
		
		
			
			
		function DraggableObjectf()
			local function a(b,c)local d=c.AbsoluteSize;local e=c.AbsolutePosition;local f=b.X.Scale*d.X+b.X.Offset;local g=b.Y.Scale*d.Y+b.Y.Offset;local h=math.clamp(f,0,d.X)local i=math.clamp(g,0,d.Y)local j=UDim2.new(b.X.Scale,h-b.X.Scale*d.X,b.Y.Scale,i-b.Y.Scale*d.Y)return j end;local k=UDim2.new;local l=game:GetService("UserInputService")local m=game:GetService("TweenService")local n={}n.__index=n;function n.new(o,p,q,r)local self={}self.Object=o;self.ToMove=p;self.Smooth=q;self.CallbackOnly=r;self.CanBeDragged=false;self.DragStarted=nil;self.DragEnded=nil;self.Dragged=nil;self.Dragging=false;self.LastPosition=nil;self.Velocity=Vector2.new(0,0)setmetatable(self,n)return self end;function n:Enable()self.CanBeDragged=true;local s=self.Object;local t=self.ToMove;local u=nil;local v=nil;local w=nil;local x=false;local function y(z)local A=z.Position-v;local B=UDim2.new(w.X.Scale,w.X.Offset+A.X,w.Y.Scale,w.Y.Offset+A.Y)if self.CallbackOnly then else B=a(B,self.Object:FindFirstAncestorWhichIsA("ScreenGui"))if(self.Smooth==nil or self.Smooth==true)and self.Smooth~=false then m:Create(t and t or s,TweenInfo.new(0.5,Enum.EasingStyle.Cubic,Enum.EasingDirection.Out),{Position=B}):Play()else local C=t and t or s;C.Position=B end end;return B end;self.InputBegan=s.InputBegan:Connect(function(z)if z.UserInputType==Enum.UserInputType.MouseButton1 or z.UserInputType==Enum.UserInputType.Touch then x=true;local D;D=z.Changed:Connect(function()if z.UserInputState==Enum.UserInputState.End and(self.Dragging or x)then self.Dragging=false;D:Disconnect()if self.DragEnded and not x then self.DragEnded(self.Velocity)end;x=false end end)end end)self.InputChanged=s.InputChanged:Connect(function(z)if z.UserInputType==Enum.UserInputType.MouseMovement or z.UserInputType==Enum.UserInputType.Touch then u=z end end)self.InputChanged2=l.InputChanged:Connect(function(z)if s.Parent==nil then self:Disable()return end;if x then x=false;if self.DragStarted then self.DragStarted()end;self.Dragging=true;v=z.Position;if t then w=t.Position else w=s.Position end;self.LastPosition=z.Position end;if z==u and self.Dragging then local B=y(z)self.Velocity=z.Position-self.LastPosition;self.LastPosition=z.Position;if self.Dragged then self.Dragged(B)end end end)end;function n:Disable()self.CanBeDragged=false;self.InputBegan:Disconnect()self.InputChanged:Disconnect()self.InputChanged2:Disconnect()if self.Dragging then self.Dragging=false;if self.DragEnded then self.DragEnded(self.Velocity)end end end;return n	
		end
		local DraggableObject = DraggableObjectf()
		
		function ClickAndHoldf()
			local a={}a.__index=a;local b=game:GetService("UserInputService")function a.new(c,d)local self=setmetatable({},a)self.textButton=c;self.holdTime=d or 0.5;self.holdTask=nil;self.initialPosition=nil;self.Holded=Instance.new("BindableEvent")local function e(f,g)return math.sqrt((g.X-f.X)^2+(g.Y-f.Y)^2)end;self.textButton.MouseButton1Down:Connect(function(h,i)self.initialPosition=Vector2.new(h,i)self.holdTask=task.spawn(function()task.wait(self.holdTime)if self.holdTask then self.Holded:Fire()end end)end)b.InputChanged:Connect(function(j)if j.UserInputType==Enum.UserInputType.MouseMovement or j.UserInputType==Enum.UserInputType.Touch then if self.holdTask and self.initialPosition then local k=j.Position;local l=e(self.initialPosition,k)if l>10 then coroutine.close(self.holdTask)self.holdTask=nil end end end end)b.InputEnded:Connect(function(j)if j.UserInputType==Enum.UserInputType.MouseButton1 or j.UserInputType==Enum.UserInputType.Touch then if self.holdTask then coroutine.close(self.holdTask)self.holdTask=nil end;self.initialPosition=nil end end)return self end;return a
		end
		local ClickAndHold = ClickAndHoldf()
		function PointSavef()
			local _=false local function d(...)if _ then print("[PointSave DEBUG]:",...)end end getgenv()._FOLDERS=getgenv()._FOLDERS or{} getgenv()._FILES=getgenv()._FILES or{} isfolder=isfolder or function(_)d("Checking if folder exists:",_) return getgenv()._FOLDERS[_]~=nil end makefolder=makefolder or function(_)d("Creating folder:",_) getgenv()._FOLDERS[_]={} return getgenv()._FOLDERS[_]end isfile=isfile or function(_)d("Checking if file exists:",_) return getgenv()._FILES[_]~=nil end writefile=writefile or function(a,_)d("Writing file:",a,"with content:",_) getgenv()._FILES[a]=_ return getgenv()._FILES[a]end readfile=readfile or function(_)d("Reading file:",_) return getgenv()._FILES[_]end delfile=delfile or function(_)d("Deleting file:",_) getgenv()._FILES[_]=nil end listfiles=listfiles or function(c)d("Listing files in folder:",c) local _=getgenv()._FOLDERS[c] if _ then local a={} for b,_ in pairs(getgenv()._FILES)do if b:sub(1,#c+1)==c.."/"then local _=b:sub(#c+2) d("Found file in folder:",_) table.insert(a,_)end end return a end d("Folder does not exist:",c) return{}end local b={} b.__index=b local c="PointSaveData" local function _()if not isfolder(c)then d("Base folder not found, creating:",c) makefolder(c)else d("Base folder already exists:",c)end end function b.new(a)d("Initializing new PointSave instance for namespace:",a) _() local _=setmetatable({},b) _.namespace=a _.folderPath=c.."/"..a if not isfolder(_.folderPath)then d("Namespace folder does not exist, creating:",_.folderPath) makefolder(_.folderPath)else d("Namespace folder already exists:",_.folderPath)end return _ end function b:set(b,a)local _=self.folderPath.."/"..b..".txt" d("Setting value for key:",b,"->",a) writefile(_,tostring(a))end function b:get(a)local _=self.folderPath.."/"..a..".txt" d("Getting value for key:",a) if isfile(_)then local _=readfile(_) d("Found value for key:",a,"->",_) return _ end d("Key not found:",a) return nil end function b:remove(a)local _=self.folderPath.."/"..a..".txt" d("Removing key:",a) if isfile(_)then delfile(_) d("Removed file for key:",a)else d("File for key does not exist:",a)end end function b:clear()d("Clearing all keys in namespace:",self.namespace) local _=listfiles(self.folderPath) for _,_ in ipairs(_)do local _=self.folderPath.."/".._ if isfile(_)then d("Deleting file:",_) delfile(_)end end end function b.deleteNamespace(a)local b=c.."/"..a d("Deleting namespace:",a) local _=listfiles(b) for _,_ in ipairs(_)do local _=b.."/".._ if isfile(_)then d("Deleting file from namespace:",_) delfile(_)end end getgenv()._FOLDERS[b]=nil d("Deleted folder for namespace:",a)end function b.listNamespaces()d("Listing all namespaces") _() local b={} for a,_ in pairs(getgenv()._FOLDERS)do if a:sub(1,#c+1)==c.."/"then local _=a:sub(#c+2) d("Found namespace:",_) table.insert(b,_)end end return b end return b
		end
		local PointSave = PointSavef()
		function SBTf()
			-- Spring-based tweening module
			-- Implementation by YARHM Team, respective credits towards the original creators for spring physics
		
			local a=function()local a=function()local a={}local function b(c,d,e,f,g,h)local i=d*d-4*e/c;local j=-0.5;local k=d+math.sqrt(i)local l=d-math.sqrt(i)local m,n=j*k,j*l;local o,p=(n*f-g)/(n-m),(m*f-g)/(m-n)local q=h/e;return{Offset=function(r)return o*math.exp(m*r)+p*math.exp(n*r)+q end,Velocity=function(r)return o*m*math.exp(m*r)+p*n*math.exp(n*r)end,Acceleration=function(r)return o*m*m*math.exp(m*r)+p*n*n*math.exp(n*r)end}end;local function s(c,d,e,f,g,h)local i=-d/2;local j,k=f,g-i*f;local l=h/e;return{Offset=function(m)return math.exp(i*m)*(j+k*m)+l end,Velocity=function(m)return math.exp(i*m)*(k*i*m+j*i+k)end,Acceleration=function(m)return i*math.exp(i*m)*(k*i*m+j*i+2*k)end}end;local function t(c,d,e,f,g,h)local i=d*d-4*e/c;local j=-d/2;local k=math.sqrt(-i)local l,m=f,(g-j*f)/k;local n=h/e;return{Offset=function(o)return math.exp(j*o)*(l*math.cos(k*o)+m*math.sin(k*o))+n end,Velocity=function(o)return-math.exp(j*o)*((l*k-m*j)*math.sin(k*o)+(-m*k-l*j)*math.cos(k*o))end,Acceleration=function(o)return-math.exp(j*o)*((m*k*k+2*l*j*k-m*j*j)*math.sin(k*o)+(l*k*k-2*m*j*k-l*j*j)*math.cos(k*o))end}end;function a.F(c)local d,e,f=c.InitialOffset,c.InitialVelocity,c.ExternalForce;local g,h,i=c.Mass,c.Damping,c.Constant;local j=h*h-4*i/g;if j>0 then return b(g,h,i,d,e,f)elseif j==0 then return s(g,h,i,d,e,f)else return t(g,h,i,d,e,f)end end;return a end;local c=a()local d=math.sqrt;local e=math.pi;local f={OFFSET="Offset",VELOCITY="Velocity",ACCELERATION="Acceleration",GOAL="Goal",FREQUENCY="Frequency"}local g=""local h=""local i={}local j={}j.__index=function(k,l)local m={[f.OFFSET]=function()local m=tick()-k.StartTick;local n=k.F;local o=n.Offset(m)return o end,[f.VELOCITY]=function()local m=tick()-k.StartTick;local n=k.F;local o=n.Velocity(m)return o end,[f.ACCELERATION]=function()local m=tick()-k.StartTick;local n=k.F;local o=n.Acceleration(m)return o end,[f.GOAL]=function()local m=k.ExternalForce;local n=k.Constant;return m/n end,[f.FREQUENCY]=function()local m=k.Damping;local n=k.Constant;local o=k.Mass;return d(-m*m+4*n/o)/(2*e)end}local n=rawget(k,l)if n~=nil then return n end;local o=m[l]if o~=nil then return o()end;return j[l]end;j.__tostring=function(k)local l=tick()-k.StartTick;local m=k.F;local n=k.AdvancedObjectStringEnabled;local o;if not n then o=string.format(g,m.Offset(l),m.Velocity(l),m.Acceleration(l))else o=string.format(h,k.Mass,k.Damping,k.Constant,k.Goal,k.Frequency,k.InitialOffset,k.InitialVelocity,k.ExternalForce,k.StartTick,m.Offset(l),m.Velocity(l),m.Acceleration(l))end;return o end;function i.fromDurationAndBounce(k,l)local m=1;local n=(2*math.pi/k)^2*m;local o=2*l*math.sqrt(m*n)return{m,o,n}end;function i.new(k,l,m,n,o,p)assert(k>0,"Mass for spring system cannot be less than or equal to 0")assert(m>0,"Spring constant for spring system cannot be less than or equal to 0")n=n or 0;o=o or 0;p=p or 0;local q=p*m;local r={Mass=k,Damping=l,Constant=m,InitialOffset=n-p,InitialVelocity=o,ExternalForce=q,AdvancedObjectStringEnabled=false,StartTick=0}setmetatable(r,j)r:Reset()return r end;function i.fromFrequency(k,l,m,n,o,p)assert(k>0,"Mass for spring system cannot be less than or equal to 0")assert(m>0,"Spring frequency for spring system cannot be less than or equal to 0")local q=0.25*k*(4*e*e*m*m+l*l)n=n or 0;o=o or 0;p=p or 0;local r=p*q;local u={Mass=k,Damping=l,Constant=q,InitialOffset=n-p,InitialVelocity=o,ExternalForce=r,AdvancedObjectStringEnabled=false,StartTick=0}setmetatable(u,j)u:Reset()return u end;function j.Reset(k)k.F=c.F(k)k.StartTick=tick()end;function j.SetExternalForce(k,l)k.ExternalForce=l;k.InitialOffset=k.Offset-l/k.Constant;k.InitialVelocity=k.Velocity;k:Reset()end;function j.SetGoal(k,l)k.ExternalForce=l*k.Constant;k.InitialOffset=k.Offset-l;k.InitialVelocity=k.Velocity;k:Reset()end;function j.SetFrequency(k,l)k.Constant=0.25*k.Mass*(4*e*e*l*l+k.Damping*k.Damping)k.InitialOffset=k.Offset;k.InitialVelocity=k.Velocity;k:Reset()end;function j.SnapToCriticalDamping(k)k.Damping=2*d(k.Constant/k.Mass)k.InitialOffset=k.Offset;k.InitialVelocity=k.Velocity;k:Reset()end;function j.SetOffset(k,l,m)k.InitialOffset=l-k.Goal;k.InitialVelocity=m and 0 or k.Velocity;k:Reset()end;function j.AddOffset(k,l)k.InitialOffset=k.Offset+l;k.InitialVelocity=k.Velocity;k:Reset()end;function j.SetVelocity(k,l)k.InitialOffset=k.Offset;k.InitialVelocity=l;k:Reset()end;function j.AddVelocity(k,l)k.InitialOffset=k.Offset;k.InitialVelocity=k.Velocity+l;k:Reset()end;function j.Print(k)local l=tostring(k)print(l)end;return i end;local c=a()local d=game:GetService"RunService"local e={}e.__index=e;function e.fromDurationAndBounce(f,g)local h=1;local i=(2*math.pi/f)^2*h;local j=2*(1-g)*math.sqrt(h*i)return{h,j,i}end;local f={number=function(f,g,h,i,j)local k=c.new(h,i,j,f[g],0,f[g])return{springType="number",springSet={k},updateFunc=function()f[g]=k.Offset end,setGoal=function(l)k:SetGoal(l)end}end,UDim2=function(f,g,h,i,j)local k=c.new(h,i,j,f[g].X.Offset,0,f[g].X.Offset)local l=c.new(h,i,j,f[g].X.Scale,0,f[g].X.Scale)local m=c.new(h,i,j,f[g].Y.Offset,0,f[g].Y.Offset)local n=c.new(h,i,j,f[g].Y.Scale,0,f[g].Y.Scale)return{springType="UDim2",springSet={XOffset=k,XScale=l,YOffset=m,YScale=n},updateFunc=function()f[g]=UDim2.new(l.Offset,k.Offset,n.Offset,m.Offset)end,setGoal=function(o)k:SetGoal(o.X.Offset)l:SetGoal(o.X.Scale)m:SetGoal(o.Y.Offset)n:SetGoal(o.Y.Scale)end}end,Vector2=function(f,g,h,i,j)local k=c.new(h,i,j,f[g].X,0,f[g].X)local l=c.new(h,i,j,f[g].Y,0,f[g].Y)return{springType="Vector2",springSet={X=k,Y=l},updateFunc=function()f[g]=Vector2.new(k.Offset,l.Offset)end,setGoal=function(m)k:SetGoal(m.X)l:SetGoal(m.Y)end}end,Vector3=function(f,g,h,i,j)local k=c.new(h,i,j,f[g].X,0,f[g].X)local l=c.new(h,i,j,f[g].Y,0,f[g].Y)local m=c.new(h,i,j,f[g].Z,0,f[g].Z)return{springType="Vector3",springSet={k,l,m},updateFunc=function()f[g]=Vector3.new(k.Offset,l.Offset,m.Offset)end,setGoal=function(n)k:SetTarget(n.X)l:SetTarget(n.Y)m:SetTarget(n.Z)end}end}function e.new(g,h,i,j,k)assert(g[h],"Property does not exist on object")local l=typeof(g[h])local m=f[l]if m then local n=setmetatable({},e)n.obj=g;n.propertyName=h;n.updater=nil;local o=m(g,h,i,j,k)n.springType=o.springType;n.springSet=o.springSet;n.updateFunc=o.updateFunc;n.setGoal=o.setGoal;return n else error("Type not supported: "..l)end end;function e.Start(g)if g.updater then return end;for h,i in pairs(g.springSet)do i:Reset()end;g.updater=d.RenderStepped:Connect(function(h)g.updateFunc()end)end;function e.Stop(g)if g.updater then g.updater:Disconnect()g.updater=nil end end;function e.SetGoal(g,h)g.setGoal(h)end;function e.SetParameters(g,h,i,j)for k,l in pairs(g.springSet)do l.Mass=h;l.Stiffness=i;l.Damping=j;l:Reset()end end;return e
		end
		local SBT = SBTf()
		
		
		
		local YARHMPointSave = PointSave.new("YARHM")
		
		local States = {}
		local toggleStates = {}
		local rangeValueStates = {}
		local AREA = script.Parent.Menu.Area.Area
		local AREACONTAINER = script.Parent.Menu.Area
		
		local AREAModuleSelected = nil
		
		local fBSF = script.Parent.FloatingButtonSetting
		
		local function calculateWidth(n)
			if n <= 3 then
				return 30
			else
				local base = 30
				local additional = math.floor((n - 3) / 3) * 30
				return base + additional
			end
		end
		local function udim2Serializer(value)
			if typeof(value) == "UDim2" then
				return string.format("%g,%g,%g,%g", value.X.Scale, value.X.Offset, value.Y.Scale, value.Y.Offset)
			elseif typeof(value) == "string" then
				local xScale, xOffset, yScale, yOffset = string.match(value, "([^,]+),([^,]+),([^,]+),([^,]+)")
				assert(xScale and xOffset and yScale and yOffset, "Invalid UDim2 string format")
				return UDim2.new(tonumber(xScale), tonumber(xOffset), tonumber(yScale), tonumber(yOffset))
			end
		end
		local function lrp(a,b,t)
			return a + (b - a) * t
		end
		function roundNumber(num, numDecimalPlaces)
			return tonumber(string.format("%." .. numDecimalPlaces .. "f", num))
		end
		
		FUNCTIONSmodule.theme = {
			font = Enum.Font.Montserrat,
			textColor = Color3.fromRGB(255, 255, 255),
			accentColor = Color3.fromRGB(197, 0, 0),
			primaryColor = Color3.fromRGB(22, 22, 22),
			secondaryColor = Color3.fromRGB(12, 12, 12),
		
			backgroundColorCSQ = ColorSequence.new(Color3.fromRGB(36, 36, 36), Color3.fromRGB(68, 68, 68)),	
			strokeColorCSQ = ColorSequence.new{
				ColorSequenceKeypoint.new(0, Color3.fromRGB(53.00000064074993, 53.00000064074993, 53.00000064074993)),
				ColorSequenceKeypoint.new(0.15224914252758026, Color3.fromRGB(50.69031357765198, 50.69031357765198, 50.69031357765198)),
				ColorSequenceKeypoint.new(0.4723183512687683, Color3.fromRGB(255, 0, 4.000000236555934)),
				ColorSequenceKeypoint.new(0.7577854990959167, Color3.fromRGB(50.13314567506313, 50.13314567506313, 50.13314567506313)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(48.000000938773155, 48.000000938773155, 48.000000938773155))
			},
		}
		
		function FUNCTIONSmodule.getTheme()
			if getgenv then
				return getgenv().YARHM_THEME or FUNCTIONSmodule.theme
			else
				return FUNCTIONSmodule.theme
			end
		end
		function FUNCTIONSmodule.setTheme(t)
			FUNCTIONSmodule.theme = t
			if getgenv then getgenv().YARHM_THEME = t end
		end
		
		local floatingButtonObjects = {}
		local floatingButtonInvisibility = {}
		local floatingButtonDraggers = {}
		local floatingButtonKeybinds = {}
		local floatingButtonConnections = {}
		
		local fBSFResizeDragger = nil
		getgenv().fBSFButton = nil
		getgenv().fBSFRealButton = nil
		getgenv().fBSF_ButtonDragger = nil
		
		local selected = Instance.new("ObjectValue")
		
		selected.Parent = script.Parent
		selected.Name = "Selected"
		
		local icons = {
			info = "rbxassetid://11780939099",
			x = "rbxassetid://10002373478",
			cross = "rbxassetid://10002373478",
			check = "rbxassetid://11604833061"
		}
		
		
		incomingNotif = false
		
		function FUNCTIONSmodule.to_base64(data)
			local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
			return ((data:gsub('.', function(x) 
				local r,b='',x:byte()
				for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
				return r;
			end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
				if (#x < 6) then return '' end
				local c=0
				for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
				return b:sub(c+1,c+1)
			end)..({ '', '==', '=' })[#data%3+1])
		end
		
		function FUNCTIONSmodule.from_base64(data)
			local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
			data = string.gsub(data, '[^'..b..'=]', '')
			return (data:gsub('.', function(x)
				if (x == '=') then return '' end
				local r,f='',(b:find(x)-1)
				for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
				return r;
			end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
				if (#x ~= 8) then return '' end
				local c=0
				for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
				return string.char(c)
			end))
		end
		
		function FUNCTIONSmodule.notification(s, color, icon)
			incomingNotif = true
			task.spawn(function()
				s = tostring(s)
				local notif = script.Parent.NotificationSample:Clone()
				notif.Parent = script.Parent
				notif.Position = UDim2.fromScale(0.5, -0.1)
				notif.UIScale.Scale = 0.5
				notif.Visible = true
				notif.Name = s
		
				if color and typeof(icon) == "Color3" then
					notif.UIStroke.Color = color
					notif.ImageLabel.ImageColor3 = color
				end
		
				if icon then
					if icons[icon] then notif.ImageLabel.Image = icons[icon] else
						if tonumber(icon) then
							notif.ImageLabel.Image = "rbxassetid://" .. tonumber(icon)
						else
							notif.ImageLabel.Image = icon
						end
					end
				end
		
				notif.TextLabel.MaxVisibleGraphemes = 0
				notif.TextLabel.Text = s
				notif:SetAttribute("close", false)
				ts:Create(notif, TweenInfo.new(0.7, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
					Position = UDim2.new(0.5, 0, 0, 10)
				}):Play()
		
				ts:Create(notif.UIScale, TweenInfo.new(0.8, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
					Scale = 0.8
				}):Play()
		
				ts:Create(notif.TextLabel, TweenInfo.new(0.7, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
					MaxVisibleGraphemes = #s
				}):Play()
		
				notif.Close.MouseButton1Click:Connect(function()
					notif:SetAttribute("close", true)
				end)
		
				task.wait()
				incomingNotif = false
				local lastclock = os.clock()
				repeat task.wait() until os.clock()-lastclock > 5 or incomingNotif or notif:GetAttribute("close")
		
				local finish = ts:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
					Position = UDim2.fromScale(0.5, -0.1)
				})
				finish:Play()
				finish.Completed:Connect(function()
					notif:Destroy()
				end)
			end)
		end
		
		local lockMode = false
		function FUNCTIONSmodule.lockModeSet(s)
			lockMode = s
		end
		
		function FUNCTIONSmodule.closeFinetuneFB()
			for _, b in ipairs(script.Parent.FloatingButtons:GetChildren()) do
				if b:IsA("TextButton") and b:FindFirstChildWhichIsA("UIScale") then
					local buttonScale = b:FindFirstChildWhichIsA("UIScale")
					ts:Create(buttonScale, TweenInfo.new(0.3), {
						Scale = 1
					}):Play()
				end
			end
		
			local buttonScale = getgenv().fBSFButton:FindFirstChildWhichIsA("UIScale") or Instance.new("UIScale", getgenv().fBSFButton)
			ts:Create(buttonScale, TweenInfo.new(0.3), {
				Scale = 0
			}):Play()
			ts:Create(fBSF, TweenInfo.new(0.3), {
				BackgroundTransparency = 1
			}):Play()
			local done = ts:Create(fBSF.ControlBarContainer.UIScale, TweenInfo.new(0.3), {
				Scale = 0
			})
			done:Play()
			done.Completed:Wait()
			--for _, b in ipairs(script.Parent.FloatingButtons:GetChildren()) do
			--	if b:FindFirstChildWhichIsA("UIScale") then
			--		b:FindFirstChildWhichIsA("UIScale"):Destroy()
			--	end
			--end
			getgenv().fBSFButton:Destroy()
			fBSF.Visible = false
		
			getgenv().fBSFButton = nil
			getgenv().fBSFRealButton = nil
			getgenv().fBSF_ButtonDragger = nil
		end
		
		function FUNCTIONSmodule.finetuneFloatingButton(button: TextButton, dragger)
			if getgenv().fBSFRealButton then return end
			getgenv().fBSFRealButton = button
			for _, b in ipairs(script.Parent.FloatingButtons:GetChildren()) do
				if b:IsA("TextButton") and b:FindFirstChildWhichIsA("UIScale") then
					local buttonScale = b:FindFirstChildWhichIsA("UIScale")
					ts:Create(buttonScale, TweenInfo.new(0.3), {
						Scale = 0
					}):Play()
				end
			end
		
			local finetuningButton = button:Clone()
			getgenv().fBSFButton = finetuningButton
			finetuningButton.Parent = fBSF
			finetuningButton.Name = "fBSFButton"
			finetuningButton.AnchorPoint = Vector2.new(0, 0)
			finetuningButton.Position = UDim2.fromOffset(button.AbsolutePosition.X, button.AbsolutePosition.Y + game:GetService("GuiService"):GetGuiInset().Y)
		
			fBSFResizeDragger = DraggableObject.new(finetuningButton, nil, nil, true)
		
			getgenv().fBSF_ButtonDragger = dragger
			local startingSize = finetuningButton.Size
			fBSFResizeDragger.DragStarted = function()
				startingSize = finetuningButton.Size
			end
			fBSFResizeDragger.Dragged = function(pos)
				local newSize =  UDim2.fromOffset(math.clamp(startingSize.X.Offset + pos.X.Offset, 30, 500), math.clamp(startingSize.Y.Offset + pos.Y.Offset, 10, 350))
				ts:Create(finetuningButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Size = newSize
				}):Play()
				button.Size = newSize
				YARHMPointSave:set(string.gsub(button.Name, "_", ""), udim2Serializer(button.Position) .. "|" .. udim2Serializer(button.Size) .. "|" .. tostring(button.Visible) .. "|" .. tostring(dragger.CanBeDragged))
			end
			fBSFResizeDragger:Enable()
		
			fBSF.ControlBarContainer.UIScale.Scale = 0
			fBSF.BackgroundTransparency = 1
			fBSF.Visible = true
			ts:Create(fBSF, TweenInfo.new(0.3), {
				BackgroundTransparency = 0.5
			}):Play()
			ts:Create(fBSF.ControlBarContainer.UIScale, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				Scale = 1
			}):Play()
			ts:Create(finetuningButton, TweenInfo.new(1, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5)
			}):Play()
		
			if finetuningButton.BackgroundTransparency == 1 then
				finetuningButton.Lock.TextTransparency = 0
				ts:Create(finetuningButton, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {
					BackgroundTransparency = 0.5,
					TextTransparency = 0.5
				}):Play()
				ts:Create(finetuningButton.UIStroke, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {
					Transparency = 0.5
				}):Play()
			end
		
			
		end
		
		function FUNCTIONSmodule.ftToggleLock()
			if getgenv().fBSF_ButtonDragger.CanBeDragged then
				getgenv().fBSF_ButtonDragger:Disable()
				getgenv().fBSFRealButton.Lock.UIScale.Scale = 1
				ts:Create(getgenv().fBSFButton.Lock.UIScale, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
					Scale = 1
				}):Play()
			else
				getgenv().fBSF_ButtonDragger:Enable()
				getgenv().fBSFRealButton.Lock.UIScale.Scale = 0
				ts:Create(getgenv().fBSFButton.Lock.UIScale, TweenInfo.new(0.3), {
					Scale = 0
				}):Play()
			end
			YARHMPointSave:set(string.gsub(getgenv().fBSFRealButton.Name, "_", ""), udim2Serializer(getgenv().fBSFRealButton.Position) .. "|" .. udim2Serializer(getgenv().fBSFRealButton.Size) .. "|" .. tostring(getgenv().fBSFRealButton.Visible) .. "|" .. tostring(getgenv().fBSF_ButtonDragger.CanBeDragged))
		end
		
		function FUNCTIONSmodule.ftToggleVisibility()
			if getgenv().fBSFButton.BackgroundTransparency == 0 then
				getgenv().fBSFRealButton.BackgroundTransparency = 1
				getgenv().fBSFRealButton.TextTransparency = 1
				getgenv().fBSFRealButton.UIStroke.Transparency = 1
				getgenv().fBSFRealButton.Lock.TextTransparency = 1
		
				ts:Create(getgenv().fBSFButton, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {
					BackgroundTransparency = 0.5,
					TextTransparency = 0.5
				}):Play()
				ts:Create(getgenv().fBSFButton.UIStroke, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {
					Transparency = 0.5
				}):Play()
			else
				getgenv().fBSFRealButton.BackgroundTransparency = 0
				getgenv().fBSFRealButton.TextTransparency = 0
				getgenv().fBSFRealButton.UIStroke.Transparency = 0
				getgenv().fBSFRealButton.Lock.TextTransparency = 0
		
				ts:Create(getgenv().fBSFButton, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {
					BackgroundTransparency = 0,
					TextTransparency = 0
				}):Play()
				ts:Create(getgenv().fBSFButton.UIStroke, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {
					Transparency = 0
				}):Play()
			end
			YARHMPointSave:set(string.gsub(getgenv().fBSFRealButton.Name, "_", ""), udim2Serializer(getgenv().fBSFRealButton.Position) .. "|" .. udim2Serializer(getgenv().fBSFRealButton.Size) .. "|" .. tostring(getgenv().fBSFRealButton.Visible) .. "|" .. tostring(getgenv().fBSF_ButtonDragger.CanBeDragged))
		end
		
		function FUNCTIONSmodule.createFloatingButton(item,button,buttonname,fromload)
			if not getgenv().YARHM.FloatingButtons:FindFirstChild(string.gsub(buttonname, "_", "")) then
				
				
				local UserInputService = game:GetService("UserInputService")
				if not fromload then
					YARHMPointSave:set(string.gsub(buttonname, "_", ""), udim2Serializer(UDim2.fromOffset(125, 90)) .. "|" .. udim2Serializer(UDim2.fromOffset(200,50)) .. "|true|true")
				end
		
				local newFloatingButton = getgenv().YARHM.FloatingButton:Clone()
				newFloatingButton.Parent = getgenv().YARHM.FloatingButtons
				
				newFloatingButton.Name = string.gsub(buttonname, "_", "")
				newFloatingButton.Text = string.gsub(buttonname, "_", " ")
				
				newFloatingButton.BackgroundColor3 = FUNCTIONSmodule.getTheme().primaryColor
				local themedColor = Instance.new("StringValue", newFloatingButton)
				themedColor.Name = "themedColor"
				themedColor.Value = "primaryColor"
				newFloatingButton.Visible = true
				
				newFloatingButton.Font = Enum.Font.Montserrat
		
				table.insert(floatingButtonObjects, newFloatingButton)
				local floatingButtonObjectSelf = floatingButtonObjects[#floatingButtonObjects]
		
				newFloatingButton.MouseButton1Click:Connect(function()
					if typeof(item["Args"][2]) == "function" then
						item["Args"][2](button)
					else
						item["Args"][2][buttonname](button)
					end
				end)
				
				local ripple
				
				newFloatingButton.MouseButton1Down:Connect(function(x, y)
					ts:Create(newFloatingButton.UIScale, TweenInfo.new(0.1), {
						Scale = 0.95
					}):Play()
					
					
					ripple = newFloatingButton.Ripple:Clone()
					ripple.BackgroundColor3 = FUNCTIONSmodule.getTheme().textColor
					ripple.Parent = newFloatingButton
					ripple.Position = UDim2.fromOffset(x - newFloatingButton.AbsolutePosition.X, (y - newFloatingButton.AbsolutePosition.Y) - game:GetService("GuiService"):GetGuiInset().Y)
					ts:Create(ripple, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
						BackgroundTransparency = 0.6,
						Size = UDim2.fromOffset(50, 50)
					}):Play()
				end)
				
				
				local function closeRipple()
					if not getgenv().fBSFRealButton then
						ts:Create(newFloatingButton.UIScale, TweenInfo.new(0.1), {
							Scale = 1
						}):Play()
					end
		
					if ripple then
						task.spawn(function()
							local rippleToRemove = ripple
							local fade = ts:Create(rippleToRemove, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
								BackgroundTransparency = 1,
								Size = UDim2.fromOffset(150, 150)
							})
							fade:Play()
							fade.Completed:Once(function()
								rippleToRemove:Destroy()
							end)
						end)
					end
				end
				UserInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
						closeRipple()
					end
				end)
				
				local shouldBeDraggable = true
				if not fromload then
					newFloatingButton.Position = UDim2.fromOffset(-125, 90)
				elseif YARHMPointSave:get(string.gsub(buttonname, "_", "")) then
					local data = YARHMPointSave:get(string.gsub(buttonname, "_", "")):split("|")
					newFloatingButton.Position = udim2Serializer(data[1])
					ts:Create(newFloatingButton, TweenInfo.new(2, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {
						Size = udim2Serializer(data[2])
					}):Play()
					newFloatingButton.Visible = (data[3] == "true")
					if data[4] == "false" then
						newFloatingButton.Lock.UIScale.Scale = 1
						shouldBeDraggable = false
					end
				end
		
				task.spawn(function()
					if not fromload then
						ts:Create(newFloatingButton, TweenInfo.new(2, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {
							Size = UDim2.fromOffset(200, 50)
						}):Play()
						ts:Create(newFloatingButton, TweenInfo.new(0.7, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
							Position = UDim2.fromOffset(125, 90)
						}):Play()
					end
				end)
		
				floatingButtonDraggers[string.gsub(buttonname, "_", "")] = DraggableObject.new(newFloatingButton)
				if shouldBeDraggable then
					floatingButtonDraggers[string.gsub(buttonname, "_", "")]:Enable()
				end
				floatingButtonDraggers[string.gsub(buttonname, "_", "")].Dragged = function(newPos)
					YARHMPointSave:set(string.gsub(buttonname, "_", ""), udim2Serializer(newPos) .. "|" .. udim2Serializer(newFloatingButton.Size) .. "|" .. tostring(newFloatingButton.Visible) .. "|" .. tostring(floatingButtonDraggers[string.gsub(buttonname, "_", "")].CanBeDragged))
				end
		
				local holder = ClickAndHold.new(newFloatingButton)
				holder.Holded.Event:Connect(function()
					if floatingButtonDraggers[string.gsub(buttonname, "_", "")].Dragging then return end
					if ripple then
						ripple:Destroy()
					end
					FUNCTIONSmodule.finetuneFloatingButton(floatingButtonObjectSelf, floatingButtonDraggers[string.gsub(buttonname, "_", "")])
				end)
		
				newFloatingButton.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton2 then
						FUNCTIONSmodule.notification("Press a key to bind " .. string.gsub(buttonname, "_", "") .. " to...")
						local keytobind
						local result
						repeat
							result = UserInputService.InputBegan:Wait()
							if result.UserInputType == Enum.UserInputType.Keyboard then keytobind = result.KeyCode end
						until keytobind
		
						FUNCTIONSmodule.notification(string.gsub(buttonname, "_", "") .. " binded to key " .. result.KeyCode.Name .. "!")
						task.wait(0.1) floatingButtonKeybinds[string.gsub(buttonname, "_", "")] = keytobind	
					end
				end)
		
				local uis = game:GetService("UserInputService")
				if uis.KeyboardEnabled and uis.MouseEnabled then
					floatingButtonConnections[string.gsub(buttonname, "_", "")] = uis.InputBegan:Connect(function(inp, processed)
						if processed then return end
						if inp.KeyCode == floatingButtonKeybinds[string.gsub(buttonname, "_", "")] then
							if typeof(item["Args"][2]) == "function" then
								item["Args"][2](button)
							else
								item["Args"][2][buttonname](button)
							end
						end
					end)
				end
		
			else
				floatingButtonKeybinds[string.gsub(buttonname, "_", "")] = nil
				if floatingButtonConnections[string.gsub(buttonname, "_", "")] then
					floatingButtonConnections[string.gsub(buttonname, "_", "")]:Disconnect()
				end
				YARHMPointSave:remove(string.gsub(buttonname, "_", ""))
				task.spawn(function()
					local buttontodestroy = getgenv().YARHM.FloatingButtons:FindFirstChild(string.gsub(buttonname, "_", ""))
					local btdtween = ts:Create(buttontodestroy, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
						Size = UDim2.new(0,0,0,0)
					})
					btdtween:Play()
					btdtween.Completed:Wait()
					buttontodestroy:Destroy()
				end)
			end
		end
		
		function FUNCTIONSmodule.loadFloatingButtons()
			repeat task.wait() until getgenv().Modules
			for _, module in ipairs(getgenv().Modules) do
				for _, item in ipairs(module) do
					if item["Type"] == "Button" then
						local key = string.gsub(item["Args"][1], "_", "")
						local saved = YARHMPointSave:get(key)
						if saved then
							FUNCTIONSmodule.createFloatingButton(item, Instance.new("TextButton"), item["Args"][1], true)
						end
					end
				end
			end
		end
		function FUNCTIONSmodule.loader(module)
			--local unloadtween = ts:Create(AREA, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			--	Position = UDim2.fromScale(1.55, 0.606)
			--})
		
			--unloadtween:Play()
			--unloadtween.Completed:Wait()
		
		
			local AREAframes = {}
			for _, i in ipairs(AREA:GetChildren()) do if i:IsA("Frame") then table.insert(AREAframes, i) end end
			if #AREAframes > 5 then
				ts:Create(AREA, TweenInfo.new(0.1, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), { CanvasPosition = Vector2.zero }):Play()
				for i=1, math.min(7, #AREAframes) do
					task.wait(0.01)
					ts:Create(AREAframes[i]:GetChildren()[1], TweenInfo.new(0.2, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
						Position = UDim2.fromScale(2, 0)
					}):Play()
				end
				task.wait(0.18)
			end
		
			AREA:ClearAllChildren()
			
			
			local listlayout = Instance.new("UIListLayout")
			listlayout.Parent = AREA
			listlayout.Padding = UDim.new(0, 10)
			listlayout.FillDirection = Enum.FillDirection.Vertical
			listlayout.SortOrder = Enum.SortOrder.LayoutOrder
			listlayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			
			
			for _, item in ipairs(module) do
				local frameHolder = Instance.new("Frame")
				frameHolder.Name = "Holder"
				frameHolder.BackgroundTransparency = 1
				frameHolder.Size = UDim2.new(1,0,0,0)
				frameHolder.AutomaticSize = Enum.AutomaticSize.XY
				frameHolder.Parent = AREA
		
				if item["Type"] == "Text" then
		
					local text = Instance.new("TextLabel")
					text.Parent = frameHolder
		
					text.BackgroundTransparency = 1
					text.Text = item["Args"][1]
					text.TextScaled = true
					text.TextColor3 = FUNCTIONSmodule.getTheme().textColor
					text.Font = Enum.Font.GothamBold
					text.Size = UDim2.new(1,0,0,20)
					text.TextXAlignment = item["Args"][2] == "center" and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left
					text.RichText = true
		
		
				elseif item["Type"] == "Button" then
		
					local button = Instance.new("TextButton")
					button.Parent = frameHolder
		
					button.BackgroundColor3 = FUNCTIONSmodule.getTheme().primaryColor
					button.Text = item["Args"][1]
					button.TextScaled = true
					button.TextColor3 = FUNCTIONSmodule.getTheme().textColor
					button.Font = Enum.Font.GothamBold
					button.Size = UDim2.new(1,0,0,25)
		
					local padding = Instance.new("UIPadding")
					padding.Parent = button
		
					padding.PaddingTop = UDim.new(0, 5)
					padding.PaddingBottom = UDim.new(0, 5)
		
		
					Instance.new("UICorner", button)
		
					local hold = false
		
					button.MouseButton1Click:Connect(function()
						item["Args"][2](button)
					end)
					
					local cah = ClickAndHold.new(button, 0.5)
					cah.Holded.Event:Connect(function()
						FUNCTIONSmodule.createFloatingButton(item, button, item["Args"][1])
					end)
		
					
				elseif item["Type"] == "ButtonGrid" then
		
		
		
		
					local frame = Instance.new("Frame")
					frame.Parent = frameHolder
					frame.Size = UDim2.new(1, 0, 0, 0)
					frame.AutomaticSize = Enum.AutomaticSize.Y
					frame.BackgroundTransparency = 1
		
		
					local gridlayout = Instance.new("UIGridLayout")
					gridlayout.Parent = frame
					gridlayout.CellSize = UDim2.new((1 / item["Args"][1]) - 0.03, 0, 0, 30) -- remove 0.03 because if not it would wrap on its own lol
		
					--print("------")
					--print(item["Args"][2])
					--print(States)
					for buttonname, args in item["Args"][2] do
						local button = Instance.new("TextButton")
						button.Parent = frame
		
						--print(args)
						button.BackgroundColor3 = FUNCTIONSmodule.getTheme().primaryColor
						if States[buttonname .. module.Name] then
							button.BackgroundColor3 = FUNCTIONSmodule.getTheme().accentColor
						end
						button.Text = string.gsub(buttonname, "_", " ")
						button.TextScaled = true
						button.TextColor3 = FUNCTIONSmodule.getTheme().textColor
						button.Font = Enum.Font.GothamBold
		
						local padding = Instance.new("UIPadding")
						padding.Parent = button
		
						padding.PaddingTop = UDim.new(0, 5)
						padding.PaddingBottom = UDim.new(0, 5)
		
						Instance.new("UICorner", button)
		
						button.MouseButton1Click:Connect(function()
							if item["Toggleable"] then
								item["Args"][2][buttonname](button)
								--print(States[buttonname .. module.Name])
								if States[buttonname .. module.Name] then
									ts:Create(button, TweenInfo.new(0.3), {
										BackgroundColor3 = FUNCTIONSmodule.getTheme().primaryColor
									}):Play()
									States[buttonname .. module.Name] = false
								else
									ts:Create(button, TweenInfo.new(0.3), {
										BackgroundColor3 = FUNCTIONSmodule.getTheme().accentColor
									}):Play()
									States[buttonname .. module.Name] = true
								end
							else
								item["Args"][2][buttonname](button)
							end
						end)
		
						local cah = ClickAndHold.new(button, 0.5)
						cah.Holded.Event:Connect(function()
							FUNCTIONSmodule.createFloatingButton(item, button, buttonname)
						end)
					end
		
		
				elseif item["Type"] == "Input" then
					local cloneinput = getgenv().YARHM.TextBoxPlaceholder:Clone()
					cloneinput.Parent = frameHolder
					cloneinput.Visible = true
					
					cloneinput.TextBox.PlaceholderText = item["Args"][1]
					cloneinput.TextButton.Text = item["Args"][2]
					
					cloneinput.TextBox.TextColor3 = FUNCTIONSmodule.getTheme().textColor
					cloneinput.TextButton.TextColor3 = FUNCTIONSmodule.getTheme().textColor
					
					cloneinput.TextBox.BackgroundColor3 = FUNCTIONSmodule.getTheme().primaryColor
					cloneinput.TextButton.BackgroundColor3 = FUNCTIONSmodule.getTheme().primaryColor
		
		
					cloneinput.TextButton.MouseButton1Click:Connect(function()
						item["Args"][3](cloneinput.TextButton, cloneinput.TextBox.Text)
					end)
				elseif item["Type"] == "Toggle" then
					local clonetoggle = getgenv().YARHM.Toggle:Clone()
					clonetoggle.Parent = frameHolder
					clonetoggle.Visible = true
		
					clonetoggle.TextLabel.Text = item["Args"][1]
					clonetoggle.TextLabel.TextColor3 = FUNCTIONSmodule.getTheme().textColor
					clonetoggle.TextLabel.Font = Enum.Font.Montserrat
		
		
		
					local clonetoggletoggler = clonetoggle.Frame.Frame.Toggler
					
					clonetoggletoggler.ImageLabel.ImageColor3 = FUNCTIONSmodule.getTheme().accentColor
					clonetoggletoggler.Parent.BackgroundColor3 = FUNCTIONSmodule.getTheme().primaryColor
					if toggleStates[item["Args"][1] .. module.Name] then
						clonetoggletoggler.Position = UDim2.fromScale(0.7, 0.5)
						clonetoggletoggler.ImageLabel.Image = "rbxassetid://5959696880"
					end
		
					clonetoggletoggler.MouseButton1Click:Connect(function()
						if toggleStates[item["Args"][1] .. module.Name] then
							toggleStates[item["Args"][1] .. module.Name] = false
							ts:Create(clonetoggletoggler, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
								Position = UDim2.fromScale(0.3, 0.5)
							}):Play()
							clonetoggletoggler.ImageLabel.Image = "rbxassetid://10002373478"
						else
							toggleStates[item["Args"][1] .. module.Name] = true
							ts:Create(clonetoggletoggler, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
								Position = UDim2.fromScale(0.7, 0.5)
							}):Play()
							clonetoggletoggler.ImageLabel.Image = "rbxassetid://5959696880"
						end
						item["Args"][2](clonetoggletoggler, toggleStates[item["Args"][1] .. module.Name])
					end)
				elseif item["Type"] == "Dropdown" then	
					local clonedropdown = getgenv().YARHM.Dropdown:Clone()
					local dropdownFrame = getgenv().YARHM.DropdownFrameSample
					clonedropdown.Parent = frameHolder
					clonedropdown.Visible = true
		
					clonedropdown.TextLabel.Text = item["Args"][1]
					clonedropdown.Frame.MouseButton1Click:Connect(function()
						for _, v in ipairs(dropdownFrame.ScrollingFrame:GetChildren()) do if v:IsA("TextButton") and v.Name ~= "Sample" then v:Destroy() end end
						local mouse = game.Players.LocalPlayer:GetMouse()
						dropdownFrame.Position = UDim2.fromOffset(mouse.X, mouse.Y - 55)
						dropdownFrame.Size = UDim2.new(0,108/2,0,0)
						dropdownFrame.Visible = true
						ts:Create(dropdownFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
							Size = UDim2.fromOffset(108, 239)
						}):Play()
		
						local items
						if typeof(item["Args"][2]) == "function" then
							items = item["Args"][2]()
						else
							items = item["Args"][2]
						end
		
						for _, v in ipairs(items) do
							local clonedropdownbutton = dropdownFrame.ScrollingFrame.Sample:Clone()
							clonedropdownbutton.Parent = dropdownFrame.ScrollingFrame
							clonedropdownbutton.Name = v
							clonedropdownbutton.Visible = true
							clonedropdownbutton.Text = v
							clonedropdownbutton.MouseButton1Click:Connect(function()
								--dropdownFrame.Visible = false
								clonedropdown.Frame.Text = v
								item["Args"][3](clonedropdown.Frame, v)
								local after = ts:Create(dropdownFrame, TweenInfo.new(0.1, Enum.EasingStyle.Circular, Enum.EasingDirection.Out), {
									Size = UDim2.fromOffset(108/2, 0)
								})
								after:Play()
								after.Completed:Once(function()
									dropdownFrame.Visible = false
								end)
							end)
						end
					end)
				elseif item["Type"] == "Range" then
					local clonerange = getgenv().YARHM.Range:Clone()
					clonerange.Parent = frameHolder
					clonerange.Visible = true
		
					clonerange.TextLabel.Text = item["Args"][1]
					clonerange.TextLabel.TextColor3 = FUNCTIONSmodule.getTheme().textColor
					clonerange.TextLabel.Font = Enum.Font.Montserrat
					
					clonerange.Frame.Track.Ball.BackgroundColor3 = FUNCTIONSmodule.getTheme().accentColor
					clonerange.Frame.Track.BackgroundColor3 = FUNCTIONSmodule.getTheme().primaryColor
					
					if not rangeValueStates[item["Args"][1] .. module.Name] then
						rangeValueStates[item["Args"][1] .. module.Name] = item["Args"][2]
					end
					clonerange.Frame.Track.Ball.Size = UDim2.new(lrp(0.06, 1, rangeValueStates[item["Args"][1] .. module.Name] / item["Args"][3]), 0, 1, 0)
		
					local slider = DraggableObject.new(clonerange.Frame, nil, false, true)
					slider:Enable()
					
					local relativeSlide = nil
					slider.Dragged = function(pos: UDim2)
						if not relativeSlide then relativeSlide = pos end
						local dragDistance = pos - relativeSlide
						
						local resolvedVal = rangeValueStates[item["Args"][1] .. module.Name]
						local deltaChange = dragDistance.X.Offset
						if math.abs(deltaChange) * 2 > item["Args"][4] then
							resolvedVal = math.clamp(resolvedVal + deltaChange, 0, item["Args"][3])
							relativeSlide = pos
							
							if item["Args"][4] > 1 then
								resolvedVal = math.round(resolvedVal)
							end
							
							rangeValueStates[item["Args"][1] .. module.Name] = resolvedVal
						end
						
						clonerange.Frame.Track.Ball.Size = UDim2.new(lrp(0.06, 1, resolvedVal / item["Args"][3]), 0, 1, 0)
		
						
						
						clonerange.Frame.Track.Ball.BallProgress.Text = roundNumber(resolvedVal, 2)
						clonerange.Frame.Track.TrackProgress.Text = tostring(resolvedVal, 2)
						if resolvedVal > item["Args"][3] / 2 then
							ts:Create(clonerange.Frame.Track.Ball.BallProgress, TweenInfo.new(0.2), {
								TextTransparency = 0,
								TextStrokeTransparency = 0
							}):Play()
							ts:Create(clonerange.Frame.Track.TrackProgress, TweenInfo.new(0.2), {
								TextTransparency = 1,
								TextStrokeTransparency = 1
							}):Play()
						else
							ts:Create(clonerange.Frame.Track.Ball.BallProgress, TweenInfo.new(0.2), {
								TextTransparency = 1,
								TextStrokeTransparency = 1
							}):Play()
							ts:Create(clonerange.Frame.Track.TrackProgress, TweenInfo.new(0.2), {
								TextTransparency = 0,
								TextStrokeTransparency = 0
							}):Play()
						end
						
						rangeValueStates[item["Args"][1] .. module.Name] = resolvedVal
						
						if item["Args"][5] then
							item["Args"][5](clonerange, resolvedVal)
						end
					end
					
					slider.DragEnded = function()
						relativeSlide = nil
						ts:Create(clonerange.Frame.Track.Ball.BallProgress, TweenInfo.new(0.2), {
							TextTransparency = 1,
							TextStrokeTransparency = 1
						}):Play()
						ts:Create(clonerange.Frame.Track.TrackProgress, TweenInfo.new(0.2), {
							TextTransparency = 1,
							TextStrokeTransparency = 1
						}):Play()
					end
		
						
				end
				
		
		
			end
			
			--if AREACONTAINER:FindFirstChildWhichIsA("UIListLayout") then
			--	AREACONTAINER:FindFirstChildWhichIsA("UIListLayout"):Destroy()
			--end -- idk where this instance coming from sorry
			AREACONTAINER.Area.Position = UDim2.fromScale(0.5, 0.5)
			ts:Create(AREACONTAINER.Area, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
				Position = UDim2.fromScale(0.5, 0.5)
			}):Play()
		
			ts:Create(listlayout, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
				Padding = UDim.new(0, 10)
			}):Play()
			local AREAframes = {}
			for _, i in ipairs(AREA:GetChildren()) do if i:IsA("Frame") then table.insert(AREAframes, i) end end
			if #AREAframes > 5 then
				for i=1, math.min(7, #AREAframes) do AREAframes[i]:GetChildren()[1].Position = UDim2.fromScale(-1, 0) end
				ts:Create(AREA, TweenInfo.new(0.1, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), { CanvasPosition = Vector2.zero }):Play()
				for i=1, math.min(7, #AREAframes) do
					task.wait(0.02)
					task.spawn(function()
						local springEnter = SBT.new(AREAframes[i]:GetChildren()[1], "Position", 1, 17, 100)
						springEnter:SetGoal(UDim2.fromScale(0, 0))
						springEnter:Start()
						task.wait(0.9)
						springEnter:Stop()
					end)
					--ts:Create(AREAframes[i]:GetChildren()[1], TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
					--	Position = UDim2.fromScale(0, 0)
					--}):Play()
				end
				--task.wait(0.1)
			end
			
		end
		
		
		
		function FUNCTIONSmodule.refreshlist()
		
			for _, v in ipairs(script.Parent.Menu.List.ScrollingFrame:GetChildren()) do
				if v:IsA("TextButton") then
					v:Destroy()
				end
			end
		
			local dense = {}
			for _, module in pairs(getgenv().Modules) do
				if module then
					table.insert(dense, module)
				end
			end
			
			if not AREAModuleSelected then
				AREAModuleSelected = dense[1]
			end
			
		
			for i, module in ipairs(dense) do
				local success, err = pcall(function()
		
					local listbutton = getgenv().YARHM.ListButton:Clone()
					listbutton.Parent           = script.Parent.Menu.List.ScrollingFrame
					listbutton.Name             = module.Name
					listbutton.Text             = module.Name
					listbutton.BackgroundColor3 = FUNCTIONSmodule.getTheme().primaryColor
					listbutton.Visible          = true
					
					local themedColor = Instance.new("StringValue", listbutton)
					themedColor.Name = "themedColor"
					themedColor.Value = "primaryColor"
		
					listbutton.MouseButton1Click:Connect(function()
		
						if selected.Value then
							ts:Create(selected.Value, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
								BackgroundColor3 = FUNCTIONSmodule.getTheme().primaryColor,
								TextColor3       = FUNCTIONSmodule.getTheme().textColor,
							}):Play()
						end
		
						selected.Value = listbutton
						AREAModuleSelected = module
						ts:Create(selected.Value, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
							BackgroundColor3 = Color3.fromRGB(255,255,255),
							TextColor3       = Color3.fromRGB(0,0,0),
						}):Play()
		
						FUNCTIONSmodule.loader(module)
					end)
		
					listbutton.MouseButton1Down:Connect(function()
						ts:Create(listbutton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
							Size = UDim2.new(1, -10, 0, 40)
						}):Play()
					end)
		
					listbutton.MouseButton1Up:Connect(function()
						ts:Create(listbutton, TweenInfo.new(1.2, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {
							Size = UDim2.new(1, 0, 0, 50),
						}):Play()
					end)
		
					listbutton.MouseLeave:Connect(function()
						ts:Create(listbutton, TweenInfo.new(1.2, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {
							Size = UDim2.new(1, 0, 0, 50),
						}):Play()
					end)
				end)
		
				if not success then
					warn(("[YARHM] Error loading module %q: %s"):format(module.Name, err))
				end
			end
		end
		
		function FUNCTIONSmodule.refresharea()
			FUNCTIONSmodule.loader(AREAModuleSelected)
		end
		
		function FUNCTIONSmodule.dialog(title, description, buttons)
			local dialog = script.Parent.Dialog
			dialog.DialogTitle.Text = title
			dialog.DialogDesc.Text = description
		
			for _,v in ipairs(dialog.Options:GetChildren()) do
				if v:IsA("TextButton") and v.Name ~= "OptionPlaceholder" then v:Destroy() end
			end
			for _, button in buttons do
				local newButton = dialog.Options.OptionPlaceholder:Clone()
		
				newButton.Visible = true
				newButton.Name = button
				newButton.Text = button
				newButton.Parent = dialog.Options
				newButton.MouseButton1Click:Connect(function()
					newButton.Parent.Parent.OnSelect:Fire(newButton.Name)
				end)
			end
		
			ts:Create(dialog, TweenInfo.new(1.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out),{
				Size = UDim2.fromOffset(313, 147)
			}):Play()
		
			ts:Create(dialog.UIScale, TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out),{
				Scale = 1
			}):Play()
		end
		
		function FUNCTIONSmodule.closedialog()
			local dialog = script.Parent.Dialog
			ts:Create(dialog, TweenInfo.new(1.1, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),{
				Size = UDim2.fromOffset(0, 147)
			}):Play()
		
			ts:Create(dialog.UIScale, TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out),{
				Scale = 0
			}):Play()
		end
		
		function FUNCTIONSmodule.waitfordialog()
			return script.Parent.Dialog.OnSelect.Event:Wait()
		end
		
		
		getgenv().YARHMFUNCTIONS = FUNCTIONSmodule
		return FUNCTIONSmodule
		
    end
    routine_module_scripts[script] = module_script
end
do -- Routine Module: StarterGui.YARHM.DraggableObject
    local script = Instance.new("ModuleScript")
    script.Name = "DraggableObject"
    script.Parent = Converted["_YARHM"]
    local function module_script()

		local function a(b,c)local d=c.AbsoluteSize;local e=c.AbsolutePosition;local f=b.X.Scale*d.X+b.X.Offset;local g=b.Y.Scale*d.Y+b.Y.Offset;local h=math.clamp(f,0,d.X)local i=math.clamp(g,0,d.Y)local j=UDim2.new(b.X.Scale,h-b.X.Scale*d.X,b.Y.Scale,i-b.Y.Scale*d.Y)return j end;local k=UDim2.new;local l=game:GetService("UserInputService")local m=game:GetService("TweenService")local n={}n.__index=n;function n.new(o,p,q,r)local self={}self.Object=o;self.ToMove=p;self.Smooth=q;self.CallbackOnly=r;self.DragStarted=nil;self.DragEnded=nil;self.Dragged=nil;self.Dragging=false;self.LastPosition=nil;self.Velocity=Vector2.new(0,0)setmetatable(self,n)return self end;function n:Enable()local s=self.Object;local t=self.ToMove;local u=nil;local v=nil;local w=nil;local x=false;local function y(z)local A=z.Position-v;local B=UDim2.new(w.X.Scale,w.X.Offset+A.X,w.Y.Scale,w.Y.Offset+A.Y)if self.CallbackOnly then else B=a(B,self.Object:FindFirstAncestorWhichIsA("ScreenGui"))if(self.Smooth==nil or self.Smooth==true)and self.Smooth~=false then m:Create(t and t or s,TweenInfo.new(0.5,Enum.EasingStyle.Cubic,Enum.EasingDirection.Out),{Position=B}):Play()else local C=t and t or s;C.Position=B end end;return B end;self.InputBegan=s.InputBegan:Connect(function(z)if z.UserInputType==Enum.UserInputType.MouseButton1 or z.UserInputType==Enum.UserInputType.Touch then x=true;local D;D=z.Changed:Connect(function()if z.UserInputState==Enum.UserInputState.End and(self.Dragging or x)then self.Dragging=false;D:Disconnect()if self.DragEnded and not x then self.DragEnded(self.Velocity)end;x=false end end)end end)self.InputChanged=s.InputChanged:Connect(function(z)if z.UserInputType==Enum.UserInputType.MouseMovement or z.UserInputType==Enum.UserInputType.Touch then u=z end end)self.InputChanged2=l.InputChanged:Connect(function(z)if s.Parent==nil then self:Disable()return end;if x then x=false;if self.DragStarted then self.DragStarted()end;self.Dragging=true;v=z.Position;if t then w=t.Position else w=s.Position end;self.LastPosition=z.Position end;if z==u and self.Dragging then local B=y(z)self.Velocity=z.Position-self.LastPosition;self.LastPosition=z.Position;if self.Dragged then self.Dragged(B)end end end)end;function n:Disable()self.InputBegan:Disconnect()self.InputChanged:Disconnect()self.InputChanged2:Disconnect()if self.Dragging then self.Dragging=false;if self.DragEnded then self.DragEnded(self.Velocity)end end end;return n
		
    end
    routine_module_scripts[script] = module_script
end
do -- Routine Module: StarterGui.YARHM.ClickAndHold
    local script = Instance.new("ModuleScript")
    script.Name = "ClickAndHold"
    script.Parent = Converted["_YARHM"]
    local function module_script()


		local a={}a.__index=a;local b=game:GetService("UserInputService")function a.new(c,d)local self=setmetatable({},a)self.textButton=c;self.holdTime=d or 0.5;self.holdTask=nil;self.initialPosition=nil;self.Holded=Instance.new("BindableEvent")local function e(f,g)return math.sqrt((g.X-f.X)^2+(g.Y-f.Y)^2)end;self.textButton.MouseButton1Down:Connect(function(h,i)self.initialPosition=Vector2.new(h,i)self.holdTask=task.spawn(function()task.wait(self.holdTime)if self.holdTask then self.Holded:Fire()end end)end)b.InputChanged:Connect(function(j)if j.UserInputType==Enum.UserInputType.MouseMovement or j.UserInputType==Enum.UserInputType.Touch then if self.holdTask and self.initialPosition then local k=j.Position;local l=e(self.initialPosition,k)if l>10 then coroutine.close(self.holdTask)self.holdTask=nil end end end end)b.InputEnded:Connect(function(j)if j.UserInputType==Enum.UserInputType.MouseButton1 or j.UserInputType==Enum.UserInputType.Touch then if self.holdTask then coroutine.close(self.holdTask)self.holdTask=nil end;self.initialPosition=nil end end)return self end;return a
    end
    routine_module_scripts[script] = module_script
end
do -- Routine Module: StarterGui.YARHM.Spring
    local script = Instance.new("ModuleScript")
    script.Name = "Spring"
    script.Parent = Converted["_YARHM"]
    local function module_script()

		local a=game:GetService("RunService")local b={}function OverDamping(c,d,e,f,g,h)local i=d*d-4*e/c;local j=-1/2;local k=d+math.sqrt(i)local l=d-math.sqrt(i)local m,n=j*k,j*l;local o,p=(n*f-g)/(n-m),(m*f-g)/(m-n)local q=h/e;return{Offset=function(r)return o*math.exp(m*r)+p*math.exp(n*r)+q end,Velocity=function(r)return o*m*math.exp(m*r)+p*n*math.exp(n*r)end,Acceleration=function(r)return o*m*m*math.exp(m*r)+p*n*n*math.exp(n*r)end}end;function CriticalDamping(c,d,e,f,g,h)local s=-d/2;local o,p=f,g-s*f;local q=h/e;return{Offset=function(r)return math.exp(s*r)*(o+p*r)+q end,Velocity=function(r)return math.exp(s*r)*(p*s*r+o*s+p)end,Acceleration=function(r)return s*math.exp(s*r)*(p*s*r+o*s+2*p)end}end;function UnderDamping(c,d,e,f,g,h)local i=d*d-4*e/c;local s=-d/2;local t=math.sqrt(-i)local o,p=f,(g-s*f)/t;local q=h/e;return{Offset=function(r)return math.exp(s*r)*(o*math.cos(t*r)+p*math.sin(t*r))+q end,Velocity=function(r)return-math.exp(s*r)*((o*t-p*s)*math.sin(t*r)+(-p*t-o*s)*math.cos(t*r))end,Acceleration=function(r)return-math.exp(s*r)*((p*t*t+2*o*s*t-p*s*s)*math.sin(t*r)+(o*t*t-2*p*s*t-o*s*s)*math.cos(t*r))end}end;function b.F(u)local f,g,h=u.InitialOffset,u.InitialVelocity,u.ExternalForce;local c,d,e=u.Mass,u.Damping,u.Constant;local i=d*d-4*e/c;if i>0 then return OverDamping(c,d,e,f,g,h)elseif i==0 then return CriticalDamping(c,d,e,f,g,h)else return UnderDamping(c,d,e,f,g,h)end end;local v=b;local w=math.sqrt;local x=math.pi;local y={OFFSET="Offset",VELOCITY="Velocity",ACCELERATION="Acceleration",GOAL="Goal",FREQUENCY="Frequency"}local z=[[.]]local A=[[.]]local u={}local B={}B.__index=function(self,C)local D={[y.OFFSET]=function()local r=tick()-self.StartTick;local E=self.F;local F=E.Offset(r)return F end,[y.VELOCITY]=function()local r=tick()-self.StartTick;local E=self.F;local G=E.Velocity(r)return G end,[y.ACCELERATION]=function()local r=tick()-self.StartTick;local E=self.F;local H=E.Acceleration(r)return H end,[y.GOAL]=function()local I=self.ExternalForce;local J=self.Constant;return I/J end,[y.FREQUENCY]=function()local K=self.Damping;local L=self.Constant;local M=self.Mass;return w(-K*K+4*L/M)/(2*x)end}local N=rawget(self,C)if N~=nil then return N end;local O=D[C]if O~=nil then return O()end;return B[C]end;B.__tostring=function(self)local r=tick()-self.StartTick;local E=self.F;local P=self.AdvancedObjectStringEnabled;local Q;if P==false then Q=string.format(z,E.Offset(r),E.Velocity(r),E.Acceleration(r))elseif P==true then Q=string.format(A,self.Mass,self.Damping,self.Constant,self.Goal,self.Frequency,self.InitialOffset,self.InitialVelocity,self.ExternalForce,self.StartTick,E.Offset(r),E.Velocity(r),E.Acceleration(r))end;return Q end;function u.new(M,K,L,f,g,R)assert(M>0,"Mass for spring system cannot be less than or equal to 0")assert(L>0,"Spring constant for spring system cannot be less than or equal to 0")f=f or 0;g=g or 0;R=R or 0;local S=R*L;local T={Mass=M,Damping=K,Constant=L,InitialOffset=f-R,InitialVelocity=g,ExternalForce=S,AdvancedObjectStringEnabled=false,StartTick=0}setmetatable(T,B)T:Reset()return T end;function u.fromFrequency(M,K,U,f,g,R)assert(M>0,"Mass for spring system cannot be less than or equal to 0")assert(U>0,"Spring frequency for spring system cannot be less than or equal to 0")local L=0.25*M*(4*x*x*U*U+K*K)f=f or 0;g=g or 0;R=R or 0;local S=R*L;local T={Mass=M,Damping=K,Constant=L,InitialOffset=f-R,InitialVelocity=g,ExternalForce=S,AdvancedObjectStringEnabled=false,StartTick=0}setmetatable(T,B)T:Reset()return T end;function B:Reset()self.F=v.F(self)self.StartTick=tick()end;function B:SetExternalForce(V)self.ExternalForce=V;self.InitialOffset=self.Offset-V/self.Constant;self.InitialVelocity=self.Velocity;self:Reset()end;function B:SetGoal(R)self.ExternalForce=R*self.Constant;self.InitialOffset=self.Offset-R;self.InitialVelocity=self.Velocity;self:Reset()end;function B:SetFrequency(U)self.Constant=0.25*self.Mass*(4*x*x*U*U+self.Damping*self.Damping)self.InitialOffset=self.Offset;self.InitialVelocity=self.Velocity;self:Reset()end;function B:SnapToCriticalDamping()self.Damping=2*w(self.Constant/self.Mass)self.InitialOffset=self.Offset;self.InitialVelocity=self.Velocity;self:Reset()end;function B:SetOffset(F,W)self.InitialOffset=F-self.Goal;self.InitialVelocity=W and 0 or self.Velocity;self:Reset()end;function B:AddOffset(F)self.InitialOffset=self.Offset+F;self.InitialVelocity=self.Velocity;self:Reset()end;function B:SetVelocity(G)self.InitialOffset=self.Offset;self.InitialVelocity=G;self:Reset()end;function B:AddVelocity(G)self.InitialOffset=self.Offset;self.InitialVelocity=self.Velocity+G;self:Reset()end;function B:Print()local X=tostring(self)print(X)end;return u
    end
    routine_module_scripts[script] = module_script
end
do -- Routine Module: StarterGui.YARHM.ESPIndicator
    local script = Instance.new("ModuleScript")
    script.Name = "ESPIndicator"
    script.Parent = Converted["_YARHM"]
    local function module_script()

		-- Robust ESP module with distancing, arrows, and grouping
		-- Designed and written by YARHM
		
		local e={} e.__index=e local a=game:GetService("RunService") local _=game:GetService("Players") local b=game:GetService("HttpService") local l=game:GetService("TweenService") e.Groups={} e.TargetIndex={} e.Defaults={AccentColor=Color3.new(1,1,0),HighlightFillTransparency=0.7,HighlightOutlineTransparency=0,HighlightDepthMode=Enum.HighlightDepthMode.AlwaysOnTop,ArrowShow=false,ArrowEdgePadding=50,ArrowMinDistance=0,ArrowSize=UDim2.new(0,30,0,30),ArrowImage="rbxassetid://97136202386756",ArrowShowDistanceText=true,ArrowDistanceFont=Enum.Font.Montserrat,ArrowDistanceTextSize=18,ShowLabel=false,LabelText="Target",LabelMaxDistance=99999,LabelOffset=Vector3.new(0,2,0),Parent=game:GetService("CoreGui")} function e.new(b)local c=setmetatable({},e) c.Settings={} for a,_ in pairs(e.Defaults)do c.Settings[a]=(b and b[a]~=nil)and b[a]or _ end local _=c.Settings.Parent or _.LocalPlayer:WaitForChild("PlayerGui") c.ScreenGui=Instance.new("ScreenGui") c.ScreenGui.Name="ESPIndicators" c.ScreenGui.IgnoreGuiInset=true c.ScreenGui.ResetOnSpawn=false c.ScreenGui.Parent=_ c.ArrowTemplate=Instance.new("ImageLabel") c.ArrowTemplate.Name="ArrowTemplate" c.ArrowTemplate.Size=c.Settings.ArrowSize c.ArrowTemplate.AnchorPoint=Vector2.new(0.5,0.5) c.ArrowTemplate.BackgroundTransparency=1 c.ArrowTemplate.Image=c.Settings.ArrowImage c.ArrowTemplate.ImageColor3=c.Settings.AccentColor c.ArrowTemplate.Visible=false c.ArrowTemplate.Parent=c.ScreenGui c.Scaler=Instance.new("UIScale") c.Scaler.Name="Scaler" c.Scaler.Scale=0 c.Scaler.Parent=c.ArrowTemplate c.Indicators={} c._updateConn=a.RenderStepped:Connect(function()c:_update()end) c._cleanupConn=a.Heartbeat:Connect(function()c:_cleanupOrphanedArrows() c:_cleanupOrphanedHighlights() c:_cleanupOrphanedLabels()end) return c end function e:AddGroup(_)local a=e.Groups[_] if not a then a={enabled=true,properties={},targets={}} e.Groups[_]=a end return a end function e:GetGroup(_)return e.Groups[_]end function e:RemoveGroup(b)local _=e.Groups[b] if not _ then return false end for _,_ in ipairs(_.targets)do local c=e.TargetIndex[_] if c then for _,a in ipairs(c)do if a==b then table.remove(c,_) break end end if#c==0 then e.TargetIndex[_]=nil end end if not e.TargetIndex[_]then self:Remove(_)end end e.Groups[b]=nil return true end function e:ClearAllGroups()for a,_ in pairs(e.Groups)do self:RemoveGroup(a)end end function e:ToggleGroup(_,a)local b=e.Groups[_] if not b then return end b.enabled=(a~=nil)and a or not b.enabled for _,_ in ipairs(b.targets)do local _=self.Indicators[_] if _ then if _.Highlight then _.Highlight.Enabled=b.enabled end if _.Arrow then _.Arrow.Visible=b.enabled and self.Settings.ArrowShow end if _.Label then _.Label.Enabled=b.enabled end end end return b.enabled end function e:SetGroupProperty(_,a,b)local _=self:AddGroup(_) _.properties[a]=b for _,_ in ipairs(_.targets)do local _=self.Indicators[_] if _ then if a=="AccentColor"then if _.Highlight then _.Highlight.FillColor=b _.Highlight.OutlineColor=b end if _.Arrow then _.Arrow.ImageColor3=b end if _.DistanceLabel then _.DistanceLabel.TextColor3=b end if _.Label and _.Label:FindFirstChild("TextLabel")then _.Label.TextLabel.TextColor3=b end end end end end function e:Add(a,g)assert(a,"ESPIndicator:Add requires a non-nil target") g=g or{} local d=Instance.new("Highlight") d.Name="Highlight_"..b:GenerateGUID(false) d.Adornee=a d.FillTransparency=g.HighlightFillTransparency or self.Settings.HighlightFillTransparency d.FillColor=g.AccentColor or self.Settings.AccentColor d.OutlineColor=g.AccentColor or self.Settings.AccentColor d.OutlineTransparency=g.HighlightOutlineTransparency or self.Settings.HighlightOutlineTransparency d.DepthMode=g.HighlightDepthMode or self.Settings.HighlightDepthMode d.Parent=self.ScreenGui local c,_,e if(g.ArrowShow or self.Settings.ArrowShow)then c=self.ArrowTemplate:Clone() c.Name="Arrow_"..b:GenerateGUID(false) c.ImageColor3=g.AccentColor or self.Settings.AccentColor c.Visible=true c.Parent=self.ScreenGui _=c:FindFirstChild("Scaler") if(g.ArrowShowDistanceText or self.Settings.ArrowShowDistanceText)then e=Instance.new("TextLabel") e.Name="DistanceLabel" e.AnchorPoint=Vector2.new(0.5,0) e.BackgroundTransparency=1 e.Font=g.ArrowDistanceFont or self.Settings.ArrowDistanceFont e.TextSize=g.ArrowDistanceTextSize or self.Settings.ArrowDistanceTextSize e.TextColor3=g.AccentColor or self.Settings.AccentColor e.Parent=c end end local f if(g.ShowLabel or self.Settings.ShowLabel)then f=Instance.new("BillboardGui") f.Name="Label_"..b:GenerateGUID(false) f.AlwaysOnTop=true f.MaxDistance=self.Settings.LabelMaxDistance f.Size=UDim2.new(0,70,0,70) f.StudsOffset=self.Settings.LabelOffset f.Adornee=a f.Parent=self.ScreenGui local _=Instance.new("TextLabel") _.Name="TextLabel" _.Size=UDim2.new(1,0,1,0) _.AnchorPoint=Vector2.new(0.5,0.5) _.Position=UDim2.new(0.5,0,0.5,0) _.BackgroundTransparency=1 _.Font=Enum.Font.SourceSansBold _.TextScaled=true _.TextWrapped=true _.TextSize=14 _.TextColor3=g.AccentColor or self.Settings.AccentColor _.Text=g.LabelText or self.Settings.LabelText _.Parent=f Instance.new("UIStroke",_)end self.Indicators[a]={Highlight=d,Arrow=c,Scaler=_,DistanceLabel=e,Label=f,Options=g} local _=g.GroupName or self.Settings.GroupName if _ then self:AddToGroup(a,_)end end function e:Remove(c)local _=self.Indicators[c] if not _ then return end if _.Highlight then _.Highlight.Adornee=nil _.Highlight:Destroy()end if _.Arrow then _.Arrow:Destroy()end if _.Label then _.Label:Destroy()end local _=e.TargetIndex[c] if _ then for _,_ in ipairs(_)do local b=e.Groups[_] if b then for a,_ in ipairs(b.targets)do if _==c then table.remove(b.targets,a) break end end end end e.TargetIndex[c]=nil end self.Indicators[c]=nil end function e:AddToGroup(c,b)local _=self:AddGroup(b) if not table.find(_.targets,c)then table.insert(_.targets,c)end local a=e.TargetIndex[c] if not a then a={} e.TargetIndex[c]=a end if not table.find(a,b)then table.insert(a,b)end for a,_ in pairs(_.properties)do self:SetGroupProperty(b,a,_)end if not _.enabled then local _=self.Indicators[c] if _ and _.Highlight then _.Highlight.Enabled=false end end return true end function e:RemoveFromGroup(d,b)local c=e.Groups[b] if not c then return false end if table.find(c.targets,d)then for _,a in ipairs(c.targets)do if a==d then table.remove(c.targets,_) break end end else return false end local c=e.TargetIndex[d] if c then for a,_ in ipairs(c)do if _==b then table.remove(c,a) break end end if#c==0 then e.TargetIndex[d]=nil end end return true end function e:GetGroupTargets(_)local _=e.Groups[_] return _ and _.targets or{}end function e:GetTargetGroups(_)return e.TargetIndex[_]or{}end function e:_cleanupOrphanedHighlights()for _,_ in ipairs(self.ScreenGui:GetChildren())do if _:IsA("Highlight")and not table.find(self:_allHighlights(),_)then _.Adornee=nil _:Destroy()end end end function e:_allHighlights()local a={} for _,_ in pairs(self.Indicators)do if _.Highlight then table.insert(a,_.Highlight)end end return a end function e:_cleanupOrphanedArrows()for _,_ in ipairs(self.ScreenGui:GetChildren())do if _:IsA("ImageLabel")and _.Name:match("^Arrow_")then if not table.find(self:_allArrows(),_)then _:Destroy()end end end end function e:_allArrows()local a={} for _,_ in pairs(self.Indicators)do if _.Arrow then table.insert(a,_.Arrow)end end return a end function e:_cleanupOrphanedLabels()for _,_ in ipairs(self.ScreenGui:GetChildren())do if _:IsA("BillboardGui")and _.Name:match("^Label_")then if not table.find(self:_allLabels(),_)then _.Adornee=nil _:Destroy()end end end end function e:_allLabels()local a={} for _,_ in pairs(self.Indicators)do if _.Label then table.insert(a,_.Label)end end return a end function e:_update()local a=workspace.CurrentCamera local _=a.ViewportSize local f,i=_.X,_.Y for _,p in pairs(self.Indicators)do local j=p.Options local h=p.Arrow local k=p.Scaler if((not h)or(not k))and self.Settings.ArrowShow then self:Remove(_) continue end if not h then continue end local n if _:IsA("Model")then n=(_.PrimaryPart and _.PrimaryPart.Position)or _:GetModelCFrame().p elseif _:IsA("BasePart")then n=_.Position else continue end local m,e=a:WorldToViewportPoint(n) local c=(a.CFrame.p-n).Magnitude local _=j.ArrowMinDistance or self.Settings.ArrowMinDistance local o=j.ArrowEdgePadding or self.Settings.ArrowEdgePadding if e and c>_ then l:Create(k,TweenInfo.new(0.1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Scale=0}):Play()else l:Create(k,TweenInfo.new(0.1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Scale=1}):Play() local d,g=f-o*2,i-o*2 local b=a.CFrame local _=math.sqrt((d/2)^2+(g/2)^2) local a=n-b.Position local a=b:VectorToObjectSpace(a) local n=Vector2.new(a.X,a.Y).Unit local a=math.clamp(m.X,o,f-o) local b=math.clamp(m.Y,o,i-o) if a==m.X and b==m.Y and e then l:Create(k,TweenInfo.new(0.1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Scale=0}):Play()else local _=n*_ local b if math.abs(_.Y)>g/2 then b=n*math.abs((g/2)/n.Y)else b=n*math.abs((d/2)/n.X)end local a=f/2+b.X local _=i/2-b.Y local b=math.atan2(n.X,n.Y) l:Create(h,TweenInfo.new(0.1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Position=UDim2.fromOffset(a,_),Rotation=math.deg(b)}):Play()end if p.DistanceLabel then p.DistanceLabel.Text=string.format("%dm",math.round(c)) local _=(j.ArrowSize and j.ArrowSize.Y.Offset or self.Settings.ArrowSize.Y.Offset)+16 p.DistanceLabel.Position=UDim2.new(0.5,0,0,_)end end end end function e:Destroy()if self._updateConn then self._updateConn:Disconnect()end if self._cleanupConn then self._cleanupConn:Disconnect()end self:ClearAllGroups() for _,_ in pairs(self.Indicators)do if _.Highlight then _.Highlight:Destroy()end if _.Arrow then _.Arrow:Destroy()end if _.Label then _.Label:Destroy()end end self.ScreenGui:Destroy() self.Indicators={} e.Groups={} e.TargetIndex={}end return e
    end
    routine_module_scripts[script] = module_script
end
do -- Routine Module: StarterGui.YARHM.Bezier
    local script = Instance.new("ModuleScript")
    script.Name = "Bezier"
    script.Parent = Converted["_YARHM"]
    local function module_script()

		local h={} h.__index=h function h.new(...)local k={...} assert(#k>=3,"Must have at least 3 points") local e=(#k==3) local _=(#k==4) local j={} local d=Vector3.new local b=d().lerp local f=nil local i={} local c=0 local a=nil local function g(_)local _={_.X,_.Y,_.Z} function _:ToVector3()return d(self[1],self[2],self[3])end function _:lerp(_,a)return b(self:ToVector3(),_:ToVector3(),a)end return _ end if(not e and not _)then for _=1,#k-1 do local a=g(k[_]) local _=g(k[_+1]) local _={a,_,g(a)} i[#i+1]=_ end local b=i for _=#i,2,-1 do local a={} for c=1,_-1 do local b,_=b[c],b[c+1] local _={b[3],_[3],g(b[3])} a[c]=_ i[#i+1]=_ end b=a end a=b[1] c=#i end if(e)then local b,c,_=k[1],k[2],k[3] function j:Get(d,a)if(a)then d=(d<0 and 0 or d>1 and 1 or d)end return(1-d)*(1-d)*b+2*(1-d)*d*c+d*d*_ end elseif(_)then local _,a,c,b=k[1],k[2],k[3],k[4] function j:Get(e,d)if(d)then e=(e<0 and 0 or e>1 and 1 or e)end return(1-e)*(1-e)*(1-e)*_+3*(1-e)*(1-e)*e*a+3*(1-e)*e*e*c+e*e*e*b end else function j:Get(b,_)if(_)then b=(b<0 and 0 or b>1 and 1 or b)end for _=1,c do local _=i[_] local a=_[1]:lerp(_[2],b) local _=_[3] _[1],_[2],_[3]=a.X,a.Y,a.Z end return a[3]:ToVector3()end end function j:GetLength(_)if(not f)then local a=self:GetPath(_ or 0.1) local b=0 for _=2,#a do local _=(a[_-1]-a[_]).Magnitude b=(b+_)end f=b end return f end function j:GetPath(_)assert(type(_)=="number","Must provide a step increment") assert(_>0 and _<1,"Step out of domain; should be between 0 and 1 (exclusive)") local b={} local a=0 for _=0,1,_ do a=_ b[#b+1]=self:Get(_)end if(a<1)then local _=((1-a)<(_*0.5)) b[#b+(_ and 0 or 1)]=self:Get(1)end return b end function j:GetPathByNumberSegments(_)assert(type(_)=="number","Must provide number of segments") assert(_>0,"Number of segments must be greater than 0") return self:GetPath(1/_)end function j:GetPathBySegmentLength(a)assert(type(a)=="number","Must provide a segment length") assert(a>0,"Segment length must be greater than 0") local _=self:GetLength() local _=_/a return self:GetPathByNumberSegments(math.floor(_+0.5))end function j:GetPoints()return k end return setmetatable(j,h)end return h
    end
    routine_module_scripts[script] = module_script
end
do -- Routine Module: StarterGui.YARHM.PointSave
    local script = Instance.new("ModuleScript")
    script.Name = "PointSave"
    script.Parent = Converted["_YARHM"]
    local function module_script()

		-- Datasaving module using files and folders
		-- Designed and written by YARHM
		
		local _=false local function d(...)if _ then print("[PointSave DEBUG]:",...)end end getgenv()._FOLDERS=getgenv()._FOLDERS or{} getgenv()._FILES=getgenv()._FILES or{} isfolder=isfolder or function(_)d("Checking if folder exists:",_) return getgenv()._FOLDERS[_]~=nil end makefolder=makefolder or function(_)d("Creating folder:",_) getgenv()._FOLDERS[_]={} return getgenv()._FOLDERS[_]end isfile=isfile or function(_)d("Checking if file exists:",_) return getgenv()._FILES[_]~=nil end writefile=writefile or function(a,_)d("Writing file:",a,"with content:",_) getgenv()._FILES[a]=_ return getgenv()._FILES[a]end readfile=readfile or function(_)d("Reading file:",_) return getgenv()._FILES[_]end delfile=delfile or function(_)d("Deleting file:",_) getgenv()._FILES[_]=nil end listfiles=listfiles or function(c)d("Listing files in folder:",c) local _=getgenv()._FOLDERS[c] if _ then local a={} for b,_ in pairs(getgenv()._FILES)do if b:sub(1,#c+1)==c.."/"then local _=b:sub(#c+2) d("Found file in folder:",_) table.insert(a,_)end end return a end d("Folder does not exist:",c) return{}end local b={} b.__index=b local c="PointSaveData" local function _()if not isfolder(c)then d("Base folder not found, creating:",c) makefolder(c)else d("Base folder already exists:",c)end end function b.new(a)d("Initializing new PointSave instance for namespace:",a) _() local _=setmetatable({},b) _.namespace=a _.folderPath=c.."/"..a if not isfolder(_.folderPath)then d("Namespace folder does not exist, creating:",_.folderPath) makefolder(_.folderPath)else d("Namespace folder already exists:",_.folderPath)end return _ end function b:set(b,a)local _=self.folderPath.."/"..b..".txt" d("Setting value for key:",b,"->",a) writefile(_,tostring(a))end function b:get(a)local _=self.folderPath.."/"..a..".txt" d("Getting value for key:",a) if isfile(_)then local _=readfile(_) d("Found value for key:",a,"->",_) return _ end d("Key not found:",a) return nil end function b:remove(a)local _=self.folderPath.."/"..a..".txt" d("Removing key:",a) if isfile(_)then delfile(_) d("Removed file for key:",a)else d("File for key does not exist:",a)end end function b:clear()d("Clearing all keys in namespace:",self.namespace) local _=listfiles(self.folderPath) for _,_ in ipairs(_)do local _=self.folderPath.."/".._ if isfile(_)then d("Deleting file:",_) delfile(_)end end end function b.deleteNamespace(a)local b=c.."/"..a d("Deleting namespace:",a) local _=listfiles(b) for _,_ in ipairs(_)do local _=b.."/".._ if isfile(_)then d("Deleting file from namespace:",_) delfile(_)end end getgenv()._FOLDERS[b]=nil d("Deleted folder for namespace:",a)end function b.listNamespaces()d("Listing all namespaces") _() local b={} for a,_ in pairs(getgenv()._FOLDERS)do if a:sub(1,#c+1)==c.."/"then local _=a:sub(#c+2) d("Found namespace:",_) table.insert(b,_)end end return b end return b
    end
    routine_module_scripts[script] = module_script
end
do -- Routine Module: StarterGui.YARHM.Theme
    local script = Instance.new("ModuleScript")
    script.Name = "Theme"
    script.Parent = Converted["_YARHM"]
    local function module_script()

		-- Beautiful theming module for YARHM
		
		local YARHMRoot = getgenv().YARHM
		local api = {
			colors = {
				font = Enum.Font.Montserrat,
				textColor = Color3.fromRGB(255, 255, 255),
				accentColor = Color3.fromRGB(197, 0, 0),
				primaryColor = Color3.fromRGB(22, 22, 22),
				secondaryColor = Color3.fromRGB(12, 12, 12),
		
				backgroundColorCSQ = ColorSequence.new(Color3.fromRGB(36, 36, 36), Color3.fromRGB(68, 68, 68)),	
				strokeColorCSQ = ColorSequence.new{
					ColorSequenceKeypoint.new(0, Color3.fromRGB(53.00000064074993, 53.00000064074993, 53.00000064074993)),
					ColorSequenceKeypoint.new(0.15224914252758026, Color3.fromRGB(50.69031357765198, 50.69031357765198, 50.69031357765198)),
					ColorSequenceKeypoint.new(0.4723183512687683, Color3.fromRGB(255, 0, 4.000000236555934)),
					ColorSequenceKeypoint.new(0.7577854990959167, Color3.fromRGB(50.13314567506313, 50.13314567506313, 50.13314567506313)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(48.000000938773155, 48.000000938773155, 48.000000938773155))
				},
			}
		}
		
		local themeObjects = {
			font = {},
			textColor = {},
			primaryColor = {},
			secondaryColor = {},
			backgroundColorCSQ = {},
			strokeColorCSQ = {},
		}
		
		
		
		-- value method matching
		function api:sortObjects(gui)
			for _, obj in next, gui:getDescendants() do
				if obj:FindFirstChild("themedColor") then 
					if obj:FindFirstChild("themedColor").Value == "primaryColor" then
						table.insert(themeObjects.primaryColor, obj)
					elseif obj:FindFirstChild("themedColor").Value == "secondaryColor" then
						table.insert(themeObjects.secondaryColor, obj)
					elseif obj:FindFirstChild("themedColor").Value == "backgroundColorCSQ" then
						for _, find in ipairs(obj:GetChildren()) do
							if find:IsA("UIGradient") then table.insert(themeObjects.backgroundColorCSQ, find) break end
						end
					else
						warn("FRAME unknown obj: "..obj.Name)
					end
				end
				if obj:IsA("TextLabel") or obj:IsA("TextButton") then
					--print("found obj")
					
					table.insert(themeObjects.font, obj)
					table.insert(themeObjects.textColor, obj)
					--print("added to font obj",obj.Name)
				end
				if obj:IsA("UIStroke") and obj:FindFirstChildWhichIsA("UIGradient") then
					table.insert(themeObjects.strokeColorCSQ, obj:FindFirstChildWhichIsA("UIGradient"))
				end
				
			end
			--print("sorted")
		end
		
		
		--function api:sortObjects(gui)
		--	for _, obj in next, gui:getDescendants() do
		--		if obj:IsA("Frame") then 
		--			if obj.BackgroundColor == api.colors.primaryColor then
		--				table.insert(themeObjects.primaryColor, obj)
		--			elseif obj.BackgroundColor == api.colors.secondaryColor then
		--				table.insert(themeObjects.secondaryColor, obj)
		--			else
		--				warn("FRAME unknown obj: "..obj.Name)
		--				local c = obj.BackgroundColor3
						--print(string.format("color of unknown obj: (%d, %d, %d)", c.R * 255, c.G * 255, c.B * 255))
		--			end
		--		elseif obj:IsA("TextLabel") or obj:IsA("TextButton") then
					--print("found obj")
		--			if obj.BackgroundColor == api.colors.primaryColor then
		--				table.insert(themeObjects.primaryColor, obj)
		--			elseif obj.BackgroundColor == api.colors.secondaryColor then
		--				table.insert(themeObjects.secondaryColor, obj)
		--		--[[
		--			elseif obj.Font == api.colors.font then
						--print("FONT OBJECT", api.colors.font)
		--				table.insert(themeObjects.font, obj)
		--			elseif obj.Text and obj.TextColor == api.colors.textColor then
		--				table.insert(themeObjects.textColor, obj)
		--		]]
		--			else
		--				warn("TEXT unknown obj: "..obj.Name)
		--			end
		--			table.insert(themeObjects.font, obj)
		--			table.insert(themeObjects.textColor, obj)
					--print("added to font obj",obj.Name)
		--		end
		--	end
			--print("sorted")
		--end
		
		function api:updateColor(colorType, newColor)
			--print("aplying")
			--api.colors[colorType] = (colorType == "font" and newColor) or newColor
			if colorType == "font" then
				--for _, obj in next, themeObjects.font do
				--	obj.Font = newColor
				--end
				
				-- changed weights so disabeled sorry
			elseif colorType == "textColor" then
				for _, obj in next, themeObjects.textColor do
					obj.TextColor3 = newColor
				end
			elseif colorType == "primaryColor" then
				for _, obj in next, themeObjects.primaryColor do
					local s=pcall(function() obj.Color = newColor end) if s then return end
					obj.BackgroundColor3 = newColor
				end
			elseif colorType == "secondaryColor" then
				for _, obj in next, themeObjects.secondaryColor do
					local s=pcall(function() obj.Color = newColor end) if s then return end
					obj.BackgroundColor3 = newColor
				end
			elseif colorType == "backgroundColorCSQ" then
				for _, obj in next, themeObjects.backgroundColorCSQ do
					obj.Color = newColor
				end
			elseif colorType == "strokeColorCSQ" then
				for _, obj in next, themeObjects.strokeColorCSQ do
					obj.Color = newColor
				end
			end
		end
		
		function api:setColorTable(t)
			api.colors = t
			if getgenv then getgenv().YARHM_THEME = t end
		end
		
		function api:init(p)
			api:sortObjects(p)
			for colorKey, color in api.colors do
				local s, e = pcall(function() 
					api:updateColor(colorKey, color)
				end)
				if not s then warn(e) end
			end
		end
		
		getgenv().ThemeManager = api
		getgenv().ThemeObjects = themeObjects
		
		getgenv().ThemeManagerModuleObject = script
		
		return api
		
    end
    routine_module_scripts[script] = module_script
end
do -- Routine Module: StarterGui.YARHM.FlyUtility
    local script = Instance.new("ModuleScript")
    script.Name = "FlyUtility"
    script.Parent = Converted["_YARHM"]
    local function module_script()

		-- Mobile-compatible fly module
		-- Designed and written by YARHM
		
		local l={} local _=game:GetService("Players") local b=game:GetService("RunService") local d=_.LocalPlayer local h=false local e=50 local c=2 local i=0 local g=Vector3.new() local j=nil local k=nil local f=nil local function _()if f then f:Disconnect() f=nil end if j then j:Destroy() j=nil end if k then k:Destroy() k=nil end local _=d.Character if _ then local _=_:FindFirstChildOfClass("Humanoid") if _ then _.PlatformStand=false end end h=false i=0 end local function a(_)local a=d.Character if not h or not a then l:Stop() return end local _=a:FindFirstChildOfClass("Humanoid") local d=a:FindFirstChild("HumanoidRootPart") local a=workspace.CurrentCamera if not _ or _.Health<=0 or not d or not a then l:Stop() return end local _=_.MoveDirection if _.Magnitude>0.01 then i=math.min(e,i+c) g=_.Unit else i=math.max(0,i-c)end local _=Vector3.new(g.X,0,g.Z) local c=Vector3.zero if _.Magnitude>0 then c=_.Unit*i end local f=a.CFrame.LookVector.Unit local b=g:Dot(f) local _=b<0 and-1 or 1 local a=Vector3.new(f.X,0,f.Z) if a.Magnitude>0 then a=a.Unit end local a=math.abs(g:Dot(a)) local _=f.Y*_*a local _=_*i k.Velocity=Vector3.new(c.X,_,c.Z) local _=(i/e)*30 local _=-math.rad(b*_) j.CFrame=CFrame.new(d.Position,d.Position+f)*CFrame.Angles(_,0,0)end function l:Start()if h then return end local c=d.Character if not c then return end local _=c:FindFirstChildOfClass("Humanoid") local c=c:FindFirstChild("HumanoidRootPart") if not _ or not c then return end h=true j=Instance.new("BodyGyro") j.P=100000 j.MaxTorque=Vector3.new(math.huge,math.huge,math.huge) j.CFrame=c.CFrame j.Parent=c k=Instance.new("BodyVelocity") k.P=10000 k.MaxForce=Vector3.new(math.huge,math.huge,math.huge) k.Velocity=Vector3.new(0,0,0) k.Parent=c _.PlatformStand=true f=b.Heartbeat:Connect(a)end function l:Stop()if not h then return end _()end function l:SetMaxSpeed(_)if type(_)=="number"and _>=0 then e=_ else warn("FlyModule:SetMaxSpeed requires a non-negative number.")end end function l:GetMaxSpeed()return e end function l:IsFlying()return h end d.CharacterRemoving:Connect(function(_)if h then l:Stop()end end) return l
    end
    routine_module_scripts[script] = module_script
end

-- Routines:

local function WMYX_routine() -- Routine: StarterGui.YARHM.Flee the Facility
    local script = Instance.new("LocalScript")
    script.Name = "Flee the Facility"
    script.Parent = Converted["_YARHM"]
    local req = require
    local require = function(obj)
        local routine = routine_module_scripts[obj]
        if routine then
            return routine()
        end
        return req(obj)
    end


	local module = {}
	module["gameId"] = 893973440 -- Restrict module to a certain game ID only. 0 allows all games.
	if (module["gameId"] ~= game.GameId) and module["gameId"] ~= 0 then
		script.Enabled = false
	end
	
	module["Name"] = "Flee the Facility"
	
	local ts = game:GetService("TweenService")
	
	local FUNCTIONS = require(script.Parent.FUNCTIONS)
	local espindc = require(script.Parent.ESPIndicator)
	
	local espcontainer = espindc.new({ArrowEdgePadding = 50, ArrowShowDistanceText = false,})
	
	
	module.players = false
	module.pcs = false
	module.pods = false
	module.exits = false
	module.lockers = false
	
	local hideLabelsAndArrows = false
	
	module.antipcerror = false
	module.flashlight = false
	
	local esps = {}
	
	local function getBeast()
		local listplayers = game.Players:GetChildren()
		for _, player in ipairs(listplayers) do
			local character = player.Character
			if character ~= nil and character:FindFirstChild("BeastPowers") then
				return player
			end
		end
	end
	
	local function reloadESP()
		espcontainer:ClearAllGroups()
	
		--for _, i in ipairs(workspace:GetChildren()) do
		--	if i.Name == "PlayerHighlight" and not module.players then
		--		i:Destroy()
		--	end
	
		--	if i.Name == "PCHighlight" and not module.pcs then
		--		i:Destroy()
		--	end
	
		--	if i.Name == "PodsHighlight" and not module.pods then
		--		i:Destroy()
		--	end
	
		--	if i.Name == "ExitsHighlight" and not module.exits then
		--		i:Destroy()
		--	end
		--end
		
		if module.players then
			
			
			local listplayers = game.Players:GetChildren()
			for _, player in ipairs(listplayers) do
				if player ~= game.Players.LocalPlayer and player.Character ~= nil then
					local character = player.Character
					if player == getBeast() then
						espcontainer:Add(character, {
							AccentColor    =  Color3.new(1, 0, 0),
							ArrowShow        = not hideLabelsAndArrows,
							ArrowMinDistance       = 999999,           
							ArrowSize         = UDim2.new(0,40,0,40),
							LabelText         = "Beast",
							ShowLabel         = not hideLabelsAndArrows,
							GroupName         = "players"
						})
					else
						espcontainer:Add(character, {
							AccentColor    =  Color3.new(0, 1, 0),
							ArrowShow        = false,
							ShowLabel         = false,
							GroupName         = "players"
						})
					end
				end
			end
			
			
		end
		
		if module.pcs then
			
			
			for _, obj in ipairs(game.Workspace:GetDescendants()) do
				if obj.Name == "ComputerTable" then
					if obj.Screen.Color == Color3.fromRGB(40, 127, 71) then
						espcontainer:Add(obj, {
							AccentColor    =  Color3.new(0.133333, 0.333333, 0.00784314),
							ArrowShow        = false,
							ArrowShowDistanceText       = false,
							ShowLabel         = false,
							GroupName       	  = "pcs"
						})
					else
						espcontainer:Add(obj, {
							AccentColor    =  Color3.new(0, 0.37, 1),
							ArrowShow        = not hideLabelsAndArrows,
							ArrowMinDistance       = 99999,      
							ArrowShowDistanceText       = false,
							ArrowSize        		 = UDim2.new(0,10,0,10),
							ShowLabel         = false,
							GroupName       	  = "pcs"
						})
					end
				end
			end
			
			
		end
		
		if module.pods then
			
			
			for _, obj in ipairs(game.Workspace:GetDescendants()) do
				if obj.Name == "FreezePod" then
					espcontainer:Add(obj, {
						AccentColor    =  Color3.new(0, 1, 1),
						ArrowShow        = false,
						ShowLabel         = false,
						GroupName         = "pods"
					})
				end
			end
			
			
		end
		
		if module.exits then
			
			
			for _, obj in ipairs(game.Workspace:GetDescendants()) do
				if obj.Name == "ExitDoor" then
					espcontainer:Add(obj, {
						AccentColor    =  Color3.new(1, 1, 0),
						ArrowShow        = false,
						ShowLabel         = false,
						GroupName         = "exits"
					})
				end
			end
			
			
		end
		
		if module.lockers then
	
	
			for _, obj in ipairs(game:GetService("CollectionService"):GetTagged("LOCKER")) do
				espcontainer:Add(obj, {
					AccentColor    =  Color3.new(1, 0.054902, 0.623529),
					ArrowShow        = false,
					ShowLabel         = false,
					GroupName         = "lockers"
				})
			end
	
	
		end
	
		--if module.players then
	
	
	
		--	local listplayers = game.Players:GetChildren()
		--	for _, player in ipairs(listplayers) do
		--		if player ~= game.Players.LocalPlayer and player.Character ~= nil then
		--			local character = player.Character
		--			if not character:FindFirstChild("PlayerHighlight") then
		--				local a = Instance.new("Highlight", workspace)
		--				esps["PlayerHighlight"] = a
		--				a.Name = "PlayerHighlight"
		--				a.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		--				a.Adornee = character
		--				task.spawn(function()
		--					repeat
		--						task.wait(0.1)
		--						if player == getBeast() then
		--							a.FillColor = Color3.fromRGB(255,0,0)
		--						else
		--							a.FillColor = Color3.fromRGB(0,255,0)
		--						end
		--					until character == nil or a == nil
		--				end)
		--			end
		--		end
		--	end
	
	
		--end
	
		--if module.pcs then
	
	
	
	
		--	for _, obj in ipairs(game.Workspace:GetDescendants()) do
		--		if obj.Name == "ComputerTable" and not obj:FindFirstChild("PCHighlight") then
		--			local hili = Instance.new("Highlight", workspace)
		--			esps["PCHighlight"] = hili
		--			hili.Name = "PCHighlight"
		--			hili.OutlineTransparency = 1
		--			hili.Adornee = obj
		--			hili.FillColor = obj:FindFirstChild("Screen").Color
		--		end
		--	end
	
	
		--end
	
		--if module.pods then
	
	
	
		--	for _, obj in ipairs(game.Workspace:GetDescendants()) do
		--		if obj.Name == "FreezePod" then
		--			local hili = Instance.new("Highlight", workspace)
		--			esps["PodsHighlight"] = hili
		--			hili.Name = "PodsHighlight"
		--			hili.OutlineTransparency = 1
		--			hili.Adornee = obj
		--			hili.FillColor = Color3.fromRGB(0, 200, 255)
		--		end
		--	end
	
		--end
	
	
		--if module.exits then
	
	
	
		--	for _, obj in ipairs(game.Workspace:GetDescendants()) do
		--		if obj.Name == "ExitDoor" and not obj:FindFirstChild("ExitsHighlight") then
		--			local hili = Instance.new("Highlight", workspace)
		--			esps["ExitsHighlight"] = hili
		--			hili.Name = "ExitsHighlight"
		--			hili.OutlineTransparency = 1
		--			hili.Adornee = obj
		--			hili.FillColor = Color3.fromRGB(255,255,0)
		--		end
		--	end
	
		--end
	end
	
	
	
	
	table.insert(module, {
		Type = "Text",
		Args = {"ESPs"}
	})
	
	table.insert(module, {
		Type = "ButtonGrid",
		Toggleable = true, -- Recolors buttons for you onclick, you still need to save the state yourself
		Args = {3, { -- 3 is the number of columns
			Players = function(Self)
	
				if module.players then
					module.players = false
					reloadESP()
				else
					module.players = true
					reloadESP()
				end
	
	
			end,
			PCs = function(Self)
	
				if module.pcs then
					module.pcs = false
					reloadESP()
				else
					module.pcs = true
					reloadESP()
				end
	
			end,
			Pods = function(Self)
	
				if module.pods then
					module.pods = false
					reloadESP()
				else
					module.pods = true
					reloadESP()
				end
	
	
			end,
			Exits = function(Self)
	
				if module.exits then
					module.exits = false
					reloadESP()
				else
					module.exits = true
					reloadESP()
				end
	
			end,
			Lockers = function(Self)
	
				if module.lockers then
					module.lockers = false
					reloadESP()
				else
					module.lockers = true
					reloadESP()
				end
	
			end,
		}
		} 
	})
	
	table.insert(module, {
		Type = "Toggle",
		Args = {"Hide arrows and labels", function(Self, state)
			hideLabelsAndArrows = state
			reloadESP()
		end,}
	})
	
	table.insert(module, {
		Type = "Text",
		Args = {"Tools"}
	})
	
	table.insert(module, {
		Type = "Button",
		Args = {"Third person camera", function(Self)
			game.Players.LocalPlayer.CameraMode = Enum.CameraMode.Classic
			game.Players.LocalPlayer.CameraMaxZoomDistance = 400
			
			FUNCTIONS.notification("Camera unlocked for third person. Try zooming out!")
		end,}
	})
	
	table.insert(module, {
		Type = "Button",
		Args = {"Reload ESP", function(Self)
			reloadESP()
		end,}
	})
	
	
	local isGameActive = game:GetService("ReplicatedStorage"):WaitForChild("IsGameActive", 5)
	local gameStatus = game:GetService("ReplicatedStorage"):WaitForChild("GameStatus", 5)
	
	if isGameActive and gameStatus then
		isGameActive.Changed:Connect(function()
			reloadESP()
		end)
		gameStatus.Changed:Connect(function()
			reloadESP()
		end)
	end
	
	local root = game:GetService("Players").LocalPlayer.Character:WaitForChild("HumanoidRootPart")
	
	light = Instance.new("PointLight", root)
	light.Brightness = 0
	light.Range = 9999999999
	
	local wslock = false
	local ws = 18
	
	local antifail = false
	
	
	task.spawn(function() 
		if game:GetService("RunService"):IsStudio() then return end -- :)
	
		local OldNameCall = nil
	
		OldNameCall = hookmetamethod(game, "__namecall", function(Self, ...)
			local Args = {...}
			local NamecallMethod = getnamecallmethod()
	
			if NamecallMethod == "FireServer" and Args[1] == "SetPlayerMinigameResult" and antifail then
				print("Minigame result - Intercepting result to true")
				Args[2] = true
			end
	
			return OldNameCall(Self, unpack(Args))
		end)
	
	end)
	
	
	table.insert(module, {
		Type = "ButtonGrid",
		Toggleable = true,
		Args = {3, {
			Anti_PC_Error = function()
				if antifail then antifail = false else antifail = true end
			end,
			Flashlight = function()
				if light.Brightness == 0 then
					light.Brightness = 2.5
				else
					light.Brightness = 0
				end
			end,
		}}
	})
	
	task.spawn(function()
		while task.wait(0.1) do
			if wslock then
				root.Parent:WaitForChild("Humanoid").WalkSpeed = ws
			end
		end
	end)
	
	table.insert(module, {
		Type = "Input",
		Args = {"Input a walkspeed", "Set & Lock", function(Self, text)
			if not tonumber(text) then
				FUNCTIONS.notification("Input isn't a valid number.")
				return
			end
	
			ws = tonumber(text)
			wslock = true
		end,}
	})
	
	table.insert(module, {
		Type = "Button",
		Args = {"Unlock all", function()
			wslock = false
		end,}
	})
	
	table.insert(module, {
		Type = "Text",
		Args = {"Locking means your speed will stay the same no matter what. This means you will not be slow when crawling or jumping as beast."}
	})
	
	repeat task.wait() until getgenv().Modules
	getgenv().Modules[2] = module
end
local function CEBY_routine() -- Routine: StarterGui.YARHM.Universal
    local script = Instance.new("LocalScript")
    script.Name = "Universal"
    script.Parent = Converted["_YARHM"]
    local req = require
    local require = function(obj)
        local routine = routine_module_scripts[obj]
        if routine then
            return routine()
        end
        return req(obj)
    end


	local module = {}
	module["gameId"] = 0 -- Restrict module to a certain game ID only. 0 allows all games.
	if (module["gameId"] ~= game.GameId) and module["gameId"] ~= 0 then
		script.Enabled = true
	end
	
	local ts = game:GetService("TweenService")
	local uis = game:GetService("UserInputService")
	local rs = game:GetService("RunService")
	local https = game:GetService("HttpService")
	local Players = game:GetService("Players")
	
	local fu = require(script.Parent.FUNCTIONS)
	local theme = require(script.Parent.Theme)
	local espind = require(script.Parent.ESPIndicator)
	local flyutility = require(script.Parent.FlyUtility)
	local PointSave = require(script.Parent.PointSave)
	
	
	local loopfovandws = false
	local ctrlclicktp = false
	local ws = 16
	local fov = 70
	
	local hidden = false
	
	local YARHMPointSave = PointSave.new("YARHM")
	
	function splitString(str,delim)
		local broken = {}
		if delim == nil then delim = "," end
		for w in string.gmatch(str,"[^"..delim.."]+") do
			table.insert(broken,w)
		end
		return broken
	end
	
	function toTokens(str)
		local tokens = {}
		for op,name in string.gmatch(str,"([+-])([^+-]+)") do
			table.insert(tokens,{Operator = op,Name = name})
		end
		return tokens
	end
	
	function onlyIncludeInTable(tab,matches)
		local matchTable = {}
		local resultTable = {}
		for i,v in pairs(matches) do matchTable[v.Name] = true end
		for i,v in pairs(tab) do if matchTable[v.Name] then table.insert(resultTable,v) end end
		return resultTable
	end
	
	function removeTableMatches(tab,matches)
		local matchTable = {}
		local resultTable = {}
		for i,v in pairs(matches) do matchTable[v.Name] = true end
		for i,v in pairs(tab) do if not matchTable[v.Name] then table.insert(resultTable,v) end end
		return resultTable
	end
	
	function getPlayersByName(Name)
		local Name,Len,Found = string.lower(Name),#Name,{}
		for _,v in pairs(Players:GetPlayers()) do
			if Name:sub(0,1) == '@' then
				if string.sub(string.lower(v.Name),1,Len-1) == Name:sub(2) then
					table.insert(Found,v)
				end
			else
				if string.sub(string.lower(v.Name),1,Len) == Name or string.sub(string.lower(v.DisplayName),1,Len) == Name then
					table.insert(Found,v)
				end
			end
		end
		return Found
	end
	
	function getPlayer(list,speaker)
		if list == nil then return {speaker.Name} end
		local nameList = splitString(list,",")
	
		local foundList = {}
	
		for _,name in pairs(nameList) do
			if string.sub(name,1,1) ~= "+" and string.sub(name,1,1) ~= "-" then name = "+"..name end
			local tokens = toTokens(name)
			local initialPlayers = Players:GetPlayers()
	
			for i,v in pairs(tokens) do
				if v.Operator == "+" then
					local tokenContent = v.Name
					local foundCase = false
	
					if not foundCase then
						initialPlayers = onlyIncludeInTable(initialPlayers,getPlayersByName(tokenContent))
					end
				else
					local tokenContent = v.Name
					local foundCase = false
	
					if not foundCase then
						initialPlayers = removeTableMatches(initialPlayers,getPlayersByName(tokenContent))
					end
				end
			end
	
			for i,v in pairs(initialPlayers) do table.insert(foundList,v) end
		end
	
		local foundNames = {}
		for i,v in pairs(foundList) do table.insert(foundNames,v.Name) end
	
		return foundNames[1]
	end
	
	
	
	task.spawn(function()
		rs.RenderStepped:Connect(function()
			if loopfovandws then
				workspace.CurrentCamera.FieldOfView = fov
				if game.Players.LocalPlayer.Character then
					if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
						game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = ws
					end
				end
			end
		end)
	end)
	
	uis.InputBegan:Connect(function(inp, proc)
		if proc then return end
	
		if uis:IsKeyDown(Enum.KeyCode.LeftControl) and inp.KeyCode == Enum.KeyCode.Y and hidden then
			hidden = false
			ts:Create(script.Parent.Menu.UIScale, TweenInfo.new(1, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
				Scale = 1
			}):Play()
		end
	end)
	
	local function getPlayerMouse()
		local player = game:GetService("Players").LocalPlayer
		if player then
			return player:GetMouse()
		end
		return nil
	end
	
	-- Function to cast a ray from the cursor to the furthest object
	local function getRayHitPosition()
		local mouse = getPlayerMouse()
		if not mouse then
			return nil
		end
	
		local camera = workspace.CurrentCamera
		local unitRay = camera:ScreenPointToRay(mouse.X, mouse.Y)
		local ray = Ray.new(unitRay.Origin, unitRay.Direction * 1000) -- Adjust the range as needed
	
		local part, position = workspace:FindPartOnRay(ray, game:GetService("Players").LocalPlayer.Character)
	
		if part then
			return position
		else
			return nil
		end
	end
	
	uis.InputBegan:Connect(function(inp, proc)
		if proc then return end
	
		if uis:IsKeyDown(Enum.KeyCode.LeftControl) and inp.UserInputType == Enum.UserInputType.MouseButton1 and ctrlclicktp then
			local ray = getRayHitPosition()
			if not ray then fu.notification("Couldn't find a place to teleport to.") return end
			game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(ray)
		end
	end)
	
	if uis.AccelerometerEnabled then
		uis.DeviceAccelerationChanged:Connect(function(acc)
			if hidden and acc.Position.Magnitude > 28 then
				hidden = false
				ts:Create(script.Parent.Menu.UIScale, TweenInfo.new(1, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
					Scale = 1
				}):Play()
			end 
		end)
	end
	
	--local flyob = flyutility.new(Players.LocalPlayer)
	
	
	module["Name"] = "Universal"
	
	local ts = game:GetService("TweenService")
	
	--table.insert(module, {
	--	Type = "Text",
	--	Args = {"Welcome to YARHM! The open, free script hub."}
	--})
	
	table.insert(module, {
		Type = "Text",
		Args = {"<font color='#FFFF00'>Another great script</font> by YARHM developers below!"}
	})
	
	table.insert(module, {
		Type = "Button",
		Args = {"AFEM Max - The best AI-powered emote script!", function()
			loadstring(game:HttpGet("https://yarhm.mhi.im/scr?channel=afemmax"))()
			fu.notification("AFEM has been executed.")
		end,}
	})
	
	
	table.insert(module, {
		Type = "Text",
		Args = {"---"}
	})
	
	table.insert(module, {
		Type = "Button",
		Args = {"Join our Discord", function(Self)
			if setclipboard then setclipboard("https://discord.gg/2jbYxvDkxr") end
			fu.notification('Discord link has been copied to clipboard!')
		end,}
	})
	
	table.insert(module, {
		Type = "Toggle",
		Args = {"OP Fly", function(Self, state)
			if state then
				flyutility:Start(Players.LocalPlayer.Character)
			else
				flyutility:Stop(Players.LocalPlayer.Character)
			end
		end}
	})
	
	table.insert(module, {
		Type = "Range",
		Args = {"Fly speed", 50, 350, 10, function(Self, spd)
			--print(spd)
			flyutility:SetMaxSpeed(spd)
		end}
	})
	
	local infJump = false
	local infJumpConnection = nil
	local landedConnection = nil
	
	local infJumps = 0
	local infJumpDeb = false
	local infJumpOnlyTwo = false
	local landed = true
	
	local function setupHumanoid(humanoid)
		if landedConnection then landedConnection:Disconnect() end
	
		landedConnection = humanoid.StateChanged:Connect(function(_, n)
			if n == Enum.HumanoidStateType.Landed or n == Enum.HumanoidStateType.Running then
	
				landed = true
				infJumps = 0
			end
		end)
	end
	
	table.insert(module, {
		Type = "Toggle",
		Args = {"Infinite jump", function(Self, state)
			infJump = state
	
			if state then
				local char = game.Players.LocalPlayer.Character
				if char and char:FindFirstChildWhichIsA("Humanoid") then
					setupHumanoid(char:FindFirstChildWhichIsA("Humanoid"))
				end
	
				infJumpConnection = uis.JumpRequest:Connect(function()
					local character = game.Players.LocalPlayer.Character
					local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")
	
					if not humanoid then return end
	
					if infJumpOnlyTwo and infJumps >= 2 and not landed then
						--print(infJumpOnlyTwo)
						--print(infJumps)
						--print(landed)
						return end
	
					if not infJumpDeb then
						infJumpDeb = true
						humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
						infJumps += 1
						landed = false
	
						task.wait(.1)
						infJumpDeb = false
					end
				end)
			else
				if infJumpConnection then infJumpConnection:Disconnect() end
				if landedConnection then landedConnection:Disconnect() end
				infJumps = 0
				landed = true
			end
		end}
	})
	
	table.insert(module, {
		Type = "Toggle",
		Args = {"Limit infinite jump to 2 jumps only", function(Self, state)
			infJumpOnlyTwo = state
			infJumps = 0 
		end}
	})
	
	
	local aggressiveExp = false
	local hitboxExp = 1
	table.insert(module, {
		Type = "Input",
		Args = {"Hitbox expander", "Expand everyone's hitbox", function(Self, ToExpand)
			hitboxExp = ToExpand
			local players = game:GetService("Players"):GetPlayers()
			for i,v in ipairs(players) do
				if v ~= game.Players.LocalPlayer and v.Character:FindFirstChild('HumanoidRootPart') then
					local sizeArg = tonumber(ToExpand)
					local Size = Vector3.new(sizeArg,sizeArg,sizeArg)
					if aggressiveExp then
						for _, part in ipairs(v.Character:GetChildren()) do
							if part:IsA("BasePart") then
								if not ToExpand or sizeArg == 1 then
									part.Size = Vector3.new(2,1,1)
									part.Transparency = 0.2
								else
									part.Size = Size
									part.Transparency = 0.2
								end
								--part.CanCollide = false
							end
						end
					else
						local Root = v.Character:FindFirstChild('HumanoidRootPart')
						if Root:IsA("BasePart") then
							if not ToExpand or sizeArg == 1 then
								Root.Size = Vector3.new(2,1,1)
								Root.Transparency = 0.2
							else
								Root.Size = Size
								Root.Transparency = 0.2
							end
							Root.CanCollide = false
						end
					end
				end
			end
			fu.notification("Hitboxes expanded.")
		end,}
	})
	
	local loopHitBoxExp
	table.insert(module, {
		Type = "Toggle",
		Args = {"Loop hitbox expansion", function(Self, state)
			if state then
				loopHitBoxExp = rs.Heartbeat:Connect(function()
					local players = game:GetService("Players"):GetPlayers()
					for i,v in ipairs(players) do
						if v ~= game.Players.LocalPlayer and v.Character:FindFirstChild('HumanoidRootPart') then
							local sizeArg = tonumber(hitboxExp)
							local Size = Vector3.new(sizeArg,sizeArg,sizeArg)
							local Root = v.Character:FindFirstChild('HumanoidRootPart')
							if aggressiveExp then
								for _, part in ipairs(v.Character:GetChildren()) do
									if part:IsA("BasePart") then
										if not hitboxExp or sizeArg == 1 then
											part.Size = Vector3.new(2,1,1)
											part.Transparency = 0.2
										else
											part.Size = Size
											part.Transparency = 0.2
										end
										--part.CanCollide = false
									end
								end
							else
								local Root = v.Character:FindFirstChild('HumanoidRootPart')
								if Root:IsA("BasePart") then
									if not hitboxExp or sizeArg == 1 then
										Root.Size = Vector3.new(2,1,1)
										Root.Transparency = 0.2
									else
										Root.Size = Size
										Root.Transparency = 0.2
									end
									Root.CanCollide = false
								end
							end
						end
					end
				end)
			else
				loopHitBoxExp:Disconnect()
			end
		end,}
	})
	
	table.insert(module, {
		Type = "Toggle",
		Args = {"Aggressive hitbox expasion (all parts)", function(Self, state)
			aggressiveExp = state
		end,}
	})
	
	table.insert(module, {
		Type = "Input",
		Args = {"Walkspeed", "Set speed", function(Self, speed)
			local lp = game:GetService("Players").LocalPlayer
			local char = lp.Character
			if not char then fu.notification("No character!") return end
			local hu = char:FindFirstChildOfClass("Humanoid")
			if not hu then fu.notification("No humanoid on your character..?") return end
			hu.WalkSpeed = tonumber(speed) or 16
			fu.notification("Walkspeed set.")
			ws = tonumber(speed) or 16
		end,}
	})
	
	
	local walkspeedInDeCrement = 2
	table.insert(module, {
		Type = "Button",
		Args = {"Increase walkspeed", function(Self)
			local lp = game:GetService("Players").LocalPlayer
			local char = lp.Character
			if not char then fu.notification("No character!") return end
			local hu = char:FindFirstChildOfClass("Humanoid")
			if not hu then fu.notification("No humanoid on your character..?") return end
			ws = ws + walkspeedInDeCrement
			hu.WalkSpeed = hu.WalkSpeed + walkspeedInDeCrement
			fu.notification("Walkspeed is now ".. hu.WalkSpeed)
		end,}
	})
	
	table.insert(module, {
		Type = "Button",
		Args = {"Decrease walkspeed", function(Self)
			local lp = game:GetService("Players").LocalPlayer
			local char = lp.Character
			if not char then fu.notification("No character!") return end
			local hu = char:FindFirstChildOfClass("Humanoid")
			if not hu then fu.notification("No humanoid on your character..?") return end
			ws = ws - walkspeedInDeCrement
			hu.WalkSpeed = hu.WalkSpeed - walkspeedInDeCrement
			fu.notification("Walkspeed is now ".. hu.WalkSpeed)
		end,}
	})
	
	table.insert(module, {
		Type = "Input",
		Args = {"Walkspeed increment (How big each increase/decrease is)", "Set", function(Self, input)
			walkspeedInDeCrement = tonumber(input) or 2
			if not tonumber(input) then fu.notification("Not a number. Setting to default (2).") end
			fu.notification("Set walkspeed increment to ".. walkspeedInDeCrement)
		end,}
	})
	
	table.insert(module, {
		Type = "Input",
		Args = {"FOV change", "Set FOV", function(Self, tofov)
			if not tonumber(tofov) then fu.notification("Not a number. Setting to default.") end
			ts:Create(workspace.CurrentCamera, TweenInfo.new(1, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
				FieldOfView = tonumber(tofov) or 70
			}):Play()
			fov = tonumber(tofov) or 70
		end,}
	})
	
	table.insert(module, {
		Type = "Toggle",
		Args = {"Loop walkspeed and FOV", function(Self, state)
			loopfovandws = state
		end,}
	})
	
	
	if uis.KeyboardEnabled and uis.MouseEnabled then
		table.insert(module, {
			Type = "Toggle",
			Args = {"CTRL+Click Teleport", function(Self, state)
				ctrlclicktp = state
			end,}
		})
	end
	
	table.insert(module, {
		Type = "Text",
		Args = {"Teleports"}
	})
	
	local function gotoPlayer(targetPlayerName)
		local targetPlayer = Players:FindFirstChild(getPlayer(targetPlayerName, game.Players.LocalPlayer))
		if targetPlayer then
			local character = targetPlayer.Character
			if character and character:FindFirstChild("HumanoidRootPart") then
				local targetPosition = character.HumanoidRootPart.Position
				local playerCharacter = Players.LocalPlayer.Character
				if playerCharacter and playerCharacter:FindFirstChild("HumanoidRootPart") then
					playerCharacter.HumanoidRootPart.CFrame = CFrame.new(targetPosition + Vector3.new(0, 5, 0))
				end
			end
		else
			print("Player '" .. targetPlayerName .. "' not found.")
		end
	end
	
	table.insert(module, {
		Type = "Input",
		Args = {
			"Enter player's name", 
			"Teleport", 
			function(Self, text)
				gotoPlayer(text)
			end
		}
	})
	
	local spectateLoop = nil
	table.insert(module, {
		Type = "Button",
		Args = {"Spectate players", function(Self)
			local listofplayers = game.Players:GetPlayers()
			local currentlyViewing = 1
			local currentPlayer = listofplayers[currentlyViewing]
			if not currentPlayer then return end
			workspace.CurrentCamera.CameraSubject = currentPlayer.Character.Humanoid
			spectateLoop = task.spawn(function()
				while true do
					fu.dialog("Spectating...", "Now spectating: " .. workspace.CurrentCamera.CameraSubject.Parent.Name, {"Previous", "Stop", "Next"})
					local action = fu.waitfordialog()
					if action == "Stop" then
						fu.closedialog()
						workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character.Humanoid
						task.cancel(spectateLoop)
						break
					elseif action == "Next" then
						currentlyViewing = currentlyViewing + 1
						if currentlyViewing > #listofplayers then
							currentlyViewing = 1
						end
						currentPlayer = listofplayers[currentlyViewing]
						if not currentPlayer then return end
						workspace.CurrentCamera.CameraSubject = currentPlayer.Character.Humanoid
					elseif action == "Previous" then
						currentlyViewing = currentlyViewing - 1
						if currentlyViewing < 1 then
							currentlyViewing = #listofplayers
						end
						currentPlayer = listofplayers[currentlyViewing]
						if not currentPlayer then return end
						workspace.CurrentCamera.CameraSubject = currentPlayer.Character.Humanoid
					end
				end
	
			end)
		end,}
	})
	
	table.insert(module, {
		Type = "Text",
		Args = {"Aim locking"}
	})
	
	local aimlockrscon
	local target
	
	table.insert(module, {
		Type = "Input",
		Args = {"Target player", "Set target", function(Self, input)
			if not Players:FindFirstChild(getPlayer(input, game.Players.LocalPlayer)) then
				fu.notification("Player not found.")
				return
			end
			fu.notification("Target is set to " .. Players:FindFirstChild(getPlayer(input, game.Players.LocalPlayer)).Name)
			target = Players:FindFirstChild(getPlayer(input, game.Players.LocalPlayer))
		end,}
	})
	
	local aimlock = false
	local cam = workspace.CurrentCamera
	table.insert(module, {
		Type = "Button",
		Args = {"Aim lock", function(Self)
			if aimlock then return end
			if aimlockrscon then aimlockrscon:Disconnect() end
			if not target then fu.notification("Set a target first.") return end
			aimlockrscon = rs.RenderStepped:Connect(function()
				if not target then fu.notification("No valid target.") aimlockrscon:Disconnect() return end
				if not target.Character then return end
				if not target.Character:FindFirstChild("HumanoidRootPart") then return end
				cam.CFrame = CFrame.new(cam.CFrame.Position, target.Character:FindFirstChild("HumanoidRootPart").Position)
			end)
			aimlock = true
			fu.notification("Aim lock is now on.")
		end,}
	})
	
	table.insert(module, {
		Type = "Button",
		Args = {"Unaim lock", function(Self)
			if not aimlock then return end
			aimlock = false
			if aimlockrscon then aimlockrscon:Disconnect() end
			fu.notification("Aim lock is now off.")
		end,}
	})
	
	
	
	
	table.insert(module, {
		Type = "Text",
		Args = {"Fling"}
	})
	
	local playerToFling
	table.insert(module, {
		Type = "Input",
		Args = {"Target fling player", "Set target", function(Self, input)
			if not Players:FindFirstChild(getPlayer(input, game.Players.LocalPlayer)) then
				fu.notification("Player not found.")
				return
			end
			fu.notification("Target is set to " .. Players:FindFirstChild(getPlayer(input, game.Players.LocalPlayer)).Name)
			playerToFling = Players:FindFirstChild(getPlayer(input, game.Players.LocalPlayer))
		end,}
	})
	
	
	local antiFling = false
	table.insert(module, {
		Type = "ButtonGrid",
		Args = {1, {
	
			Fling = function(Self)
				if not playerToFling then
					fu.notification("You need to target a player to fling.")
					return
				end
				if not Players:FindFirstChild(playerToFling.Name) then
					fu.notification("You need to target a player to fling.")
					return
				end
				if antiFling then
					fu.notification("Turn off anti-fling to use fling.")
					return
				end
	
				local player = game.Players.LocalPlayer
				local mouse = player:GetMouse()
				local Targets = {playerToFling}
	
				local Players = game:GetService("Players")
				local Player = Players.LocalPlayer
	
				local AllBool = false
	
				local SkidFling = function(TargetPlayer)
					local Character = Player.Character
					local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
					local RootPart = Humanoid and Humanoid.RootPart
	
					local TCharacter = TargetPlayer.Character
					local THumanoid
					local TRootPart
					local THead
					local Accessory
					local Handle
	
					if TCharacter:FindFirstChildOfClass("Humanoid") then
						THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
					end
					if THumanoid and THumanoid.RootPart then
						TRootPart = THumanoid.RootPart
					end
					if TCharacter:FindFirstChild("Head") then
						THead = TCharacter.Head
					end
					if TCharacter:FindFirstChildOfClass("Accessory") then
						Accessory = TCharacter:FindFirstChildOfClass("Accessory")
					end
					if Accessory and Accessory:FindFirstChild("Handle") then
						Handle = Accessory.Handle
					end
	
					if Character and Humanoid and RootPart then
						if RootPart.Velocity.Magnitude < 50 then
							getgenv().OldPos = RootPart.CFrame
						end
						if THumanoid and THumanoid.Sit and not AllBool then
						end
						if THead then
							if THead.Velocity.Magnitude > 500 then
								fu.dialog("Player flung", "Player is already flung. Fling again?", {"Fling again", "No"})
								if fu.waitfordialog() == "No" then return fu.closedialog() end
								fu.closedialog()
							end
						elseif not THead and Handle then
							if Handle.Velocity.Magnitude > 500 then
								fu.dialog("Player flung", "Player is already flung. Fling again?", {"Fling again", "No"})
								if fu.waitfordialog() == "No" then return fu.closedialog() end
								fu.closedialog()
							end
						end
	
	
						if THead then
							workspace.CurrentCamera.CameraSubject = THead
						elseif not THead and Handle then
							workspace.CurrentCamera.CameraSubject = Handle
						elseif THumanoid and TRootPart then
							workspace.CurrentCamera.CameraSubject = THumanoid
						end
						if not TCharacter:FindFirstChildWhichIsA("BasePart") then
							return
						end
	
						local FPos = function(BasePart, Pos, Ang)
							RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
							Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
							RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
							RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
						end
	
						local SFBasePart = function(BasePart)
							local TimeToWait = 2
							local Time = tick()
							local Angle = 0
	
							repeat
								if RootPart and THumanoid then
									if BasePart.Velocity.Magnitude < 50 then
										Angle = Angle + 100
	
										FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0 ,0))
										task.wait()
	
										FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
										task.wait()
	
										FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
										task.wait()
	
										FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
										task.wait()
	
										FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
										task.wait()
	
										FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
										task.wait()
									else
										FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
										task.wait()
	
										FPos(BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0, 0, 0))
										task.wait()
	
										FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
										task.wait()
	
										FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
										task.wait()
	
										FPos(BasePart, CFrame.new(0, -1.5, -TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(0, 0, 0))
										task.wait()
	
										FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
										task.wait()
	
										FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
										task.wait()
	
										FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
										task.wait()
	
										FPos(BasePart, CFrame.new(0, -1.5 ,0), CFrame.Angles(math.rad(-90), 0, 0))
										task.wait()
	
										FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
										task.wait()
									end
								else
									break
								end
							until BasePart.Velocity.Magnitude > 500 or BasePart.Parent ~= TargetPlayer.Character or TargetPlayer.Parent ~= Players or TargetPlayer.Character ~= TCharacter or THumanoid.Sit or Humanoid.Health <= 0 or tick() > Time + TimeToWait
						end
	
						workspace.FallenPartsDestroyHeight = 0/0
	
						local BV = Instance.new("BodyVelocity")
						BV.Name = "EpixVel"
						BV.Parent = RootPart
						BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
						BV.MaxForce = Vector3.new(1/0, 1/0, 1/0)
	
						Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
	
						if TRootPart and THead then
							if (TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 then
								SFBasePart(THead)
							else
								SFBasePart(TRootPart)
							end
						elseif TRootPart and not THead then
							SFBasePart(TRootPart)
						elseif not TRootPart and THead then
							SFBasePart(THead)
						elseif not TRootPart and not THead and Accessory and Handle then
							SFBasePart(Handle)
						else
							fu.notification("Can't find a proper part of target player to fling.")
						end
	
						BV:Destroy()
						Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
						workspace.CurrentCamera.CameraSubject = Humanoid
	
						repeat
							RootPart.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0)
							Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, .5, 0))
							Humanoid:ChangeState("GettingUp")
							table.foreach(Character:GetChildren(), function(_, x)
								if x:IsA("BasePart") then
									x.Velocity, x.RotVelocity = Vector3.new(), Vector3.new()
								end
							end)
							task.wait()
						until (RootPart.Position - getgenv().OldPos.p).Magnitude < 25
						workspace.FallenPartsDestroyHeight = getgenv().FPDH
					else
						fu.notification("No valid character of said target player. May have died.")
					end
				end
				SkidFling(Targets[1])
				-- this whole thing is skidded LMAOO
			end,
	
			--Stop_Fling = function(Self)
			--	if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart"):FindFirstChild("BodyAngularVelocity") then
			--		game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart"):FindFirstChild("BodyAngularVelocity"):Destroy()
			--	end
			--end,
		}
		}
	})
	
	
	local antiFlingLastPos = Vector3.zero
	local flingNeutralizerCon
	local flingDetectionCon
	local detectedPlayers = {}
	table.insert(module, {
		Type = "Toggle",
		Args = {"Anti-fling", function(Self, state)
			antiFling = state
			if state then
				fu.notification("Anti-fling activated.")
				flingDetectionCon = rs.Heartbeat:Connect(function()
					for _, pl in ipairs(game:GetService("Players"):GetPlayers()) do
						if pl.Character:IsDescendantOf(workspace) then
							if pl.Character.PrimaryPart.AssemblyAngularVelocity.Magnitude > 50 or pl.Character.PrimaryPart.AssemblyLinearVelocity.Magnitude > 100 then
								if not detectedPlayers[pl.Name] then
									fu.notification("A flinger has been detected with the name " .. pl.Name .. "!")
									detectedPlayers[pl.Name] = true	
								end
	
								for _, p in ipairs(pl.Character:GetDescendants()) do
									if p:IsA("BasePart") then
										p.CanCollide = false
										p.AssemblyAngularVelocity = Vector3.zero
										p.AssemblyLinearVelocity = Vector3.zero
										p.CustomPhysicalProperties = PhysicalProperties.new(0,0,0)
									end
								end
							end
						end
					end
				end)
	
				flingNeutralizerCon = rs.Heartbeat:Connect(function()
					if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character.PrimaryPart then
						if game.Players.LocalPlayer.Character.PrimaryPart.AssemblyLinearVelocity.Magnitude > 250 or  game.Players.LocalPlayer.Character.PrimaryPart.AssemblyAngularVelocity.Magnitude > 250 then
							fu.notification("You were flung. Neutralizing velocity!")
							game.Players.LocalPlayer.Character.PrimaryPart.AssemblyLinearVelocity = Vector3.zero
							game.Players.LocalPlayer.Character.PrimaryPart.AssemblyAngularVelocity = Vector3.zero
							if antiFlingLastPos ~= Vector3.zero then
								game.Players.LocalPlayer.Character.PrimaryPart.CFrame = CFrame.new(antiFlingLastPos)
							end
						else
							antiFlingLastPos = game.Players.LocalPlayer.Character.PrimaryPart.Position
						end
					end
				end)
			else
				flingDetectionCon:Disconnect()
				flingNeutralizerCon:Disconnect()
				detectedPlayers = {}
				fu.notification("Anti-fling deactivated.")
			end
		end,}
	})
	
	table.insert(module, {
		Type = "Text",
		Args = {"Miscellaneous"}
	})
	
	-- taken (corporate term for skidded) from infyiff
	table.insert(module, {
		Type = "Button",
		Args = {"Anti AFK detection", function(Self)
			local pl = game.Players.LocalPlayer
			if getconnections then
				for _, connection in pairs(getconnections(pl.Idled)) do
					if connection["Disable"] then
						connection["Disable"](connection)
					elseif connection["Disconnect"] then
						connection["Disconnect"](connection)
					end
				end
			else
				pl.Idled:Connect(function()
					game:GetService("VirtualUser"):CaptureController()
					game:GetService("VirtualUser"):ClickButton2(Vector2.new())
				end)
			end
			
		end,}
	})
	
	--table.insert(module, {
	--	Type = "Dropdown",
	--	Args = {"Player to fling", function()
	--		local playersAsStrings = {"None"}
	--		for _, p in ipairs(game.Players:GetPlayers()) do
	--			table.insert(playersAsStrings, p.Name)
	--		end
	--		return playersAsStrings
	--	end,
	
	--	function(Self, selected)
	--		print(selected)
	--	end,}
	--})
	
	pcall(function()
		if game:GetService("CoreGui"):FindFirstChild("DeltaIcon") then
			table.insert(module, {
				Type = "Toggle",
				Args = {"Hide Delta Icon", function(Self, state)
					game:GetService("CoreGui"):FindFirstChild("DeltaIcon").Enabled = state
				end,}
			})
		end
	end)
	
	
	
	
	table.insert(module, {
		Type = "Button",
		Args = {"Hide YARHM", function(Self)
			if uis.KeyboardEnabled then
				ts:Create(script.Parent.Menu.UIScale, TweenInfo.new(0.6, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
					Scale = 0
				}):Play()
				hidden=true
				fu.notification("Press CTRL+SHIFT+Y to bring back the menu.")
			elseif uis.AccelerometerEnabled then
				ts:Create(script.Parent.Menu.UIScale, TweenInfo.new(0.6, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
					Scale = 0
				}):Play()
				hidden=true
				fu.notification("Shake your device to bring back the menu.")
			else
				fu.notification("Can't hide YARHM!") -- how else are you gonna open???
			end
		end,}
	}
	)
	
	table.insert(module, {
		Type = "Button",
		Args = {"FPS Boost", function(Self)
			fu.dialog("FPS boosting", "FPS boosting can have unpredictable effects. You may instead lag more using this!", {"FPS boost anyway", "Nevermind"})
			local result = fu.waitfordialog()
			fu.closedialog()
			if result == "FPS boost anyway" then
				local Terrain = workspace:FindFirstChildOfClass('Terrain')
				Terrain.WaterWaveSize = 0
				Terrain.WaterWaveSpeed = 0
				Terrain.WaterReflectance = 0
				Terrain.WaterTransparency = 0
				game.Lighting.GlobalShadows = false
				game.Lighting.FogEnd = 9e9
				pcall(function()
					settings().Rendering.QualityLevel = 1
				end)
				for i,v in pairs(game:GetDescendants()) do
					if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
						v.Material = "Plastic"
						v.Reflectance = 0
					elseif v:IsA("Decal") then
						v.Transparency = 1
					elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
						v.Lifetime = NumberRange.new(0)
					elseif v:IsA("Explosion") then
						v.BlastPressure = 1
						v.BlastRadius = 1
					end
				end
				for i,v in pairs(game.Lighting:GetDescendants()) do
					if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
						v.Enabled = false
					end
				end
				workspace.DescendantAdded:Connect(function(child)
					task.spawn(function()
						if child:IsA('ForceField') then
							rs.Heartbeat:Wait()
							child:Destroy()
						elseif child:IsA('Sparkles') then
							rs.Heartbeat:Wait()
							child:Destroy()
						elseif child:IsA('Smoke') or child:IsA('Fire') then
							rs.Heartbeat:Wait()
							child:Destroy()
						end
					end)
				end)
			end
		end,}
	})
	
	local rsloopconnectionfling
	local clip = true
	local nocliploop
	
	
	table.insert(module, {
		Type = "ButtonGrid",
		Args = {2, {
			Noclip = function()
				clip = false
				nocliploop = rs.Stepped:Connect(function()
					if clip == false and game.Players.LocalPlayer.Character ~= nil then
						for _, child in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
							if child:IsA("BasePart") and child.CanCollide == true then
								child.CanCollide = false
							end
						end
					end
				end)
			end,
	
			Reclip = function()
				if clip then return end
				clip = true
				nocliploop:Disconnect()
				fu.notification("Reclipping may need you to reset your character.")
			end,
		}}})
	
	
	
	table.insert(module, {
		Type = "Text",
		Args = {"Other"}
	})
	
	--table.insert(module, {
	--	Type = "Button",
	--	Args = {"Lock/unlock a floating button", function()
	--		fu.lockMode = true
	--		fu.notification("Click/tap a floating button to lock/unlock...")
	--	end,}
	--})
	
	table.insert(module, {
		Type = "Button",
		Args = {"Get ping", function(Self)
			fu.notification(game.Players.LocalPlayer:GetNetworkPing() * 1000)
		end,}
	})
	
	table.insert(module, {
		Type = "Button",
		Args = {"Open developer console (debugging)", function(Self)
			game.StarterGui:SetCore("DevConsoleVisible", true)
			--getgenv().YARHM.Open.UIStroke.Transparency = 0
			--getgenv().YARHM.Open.TextTransparency = 0
			--ts:Create(getgenv().YARHM.Open, TweenInfo.new(1, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
			--	Position = UDim2.fromScale(0.5, 0.903)
			--}):Play()
	
			--ts:Create(getgenv().YARHM.Open.UIStroke, TweenInfo.new(1), {
			--	Transparency = 1
			--}):Play()
			--ts:Create(getgenv().YARHM.Open, TweenInfo.new(1), {
			--	TextTransparency = 1
			--}):Play()
		end}
	}
	)
	
	function themeSerialize(data)
		local function s(v)
			local t = typeof(v)
			if t == "number" or t == "string" or t == "boolean" then
				return v
			elseif t == "Color3" then
				return {__type="Color3", r=math.floor(v.R*255+0.5), g=math.floor(v.G*255+0.5), b=math.floor(v.B*255+0.5)}
			elseif t == "EnumItem" then
				return {__type="EnumItem", enumType=v.EnumType.Name, name=v.Name}
			elseif t == "ColorSequence" then
				local kp = {}
				for _, k in ipairs(v.Keypoints) do
					table.insert(kp, {t=k.Time, v={r=math.floor(k.Value.R*255+0.5), g=math.floor(k.Value.G*255+0.5), b=math.floor(k.Value.B*255+0.5)}})
				end
				return {__type="ColorSequence", keypoints=kp}
			elseif t == "table" then
				local out = {}
				for k, val in pairs(v) do
					if k ~= "font" then out[k] = s(val) end
				end
				return out
			else
				error("Unsupported type: " .. t)
			end
		end
		return s(data)
	end
	
	function themeDeserialize(data)
		local function d(v)
			if typeof(v) ~= "table" then return v end
			if v.__type == "Color3" then
				return Color3.fromRGB(v.r, v.g, v.b)
			elseif v.__type == "EnumItem" then
				local e = Enum[v.enumType] return e and e[v.name] or nil
			elseif v.__type == "ColorSequence" then
				local kps = {}
				for _, k in ipairs(v.keypoints) do
					table.insert(kps, ColorSequenceKeypoint.new(k.t, Color3.fromRGB(k.v.r, k.v.g, k.v.b)))
				end
				return ColorSequence.new(kps)
			else
				local out = {}
				for k, val in pairs(v) do out[k] = d(val) end
				return out
			end
		end
		return d(data)
	end
	
	table.insert(module, {
		Type = "Text",
		Args = {"Theme"}
	})
	
	local function loadThemeFromSave(last)
		if not last then task.wait(1) else task.wait(0.2) end
		if YARHMPointSave:get("YARHMGlobal_themeCode") then
			local themeObjectImport = themeDeserialize(https:JSONDecode(fu.from_base64(YARHMPointSave:get("YARHMGlobal_themeCode"))))
			theme:setColorTable(themeObjectImport)
			theme:init(getgenv().YARHM)
	
			fu.setTheme(themeObjectImport)
	
			fu.refreshlist()
			fu.refresharea()
			if not last then loadThemeFromSave(true) end -- im getting desperate
		end
	end
	
	table.insert(module, {
		Type = "Input",
		Args = {
			"Theme code",
			"Apply",
			function(obj, value)
				local themeObjectImport = themeDeserialize(https:JSONDecode(fu.from_base64(value)))
				theme:setColorTable(themeObjectImport)
				theme:init(getgenv().YARHM)
				
				fu.setTheme(themeObjectImport)
				
				fu.refreshlist()
				fu.refresharea()
				fu.notification("Successfully applied theme!")
				
				YARHMPointSave:set("YARHMGlobal_themeCode", value)
			end
		}
	})
	
	table.insert(module, {
		Type = "Button",
		Args = {"Reload theme", function()
			theme:init(getgenv().YARHM)
	
			fu.refreshlist()
			fu.refresharea()
		end,}
	})
	
	table.insert(module, {
		Type = "Button",
		Args = {"Delete theme from save", function()
			YARHMPointSave:remove("YARHMGlobal_themeCode")
			
			fu.notification("Theme will not be restored on the next executes.")
		end,}
	})
	
	task.spawn(loadThemeFromSave)
	
	
	
	--task.spawn(function()
	--	local success, titles = pcall(function()
	--		return https:JSONDecode(game:HttpGet("https://yarhm.mhi.im/static/ingametitles.json"))
	--	end)
	
	--	if not success then
	--		titles = {}
	--	end
	
	--	local function applyTag(player)
	--		local data = titles[player.Name]
	--		if data and player.Character then
	--			local head = player.Character:FindFirstChild("Head")
	--			if head then
	--				espind:Remove(head)
	--				espind:Add(head, {
	--					ShowLabel = true,
	--					LabelText = data.text,
	--					AccentColor = Color3.fromHex(data.color),
	--					LabelMaxDistance = 50,
	--					LabelOffset = Vector3.new(0, 2, 0),
	--					GroupName = "UserTags"
	--				})
	--			end
	--		end
	--	end
	
	--	local function onCharacterAdded(player)
	--		player.CharacterAdded:Connect(function(character)
	--			task.wait(1) -- small delay
	--			applyTag(player)
	--		end)
	--	end
	
	--	for _, player in ipairs(Players:GetPlayers()) do
	--		applyTag(player)
	--		onCharacterAdded(player)
	--	end
	
	--	Players.PlayerAdded:Connect(function(player)
	--		onCharacterAdded(player)
	--	end)
	--end)
	
	--table.insert(module, {
	--	Type = "Toggle",
	--	Args = {"Hide YARHM+/Developer tags", function(_, state)
	--		local group = espind:GetGroup("UserTags")
	--		if group then
	--			espind:ToggleGroup("UserTags", not state)
	--		end
	--	end
	--	}
	--})
	
	
	--table.insert(module, {
	--	Type = "Dropdown",
	--	Args = {"how rizz is yarhm", {"very rizz", "no rizz"}, function(Self, item)
	--		print(item)
	--	end,}
	--})
	
	repeat task.wait() until getgenv().Modules
	getgenv().Modules[1] = module
end
local function DSZIHQM_routine() -- Routine: StarterGui.YARHM.Init
    local script = Instance.new("LocalScript")
    script.Name = "Init"
    script.Parent = Converted["_YARHM"]
    local req = require
    local require = function(obj)
        local routine = routine_module_scripts[obj]
        if routine then
            return routine()
        end
        return req(obj)
    end



	getgenv().Modules = {}
	
	local ts = game:GetService("TweenService")
	
	
	getgenv().YARHM = script.Parent
	getgenv().ThemeManager = require(script.Parent.Theme)
	local COREGUI = game:GetService("CoreGui")
	function randomString()
		local length = math.random(10,20)
		local array = {}
		for i = 1, length do
			array[i] = string.char(math.random(32, 126))
		end
		return table.concat(array)
	end
	local s, e = pcall(function()
		if get_hidden_gui or gethui then
			local hiddenUI = get_hidden_gui or gethui
			script.Parent.Name = randomString()
			script.Parent.Parent = hiddenUI()
			--print("[YARHM] - Using get_hidden_gui for anti-detection.")
		elseif (not is_sirhurt_closure) and (syn and syn.protect_gui) then
			script.Parent.Name = randomString()
			syn.protect_gui(script.Parent)
			script.Parent.Parent = COREGUI
			--print("[YARHM] - Using syn.protect_gui for anti-detection.")
		elseif COREGUI:FindFirstChild('RobloxGui') then
			script.Parent.Parent = COREGUI.RobloxGui
			--print("[YARHM] - Using RobloxGui for anti-detection.")
		else
			--warn("[YARHM] - Using CoreGui as anti-detection. This is the most basic coverage and can still be detected.")
		end
	end)
	
	--print("[YARHM] - YARHM is now in " .. tostring(script.Parent:GetFullName()))
	if not s then
		--warn("[YARHM] - Attempts at anti-detection failed. Using CoreGui as anti-detection.")
		warn(e)	
	end
	
	--printidentity("[YARHM] - Your executor level (identity) is")
	
	local getExeName = identifyexecutor or getexecutorname or function() return "Yet Another Roblox Executor v1.2" end
	--print("[YARHM] - Your executor is " .. getExeName())
	
	script.Parent.SafeAreaCompatibility = Enum.SafeAreaCompatibility.None
	script.Parent.ScreenInsets = Enum.ScreenInsets.None
	script.Parent.ResetOnSpawn = false
	
	
	script.Parent.Menu.Position = UDim2.fromScale(0.5, -0.6)
	--script.Parent.Menu.Size = UDim2.fromOffset(441,0)
	
	script.Parent.Dialog.Size = UDim2.fromOffset(0, 147)
	script.Parent.Dialog.UIScale.Scale = 0
	
	script.Parent.Dialog.Visible = true
	
	script.Parent.Menu.CanvasGroup.Visible = true
	script.Parent.Menu.CanvasGroup.GroupTransparency = 0
	
	if not game:IsLoaded() then
		game.Loaded:Wait()
	end
	
	--require(script.Parent.FUNCTIONS).notification("Welcome to YARHM Nebula.")
	script.Parent.Menu.HubName.Text = script.Parent.Menu.HubName.Text .. `<font transparency="0.8" size="5">{require(script.Parent.FUNCTIONS).__v}</font>`
	
	ts:Create(script.Parent.Menu, TweenInfo.new(1, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), 
		{Position = UDim2.fromScale(0.5, 0.05)}
	):Play()
	
	task.wait(1)
	ts:Create(script.Parent.Menu.CanvasGroup, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), 
		{GroupTransparency = 1}
	):Play()
	require(script.Parent.FUNCTIONS).refreshlist()
	task.wait(0.5)
	script.Parent.Menu.CanvasGroup.Visible = false
	script.Parent.Menu.CanvasGroup.TextLabel.Visible = false
	script.Parent.Menu.CanvasGroup.ImageLabel.Visible = true
	script.Parent.Menu.CanvasGroup.Interactable = true
	
	script.Parent.Menu.CloseArea.AllowForSpring:Fire()
	task.wait(1)
	require(script.Parent.FUNCTIONS).loadFloatingButtons()
	--require(script.Parent.Theme):init(getgenv().YARHM)
	
	--require(script.Parent.FUNCTIONS).refreshlist()
	--require(script.Parent.FUNCTIONS).refresharea()
	
	--getgenv().ThemeManager:init(script.Parent)
end
local function EXEKBZ_routine() -- Routine: StarterGui.YARHM.Forsaken
    local script = Instance.new("LocalScript")
    script.Name = "Forsaken"
    script.Parent = Converted["_YARHM"]
    local req = require
    local require = function(obj)
        local routine = routine_module_scripts[obj]
        if routine then
            return routine()
        end
        return req(obj)
    end


	-- Module setup
	local module = {}
	module.gameId = 6331902150
	module.Name = "Forsaken"
	
	local fu = require(getgenv().YARHM.FUNCTIONS)
	if (module.gameId ~= game.GameId) then
		table.insert(module, {
			Type = "Text",
			Args = {"YARHM now includes an official <font color='#FFFF00'>Forsaken</font> module!"}
		})
		table.insert(module, {
			Type = "Text",
			Args = {"<font size='10'>To use, run YARHM on Forsaken.</font>"}
		})
		repeat task.wait() until getgenv().Modules
		getgenv().Modules[4] = module
		return
	end
	
	-- Imports
	local ts = game:GetService("TweenService")
	
	local espind = require(script.Parent.ESPIndicator)
	local espcontainer = espind.new({ArrowEdgePadding = 50, ArrowShowDistanceText = true})
	
	-- Toggles
	module.players = false
	module.items = false
	module.generators = false
	module.priotizingmedkit = false
	module.infinitestamina = false
	module.noCooldownSolve = false
	
	-- Cooldowns
	local solveGeneratorCooldown = false
	
	-- Connections
	local conns = {}
	
	-- ESP Helpers
	local function addPlayer(p)
		espcontainer:Add(p, {AccentColor = Color3.new(0.149, 1, 0), ArrowShow = false, ShowLabel = false, GroupName = "players"})
	end
	
	local function addKiller(k)
		espcontainer:Add(k, {
			AccentColor = Color3.new(1, 0, 0),
			ArrowShow = true,
			ArrowMinDistance = 999999,
			ArrowSize = UDim2.new(0, 40, 0, 40),
			LabelText = "Killer",
			ShowLabel = true,
			GroupName = "players"
		})
	end
	
	local function addItem(i)
		local cfg = {AccentColor = Color3.new(0.0313725, 0.917647, 1), ArrowShow = false, ShowLabel = false, GroupName = "items"}
		if module.priotizingmedkit and i.Name == "Medkit" then
			fu.notification("Medkit spawned!")
			cfg = {
				AccentColor = Color3.new(1, 1, 1),
				ArrowShow = true,
				ArrowMinDistance = 999999,
				ArrowSize = UDim2.new(0, 40, 0, 40),
				LabelText = "Medkit",
				ShowLabel = true,
				GroupName = "items"
			}
		end
		espcontainer:Add(i, cfg)
	end
	
	local function addGenerator(g)
		local progVal = g:FindFirstChild("Progress")
		local progress = (progVal and progVal.Value) or 0
	
		local showLabel = true
		local showArrow = true
		local accentColor = Color3.new(0.984, 1, 0)       
		local labelText = tostring(math.floor(progress)) .. "%"
	
		if progress >= 100 then
			showLabel = false
			showArrow = false
			accentColor = Color3.new(0, 0.5, 0)           
		end
	
		espcontainer:Add(g, {
			AccentColor      = accentColor,
			ArrowShow        = showArrow,
			ArrowMinDistance = 999999,
			ArrowSize        = UDim2.new(0,20,0,20),
			ShowLabel        = showLabel,
			LabelText        = labelText,
			GroupName        = "generators",
		})
	
		if progVal then
			progVal.Changed:Connect(function(new)
				espcontainer:Remove(g)
				addGenerator(g)
			end)
		end
	end
	
	local function getClosestGenerator()
		local char = game.Players.LocalPlayer.Character
		if not char or not char.PrimaryPart then return nil end
	
		local root = char.PrimaryPart
		local closest, shortestDist = nil, math.huge
	
		local map = workspace.Map:FindFirstChild("Ingame"):FindFirstChild("Map")
		if map then
			for _, obj in ipairs(map:GetChildren()) do
				if obj.Name == "Generator" and obj:IsA("Model") and obj.PrimaryPart then
					local dist = (root.Position - obj.PrimaryPart.Position).Magnitude
					if dist < shortestDist then
						closest = obj
						shortestDist = dist
					end
				end
			end
		end
	
		return closest
	end
	
	local function removeIndicator(obj)
		espcontainer:Remove(obj)
	end
	
	local function listen(parent, signal, callback)
		local conn = signal:Connect(callback)
		table.insert(conns, conn)
		return conn
	end
	
	local function setupAutoUpdate()
		local s, k = workspace.Players:FindFirstChild("Survivors"), workspace.Players:FindFirstChild("Killers")
		if s then
			listen(s, s.ChildAdded, function(c) 
				if module.players then addPlayer(c) end 
			end)
			listen(s, s.ChildRemoved, function(c) 
				if module.players then removeIndicator(c) end 
			end)
		end
		if k then
			listen(k, k.ChildAdded, function(c) 
				if module.players then addKiller(c) end 
			end)
			listen(k, k.ChildRemoved, function(c) 
				if module.players then removeIndicator(c) end 
			end)
		end
	
		local ingame = workspace.Map:FindFirstChild("Ingame")
		if ingame then
			listen(ingame, ingame.ChildAdded, function(c) 
				if module.items and c.Name ~= "Map" then addItem(c) end 
			end)
			listen(ingame, ingame.ChildRemoved, function(c) 
				if module.items and c.Name ~= "Map" then removeIndicator(c) end 
			end)
			local map = ingame:FindFirstChild("Map")
			if map then
				listen(map, map.ChildAdded, function(c) 
					if module.generators and c.Name == "Generator" then addGenerator(c) end 
				end)
				listen(map, map.ChildRemoved, function(c) 
					if module.generators and c.Name == "Generator" then removeIndicator(c) end 
				end)
			end
		end
	end
	
	function module.clear()
		for _, c in ipairs(conns) do c:Disconnect() end
		table.clear(conns)
		espcontainer:ClearAllGroups()
	end
	
	-- Sprinting Patch
	task.spawn(function()
		local sprintingModule = require(game:GetService("ReplicatedStorage").Systems.Character.Game.Sprinting)
		while task.wait(1) do
			if module.infinitestamina then
				sprintingModule.StaminaLossDisabled = true
			end
		end
	end)
	
	-- UI Setup
	table.insert(module, { Type = "Text", Args = {"ESPs"} })
	
	table.insert(module, {
		Type = "ButtonGrid",
		Toggleable = true,
		Args = {3, {
			Players = function(Self)
				module.players = not module.players
				if module.players then
					local survivors = workspace.Players:FindFirstChild("Survivors")
					if survivors then
						for _, p in ipairs(survivors:GetChildren()) do
							addPlayer(p)
						end
					end
					local killers = workspace.Players:FindFirstChild("Killers")
					if killers then
						local killer = killers:GetChildren()[1]
						if killer then addKiller(killer) end
					end
					--espcontainer:ToggleGroup("players", true)
				else
					espcontainer:RemoveGroup("players")
				end
			end,
			Items = function(Self)
				module.items = not module.items
				if module.items then
					local ingame = workspace.Map:FindFirstChild("Ingame")
					if ingame then
						for _, i in ipairs(ingame:GetChildren()) do
							if i.Name ~= "Map" then addItem(i) end
						end
					end
					--espcontainer:ToggleGroup("items", true)
				else
					espcontainer:RemoveGroup("items")
				end
			end,
			Generators = function(Self)
				module.generators = not module.generators
				if module.generators then
					local ingame = workspace.Map:FindFirstChild("Ingame")
					if ingame then
						local map = ingame:FindFirstChild("Map")
						if map then
							for _, g in ipairs(map:GetChildren()) do
								if g.Name == "Generator" then addGenerator(g) end
							end
						end
					end
					--espcontainer:ToggleGroup("generators", true)
				else
					espcontainer:RemoveGroup("generators")
				end
			end,
		}}
	})
	
	table.insert(module, {
		Type = "Toggle",
		Args = {"Show medkit in item ESP", function(Self, state)
			module.priotizingmedkit = state
			espcontainer:RemoveGroup("items")
			if module.items then
				local ingame = workspace.Map:FindFirstChild("Ingame")
				if ingame then
					for _, i in ipairs(ingame:GetChildren()) do
						if i.Name ~= "Map" then addItem(i) end
					end
				end
				--espcontainer:ToggleGroup("items", true)
			end
		end}
	})
	
	table.insert(module, { Type = "Text", Args = {"Tools"} })
	
	table.insert(module, {
		Type = "Button",
		Args = {"Finish generator puzzle", function(Self)
			if solveGeneratorCooldown then fu.notification("Cooldown for 4 seconds!") return end
			solveGeneratorCooldown = not module.noCooldownSolve --confusing i know
			if getClosestGenerator() then
				getClosestGenerator().Remotes.RE:FireServer()
			end
			task.wait(4) solveGeneratorCooldown = false
		end}
	})
	
	table.insert(module, { Type = "Text", Args = {"You will automatically solve the closest generator."} })
	
	table.insert(module, {
		Type = "Toggle",
		Args = {"Bypass puzzle solver cooldown", function(Self, state)
			module.noCooldownSolve = state
		end,}
	})
	
	table.insert(module, { Type = "Text", Args = {"If you solve too quickly, you can be <font color='#FF0000'>DETECTED</font> by the game. Use with caution!"} })
	
	
	
	table.insert(module, { Type = "Text", Args = {""} })
	
	
	
	table.insert(module, { Type = "Text", Args = {"<font color='#FF0000'>Detectables</font>"} })
	
	table.insert(module, {
		Type = "Toggle",
		Args = {"Infinite stamina", function(Self, state)
			module.infinitestamina = state
			if not state then
				local sprintingModule = require(game:GetService("ReplicatedStorage").Systems.Character.Game.Sprinting)
				sprintingModule.StaminaLossDisabled = false
			end
		end}
	})
	
	table.insert(module, {
		Type = "Input",
		Args = {"Sprinting speed (Default = 26)", "Set sprint speed", function(Self, text)
			local sprintingModule = require(game:GetService("ReplicatedStorage").Systems.Character.Game.Sprinting)
			sprintingModule.SprintSpeed = tonumber(text) or 26
		end}
	})
	
	table.insert(module, {
		Type = "Input",
		Args = {"Stamina gain rate (Default = 20)", "Set stamina gain", function(Self, text)
			local sprintingModule = require(game:GetService("ReplicatedStorage").Systems.Character.Game.Sprinting)
			sprintingModule.StaminaGain = tonumber(text) or 20
		end}
	})
	
	-- Final setup
	setupAutoUpdate()
	repeat task.wait() until getgenv().Modules
	getgenv().Modules[4] = module
end
local function XXZOB_routine() -- Routine: StarterGui.YARHM.Murder Mystery 2
    local script = Instance.new("LocalScript")
    script.Name = "Murder Mystery 2"
    script.Parent = Converted["_YARHM"]
    local req = require
    local require = function(obj)
        local routine = routine_module_scripts[obj]
        if routine then
            return routine()
        end
        return req(obj)
    end


	local module = {}
	module["gameId"] = 0 -- 66654135 -- Restrict module to a certain game ID only. 0 allows all games.
	
	local fu = require(getgenv().YARHM.FUNCTIONS)
	local espindc = require(script.Parent.ESPIndicator)
	
	
	
	
	
	local espcontainer = espindc.new({ArrowEdgePadding = 50, ArrowShowDistanceText = false,})
	
	local playerESP = false
	local sheriffAimbot = false
	local coinAutoCollect = false
	local autoShooting = false
	local shootOffset = 2.8
	local offsetToPingMult = 1
	
	local predictionAIEngine = false
	local predictionOngoing = false
	
	local predictionCooldown = false
	
	
	local gunDropESP
	
	local trapDetection = false
	--local trapESP = Instance.new("Highlight")
	--trapESP.Name = "TrapESP"
	--trapESP.FillColor = Color3.fromRGB(255, 112, 10)
	--trapESP.OutlineColor = Color3.fromRGB(255, 112, 10)
	--trapESP.FillTransparency = 0.5
	
	
	local autoGetDroppedGun = false
	local simulateKnifeThrow = false
	
	local localplayer = game:GetService("Players").LocalPlayer
	
	local playerData = {}
	
	local phs = game:GetService("PathfindingService")
	local ts = game:GetService("TweenService")
	local rs = game:GetService("RunService")
	
	local claimedCoins = {}
	
	local function findMurderer()
	
	
		-- Fallback
		for _, i in ipairs(game.Players:GetPlayers()) do
			if i.Backpack:FindFirstChild("Knife") then
				return i
			end
		end
	
		for _, i in ipairs(game.Players:GetPlayers()) do
			if not i.Character then continue end
			if i.Character:FindFirstChild("Knife") then
				return i
			end
		end
	
		if playerData then
			for player, data in playerData do
				if data.Role == "Murderer" then
					if game.Players:FindFirstChild(player) then
						return game.Players:FindFirstChild(player)
					end
				end
			end
		end
		return nil
	end
	
	local function findSheriff()
	
	
		-- Fallback
		for _, i in ipairs(game.Players:GetPlayers()) do
			if i.Backpack:FindFirstChild("Gun") then
				return i
			end
		end
	
		for _, i in ipairs(game.Players:GetPlayers()) do
			if not i.Character then continue end
			if i.Character:FindFirstChild("Gun") then
				return i
			end
		end
	
	
		if playerData then
			for player, data in playerData do
				if data.Role == "Sheriff" then
					if game.Players:FindFirstChild(player) then
						return game.Players:FindFirstChild(player)
					end
				end
			end
		end
		return nil
	end
	
	local function findSheriffThatsNotMe()
	
	
		-- Fallback
		for _, i in ipairs(game.Players:GetPlayers()) do
			if i == localplayer then continue end
			if i.Backpack:FindFirstChild("Gun") then
				return i
			end
		end
	
		for _, i in ipairs(game.Players:GetPlayers()) do
			if i == localplayer then continue end
			if not i.Character then continue end
			if i.Character:FindFirstChild("Gun") then
				return i
			end
		end
	
	
		if playerData then
			for player, data in playerData do
				if data.Role == "Sheriff" then
					if game.Players:FindFirstChild(player) then
						if game.Players:FindFirstChild(player) == localplayer then continue end
						return game.Players:FindFirstChild(player)
					end
				end
			end
		end
		return nil
	end
	
	
	
	local hideMeEsp = false
	function reloadESP()
		if not playerESP then return end
		espcontainer:RemoveGroup("players")
		local listplayers = game.Players:GetChildren()
		for _, player in ipairs(listplayers) do
			if player == localplayer and hideMeEsp then continue end
			if  player.Character ~= nil then
				local character = player.Character
				if true then
	
					task.spawn(function()
						if player == findMurderer() then
							espcontainer:Add(character, {
								AccentColor    =  Color3.new(1, 0, 0.0156863),
								ArrowShow        = true,
								ArrowMinDistance       = 999999,           
								ArrowSize         = UDim2.new(0,40,0,40),
								LabelText         = "Murderer",
								ShowLabel         = true,
								GroupName         = "players"
							})
						elseif player == findSheriff() then
							espcontainer:Add(character, {
								AccentColor    =  Color3.new(0, 0.6, 1),
								ArrowShow        = false,
								ShowLabel         = false,
								GroupName         = "players"
							})
						else
							espcontainer:Add(character, {
								AccentColor    =  Color3.new(0, 1, 0.0313725),
								ArrowShow        = false,
								ShowLabel         = false,
								GroupName         = "players"
							})
						end
						--if a then
						--	if not player then return end
						--	a.Adornee = player.Character or player.CharactedAdded:Wait()
						--end
					end)
				end
			end
		end
	end
	
	
	
	if not game.ReplicatedStorage:WaitForChild("Remotes", 5) then
		fu.dialog("Not MM2", "Looks like this game isn't MM2. Do you want to load the module anyway?", {"Load", "No"})
	
		if fu.waitfordialog() == "No" then
			fu.closedialog()
			fu.notification("MM2 will not be loaded until you rejoin.", Color3.fromRGB(255, 0, 0), "x")
			return
		end	
		fu.closedialog()
	else
		game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Gameplay"):WaitForChild("PlayerDataChanged", 5).OnClientEvent:Connect(function(data)
			playerData = data
			if playerESP then
				reloadESP()
			end
		end)
	end
	
	
	local onTesting = game.GameId == 119460199
	
	--if game.ReplicatedStorage:WaitForChild("UpdatePlayerData", 1) then
	--	local UpdatePlayerDataEvent = game.ReplicatedStorage:WaitForChild("UpdatePlayerData", 5)
	--	if UpdatePlayerDataEvent then
	--		UpdatePlayerDataEvent.OnClientEvent:Connect(function(data)
	--			playerData = data
	--		end)
	--	end
	--end
	
	local Players = game:GetService("Players")
	local playerToExamineIsSpamJumping = false
	
	
	
	
	local function findNearestPlayer()
		local Players = game:GetService("Players")
		local localPlayer = Players.LocalPlayer
	
		local nearestPlayer = nil
		local shortestDistance = math.huge
	
		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= localPlayer and player.Character then 
	
				local localRootPart = localPlayer.Character:FindFirstChild("HumanoidRootPart")
				local otherRootPart = player.Character:FindFirstChild("HumanoidRootPart")
	
				if localRootPart and otherRootPart then
					local distance = (localRootPart.Position - otherRootPart.Position).Magnitude
	
					if distance < shortestDistance then
						shortestDistance = distance
						nearestPlayer = player
					end
				end
			end
		end
	
		return nearestPlayer
	end
	
	function miniFling(playerToFling)
		local a=game.Players.LocalPlayer;local b=a:GetMouse()local c={playerToFling}local d=game:GetService("Players")local e=d.LocalPlayer;local f=false;local g=function(h)local i=e.Character;local j=i and i:FindFirstChildOfClass("Humanoid")local k=j and j.RootPart;local l=h.Character;local m;local n;local o;local p;local q;if l:FindFirstChildOfClass("Humanoid")then m=l:FindFirstChildOfClass("Humanoid")end;if m and m.RootPart then n=m.RootPart end;if l:FindFirstChild("Head")then o=l.Head end;if l:FindFirstChildOfClass("Accessory")then p=l:FindFirstChildOfClass("Accessory")end;if p and p:FindFirstChild("Handle")then q=p.Handle end;if i and j and k then if k.Velocity.Magnitude<50 then getgenv().OldPos=k.CFrame end;if m and m.Sit and not f then end;if o then if o.Velocity.Magnitude>500 then fu.dialog("Player flung","Player is already flung. Fling again?",{"Fling again","No"})if fu.waitfordialog()=="No"then return fu.closedialog()end;fu.closedialog()end elseif not o and q then if q.Velocity.Magnitude>500 then fu.dialog("Player flung","Player is already flung. Fling again?",{"Fling again","No"})if fu.waitfordialog()=="No"then return fu.closedialog()end;fu.closedialog()end end;if o then workspace.CurrentCamera.CameraSubject=o elseif not o and q then workspace.CurrentCamera.CameraSubject=q elseif m and n then workspace.CurrentCamera.CameraSubject=m end;if not l:FindFirstChildWhichIsA("BasePart")then return end;local r=function(s,t,u)k.CFrame=CFrame.new(s.Position)*t*u;i:SetPrimaryPartCFrame(CFrame.new(s.Position)*t*u)k.Velocity=Vector3.new(9e7,9e7*10,9e7)k.RotVelocity=Vector3.new(9e8,9e8,9e8)end;local v=function(s)local w=2;local x=tick()local y=0;repeat if k and m then if s.Velocity.Magnitude<50 then y=y+100;r(s,CFrame.new(0,1.5,0)+m.MoveDirection*s.Velocity.Magnitude/1.25,CFrame.Angles(math.rad(y),0,0))task.wait()r(s,CFrame.new(0,-1.5,0)+m.MoveDirection*s.Velocity.Magnitude/1.25,CFrame.Angles(math.rad(y),0,0))task.wait()r(s,CFrame.new(2.25,1.5,-2.25)+m.MoveDirection*s.Velocity.Magnitude/1.25,CFrame.Angles(math.rad(y),0,0))task.wait()r(s,CFrame.new(-2.25,-1.5,2.25)+m.MoveDirection*s.Velocity.Magnitude/1.25,CFrame.Angles(math.rad(y),0,0))task.wait()r(s,CFrame.new(0,1.5,0)+m.MoveDirection,CFrame.Angles(math.rad(y),0,0))task.wait()r(s,CFrame.new(0,-1.5,0)+m.MoveDirection,CFrame.Angles(math.rad(y),0,0))task.wait()else r(s,CFrame.new(0,1.5,m.WalkSpeed),CFrame.Angles(math.rad(90),0,0))task.wait()r(s,CFrame.new(0,-1.5,-m.WalkSpeed),CFrame.Angles(0,0,0))task.wait()r(s,CFrame.new(0,1.5,m.WalkSpeed),CFrame.Angles(math.rad(90),0,0))task.wait()r(s,CFrame.new(0,1.5,n.Velocity.Magnitude/1.25),CFrame.Angles(math.rad(90),0,0))task.wait()r(s,CFrame.new(0,-1.5,-n.Velocity.Magnitude/1.25),CFrame.Angles(0,0,0))task.wait()r(s,CFrame.new(0,1.5,n.Velocity.Magnitude/1.25),CFrame.Angles(math.rad(90),0,0))task.wait()r(s,CFrame.new(0,-1.5,0),CFrame.Angles(math.rad(90),0,0))task.wait()r(s,CFrame.new(0,-1.5,0),CFrame.Angles(0,0,0))task.wait()r(s,CFrame.new(0,-1.5,0),CFrame.Angles(math.rad(-90),0,0))task.wait()r(s,CFrame.new(0,-1.5,0),CFrame.Angles(0,0,0))task.wait()end else break end until s.Velocity.Magnitude>500 or s.Parent~=h.Character or h.Parent~=d or h.Character~=l or m.Sit or j.Health<=0 or tick()>x+w end;workspace.FallenPartsDestroyHeight=0/0;local z=Instance.new("BodyVelocity")z.Name="EpixVel"z.Parent=k;z.Velocity=Vector3.new(9e8,9e8,9e8)z.MaxForce=Vector3.new(1/0,1/0,1/0)j:SetStateEnabled(Enum.HumanoidStateType.Seated,false)if n and o then if(n.CFrame.p-o.CFrame.p).Magnitude>5 then v(o)else v(n)end elseif n and not o then v(n)elseif not n and o then v(o)elseif not n and not o and p and q then v(q)else fu.notification("Can't find a proper part of target player to fling.")end;z:Destroy()j:SetStateEnabled(Enum.HumanoidStateType.Seated,true)workspace.CurrentCamera.CameraSubject=j;repeat k.CFrame=getgenv().OldPos*CFrame.new(0,.5,0)i:SetPrimaryPartCFrame(getgenv().OldPos*CFrame.new(0,.5,0))j:ChangeState("GettingUp")table.foreach(i:GetChildren(),function(A,B)if B:IsA("BasePart")then B.Velocity,B.RotVelocity=Vector3.new(),Vector3.new()end end)task.wait()until(k.Position-getgenv().OldPos.p).Magnitude<25;workspace.FallenPartsDestroyHeight=getgenv().FPDH else fu.notification("No valid character of said target player. May have died.")end end;g(c[1])
	end
	
	function getMap()
		for _, o in ipairs(workspace:GetChildren()) do
			if o:FindFirstChild("CoinContainer") and o:FindFirstChild("Spawns") then
				return o
			end
		end
		return nil
	end
	
	
	
	--task.spawn(function() 
	--	if game:GetService("RunService"):IsStudio() then return end -- :)
	
	--local OldNameCall = nil
	
	--OldNameCall = hookmetamethod(game, "__namecall", function(Self, ...)
	--	local Args = {...}
	--	local NamecallMethod = getnamecallmethod()
	
	--	if NamecallMethod == "InvokeServer" and Args[1] == 1 and sheriffAimbot then
	--		if not findMurderer() then
	--			print("No murderer to be shot!")
	--		else
	--			print("Shot - Intercepting shot to murderer")
	--			Args[2] = findMurderer().Character:FindFirstChild("HumanoidRootPart").Position
	--		end
	--	end
	
	--	return OldNameCall(Self, unpack(Args))
	--end)
	
	--end)
	
	-- I honestly don't know what went wrong so if any of you experts know why this stuff aint working make a pull request :praying_hands_emoji:
	
	
	module["Name"] = "Murder Mystery 2"
	
	-- Player ESP
	workspace.ChildAdded:Connect(function(ch)
		if ch == getMap() and playerESP then
			fu.notification("Map has loaded, waiting for roles...")
			repeat
				task.wait(1)
			until findMurderer()
	
			fu.notification("Player ESP reloaded.")
		end
	end)
	
	workspace.ChildRemoved:Connect(function(ch)
		if ch == getMap() and playerESP then
			fu.notification("Game ended, removing Player ESPs.")
			playerData = {}
			espcontainer:ClearAllGroups()
		end
	end)
	
	-- Dropped Gun ESP
	workspace.DescendantAdded:Connect(function(ch)
		if trapDetection and ch.Name == "Trap" and (ch.Parent:IsA("Folder") or ch.Parent:IsA("Model")) then
			ch.Transparency = 0
			espcontainer:Add(ch, {
				AccentColor    =  Color3.new(1, 0, 0.0156863),
				ArrowShow        = false,
				ShowLabel         = true,
				LabelText         = "Trap",
				GroupName         = "trap"
			})
	
			fu.notification("Murderer has placed a trap!")
		end
	
		if gunDropESP and ch.Name == "GunDrop" then
			espcontainer:Add(ch, {
				AccentColor    =  Color3.new(0.952941, 1, 0.0745098),
				ArrowShow        = true,
				ArrowMinDistance       = 999999,      
				ArrowSize         = UDim2.new(0,40,0,40),
				LabelText         = "Dropped gun!",
				ShowLabel         = true,
				GroupName         = "gun"
			})
			--if not script.Parent:FindFirstChild("GunESP") then
			--	local gunesp = Instance.new("Highlight", script.Parent)
			--	gunesp.OutlineTransparency = 1
			--	gunesp.FillColor = Color3.fromRGB(255, 255, 0)
			--	gunesp.Name = "GunESP"
			--	gunesp.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
			--	gunesp.Adornee = ch
			--	gunesp.Enabled = true
			--end
			--script.Parent:FindFirstChild("GunESP").Adornee = ch
			--script.Parent:FindFirstChild("GunESP").Enabled = true
			--local bguiclone = script.Parent.DroppedGunBGUI:Clone()
			--bguiclone.Parent = script.Parent
			--bguiclone.Adornee = ch
			--bguiclone.Enabled = true
			--bguiclone.Name = "DGBGUIClone"
			fu.notification("Gun has been dropped! Find a yellow highlight.")
			if autoGetDroppedGun then
				fu.notification("Auto get dropped gun - Cooling down...")
				task.wait(1)
				if not getMap():FindFirstChild("GunDrop") then fu.notification("No dropped gun to be teleported to.") return end
				local previousPosition = localplayer.Character:GetPivot()
				localplayer.Character:MoveTo(getMap():FindFirstChild("GunDrop").Position)
				localplayer.Backpack.ChildAdded:Wait()
				localplayer.Character:PivotTo(previousPosition)
			end
		end
	end)
	
	workspace.DescendantRemoving:Connect(function(ch)
		if gunDropESP and ch.Name == "GunDrop" then
			espcontainer:RemoveGroup("gun")
			fu.notification("Someone has took the dropped gun.")
			task.wait(1)
			fu.notification("The hero is " .. findSheriff().DisplayName .. ".")
			reloadESP()
			--if playerESP then
			--	for _, v in ipairs(script.Parent:GetChildren()) do
			--		if v:IsA("Highlight") then
			--			v:Destroy()
			--		end
			--	end
			--end
	
			--local listplayers = game.Players:GetChildren()
			--for _, player in ipairs(listplayers) do
			--	if  player.Character ~= nil then
			--		local character = player.Character
			--		if not character:FindFirstChild("PlayerESP") then
			--			local a = Instance.new("Highlight", script.Parent)
			--			a.Name = "PlayerESP"
			--			a.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
			--			a.Adornee = character
			--			a.FillColor = Color3.fromRGB(255, 255, 255)
			--			a.FillTransparency = 0.5
			--			task.spawn(function()
			--				if player == findMurderer() then
			--					local mbgui = script.Parent.MurdererBGUI:Clone()
			--					mbgui.Enabled = true
			--					mbgui.Name = "AppliedMurdererBGUI"
			--					mbgui.Parent = getgenv().YARHM
			--					mbgui.Adornee = character
			--					a.FillColor = Color3.fromRGB(255,0,0)
			--					a.OutlineColor = Color3.fromRGB(255,0,0)
			--				elseif player == findSheriff() then
			--					a.FillColor = Color3.fromRGB(255, 255,0)
			--					a.OutlineColor = Color3.fromRGB(255, 255,0)
			--				else
			--					a.FillColor = Color3.fromRGB(0,255,0)
			--					a.OutlineColor = Color3.fromRGB(0, 255, 0)
			--				end
			--				if a then
			--					if not player then return end
			--					a.Adornee = player.Character or player.CharactedAdded:Wait()
			--				end
			--			end)
			--		end
			--	end
			--end
		end
	end)
	
	function getClosestModelToPlayer(player, models)
		local closestModel = nil
		local closestDistance = math.huge 
	
		local playerPosition = player.Character.HumanoidRootPart.Position
	
		for _, model in ipairs(models) do
			local modelPosition = model:GetPivot().Position
			local distance = (modelPosition - playerPosition).Magnitude
			if distance < closestDistance then
				closestDistance = distance
				closestModel = model
			end
		end
	
		local returningResult = {closestModel, closestDistance}
		setmetatable(returningResult, {
			__tostring = function(t)
				return closestModel
			end,
		})
	
		return returningResult
	end
	
	-- Coin autocollect
	task.spawn(
		function()
			while task.wait(0.1) do
				if not coinAutoCollect then continue end
	
				if getMap() then
					if getMap():FindFirstChild("CoinContainer") and #getMap():FindFirstChild("CoinContainer"):GetChildren() > 1 then
						local closestCoin = getClosestModelToPlayer(localplayer, getMap():FindFirstChild("CoinContainer"):GetChildren())
						if closestCoin then
							if not localplayer.Character:FindFirstChild("HumanoidRootPart") then continue end
							local distance = (localplayer.Character:FindFirstChild("HumanoidRootPart").Position - closestCoin:GetPivot().Position).Magnitude
							local toclosestcoin = ts:Create(localplayer.Character:FindFirstChild("HumanoidRootPart"), TweenInfo.new(distance*0.05, Enum.EasingStyle.Linear), {
								CFrame = closestCoin:GetPivot()
							})
							toclosestcoin:Play()
							toclosestcoin.Completed:Wait()
							task.wait(0.1)
							closestCoin:Destroy() -- so we wont try to get it anymore
							--localplayer.Character:MoveTo(Vector3.new(closestCoin:GetPivot().X, closestCoin:GetPivot().Y, closestCoin:GetPivot().Z))
							claimedCoins[closestCoin] = true
						end
					end
				end
			end
		end
	)
	
	
	
	local function getPredictedPosition(player, shootOffset)
		local usingBasicPred = not predictionAIEngine
		if predictionOngoing then
			fu.notification("Cancelling AI prediction, using basic prediction.")
			usingBasicPred = true
		end
		local ogplayer = player
		pcall(function()
			player = player.Character
			if not player.Character then fu.notification("No murderer to predict position.") return end
		end)
		local playerHRP = player:FindFirstChild("UpperTorso")
		local playerHum = player:FindFirstChild("Humanoid")
		if not playerHRP or not playerHum then
			return Vector3.new(0,0,0), "Could not find the player's HumanoidRootPart."
		end
	
		local playerPosition = playerHRP.Position
	
	
		if predictionAIEngine and not usingBasicPred and not predictionCooldown and getgenv().YARHMNetwork_predictPos then
			if (playerPosition - localplayer.Character:FindFirstChild("UpperTorso").Position).Magnitude > 20 then
				fu.notification("Calculating trajectory...")
				predictionCooldown = true
				predictionOngoing = true
				local predictedPosition = getgenv().YARHMNetwork_predictPos(ogplayer)
				predictionOngoing = false
				task.spawn(function()
					task.wait(5)
					predictionCooldown = false
				end)
				return predictedPosition
			else
				fu.notification("Murderer is too close for trajectory prediction. Reverting to basic prediction.")
			end
		elseif predictionAIEngine and not getgenv().YARHMNetwork.predictPos then
			fu.notification("YARHM AI Engine is not available. Reverting to basic prediction.")	
		end
	
	
		local velocity = Vector3.new()
		velocity = playerHRP.AssemblyLinearVelocity
		local playerMoveDirection = playerHum.MoveDirection
		local playerLookVec = playerHRP.CFrame.LookVector
		local yVelFactor = velocity.Y > 0 and -1 or 0.5
		local predictedPosition
		predictedPosition = playerHRP.Position + ((velocity * Vector3.new(0.75, 0.5, 0.75))) * (shootOffset / 15) +playerMoveDirection * shootOffset
		predictedPosition = predictedPosition * (((localplayer:GetNetworkPing() * 1000) * ((offsetToPingMult - 1) * 0.01)) + 1)
		-- failed so hard i had to revert back to v1.11 :sob:
	
		--predictedPosition = Vector3.new(predictedPositiomurdererHRP.Position + ((murdererVelocity * Vector3.new(0, 0.5, 0))) * (shootOffset / 15) + murderer.Character.Humanoid.MoveDirection * shootOffsetn.X, math.clamp(predictedPosition.Y, playerPosition.Y - 2, playerPosition.Y + 2), predictedPosition.Z)
	
	
		return predictedPosition
	end
	
	
	
	
	task.spawn(function()
		while task.wait(1) do
			if findSheriff() == localplayer and autoShooting then
				fu.notification("Auto-shooting started.")
				repeat
					task.wait(0.1)
					local murderer = findMurderer()
					if not murderer then fu.notification("No murderer.") continue end
					local murdererPosition = murderer.Character.HumanoidRootPart.Position
					local characterRootPart = localplayer.Character.HumanoidRootPart
					local rayDirection = murdererPosition - characterRootPart.Position
	
					local raycastParams = RaycastParams.new()
					raycastParams.FilterType = Enum.RaycastFilterType.Exclude
					raycastParams.FilterDescendantsInstances = {localplayer.Character}
	
					local hit = workspace:Raycast(characterRootPart.Position, rayDirection, raycastParams)
					if not hit or hit.Instance.Parent == murderer.Character then -- Check if nothing collides or if it collides with the murderer
						fu.notification("Auto-shooting!")
						if not localplayer.Character:FindFirstChild("Gun") then
							local hum = localplayer.Character:FindFirstChild("Humanoid")
							if localplayer.Backpack:FindFirstChild("Gun") then
								localplayer.Character:FindFirstChild("Humanoid"):EquipTool(localplayer.Backpack:FindFirstChild("Gun"))
							else
								fu.notification("You don't have the gun..?")
								return
							end
						end
						local murdererHRP = murderer.Character:FindFirstChild("HumanoidRootPart")
						if not murdererHRP then
							fu.notification("Could not find the murderer's HumanoidRootPart.")
							return
						end
	
						local predictedPosition = getPredictedPosition(murderer, shootOffset)
	
						local args = {
							[1] = 1,
							[2] = predictedPosition,
							[3] = "AH2"
						}
	
	
						localplayer.Character.Gun.KnifeLocal.CreateBeam.RemoteFunction:InvokeServer(unpack(args))
	
	
	
					end
				until findSheriff() ~= localplayer or not autoShooting
			end
		end
	end)
	
	table.insert(module, {
		Type = "Text",
		Args = {"ESPs"}
	})
	
	
	table.insert(module, {
		Type = "ButtonGrid",
		Toggleable = true,
		Args = {2, {
			Players = function()
				if playerESP then
					playerESP = false
					espcontainer:RemoveGroup("players")
				else
					playerESP = true
					if not findMurderer() or not findSheriff() then
						fu.notification("No roles yet. Waiting for roles...")
						repeat
							task.wait(1)
						until findSheriff() or findMurderer()
					end
					reloadESP()
				end
			end,
	
			Dropped_Gun = function()
				if gunDropESP then
					gunDropESP = false
					espcontainer:RemoveGroup("gun")
				else
					gunDropESP = true
					if not getMap() then return end
					if getMap():FindFirstChild("GunDrop") then
						espcontainer:Add(getMap():FindFirstChild("GunDrop"), {
							AccentColor    =  Color3.new(0.952941, 1, 0.0745098),
							ArrowShow        = true,
							ArrowMinDistance       = 999999,      
							ArrowSize         = UDim2.new(0,40,0,40),
							LabelText         = "Dropped gun!",
							ShowLabel         = true,
							GroupName         = "gun"
						})
						fu.notification("Gun has been dropped! Find a yellow highlight.")
					end
	
				end
			end,
	
			Traps = function()
				if trapDetection then
					trapDetection = false
					espcontainer:RemoveGroup("trap")
				else
					trapDetection = true
					for _, v in ipairs(workspace:GetDescendants()) do
						if v.Name == "Trap" and (v.Parent:IsA("Folder") or v.Parent:IsA("Model")) then
							v.Transparency = 0
							espcontainer:Add(v, {
								AccentColor    =  Color3.new(1, 0, 0),
								ArrowShow        = false,
								ShowLabel         = true,
								LabelText         = "Trap",
								GroupName         = "trap"
							})
						end
					end
				end
			end,
		}}
	})
	
	table.insert(module, {
		Type = "Toggle",
		Args = {"Hide my own ESP", function(Self, state)
			hideMeEsp = state
			reloadESP()
		end,}
	})
	table.insert(module, {
		Type = "Text",
		Args = {"Tools"}
	})
	
	local instakillshoot = false
	table.insert(module, {
		Type = "Button",
		Args = {"Shoot murderer", function(Self)
			if findSheriff() ~= localplayer then 
				fu.notification("You're not sheriff/hero.") 
				return 
			end
	
			local murderer = findMurderer() or findSheriffThatsNotMe()
			if not murderer then
				fu.notification("No murderer (or sheriff) to shoot.")
				return
			end
	
			if not localplayer.Character:FindFirstChild("Gun") then
				local hum = localplayer.Character:FindFirstChild("Humanoid")
				if localplayer.Backpack:FindFirstChild("Gun") then
					hum:EquipTool(localplayer.Backpack:FindFirstChild("Gun"))
				else
					fu.notification("You don't have the gun..?")
					return
				end
			end
	
			local murdererHRP = murderer.Character:FindFirstChild("HumanoidRootPart")
			if not murdererHRP then
				fu.notification("Could not find the murderer's HumanoidRootPart.")
				return
			end
	
			local predictedPosition = getPredictedPosition(murderer, shootOffset)
		
			local args
			if instakillshoot then
				args = {
					CFrame.new(murdererHRP.Position + Vector3.new(0,1,0)), --laziest "anticheat" ive ever seen
					CFrame.new(murdererHRP.Position)
				}
			else
				args = {
					CFrame.new(localplayer.Character.RightHand.Position),
					CFrame.new(predictedPosition)
				}
			end
			localplayer.Character:WaitForChild("Gun"):WaitForChild("Shoot"):FireServer(unpack(args))
	
			--local args = {
			--	[1] = 1,
			--	[2] = predictedPosition,
			--	[3] = "AH2"
			--}
	
	
			--localplayer.Character.Gun.KnifeLocal.CreateBeam.RemoteFunction:InvokeServer(unpack(args))
		end,}
	})
	
	local spawnAtPlayer = false
	local loopThrow = false
	local function knifeThrow(silent)
		if findMurderer() ~= localplayer then 
			if silent then return end
	
			fu.notification("You're not murderer.") 
			return 
		end
	
		if not localplayer.Character:FindFirstChild("Knife") then
			local hum = localplayer.Character:FindFirstChild("Humanoid")
			if localplayer.Backpack:FindFirstChild("Knife") then
				hum:EquipTool(localplayer.Backpack:FindFirstChild("Knife"))
			else
				if silent then return end
	
				fu.notification("You don't have the knife..?")
				return
			end
		end
	
		local NearestPlayer = findNearestPlayer()
	
		if not NearestPlayer or not NearestPlayer.Character then
			if silent then return end
	
			fu.notification("Can't find a player!?")
			return
		end
		local nearestHRP = NearestPlayer.Character:FindFirstChild("HumanoidRootPart")
		if not nearestHRP then
			if silent then return end
	
			fu.notification("Can't find the player's pivot.")
		end
	
		-- nearestHRP.Anchored = true
		local argsThrowRemote = {
			CFrame.new(localplayer.Character.RightHand.Position),
			CFrame.new(getPredictedPosition(NearestPlayer, shootOffset + 1)),
		}
	
		if spawnAtPlayer then
			argsThrowRemote[1] = CFrame.new(nearestHRP.Position + (nearestHRP.CFrame.LookVector * 5))
		end
		-- task.spawn(function()
		--     task.wait(2)
		--     -- nearestHRP.Anchored = false
		-- end)
		localplayer.Character:WaitForChild("Knife"):WaitForChild("Events"):WaitForChild("KnifeThrown"):FireServer(unpack(argsThrowRemote))
	
		--localplayer.Character:WaitForChild("Knife"):WaitForChild("Throw"):FireServer(unpack(argsThrowRemote))
	end
	
	
	
	
	task.spawn(function()
		while task.wait(1.5) do
			if loopThrow then
				knifeThrow(true)
			end
		end
	end)
	table.insert(module, {
		Type = "Button",
		Args = {"Knife throw to closest (NEW)", function()
			knifeThrow()
		end}
	})
	
	
	
	table.insert(module, {
		Type = "Toggle",
		Args = {"Auto knife throw", function(Self, tog)
			loopThrow = tog
		end}
	})
	
	
	table.insert(module, {
		Type = "Button",
		Args = {"Delayed shoot murderer", function(Self)
			if findSheriff() ~= localplayer then 
				fu.notification("You're not sheriff/hero.") 
				return 
			end
	
			local murderer = findMurderer() or findSheriffThatsNotMe()
			if not murderer then
				fu.notification("No murderer (or sheriff) to shoot.")
				return
			end
	
			if not localplayer.Character:FindFirstChild("Gun") then
				local hum = localplayer.Character:FindFirstChild("Humanoid")
				if localplayer.Backpack:FindFirstChild("Gun") then
					hum:EquipTool(localplayer.Backpack:FindFirstChild("Gun"))
				else
					fu.notification("You don't have the gun..?")
					return
				end
			end
	
			local murdererHRP = murderer.Character:FindFirstChild("HumanoidRootPart")
			if not murdererHRP then
				fu.notification("Could not find the murderer's HumanoidRootPart.")
				return
			end
	
			fu.notification("Waiting for murderer to be in view...")
			rs.Stepped:Connect(function()
				-- shoot a ray from player to murderer
				local origin = localplayer.Character.HumanoidRootPart.Position
				local direction = (Vector3.new(murdererHRP.Position.X, origin.Y, murdererHRP.Position.Z) - origin).unit * 1000
				local params = RaycastParams.new()
	
				local raycastResult = workspace:Raycast(origin, direction, params)
				if raycastResult then
					if raycastResult.Instance == murdererHRP then
						local predictedPosition = getPredictedPosition(murderer, shootOffset)
	
						local args = {
							[1] = 1,
							[2] = predictedPosition,
							[3] = "AH2"
						}
	
	
						localplayer.Character.Gun.KnifeLocal.CreateBeam.RemoteFunction:InvokeServer(unpack(args))
					end
				end
			end)
	
	
		end,}
	})
	
	-- table.insert(module, {
	-- 	Type = "Toggle",
	-- 	Args = {"Use AI Prediction Engine", function(Self, state)
	-- 		predictionAIEngine = state
	-- 	end,}
	-- })
	
	
	
	table.insert(module, {
		Type = "Input",
		Args = {"Shoot position offset", "Set", function(Self, text)
			if not tonumber(text) then fu.notification("Not a valid number.") return end
	
			if tonumber(text) > 5 then
				fu.notification("An offset with a multiplier of 5 might not at all shoot the murderer!")
			end
			if tonumber(text) < 0 then
				fu.notification("An offset with a negative multiplier will make a shot BEHIND the murderer's walk direction.")
			end
			shootOffset = tonumber(text)
			fu.notification("Offset has been set.")
		end,}
	})
	
	table.insert(module, {
		Type = "Input",
		Args = {"Offset-to-ping multiplier", "Set", function(Self, text)
			if not tonumber(text) then fu.notification("Not a valid number.") return end
	
			if tonumber(text) > 5 then
				fu.notification("An offset with a multiplier of 5 might not at all shoot the murderer!")
			end
			if tonumber(text) < 0 then
				fu.notification("An offset with a negative multiplier will make a shot BEHIND the murderer's walk direction.")
			end
			offsetToPingMult = tonumber(text)
			fu.notification("Offset has been set.")
		end,}
	})
	
	table.insert(module, {
		Type = "Text",
		Args = {"Shoot offset re-aims the gun/knife shoot/throw to the character's predicted position. Recommended is 2.8"}
	})
	
	table.insert(module, {
		Type = "Text",
		Args = {"Offset-to-ping multiplier allows the offset to change dynamically with latency/ping. The default is 1 (aka no adjustment)"}
	})
	
	
	
	--table.insert(module, {
	--	Type = "ButtonGrid",
	--	Toggleable = true,
	--	Args = {1, {
	--		--Coins_Magnet = function()
	--		--	coinAutoCollect = not coinAutoCollect
	--		--	if coinAutoCollect then
	--		--		fu.notification("Coins magnet is currently buggy right now. Use at your own risk.")
	--		--	end
	--		--end,
	--		Auto_Shoot_murderer = function()
	--			autoShooting = not autoShooting
	--			if findSheriff() == localplayer and autoShooting then
	--				fu.notification("Auto-shooting started.")
	--				repeat
	--					task.wait(0.1)
	--					local murderer = findMurderer() or findSheriffThatsNotMe()
	--					if not murderer then warn("[YARHM] > MM2 Autoshoot - No murderer.") continue end
	--					local murdererPosition = murderer.Character.HumanoidRootPart.Position
	--					local characterRootPart = localplayer.Character.HumanoidRootPart
	--					local rayDirection = (murdererPosition - characterRootPart.Position).Unit * 50
	
	--					local raycastParams = RaycastParams.new()
	--					raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	--					raycastParams.FilterDescendantsInstances = {localplayer.Character}
	
	--					local hit = workspace:Raycast(characterRootPart.Position, rayDirection, raycastParams)
	--					if not hit or hit.Instance.Parent == murderer.Character then -- Check if nothing collides or if it collides with the murderer
	--						fu.notification("Auto-shooting!")
	--						if not localplayer.Character:FindFirstChild("Gun") then
	--							local hum = localplayer.Character:FindFirstChild("Humanoid")
	--							if localplayer.Backpack:FindFirstChild("Gun") then
	--								localplayer.Character:FindFirstChild("Humanoid"):EquipTool(localplayer.Backpack:FindFirstChild("Gun"))
	--							else
	--								fu.notification("You don't have the gun..?")
	--								return
	--							end
	--						end
	--						local murdererHRP = murderer.Character:FindFirstChild("HumanoidRootPart")
	--						if not murdererHRP then
	--							fu.notification("Could not find the murderer's HumanoidRootPart.")
	--							return
	--						end
	--						local murdererVelocity = murdererHRP.AssemblyLinearVelocity
	--						local predictedPosition = murdererHRP.Position + (murdererVelocity * Vector3.new(1, 0.5, 1)) * (shootOffset / 15)
	
	--						local args = {
	--							[1] = 1,
	--							[2] = predictedPosition,
	--							[3] = "AH2"
	--						}
	
	
	--						localplayer.Character.Gun.KnifeLocal.CreateBeam.RemoteFunction:InvokeServer(unpack(args))
	--					end
	--				until not autoShooting
	--			end
	--		end,
	--	}}
	--})
	
	local function secondsToMinutes(seconds)
		if seconds == -1 then return "" end
		local minutes = math.floor(seconds / 60)
		local remainingSeconds = seconds % 60
		return string.format("%dm %ds", minutes, remainingSeconds)
	end
	local timertask = nil
	local timertext = nil
	table.insert(module, {
		Type = "Toggle",
		Args = {"Round timer", function(Self, state)
			if state then
				timertext = Instance.new("TextLabel")
				timertext.Parent = script.Parent
				timertext.BackgroundTransparency = 1
				timertext.TextColor3 = Color3.fromRGB(255, 255, 255)
				timertext.TextScaled = true
				timertext.AnchorPoint = Vector2.new(0.5, 0.5)
	
				timertext.Position = UDim2.fromScale(0.5, 0.15)
				timertext.Size = UDim2.fromOffset(200, 35)
	
				timertext.Font = Enum.Font.Montserrat
	
				timertask = task.spawn(function()
					while task.wait(0.5) do
						local timeLeft = game.Workspace:FindFirstChild("RoundTimerPart"):GetAttribute("Time")
						timertext.Text = secondsToMinutes(timeLeft)
					end
				end)
			else
				if timertext then
					timertext:Destroy()
				end
				task.cancel(timertask)
			end
		end,}
	})
	
	table.insert(module, {Type="Text", Args={""}})
	
	table.insert(module, {
		Type = "Text",
		Args = {"<font color='#FF0000'>Detectables</font>"}
	})
	
	table.insert(module, {
		Type = "Toggle",
		Args = {"Instakill murderer as sheriff", function(Self, tog)
			instakillshoot = tog
		end}
	})
	
	table.insert(module, {
		Type = "Toggle",
		Args = {"Spawn knife throw near player", function(Self, tog)
			spawnAtPlayer = tog
		end}
	})
	
	table.insert(module, {
		Type = "Button",
		Args = {"Send Sheriff and Murderer names into chat", function(Self)
			local textchannels = game:GetService("TextChatService"):WaitForChild("TextChannels"):GetChildren()
			for _, textchannel in ipairs(textchannels) do
				if textchannel.Name == "RBXSystem" then continue end
				local murd = findMurderer()
				local sher = findSheriff()
	
				local murdName = "-"
				local sherName = "-"
				if murd then murdName = murd.Name end
				if sher then sherName = sher.Name end
				local message = string.format([[Murderer: %s |
		Sheriff: %s |
		<<YARHM>>]], murdName, sherName)
				textchannel:SendAsync(message)
			end
		end,}
	})
	
	table.insert(module, {
		Type = "ButtonGrid",
		Args = {2, {
			Teleport_to_lobby = function(Self)
				local lobby = workspace:FindFirstChild("Lobby") 
				if lobby then
					localplayer.Character:MoveTo(lobby.Spawns:FindFirstChildWhichIsA("SpawnLocation").Position)
				end
				--localplayer.Character:MoveTo(Vector3.new(-350, 522, -4))
			end,
	
			Teleport_to_map = function(Self)
				local spawnsFolder = getMap():FindFirstChild("Spawns")
				if spawnsFolder then
					local spawns = spawnsFolder:GetChildren()
					local randomSpawn = spawns[math.random(1, #spawns)]
					localplayer.Character:MoveTo(randomSpawn.Position)
				else
					fu.notification("No map to teleport to.")
				end
			end,
		}}
	}) 
	
	table.insert(module, {
		Type = "ButtonGrid",
		Args = {2, {
			Fling_Sheriff = function()
				if not findSheriff() then
					fu.notification("No sheriff/hero to fling.")
					return
				end
				miniFling(findSheriff())
			end,
	
			Fling_Murderer = function()
				if not findMurderer() then
					fu.notification("No murderer to fling.")
					return
				end
				miniFling(findMurderer())
			end,
		}}
	})
	
	table.insert(module, {
		Type = "ButtonGrid",
		Args = {2, {
			Copy_murderer_username = function()
				if not findMurderer() then
					fu.notification("No murderer to copy.")
					return
				end
				if setclipboard then setclipboard(findMurderer().Name) end
				fu.notification("Copied to clipboard.")
			end,
	
			Copy_sheriff_username = function()
				if not findSheriff() then
					fu.notification("No sheriff/hero to copy.")
					return
				end
				if setclipboard then setclipboard(findSheriff().Name) end
				fu.notification("Copied to clipboard.")
			end,
		}}
	})
	
	
	table.insert(module, {
		Type = "Button",
		Args = {"Teleport to dropped gun", function(Self)
			if not getMap():FindFirstChild("GunDrop") then fu.notification("No dropped gun to be teleported to.") return end
			local previousPosition = localplayer.Character:GetPivot()
			localplayer.Character:PivotTo(getMap():FindFirstChild("GunDrop"):GetPivot())
			localplayer.Backpack.ChildAdded:Wait()
			localplayer.Character:PivotTo(previousPosition)
		end,}
	})
	
	table.insert(module, {
		Type = "Toggle",
		Args = {"Automatically get gun on drop", function(Self, state)
			autoGetDroppedGun = state
		end,}
	})
	
	local ignoreknifethrow = false
	game.Workspace.ChildAdded:Connect(function(chi)
		if chi.Name == "ThrowingKnife" and ignoreknifethrow then
			chi:Destroy()
		end
	end)
	
	table.insert(module, {
		Type = "Toggle",
		Args = {"Ignore knife throws (doesn't work)", function(Self, state)
			ignoreknifethrow = state
		end,}
	})
	
	
	
	table.insert(module, {
		Type = "Button",
		Args = {"God mode (Very, VERY UNSTABLE)", function(Self) -- Credits to EdgeIY, Infinite Yield
			local Cam = workspace.CurrentCamera
			local Pos, Char = Cam.CFrame, localplayer.Character
			local Human = Char and Char.FindFirstChildWhichIsA(Char, "Humanoid")
			local nHuman = Human.Clone(Human)
			nHuman.Parent, localplayer.Character = Char, nil
			nHuman.SetStateEnabled(nHuman, 15, false)
			nHuman.SetStateEnabled(nHuman, 1, false)
			nHuman.SetStateEnabled(nHuman, 0, false)
			nHuman.BreakJointsOnDeath, Human = true, Human.Destroy(Human)
			localplayer.Character, Cam.CameraSubject, Cam.CFrame = Char, nHuman, wait() and Pos
			nHuman.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
			local Script = Char.FindFirstChild(Char, "Animate")
			if Script then
				Script.Disabled = true
				wait()
				Script.Disabled = false
			end
			nHuman.Health = nHuman.MaxHealth
		end,}
	})
	
	
	
	
	table.insert(module, {
		Type = "Button",
		Args = {"Kill closest player as murderer", function()
			if findMurderer() ~= localplayer then fu.notification("You're not murderer.") return end
	
			if not localplayer.Character:FindFirstChild("Knife") then
				local hum = localplayer.Character:FindFirstChild("Humanoid")
				if localplayer.Backpack:FindFirstChild("Knife") then
					localplayer.Character:FindFirstChild("Humanoid"):EquipTool(localplayer.Backpack:FindFirstChild("Knife"))
				else
					fu.notification("You don't have the knife..?")
					return
				end
			end
	
			local NearestPlayer = findNearestPlayer()
	
			if not NearestPlayer or not NearestPlayer.Character then
				fu.notification("Can't find a player!?")
				return
			end
			local nearestHRP = NearestPlayer.Character:FindFirstChild("HumanoidRootPart")
			if not nearestHRP then
				fu.notification("Can't find the player's pivot.")
			end
	
			if not localplayer.Character:FindFirstChild("HumanoidRootPart") then fu.notification("You're not a valid character.") return end
			if not simulateKnifeThrow then
				nearestHRP.Anchored = true
				nearestHRP.CFrame = localplayer.Character:FindFirstChild("HumanoidRootPart").CFrame + localplayer.Character:FindFirstChild("HumanoidRootPart").CFrame.LookVector * 2
				task.wait(0.1)
				local args = {
					[1] = "Slash"
				}
	
				localplayer.Character.Knife.Stab:FireServer(unpack(args))
				return
			else
				local lpknife = localplayer.Character:FindFirstChild("Knife")
				if not lpknife then return end
	
				local raycastParams = RaycastParams.new()
				raycastParams.FilterType = Enum.RaycastFilterType.Exclude
				raycastParams.FilterDescendantsInstances = {localplayer.Character}
				local rayResult = workspace:Raycast(lpknife:GetPivot().Position, (nearestHRP.Position - localplayer.Character:FindFirstChild("HumanoidRootPart").Position).Unit * 350, raycastParams)
				local toThrow = nearestHRP.Position
				--if rayResult then
				--	toThrow = rayResult.Position
				--end
				--if math.random(0, 10) == 5 then -- idk what the fuk im doing
				--	toThrow = nearestHRP.Position
				--end
				local args = {
					[1] = lpknife:GetPivot(), 
					[2] = toThrow
				}
	
				localplayer.Character.Knife.Throw:FireServer(unpack(args))
				return
			end
	
	
		end,}
	})
	
	-- table.insert(module, {
	-- 	Type = "Toggle",
	-- 	Args = {"Simulate knife throw for killing nearest", function(Self, state)
	-- 		simulateKnifeThrow = state
	-- 		if state then
	-- 			fu.notification("Simulating a knife throw can make you look legitimate. However, note that it's less reliable and may miss the target.")
	-- 		end
	-- 	end,}
	-- })
	
	local killAuraCon = nil
	
	table.insert(module, {
		Type = "Toggle",
		Args = {"Murderer kill aura", function(Self, state)
			if state then
				if killAuraCon then killAuraCon:Disconnect() end
			else
				killAuraCon = game:GetService("RunService").Heartbeat:Connect(function()
					for _, player in ipairs(game.Players:GetPlayers()) do
						if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player ~= localplayer then
							local hrp = player.Character:FindFirstChild("HumanoidRootPart")
							if (hrp.Position - localplayer.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude < 7 then
								hrp.Anchored = true
								hrp.CFrame = localplayer.Character:FindFirstChild("HumanoidRootPart").CFrame + localplayer.Character:FindFirstChild("HumanoidRootPart").CFrame.LookVector * 2
	
								task.wait(0.1)
								local args = {
									[1] = "Slash"
								}
	
								localplayer.Character.Knife.Stab:FireServer(unpack(args))
								return	
							end
						end
					end
				end)
			end
		end,}
	})
	
	table.insert(module, {
		Type = "Button",
		Args = {"Kill EVERYONE as murderer", function()
			if findMurderer() ~= localplayer then fu.notification("You're not murderer.") return end
	
			if not localplayer.Character:FindFirstChild("Knife") then
				local hum = localplayer.Character:FindFirstChild("Humanoid")
				if localplayer.Backpack:FindFirstChild("Knife") then
					localplayer.Character:FindFirstChild("Humanoid"):EquipTool(localplayer.Backpack:FindFirstChild("Knife"))
				else
					fu.notification("You don't have the knife..?")
					return
				end
			end
	
			for _, player in ipairs(game.Players:GetPlayers()) do
				if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player ~= localplayer then
					player.Character:FindFirstChild("HumanoidRootPart").Anchored = true
					player.Character:FindFirstChild("HumanoidRootPart").CFrame = localplayer.Character:FindFirstChild("HumanoidRootPart").CFrame + localplayer.Character:FindFirstChild("HumanoidRootPart").CFrame.LookVector * 1 
	
				end	
			end
	
			local args = {
				[1] = "Slash"
			}
			localplayer.Character.Knife.Stab:FireServer(unpack(args))
		end,}
	})
	
	--table.insert(module, {
	--	Type = "Text",
	--	Args = {"Coin farming"}
	--})
	
	
	--local Players = game:GetService("Players")
	--local RunService = game:GetService("RunService")
	
	--local coinFarming = false
	--local coinFarmConnection = nil
	--local coinCollected = 0
	--local coinBag = 0
	--local coinLimit = 50
	--local coinBlacklists = {}
	
	--game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Gameplay"):WaitForChild("CoinCollected").OnClientEvent:Connect(function(arg1, arg2, arg3)
	--	local amount = tonumber(arg1) or tonumber(arg2)
	--	local limit = tonumber(arg2) or tonumber(arg3)
	--	if amount then coinBag = amount end
	--	if limit then coinLimit = limit end
	--end)
	
	--local FARM_SPEED = 30
	
	--local function isPlayerInLobby()
	--	local coinFolder = workspace:FindFirstChild("CoinContainer", true) or workspace:FindFirstChild("CoinVisuals", true) or workspace:FindFirstChild("Coins", true)
	--	if not coinFolder then return true end
	
	--	local lobby = workspace:FindFirstChild("Lobby")
	--	if lobby and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
	--		local dist = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - lobby:GetPivot().Position).Magnitude
	--		if dist < 200 then return true end
	--	end
	--	return false
	--end
	
	--local function getNearestCoin(hrp)
	--	local container = workspace:FindFirstChild("CoinContainer", true) or workspace:FindFirstChild("CoinVisuals", true) or workspace:FindFirstChild("Coins", true)
	--	if not container then return nil end
	
	--	local nearest, minDist = nil, math.huge
	--	for _, coin in ipairs(container:GetChildren()) do
	--		if coin:IsA("BasePart") and not coinBlacklists[coin] and (coin.Name == "Coin_Server" or coin:FindFirstChildWhichIsA("TouchTransmitter")) then
	--			local visual = coin:FindFirstChild("CoinVisual")
	--			if not visual or visual.Transparency == 0 then
	--				local dist = (hrp.Position - coin.Position).Magnitude
	--				if dist < minDist then
	--					minDist = dist
	--					nearest = coin
	--				end
	--			end
	--		end
	--	end
	--	return nearest
	--end
	
	--local function startCoinFarm()
	--	if coinFarming then fu.notification("Already coin farming.") return end
	
	--	coinFarming = true
	
	--	coinFarmConnection = RunService.Heartbeat:Connect(function()
	--		local char = Players.LocalPlayer.Character
	--		local hrp = char and char:FindFirstChild("HumanoidRootPart")
	--		local hum = char and char:FindFirstChild("Humanoid")
	
	--		if not hrp or not hum or hum.Health <= 0 then return end 
	
	--		if isPlayerInLobby() then 
	--			coinBag = 0
	--			coinBlacklists = {}
	--			hrp.Velocity = Vector3.zero
	--			fu.dialog("Coin farming | IN LOBBY", `{coinCollected} coins collected.`, {})
	--			return 
	--		end
	
	--		if coinBag >= coinLimit then
	--			hrp.Velocity = Vector3.zero
	--			fu.dialog("Coin farming | COIN MAX", `{coinCollected} coins collected.`, {})
	--			return
	--		end
	
	--		local target = getNearestCoin(hrp)
	
	--		if target then
	--			for _, part in ipairs(char:GetDescendants()) do
	--				if part:IsA("BasePart") then part.CanCollide = false end
	--			end
	
	--			local direction = (target.Position - hrp.Position).Unit
	--			hrp.Velocity = direction * FARM_SPEED
	--			hrp.CFrame = CFrame.new(hrp.Position, target.Position)
	
	--			local distance = (target.Position - hrp.Position).Magnitude
	--			if distance < 3 then
	--				local touch = target:FindFirstChildWhichIsA("TouchTransmitter", true) or target
	--				if firetouchinterest then
	--					firetouchinterest(hrp, touch.Parent or touch, 0)
	
	--					task.spawn(function()
	--						task.wait()
	--						firetouchinterest(hrp, touch.Parent or touch, 1)
	--					end)
	--				end
	
	--				coinCollected += 1
	--				coinBlacklists[target] = true
	--			end
	--		else
	--			hrp.Velocity = Vector3.zero
	--		end
	
	--		fu.dialog("Coin farming", `{coinBag} / {coinLimit} in bag. Total: {coinCollected}`, {})
	--	end)
	--end
	
	--table.insert(module, {
	--	Type = "Button",
	--	Args = {"Start coin farming", function()
	--		startCoinFarm()
	--	end,}
	--})
	
	--table.insert(module, {
	--	Type = "Button",
	--	Args = {"Stop coin farming", function()
	--		if not coinFarming then fu.notification("You're not coin farming.") return end
	--		fu.notification("Stopped coin farming. Collected " .. coinCollected .. " coins.")
	
	--		coinFarming = false
	--		if coinFarmConnection then 
	--			coinFarmConnection:Disconnect() 
	--			coinFarmConnection = nil 
	--		end
	
	--		coinCollected = 0
	--		coinBlacklists = {}
	--		coinBag = 0
	--		fu.closedialog()
	
	--		local char = game.Players.LocalPlayer.Character
	--		if char then
	--			for _, part in ipairs(char:GetDescendants()) do
	--				if part:IsA("BasePart") then part.CanCollide = true end
	--			end
	--			local hrp = char:FindFirstChild("HumanoidRootPart")
	--			if hrp then hrp.Velocity = Vector3.zero end
	--		end
	--	end,}
	--})
	
	-- no i give up im srry this ass
	
	-- any smarties wanna fixthis ass code please do
	
	
	table.insert(module, {
		Type = "Text",
		Args = {"Fun"}
	})
	
	table.insert(module, {
		Type = "Button",
		Args = {"Hold everyone hostage", function()
			if findMurderer() ~= localplayer then fu.notification("You're not murderer. This'll only be useful if you're the murderer.") return end
	
			for _, player in ipairs(game.Players:GetPlayers()) do
				if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player ~= localplayer then
					player.Character:FindFirstChild("HumanoidRootPart").Anchored = true
					player.Character:FindFirstChild("HumanoidRootPart").CFrame = localplayer.Character:FindFirstChild("HumanoidRootPart").CFrame + localplayer.Character:FindFirstChild("HumanoidRootPart").CFrame.LookVector * 5
				end	
			end
	
			fu.notification("Placed every single player in a single point. Kill everyone at once once you decide to.")
		end,}
	})
	
	repeat task.wait() until getgenv().Modules
	getgenv().Modules[3] = module
	fu.refreshlist()
end
local function ONOAH_routine() -- Routine: StarterGui.YARHM.Open.InitOpen
    local script = Instance.new("LocalScript")
    script.Name = "InitOpen"
    script.Parent = Converted["_Open"]
    local req = require
    local require = function(obj)
        local routine = routine_module_scripts[obj]
        if routine then
            return routine()
        end
        return req(obj)
    end


	local ts = game:GetService("TweenService")
	
	
	local stroke = Instance.new("UIStroke")
	stroke.Parent = script.Parent
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Color = Color3.fromRGB(255,255,255)
	
	
	script.Parent.Position = UDim2.fromScale(0.5, -1)
	ts:Create(script.Parent, TweenInfo.new(1.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {
		Position = UDim2.fromScale(0.5, 0.063)
	}):Play()
	
	
	task.wait(5)
	ts:Create(script.Parent, TweenInfo.new(5), {
		TextTransparency = 1
	}):Play()
	--ts:Create(stroke, TweenInfo.new(5), {
	--	Transparency = 1
	--}):Play()
end
local function JFQXCG_routine() -- Routine: StarterGui.YARHM.Open.OnClick
    local script = Instance.new("LocalScript")
    script.Name = "OnClick"
    script.Parent = Converted["_Open"]
    local req = require
    local require = function(obj)
        local routine = routine_module_scripts[obj]
        if routine then
            return routine()
        end
        return req(obj)
    end


	local ts = game:GetService("TweenService")
	
	local clickCount = 0
	local lastClickTime = tick()
	script.Parent.MouseButton1Click:Connect(function()
		local currentTime = tick()
		
		script.Parent.TextTransparency = 1
		ts:Create(script.Parent, TweenInfo.new(1),
			{TextTransparency = 1}
		):Play()
		
		-- Check if the time since the last click is within a certain threshold
		if currentTime - lastClickTime < 0.5 then
			clickCount = clickCount + 1
		else
			
			clickCount = 1
		end
	
		lastClickTime = currentTime
	
		if clickCount == 3 then
			-- Triple-click detected
	
			ts:Create(getgenv().YARHM.Menu, TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out), 
				{Position = UDim2.fromScale(0.499, 0.041), Size = UDim2.fromOffset(441, 268)}
			):Play()
		end
	end)
	
end
local function EJGX_routine() -- Routine: StarterGui.YARHM.Open.Resizer
    local script = Instance.new("LocalScript")
    script.Name = "Resizer"
    script.Parent = Converted["_Open"]
    local req = require
    local require = function(obj)
        local routine = routine_module_scripts[obj]
        if routine then
            return routine()
        end
        return req(obj)
    end



	local guiObject = script.Parent
	local userInputService = game:GetService("UserInputService")
	local ts = game:GetService("TweenService")
	
	local resizing = false
	local initialMousePosition = nil
	local initialSize = nil
	local touchCount = 0
	
	-- Define the minimum width (50 pixels) and maximum width (initial width)
	local MIN_WIDTH = 100
	local MAX_WIDTH = guiObject.Size.X.Offset
	
	local function onInputBegan(input, gameProcessed)
		if input.UserInputType == Enum.UserInputType.Touch then
			touchCount = touchCount + 1
		end
	
		if touchCount == 2 then
			resizing = false
			return
		end
	
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			resizing = true
			initialMousePosition = input.Position
			initialSize = guiObject.Size
		end
	end
	
	local function onInputEnded(input, gameProcessed)
		if input.UserInputType == Enum.UserInputType.Touch then
			touchCount = touchCount - 1
		end
	
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then		
			resizing = false
			initialMousePosition = nil
			initialSize = nil
			--ts:Create(guiObject.UIStroke, TweenInfo.new(1.2, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
			--	Transparency = 1
			--}):Play()
		end
	end
	
	local function onInputChanged(input, gameProcessed)
		if touchCount == 2 then
			return
		end
	
		if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - initialMousePosition
			if math.abs(delta.X) > 50 then
				local newWidth = math.clamp(initialSize.X.Offset + delta.X, MIN_WIDTH, MAX_WIDTH)
				local newSize = UDim2.new(
					initialSize.X.Scale,
					newWidth,
					initialSize.Y.Scale,
					initialSize.Y.Offset
				)
				ts:Create(guiObject, TweenInfo.new(0.8, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
					Size = newSize
				}):Play()
				--guiObject.UIStroke.Transparency = 0
			end
		end
	end
	
	guiObject.InputBegan:Connect(onInputBegan)
	guiObject.InputEnded:Connect(onInputEnded)
	userInputService.InputChanged:Connect(onInputChanged)
	
end
local function FRPPL_routine() -- Routine: StarterGui.YARHM.FloatingButton.Keybinding
    local script = Instance.new("LocalScript")
    script.Name = "Keybinding"
    script.Parent = Converted["_FloatingButton"]
    local req = require
    local require = function(obj)
        local routine = routine_module_scripts[obj]
        if routine then
            return routine()
        end
        return req(obj)
    end


	
end
local function VOBA_routine() -- Routine: StarterGui.YARHM.FloatingButton.Invisible
    local script = Instance.new("LocalScript")
    script.Name = "Invisible"
    script.Parent = Converted["_FloatingButton"]
    local req = require
    local require = function(obj)
        local routine = routine_module_scripts[obj]
        if routine then
            return routine()
        end
        return req(obj)
    end


	--local ts = game:GetService("TweenService")
	
	--local holding = false
	--local invisible = false
	
	
	
	--script.Parent.MouseButton1Down:Connect(function()
	--	holding = true
	--	task.wait(0.5)
	--	if holding then
	--		if not invisible then 
	--			invisible = true
	--			ts:Create(script.Parent, TweenInfo.new(1, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {
	--				BackgroundTransparency = 1,
	--				TextTransparency = 1
	--			}):Play()
	--			ts:Create(script.Parent.UIStroke, TweenInfo.new(1, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {
	--				Transparency = 0.7
	--			}):Play()
	--		else
	--			invisible = false
	--			ts:Create(script.Parent, TweenInfo.new(1, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {
	--				BackgroundTransparency = 0,
	--				TextTransparency = 0
	--			}):Play()
	--			ts:Create(script.Parent.UIStroke, TweenInfo.new(1, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {
	--				Transparency = 0
	--			}):Play()
	--		end
	--	end
	--end)
	
	--script.Parent.MouseButton1Up:Connect(function()
	--	holding = false
	--end)
end
local function SZSARYI_routine() -- Routine: StarterGui.YARHM.AddCustomModule.Add.LocalScript
    local script = Instance.new("LocalScript")
    script.Name = "LocalScript"
    script.Parent = Converted["_Add"]
    local req = require
    local require = function(obj)
        local routine = routine_module_scripts[obj]
        if routine then
            return routine()
        end
        return req(obj)
    end


	local ts = game:GetService("TweenService")
	
	local function loadModule(modulelink)
		if script.Parent.Parent.TextBox.Text == "" and not modulelink then return end
		ts:Create(script.Parent.Parent.Parent.Menu.UIScale, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Scale = 1
		}):Play()
		ts:Create(script.Parent.Parent, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Position = UDim2.fromScale(0.5, -0.5)
		}):Play()
	
	
		local lastmodule = getgenv().Modules[#getgenv().Modules]
		require(script.Parent.Parent.Parent.FUNCTIONS).notification("Module is loading...")
	
		local moduleload = modulelink
		if script.Parent.Parent.TextBox.Text ~= "" then
			moduleload = script.Parent.Parent.TextBox.Text
		end
	
		local moduleEx = loadstring(game:HttpGet(moduleload))
		--setfenv(moduleEx, {FUNCTIONS = require(script.Parent.Parent.Parent.FUNCTIONS)})
	
		local newmodule = moduleEx()
		if newmodule["BG_TASK"] then
			coroutine.wrap(newmodule["BG_TASK"])()
		end
		if getgenv().Modules[#getgenv().Modules] ~= lastmodule then
			local newmodule = getgenv().Modules[#getgenv().Modules]
			require(script.Parent.Parent.Parent.FUNCTIONS).notification("New module added: " .. newmodule["Name"])
			require(script.Parent.Parent.Parent.FUNCTIONS).refreshlist()
		else
			require(script.Parent.Parent.Parent.FUNCTIONS).notification("Module failed to load...")
		end
	end
	script.Parent.MouseButton1Click:Connect(function() loadModule() end)
	
	-- Additional plugin modules
	task.wait(1.5)
	if game.gameId == 5794311181 then loadModule("https://yarhm.mhi.im/static/cnasim.yrmdl") end -- CNA Simulator
end
local function UVBTWP_routine() -- Routine: StarterGui.YARHM.AddCustomModule.Cancel.LocalScript
    local script = Instance.new("LocalScript")
    script.Name = "LocalScript"
    script.Parent = Converted["_Cancel"]
    local req = require
    local require = function(obj)
        local routine = routine_module_scripts[obj]
        if routine then
            return routine()
        end
        return req(obj)
    end


	local ts = game:GetService("TweenService")
	
	script.Parent.MouseButton1Click:Connect(function()
		ts:Create(script.Parent.Parent.Parent.Menu.UIScale, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Scale = 1
		}):Play()
		ts:Create(script.Parent.Parent, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Position = UDim2.fromScale(0.5, -0.5)
		}):Play()
	end)
end
local function HCWF_routine() -- Routine: StarterGui.YARHM.Menu.UIStroke.UIGradient.Animator
    local script = Instance.new("LocalScript")
    script.Name = "Animator"
    script.Parent = Converted["_UIGradient4"]
    local req = require
    local require = function(obj)
        local routine = routine_module_scripts[obj]
        if routine then
            return routine()
        end
        return req(obj)
    end


	local ts = game:GetService("TweenService")
	
	ts:Create(script.Parent, TweenInfo.new(
		10, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut,
		math.huge, false), {
			Rotation = -180
		}):Play()
end
local function AWDPHWS_routine() -- Routine: StarterGui.YARHM.Menu.CloseArea.CloseOpen
    local script = Instance.new("LocalScript")
    script.Name = "CloseOpen"
    script.Parent = Converted["_CloseArea"]
    local req = require
    local require = function(obj)
        local routine = routine_module_scripts[obj]
        if routine then
            return routine()
        end
        return req(obj)
    end


	local TweenService = game:GetService("TweenService")
	local RunService = game:GetService("RunService")
	local UserInputService = game:GetService("UserInputService")
	
	local menu = script.Parent.Parent
	local Spring = require(menu.Parent.Spring)
	local DraggableObject = require(menu.Parent.DraggableObject)
	local Bezier = require(menu.Parent.Bezier)
	
	-- Tween the TextLabel transparency
	--TweenService:Create(script.Parent.TextLabel, TweenInfo.new(20, Enum.EasingStyle.Linear), {
	--	TextTransparency = 1,
	--	BackgroundTransparency = 1
	--}):Play()
	
	local closed = false
	local springing = false
	
	local closing
	
	local lastPos = UDim2.fromScale(0.5, 0.5)
	local closedLastPos = UDim2.fromScale(0.5, 0.1)
	
	-- Initialize springs for menu position and size
	local MenuPosXScale = Spring.new(0.7, 30, 160, menu.Position.X.Scale, 0, menu.Position.X.Scale)
	local MenuPosYScale = Spring.new(0.7, 45, 190, 0.05, 0, 0.05)
	local MenuPosXOffset = Spring.new(0.7, 30, 160, 0, 0)
	local MenuPosYOffset = Spring.new(0.7, 45, 190, 0, 0)
	local MenuSizeXOffset = Spring.new(1, 25, 120, menu.Size.X.Offset, 0, menu.Size.X.Offset)
	local MenuSizeYOffset = Spring.new(1, 25, 120, menu.Size.Y.Offset, 0, menu.Size.Y.Offset)
	
	local MenuRotation = Spring.new(1, 18, 100, menu.Rotation, 0, menu.Rotation)
	
	
	-- Functions to update spring goals and offsets
	local function setSpringPosGoal(udim2)
		MenuPosXScale:SetGoal(udim2.X.Scale)
		MenuPosYScale:SetGoal(udim2.Y.Scale)
		MenuPosXOffset:SetGoal(udim2.X.Offset)
		MenuPosYOffset:SetGoal(udim2.Y.Offset)
	end
	
	local function setSpringSizeGoal(udim2)
		MenuSizeXOffset:SetGoal(udim2.X.Offset)
		MenuSizeYOffset:SetGoal(udim2.Y.Offset)
	end
	
	-- Render step to update menu position and size based on spring values
	RunService.RenderStepped:Connect(function()
		if springing then
			menu.Position = UDim2.new(MenuPosXScale.Offset, MenuPosXOffset.Offset, MenuPosYScale.Offset, MenuPosYOffset.Offset)
			menu.Size = UDim2.fromOffset(MenuSizeXOffset.Offset, MenuSizeYOffset.Offset)
			menu.Rotation = MenuRotation.Offset
			MenuRotation:SetGoal(0)
		end
	end)
	
	-- Initialize draggable menu
	local MenuDrag = DraggableObject.new(script.Parent, menu, false, true)
	MenuDrag:Enable()
	
	local OpenerMenuDrag = DraggableObject.new(script.Parent.Parent.CanvasGroup.Opener, menu, false, true)
	OpenerMenuDrag:Enable()
	local OpenerDraggable = true
	
	textHidden = false
	
	
	-- Dragging behavior
	local deltaFrom = menu.Position
	MenuDrag.Dragged = function(pos)
		--if not textHidden then
		--	textHidden = true
		--	TweenService:Create(script.Parent.TextLabel, TweenInfo.new(1, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
		--		TextTransparency = 1,
		--		BackgroundTransparency = 1
		--	}):Play()
		--end
		local delta = pos - deltaFrom
		deltaFrom = pos
		MenuRotation:SetGoal(delta.X.Offset * 0.5)
		setSpringPosGoal(pos)
		TweenService:Create(menu.UIScale, TweenInfo.new(0.6, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
			Scale = 0.95
		}):Play()
	end
	
	OpenerMenuDrag.Dragged = function(pos)
		if OpenerDraggable then
			closedLastPos = pos
			setSpringPosGoal(pos)
		end
	end
	
	script.Parent.MouseButton1Click:Connect(function()
		if not textHidden then
			textHidden = true
			TweenService:Create(script.Parent.TextLabel, TweenInfo.new(1, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
				TextTransparency = 1,
				BackgroundTransparency = 1
			}):Play()
		end
		TweenService:Create(menu, TweenInfo.new(2, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
			AnchorPoint = Vector2.new(0.5, 0.5)
		}):Play()
		springing = true
		setSpringPosGoal(closedLastPos)
		setSpringSizeGoal(UDim2.fromOffset(60, 60))
		--script.Parent.ZIndex = script.Parent.ZIndex - 2
		if not menu.Area:FindFirstChildWhichIsA("UICorner") then
			Instance.new("UICorner", menu.Area)
		end
		menu.Area:FindFirstChildWhichIsA("UICorner").CornerRadius = UDim.new(0, 16)
		task.spawn(function() task.wait(0.05) menu.List.Visible = false end)
		menu.CanvasGroup.Visible = true
		OpenerDraggable = true
		if closing then closing:Cancel() end
		TweenService:Create(menu.CanvasGroup, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
			GroupTransparency = 0
		}):Play()
	end)
	
	MenuDrag.DragEnded = function(vel)
		TweenService:Create(
			menu.UIScale,
			TweenInfo.new(0.6, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
			{ Scale = 1 }
		):Play()
	
		if math.abs(vel.Y) > 10 then
			local thrownPosition = menu.Position
	
			if not textHidden then
				textHidden = true
				TweenService:Create(
					script.Parent.TextLabel,
					TweenInfo.new(1, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
					{
						TextTransparency = 1,
						BackgroundTransparency = 1
					}
				):Play()
			end
	
			TweenService:Create(
				menu,
				TweenInfo.new(2, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
				{ AnchorPoint = Vector2.new(0.5, 0.5) }
			):Play()
			
			local farPos = Vector3.new(thrownPosition.X.Offset + vel.X * 10, thrownPosition.Y.Offset + vel.Y * 10, 0)
	
			springing = true
			
			local bezierCurve = Bezier.new(
				Vector3.new(thrownPosition.X.Offset, thrownPosition.Y.Offset, 0),
				farPos,
				Vector3.new(closedLastPos.X.Offset, closedLastPos.Y.Offset, 0)
			)
			local points = bezierCurve:GetPath(0.5)
	
			--setSpringPosGoal(UDim2.new(closedLastPos.X.Scale, farPos.X, closedLastPos.Y.Scale, farPos.Y))
			setSpringPosGoal(UDim2.new(closedLastPos.X.Scale, points[math.ceil(#points/2)].X, closedLastPos.Y.Scale, points[math.ceil(#points/2)].Y))
			setSpringSizeGoal(UDim2.fromOffset(60 - vel.Y * 2, 60 - vel.Y * 2))
	
			task.wait(0.1)
	
			--task.spawn(function()
			--	for _, point in bezierCurve:GetPath(0.08) do
			--		setSpringPosGoal(UDim2.new(closedLastPos.X.Scale, point.X, closedLastPos.Y.Scale, point.Y))
			--		task.wait()
			--	end
			--end)
	
			setSpringSizeGoal(UDim2.fromOffset(60, 60))
			setSpringPosGoal(UDim2.new(closedLastPos.X.Scale, closedLastPos.X.Offset, closedLastPos.Y.Scale, closedLastPos.Y.Offset))
			menu.Area.UICorner.CornerRadius = UDim.new(0, 16)
			task.delay(0.25, function() menu.List.Visible = false end)
			menu.CanvasGroup.Visible = true
	
			OpenerDraggable = true
	
			if closing then closing:Cancel() end
	
			TweenService:Create(
				menu.CanvasGroup,
				TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out),
				{ GroupTransparency = 0 }
			):Play()
		else
			lastPos = menu.Position
		end
	end
	
	
	-- Opener button behavior
	local function sign(n) if n>0 then return 1 elseif n<0 then return -1 else return 0 end end
	local function openMenu()
		TweenService:Create(menu, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
			AnchorPoint = Vector2.new(0.5, 0)
		}):Play()
	
		local bezierCurve = Bezier.new(
			Vector3.new(closedLastPos.X.Offset, closedLastPos.Y.Offset, 0),
			Vector3.new(
				(closedLastPos.X.Offset + lastPos.X.Offset) / 2,
				lastPos.Y.Offset + (math.abs(lastPos.Y.Offset - closedLastPos.Y.Offset) * 2.5 * -math.sign(closedLastPos.Y.Offset - lastPos.Y.Offset)),
				0
			),
			Vector3.new(lastPos.X.Offset, lastPos.Y.Offset, 0)
		)
	
		task.spawn(function()
			for _, point in bezierCurve:GetPath(0.2) do
				setSpringPosGoal(UDim2.new(closedLastPos.X.Scale, point.X, closedLastPos.Y.Scale, point.Y))
				task.wait() task.wait() -- 2 heartbeats uwu
			end
		end)
		--setSpringPosGoal(lastPos)
		setSpringSizeGoal(UDim2.fromOffset(441, 268))
		OpenerDraggable = false
		--script.Parent.ZIndex = script.Parent.ZIndex + 2
		menu.Area.UICorner.CornerRadius = UDim.new(0, 0)
		menu.List.Visible = true
		closing = TweenService:Create(menu.CanvasGroup, TweenInfo.new(0.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
			GroupTransparency = 1
		})
		closing:Play()
		closing.Completed:Once(function(state)
			menu.CanvasGroup.Visible = false
		end)
	end
	menu.CanvasGroup.Opener.MouseButton1Click:Connect(openMenu)
	UserInputService.InputBegan:Connect(function(inp, proc)
		if proc then return end
	
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt) and inp.KeyCode == Enum.KeyCode.Y then
			openMenu()
		end
	end)
	
	-- Parallax camera offset
	local RunService = game:GetService("RunService")
	local cam = workspace.CurrentCamera
	
	local lastLook = cam.CFrame.LookVector
	local uiOffset = Vector2.new(0, 0)
	local prevUiOffset = Vector2.new(0, 0)
	
	local function normalizeAngle(angle)
		while angle > math.pi do angle = angle - 2 * math.pi end
		while angle <= -math.pi do angle = angle + 2 * math.pi end
		return angle
	end
	
	RunService.RenderStepped:Connect(function(dt)
		local look = cam.CFrame.LookVector
	
		local oldYaw   = math.atan2(lastLook.X, lastLook.Z)        
		local newYaw   = math.atan2(look.X, look.Z)
	
		local oldPitch = math.asin(math.clamp(lastLook.Y, -1, 1))
		local newPitch = math.asin(math.clamp(look.Y, -1, 1))
	
		local deltaYaw   = normalizeAngle(newYaw - oldYaw)
		local deltaPitch = newPitch - oldPitch  
	
		local targetOffset = Vector2.new(deltaYaw * 15, deltaPitch * 15)
	
		uiOffset = uiOffset:Lerp(targetOffset, 0.2)
		--uiOffset = uiOffset * Vector2.new(-1, 1)
	
		
		if not OpenerDraggable then
			MenuPosXOffset:SetGoal((MenuPosXOffset.Goal - prevUiOffset.X) + uiOffset.X)
			MenuPosYOffset:SetGoal((MenuPosYOffset.Goal - prevUiOffset.Y) + uiOffset.Y)
		end
		prevUiOffset = uiOffset
		
		lastLook = look
	end)
	
	
	
	script.Parent.AllowForSpring.Event:Wait()
	springing = true
end
local function VTLALB_routine() -- Routine: StarterGui.YARHM.Menu.List.AutoSetup
    local script = Instance.new("LocalScript")
    script.Name = "AutoSetup"
    script.Parent = Converted["_List"]
    local req = require
    local require = function(obj)
        local routine = routine_module_scripts[obj]
        if routine then
            return routine()
        end
        return req(obj)
    end


	--local ts = game:GetService("TweenService")
	
	
	--local States = {}
	
	--local FloatingButtonConnectionsMouse = {}
	--local FloatingButtonConnectionsTouch = {}
	
	--task.wait(0.1)
	
	--AREA = script.Parent.Parent.Area
	
	--local function calculateWidth(n)
	--	if n <= 3 then
	--		return 30
	--	else
	--		local base = 30
	--		local additional = math.floor((n - 3) / 3) * 30
	--		return base + additional
	--	end
	--end
	
	----local listlayout = Instance.new("UIListLayout")
	----listlayout.Parent = AREA
	----listlayout.Padding = UDim.new(0, 10)
	----listlayout.FillDirection = Enum.FillDirection.Vertical
	----listlayout.SortOrder = Enum.SortOrder.LayoutOrder
	----listlayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	
	
	
	
	--task.wait(.5) -- magic number to wait modules to load lmao
	--task.spawn(function()
	--	require(script.Parent.Parent.Parent.FUNCTIONS).refreshlist()
	--	--for i = 1, 10 do
	--	--	task.wait(.1)
	--	--	require(script.Parent.Parent.Parent.FUNCTIONS).refreshlist()
	--	--end
	--end)
end
local function TVLRH_routine() -- Routine: StarterGui.YARHM.Menu.List.AddCustomModule.LocalScript
    local script = Instance.new("LocalScript")
    script.Name = "LocalScript"
    script.Parent = Converted["_AddCustomModule1"]
    local req = require
    local require = function(obj)
        local routine = routine_module_scripts[obj]
        if routine then
            return routine()
        end
        return req(obj)
    end


	local ts = game:GetService("TweenService")
	
	script.Parent.MouseButton1Click:Connect(function()
		ts:Create(script.Parent.Parent.Parent.UIScale, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Scale = 0.9
		}):Play()
		ts:Create(script.Parent.Parent.Parent.Parent.AddCustomModule, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Position = UDim2.fromScale(0.5, 0.5)
		}):Play()
	end)
end
local function KUFNO_routine() -- Routine: StarterGui.YARHM.FloatingButtonSetting.ControlBarContainer.ControlBar.Visibility.LocalScript
    local script = Instance.new("LocalScript")
    script.Name = "LocalScript"
    script.Parent = Converted["_Visibility"]
    local req = require
    local require = function(obj)
        local routine = routine_module_scripts[obj]
        if routine then
            return routine()
        end
        return req(obj)
    end


	script.Parent.MouseButton1Click:Connect(function()
		getgenv().YARHMFUNCTIONS.ftToggleVisibility()
	end)
end
local function XLYNZG_routine() -- Routine: StarterGui.YARHM.FloatingButtonSetting.ControlBarContainer.ControlBar.Lock.LocalScript
    local script = Instance.new("LocalScript")
    script.Name = "LocalScript"
    script.Parent = Converted["_Lock1"]
    local req = require
    local require = function(obj)
        local routine = routine_module_scripts[obj]
        if routine then
            return routine()
        end
        return req(obj)
    end


	script.Parent.MouseButton1Click:Connect(function()
		getgenv().YARHMFUNCTIONS.ftToggleLock()
	end)
end
local function XAPKH_routine() -- Routine: StarterGui.YARHM.FloatingButtonSetting.ControlBarContainer.ControlBar.Exit.LocalScript
    local script = Instance.new("LocalScript")
    script.Name = "LocalScript"
    script.Parent = Converted["_Exit"]
    local req = require
    local require = function(obj)
        local routine = routine_module_scripts[obj]
        if routine then
            return routine()
        end
        return req(obj)
    end


	script.Parent.MouseButton1Click:Connect(function()
		getgenv().YARHMFUNCTIONS.closeFinetuneFB()
	end)
end

coroutine.wrap(WMYX_routine)()
coroutine.wrap(CEBY_routine)()
coroutine.wrap(DSZIHQM_routine)()
coroutine.wrap(EXEKBZ_routine)()
coroutine.wrap(XXZOB_routine)()
coroutine.wrap(ONOAH_routine)()
coroutine.wrap(JFQXCG_routine)()
coroutine.wrap(EJGX_routine)()
coroutine.wrap(FRPPL_routine)()
coroutine.wrap(VOBA_routine)()
coroutine.wrap(SZSARYI_routine)()
coroutine.wrap(UVBTWP_routine)()
coroutine.wrap(HCWF_routine)()
coroutine.wrap(AWDPHWS_routine)()
coroutine.wrap(VTLALB_routine)()
coroutine.wrap(TVLRH_routine)()
coroutine.wrap(KUFNO_routine)()
coroutine.wrap(XLYNZG_routine)()
coroutine.wrap(XAPKH_routine)()
