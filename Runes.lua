local _, Engraved = ...

local function round(x) 
	return floor(x + 0.5);
end


--[[ Rune Frame ]]--

local RuneFrame = EngravedRuneFrame;

function RuneFrame:OnEvent(event, ...)
	if ( event == "UNIT_POWER_FREQUENT" ) then
		local unit, powerToken = ...;
		if ( (unit == "player") and (self.powerToken == powerToken) ) then
			self:UpdatePower();
		end
	elseif ( event == "UNIT_MAXPOWER" ) then
		local unit, powerToken = ...;
		if ( (unit == "player") and (self.powerToken == powerToken) ) then
			self:UpdateMaxPower();
		end
	elseif ( event == "RUNE_POWER_UPDATE" ) then
		-- For death knights
		local runeIndex, usable = ...;
		self:UpdatePower();  -- So we can sort runes (not yet implemented)
		-- self:UpdateRune(runeIndex);
	elseif ( event == "RUNE_TYPE_UPDATE" ) then
		-- For death knights in classic, otherwise event not registered
		local runeIndex = ...;
		if ( runeIndex ) then
			self:UpdateRune(runeIndex);
		end
	elseif ( (event == "PLAYER_REGEN_DISABLED") and self.inUse ) then
		self:SetShown();
	elseif ( (event == "PLAYER_REGEN_ENABLED") and self.inUse ) then
		self:SetOutOfCombat();
	elseif ( event == "PLAYER_TARGET_CHANGED" ) then
		-- For rogues and druids in classic, otherwise event not registered
		self:UpdatePower();
	elseif ( event == "UNIT_DISPLAYPOWER" ) then
		local unit = ...;
		if ( unit == "player" ) then
			Engraved.Druid:OnShapeshift();
			self:UpdateShown();
		end
	elseif (event == "UNIT_ENTERED_VEHICLE") or (event == "PET_BATTLE_OPENING_START") then
		self:Hide();
	elseif (event == "UNIT_EXITED_VEHICLE") or (event == "PET_BATTLE_OVER") then
		self:UpdateShown();
	end
end
RuneFrame:SetScript("OnEvent", RuneFrame.OnEvent);

function RuneFrame:UpdatePower() end
function RuneFrame:UpdateMaxPower() end
-- These get replaced by class Setup() methods

function RuneFrame:UpdateShown()
	if ( not self.inUse ) then
		self:Hide();
	else
		self:Show();
		if ( not InCombatLockdown() ) then
			self:SetOutOfCombat();
		else
			self:SetShown();
		end
	end
end

function RuneFrame:SetShown()
	self:SetAlpha(1);
end

function RuneFrame:SetOutOfCombat()
	if ( self.isLocked ) then 
		self:SetAlpha(self.outOfCombatAlpha);
	else
		self:SetShown();
	end
end

function RuneFrame:SetOutOfCombatAlpha(outOfCombatAlpha)
	self.outOfCombatAlpha = outOfCombatAlpha;
end

function RuneFrame:SetRuneTheme(theme)
	local texturePath = "Interface\\AddOns\\Engraved\\";
	local themeIndex = {
		ICECROWN = 1, 
		NEXUS = 2, 
		ULDUAR = 3, 
		FROSTMOURNE = 4, 
		ELDRITCH = 5
	};
	for i, rune in pairs(self.Runes) do
		rune.background:SetTexture(texturePath.."RuneBackground");
		rune.fill:SetTexture(texturePath.."RuneFill");
		rune.charge:SetTexture(texturePath.."RuneFill");
		rune.glow:SetTexture(texturePath.."RuneGlow");
		rune.background:SetTexCoord((i-1)/8, i/8, (themeIndex[theme] - 1)/8, themeIndex[theme]/8);
		rune.fill:SetTexCoord((i-1)/8, i/8, (themeIndex[theme] - 1)/8, themeIndex[theme]/8);
		rune.charge:SetTexCoord((i-1)/8, i/8, (themeIndex[theme] - 1)/8, themeIndex[theme]/8);
		rune.glow:SetTexCoord((i-1)/8, i/8, (themeIndex[theme] - 1)/8, themeIndex[theme]/8);
	end
end

function RuneFrame:SetRuneColor(color)
	for _, rune in pairs(self.Runes) do
		-- rune.background:SetVertexColor(color.r, color.g, color.b);
		-- rune.fill:SetVertexColor(color.r, color.g, color.b);
		-- rune.charge:SetVertexColor(color.r, color.g, color.b);
		-- rune.glow:SetVertexColor(color.r, color.g, color.b);
		rune:SetRuneColor(color)
	end
end

function RuneFrame:SetPosition(point) 
	RuneFrame:ClearAllPoints();
	RuneFrame:SetPoint(unpack(point));
end

function RuneFrame:SetSize(size)
	-- Overwriting SetSize() for this frame to parallel SetPosition()
	local width, height = unpack(size);
	RuneFrame:SetWidth(width);
	RuneFrame:SetHeight(height);
end

function RuneFrame:SetRunePositions(runePositions) 
	for i, rune in pairs(self.Runes) do
		rune:ClearAllPoints();
		rune:SetPoint(unpack(runePositions[i]));
	end
end

function RuneFrame:SetRuneSizes(runeSizes) 
	for i, rune in pairs(self.Runes) do
		rune:SetSize(runeSizes[i], runeSizes[i]);
	end
end

function RuneFrame:SetLocked(isLocked) 
	self = RuneFrame;  -- If called from tab dropdown, self would be dropdown button
	EngravedOptions.IsLocked = isLocked; 
	self.isLocked = isLocked;
	if ( isLocked ) then
		self.Background:Hide();
		self.Border:Hide();
		self.Tab:Hide();
		self:EnableMouse(false);
		for _, rune in pairs(self.Runes) do
			rune:EnableMouse(false);
			rune.resizeButton:Hide();
		end
	else
		self.Background:Show();
		self.Border:Show();
		self.Tab:Show();
		self:EnableMouse(true);
		for _, rune in pairs(self.Runes) do
			rune:EnableMouse(true);
			rune.resizeButton:Show();
		end
	end
	self:UpdateShown();
end

function RuneFrame:OnDragStart()
	self:StartMoving();
end
RuneFrame:SetScript("OnDragStart", RuneFrame.OnDragStart);
RuneFrame.Tab:SetScript("OnDragStart", function() RuneFrame:OnDragStart() end);

function RuneFrame:OnDragStop()
	self:StopMovingOrSizing();
	self:SetUserPlaced(false);
	local point, relativeTo, relativePoint, xOfs, yOfs = self:GetPoint();
	xOfs, yOfs = round(xOfs), round(yOfs);
	EngravedOptions.RuneFramePosition = { point, relativeTo, relativePoint, xOfs, yOfs };
end
RuneFrame:SetScript("OnDragStop", RuneFrame.OnDragStop);
RuneFrame.Tab:SetScript("OnDragStop", function() RuneFrame:OnDragStop() end);

function RuneFrame:FitToRunes()
	local runeLeft, runeRight, runeTop, runeBottom = {}, {}, {}, {};
	for i, rune in pairs(self.Runes) do
		if ( rune.inUse ) then
			table.insert(runeLeft, rune:GetLeft());
			table.insert(runeRight, rune:GetRight());
			table.insert(runeBottom, rune:GetBottom());
			table.insert(runeTop, rune:GetTop());
		end
	end
	self:ClearAllPoints();
	if ( #runeLeft > 0 ) then  -- Function sometimes called when runeLeft == nil
		self:SetPoint("BOTTOMLEFT", nil, "BOTTOMLEFT", min(unpack(runeLeft)), min(unpack(runeBottom)));
		self:SetPoint("TOPRIGHT", nil, "BOTTOMLEFT", max(unpack(runeRight)), max(unpack(runeTop)));
	end
end

function RuneFrame:SaveSizeAndPosition()
	local width, height = round(self:GetWidth()), round(self:GetHeight());
	local xPos = round(self:GetLeft() + width/2);
	local yPos = round(self:GetBottom() + height/2);
	EngravedOptions.RuneFramePosition = {"CENTER", nil, "BOTTOMLEFT", xPos, yPos};
	EngravedOptions.RuneFrameSize = {width, height};
end

function RuneFrame:SaveRunePositions()
	local runeFrameX = round(self:GetLeft() + self:GetWidth()/2);
	local runeFrameY = round(self:GetBottom() + self:GetHeight()/2);
	local runeX, runeY;
	for i, rune in pairs(self.Runes) do
		runeX = round(rune:GetLeft() + rune:GetWidth()/2);
		runeY = round(rune:GetBottom() + rune:GetHeight()/2);
		EngravedOptions.RunePositions[i] = {"CENTER", runeX - runeFrameX, runeY - runeFrameY};
	end
end

function RuneFrame:UpdateSizeAndPosition()
	for _, rune in pairs(self.Runes) do
		rune:AnchorToScreen();
	end
	self:FitToRunes();
	self:SaveSizeAndPosition();
	self:SetPosition(EngravedOptions.RuneFramePosition);
	self:SetSize(EngravedOptions.RuneFrameSize);
	self:SaveRunePositions();
	self:SetRunePositions(EngravedOptions.RunePositions);
end

function RuneFrame:Tab_OnClick(button)
	PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON);
	if ( button == "RightButton" ) then
		ToggleDropDownMenu(1, nil, EngravedRuneFrameTabDropDown, self:GetName(), 0, 0);
		return;
	end
	CloseDropDownMenus();
end

function RuneFrame:InitializeTabDropDown()

	local strings = Engraved.Strings;
	local info = UIDropDownMenu_CreateInfo();

	info.text = strings.LOCK_RUNE_DISPLAY;
	info.func = RuneFrame.SetLocked;
	info.arg1 = true;
	info.isNotRadio = true;
	info.notCheckable = true;
	UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

	--[[
	info.text = strings.OPEN_OPTIONS_MENU;
	info.func = nil;
	info.isNotRadio = true;
	info.notCheckable = true;
	UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);

	info.text = strings.RESET_POSITIONS;
	info.func = nil;
	info.isNotRadio = true;
	info.notCheckable = true;
	UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
	]]--

end


--[[ Runes ]]--

Engraved.Rune = {};
local Rune = Engraved.Rune;

function Rune:SetRuneColor(color)
	self.background:SetVertexColor(color.r, color.g, color.b);
	self.fill:SetVertexColor(color.r, color.g, color.b);
	self.charge:SetVertexColor(color.r, color.g, color.b);
	self.glow:SetVertexColor(color.r, color.g, color.b);
end


function Rune:TurnOn()
	self.animOut:Stop();
	if ( not self.animIn:IsPlaying() ) then
		self.animIn:Play();
	end
	self.on = true;
end

function Rune:TurnOff()
	self.animIn:Stop();
	if ( not self.animOut:IsPlaying() ) then
		self.animOut:Play();
	end
	self.on = false;
end

function Rune:ChargeUp()
	self.animChargeDown:Stop();
	if ( not self.animChargeUp:IsPlaying() ) then
		self.animChargeUp:Play();
	end
end

function Rune:ChargeDown()
	self.animChargeUp:Stop();
	if ( not self.animChargeDown:IsPlaying() ) then
		self.animChargeDown:Play();
	end
end

function Rune:OnEnter()
	self.Border:Show();
	self.resizeButton:SetAlpha(1);
	GameTooltip_SetDefaultAnchor(GameTooltip, self);
	GameTooltip:SetText(Engraved.Strings.RUNE.." "..self:GetID());
	GameTooltip:Show();
end

function Rune:OnLeave()
	self.Border:Hide();
	self.resizeButton:SetAlpha(0);
	GameTooltip:Hide();
end

function Rune:ResizeButtonOnEnter()
	self:GetParent().Border:Show();
	self:SetAlpha(1);
end

function Rune:ResizeButtonOnLeave()
	self:GetParent().Border:Hide();
	self:SetAlpha(0);
end

function Rune:OnDragStart()
	local runeFrame = self:GetParent();
	for _, rune in pairs(runeFrame.Runes) do
		rune:AnchorToScreen();
	end
	runeFrame:SetScript("OnUpdate", RuneFrame.FitToRunes);
	self:StartMoving();
end

function Rune:AnchorToScreen()
	local xOfs = self:GetLeft() + self:GetWidth()/2;
	local yOfs = self:GetBottom() + self:GetHeight()/2;
	self:ClearAllPoints();
	self:SetPoint("CENTER", UIParent, "BOTTOMLEFT", xOfs, yOfs);
end

function Rune:OnDragStop()
	self:StopMovingOrSizing();
	self:SetUserPlaced(false);	-- So client won't mess with frame

	local runeFrame = self:GetParent();
	runeFrame:SetScript("OnUpdate", nil);
	runeFrame:SaveSizeAndPosition();
	runeFrame:SetPosition(EngravedOptions.RuneFramePosition);
	runeFrame:SetSize(EngravedOptions.RuneFrameSize);

	runeFrame:SaveRunePositions();
	runeFrame:SetRunePositions(EngravedOptions.RunePositions);
end

function Rune:OnResizeStart()
	self:SetButtonState("PUSHED", true);
	self:GetHighlightTexture():Hide();
	local runeFrame = RuneFrame;
	for _, rune in pairs(runeFrame.Runes) do
		rune:AnchorToScreen();
	end
	runeFrame:SetScript("OnUpdate", RuneFrame.FitToRunes);
	self:SetScript("OnUpdate", Rune.OnResize);
end

function Rune:OnResize()
	local rune = self:GetParent();
	local mouseX, mouseY = GetCursorPosition();
	mouseX, mouseY = mouseX / UIParent:GetScale(), mouseY / UIParent:GetScale();
	local runeX = rune:GetLeft() + rune:GetWidth()/2;
	local runeY = rune:GetBottom() + rune:GetHeight()/2;
	local newSize = max( 32, 2*(mouseX-runeX+4), 2*(runeY-mouseY+4) );  -- +4 prevents flicker
	newSize = min(newSize, 150);
	rune:SetSize(newSize, newSize);
end

function Rune:OnResizeStop()
	self:SetButtonState("NORMAL", false);
	self:GetHighlightTexture():Show();
	self:SetScript("OnUpdate", nil);
	EngravedOptions.RuneSizes[self:GetParent():GetID()] = self:GetParent():GetWidth();

	local runeFrame = RuneFrame;
	runeFrame:SetScript("OnUpdate", nil);
	runeFrame:SaveSizeAndPosition();
	runeFrame:SetPosition(EngravedOptions.RuneFramePosition);
	runeFrame:SetSize(EngravedOptions.RuneFrameSize);

	runeFrame:SaveRunePositions();
	runeFrame:SetRunePositions(EngravedOptions.RunePositions);
end

for _, rune in pairs(RuneFrame.Runes) do
	rune.SetRuneColor  = Rune.SetRuneColor;
	rune.TurnOn  = Rune.TurnOn;
	rune.TurnOff = Rune.TurnOff;
	rune.ChargeUp  = Rune.ChargeUp;
	rune.ChargeDown = Rune.ChargeDown;
	rune.AnchorToScreen = Rune.AnchorToScreen;
	rune:SetScript("OnEnter", Rune.OnEnter);
	rune:SetScript("OnLeave", Rune.OnLeave);
	rune:SetScript("OnDragStart", Rune.OnDragStart);
	rune:SetScript("OnDragStop", Rune.OnDragStop);
	rune.resizeButton:SetScript("OnEnter", Rune.ResizeButtonOnEnter);
	rune.resizeButton:SetScript("OnLeave", Rune.ResizeButtonOnLeave);
	rune.resizeButton:SetScript("OnDragStart", Rune.OnResizeStart);
	rune.resizeButton:SetScript("OnDragStop", Rune.OnResizeStop);
end


