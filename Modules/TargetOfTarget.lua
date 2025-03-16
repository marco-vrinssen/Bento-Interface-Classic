-- CREATE TARGET TARGET BACKDROP

local ToTFrameBackdrop = CreateFrame("Button", nil, TargetFrameToT, "SecureUnitButtonTemplate, BackdropTemplate")
ToTFrameBackdrop:SetPoint("BOTTOMLEFT", TargetPortraitBackdrop, "BOTTOMRIGHT", 0, 0)
ToTFrameBackdrop:SetSize(64, 24)
ToTFrameBackdrop:SetBackdrop({ edgeFile = BORD, edgeSize = 12 })
ToTFrameBackdrop:SetBackdropBorderColor(unpack(GREY))
ToTFrameBackdrop:SetFrameLevel(TargetFrameToT:GetFrameLevel() + 2)
ToTFrameBackdrop:SetAttribute("unit", "targettarget")
ToTFrameBackdrop:RegisterForClicks("AnyUp")
ToTFrameBackdrop:SetAttribute("type1", "target")
ToTFrameBackdrop:SetAttribute("type2", "togglemenu")


-- UPDATE TARGET TARGET FRAME

local function UpdateToT()

	TargetFrameToT:ClearAllPoints()
	TargetFrameToT:SetPoint("CENTER", ToTFrameBackdrop, "CENTER", 0, 0)

	TargetFrameToTTextureFrame:Hide()
	TargetFrameToTTextureFrameName:SetParent(TargetFrameToT)
	TargetFrameToTTextureFrameName:ClearAllPoints()
	TargetFrameToTTextureFrameName:SetPoint("BOTTOMLEFT", ToTFrameBackdrop, "TOPLEFT", 2, 2)
	TargetFrameToTTextureFrameName:SetWidth(ToTFrameBackdrop:GetWidth() - 4)
	TargetFrameToTTextureFrameName:SetTextColor(1, 1, 1, 1)
	TargetFrameToTTextureFrameName:SetFont(FONT, 10, "OUTLINE")

	TargetFrameToTHealthBar:ClearAllPoints()
	TargetFrameToTHealthBar:SetPoint("TOP", ToTFrameBackdrop, "TOP", 0, -2)
	TargetFrameToTHealthBar:SetPoint("BOTTOMRIGHT", TargetFrameToTManaBar, "TOPRIGHT", 0, 0)
	TargetFrameToTHealthBar:SetWidth(ToTFrameBackdrop:GetWidth() - 6)
	TargetFrameToTHealthBar:SetStatusBarTexture(BAR)

	TargetFrameToTManaBar:ClearAllPoints()
	TargetFrameToTManaBar:SetPoint("BOTTOM", ToTFrameBackdrop, "BOTTOM", 0, 2)
	TargetFrameToTManaBar:SetHeight(8)
	TargetFrameToTManaBar:SetWidth(ToTFrameBackdrop:GetWidth() - 6)
	TargetFrameToTManaBar:SetStatusBarTexture(BAR)

	TargetFrameToTBackground:Hide()
	TargetFrameToTTextureFrameTexture:Hide()
	TargetFrameToTPortrait:Hide()

	for i = 1, MAX_TARGET_BUFFS do
		local ToTBuff = _G["TargetFrameToTBuff" .. i]
		if ToTBuff then
			ToTBuff:SetAlpha(0)
		end
	end

	for i = 1, MAX_TARGET_DEBUFFS do
		local ToTDebuff = _G["TargetFrameToTDebuff" .. i]
		if ToTDebuff then
			ToTDebuff:SetAlpha(0)
		end
	end
end

local ToTEvents = CreateFrame("Frame")
ToTEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
ToTEvents:RegisterEvent("PLAYER_TARGET_CHANGED")
ToTEvents:SetScript("OnEvent", UpdateToT)


-- UPDATE TARGET OF TARGET CONFIGURATIOn

local function UpdateToTConfig()
	SetCVar("ShowTargetOfTarget", 1)
end

local ToTConfigEvents = CreateFrame("Frame")
ToTConfigEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
ToTConfigEvents:SetScript("OnEvent", UpdateToTConfig)