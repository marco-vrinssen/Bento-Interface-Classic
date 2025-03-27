-- UPDATE ADDON BUTTONS ON MINIMAP

local function addonButtonUpdate()

    local libDbIcon = _G.LibStub and _G.LibStub("LibDBIcon-1.0", true)
    if not libDbIcon then return end


    -- COLLECT BUTTONS

    local buttons = {}
    for name, addonButton in pairs(libDbIcon.objects) do
        table.insert(buttons, {name = name, button = addonButton})
    end
    table.sort(buttons, function(a, b) return a.name < b.name end)


    -- UPDATE BUTTONS

    local angleStep = 90 / #buttons
    local radius = 100

    for index, data in ipairs(buttons) do
        local addonButton = data.button
        if addonButton:IsShown() then
            for i = 1, addonButton:GetNumRegions() do
                local buttonRegion = select(i, addonButton:GetRegions())
                if buttonRegion:IsObjectType("Texture") and buttonRegion ~= addonButton.icon then
                    buttonRegion:Hide()
                end
            end

            -- CALCULATE ANGLE FOR LOWER LEFT CORNER DISTRIBUTION

            local angle = math.rad(120 + angleStep * (index - 1))
            local xOffset = math.cos(angle) * radius
            local yOffset = math.sin(angle) * radius

            addonButton:SetParent(Minimap)
            addonButton:SetSize(16, 16)
            addonButton:SetFrameLevel(Minimap:GetFrameLevel() + 2)
            addonButton:ClearAllPoints()
            addonButton:SetPoint("CENTER", Minimap, "CENTER", xOffset, yOffset)
            addonButton.icon:ClearAllPoints()
            addonButton.icon:SetPoint("CENTER", addonButton, "CENTER", 0, 0)
            addonButton.icon:SetSize(12, 12)


            -- CREATE BACKGROUND IF NOT EXISTS

            if not addonButton.background then
                addonButton.background = CreateFrame("Frame", nil, addonButton, BackdropTemplateMixin and "BackdropTemplate")
                addonButton.background:SetPoint("TOPLEFT", addonButton, "TOPLEFT", -3, 3)
                addonButton.background:SetPoint("BOTTOMRIGHT", addonButton, "BOTTOMRIGHT", 3, -3)
                addonButton.background:SetBackdrop({
                    bgFile = BG,
                    edgeFile = BORD,
                    edgeSize = 12,
                    insets = {left = 2, right = 2, top = 2, bottom = 2}
                })
                addonButton.background:SetBackdropColor(unpack(BLACK))
                addonButton.background:SetBackdropBorderColor(unpack(GREY))
                addonButton.background:SetFrameLevel(addonButton:GetFrameLevel() - 1)
            end
        end
    end
end


-- CREATE FRAME FOR ADDON BUTTON UPDATE

local addonButtonFrame = CreateFrame("Frame")
addonButtonFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
addonButtonFrame:RegisterEvent("ADDON_LOADED")
addonButtonFrame:SetScript("OnEvent", function(self, event)
    if event == "ADDON_LOADED" or event == "PLAYER_ENTERING_WORLD" then
        C_Timer.After(0.5, addonButtonUpdate)
    end
end)