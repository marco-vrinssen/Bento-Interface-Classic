-- Position micro buttons right aligned

local BUTTON_WIDTH = 28

local function configureMicroButtons()
  local buttons = {}
  
  for buttonName in pairs(_G) do
    if type(buttonName) == "string" and string.match(buttonName, "^%a+MicroButton$") then
      local button = _G[buttonName]
      if type(button) == "table" and button.IsVisible and button:IsVisible() then
        table.insert(buttons, button)
        button:SetAlpha(0.5)
        button:SetWidth(BUTTON_WIDTH)
        button:SetClampedToScreen(false)
      end
    end
  end

  local buttonCount = #buttons
  local totalWidth = buttonCount * BUTTON_WIDTH
  local adjustedWidth = totalWidth - BUTTON_WIDTH
  
  local characterButton = _G["CharacterMicroButton"]
  if characterButton then
    characterButton:ClearAllPoints()
    characterButton:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMRIGHT", -(adjustedWidth + 16), 16)
  end
end

-- Schedule delayed button update

local function scheduleButtonUpdate()
  C_Timer.After(0, configureMicroButtons)
end

-- Register interface event handlers

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("UI_SCALE_CHANGED")
eventFrame:RegisterEvent("DISPLAY_SIZE_CHANGED")
eventFrame:SetScript("OnEvent", scheduleButtonUpdate)