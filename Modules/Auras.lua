-- Style aura timer text to improve readability
local function styleAuraTimer(aura)
  local durationText = _G[aura:GetName().."Duration"]
  if durationText then
    durationText:SetFont(FONT, 10, "OUTLINE")
    durationText:SetTextColor(1, 1, 1)
    durationText:ClearAllPoints()
    durationText:SetPoint("BOTTOM", aura, "BOTTOM", 2, -14)
    durationText:SetTextColor(unpack(WHITE_RGB))
  end
end

hooksecurefunc("AuraButton_UpdateDuration", function(aura)
  if aura then
    styleAuraTimer(aura)
  end
end)

-- Add border styling and crop icons to create uniform appearance
local function applyAuraStyle(button, borderColor)
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

  local buttonIcon = _G[button:GetName().."Icon"]
  if buttonIcon then
    buttonIcon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
  end

  local buttonBorder = _G[button:GetName().."Border"]
  if buttonBorder then
    buttonBorder:Hide()
  end
end

local function styleBuffButton(button)
  applyAuraStyle(button, GREY_RGB)
end

local function styleDebuffButton(button)
  applyAuraStyle(button, RED_RGB)
end

local function styleTempEnchant(button)
  applyAuraStyle(button, VIOLET_RGB)

  local enchantBorder = _G[button:GetName().."Border"]
  if enchantBorder then
    enchantBorder:Hide()
  end
end

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

-- Position auras near minimap to maintain clean interface layout
local function arrangeAuraPosition()
  BuffFrame:ClearAllPoints()

  local anchorPoint = Minimap
  local offsetX = -40
  local offsetY = 0
  local padding = 8

  local hasFirstAura = false

  for i = 1, 5 do
    local enchantButton = _G["TempEnchant"..i]
    if enchantButton and enchantButton:IsShown() then
      if not hasFirstAura then
        enchantButton:ClearAllPoints()
        enchantButton:SetPoint("TOPRIGHT", anchorPoint, "TOPLEFT", offsetX, offsetY)
        anchorPoint = enchantButton
        hasFirstAura = true
      else
        enchantButton:ClearAllPoints()
        enchantButton:SetPoint("TOPRIGHT", anchorPoint, "TOPLEFT", -padding, 0)
        anchorPoint = enchantButton
      end
    end
  end

  for i = 1, BUFF_MAX_DISPLAY do
    local buffButton = _G["BuffButton"..i]
    if buffButton and buffButton:IsShown() then
      if not hasFirstAura then
        buffButton:ClearAllPoints()
        buffButton:SetPoint("TOPRIGHT", anchorPoint, "TOPLEFT", offsetX, offsetY)
        anchorPoint = buffButton
        hasFirstAura = true
      else
        buffButton:ClearAllPoints()
        buffButton:SetPoint("TOPRIGHT", anchorPoint, "TOPLEFT", -padding, 0)
        anchorPoint = buffButton
      end
    end
  end

  local debuffAnchor = Minimap
  local hasBuffs = false

  for i = 1, 5 do
    local enchantButton = _G["TempEnchant"..i]
    if enchantButton and enchantButton:IsShown() and not hasBuffs then
      debuffAnchor = enchantButton
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

-- Update all player auras to ensure consistent styling
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
    local enchantButton = _G["TempEnchant"..i]
    if enchantButton then
      styleAuraTimer(enchantButton)
      styleTempEnchant(enchantButton)
    end
  end

  arrangeAuraPosition()
end

-- Handle aura update events to maintain visual consistency
local auraEventFrame = CreateFrame("Frame")
auraEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
auraEventFrame:RegisterEvent("UNIT_AURA")
auraEventFrame:SetScript("OnEvent", function(self, event, unit)
  if event == "UNIT_AURA" and unit ~= "player" then
    return
  end
  refreshPlayerAuras()
end)

hooksecurefunc("BuffFrame_UpdateAllBuffAnchors", arrangeAuraPosition)