-- Create interactive player frames

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

-- Position elements within backdrops

local function updateElements()
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

    local hiddenElements = {
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
    
    for _, element in ipairs(hiddenElements) do
        if element and not element._bentoOnShowHooked then
            element:Hide()
            element:HookScript("OnShow", element.Hide)
            element._bentoOnShowHooked = true
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
playerElementEvents:SetScript("OnEvent", updateElements)

-- Update player level with delay

local function updateDelayedLevel()
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
playerLevelEvents:SetScript("OnEvent", updateDelayedLevel)

-- Apply custom bar textures

local function updateResources()
    PlayerFrameHealthBar:SetStatusBarTexture(BAR)
    PlayerFrameManaBar:SetStatusBarTexture(BAR)
end

-- Enforce bar texture consistency

local function enforceBarTextures()
    if PlayerFrameHealthBar then
        PlayerFrameHealthBar:SetStatusBarTexture(BAR)
    end
    if PlayerFrameManaBar then
        PlayerFrameManaBar:SetStatusBarTexture(BAR)
    end
end

hooksecurefunc("PlayerFrame_Update", enforceBarTextures)
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
        updateResources()
        enforceBarTextures()
    end
end)

-- Position portrait with cropped coordinates

local function updatePortrait()
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
playerPortraitEvents:SetScript("OnEvent", updatePortrait)


-- Hide group indicator elements

local function updateGroup()
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
playerGroupEvents:SetScript("OnEvent", updateGroup)

-- Create combat indicator frame

local playerCombatBackdrop = CreateFrame("Frame", nil, PlayerFrame, "BackdropTemplate")
playerCombatBackdrop:SetPoint("BOTTOMRIGHT", PlayerPortraitBackdrop, "TOPLEFT", 2, -2)
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

-- Update combat state visibility

local function updateCombat()
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
playerCombatEvents:SetScript("OnEvent", updateCombat)





-- Create pet container with backdrop

local petContainer = CreateFrame("Button", nil, PetFrame, "SecureUnitButtonTemplate, BackdropTemplate")
petContainer:SetPoint("BOTTOMRIGHT", PlayerPortraitBackdrop, "BOTTOMLEFT", 0, 0)
petContainer:SetSize(64, 24)
petContainer:SetBackdrop({edgeFile = BORD, edgeSize = 12})
petContainer:SetBackdropBorderColor(unpack(GREY_RGB))
petContainer:SetFrameLevel(PetFrame:GetFrameLevel() + 2)
petContainer:SetAttribute("unit", "pet")
petContainer:RegisterForClicks("AnyUp")
petContainer:SetAttribute("type1", "target")
petContainer:SetAttribute("type2", "togglemenu")

-- Create pet background frame

local petBackground = CreateFrame("Frame", nil, petContainer, "BackdropTemplate")
petBackground:SetPoint("TOPLEFT", petContainer, "TOPLEFT", 2, -2)
petBackground:SetPoint("BOTTOMRIGHT", petContainer, "BOTTOMRIGHT", -2, 2)
petBackground:SetBackdrop({ bgFile = BG })
petBackground:SetBackdropColor(unpack(BLACK_RGB))
petBackground:SetFrameLevel(petContainer:GetFrameLevel() - 1)

-- Configure pet frame positioning

local function configurePet()
	PetFrame:ClearAllPoints()
	PetFrame:SetPoint("CENTER", petContainer, "CENTER", 0, 0)
	PetFrame:SetSize(petContainer:GetWidth(), petContainer:GetHeight())
    PetFrame:UnregisterEvent("UNIT_COMBAT")
	PetAttackModeTexture:SetTexture(nil)
    PetFrameTexture:Hide()
    PetPortrait:Hide()
    PetName:ClearAllPoints()
    PetName:SetPoint("BOTTOMRIGHT", petContainer, "TOPRIGHT", -2, 2)
    PetName:SetWidth(petContainer:GetWidth() - 4)
    PetName:SetFont(FONT, 10, "OUTLINE")
    PetName:SetTextColor(unpack(WHITE_RGB))
	for i = 1, MAX_TARGET_BUFFS do
		local petBuff = _G["PetFrameBuff" .. i]
		if petBuff then
			petBuff:SetAlpha(0)
		end
	end
	for i = 1, MAX_TARGET_DEBUFFS do
		local petDebuff = _G["PetFrameDebuff" .. i]
		if petDebuff then
			petDebuff:SetAlpha(0)
		end
	end
end

local petFrameEvents = CreateFrame("Frame")
petFrameEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
petFrameEvents:RegisterEvent("UNIT_PET")
petFrameEvents:SetScript("OnEvent", configurePet)

-- Configure pet resource bars

local function configurePetBars()
    PetFrameHealthBar:ClearAllPoints()
    PetFrameHealthBar:SetPoint("TOP", petContainer, "TOP", 0, -2)
    PetFrameHealthBar:SetPoint("BOTTOM", PetFrameManaBar, "TOP", 0, 0)
    PetFrameHealthBar:SetWidth(petContainer:GetWidth()-6)
    PetFrameHealthBar:SetStatusBarTexture(BAR)
    PetFrameManaBar:ClearAllPoints()
    PetFrameManaBar:SetPoint("BOTTOM", petContainer, "BOTTOM", 0, 2)
    PetFrameManaBar:SetWidth(petContainer:GetWidth()-6)
    PetFrameManaBar:SetHeight(8)
    PetFrameManaBar:SetStatusBarTexture(BAR)
    PetFrameHealthBarText:SetAlpha(0)
    PetFrameHealthBarTextLeft:SetAlpha(0)
    PetFrameHealthBarTextRight:SetAlpha(0)
    PetFrameManaBarText:SetAlpha(0)
    PetFrameManaBarTextLeft:SetAlpha(0)
    PetFrameManaBarTextRight:SetAlpha(0)
    PetFrameHappiness:ClearAllPoints()
    PetFrameHappiness:SetPoint("RIGHT", petContainer, "LEFT", 0, 0)
    PetFrameHappiness:SetSize(20, 20)
end

local petResourceEvents = CreateFrame("Frame")
petResourceEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
petResourceEvents:RegisterEvent("UNIT_PET")
petResourceEvents:RegisterEvent("UNIT_POWER_UPDATE")
petResourceEvents:SetScript("OnEvent", function(self, event, unit)
    if event == "PLAYER_ENTERING_WORLD" or event == "UNIT_PET" or 
       (event == "UNIT_POWER_UPDATE" and unit == "pet") then
        configurePetBars()
    end
end)