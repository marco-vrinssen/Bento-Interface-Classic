-- create backdrop frame with border styling
local backdrop = CreateFrame("Frame", nil, CastingBarFrame, "BackdropTemplate")
backdrop:SetPoint("TOPLEFT", CastingBarFrame, "TOPLEFT", -3, 3)
backdrop:SetPoint("BOTTOMRIGHT", CastingBarFrame, "BOTTOMRIGHT", 3, -3)
backdrop:SetBackdrop({ edgeFile = BORD, edgeSize = 12 })
backdrop:SetBackdropBorderColor(unpack(GREY_RGB))
backdrop:SetFrameLevel(CastingBarFrame:GetFrameLevel() + 2)

-- configure bar positioning and appearance
local function configureBar()
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

-- apply colors based on spell events
local function applyColors(event, unit)
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

-- register events for spell tracking
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("UNIT_SPELLCAST_START")
frame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
frame:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
frame:RegisterEvent("UNIT_SPELLCAST_FAILED")
frame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")

frame:SetScript("OnEvent", function(self, event, unit, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        configureBar()
    elseif unit == "player" then
        applyColors(event, unit)
    end
end)