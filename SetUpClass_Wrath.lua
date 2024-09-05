-- Set up Engraved for classic WoW

local addonName, Engraved = ...

local RuneFrame = EngravedRuneFrame

function Engraved:SetupClass()
	local _, class = UnitClass("player")
	if class == "DEATHKNIGHT" then
		Engraved.DeathKnight:Setup()
		Engraved.DeathKnight:SetupClassic()
		Engraved.DeathKnight:ShowClassicRuneColorOptions()
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
