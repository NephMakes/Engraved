-- Monk chi
-- File not loaded if Classic

local _, Engraved = ...
local Monk = Engraved.Monk
local RuneFrame = Engraved.RuneFrame

local POWER_TYPE_CHI = Enum.PowerType.Chi
local SPEC_ID_WINDWALKER = 3


--[[ RuneFrame ]]--

function RuneFrame:MONK()
	local specID = GetSpecialization()
	if specID == SPEC_ID_WINDWALKER then
		self.inUse = true
		Mixin(self, Monk.RuneFrameMixin)
		self:SetMonk()
	else
		self.inUse = false
	end
end

Monk.RuneFrameMixin = {}
local RuneFrameMixin = Monk.RuneFrameMixin

function RuneFrameMixin:SetMonk()
	-- self:RegisterUnitEvent("UNIT_MAXPOWER", "player")
	self:RegisterUnitEvent("UNIT_POWER_FREQUENT", "player")
	self.powerToken = "CHI"
end

function RuneFrameMixin:UpdateMaxPower()
	local maxPower = UnitPowerMax("player", POWER_TYPE_CHI)
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

function RuneFrameMixin:UpdatePower()
	local power = UnitPower("player", POWER_TYPE_CHI)
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

