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
    PlayerFrameManaBar:SetStatusBarTexture(BAR)
end

-- HOOK PLAYER FRAME UPDATES TO MAINTAIN CUSTOM TEXTURES

local function enforcePlayerBarTextures()
    if PlayerFrameHealthBar then
        PlayerFrameHealthBar:SetStatusBarTexture(BAR)
    end
    if PlayerFrameManaBar then
        PlayerFrameManaBar:SetStatusBarTexture(BAR)
    end
end

hooksecurefunc("PlayerFrame_Update", enforcePlayerBarTextures)
hooksecurefunc("UnitFrameHealthBar_Update", function(statusbar, unit)
    if unit == "player" and statusbar then
        statusbar:SetStatusBarTexture(BAR)
    end
end)
hooksecurefunc("UnitFrameManaBar_Update", function(statusbar, unit)
    if unit == "player" and statusbar then
        statusbar:SetStatusBarTexture(BAR)
    end
end)

local playerResourceEvents = CreateFrame("Frame")
playerResourceEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
playerResourceEvents:RegisterEvent("UNIT_HEALTH")
playerResourceEvents:RegisterEvent("UNIT_HEALTH_FREQUENT")
playerResourceEvents:RegisterEvent("UNIT_MAXHEALTH")
playerResourceEvents:RegisterEvent("UNIT_POWER_UPDATE")
playerResourceEvents:RegisterEvent("UNIT_POWER_FREQUENT")
playerResourceEvents:RegisterEvent("UNIT_MAXPOWER")
playerResourceEvents:RegisterEvent("PLAYER_REGEN_ENABLED")
playerResourceEvents:RegisterEvent("PLAYER_REGEN_DISABLED")
playerResourceEvents:RegisterEvent("UNIT_AURA")
playerResourceEvents:SetScript("OnEvent", function(_, event, unit)
    if unit == "player" or event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_REGEN_ENABLED" or event == "PLAYER_REGEN_DISABLED" or not unit then
        updatePlayerResources()
        enforcePlayerBarTextures()
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

-- CREATE PLAYER COMBAT INDICATOR

local playerCombatBackdrop = CreateFrame("Frame", nil, PlayerFrame, "BackdropTemplate")
playerCombatBackdrop:SetPoint("BOTTOMRIGHT", PlayerPortraitBackdrop, "TOPLEFT", 2, 2)
playerCombatBackdrop:SetSize(28, 28)
playerCombatBackdrop:SetBackdrop({
    bgFile = BG,
    edgeFile = BORD, edgeSize = 12,
    insets = {left = 3, right = 3, top = 3, bottom = 3}
})
playerCombatBackdrop:SetBackdropColor(unpack(BLACK_RGB))
playerCombatBackdrop:SetBackdropBorderColor(unpack(GREY_RGB))
playerCombatBackdrop:Hide()

local playerCombatIcon = playerCombatBackdrop:CreateTexture(nil, "OVERLAY")
playerCombatIcon:SetPoint("CENTER", playerCombatBackdrop, "CENTER", 0, 0)
playerCombatIcon:SetSize(16 * 1.2, 16 * 1.2)
playerCombatIcon:SetTexture("Interface\\CharacterFrame\\UI-StateIcon")
playerCombatIcon:SetTexCoord(0.5, 1.0, 0.0, 0.5)

local function updatePlayerCombat()
    if UnitAffectingCombat("player") then
        playerCombatBackdrop:Show()
    else
        playerCombatBackdrop:Hide()
    end
end

local playerCombatEvents = CreateFrame("Frame")
playerCombatEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
playerCombatEvents:RegisterEvent("PLAYER_REGEN_ENABLED")
playerCombatEvents:RegisterEvent("PLAYER_REGEN_DISABLED")
playerCombatEvents:SetScript("OnEvent", updatePlayerCombat)