-- Evoker essence
-- File not loaded if Classic

local _, Engraved = ...
local Evoker = Engraved.Evoker
local RuneFrame = EngravedRuneFrame

local POWER_TYPE_ESSENCE = Enum.PowerType.Essence


--[[ RuneFrame ]]--

function RuneFrame:EVOKER()
	-- Called by RuneFrame:SetClass
	self.inUse = true
	Mixin(self, Evoker.RuneFrameMixin)
	self:SetEvoker()
end

Evoker.RuneFrameMixin = {}
local RuneFrameMixin = Evoker.RuneFrameMixin

function RuneFrameMixin:SetEvoker()
	-- self:RegisterUnitEvent("UNIT_MAXPOWER", "player")
	self:RegisterUnitEvent("UNIT_POWER_FREQUENT", "player")
	self.powerToken = "ESSENCE"
end

function RuneFrameMixin:UpdateMaxPower()
	local maxPower = UnitPowerMax("player", POWER_TYPE_ESSENCE)
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
	local power = UnitPower("player", POWER_TYPE_ESSENCE)
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

