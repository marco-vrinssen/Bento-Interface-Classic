-- Define bag button elements for consistent interface organization

local bagButtons = {
  MainMenuBarBackpackButton,
  CharacterBag0Slot,
  CharacterBag1Slot,
  CharacterBag2Slot,
  CharacterBag3Slot,
  KeyRingButton
}

-- Style bag buttons to create consistent visual appearance

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

-- Position bag buttons near microMenu for interface organization

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

-- Register bag slot events to maintain button styling

local bagSlotFrame = CreateFrame("Frame")
bagSlotFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
bagSlotFrame:RegisterEvent("BAG_UPDATE")
bagSlotFrame:SetScript("OnEvent", arrangeBagButtons)

-- Arrange container frames in optimized grid formation

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

hooksecurefunc("UpdateContainerFrameAnchors", arrangeContainers)

-- Register bag container events for dynamic updates

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

-- Toggle all player bags for simplified management

local function toggleAllBags()
  if IsBagOpen(0) then
    CloseAllBags()
  else
    OpenAllBags()
  end
end

MainMenuBarBackpackButton:SetScript("OnClick", toggleAllBags)

-- Open bank containers when accessing bank interface

local function openBankContainers()
  for bagID = NUM_BAG_SLOTS + 1, NUM_BAG_SLOTS + NUM_BANKBAGSLOTS do
    OpenBag(bagID)
  end
end

-- Close bank containers when leaving bank interface

local function closeBankContainers()
  for bagID = NUM_BAG_SLOTS + 1, NUM_BAG_SLOTS + NUM_BANKBAGSLOTS do
    CloseBag(bagID)
  end
end

-- Register bank toggle events for automatic handling

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

-- Style bank bag buttons to match interface appearance

local function styleBankBags()
end

-- Register bank bag style events for consistency

local bankBagStyleFrame = CreateFrame("Frame")
bankBagStyleFrame:RegisterEvent("BANKFRAME_OPENED")
bankBagStyleFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
bankBagStyleFrame:SetScript("OnEvent", function(self, event)
  if event == "BANKFRAME_OPENED" then
    styleBankBags()
  elseif event == "PLAYER_ENTERING_WORLD" then
    arrangeBagButtons()
  end
end)