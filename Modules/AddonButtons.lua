-- UPDATE ADDON BUTTONS ON MINIMAP
local function updateAddonButtonsOnMinimap()
    local libDbIcon = _G.LibStub and _G.LibStub("LibDBIcon-1.0", true)
    if not libDbIcon then return end

    -- COLLECT ADDON BUTTONS
    local sortedButtons = {}
    for addonName, iconButton in pairs(libDbIcon.objects) do
        table.insert(sortedButtons, {name = addonName, button = iconButton})
    end
    table.sort(sortedButtons, function(a, b) return a.name < b.name end)

    -- POSITION BUTTONS IN ARC
    local angleStepDegrees = 120 / #sortedButtons
    local minimapRadius = 100
    for buttonIndex, buttonData in ipairs(sortedButtons) do
        local iconButton = buttonData.button
        if iconButton:IsShown() then
            for regionIndex = 1, iconButton:GetNumRegions() do
                local textureRegion = select(regionIndex, iconButton:GetRegions())
                if textureRegion:IsObjectType("Texture") and textureRegion ~= iconButton.icon then
                    textureRegion:Hide()
                end
            end

            -- CALCULATE BUTTON POSITION
            local angleRadians = math.rad(120 + angleStepDegrees * (buttonIndex - 1))
            local xPositionOffset = math.cos(angleRadians) * minimapRadius
            local yPositionOffset = math.sin(angleRadians) * minimapRadius
            iconButton:SetParent(Minimap)
            iconButton:SetSize(16, 16)
            iconButton:SetFrameLevel(Minimap:GetFrameLevel() + 2)
            iconButton:ClearAllPoints()
            iconButton:SetPoint("CENTER", Minimap, "CENTER", xPositionOffset, yPositionOffset)
            iconButton.icon:ClearAllPoints()
            iconButton.icon:SetPoint("CENTER", iconButton, "CENTER", 0, 0)
            iconButton.icon:SetSize(12, 12)

            -- CREATE BUTTON BACKGROUND
            if not iconButton.background then
                iconButton.background = CreateFrame("Frame", nil, iconButton, BackdropTemplateMixin and "BackdropTemplate")
                iconButton.background:SetPoint("TOPLEFT", iconButton, "TOPLEFT", -3, 3)
                iconButton.background:SetPoint("BOTTOMRIGHT", iconButton, "BOTTOMRIGHT", 3, -3)
                iconButton.background:SetBackdrop({
                    bgFile = BG,
                    edgeFile = BORD,
                    edgeSize = 12,
                    insets = {left = 2, right = 2, top = 2, bottom = 2}
                })
                iconButton.background:SetBackdropColor(unpack(BLACK_RGB))
                iconButton.background:SetBackdropBorderColor(unpack(GREY_RGB))
                iconButton.background:SetFrameLevel(iconButton:GetFrameLevel() - 1)
            end
        end
    end
end

-- REGISTER EVENTS FOR BUTTON UPDATES
local eventHandler = CreateFrame("Frame")
eventHandler:RegisterEvent("PLAYER_ENTERING_WORLD")
eventHandler:RegisterEvent("ADDON_LOADED")
eventHandler:SetScript("OnEvent", function(self, event)
    if event == "ADDON_LOADED" or event == "PLAYER_ENTERING_WORLD" then
        C_Timer.After(0.5, updateAddonButtonsOnMinimap)
    end
end)