-- Restrict to rogue and druid classes only

local _, playerClass = UnitClass("player")
if playerClass ~= "ROGUE" and playerClass ~= "DRUID" then
    return
end

-- Initialize combo point display configuration

local comboFrameSize = 24
local comboFrameMargin = 4
local comboDisplayWidth = 5 * comboFrameSize + 4 * comboFrameMargin

local comboMainFrame = CreateFrame("Frame", "ComboPointsFrame", UIParent)
comboMainFrame:SetSize(comboDisplayWidth, comboFrameSize)
comboMainFrame:SetPoint("BOTTOM", CastingBarFrame, "TOP", 0, 4)
local comboPointFrames = {}

-- Create combo point frame with inactive styling

local function createComboPointFrame()
    local frame = CreateFrame("Frame", nil, comboMainFrame, "BackdropTemplate")
    frame:SetSize(comboFrameSize, comboFrameSize)
    frame:SetBackdrop({
        bgFile = BG,
        edgeFile = BORD,
        edgeSize = 12,
        insets = { left = 2, right = 2, top = 2, bottom = 2 }
    })
    frame:SetBackdropBorderColor(unpack(GREY_RGB))
    frame:SetBackdropColor(0, 0, 0, 1)
    return frame
end

for comboIndex = 1, 5 do
    comboPointFrames[comboIndex] = createComboPointFrame()
    comboPointFrames[comboIndex]:SetPoint(
        "LEFT",
        comboMainFrame,
        "LEFT",
        (comboFrameSize + comboFrameMargin) * (comboIndex - 1),
        0
    )
    comboPointFrames[comboIndex]:SetBackdropColor(unpack(GREY_RGB))
end

-- Hide default combo point UI elements

local function hideDefaultComboPoints()
    for comboIndex = 1, 5 do
        local defaultFrame = _G["ComboPoint" .. comboIndex]
        if defaultFrame then
            defaultFrame:Hide()
            defaultFrame:SetScript("OnShow", function(self)
                self:Hide()
            end)
        end
    end
end

-- Update combo point display based on current state

local function updateComboDisplay()
    local currentComboPoints = GetComboPoints("player", "target") or 0
    if currentComboPoints > 0 then
        comboMainFrame:Show()
        for comboIndex = 1, 5 do
            local isActive = comboIndex <= currentComboPoints
            local frame = comboPointFrames[comboIndex]
            if isActive then
                frame:SetBackdrop({
                    bgFile = BG_SOLID,
                    edgeFile = BORD,
                    edgeSize = 12,
                    insets = { left = 3, right = 3, top = 3, bottom = 3 }
                })
                frame:SetBackdropColor(unpack(ORANGE_LIGHT_RGB))
            else
                frame:SetBackdrop({
                    bgFile = BG,
                    edgeFile = BORD,
                    edgeSize = 12,
                    insets = { left = 3, right = 3, top = 3, bottom = 3 }
                })
                frame:SetBackdropColor(unpack(GREY_RGB))
            end
            frame:SetBackdropBorderColor(unpack(GREY_RGB))
        end
    else
        comboMainFrame:Hide()
    end
end

-- Register events to track combo point state changes

local comboEventFrame = CreateFrame("Frame")
comboEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
comboEventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
comboEventFrame:RegisterUnitEvent("UNIT_POWER_UPDATE", "player")
comboEventFrame:SetScript("OnEvent", function(self, event, ...)
    updateComboDisplay()
    if event == "PLAYER_ENTERING_WORLD" then
        hideDefaultComboPoints()
    end
end)