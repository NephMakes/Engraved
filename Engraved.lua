-- Engraved: Track class combat resources using Warcraft rune art
-- by NephMakes

local ENGRAVED, Engraved = ...

-- Define namespaces
Engraved.EngravedFrame = CreateFrame("Frame", "EngravedFrame")
Engraved.Localization = {}
Engraved.RuneFrame = EngravedRuneFrame  -- Defined in Engraved.xml
Engraved.Rune = {}
Engraved.DeathKnight = {}
Engraved.Rogue = {}
Engraved.Druid = {}
Engraved.Paladin = {}
Engraved.Mage = {}
Engraved.Warlock = {}
Engraved.Monk = {}
Engraved.Evoker = {}

local EngravedFrame = Engraved.EngravedFrame
local RuneFrame = EngravedRuneFrame


--[[ EngravedFrame ]]--

-- Handles executive events like class, expansion, etc

function EngravedFrame:OnLoad()
	self:SetScript("OnEvent", EngravedFrame.OnEvent)
	self:RegisterEvent("ADDON_LOADED")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("PLAYER_LEVEL_UP")
	if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
		-- Classic Era
		self:RegisterEvent("CHARACTER_POINTS_CHANGED")
	else
		self:RegisterEvent("PLAYER_TALENT_UPDATE")
	end
	-- SetUpClass_Retail.lua registers PLAYER_SPECIALIZATION_CHANGED
end

function EngravedFrame:OnEvent(event, ...)
	local f = self[event]
	if f then
		f(self, ...)
	end
end

function EngravedFrame:ADDON_LOADED(addonName)
	if addonName ~= ENGRAVED then return end
	Engraved:OnAddonLoaded()
	self:UnregisterEvent("ADDON_LOADED")
end

function EngravedFrame:PLAYER_ENTERING_WORLD()
	Engraved:SetupClass()
	Engraved:ApplyOptions()
	Engraved:Update()
end
			
function EngravedFrame:PLAYER_SPECIALIZATION_CHANGED()
	Engraved:SetupClass()
	Engraved:ApplyOptions()
	Engraved:Update()
end
			
function EngravedFrame:PLAYER_TALENT_UPDATE()
	Engraved:ApplyOptions()
	Engraved:Update()
end
			
function EngravedFrame:CHARACTER_POINTS_CHANGED()
	Engraved:ApplyOptions()
	Engraved:Update()
end
			
function EngravedFrame:PLAYER_LEVEL_UP()
	Engraved:SetupClass()
	Engraved:ApplyOptions()
	Engraved:Update()
end

do
	EngravedFrame:OnLoad()
end


--[[ General Engraved functions ]]--

function Engraved:OnAddonLoaded()
	Engraved:LocalizeStrings()
	Engraved:AddSlashCommand()
	UIDropDownMenu_Initialize(EngravedRuneFrameTabDropDown, RuneFrame.InitializeTabDropDown, "MENU")

	local _, class = UnitClass("player")
	Engraved:SetClassDefaults(class)

	local reset = false
	if EngravedOptions and EngravedOptions.Version and EngravedOptions.Version < "2.0" then 
		reset = true
	end
	Engraved:UpdateOptions("EngravedOptions", Engraved.Defaults, reset)

	RuneFrame:OnLoad()
end

function Engraved:ApplyOptions()
	local options = EngravedOptions
	RuneFrame:SetRuneTheme(options.RuneTheme)
	RuneFrame:SetRuneColor(options.RuneColor)
	RuneFrame:SetOutOfCombatAlpha(options.OutOfCombatAlpha)
	RuneFrame:SetPosition(options.RuneFramePosition)
	RuneFrame:SetSize(options.RuneFrameSize)
	RuneFrame:SetRunePositions(options.RunePositions)
	RuneFrame:SetRuneSizes(options.RuneSizes)
	RuneFrame:SetLocked(options.IsLocked)
end

function Engraved:Update()
	RuneFrame:UpdateMaxPower()
	RuneFrame:UpdatePower()
	RuneFrame:UpdateShown()
end

function Engraved:ToggleLockUnlock() 
	local isLocked = EngravedOptions.IsLocked
	if isLocked then
		RuneFrame:SetLocked(false)
	else
		RuneFrame:SetLocked(true)
	end
end

