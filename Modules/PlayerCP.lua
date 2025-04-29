-- ONLY ENABLE FOR ROGUE AND DRUID

local _, classIdentifier = UnitClass("player")
if classIdentifier ~= "ROGUE" and classIdentifier ~= "DRUID" then
    return
end

-- DRAW CUSTOM COMBO POINT DISPLAY

local comboPointFrameSize = 24
local comboPointFrameMargin = 4
local comboPointDisplayWidth = 5 * comboPointFrameSize + 4 * comboPointFrameMargin

local comboPointsFrame = CreateFrame("Frame", "ComboPointsFrame", UIParent)
comboPointsFrame:SetSize(comboPointDisplayWidth, comboPointFrameSize)
comboPointsFrame:SetPoint("BOTTOM", CastingBarFrame, "TOP", 0, 4)

local comboPointFrames = {}

local function CreateComboPointFrame()
    local singleComboPointFrame = CreateFrame("Frame", nil, comboPointsFrame, "BackdropTemplate")
    singleComboPointFrame:SetSize(comboPointFrameSize, comboPointFrameSize)
    singleComboPointFrame:SetBackdrop({
        bgFile = BG,
        edgeFile = BORD,
        edgeSize = 12,
        insets = { left = 2, right = 2, top = 2, bottom = 2 }
    })
    singleComboPointFrame:SetBackdropBorderColor(unpack(GREY_RGB))
    return singleComboPointFrame
end

for comboPointIndex = 1, 5 do
    comboPointFrames[comboPointIndex] = CreateComboPointFrame()
    comboPointFrames[comboPointIndex]:SetPoint(
        "LEFT",
        comboPointsFrame,
        "LEFT",
        (comboPointFrameSize + comboPointFrameMargin) * (comboPointIndex - 1),
        0
    )
    comboPointFrames[comboPointIndex]:SetBackdropColor(unpack(GREY_RGB))
end

-- HIDE DEFAULT UI COMBO POINTS

local function HideDefaultComboPoints()
    for comboPointIndex = 1, 5 do
        local defaultComboPointFrame = _G["ComboPoint" .. comboPointIndex]
        if defaultComboPointFrame then
            defaultComboPointFrame:Hide()
            defaultComboPointFrame:SetScript("OnShow", function(self)
                self:Hide()
            end)
        end
    end
end

-- UPDATE CUSTOM COMBO POINT DISPLAY

local function UpdateCustomComboPointDisplay()
    local currentComboPointsOnTarget = GetComboPoints("player", "target") or 0

    if currentComboPointsOnTarget > 0 then
        comboPointsFrame:Show()
        for comboPointIndex = 1, 5 do
            if comboPointIndex <= currentComboPointsOnTarget then
                comboPointFrames[comboPointIndex]:SetBackdropColor(unpack(RED_RGB))
            else
                comboPointFrames[comboPointIndex]:SetBackdropColor(unpack(GREY_RGB))
            end
        end
    else
        comboPointsFrame:Hide()
    end
end

-- REGISTER EVENTS FOR COMBO POINT DISPLAY

local comboPointsEventFrame = CreateFrame("Frame")
comboPointsEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
comboPointsEventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
comboPointsEventFrame:RegisterUnitEvent("UNIT_POWER_UPDATE", "player")
comboPointsEventFrame:SetScript("OnEvent", function(self, event, ...)
    UpdateCustomComboPointDisplay()
    if event == "PLAYER_ENTERING_WORLD" then
        HideDefaultComboPoints()
    end
end)