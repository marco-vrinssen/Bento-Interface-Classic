-- Style timer text for improved aura readability

local function styleAuraTimerText(auraElement)
  local durationText = _G[auraElement:GetName().."Duration"]
  if durationText then
    durationText:SetFont(FONT, 10, "OUTLINE")
    durationText:SetTextColor(1, 1, 1)
    durationText:ClearAllPoints()
    durationText:SetPoint("BOTTOM", auraElement, "BOTTOM", 2, -14)
    durationText:SetTextColor(unpack(WHITE_RGB))
  end
end

-- Apply border styling to aura buttons with dynamic color

local function applyAuraBorderStyle(auraButton, borderColor)
  if not auraButton.customBorder then
    local borderFrame = CreateFrame("Frame", nil, auraButton, "BackdropTemplate")
    borderFrame:SetPoint("TOPLEFT", auraButton, "TOPLEFT", -3, 3)
    borderFrame:SetPoint("BOTTOMRIGHT", auraButton, "BOTTOMRIGHT", 3, -3)
    borderFrame:SetBackdrop({ edgeFile = BORD, edgeSize = 12 })
    borderFrame:SetBackdropBorderColor(unpack(borderColor or GREY_RGB))
    borderFrame:SetFrameLevel(auraButton:GetFrameLevel() + 2)
    auraButton.customBorder = borderFrame
  else
    auraButton.customBorder:SetBackdropBorderColor(unpack(borderColor or GREY_RGB))
  end

  local icon = _G[auraButton:GetName().."Icon"]
  if icon then
    icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
  end

  local border = _G[auraButton:GetName().."Border"]
  if border then
    border:Hide()
  end
end

-- Style buff buttons with grey borders

local function styleBuffButtonGrey(buffButton)
  applyAuraBorderStyle(buffButton, GREY_RGB)
end

-- Style debuff buttons with color by debuff type

local function styleDebuffButtonByType(debuffButton)
  local debuffType = select(5, UnitDebuff("player", debuffButton:GetID()))
  local color = RED_RGB
  if debuffType == "Poison" then
    color = GREEN_RGB
  elseif debuffType == "Magic" then
    color = BLUE_RGB
  elseif debuffType == "Curse" then
    color = VIOLET_RGB
  elseif debuffType == "Disease" then
    color = ORANGE_RGB
  end
  applyAuraBorderStyle(debuffButton, color)
end

-- Style enchant buttons with blue borders

local function styleEnchantButtonBlue(tempEnchant)
  applyAuraBorderStyle(tempEnchant, BLUE_RGB)
  local enchantBorder = _G[tempEnchant:GetName().."Border"]
  if enchantBorder then
    enchantBorder:Hide()
  end
end

-- Hook duration updates for timer styling

hooksecurefunc("AuraButton_UpdateDuration", function(auraElement)
  if auraElement then
    styleAuraTimerText(auraElement)
  end
end)

-- Hook aura updates for border styling

hooksecurefunc("AuraButton_Update", function(buttonName, index, filter)
  local auraButton = _G[buttonName..index]
  if auraButton then
    if filter == "HARMFUL" then
      styleDebuffButtonByType(auraButton)
    else
      styleBuffButtonGrey(auraButton)
    end
  end
end)

-- Position auras near minimap for layout

local function arrangeAuraLayoutMinimap()
  BuffFrame:ClearAllPoints()

  local anchor = Minimap
  local offsetX = -40
  local offsetY = 0
  local padding = 8

  local hasFirstAura = false

  for i = 1, 5 do
    local tempEnchant = _G["TempEnchant"..i]
    if tempEnchant and tempEnchant:IsShown() then
      if not hasFirstAura then
        tempEnchant:ClearAllPoints()
        tempEnchant:SetPoint("TOPRIGHT", anchor, "TOPLEFT", offsetX, offsetY)
        anchor = tempEnchant
        hasFirstAura = true
      else
        tempEnchant:ClearAllPoints()
        tempEnchant:SetPoint("TOPRIGHT", anchor, "TOPLEFT", -padding, 0)
        anchor = tempEnchant
      end
    end
  end

  for i = 1, BUFF_MAX_DISPLAY do
    local buffButton = _G["BuffButton"..i]
    if buffButton and buffButton:IsShown() then
      if not hasFirstAura then
        buffButton:ClearAllPoints()
        buffButton:SetPoint("TOPRIGHT", anchor, "TOPLEFT", offsetX, offsetY)
        anchor = buffButton
        hasFirstAura = true
      else
        buffButton:ClearAllPoints()
        buffButton:SetPoint("TOPRIGHT", anchor, "TOPLEFT", -padding, 0)
        anchor = buffButton
      end
    end
  end

  local debuffAnchor = Minimap
  local hasBuffs = false

  for i = 1, 5 do
    local tempEnchant = _G["TempEnchant"..i]
    if tempEnchant and tempEnchant:IsShown() and not hasBuffs then
      debuffAnchor = tempEnchant
      hasBuffs = true
      break
    end
  end

  if not hasBuffs then
    for i = 1, BUFF_MAX_DISPLAY do
      local buffButton = _G["BuffButton"..i]
      if buffButton and buffButton:IsShown() then
        debuffAnchor = buffButton
        hasBuffs = true
        break
      end
    end
  end

  local hasFirstDebuff = false
  local debuffAnchorPoint = hasBuffs and debuffAnchor or Minimap
  local debuffOffsetX = hasBuffs and 0 or offsetX

  for i = 1, DEBUFF_MAX_DISPLAY do
    local debuffButton = _G["DebuffButton"..i]
    if debuffButton and debuffButton:IsShown() then
      if not hasFirstDebuff then
        debuffButton:ClearAllPoints()
        debuffButton:SetPoint("TOPRIGHT", debuffAnchorPoint, hasBuffs and "BOTTOMRIGHT" or "TOPLEFT", debuffOffsetX, -40)
        debuffAnchor = debuffButton
        hasFirstDebuff = true
      else
        debuffButton:ClearAllPoints()
        debuffButton:SetPoint("TOPRIGHT", debuffAnchor, "TOPLEFT", -padding, 0)
        debuffAnchor = debuffButton
      end
    end
  end
end

-- Update all auras for visual consistency

local function refreshAllAuraStyles()
  for i = 1, BUFF_MAX_DISPLAY do
    local buffButton = _G["BuffButton"..i]
    if buffButton then
      styleAuraTimerText(buffButton)
      styleBuffButtonGrey(buffButton)
    end
  end

  for i = 1, DEBUFF_MAX_DISPLAY do
    local debuffButton = _G["DebuffButton"..i]
    if debuffButton then
      styleAuraTimerText(debuffButton)
      styleDebuffButtonByType(debuffButton)
    end
  end

  for i = 1, 5 do
    local tempEnchant = _G["TempEnchant"..i]
    if tempEnchant then
      styleAuraTimerText(tempEnchant)
      styleEnchantButtonBlue(tempEnchant)
    end
  end

  arrangeAuraLayoutMinimap()
end

-- Handle aura events for styling

local auraEventFrame = CreateFrame("Frame")
auraEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
auraEventFrame:RegisterEvent("UNIT_AURA")
auraEventFrame:SetScript("OnEvent", function(self, event, unit)
  if event == "UNIT_AURA" and unit ~= "player" then
    return
  end
  refreshAllAuraStyles()
end)

-- Hook anchor updates for layout

hooksecurefunc("BuffFrame_UpdateAllBuffAnchors", arrangeAuraLayoutMinimap)