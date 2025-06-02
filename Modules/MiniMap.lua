-- UPDATE MINIMAP

local minimapFirstBackdrop = CreateFrame("Frame", nil, Minimap, "BackdropTemplate")
minimapFirstBackdrop:SetSize(199, 199)
minimapFirstBackdrop:SetPoint("CENTER", Minimap, "CENTER", 0, 0)
minimapFirstBackdrop:SetBackdrop({bgFile = "Interface/CHARACTERFRAME/TempPortraitAlphaMask",})
minimapFirstBackdrop:SetBackdropColor(0, 0, 0, 0.5)
minimapFirstBackdrop:SetFrameLevel(Minimap:GetFrameLevel() - 1) 

local function updateMinimap()
    Minimap:SetClampedToScreen(false)
    Minimap:SetParent(UIParent)
    Minimap:SetSize(200, 200)

    Minimap:ClearAllPoints()
    Minimap:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -16, -16)
    MinimapBackdrop:Hide()
    GameTimeFrame:Hide()
    MinimapCluster:Hide()
end

local minimapEvents = CreateFrame("Frame")
minimapEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
minimapEvents:RegisterEvent("ZONE_CHANGED")
minimapEvents:SetScript("OnEvent", updateMinimap)

-- ENABLE MOUSE WHEEL ZOOM ON MINIMAP

local function enableMinimapScroll(self, delta)
    if delta > 0 then
        Minimap_ZoomIn()
    else
        Minimap_ZoomOut()
    end
end

local zoomEvents = CreateFrame("Frame", nil, Minimap)
zoomEvents:SetAllPoints(Minimap)
zoomEvents:EnableMouseWheel(true)
zoomEvents:SetScript("OnMouseWheel", enableMinimapScroll)

-- UPDATE MINIMAP TIME DISPLAY

local minimapTimeBackdrop = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
minimapTimeBackdrop:SetSize(48, 24)
minimapTimeBackdrop:SetPoint("CENTER", Minimap, "BOTTOM", 0, 0)
minimapTimeBackdrop:SetBackdrop({
    bgFile = BG,
    edgeFile = BORD,
    edgeSize = 12,
    insets = {left = 2, right = 2, top = 2, bottom = 2}
})
minimapTimeBackdrop:SetBackdropColor(unpack(BLACK_RGB))
minimapTimeBackdrop:SetBackdropBorderColor(unpack(GREY_RGB))
minimapTimeBackdrop:SetFrameLevel(Minimap:GetFrameLevel() + 2)

local function updateMinimapTimer()
    for _, buttonRegion in pairs({TimeManagerClockButton:GetRegions()}) do
        if buttonRegion:IsObjectType("Texture") then
            buttonRegion:Hide()
        end
    end
    TimeManagerClockButton:SetParent(minimapTimeBackdrop)
    TimeManagerClockButton:SetAllPoints(minimapTimeBackdrop)
    TimeManagerClockTicker:SetPoint("CENTER", TimeManagerClockButton, "CENTER", 0, 0)
    TimeManagerClockTicker:SetFont(FONT, 12)
    TimeManagerFrame:ClearAllPoints()
    TimeManagerFrame:SetPoint("TOPRIGHT", minimapTimeBackdrop, "BOTTOMRIGHT", 0, -4)
end

local minimapTimerEvents = CreateFrame("Frame")
minimapTimerEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
minimapTimerEvents:SetScript("OnEvent", updateMinimapTimer)

-- UPDATE MINIMAP MAIL ICON

local minimapMailBackdrop = CreateFrame("Frame", nil, MiniMapMailFrame, "BackdropTemplate")
minimapMailBackdrop:SetPoint("TOPLEFT", MiniMapMailFrame, "TOPLEFT", -4, 4)
minimapMailBackdrop:SetPoint("BOTTOMRIGHT", MiniMapMailFrame, "BOTTOMRIGHT", 4, -4)
minimapMailBackdrop:SetBackdrop({
    bgFile = BG,
    edgeFile = BORD,
    edgeSize = 12,
    insets = {left = 2, right = 2, top = 2, bottom = 2}
})
minimapMailBackdrop:SetBackdropColor(unpack(BLACK_RGB))
minimapMailBackdrop:SetBackdropBorderColor(unpack(GREY_RGB))
minimapMailBackdrop:SetFrameLevel(Minimap:GetFrameLevel() + 2)

local function updateMail()
    MiniMapMailBorder:Hide()
    MiniMapMailFrame:SetParent(Minimap)
    MiniMapMailFrame:ClearAllPoints()
    MiniMapMailFrame:SetSize(16, 16)
    MiniMapMailFrame:SetPoint("RIGHT", minimapTimeBackdrop, "LEFT", -4, 0)
    MiniMapMailIcon:ClearAllPoints()
    MiniMapMailIcon:SetSize(18, 18)
    MiniMapMailIcon:SetPoint("CENTER", MiniMapMailFrame, "CENTER", 0, 0)
end

local mailEvents = CreateFrame("Frame")
mailEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
mailEvents:SetScript("OnEvent", function()
    C_Timer.After(0, updateMail)
end)

-- UPDATE MINIMAP BATTLEFIELD ICON

local minimapBattlefieldBackdrop = CreateFrame("Frame", nil, MiniMapBattlefieldFrame, "BackdropTemplate")
minimapBattlefieldBackdrop:SetPoint("TOPLEFT", MiniMapBattlefieldFrame, "TOPLEFT", -4, 4)
minimapBattlefieldBackdrop:SetPoint("BOTTOMRIGHT", MiniMapBattlefieldFrame, "BOTTOMRIGHT", 4, -4)
minimapBattlefieldBackdrop:SetBackdrop({
    bgFile = BG,
    edgeFile = BORD,
    edgeSize = 12,
    insets = {left = 2, right = 2, top = 2, bottom = 2}
})
minimapBattlefieldBackdrop:SetBackdropColor(unpack(BLACK_RGB))
minimapBattlefieldBackdrop:SetBackdropBorderColor(unpack(GREY_RGB))
minimapBattlefieldBackdrop:SetFrameLevel(Minimap:GetFrameLevel() + 2)

local function updateBattlefield()
    MiniMapBattlefieldBorder:Hide()
    BattlegroundShine:Hide()
    MiniMapBattlefieldFrame:SetParent(Minimap)
    MiniMapBattlefieldFrame:ClearAllPoints()
    MiniMapBattlefieldFrame:SetSize(16, 16)
    MiniMapBattlefieldFrame:SetPoint("LEFT", minimapTimeBackdrop, "RIGHT", 4, 0)
    MiniMapBattlefieldIcon:ClearAllPoints()
    MiniMapBattlefieldIcon:SetSize(16, 16)
    MiniMapBattlefieldIcon:SetPoint("CENTER", MiniMapBattlefieldFrame, "CENTER", 0, 0)
end

local battlefieldEvents = CreateFrame("Frame")
battlefieldEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
battlefieldEvents:RegisterEvent("UPDATE_BATTLEFIELD_STATUS")
battlefieldEvents:RegisterEvent("UPDATE_ACTIVE_BATTLEFIELD")
battlefieldEvents:SetScript("OnEvent", function()
    C_Timer.After(0, updateBattlefield)
end)

-- UPDATE MINIMAP TRACKING ICON

local minimapTrackingBackdrop = CreateFrame("Frame", nil, MiniMapTracking, "BackdropTemplate")
minimapTrackingBackdrop:SetPoint("TOPLEFT", MiniMapTracking, "TOPLEFT", -4, 4)
minimapTrackingBackdrop:SetPoint("BOTTOMRIGHT", MiniMapTracking, "BOTTOMRIGHT", 4, -4)
minimapTrackingBackdrop:SetBackdrop({
    bgFile = BG,
    edgeFile = BORD,
    edgeSize = 12,
    insets = {left = 2, right = 2, top = 2, bottom = 2}
})
minimapTrackingBackdrop:SetBackdropColor(unpack(BLACK_RGB))
minimapTrackingBackdrop:SetBackdropBorderColor(unpack(GREY_RGB))
minimapTrackingBackdrop:SetFrameLevel(Minimap:GetFrameLevel() + 2)

local function updateTracking()
    MiniMapTrackingBorder:Hide()
    MiniMapTracking:SetParent(Minimap)
    MiniMapTracking:ClearAllPoints()
    MiniMapTracking:SetSize(16, 16)
    MiniMapTracking:SetPoint("TOP", Minimap, "TOP", 0, 0)
    MiniMapTrackingIcon:ClearAllPoints()
    MiniMapTrackingIcon:SetSize(18, 18)
    MiniMapTrackingIcon:SetTexCoord(0.15, 0.85, 0.15, 0.85)
    MiniMapTrackingIcon:SetPoint("CENTER", MiniMapTracking, "CENTER", 0, 0)
end

local trackingEvents = CreateFrame("Frame")
trackingEvents:RegisterEvent("MINIMAP_UPDATE_TRACKING")
trackingEvents:SetScript("OnEvent", function()
    C_Timer.After(0, updateTracking)
end)