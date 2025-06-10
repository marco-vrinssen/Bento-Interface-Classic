
-- Create minimapBackdrop to achieve visual enhancement

local minimapBackdrop = CreateFrame("Frame", nil, Minimap, "BackdropTemplate")
minimapBackdrop:SetSize(199, 199)
minimapBackdrop:SetPoint("CENTER", Minimap, "CENTER", 0, 0)
minimapBackdrop:SetBackdrop({bgFile = "Interface/CHARACTERFRAME/TempPortraitAlphaMask",})
minimapBackdrop:SetBackdropColor(0, 0, 0, 0.5)
minimapBackdrop:SetFrameLevel(Minimap:GetFrameLevel() - 1)

-- Configure minimapPosition to achieve proper positioning

local function configureMinimapPosition()
    Minimap:SetClampedToScreen(false)
    Minimap:SetParent(UIParent)
    Minimap:SetSize(200, 200)

    Minimap:ClearAllPoints()
    Minimap:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -16, -16)
    MinimapBackdrop:Hide()
    GameTimeFrame:Hide()
    MinimapCluster:Hide()
end

-- Register minimapEvents to achieve automatic updates

local minimapEventHandler = CreateFrame("Frame")
minimapEventHandler:RegisterEvent("PLAYER_ENTERING_WORLD")
minimapEventHandler:RegisterEvent("ZONE_CHANGED")
minimapEventHandler:SetScript("OnEvent", configureMinimapPosition)

-- Enable scrollFunctionality to achieve zoom control

local function handleMinimapScroll(self, delta)
    if delta > 0 then
        Minimap_ZoomIn()
    else
        Minimap_ZoomOut()
    end
end

-- Create scrollHandler to achieve wheel zoom

local scrollHandler = CreateFrame("Frame", nil, Minimap)
scrollHandler:SetAllPoints(Minimap)
scrollHandler:EnableMouseWheel(true)
scrollHandler:SetScript("OnMouseWheel", handleMinimapScroll)

-- Create timeDisplayBackdrop to achieve styled time frame

local timeDisplayBackdrop = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
timeDisplayBackdrop:SetSize(48, 24)
timeDisplayBackdrop:SetPoint("CENTER", Minimap, "BOTTOM", 0, 0)
timeDisplayBackdrop:SetBackdrop({
    bgFile = BG,
    edgeFile = BORD,
    edgeSize = 12,
    insets = {left = 2, right = 2, top = 2, bottom = 2}
})
timeDisplayBackdrop:SetBackdropColor(unpack(BLACK_RGB))
timeDisplayBackdrop:SetBackdropBorderColor(unpack(GREY_RGB))
timeDisplayBackdrop:SetFrameLevel(Minimap:GetFrameLevel() + 2)

-- Configure timerDisplay to achieve styled time

local function configureTimerDisplay()
    for _, buttonRegion in pairs({TimeManagerClockButton:GetRegions()}) do
        if buttonRegion:IsObjectType("Texture") then
            buttonRegion:Hide()
        end
    end
    TimeManagerClockButton:SetParent(timeDisplayBackdrop)
    TimeManagerClockButton:SetAllPoints(timeDisplayBackdrop)
    TimeManagerClockTicker:SetPoint("CENTER", TimeManagerClockButton, "CENTER", 0, 0)
    TimeManagerClockTicker:SetFont(FONT, 12)
    TimeManagerFrame:ClearAllPoints()
    TimeManagerFrame:SetPoint("TOPRIGHT", timeDisplayBackdrop, "BOTTOMRIGHT", 0, -4)
end

-- Register timerEvents to achieve automatic timer updates

local timerEventHandler = CreateFrame("Frame")
timerEventHandler:RegisterEvent("PLAYER_ENTERING_WORLD")
timerEventHandler:SetScript("OnEvent", configureTimerDisplay)

-- Create mailIconBackdrop to achieve styled mail display

local mailIconBackdrop = CreateFrame("Frame", nil, MiniMapMailFrame, "BackdropTemplate")
mailIconBackdrop:SetPoint("TOPLEFT", MiniMapMailFrame, "TOPLEFT", -4, 4)
mailIconBackdrop:SetPoint("BOTTOMRIGHT", MiniMapMailFrame, "BOTTOMRIGHT", 4, -4)
mailIconBackdrop:SetBackdrop({
    bgFile = BG,
    edgeFile = BORD,
    edgeSize = 12,
    insets = {left = 2, right = 2, top = 2, bottom = 2}
})
mailIconBackdrop:SetBackdropColor(unpack(BLACK_RGB))
mailIconBackdrop:SetBackdropBorderColor(unpack(GREY_RGB))
mailIconBackdrop:SetFrameLevel(Minimap:GetFrameLevel() + 2)

-- Configure mailDisplay to achieve styled mail icon

local function configureMailDisplay()
    MiniMapMailBorder:Hide()
    MiniMapMailFrame:SetParent(Minimap)
    MiniMapMailFrame:ClearAllPoints()
    MiniMapMailFrame:SetSize(16, 16)
    MiniMapMailFrame:SetPoint("RIGHT", timeDisplayBackdrop, "LEFT", -4, 0)
    MiniMapMailIcon:ClearAllPoints()
    MiniMapMailIcon:SetSize(18, 18)
    MiniMapMailIcon:SetPoint("CENTER", MiniMapMailFrame, "CENTER", 0, 0)
end

-- Register mailEvents to achieve automatic mail updates

local mailEventHandler = CreateFrame("Frame")
mailEventHandler:RegisterEvent("PLAYER_ENTERING_WORLD")
mailEventHandler:SetScript("OnEvent", function()
    C_Timer.After(0, configureMailDisplay)
end)

-- Create battlefieldIconBackdrop to achieve styled battlefield display

local battlefieldIconBackdrop = CreateFrame("Frame", nil, MiniMapBattlefieldFrame, "BackdropTemplate")
battlefieldIconBackdrop:SetPoint("TOPLEFT", MiniMapBattlefieldFrame, "TOPLEFT", -4, 4)
battlefieldIconBackdrop:SetPoint("BOTTOMRIGHT", MiniMapBattlefieldFrame, "BOTTOMRIGHT", 4, -4)
battlefieldIconBackdrop:SetBackdrop({
    bgFile = BG,
    edgeFile = BORD,
    edgeSize = 12,
    insets = {left = 2, right = 2, top = 2, bottom = 2}
})
battlefieldIconBackdrop:SetBackdropColor(unpack(BLACK_RGB))
battlefieldIconBackdrop:SetBackdropBorderColor(unpack(GREY_RGB))
battlefieldIconBackdrop:SetFrameLevel(Minimap:GetFrameLevel() + 2)

-- Configure battlefieldDisplay to achieve styled battlefield icon

local function configureBattlefieldDisplay()
    MiniMapBattlefieldBorder:Hide()
    BattlegroundShine:Hide()
    MiniMapBattlefieldFrame:SetParent(Minimap)
    MiniMapBattlefieldFrame:ClearAllPoints()
    MiniMapBattlefieldFrame:SetSize(16, 16)
    MiniMapBattlefieldFrame:SetPoint("LEFT", timeDisplayBackdrop, "RIGHT", 4, 0)
    MiniMapBattlefieldIcon:ClearAllPoints()
    MiniMapBattlefieldIcon:SetSize(16, 16)
    MiniMapBattlefieldIcon:SetPoint("CENTER", MiniMapBattlefieldFrame, "CENTER", 0, 0)
end

-- Register battlefieldEvents to achieve automatic battlefield updates

local battlefieldEventHandler = CreateFrame("Frame")
battlefieldEventHandler:RegisterEvent("PLAYER_ENTERING_WORLD")
battlefieldEventHandler:RegisterEvent("UPDATE_BATTLEFIELD_STATUS")
battlefieldEventHandler:RegisterEvent("UPDATE_ACTIVE_BATTLEFIELD")
battlefieldEventHandler:SetScript("OnEvent", function()
    C_Timer.After(0, configureBattlefieldDisplay)
end)

-- Create trackingIconBackdrop to achieve styled tracking display

local trackingIconBackdrop = CreateFrame("Frame", nil, MiniMapTracking, "BackdropTemplate")
trackingIconBackdrop:SetPoint("TOPLEFT", MiniMapTracking, "TOPLEFT", -4, 4)
trackingIconBackdrop:SetPoint("BOTTOMRIGHT", MiniMapTracking, "BOTTOMRIGHT", 4, -4)
trackingIconBackdrop:SetBackdrop({
    bgFile = BG,
    edgeFile = BORD,
    edgeSize = 12,
    insets = {left = 2, right = 2, top = 2, bottom = 2}
})
trackingIconBackdrop:SetBackdropColor(unpack(BLACK_RGB))
trackingIconBackdrop:SetBackdropBorderColor(unpack(GREY_RGB))
trackingIconBackdrop:SetFrameLevel(Minimap:GetFrameLevel() + 2)

-- Configure trackingDisplay to achieve styled tracking icon

local function configureTrackingDisplay()
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

-- Register trackingEvents to achieve automatic tracking updates

local trackingEventHandler = CreateFrame("Frame")
trackingEventHandler:RegisterEvent("MINIMAP_UPDATE_TRACKING")
trackingEventHandler:SetScript("OnEvent", function()
    C_Timer.After(0, configureTrackingDisplay)
end)