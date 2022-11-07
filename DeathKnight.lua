local _, Engraved = ...
Engraved.DeathKnight = {};
local DeathKnight = Engraved.DeathKnight;
local RuneFrame = EngravedRuneFrame;

local GetTime = GetTime

function DeathKnight:Setup()
	RuneFrame.inUse = true;
	RuneFrame:RegisterEvent("RUNE_POWER_UPDATE");
	RuneFrame.powerToken = "RUNES";
	RuneFrame.UpdatePower = DeathKnight.UpdateRunes;
	RuneFrame.UpdateRune = DeathKnight.UpdateRune;
	RuneFrame.UpdateRuneType = DeathKnight.UpdateRuneType;
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

function DeathKnight:SetupClassic()
	RuneFrame:RegisterEvent("RUNE_TYPE_UPDATE")
	RuneFrame.UpdateRune = DeathKnight.UpdateRuneClassic
	RuneFrame.SetRuneColor = DeathKnight.SetRuneColorClassic
	local options = EngravedOptions
	RuneFrame.runeColor = {}
	RuneFrame.runeColor[1] = options.RuneColorBlood
	RuneFrame.runeColor[2] = options.RuneColorFrost
	RuneFrame.runeColor[3] = options.RuneColorUnholy
	RuneFrame.runeColor[4] = options.RuneColorDeath
end

function DeathKnight:SetRuneTypeColor(runeType, runeColor)
	-- Called by optionsPanel.runeColorXXXX
	RuneFrame.runeColor[runeType] = runeColor
	RuneFrame:SetRuneColor()
end

function DeathKnight:SetRuneColorClassic(runeColorRetail)
	-- self is RuneFrame
	-- Called by Engraved:ApplyOptions() when entering world or talents changed
	-- Called by DeathKnight:SetRuneTypeColor() when user changes rune color
	for runeIndex, rune in pairs(self.Runes) do
		self:UpdateRuneType(runeIndex)
	end	
end


--[[ Combat functions ]]--

function DeathKnight:UpdateRunes()
	-- self is RuneFrame
	for runeIndex = 1, 6 do
		self:UpdateRuneType(runeIndex);
		self:UpdateRune(runeIndex);
	end
end

function DeathKnight:UpdateRune(runeIndex)
	-- self is RuneFrame
	local rune = self.Runes[runeIndex];
	local start, duration, runeReady = GetRuneCooldown(runeIndex);
	if runeReady and not rune.on then
		rune:TurnOn()
		rune:ChargeDown()
	elseif not runeReady then
		if rune.on then
			rune:TurnOff()
		end
		if start then
			rune.animChargeUp.hold:SetDuration(max(start - GetTime(), 0))
			rune.animChargeUp.charge:SetDuration(duration)
			-- In retail, runes can wait to start cooling down
			rune:ChargeUp()
		end
	end
end

function DeathKnight:UpdateRuneClassic(runeIndex)
	-- self is RuneFrame
	local rune = self.Runes[runeIndex];
	local start, duration, runeReady = GetRuneCooldown(runeIndex);
	if runeReady and not rune.on then
		rune:TurnOn()
		rune:ChargeDown()
	elseif not runeReady then
		if rune.on then
			rune:TurnOff()
		end
		if start then
			rune.animChargeUp.hold:SetDuration(0)
			rune.animChargeUp.charge:SetDuration(start + duration - GetTime())
			rune:ChargeUp()
		end
	end
end

function DeathKnight:UpdateRuneType(runeIndex)
	-- self is RuneFrame
	local runeType = GetRuneType(runeIndex)
	if runeType then
		local rune = self.Runes[runeIndex];
		rune.runeType = runeType
		rune:SetRuneColor(self.runeColor[runeType])
	end
end



