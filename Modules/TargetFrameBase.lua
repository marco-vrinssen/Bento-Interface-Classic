-- Create target frame components and configure base layout

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

    -- Hide unwanted target frame elements for cleaner UI

    local hiddenTargetElements = {
        TargetFrameTextureFrameTexture,
        TargetFrameTextureFramePVPIcon,
        TargetFrameNameBackground,
        TargetFrameTextureFrameHighLevelTexture,
    }

    for _, hiddenElement in ipairs(hiddenTargetElements) do
        if hiddenElement and not hiddenElement._bentoOnShowHooked then
            hiddenElement:Hide()
            hiddenElement:HookScript("OnShow", hiddenElement.Hide)
            hiddenElement._bentoOnShowHooked = true
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

    -- Update target name color based on unit relation

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

-- Update target settings for configuration

local function updateTargetConfigSettings()
    SetCVar("showTargetCastbar", 1)
    TARGET_FRAME_BUFFS_ON_TOP = true
end

local targetConfigEvents = CreateFrame("Frame")
targetConfigEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
targetConfigEvents:SetScript("OnEvent", updateTargetConfigSettings)
