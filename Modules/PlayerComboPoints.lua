-- Restrict access to rogue and druid classes only

local _, currentClass = UnitClass("player")
if currentClass ~= "ROGUE" and currentClass ~= "DRUID" then
    return
end

-- Initialize frameConfiguration to create combo point display

local frameSize = 24
local frameMargin = 4
local displayWidth = 5 * frameSize + 4 * frameMargin

local mainFrame = CreateFrame("Frame", "ComboPointsFrame", UIParent)
mainFrame:SetSize(displayWidth, frameSize)
mainFrame:SetPoint("BOTTOM", CastingBarFrame, "TOP", 0, 4)
local comboFrames = {}

-- Create individualFrame with inactive styling

local function createComboFrame()
    local individualFrame = CreateFrame("Frame", nil, mainFrame, "BackdropTemplate")
    individualFrame:SetSize(frameSize, frameSize)
    individualFrame:SetBackdrop({
        bgFile = BG,
        edgeFile = BORD,
        edgeSize = 12,
        insets = { left = 2, right = 2, top = 2, bottom = 2 }
    })
    individualFrame:SetBackdropBorderColor(unpack(GREY_RGB))
    individualFrame:SetBackdropColor(0, 0, 0, 1)
    return individualFrame
end

for comboIndex = 1, 5 do
    comboFrames[comboIndex] = createComboFrame()
    comboFrames[comboIndex]:SetPoint(
        "LEFT",
        mainFrame,
        "LEFT",
        (frameSize + frameMargin) * (comboIndex - 1),
        0
    )
    comboFrames[comboIndex]:SetBackdropColor(unpack(GREY_RGB))
end

-- Hide defaultElements to prevent conflicts

local function hideDefaultElements()
    for comboIndex = 1, 5 do
        local defaultElement = _G["ComboPoint" .. comboIndex]
        if defaultElement then
            defaultElement:Hide()
            defaultElement:SetScript("OnShow", function(self)
                self:Hide()
            end)
        end
    end
end

-- Update frameStyling based on current state

local function updateStyling()
    local currentPoints = GetComboPoints("player", "target") or 0
    if currentPoints > 0 then
        mainFrame:Show()
        for comboIndex = 1, 5 do
            local isActive = comboIndex <= currentPoints
            local currentFrame = comboFrames[comboIndex]
            if isActive then
                currentFrame:SetBackdrop({
                    bgFile = BG_SOLID,
                    edgeFile = BORD,
                    edgeSize = 12,
                    insets = { left = 3, right = 3, top = 3, bottom = 3 }
                })
                currentFrame:SetBackdropColor(unpack(RED_RGB))
            else
                currentFrame:SetBackdrop({
                    bgFile = BG,
                    edgeFile = BORD,
                    edgeSize = 12,
                    insets = { left = 3, right = 3, top = 3, bottom = 3 }
                })
                currentFrame:SetBackdropColor(unpack(GREY_RGB))
            end
            currentFrame:SetBackdropBorderColor(unpack(GREY_RGB))
        end
    else
        mainFrame:Hide()
    end
end

-- Register eventHandlers to track player state changes

local eventHandler = CreateFrame("Frame")
eventHandler:RegisterEvent("PLAYER_ENTERING_WORLD")
eventHandler:RegisterEvent("PLAYER_TARGET_CHANGED")
eventHandler:RegisterUnitEvent("UNIT_POWER_UPDATE", "player")
eventHandler:SetScript("OnEvent", function(self, event, ...)
    updateStyling()
    if event == "PLAYER_ENTERING_WORLD" then
        hideDefaultElements()
    end
end)