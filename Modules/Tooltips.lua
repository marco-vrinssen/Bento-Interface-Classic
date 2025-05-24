-- UPDATE TOOLTIP SCALE AND POSITION

local function positionTooltip(self)
    if self:GetAnchorType() ~= "ANCHOR_CURSOR" then
        GameTooltip:ClearAllPoints()
        GameTooltip:SetPoint("TOPLEFT", TargetPortraitBackdrop, "BOTTOMRIGHT", 0, 0)
    end
end

hooksecurefunc("GameTooltip_SetDefaultAnchor", positionTooltip)

-- CREATE GAMETOOLTIPSTATUSBAR BACKDROP

local tooltipStatusBarBackdrop = CreateFrame("Frame", nil, GameTooltipStatusBar, "BackdropTemplate")
tooltipStatusBarBackdrop:ClearAllPoints()
tooltipStatusBarBackdrop:SetPoint("TOPLEFT", GameTooltipStatusBar, "TOPLEFT", -2, 2)
tooltipStatusBarBackdrop:SetPoint("BOTTOMRIGHT", GameTooltipStatusBar, "BOTTOMRIGHT", 2, -2)
tooltipStatusBarBackdrop:SetBackdrop({ edgeFile = BORD, edgeSize = 12 })
tooltipStatusBarBackdrop:SetBackdropBorderColor(unpack(GREY_RGB))

local function positionTooltipStatusBarAndBackdrop()
    GameTooltipStatusBar:ClearAllPoints()
    GameTooltipStatusBar:SetPoint("TOPLEFT", GameTooltip, "BOTTOMLEFT", 3, -2)
    GameTooltipStatusBar:SetPoint("TOPRIGHT", GameTooltip, "BOTTOMRIGHT", -3, -2)
    GameTooltipStatusBar:SetHeight(12)
    GameTooltipStatusBar:SetStatusBarTexture(BAR)
end

GameTooltip:HookScript("OnShow", positionTooltipStatusBarAndBackdrop)
GameTooltip:HookScript("OnSizeChanged", positionTooltipStatusBarAndBackdrop)