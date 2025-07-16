-- Collect visible micro buttons for positioning

local function collectVisibleMicroButtons()
  local visibleMicroButtons = {}
  
  for globalName in pairs(_G) do
    if type(globalName) == "string" and string.match(globalName, "^%a+MicroButton$") then
      local microButton = _G[globalName]
      if type(microButton) == "table" and microButton.IsVisible and microButton:IsVisible() then
        table.insert(visibleMicroButtons, microButton)
        microButton:SetAlpha(0.8)
      end
    end
  end

  local singleButtonWidth = CharacterMicroButton:GetWidth()
  local allButtonsWidth = singleButtonWidth * #visibleMicroButtons
  local positionOffset = singleButtonWidth + 16

  CharacterMicroButton:ClearAllPoints()
  CharacterMicroButton:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -(allButtonsWidth - positionOffset), 16)
end

-- Schedule micro button positioning update

local function scheduleMicroButtonUpdate()
  C_Timer.After(0, collectVisibleMicroButtons)
end

-- Register positioning event handlers

local microButtonEventFrame = CreateFrame("Frame")
microButtonEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
microButtonEventFrame:RegisterEvent("PLAYER_LOGIN")
microButtonEventFrame:RegisterEvent("UI_SCALE_CHANGED")
microButtonEventFrame:RegisterEvent("DISPLAY_SIZE_CHANGED")
microButtonEventFrame:SetScript("OnEvent", scheduleMicroButtonUpdate)