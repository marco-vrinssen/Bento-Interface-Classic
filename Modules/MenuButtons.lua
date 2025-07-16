-- Configure micro buttons

local function configureMicroButtons()
  local visibleButtons = {}
  
  for buttonName in pairs(_G) do
    if type(buttonName) == "string" and string.match(buttonName, "^%a+MicroButton$") then
      local button = _G[buttonName]
      if type(button) == "table" and button.IsVisible and button:IsVisible() then
        table.insert(visibleButtons, button)
        button:SetAlpha(0.5)
        button:SetWidth(28)
      end
    end
  end

  local buttonCount = #visibleButtons
  
  CharacterMicroButton:ClearAllPoints()
  CharacterMicroButton:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -((buttonCount - 1) * 27), 16)
end

-- Schedule button update

local function scheduleUpdate()
  C_Timer.After(0, configureMicroButtons)
end

-- Register event handlers

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("UI_SCALE_CHANGED")
eventFrame:RegisterEvent("DISPLAY_SIZE_CHANGED")
eventFrame:SetScript("OnEvent", scheduleUpdate)