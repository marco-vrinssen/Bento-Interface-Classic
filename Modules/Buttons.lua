-- Position actionBars with optimal layout to achieve proper ui alignment

local function positionActionBars()
    MainMenuBar:SetWidth(512)
    MainMenuBar:ClearAllPoints()
    MainMenuBar:SetPoint("BOTTOM", UIParent, "BOTTOM", -2, 72)
    MainMenuBar:SetMovable(true)
    MainMenuBar:SetUserPlaced(true)

    MultiBarBottomLeft:Show()
    MultiBarBottomLeft:ClearAllPoints()
    MultiBarBottomLeft:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 118)
    MultiBarBottomLeft:SetMovable(true)
    MultiBarBottomLeft:SetUserPlaced(true)

    MultiBarBottomRight:Show()
    MultiBarBottomRight:ClearAllPoints()
    MultiBarBottomRight:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 24)
    MultiBarBottomRight:SetMovable(true)
    MultiBarBottomRight:SetUserPlaced(true)
    MultiBarBottomRight:SetScale(0.8)

    MultiBarRight:ClearAllPoints()
    MultiBarRight:SetPoint("RIGHT", UIParent, "RIGHT", -16, 0)
    MultiBarRight:SetMovable(true)
    MultiBarRight:SetUserPlaced(true)

    MultiBarLeft:ClearAllPoints()
    MultiBarLeft:SetPoint("RIGHT", MultiBarRight, "LEFT", -2, 0)
    MultiBarLeft:SetMovable(true)
    MultiBarLeft:SetUserPlaced(true)

    MainMenuBarLeftEndCap:Hide()
    MainMenuBarRightEndCap:Hide()
    MainMenuBarPageNumber:Hide()
    ActionBarUpButton:Hide()
    ActionBarDownButton:Hide()
    MainMenuBarTexture0:Hide()
    MainMenuBarTexture1:Hide()
    MainMenuBarTexture2:Hide()
    MainMenuBarTexture3:Hide()
    MainMenuMaxLevelBar0:Hide()
    MainMenuMaxLevelBar1:Hide()
    MainMenuMaxLevelBar2:Hide()
    MainMenuMaxLevelBar3:Hide()
    MainMenuBarMaxLevelBar:Hide()
    MainMenuBarOverlayFrame:Hide()
    
    SlidingActionBarTexture0:Hide()
    SlidingActionBarTexture0.Show = SlidingActionBarTexture0.Hide

    SlidingActionBarTexture1:Hide()
    SlidingActionBarTexture1.Show = SlidingActionBarTexture1.Hide

    MainMenuBarPerformanceBarFrame:Hide()
    MainMenuBarPerformanceBarFrame.Show = MainMenuBarPerformanceBarFrame.Hide
end

local actionBarEventFrame = CreateFrame("Frame")
actionBarEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
actionBarEventFrame:SetScript("OnEvent", positionActionBars)

-- Update buttonUsability with opacity to achieve visual feedback

local function updateButtonUsability(self)
    if not self or not self.action then 
        return 
    end

    local isUsable = IsUsableAction(self.action)
    local inRange = IsActionInRange(self.action)

    local alpha = (not isUsable or inRange == false) and 0.5 or 1.0
    self.icon:SetAlpha(alpha)
end

hooksecurefunc("ActionButton_OnUpdate", updateButtonUsability)

-- Customize actionButtons with styling to achieve visual consistency

local function styleActionButtons()
    local function hideTextures(button)
        if button then
            local normalTexture = _G[button:GetName() .. "NormalTexture"]
            if normalTexture then
                normalTexture:SetAlpha(0)
                normalTexture:SetTexture(nil)
            end
            local floatingBG = _G[button:GetName() .. "FloatingBG"]
            if floatingBG then
                floatingBG:SetAlpha(0)
                floatingBG:SetTexture(nil)
            end
        end
    end

    local function addBorder(button)
        if button then
            if not button.customBorder then
                local backdrop = CreateFrame("Frame", nil, button, "BackdropTemplate")
                backdrop:SetPoint("TOPLEFT", button, "TOPLEFT", -3, 3)
                backdrop:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 3, -3)
                backdrop:SetBackdrop({ edgeFile = BORD, edgeSize = 12 })
                backdrop:SetBackdropBorderColor(unpack(GREY_RGB))
                backdrop:SetFrameLevel(button:GetFrameLevel() + 2)
                button.customBorder = backdrop
            end

            local icon = _G[button:GetName() .. "Icon"]
            if icon then
                icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
            end
        end
    end

    local function styleFonts(button)
        if button then
            local macroName = _G[button:GetName() .. "Name"]
            if macroName then
                macroName:SetFont(FONT, 10, "OUTLINE")
                macroName:SetTextColor(unpack(WHITE_RGB))
                macroName:SetAlpha(0.5)
            end
            local hotkey = _G[button:GetName() .. "HotKey"]
            if hotkey then
                hotkey:SetFont(FONT, 12, "OUTLINE")
                hotkey:SetTextColor(unpack(WHITE_RGB))
                hotkey:SetAlpha(0.75)
            end
        end
    end

    for i = 1, 12 do
        local buttonList = {
            _G["ActionButton" .. i],
            _G["MultiBarBottomLeftButton" .. i],
            _G["MultiBarBottomRightButton" .. i],
            _G["MultiBarRightButton" .. i],
            _G["MultiBarLeftButton" .. i]
        }
        for _, button in ipairs(buttonList) do
            hideTextures(button)
            addBorder(button)
            styleFonts(button)
        end
    end
end

local buttonEventFrame = CreateFrame("Frame")
buttonEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
buttonEventFrame:SetScript("OnEvent", styleActionButtons)

-- Style stanceButtons with borders to achieve visual uniformity

local function hideStanceTextures(button)
    for numTextures = 1, 3 do
        local normalTexture = _G[button:GetName() .. "NormalTexture" .. numTextures]
        if normalTexture then
            normalTexture:SetAlpha(0)
            normalTexture:SetTexture(nil)
        end
    end
end

local function addStanceBorder(button)
    if not button.customBorder then
        local backdrop = CreateFrame("Frame", nil, button, "BackdropTemplate")
        backdrop:SetPoint("TOPLEFT", button, "TOPLEFT", -3, 3)
        backdrop:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 3, -3)
        backdrop:SetBackdrop({ edgeFile = BORD, edgeSize = 12 })
        backdrop:SetBackdropBorderColor(unpack(GREY_RGB))
        backdrop:SetFrameLevel(button:GetFrameLevel() + 2)
        button.customBorder = backdrop
    end
    
    local icon = _G[button:GetName() .. "Icon"]
    if icon then
        icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    end
end

-- Position stanceButtons with multiBar to achieve proper alignment

local function positionStanceButtons()
    if InCombatLockdown() then return end

    local previousButton
    local anchorButton = MultiBarBottomLeft:IsShown() and MultiBarBottomLeftButton1 or ActionButton1

    for numStances = 1, NUM_STANCE_SLOTS do
        local stanceButton = _G["StanceButton" .. numStances]
        
        stanceButton:ClearAllPoints()

        if not previousButton then
            stanceButton:SetPoint("BOTTOMLEFT", anchorButton, "TOPLEFT", 0, 8)
        else
            stanceButton:SetPoint("LEFT", previousButton, "RIGHT", 8, 0)
        end

        stanceButton:SetScale(0.9)
        
        hideStanceTextures(stanceButton)
        addStanceBorder(stanceButton)

        previousButton = stanceButton
    end

    StanceBarLeft:SetAlpha(0)
    StanceBarLeft:SetTexture(nil)
    StanceBarMiddle:SetAlpha(0)
    StanceBarMiddle:SetTexture(nil)
    StanceBarRight:SetAlpha(0)
    StanceBarRight:SetTexture(nil)
end

local stanceFrame = CreateFrame("Frame")
stanceFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
stanceFrame:RegisterEvent("UPDATE_STEALTH")
stanceFrame:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
stanceFrame:RegisterEvent("UPDATE_SHAPESHIFT_USABLE")
stanceFrame:RegisterEvent("UPDATE_SHAPESHIFT_COOLDOWN")
stanceFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
stanceFrame:SetScript("OnEvent", positionStanceButtons)

-- Style petButtons with borders to achieve unified appearance

local function hidePetTextures(button)
    local petTexture1 = _G[button:GetName() .. "NormalTexture"]
    if petTexture1 then
        petTexture1:SetAlpha(0)
        petTexture1:SetTexture(nil)
    end
    
    local petTexture2 = _G[button:GetName() .. "NormalTexture2"]
    if petTexture2 then
        petTexture2:SetAlpha(0)
        petTexture2:SetTexture(nil)
    end
    
    local autoCastable = _G[button:GetName() .. "AutoCastable"]
    if autoCastable then
        autoCastable:SetAlpha(0)
        autoCastable:Hide()
    end
end

local function addPetBorder(button)
    if not button.customBorder then
        local backdrop = CreateFrame("Frame", nil, button, "BackdropTemplate")
        backdrop:SetPoint("TOPLEFT", button, "TOPLEFT", -3, 3)
        backdrop:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 3, -3)
        backdrop:SetBackdrop({ edgeFile = BORD, edgeSize = 12 })
        backdrop:SetBackdropBorderColor(unpack(GREY_RGB))
        backdrop:SetFrameLevel(button:GetFrameLevel() + 2)
        button.customBorder = backdrop
    end
    
    local icon = _G[button:GetName() .. "Icon"]
    if icon then
        icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    end
end

local function positionPetButtons()
    local previousButton

    for numStances = 1, 10 do
        local petButton = _G["PetActionButton" .. numStances]
        petButton:ClearAllPoints()

        if not previousButton then
            petButton:SetPoint("BOTTOMLEFT", MultiBarBottomLeft, "TOPLEFT", 0, 6)
        else
            petButton:SetPoint("LEFT", previousButton, "RIGHT", 6, 0)
        end

        petButton:SetScale(0.9)

        hidePetTextures(petButton)
        addPetBorder(petButton)

        previousButton = petButton
    end
end

local petFrame = CreateFrame("Frame")
petFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
petFrame:RegisterEvent("UNIT_PET")
petFrame:RegisterEvent("PET_BAR_UPDATE")
petFrame:SetScript("OnEvent", positionPetButtons)

-- Position vehicleButton with portrait to achieve proper placement

local function positionVehicleButton()
    MainMenuBarVehicleLeaveButton:SetSize(24, 24)
    MainMenuBarVehicleLeaveButton:ClearAllPoints()
    MainMenuBarVehicleLeaveButton:SetPoint("BOTTOMRIGHT", PlayerPortrait, "TOPLEFT", -2, 2)
end

MainMenuBarVehicleLeaveButton:HookScript("OnShow", positionVehicleButton)