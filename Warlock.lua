local _, Engraved = ...
Engraved.Warlock = {}
local Warlock = Engraved.Warlock
local RuneFrame = EngravedRuneFrame

function Engraved.Warlock:Setup()
	RuneFrame.inUse = true
	RuneFrame:RegisterUnitEvent("UNIT_POWER_FREQUENT", "player")
	RuneFrame:RegisterUnitEvent("UNIT_MAXPOWER", "player")
	RuneFrame.powerToken = "SOUL_SHARDS"
	RuneFrame.UpdateMaxPower = Warlock.UpdateMaxSoulShards
	RuneFrame.UpdatePower = Warlock.UpdateSoulShards
end

function Warlock:UpdateSoulShards()
	local shards = UnitPower("player", Enum.PowerType.SoulShards)
	for i = 1, shards do
		if not self.Runes[i].on then
			self.Runes[i]:TurnOn()
		end
	end
	for i = shards + 1, #self.Runes do
		if self.Runes[i].inUse then
			if self.Runes[i].on then
				self.Runes[i]:TurnOff()
			elseif self.Runes[i].on == nil then 
				self.Runes[i].fill:SetAlpha(0)
				self.Runes[i].glow:SetAlpha(0)
				self.Runes[i].on = false
			end
		end
	end
end

function Warlock:UpdateMaxSoulShards()
	local maxShards = UnitPowerMax("player", Enum.PowerType.SoulShards)
	for i = 1, maxShards do
		self.Runes[i].inUse = true
		self.Runes[i]:Show()
	end
	for i = maxShards + 1, #RuneFrame.Runes do
		self.Runes[i].inUse = false
		self.Runes[i]:Hide()
	end
	self:UpdateSizeAndPosition()
end

