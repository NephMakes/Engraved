local _, Engraved = ...
local RuneFrame = EngravedRuneFrame;


--[[ Rogue ]]--

Engraved.Rogue = {};
local Rogue = Engraved.Rogue;

function Rogue:Setup()
	RuneFrame.inUse = true;
	RuneFrame:RegisterUnitEvent("UNIT_POWER_FREQUENT", "player");
	RuneFrame:RegisterUnitEvent("UNIT_MAXPOWER", "player");
	RuneFrame.powerToken = "COMBO_POINTS";
	RuneFrame.UpdatePower = Rogue.UpdateComboPoints;
	RuneFrame.UpdateMaxPower = Rogue.UpdateMaxComboPoints;
end

function Rogue:SetupClassic()
	RuneFrame:RegisterEvent("PLAYER_TARGET_CHANGED"); -- Combo points stored on target
	RuneFrame.isClassic = true
end

function Rogue:UpdateComboPoints()
	-- self is RuneFrame
	local comboPoints
	if self.isClassic then
		comboPoints = GetComboPoints("player", "target");
	else
		comboPoints = UnitPower("player", Enum.PowerType.ComboPoints);
	end
	for i = 1, comboPoints do
		if ( not self.Runes[i].on ) then
			self.Runes[i]:TurnOn();
		end
	end
	for i = comboPoints + 1, #self.Runes do
		if ( self.Runes[i].inUse ) then
			if ( self.Runes[i].on ) then
				self.Runes[i]:TurnOff();
			elseif ( self.Runes[i].on == nil ) then
				-- self.Runes[i]:TurnOff();
				self.Runes[i].fill:SetAlpha(0);
				self.Runes[i].glow:SetAlpha(0);
				self.Runes[i].on = false;
			end
		end
	end
end

function Rogue:UpdateMaxComboPoints()
	-- self is RuneFrame
	local maxComboPoints = UnitPowerMax("player", Enum.PowerType.ComboPoints);
	for i = 1, maxComboPoints do
		self.Runes[i]:Show();
		self.Runes[i].inUse = true;
	end
	for i = maxComboPoints + 1, #self.Runes do
		self.Runes[i]:Hide();
		self.Runes[i].inUse = false;
	end
	self:UpdateSizeAndPosition();
end


--[[ Druid ]]--

Engraved.Druid = {};
local Druid = Engraved.Druid;

function Druid:Setup()
	RuneFrame:RegisterUnitEvent("UNIT_DISPLAYPOWER", "player");
	RuneFrame.powerToken = "COMBO_POINTS";
	RuneFrame.UpdatePower = Rogue.UpdateComboPoints;
	RuneFrame.UpdateMaxPower = Rogue.UpdateMaxComboPoints;
	Druid:OnShapeshift()
end

function Druid:SetupClassic()
	RuneFrame:RegisterEvent("PLAYER_TARGET_CHANGED"); -- Combo points stored on target
	RuneFrame.isClassic = true
end

function Druid:OnShapeshift()
	local powerType, powerToken = UnitPowerType("player");
	if ( powerType == Enum.PowerType.Energy ) then
		RuneFrame.inUse = true;
		RuneFrame:RegisterUnitEvent("UNIT_POWER_FREQUENT", "player");
		RuneFrame:RegisterUnitEvent("UNIT_MAXPOWER", "player");
		if RuneFrame.isClassic then
			RuneFrame:RegisterEvent("PLAYER_TARGET_CHANGED");
		end
		RuneFrame:UpdatePower();
	else
		RuneFrame.inUse = false;
		RuneFrame:UnregisterEvent("UNIT_POWER_FREQUENT", "player");
		RuneFrame:UnregisterEvent("UNIT_MAXPOWER", "player");
		if RuneFrame.isClassic then
			RuneFrame:UnregisterEvent("PLAYER_TARGET_CHANGED");
		end
	end
end
