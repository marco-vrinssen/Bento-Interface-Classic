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