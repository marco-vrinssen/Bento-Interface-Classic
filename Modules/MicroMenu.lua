-- Collect visible micro buttons to calculate positioning
local function collectVisibleButtons()
  local visibleButtons = {}
  
  for name in pairs(_G) do
    if type(name) == "string" and string.match(name, "^%a+MicroButton$") then
      local button = _G[name]
      if type(button) == "table" and button.IsVisible and button:IsVisible() then
        table.insert(visibleButtons, button)
      end
    end
  end
  
  local buttonWidth = CharacterMicroButton:GetWidth()
  local totalWidth = buttonWidth * (#visibleButtons - 1)
  
  CharacterMicroButton:ClearAllPoints()
  CharacterMicroButton:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -totalWidth, 16)
end

-- Delay button updates to ensure proper initialization
local function scheduleButtonUpdate()
  C_Timer.After(0, collectVisibleButtons)
end

-- Register events to update micro menu positioning
local menuEventFrame = CreateFrame("Frame")
menuEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
menuEventFrame:RegisterEvent("PLAYER_LOGIN")
menuEventFrame:RegisterEvent("UI_SCALE_CHANGED")
menuEventFrame:RegisterEvent("DISPLAY_SIZE_CHANGED")
menuEventFrame:SetScript("OnEvent", scheduleButtonUpdate)

-- Hide LFG border and reposition frame elements
local function repositionLfgElements()
  if LFGMinimapFrameBorder then
    LFGMinimapFrameBorder:Hide()
  end

  if LFGMinimapFrame then
    LFGMinimapFrame:SetParent(UIParent)
    LFGMinimapFrame:ClearAllPoints()
    LFGMinimapFrame:SetSize(36, 36)
    LFGMinimapFrame:SetPoint("RIGHT", CharacterMicroButton, "LEFT", -4, -12)
  end

  if LFGMinimapFrameIcon then
    LFGMinimapFrameIcon:SetSize(40, 40)
    LFGMinimapFrameIcon:SetPoint("CENTER", LFGMinimapFrame, "CENTER", 0, 0)
  end
end

-- Register events to initialize LFG positioning
local lfgEventFrame = CreateFrame("Frame")
lfgEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
lfgEventFrame:SetScript("OnEvent", repositionLfgElements)