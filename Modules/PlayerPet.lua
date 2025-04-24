-- CREATE PET FRAME CONTAINER WITH BORDER

local petContainer = CreateFrame("Button", nil, PetFrame, "SecureUnitButtonTemplate, BackdropTemplate")
petContainer:SetPoint("BOTTOMRIGHT", PlayerPortraitBackdrop, "BOTTOMLEFT", 0, 0)
petContainer:SetSize(64, 24)
petContainer:SetBackdrop({edgeFile = BORD, edgeSize = 12})
petContainer:SetBackdropBorderColor(unpack(GREY))
petContainer:SetFrameLevel(PetFrame:GetFrameLevel() + 2)
petContainer:SetAttribute("unit", "pet")
petContainer:RegisterForClicks("AnyUp")
petContainer:SetAttribute("type1", "target")
petContainer:SetAttribute("type2", "togglemenu")

-- CREATE BACKGROUND FRAME BELOW BORDER

local petContainerBackground = CreateFrame("Frame", nil, petContainer, "BackdropTemplate")
petContainerBackground:SetPoint("TOPLEFT", petContainer, "TOPLEFT", 2, -2)
petContainerBackground:SetPoint("BOTTOMRIGHT", petContainer, "BOTTOMRIGHT", -2, 2)
petContainerBackground:SetBackdrop({ bgFile = BG })
petContainerBackground:SetBackdropColor(unpack(BLACK))
petContainerBackground:SetFrameLevel(petContainer:GetFrameLevel() - 1)

-- UPDATE PET FRAME

local function updatePetFrame()
	PetFrame:ClearAllPoints()
	PetFrame:SetPoint("CENTER", petContainer, "CENTER", 0, 0)
	PetFrame:SetSize(petContainer:GetWidth(), petContainer:GetHeight())
    PetFrame:UnregisterEvent("UNIT_COMBAT")
	PetAttackModeTexture:SetTexture(nil)
    PetFrameTexture:Hide()
    PetPortrait:Hide()

    PetName:ClearAllPoints()
    PetName:SetPoint("BOTTOMRIGHT", petContainer, "TOPRIGHT", -2, 2)
    PetName:SetWidth(petContainer:GetWidth() - 4)
    PetName:SetFont(FONT, 10, "OUTLINE")
    PetName:SetTextColor(unpack(WHITE))

	for i = 1, MAX_TARGET_BUFFS do
		local PetBuff = _G["PetFrameBuff" .. i]
		if PetBuff then
			PetBuff:SetAlpha(0)
		end
	end
	
	for i = 1, MAX_TARGET_DEBUFFS do
		local PetDebuff = _G["PetFrameDebuff" .. i]
		if PetDebuff then
			PetDebuff:SetAlpha(0)
		end
	end
end

local petFrameEvents = CreateFrame("Frame")
petFrameEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
petFrameEvents:RegisterEvent("UNIT_PET")
petFrameEvents:SetScript("OnEvent", updatePetFrame)

-- UPDATE PET RESOURCES

local function UpdatePetResources()
    PetFrameHealthBar:ClearAllPoints()
    PetFrameHealthBar:SetPoint("TOP", petContainer, "TOP", 0, -2)
    PetFrameHealthBar:SetPoint("BOTTOM", PetFrameManaBar, "TOP", 0, 0)
    PetFrameHealthBar:SetWidth(petContainer:GetWidth()-6)
    PetFrameHealthBar:SetStatusBarTexture(BAR)
    
    PetFrameManaBar:ClearAllPoints()
    PetFrameManaBar:SetPoint("BOTTOM", petContainer, "BOTTOM", 0, 2)
    PetFrameManaBar:SetWidth(petContainer:GetWidth()-6)
    PetFrameManaBar:SetHeight(8)
    PetFrameManaBar:SetStatusBarTexture(BAR)
    
    PetFrameHealthBarText:SetAlpha(0)
    PetFrameHealthBarTextLeft:SetAlpha(0)
    PetFrameHealthBarTextRight:SetAlpha(0)

    PetFrameManaBarText:SetAlpha(0)
    PetFrameManaBarTextLeft:SetAlpha(0)
    PetFrameManaBarTextRight:SetAlpha(0)

    PetFrameHappiness:ClearAllPoints()
    PetFrameHappiness:SetPoint("RIGHT", petContainer, "LEFT", 0, 0)
    PetFrameHappiness:SetSize(20, 20)
end

local petResourceEvents = CreateFrame("Frame")
petResourceEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
petResourceEvents:RegisterEvent("UNIT_PET")
petResourceEvents:RegisterEvent("UNIT_POWER_UPDATE")
petResourceEvents:SetScript("OnEvent", function(self, event, unit)
    if event == "PLAYER_ENTERING_WORLD" or event == "UNIT_PET" or 
       (event == "UNIT_POWER_UPDATE" and unit == "pet") then
        UpdatePetResources()
    end
end)