local _, Engraved = ...
Engraved.Warlock = {}
local Warlock = Engraved.Warlock
local RuneFrame = EngravedRuneFrame

local POWER_TYPE = Enum.PowerType.SoulShards

function Engraved.Warlock:Setup()
	RuneFrame.inUse = true
	RuneFrame:RegisterUnitEvent("UNIT_POWER_FREQUENT", "player")
	RuneFrame:RegisterUnitEvent("UNIT_MAXPOWER", "player")
	RuneFrame.powerToken = "SOUL_SHARDS"
	RuneFrame.UpdatePower = Warlock.UpdateSoulShards
	RuneFrame.UpdateMaxPower = Warlock.UpdateMaxSoulShards
end

function Warlock:UpdateSoulShards()
	local power = UnitPower("player", POWER_TYPE)
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

function Warlock:UpdateMaxSoulShards()
	local maxPower = UnitPowerMax("player", POWER_TYPE)
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

