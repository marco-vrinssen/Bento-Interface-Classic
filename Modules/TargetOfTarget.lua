-- Create targetTargetBackdrop for target of target frame

local targetTargetBackdrop = CreateFrame("Button", nil, TargetFrameToT, "SecureUnitButtonTemplate, BackdropTemplate")
targetTargetBackdrop:SetPoint("BOTTOMLEFT", TargetPortraitBackdrop, "BOTTOMRIGHT", 0, 0)
targetTargetBackdrop:SetSize(64, 24)
targetTargetBackdrop:SetBackdrop({ edgeFile = BORD, edgeSize = 12 })
targetTargetBackdrop:SetBackdropBorderColor(unpack(GREY_RGB))
targetTargetBackdrop:SetFrameLevel(TargetFrameToT:GetFrameLevel() + 2)
targetTargetBackdrop:SetAttribute("unit", "targettarget")
targetTargetBackdrop:RegisterForClicks("AnyUp")
targetTargetBackdrop:SetAttribute("type1", "target")
targetTargetBackdrop:SetAttribute("type2", "togglemenu")

-- Update targetOfTargetFrame to reposition and restyle elements

local function updateTargetOfTargetFrame()

	TargetFrameToT:ClearAllPoints()
	TargetFrameToT:SetPoint("CENTER", targetTargetBackdrop, "CENTER", 0, 0)

	TargetFrameToTTextureFrameTexture:Hide()
	TargetFrameToTPortrait:Hide()

	TargetFrameToTBackground:ClearAllPoints()
	TargetFrameToTBackground:SetPoint("TOPLEFT", targetTargetBackdrop, "TOPLEFT", 2, -2)
	TargetFrameToTBackground:SetPoint("BOTTOMRIGHT", targetTargetBackdrop, "BOTTOMRIGHT", -2, 2)

	TargetFrameToTTextureFrame:Hide()
	TargetFrameToTTextureFrameName:SetParent(TargetFrameToT)
	TargetFrameToTTextureFrameName:ClearAllPoints()
	TargetFrameToTTextureFrameName:SetPoint("BOTTOMLEFT", targetTargetBackdrop, "TOPLEFT", 2, 2)
	TargetFrameToTTextureFrameName:SetWidth(targetTargetBackdrop:GetWidth() - 4)
	TargetFrameToTTextureFrameName:SetTextColor(1, 1, 1, 1)
	TargetFrameToTTextureFrameName:SetFont(FONT, 10, "OUTLINE")

	TargetFrameToTHealthBar:ClearAllPoints()
	TargetFrameToTHealthBar:SetPoint("TOP", targetTargetBackdrop, "TOP", 0, -2)
	TargetFrameToTHealthBar:SetPoint("BOTTOMRIGHT", TargetFrameToTManaBar, "TOPRIGHT", 0, 0)
	TargetFrameToTHealthBar:SetWidth(targetTargetBackdrop:GetWidth() - 6)
	TargetFrameToTHealthBar:SetStatusBarTexture(BAR)

	TargetFrameToTManaBar:ClearAllPoints()
	TargetFrameToTManaBar:SetPoint("BOTTOM", targetTargetBackdrop, "BOTTOM", 0, 2)
	TargetFrameToTManaBar:SetHeight(8)
	TargetFrameToTManaBar:SetWidth(targetTargetBackdrop:GetWidth() - 6)
	TargetFrameToTManaBar:SetStatusBarTexture(BAR)

	for i = 1, MAX_TARGET_BUFFS do
		local targetBuff = _G["TargetFrameToTBuff" .. i]
		if targetBuff then
			targetBuff:SetAlpha(0)
		end
	end

	for i = 1, MAX_TARGET_DEBUFFS do
		local targetDebuff = _G["TargetFrameToTDebuff" .. i]
		if targetDebuff then
			targetDebuff:SetAlpha(0)
		end
	end
end

-- Register targetOfTargetFrame events for updating

local targetOfTargetEvents = CreateFrame("Frame")
targetOfTargetEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
targetOfTargetEvents:RegisterEvent("PLAYER_TARGET_CHANGED")
targetOfTargetEvents:SetScript("OnEvent", updateTargetOfTargetFrame)

-- Update targetOfTargetConfig to ensure CVar is set

local function updateTargetOfTargetConfig()
	SetCVar("ShowTargetOfTarget", 1)
end

-- Register targetOfTargetConfig events for CVar update

local targetOfTargetConfigEvents = CreateFrame("Frame")
targetOfTargetConfigEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
targetOfTargetConfigEvents:SetScript("OnEvent", updateTargetOfTargetConfig)