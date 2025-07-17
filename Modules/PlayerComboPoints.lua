-- Restrict addon to compatible classes

local _, playerClass = UnitClass("player")
if playerClass ~= "ROGUE" and playerClass ~= "DRUID" then
    return
end

-- Configure point display dimensions

local POINT_SIZE = 24
local POINT_SPACING = 4
local MAX_POINTS = 5
local CONTAINER_WIDTH = MAX_POINTS * POINT_SIZE + (MAX_POINTS - 1) * POINT_SPACING

-- Create main container frame

local comboContainer = CreateFrame("Frame", "ComboPointsFrame", UIParent)
comboContainer:SetSize(CONTAINER_WIDTH, POINT_SIZE)
comboContainer:SetPoint("BOTTOM", CastingBarFrame, "TOP", 0, 4)
local comboFrames = {}

-- Create individual combo point frames

local function createComboFrame()
    local comboFrame = CreateFrame("Frame", nil, comboContainer, "BackdropTemplate")
    comboFrame:SetSize(POINT_SIZE, POINT_SIZE)
    comboFrame:SetBackdrop({
        bgFile = BG,
        edgeFile = BORD,
        edgeSize = 12,
        insets = { left = 2, right = 2, top = 2, bottom = 2 }
    })
    comboFrame:SetBackdropBorderColor(unpack(GREY_RGB))
    comboFrame:SetBackdropColor(0, 0, 0, 1)
    return comboFrame
end

-- Position all combo point frames

for frameIndex = 1, MAX_POINTS do
    comboFrames[frameIndex] = createComboFrame()
    comboFrames[frameIndex]:SetPoint(
        "LEFT",
        comboContainer,
        "LEFT",
        (POINT_SIZE + POINT_SPACING) * (frameIndex - 1),
        0
    )
    comboFrames[frameIndex]:SetBackdropColor(unpack(GREY_RGB))
end


-- Disable default blizzard combo display

local function hideBlizzardCombo()
    for frameIndex = 1, MAX_POINTS do
        local defaultFrame = _G["ComboPoint" .. frameIndex]
        if defaultFrame then
            defaultFrame:Hide()
            defaultFrame:SetScript("OnShow", function(self)
                self:Hide()
            end)
        end
    end
end

-- Update combo point visual state

local function refreshComboDisplay()
    local activePoints = GetComboPoints("player", "target") or 0
    if activePoints > 0 then
        comboContainer:Show()
        for frameIndex = 1, MAX_POINTS do
            local isActivePoint = frameIndex <= activePoints
            local currentFrame = comboFrames[frameIndex]
            if isActivePoint then
                currentFrame:SetBackdrop({
                    bgFile = BG_SOLID,
                    edgeFile = BORD,
                    edgeSize = 12,
                    insets = { left = 3, right = 3, top = 3, bottom = 3 }
                })
                currentFrame:SetBackdropColor(unpack(ORANGE_LIGHT_RGB))
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
        comboContainer:Hide()
    end
end

-- Handle combo point state events

local function onComboStateChanged(self, eventType, ...)
    refreshComboDisplay()
    if eventType == "PLAYER_ENTERING_WORLD" then
        hideBlizzardCombo()
    end
end

-- Register combo point tracking events

local comboEventFrame = CreateFrame("Frame")
comboEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
comboEventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
comboEventFrame:RegisterUnitEvent("UNIT_POWER_UPDATE", "player")
comboEventFrame:SetScript("OnEvent", onComboStateChanged)