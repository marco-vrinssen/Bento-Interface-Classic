-- CREATE TARGET FRAME COMPONENTS

TargetFrameBackdrop = CreateFrame("Button", nil, TargetFrame, "SecureUnitButtonTemplate, BackdropTemplate")
TargetFrameBackdrop:SetPoint("BOTTOM", UIParent, "BOTTOM", 190, 232)
TargetFrameBackdrop:SetSize(128, 48)
TargetFrameBackdrop:SetBackdrop({ edgeFile = BORD, edgeSize = 12 })
TargetFrameBackdrop:SetBackdropBorderColor(unpack(GREY_RGB))
TargetFrameBackdrop:SetFrameLevel(TargetFrame:GetFrameLevel() + 2)
TargetFrameBackdrop:SetAttribute("unit", "target")
TargetFrameBackdrop:RegisterForClicks("AnyUp")
TargetFrameBackdrop:SetAttribute("type1", "target")
TargetFrameBackdrop:SetAttribute("type2", "togglemenu")

TargetPortraitBackdrop = CreateFrame("Button", nil, TargetFrame, "SecureUnitButtonTemplate, BackdropTemplate")
TargetPortraitBackdrop:SetPoint("LEFT", TargetFrameBackdrop, "RIGHT", 0, 0)
TargetPortraitBackdrop:SetSize(48, 48)
TargetPortraitBackdrop:SetBackdrop({ edgeFile = BORD, edgeSize = 12 })
TargetPortraitBackdrop:SetBackdropBorderColor(unpack(GREY_RGB))
TargetPortraitBackdrop:SetFrameLevel(TargetFrame:GetFrameLevel() + 4)
TargetPortraitBackdrop:SetAttribute("unit", "target")
TargetPortraitBackdrop:RegisterForClicks("AnyUp")
TargetPortraitBackdrop:SetAttribute("type1", "target")
TargetPortraitBackdrop:SetAttribute("type2", "togglemenu")

-- CONFIGURE TARGET FRAME LAYOUT

local function updateTargetFrame()
    TargetFrame:ClearAllPoints()
    TargetFrame:SetPoint("BOTTOMLEFT", TargetFrameBackdrop, "BOTTOMLEFT", 0, 0)
    TargetFrame:SetPoint("TOPRIGHT", TargetPortraitBackdrop, "TOPRIGHT", 0, 0)
    TargetFrame:SetAttribute("unit", "target")
    TargetFrame:RegisterForClicks("AnyUp")
    TargetFrame:SetAttribute("type1", "target")
    TargetFrame:SetAttribute("type2", "togglemenu")

    TargetFrameBackground:ClearAllPoints()
    TargetFrameBackground:SetPoint("TOPLEFT", TargetFrameBackdrop, "TOPLEFT", 3, -3)
    TargetFrameBackground:SetPoint("BOTTOMRIGHT", TargetFrameBackdrop, "BOTTOMRIGHT", -3, 3)

    -- HIDE AND HOOK UNWANTED TARGET FRAME ELEMENTS

    local alwaysHiddenTargetElements = {
        TargetFrameTextureFrameTexture,
        TargetFrameTextureFramePVPIcon,
        TargetFrameNameBackground,
        TargetFrameTextureFrameHighLevelTexture,
    }

    for _, alwaysHiddenTargetElement in ipairs(alwaysHiddenTargetElements) do
        if alwaysHiddenTargetElement and not alwaysHiddenTargetElement._bentoOnShowHooked then
            alwaysHiddenTargetElement:Hide()
            alwaysHiddenTargetElement:HookScript("OnShow", alwaysHiddenTargetElement.Hide)
            alwaysHiddenTargetElement._bentoOnShowHooked = true
        end
    end

    TargetFrameTextureFrameDeadText:ClearAllPoints()
    TargetFrameTextureFrameDeadText:SetPoint("CENTER", TargetFrameBackdrop, "CENTER", 0, -4)
    TargetFrameTextureFrameDeadText:SetFont(FONT, 12, "OUTLINE")
    TargetFrameTextureFrameDeadText:SetTextColor(unpack(GREY_RGB))

    TargetFrameTextureFrameName:ClearAllPoints()
    TargetFrameTextureFrameName:SetPoint("TOP", TargetFrameBackdrop, "TOP", 0, -7)
    TargetFrameTextureFrameName:SetFont(FONT, 12, "OUTLINE")
    
    TargetFrameTextureFrameLevelText:ClearAllPoints()
    TargetFrameTextureFrameLevelText:SetPoint("TOP", TargetPortraitBackdrop, "BOTTOM", 0, -4)
    TargetFrameTextureFrameLevelText:SetFont(FONT, 12, "OUTLINE")

    -- CUSTOM TARGET NAME COLORING LOGIC

    if UnitExists("target") then
        local isAttackable = UnitCanAttack("player", "target")
        local isHostile = UnitIsEnemy("player", "target")
        local reaction = UnitReaction("player", "target")
        if isAttackable then
            if isHostile then
                TargetFrameTextureFrameName:SetTextColor(unpack(RED_RGB))
            elseif reaction == 4 then
                TargetFrameTextureFrameName:SetTextColor(unpack(YELLOW_RGB))
            else
                TargetFrameTextureFrameName:SetTextColor(unpack(YELLOW_RGB))
            end
        else
            TargetFrameTextureFrameName:SetTextColor(unpack(WHITE_RGB))
        end
    end

    TargetFrameHealthBar:ClearAllPoints()
    TargetFrameHealthBar:SetSize(TargetFrameBackground:GetWidth(), 12)
    TargetFrameHealthBar:SetPoint("BOTTOM", TargetFrameManaBar, "TOP", 0, 0)

    TargetFrameManaBar:ClearAllPoints()
    TargetFrameManaBar:SetSize(TargetFrameBackground:GetWidth(), 10)
    TargetFrameManaBar:SetPoint("BOTTOM", TargetFrameBackdrop, "BOTTOM", 0, 3)
end

local targetEvents = CreateFrame("Frame")
targetEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
targetEvents:RegisterEvent("PLAYER_TARGET_CHANGED")
targetEvents:SetScript("OnEvent", updateTargetFrame)

-- SETUP TARGET PORTRAIT

local function targetPortraitUpdate()
    TargetFramePortrait:ClearAllPoints()
    TargetFramePortrait:SetPoint("CENTER", TargetPortraitBackdrop, "CENTER", 0, 0)
    TargetFramePortrait:SetSize(TargetPortraitBackdrop:GetHeight() - 6, TargetPortraitBackdrop:GetHeight() - 6)
end

local targetPortraitEvents = CreateFrame("Frame")
targetPortraitEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
targetPortraitEvents:RegisterEvent("PLAYER_TARGET_CHANGED")
targetPortraitEvents:SetScript("OnEvent", targetPortraitUpdate)

hooksecurefunc("TargetFrame_Update", targetPortraitUpdate)
hooksecurefunc("UnitFramePortrait_Update", targetPortraitUpdate)

local function portraitTextureUpdate(targetPortrait)
    if targetPortrait.unit == "target" and targetPortrait.portrait then
        if UnitIsPlayer(targetPortrait.unit) then
            local portraitTexture = CLASS_ICON_TCOORDS[select(2, UnitClass(targetPortrait.unit))]
            if portraitTexture then
                targetPortrait.portrait:SetTexture("Interface/GLUES/CHARACTERCREATE/UI-CHARACTERCREATE-CLASSES")
                local left, right, top, bottom = unpack(portraitTexture)
                local leftUpdate = left + (right - left) * 0.15
                local rightUpdate = right - (right - left) * 0.15
                local topUpdate = top + (bottom - top) * 0.15
                local bottomUpdate = bottom - (bottom - top) * 0.15
                targetPortrait.portrait:SetTexCoord(leftUpdate, rightUpdate, topUpdate, bottomUpdate)
                targetPortrait.portrait:SetDrawLayer("BACKGROUND", -1)
            end
        else
            targetPortrait.portrait:SetTexCoord(0.15, 0.85, 0.15, 0.85)
        end
    end
end

hooksecurefunc("UnitFramePortrait_Update", portraitTextureUpdate)

-- CREATE THREAT INDICATOR

local targetThreatIcon = TargetPortraitBackdrop:CreateTexture(nil, "OVERLAY")
targetThreatIcon:SetPoint("TOPLEFT", TargetPortraitBackdrop, "TOPLEFT", 4, -4)
targetThreatIcon:SetPoint("BOTTOMRIGHT", TargetPortraitBackdrop, "BOTTOMRIGHT", -4, 4)
targetThreatIcon:SetTexCoord(0.15, 0.85, 0.15, 0.85)

-- AGGRO STATUS HANDLING: TINT PORTRAIT TEXTURE RED, NO OTHER AGGRO CUSTOMIZATION

local function updateAggroStatus()
    local isTanking, threatStatus = UnitDetailedThreatSituation("player", "target")
    if threatStatus and isTanking and TargetFramePortrait then
        TargetFramePortrait:SetVertexColor(unpack(RED_RGB))
    elseif TargetFramePortrait then
        TargetFramePortrait:SetVertexColor(1, 1, 1)
    end
    targetThreatIcon:Hide()
end

local targetThreatEvents = CreateFrame("Frame")
targetThreatEvents:RegisterEvent("PLAYER_TARGET_CHANGED")
targetThreatEvents:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE")
targetThreatEvents:SetScript("OnEvent", updateAggroStatus)

hooksecurefunc("TargetFrame_Update", updateAggroStatus)

-- RECOLOR TARGET BACKDROPS AND SHOW/RECOLOR CLASSIFICATION BORDER BASED ON TARGET TYPE

local function updateTargetType()
    if not UnitExists("target") then
        TargetFrameBackdrop:SetBackdrop({ edgeFile = BORD, edgeSize = 12 })
        TargetFrameBackdrop:SetBackdropBorderColor(unpack(GREY_RGB))
        TargetPortraitBackdrop:SetBackdrop({ edgeFile = BORD, edgeSize = 12 })
        TargetPortraitBackdrop:SetBackdropBorderColor(unpack(GREY_RGB))
        return
    end

    local classification = UnitClassification("target")
    if classification == "worldboss" then
        TargetFrameBackdrop:SetBackdrop({ edgeFile = BORD, edgeSize = 16 })
        TargetFrameBackdrop:SetBackdropBorderColor(unpack(ORANGE_RGB))
        TargetPortraitBackdrop:SetBackdrop({ edgeFile = BORD, edgeSize = 18 })
        TargetPortraitBackdrop:SetBackdropBorderColor(unpack(ORANGE_RGB))
        TargetPortraitBackdrop:SetSize(50, 50)
    elseif classification == "elite" then
        TargetFrameBackdrop:SetBackdrop({ edgeFile = BORD, edgeSize = 16 })
        TargetFrameBackdrop:SetBackdropBorderColor(unpack(YELLOW_RGB))
        TargetPortraitBackdrop:SetBackdrop({ edgeFile = BORD, edgeSize = 18 })
        TargetPortraitBackdrop:SetBackdropBorderColor(unpack(YELLOW_RGB))
        TargetPortraitBackdrop:SetSize(50, 50)
    elseif classification == "rareelite" then
        TargetFrameBackdrop:SetBackdrop({ edgeFile = BORD, edgeSize = 16 })
        TargetFrameBackdrop:SetBackdropBorderColor(unpack(WHITE_RGB))
        TargetPortraitBackdrop:SetBackdrop({ edgeFile = BORD, edgeSize = 18 })
        TargetPortraitBackdrop:SetBackdropBorderColor(unpack(WHITE_RGB))
        TargetPortraitBackdrop:SetSize(50, 50)
    elseif classification == "rare" then
        TargetFrameBackdrop:SetBackdrop({ edgeFile = BORD, edgeSize = 16 })
        TargetFrameBackdrop:SetBackdropBorderColor(unpack(WHITE_RGB))
        TargetPortraitBackdrop:SetBackdrop({ edgeFile = BORD, edgeSize = 18 })
        TargetPortraitBackdrop:SetBackdropBorderColor(unpack(WHITE_RGB))
        TargetPortraitBackdrop:SetSize(50, 50)
    else
        TargetFrameBackdrop:SetBackdrop({ edgeFile = BORD, edgeSize = 12 })
        TargetFrameBackdrop:SetBackdropBorderColor(unpack(GREY_RGB))
        TargetPortraitBackdrop:SetBackdrop({ edgeFile = BORD, edgeSize = 12 })
        TargetPortraitBackdrop:SetBackdropBorderColor(unpack(GREY_RGB))
        TargetPortraitBackdrop:SetSize(48, 48)
    end
end

local targetTypeEvents = CreateFrame("Frame")
targetTypeEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
targetTypeEvents:RegisterEvent("PLAYER_TARGET_CHANGED")
targetTypeEvents:RegisterEvent("UNIT_CLASSIFICATION_CHANGED")
targetTypeEvents:SetScript("OnEvent", function(self, event, unit)
    if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_TARGET_CHANGED" or (event == "UNIT_CLASSIFICATION_CHANGED" and unit == "target") then
        updateTargetType()
    end
end)

-- SETUP TARGET RESOURCE BARS

local function updateTargetResources()
    TargetFrameHealthBar:SetStatusBarTexture(BAR)
    TargetFrameHealthBar:SetStatusBarColor(unpack(GREEN_RGB))
    TargetFrameManaBar:SetStatusBarTexture(BAR)
    local targetPowerType = UnitPowerType("target")
    if targetPowerType == 0 then -- MANA
        TargetFrameManaBar:SetStatusBarColor(unpack(BLUE_RGB))
    elseif targetPowerType == 1 then -- RAGE
        TargetFrameManaBar:SetStatusBarColor(unpack(RED_RGB))
    elseif targetPowerType == 3 then -- ENERGY
        TargetFrameManaBar:SetStatusBarColor(unpack(YELLOW_RGB))
    else
        TargetFrameManaBar:SetStatusBarColor(unpack(BLUE_RGB))
    end
end

local targetResourceEvents = CreateFrame("Frame")
targetResourceEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
targetResourceEvents:RegisterEvent("PLAYER_TARGET_CHANGED")
targetResourceEvents:RegisterEvent("UNIT_HEALTH")
targetResourceEvents:RegisterEvent("UNIT_HEALTH_FREQUENT")
targetResourceEvents:RegisterEvent("UNIT_MAXHEALTH")
targetResourceEvents:RegisterEvent("UNIT_POWER_UPDATE")
targetResourceEvents:RegisterEvent("UNIT_POWER_FREQUENT")
targetResourceEvents:RegisterEvent("UNIT_MAXPOWER")
targetResourceEvents:SetScript("OnEvent", function(_, event, unit)
    if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_TARGET_CHANGED" or unit == "target" then
        updateTargetResources()
    end
end)

-- CONFIGURE TARGET AURAS

local function updateTargetAuras()
    local maxAurasPerRow = 5
    local maxRows = 10
    local auraSize = 20
    local xOffset, yOffset = 4, 4
    local horizontalStartOffset = 4
    local verticalStartOffset = 4

    local function setupAura(aura, row, col, isDebuff)
        aura:ClearAllPoints()
        aura:SetPoint("BOTTOMLEFT", TargetFrameBackdrop, "TOPLEFT", 
            horizontalStartOffset + col * (auraSize + xOffset), 
            verticalStartOffset + row * (auraSize + yOffset))
        
        aura:SetSize(auraSize, auraSize)
        
        local border = _G[aura:GetName().."Border"]
        if border then
            border:Hide()
        end
        
        if not aura.backdrop then
            aura.backdrop = CreateFrame("Frame", nil, aura, "BackdropTemplate")
            aura.backdrop:SetPoint("TOPLEFT", aura, "TOPLEFT", -2, 2)
            aura.backdrop:SetPoint("BOTTOMRIGHT", aura, "BOTTOMRIGHT", 2, -2)
            aura.backdrop:SetBackdrop({ edgeFile = BORD, edgeSize = 8 })
            aura.backdrop:SetFrameLevel(aura:GetFrameLevel() + 2)
        end
        
        if isDebuff then
            aura.backdrop:SetBackdropBorderColor(unpack(RED_RGB))
        else
            aura.backdrop:SetBackdropBorderColor(unpack(GREY_RGB))
        end
        
        local icon = _G[aura:GetName().."Icon"]
        if icon then
            icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
        end
    end

    local buffCount = 0
    local currentBuff = _G["TargetFrameBuff1"]
    while currentBuff and currentBuff:IsShown() and buffCount < maxAurasPerRow * maxRows do
        buffCount = buffCount + 1
        currentBuff = _G["TargetFrameBuff"..(buffCount + 1)]
    end

    for i = 1, buffCount do
        local currentBuff = _G["TargetFrameBuff"..i]
        local row = math.floor((i - 1) / maxAurasPerRow)
        local col = (i - 1) % maxAurasPerRow
        setupAura(currentBuff, row, col, false)
    end

    local debuffCount = 0
    local currentDebuff = _G["TargetFrameDebuff1"]
    
    while currentDebuff and currentDebuff:IsShown() and (buffCount + debuffCount) < maxAurasPerRow * maxRows do
        debuffCount = debuffCount + 1

        local totalIndex = buffCount + debuffCount
        local row = math.floor((totalIndex - 1) / maxAurasPerRow)
        local col = (totalIndex - 1) % maxAurasPerRow
        
        setupAura(currentDebuff, row, col, true)
        
        currentDebuff = _G["TargetFrameDebuff"..(debuffCount + 1)]
    end
end

hooksecurefunc("TargetFrame_Update", updateTargetAuras)
hooksecurefunc("TargetFrame_UpdateAuras", updateTargetAuras)

local targetAuraEvents = CreateFrame("Frame")
targetAuraEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
targetAuraEvents:RegisterEvent("PLAYER_TARGET_CHANGED")
targetAuraEvents:RegisterEvent("UNIT_AURA")
targetAuraEvents:SetScript("OnEvent", function(self, event, unit)
    if unit == "target" or not unit then
        updateTargetAuras()
    end
end)

-- CREATE RAID TARGET ICON

local targetRaidIconBackdrop = CreateFrame("Frame", nil, TargetFrame, "BackdropTemplate")
targetRaidIconBackdrop:SetPoint("BOTTOMLEFT", TargetPortraitBackdrop, "TOPRIGHT", -2, -2)
targetRaidIconBackdrop:SetSize(28, 28)
targetRaidIconBackdrop:SetBackdrop({
    bgFile = BG,
    edgeFile = BORD, edgeSize = 12,
    insets = {left = 3, right = 3, top = 3, bottom = 3}
})
targetRaidIconBackdrop:SetBackdropColor(unpack(BLACK_RGB))
targetRaidIconBackdrop:SetBackdropBorderColor(unpack(GREY_RGB))
targetRaidIconBackdrop:Hide()

local function updateTargetRaidIcon()
    if GetRaidTargetIndex("target") then
        targetRaidIconBackdrop:Show()
        TargetFrameTextureFrameRaidTargetIcon:ClearAllPoints()
        TargetFrameTextureFrameRaidTargetIcon:SetPoint("CENTER", targetRaidIconBackdrop, "CENTER", 0, 0)
        TargetFrameTextureFrameRaidTargetIcon:SetSize(16, 16)
    else
        targetRaidIconBackdrop:Hide()
    end
end

local targetRaidIconEvents = CreateFrame("Frame")
targetRaidIconEvents:RegisterEvent("PLAYER_TARGET_CHANGED")
targetRaidIconEvents:RegisterEvent("RAID_TARGET_UPDATE")
targetRaidIconEvents:SetScript("OnEvent", updateTargetRaidIcon)

-- POSITION TARGET GROUP INDICATORS

local function targetGroupUpdate()
    TargetFrameTextureFrameLeaderIcon:ClearAllPoints()
    TargetFrameTextureFrameLeaderIcon:SetPoint("BOTTOM", TargetPortraitBackdrop, "TOP", 0, 0)
end

local targetGroupFrame = CreateFrame("Frame")
targetGroupFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
targetGroupFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
targetGroupFrame:SetScript("OnEvent", targetGroupUpdate)

hooksecurefunc("TargetFrame_Update", targetGroupUpdate)

-- SETUP TARGET CASTBAR

local targetSpellBarBackdrop = CreateFrame("Frame", nil, TargetFrameSpellBar, "BackdropTemplate")
targetSpellBarBackdrop:SetPoint("TOP", TargetFrameBackdrop, "BOTTOM", 0, 0)
targetSpellBarBackdrop:SetSize(TargetFrameBackdrop:GetWidth(), 24)
targetSpellBarBackdrop:SetBackdrop({ edgeFile = BORD, edgeSize = 12 })
targetSpellBarBackdrop:SetBackdropBorderColor(unpack(GREY_RGB))
targetSpellBarBackdrop:SetFrameLevel(TargetFrameSpellBar:GetFrameLevel() + 2)

local function updateTargetCastbar()
    TargetFrameSpellBar:ClearAllPoints()
    TargetFrameSpellBar:SetPoint("TOPLEFT", targetSpellBarBackdrop, "TOPLEFT", 3, -2)
    TargetFrameSpellBar:SetPoint("BOTTOMRIGHT", targetSpellBarBackdrop, "BOTTOMRIGHT", -3, 2)
    TargetFrameSpellBar:SetStatusBarTexture(BAR)
    TargetFrameSpellBar:SetStatusBarColor(unpack(YELLOW_RGB))
    TargetFrameSpellBar.Border:SetTexture(nil)
    TargetFrameSpellBar.Flash:SetTexture(nil)
    TargetFrameSpellBar.Spark:SetTexture(nil)
    TargetFrameSpellBar.Icon:SetSize(targetSpellBarBackdrop:GetHeight() - 4, targetSpellBarBackdrop:GetHeight() - 4)
    TargetFrameSpellBar.Text:ClearAllPoints()
    TargetFrameSpellBar.Text:SetPoint("TOPLEFT", TargetFrameSpellBar, "TOPLEFT", 2, -2)
    TargetFrameSpellBar.Text:SetPoint("BOTTOMRIGHT", TargetFrameSpellBar, "BOTTOMRIGHT", -2, 2)
    TargetFrameSpellBar.Text:SetFont(FONT, 10, "OUTLINE")
end

TargetFrameSpellBar:HookScript("OnShow", updateTargetCastbar)
TargetFrameSpellBar:HookScript("OnUpdate", updateTargetCastbar)

local targetCastBarEvents = CreateFrame("Frame")
targetCastBarEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
targetCastBarEvents:SetScript("OnEvent", updateTargetCastbar)

-- CONFIGURE TARGET SETTINGS

local function targetConfigUpdate()
    SetCVar("showTargetCastbar", 1)
    TARGET_FRAME_BUFFS_ON_TOP = true
end

local targetConfigEvents = CreateFrame("Frame")
targetConfigEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
targetConfigEvents:SetScript("OnEvent", targetConfigUpdate)