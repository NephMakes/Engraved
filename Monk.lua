local _, Engraved = ...
Engraved.Monk = {};
local Monk = Engraved.Monk;
local RuneFrame  = EngravedRuneFrame;

function Engraved.Monk:Setup()
	RuneFrame.inUse = true;
	RuneFrame:RegisterUnitEvent("UNIT_POWER_FREQUENT", "player");
	RuneFrame:RegisterUnitEvent("UNIT_MAXPOWER", "player");
	RuneFrame.powerToken = "CHI";
	RuneFrame.UpdatePower = Monk.UpdateChi;
	RuneFrame.UpdateMaxPower = Monk.UpdateMaxChi;
end

function Monk:UpdateChi()
	local chi = UnitPower("player", Enum.PowerType.Chi);
	for i = 1, chi do
		if ( not self.Runes[i].on ) then
			self.Runes[i]:TurnOn();
		end
	end
	for i = chi + 1, #self.Runes do
		if ( self.Runes[i].inUse ) then
			if ( self.Runes[i].on ) then
				self.Runes[i]:TurnOff();
			elseif ( self.Runes[i].on == nil ) then
				self.Runes[i].fill:SetAlpha(0);
				self.Runes[i].glow:SetAlpha(0);
				self.Runes[i].on = false;
			end
		end
	end
end

function Monk:UpdateMaxChi()
	local maxChi = UnitPowerMax("player", Enum.PowerType.Chi);
	for i = 1, maxChi do
		self.Runes[i]:Show();
		self.Runes[i].inUse = true;
	end
	for i = maxChi + 1, #RuneFrame.Runes do
		self.Runes[i]:Hide();
		self.Runes[i].inUse = false;
	end
	self:UpdateSizeAndPosition();
end

