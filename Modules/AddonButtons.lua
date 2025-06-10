-- Position minimapButtons in arc formation to create organized layout

local function positionMinimapButtons()
  local libraryDbIcon = _G.LibStub and _G.LibStub("LibDBIcon-1.0", true)
  if not libraryDbIcon then 
    return 
  end

  local addonButtonList = {}
  for addonName, iconButton in pairs(libraryDbIcon.objects) do
    table.insert(addonButtonList, {name = addonName, button = iconButton})
  end
  table.sort(addonButtonList, function(a, b) 
    return a.name < b.name 
  end)

  local angleStep = 120 / #addonButtonList
  local arcRadius = 100
  
  for buttonIndex, buttonData in ipairs(addonButtonList) do
    local minimapButton = buttonData.button
    if minimapButton:IsShown() then
      for regionIndex = 1, minimapButton:GetNumRegions() do
        local textureRegion = select(regionIndex, minimapButton:GetRegions())
        if textureRegion:IsObjectType("Texture") and textureRegion ~= minimapButton.icon then
          textureRegion:Hide()
        end
      end

      local buttonAngle = math.rad(120 + angleStep * (buttonIndex - 1))
      local xPosition = math.cos(buttonAngle) * arcRadius
      local yPosition = math.sin(buttonAngle) * arcRadius
      
      minimapButton:SetParent(Minimap)
      minimapButton:SetSize(16, 16)
      minimapButton:SetFrameLevel(Minimap:GetFrameLevel() + 2)
      minimapButton:ClearAllPoints()
      minimapButton:SetPoint("CENTER", Minimap, "CENTER", xPosition, yPosition)
      minimapButton.icon:ClearAllPoints()
      minimapButton.icon:SetPoint("CENTER", minimapButton, "CENTER", 0, 0)
      minimapButton.icon:SetSize(12, 12)

      if not minimapButton.background then
        minimapButton.background = CreateFrame("Frame", nil, minimapButton, BackdropTemplateMixin and "BackdropTemplate")
        minimapButton.background:SetPoint("TOPLEFT", minimapButton, "TOPLEFT", -2, 2)
        minimapButton.background:SetPoint("BOTTOMRIGHT", minimapButton, "BOTTOMRIGHT", 2, -2)
        minimapButton.background:SetBackdrop({
          bgFile = BG,
          edgeFile = BORD,
          edgeSize = 8,
          insets = {left = 2, right = 2, top = 2, bottom = 2}
        })
        minimapButton.background:SetBackdropColor(unpack(BLACK_RGB))
        minimapButton.background:SetBackdropBorderColor(unpack(GREY_RGB))
        minimapButton.background:SetFrameLevel(minimapButton:GetFrameLevel() - 1)
      end
    end
  end
end

-- Handle addonEvents to initialize button positioning

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", function(self, event)
  if event == "ADDON_LOADED" or event == "PLAYER_ENTERING_WORLD" then
    C_Timer.After(0.5, positionMinimapButtons)
  end
end)