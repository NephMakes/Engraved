local _, Engraved = ...
local Rogue = Engraved.Rogue
local Druid = Engraved.Druid
local RuneFrame = EngravedRuneFrame

local POWER_TYPE_COMBO = Enum.PowerType.ComboPoints
local POWER_TYPE_ENERGY = Enum.PowerType.Energy


--[[ Rogue ]]--


function Rogue:Setup()
	RuneFrame.inUse = true
	RuneFrame:RegisterUnitEvent("UNIT_POWER_FREQUENT", "player")
	RuneFrame:RegisterUnitEvent("UNIT_MAXPOWER", "player")
	RuneFrame.powerToken = "COMBO_POINTS"
	RuneFrame.UpdatePower = Rogue.UpdateComboPoints
	RuneFrame.UpdateMaxPower = Rogue.UpdateMaxComboPoints
end

function Rogue:SetupClassic()
	-- Combo points stored on target
	RuneFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
	RuneFrame.isClassic = true
end

function Rogue:UpdateComboPoints()
	local power
	if self.isClassic then
		power = GetComboPoints("player", "target")
	else
		power = UnitPower("player", POWER_TYPE_COMBO)
	end
	for i, rune in ipairs(self.Runes) do
		if i <= power then
			if not rune.on then
				rune:TurnOn()
			end
		elseif rune.inUse then
			if rune.on then
				rune:TurnOff()
			elseif rune.on == nil then
				rune:SetOff()
			end
		end
	end
end

function Rogue:UpdateMaxComboPoints()
	local maxPower = UnitPowerMax("player", POWER_TYPE_COMBO)
	for i, rune in ipairs(self.Runes) do
		if i <= maxPower then
			rune.inUse = true
			rune:Show()
		else
			rune.inUse = false
			rune:Hide()
		end
	end
	self:UpdateSizeAndPosition()
end


--[[ Druid ]]--


function Druid:Setup()
	RuneFrame:RegisterUnitEvent("UNIT_DISPLAYPOWER", "player")
	RuneFrame.powerToken = "COMBO_POINTS"
	RuneFrame.UpdatePower = Rogue.UpdateComboPoints
	RuneFrame.UpdateMaxPower = Rogue.UpdateMaxComboPoints
	Druid:OnShapeshift()
end

function Druid:SetupClassic()
	-- Combo points stored on target
	RuneFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
	RuneFrame.isClassic = true
end

function Druid:OnShapeshift()
	local powerType, powerToken = UnitPowerType("player")
	if powerType == POWER_TYPE_ENERGY then
		RuneFrame.inUse = true
		RuneFrame:RegisterUnitEvent("UNIT_POWER_FREQUENT", "player")
		RuneFrame:RegisterUnitEvent("UNIT_MAXPOWER", "player")
		if RuneFrame.isClassic then
			RuneFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
		end
		RuneFrame:UpdatePower()
	else
		RuneFrame.inUse = false
		RuneFrame:UnregisterEvent("UNIT_POWER_FREQUENT", "player")
		RuneFrame:UnregisterEvent("UNIT_MAXPOWER", "player")
		if RuneFrame.isClassic then
			RuneFrame:UnregisterEvent("PLAYER_TARGET_CHANGED")
		end
	end
end
