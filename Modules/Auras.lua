-- UPDATE AURA DURATION

local function UpdateAuraTimer(aura)
    local auraDuration = _G[aura:GetName().."Duration"]
    if auraDuration then
        auraDuration:SetFont(FONT, 10, "OUTLINE")
        auraDuration:SetTextColor(1, 1, 1)
        auraDuration:ClearAllPoints()
        auraDuration:SetPoint("BOTTOM", aura, "BOTTOM", 2, -14)
        auraDuration:SetTextColor(unpack(WHITE_RGB))
    end
end

hooksecurefunc("AuraButton_UpdateDuration", function(aura)
    if aura then
        UpdateAuraTimer(aura)
    end
end)

-- UPDATE AURA DESIGN

local function StyleAuraButton(button, borderColor)
    if not button.customBorder then
        local backdrop = CreateFrame("Frame", nil, button, "BackdropTemplate")
        backdrop:SetPoint("TOPLEFT", button, "TOPLEFT", -3, 3)
        backdrop:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 3, -3)
        backdrop:SetBackdrop({ edgeFile = BORD, edgeSize = 12 })
        backdrop:SetBackdropBorderColor(unpack(borderColor or GREY_RGB))
        backdrop:SetFrameLevel(button:GetFrameLevel() + 2)
        button.customBorder = backdrop
    else
        button.customBorder:SetBackdropBorderColor(unpack(borderColor or GREY_RGB))
    end

    local icon = _G[button:GetName().."Icon"]
    if icon then
        icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
    end

    local border = _G[button:GetName().."Border"]
    if border then
        border:Hide()
    end
end

local function StyleBuffButton(button)
    StyleAuraButton(button, GREY_RGB)
end

local function StyleDebuffButton(button)
    StyleAuraButton(button, RED_RGB)
end

local function StyleTempEnchant(button)
    StyleAuraButton(button, VIOLET_RGB)

    local border = _G[button:GetName().."Border"]
    if border then
        border:Hide()
    end
end

hooksecurefunc("AuraButton_Update", function(buttonName, index, filter)
    local button = _G[buttonName..index]
    if button then
        if filter == "HARMFUL" then
            StyleDebuffButton(button)
        else
            StyleBuffButton(button)
        end
    end
end)

-- REPOSITION AURAS

local function UpdateAuraPosition()
    BuffFrame:ClearAllPoints()

    local firstAnchor = Minimap
    local xOffset = -40
    local yOffset = 0
    local padding = 8

    local firstAuraSet = false

    for i = 1, 5 do
        local tempEnchant = _G["TempEnchant"..i]
        if tempEnchant and tempEnchant:IsShown() then
            if not firstAuraSet then
                tempEnchant:ClearAllPoints()
                tempEnchant:SetPoint("TOPRIGHT", firstAnchor, "TOPLEFT", xOffset, yOffset)
                firstAnchor = tempEnchant
                firstAuraSet = true
            else
                tempEnchant:ClearAllPoints()
                tempEnchant:SetPoint("TOPRIGHT", firstAnchor, "TOPLEFT", -padding, 0)
                firstAnchor = tempEnchant
            end
        end
    end

    for i = 1, BUFF_MAX_DISPLAY do
        local buff = _G["BuffButton"..i]
        if buff and buff:IsShown() then
            if not firstAuraSet then
                buff:ClearAllPoints()
                buff:SetPoint("TOPRIGHT", firstAnchor, "TOPLEFT", xOffset, yOffset)
                firstAnchor = buff
                firstAuraSet = true
            else
                buff:ClearAllPoints()
                buff:SetPoint("TOPRIGHT", firstAnchor, "TOPLEFT", -padding, 0)
                firstAnchor = buff
            end
        end
    end

    local debuffAnchor = Minimap
    local firstBuffFound = false

    for i = 1, 5 do
        local tempEnchant = _G["TempEnchant"..i]
        if tempEnchant and tempEnchant:IsShown() and not firstBuffFound then
            debuffAnchor = tempEnchant
            firstBuffFound = true
            break
        end
    end

    if not firstBuffFound then
        for i = 1, BUFF_MAX_DISPLAY do
            local buff = _G["BuffButton"..i]
            if buff and buff:IsShown() then
                debuffAnchor = buff
                firstBuffFound = true
                break
            end
        end
    end

    local firstDebuffSet = false
    local debuffAnchorPoint = firstBuffFound and debuffAnchor or Minimap
    local debuffXOffset = firstBuffFound and 0 or xOffset

    for i = 1, DEBUFF_MAX_DISPLAY do
        local debuff = _G["DebuffButton"..i]
        if debuff and debuff:IsShown() then
            if not firstDebuffSet then
                debuff:ClearAllPoints()
                debuff:SetPoint("TOPRIGHT", debuffAnchorPoint, firstBuffFound and "BOTTOMRIGHT" or "TOPLEFT", debuffXOffset, -24)
                debuffAnchor = debuff
                firstDebuffSet = true
            else
                debuff:ClearAllPoints()
                debuff:SetPoint("TOPRIGHT", debuffAnchor, "TOPLEFT", -padding, 0)
                debuffAnchor = debuff
            end
        end
    end
end

-- INITIALIZE AURA UPDATE

local function UpdatePlayerAuras()
    for i = 1, BUFF_MAX_DISPLAY do
        local buff = _G["BuffButton"..i]
        if buff then
            UpdateAuraTimer(buff)
            StyleBuffButton(buff)
        end
    end

    for i = 1, DEBUFF_MAX_DISPLAY do
        local debuff = _G["DebuffButton"..i]
        if debuff then
            UpdateAuraTimer(debuff)
            StyleDebuffButton(debuff)
        end
    end

    for i = 1, 5 do
        local tempEnchant = _G["TempEnchant"..i]
        if tempEnchant then
            UpdateAuraTimer(tempEnchant)
            StyleTempEnchant(tempEnchant)
        end
    end

    UpdateAuraPosition()
end

-- REGISTER EVENTS

local auraEvents = CreateFrame("Frame")
auraEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
auraEvents:RegisterEvent("UNIT_AURA")
auraEvents:SetScript("OnEvent", function(self, event, unit)
    if event == "UNIT_AURA" and unit ~= "player" then
        return
    end
    UpdatePlayerAuras()
end)

hooksecurefunc("BuffFrame_UpdateAllBuffAnchors", UpdateAuraPosition)