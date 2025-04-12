-- UPDATE FRAME RATE DISPLAY

local function enforceHideFramerateLabel()
    FramerateLabel:Hide()
end

FramerateLabel:HookScript("OnShow", enforceHideFramerateLabel)

local function framerateUpdate()
    FramerateText:ClearAllPoints()
    FramerateText:SetPoint("TOP", TimeManagerClockButton, "BOTTOM", 0, -8)
    FramerateText:SetFont(FONT, 12, "OUTLINE")
end

local framerateEvents = CreateFrame("Frame")
framerateEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
framerateEvents:SetScript("OnEvent", framerateUpdate)