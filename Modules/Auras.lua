-- Style aura timer text to improve readability

local function styleAuraTimer(auraElement)
  local durationText = _G[auraElement:GetName().."Duration"]
  if durationText then
    durationText:SetFont(FONT, 10, "OUTLINE")
    durationText:SetTextColor(1, 1, 1)
    durationText:ClearAllPoints()
    durationText:SetPoint("BOTTOM", auraElement, "BOTTOM", 2, -14)
    durationText:SetTextColor(unpack(WHITE_RGB))
  end
end

-- Apply consistent border styling to aura buttons

local function applyAuraStyle(auraButton, borderColor)
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


-- Style buff buttons with default border color

local function styleBuffButton(buffButton)
  applyAuraStyle(buffButton, GREY_RGB)
end

-- Style debuff buttons with red border color

local function styleDebuffButton(debuffButton)
  applyAuraStyle(debuffButton, RED_RGB)
end

-- Style temporary enchant buttons with violet border

local function styleTempEnchant(tempEnchant)
  applyAuraStyle(tempEnchant, VIOLET_RGB)

  local enchantBorder = _G[tempEnchant:GetName().."Border"]
  if enchantBorder then
    enchantBorder:Hide()
  end
end

hooksecurefunc("AuraButton_UpdateDuration", function(auraElement)
  if auraElement then
    styleAuraTimer(auraElement)
  end
end)


hooksecurefunc("AuraButton_Update", function(buttonName, index, filter)
  local auraButton = _G[buttonName..index]
  if auraButton then
    if filter == "HARMFUL" then
      styleDebuffButton(auraButton)
    else
      styleBuffButton(auraButton)
    end
  end
end)

-- Position aura elements near minimap for organized layout

local function arrangeAuraPosition()
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
        debuffButton:SetPoint("TOPRIGHT", debuffAnchorPoint, hasBuffs and "BOTTOMRIGHT" or "TOPLEFT", debuffOffsetX, -24)
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


-- Update all player auras for visual consistency

local function refreshPlayerAuras()
  for i = 1, BUFF_MAX_DISPLAY do
    local buffButton = _G["BuffButton"..i]
    if buffButton then
      styleAuraTimer(buffButton)
      styleBuffButton(buffButton)
    end
  end

  for i = 1, DEBUFF_MAX_DISPLAY do
    local debuffButton = _G["DebuffButton"..i]
    if debuffButton then
      styleAuraTimer(debuffButton)
      styleDebuffButton(debuffButton)
    end
  end

  for i = 1, 5 do
    local tempEnchant = _G["TempEnchant"..i]
    if tempEnchant then
      styleAuraTimer(tempEnchant)
      styleTempEnchant(tempEnchant)
    end
  end

  arrangeAuraPosition()
end

-- Handle aura update events for consistent styling

local auraUpdateFrame = CreateFrame("Frame")
auraUpdateFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
auraUpdateFrame:RegisterEvent("UNIT_AURA")
auraUpdateFrame:SetScript("OnEvent", function(self, event, unit)
  if event == "UNIT_AURA" and unit ~= "player" then
    return
  end
  refreshPlayerAuras()
end)

hooksecurefunc("BuffFrame_UpdateAllBuffAnchors", arrangeAuraPosition)