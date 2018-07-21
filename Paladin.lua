local _, Engraved = ...
Engraved.Paladin = {};
local Paladin = Engraved.Paladin;
local RuneFrame  = EngravedRuneFrame;

function Paladin:Setup()
	RuneFrame.inUse = true;
	EngravedFrame:RegisterEvent("PLAYER_LEVEL_UP"); 
	RuneFrame:RegisterUnitEvent("UNIT_POWER_FREQUENT", "player");
	RuneFrame:RegisterUnitEvent("UNIT_MAXPOWER", "player");
	RuneFrame.powerToken = "HOLY_POWER";
	RuneFrame.UpdateMaxPower = Paladin.UpdateMaxHolyPower;
	RuneFrame.UpdatePower = Paladin.UpdateHolyPower;
end

function Paladin:UpdateHolyPower()
	local holyPower = UnitPower("player", Enum.PowerType.HolyPower);
	for i = 1, holyPower do
		if ( not self.Runes[i].on ) then
			self.Runes[i]:TurnOn();
		end
	end
	for i = holyPower + 1, #self.Runes do
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

function Paladin:UpdateMaxHolyPower()
	local maxHolyPower = UnitPowerMax("player", Enum.PowerType.HolyPower);
	for i = 1, maxHolyPower do
		self.Runes[i]:Show();
		self.Runes[i].inUse = true;
	end
	for i = maxHolyPower + 1, #RuneFrame.Runes do
		self.Runes[i]:Hide();
		self.Runes[i].inUse = false;
	end
	self:UpdateSizeAndPosition();
end


