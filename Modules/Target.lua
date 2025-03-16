-- CREATE TARGET BACKDROPS

TargetFrameBackdrop = CreateFrame("Button", nil, TargetFrame, "SecureUnitButtonTemplate, BackdropTemplate")
TargetFrameBackdrop:SetPoint("BOTTOM", UIParent, "BOTTOM", 190, 240)
TargetFrameBackdrop:SetSize(124, 48)
TargetFrameBackdrop:SetBackdrop({ edgeFile = BORD, edgeSize = 12 })
TargetFrameBackdrop:SetBackdropBorderColor(unpack(GREY))
TargetFrameBackdrop:SetFrameLevel(TargetFrame:GetFrameLevel() + 2)
TargetFrameBackdrop:SetAttribute("unit", "target")
TargetFrameBackdrop:RegisterForClicks("AnyUp")
TargetFrameBackdrop:SetAttribute("type1", "target")
TargetFrameBackdrop:SetAttribute("type2", "togglemenu")

TargetPortraitBackdrop = CreateFrame("Button", nil, TargetFrame, "SecureUnitButtonTemplate, BackdropTemplate")
TargetPortraitBackdrop:SetPoint("LEFT", TargetFrameBackdrop, "RIGHT", 0, 0)
TargetPortraitBackdrop:SetSize(48, 48)
TargetPortraitBackdrop:SetBackdrop({ edgeFile = BORD, edgeSize = 12 })
TargetPortraitBackdrop:SetBackdropBorderColor(unpack(GREY))
TargetPortraitBackdrop:SetFrameLevel(TargetFrame:GetFrameLevel() + 2)
TargetPortraitBackdrop:SetAttribute("unit", "target")
TargetPortraitBackdrop:RegisterForClicks("AnyUp")
TargetPortraitBackdrop:SetAttribute("type1", "target")
TargetPortraitBackdrop:SetAttribute("type2", "togglemenu")


-- UPDATE TARGET FRAME

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

    TargetFrameTextureFrameTexture:Hide()
    TargetFrameTextureFramePVPIcon:SetAlpha(0)

    TargetFrameTextureFrameDeadText:Hide()

    TargetFrameNameBackground:Hide()
    TargetFrameTextureFrameName:ClearAllPoints()
    TargetFrameTextureFrameName:SetPoint("TOP", TargetFrameBackdrop, "TOP", 0, -7)
    TargetFrameTextureFrameName:SetFont(FONT, 12, "OUTLINE")
    
    TargetFrameTextureFrameLevelText:ClearAllPoints()
    TargetFrameTextureFrameLevelText:SetPoint("TOP", TargetPortraitBackdrop, "BOTTOM", 0, -4)
    TargetFrameTextureFrameLevelText:SetFont(FONT, 12, "OUTLINE")

    TargetFrameTextureFrameHighLevelTexture:Hide()

    if UnitExists("target") then
        if UnitIsPlayer("target") then
            if UnitIsEnemy("player", "target") and UnitCanAttack("player", "target") then
                TargetFrameTextureFrameName:SetTextColor(unpack(RED)) -- Red for enemy players that can be attacked
            else
                TargetFrameTextureFrameName:SetTextColor(unpack(WHITE)) -- White for neutral or friendly players
            end
        else
            if UnitIsEnemy("player", "target") and UnitCanAttack("player", "target") then
                TargetFrameTextureFrameName:SetTextColor(unpack(RED)) -- Red for hostile NPCs
            elseif UnitReaction("player", "target") == 4 and UnitCanAttack("player", "target") then
                TargetFrameTextureFrameName:SetTextColor(unpack(YELLOW)) -- Yellow for neutral but attackable NPCs
            else
                TargetFrameTextureFrameName:SetTextColor(unpack(WHITE)) -- White for neutral non-attackable or friendly NPCs
            end
        end
    end

    TargetFrameHealthBar:ClearAllPoints()
    TargetFrameHealthBar:SetSize(TargetFrameBackground:GetWidth(), 16)
    TargetFrameHealthBar:SetPoint("BOTTOM", TargetFrameManaBar, "TOP", 0, 0)

    TargetFrameManaBar:ClearAllPoints()
    TargetFrameManaBar:SetSize(TargetFrameBackground:GetWidth(), 8)
    TargetFrameManaBar:SetPoint("BOTTOM", TargetFrameBackdrop, "BOTTOM", 0, 3)
end

local targetEvents = CreateFrame("Frame")
targetEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
targetEvents:RegisterEvent("PLAYER_TARGET_CHANGED")
targetEvents:SetScript("OnEvent", updateTargetFrame)


-- UPDATE TARGET RESOURCES

local function updateTargetResources()
    TargetFrameHealthBar:SetStatusBarTexture(BAR)
    TargetFrameManaBar:SetStatusBarTexture(BAR)
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


-- UPDATE TARGET PORTRAIT

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


-- UPDATE TARGET AURAS

local function updateTargetAuras()

    -- INITIALIZE VARIABLES
    local maxAurasPerRow = 5
    local maxRows = 10
    local auraSize = 20
    local xOffset, yOffset = 4, 4
    local horizontalStartOffset = 4
    local verticalStartOffset = 4


    -- SETUP AURA FUNCTION
    local function setupAura(aura, row, col, isDebuff)
        -- Position the aura
        aura:ClearAllPoints()
        aura:SetPoint("BOTTOMLEFT", TargetFrameBackdrop, "TOPLEFT", 
            horizontalStartOffset + col * (auraSize + xOffset), 
            verticalStartOffset + row * (auraSize + yOffset))
        
        aura:SetSize(auraSize, auraSize)
        
        -- Hide default border
        local border = _G[aura:GetName().."Border"]
        if border then
            border:Hide()
        end
        
        -- Create or update backdrop
        if not aura.backdrop then
            aura.backdrop = CreateFrame("Frame", nil, aura, "BackdropTemplate")
            aura.backdrop:SetPoint("TOPLEFT", aura, "TOPLEFT", -2, 2)
            aura.backdrop:SetPoint("BOTTOMRIGHT", aura, "BOTTOMRIGHT", 2, -2)
            aura.backdrop:SetBackdrop({ edgeFile = BORD, edgeSize = 8 })
            aura.backdrop:SetFrameLevel(aura:GetFrameLevel() + 2)
        end
        
        -- Set border color based on aura type
        if isDebuff then
            aura.backdrop:SetBackdropBorderColor(unpack(RED))
        else
            aura.backdrop:SetBackdropBorderColor(unpack(GREY))
        end
        
        -- Fix icon texture
        local icon = _G[aura:GetName().."Icon"]
        if icon then
            icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
        end
    end


    -- COUNT VISIBLE BUFFS
    local buffCount = 0
    local currentBuff = _G["TargetFrameBuff1"]
    while currentBuff and currentBuff:IsShown() and buffCount < maxAurasPerRow * maxRows do
        buffCount = buffCount + 1
        currentBuff = _G["TargetFrameBuff"..(buffCount + 1)]
    end


    -- UPDATE BUFFS
    for i = 1, buffCount do
        local currentBuff = _G["TargetFrameBuff"..i]
        local row = math.floor((i - 1) / maxAurasPerRow)
        local col = (i - 1) % maxAurasPerRow
        setupAura(currentBuff, row, col, false)
    end


    -- PROCESS DEBUFFS - CONTINUE FROM WHERE BUFFS LEFT OFF
    local debuffCount = 0
    local currentDebuff = _G["TargetFrameDebuff1"]
    
    while currentDebuff and currentDebuff:IsShown() and (buffCount + debuffCount) < maxAurasPerRow * maxRows do
        debuffCount = debuffCount + 1
        
        -- Calculate position based on total number of auras (buffs + debuffs)
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


-- GENERATE AND UPDATE TARGET CLASSIFICATION TEXT

local targetTypeText = TargetFrame:CreateFontString(nil, "OVERLAY")
targetTypeText:SetFont(FONT, 12, "OUTLINE")
targetTypeText:SetPoint("BOTTOM", TargetPortraitBackdrop, "TOP", 0, 4)

local function updateTargetType()
    if not UnitExists("target") then
        targetTypeText:SetText("")
        TargetFrameBackdrop:SetBackdropBorderColor(unpack(GREY))
        TargetPortraitBackdrop:SetBackdropBorderColor(unpack(GREY))
        return
    end

    local targetClassification = UnitClassification("target")
    
    if targetClassification == "worldboss" then
        targetTypeText:SetText("Boss")
        targetTypeText:SetTextColor(unpack(ORANGE))
        TargetFrameBackdrop:SetBackdropBorderColor(unpack(ORANGE))
        TargetPortraitBackdrop:SetBackdropBorderColor(unpack(ORANGE))
    elseif targetClassification == "elite" then
        targetTypeText:SetText("Elite")
        targetTypeText:SetTextColor(unpack(YELLOW))
        TargetFrameBackdrop:SetBackdropBorderColor(unpack(YELLOW))
        TargetPortraitBackdrop:SetBackdropBorderColor(unpack(YELLOW))
    elseif targetClassification == "rare" or targetClassification == "rareelite" then
        targetTypeText:SetText("Rare")
        targetTypeText:SetTextColor(unpack(WHITE))
        TargetFrameBackdrop:SetBackdropBorderColor(unpack(WHITE))
        TargetPortraitBackdrop:SetBackdropBorderColor(unpack(WHITE))
    else
        targetTypeText:SetText("")
        TargetFrameBackdrop:SetBackdropBorderColor(unpack(GREY))
        TargetPortraitBackdrop:SetBackdropBorderColor(unpack(GREY))
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


-- CREATE AGGRO TEXT

local targetThreatText = TargetFrame:CreateFontString(nil, "OVERLAY")
targetThreatText:SetFont(FONT, 12, "OUTLINE")
targetThreatText:SetPoint("BOTTOM", targetTypeText, "TOP", 0, 8)
targetThreatText:Hide()


-- UPDATE AGGRO STATUS

local function updateAggroStatus()
    local isTanking, status, threatPct = UnitDetailedThreatSituation("player", "target")
    if status and threatPct then
        targetThreatText:SetText(string.format("%d%%", threatPct))
        if threatPct == 100 then
            targetThreatText:SetTextColor(unpack(RED))
        else
            targetThreatText:SetTextColor(unpack(YELLOW))
        end
        targetThreatText:Show()
    else
        targetThreatText:Hide()
    end
end

local targetThreatEvents = CreateFrame("Frame")
targetThreatEvents:RegisterEvent("PLAYER_TARGET_CHANGED")
targetThreatEvents:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE")
targetThreatEvents:SetScript("OnEvent", updateAggroStatus)

hooksecurefunc("TargetFrame_Update", updateAggroStatus)


-- UPDATE TARGET RAID ICON

local tragetRaidIconBackdrop = CreateFrame("Frame", nil, TargetFrame, "BackdropTemplate")
tragetRaidIconBackdrop:SetPoint("BOTTOMLEFT", TargetPortraitBackdrop, "TOPRIGHT", -2, -2)
tragetRaidIconBackdrop:SetSize(28, 28)
tragetRaidIconBackdrop:SetBackdrop({
    bgFile = BG,
    edgeFile = BORD, edgeSize = 12,
    insets = {left = 3, right = 3, top = 3, bottom = 3}
})
tragetRaidIconBackdrop:SetBackdropColor(unpack(BLACK))
tragetRaidIconBackdrop:SetBackdropBorderColor(unpack(GREY))
tragetRaidIconBackdrop:Hide()

local function updateTargetRaidIcon()
    if GetRaidTargetIndex("target") then
        tragetRaidIconBackdrop:Show()
        TargetFrameTextureFrameRaidTargetIcon:ClearAllPoints()
        TargetFrameTextureFrameRaidTargetIcon:SetPoint("CENTER", tragetRaidIconBackdrop, "CENTER", 0, 0)
        TargetFrameTextureFrameRaidTargetIcon:SetSize(12, 12)
        -- Check if icon exists before setting frame level
        if TargetFrameTextureFrameRaidTargetIcon and TargetFrameTextureFrameRaidTargetIcon.SetFrameLevel then
            TargetFrameTextureFrameRaidTargetIcon:SetFrameLevel(tragetRaidIconBackdrop:GetFrameLevel() + 2)
        end
    else
        tragetRaidIconBackdrop:Hide()
    end
end

local targetRaidIconEvents = CreateFrame("Frame")
targetRaidIconEvents:RegisterEvent("PLAYER_TARGET_CHANGED")
targetRaidIconEvents:RegisterEvent("RAID_TARGET_UPDATE")
targetRaidIconEvents:SetScript("OnEvent", updateTargetRaidIcon)


-- UPDATE TARGET GROUP INDICATORS

local function targetGroupUpdate()
    TargetFrameTextureFrameLeaderIcon:ClearAllPoints()
    TargetFrameTextureFrameLeaderIcon:SetPoint("BOTTOM", TargetPortraitBackdrop, "TOP", 0, 0)
end

local targetGroupFrame = CreateFrame("Frame")
targetGroupFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
targetGroupFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
targetGroupFrame:SetScript("OnEvent", targetGroupUpdate)

hooksecurefunc("TargetFrame_Update", targetGroupUpdate)


-- UPDATE TARGET CASTBAR

local targetSpellBarBackdrop = CreateFrame("Frame", nil, TargetFrameSpellBar, "BackdropTemplate")
targetSpellBarBackdrop:SetPoint("TOP", TargetFrameBackdrop, "BOTTOM", 0, 0)
targetSpellBarBackdrop:SetSize(TargetFrameBackdrop:GetWidth(), 24)
targetSpellBarBackdrop:SetBackdrop({ edgeFile = BORD, edgeSize = 12 })
targetSpellBarBackdrop:SetBackdropBorderColor(unpack(GREY))
targetSpellBarBackdrop:SetFrameLevel(TargetFrameSpellBar:GetFrameLevel() + 2)

local function updateTargetCastbar()
    TargetFrameSpellBar:ClearAllPoints()
    TargetFrameSpellBar:SetPoint("TOPLEFT", targetSpellBarBackdrop, "TOPLEFT", 3, -2)
    TargetFrameSpellBar:SetPoint("BOTTOMRIGHT", targetSpellBarBackdrop, "BOTTOMRIGHT", -3, 2)
    TargetFrameSpellBar:SetStatusBarTexture(BAR)
    TargetFrameSpellBar:SetStatusBarColor(unpack(YELLOW))
    TargetFrameSpellBar.Border:SetTexture(nil)
    TargetFrameSpellBar.Flash:SetTexture(nil)
    TargetFrameSpellBar.Spark:SetTexture(nil)
    TargetFrameSpellBar.Icon:SetSize(targetSpellBarBackdrop:GetHeight() - 4, targetSpellBarBackdrop:GetHeight() - 4)
    TargetFrameSpellBar.Text:ClearAllPoints()
    TargetFrameSpellBar.Text:SetAllPoints(targetSpellBarBackdrop)
    TargetFrameSpellBar.Text:SetFont(FONT, 10, "OUTLINE")
end

TargetFrameSpellBar:HookScript("OnShow", updateTargetCastbar)
TargetFrameSpellBar:HookScript("OnUpdate", updateTargetCastbar)

local targetCastBarEvents = CreateFrame("Frame")
targetCastBarEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
targetCastBarEvents:SetScript("OnEvent", updateTargetCastbar)


-- UPDATE TARGET CONFIGURATION

local function targetConfigUpdate()
    SetCVar("showTargetCastbar", 1)
    TARGET_FRAME_BUFFS_ON_TOP = true
end

local targetConfigEvents = CreateFrame("Frame")
targetConfigEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
targetConfigEvents:SetScript("OnEvent", targetConfigUpdate)