-- Individual runes

local addonName, Engraved = ...
local RuneFrame = Engraved.RuneFrame
local Rune = Engraved.Rune

local function round(x) 
	return floor(x + 0.5)
end


--[[ Setup ]]--

function Rune:OnLoad()
	self:SetScript("OnEnter", self.OnEnter)
	self:SetScript("OnLeave", self.OnLeave)
	self:SetScript("OnDragStart", self.OnDragStart)
	self:SetScript("OnDragStop", self.OnDragStop)
	self:RegisterForDrag("LeftButton")

	self.chargeFinalAlpha = self.animChargeUp.charge:GetToAlpha()
		-- For DeathKnight

	local resizeButton = self.resizeButton
	resizeButton:SetScript("OnEnter", self.ResizeButtonOnEnter)
	resizeButton:SetScript("OnLeave", self.ResizeButtonOnLeave)
	resizeButton:SetScript("OnDragStart", self.OnResizeStart)
	resizeButton:SetScript("OnDragStop", self.OnResizeStop)
	resizeButton:RegisterForDrag("LeftButton")
end

function Rune:SetRuneColor(color)
	self.background:SetVertexColor(color.r, color.g, color.b)
	self.fill:SetVertexColor(color.r, color.g, color.b)
	self.charge:SetVertexColor(color.r, color.g, color.b)
	self.glow:SetVertexColor(color.r, color.g, color.b)
end


--[[ Action ]]--

function Rune:TurnOn()
	self.animOut:Stop()
	if not self.animIn:IsPlaying() then
		self.animIn:Play()
	end
	self.on = true
end

function Rune:TurnOff()
	self.animIn:Stop()
	if not self.animOut:IsPlaying() then
		self.animOut:Play()
	end
	self.on = false
end

function Rune:SetOff()
	self.fill:SetAlpha(0)
	self.glow:SetAlpha(0)
	self.on = false
end

function Rune:ChargeUp()
	-- For Death Knight cooldowns
	self.animChargeDown:Stop()
	self.animChargeUp:Stop()
	self.animChargeUp:Play()
end

function Rune:ChargeDown()
	self.animChargeUp:Stop()
	if not self.animChargeDown:IsPlaying() then
		self.animChargeDown:Play()
	end
end


--[[ Config ]]--

function Rune:OnEnter()
	self.Border:Show()
	self.resizeButton:SetAlpha(1)
	GameTooltip_SetDefaultAnchor(GameTooltip, self)
	GameTooltip:SetText(Engraved.Strings.RUNE.." "..self:GetID())
	GameTooltip:Show()
end

function Rune:OnLeave()
	self.Border:Hide()
	self.resizeButton:SetAlpha(0)
	GameTooltip:Hide()
end

function Rune:ResizeButtonOnEnter()
	self:GetParent().Border:Show()
	self:SetAlpha(1)
end

function Rune:ResizeButtonOnLeave()
	self:GetParent().Border:Hide()
	self:SetAlpha(0)
end

function Rune:OnDragStart()
	local runeFrame = self:GetParent()
	for _, rune in pairs(runeFrame.Runes) do
		rune:AnchorToScreen()
	end
	runeFrame:SetScript("OnUpdate", RuneFrame.FitToRunes)
	self:StartMoving()
end

function Rune:AnchorToScreen()
	local xOfs = self:GetLeft() + self:GetWidth()/2
	local yOfs = self:GetBottom() + self:GetHeight()/2
	self:ClearAllPoints()
	self:SetPoint("CENTER", UIParent, "BOTTOMLEFT", xOfs, yOfs)
end

function Rune:OnDragStop()
	self:StopMovingOrSizing()
	self:SetUserPlaced(false)	-- So client won't mess with frame

	local runeFrame = self:GetParent()
	runeFrame:SetScript("OnUpdate", nil)
	runeFrame:SaveSizeAndPosition()
	runeFrame:SetPosition(EngravedOptions.RuneFramePosition)
	runeFrame:SetSize(EngravedOptions.RuneFrameSize)

	runeFrame:SaveRunePositions()
	runeFrame:SetRunePositions(EngravedOptions.RunePositions)
end

function Rune:OnResizeStart()
	self:SetButtonState("PUSHED", true)
	self:GetHighlightTexture():Hide()
	local runeFrame = RuneFrame
	for _, rune in pairs(runeFrame.Runes) do
		rune:AnchorToScreen()
	end
	runeFrame:SetScript("OnUpdate", RuneFrame.FitToRunes)
	self:SetScript("OnUpdate", Rune.OnResize)
end

function Rune:OnResize()
	local rune = self:GetParent()
	local mouseX, mouseY = GetCursorPosition()
	mouseX, mouseY = mouseX / UIParent:GetScale(), mouseY / UIParent:GetScale()
	local runeX = rune:GetLeft() + rune:GetWidth()/2
	local runeY = rune:GetBottom() + rune:GetHeight()/2
	local newSize = max( 32, 2*(mouseX-runeX+4), 2*(runeY-mouseY+4) )  -- +4 prevents flicker
	newSize = min(newSize, 150)
	rune:SetSize(newSize, newSize)
end

function Rune:OnResizeStop()
	self:SetButtonState("NORMAL", false)
	self:GetHighlightTexture():Show()
	self:SetScript("OnUpdate", nil)
	EngravedOptions.RuneSizes[self:GetParent():GetID()] = self:GetParent():GetWidth()

	local runeFrame = RuneFrame
	runeFrame:SetScript("OnUpdate", nil)
	runeFrame:SaveSizeAndPosition()
	runeFrame:SetPosition(EngravedOptions.RuneFramePosition)
	runeFrame:SetSize(EngravedOptions.RuneFrameSize)

	runeFrame:SaveRunePositions()
	runeFrame:SetRunePositions(EngravedOptions.RunePositions)
end

