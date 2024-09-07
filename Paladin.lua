-- Paladin holy power
-- File not loaded if Classic Era or Classic Wrath

local _, Engraved = ...
local Paladin = Engraved.Paladin
local RuneFrame = Engraved.RuneFrame

local POWER_TYPE_HOLY = Enum.PowerType.HolyPower


--[[ RuneFrame ]]--

function RuneFrame:PALADIN()
	-- Called by RuneFrame:SetClass
	self.inUse = true
	Mixin(self, Paladin.RuneFrameMixin)
	self:SetPaladin()
end

Paladin.RuneFrameMixin = {}
local RuneFrameMixin = Paladin.RuneFrameMixin

function RuneFrameMixin:SetPaladin()
	-- self:RegisterUnitEvent("UNIT_MAXPOWER", "player")
	self:RegisterUnitEvent("UNIT_POWER_FREQUENT", "player")
	self.powerToken = "HOLY_POWER"
end

function RuneFrameMixin:UpdateMaxPower()
	local maxPower = UnitPowerMax("player", POWER_TYPE_HOLY)
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
	local power = UnitPower("player", POWER_TYPE_HOLY)
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


