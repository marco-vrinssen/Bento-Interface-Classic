-- Style timer text with outline font
local function styleTimerText(element)
  local durationText = _G[element:GetName().."Duration"]
  if durationText then
    durationText:SetFont(FONT, 10, "OUTLINE")
    durationText:SetTextColor(1, 1, 1)
    durationText:ClearAllPoints()
    durationText:SetPoint("BOTTOM", element, "BOTTOM", 2, -14)
    durationText:SetTextColor(unpack(WHITE_RGB))
  end
end

-- Create bordered frames with color coding
local function createBorder(button, borderColor)
  if not button.customBorder then
    local borderFrame = CreateFrame("Frame", nil, button, "BackdropTemplate")
    borderFrame:SetPoint("TOPLEFT", button, "TOPLEFT", -3, 3)
    borderFrame:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 3, -3)
    borderFrame:SetBackdrop({ edgeFile = BORD, edgeSize = 12 })
    borderFrame:SetBackdropBorderColor(unpack(borderColor or GREY_RGB))
    borderFrame:SetFrameLevel(button:GetFrameLevel() + 2)
    button.customBorder = borderFrame
  else
    button.customBorder:SetBackdropBorderColor(unpack(borderColor or GREY_RGB))
  end

  local icon = _G[button:GetName().."Icon"]
  if icon then
    icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
  end

  local border = _G[button:GetName().."Border"]
  if border then
    border:Hide()
  end
end

-- Style buff with grey border
local function styleBuffs(button)
  createBorder(button, GREY_RGB)
end

-- Style debuffs with type colored borders
local function styleDebuffs(button)
  local debuffType = select(5, UnitDebuff("player", button:GetID()))
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
  createBorder(button, color)
end

-- Style enchants with blue border
local function styleEnchants(enchant)
  createBorder(enchant, BLUE_RGB)
  local enchantBorder = _G[enchant:GetName().."Border"]
  if enchantBorder then
    enchantBorder:Hide()
  end
end

-- Hook duration updates for timer styling
hooksecurefunc("AuraButton_UpdateDuration", function(element)
  if element then
    styleTimerText(element)
  end
end)

-- Hook aura updates for border styling
hooksecurefunc("AuraButton_Update", function(buttonName, index, filter)
  local button = _G[buttonName..index]
  if button then
    if filter == "HARMFUL" then
      styleDebuffs(button)
    else
      styleBuffs(button)
    end
  end
end)

-- Position auras near minimap anchor
local function arrangeLayout()
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

-- Refresh all aura styles and positioning
local function refreshStyles()
  for i = 1, BUFF_MAX_DISPLAY do
    local buffButton = _G["BuffButton"..i]
    if buffButton then
      styleTimerText(buffButton)
      styleBuffs(buffButton)
    end
  end

  for i = 1, DEBUFF_MAX_DISPLAY do
    local debuffButton = _G["DebuffButton"..i]
    if debuffButton then
      styleTimerText(debuffButton)
      styleDebuffs(debuffButton)
    end
  end

  for i = 1, 5 do
    local tempEnchant = _G["TempEnchant"..i]
    if tempEnchant then
      styleTimerText(tempEnchant)
      styleEnchants(tempEnchant)
    end
  end

  arrangeLayout()
end

-- Handle aura events for refreshing
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("UNIT_AURA")
eventFrame:SetScript("OnEvent", function(self, event, unit)
  if event == "UNIT_AURA" and unit ~= "player" then
    return
  end
  refreshStyles()
end)

-- Hook anchor updates for layout
hooksecurefunc("BuffFrame_UpdateAllBuffAnchors", arrangeLayout)