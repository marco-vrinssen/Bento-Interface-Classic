local itemBorderAddon = CreateFrame("Button", "ItemBorderFrame");

local slotWidth, slotHeight = 68, 68;
local borderIntensity = 0.5;

-- ADD QUEST ITEM QUALITY COLOR

QUALITY_QUEST = #BAG_ITEM_QUALITY_COLORS + 1;
QUALITY_POOR = 0;
QUALITY_COMMON = 1;
BAG_ITEM_QUALITY_COLORS[QUALITY_POOR] = { r = 0.1, g = 0.1, b = 0.1 }
BAG_ITEM_QUALITY_COLORS[QUALITY_QUEST] = { r = 1, g = 1, b = 0 }

-- REGISTER EVENTS

itemBorderAddon:RegisterEvent("ADDON_LOADED");
itemBorderAddon:RegisterEvent("PLAYER_ENTERING_WORLD");
itemBorderAddon:RegisterEvent("INSPECT_READY");
itemBorderAddon:RegisterEvent("BAG_UPDATE");
itemBorderAddon:RegisterEvent("BANKFRAME_OPENED");
itemBorderAddon:RegisterEvent("PLAYERBANKSLOTS_CHANGED");

itemBorderAddon:SetScript("OnEvent", function(self, event, arg1) self[event](self, arg1) end);

function itemBorderAddon:ADDON_LOADED(addonName)
    if (addonName == "BentoInterface-Classic") then
        hooksecurefunc("ToggleCharacter", function() self:updateCharacterFrame() end);
        hooksecurefunc("ToggleBackpack", function() self:updateBackpack() end);
        hooksecurefunc("ToggleBag", function(id) self:updateBag(id) end);
        hooksecurefunc("MerchantFrame_UpdateMerchantInfo", function() self:updateMerchant() end);
        hooksecurefunc("MerchantFrame_UpdateBuybackInfo", function() self:updateBuyback() end);
    end

    if (addonName == "Blizzard_TradeSkillUI") then
        hooksecurefunc("TradeSkillFrame_SetSelection", function(id) self:updateTradeskill(id) end);
    end
end

function itemBorderAddon:PLAYER_ENTERING_WORLD()
end

-- CHARACTER FRAME UPDATES

function itemBorderAddon:updateCharacterFrame()
    if (CharacterFrame:IsShown()) then
        self:RegisterEvent("UNIT_INVENTORY_CHANGED");
        self:updateCharacterSlots("player", "Character");
    else
        self:UnregisterEvent("UNIT_INVENTORY_CHANGED")
    end
end

function itemBorderAddon:UNIT_INVENTORY_CHANGED()
    self:updateCharacterSlots("player", "Character");
end

-- BAG UPDATES

function itemBorderAddon:BAG_UPDATE(bagId)
    self:updateBag(bagId);
end

-- INSPECT FRAME UPDATE

function itemBorderAddon:INSPECT_READY()
    self:updateCharacterSlots("target", "Inspect");
end

-- BANK UPDATES

function itemBorderAddon:BANKFRAME_OPENED()
    self:updateBankSlots();
end

function itemBorderAddon:PLAYERBANKSLOTS_CHANGED()
    self:updateBankSlots();
end

-- BACKPACK UPDATE

function itemBorderAddon:updateBackpack()
    local containerFrame = _G["ContainerFrame1"];
    if (containerFrame.allBags == true) then
        for bagId = 0, NUM_BAG_SLOTS do
            OpenBag(bagId);
            self:updateBag(bagId);
        end
    end
end

-- UPDATE BAG CONTENTS

function itemBorderAddon:updateBag(bagId)
    local frameId = IsBagOpen(bagId);
    if (frameId) then
        local slotCount = C_Container.GetContainerNumSlots(bagId);
        for slot = 1, slotCount do
            local slotFrameId = slotCount + 1 - slot;
            local slotFrameName = "ContainerFrame" .. frameId .. "Item" .. slotFrameId;
            self:updateContainerSlot(bagId, slot, slotFrameName);
        end
    end
end

-- UPDATE BANK SLOTS

function itemBorderAddon:updateBankSlots()
    local container = BANK_CONTAINER;
    for slot = 1, C_Container.GetContainerNumSlots(container) do
        self:updateContainerSlot(container, slot, "BankFrameItem" .. slot);
    end
end

-- UPDATE CONTAINER SLOT BORDER

function itemBorderAddon:updateContainerSlot(containerId, slotId, slotFrameName)
    local slotFrame = _G[slotFrameName];
    if not slotFrame then return end

    if (not slotFrame.itemBorder) then
        slotFrame.itemBorder = self:createBorder(slotFrameName, slotFrame, slotWidth, slotHeight);
    end

    local itemId = C_Container.GetContainerItemID(containerId, slotId);
    if (itemId) then
        local quality = GetItemQuality(itemId);
        if (quality and quality > QUALITY_COMMON) then
            local r, g, b = GetQualityColor(quality);
            slotFrame.itemBorder:SetVertexColor(r, g, b);
            slotFrame.itemBorder:SetAlpha(borderIntensity);
            slotFrame.itemBorder:Show();
        else
            slotFrame.itemBorder:Hide();
        end
    else
        slotFrame.itemBorder:Hide();
    end
end

local characterSlotTypes = {
    "Head", "Neck", "Shoulder", "Back", "Chest", "Shirt", "Tabard",
    "Wrist", "Hands", "Waist", "Legs", "Feet", "Finger0", "Finger1",
    "Trinket0", "Trinket1", "MainHand", "SecondaryHand", "Ranged", "Ammo"
};

-- UPDATE CHARACTER FRAME ITEM BORDERS

function itemBorderAddon:updateCharacterSlots(unit, frameType)
    for _, slotName in ipairs(characterSlotTypes) do
        local slotId = GetInventorySlotInfo(slotName .. "Slot");
        local quality = GetInventoryItemQuality(unit, slotId);
        local slotFrameName = frameType .. slotName .. "Slot";
        local slotFrame = _G[slotFrameName];

        if (slotFrame) then
            if (not slotFrame.itemBorder) then
                local width, height = slotWidth, slotHeight;
                if slotName == "Ammo" then
                    width, height = 58, 58;
                end
                slotFrame.itemBorder = self:createBorder(slotFrameName, slotFrame, width, height);
            end

            if (quality) then
                local r, g, b = GetQualityColor(quality);
                slotFrame.itemBorder:SetVertexColor(r, g, b);
                slotFrame.itemBorder:SetAlpha(borderIntensity);
                slotFrame.itemBorder:Show();
            else
                slotFrame.itemBorder:Hide();
            end
        end
    end
end

-- MERCHANT FRAME UPDATES

function itemBorderAddon:updateMerchant()
    self:updateMerchantItems(GetMerchantItemLink);
    self:updateBuybackButton();
end

function itemBorderAddon:updateBuyback()
    self:updateMerchantItems(GetBuybackItemLink);
end

function itemBorderAddon:updateMerchantItems(itemLinkFunc)
    for slotId = 1, 12 do
        local slotName = "MerchantItem" .. slotId .. "ItemButton";
        local itemFrame = _G[slotName];
        if itemFrame then
            if (not itemFrame.itemBorder) then
                itemFrame.itemBorder = self:createBorder(slotName, itemFrame, slotWidth, slotHeight);
            end

            local link = itemLinkFunc(slotId);
            if (link) then
                self:updateSlotBorderFromLink(itemFrame, link);
            else
                itemFrame.itemBorder:Hide();
            end
        end
    end
end

function itemBorderAddon:updateBuybackButton()
    local buybackSlotName = "MerchantBuyBackItemItemButton";
    local itemFrame = _G[buybackSlotName];
    if itemFrame then
        if (not itemFrame.itemBorder) then
            itemFrame.itemBorder = self:createBorder(buybackSlotName, itemFrame, slotWidth, slotHeight);
        end

        local lastLink = self:findLastBuybackItem();
        if (lastLink) then
            self:updateSlotBorderFromLink(itemFrame, lastLink);
        else
            itemFrame.itemBorder:Hide();
        end
    end
end

function itemBorderAddon:updateSlotBorderFromLink(itemFrame, itemId)
    local itemQuality = GetItemQuality(itemId);
    if (itemQuality and itemQuality > QUALITY_COMMON) then
        local r, g, b = GetQualityColor(itemQuality);
        itemFrame.itemBorder:SetVertexColor(r, g, b);
        itemFrame.itemBorder:SetAlpha(borderIntensity);
        itemFrame.itemBorder:Show();
    else
        itemFrame.itemBorder:Hide();
    end
end

function itemBorderAddon:findLastBuybackItem()
    local lastLink = nil;
    for slotId = 1, 12 do
        local link = GetBuybackItemLink(slotId);
        if (link) then lastLink = link; end
    end
    return lastLink;
end

-- TRADESKILL FRAME UPDATES

function itemBorderAddon:updateTradeskill(skillId)
    self:updateTradeskillItem(skillId);
    self:updateTradeskillReagents(skillId);
end

function itemBorderAddon:updateTradeskillItem(skillId)
    local slotName = "TradeSkillSkillIcon";
    local itemFrame = _G[slotName];
    if itemFrame then
        if (not itemFrame.itemBorder) then
            itemFrame.itemBorder = self:createBorder(slotName, itemFrame, slotWidth, slotHeight);
        end

        local link = GetTradeSkillItemLink(skillId);
        if (link) then
            self:updateSlotBorderFromLink(itemFrame, link);
        else
            itemFrame.itemBorder:Hide();
        end
    end
end

function itemBorderAddon:updateTradeskillReagents(skillId)
    local reagentCount = GetTradeSkillNumReagents(skillId);
    for index = 1, reagentCount do
        local slotName = "TradeSkillReagent" .. index;
        local itemFrame = _G[slotName];
        if itemFrame then
            if (not itemFrame.itemBorder) then
                itemFrame.itemBorder = self:createBorder(slotName, itemFrame, slotWidth, slotHeight, -54);
            end

            local link = GetTradeSkillReagentItemLink(skillId, index);
            if (link) then
                self:updateSlotBorderFromLink(itemFrame, link);
            else
                itemFrame.itemBorder:Hide();
            end
        end
    end
end

-- CREATE BORDER TEXTURE

function itemBorderAddon:createBorder(name, parent, width, height, offsetX, offsetY)
    local offsetX = offsetX or 0;
    local offsetY = offsetY or 1;

    local border = parent:CreateTexture(name .. "Border", "OVERLAY");
    border:SetTexture("Interface\\Buttons\\UI-ActionButton-Border");
    border:SetBlendMode("ADD");
    border:SetAlpha(borderIntensity);
    border:SetHeight(height);
    border:SetWidth(width);
    border:SetPoint("CENTER", parent, "CENTER", offsetX, offsetY);
    border:Hide();

    return border;
end

-- CUSTOM QUALITY COLOR FUNCTION

function GetQualityColor(quality)
    local colorData = BAG_ITEM_QUALITY_COLORS[quality];
    return colorData.r, colorData.g, colorData.b;
end

-- CUSTOM ITEM QUALITY FUNCTION FOR QUEST ITEMS

function GetItemQuality(itemId)
    local quality, _, _, _, _, _, _, _, _, classId = select(3, GetItemInfo(itemId));
    if (classId == 12) then quality = QUALITY_QUEST; end
    return quality;
end
