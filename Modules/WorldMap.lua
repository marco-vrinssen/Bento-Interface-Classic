-- Set map scale for WorldMapFrame display

local mapScaleValue = 0.9

-- Update WorldMapFrame position, scale, and cursor position

local function updateMapFrameDisplay()
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

-- Fade WorldMapFrame when player is moving

local function fadeMapOnMove()
    if WorldMapFrame:IsShown() then
        local mapAlphaValue = IsPlayerMoving() and 0.5 or 1
        UIFrameFadeOut(WorldMapFrame, 0.1, WorldMapFrame:GetAlpha(), mapAlphaValue)
    end
end

-- Register movement events for map fading

local mapFadeEventFrame = CreateFrame("Frame")
mapFadeEventFrame:RegisterEvent("PLAYER_STARTED_MOVING")
mapFadeEventFrame:RegisterEvent("PLAYER_STOPPED_MOVING")
mapFadeEventFrame:SetScript("OnEvent", fadeMapOnMove)

-- Hook WorldMapFrame scripts for update and initial display

WorldMapFrame:HookScript("OnUpdate", updateMapFrameDisplay)
WorldMapFrame:HookScript("OnShow", function()
    local initialMapAlpha = IsPlayerMoving() and 0.5 or 1
    WorldMapFrame:SetAlpha(0)
    UIFrameFadeIn(WorldMapFrame, 0.1, 0, initialMapAlpha)
    updateMapFrameDisplay()
end)