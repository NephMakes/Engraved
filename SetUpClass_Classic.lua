-- Set up Engraved for classic WoW

local addonName, Engraved = ...

local RuneFrame = EngravedRuneFrame;

function Engraved:SetupClass()
	RuneFrame:RegisterEvent("PLAYER_REGEN_DISABLED");
	RuneFrame:RegisterEvent("PLAYER_REGEN_ENABLED");
	RuneFrame:RegisterUnitEvent("UNIT_ENTERED_VEHICLE", "player");
	RuneFrame:RegisterUnitEvent("UNIT_EXITED_VEHICLE", "player");

	local _, class = UnitClass("player");
	if ( class == "DEATHKNIGHT" ) then
		Engraved.DeathKnight:Setup();
	elseif ( class == "ROGUE" ) then
		Engraved.Rogue:Setup();
	elseif ( class == "DRUID" ) then
		Engraved.Druid:Setup();  
	else
		RuneFrame.inUse = false;
		RuneFrame:UnregisterAllEvents();
	end

	RuneFrame.isClassic = true;  -- For conditionals in class functions
end
