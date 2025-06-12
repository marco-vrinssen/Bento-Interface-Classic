-- Restrict access to rogue and druid classes only
local _, playerClass = UnitClass("player")
if playerClass ~= "ROGUE" and playerClass ~= "DRUID" then
    return
end

-- Initialize display configuration to create combo point frames
local frameSize = 24
local frameMargin = 4
local displayWidth = 5 * frameSize + 4 * frameMargin

local mainFrame = CreateFrame("Frame", "ComboPointsFrame", UIParent)
mainFrame:SetSize(displayWidth, frameSize)
mainFrame:SetPoint("BOTTOM", CastingBarFrame, "TOP", 0, 4)
local pointFrames = {}

-- Create individual frame with inactive styling
local function createPointFrame()
    local frame = CreateFrame("Frame", nil, mainFrame, "BackdropTemplate")
    frame:SetSize(frameSize, frameSize)
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

for pointIndex = 1, 5 do
    pointFrames[pointIndex] = createPointFrame()
    pointFrames[pointIndex]:SetPoint(
        "LEFT",
        mainFrame,
        "LEFT",
        (frameSize + frameMargin) * (pointIndex - 1),
        0
    )
    pointFrames[pointIndex]:SetBackdropColor(unpack(GREY_RGB))
end

-- Hide default ui elements to prevent conflicts
local function hideDefaultPoints()
    for pointIndex = 1, 5 do
        local defaultFrame = _G["ComboPoint" .. pointIndex]
        if defaultFrame then
            defaultFrame:Hide()
            defaultFrame:SetScript("OnShow", function(self)
                self:Hide()
            end)
        end
    end
end

-- Update frame styling based on current state
local function updateDisplay()
    local currentPoints = GetComboPoints("player", "target") or 0
    if currentPoints > 0 then
        mainFrame:Show()
        for pointIndex = 1, 5 do
            local isActive = pointIndex <= currentPoints
            local frame = pointFrames[pointIndex]
            if isActive then
                frame:SetBackdrop({
                    bgFile = BG_SOLID,
                    edgeFile = BORD,
                    edgeSize = 12,
                    insets = { left = 3, right = 3, top = 3, bottom = 3 }
                })
                frame:SetBackdropColor(unpack(RED_RGB))
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
        mainFrame:Hide()
    end
end

-- Register events to track player state changes
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
eventFrame:RegisterUnitEvent("UNIT_POWER_UPDATE", "player")
eventFrame:SetScript("OnEvent", function(self, event, ...)
    updateDisplay()
    if event == "PLAYER_ENTERING_WORLD" then
        hideDefaultPoints()
    end
end)