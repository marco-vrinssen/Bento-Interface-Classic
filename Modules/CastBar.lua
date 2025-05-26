-- CREATE CASTBAR BACKDROP

local castingBarBackdrop = CreateFrame("Frame", nil, CastingBarFrame, "BackdropTemplate")
castingBarBackdrop:SetPoint("TOPLEFT", CastingBarFrame, "TOPLEFT", -3, 3)
castingBarBackdrop:SetPoint("BOTTOMRIGHT", CastingBarFrame, "BOTTOMRIGHT", 3, -3)
castingBarBackdrop:SetBackdrop({ edgeFile = BORD, edgeSize = 12 })
castingBarBackdrop:SetBackdropBorderColor(unpack(GREY_RGB))
castingBarBackdrop:SetFrameLevel(CastingBarFrame:GetFrameLevel() + 2)

-- UPDATE CASTBAR

local function updateCastBar()
    CastingBarFrame:ClearAllPoints()
    CastingBarFrame:SetSize(160, 20)
    CastingBarFrame:SetMovable(true)
    CastingBarFrame:SetUserPlaced(true)
    CastingBarFrame:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 234)
    CastingBarFrame:SetStatusBarTexture(BAR)
    CastingBarFrame.Border:Hide()
    CastingBarFrame.Flash:SetTexture(nil)
    CastingBarFrame.Text:ClearAllPoints()
    CastingBarFrame.Text:SetPoint("TOPLEFT", CastingBarFrame, "TOPLEFT", 2, -2)
    CastingBarFrame.Text:SetPoint("BOTTOMRIGHT", CastingBarFrame, "BOTTOMRIGHT", -2, 2)
    CastingBarFrame.Text:SetFont(FONT, 12, "OUTLINE")
end

-- RECOLOR CASTBAR ON EVENTS

local function recolorCastBar(event, unit)
    if unit ~= "player" then return end

    if event == "UNIT_SPELLCAST_START" then
        CastingBarFrame:SetStatusBarColor(unpack(YELLOW_RGB))
    elseif event == "UNIT_SPELLCAST_CHANNEL_START" then
        CastingBarFrame:SetStatusBarColor(unpack(GREEN_RGB))
    elseif event == "UNIT_SPELLCAST_INTERRUPTED" then
        CastingBarFrame:SetStatusBarColor(unpack(RED_RGB))
    elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
        CastingBarFrame:SetStatusBarColor(unpack(GREEN_RGB))
    end
end

-- INITIALIZE EVENT HANDLING

local castBarEvents = CreateFrame("Frame")
castBarEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
castBarEvents:RegisterEvent("UNIT_SPELLCAST_START")
castBarEvents:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
castBarEvents:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
castBarEvents:RegisterEvent("UNIT_SPELLCAST_FAILED")
castBarEvents:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")

castBarEvents:SetScript("OnEvent", function(self, event, unit, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        updateCastBar()
    elseif unit == "player" then
        recolorCastBar(event, unit)
    end
end)