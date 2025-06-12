-- Define bag button collection

local bagButtons = {
  MainMenuBarBackpackButton,
  CharacterBag0Slot,
  CharacterBag1Slot,
  CharacterBag2Slot,
  CharacterBag3Slot,
  KeyRingButton
}

-- Apply style to single bag button

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

-- Arrange main bag button positions

local function arrangeBagButtons()
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

  for _, bagButton in ipairs(bagButtons) do
    styleBagButton(bagButton)
  end
end

-- Register events for bag button styling

local bagSlotFrame = CreateFrame("Frame")
bagSlotFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
bagSlotFrame:RegisterEvent("BAG_UPDATE")
bagSlotFrame:SetScript("OnEvent", arrangeBagButtons)

-- Arrange open container frame positions

local function arrangeContainers()
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

-- Hook container anchor updates

hooksecurefunc("UpdateContainerFrameAnchors", arrangeContainers)

-- Register events for container arranging

local bagContainerFrame = CreateFrame("Frame")
bagContainerFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
bagContainerFrame:RegisterEvent("BAG_UPDATE")
bagContainerFrame:RegisterEvent("BANKFRAME_OPENED")
bagContainerFrame:RegisterEvent("BANKFRAME_CLOSED")
bagContainerFrame:RegisterEvent("MERCHANT_SHOW")
bagContainerFrame:RegisterEvent("MERCHANT_CLOSED")
bagContainerFrame:RegisterEvent("BAG_OPEN")
bagContainerFrame:RegisterEvent("BAG_CLOSED")
bagContainerFrame:SetScript("OnEvent", arrangeContainers)

-- Implement toggle for all player bags

local function toggleAllBags()
  if IsBagOpen(0) then
    CloseAllBags()
  else
    OpenAllBags()
  end
end

-- Set backpack button click to toggle bags

MainMenuBarBackpackButton:SetScript("OnClick", toggleAllBags)

-- Implement opening all bank bags

local function openBankContainers()
  for bagId = NUM_BAG_SLOTS + 1, NUM_BAG_SLOTS + NUM_BANKBAGSLOTS do
    OpenBag(bagId)
  end
end

-- Implement closing all bank bags

local function closeBankContainers()
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
    openBankContainers()
  elseif event == "BANKFRAME_CLOSED" then
    closeBankContainers()
  end
end)

-- Implement styling for bank bag buttons

local function styleBankBags()
end

-- Register events for bank bag styling

local bankStyleFrame = CreateFrame("Frame")
bankStyleFrame:RegisterEvent("BANKFRAME_OPENED")
bankStyleFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
bankStyleFrame:SetScript("OnEvent", function(self, event)
  if event == "BANKFRAME_OPENED" then
    styleBankBags()
  elseif event == "PLAYER_ENTERING_WORLD" then
    arrangeBagButtons()
  end
end)