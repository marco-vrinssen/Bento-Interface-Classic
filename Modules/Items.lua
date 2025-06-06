
-- Initialize item frame manager to handle item border display
local itemFrameManager = CreateFrame("Button", "ItemBorderFrame");

local slotWidth, slotHeight = 68, 68;
local borderAlpha = 0.5;

-- Define quality constants with color mappings to enhance item display

QUALITY_QUEST_TIER = #BAG_ITEM_QUALITY_COLORS + 1;
QUALITY_POOR_TIER = 0;
QUALITY_COMMON_TIER = 1;

BAG_ITEM_QUALITY_COLORS[QUALITY_POOR_TIER] = { r = GREY_RGB[1], g = GREY_RGB[2], b = GREY_RGB[3] }
BAG_ITEM_QUALITY_COLORS[QUALITY_QUEST_TIER] = { r = YELLOW_RGB[1], g = YELLOW_RGB[2], b = YELLOW_RGB[3] }

-- Register events with frame manager to handle item updates

itemFrameManager:RegisterEvent("ADDON_LOADED");
itemFrameManager:RegisterEvent("PLAYER_ENTERING_WORLD");
itemFrameManager:RegisterEvent("INSPECT_READY");
itemFrameManager:RegisterEvent("BAG_UPDATE");
itemFrameManager:RegisterEvent("BANKFRAME_OPENED");
itemFrameManager:RegisterEvent("PLAYERBANKSLOTS_CHANGED");

itemFrameManager:SetScript("OnEvent", function(self, event, arg1) self[event](self, arg1) end);

function itemFrameManager:ADDON_LOADED(addonName)
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

function itemFrameManager:PLAYER_ENTERING_WORLD()
end

-- Update character frame display to show item borders

function itemFrameManager:updateCharacterFrame()
    if (CharacterFrame:IsShown()) then
        self:RegisterEvent("UNIT_INVENTORY_CHANGED");
        self:updateCharacterSlots("player", "Character");
    else
        self:UnregisterEvent("UNIT_INVENTORY_CHANGED")
    end
end

function itemFrameManager:UNIT_INVENTORY_CHANGED()
    self:updateCharacterSlots("player", "Character");
end

-- Update bag contents to reflect item quality borders

function itemFrameManager:BAG_UPDATE(bagId)
    self:updateBag(bagId);
end

-- Update inspect frame to display target item borders

function itemFrameManager:INSPECT_READY()
    self:updateCharacterSlots("target", "Inspect");
end

-- Update bank interface to show item quality borders

function itemFrameManager:BANKFRAME_OPENED()
    self:updateBankSlots();
end

function itemFrameManager:PLAYERBANKSLOTS_CHANGED()
    self:updateBankSlots();
end

-- Update backpack display to show all bag contents

function itemFrameManager:updateBackpack()
    local containerFrame = _G["ContainerFrame1"];
    if (containerFrame.allBags == true) then
        for bagId = 0, NUM_BAG_SLOTS do
            OpenBag(bagId);
            self:updateBag(bagId);
        end
    end
end

-- Update bag items with quality borders

function itemFrameManager:updateBag(bagId)
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

-- Update bank slots with item quality borders

function itemFrameManager:updateBankSlots()
    local container = BANK_CONTAINER;
    for slot = 1, C_Container.GetContainerNumSlots(container) do
        self:updateContainerSlot(container, slot, "BankFrameItem" .. slot);
    end
end

-- Update container slot border based on item quality

function itemFrameManager:updateContainerSlot(containerId, slotId, slotFrameName)
    local slotFrame = _G[slotFrameName];
    if not slotFrame then return end

    if (not slotFrame.itemBorder) then
        slotFrame.itemBorder = self:createBorder(slotFrameName, slotFrame, slotWidth, slotHeight);
    end

    local itemId = C_Container.GetContainerItemID(containerId, slotId);
    if (itemId) then
        local quality = GetItemQuality(itemId);
        if (quality and quality > QUALITY_COMMON_TIER) then
            local r, g, b = GetQualityColor(quality);
            slotFrame.itemBorder:SetVertexColor(r, g, b);
            slotFrame.itemBorder:SetAlpha(borderAlpha);
            slotFrame.itemBorder:Show();
        else
            slotFrame.itemBorder:Hide();
        end
    else
        slotFrame.itemBorder:Hide();
    end
end

local equipmentSlots = {
    "Head", "Neck", "Shoulder", "Back", "Chest", "Shirt", "Tabard",
    "Wrist", "Hands", "Waist", "Legs", "Feet", "Finger0", "Finger1",
    "Trinket0", "Trinket1", "MainHand", "SecondaryHand", "Ranged", "Ammo"
};

-- Update character equipment slots with quality borders

function itemFrameManager:updateCharacterSlots(unit, frameType)
    for _, slotName in ipairs(equipmentSlots) do
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
                slotFrame.itemBorder:SetAlpha(borderAlpha);
                slotFrame.itemBorder:Show();
            else
                slotFrame.itemBorder:Hide();
            end
        end
    end
end

-- Update merchant frame items with quality borders

function itemFrameManager:updateMerchant()
    self:updateMerchantItems(GetMerchantItemLink);
    self:updateBuybackButton();
end

function itemFrameManager:updateBuyback()
    self:updateMerchantItems(GetBuybackItemLink);
end

function itemFrameManager:updateMerchantItems(itemLinkFunc)
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

function itemFrameManager:updateBuybackButton()
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

function itemFrameManager:updateSlotBorderFromLink(itemFrame, itemId)
    local itemQuality = GetItemQuality(itemId);
    if (itemQuality and itemQuality > QUALITY_COMMON_TIER) then
        local r, g, b = GetQualityColor(itemQuality);
        itemFrame.itemBorder:SetVertexColor(r, g, b);
        itemFrame.itemBorder:SetAlpha(borderAlpha);
        itemFrame.itemBorder:Show();
    else
        itemFrame.itemBorder:Hide();
    end
end

function itemFrameManager:findLastBuybackItem()
    local lastLink = nil;
    for slotId = 1, 12 do
        local link = GetBuybackItemLink(slotId);
        if (link) then lastLink = link; end
    end
    return lastLink;
end

-- Update tradeskill interface with item quality borders

function itemFrameManager:updateTradeskill(skillId)
    self:updateTradeskillItem(skillId);
    self:updateTradeskillReagents(skillId);
end

function itemFrameManager:updateTradeskillItem(skillId)
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

function itemFrameManager:updateTradeskillReagents(skillId)
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

-- Create border texture for item slots

function itemFrameManager:createBorder(name, parent, width, height, offsetX, offsetY)
    local offsetX = offsetX or 0;
    local offsetY = offsetY or 1;

    local border = parent:CreateTexture(name .. "Border", "OVERLAY");
    border:SetTexture("Interface\\Buttons\\UI-ActionButton-Border");
    border:SetBlendMode("ADD");
    border:SetAlpha(borderAlpha);
    border:SetHeight(height);
    border:SetWidth(width);
    border:SetPoint("CENTER", parent, "CENTER", offsetX, offsetY);
    border:Hide();

    return border;
end

-- Override quality color function to use custom colors

function GetQualityColor(quality)
    local colorData = BAG_ITEM_QUALITY_COLORS[quality];
    return colorData.r, colorData.g, colorData.b;
end

-- Override item quality function to handle quest items

function GetItemQuality(itemId)
    local quality, _, _, _, _, _, _, _, _, classId = select(3, GetItemInfo(itemId));
    if (classId == 12) then quality = QUALITY_QUEST_TIER; end
    return quality;
end
