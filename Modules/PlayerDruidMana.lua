-- CREATE EDGE-ONLY BACKDROP FRAME ABOVE MANA BAR

local druidManaEdgeFrame = CreateFrame("Frame", nil, PlayerFrame, "BackdropTemplate")
druidManaEdgeFrame:SetPoint("TOP", PlayerFrameBackdrop, "BOTTOM", 0, 0)
druidManaEdgeFrame:SetSize(PlayerFrameBackdrop:GetWidth(), 16)
druidManaEdgeFrame:SetBackdrop({
    bgFile = nil,
    edgeFile = BORD,
    edgeSize = 12,
    insets = { left = 3, right = 3, top = 3, bottom = 3 }
})
druidManaEdgeFrame:SetBackdropBorderColor(unpack(GREY))
druidManaEdgeFrame:SetFrameLevel(PlayerFrameBackdrop:GetFrameLevel() + 4)

-- CREATE MANA BAR INSIDE EDGE FRAME, CROPPED BY EDGE

local druidManaBar = CreateFrame("StatusBar", nil, druidManaEdgeFrame, "BackdropTemplate")
druidManaBar:SetPoint("TOPLEFT", druidManaEdgeFrame, "TOPLEFT", 3, -3)
druidManaBar:SetPoint("BOTTOMRIGHT", druidManaEdgeFrame, "BOTTOMRIGHT", -3, 3)
druidManaBar:SetStatusBarTexture(BAR)
druidManaBar:SetStatusBarColor(unpack(BLUE))
druidManaBar:SetMinMaxValues(0, 1)
druidManaBar:SetFrameLevel(druidManaEdgeFrame:GetFrameLevel() - 1)

-- CREATE BG FRAME BELOW BAR FOR BACKGROUND COLOR

local druidManaBgFrame = CreateFrame("Frame", nil, druidManaEdgeFrame, "BackdropTemplate")
druidManaBgFrame:SetPoint("TOPLEFT", druidManaEdgeFrame, "TOPLEFT", 3, -3)
druidManaBgFrame:SetPoint("BOTTOMRIGHT", druidManaEdgeFrame, "BOTTOMRIGHT", -3, 3)
druidManaBgFrame:SetBackdrop({ bgFile = BG })
druidManaBgFrame:SetBackdropColor(unpack(BLACK))
druidManaBgFrame:SetFrameLevel(druidManaBar:GetFrameLevel() - 1)

-- CREATE MANA TEXT INSIDE MANA BAR

local druidManaText = druidManaBar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
druidManaText:SetPoint("CENTER", druidManaBar, "CENTER", 0, 0)
druidManaText:SetTextColor(unpack(WHITE))
druidManaText:SetFont(GameFontNormal:GetFont(), 8, "OUTLINE")

-- ONLY ENABLE FOR DRUIDS

local _, classIdentifier = UnitClass("player")
if classIdentifier ~= "DRUID" then
    druidManaEdgeFrame:Hide()
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
            druidManaEdgeFrame:Show()
            druidManaBar:Show()
            druidManaBgFrame:Show()
        else
            druidManaEdgeFrame:Hide()
            druidManaBar:Hide()
            druidManaBgFrame:Hide()
        end
    else
        druidManaEdgeFrame:Hide()
        druidManaBar:Hide()
        druidManaBgFrame:Hide()
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