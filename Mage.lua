-- Mage arcane charges, frost icicles
-- File not loaded if Classic

local _, Engraved = ...
local Mage = Engraved.Mage
local RuneFrame  = Engraved.RuneFrame

local SPEC_MAGE_ARCANE, SPEC_MAGE_FIRE, SPEC_MAGE_FROST = 1, 2, 3

local SPEC_ID_ARCANE = 1
local POWER_TYPE_ARCANE = Enum.PowerType.ArcaneCharges

local SPEC_ID_FROST = 3
local MAX_ICICLES = 5
local GetPlayerAuraBySpellID = C_UnitAuras.GetPlayerAuraBySpellID


--[[ RuneFrame ]]--

function RuneFrame:MAGE()
	-- Called by RuneFrame:SetClass
    local specID = GetSpecialization()
    if specID == SPEC_ID_ARCANE then
		self.inUse = true
		Mixin(self, Mage.ArcaneRuneFrameMixin)
		self:SetArcane()
    elseif specID == SPEC_ID_FROST then
		self.inUse = true
		Mixin(self, Mage.FrostRuneFrameMixin)
		self:SetFrost()
	else
		self.inUse = false
    end
end

-- Arcane

Mage.ArcaneRuneFrameMixin = {}
local RuneFrameArcane = Mage.ArcaneRuneFrameMixin

function RuneFrameArcane:SetArcane()
    self:RegisterUnitEvent("UNIT_POWER_FREQUENT", "player")
    self.powerToken = "ARCANE_CHARGES"
end

function RuneFrameArcane:UpdateMaxPower()
	local maxPower = UnitPowerMax("player", POWER_TYPE_ARCANE)
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

function RuneFrameArcane:UpdatePower()
	local power = UnitPower("player", POWER_TYPE_ARCANE)
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

-- Frost

Mage.FrostRuneFrameMixin = {}
local RuneFrameFrost = Mage.FrostRuneFrameMixin

function RuneFrameFrost:SetFrost()
    self:RegisterUnitEvent("UNIT_AURA", "player")
end

function RuneFrameFrost:UpdateMaxPower()
	local maxPower = MAX_ICICLES
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

function RuneFrameFrost:UpdatePower()
	local power = self:GetIcicles()
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

function RuneFrameFrost:GetIcicles()
	local aura = GetPlayerAuraBySpellID(205473)  -- "Icicles"
	if aura then
		return aura.applications
	else 
		return 0
	end
end

function RuneFrameFrost:UNIT_AURA(unit, updateInfo)
	--[[
	-- Needs testing
	local shouldUpdate
	if updateInfo.isFullUpdate then
		shouldUpdate = true
	elseif updateInfo.addedAuras then
		for _, aura in pairs(updateInfo.addedAuras) do
			if aura.spellId and aura.spellId == 205473 then
				 -- "Icicles"
				shouldUpdate = true
			end
		end
	end
	if shouldUpdate then
		self:UpdatePower()
	end
	]]--
	self:UpdatePower()
end


