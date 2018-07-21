local addonName, Engraved = ...

Engraved.EngravedFrame = CreateFrame("Frame", "EngravedFrame");
local EngravedFrame    = Engraved.EngravedFrame;
local RuneFrame        = EngravedRuneFrame;

function EngravedFrame:OnEvent(event, ...)
	if ( event == "ADDON_LOADED" ) then
		local arg1 = ...;
		if ( arg1 == addonName ) then
			Engraved:OnAddonLoaded();
		end
	elseif ( event == "PLAYER_ENTERING_WORLD" ) then 
		Engraved:SetupClass();
		Engraved:ApplyOptions();
		Engraved:Update();
	elseif ( event == "PLAYER_SPECIALIZATION_CHANGED" ) then 
		Engraved:SetupClass();
		Engraved:ApplyOptions();
		Engraved:Update();
	elseif ( event == "PLAYER_TALENT_UPDATE" ) then 
		Engraved:ApplyOptions();
		Engraved:Update();
	elseif ( event == "PLAYER_LEVEL_UP" ) then 
		local arg1 = ...;
		if ( arg1 >= PALADINPOWERBAR_SHOW_LEVEL ) then
			Engraved:Update();
			self:UnregisterEvent("PLAYER_LEVEL_UP");
		end
	end
end
EngravedFrame:SetScript("OnEvent", EngravedFrame.OnEvent);
EngravedFrame:RegisterEvent("ADDON_LOADED");
EngravedFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
EngravedFrame:RegisterUnitEvent("PLAYER_SPECIALIZATION_CHANGED", "player");
EngravedFrame:RegisterEvent("PLAYER_TALENT_UPDATE");

function Engraved:OnAddonLoaded()
	Engraved:LocalizeStrings();
	UIDropDownMenu_Initialize(EngravedRuneFrameTabDropDown, EngravedRuneFrame.InitializeTabDropDown, "MENU");

	local _, class = UnitClass("player"); 
	Engraved:SetClassDefaults(class); 

	local reset = false;
	if (EngravedOptions) and (EngravedOptions.Version) and (EngravedOptions.Version < "2.0") then 
		reset = true;
	end
	Engraved:UpdateOptions("EngravedOptions", Engraved.Defaults, reset); 
end

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
	elseif ( class == "MAGE" ) and ( spec == SPEC_MAGE_ARCANE ) then
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

function Engraved:ApplyOptions()
	local options = EngravedOptions;
	RuneFrame:SetRuneTheme(options.RuneTheme);
	RuneFrame:SetRuneColor(options.RuneColor);
	RuneFrame:SetOutOfCombatAlpha(options.OutOfCombatAlpha);
	RuneFrame:SetPosition(options.RuneFramePosition);
	RuneFrame:SetSize(options.RuneFrameSize);
	RuneFrame:SetRunePositions(options.RunePositions);
	RuneFrame:SetRuneSizes(options.RuneSizes);
	RuneFrame:SetLocked(options.IsLocked);
end

function Engraved:Update()
	RuneFrame:UpdateMaxPower();
	RuneFrame:UpdatePower();
	RuneFrame:UpdateShown();
end



