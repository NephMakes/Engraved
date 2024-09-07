-- Engraved: Track class combat resources with Warcraft rune art
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
local RuneFrame = Engraved.RuneFrame


function Engraved:Update()
	-- TODO: Update OptionsPanel, etc here
	RuneFrame:Update()
end

function Engraved:ToggleLockUnlock() 
	-- Called by Engraved.SlashCommand()
	local isLocked = EngravedOptions.IsLocked
	if isLocked then
		RuneFrame:SetLocked(false)
	else
		RuneFrame:SetLocked(true)
	end
end


--[[ EngravedFrame ]]--

-- Handles executive events like class, expansion, etc

function EngravedFrame:OnLoad()
	self:SetScript("OnEvent", EngravedFrame.OnEvent)

	self:RegisterEvent("ADDON_LOADED")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("PLAYER_LEVEL_UP")

	if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
		self:RegisterEvent("CHARACTER_POINTS_CHANGED")
	else
		self:RegisterUnitEvent("PLAYER_SPECIALIZATION_CHANGED", "player")
		self:RegisterEvent("PLAYER_TALENT_UPDATE")
	end
end

function EngravedFrame:OnEvent(event, ...)
	local f = self[event]
	if f then
		f(self, ...)
	end
end

function EngravedFrame:ADDON_LOADED(addonName)
	if addonName ~= ENGRAVED then return end
	self:OnAddonLoaded()
	self:UnregisterEvent("ADDON_LOADED")
end

function EngravedFrame:OnAddonLoaded()
	Engraved:LocalizeStrings()
	Engraved:AddSlashCommand()

	local _, class = UnitClass("player")
	Engraved:SetClassDefaults(class)

	local reset = false
	if EngravedOptions and EngravedOptions.Version and EngravedOptions.Version < "2.0" then 
		reset = true
	end
	Engraved:UpdateOptions("EngravedOptions", Engraved.Defaults, reset)

	RuneFrame:OnLoad()
end

function EngravedFrame:PLAYER_ENTERING_WORLD()
	Engraved:Update()
end
			
function EngravedFrame:PLAYER_LEVEL_UP()
	Engraved:Update()
end

function EngravedFrame:PLAYER_SPECIALIZATION_CHANGED()
	Engraved:Update()
end
			
function EngravedFrame:PLAYER_TALENT_UPDATE()
	Engraved:Update()
end
			
function EngravedFrame:CHARACTER_POINTS_CHANGED()
	Engraved:Update()
end
			
do
	EngravedFrame:OnLoad()
end

