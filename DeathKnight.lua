local _, Engraved = ...
Engraved.DeathKnight = {};
local DeathKnight = Engraved.DeathKnight;
local RuneFrame  = EngravedRuneFrame;

function DeathKnight:Setup()
	RuneFrame.inUse = true;
	RuneFrame:RegisterEvent("RUNE_POWER_UPDATE");
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

-- Not yet implemented: 
function DeathKnight:SetupClassic()
	RuneFrame.inUse = true;
	RuneFrame:RegisterEvent("RUNE_POWER_UPDATE");
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
	for runeIndex = 1, 6 do
		self:UpdateRune(runeIndex);
	end
end

function DeathKnight:UpdateRune(runeIndex)
	local rune = self.Runes[runeIndex];
	local start, duration, runeReady = GetRuneCooldown(runeIndex);
	-- print(GetTime(), "Rune", runeIndex, start, duration, runeReady);
	-- print("runeIndex", runeIndex);

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






