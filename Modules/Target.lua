-- Create target frame components for custom layout

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

-- Configure target frame layout and hide unwanted elements

local function updateTargetFrameLayout()
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

    -- Hide and hook unwanted target frame elements for cleaner UI

    local alwaysHiddenTargetElements = {
        TargetFrameTextureFrameTexture,
        TargetFrameTextureFramePVPIcon,
        TargetFrameNameBackground,
        TargetFrameTextureFrameHighLevelTexture,
    }

    for _, hiddenElement in ipairs(alwaysHiddenTargetElements) do
        if hiddenElement and not hiddenElement._bentoOnShowHooked then
            hiddenElement:Hide()
            hiddenElement:HookScript("OnShow", hiddenElement.Hide)
            hiddenElement._bentoOnShowHooked = true
        end
    end

    TargetFrameTextureFrameDeadText:ClearAllPoints()
    TargetFrameTextureFrameDeadText:SetParent(TargetFrameBackdrop)
    TargetFrameTextureFrameDeadText:SetPoint("CENTER", TargetFrameBackdrop, "CENTER", 0, -4)
    TargetFrameTextureFrameDeadText:SetFont(FONT, 12, "OUTLINE")
    TargetFrameTextureFrameDeadText:SetTextColor(unpack(WHITE_RGB))

    TargetFrameTextureFrameName:ClearAllPoints()
    TargetFrameTextureFrameName:SetPoint("TOPLEFT", TargetFrameBackdrop, "TOPLEFT", 8, -8)
    TargetFrameTextureFrameName:SetPoint("TOPRIGHT", TargetFrameBackdrop, "TOPRIGHT", -8, -8)
    TargetFrameTextureFrameName:SetFont(FONT, 12, "OUTLINE")

    TargetFrameTextureFrameLevelText:ClearAllPoints()
    TargetFrameTextureFrameLevelText:SetPoint("TOP", TargetPortraitBackdrop, "BOTTOM", 0, -4)
    TargetFrameTextureFrameLevelText:SetFont(FONT, 12, "OUTLINE")

    -- Update target name color for clarity

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

local targetFrameEvents = CreateFrame("Frame")
targetFrameEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
targetFrameEvents:RegisterEvent("PLAYER_TARGET_CHANGED")
targetFrameEvents:SetScript("OnEvent", updateTargetFrameLayout)

-- Setup target portrait for custom position and size

local function updateTargetPortrait()
    TargetFramePortrait:ClearAllPoints()
    TargetFramePortrait:SetPoint("CENTER", TargetPortraitBackdrop, "CENTER", 0, 0)
    TargetFramePortrait:SetSize(TargetPortraitBackdrop:GetHeight() - 6, TargetPortraitBackdrop:GetHeight() - 6)
end

local targetPortraitEvents = CreateFrame("Frame")
targetPortraitEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
targetPortraitEvents:RegisterEvent("PLAYER_TARGET_CHANGED")
targetPortraitEvents:SetScript("OnEvent", updateTargetPortrait)

hooksecurefunc("TargetFrame_Update", updateTargetPortrait)
hooksecurefunc("UnitFramePortrait_Update", updateTargetPortrait)

-- Update portrait texture for class or NPC

local function updatePortraitTexture(targetPortrait)
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

hooksecurefunc("UnitFramePortrait_Update", updatePortraitTexture)

-- Create threat indicator for aggro status

local targetThreatIcon = TargetPortraitBackdrop:CreateTexture(nil, "OVERLAY")
targetThreatIcon:SetPoint("TOPLEFT", TargetPortraitBackdrop, "TOPLEFT", 4, -4)
targetThreatIcon:SetPoint("BOTTOMRIGHT", TargetPortraitBackdrop, "BOTTOMRIGHT", -4, 4)
targetThreatIcon:SetTexCoord(0.15, 0.85, 0.15, 0.85)

-- Update aggro status to tint portrait red if tanking

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

-- Update target backdrops and border color for classification

local function updateTargetClassification()
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
    elseif classification == "rareelite" or classification == "rare" then
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
        updateTargetClassification()
    end
end)

-- Update target resource bars for custom textures

local function updateTargetResourceBars()
    TargetFrameHealthBar:SetStatusBarTexture(BAR)
    TargetFrameManaBar:SetStatusBarTexture(BAR)
end

-- Enforce custom bar textures on target frame

local function enforceTargetBarTextures()
    if TargetFrameHealthBar then
        TargetFrameHealthBar:SetStatusBarTexture(BAR)
    end
    if TargetFrameManaBar then
        TargetFrameManaBar:SetStatusBarTexture(BAR)
    end
end

hooksecurefunc("TargetFrame_Update", enforceTargetBarTextures)
hooksecurefunc("UnitFrameHealthBar_Update", function(statusbar, unit)
    if unit == "target" and statusbar then
        statusbar:SetStatusBarTexture(BAR)
    end
end)
hooksecurefunc("UnitFrameManaBar_Update", function(statusbar, unit)
    if unit == "target" and statusbar then
        statusbar:SetStatusBarTexture(BAR)
    end
end)

local targetResourceEvents = CreateFrame("Frame")
targetResourceEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
targetResourceEvents:RegisterEvent("PLAYER_TARGET_CHANGED")
targetResourceEvents:RegisterEvent("UNIT_HEALTH")
targetResourceEvents:RegisterEvent("UNIT_HEALTH_FREQUENT")
targetResourceEvents:RegisterEvent("UNIT_MAXHEALTH")
targetResourceEvents:RegisterEvent("UNIT_POWER_UPDATE")
targetResourceEvents:RegisterEvent("UNIT_POWER_FREQUENT")
targetResourceEvents:RegisterEvent("UNIT_MAXPOWER")
targetResourceEvents:RegisterEvent("PLAYER_REGEN_ENABLED")
targetResourceEvents:RegisterEvent("PLAYER_REGEN_DISABLED")
targetResourceEvents:RegisterEvent("UNIT_AURA")
targetResourceEvents:SetScript("OnEvent", function(_, event, unit)
    if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_TARGET_CHANGED" or event == "PLAYER_REGEN_ENABLED" or event == "PLAYER_REGEN_DISABLED" or unit == "target" or not unit then
        updateTargetResourceBars()
        enforceTargetBarTextures()
    end
end)

-- Update target auras for custom layout and border

local function updateTargetAurasLayout()
    local maxAurasPerRow = 5
    local maxRows = 10
    local auraSize = 20
    local xOffset, yOffset = 4, 4
    local horizontalStartOffset = 4
    local verticalStartOffset = 4

    local function setupAuraFrame(aura, row, col, isDebuff)
        aura:ClearAllPoints()
        aura:SetPoint("BOTTOMLEFT", TargetFrameBackdrop, "TOPLEFT", 
            horizontalStartOffset + col * (auraSize + xOffset), 
            verticalStartOffset + row * (auraSize + yOffset))
        aura:SetSize(auraSize, auraSize)
        local border = _G[aura:GetName().."Border"]
        if border then border:Hide() end
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
        if icon then icon:SetTexCoord(0.1, 0.9, 0.1, 0.9) end
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
        setupAuraFrame(currentBuff, row, col, false)
    end
    local debuffCount = 0
    local currentDebuff = _G["TargetFrameDebuff1"]
    while currentDebuff and currentDebuff:IsShown() and (buffCount + debuffCount) < maxAurasPerRow * maxRows do
        debuffCount = debuffCount + 1
        local totalIndex = buffCount + debuffCount
        local row = math.floor((totalIndex - 1) / maxAurasPerRow)
        local col = (totalIndex - 1) % maxAurasPerRow
        setupAuraFrame(currentDebuff, row, col, true)
        currentDebuff = _G["TargetFrameDebuff"..(debuffCount + 1)]
    end
end

hooksecurefunc("TargetFrame_Update", updateTargetAurasLayout)
hooksecurefunc("TargetFrame_UpdateAuras", updateTargetAurasLayout)

local targetAuraEvents = CreateFrame("Frame")
targetAuraEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
targetAuraEvents:RegisterEvent("PLAYER_TARGET_CHANGED")
targetAuraEvents:RegisterEvent("UNIT_AURA")
targetAuraEvents:SetScript("OnEvent", function(self, event, unit)
    if unit == "target" or not unit then
        updateTargetAurasLayout()
    end
end)

-- Create raid target icon with custom backdrop

local raidIconBackdrop = CreateFrame("Frame", nil, TargetFrame, "BackdropTemplate")
raidIconBackdrop:SetPoint("BOTTOMLEFT", TargetPortraitBackdrop, "TOPRIGHT", -2, -2)
raidIconBackdrop:SetSize(28, 28)
raidIconBackdrop:SetBackdrop({
    bgFile = BG,
    edgeFile = BORD, edgeSize = 12,
    insets = {left = 3, right = 3, top = 3, bottom = 3}
})
raidIconBackdrop:SetBackdropColor(unpack(BLACK_RGB))
raidIconBackdrop:SetBackdropBorderColor(unpack(GREY_RGB))
raidIconBackdrop:Hide()

-- Update raid icon position and visibility for target

local function updateRaidIconPosition()
    if GetRaidTargetIndex("target") then
        raidIconBackdrop:Show()
        TargetFrameTextureFrameRaidTargetIcon:ClearAllPoints()
        TargetFrameTextureFrameRaidTargetIcon:SetPoint("CENTER", raidIconBackdrop, "CENTER", 0, 0)
        TargetFrameTextureFrameRaidTargetIcon:SetSize(16, 16)
    else
        raidIconBackdrop:Hide()
    end
end

local raidIconEvents = CreateFrame("Frame")
raidIconEvents:RegisterEvent("PLAYER_TARGET_CHANGED")
raidIconEvents:RegisterEvent("RAID_TARGET_UPDATE")
raidIconEvents:SetScript("OnEvent", updateRaidIconPosition)

-- Update target group indicators for leader icon

local function updateTargetGroupIndicators()
    TargetFrameTextureFrameLeaderIcon:ClearAllPoints()
    TargetFrameTextureFrameLeaderIcon:SetPoint("BOTTOM", TargetPortraitBackdrop, "TOP", 0, 0)
end

local targetGroupFrame = CreateFrame("Frame")
targetGroupFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
targetGroupFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
targetGroupFrame:SetScript("OnEvent", updateTargetGroupIndicators)

hooksecurefunc("TargetFrame_Update", updateTargetGroupIndicators)

-- Setup target castbar with custom backdrop and font

local targetSpellBarBackdrop = CreateFrame("Frame", nil, TargetFrameSpellBar, "BackdropTemplate")
targetSpellBarBackdrop:SetPoint("TOP", TargetFrameBackdrop, "BOTTOM", 0, 0)
targetSpellBarBackdrop:SetSize(TargetFrameBackdrop:GetWidth(), 24)
targetSpellBarBackdrop:SetBackdrop({ edgeFile = BORD, edgeSize = 12 })
targetSpellBarBackdrop:SetBackdropBorderColor(unpack(GREY_RGB))
targetSpellBarBackdrop:SetFrameLevel(TargetFrameSpellBar:GetFrameLevel() + 2)

-- Add backdrop to target spell bar icon and zoom icon texture

local targetCastBarIconBackdrop = CreateFrame("Frame", nil, TargetFrameSpellBar, "BackdropTemplate")
targetCastBarIconBackdrop:SetPoint("CENTER", TargetFrameSpellBar.Icon, "CENTER", 0, 0)
targetCastBarIconBackdrop:SetSize(TargetFrameSpellBar.Icon:GetWidth() + 6, TargetFrameSpellBar.Icon:GetHeight() + 6)
targetCastBarIconBackdrop:SetBackdrop({ edgeFile = BORD, edgeSize = 12 })
targetCastBarIconBackdrop:SetBackdropBorderColor(unpack(GREY_RGB))
targetCastBarIconBackdrop:SetFrameLevel(TargetFrameSpellBar:GetFrameLevel() + 3)

-- Update target cast bar layout and icon appearance

local function updateTargetCastBarLayout()
    TargetFrameSpellBar:ClearAllPoints()
    TargetFrameSpellBar:SetPoint("TOPLEFT", targetSpellBarBackdrop, "TOPLEFT", 3, -2)
    TargetFrameSpellBar:SetPoint("BOTTOMRIGHT", targetSpellBarBackdrop, "BOTTOMRIGHT", -3, 2)
    TargetFrameSpellBar:SetStatusBarTexture(BAR)
    TargetFrameSpellBar:SetStatusBarColor(unpack(YELLOW_RGB))
    TargetFrameSpellBar.Border:SetTexture(nil)
    TargetFrameSpellBar.Flash:SetTexture(nil)
    TargetFrameSpellBar.Spark:SetTexture(nil)

    TargetFrameSpellBar.Icon:SetSize(targetSpellBarBackdrop:GetHeight() - 6, targetSpellBarBackdrop:GetHeight() - 6)
    targetCastBarIconBackdrop:SetPoint("CENTER", TargetFrameSpellBar.Icon, "CENTER", 0, 0)
    targetCastBarIconBackdrop:SetSize(TargetFrameSpellBar.Icon:GetWidth() + 6, TargetFrameSpellBar.Icon:GetHeight() + 6)
    TargetFrameSpellBar.Icon:SetTexCoord(0.2, 0.8, 0.2, 0.8)

    TargetFrameSpellBar.Text:ClearAllPoints()
    TargetFrameSpellBar.Text:SetPoint("TOPLEFT", TargetFrameSpellBar, "TOPLEFT", 2, -2)
    TargetFrameSpellBar.Text:SetPoint("BOTTOMRIGHT", TargetFrameSpellBar, "BOTTOMRIGHT", -2, 2)
    TargetFrameSpellBar.Text:SetFont(FONT, 10, "OUTLINE")
end

TargetFrameSpellBar:HookScript("OnShow", updateTargetCastBarLayout)
TargetFrameSpellBar:HookScript("OnUpdate", updateTargetCastBarLayout)

local targetCastBarEvents = CreateFrame("Frame")
targetCastBarEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
targetCastBarEvents:SetScript("OnEvent", updateTargetCastBarLayout)

-- Update target settings for castbar and buffs

local function updateTargetConfigSettings()
    SetCVar("showTargetCastbar", 1)
    TARGET_FRAME_BUFFS_ON_TOP = true
end

local targetConfigEvents = CreateFrame("Frame")
targetConfigEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
targetConfigEvents:SetScript("OnEvent", updateTargetConfigSettings)






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