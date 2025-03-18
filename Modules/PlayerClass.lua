-- ENABLE DRUID MANA BAR

local _, classIdentifier = UnitClass("player")

if classIdentifier == "DRUID" then
    local druidManaContainer = CreateFrame("Frame", nil, PlayerFrame)
    druidManaContainer:SetPoint("TOP", PlayerFrameBackdrop, "BOTTOM", 0, 0)
    druidManaContainer:SetSize(PlayerFrameBackdrop:GetWidth() - 2, 16)
    
    local druidManaBackground = CreateFrame("Frame", nil, druidManaContainer, "BackdropTemplate")
    druidManaBackground:SetPoint("TOPLEFT", druidManaContainer, "TOPLEFT", 3, -3)
    druidManaBackground:SetPoint("BOTTOMRIGHT", druidManaContainer, "BOTTOMRIGHT", -3, 3)
    druidManaBackground:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    })
    druidManaBackground:SetBackdropColor(unpack(BLACK))
    druidManaBackground:SetFrameLevel(druidManaContainer:GetFrameLevel())
    
    local druidManaBar = CreateFrame("StatusBar", nil, druidManaContainer)
    druidManaBar:SetSize(druidManaContainer:GetWidth() - 6, druidManaContainer:GetHeight() - 6)
    druidManaBar:SetPoint("CENTER", druidManaContainer, "CENTER", 0, 0)
    druidManaBar:SetStatusBarTexture(BAR)
    druidManaBar:SetStatusBarColor(unpack(BLUE))
    druidManaBar:SetMinMaxValues(0, 1)
    druidManaBar:SetFrameLevel(druidManaBackground:GetFrameLevel() + 1)
    
    local druidManaBorder = CreateFrame("Frame", nil, druidManaContainer, "BackdropTemplate")
    druidManaBorder:SetAllPoints()
    druidManaBorder:SetBackdrop({
        edgeFile = BORD,
        edgeSize = 12,
    })
    druidManaBorder:SetBackdropBorderColor(unpack(GREY))
    druidManaBorder:SetFrameLevel(druidManaBar:GetFrameLevel() + 1)
    
    local druidManaText = druidManaBar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    druidManaText:SetPoint("CENTER", druidManaBar, "CENTER", 0, 0)
    druidManaText:SetTextColor(unpack(WHITE))
    druidManaText:SetFont(GameFontNormal:GetFont(), 8, "OUTLINE")
   
    local function druidManaBarUpdate()
        local playerPowerType = UnitPowerType("player")
        local playerForm = GetShapeshiftFormID()
        
        -- Only show mana bar when shapeshifted (not in caster form)
        if playerForm and playerForm > 0 and playerPowerType ~= Enum.PowerType.Mana then
            local playerMana = UnitPower("player", Enum.PowerType.Mana)
            local playerMaxMana = UnitPowerMax("player", Enum.PowerType.Mana)
            
            if playerMaxMana > 0 then
                druidManaBar:SetValue(playerMana / playerMaxMana)
                druidManaText:SetText(playerMana .. " / " .. playerMaxMana)
                druidManaContainer:Show()
            else
                druidManaContainer:Hide()
            end
        else
            druidManaContainer:Hide()
        end
    end
    
    local druidManaBarEvents = CreateFrame("Frame")
    druidManaBarEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
    druidManaBarEvents:RegisterEvent("UNIT_POWER_UPDATE")
    druidManaBarEvents:RegisterEvent("UNIT_DISPLAYPOWER")
    druidManaBarEvents:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
    druidManaBarEvents:SetScript("OnEvent", druidManaBarUpdate)
end


-- CREATE CUSTOM COMBO POINTS
  
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