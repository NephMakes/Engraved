local _, Engraved = ...
Engraved.Mage = {};
local Mage = Engraved.Mage;
local RuneFrame  = EngravedRuneFrame;

function Mage:Setup()
	RuneFrame.inUse = true;
	RuneFrame:RegisterUnitEvent("UNIT_POWER_FREQUENT", "player");
	RuneFrame.powerToken = "ARCANE_CHARGES";
	RuneFrame.UpdatePower = Mage.UpdateArcaneCharges;
	for i = 1, 4 do
		RuneFrame.Runes[i]:Show();
		RuneFrame.Runes[i].inUse = true;
	end
	for i = 5, #RuneFrame.Runes do
		RuneFrame.Runes[i]:Hide();
		RuneFrame.Runes[i].inUse = false;
	end
end

function Mage:UpdateArcaneCharges()
	local charges = UnitPower("player", Enum.PowerType.ArcaneCharges);
	for i = 1, charges do
		if ( not self.Runes[i].on ) then
			self.Runes[i]:TurnOn();
		end
	end
	for i = charges + 1, 4 do
		if ( self.Runes[i].on ) then
			self.Runes[i]:TurnOff();
		elseif ( self.Runes[i].on == nil ) then 
			self.Runes[i].fill:SetAlpha(0);
			self.Runes[i].glow:SetAlpha(0);
			self.Runes[i].on = false;
		end
	end
end


