-- Rogue combo points

local _, Engraved = ...
local Rogue = Engraved.Rogue
local RuneFrame = Engraved.RuneFrame

local POWER_TYPE_COMBO = Enum.PowerType.ComboPoints

local IsClassic = {
	["WOW_PROJECT_CLASSIC"] = true, 
	["WOW_PROJECT_BURNING_CRUSADE_CLASSIC"] = true, 
	["WOW_PROJECT_WRATH_CLASSIC"] = true, 
	["WOW_PROJECT_CATACLYSM_CLASSIC"] = true, 
}
local IS_CLASSIC = IsClassic[WOW_PROJECT_ID]

local function GetPower()
	if IS_CLASSIC then
		return GetComboPoints("player", "target")
	else
		return UnitPower("player", POWER_TYPE_COMBO)
	end
end


--[[ RuneFrame ]]--

function RuneFrame:ROGUE()
	-- Called by RuneFrame:SetClass
	self.inUse = true
	Mixin(self, Rogue.RuneFrameMixin)
	self:SetRogue()
end

Rogue.RuneFrameMixin = {}
local RuneFrameMixin = Rogue.RuneFrameMixin

function RuneFrameMixin:SetRogue()
	-- self:RegisterUnitEvent("UNIT_MAXPOWER", "player")
	self:RegisterUnitEvent("UNIT_POWER_FREQUENT", "player")
	self.powerToken = "COMBO_POINTS"
	if IS_CLASSIC then
		self:RegisterEvent("PLAYER_TARGET_CHANGED")
	end
end

function RuneFrameMixin:PLAYER_TARGET_CHANGED()
	self:UpdatePower()
end

function RuneFrameMixin:UpdateMaxPower()
	local maxPower = UnitPowerMax("player", POWER_TYPE_COMBO)
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
	local power = GetPower()  -- See local function above
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

