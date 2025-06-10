-- Create healthbarBackdrop with parentFrame to provide visual border

local function createHealthbarBackdrop(parentFrame)
    local healthbarBackdrop = CreateFrame("Frame", nil, parentFrame, "BackdropTemplate")
    healthbarBackdrop:SetPoint("TOPLEFT", parentFrame, "TOPLEFT", -3, 3)
    healthbarBackdrop:SetPoint("BOTTOMRIGHT", parentFrame, "BOTTOMRIGHT", 3, -3)
    healthbarBackdrop:SetBackdrop({edgeFile = BORD, edgeSize = 12})
    healthbarBackdrop:SetBackdropBorderColor(unpack(GREY_RGB))
    healthbarBackdrop:SetFrameStrata("HIGH")
    return healthbarBackdrop
end

-- Create castbarBackdrop with parentFrame to provide visual border

local function createCastbarBackdrop(parentFrame)
    local castbarBackdrop = CreateFrame("Frame", nil, parentFrame, "BackdropTemplate")
    castbarBackdrop:SetPoint("TOPLEFT", parentFrame, "TOPLEFT", -3, 3)
    castbarBackdrop:SetPoint("BOTTOMRIGHT", parentFrame, "BOTTOMRIGHT", 3, -3)
    castbarBackdrop:SetBackdrop({edgeFile = BORD, edgeSize = 12})
    castbarBackdrop:SetBackdropBorderColor(unpack(GREY_RGB))
    castbarBackdrop:SetFrameStrata("HIGH")
    return castbarBackdrop
end

-- Update castingProgress with elapsedTime to maintain animation

local function onUpdateTimer(self, elapsedTime)
    if self.casting or self.channeling then
        local currentTimer = GetTime()
        if currentTimer > self.maxValue then
            self:SetValue(self.maxValue)
            self.casting = false
            self.channeling = false
            self:Hide()
        else
            self:SetValue(currentTimer)
        end
    end
end

-- Create nameplateCastbar with nameplateReference to display spell progress

local function setupNameplateCastbar(nameplateReference)
    local healthbarReference = nameplateReference.UnitFrame.healthBar

    local nameplateCastbar = CreateFrame("StatusBar", nil, nameplateReference)
    nameplateCastbar:SetStatusBarTexture(BAR)
    nameplateCastbar:SetStatusBarColor(unpack(YELLOW_RGB))
    nameplateCastbar:SetSize(healthbarReference:GetWidth(), 10)
    nameplateCastbar:SetPoint("TOP", healthbarReference, "BOTTOM", 0, -4)
    nameplateCastbar:SetMinMaxValues(0, 1)
    nameplateCastbar:SetValue(0)

    nameplateCastbar.backdrop = createCastbarBackdrop(nameplateCastbar)

    local castbarText = nameplateCastbar:CreateFontString(nil, "OVERLAY")
    castbarText:SetFont(FONT, 8, "OUTLINE")
    castbarText:SetPoint("CENTER", nameplateCastbar)

    nameplateCastbar.CastBarText = castbarText
    nameplateCastbar:Hide()

    return nameplateCastbar
end

-- Update castbarValues with unitInformation to reflect current spell

local function updateCastbarValues(castbarReference, unitInformation)
    if not castbarReference or not unitInformation then return end
    
    local name, _, _, startTime, endTime, _, _, spellInterruptible = UnitCastingInfo(unitInformation)
    local channelName, _, _, channelStartTime, channelEndTime = UnitChannelInfo(unitInformation)

    if name or channelName then
        local castDuration = (endTime or channelEndTime) / 1000
        local currentTimer = GetTime()

        castbarReference:SetMinMaxValues((startTime or channelStartTime) / 1000, castDuration)
        castbarReference:SetValue(currentTimer)

        if spellInterruptible then
            castbarReference:SetStatusBarColor(unpack(GREY_RGB))
        else
            castbarReference:SetStatusBarColor(unpack(YELLOW_RGB))
        end

        castbarReference.casting = name ~= nil
        castbarReference.channeling = channelName ~= nil
        castbarReference.maxValue = castDuration
        castbarReference.CastBarText:SetText(name or channelName)
        castbarReference:Show()
    else
        castbarReference:Hide()
    end
end

-- Update healthbarColors with unitStatus to reflect threat levels

local function updateHealthbarColors(nameplateReference, unitID)
    if not nameplateReference or not unitID then return end
    
    local healthbarReference = nameplateReference.UnitFrame.healthBar
    
    if not healthbarReference.originalColor then
        local r, g, b = healthbarReference:GetStatusBarColor()
        healthbarReference.originalColor = {r, g, b}
    end

    local unitThreat = UnitThreatSituation("player", unitID)
    local unitTapState = UnitIsTapDenied(unitID)
    
    if unitThreat and unitThreat >= 2 then
        healthbarReference:SetStatusBarColor(unpack(ORANGE_RGB))
    elseif unitTapState then
        healthbarReference:SetStatusBarColor(unpack(GREY_RGB))
    elseif UnitCanAttack("player", unitID) then
        if UnitReaction(unitID, "player") <= 3 then
            healthbarReference:SetStatusBarColor(unpack(RED_RGB))
        else
            healthbarReference:SetStatusBarColor(unpack(YELLOW_RGB))
        end
    else
        healthbarReference:SetStatusBarColor(unpack(GREEN_RGB))
    end
end

-- Update nameplateElements with unitStyling to improve visibility

local function updateNameplateElements(nameplateReference, unitID)
    local unitFrame = nameplateReference and nameplateReference.UnitFrame
    if not unitFrame then return end

    local healthbarReference = unitFrame.healthBar

    healthbarReference:SetStatusBarTexture(BAR)
    
    healthbarReference.border:Hide()
    unitFrame.LevelFrame:Hide()

    if not healthbarReference.backdrop then
        healthbarReference.backdrop = createHealthbarBackdrop(healthbarReference)
    end

    healthbarReference:ClearAllPoints()
    healthbarReference:SetPoint("CENTER", unitFrame, "CENTER", 0, 8)
    healthbarReference:SetWidth(unitFrame:GetWidth())

    unitFrame.name:ClearAllPoints()
    unitFrame.name:SetPoint("BOTTOM", healthbarReference, "TOP", 0, 8)
    unitFrame.name:SetFont(FONT, 12, "OUTLINE")
    
    unitFrame.name:SetTextColor(unpack(WHITE_RGB))
    
    if unitFrame.RaidTargetFrame then
        unitFrame.RaidTargetFrame:ClearAllPoints()
        unitFrame.RaidTargetFrame:SetPoint("LEFT", healthbarReference, "RIGHT", 8, 0)
    end
    
    updateHealthbarColors(nameplateReference, unitID)
    
    if not nameplateReference.castbar then
        nameplateReference.castbar = setupNameplateCastbar(nameplateReference)
        nameplateReference.castbar:SetScript("OnUpdate", onUpdateTimer)
    end
    
    updateCastbarValues(nameplateReference.castbar, unitID)
end

-- Handle nameplateShow with unitStyling to initialize appearance

local function onNameplateShow(nameplateReference)
    local unitID = nameplateReference.unit
    if unitID then
        updateNameplateElements(nameplateReference, unitID)
    end
end

-- Register nameplateEvents with unitHandling to track appearing nameplates

local nameplateEvents = CreateFrame("Frame")
nameplateEvents:RegisterEvent("NAME_PLATE_UNIT_ADDED")
nameplateEvents:SetScript("OnEvent", function(self, event, unitID)
    local nameplateReference = C_NamePlate.GetNamePlateForUnit(unitID)
    if nameplateReference then
        updateNameplateElements(nameplateReference, unitID)
    end
end)

-- Register threatEvents with healthbarUpdates to track combat status

local threatEvents = CreateFrame("Frame")
threatEvents:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE")
threatEvents:RegisterEvent("UNIT_THREAT_LIST_UPDATE")
threatEvents:SetScript("OnEvent", function(self, event, unitID)
    local nameplateReference = C_NamePlate.GetNamePlateForUnit(unitID)
    if nameplateReference then
        updateHealthbarColors(nameplateReference, unitID)
    end
end)

-- Register castbarEvents with spellTracking to monitor cast progress

local castbarEvents = CreateFrame("Frame")
castbarEvents:RegisterEvent("NAME_PLATE_UNIT_ADDED")
castbarEvents:RegisterEvent("UNIT_SPELLCAST_START")
castbarEvents:RegisterEvent("UNIT_SPELLCAST_STOP")
castbarEvents:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
castbarEvents:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
castbarEvents:SetScript("OnEvent", function(self, event, unitID)
    local nameplateReference = C_NamePlate.GetNamePlateForUnit(unitID)
    if nameplateReference then
        if not nameplateReference.castbar then
            nameplateReference.castbar = setupNameplateCastbar(nameplateReference)
            nameplateReference.castbar:SetScript("OnUpdate", onUpdateTimer)
        end
        updateCastbarValues(nameplateReference.castbar, unitID)
    end
end)

-- Update nameplateConfig with optimalSettings to improve nameplate behavior

local function updateNameplateConfig()
    SetCVar("nameplateMinScale", 0.8)
    
    SetCVar("nameplateSelectedScale", 1)
    SetCVar("nameplateMaxScale", 1)
    
    SetCVar("nameplateOverlapH", 1)
    SetCVar("nameplateOverlapV", 1)
    
    SetCVar("nameplateMaxDistance", 40)
end

local configEvents = CreateFrame("Frame")
configEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
configEvents:SetScript("OnEvent", updateNameplateConfig)