-- Define bag button list for main and keyring bags
local bagButtons = {
    MainMenuBarBackpackButton,
    CharacterBag0Slot,
    CharacterBag1Slot,
    CharacterBag2Slot,
    CharacterBag3Slot,
    KeyRingButton
}

-- Style single bag button
local function styleBag(button)
    if not button or button.customBorder then return end
    local name = button:GetName()
    local border = CreateFrame("Frame", nil, button, "BackdropTemplate")
    border:SetPoint("TOPLEFT", button, "TOPLEFT", -3, 3)
    border:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 3, -3)
    border:SetBackdrop({
        edgeFile = BORD,
        edgeSize = 12
    })
    border:SetBackdropBorderColor(unpack(GREY_RGB))
    border:SetFrameLevel(button:GetFrameLevel() + 2)
    button.customBorder = border
    local normal = _G[name.."NormalTexture"]
    if normal then
        normal:SetAlpha(0)
        normal:Hide()
    end
    local icon = _G[name.."IconTexture"]
    if icon then
        icon:ClearAllPoints()
        icon:SetPoint("TOPLEFT", button, "TOPLEFT", 0, -0)
        icon:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -0, 0)
        icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    end
end

-- Arrange main bag button positions
local function arrangeBags()
    MainMenuBarBackpackButton:ClearAllPoints()
    MainMenuBarBackpackButton:SetPoint("BOTTOMRIGHT", MainMenuMicroButton, "TOPRIGHT", 0, 4)

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
        styleBag(button)
    end
end

-- Register events to style and arrange bag buttons
local bagSlotFrame = CreateFrame("Frame")
bagSlotFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
bagSlotFrame:RegisterEvent("BAG_UPDATE")
bagSlotFrame:SetScript("OnEvent", arrangeBags)

-- Arrange open container frame positions
local function arrangeContainers()
    local visibleList = {}

    for i = 1, NUM_CONTAINER_FRAMES do
        local frame = _G["ContainerFrame"..i]
        if frame and frame:IsShown() then
            table.insert(visibleList, frame)
        end
    end

    if #visibleList > 0 then
        visibleList[1]:ClearAllPoints()
        visibleList[1]:SetPoint("BOTTOMRIGHT", MainMenuBarBackpackButton, "TOPRIGHT", 4, 4)

        for i = 2, #visibleList do
            local container = visibleList[i]
            container:ClearAllPoints()

            if i % 2 == 0 then
                container:SetPoint("BOTTOMRIGHT", visibleList[i-1], "TOPRIGHT", 0, 4)
            else
                container:SetPoint("BOTTOMRIGHT", visibleList[i-2], "BOTTOMLEFT", 0, 4)
            end
        end
    end

    if not IsBagOpen(0) then
        if IsBagOpen(KEYRING_CONTAINER) then
            ToggleBag(KEYRING_CONTAINER)
        end
    end
end

-- Hook container anchor updates
hooksecurefunc("UpdateContainerFrameAnchors", arrangeContainers)

-- Register events for container arrangement
local containerFrame = CreateFrame("Frame")
containerFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
containerFrame:RegisterEvent("BAG_UPDATE")
containerFrame:RegisterEvent("BANKFRAME_OPENED")
containerFrame:RegisterEvent("BANKFRAME_CLOSED")
containerFrame:RegisterEvent("MERCHANT_SHOW")
containerFrame:RegisterEvent("MERCHANT_CLOSED")
containerFrame:RegisterEvent("BAG_OPEN")
containerFrame:RegisterEvent("BAG_CLOSED")
containerFrame:SetScript("OnEvent", arrangeContainers)

-- Toggle all player bags
local function toggleBags()
    if IsBagOpen(0) then
        CloseAllBags()
    else
        OpenAllBags()
    end
end

-- Set backpack button click handler
MainMenuBarBackpackButton:SetScript("OnClick", toggleBags)

-- Open all bank bags
local function openBankBags()
    for bagId = NUM_BAG_SLOTS + 1, NUM_BAG_SLOTS + NUM_BANKBAGSLOTS do
        OpenBag(bagId)
    end
end

-- Close all bank bags
local function closeBankBags()
    for bagId = NUM_BAG_SLOTS + 1, NUM_BAG_SLOTS + NUM_BANKBAGSLOTS do
        CloseBag(bagId)
    end
end

-- Register events for bank bag toggling
local bankToggle = CreateFrame("Frame")
bankToggle:RegisterEvent("BANKFRAME_OPENED")
bankToggle:RegisterEvent("BANKFRAME_CLOSED")
bankToggle:SetScript("OnEvent", function(self, event)
    if event == "BANKFRAME_OPENED" then
        openBankBags()
    elseif event == "BANKFRAME_CLOSED" then
        closeBankBags()
    end
end)

-- Style bank bag buttons
local function styleBankBags()
end

-- Register events for bank bag styling
local bankStyle = CreateFrame("Frame")
bankStyle:RegisterEvent("BANKFRAME_OPENED")
bankStyle:RegisterEvent("PLAYER_ENTERING_WORLD")
bankStyle:SetScript("OnEvent", function(self, event)
    if event == "BANKFRAME_OPENED" then
        styleBankBags()
    elseif event == "PLAYER_ENTERING_WORLD" then
        arrangeBags()
    end
end)