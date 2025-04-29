-- UPDATE TOOLTIP SCALE AND POSITION

local function positionTooltip(self)
    if self:GetAnchorType() ~= "ANCHOR_CURSOR" then
        GameTooltip:ClearAllPoints()
        GameTooltip:SetPoint("TOPLEFT", TargetPortraitBackdrop, "BOTTOMRIGHT", 0, 0)
    end
end

-- HIDE GAME TOOLTIP STATUS BAR

GameTooltipStatusBar:SetScript("OnShow", function()
    GameTooltipStatusBar:ClearAllPoints()
    GameTooltipStatusBar:SetParent(GameTooltip) 
    GameTooltipStatusBar:SetPoint("BOTTOMLEFT", GameTooltip, "BOTTOMLEFT", 3, 3)
    GameTooltipStatusBar:SetPoint("BOTTOMRIGHT", GameTooltip, "BOTTOMRIGHT", -3, 3)
    GameTooltipStatusBar:SetHeight(4)
    GameTooltipStatusBar:SetStatusBarTexture(BAR)
end)

hooksecurefunc("GameTooltip_SetDefaultAnchor", positionTooltip)