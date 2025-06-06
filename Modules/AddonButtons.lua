-- Position minimap buttons in arc formation to create organized layout
local function positionMinimapButtons()
  local libDbIcon = _G.LibStub and _G.LibStub("LibDBIcon-1.0", true)
  if not libDbIcon then 
    return 
  end

  local buttonList = {}
  for addonName, iconButton in pairs(libDbIcon.objects) do
    table.insert(buttonList, {name = addonName, button = iconButton})
  end
  table.sort(buttonList, function(a, b) 
    return a.name < b.name 
  end)

  local angleStep = 120 / #buttonList
  local radius = 100
  
  for index, data in ipairs(buttonList) do
    local button = data.button
    if button:IsShown() then
      for regionIndex = 1, button:GetNumRegions() do
        local region = select(regionIndex, button:GetRegions())
        if region:IsObjectType("Texture") and region ~= button.icon then
          region:Hide()
        end
      end

      local angle = math.rad(120 + angleStep * (index - 1))
      local xPos = math.cos(angle) * radius
      local yPos = math.sin(angle) * radius
      
      button:SetParent(Minimap)
      button:SetSize(16, 16)
      button:SetFrameLevel(Minimap:GetFrameLevel() + 2)
      button:ClearAllPoints()
      button:SetPoint("CENTER", Minimap, "CENTER", xPos, yPos)
      button.icon:ClearAllPoints()
      button.icon:SetPoint("CENTER", button, "CENTER", 0, 0)
      button.icon:SetSize(12, 12)

      if not button.background then
        button.background = CreateFrame("Frame", nil, button, BackdropTemplateMixin and "BackdropTemplate")
        button.background:SetPoint("TOPLEFT", button, "TOPLEFT", -2, 2)
        button.background:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 2, -2)
        button.background:SetBackdrop({
          bgFile = BG,
          edgeFile = BORD,
          edgeSize = 8,
          insets = {left = 2, right = 2, top = 2, bottom = 2}
        })
        button.background:SetBackdropColor(unpack(BLACK_RGB))
        button.background:SetBackdropBorderColor(unpack(GREY_RGB))
        button.background:SetFrameLevel(button:GetFrameLevel() - 1)
      end
    end
  end
end

-- Handle addon loading events to initialize button positioning
local addonEventFrame = CreateFrame("Frame")
addonEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
addonEventFrame:RegisterEvent("ADDON_LOADED")
addonEventFrame:SetScript("OnEvent", function(self, event)
  if event == "ADDON_LOADED" or event == "PLAYER_ENTERING_WORLD" then
    C_Timer.After(0.5, positionMinimapButtons)
  end
end)