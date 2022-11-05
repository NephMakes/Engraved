local _, Engraved = ...
Engraved.DeathKnight = {};
local DeathKnight = Engraved.DeathKnight;
local RuneFrame  = EngravedRuneFrame;

function DeathKnight:Setup()
	RuneFrame.inUse = true;
	RuneFrame:RegisterEvent("RUNE_POWER_UPDATE");
	if RuneFrame.isClassic then
		RuneFrame:RegisterEvent("RUNE_TYPE_UPDATE");
	end
	RuneFrame.powerToken = "RUNES";
	RuneFrame.UpdatePower = DeathKnight.UpdateRunes;
	RuneFrame.UpdateRune = DeathKnight.UpdateRune;
	for i = 1, 6 do
		local rune = RuneFrame.Runes[i];
		rune:Show();
		rune.on = true;
		rune.inUse = true;
	end
	for i = 7, #RuneFrame.Runes do
		RuneFrame.Runes[i]:Hide();
		RuneFrame.Runes[i].inUse = false;
	end
end

function DeathKnight:UpdateRunes()
	-- self is RuneFrame
	for runeIndex = 1, 6 do
		self:UpdateRune(runeIndex);
	end
end

local runeColor = {
	[1] = { r = 1.0, g = 0.2, b = 0.0 },  -- Blood
	[2] = { r = 0.5, g = 0.8, b = 1.0 },  -- Frost
	[3] = { r = 0.3, g = 1.0, b = 0.4 },  -- Unholy
	[4] = { r = 0.50, g = 0.32, b = 0.55 },  -- Death
}

function DeathKnight:UpdateRune(runeIndex)
	-- self is RuneFrame
	local rune = self.Runes[runeIndex];
	local start, duration, runeReady = GetRuneCooldown(runeIndex);
	-- print(GetTime(), "Rune", runeIndex, start, duration, runeReady);
	-- print("runeIndex", runeIndex);

	if self.isClassic then
		local runeType = GetRuneType(runeIndex)
		if runeType then
			rune.runeType = runeType
			rune:SetRuneColor(runeColor[runeType])
		end
	end

	if ( runeReady and not rune.on ) then
		rune:TurnOn();
		rune:ChargeDown();
	elseif ( not runeReady ) then
		if ( rune.on ) then
			rune:TurnOff();
		end
		if ( start ) then
			rune.animChargeUp.hold:SetDuration(max(start - GetTime(), 0));
			rune.animChargeUp.charge:SetDuration(duration);
			rune:ChargeUp();
		end
	end
end






