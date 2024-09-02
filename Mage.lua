local _, Engraved = ...
local Mage = Engraved.Mage
local RuneFrame  = EngravedRuneFrame

local SPEC_MAGE_ARCANE, SPEC_MAGE_FIRE, SPEC_MAGE_FROST = 1, 2, 3;

function Mage:Setup()
    local spec = GetSpecialization();
    if spec == SPEC_MAGE_ARCANE then
        Mage:ArcaneSetup();
    elseif spec == SPEC_MAGE_FROST then
        Mage:FrostSetup();
    end
end


--[[ Arcane ]] --

function Mage:ArcaneSetup()
    RuneFrame.inUse = true;
    RuneFrame:RegisterUnitEvent("UNIT_POWER_FREQUENT", "player");
    RuneFrame.powerToken = "ARCANE_CHARGES";
    RuneFrame.UpdatePower = Mage.UpdateArcaneCharges;
    RuneFrame.UpdateMaxPower = Mage.UpdateArcaneMaxPower;
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

function Mage:UpdateArcaneMaxPower()
	-- self is RuneFrame
	local charges = UnitPowerMax("player", Enum.PowerType.ArcaneCharges);
	for i = 1, charges do
		self.Runes[i]:Show();
		self.Runes[i].inUse = true;
	end
	for i = charges + 1, #self.Runes do
		self.Runes[i]:Hide();
		self.Runes[i].inUse = false;
	end
	self:UpdateSizeAndPosition();
end


-- [[ Frost ]] --

function Mage:FrostSetup()
    RuneFrame.inUse = true;
    RuneFrame.powerToken = "ICICLES";
    RuneFrame:RegisterUnitEvent("UNIT_AURA", "player");
    RuneFrame.UpdatePower = Mage.UpdateFrostIciclesCharges;
    RuneFrame.UpdateMaxPower = Mage.UpdateFrostMaxPower;
    for i = 1, 5 do
    	RuneFrame.Runes[i].inUse = true;
    	RuneFrame.Runes[i]:Show();
    end
    for i = 6, #RuneFrame.Runes do
    	RuneFrame.Runes[i].inUse = false;
    	RuneFrame.Runes[i]:Hide();
    end
end

local ICICLES_SPELL_ID = 205473;

function Mage:UpdateFrostIciclesCharges()
	local auraData = C_UnitAuras.GetPlayerAuraBySpellID(ICICLES_SPELL_ID) or {};
	local charges, maxCharges = auraData.applications or 0, 5;
    for i = 1, charges do
    	if ( not self.Runes[i].on ) then
    		self.Runes[i]:TurnOn();
    	end
    end
    for i = charges + 1, maxCharges do
    	if ( self.Runes[i].on ) then
    		self.Runes[i]:TurnOff();
    	elseif ( self.Runes[i].on == nil ) then
    		self.Runes[i].fill:SetAlpha(0);
    		self.Runes[i].glow:SetAlpha(0);
    		self.Runes[i].on = false;
    	end
    end
end

function Mage:UpdateFrostMaxPower()
	-- self is RuneFrame
    local maxCharges = 5
	for i = 1, maxCharges do
		self.Runes[i]:Show();
		self.Runes[i].inUse = true;
	end
	for i = maxCharges + 1, #self.Runes do
		self.Runes[i]:Hide();
		self.Runes[i].inUse = false;
	end
	self:UpdateSizeAndPosition();
end