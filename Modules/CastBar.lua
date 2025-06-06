-- Create backdrop frame with border styling for cast bar
local castBarBackdrop = CreateFrame("Frame", nil, CastingBarFrame, "BackdropTemplate")
castBarBackdrop:SetPoint("TOPLEFT", CastingBarFrame, "TOPLEFT", -3, 3)
castBarBackdrop:SetPoint("BOTTOMRIGHT", CastingBarFrame, "BOTTOMRIGHT", 3, -3)
castBarBackdrop:SetBackdrop({ edgeFile = BORD, edgeSize = 12 })
castBarBackdrop:SetBackdropBorderColor(unpack(GREY_RGB))
castBarBackdrop:SetFrameLevel(CastingBarFrame:GetFrameLevel() + 2)

-- Configure cast bar with positioning to enhance visibility
local function configureCastBar()
    CastingBarFrame:ClearAllPoints()
    CastingBarFrame:SetSize(160, 20)
    CastingBarFrame:SetMovable(true)
    CastingBarFrame:SetUserPlaced(true)
    CastingBarFrame:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 234)
    CastingBarFrame:SetStatusBarTexture(BAR)
    CastingBarFrame.Border:Hide()
    CastingBarFrame.Spark:ClearAllPoints()
    CastingBarFrame.Spark:SetHeight(CastingBarFrame:GetHeight() * 2)
    CastingBarFrame.Spark:SetPoint("CENTER", CastingBarFrame, "RIGHT", 0, -2)
    CastingBarFrame.Flash:SetTexture(nil)
    CastingBarFrame.Text:ClearAllPoints()
    CastingBarFrame.Text:SetPoint("TOPLEFT", CastingBarFrame, "TOPLEFT", 2, -2)
    CastingBarFrame.Text:SetPoint("BOTTOMRIGHT", CastingBarFrame, "BOTTOMRIGHT", -2, 2)
    CastingBarFrame.Text:SetFont(FONT, 12, "OUTLINE")
end

-- Apply cast bar colors based on spell events
local function applyCastColors(event, unit)
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

-- Register events for spell tracking to enable cast functionality
local castEventFrame = CreateFrame("Frame")
castEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
castEventFrame:RegisterEvent("UNIT_SPELLCAST_START")
castEventFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
castEventFrame:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
castEventFrame:RegisterEvent("UNIT_SPELLCAST_FAILED")
castEventFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")

castEventFrame:SetScript("OnEvent", function(self, event, unit, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        configureCastBar()
    elseif unit == "player" then
        applyCastColors(event, unit)
    end
end)