-- Create cast bar backdrop with consistent border styling

local castBarBackdrop = CreateFrame("Frame", nil, CastingBarFrame, "BackdropTemplate")
castBarBackdrop:SetPoint("TOPLEFT", CastingBarFrame, "TOPLEFT", -3, 3)
castBarBackdrop:SetPoint("BOTTOMRIGHT", CastingBarFrame, "BOTTOMRIGHT", 3, -3)
castBarBackdrop:SetBackdrop({ edgeFile = BORD, edgeSize = 12 })
castBarBackdrop:SetBackdropBorderColor(unpack(GREY_RGB))
castBarBackdrop:SetFrameLevel(CastingBarFrame:GetFrameLevel() + 2)

-- Configure cast bar positioning and visual elements

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
    CastingBarFrame.Spark:SetPoint("CENTER", CastingBarFrame, "RIGHT", 0, -4)
    CastingBarFrame.Flash:SetTexture(nil)
    CastingBarFrame.Text:ClearAllPoints()
    CastingBarFrame.Text:SetPoint("TOPLEFT", CastingBarFrame, "TOPLEFT", 2, -2)
    CastingBarFrame.Text:SetPoint("BOTTOMRIGHT", CastingBarFrame, "BOTTOMRIGHT", -2, 2)
    CastingBarFrame.Text:SetFont(FONT, 12, "OUTLINE")
end

-- Apply cast bar colors based on spell events

local function applyCastBarColors(event, unit)
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

-- Register cast bar events for spell tracking

local castBarFrame = CreateFrame("Frame")
castBarFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
castBarFrame:RegisterEvent("UNIT_SPELLCAST_START")
castBarFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
castBarFrame:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
castBarFrame:RegisterEvent("UNIT_SPELLCAST_FAILED")
castBarFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")

castBarFrame:SetScript("OnEvent", function(self, event, unit, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        configureCastBar()
    elseif unit == "player" then
        applyCastBarColors(event, unit)
    end
end)