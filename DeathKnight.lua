-- Death Knight runes
-- File not loaded if Classic Era

local _, Engraved = ...
local DeathKnight = Engraved.DeathKnight
local RuneFrame = Engraved.RuneFrame

DeathKnight.RuneFrameMixin = {}
DeathKnight.RuneMixin = {}
local RuneFrameMixin = DeathKnight.RuneFrameMixin
local RuneMixin = DeathKnight.RuneMixin

local GetTime = GetTime

local IS_CATA = (WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC)
local IS_WRATH = (WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC)
local IS_MISTS = (WOW_PROJECT_ID == WOW_PROJECT_MISTS_CLASSIC)
local CHARGE_ALPHA = 0.6  -- Should be animChargeUp.charge.toAlpha

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

-- For Blizz code see wow-ui-source/Interface/AddOns/Blizzard_UnitFrame/RuneFrame.lua

function RuneFrame:DEATHKNIGHT()
	-- Called by RuneFrame:SetClass
	self.inUse = true
	Mixin(self, RuneFrameMixin)
	for _, rune in pairs(self.Runes) do
		Mixin(rune, RuneMixin)
	end
	self:SetDeathKnight()
end

function RuneFrameMixin:SetDeathKnight()
	self:RegisterEvent("RUNE_POWER_UPDATE")
	self.powerToken = "RUNES"
	self:SetUsedRunes()
	if IS_WRATH then
		self:SetDeathKnightWrath()
	elseif IS_CATA or IS_MISTS then
		self:SetDeathKnightCata()
	else
		self:SetDeathKnightRetail()
	end
end

function RuneFrameMixin:SetUsedRunes()
	-- Death Knights always have six runes
	self.usedRunes = {}
	for i, rune in ipairs(self.Runes) do
		if i <= 6 then
			tinsert(self.usedRunes, rune)
			rune:Show()
		else
			rune:Hide()
		end
	end
end

function RuneFrameMixin:RUNE_POWER_UPDATE()
	self:UpdatePower()
end


--[[ RuneFrame ]]--

function RuneFrameMixin:SetDeathKnightRetail()
	self.UpdatePower = self.UpdatePowerRetail

	-- Initialize resource slot each rune graphic should show
	self.runeMapping = {}  -- {[runeIndex] = powerSlot}
	for i, rune in ipairs(self.usedRunes) do
		tinsert(self.runeMapping, i)
		rune.powerSlot = i
	end
	self.sortFunction = GenerateClosure(self.ComparePowerSlots, self)
end

function RuneFrameMixin:UpdatePowerRetail()
	-- Update rune states
	for i, rune in ipairs(self.usedRunes) do
		rune:UpdateReadiness()
	end

	-- Sort runeMapping by readiness
	table.sort(self.runeMapping, self.sortFunction)
	-- print(table.concat(self.runeMapping, ", "))

	-- Assign new powerSlot as necessary

	-- Animate runes
	for i, rune in ipairs(self.usedRunes) do
		rune:Animate()
	end
end

function RuneFrameMixin:ComparePowerSlots(slotA, slotB)
	-- return true if first should come before second

	-- Get runes for each slot
	local runeA, runeB
	for i, rune in ipairs(self.Runes) do
		if not rune.powerSlot then break end
		if rune.powerSlot == slotA then
			runeA = rune
		elseif rune.powerSlot == slotB then
			runeB = rune
		end
	end
	local readinessA = runeA.readiness
	local readinessB = runeB.readiness

	-- Handle nil states
	if readinessA == nil or readinessB == nil then
		if readinessA == nil and readinessB == nil then
			return slotA < slotB
		end
		return readinessA ~= nil
	end

	-- Order by shownState
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

function RuneFrameMixin:SetDeathKnightWrath()
	self.UpdatePower = self.UpdatePowerClassic
	self.UpdateRune = self.UpdateRuneWrath

	self:RegisterEvent("RUNE_TYPE_UPDATE")
	self:SetRuneTypeColors()
	self.SetRuneColor = self.SetRuneColorClassic
end

function RuneFrameMixin:SetDeathKnightCata()
	self.UpdatePower = self.UpdatePowerClassic
	self.UpdateRune = self.UpdateRuneRetail

	self:RegisterEvent("RUNE_TYPE_UPDATE")
	self:SetRuneTypeColors()
	self.SetRuneColor = self.SetRuneColorClassic
end

function RuneFrameMixin:UpdatePowerClassic()
	for runeIndex = 1, 6 do
		self:UpdateRuneType(runeIndex)
		self:UpdateRune(runeIndex)
	end
end

function RuneFrameMixin:UpdateRuneWrath(runeIndex)
	-- Rune cooldowns are independent of each other
	-- Called as self:UpdateRune
	local rune = self.Runes[runeIndex]
	local start, duration, runeReady = GetRuneCooldown(runeIndex)
	if runeReady and not rune.on then
		rune:TurnOn()
		rune:ChargeDown()
	elseif not runeReady then
		if rune.on then
			rune:TurnOff()
		elseif rune.on == nil then
			rune:SetOff()
		end
		if start then
			local timeLeft = start + duration - GetTime()
			-- if self.chargeType == "SLOW_GLOW" then
				-- rune.animChargeUp.hold:SetDuration(0)
				-- rune.animChargeUp.charge:SetDuration(timeLeft)
			-- else  -- "ALMOST_READY"
				rune.animChargeUp.hold:SetDuration(timeLeft - 1.5)
				rune.animChargeUp.charge:SetDuration(0.15)
			-- end
			rune:ChargeUp()
		end
	end
end

function RuneFrameMixin:UpdateRuneRetail(runeIndex)
	-- Deprecated: Roll into UpdatePowerRetail()
	-- Called as self:UpdateRune(runeIndex)
	local rune = self.Runes[runeIndex]
	if not rune then return end
	rune:UpdateRetail()
end

function RuneMixin:UpdateRetail()
	-- Runes can wait to start cooling down until others finish
	local startTime, duration, isReady = GetRuneCooldown(self.powerSlot)
	if not isReady then
		self:ShowAsEmpty()
		if startTime then
			self:ShowAsCharging(startTime, duration)
		end
	else
		self:ShowAsReady()
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
	for runeIndex = 1, 6 do
		self:UpdateRuneType(runeIndex)
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

function RuneFrameMixin:RUNE_TYPE_UPDATE(runeIndex)
	if runeIndex then  -- Why do we need a check?
		self:UpdateRuneType(runeIndex)
	end
end

-- Deprecated
function DeathKnight:SetRuneTypeColor(runeType, runeColor)
	-- Called by optionsPanel.runeColorXXXX
	RuneFrame.runeColor[runeType] = runeColor
	RuneFrame:SetRuneColorClassic()
end


