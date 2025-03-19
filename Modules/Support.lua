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

    for _, data in ipairs(buttons) do
        local addonButton = data.button
        if addonButton:IsShown() then
            for i = 1, addonButton:GetNumRegions() do
                local buttonRegion = select(i, addonButton:GetRegions())
                if buttonRegion:IsObjectType("Texture") and buttonRegion ~= addonButton.icon then
                    buttonRegion:Hide()
                end
            end

            addonButton:SetSize(16, 16)
            addonButton:SetParent(UIParent)
            addonButton:SetFrameLevel(Minimap:GetFrameLevel() + 2)
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
        C_Timer.After(0, addonButtonUpdate)
    end
end)


-- UPDATE AUCTIONATOR SCAN BUTTON POSITION

local function updateAuctionator()

    if not IsAddOnLoaded("Auctionator") then
        return
    end

    local scanButton = AuctionatorConfigFrame.ScanButton
    scanButton:SetParent(AuctionFrame)
    scanButton:ClearAllPoints()
    scanButton:SetPoint("RIGHT", AuctionFrameCloseButton, "LEFT", -20, 0)
end


-- CREATE FRAME FOR AUCTIONATOR UPDATE

local auctionatorFrame = CreateFrame("Frame")
auctionatorFrame:RegisterEvent("AUCTION_HOUSE_SHOW")
auctionatorFrame:SetScript("OnEvent", updateAuctionator)


-- UPDATE QUESTIE TRACKING ICONS

local function updateQuestieIcons()

    if not IsAddOnLoaded("Questie") then
        return
    end

    Questie.db.profile.nameplateX = -28
    Questie.db.profile.nameplateY = 10
    Questie.db.profile.nameplateScale = 1.5

    Questie.db.profile.nameplateTargetFrameX = -172
    Questie.db.profile.nameplateTargetFrameY = 4
    Questie.db.profile.nameplateTargetFrameScale = 1.5
end


-- CREATE FRAME FOR QUESTIE UPDATE

local questieSupportFrame = CreateFrame("Frame")
questieSupportFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
questieSupportFrame:SetScript("OnEvent", updateQuestieIcons)