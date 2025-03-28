-- UPDATE MINIMAP

local minimapFirstBackdrop = CreateFrame("Frame", nil, Minimap, "BackdropTemplate")
minimapFirstBackdrop:SetSize(198, 198)
minimapFirstBackdrop:SetPoint("CENTER", Minimap, "CENTER", 0, 0)
minimapFirstBackdrop:SetBackdrop({bgFile = "Interface/CHARACTERFRAME/TempPortraitAlphaMask",})
minimapFirstBackdrop:SetBackdropColor(unpack(GREY))
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
minimapTimeBackdrop:SetBackdropColor(unpack(BLACK))
minimapTimeBackdrop:SetBackdropBorderColor(unpack(GREY))
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
minimapMailBackdrop:SetBackdropColor(unpack(BLACK))
minimapMailBackdrop:SetBackdropBorderColor(unpack(GREY))
minimapMailBackdrop:SetFrameLevel(Minimap:GetFrameLevel() + 2)

local function updateMinimapMail()
    MiniMapMailBorder:Hide()
    MiniMapMailFrame:SetParent(Minimap)
    MiniMapMailFrame:ClearAllPoints()
    MiniMapMailFrame:SetSize(16, 16)
    MiniMapMailFrame:SetPoint("RIGHT", minimapTimeBackdrop, "LEFT", -4, 0)
    MiniMapMailIcon:ClearAllPoints()
    MiniMapMailIcon:SetSize(18, 18)
    MiniMapMailIcon:SetPoint("CENTER", MiniMapMailFrame, "CENTER", 0, 0)
end

local minimapMailEvents = CreateFrame("Frame")
minimapMailEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
minimapMailEvents:SetScript("OnEvent", updateMinimapMail)


-- UPDATE MINIMAP BATTLEFIELD ICON

local minimapBFBackdrop = CreateFrame("Frame", nil, MiniMapBattlefieldFrame, "BackdropTemplate")
minimapBFBackdrop:SetPoint("TOPLEFT", MiniMapBattlefieldFrame, "TOPLEFT", -4, 4)
minimapBFBackdrop:SetPoint("BOTTOMRIGHT", MiniMapBattlefieldFrame, "BOTTOMRIGHT", 4, -4)
minimapBFBackdrop:SetBackdrop({
    bgFile = BG, -- Updated background
    edgeFile = BORD,
    edgeSize = 12,
    insets = {left = 2, right = 2, top = 2, bottom = 2}
})
minimapBFBackdrop:SetBackdropColor(unpack(BLACK)) -- SET BACKDROP COLOR TO BLACK WITH 50% OPACITY
minimapBFBackdrop:SetBackdropBorderColor(unpack(GREY))
minimapBFBackdrop:SetFrameLevel(Minimap:GetFrameLevel() + 2)

local function minimapBFUpdate()
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

local minimapBFFrame = CreateFrame("Frame")
minimapBFFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
minimapBFFrame:RegisterEvent("UPDATE_BATTLEFIELD_STATUS")
minimapBFFrame:RegisterEvent("UPDATE_ACTIVE_BATTLEFIELD")
minimapBFFrame:SetScript("OnEvent", minimapBFUpdate)



-- UPDATE MINIMAP TRACKING ICON

local minimapTrackingBackdrop = CreateFrame("Frame", nil, MiniMapTracking, "BackdropTemplate")
minimapTrackingBackdrop:SetPoint("TOPLEFT", MiniMapTracking, "TOPLEFT", -4, 4)
minimapTrackingBackdrop:SetPoint("BOTTOMRIGHT", MiniMapTracking, "BOTTOMRIGHT", 4, -4)
minimapTrackingBackdrop:SetBackdrop({
    bgFile = BG, -- Updated background
    edgeFile = BORD,
    edgeSize = 12,
    insets = {left = 2, right = 2, top = 2, bottom = 2}
})
minimapTrackingBackdrop:SetBackdropColor(unpack(BLACK)) -- SET BACKDROP COLOR TO BLACK WITH 50% OPACITY
minimapTrackingBackdrop:SetBackdropBorderColor(unpack(GREY))
minimapTrackingBackdrop:SetFrameLevel(Minimap:GetFrameLevel() + 2)

local function updateTracking()
    MiniMapTrackingBorder:Hide()
    MiniMapTracking:SetParent(Minimap)
    MiniMapTracking:ClearAllPoints()
    MiniMapTracking:SetSize(12, 12)
    MiniMapTracking:SetPoint("TOP", Minimap, "TOP", 0, 0)
    MiniMapTrackingIcon:ClearAllPoints()
    MiniMapTrackingIcon:SetSize(13, 13)
    MiniMapTrackingIcon:SetPoint("CENTER", MiniMapTracking, "CENTER", 0, 0)
end

local trackingEvents = CreateFrame("Frame")
trackingEvents:RegisterEvent("MINIMAP_UPDATE_TRACKING")
trackingEvents:SetScript("OnEvent", function()
    C_Timer.After(0.1, updateTracking)
end)