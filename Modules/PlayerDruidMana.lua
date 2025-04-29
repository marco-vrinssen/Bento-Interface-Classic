-- CREATE EDGE-ONLY BACKDROP FRAME ABOVE MANA BAR

local druidManaBorder = CreateFrame("Frame", nil, PlayerFrame, "BackdropTemplate")
druidManaBorder:SetPoint("TOP", PlayerFrameBackdrop, "BOTTOM", 0, 0)
druidManaBorder:SetSize(PlayerFrameBackdrop:GetWidth(), 18)
druidManaBorder:SetBackdrop({edgeFile = BORD, edgeSize = 12})
druidManaBorder:SetBackdropBorderColor(unpack(GREY_RGB))
druidManaBorder:SetFrameLevel(PlayerFrameBackdrop:GetFrameLevel() + 4)

-- CREATE MANA BAR INSIDE EDGE FRAME, CROPPED BY EDGE

local druidManaBar = CreateFrame("StatusBar", nil, druidManaBorder, "BackdropTemplate")
druidManaBar:SetPoint("TOPLEFT", druidManaBorder, "TOPLEFT", 2, -2)
druidManaBar:SetPoint("BOTTOMRIGHT", druidManaBorder, "BOTTOMRIGHT", -2, 2)
druidManaBar:SetStatusBarTexture(BAR)
druidManaBar:SetStatusBarColor(unpack(BLUE_RGB))
druidManaBar:SetMinMaxValues(0, 1)
druidManaBar:SetFrameLevel(druidManaBorder:GetFrameLevel() - 1)

-- CREATE BG FRAME BELOW BAR FOR BACKGROUND COLOR

local druidManaBackground = CreateFrame("Frame", nil, druidManaBorder, "BackdropTemplate")
druidManaBackground:SetPoint("TOPLEFT", druidManaBorder, "TOPLEFT", 2, -2)
druidManaBackground:SetPoint("BOTTOMRIGHT", druidManaBorder, "BOTTOMRIGHT", -2, 2)
druidManaBackground:SetBackdrop({ bgFile = BG })
druidManaBackground:SetBackdropColor(unpack(BLACK_RGB))
druidManaBackground:SetFrameLevel(druidManaBar:GetFrameLevel() - 1)

-- CREATE MANA TEXT INSIDE MANA BAR

local druidManaText = druidManaBar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
druidManaText:SetPoint("CENTER", druidManaBar, "CENTER", 0, 0)
druidManaText:SetTextColor(unpack(WHITE_RGB))
druidManaText:SetFont(GameFontNormal:GetFont(), 8, "OUTLINE")

-- ONLY ENABLE FOR DRUIDS

local _, classIdentifier = UnitClass("player")
if classIdentifier ~= "DRUID" then
    druidManaBorder:Hide()
    return
end

-- UPDATE DRUID MANA BAR VISIBILITY AND VALUES

local function UpdateDruidManaBar()
    
    -- ONLY SHOW BAR IN FORM AND NOT USING MANA AS PRIMARY POWER
    local currentPowerType = UnitPowerType("player")
    local currentFormId = GetShapeshiftFormID()
    if currentFormId and currentFormId > 0 and currentPowerType ~= Enum.PowerType.Mana then
        local druidCurrentMana = UnitPower("player", Enum.PowerType.Mana)
        local druidMaxMana = UnitPowerMax("player", Enum.PowerType.Mana)
        if druidMaxMana > 0 then
            druidManaBar:SetValue(druidCurrentMana / druidMaxMana)
            druidManaText:SetText(druidCurrentMana .. " / " .. druidMaxMana)
            druidManaBorder:Show()
            druidManaBar:Show()
            druidManaBackground:Show()
        else
            druidManaBorder:Hide()
            druidManaBar:Hide()
            druidManaBackground:Hide()
        end
    else
        druidManaBorder:Hide()
        druidManaBar:Hide()
        druidManaBackground:Hide()
    end
end

-- REGISTER EVENTS FOR MANA BAR UPDATES

local druidManaEventFrame = CreateFrame("Frame")
druidManaEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
druidManaEventFrame:RegisterEvent("UNIT_POWER_UPDATE")
druidManaEventFrame:RegisterEvent("UNIT_DISPLAYPOWER")
druidManaEventFrame:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
druidManaEventFrame:SetScript("OnEvent", function(self, event, arg1)
    if event == "UNIT_POWER_UPDATE" and arg1 ~= "player" then return end
    UpdateDruidManaBar()
end)