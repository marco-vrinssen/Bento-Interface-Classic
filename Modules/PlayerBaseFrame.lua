-- Create player frame components and configure base layout

PlayerFrameBackdrop = CreateFrame("Button", nil, PlayerFrame, "SecureUnitButtonTemplate, BackdropTemplate")
PlayerFrameBackdrop:SetPoint("BOTTOM", UIParent, "BOTTOM", -190, 232)
PlayerFrameBackdrop:SetSize(128, 48)
PlayerFrameBackdrop:SetBackdrop({edgeFile = BORD, edgeSize = 12})
PlayerFrameBackdrop:SetBackdropBorderColor(unpack(GREY_RGB))
PlayerFrameBackdrop:SetFrameLevel(PlayerFrame:GetFrameLevel() + 2)
PlayerFrameBackdrop:SetAttribute("unit", "player")
PlayerFrameBackdrop:RegisterForClicks("AnyUp")
PlayerFrameBackdrop:SetAttribute("type1", "target")
PlayerFrameBackdrop:SetAttribute("type2", "togglemenu")

PlayerPortraitBackdrop = CreateFrame("Button", nil, PlayerFrame, "SecureUnitButtonTemplate, BackdropTemplate")
PlayerPortraitBackdrop:SetPoint("RIGHT", PlayerFrameBackdrop, "LEFT", 0, 0)
PlayerPortraitBackdrop:SetSize(48, 48)
PlayerPortraitBackdrop:SetBackdrop({edgeFile = BORD, edgeSize = 12})
PlayerPortraitBackdrop:SetBackdropBorderColor(unpack(GREY_RGB))
PlayerPortraitBackdrop:SetFrameLevel(PlayerFrame:GetFrameLevel() + 2)
PlayerPortraitBackdrop:SetAttribute("unit", "player")
PlayerPortraitBackdrop:RegisterForClicks("AnyUp")
PlayerPortraitBackdrop:SetAttribute("type1", "target")
PlayerPortraitBackdrop:SetAttribute("type2", "togglemenu")

-- Position elements within backdrop boundaries for clean layout

local function updatePlayerElements()
    PlayerFrame:ClearAllPoints()
    PlayerFrame:SetPoint("TOPLEFT", PlayerPortraitBackdrop, "TOPLEFT", 0, 0)
    PlayerFrame:SetPoint("BOTTOMRIGHT", PlayerFrameBackdrop, "BOTTOMRIGHT", 0, 0)

    PlayerFrameBackground:ClearAllPoints()
    PlayerFrameBackground:SetPoint("TOPLEFT", PlayerFrameBackdrop, "TOPLEFT", 3, -3)
    PlayerFrameBackground:SetPoint("BOTTOMRIGHT", PlayerFrameBackdrop, "BOTTOMRIGHT", -3, 3)

    PlayerName:ClearAllPoints()
    PlayerName:SetPoint("TOP", PlayerFrameBackdrop, "TOP", 0, -6)
    PlayerName:SetFont(FONT, 12, "OUTLINE")
    PlayerName:SetTextColor(unpack(WHITE_RGB))

    -- Hide unwanted player frame elements for cleaner UI

    local hiddenPlayerElements = {
        PlayerFrameTexture,
        PlayerStatusTexture,
        PlayerStatusGlow,
        PlayerAttackBackground,
        PlayerAttackGlow,
        PlayerAttackIcon,
        PlayerRestGlow,
        PlayerRestIcon,
        PlayerPVPIconHitArea,
        PlayerPVPTimerText,
        PlayerPVPIcon,
    }
    
    for _, hiddenElement in ipairs(hiddenPlayerElements) do
        if hiddenElement and not hiddenElement._bentoOnShowHooked then
            hiddenElement:Hide()
            hiddenElement:HookScript("OnShow", hiddenElement.Hide)
            hiddenElement._bentoOnShowHooked = true
        end
    end

    PlayerFrameHealthBar:ClearAllPoints()
    PlayerFrameHealthBar:SetSize(PlayerFrameBackground:GetWidth(), 12)
    PlayerFrameHealthBar:SetPoint("BOTTOM", PlayerFrameManaBar, "TOP", 0, 0)

    PlayerFrameManaBar:ClearAllPoints()
    PlayerFrameManaBar:SetPoint("BOTTOM", PlayerFrameBackdrop, "BOTTOM", 0, 3)
    PlayerFrameManaBar:SetSize(PlayerFrameBackground:GetWidth(), 10)

    PlayerFrameHealthBarText:SetPoint("CENTER", PlayerFrameHealthBar, "CENTER", 0, 0)
    PlayerFrameHealthBarText:SetFont(FONT, 12, "OUTLINE")
    PlayerFrameHealthBarTextRight:SetPoint("RIGHT", PlayerFrameHealthBar, "RIGHT", -4, 0)
    PlayerFrameHealthBarTextRight:SetFont(FONT, 12, "OUTLINE")
    PlayerFrameHealthBarTextLeft:SetPoint("LEFT", PlayerFrameHealthBar, "LEFT", 4, 0)
    PlayerFrameHealthBarTextLeft:SetFont(FONT, 12, "OUTLINE")

    PlayerFrameManaBarText:SetPoint("CENTER", PlayerFrameManaBar, "CENTER", 0, 0)
    PlayerFrameManaBarText:SetFont(FONT, 8, "OUTLINE")
    PlayerFrameManaBarTextLeft:SetPoint("LEFT", PlayerFrameManaBar, "LEFT", 4, 0)
    PlayerFrameManaBarTextLeft:SetFont(FONT, 8, "OUTLINE")
    PlayerFrameManaBarTextRight:SetPoint("RIGHT", PlayerFrameManaBar, "RIGHT", -4, 0)
    PlayerFrameManaBarTextRight:SetFont(FONT, 8, "OUTLINE")
end

local playerElementEvents = CreateFrame("Frame")
playerElementEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
playerElementEvents:SetScript("OnEvent", updatePlayerElements)
