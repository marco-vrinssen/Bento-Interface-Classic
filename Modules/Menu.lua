-- CUSTOMIZE MICRO MENU BUTTONS

local function updateMenuButtons()
  local menuButtons = {}

  for name in pairs(_G) do
    if type(name) == "string" and string.match(name, "^%a+MicroButton$") then
      local button = _G[name]
      if type(button) == "table" and button.IsVisible and button:IsVisible() then
        table.insert(menuButtons, button)
      end
    end
  end
  
  local buttonWidth = CharacterMicroButton:GetWidth()
  local totalMenuWidth = buttonWidth * (#menuButtons - 1)
  
  CharacterMicroButton:ClearAllPoints()
  CharacterMicroButton:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -totalMenuWidth, 16)
end


-- DELAYED MICROMENU UPDATE

local function delayUpdate()
  C_Timer.After(0.1, updateMenuButtons)
end

local microMenuEvents = CreateFrame("Frame")
microMenuEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
microMenuEvents:RegisterEvent("PLAYER_LOGIN")
microMenuEvents:SetScript("OnEvent", delayUpdate)


-- UPDATE LFG BUTTON

local function updateMinimapAndLFG()
  if LFGMinimapFrameBorder then
      LFGMinimapFrameBorder:Hide()
  end

  if LFGMinimapFrame then
      LFGMinimapFrame:SetParent(Minimap)
      LFGMinimapFrame:ClearAllPoints()
      LFGMinimapFrame:SetSize(36, 36)
      LFGMinimapFrame:SetPoint("RIGHT", CharacterMicroButton, "LEFT", -4, -12)
  end

  if LFGMinimapFrameIcon then
      LFGMinimapFrameIcon:SetSize(40, 40)
      LFGMinimapFrameIcon:SetPoint("CENTER", LFGMinimapFrame, "CENTER", 0, 0)
  end
end

local minimapLFGEvents = CreateFrame("Frame")
minimapLFGEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
minimapLFGEvents:SetScript("OnEvent", updateMinimapAndLFG)