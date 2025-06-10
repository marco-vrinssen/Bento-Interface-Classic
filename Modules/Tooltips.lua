-- Update tooltipPosition to set scale and position

local function tooltipPositionUpdate(tooltipFrame)
    if tooltipFrame:GetAnchorType() ~= "ANCHOR_CURSOR" then
        GameTooltip:ClearAllPoints()
        GameTooltip:SetPoint("TOPLEFT", TargetPortraitBackdrop, "BOTTOMRIGHT", 0, 0)
    end
end

hooksecurefunc("GameTooltip_SetDefaultAnchor", tooltipPositionUpdate)

-- Create tooltipStatusBarBackdrop for GameTooltipStatusBar

local tooltipStatusBarBackdrop = CreateFrame("Frame", nil, GameTooltipStatusBar, "BackdropTemplate")
tooltipStatusBarBackdrop:ClearAllPoints()
tooltipStatusBarBackdrop:SetPoint("TOPLEFT", GameTooltipStatusBar, "TOPLEFT", -3, 3)
tooltipStatusBarBackdrop:SetPoint("BOTTOMRIGHT", GameTooltipStatusBar, "BOTTOMRIGHT", 3, -3)
tooltipStatusBarBackdrop:SetBackdrop({ edgeFile = BORD, edgeSize = 12 })
tooltipStatusBarBackdrop:SetBackdropBorderColor(unpack(GREY_RGB))

-- Update tooltipStatusBarPosition to set bar and backdrop

local function tooltipStatusBarPositionUpdate()
    GameTooltipStatusBar:ClearAllPoints()
    GameTooltipStatusBar:SetPoint("TOPLEFT", GameTooltip, "BOTTOMLEFT", 3, -2)
    GameTooltipStatusBar:SetPoint("TOPRIGHT", GameTooltip, "BOTTOMRIGHT", -3, -2)
    GameTooltipStatusBar:SetHeight(12)
    GameTooltipStatusBar:SetStatusBarTexture(BAR)
end

GameTooltip:HookScript("OnShow", tooltipStatusBarPositionUpdate)
GameTooltip:HookScript("OnSizeChanged", tooltipStatusBarPositionUpdate)