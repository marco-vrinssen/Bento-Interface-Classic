-- Collect visible micro buttons for positioning

local function collectVisibleButtons()
  local visibleButtons = {}
  
  for name in pairs(_G) do
    if type(name) == "string" and string.match(name, "^%a+MicroButton$") then
      local microButton = _G[name]
      if type(microButton) == "table" and microButton.IsVisible and microButton:IsVisible() then
        table.insert(visibleButtons, microButton)
      end
    end
  end

  local buttonWidth = CharacterMicroButton:GetWidth()
  local totalWidth = buttonWidth * (#visibleButtons - 1)

  CharacterMicroButton:ClearAllPoints()
  CharacterMicroButton:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -totalWidth, 16)
end

-- Schedule micro button update

local function scheduleMicroUpdate()
  C_Timer.After(0, collectVisibleButtons)
end

-- Register micro event frame

local microEventFrame = CreateFrame("Frame")
microEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
microEventFrame:RegisterEvent("PLAYER_LOGIN")
microEventFrame:RegisterEvent("UI_SCALE_CHANGED")
microEventFrame:RegisterEvent("DISPLAY_SIZE_CHANGED")
microEventFrame:SetScript("OnEvent", scheduleMicroUpdate)

-- Hide LFG border element and reposition frame

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

-- Register LFG event frame

local lfgEventFrame = CreateFrame("Frame")
lfgEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
lfgEventFrame:SetScript("OnEvent", repositionLfgElements)