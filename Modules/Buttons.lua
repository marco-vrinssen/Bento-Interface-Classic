-- UPDATE AND REPOSITION ACTION BARS

local function updateActionButtons()
    MainMenuBar:SetWidth(512)
    MainMenuBar:ClearAllPoints()
    MainMenuBar:SetPoint("BOTTOM", UIParent, "BOTTOM", -2, 88)
    MainMenuBar:SetMovable(true)
    MainMenuBar:SetUserPlaced(true)

    MultiBarBottomLeft:Show()
    MultiBarBottomLeft:ClearAllPoints()
    MultiBarBottomLeft:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 134)
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

local actionBarFrame = CreateFrame("Frame")
actionBarFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
actionBarFrame:SetScript("OnEvent", updateActionButtons)


-- UPDATE BUTTON USABILITY

local function updateButtonUsability(self)
    if not self or not self.action then 
        return 
    end

    local isUsable = IsUsableAction(self.action)
    local inRange = IsActionInRange(self.action)

    local color = (not isUsable or inRange == false) and RED_RGB or WHITE_RGB
    self.icon:SetVertexColor(unpack(color))
end

hooksecurefunc("ActionButton_OnUpdate", updateButtonUsability)


-- UPDATE ACTION BUTTONS

local function updateActionButtonAppearance()
    local function hideNormalTexture(button)
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

    local function customizeButton(button)
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

    local function updateButtonFonts(button)
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
        local buttons = {
            _G["ActionButton" .. i],
            _G["MultiBarBottomLeftButton" .. i],
            _G["MultiBarBottomRightButton" .. i],
            _G["MultiBarRightButton" .. i],
            _G["MultiBarLeftButton" .. i]
        }
        for _, button in ipairs(buttons) do
            hideNormalTexture(button)
            customizeButton(button)
            updateButtonFonts(button)
        end
    end
end

local actionButtonFrame = CreateFrame("Frame")
actionButtonFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
actionButtonFrame:SetScript("OnEvent", updateActionButtonAppearance)


-- UPDATE CLASS BUTTONS

local function hideClassButtonTextures(button)
    for numTextures = 1, 3 do
        local normalTexture = _G[button:GetName() .. "NormalTexture" .. numTextures]
        if normalTexture then
            normalTexture:SetAlpha(0)
            normalTexture:SetTexture(nil)
        end
    end
end

local function addCustomBorderToClassButton(button)
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

-- ALIGN CLASS BUTTONS BASED ON MULTIBARBOTTOMLEFT VISIBILITY

local function updateClassButtons()
    if InCombatLockdown() then return end

    local previousClassButton
    local anchorButton = MultiBarBottomLeft:IsShown() and MultiBarBottomLeftButton1 or ActionButton1

    for numStances = 1, NUM_STANCE_SLOTS do
        local classButton = _G["StanceButton" .. numStances]
        
        classButton:ClearAllPoints()

        if not previousClassButton then
            classButton:SetPoint("BOTTOMLEFT", anchorButton, "TOPLEFT", 0, 8)
        else
            classButton:SetPoint("LEFT", previousClassButton, "RIGHT", 4, 0)
        end

        classButton:SetScale(0.9)
        
        hideClassButtonTextures(classButton)
        addCustomBorderToClassButton(classButton)

        previousClassButton = classButton
    end

    StanceBarLeft:SetAlpha(0)
    StanceBarLeft:SetTexture(nil)
    StanceBarMiddle:SetAlpha(0)
    StanceBarMiddle:SetTexture(nil)
    StanceBarRight:SetAlpha(0)
    StanceBarRight:SetTexture(nil)
end

local classButtonsFrame = CreateFrame("Frame")
classButtonsFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
classButtonsFrame:RegisterEvent("UPDATE_STEALTH")
classButtonsFrame:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
classButtonsFrame:RegisterEvent("UPDATE_SHAPESHIFT_USABLE")
classButtonsFrame:RegisterEvent("UPDATE_SHAPESHIFT_COOLDOWN")
classButtonsFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
classButtonsFrame:SetScript("OnEvent", updateClassButtons)


-- UPDATE PET BUTTONS

local function hidePetButtonTextures(button)
    local petButtonTexture1 = _G[button:GetName() .. "NormalTexture"]
    if petButtonTexture1 then
        petButtonTexture1:SetAlpha(0)
        petButtonTexture1:SetTexture(nil)
    end
    
    local petButtonTexture2 = _G[button:GetName() .. "NormalTexture2"]
    if petButtonTexture2 then
        petButtonTexture2:SetAlpha(0)
        petButtonTexture2:SetTexture(nil)
    end
    
    local autoCastable = _G[button:GetName() .. "AutoCastable"]
    if autoCastable then
        autoCastable:SetAlpha(0)
        autoCastable:Hide()
    end
end

local function addCustomBorderToPetButton(button)
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

local function updatePetButton()
    local previousPetButton

    for numStances = 1, 10 do
        local petButton = _G["PetActionButton" .. numStances]
        petButton:ClearAllPoints()

        if not previousPetButton then
            petButton:SetPoint("BOTTOMLEFT", MultiBarBottomLeft, "TOPLEFT", 0, 6)
        else
            petButton:SetPoint("LEFT", previousPetButton, "RIGHT", 6, 0)
        end

        petButton:SetScale(0.9)

        hidePetButtonTextures(petButton)
        addCustomBorderToPetButton(petButton)

        previousPetButton = petButton
    end
end

local petButtonsFrame = CreateFrame("Frame")
petButtonsFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
petButtonsFrame:RegisterEvent("UNIT_PET")
petButtonsFrame:RegisterEvent("PET_BAR_UPDATE")
petButtonsFrame:SetScript("OnEvent", updatePetButton)


-- UPDATE VEHICLE LEAVE BUTTON

local function vehicleButtonUpdate()
    MainMenuBarVehicleLeaveButton:SetSize(24, 24)
    MainMenuBarVehicleLeaveButton:ClearAllPoints()
    MainMenuBarVehicleLeaveButton:SetPoint("BOTTOMRIGHT", PlayerPortrait, "TOPLEFT", -2, 2)
end

MainMenuBarVehicleLeaveButton:HookScript("OnShow", vehicleButtonUpdate)