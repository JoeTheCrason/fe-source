--[[
	NPC Panel - Modern UI Module
	Original script by @Im_Patrick
	UI redesign: modernized layout, cleaner controls, improved NPC selection feedback
--]]

local G2L = {}
local core

if game:FindFirstChildOfClass("CoreGui") then
	if gethui then
		core = gethui()
	else
		core = game:GetService("CoreGui")
	end
else
	core = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
end

local tweenservice = game:GetService("TweenService")

local fast   = TweenInfo.new(0.35, Enum.EasingStyle.Exponential)
local medium = TweenInfo.new(0.5,  Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local slow   = TweenInfo.new(0.75, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

-- ─────────────────────────── COLOURS ───────────────────────────
local C = {
	bg          = Color3.fromRGB(14,  14,  18),
	surface     = Color3.fromRGB(22,  22,  30),
	surfaceHigh = Color3.fromRGB(30,  30,  42),
	border      = Color3.fromRGB(50,  50,  70),
	accent      = Color3.fromRGB(110, 90,  255),
	accentDim   = Color3.fromRGB(70,  55,  180),
	accentGlow  = Color3.fromRGB(140, 120, 255),
	green       = Color3.fromRGB(40,  210, 110),
	red         = Color3.fromRGB(220, 60,  60),
	textPrimary = Color3.fromRGB(240, 240, 255),
	textMuted   = Color3.fromRGB(140, 140, 165),
	textAccent  = Color3.fromRGB(170, 155, 255),
	white       = Color3.fromRGB(255, 255, 255),
}

-- ─────────────────────────── HELPERS ───────────────────────────
local function makefont(weight)
	return Font.new("rbxasset://fonts/families/GothamSSm.json", weight or Enum.FontWeight.Regular, Enum.FontStyle.Normal)
end

local function corner(parent, radius)
	local c = Instance.new("UICorner", parent)
	c.CornerRadius = UDim.new(0, radius or 8)
	return c
end

local function stroke(parent, thickness, color, transparency)
	local s = Instance.new("UIStroke", parent)
	s.Thickness = thickness or 1
	s.Color = color or C.border
	s.Transparency = transparency or 0
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	return s
end

local function gradient(parent, c0, c1, rotation)
	local g = Instance.new("UIGradient", parent)
	g.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, c0),
		ColorSequenceKeypoint.new(1, c1),
	}
	g.Rotation = rotation or 90
	return g
end

local function label(parent, text, textsize, color, weight, font)
	local l = Instance.new("TextLabel", parent)
	l.Text = text or ""
	l.TextSize = textsize or 13
	l.TextColor3 = color or C.textPrimary
	l.FontFace = font or makefont(weight or Enum.FontWeight.Regular)
	l.BackgroundTransparency = 1
	l.BorderSizePixel = 0
	l.TextXAlignment = Enum.TextXAlignment.Left
	l.TextYAlignment = Enum.TextYAlignment.Center
	l.RichText = true
	l.TextWrapped = true
	l.Size = UDim2.new(1, 0, 1, 0)
	return l
end

local function imagebutton(parent, size, position)
	local b = Instance.new("ImageButton", parent)
	b.Size = size or UDim2.new(1, 0, 1, 0)
	b.Position = position or UDim2.new(0, 0, 0, 0)
	b.BackgroundTransparency = 1
	b.BorderSizePixel = 0
	b.Image = ""
	b.ZIndex = 10
	return b
end

-- ─────────────────────────── SCREEN GUI ───────────────────────────
G2L["screen"] = Instance.new("ScreenGui", core)
G2L["screen"].IgnoreGuiInset = true
G2L["screen"].DisplayOrder = 5
G2L["screen"].ScreenInsets = Enum.ScreenInsets.None
G2L["screen"].ClipToDeviceSafeArea = false
G2L["screen"].ResetOnSpawn = false

-- ─────────────────────────── DARK OVERLAY ───────────────────────────
G2L["dark"] = Instance.new("Frame", G2L["screen"])
G2L["dark"].Name = "dark"
G2L["dark"].Size = UDim2.new(1, 0, 1, 0)
G2L["dark"].BackgroundColor3 = Color3.fromRGB(0, 0, 0)
G2L["dark"].BackgroundTransparency = 1
G2L["dark"].BorderSizePixel = 0
G2L["dark"].Visible = false
G2L["dark"].ZIndex = -10

-- ─────────────────────────── INTRO CARD ───────────────────────────
G2L["intro"] = Instance.new("Frame", G2L["screen"])
G2L["intro"].Name = "intro"
G2L["intro"].AnchorPoint = Vector2.new(0.5, 0.5)
G2L["intro"].Position = UDim2.new(0.5, 0, 0.5, 0)
G2L["intro"].Size = UDim2.new(0, 260, 0, 160)
G2L["intro"].BackgroundColor3 = C.surface
G2L["intro"].BorderSizePixel = 0
G2L["intro"].Visible = false
corner(G2L["intro"], 16)
stroke(G2L["intro"], 1, C.border)
gradient(G2L["intro"], C.surface, C.bg, 135)

do
	local s = Instance.new("UIScale", G2L["intro"])
	s.Scale = 0
	G2L["intro_scale"] = s

	local ico = Instance.new("ImageLabel", G2L["intro"])
	ico.Name = "icon"
	ico.Image = "rbxassetid://96581271712752"
	ico.ScaleType = Enum.ScaleType.Fit
	ico.Size = UDim2.new(0, 56, 0, 56)
	ico.Position = UDim2.new(0.5, -28, 0, 24)
	ico.BackgroundTransparency = 1
	ico.BorderSizePixel = 0
	ico.ImageTransparency = 1
	G2L["intro_icon"] = ico

	local t = Instance.new("TextLabel", G2L["intro"])
	t.Name = "title"
	t.Text = "npc panel"
	t.TextSize = 17
	t.FontFace = makefont(Enum.FontWeight.Bold)
	t.TextColor3 = C.textPrimary
	t.BackgroundTransparency = 1
	t.BorderSizePixel = 0
	t.Size = UDim2.new(1, 0, 0, 26)
	t.Position = UDim2.new(0, 0, 0, 92)
	t.TextXAlignment = Enum.TextXAlignment.Center
	t.TextTransparency = 1
	G2L["intro_title"] = t

	local sub = Instance.new("TextLabel", G2L["intro"])
	sub.Text = "by @Im_Patrick"
	sub.TextSize = 12
	sub.FontFace = makefont(Enum.FontWeight.Regular)
	sub.TextColor3 = C.textMuted
	sub.BackgroundTransparency = 1
	sub.BorderSizePixel = 0
	sub.Size = UDim2.new(1, 0, 0, 18)
	sub.Position = UDim2.new(0, 0, 0, 118)
	sub.TextXAlignment = Enum.TextXAlignment.Center
	sub.TextTransparency = 1
	G2L["intro_sub"] = sub
end

-- ─────────────────────────── MAIN WINDOW ───────────────────────────
G2L["frame"] = Instance.new("Frame", G2L["screen"])
G2L["frame"].Name = "Frame"
G2L["frame"].AnchorPoint = Vector2.new(0.5, 0.5)
G2L["frame"].Position = UDim2.new(0.5, 0, 0.5, 0)
G2L["frame"].Size = UDim2.new(0, 580, 0, 420)
G2L["frame"].BackgroundColor3 = C.bg
G2L["frame"].BorderSizePixel = 0
corner(G2L["frame"], 14)
stroke(G2L["frame"], 1, C.border)
gradient(G2L["frame"], C.surface, C.bg, 160)
Instance.new("UIDragDetector", G2L["frame"])

do
	local s = Instance.new("UIScale", G2L["frame"])
	s.Scale = 0
	G2L["frame_scale"] = s

	-- drop shadow
	local shadow = Instance.new("ImageLabel", G2L["frame"])
	shadow.Name = "shadow"
	shadow.ZIndex = -2
	shadow.AnchorPoint = Vector2.new(0.5, 0.5)
	shadow.Position = UDim2.new(0.5, 0, 0.5, 12)
	shadow.Size = UDim2.new(1, 60, 1, 60)
	shadow.BackgroundTransparency = 1
	shadow.BorderSizePixel = 0
	shadow.Image = "rbxassetid://4654143143"
	shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	shadow.ImageTransparency = 0.55
	shadow.SliceScale = 0.04
	shadow.ScaleType = Enum.ScaleType.Slice
	shadow.SliceCenter = Rect.new(23, 23, 277, 277)
end

-- ─── TITLEBAR ───
G2L["bar"] = Instance.new("Frame", G2L["frame"])
G2L["bar"].Name = "bar"
G2L["bar"].Size = UDim2.new(1, -24, 0, 44)
G2L["bar"].Position = UDim2.new(0, 12, 0, 10)
G2L["bar"].BackgroundTransparency = 1
G2L["bar"].BorderSizePixel = 0

do
	-- accent pill left
	local pill = Instance.new("Frame", G2L["bar"])
	pill.Size = UDim2.new(0, 4, 0, 24)
	pill.Position = UDim2.new(0, 0, 0.5, -12)
	pill.BackgroundColor3 = C.accent
	pill.BorderSizePixel = 0
	corner(pill, 4)

	local icon = Instance.new("ImageLabel", G2L["bar"])
	icon.Name = "icon"
	icon.Image = "rbxassetid://96581271712752"
	icon.ScaleType = Enum.ScaleType.Fit
	icon.Size = UDim2.new(0, 24, 0, 24)
	icon.Position = UDim2.new(0, 12, 0.5, -12)
	icon.BackgroundTransparency = 1
	icon.BorderSizePixel = 0

	local title = label(G2L["bar"], "NPC Panel", 16, C.textPrimary, Enum.FontWeight.Bold)
	title.Name = "title"
	title.Size = UDim2.new(0, 200, 1, 0)
	title.Position = UDim2.new(0, 44, 0, 0)

	local credit = label(G2L["bar"], "@Im_Patrick", 11, C.textMuted)
	credit.Size = UDim2.new(0, 120, 1, 0)
	credit.Position = UDim2.new(0, 44, 0, 0)
	credit.TextYAlignment = Enum.TextYAlignment.Bottom

	-- NPC Status badge
	G2L["npc_badge"] = Instance.new("Frame", G2L["bar"])
	G2L["npc_badge"].Name = "npc_badge"
	G2L["npc_badge"].AnchorPoint = Vector2.new(0, 0.5)
	G2L["npc_badge"].Position = UDim2.new(0, 175, 0.5, 0)
	G2L["npc_badge"].Size = UDim2.new(0, 130, 0, 22)
	G2L["npc_badge"].BackgroundColor3 = C.surfaceHigh
	G2L["npc_badge"].BorderSizePixel = 0
	corner(G2L["npc_badge"], 11)
	stroke(G2L["npc_badge"], 1, C.border)

	G2L["npc_dot"] = Instance.new("Frame", G2L["npc_badge"])
	G2L["npc_dot"].Size = UDim2.new(0, 7, 0, 7)
	G2L["npc_dot"].Position = UDim2.new(0, 8, 0.5, -3)
	G2L["npc_dot"].BackgroundColor3 = C.textMuted
	G2L["npc_dot"].BorderSizePixel = 0
	corner(G2L["npc_dot"], 4)

	G2L["npc_label"] = label(G2L["npc_badge"], "No NPC Selected", 10, C.textMuted)
	G2L["npc_label"].Size = UDim2.new(1, -20, 1, 0)
	G2L["npc_label"].Position = UDim2.new(0, 20, 0, 0)
	G2L["npc_label"].TextXAlignment = Enum.TextXAlignment.Left

	-- Minimize button
	G2L["minimize"] = Instance.new("Frame", G2L["bar"])
	G2L["minimize"].Name = "minimize"
	G2L["minimize"].AnchorPoint = Vector2.new(1, 0.5)
	G2L["minimize"].Position = UDim2.new(1, 0, 0.5, 0)
	G2L["minimize"].Size = UDim2.new(0, 32, 0, 32)
	G2L["minimize"].BackgroundColor3 = C.surfaceHigh
	G2L["minimize"].BorderSizePixel = 0
	corner(G2L["minimize"], 8)
	stroke(G2L["minimize"], 1, C.border)

	local minLabel = label(G2L["minimize"], "─", 14, C.textMuted, Enum.FontWeight.Bold)
	minLabel.TextXAlignment = Enum.TextXAlignment.Center
	minLabel.TextYAlignment = Enum.TextYAlignment.Center

	G2L["minimize_btn"] = imagebutton(G2L["minimize"])
end

-- divider under bar
do
	local div = Instance.new("Frame", G2L["frame"])
	div.Size = UDim2.new(1, -24, 0, 1)
	div.Position = UDim2.new(0, 12, 0, 60)
	div.BackgroundColor3 = C.border
	div.BorderSizePixel = 0
	div.BackgroundTransparency = 0.5
end

-- ─── LEFT PANEL: DISABLE + NETWORK TOGGLES ───
G2L["left_panel"] = Instance.new("Frame", G2L["frame"])
G2L["left_panel"].Name = "left_panel"
G2L["left_panel"].Position = UDim2.new(0, 12, 0, 70)
G2L["left_panel"].Size = UDim2.new(0, 175, 1, -90)
G2L["left_panel"].BackgroundTransparency = 1
G2L["left_panel"].BorderSizePixel = 0

do
	local list = Instance.new("UIListLayout", G2L["left_panel"])
	list.Padding = UDim.new(0, 8)
	list.SortOrder = Enum.SortOrder.LayoutOrder

	-- Helper: create a small toggle card
	local function makeToggleCard(parent, name, title, desc, order)
		local card = Instance.new("Frame", parent)
		card.Name = name
		card.Size = UDim2.new(1, 0, 0, 80)
		card.BackgroundColor3 = C.surface
		card.BorderSizePixel = 0
		card.LayoutOrder = order or 1
		corner(card, 10)
		stroke(card, 1, C.border)

		local titleL = label(card, title, 12, C.textPrimary, Enum.FontWeight.SemiBold)
		titleL.Size = UDim2.new(1, -16, 0, 16)
		titleL.Position = UDim2.new(0, 10, 0, 10)

		local descL = label(card, desc, 10, C.textMuted)
		descL.Size = UDim2.new(1, -16, 0, 28)
		descL.Position = UDim2.new(0, 10, 0, 26)
		descL.TextYAlignment = Enum.TextYAlignment.Top

		-- Toggle switch track
		local track = Instance.new("Frame", card)
		track.Name = "togheader"
		track.Size = UDim2.new(0, 44, 0, 22)
		track.AnchorPoint = Vector2.new(1, 1)
		track.Position = UDim2.new(1, -10, 1, -10)
		track.BackgroundColor3 = C.red
		track.BorderSizePixel = 0
		corner(track, 11)

		local knob = Instance.new("Frame", track)
		knob.Name = "togglebutton"
		knob.Size = UDim2.new(0, 18, 0, 18)
		knob.Position = UDim2.new(0, 2, 0.5, -9)
		knob.BackgroundColor3 = C.white
		knob.BorderSizePixel = 0
		corner(knob, 9)

		-- invisible click overlay
		local click = imagebutton(card)
		click.Name = "toggleclick"
		G2L[name .. "_track"] = track
		G2L[name .. "_knob"] = knob

		return card, click
	end

	local disableCard, disableClick = makeToggleCard(
		G2L["left_panel"], "disable", "Click to Select NPC",
		"Click an NPC in the world to target it for controls.", 1
	)
	G2L["disable"] = disableCard
	G2L["disable_click"] = disableClick

	local networkCard, networkClick = makeToggleCard(
		G2L["left_panel"], "network", "Network Ownership",
		"Visualise which NPCs you own on the network.", 2
	)
	G2L["network"] = networkCard
	G2L["network_click"] = networkClick

	-- Info card: selected NPC name
	local infoCard = Instance.new("Frame", G2L["left_panel"])
	infoCard.Name = "info_card"
	infoCard.Size = UDim2.new(1, 0, 0, 56)
	infoCard.BackgroundColor3 = C.surface
	infoCard.BorderSizePixel = 0
	infoCard.LayoutOrder = 3
	corner(infoCard, 10)
	stroke(infoCard, 1, C.border)

	local infoTitle = label(infoCard, "Selected NPC", 10, C.textMuted)
	infoTitle.Size = UDim2.new(1, -16, 0, 16)
	infoTitle.Position = UDim2.new(0, 10, 0, 8)

	G2L["selected_name"] = label(infoCard, "─────────", 12, C.textAccent, Enum.FontWeight.SemiBold)
	G2L["selected_name"].Size = UDim2.new(1, -16, 0, 18)
	G2L["selected_name"].Position = UDim2.new(0, 10, 0, 26)
end

-- vertical separator
do
	local sep = Instance.new("Frame", G2L["frame"])
	sep.Size = UDim2.new(0, 1, 1, -90)
	sep.Position = UDim2.new(0, 195, 0, 70)
	sep.BackgroundColor3 = C.border
	sep.BorderSizePixel = 0
	sep.BackgroundTransparency = 0.5
end

-- ─── RIGHT SECTION HEADER ───
G2L["right_container"] = Instance.new("Frame", G2L["frame"])
G2L["right_container"].Name = "right_container"
G2L["right_container"].Position = UDim2.new(0, 204, 0, 68)
G2L["right_container"].Size = UDim2.new(1, -216, 1, -80)
G2L["right_container"].BackgroundTransparency = 1
G2L["right_container"].BorderSizePixel = 0

do
	-- Main tab label
	local mainLabel = label(G2L["right_container"], "Controls", 11, C.textMuted, Enum.FontWeight.SemiBold)
	mainLabel.Size = UDim2.new(0, 80, 0, 18)
	mainLabel.Position = UDim2.new(0, 0, 0, 0)
	mainLabel.TextXAlignment = Enum.TextXAlignment.Left

	-- ─── MAIN SCROLLING FRAME (buttons/toggles) ───
	G2L["main"] = Instance.new("ScrollingFrame", G2L["right_container"])
	G2L["main"].Name = "main"
	G2L["main"].Position = UDim2.new(0, 0, 0, 22)
	G2L["main"].Size = UDim2.new(0.55, -4, 1, -22)
	G2L["main"].BackgroundTransparency = 1
	G2L["main"].BorderSizePixel = 0
	G2L["main"].ScrollBarThickness = 2
	G2L["main"].ScrollBarImageColor3 = C.accent
	G2L["main"].AutomaticCanvasSize = Enum.AutomaticSize.Y
	G2L["main"].CanvasSize = UDim2.new(0, 0, 0, 0)
	G2L["main"].ScrollingDirection = Enum.ScrollingDirection.Y
	G2L["main"].ClipsDescendants = true

	local mainList = Instance.new("UIListLayout", G2L["main"])
	mainList.Padding = UDim.new(0, 6)
	mainList.SortOrder = Enum.SortOrder.LayoutOrder

	-- ─── EXTRA SCROLLING FRAME (aura toggles) ───
	local extraLabel = label(G2L["right_container"], "Aura", 11, C.textMuted, Enum.FontWeight.SemiBold)
	extraLabel.Size = UDim2.new(0, 60, 0, 18)
	extraLabel.Position = UDim2.new(0.55, 4, 0, 0)

	G2L["extra"] = Instance.new("ScrollingFrame", G2L["right_container"])
	G2L["extra"].Name = "extra"
	G2L["extra"].Position = UDim2.new(0.55, 4, 0, 22)
	G2L["extra"].Size = UDim2.new(0.45, -4, 1, -22)
	G2L["extra"].BackgroundTransparency = 1
	G2L["extra"].BorderSizePixel = 0
	G2L["extra"].ScrollBarThickness = 2
	G2L["extra"].ScrollBarImageColor3 = C.accent
	G2L["extra"].AutomaticCanvasSize = Enum.AutomaticSize.Y
	G2L["extra"].CanvasSize = UDim2.new(0, 0, 0, 0)
	G2L["extra"].ScrollingDirection = Enum.ScrollingDirection.Y
	G2L["extra"].ClipsDescendants = true

	local extraList = Instance.new("UIListLayout", G2L["extra"])
	extraList.Padding = UDim.new(0, 6)
	extraList.SortOrder = Enum.SortOrder.LayoutOrder
end

-- ─── TEMPLATE: MAIN BUTTON ───
do
	local btn = Instance.new("Frame")
	btn.Name = "button"
	btn.Size = UDim2.new(1, 0, 0, 62)
	btn.BackgroundColor3 = C.surface
	btn.BorderSizePixel = 0
	corner(btn, 9)
	local s = stroke(btn, 1, C.border, 0)
	G2L["btn_stroke_ref"] = s -- not used directly, just part of template

	local titleL = label(btn, "title", 12, C.textPrimary, Enum.FontWeight.SemiBold)
	titleL.Name = "title"
	titleL.Size = UDim2.new(1, -52, 0, 18)
	titleL.Position = UDim2.new(0, 12, 0, 10)

	local desL = label(btn, "description", 10, C.textMuted)
	desL.Name = "des"
	desL.Size = UDim2.new(1, -52, 0, 28)
	desL.Position = UDim2.new(0, 12, 0, 28)
	desL.TextYAlignment = Enum.TextYAlignment.Top

	-- right arrow icon area
	local arrow = Instance.new("Frame", btn)
	arrow.Name = "arrow"
	arrow.AnchorPoint = Vector2.new(1, 0.5)
	arrow.Position = UDim2.new(1, -10, 0.5, 0)
	arrow.Size = UDim2.new(0, 28, 0, 28)
	arrow.BackgroundColor3 = C.surfaceHigh
	arrow.BorderSizePixel = 0
	corner(arrow, 7)
	local al = label(arrow, "›", 18, C.textMuted, Enum.FontWeight.Bold)
	al.TextXAlignment = Enum.TextXAlignment.Center

	local click = imagebutton(btn)
	click.Name = "click"

	G2L["main_button_template"] = btn
end

-- ─── TEMPLATE: MAIN TOGGLE ───
do
	local tog = Instance.new("Frame")
	tog.Name = "toggle"
	tog.Size = UDim2.new(1, 0, 0, 62)
	tog.BackgroundColor3 = C.surface
	tog.BorderSizePixel = 0
	corner(tog, 9)
	stroke(tog, 1, C.border, 0)

	local titleL = label(tog, "title", 12, C.textPrimary, Enum.FontWeight.SemiBold)
	titleL.Name = "title"
	titleL.Size = UDim2.new(1, -58, 0, 18)
	titleL.Position = UDim2.new(0, 12, 0, 10)

	local desL = label(tog, "description", 10, C.textMuted)
	desL.Name = "des"
	desL.Size = UDim2.new(1, -58, 0, 28)
	desL.Position = UDim2.new(0, 12, 0, 28)
	desL.TextYAlignment = Enum.TextYAlignment.Top

	-- toggle track (pill)
	local track = Instance.new("Frame", tog)
	track.Name = "toggle"
	track.AnchorPoint = Vector2.new(1, 0.5)
	track.Position = UDim2.new(1, -10, 0.5, 0)
	track.Size = UDim2.new(0, 42, 0, 22)
	track.BackgroundColor3 = C.red
	track.BorderSizePixel = 0
	corner(track, 11)

	local knob = Instance.new("Frame", track)
	knob.Name = "knob"
	knob.Size = UDim2.new(0, 18, 0, 18)
	knob.Position = UDim2.new(0, 2, 0.5, -9)
	knob.BackgroundColor3 = C.white
	knob.BorderSizePixel = 0
	corner(knob, 9)

	local click = imagebutton(tog)
	click.Name = "click"

	G2L["main_toggle_template"] = tog
end

-- ─── TEMPLATE: EXTRA TOGGLE (aura cards) ───
do
	local etog = Instance.new("Frame")
	etog.Name = "extratoggle"
	etog.Size = UDim2.new(1, 0, 0, 72)
	etog.BackgroundColor3 = C.surface
	etog.BorderSizePixel = 0
	corner(etog, 9)
	stroke(etog, 1, C.border, 0)

	local titleL = label(etog, "title", 11, C.textPrimary, Enum.FontWeight.SemiBold)
	titleL.Name = "title"
	titleL.Size = UDim2.new(1, -16, 0, 16)
	titleL.Position = UDim2.new(0, 10, 0, 10)
	titleL.TextXAlignment = Enum.TextXAlignment.Center

	-- status circle
	local dot = Instance.new("Frame", etog)
	dot.Name = "dot"
	dot.AnchorPoint = Vector2.new(0.5, 0)
	dot.Position = UDim2.new(0.5, 0, 0, 30)
	dot.Size = UDim2.new(0, 28, 0, 28)
	dot.BackgroundColor3 = C.surfaceHigh
	dot.BorderSizePixel = 0
	corner(dot, 14)
	stroke(dot, 1.5, C.border)

	local dotInner = Instance.new("Frame", dot)
	dotInner.Name = "inner"
	dotInner.AnchorPoint = Vector2.new(0.5, 0.5)
	dotInner.Position = UDim2.new(0.5, 0, 0.5, 0)
	dotInner.Size = UDim2.new(0, 12, 0, 12)
	dotInner.BackgroundColor3 = C.textMuted
	dotInner.BorderSizePixel = 0
	corner(dotInner, 6)

	local click = imagebutton(etog)
	click.Name = "click"

	G2L["extra_toggle_template"] = etog
end

-- ─── MINIMIZED ICON ───
G2L["icon"] = Instance.new("Frame", G2L["screen"])
G2L["icon"].Name = "icon"
G2L["icon"].AnchorPoint = Vector2.new(0.5, 0.5)
G2L["icon"].Position = UDim2.new(0.08, 0, 0.15, 0)
G2L["icon"].Size = UDim2.new(0, 46, 0, 46)
G2L["icon"].BackgroundColor3 = C.surface
G2L["icon"].BorderSizePixel = 0
G2L["icon"].Visible = false
corner(G2L["icon"], 12)
stroke(G2L["icon"], 1, C.border)

do
	local s = Instance.new("UIScale", G2L["icon"])
	s.Scale = 0
	G2L["icon_scale"] = s

	local ico = Instance.new("ImageButton", G2L["icon"])
	ico.Name = "ImageButton"
	ico.Image = "rbxassetid://96581271712752"
	ico.ScaleType = Enum.ScaleType.Fit
	ico.AnchorPoint = Vector2.new(0.5, 0.5)
	ico.Position = UDim2.new(0.5, 0, 0.5, 0)
	ico.Size = UDim2.new(0.65, 0, 0.65, 0)
	ico.BackgroundTransparency = 1
	ico.BorderSizePixel = 0
	G2L["icon_button"] = ico

	Instance.new("UIDragDetector", G2L["icon"])
end

-- ═══════════════════════════════════════════════════════
-- BEHAVIOUR LOGIC
-- ═══════════════════════════════════════════════════════

local function partowner(part)
	return part.ReceiveAge == 0
end

-- exported so main.Luau can use it
function G2L.partowner(part)
	return part.ReceiveAge == 0
end

-- ─── NPC BADGE UPDATER ───
function G2L.setSelectedNPC(npc)
	if npc then
		tweenservice:Create(G2L["npc_dot"], TweenInfo.new(0.2), {BackgroundColor3 = C.green}):Play()
		G2L["npc_label"].TextColor3 = C.green
		G2L["npc_label"].Text = "NPC Selected"
		G2L["selected_name"].Text = npc.Name
		G2L["selected_name"].TextColor3 = C.textAccent
	else
		tweenservice:Create(G2L["npc_dot"], TweenInfo.new(0.2), {BackgroundColor3 = C.textMuted}):Play()
		G2L["npc_label"].TextColor3 = C.textMuted
		G2L["npc_label"].Text = "No NPC Selected"
		G2L["selected_name"].Text = "─────────"
		G2L["selected_name"].TextColor3 = C.textMuted
	end
end

-- ─── DISABLE (click-to-select) TOGGLE ───
clicknpc = true -- global, read by main.Luau
do
	local track = G2L["disable_track"]
	local knob  = G2L["disable_knob"]
	local onPos  = UDim2.new(1, -20, 0.5, -9)
	local offPos = UDim2.new(0, 2, 0.5, -9)

	-- start in ON state (clicknpc = true)
	track.BackgroundColor3 = C.green
	knob.Position = onPos

	G2L["disable_click"].MouseButton1Click:Connect(function()
		clicknpc = not clicknpc
		tweenservice:Create(track, fast, {BackgroundColor3 = clicknpc and C.green or C.red}):Play()
		tweenservice:Create(knob, fast, {Position = clicknpc and onPos or offPos}):Play()
	end)
end

-- ─── NETWORK VISIBILITY TOGGLE ───
networkvis = false -- global
do
	local track = G2L["network_track"]
	local knob  = G2L["network_knob"]
	local onPos  = UDim2.new(1, -20, 0.5, -9)
	local offPos = UDim2.new(0, 2, 0.5, -9)

	G2L["network_click"].MouseButton1Click:Connect(function()
		networkvis = not networkvis
		pcall(function()
			settings().Physics.AreOwnersShown = networkvis
		end)
		tweenservice:Create(track, fast, {BackgroundColor3 = networkvis and C.green or C.red}):Play()
		tweenservice:Create(knob, fast, {Position = networkvis and onPos or offPos}):Play()
	end)
end

-- ─── MINIMIZE ───
local minimized = false
local function toggleMinimize()
	minimized = not minimized
	if minimized then
		G2L["icon"].Visible = true
		G2L["icon_scale"].Scale = 0
		tweenservice:Create(G2L["frame_scale"], fast, {Scale = 0}):Play()
		tweenservice:Create(G2L["icon_scale"], fast, {Scale = 1}):Play()
		task.wait(0.4)
		G2L["frame"].Visible = false
	else
		G2L["frame"].Visible = true
		tweenservice:Create(G2L["frame_scale"], fast, {Scale = 1}):Play()
		tweenservice:Create(G2L["icon_scale"], fast, {Scale = 0}):Play()
		task.wait(0.4)
		G2L["icon"].Visible = false
	end
end

G2L["minimize_btn"].MouseButton1Click:Connect(toggleMinimize)
G2L["icon_button"].MouseButton1Click:Connect(toggleMinimize)

-- ─── INTRO SEQUENCE ───
local function playIntro()
	local lighting = game:GetService("Lighting")

	G2L["dark"].Visible = true
	G2L["dark"].BackgroundTransparency = 1
	G2L["intro_icon"].ImageTransparency = 1
	G2L["intro_title"].TextTransparency = 1
	G2L["intro_sub"].TextTransparency = 1
	G2L["intro_scale"].Scale = 0
	G2L["frame_scale"].Scale = 0
	G2L["intro"].Visible = true

	local blur = Instance.new("BlurEffect")
	blur.Name = "intro_blur"
	blur.Size = 0
	blur.Parent = lighting

	tweenservice:Create(blur, slow, {Size = 18}):Play()
	tweenservice:Create(G2L["dark"], slow, {BackgroundTransparency = 0.6}):Play()

	task.wait(0.15)
	tweenservice:Create(G2L["intro_scale"], medium, {Scale = 1}):Play()
	task.wait(0.25)
	tweenservice:Create(G2L["intro_icon"], medium, {ImageTransparency = 0}):Play()
	task.wait(0.35)
	tweenservice:Create(G2L["intro_title"], medium, {TextTransparency = 0}):Play()
	task.wait(0.2)
	tweenservice:Create(G2L["intro_sub"], medium, {TextTransparency = 0}):Play()

	task.wait(3.5)

	tweenservice:Create(blur, slow, {Size = 0}):Play()
	tweenservice:Create(G2L["intro_scale"], medium, {Scale = 0}):Play()
	task.wait(0.3)
	tweenservice:Create(G2L["dark"], slow, {BackgroundTransparency = 1}):Play()
	task.wait(0.5)
	G2L["intro"].Visible = false
	G2L["dark"].Visible = false
	tweenservice:Create(G2L["frame_scale"], medium, {Scale = 1}):Play()
	blur:Destroy()
end

-- ─── ELEMENT FACTORY ───
local function create()
	local api = {}

	-- Main Button
	function api:mainbutton(title, description, func)
		local btn = G2L["main_button_template"]:Clone()
		btn.Parent = G2L["main"]
		btn.title.Text = title or "button"
		btn.des.Text = description or ""

		btn.click.MouseButton1Click:Connect(function()
			if func then
				tweenservice:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = C.accentDim}):Play()
				task.wait(0.12)
				tweenservice:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = C.surface}):Play()
				task.spawn(function()
					local ok, err = pcall(func)
					if not ok then warn(err) end
				end)
			end
		end)

		-- hover
		btn.click.MouseEnter:Connect(function()
			tweenservice:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = C.surfaceHigh}):Play()
		end)
		btn.click.MouseLeave:Connect(function()
			tweenservice:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = C.surface}):Play()
		end)

		return btn
	end

	-- Main Toggle
	function api:maintoggle(title, description, func)
		local tog = G2L["main_toggle_template"]:Clone()
		tog.Parent = G2L["main"]
		tog.title.Text = title or "toggle"
		tog.des.Text = description or ""

		local track = tog.toggle
		local knob  = tog.toggle.knob
		local onPos  = UDim2.new(1, -20, 0.5, -9)
		local offPos = UDim2.new(0, 2, 0.5, -9)
		local state  = false
		local handle = {}

		tog.click.MouseButton1Click:Connect(function()
			state = not state
			tweenservice:Create(track, fast, {BackgroundColor3 = state and C.green or C.red}):Play()
			tweenservice:Create(knob, fast, {Position = state and onPos or offPos}):Play()

			-- subtle flash
			tweenservice:Create(tog, TweenInfo.new(0.08), {BackgroundColor3 = C.surfaceHigh}):Play()
			task.wait(0.1)
			tweenservice:Create(tog, TweenInfo.new(0.2), {BackgroundColor3 = C.surface}):Play()

			if func then
				task.spawn(function()
					local ok, err = pcall(func, state)
					if not ok then warn(err) end
				end)
			end
		end)

		tog.click.MouseEnter:Connect(function()
			tweenservice:Create(tog, TweenInfo.new(0.15), {BackgroundColor3 = C.surfaceHigh}):Play()
		end)
		tog.click.MouseLeave:Connect(function()
			tweenservice:Create(tog, TweenInfo.new(0.15), {BackgroundColor3 = C.surface}):Play()
		end)

		function handle:swich(bool)
			state = bool
			tweenservice:Create(track, fast, {BackgroundColor3 = state and C.green or C.red}):Play()
			tweenservice:Create(knob, fast, {Position = state and onPos or offPos}):Play()
		end

		return handle
	end

	-- Extra Toggle (aura)
	function api:extratoggle(title, func)
		local etog = G2L["extra_toggle_template"]:Clone()
		etog.Parent = G2L["extra"]
		etog.title.Text = title or "aura"

		local dot   = etog.dot
		local inner = dot.inner
		local state = false

		etog.click.MouseButton1Click:Connect(function()
			state = not state
			tweenservice:Create(dot, fast, {BackgroundColor3 = state and C.green or C.surfaceHigh}):Play()
			tweenservice:Create(inner, fast, {BackgroundColor3 = state and C.white or C.textMuted}):Play()

			tweenservice:Create(etog, TweenInfo.new(0.08), {BackgroundColor3 = C.surfaceHigh}):Play()
			task.wait(0.1)
			tweenservice:Create(etog, TweenInfo.new(0.2), {BackgroundColor3 = C.surface}):Play()

			if func then
				task.spawn(function()
					local ok, err = pcall(func, state)
					if not ok then warn(err) end
				end)
			end
		end)

		etog.click.MouseEnter:Connect(function()
			tweenservice:Create(etog, TweenInfo.new(0.15), {BackgroundColor3 = C.surfaceHigh}):Play()
		end)
		etog.click.MouseLeave:Connect(function()
			tweenservice:Create(etog, TweenInfo.new(0.15), {BackgroundColor3 = C.surface}):Play()
		end)
	end

	return api
end

playIntro()

return {create = create, G2L = G2L["screen"], partowner = G2L.partowner, setSelectedNPC = G2L.setSelectedNPC}
