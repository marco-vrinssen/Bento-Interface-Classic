-- SHOW CUSTOM DRUID MANA BAR CROPPED BY EDGE

local _, classIdentifier = UnitClass("player")

if classIdentifier == "DRUID" then

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

    -- UPDATE DRUID MANA BAR VISIBILITY AND VALUES

    local function UpdateDruidManaBar()
        
        -- ONLY SHOW BAR IN FORM AND NOT USING MANA AS PRIMARY POWER
        local currentPowerType = UnitPowerType("player")
        local currentFormId = GetShapeshiftFormID()
        if currentFormId and currentFormId > 0 and currentPowerType ~= Enum.PowerType.Mana then
            local currentMana = UnitPower("player", Enum.PowerType.Mana)
            local maxMana = UnitPowerMax("player", Enum.PowerType.Mana)
            if maxMana > 0 then
                druidManaBar:SetValue(currentMana / maxMana)
                druidManaText:SetText(currentMana .. " / " .. maxMana)
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
    druidManaEventFrame:SetScript("OnEvent", UpdateDruidManaBar)
end





local _, classIdentifier = UnitClass("player")
if classIdentifier ~= "ROGUE" and classIdentifier ~= "DRUID" then
    return
end

local pointSize = 24
local pointMargin = 4
local pointsTotalWidth = 5 * pointSize + 4 * pointMargin

local function hideDefaultComboPoints()
    for i = 1, 5 do
        local point = _G["ComboPoint" .. i]
        if point then
            point:Hide()
            point:SetScript("OnShow", function(self)
                self:Hide()
            end)
        end
    end
end

local comboPointsFrame = CreateFrame("Frame", "ComboPointsFrame", UIParent)
comboPointsFrame:SetSize(pointsTotalWidth, pointSize)
comboPointsFrame:SetPoint("BOTTOM", CastingBarFrame, "TOP", 0, 4)

local comboPoints = {}

local function createComboPoint()
    local cp = CreateFrame("Frame", nil, comboPointsFrame, "BackdropTemplate")
    cp:SetSize(pointSize, pointSize)
    cp:SetBackdrop({
        bgFile = BG,
        edgeFile = BORD,
        edgeSize = 12,
        insets = {left = 2, right = 2, top = 2, bottom = 2}
    })
    cp:SetBackdropBorderColor(unpack(GREY))
    return cp
end

local function comboPointTextures(cp, active)
    if active then
        cp:SetBackdropColor(unpack(RED))
    else
        cp:SetBackdropColor(unpack(GREY))
    end
end

for i = 1, 5 do
    comboPoints[i] = createComboPoint()
    comboPointTextures(comboPoints[i], false)
    comboPoints[i]:SetPoint("LEFT", comboPointsFrame, "LEFT", pointSize * (i - 1) + pointMargin * (i - 1), 0)
end

local function comboPointsUpdate()
    local count = GetComboPoints("player", "target") or 0
    
    if count > 0 then
        comboPointsFrame:Show()
        for i = 1, 5 do
            comboPointTextures(comboPoints[i], i <= count)
        end
    else
        comboPointsFrame:Hide()
    end
end

local comboPointEvents = CreateFrame("Frame")
comboPointEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
comboPointEvents:RegisterEvent("PLAYER_TARGET_CHANGED")
comboPointEvents:RegisterUnitEvent("UNIT_POWER_UPDATE", "player")
comboPointEvents:SetScript("OnEvent", function(self, event, ...)
    comboPointsUpdate()
    
    if event == "PLAYER_ENTERING_WORLD" then
        hideDefaultComboPoints()
    end
end)