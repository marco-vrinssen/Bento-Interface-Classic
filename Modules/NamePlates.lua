-- Create backdrop frame with healthbar parent to provide visual border
local function createHealthbarBackdrop(parent)
    local healthbarBackdrop = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    healthbarBackdrop:SetPoint("TOPLEFT", parent, "TOPLEFT", -3, 3)
    healthbarBackdrop:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", 3, -3)
    healthbarBackdrop:SetBackdrop({edgeFile = BORD, edgeSize = 12})
    healthbarBackdrop:SetBackdropBorderColor(unpack(GREY_RGB))
    healthbarBackdrop:SetFrameStrata("HIGH")
    return healthbarBackdrop
end

-- Create backdrop frame with castbar parent to provide visual border
local function createCastbarBackdrop(parent)
    local castbarBackdrop = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    castbarBackdrop:SetPoint("TOPLEFT", parent, "TOPLEFT", -3, 3)
    castbarBackdrop:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", 3, -3)
    castbarBackdrop:SetBackdrop({edgeFile = BORD, edgeSize = 12})
    castbarBackdrop:SetBackdropBorderColor(unpack(GREY_RGB))
    castbarBackdrop:SetFrameStrata("HIGH")
    return castbarBackdrop
end

-- Update casting progress with elapsed time to maintain animation
local function onUpdate(self, elapsed)
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

-- Create castbar frame with nameplate reference to display spell progress
local function setupNameplateCastbar(nameplate)
    local healthbarReference = nameplate.UnitFrame.healthBar

    local castbar = CreateFrame("StatusBar", nil, nameplate)
    castbar:SetStatusBarTexture(BAR)
    castbar:SetStatusBarColor(unpack(YELLOW_RGB))
    castbar:SetSize(healthbarReference:GetWidth(), 10)
    castbar:SetPoint("TOP", healthbarReference, "BOTTOM", 0, -4)
    castbar:SetMinMaxValues(0, 1)
    castbar:SetValue(0)

    castbar.backdrop = createCastbarBackdrop(castbar)

    local castbarText = castbar:CreateFontString(nil, "OVERLAY")
    castbarText:SetFont(FONT, 8, "OUTLINE")
    castbarText:SetPoint("CENTER", castbar)

    castbar.CastBarText = castbarText
    castbar:Hide()

    return castbar
end

-- Update castbar values with unit information to reflect current spell
local function updateCastbar(castbar, unit)
    if not castbar or not unit then return end
    
    local name, _, _, startTime, endTime, _, _, spellInterruptible = UnitCastingInfo(unit)
    local channelName, _, _, channelStartTime, channelEndTime = UnitChannelInfo(unit)

    if name or channelName then
        local castDuration = (endTime or channelEndTime) / 1000
        local currentTimer = GetTime()

        castbar:SetMinMaxValues((startTime or channelStartTime) / 1000, castDuration)
        castbar:SetValue(currentTimer)

        if spellInterruptible then
            castbar:SetStatusBarColor(unpack(GREY_RGB))
        else
            castbar:SetStatusBarColor(unpack(YELLOW_RGB))
        end

        castbar.casting = name ~= nil
        castbar.channeling = channelName ~= nil
        castbar.maxValue = castDuration
        castbar.CastBarText:SetText(name or channelName)
        castbar:Show()
    else
        castbar:Hide()
    end
end

-- Update healthbar color with unit status to reflect threat levels
local function updateHealthbarColor(nameplate, unitID)
    if not nameplate or not unitID then return end
    
    local healthbar = nameplate.UnitFrame.healthBar
    
    if not healthbar.originalColor then
        local r, g, b = healthbar:GetStatusBarColor()
        healthbar.originalColor = {r, g, b}
    end

    local unitThreat = UnitThreatSituation("player", unitID)
    local unitTapState = UnitIsTapDenied(unitID)
    
    if unitThreat and unitThreat >= 2 then
        healthbar:SetStatusBarColor(unpack(ORANGE_RGB))
    elseif unitTapState then
        healthbar:SetStatusBarColor(unpack(GREY_RGB))
    elseif UnitCanAttack("player", unitID) then
        if UnitReaction(unitID, "player") <= 3 then
            healthbar:SetStatusBarColor(unpack(RED_RGB))
        else
            healthbar:SetStatusBarColor(unpack(YELLOW_RGB))
        end
    else
        healthbar:SetStatusBarColor(unpack(GREEN_RGB))
    end
end

-- Update nameplate elements with unit styling to improve visibility
local function updateNameplate(nameplate, unitID)
    local unitFrame = nameplate and nameplate.UnitFrame
    if not unitFrame then return end

    local healthbar = unitFrame.healthBar

    healthbar:SetStatusBarTexture(BAR)
    
    healthbar.border:Hide()
    unitFrame.LevelFrame:Hide()

    if not healthbar.backdrop then
        healthbar.backdrop = createHealthbarBackdrop(healthbar)
    end

    healthbar:ClearAllPoints()
    healthbar:SetPoint("CENTER", unitFrame, "CENTER", 0, 8)
    healthbar:SetWidth(unitFrame:GetWidth())

    unitFrame.name:ClearAllPoints()
    unitFrame.name:SetPoint("BOTTOM", healthbar, "TOP", 0, 8)
    unitFrame.name:SetFont(FONT, 12, "OUTLINE")
    
    unitFrame.name:SetTextColor(unpack(WHITE_RGB))
    
    if unitFrame.RaidTargetFrame then
        unitFrame.RaidTargetFrame:ClearAllPoints()
        unitFrame.RaidTargetFrame:SetPoint("LEFT", healthbar, "RIGHT", 8, 0)
    end
    
    updateHealthbarColor(nameplate, unitID)
    
    if not nameplate.castbar then
        nameplate.castbar = setupNameplateCastbar(nameplate)
        nameplate.castbar:SetScript("OnUpdate", onUpdate)
    end
    
    updateCastbar(nameplate.castbar, unitID)
end

-- Handle nameplate show with unit styling to initialize appearance
local function onNameplateShow(nameplate)
    local unitID = nameplate.unit
    if unitID then
        updateNameplate(nameplate, unitID)
    end
end

-- Register nameplate events with unit handling to track appearing nameplates
local nameplateEvents = CreateFrame("Frame")
nameplateEvents:RegisterEvent("NAME_PLATE_UNIT_ADDED")
nameplateEvents:SetScript("OnEvent", function(self, event, unitID)
    local nameplate = C_NamePlate.GetNamePlateForUnit(unitID)
    if nameplate then
        updateNameplate(nameplate, unitID)
    end
end)

-- Register threat events with healthbar updates to track combat status
local threatEvents = CreateFrame("Frame")
threatEvents:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE")
threatEvents:RegisterEvent("UNIT_THREAT_LIST_UPDATE")
threatEvents:SetScript("OnEvent", function(self, event, unitID)
    local nameplate = C_NamePlate.GetNamePlateForUnit(unitID)
    if nameplate then
        updateHealthbarColor(nameplate, unitID)
    end
end)

-- Register castbar events with spell tracking to monitor cast progress
local castbarEvents = CreateFrame("Frame")
castbarEvents:RegisterEvent("NAME_PLATE_UNIT_ADDED")
castbarEvents:RegisterEvent("UNIT_SPELLCAST_START")
castbarEvents:RegisterEvent("UNIT_SPELLCAST_STOP")
castbarEvents:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
castbarEvents:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
castbarEvents:SetScript("OnEvent", function(self, event, unitID)
    local nameplate = C_NamePlate.GetNamePlateForUnit(unitID)
    if nameplate then
        if not nameplate.castbar then
            nameplate.castbar = setupNameplateCastbar(nameplate)
            nameplate.castbar:SetScript("OnUpdate", onUpdate)
        end
        updateCastbar(nameplate.castbar, unitID)
    end
end)

-- Update nameplate config with optimal settings to improve nameplate behavior
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