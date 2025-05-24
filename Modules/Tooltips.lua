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

-- ADD ITEM LEVEL TO GEAR TOOLTIP BELOW LEVEL REQUIREMENT

local function addItemLevelToGearTooltip(tooltip)
    local _, itemLink = tooltip:GetItem()
    if not itemLink then return end
    local itemName, _, itemQuality, _, itemMinLevel, itemType, itemSubType, _, itemEquipLoc = GetItemInfo(itemLink)
    if not itemEquipLoc or itemEquipLoc == "" then return end
    if itemType ~= "Armor" and itemType ~= "Weapon" then return end
    local itemLevel = GetDetailedItemLevelInfo(itemLink)
    if not itemLevel then return end
    local levelLineIndex
    for i = 2, tooltip:NumLines() do
        local leftLine = _G[tooltip:GetName() .. "TextLeft" .. i]
        if leftLine and leftLine:GetText() and leftLine:GetText():find("Requires Level") then
            levelLineIndex = i
            break
        end
    end
    if not levelLineIndex then return end
    tooltip:AddLine(" ")
    local insertIndex = levelLineIndex + 1
    for i = tooltip:NumLines(), insertIndex, -1 do
        local leftLine = _G[tooltip:GetName() .. "TextLeft" .. i]
        local prevLine = _G[tooltip:GetName() .. "TextLeft" .. (i-1)]
        if leftLine and prevLine then
            leftLine:SetText(prevLine:GetText())
        end
    end
    local itemLevelLine = _G[tooltip:GetName() .. "TextLeft" .. insertIndex]
    if itemLevelLine then
        itemLevelLine:SetText("Item Level: " .. itemLevel)
        itemLevelLine:SetTextColor(1, 1, 1)
    end
    tooltip:Show()
end

GameTooltip:HookScript("OnTooltipSetItem", function(self)
    addItemLevelToGearTooltip(self)
end)