-- Define bagButtonList for main and keyring bags

local bagButtonList = {
  MainMenuBarBackpackButton,
  CharacterBag0Slot,
  CharacterBag1Slot,
  CharacterBag2Slot,
  CharacterBag3Slot,
  KeyRingButton
}

-- Style a single bag button for consistent appearance

local function styleBagButton(bagButton)
  if not bagButton or bagButton.customBorder then return end
  bagButton:SetScale(0.95)
  local bagButtonName = bagButton:GetName()
  local borderFrame = CreateFrame("Frame", nil, bagButton, "BackdropTemplate")
  borderFrame:SetPoint("TOPLEFT", bagButton, "TOPLEFT", -3, 3)
  borderFrame:SetPoint("BOTTOMRIGHT", bagButton, "BOTTOMRIGHT", 3, -3)
  borderFrame:SetBackdrop({
    edgeFile = BORD,
    edgeSize = 12
  })
  borderFrame:SetBackdropBorderColor(unpack(GREY_RGB))
  borderFrame:SetFrameLevel(bagButton:GetFrameLevel() + 2)
  bagButton.customBorder = borderFrame
  local normalTexture = _G[bagButtonName.."NormalTexture"]
  if normalTexture then
    normalTexture:SetAlpha(0)
    normalTexture:Hide()
  end
  local iconTexture = _G[bagButtonName.."IconTexture"]
  if iconTexture then
    iconTexture:ClearAllPoints()
    iconTexture:SetPoint("TOPLEFT", bagButton, "TOPLEFT", 0, -0)
    iconTexture:SetPoint("BOTTOMRIGHT", bagButton, "BOTTOMRIGHT", -0, 0)
    iconTexture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
  end
end

-- Arrange main bag button positions for UI layout

local function arrangeBagButtonPositions()
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

  for _, bagButton in ipairs(bagButtonList) do
    styleBagButton(bagButton)
  end
end

-- Register events to style and arrange bag buttons

local bagSlotFrame = CreateFrame("Frame")
bagSlotFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
bagSlotFrame:RegisterEvent("BAG_UPDATE")
bagSlotFrame:SetScript("OnEvent", arrangeBagButtonPositions)

-- Arrange open container frame positions for UI

local function arrangeContainerPositions()
  local visibleContainerList = {}

  for i = 1, NUM_CONTAINER_FRAMES do
    local containerFrame = _G["ContainerFrame"..i]
    if containerFrame and containerFrame:IsShown() then
      table.insert(visibleContainerList, containerFrame)
    end
  end

  if #visibleContainerList > 0 then
    visibleContainerList[1]:ClearAllPoints()
    visibleContainerList[1]:SetPoint("BOTTOMRIGHT", MainMenuBarBackpackButton, "TOPRIGHT", 4, 4)

    for i = 2, #visibleContainerList do
      local container = visibleContainerList[i]
      container:ClearAllPoints()

      if i % 2 == 0 then
        container:SetPoint("BOTTOMRIGHT", visibleContainerList[i-1], "TOPRIGHT", 0, 4)
      else
        container:SetPoint("BOTTOMRIGHT", visibleContainerList[i-2], "BOTTOMLEFT", 0, 4)
      end
    end
  end

  if not IsBagOpen(0) then
    if IsBagOpen(KEYRING_CONTAINER) then
      ToggleBag(KEYRING_CONTAINER)
    end
  end
end

-- Hook container anchor updates to custom arrangement

hooksecurefunc("UpdateContainerFrameAnchors", arrangeContainerPositions)

-- Register events for container arrangement

local bagContainerFrame = CreateFrame("Frame")
bagContainerFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
bagContainerFrame:RegisterEvent("BAG_UPDATE")
bagContainerFrame:RegisterEvent("BANKFRAME_OPENED")
bagContainerFrame:RegisterEvent("BANKFRAME_CLOSED")
bagContainerFrame:RegisterEvent("MERCHANT_SHOW")
bagContainerFrame:RegisterEvent("MERCHANT_CLOSED")
bagContainerFrame:RegisterEvent("BAG_OPEN")
bagContainerFrame:RegisterEvent("BAG_CLOSED")
bagContainerFrame:SetScript("OnEvent", arrangeContainerPositions)

-- Toggle all player bags open or closed

local function toggleAllBags()
  if IsBagOpen(0) then
    CloseAllBags()
  else
    OpenAllBags()
  end
end

-- Set backpack button click to toggle all bags

MainMenuBarBackpackButton:SetScript("OnClick", toggleAllBags)

-- Open all bank bags for player

local function openBankBagContainers()
  for bagId = NUM_BAG_SLOTS + 1, NUM_BAG_SLOTS + NUM_BANKBAGSLOTS do
    OpenBag(bagId)
  end
end

-- Close all bank bags for player

local function closeBankBagContainers()
  for bagId = NUM_BAG_SLOTS + 1, NUM_BAG_SLOTS + NUM_BANKBAGSLOTS do
    CloseBag(bagId)
  end
end

-- Register events for bank bag toggling

local bankToggleFrame = CreateFrame("Frame")
bankToggleFrame:RegisterEvent("BANKFRAME_OPENED")
bankToggleFrame:RegisterEvent("BANKFRAME_CLOSED")
bankToggleFrame:SetScript("OnEvent", function(self, event)
  if event == "BANKFRAME_OPENED" then
    openBankBagContainers()
  elseif event == "BANKFRAME_CLOSED" then
    closeBankBagContainers()
  end
end)

-- Style bank bag buttons for consistent appearance

local function styleBankBagButtons()
end

-- Register events for bank bag styling and bag arrangement

local bankStyleFrame = CreateFrame("Frame")
bankStyleFrame:RegisterEvent("BANKFRAME_OPENED")
bankStyleFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
bankStyleFrame:SetScript("OnEvent", function(self, event)
  if event == "BANKFRAME_OPENED" then
    styleBankBagButtons()
  elseif event == "PLAYER_ENTERING_WORLD" then
    arrangeBagButtonPositions()
  end
end)