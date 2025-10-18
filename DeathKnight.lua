-- Death Knight runes
-- File not loaded if Classic Era
-- For Blizz code see wow-ui-source/Interface/AddOns/Blizzard_UnitFrame/RuneFrame.lua

local _, Engraved = ...
local DeathKnight = Engraved.DeathKnight
local RuneFrame = Engraved.RuneFrame

DeathKnight.RuneFrameMixin = {}
DeathKnight.RuneMixin = {}
local RuneFrameMixin = DeathKnight.RuneFrameMixin
local RuneMixin = DeathKnight.RuneMixin

local IS_MISTS = (WOW_PROJECT_ID == WOW_PROJECT_MISTS_CLASSIC)

local GetTime = GetTime
local function round(value, decimalPlaces)
    local order = 10^(decimalPlaces or 0)
    return math.floor(value * order + 0.5) / order
end

-- Rune readiness states (for sorting)
local Readiness = {
	Empty = 1,
	Charging = 2,
	AlmostReady = 3,
	Ready = 4
}


--[[ RuneFrame ]]--

function RuneFrame:DEATHKNIGHT()
	-- Called by RuneFrame:SetClass
	self.inUse = true
	self.powerToken = "RUNES"
	self:RegisterEvent("RUNE_POWER_UPDATE")
	Mixin(self, RuneFrameMixin)
	for _, rune in pairs(self.Runes) do
		Mixin(rune, RuneMixin)
	end
	self:SetUsedRunes()
	self:SetExpansion()
end

function RuneFrameMixin:RUNE_POWER_UPDATE()
	self:UpdatePower()
end

function RuneFrameMixin:SetUsedRunes()
	-- Death Knights always have six runes
	self.usedRunes = {}
	for i, rune in ipairs(self.Runes) do
		if i <= 6 then
			tinsert(self.usedRunes, rune)
			rune.inUse = true
			rune:Show()
		else
			rune:Hide()
		end
	end
end

function RuneFrameMixin:SetExpansion()
	if IS_MISTS then
		self:SetDeathKnightMists()
	else
		self:SetDeathKnightRetail()
	end
end

function RuneFrameMixin:SetDeathKnightRetail()
	-- Only one runeType, sorted by readiness
	self.UpdatePower = self.UpdatePowerRetail
	self.runeMapping = {}  -- {[runeIndex] = powerSlot}
	for i, rune in ipairs(self.usedRunes) do
		tinsert(self.runeMapping, i)
		rune.powerSlot = i
	end
	self.sortSlotsByReadiness = GenerateClosure(self.ComparePowerSlots, self)
end

function RuneFrameMixin:UpdatePowerRetail()
	for i, rune in ipairs(self.usedRunes) do
		rune:UpdateReadiness()
	end
	table.sort(self.runeMapping, self.sortSlotsByReadiness)
	self:UpdatePowerSlots()
	for i, rune in ipairs(self.usedRunes) do
		rune:Animate()
	end
end

function RuneFrameMixin:ComparePowerSlots(slotA, slotB)
	-- return true if first should come before second

	-- Get runes for each slot
	local runeA, runeB
	for i, rune in ipairs(self.Runes) do
		-- if not rune.powerSlot then break end
		if rune.powerSlot == slotA then
			runeA = rune
		elseif rune.powerSlot == slotB then
			runeB = rune
		end
	end

	-- Handle nils
	if runeA == nil or runeB == nil then
		if runeA == nil and runeB == nil then
			return slotA < slotB
		end
		return runeA ~= nil
	end

	-- Order by readiness
	local readinessA = runeA.readiness
	local readinessB = runeB.readiness
	if readinessA ~= readinessB then
		return readinessA > readinessB
	end

	-- Order by cooldown startTime
	local startTimeA = runeA.startTime
	local startTimeB = runeB.startTime
	if startTimeA ~= startTimeB then
		return startTimeA < startTimeB
	end

	-- Order by powerSlot
	return slotA < slotB
end

function RuneFrameMixin:UpdatePowerSlots()
	-- Update which resource slot rune graphics show
	for i, rune in ipairs(self.usedRunes) do
		newSlot = self.runeMapping[i]
		if rune.powerSlot ~= newSlot then
			rune.powerSlot = newSlot
			for _, oldRune in ipairs(self.usedRunes) do
				if oldRune.oldSlot == newSlot then
					rune.readiness = oldRune.oldReadiness
					rune.startTime = oldRune.oldStart
					rune.duration = oldRune.oldDuration
					break
				end
			end
		end
	end
end


--[[ Rune ]]--

function RuneMixin:UpdateReadiness()
	local startTime, duration, isReady = GetRuneCooldown(self.powerSlot)
	self.startTime = startTime
	self.duration = duration

	if not isReady then
		if startTime then
			self.readiness = Readiness.Charging
		else
			self.readiness = Readiness.Empty
		end
	else
		self.readiness = Readiness.Ready
	end

	-- Set old values in case runes need sorting
	self.oldSlot = self.powerSlot
	self.oldReadiness = self.readiness
	self.oldStart = startTime
	self.oldDuration = duration
end

function RuneMixin:Animate()
	if self.readiness == Readiness.Empty then
		self:ShowAsEmpty()
	elseif self.readiness == Readiness.Charging then
		self:ShowAsEmpty()
		self:ShowAsCharging(self.startTime, self.duration)
	elseif self.readiness == Readiness.Ready then
		self:ShowAsReady()
	end
end

function RuneMixin:ShowAsEmpty()
	if self.on then
		self:TurnOff()
	elseif self.on == nil then
		self:SetOff()
	end
end

function RuneMixin:ShowAsCharging(startTime, duration)
	local now = GetTime()
	local timeLeft = startTime + duration - now
	local runeFrame = self:GetParent()
	if runeFrame.chargeType == "SLOW_GLOW" then
		local startDelay = startTime - now  -- Can be negative! 
		local chargeProgress = max(0, (now - startTime)/duration)
		self.animChargeUp.hold:SetDuration(max(0, startDelay))
		self.animChargeUp.charge:SetDuration(min(duration, timeLeft))
		self.animChargeUp.charge:SetFromAlpha(self.chargeFinalAlpha * chargeProgress)
	else
		-- "ALMOST_READY"
		if timeLeft > 1.5 then
			self.animChargeUp.hold:SetDuration(timeLeft - 1.5)
			self.animChargeUp.charge:SetDuration(0.15)
		else
			self.animChargeUp.hold:SetDuration(0)
			self.animChargeUp.charge:SetDuration(0)
		end
	end
	self:ChargeUp()
end

function RuneMixin:ShowAsReady()
	if not self.on then
		self:TurnOn()
		self:ChargeDown()
	end
end


--[[ Classic ]]--

function RuneFrameMixin:SetDeathKnightMists()
	-- Three rune types. They don't change type.
	self.UpdatePower = self.UpdatePowerClassic
	for i, rune in ipairs(self.usedRunes) do
		rune.powerSlot = i
	end
	self:SetRuneTypeColors()
	self.SetRuneColor = self.SetRuneColorClassic
end

function RuneFrameMixin:UpdatePowerClassic()
	for i, rune in ipairs(self.usedRunes) do
		rune:UpdateReadiness()
		rune:Animate()
	end
end

function RuneFrameMixin:SetRuneTypeColors()
	local options = EngravedOptions
	self.runeColor = {}
	self.runeColor[1] = options.RuneColorBlood
	self.runeColor[2] = options.RuneColorFrost
	self.runeColor[3] = options.RuneColorUnholy
	self.runeColor[4] = options.RuneColorDeath
end

function RuneFrameMixin:SetRuneColorClassic()
	for i, rune in ipairs(self.usedRunes) do
		local runeType = GetRuneType(i)
		local color = self.runeColor[runeType]
		rune:SetRuneColor(color)
	end
end


--[[ Classic (old) ]]--

--[[
function RuneFrameMixin:RUNE_TYPE_UPDATE(runeIndex)
	if runeIndex then  -- Why do we need a check?
		self:UpdateRuneType(runeIndex)
	end
end

function RuneFrameMixin:UpdatePowerClassic()
	for runeIndex = 1, 6 do
		self:UpdateRuneType(runeIndex)
		self:UpdateRune(runeIndex)
	end
end

function RuneFrameMixin:UpdateRuneType(runeIndex)
	local runeType = GetRuneType(runeIndex)
	if runeType then
		local rune = self.Runes[runeIndex]
		rune.runeType = runeType
		rune:SetRuneColor(self.runeColor[runeType])
	end
end

function RuneFrameMixin:SetRuneColorClassic()
	for runeIndex = 1, 6 do
		self:UpdateRuneType(runeIndex)
	end
end
--]]

-- Deprecated
function DeathKnight:SetRuneTypeColor(runeType, runeColor)
	-- Called by optionsPanel.runeColorXXXX
	RuneFrame.runeColor[runeType] = runeColor
	RuneFrame:SetRuneColorClassic()
end


