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
		-- Only for retail WoW. Event not registered in classic. 
		Engraved:SetupClass();
		Engraved:ApplyOptions();
		Engraved:Update();
	elseif ( event == "PLAYER_TALENT_UPDATE" ) or ( event == "CHARACTER_POINTS_CHANGED" ) then 
		Engraved:ApplyOptions();
		Engraved:Update();
	elseif ( event == "PLAYER_LEVEL_UP" ) then 
		-- For Paladins in retail WoW. Otherwise event not registered. 
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

if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
	-- Classic Era
	EngravedFrame:RegisterEvent("CHARACTER_POINTS_CHANGED");
else
	-- Retail, Classic Wrath
	EngravedFrame:RegisterEvent("PLAYER_TALENT_UPDATE");
end
-- EngravedFrame:RegisterUnitEvent("PLAYER_SPECIALIZATION_CHANGED", "player"); 
-- See SetUpClass_Retail.lua

function Engraved:OnAddonLoaded()
	Engraved:LocalizeStrings();
	UIDropDownMenu_Initialize(EngravedRuneFrameTabDropDown, EngravedRuneFrame.InitializeTabDropDown, "MENU");

	local _, class = UnitClass("player"); 
	Engraved:SetClassDefaults(class); 

	local reset = false
	if EngravedOptions and EngravedOptions.Version and EngravedOptions.Version < "2.0" then 
		reset = true
	end
	Engraved:UpdateOptions("EngravedOptions", Engraved.Defaults, reset);
end

-- function Engraved:SetupClass() end
-- See SetUpClass_Retail.lua, SetUpClass_Classic.lua

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



