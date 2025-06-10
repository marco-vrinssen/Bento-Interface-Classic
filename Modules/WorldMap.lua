-- Set mapScaleValue for worldMapFrame display
local mapScaleValue = 0.9

-- Update worldMapFrameDisplay to set position, scale, and cursor position
local function updateWorldMapFrameDisplay()
    WorldMapFrame:ClearAllPoints()
    WorldMapFrame:SetScale(mapScaleValue)
    WorldMapFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    WorldMapFrame.BlackoutFrame.Show = function()
        WorldMapFrame.BlackoutFrame:Hide()
    end
    WorldMapFrame.ScrollContainer.GetCursorPosition = function()
        local cursorWidth, cursorHeight = MapCanvasScrollControllerMixin.GetCursorPosition()
        return cursorWidth / mapScaleValue, cursorHeight / mapScaleValue
    end
end

-- Fade worldMapFrame when player is moving

local function fadeWorldMapFrameOnMove()
    if WorldMapFrame:IsShown() then
        local mapAlphaValue = IsPlayerMoving() and 0.5 or 1
        UIFrameFadeOut(WorldMapFrame, 0.1, WorldMapFrame:GetAlpha(), mapAlphaValue)
    end
end

-- Register mapFadeEventFrame for movement events to fade map

local mapFadeEventFrame = CreateFrame("Frame")
mapFadeEventFrame:RegisterEvent("PLAYER_STARTED_MOVING")
mapFadeEventFrame:RegisterEvent("PLAYER_STOPPED_MOVING")
mapFadeEventFrame:SetScript("OnEvent", fadeWorldMapFrameOnMove)

-- Hook worldMapFrame scripts for update and initial display

WorldMapFrame:HookScript("OnUpdate", updateWorldMapFrameDisplay)
WorldMapFrame:HookScript("OnShow", function()
    local initialMapAlpha = IsPlayerMoving() and 0.5 or 1
    WorldMapFrame:SetAlpha(0)
    UIFrameFadeIn(WorldMapFrame, 0.1, 0, initialMapAlpha)
    updateWorldMapFrameDisplay()
end)