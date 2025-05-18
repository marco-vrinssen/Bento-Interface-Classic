local mapScale = 0.9

local function updateWorldMap()
    WorldMapFrame:ClearAllPoints()
    WorldMapFrame:SetScale(mapScale)
    WorldMapFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    WorldMapFrame.BlackoutFrame.Show = function()
        WorldMapFrame.BlackoutFrame:Hide()
    end
    WorldMapFrame.ScrollContainer.GetCursorPosition = function()
        local mapWidth, mapHeight = MapCanvasScrollControllerMixin.GetCursorPosition()
        return mapWidth / mapScale, mapHeight / mapScale
    end
end

-- HANDLE MAP TRANSPARENCY WHILE PLAYER IS MOVING
local function fadeMap()
    if WorldMapFrame:IsShown() then
        local mapAlpha = IsPlayerMoving() and 0.5 or 1
        UIFrameFadeOut(WorldMapFrame, 0.1, WorldMapFrame:GetAlpha(), mapAlpha)
    end
end

-- REGISTER MOVEMENT EVENTS FOR MAP FADING
local fadeMapEvents = CreateFrame("Frame")
fadeMapEvents:RegisterEvent("PLAYER_STARTED_MOVING")
fadeMapEvents:RegisterEvent("PLAYER_STOPPED_MOVING")
fadeMapEvents:SetScript("OnEvent", fadeMap)

-- HOOK MAP SCRIPTS FOR UPDATING AND INITIAL DISPLAY
WorldMapFrame:HookScript("OnUpdate", updateWorldMap)
WorldMapFrame:HookScript("OnShow", function()
    local initialAlpha = IsPlayerMoving() and 0.5 or 1
    WorldMapFrame:SetAlpha(0)
    UIFrameFadeIn(WorldMapFrame, 0.1, 0, initialAlpha)
    updateWorldMap()
end)