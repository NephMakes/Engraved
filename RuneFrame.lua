-- RuneFrame handles class resource mechanics

local addonName, Engraved = ...
local RuneFrame = Engraved.RuneFrame
local Rune = Engraved.Rune

local function round(x) 
	return floor(x + 0.5)
end


--[[ Setup ]]--

function RuneFrame:OnLoad()
	self:SetScript("OnEvent", self.OnEvent)
	self:RegisterEvents()

	for _, rune in pairs(self.Runes) do
		Mixin(rune, Rune)
		rune:OnLoad()
	end

	self:SetScript("OnDragStart", self.OnDragStart)
	self:SetScript("OnDragStop", self.OnDragStop)
	self:RegisterForDrag("LeftButton")
	self:OnLoadTab()
end

function RuneFrame:RegisterEvents()
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterUnitEvent("UNIT_ENTERED_VEHICLE", "player")
	self:RegisterUnitEvent("UNIT_EXITED_VEHICLE", "player")
	self:RegisterEvent("PET_BATTLE_OPENING_START")
	self:RegisterEvent("PET_BATTLE_OVER")
end

function RuneFrame:Update()
	self:SetClass()
	if self.inUse then
		self:SetOptions(EngravedOptions)  -- Saved variable
		self:UpdateRunes()
	else
		self:Inactivate()
	end
end

function RuneFrame:SetClass()
	-- RuneFrame:CLASS defined in [Class].lua
	-- Loaded in .toc according to game version
	local _, class = UnitClass("player")
	local classFunction = self[class]
	if classFunction then
		classFunction(self)
	end
end

function RuneFrame:Inactivate()
	-- Render harmless if loaded for inappropriate class/spec
	self:UnregisterAllEvents()
	self:Hide()
end

function RuneFrame:SetOptions(options)
	self:SetRuneTheme(options.RuneTheme)
	self:SetRuneColor(options.RuneColor)
	self:SetOutOfCombatAlpha(options.OutOfCombatAlpha)
	self:SetPosition(options.RuneFramePosition)
	self:SetSize(options.RuneFrameSize)
	self:SetRunePositions(options.RunePositions)
	self:SetRuneSizes(options.RuneSizes)
	self:SetLocked(options.IsLocked)
end

function RuneFrame:SetRuneTheme(theme)
	local texturePath = "Interface\\AddOns\\Engraved\\"
	local themeIndex = {
		ICECROWN = 1, 
		NEXUS = 2, 
		ULDUAR = 3, 
		FROSTMOURNE = 4, 
		ELDRITCH = 5
	}
	for i, rune in pairs(self.Runes) do
		rune.background:SetTexture(texturePath.."RuneBackground")
		rune.fill:SetTexture(texturePath.."RuneFill")
		rune.charge:SetTexture(texturePath.."RuneFill")
		rune.glow:SetTexture(texturePath.."RuneGlow")
		rune.background:SetTexCoord((i-1)/8, i/8, (themeIndex[theme] - 1)/8, themeIndex[theme]/8)
		rune.fill:SetTexCoord((i-1)/8, i/8, (themeIndex[theme] - 1)/8, themeIndex[theme]/8)
		rune.charge:SetTexCoord((i-1)/8, i/8, (themeIndex[theme] - 1)/8, themeIndex[theme]/8)
		rune.glow:SetTexCoord((i-1)/8, i/8, (themeIndex[theme] - 1)/8, themeIndex[theme]/8)
	end
end

function RuneFrame:SetRuneColor(color)
	-- This gets replaced for Classic Death Knights
	for _, rune in pairs(self.Runes) do
		rune:SetRuneColor(color)
	end
end

function RuneFrame:SetOutOfCombatAlpha(outOfCombatAlpha)
	self.outOfCombatAlpha = outOfCombatAlpha
end

function RuneFrame:SetPosition(point) 
	self:ClearAllPoints()
	self:SetPoint(unpack(point))
end

function RuneFrame:SetSize(size)
	-- Overwriting SetSize() for this frame to parallel SetPosition()
	local width, height = unpack(size)
	self:SetWidth(width)
	self:SetHeight(height)
end

function RuneFrame:SetRunePositions(runePositions) 
	for i, rune in ipairs(self.Runes) do
		rune:ClearAllPoints()
		rune:SetPoint(unpack(runePositions[i]))
	end
end

function RuneFrame:SetRuneSizes(runeSizes) 
	for i, rune in ipairs(self.Runes) do
		rune:SetSize(runeSizes[i], runeSizes[i])
	end
end

function RuneFrame:SetLocked(isLocked) 
	self = RuneFrame  -- Can be called from tab dropdown menu or options panel
	EngravedOptions.IsLocked = isLocked
	self.isLocked = isLocked
	if isLocked then
		self.Background:Hide()
		self.Border:Hide()
		self.Tab:Hide()
		self:EnableMouse(false)
		for _, rune in pairs(self.Runes) do
			rune:EnableMouse(false)
			rune.resizeButton:Hide()
		end
	else
		self.Background:Show()
		self.Border:Show()
		self.Tab:Show()
		self:EnableMouse(true)
		for _, rune in pairs(self.Runes) do
			rune:EnableMouse(true)
			rune.resizeButton:Show()
		end
	end
	self:UpdateShown()
end


--[[ Action ]]--

function RuneFrame:UpdateRunes()
	self:UpdateMaxPower()
	self:UpdatePower()
	self:UpdateShown()
end

function RuneFrame:UpdateMaxPower() end
function RuneFrame:UpdatePower() end
-- These get replaced by class RuneFrameMixin

function RuneFrame:UpdateShown()
	if not self.inUse or self.isDormant then
		self:Hide()
	else
		self:Show()
		if InCombatLockdown() then
			self:SetShown()
		else
			self:SetOutOfCombat()
		end
	end
end

function RuneFrame:SetShown()
	self:SetAlpha(1)
end

function RuneFrame:SetOutOfCombat()
	if self.isLocked then 
		self:SetAlpha(self.outOfCombatAlpha)
	else
		self:SetShown()
	end
end

function RuneFrame:OnEvent(event, ...)
	local f = self[event]
	if f then
		f(self, ...)
	end
end

--[[
-- Shouldn't ever affect these resources
-- Update on talent/spec change should be enough
function RuneFrame:UNIT_MAXPOWER(unit, powerToken)
	-- Only registered for unit "player"
	if powerToken == self.powerToken then
		self:UpdateMaxPower()
	end
end
]]--

function RuneFrame:UNIT_POWER_FREQUENT(unit, powerToken)
	-- Only registered for unit "player"
	if powerToken == self.powerToken then
		self:UpdatePower()
	end
end

function RuneFrame:PLAYER_REGEN_ENABLED()
	self:SetOutOfCombat()
end

function RuneFrame:PLAYER_REGEN_DISABLED()
	self:SetShown()
end

function RuneFrame:UNIT_ENTERED_VEHICLE()
	self:Hide()
end

function RuneFrame:UNIT_EXITED_VEHICLE()
	self:UpdateShown()
end

function RuneFrame:PET_BATTLE_OPENING_START()
	self:Hide()
end

function RuneFrame:PET_BATTLE_OVER()
	self:UpdateShown()
end


--[[ Config ]]--

function RuneFrame:OnDragStart()
	self:StartMoving()
end

function RuneFrame:OnDragStop()
	self:StopMovingOrSizing()
	self:SetUserPlaced(false)
	local point, relativeTo, relativePoint, xOfs, yOfs = self:GetPoint()
	xOfs, yOfs = round(xOfs), round(yOfs)
	EngravedOptions.RuneFramePosition = { point, relativeTo, relativePoint, xOfs, yOfs }
end

function RuneFrame:FitToRunes()
	local runeLeft, runeRight, runeTop, runeBottom = {}, {}, {}, {}
	for _, rune in pairs(self.Runes) do
		if rune.inUse then
			table.insert(runeLeft, rune:GetLeft())
			table.insert(runeRight, rune:GetRight())
			table.insert(runeBottom, rune:GetBottom())
			table.insert(runeTop, rune:GetTop())
		end
	end
	self:ClearAllPoints()
	if #runeLeft > 0 then  -- Function sometimes called when runeLeft == nil
		self:SetPoint("BOTTOMLEFT", nil, "BOTTOMLEFT", min(unpack(runeLeft)), min(unpack(runeBottom)))
		self:SetPoint("TOPRIGHT", nil, "BOTTOMLEFT", max(unpack(runeRight)), max(unpack(runeTop)))
	end
end

function RuneFrame:SaveSizeAndPosition()
	local width, height = round(self:GetWidth()), round(self:GetHeight())
	local xPos = round(self:GetLeft() + width/2)
	local yPos = round(self:GetBottom() + height/2)
	EngravedOptions.RuneFramePosition = {"CENTER", nil, "BOTTOMLEFT", xPos, yPos}
	EngravedOptions.RuneFrameSize = {width, height}
end

function RuneFrame:SaveRunePositions()
	local runeFrameX = round(self:GetLeft() + self:GetWidth()/2)
	local runeFrameY = round(self:GetBottom() + self:GetHeight()/2)
	local runeX, runeY
	for i, rune in pairs(self.Runes) do
		runeX = round(rune:GetLeft() + rune:GetWidth()/2)
		runeY = round(rune:GetBottom() + rune:GetHeight()/2)
		EngravedOptions.RunePositions[i] = {"CENTER", runeX - runeFrameX, runeY - runeFrameY}
	end
end

function RuneFrame:UpdateSizeAndPosition()
	for _, rune in pairs(self.Runes) do
		rune:AnchorToScreen()
	end
	self:FitToRunes()
	self:SaveSizeAndPosition()
	self:SetPosition(EngravedOptions.RuneFramePosition)
	self:SetSize(EngravedOptions.RuneFrameSize)
	self:SaveRunePositions()
	self:SetRunePositions(EngravedOptions.RunePositions)
end

function RuneFrame:OnLoadTab()
	local tab = self.Tab
	tab:SetScript("OnClick", self.OnClickTab)
	tab:SetScript("OnDragStart", function() RuneFrame:OnDragStart() end)
	tab:SetScript("OnDragStop", function() RuneFrame:OnDragStop() end)
	tab:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	tab:RegisterForDrag("LeftButton")
	UIDropDownMenu_Initialize(EngravedRuneFrameTabDropDown, RuneFrame.InitializeTabDropDown, "MENU")
end

function RuneFrame:OnClickTab(mouseButton)
	PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON)
	if mouseButton == "RightButton" then
		ToggleDropDownMenu(1, nil, EngravedRuneFrameTabDropDown, self:GetName(), 0, 0)
		return
	end
	CloseDropDownMenus()
end

function RuneFrame:InitializeTabDropDown()
	local strings = Engraved.Strings
	local info = UIDropDownMenu_CreateInfo()

	info.text = strings.OPEN_OPTIONS_MENU
	info.func = RuneFrame.OpenOptionsPanel
	info.isNotRadio = true
	info.notCheckable = true
	UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL)

	info.text = strings.LOCK_RUNE_DISPLAY
	info.func = RuneFrame.SetLocked
	info.arg1 = true
	info.isNotRadio = true
	info.notCheckable = true
	UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL)

	--[[
	info.text = strings.RESET_POSITIONS
	info.func = nil
	info.isNotRadio = true
	info.notCheckable = true
	UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL)
	]]--
end

function RuneFrame:OpenOptionsPanel()
	Settings.OpenToCategory(addonName)
end


