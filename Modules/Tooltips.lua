-- UPDATE TOOLTIP POSITION

local function updateTooltipPos(self)
    if self:GetAnchorType() ~= "ANCHOR_CURSOR" then
        GameTooltip:ClearAllPoints()
        GameTooltip:SetPoint("TOPLEFT", TargetFramePortrait, "BOTTOMRIGHT", 4, -4)
    end
end


-- HIDE GAME TOOLTIP STATUS BAR

GameTooltipStatusBar:SetScript("OnShow", function()
    GameTooltipStatusBar:Hide()
end)


-- ADD ITEM LEVEL TO TOOLTIP

local function addItemLevelToTooltip(tooltip)
    local _, itemLink = tooltip:GetItem()
    if itemLink then
        local itemType = select(6, GetItemInfo(itemLink))
        if itemType == "Armor" or itemType == "Weapon" or itemType == "Consumable" or itemType == "Reagent" or itemType == "Trade Goods" then
            local itemLevel = select(4, GetItemInfo(itemLink))
            if itemLevel then
                tooltip:AddLine("Item Level: " .. itemLevel, unpack(GREY))
                tooltip:Show()
            end
        end
    end
end

GameTooltip:HookScript("OnTooltipSetItem", addItemLevelToTooltip)

hooksecurefunc("GameTooltip_SetDefaultAnchor", updateTooltipPos)