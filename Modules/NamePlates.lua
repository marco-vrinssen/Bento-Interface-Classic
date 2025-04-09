-- CREATE BACKDROP FOR HEALTHBAR

local function createHealthbarBackdrop(parent)
    local healthbarBackdrop = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    healthbarBackdrop:SetPoint("TOPLEFT", parent, "TOPLEFT", -3, 3)
    healthbarBackdrop:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", 3, -3)
    healthbarBackdrop:SetBackdrop({edgeFile = BORD, edgeSize = 12})
    healthbarBackdrop:SetBackdropBorderColor(unpack(GREY))
    healthbarBackdrop:SetFrameStrata("HIGH")
    return healthbarBackdrop
end

-- CREATE BACKDROP FOR CASTBAR

local function createCastbarBackdrop(parent)
    local castbarBackdrop = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    castbarBackdrop:SetPoint("TOPLEFT", parent, "TOPLEFT", -3, 3)
    castbarBackdrop:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", 3, -3)
    castbarBackdrop:SetBackdrop({edgeFile = BORD, edgeSize = 12})
    castbarBackdrop:SetBackdropBorderColor(unpack(GREY))
    castbarBackdrop:SetFrameStrata("HIGH")
    return castbarBackdrop
end


-- HANDLE CASTBAR ANIMATION UPDATES

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


-- SETUP NAMEPLATE CASTBAR

local function nameplateCastbarSetup(nameplate)
    local healthbarReference = nameplate.UnitFrame.healthBar

    local namePlateCastBar = CreateFrame("StatusBar", nil, nameplate)
    namePlateCastBar:SetStatusBarTexture(BAR)
    namePlateCastBar:SetStatusBarColor(unpack(YELLOW))
    namePlateCastBar:SetSize(healthbarReference:GetWidth(), 10)
    namePlateCastBar:SetPoint("TOP", healthbarReference, "BOTTOM", 0, -4)
    namePlateCastBar:SetMinMaxValues(0, 1)
    namePlateCastBar:SetValue(0)

    -- Use a separate backdrop style for the castbar
    namePlateCastBar.backdrop = createCastbarBackdrop(namePlateCastBar)

    local castBarText = namePlateCastBar:CreateFontString(nil, "OVERLAY")
    castBarText:SetFont(FONT, 8, "OUTLINE")
    castBarText:SetPoint("CENTER", namePlateCastBar)

    namePlateCastBar.CastBarText = castBarText
    namePlateCastBar:Hide()

    return namePlateCastBar
end


-- UPDATE NAMEPLATE CASTBAR

local function updateNamePlateCastBar(namePlateCastBar, unit)
    if not namePlateCastBar or not unit then return end
    
    local name, _, _, startTime, endTime, _, _, spellInterruptible = UnitCastingInfo(unit)
    local channelName, _, _, channelStartTime, channelEndTime = UnitChannelInfo(unit)

    if name or channelName then
        local castDuration = (endTime or channelEndTime) / 1000
        local currentTimer = GetTime()

        namePlateCastBar:SetMinMaxValues((startTime or channelStartTime) / 1000, castDuration)
        namePlateCastBar:SetValue(currentTimer)

        if spellInterruptible then
            namePlateCastBar:SetStatusBarColor(unpack(GREY))
        else
            namePlateCastBar:SetStatusBarColor(unpack(YELLOW))
        end

        namePlateCastBar.casting = name ~= nil
        namePlateCastBar.channeling = channelName ~= nil
        namePlateCastBar.maxValue = castDuration
        namePlateCastBar.CastBarText:SetText(name or channelName)
        namePlateCastBar:Show()
    else
        namePlateCastBar:Hide()
    end
end


-- UPDATE HEALTHBAR COLOR

local function updateNamePlateHealthBar(nameplate, unitID)
    if not nameplate or not unitID then return end
    
    local nameplateHealthbar = nameplate.UnitFrame.healthBar
    
    if not nameplateHealthbar.originalColor then
        local r, g, b = nameplateHealthbar:GetStatusBarColor()
        nameplateHealthbar.originalColor = {r, g, b}
    end

    local unitThreat = UnitThreatSituation("player", unitID)
    local unitTapState = UnitIsTapDenied(unitID)
    
    if unitThreat and unitThreat >= 2 then
        nameplateHealthbar:SetStatusBarColor(unpack(ORANGE))
    elseif unitTapState then
        nameplateHealthbar:SetStatusBarColor(unpack(GREY))
    elseif UnitCanAttack("player", unitID) then
        if UnitReaction(unitID, "player") <= 3 then
            nameplateHealthbar:SetStatusBarColor(unpack(RED))
        else
            nameplateHealthbar:SetStatusBarColor(unpack(YELLOW))
        end
    else
        nameplateHealthbar:SetStatusBarColor(unpack(GREEN))
    end
end


-- UPDATE NAMEPLATE APPEARANCE

local function nameplateUpdate(nameplate, unitID)
    local unitNameplate = nameplate and nameplate.UnitFrame
    if not unitNameplate then return end

    local nameplateHealthbar = unitNameplate.healthBar

    nameplateHealthbar:SetStatusBarTexture(BAR)
    
    nameplateHealthbar.border:Hide()
    unitNameplate.LevelFrame:Hide()

    if not nameplateHealthbar.backdrop then
        nameplateHealthbar.backdrop = createHealthbarBackdrop(nameplateHealthbar)
    end

    nameplateHealthbar:ClearAllPoints()
    nameplateHealthbar:SetPoint("CENTER", unitNameplate, "CENTER", 0, 8)
    nameplateHealthbar:SetWidth(unitNameplate:GetWidth())

    unitNameplate.name:ClearAllPoints()
    unitNameplate.name:SetPoint("BOTTOM", nameplateHealthbar, "TOP", 0, 8)
    unitNameplate.name:SetFont(FONT, 12, "OUTLINE")
    
    unitNameplate.name:SetTextColor(unpack(WHITE))
    
    if unitNameplate.RaidTargetFrame then
        unitNameplate.RaidTargetFrame:ClearAllPoints()
        unitNameplate.RaidTargetFrame:SetPoint("LEFT", nameplateHealthbar, "RIGHT", 8, 0)
    end
    
    updateNamePlateHealthBar(nameplate, unitID)
    
    if not nameplate.namePlateCastBar then
        nameplate.namePlateCastBar = nameplateCastbarSetup(nameplate)
        nameplate.namePlateCastBar:SetScript("OnUpdate", onUpdate)
    end
    
    updateNamePlateCastBar(nameplate.namePlateCastBar, unitID)
end


-- HANDLE NAMEPLATE SHOW EVENT

local function nameplateOnShow(nameplate)
    local unitID = nameplate.unit
    if unitID then
        nameplateUpdate(nameplate, unitID)
    end
end


-- REGISTER NAMEPLATE EVENTS

local nameplateEvents = CreateFrame("Frame")
nameplateEvents:RegisterEvent("NAME_PLATE_UNIT_ADDED")
nameplateEvents:SetScript("OnEvent", function(self, event, unitID)
    local nameplate = C_NamePlate.GetNamePlateForUnit(unitID)
    if nameplate then
        nameplateUpdate(nameplate, unitID)
    end
end)


-- REGISTER THREAT EVENTS

local nameplateHealthBarEvents = CreateFrame("Frame")
nameplateHealthBarEvents:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE")
nameplateHealthBarEvents:RegisterEvent("UNIT_THREAT_LIST_UPDATE")
nameplateHealthBarEvents:SetScript("OnEvent", function(self, event, unitID)
    local nameplate = C_NamePlate.GetNamePlateForUnit(unitID)
    if nameplate then
        updateNamePlateHealthBar(nameplate, unitID)
    end
end)


-- REGISTER CASTBAR EVENTS

local nameplateCastbarEvents = CreateFrame("Frame")
nameplateCastbarEvents:RegisterEvent("NAME_PLATE_UNIT_ADDED")
nameplateCastbarEvents:RegisterEvent("UNIT_SPELLCAST_START")
nameplateCastbarEvents:RegisterEvent("UNIT_SPELLCAST_STOP")
nameplateCastbarEvents:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
nameplateCastbarEvents:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
nameplateCastbarEvents:SetScript("OnEvent", function(self, event, unitID)
    local nameplate = C_NamePlate.GetNamePlateForUnit(unitID)
    if nameplate then
        if not nameplate.namePlateCastBar then
            nameplate.namePlateCastBar = nameplateCastbarSetup(nameplate)
            nameplate.namePlateCastBar:SetScript("OnUpdate", onUpdate)
        end
        updateNamePlateCastBar(nameplate.namePlateCastBar, unitID)
    end
end)


-- UPDATE NAMEPLATE CONFIG

local function nameplateConfigUpdate()
    SetCVar("nameplateMinScale", 0.8)
    
    SetCVar("nameplateSelectedScale", 1)
    SetCVar("nameplateMaxScale", 1)
    
    SetCVar("nameplateOverlapH", 1)
    SetCVar("nameplateOverlapV", 1)
    
    SetCVar("nameplateMaxDistance", 40)
end

local nameplateConfigEvents = CreateFrame("Frame")
nameplateConfigEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
nameplateConfigEvents:SetScript("OnEvent", nameplateConfigUpdate)