-- CREATE PET FRAME BACKDROP

local PetFrameBackdrop = CreateFrame("Button", nil, PetFrame, "SecureUnitButtonTemplate, BackdropTemplate")
PetFrameBackdrop:SetPoint("BOTTOMRIGHT", PlayerPortraitBackdrop, "BOTTOMLEFT", 0, 0)
PetFrameBackdrop:SetSize(64, 24)
PetFrameBackdrop:SetBackdrop({edgeFile = BORD, edgeSize = 12})
PetFrameBackdrop:SetBackdropBorderColor(unpack(GREY))
PetFrameBackdrop:SetFrameLevel(PetFrame:GetFrameLevel() + 2)
PetFrameBackdrop:SetAttribute("unit", "pet")
PetFrameBackdrop:RegisterForClicks("AnyUp")
PetFrameBackdrop:SetAttribute("type1", "target")
PetFrameBackdrop:SetAttribute("type2", "togglemenu")


-- UPDATE PET FRAME

local function updatePetFrame()
	PetFrame:ClearAllPoints()
	PetFrame:SetPoint("CENTER", PetFrameBackdrop, "CENTER", 0, 0)
	PetFrame:SetSize(PetFrameBackdrop:GetWidth(), PetFrameBackdrop:GetHeight())
    PetFrame:UnregisterEvent("UNIT_COMBAT")
	PetAttackModeTexture:SetTexture(nil)
    PetFrameTexture:Hide()
   
    PetPortrait:Hide()

    PetName:ClearAllPoints()
    PetName:SetPoint("BOTTOMRIGHT", PetFrameBackdrop, "TOPRIGHT", -2, 2)
    PetName:SetWidth(PetFrameBackdrop:GetWidth() - 4)
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
    PetFrameHealthBar:SetPoint("TOP", PetFrameBackdrop, "TOP", 0, -2)
    PetFrameHealthBar:SetPoint("BOTTOM", PetFrameManaBar, "TOP", 0, 0)
    PetFrameHealthBar:SetWidth(PetFrameBackdrop:GetWidth()-6)
    PetFrameHealthBar:SetStatusBarTexture(BAR)
    
    PetFrameManaBar:ClearAllPoints()
    PetFrameManaBar:SetPoint("BOTTOM", PetFrameBackdrop, "BOTTOM", 0, 2)
    PetFrameManaBar:SetWidth(PetFrameBackdrop:GetWidth()-6)
    PetFrameManaBar:SetHeight(8)
    PetFrameManaBar:SetStatusBarTexture(BAR)
    
    PetFrameHealthBarText:SetAlpha(0)
    PetFrameHealthBarTextLeft:SetAlpha(0)
    PetFrameHealthBarTextRight:SetAlpha(0)

    PetFrameManaBarText:SetAlpha(0)
    PetFrameManaBarTextLeft:SetAlpha(0)
    PetFrameManaBarTextRight:SetAlpha(0)
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


-- CREATE PET HAPPINESS BACKDROP

local petHappinessBackdrop = CreateFrame("Frame", nil, PetFrame, "BackdropTemplate")
petHappinessBackdrop:SetSize(24, 24)
petHappinessBackdrop:SetPoint("RIGHT", PetFrameBackdrop, "LEFT", 0, 0)
petHappinessBackdrop:SetBackdrop({
    bgFile = "Interface\\Icons\\ability_hunter_beasttraining",
    edgeFile = BORD, edgeSize = 12,
    insets = {left = 2, right = 2, top = 2, bottom = 2}
})
petHappinessBackdrop:SetBackdropBorderColor(unpack(GREY))
petHappinessBackdrop:SetFrameLevel(PetFrame:GetFrameLevel() + 2)


-- UPDATE PET HAPPINESS

local function updatePetHappiness()
    PetFrameHappiness:Hide()
    PetFrameHappinessTexture:Hide()

    local happiness = GetPetHappiness()
    if happiness and happiness < 3 then
        petHappinessBackdrop:Show()
    else
        petHappinessBackdrop:Hide()
    end
end

local petHappinessEvents = CreateFrame("Frame")
petHappinessEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
petHappinessEvents:RegisterEvent("UNIT_HAPPINESS")
petHappinessEvents:RegisterEvent("UNIT_PET")
petHappinessEvents:SetScript("OnEvent", function(self, event, unit)
    if unit == "pet" or event == "PLAYER_ENTERING_WORLD" then
        updatePetHappiness()
    end
end)