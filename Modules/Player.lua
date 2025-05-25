-- CREATE PLAYER FRAME BACKDROPS

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

-- UPDATE PLAYER FRAME
  
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

    local alwaysHiddenElements = {
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
    
    for _, alwaysHiddenElement in ipairs(alwaysHiddenElements) do
        if alwaysHiddenElement and not alwaysHiddenElement._bentoOnShowHooked then
            alwaysHiddenElement:Hide()
            alwaysHiddenElement:HookScript("OnShow", alwaysHiddenElement.Hide)
            alwaysHiddenElement._bentoOnShowHooked = true
        end
    end

    PlayerFrameHealthBar:ClearAllPoints()
    PlayerFrameHealthBar:SetSize(PlayerFrameBackground:GetWidth(), 14)
    PlayerFrameHealthBar:SetPoint("BOTTOM", PlayerFrameManaBar, "TOP", 0, 0)

    PlayerFrameManaBar:ClearAllPoints()
    PlayerFrameManaBar:SetPoint("BOTTOM", PlayerFrameBackdrop, "BOTTOM", 0, 3)
    PlayerFrameManaBar:SetSize(PlayerFrameBackground:GetWidth(), 8)

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


-- ADD DELAYED PLAYER LEVEL TEXT UPDATE

local function delayedUpdatePlayerLevel()
    C_Timer.After(0.2, function()
        local currentPlayerLevel = UnitLevel("player")
        if currentPlayerLevel == MAX_PLAYER_LEVEL then
            PlayerLevelText:Hide()
        else
            PlayerLevelText:Show()
        end
        PlayerLevelText:ClearAllPoints()
        PlayerLevelText:SetPoint("TOP", PlayerPortraitBackdrop, "BOTTOM", 0, -4)
        PlayerLevelText:SetFont(FONT, 12, "OUTLINE")
        PlayerLevelText:SetTextColor(unpack(WHITE_RGB))
    end)
end

local playerLevelEvents = CreateFrame("Frame")
playerLevelEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
playerLevelEvents:RegisterEvent("PLAYER_LEVEL_UP")
playerLevelEvents:SetScript("OnEvent", delayedUpdatePlayerLevel)


-- UPDATE PLAYER RESOURCE TEXTURES

local function updatePlayerResources()
    PlayerFrameHealthBar:SetStatusBarTexture(BAR)
    PlayerFrameHealthBar:SetStatusBarColor(unpack(GREEN_RGB))
    PlayerFrameManaBar:SetStatusBarTexture(BAR)
    local playerPowerType = UnitPowerType("player")
    if playerPowerType == 0 then -- MANA
        PlayerFrameManaBar:SetStatusBarColor(unpack(BLUE_RGB))
    elseif playerPowerType == 1 then -- RAGE
        PlayerFrameManaBar:SetStatusBarColor(unpack(RED_RGB))
    elseif playerPowerType == 3 then -- ENERGY
        PlayerFrameManaBar:SetStatusBarColor(unpack(YELLOW_RGB))
    else
        PlayerFrameManaBar:SetStatusBarColor(unpack(BLUE_RGB))
    end
end

local playerResourceEvents = CreateFrame("Frame")
playerResourceEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
playerResourceEvents:RegisterEvent("UNIT_HEALTH")
playerResourceEvents:RegisterEvent("UNIT_HEALTH_FREQUENT")
playerResourceEvents:RegisterEvent("UNIT_MAXHEALTH")
playerResourceEvents:RegisterEvent("UNIT_POWER_UPDATE")
playerResourceEvents:RegisterEvent("UNIT_POWER_FREQUENT")
playerResourceEvents:RegisterEvent("UNIT_MAXPOWER")
playerResourceEvents:SetScript("OnEvent", function(_, event, unit)
    if unit == "player" or event == "PLAYER_ENTERING_WORLD" then
        updatePlayerResources()
    end
end)


-- UPDATE PLAYER PORTRAIT
  
local function updatePlayerPortrait()
    PlayerPortrait:ClearAllPoints()
    PlayerPortrait:SetPoint("CENTER", PlayerPortraitBackdrop, "CENTER", 0, 0)
    PlayerPortrait:SetTexCoord(0.15, 0.85, 0.15, 0.85)
    PlayerPortrait:SetSize(PlayerPortraitBackdrop:GetHeight() - 6, PlayerPortraitBackdrop:GetHeight() - 6)
    
    PlayerFrame:UnregisterEvent("UNIT_COMBAT")

    PlayerLeaderIcon:ClearAllPoints()
    PlayerLeaderIcon:SetPoint("BOTTOM", PlayerPortraitBackdrop, "TOP", 0, 0)

    PlayerMasterIcon:ClearAllPoints()
    PlayerMasterIcon:SetPoint("BOTTOM", PlayerLeaderIcon, "TOP", 0, 0)
    PlayerMasterIcon:SetScale(0.75)
end

local playerPortraitEvents = CreateFrame("Frame")
playerPortraitEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
playerPortraitEvents:SetScript("OnEvent", updatePlayerPortrait)


-- UPDATE PLAYER GROUP ELEMENTS
  
local function updatePlayerGroup()
    if PlayerFrameGroupIndicator then
        PlayerFrameGroupIndicator:SetAlpha(0)
        PlayerFrameGroupIndicator:Hide()
        
        if not PlayerFrameGroupIndicator.hooked then
            hooksecurefunc(PlayerFrameGroupIndicator, "Show", function(self)
                self:SetAlpha(0)
                self:Hide()
            end)
            PlayerFrameGroupIndicator.hooked = true
        end
    end

    local multiGroupFrame = _G["MultiGroupFrame"]
    if multiGroupFrame then
        multiGroupFrame:SetTexture(nil)
        multiGroupFrame:SetAlpha(0)
        multiGroupFrame:Hide()
        
        if not multiGroupFrame.hooked then
            hooksecurefunc(multiGroupFrame, "Show", function(self)
                self:SetTexture(nil)
                self:SetAlpha(0)
                self:Hide()
            end)
            multiGroupFrame.hooked = true
        end
    end
end

local playerGroupEvents = CreateFrame("Frame")
playerGroupEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
playerGroupEvents:RegisterEvent("GROUP_ROSTER_UPDATE")
playerGroupEvents:RegisterEvent("PARTY_LEADER_CHANGED")
playerGroupEvents:SetScript("OnEvent", updatePlayerGroup)