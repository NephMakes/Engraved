-- Set up Engraved for retail WoW

local addonName, Engraved = ...

local EngravedFrame = Engraved.EngravedFrame
local RuneFrame = EngravedRuneFrame

local GetSpecialization = GetSpecialization or GetPrimaryTalentTree

function Engraved:SetupClass()
	local _, class = UnitClass("player")
	local spec = GetSpecialization()
	if class == "DEATHKNIGHT" then
		Engraved.DeathKnight:Setup()
	elseif class == "ROGUE" then
		Engraved.Rogue:Setup()
	elseif class == "DRUID" then
		Engraved.Druid:Setup()
	elseif class == "WARLOCK" then
		Engraved.Warlock:Setup()
	elseif class == "MAGE" then
		Engraved.Mage:Setup()
	elseif class == "PALADIN" then
		Engraved.Paladin:Setup()
	elseif class == "MONK" and spec == SPEC_MONK_WINDWALKER then
		Engraved.Monk:Setup()
	elseif class == "EVOKER" then
		Engraved.Evoker:Setup()
	else
		RuneFrame.inUse = false
		RuneFrame:UnregisterAllEvents()
	end
end
