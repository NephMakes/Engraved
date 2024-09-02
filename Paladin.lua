local _, Engraved = ...
local Paladin = Engraved.Paladin
local RuneFrame = EngravedRuneFrame

local POWER_TYPE_HOLY = Enum.PowerType.HolyPower

function Paladin:Setup()
	RuneFrame.inUse = true
	RuneFrame:RegisterUnitEvent("UNIT_POWER_FREQUENT", "player")
	RuneFrame:RegisterUnitEvent("UNIT_MAXPOWER", "player")
	RuneFrame.powerToken = "HOLY_POWER"
	RuneFrame.UpdatePower = Paladin.UpdateHolyPower
	RuneFrame.UpdateMaxPower = Paladin.UpdateMaxHolyPower
end

function Paladin:UpdateHolyPower()
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

function Paladin:UpdateMaxHolyPower()
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

