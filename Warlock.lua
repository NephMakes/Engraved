local _, Engraved = ...
Engraved.Warlock = {};
local Warlock = Engraved.Warlock;
local RuneFrame  = EngravedRuneFrame;

function Engraved.Warlock:Setup()
	RuneFrame.inUse = true;
	RuneFrame.powerToken = "SOUL_SHARDS";
	RuneFrame:RegisterUnitEvent("UNIT_POWER_FREQUENT", "player");
	RuneFrame.UpdatePower = Warlock.UpdateSoulShards;
	for i = 1, 5 do
		RuneFrame.Runes[i].inUse = true;
		RuneFrame.Runes[i]:Show();
	end
	for i = 6, #RuneFrame.Runes do
		RuneFrame.Runes[i].inUse = false;
		RuneFrame.Runes[i]:Hide();
	end
end

function Warlock:UpdateSoulShards()
	local shards = UnitPower("player", Enum.PowerType.SoulShards);
	for i = 1, shards do
		if ( not self.Runes[i].on ) then
			self.Runes[i]:TurnOn();
		end
	end
	for i = shards + 1, 5 do
		if ( self.Runes[i].on ) then
			self.Runes[i]:TurnOff();
		elseif ( self.Runes[i].on == nil ) then
			self.Runes[i].fill:SetAlpha(0);
			self.Runes[i].glow:SetAlpha(0);
			self.Runes[i].on = false;
		end
	end
end

