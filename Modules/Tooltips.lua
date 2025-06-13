-- Update tooltip anchor position

local function updateTooltipAnchor(tooltipFrame)
    if tooltipFrame:GetAnchorType() ~= "ANCHOR_CURSOR" then
        GameTooltip:ClearAllPoints()
        GameTooltip:SetPoint("TOPLEFT", TargetPortraitBackdrop, "BOTTOMRIGHT", 0, 0)
        GameTooltipStatusBar:Hide()
    end
end

hooksecurefunc("GameTooltip_SetDefaultAnchor", updateTooltipAnchor)

-- Hide status bar permanently

GameTooltipStatusBar:Hide()
GameTooltipStatusBar:SetScript("OnShow", function(self) self:Hide() end)