-- Create border frame to display druid mana above player frame

-- Wait for PlayerFrameBackdrop to be created
local function CreateDruidManaFrame()
    if not PlayerFrameBackdrop then
        return
    end

    local manaBorder = CreateFrame("Frame", nil, PlayerFrame, "BackdropTemplate")
    manaBorder:SetPoint("TOP", PlayerFrameBackdrop, "BOTTOM", 0, 0)
    manaBorder:SetSize(PlayerFrameBackdrop:GetWidth(), 18)
    manaBorder:SetBackdrop({edgeFile = BORD, edgeSize = 12})
    manaBorder:SetBackdropBorderColor(unpack(GREY_RGB))
    manaBorder:SetFrameLevel(PlayerFrameBackdrop:GetFrameLevel() + 4)

    local manaBar = CreateFrame("StatusBar", nil, manaBorder, "BackdropTemplate")
    manaBar:SetPoint("TOPLEFT", manaBorder, "TOPLEFT", 2, -2)
    manaBar:SetPoint("BOTTOMRIGHT", manaBorder, "BOTTOMRIGHT", -2, 2)
    manaBar:SetStatusBarTexture(BAR)
    manaBar:SetStatusBarColor(unpack(BLUE_RGB))
    manaBar:SetMinMaxValues(0, 1)
    manaBar:SetFrameLevel(manaBorder:GetFrameLevel() - 1)

    local manaBackground = CreateFrame("Frame", nil, manaBorder, "BackdropTemplate")
    manaBackground:SetPoint("TOPLEFT", manaBorder, "TOPLEFT", 2, -2)
    manaBackground:SetPoint("BOTTOMRIGHT", manaBorder, "BOTTOMRIGHT", -2, 2)
    manaBackground:SetBackdrop({ bgFile = BG })
    manaBackground:SetBackdropColor(unpack(BLACK_RGB))
    manaBackground:SetFrameLevel(manaBar:GetFrameLevel() - 1)

    local manaText = manaBar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    manaText:SetPoint("CENTER", manaBar, "CENTER", 0, 0)
    manaText:SetTextColor(unpack(WHITE_RGB))
    manaText:SetFont(GameFontNormal:GetFont(), 8, "OUTLINE")

    -- Hide frames for non-druids to prevent unnecessary display

    local _, playerClass = UnitClass("player")
    if playerClass ~= "DRUID" then
        manaBorder:Hide()
        return
    end

    -- Update mana display with current values to show secondary resource

    local function updateManaDisplay()
        local powerType = UnitPowerType("player")
        local formId = GetShapeshiftFormID()
        if formId and formId > 0 and powerType ~= Enum.PowerType.Mana then
            local currentMana = UnitPower("player", Enum.PowerType.Mana)
            local maxMana = UnitPowerMax("player", Enum.PowerType.Mana)
            if maxMana > 0 then
                manaBar:SetValue(currentMana / maxMana)
                manaText:SetText(currentMana .. " / " .. maxMana)
                manaBorder:Show()
                manaBar:Show()
                manaBackground:Show()
            else
                manaBorder:Hide()
                manaBar:Hide()
                manaBackground:Hide()
            end
        else
            manaBorder:Hide()
            manaBar:Hide()
            manaBackground:Hide()
        end
    end

    -- Register events to track power changes for real-time updates

    local eventFrame = CreateFrame("Frame")
    eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
    eventFrame:RegisterEvent("UNIT_POWER_UPDATE")
    eventFrame:RegisterEvent("UNIT_DISPLAYPOWER")
    eventFrame:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
    eventFrame:SetScript("OnEvent", function(self, event, arg1)
        if event == "UNIT_POWER_UPDATE" and arg1 ~= "player" then return end
        updateManaDisplay()
    end)
end

-- Create an event frame to wait for PlayerFrameBackdrop to be initialized
local initFrame = CreateFrame("Frame")
initFrame:RegisterEvent("ADDON_LOADED")
initFrame:RegisterEvent("PLAYER_LOGIN")
initFrame:SetScript("OnEvent", function(self, event, addonName)
    if event == "ADDON_LOADED" and addonName == "BentoInterface-Classic" then
        -- PlayerFrameBackdrop should be available now
        CreateDruidManaFrame()
        self:UnregisterEvent("ADDON_LOADED")
    elseif event == "PLAYER_LOGIN" then
        -- Fallback in case the addon loaded event was missed
        if PlayerFrameBackdrop then
            CreateDruidManaFrame()
        end
        self:UnregisterEvent("PLAYER_LOGIN")
    end
end)