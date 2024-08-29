local addonName, Engraved = ...

local EngravedFrame = Engraved.EngravedFrame;
local RuneFrame     = EngravedRuneFrame;

EngravedFrame:RegisterUnitEvent("PLAYER_SPECIALIZATION_CHANGED", "player");
-- Event not in Classic

function Engraved:SetupClass()
	RuneFrame:RegisterEvent("PLAYER_REGEN_DISABLED");
	RuneFrame:RegisterEvent("PLAYER_REGEN_ENABLED");
	RuneFrame:RegisterUnitEvent("UNIT_ENTERED_VEHICLE", "player");
	RuneFrame:RegisterUnitEvent("UNIT_EXITED_VEHICLE", "player");
	RuneFrame:RegisterEvent("PET_BATTLE_OPENING_START");
	RuneFrame:RegisterEvent("PET_BATTLE_OVER");

	local _, class = UnitClass("player");
	local spec = GetSpecialization();
	if ( class == "DEATHKNIGHT" ) then
		Engraved.DeathKnight:Setup();
	elseif ( class == "ROGUE" ) then
		Engraved.Rogue:Setup();
	elseif ( class == "DRUID" ) then
		Engraved.Druid:Setup();
	elseif ( class == "WARLOCK" ) then
		Engraved.Warlock:Setup();
	elseif ( class == "MAGE" ) then
		Engraved.Mage:Setup();
	elseif ( class == "PALADIN" ) and ( spec == SPEC_PALADIN_RETRIBUTION ) then
		Engraved.Paladin:Setup();
	elseif ( class == "MONK" ) and ( spec == SPEC_MONK_WINDWALKER ) then
		Engraved.Monk:Setup();
	else
		RuneFrame.inUse = false;
		RuneFrame:UnregisterAllEvents();
	end
end
