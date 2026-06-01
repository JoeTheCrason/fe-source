--[[
	NPC Panel - Modern UI Module  v3
	UI refinements: flat bottom bar corners, fixed toggle alignment in templates,
	                auto-select card slot, spectate toggle template exposed,
	                all previous fixes retained.
--]]

local G2L = {}
local core

if game:FindFirstChildOfClass("CoreGui") then
	if gethui then core = gethui()
	else core = game:GetService("CoreGui") end
else
	core = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
end

local tweenservice = game:GetService("TweenService")
local uis          = game:GetService("UserInputService")

local fast   = TweenInfo.new(0.32, Enum.EasingStyle.Exponential)
local medium = TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local slow   = TweenInfo.new(0.70, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

-- ─────────────────────────── COLOURS ───────────────────────────
local C = {
	bg          = Color3.fromRGB(18,  18,  26),
	surface     = Color3.fromRGB(26,  26,  36),
	surfaceHigh = Color3.fromRGB(36,  36,  50),
	border      = Color3.fromRGB(55,  55,  78),
	accent      = Color3.fromRGB(110, 90,  255),
	accentDim   = Color3.fromRGB(70,  55,  180),
	green       = Color3.fromRGB(40,  210, 110),
	red         = Color3.fromRGB(215, 55,  55),
	textPrimary = Color3.fromRGB(238, 238, 255),
	textMuted   = Color3.fromRGB(135, 135, 160),
	textAccent  = Color3.fromRGB(170, 155, 255),
	white       = Color3.fromRGB(255, 255, 255),
}

-- ─────────────────────────── HELPERS ───────────────────────────
local function makefont(weight)
	return Font.new("rbxasset://fonts/families/GothamSSm.json",
		weight or Enum.FontWeight.Regular, Enum.FontStyle.Normal)
end

local function corner(parent, radius)
	local c = Instance.new("UICorner", parent)
	c.CornerRadius = UDim.new(0, radius or 8)
	return c
end

local function stroke(parent, thickness, color, transparency)
	local s = Instance.new("UIStroke", parent)
	s.Thickness       = thickness or 1
	s.Color           = color or C.border
	s.Transparency    = transparency or 0
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	return s
end

local function label(parent, text, textsize, color, weight)
	local l = Instance.new("TextLabel", parent)
	l.Text                = text or ""
	l.TextSize            = textsize or 13
	l.TextColor3          = color or C.textPrimary
	l.FontFace            = makefont(weight or Enum.FontWeight.Regular)
	l.BackgroundTransparency = 1
	l.BorderSizePixel     = 0
	l.TextXAlignment      = Enum.TextXAlignment.Left
	l.TextYAlignment      = Enum.TextYAlignment.Center
	l.RichText            = true
	l.TextWrapped         = true
	l.Size                = UDim2.new(1, 0, 1, 0)
	return l
end

local function imagebutton(parent)
	local b = Instance.new("ImageButton", parent)
	b.Size                = UDim2.new(1, 0, 1, 0)
	b.Position            = UDim2.new(0, 0, 0, 0)
	b.BackgroundTransparency = 1
	b.BorderSizePixel     = 0
	b.Image               = ""
	b.ZIndex              = 10
	return b
end

-- ─────────────────────────── SCREEN GUI ───────────────────────────
G2L["screen"] = Instance.new("ScreenGui", core)
G2L["screen"].IgnoreGuiInset       = true
G2L["screen"].DisplayOrder         = 5
G2L["screen"].ScreenInsets         = Enum.ScreenInsets.None
G2L["screen"].ClipToDeviceSafeArea = false
G2L["screen"].ResetOnSpawn         = false

-- ─────────────────────────── DARK OVERLAY ───────────────────────────
G2L["dark"] = Instance.new("Frame", G2L["screen"])
G2L["dark"].Name                   = "dark"
G2L["dark"].Size                   = UDim2.new(1, 0, 1, 0)
G2L["dark"].BackgroundColor3       = Color3.fromRGB(0, 0, 0)
G2L["dark"].BackgroundTransparency = 1
G2L["dark"].BorderSizePixel        = 0
G2L["dark"].Visible                = false
G2L["dark"].ZIndex                 = -10

-- ─────────────────────────── INTRO CARD ───────────────────────────
G2L["intro"] = Instance.new("Frame", G2L["screen"])
G2L["intro"].Name             = "intro"
G2L["intro"].AnchorPoint      = Vector2.new(0.5, 0.5)
G2L["intro"].Position         = UDim2.new(0.5, 0, 0.5, 0)
G2L["intro"].Size             = UDim2.new(0, 260, 0, 160)
G2L["intro"].BackgroundColor3 = C.surface
G2L["intro"].BorderSizePixel  = 0
G2L["intro"].Visible          = false
corner(G2L["intro"], 16)
stroke(G2L["intro"], 1, C.border)

do
	local s = Instance.new("UIScale", G2L["intro"])
	s.Scale = 0
	G2L["intro_scale"] = s

	local ico = Instance.new("ImageLabel", G2L["intro"])
	ico.Name                  = "icon"
	ico.Image                 = "rbxassetid://124350377833889"
	ico.ScaleType             = Enum.ScaleType.Fit
	ico.Size                  = UDim2.new(0, 56, 0, 56)
	ico.Position              = UDim2.new(0.5, -28, 0, 20)
	ico.BackgroundTransparency = 1
	ico.BorderSizePixel       = 0
	ico.ImageTransparency     = 1
	G2L["intro_icon"] = ico

	local t = Instance.new("TextLabel", G2L["intro"])
	t.Text                  = "NPC PANEL"
	t.TextSize              = 17
	t.FontFace              = makefont(Enum.FontWeight.Bold)
	t.TextColor3            = C.textPrimary
	t.BackgroundTransparency = 1
	t.BorderSizePixel       = 0
	t.Size                  = UDim2.new(1, 0, 0, 26)
	t.Position              = UDim2.new(0, 0, 0, 86)
	t.TextXAlignment        = Enum.TextXAlignment.Center
	t.TextTransparency      = 1
	G2L["intro_title"] = t

	local sub = Instance.new("TextLabel", G2L["intro"])
	sub.Text                  = "by @nullgpt20"
	sub.TextSize              = 12
	sub.FontFace              = makefont(Enum.FontWeight.Regular)
	sub.TextColor3            = C.textMuted
	sub.BackgroundTransparency = 1
	sub.BorderSizePixel       = 0
	sub.Size                  = UDim2.new(1, 0, 0, 18)
	sub.Position              = UDim2.new(0, 0, 0, 114)
	sub.TextXAlignment        = Enum.TextXAlignment.Center
	sub.TextTransparency      = 1
	G2L["intro_sub"] = sub
end

-- ─────────────────────────── MAIN WINDOW ───────────────────────────
G2L["frame"] = Instance.new("Frame", G2L["screen"])
G2L["frame"].Name             = "Frame"
G2L["frame"].AnchorPoint      = Vector2.new(0.5, 0.5)
G2L["frame"].Position         = UDim2.new(0.5, 0, 0.5, 0)
G2L["frame"].Size             = UDim2.new(0, 580, 0, 420)
G2L["frame"].BackgroundColor3 = C.bg
G2L["frame"].BorderSizePixel  = 0
corner(G2L["frame"], 14)
stroke(G2L["frame"], 1, C.border)
Instance.new("UIDragDetector", G2L["frame"])

do
	local s = Instance.new("UIScale", G2L["frame"])
	s.Scale = 0
	G2L["frame_scale"] = s
end

-- ─────────────────────────── TITLEBAR ───────────────────────────
-- FIX #1: The bar itself has radius 14 to match the window, but we cover its
-- bottom portion with a same-coloured rectangle so ONLY the top-left and
-- top-right corners are visually rounded. The bottom edge is flush/flat.
-- Technique: bar height 54, we stack a flat-bottomed rectangle (no UICorner)
-- that is 14px tall at the very bottom, same colour, hiding the bottom curves.

G2L["bar"] = Instance.new("Frame", G2L["frame"])
G2L["bar"].Name             = "bar"
G2L["bar"].Size             = UDim2.new(1, 0, 0, 54)
G2L["bar"].Position         = UDim2.new(0, 0, 0, 0)
G2L["bar"].BackgroundColor3 = C.surfaceHigh
G2L["bar"].BorderSizePixel  = 0
-- Full radius on the frame (all 4 corners start rounded)
do
	local bc = Instance.new("UICorner", G2L["bar"])
	bc.CornerRadius = UDim.new(0, 14)
end
-- Cover panel: sits at the very bottom of the bar, same colour, no radius.
-- This visually squares off the bottom-left and bottom-right corners.
do
	local cover = Instance.new("Frame", G2L["bar"])
	cover.Name             = "bottomcover"
	cover.AnchorPoint      = Vector2.new(0, 1)
	cover.Position         = UDim2.new(0, 0, 1, 0)
	cover.Size             = UDim2.new(1, 0, 0, 14)   -- 14px = corner radius
	cover.BackgroundColor3 = C.surfaceHigh
	cover.BorderSizePixel  = 0
	cover.ZIndex           = 2
	-- no UICorner → square bottom corners
end
-- Thin divider line at the bottom of bar
do
	local bdiv = Instance.new("Frame", G2L["bar"])
	bdiv.AnchorPoint            = Vector2.new(0, 1)
	bdiv.Position               = UDim2.new(0, 0, 1, 0)
	bdiv.Size                   = UDim2.new(1, 0, 0, 1)
	bdiv.BackgroundColor3       = C.border
	bdiv.BackgroundTransparency = 0.5
	bdiv.BorderSizePixel        = 0
	bdiv.ZIndex                 = 6
end

do
	-- Accent pill
	local pill = Instance.new("Frame", G2L["bar"])
	pill.Size             = UDim2.new(0, 4, 0, 22)
	pill.Position         = UDim2.new(0, 14, 0.5, -11)
	pill.BackgroundColor3 = C.accent
	pill.BorderSizePixel  = 0
	pill.ZIndex           = 3
	corner(pill, 3)

	-- Icon
	local icon = Instance.new("ImageLabel", G2L["bar"])
	icon.Name                  = "icon"
	icon.Image                 = "rbxassetid://124350377833889"
	icon.ScaleType             = Enum.ScaleType.Fit
	icon.Size                  = UDim2.new(0, 34, 0, 34)
	icon.Position              = UDim2.new(0, 19, 0.5, -17)
	icon.BackgroundTransparency = 1
	icon.BorderSizePixel       = 0
	icon.ZIndex                = 3

	-- Title
	local title = label(G2L["bar"], "NPC Panel", 15, C.textPrimary, Enum.FontWeight.Bold)
	title.Size     = UDim2.new(0, 180, 0, 20)
	title.Position = UDim2.new(0, 56, 0, 8)
	title.ZIndex   = 3

	local credit = label(G2L["bar"], "@nullgpt20", 10, C.textMuted)
	credit.Size     = UDim2.new(0, 120, 0, 14)
	credit.Position = UDim2.new(0, 56, 0, 30)
	credit.ZIndex   = 3

	-- Minimize button (right edge)
	G2L["minimize"] = Instance.new("Frame", G2L["bar"])
	G2L["minimize"].Name             = "minimize"
	G2L["minimize"].AnchorPoint      = Vector2.new(1, 0.5)
	G2L["minimize"].Position         = UDim2.new(1, -12, 0.5, 0)
	G2L["minimize"].Size             = UDim2.new(0, 30, 0, 30)
	G2L["minimize"].BackgroundColor3 = C.surface
	G2L["minimize"].BorderSizePixel  = 0
	G2L["minimize"].ZIndex           = 3
	corner(G2L["minimize"], 8)
	stroke(G2L["minimize"], 1, C.border)

	local minL = label(G2L["minimize"], "─", 13, C.textMuted, Enum.FontWeight.Bold)
	minL.TextXAlignment = Enum.TextXAlignment.Center
	minL.TextYAlignment = Enum.TextYAlignment.Center
	minL.ZIndex         = 3

	G2L["minimize_btn"] = imagebutton(G2L["minimize"])
	G2L["minimize_btn"].ZIndex = 10

	-- NPC status badge: anchored to right, sitting left of the minimize button
	-- Badge right edge = minimize right edge (1, -12) minus btn width (30) minus gap (8) = offset -50
	G2L["npc_badge"] = Instance.new("Frame", G2L["bar"])
	G2L["npc_badge"].Name             = "npc_badge"
	G2L["npc_badge"].AnchorPoint      = Vector2.new(1, 0.5)
	G2L["npc_badge"].Position         = UDim2.new(1, -50, 0.5, 0)
	G2L["npc_badge"].Size             = UDim2.new(0, 130, 0, 26)
	G2L["npc_badge"].BackgroundColor3 = C.surface
	G2L["npc_badge"].BorderSizePixel  = 0
	G2L["npc_badge"].ZIndex           = 3
	corner(G2L["npc_badge"], 13)
	stroke(G2L["npc_badge"], 1, C.border)

	G2L["npc_dot"] = Instance.new("Frame", G2L["npc_badge"])
	G2L["npc_dot"].Size             = UDim2.new(0, 7, 0, 7)
	G2L["npc_dot"].Position         = UDim2.new(0, 9, 0.5, -3)
	G2L["npc_dot"].BackgroundColor3 = C.textMuted
	G2L["npc_dot"].BorderSizePixel  = 0
	G2L["npc_dot"].ZIndex           = 3
	corner(G2L["npc_dot"], 4)

	G2L["npc_label"] = label(G2L["npc_badge"], "No NPC Selected", 10, C.textMuted)
	G2L["npc_label"].Size     = UDim2.new(1, -22, 1, 0)
	G2L["npc_label"].Position = UDim2.new(0, 21, 0, 0)
	G2L["npc_label"].ZIndex   = 3
end

-- ─────────────────────────── BODY LAYOUT ───────────────────────────
-- Body starts below bar (y=54). Inner padding: 8px sides, 8px top gap.
local BODY_Y = 62   -- bar(54) + 8px gap

-- LEFT PANEL  x=12, y=62, width=178
G2L["left_panel"] = Instance.new("Frame", G2L["frame"])
G2L["left_panel"].Name                   = "left_panel"
G2L["left_panel"].Position               = UDim2.new(0, 12, 0, BODY_Y)
G2L["left_panel"].Size                   = UDim2.new(0, 178, 1, -(BODY_Y + 10))
G2L["left_panel"].BackgroundTransparency = 1
G2L["left_panel"].BorderSizePixel        = 0

do
	local list = Instance.new("UIListLayout", G2L["left_panel"])
	list.Padding       = UDim.new(0, 8)
	list.SortOrder     = Enum.SortOrder.LayoutOrder
	list.FillDirection = Enum.FillDirection.Vertical

	-- ── SHARED TOGGLE CARD BUILDER ──
	-- Used by: Click to Select NPC (order 1), Auto-Select Nearest NPC (order 2),
	--          Network Ownership (order 3).
	local function makeToggleCard(parent, name, titleTxt, descTxt, order)
		local card = Instance.new("Frame", parent)
		card.Name             = name
		card.Size             = UDim2.new(1, 0, 0, 88)
		card.BackgroundColor3 = C.surface
		card.BorderSizePixel  = 0
		card.LayoutOrder      = order
		corner(card, 10)
		stroke(card, 1, C.border)

		local tL = label(card, titleTxt, 12, C.textPrimary, Enum.FontWeight.SemiBold)
		tL.Size     = UDim2.new(1, -16, 0, 16)
		tL.Position = UDim2.new(0, 10, 0, 10)

		local dL = label(card, descTxt, 10, C.textMuted)
		dL.Size           = UDim2.new(1, -16, 0, 32)
		dL.Position       = UDim2.new(0, 10, 0, 26)
		dL.TextYAlignment = Enum.TextYAlignment.Top

		-- pill track — anchored bottom-right of card
		local track = Instance.new("Frame", card)
		track.Name             = "togheader"
		track.Size             = UDim2.new(0, 44, 0, 22)
		track.AnchorPoint      = Vector2.new(1, 1)
		track.Position         = UDim2.new(1, -10, 1, -10)
		track.BackgroundColor3 = C.red
		track.BorderSizePixel  = 0
		corner(track, 11)

		local knob = Instance.new("Frame", track)
		knob.Name             = "togglebutton"
		knob.Size             = UDim2.new(0, 18, 0, 18)
		knob.Position         = UDim2.new(0, 2, 0.5, -9)
		knob.BackgroundColor3 = C.white
		knob.BorderSizePixel  = 0
		corner(knob, 9)

		local click = imagebutton(card)
		click.Name = "toggleclick"

		G2L[name .. "_track"] = track
		G2L[name .. "_knob"]  = knob
		return card, click
	end

	-- Card 1: Click to Select NPC
	local dCard, dClick = makeToggleCard(G2L["left_panel"], "disable",
		"Click to Select NPC", "Click an NPC in the world to target it for controls.", 1)
	G2L["disable"]       = dCard
	G2L["disable_click"] = dClick

	-- Card 2 (NEW): Auto-Select Nearest NPC — between disable and network
	local aCard, aClick = makeToggleCard(G2L["left_panel"], "autoselect",
		"Auto-Select Nearest NPC", "Automatically targets the closest owned NPC to your character.", 2)
	G2L["autoselect"]       = aCard
	G2L["autoselect_click"] = aClick

	-- Card 3: Network Ownership
	local nCard, nClick = makeToggleCard(G2L["left_panel"], "network",
		"Network Ownership", "Visualise which NPCs you own on the network.", 3)
	G2L["network"]       = nCard
	G2L["network_click"] = nClick

	-- Selected NPC info card
	local info = Instance.new("Frame", G2L["left_panel"])
	info.Name             = "info_card"
	info.Size             = UDim2.new(1, 0, 0, 52)
	info.BackgroundColor3 = C.surface
	info.BorderSizePixel  = 0
	info.LayoutOrder      = 4
	corner(info, 10)
	stroke(info, 1, C.border)

	local iL = label(info, "Selected NPC", 10, C.textMuted)
	iL.Size     = UDim2.new(1, -16, 0, 14)
	iL.Position = UDim2.new(0, 10, 0, 8)

	G2L["selected_name"] = label(info, "─────────", 12, C.textAccent, Enum.FontWeight.SemiBold)
	G2L["selected_name"].Size     = UDim2.new(1, -16, 0, 18)
	G2L["selected_name"].Position = UDim2.new(0, 10, 0, 26)
end

-- VERTICAL SEPARATOR
do
	local sep = Instance.new("Frame", G2L["frame"])
	sep.Size                   = UDim2.new(0, 1, 1, -(BODY_Y + 10))
	sep.Position               = UDim2.new(0, 198, 0, BODY_Y)
	sep.BackgroundColor3       = C.border
	sep.BackgroundTransparency = 0.5
	sep.BorderSizePixel        = 0
end

-- ─── RIGHT CONTAINER ───────────────────────────────────────────
G2L["right_container"] = Instance.new("Frame", G2L["frame"])
G2L["right_container"].Name                   = "right_container"
G2L["right_container"].Position               = UDim2.new(0, 206, 0, BODY_Y)
G2L["right_container"].Size                   = UDim2.new(1, -218, 1, -(BODY_Y + 10))
G2L["right_container"].BackgroundTransparency = 1
G2L["right_container"].BorderSizePixel        = 0

do
	-- Controls column label
	local cLabel = label(G2L["right_container"], "Controls", 10, C.textMuted, Enum.FontWeight.SemiBold)
	cLabel.Size     = UDim2.new(0.56, -6, 0, 16)
	cLabel.Position = UDim2.new(0, 0, 0, 0)

	G2L["main"] = Instance.new("ScrollingFrame", G2L["right_container"])
	G2L["main"].Name                   = "main"
	G2L["main"].Position               = UDim2.new(0, 0, 0, 20)
	G2L["main"].Size                   = UDim2.new(0.56, -6, 1, -20)
	G2L["main"].BackgroundTransparency = 1
	G2L["main"].BorderSizePixel        = 0
	G2L["main"].ScrollBarThickness     = 0
	G2L["main"].AutomaticCanvasSize    = Enum.AutomaticSize.Y
	G2L["main"].CanvasSize             = UDim2.new(0, 0, 0, 0)
	G2L["main"].ScrollingDirection     = Enum.ScrollingDirection.Y
	G2L["main"].ClipsDescendants       = true

	local mList = Instance.new("UIListLayout", G2L["main"])
	mList.Padding   = UDim.new(0, 6)
	mList.SortOrder = Enum.SortOrder.LayoutOrder

	local mPad = Instance.new("UIPadding", G2L["main"])
	mPad.PaddingLeft   = UDim.new(0, 2)
	mPad.PaddingRight  = UDim.new(0, 2)
	mPad.PaddingTop    = UDim.new(0, 2)
	mPad.PaddingBottom = UDim.new(0, 4)

	-- Aura column label
	local aLabel = label(G2L["right_container"], "Aura", 10, C.textMuted, Enum.FontWeight.SemiBold)
	aLabel.Size     = UDim2.new(0.44, -2, 0, 16)
	aLabel.Position = UDim2.new(0.56, 6, 0, 0)

	G2L["extra"] = Instance.new("ScrollingFrame", G2L["right_container"])
	G2L["extra"].Name                   = "extra"
	G2L["extra"].Position               = UDim2.new(0.56, 6, 0, 20)
	G2L["extra"].Size                   = UDim2.new(0.44, -6, 1, -20)
	G2L["extra"].BackgroundTransparency = 1
	G2L["extra"].BorderSizePixel        = 0
	G2L["extra"].ScrollBarThickness     = 0
	G2L["extra"].AutomaticCanvasSize    = Enum.AutomaticSize.Y
	G2L["extra"].CanvasSize             = UDim2.new(0, 0, 0, 0)
	G2L["extra"].ScrollingDirection     = Enum.ScrollingDirection.Y
	G2L["extra"].ClipsDescendants       = true

	local eList = Instance.new("UIListLayout", G2L["extra"])
	eList.Padding   = UDim.new(0, 6)
	eList.SortOrder = Enum.SortOrder.LayoutOrder

	local ePad = Instance.new("UIPadding", G2L["extra"])
	ePad.PaddingLeft   = UDim.new(0, 2)
	ePad.PaddingRight  = UDim.new(0, 2)
	ePad.PaddingTop    = UDim.new(0, 2)
	ePad.PaddingBottom = UDim.new(0, 4)
end

-- ─── TEMPLATE: MAIN BUTTON ───────────────────────────────────────
do
	local btn = Instance.new("Frame")
	btn.Name             = "button"
	btn.Size             = UDim2.new(1, 0, 0, 60)
	btn.BackgroundColor3 = C.surface
	btn.BorderSizePixel  = 0
	corner(btn, 10)
	stroke(btn, 1, C.border)

	local tL = label(btn, "title", 12, C.textPrimary, Enum.FontWeight.SemiBold)
	tL.Name     = "title"
	tL.Size     = UDim2.new(1, -48, 0, 18)
	tL.Position = UDim2.new(0, 12, 0, 10)

	local dL = label(btn, "description", 10, C.textMuted)
	dL.Name           = "des"
	dL.Size           = UDim2.new(1, -48, 0, 26)
	dL.Position       = UDim2.new(0, 12, 0, 30)
	dL.TextYAlignment = Enum.TextYAlignment.Top

	local arrow = Instance.new("Frame", btn)
	arrow.Name             = "arrow"
	arrow.AnchorPoint      = Vector2.new(1, 0.5)
	arrow.Position         = UDim2.new(1, -10, 0.5, 0)
	arrow.Size             = UDim2.new(0, 26, 0, 26)
	arrow.BackgroundColor3 = C.surfaceHigh
	arrow.BorderSizePixel  = 0
	corner(arrow, 7)
	local al = label(arrow, "›", 17, C.textMuted, Enum.FontWeight.Bold)
	al.TextXAlignment = Enum.TextXAlignment.Center

	local click = imagebutton(btn)
	click.Name = "click"

	G2L["main_button_template"] = btn
end

-- ─── TEMPLATE: MAIN TOGGLE ───────────────────────────────────────
-- FIX #2: toggle pill now uses AnchorPoint(0.5, 0.5) + Position relative
-- to card centre, NOT anchored to bottom-right. This keeps it vertically
-- centred regardless of card height and avoids overlapping the subtext.
-- Text blocks are also narrowed to leave room for the pill on the right.
do
	local tog = Instance.new("Frame")
	tog.Name             = "toggle"
	tog.Size             = UDim2.new(1, 0, 0, 60)
	tog.BackgroundColor3 = C.surface
	tog.BorderSizePixel  = 0
	corner(tog, 10)
	stroke(tog, 1, C.border)

	-- Title: leaves 60px on the right for the pill (42w + 10 right margin + 8 gap)
	local tL = label(tog, "title", 12, C.textPrimary, Enum.FontWeight.SemiBold)
	tL.Name     = "title"
	tL.Size     = UDim2.new(1, -68, 0, 18)
	tL.Position = UDim2.new(0, 12, 0, 10)

	-- Subtext: same width constraint, does not extend under the pill
	local dL = label(tog, "description", 10, C.textMuted)
	dL.Name           = "des"
	dL.Size           = UDim2.new(1, -68, 0, 24)
	dL.Position       = UDim2.new(0, 12, 0, 30)
	dL.TextYAlignment = Enum.TextYAlignment.Top

	-- FIX: pill anchored centre-right so it stays vertically centred always
	local track = Instance.new("Frame", tog)
	track.Name             = "toggle"
	track.AnchorPoint      = Vector2.new(1, 0.5)   -- pivot at track's right+centre
	track.Position         = UDim2.new(1, -10, 0.5, 0)  -- 10px from right, vertically centred
	track.Size             = UDim2.new(0, 42, 0, 22)
	track.BackgroundColor3 = C.red
	track.BorderSizePixel  = 0
	corner(track, 11)

	local knob = Instance.new("Frame", track)
	knob.Name             = "knob"
	knob.Size             = UDim2.new(0, 18, 0, 18)
	knob.Position         = UDim2.new(0, 2, 0.5, -9)
	knob.BackgroundColor3 = C.white
	knob.BorderSizePixel  = 0
	corner(knob, 9)

	local click = imagebutton(tog)
	click.Name = "click"

	G2L["main_toggle_template"] = tog
end

-- ─── TEMPLATE: EXTRA / AURA TOGGLE ──────────────────────────────
do
	local etog = Instance.new("Frame")
	etog.Name             = "extratoggle"
	etog.Size             = UDim2.new(1, 0, 0, 76)
	etog.BackgroundColor3 = C.surface
	etog.BorderSizePixel  = 0
	corner(etog, 10)
	stroke(etog, 1, C.border)

	local tL = label(etog, "title", 11, C.textPrimary, Enum.FontWeight.SemiBold)
	tL.Name           = "title"
	tL.Size           = UDim2.new(1, -16, 0, 16)
	tL.Position       = UDim2.new(0, 8, 0, 8)
	tL.TextXAlignment = Enum.TextXAlignment.Center

	local dot = Instance.new("Frame", etog)
	dot.Name             = "dot"
	dot.AnchorPoint      = Vector2.new(0.5, 0)
	dot.Position         = UDim2.new(0.5, 0, 0, 30)
	dot.Size             = UDim2.new(0, 30, 0, 30)
	dot.BackgroundColor3 = C.surfaceHigh
	dot.BorderSizePixel  = 0
	corner(dot, 15)
	stroke(dot, 1.5, C.border)

	local inner = Instance.new("Frame", dot)
	inner.Name             = "inner"
	inner.AnchorPoint      = Vector2.new(0.5, 0.5)
	inner.Position         = UDim2.new(0.5, 0, 0.5, 0)
	inner.Size             = UDim2.new(0, 12, 0, 12)
	inner.BackgroundColor3 = C.textMuted
	inner.BorderSizePixel  = 0
	corner(inner, 6)

	local click = imagebutton(etog)
	click.Name = "click"

	G2L["extra_toggle_template"] = etog
end

-- ─────────────────────────── MINIMISED OVERLAY ───────────────────
G2L["icon"] = Instance.new("Frame", G2L["screen"])
G2L["icon"].Name             = "icon"
G2L["icon"].AnchorPoint      = Vector2.new(0, 0)
G2L["icon"].Position         = UDim2.new(0, 20, 0, 60)
G2L["icon"].Size             = UDim2.new(0, 50, 0, 50)
G2L["icon"].BackgroundColor3 = C.surface
G2L["icon"].BorderSizePixel  = 0
G2L["icon"].Visible          = false
corner(G2L["icon"], 14)
stroke(G2L["icon"], 1.5, C.border)

do
	local s = Instance.new("UIScale", G2L["icon"])
	s.Scale = 0
	G2L["icon_scale"] = s

	local ico = Instance.new("ImageButton", G2L["icon"])
	ico.Name                  = "ImageButton"
	ico.Image                 = "rbxassetid://124350377833889"
	ico.ScaleType             = Enum.ScaleType.Fit
	ico.AnchorPoint           = Vector2.new(0.5, 0.5)
	ico.Position              = UDim2.new(0.5, 0, 0.5, 0)
	ico.Size                  = UDim2.new(0.62, 0, 0.62, 0)
	ico.BackgroundTransparency = 1
	ico.BorderSizePixel       = 0
	G2L["icon_button"] = ico
end

-- Screen-bounded drag (UIS delta, no UIDragDetector)
do
	local icon       = G2L["icon"]
	local dragging   = false
	local dragStart  = Vector2.new(0, 0)
	local frameStart = Vector2.new(0, 0)
	local W, H       = 50, 50

	icon.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
			dragging   = true
			dragStart  = Vector2.new(input.Position.X, input.Position.Y)
			frameStart = Vector2.new(icon.Position.X.Offset, icon.Position.Y.Offset)
		end
	end)

	uis.InputChanged:Connect(function(input)
		if not dragging then return end
		if input.UserInputType ~= Enum.UserInputType.MouseMovement
		and input.UserInputType ~= Enum.UserInputType.Touch then return end
		local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStart
		local vp    = game:GetService("Workspace").CurrentCamera.ViewportSize
		local nx    = math.clamp(frameStart.X + delta.X, 0, vp.X - W)
		local ny    = math.clamp(frameStart.Y + delta.Y, 0, vp.Y - H)
		icon.Position = UDim2.new(0, nx, 0, ny)
	end)

	uis.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
end

-- ═══════════════════════════════════════════════════════
-- BEHAVIOUR LOGIC
-- ═══════════════════════════════════════════════════════

local function partowner(part) return part.ReceiveAge == 0 end
function G2L.partowner(part)   return part.ReceiveAge == 0 end

function G2L.setSelectedNPC(npc)
	if npc then
		tweenservice:Create(G2L["npc_dot"], TweenInfo.new(0.2), {BackgroundColor3 = C.green}):Play()
		G2L["npc_label"].TextColor3     = C.green
		G2L["npc_label"].Text           = "NPC Selected"
		G2L["selected_name"].Text       = npc.Name
		G2L["selected_name"].TextColor3 = C.textAccent
	else
		tweenservice:Create(G2L["npc_dot"], TweenInfo.new(0.2), {BackgroundColor3 = C.textMuted}):Play()
		G2L["npc_label"].TextColor3     = C.textMuted
		G2L["npc_label"].Text           = "No NPC Selected"
		G2L["selected_name"].Text       = "─────────"
		G2L["selected_name"].TextColor3 = C.textMuted
	end
end

-- ─── LEFT TOGGLE: Click to Select NPC ────────────────────────────
clicknpc = true
do
	local track  = G2L["disable_track"]
	local knob   = G2L["disable_knob"]
	local onPos  = UDim2.new(1, -20, 0.5, -9)
	local offPos = UDim2.new(0,   2, 0.5, -9)
	track.BackgroundColor3 = C.green
	knob.Position          = onPos

	G2L["disable_click"].MouseButton1Click:Connect(function()
		clicknpc = not clicknpc
		tweenservice:Create(track, fast, {BackgroundColor3 = clicknpc and C.green or C.red}):Play()
		tweenservice:Create(knob,  fast, {Position         = clicknpc and onPos   or offPos}):Play()
	end)
end

-- ─── LEFT TOGGLE: Auto-Select Nearest NPC ────────────────────────
-- Exposed as a global so main.Luau can read it. Logic lives in main.Luau.
autonpc = false
do
	local track  = G2L["autoselect_track"]
	local knob   = G2L["autoselect_knob"]
	local onPos  = UDim2.new(1, -20, 0.5, -9)
	local offPos = UDim2.new(0,   2, 0.5, -9)

	G2L["autoselect_click"].MouseButton1Click:Connect(function()
		autonpc = not autonpc
		tweenservice:Create(track, fast, {BackgroundColor3 = autonpc and C.green or C.red}):Play()
		tweenservice:Create(knob,  fast, {Position         = autonpc and onPos   or offPos}):Play()
	end)
end

-- ─── LEFT TOGGLE: Network Ownership ──────────────────────────────
networkvis = false
do
	local track  = G2L["network_track"]
	local knob   = G2L["network_knob"]
	local onPos  = UDim2.new(1, -20, 0.5, -9)
	local offPos = UDim2.new(0,   2, 0.5, -9)

	G2L["network_click"].MouseButton1Click:Connect(function()
		networkvis = not networkvis
		pcall(function() settings().Physics.AreOwnersShown = networkvis end)
		tweenservice:Create(track, fast, {BackgroundColor3 = networkvis and C.green or C.red}):Play()
		tweenservice:Create(knob,  fast, {Position         = networkvis and onPos   or offPos}):Play()
	end)
end

-- ─── MINIMIZE ────────────────────────────────────────────────────
local minimized = false
local function toggleMinimize()
	minimized = not minimized
	if minimized then
		G2L["icon"].Visible     = true
		G2L["icon_scale"].Scale = 0
		tweenservice:Create(G2L["frame_scale"], fast, {Scale = 0}):Play()
		tweenservice:Create(G2L["icon_scale"],  fast, {Scale = 1}):Play()
		task.wait(0.38)
		G2L["frame"].Visible = false
	else
		G2L["frame"].Visible = true
		tweenservice:Create(G2L["frame_scale"], fast, {Scale = 1}):Play()
		tweenservice:Create(G2L["icon_scale"],  fast, {Scale = 0}):Play()
		task.wait(0.38)
		G2L["icon"].Visible = false
	end
end

G2L["minimize_btn"].MouseButton1Click:Connect(toggleMinimize)
G2L["icon_button"].MouseButton1Click:Connect(toggleMinimize)

-- ─── INTRO SEQUENCE ──────────────────────────────────────────────
local function playIntro()
	local lighting = game:GetService("Lighting")

	G2L["dark"].Visible                 = true
	G2L["dark"].BackgroundTransparency  = 1
	G2L["intro_icon"].ImageTransparency = 1
	G2L["intro_title"].TextTransparency = 1
	G2L["intro_sub"].TextTransparency   = 1
	G2L["intro_scale"].Scale            = 0
	G2L["frame_scale"].Scale            = 0
	G2L["intro"].Visible                = true

	local blur = Instance.new("BlurEffect")
	blur.Name   = "intro_blur"
	blur.Size   = 0
	blur.Parent = lighting

	tweenservice:Create(blur,            slow,   {Size = 18}):Play()
	tweenservice:Create(G2L["dark"],     slow,   {BackgroundTransparency = 0.6}):Play()
	task.wait(0.15)
	tweenservice:Create(G2L["intro_scale"], medium, {Scale = 1}):Play()
	task.wait(0.25)
	tweenservice:Create(G2L["intro_icon"],  medium, {ImageTransparency = 0}):Play()
	task.wait(0.35)
	tweenservice:Create(G2L["intro_title"], medium, {TextTransparency = 0}):Play()
	task.wait(0.20)
	tweenservice:Create(G2L["intro_sub"],   medium, {TextTransparency = 0}):Play()
	task.wait(3.5)
	tweenservice:Create(blur,               slow,   {Size = 0}):Play()
	tweenservice:Create(G2L["intro_scale"], medium, {Scale = 0}):Play()
	task.wait(0.3)
	tweenservice:Create(G2L["dark"],        slow,   {BackgroundTransparency = 1}):Play()
	task.wait(0.5)
	G2L["intro"].Visible = false
	G2L["dark"].Visible  = false
	tweenservice:Create(G2L["frame_scale"], medium, {Scale = 1}):Play()
	blur:Destroy()
end

-- ─── ELEMENT FACTORY ─────────────────────────────────────────────
local function create()
	local api = {}

	function api:mainbutton(title, description, func)
		local btn = G2L["main_button_template"]:Clone()
		btn.Parent     = G2L["main"]
		btn.title.Text = title or "button"
		btn.des.Text   = description or ""

		btn.click.MouseButton1Click:Connect(function()
			if not func then return end
			tweenservice:Create(btn, TweenInfo.new(0.08), {BackgroundColor3 = C.accentDim}):Play()
			task.wait(0.10)
			tweenservice:Create(btn, TweenInfo.new(0.18), {BackgroundColor3 = C.surface}):Play()
			task.spawn(function()
				local ok, err = pcall(func)
				if not ok then warn(err) end
			end)
		end)
		btn.click.MouseEnter:Connect(function()
			tweenservice:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = C.surfaceHigh}):Play()
		end)
		btn.click.MouseLeave:Connect(function()
			tweenservice:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = C.surface}):Play()
		end)
		return btn
	end

	function api:maintoggle(title, description, func)
		local tog = G2L["main_toggle_template"]:Clone()
		tog.Parent     = G2L["main"]
		tog.title.Text = title or "toggle"
		tog.des.Text   = description or ""

		local track  = tog.toggle
		local knob   = tog.toggle.knob
		local onPos  = UDim2.new(1, -20, 0.5, -9)
		local offPos = UDim2.new(0,   2, 0.5, -9)
		local state  = false
		local handle = {}

		tog.click.MouseButton1Click:Connect(function()
			state = not state
			tweenservice:Create(track, fast, {BackgroundColor3 = state and C.green or C.red}):Play()
			tweenservice:Create(knob,  fast, {Position         = state and onPos   or offPos}):Play()
			tweenservice:Create(tog,   TweenInfo.new(0.08), {BackgroundColor3 = C.surfaceHigh}):Play()
			task.wait(0.10)
			tweenservice:Create(tog,   TweenInfo.new(0.18), {BackgroundColor3 = C.surface}):Play()
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
			tweenservice:Create(knob,  fast, {Position         = state and onPos   or offPos}):Play()
		end

		return handle
	end

	function api:extratoggle(title, func)
		local etog = G2L["extra_toggle_template"]:Clone()
		etog.Parent     = G2L["extra"]
		etog.title.Text = title or "aura"

		local dot   = etog.dot
		local inner = dot.inner
		local state = false

		etog.click.MouseButton1Click:Connect(function()
			state = not state
			tweenservice:Create(dot,   fast, {BackgroundColor3 = state and C.green    or C.surfaceHigh}):Play()
			tweenservice:Create(inner, fast, {BackgroundColor3 = state and C.white    or C.textMuted}):Play()
			tweenservice:Create(etog,  TweenInfo.new(0.08), {BackgroundColor3 = C.surfaceHigh}):Play()
			task.wait(0.10)
			tweenservice:Create(etog,  TweenInfo.new(0.18), {BackgroundColor3 = C.surface}):Play()
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
