-- Death Knight runes
-- File not loaded if Classic Era

local _, Engraved = ...
local DeathKnight = Engraved.DeathKnight
local RuneFrame = Engraved.RuneFrame
-- local OptionsPanel = Engraved.OptionsPanel

local GetTime = GetTime

local IS_CATA = (WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC)
local IS_WRATH = (WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC)
local CHARGE_ALPHA = 0.6  -- Should be animChargeUp.charge.toAlpha

local function round(value, decimalPlaces)
    local order = 10^(decimalPlaces or 0)
    return math.floor(value * order + 0.5) / order
end


--[[ RuneFrame ]]--

function RuneFrame:DEATHKNIGHT()
	-- Called by RuneFrame:SetClass
	self.inUse = true
	Mixin(self, DeathKnight.RuneFrameMixin)
	self:SetDeathKnight()
end

DeathKnight.RuneFrameMixin = {}
local RuneFrameMixin = DeathKnight.RuneFrameMixin

function RuneFrameMixin:SetDeathKnight()
	self:RegisterEvent("RUNE_POWER_UPDATE")
	self.powerToken = "RUNES"
	if IS_WRATH then
		self:SetDeathKnightWrath()
	elseif IS_CATA then
		self:SetDeathKnightCata()
	else
		self:SetDeathKnightRetail()
	end
end

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

function RuneFrameMixin:SetDeathKnightRetail()
	self.UpdatePower = self.UpdatePowerRetail
	self.UpdateRune = self.UpdateRuneRetail
end

function RuneFrameMixin:UpdateMaxPower()
	for i, rune in ipairs(self.Runes) do
		if i < 7 then
			rune.inUse = true
			rune:Show()
		else
			rune.inUse = false
			rune:Hide()
		end
	end
end

function RuneFrameMixin:UpdatePowerClassic()
	for runeIndex = 1, 6 do
		self:UpdateRuneType(runeIndex)
		self:UpdateRune(runeIndex)
	end
end

function RuneFrameMixin:UpdatePowerRetail()
	for runeIndex = 1, 6 do
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
	-- Runes can wait to start cooling down until others finish
	-- Called as self:UpdateRune
	local rune = self.Runes[runeIndex]
	local startTime, duration, isReady = GetRuneCooldown(runeIndex)
	if isReady and not rune.on then
		rune:TurnOn()
		rune:ChargeDown()
	elseif not isReady then
		if rune.on then
			rune:TurnOff()
		elseif rune.on == nil then
			rune:SetOff()
		end
		if startTime then
			local now = GetTime()
			local timeLeft = startTime + duration - now
			if self.chargeType == "SLOW_GLOW" then
				local startDelay = startTime - now  -- Can be negative! 
				local chargeProgress = max(0, (now - startTime)/duration)
				rune.animChargeUp.hold:SetDuration(max(0, startDelay))
				rune.animChargeUp.charge:SetDuration(min(duration, timeLeft))
				rune.animChargeUp.charge:SetFromAlpha(rune.chargeFinalAlpha * chargeProgress)
			else
				-- "ALMOST_READY"
				if timeLeft > 1.5 then
					rune.animChargeUp.hold:SetDuration(timeLeft - 1.5)
					rune.animChargeUp.charge:SetDuration(0.15)
				else
					rune.animChargeUp.hold:SetDuration(0)
					rune.animChargeUp.charge:SetDuration(0)
				end
			end
			rune:ChargeUp()
		end
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

function RuneFrameMixin:RUNE_POWER_UPDATE(runeIndex, isUsable)
	self:UpdateRune(runeIndex)
end

function RuneFrameMixin:RUNE_TYPE_UPDATE(runeIndex)
	if runeIndex then  -- Why do we need a check?
		self:UpdateRuneType(runeIndex)
	end
end


--[[ OptionsPanel ]]--

-- Deprecated
function DeathKnight:SetRuneTypeColor(runeType, runeColor)
	-- Called by optionsPanel.runeColorXXXX
	RuneFrame.runeColor[runeType] = runeColor
	RuneFrame:SetRuneColorClassic()
end


