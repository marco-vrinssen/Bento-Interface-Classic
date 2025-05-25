-- DEFINE TARGET BAG BUTTONS

local bagButtons = {
    MainMenuBarBackpackButton,
    CharacterBag0Slot,
    CharacterBag1Slot,
    CharacterBag2Slot,
    CharacterBag3Slot,
    KeyRingButton
}

-- CUSTOMIZE BAG SLOT BUTTONS

local function customizeBagSlot(button)
    if not button or button.customBorder then return end

    button:SetScale(0.95)

    local name = button:GetName()
    local backdrop = CreateFrame("Frame", nil, button, "BackdropTemplate")
    backdrop:SetPoint("TOPLEFT", button, "TOPLEFT", -3, 3)
    backdrop:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 3, -3)
    backdrop:SetBackdrop({
        edgeFile = BORD,
        edgeSize = 12
    })
    backdrop:SetBackdropBorderColor(unpack(GREY_RGB))
    backdrop:SetFrameLevel(button:GetFrameLevel() + 2)
    button.customBorder = backdrop

    local normalTexture = _G[name.."NormalTexture"]
    if normalTexture then
        normalTexture:SetAlpha(0)
        normalTexture:Hide()
    end

    local iconTexture = _G[name.."IconTexture"]
    if iconTexture then
        iconTexture:ClearAllPoints()
        iconTexture:SetPoint("TOPLEFT", button, "TOPLEFT", 0, -0)
        iconTexture:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -0, 0)
        iconTexture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    end
end

-- UPDATE BAG SLOTS

local function updateBagSlots()
    MainMenuBarBackpackButton:ClearAllPoints()
    MainMenuBarBackpackButton:SetPoint("BOTTOMRIGHT", HelpMicroButton, "TOPRIGHT", -4, -16)

    CharacterBag0Slot:ClearAllPoints()
    CharacterBag0Slot:SetPoint("RIGHT", MainMenuBarBackpackButton, "LEFT", -4, 0)
    CharacterBag0Slot:SetParent(ContainerFrame1)

    CharacterBag1Slot:ClearAllPoints()
    CharacterBag1Slot:SetPoint("RIGHT", CharacterBag0Slot, "LEFT", -4, 0)
    CharacterBag1Slot:SetParent(ContainerFrame1)

    CharacterBag2Slot:ClearAllPoints()
    CharacterBag2Slot:SetPoint("RIGHT", CharacterBag1Slot, "LEFT", -4, 0)
    CharacterBag2Slot:SetParent(ContainerFrame1)

    CharacterBag3Slot:ClearAllPoints()
    CharacterBag3Slot:SetPoint("RIGHT", CharacterBag2Slot, "LEFT", -4, 0)
    CharacterBag3Slot:SetParent(ContainerFrame1)

    KeyRingButton:ClearAllPoints()
    KeyRingButton:SetPoint("RIGHT", CharacterBag3Slot, "LEFT", -4, -1)
    KeyRingButton:SetParent(ContainerFrame1)

    for _, button in ipairs(bagButtons) do
        customizeBagSlot(button)
    end
end

local bagSlotEvents = CreateFrame("Frame")
bagSlotEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
bagSlotEvents:RegisterEvent("BAG_UPDATE")
bagSlotEvents:SetScript("OnEvent", updateBagSlots)

-- UPDATE BAG CONTAINERS

local function updateContainers()
    local visibleContainers = {}

    for i = 1, NUM_CONTAINER_FRAMES do
        local containerFrame = _G["ContainerFrame"..i]
        if containerFrame and containerFrame:IsShown() then
            table.insert(visibleContainers, containerFrame)
        end
    end

    if #visibleContainers > 0 then
        visibleContainers[1]:ClearAllPoints()
        visibleContainers[1]:SetPoint("BOTTOMRIGHT", MainMenuBarBackpackButton, "TOPRIGHT", 4, 4)

        for i = 2, #visibleContainers do
            local container = visibleContainers[i]
            container:ClearAllPoints()

            if i % 2 == 0 then
                container:SetPoint("BOTTOMRIGHT", visibleContainers[i-1], "TOPRIGHT", 0, 4)
            else
                container:SetPoint("BOTTOMRIGHT", visibleContainers[i-2], "BOTTOMLEFT", 0, 4)
            end
        end
    end

    if not IsBagOpen(0) then
        if IsBagOpen(KEYRING_CONTAINER) then
            ToggleBag(KEYRING_CONTAINER)
        end
    end
end

hooksecurefunc("UpdateContainerFrameAnchors", updateContainers)

local bagContainerEvents = CreateFrame("Frame")
bagContainerEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
bagContainerEvents:RegisterEvent("BAG_UPDATE")
bagContainerEvents:RegisterEvent("BANKFRAME_OPENED")
bagContainerEvents:RegisterEvent("BANKFRAME_CLOSED")
bagContainerEvents:RegisterEvent("MERCHANT_SHOW")
bagContainerEvents:RegisterEvent("MERCHANT_CLOSED")
bagContainerEvents:RegisterEvent("BAG_OPEN")
bagContainerEvents:RegisterEvent("BAG_CLOSED")
bagContainerEvents:SetScript("OnEvent", updateContainers)

-- ENABLE AUTOMATIC BAG TOGGLE

local function togglePlayerBags()
    if IsBagOpen(0) then
        CloseAllBags()
    else
        OpenAllBags()
    end
end

MainMenuBarBackpackButton:SetScript("OnClick", togglePlayerBags)

-- ENABLE AUTOMATIC BANK BAG TOGGLE

local function openBankBags()
    for bagID = NUM_BAG_SLOTS + 1, NUM_BAG_SLOTS + NUM_BANKBAGSLOTS do
        OpenBag(bagID)
    end
end

local function closeBankBags()
    for bagID = NUM_BAG_SLOTS + 1, NUM_BAG_SLOTS + NUM_BANKBAGSLOTS do
        CloseBag(bagID)
    end
end

local bagToggleEvents = CreateFrame("Frame")
bagToggleEvents:RegisterEvent("BANKFRAME_OPENED")
bagToggleEvents:RegisterEvent("BANKFRAME_CLOSED")
bagToggleEvents:SetScript("OnEvent", function(self, event)
    if event == "BANKFRAME_OPENED" then
        openBankBags()
    elseif event == "BANKFRAME_CLOSED" then
        closeBankBags()
    end
end)

-- CUSTOMIZE BANK BAG SLOTS

local function customizeBankBagSlots()
end

local bagCustomizationEvents = CreateFrame("Frame")
bagCustomizationEvents:RegisterEvent("BANKFRAME_OPENED")
bagCustomizationEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
bagCustomizationEvents:SetScript("OnEvent", function(self, event)
    if event == "BANKFRAME_OPENED" then
        customizeBankBagSlots()
    elseif event == "PLAYER_ENTERING_WORLD" then
        updateBagSlots()
    end
end)