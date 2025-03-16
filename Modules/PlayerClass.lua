-- ENABLE DRUID MANA BAR
  
local _, classIdentifier = UnitClass("player")

if classIdentifier == "DRUID" then

    local druidManaBackdrop = CreateFrame("Frame", nil, PlayerFrame, "BackdropTemplate")
    druidManaBackdrop:SetPoint("TOP", PlayerFrameBackdrop, "BOTTOM", 0, 0)
    druidManaBackdrop:SetSize(PlayerFrameBackdrop:GetWidth() - 2, 16)
    druidManaBackdrop:SetBackdrop({edgeFile = BORD, edgeSize = 12})
    druidManaBackdrop:SetBackdropBorderColor(unpack(GREY))
    

    -- SET UP DRUID MANA BAR
    
    local druidManaBar = CreateFrame("StatusBar", nil, PlayerFrame, "BackdropTemplate")
    druidManaBar:SetSize(druidManaBackdrop:GetWidth() - 4, druidManaBackdrop:GetHeight() - 4)
    druidManaBar:SetPoint("CENTER", druidManaBackdrop, "CENTER", 0, 0)
    druidManaBar:SetStatusBarTexture(BAR)
    druidManaBar:SetMinMaxValues(0, 1)
    
    druidManaBackdrop:SetFrameLevel(druidManaBar:GetFrameLevel() + 2)
    
      
    -- CREATE DRUID MANA TEXT
    
    local druidManaEvents = druidManaBar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    druidManaEvents:SetPoint("CENTER", druidManaBar, "CENTER", 0, 0)
    druidManaEvents:SetTextColor(1, 1, 1)
    druidManaEvents:SetFont(GameFontNormal:GetFont(), 10, "OUTLINE")
    
      
    -- DRUID MANA BAR UPDATE FUNCTION
    
    local function druidManaBarUpdate()
        local playerPowerType, powerToken = UnitPowerType("player")
        local playerForm = GetShapeshiftFormID()
    
        if playerForm and powerToken ~= "MANA" then
            local playerMana = UnitPower("player", Enum.PowerType.Mana)
            local playerMaxMana = UnitPowerMax("player", Enum.PowerType.Mana)
            druidManaBar:SetValue(playerMana / playerMaxMana)
            druidManaEvents:SetText(playerMana .. " / " .. playerMaxMana)
            druidManaBar:Show()
            druidManaBackdrop:Show()
        else
            druidManaBar:Hide()
            druidManaBackdrop:Hide()
        end
    end
    
    local druidManaBarEvents = CreateFrame("Frame")
    druidManaBarEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
    druidManaBarEvents:RegisterEvent("UNIT_POWER_UPDATE")
    druidManaBarEvents:RegisterEvent("UNIT_DISPLAYPOWER")
    druidManaBarEvents:SetScript("OnEvent", druidManaBarUpdate)
end


-- UPDATE ROGUE COMBO POINTS
  
local _, classIdentifier = UnitClass("player")
if classIdentifier ~= "ROGUE" and classIdentifier ~= "DRUID" then
    return
end

  
-- CONFIGURE COMBO POINT CONSTANTS
  
local pointSize = 24
local pointMargin = 4
local pointsTotalWidth = 5 * pointSize + 4 * pointMargin

  
-- HIDE DEFAULT COMBO POINTS FUNCTION
  
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

  
-- CREATE COMBO POINT FRAME FUNCTION
  
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

  
-- SET COMBO POINT TEXTURES FUNCTION
  
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

      
-- UPDATE COMBO POINTS DISPLAY FUNCTION
  
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