local addonName, Engraved = ...

local RuneFrame = EngravedRuneFrame;

function Engraved:SetupClass()
	RuneFrame:RegisterEvent("PLAYER_REGEN_DISABLED");
	RuneFrame:RegisterEvent("PLAYER_REGEN_ENABLED");
	RuneFrame:RegisterUnitEvent("UNIT_ENTERED_VEHICLE", "player");
	RuneFrame:RegisterUnitEvent("UNIT_EXITED_VEHICLE", "player");
	RuneFrame:RegisterEvent("PET_BATTLE_OPENING_START");
	RuneFrame:RegisterEvent("PET_BATTLE_OVER");

	local _, class = UnitClass("player");
	if ( class == "DEATHKNIGHT" ) then
		-- NOT YET IMPLEMENTED
		-- Engraved.DeathKnight:Setup();
	elseif ( class == "ROGUE" ) then
		Engraved.Rogue:Setup();
		RuneFrame:RegisterUnitEvent("PLAYER_TARGET_CHANGED");
	elseif ( class == "DRUID" ) then
		-- NOT YET IMPLEMENTED (needs shapeshift behavior)
		-- Engraved.Druid:Setup();
		-- RuneFrame:RegisterUnitEvent("PLAYER_TARGET_CHANGED");
	else
		RuneFrame.inUse = false;
		RuneFrame:UnregisterAllEvents();
	end
end
