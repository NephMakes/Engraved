-- OptionsLibrary.lua must be loaded before this file

local addonName, Engraved = ...
local RuneFrame = Engraved.RuneFrame
local DeathKnight = Engraved.DeathKnight

local IS_MAINLINE = (WOW_PROJECT_ID == WOW_PROJECT_MAINLINE)


--[[ Defaults ]]-- 

Engraved.Defaults = {
	-- AtRestAlpha = 0, 
	ChargeType = "ALMOST_READY", 
	IsLocked = true, 
	OutOfCombatAlpha = 0.2,
	PrioritizeRunes = true,  -- Not yet implemented
	RuneColor = { r = 1, g = 1, b = 1 }, 
	RuneColorBlood = { r = 1, g = 0.2, b = 0 }, 
	RuneColorFrost = { r = 0.5, g = 0.8, b = 1 }, 
	RuneColorUnholy = { r = 0.4, g = 1, b = 0.2 }, 
	RuneColorDeath = { r = 0.8, g = 0.5, b = 0.8 }, 
	RuneFramePosition = { "CENTER", nil, "CENTER", 0, -300 }, 
	RuneFrameSize = { 340, 120 }, 
	RunePositions = {
			[1] = { "CENTER", -130, 20 }, 
			[2] = { "CENTER", -65, 20 }, 
			[3] = { "CENTER", 0, 20 }, 
			[4] = { "CENTER", 65, 20 }, 
			[5] = { "CENTER", 130, 20 }, 
			[6] = { "CENTER", -40, -40 }, 
			[7] = { "CENTER", 0, -40 }, 
			[8] = { "CENTER", 40, -40 } 
	}, 
	RuneSizes = { 80, 80, 80, 80, 80, 80, 80, 80 },
	RuneTheme = "ICECROWN", 
	Version = C_AddOns.GetAddOnMetadata(addonName, "Version")
}

function Engraved:SetClassDefaults(class)
	--local _, class = UnitClass("player")
	local defaults = Engraved.Defaults
	if class == "DEATHKNIGHT" then
		defaults.RuneTheme = "FROSTMOURNE"
		defaults.RuneColor = { r = 0.5, g = 0.8, b = 1.0 }
		defaults.RuneFrameSize = { 404, 80 }
		defaults.RunePositions[1] = { "CENTER", -162, 0 }
		defaults.RunePositions[2] = { "CENTER", -97, 0 }
		defaults.RunePositions[3] = { "CENTER", -32, 0 }
		defaults.RunePositions[4] = { "CENTER", 32, 0 }
		defaults.RunePositions[5] = { "CENTER", 97, 0 }
		defaults.RunePositions[6] = { "CENTER", 162, 0 }
	elseif class == "ROGUE" then
		defaults.RuneTheme = "ICECROWN"
		defaults.RuneColor = { r = 1.0, g = 0.2, b = 0.0 }
		defaults.RuneFrameSize = { 340, 80 }
		defaults.RunePositions[1] = { "CENTER", -130, 0 }
		defaults.RunePositions[2] = { "CENTER", -65, 0 }
		defaults.RunePositions[3] = { "CENTER", 0, 0 }
		defaults.RunePositions[4] = { "CENTER", 65, 0 }
		defaults.RunePositions[5] = { "CENTER", 130, 0 }
		defaults.RuneSizes = { 80, 80, 80, 80, 80, 40, 40, 40 }
	elseif class == "DRUID" then
		defaults.RuneTheme = "NEXUS"
		defaults.RuneColor = { r = 1.0, g = 0.2, b = 0.0 }
		defaults.RuneFrameSize = { 340, 80 }
		defaults.RunePositions[1] = { "CENTER", -130, 0 }
		defaults.RunePositions[2] = { "CENTER", -65, 0 }
		defaults.RunePositions[3] = { "CENTER", 0, 0 }
		defaults.RunePositions[4] = { "CENTER", 65, 0 }
		defaults.RunePositions[5] = { "CENTER", 130, 0 }
	elseif class == "WARLOCK" then
		defaults.RuneTheme = "NEXUS"
		defaults.RuneColor = { r = 0.50, g = 0.32, b = 0.55 }
		defaults.RuneFrameSize = { 340, 80 }
		defaults.RunePositions[1] = { "CENTER", -130, 0 }
		defaults.RunePositions[2] = { "CENTER", -65, 0 }
		defaults.RunePositions[3] = { "CENTER", 0, 0 }
		defaults.RunePositions[4] = { "CENTER", 65, 0 }
		defaults.RunePositions[5] = { "CENTER", 130, 0 }
	elseif class == "MAGE" then
		defaults.RuneTheme = "ELDRITCH"
		defaults.RuneColor = { r = 0.5, g = 0.4, b = 1 }
		defaults.RuneFrameSize = { 275, 80 }
		defaults.RunePositions[1] = { "CENTER", -97, 0 }
		defaults.RunePositions[2] = { "CENTER", -32, 0 }
		defaults.RunePositions[3] = { "CENTER", 32, 0 }
		defaults.RunePositions[4] = { "CENTER", 97, 0 }
	elseif class == "PALADIN" then
		defaults.RuneTheme = "ULDUAR"
		defaults.RuneColor = { r = 0.95, g = 0.90, b = 0.60 }
		defaults.RuneFrameSize = { 340, 80 }
		defaults.RunePositions[1] = { "CENTER", -130, 0 }
		defaults.RunePositions[2] = { "CENTER", -65, 0 }
		defaults.RunePositions[3] = { "CENTER", 0, 0 }
		defaults.RunePositions[4] = { "CENTER", 65, 0 }
		defaults.RunePositions[5] = { "CENTER", 130, 0 }
	elseif class == "MONK" then
		defaults.RuneTheme = "ULDUAR"
		defaults.RuneColor = { r = 0.71, g = 1.0, b = 0.92 }
		defaults.RuneFrameSize = { 404, 80 }
		defaults.RunePositions[1] = { "CENTER", -162, 0 }
		defaults.RunePositions[2] = { "CENTER", -97, 0 }
		defaults.RunePositions[3] = { "CENTER", -32, 0 }
		defaults.RunePositions[4] = { "CENTER", 32, 0 }
		defaults.RunePositions[5] = { "CENTER", 97, 0 }
		defaults.RunePositions[6] = { "CENTER", 162, 0 }
	elseif class == "EVOKER" then
		defaults.RuneTheme = "NEXUS"
		defaults.RuneColor = { r = 0.6, g = 0.8, b = 1.0 }
		defaults.RuneFrameSize = { 340, 80 }
		defaults.RunePositions[1] = { "CENTER", -130, 0 }
		defaults.RunePositions[2] = { "CENTER", -65, 0 }
		defaults.RunePositions[3] = { "CENTER", 0, 0 }
		defaults.RunePositions[4] = { "CENTER", 65, 0 }
		defaults.RunePositions[5] = { "CENTER", 130, 0 }
	end
	Engraved.OptionsPanel.defaults = defaults
end


--[[ OptionsPanel ]]-- 

Engraved.OptionsPanel = Engraved:CreateOptionsPanel()
local optionsPanel = Engraved.OptionsPanel

optionsPanel.savedVariablesName = "EngravedOptions"
-- optionsPanel.defaults set in SetClassDefaults()
optionsPanel.defaultsFunc = function()
	local runeFrame, options = EngravedRuneFrame, EngravedOptions;
	runeFrame:SetPosition(options.RuneFramePosition);
	runeFrame:SetSize(options.RuneFrameSize);
	runeFrame:SetRunePositions(options.RunePositions);
	runeFrame:SetRuneSizes(options.RuneSizes);
	runeFrame:SetLocked(options.IsLocked);
end;

-- Rune theme
optionsPanel.runeTheme = optionsPanel:CreateDropDownMenu("RuneTheme");
local runeTheme = optionsPanel.runeTheme;
runeTheme:SetPoint("TOPLEFT", optionsPanel.subtext, "BOTTOMLEFT", -14, -42);
runeTheme.onValueChanged = function(value) 
	EngravedRuneFrame:SetRuneTheme(value);
end
runeTheme.optionList = {
	{text = "Icecrown", value = "ICECROWN"},
	{text = "Nexus", value = "NEXUS"},
	{text = "Ulduar", value = "ULDUAR"}, 
	{text = "Frostmourne", value = "FROSTMOURNE"}, 
	{text = "Eldritch", value = "ELDRITCH"} 
}

-- Rune color
optionsPanel.runeColor = optionsPanel:CreateColorPicker("RuneColor")
local runeColor = optionsPanel.runeColor
runeColor:SetPoint("TOPLEFT", optionsPanel.runeTheme, "BOTTOMLEFT", 18, -28)
runeColor.onValueChanged = function(value)
	EngravedRuneFrame:SetRuneColor(value)
end

-- Blood rune color
optionsPanel.runeColorBlood = optionsPanel:CreateColorPicker("RuneColorBlood");
local runeColorBlood = optionsPanel.runeColorBlood;
runeColorBlood:SetPoint("TOPLEFT", optionsPanel.runeTheme, "BOTTOMLEFT", 18, -28);
runeColorBlood.onValueChanged = function(value) 
	DeathKnight:SetRuneTypeColor(1, value)
end
runeColorBlood:Hide()

-- Frost rune color
optionsPanel.runeColorFrost = optionsPanel:CreateColorPicker("RuneColorFrost");
local runeColorFrost = optionsPanel.runeColorFrost;
runeColorFrost:SetPoint("LEFT", optionsPanel.runeColorBlood, "RIGHT", 128, 0);
runeColorFrost.onValueChanged = function(value) 
	DeathKnight:SetRuneTypeColor(2, value)
end
runeColorFrost:Hide()

-- Unholy rune color
optionsPanel.runeColorUnholy = optionsPanel:CreateColorPicker("RuneColorUnholy");
local runeColorUnholy = optionsPanel.runeColorUnholy;
runeColorUnholy:SetPoint("LEFT", optionsPanel.runeColorFrost, "RIGHT", 128, 0);
runeColorUnholy.onValueChanged = function(value) 
	DeathKnight:SetRuneTypeColor(3, value)
end
runeColorUnholy:Hide()

-- Death rune color
optionsPanel.runeColorDeath = optionsPanel:CreateColorPicker("RuneColorDeath");
local runeColorDeath = optionsPanel.runeColorDeath;
runeColorDeath:SetPoint("LEFT", optionsPanel.runeColorUnholy, "RIGHT", 128, 0);
runeColorDeath.onValueChanged = function(value) 
	DeathKnight:SetRuneTypeColor(4, value)
end
runeColorDeath:Hide()

-- Charge type
optionsPanel.chargeType = optionsPanel:CreateDropDownMenu("ChargeType")
local chargeType = optionsPanel.chargeType
chargeType:SetPoint("TOPLEFT", optionsPanel.runeColorBlood, "BOTTOMLEFT", -14, -42)
UIDropDownMenu_SetWidth(chargeType, 220)
chargeType.onValueChanged = function(value) 
	RuneFrame:SetChargeType(value)
end
chargeType.optionList = {
	{text = "Slowly increase glow", value = "SLOW_GLOW"},
	{text = "Glow when almost ready", value = "ALMOST_READY"}
}
chargeType:Hide()

-- Out of combat alpha
optionsPanel.outOfCombatAlpha = optionsPanel:CreateSlider("OutOfCombatAlpha");
local outOfCombatAlpha = optionsPanel.outOfCombatAlpha;
outOfCombatAlpha:SetPoint("TOPLEFT", optionsPanel.subtext, "BOTTOMLEFT", 300, -48);
outOfCombatAlpha:SetMinMaxValues(0, 1);
outOfCombatAlpha:SetValueStep(0.05);
outOfCombatAlpha:SetObeyStepOnDrag(true);
outOfCombatAlpha.onValueChanged = function(value)
	EngravedRuneFrame:SetOutOfCombatAlpha(value);
	EngravedRuneFrame:UpdateShown();
end

-- Config mode button
local configButton = CreateFrame("Button", optionsPanel:GetName().."ConfigButton", optionsPanel, "UIPanelButtonTemplate")
optionsPanel.configButton = configButton
configButton:SetSize(128, 22)
configButton:SetPoint("BOTTOMRIGHT", optionsPanel, "BOTTOM", -12, 24)
configButton.Text = _G[configButton:GetName().."Text"]
configButton:SetScript("OnClick", function () 
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
	EngravedRuneFrame:SetLocked(false)
end)

-- Play mode button
local playButton = CreateFrame("Button", optionsPanel:GetName().."PlayButton", optionsPanel, "UIPanelButtonTemplate")
optionsPanel.playButton = playButton
playButton:SetSize(128, 22)
playButton:SetPoint("BOTTOMLEFT", optionsPanel, "BOTTOM", 12, 24)
playButton.Text = _G[playButton:GetName().."Text"]
playButton:SetScript("OnClick", function () 
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
	EngravedRuneFrame:SetLocked(true)
end)

local OptionsPanel = Engraved.OptionsPanel

function OptionsPanel:ShowDeathKnightOptions()
	if not IS_MAINLINE then
		self.runeColor:Hide()
		self.runeColorBlood:Show()
		self.runeColorFrost:Show()
		self.runeColorUnholy:Show()
		self.runeColorDeath:Show()
		self.chargeType:Show()
	end
end




