-- UPDATE TOOLTIP POSITION

local function updateTooltipPos(self)
    if self:GetAnchorType() ~= "ANCHOR_CURSOR" then
        GameTooltip:ClearAllPoints()
        GameTooltip:SetPoint("TOPLEFT", TargetPortraitBackdrop, "BOTTOMRIGHT", 0, 0)
    end
end

-- HIDE GAME TOOLTIP STATUS BAR

GameTooltipStatusBar:SetScript("OnShow", function()
    GameTooltipStatusBar:Hide()
end)
 
hooksecurefunc("GameTooltip_SetDefaultAnchor", updateTooltipPos)