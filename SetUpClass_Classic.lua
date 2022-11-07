-- Set up Engraved for classic WoW

local addonName, Engraved = ...

local RuneFrame = EngravedRuneFrame

function Engraved:SetupClass()
	RuneFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
	RuneFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
	RuneFrame:RegisterUnitEvent("UNIT_ENTERED_VEHICLE", "player")
	RuneFrame:RegisterUnitEvent("UNIT_EXITED_VEHICLE", "player")

	local _, class = UnitClass("player")
	if class == "DEATHKNIGHT" then
		Engraved.DeathKnight:Setup()
		Engraved.DeathKnight:SetupClassic()
		Engraved:ShowClassicRuneColorOptions()
	elseif class == "ROGUE" then
		Engraved.Rogue:Setup()
		Engraved.Rogue:SetupClassic()
	elseif class == "DRUID" then
		Engraved.Druid:Setup()
		Engraved.Druid:SetupClassic()
	else
		RuneFrame.inUse = false
		RuneFrame:UnregisterAllEvents()
	end
end

function Engraved:ShowClassicRuneColorOptions()
	local optionsPanel = Engraved.OptionsPanel
	optionsPanel.runeColor:Hide()
	optionsPanel.runeColorBlood:Show()
	optionsPanel.runeColorFrost:Show()
	optionsPanel.runeColorUnholy:Show()
	optionsPanel.runeColorDeath:Show()
end
