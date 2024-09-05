-- Set up Engraved for classic WoW

local addonName, Engraved = ...

local RuneFrame = EngravedRuneFrame

function Engraved:SetupClass()
	local _, class = UnitClass("player")
	if class == "DEATHKNIGHT" then
		Engraved.DeathKnight:Setup()
		Engraved.DeathKnight:SetupCataclysm()
		Engraved.DeathKnight:ShowClassicRuneColorOptions()
	elseif class == "ROGUE" then
		Engraved.Rogue:Setup()
		Engraved.Rogue:SetupClassic()
	elseif class == "DRUID" then
		Engraved.Druid:Setup()
		Engraved.Druid:SetupClassic()
	elseif class == "PALADIN" then
		Engraved.Paladin:Setup()
	elseif class == "WARLOCK" then
		Engraved.Warlock:Setup()
	else
		RuneFrame.inUse = false
		RuneFrame:UnregisterAllEvents()
	end
end
