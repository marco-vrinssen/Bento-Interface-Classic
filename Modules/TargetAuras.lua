-- Update target auras for custom layout and border

local function updateTargetAurasLayout()
    local maxAurasPerRow = 5
    local maxRows = 10
    local auraSize = 20
    local xOffset, yOffset = 4, 4
    local horizontalStartOffset = 4
    local verticalStartOffset = 4

    local function setupAuraFrame(aura, row, col, isDebuff)
        aura:ClearAllPoints()
        aura:SetPoint("BOTTOMLEFT", TargetFrameBackdrop, "TOPLEFT", 
            horizontalStartOffset + col * (auraSize + xOffset), 
            verticalStartOffset + row * (auraSize + yOffset))
        aura:SetSize(auraSize, auraSize)
        local border = _G[aura:GetName().."Border"]
        if border then border:Hide() end
        if not aura.backdrop then
            aura.backdrop = CreateFrame("Frame", nil, aura, "BackdropTemplate")
            aura.backdrop:SetPoint("TOPLEFT", aura, "TOPLEFT", -2, 2)
            aura.backdrop:SetPoint("BOTTOMRIGHT", aura, "BOTTOMRIGHT", 2, -2)
            aura.backdrop:SetBackdrop({ edgeFile = BORD, edgeSize = 8 })
            aura.backdrop:SetFrameLevel(aura:GetFrameLevel() + 2)
        end
        if isDebuff then
            aura.backdrop:SetBackdropBorderColor(unpack(RED_RGB))
        else
            aura.backdrop:SetBackdropBorderColor(unpack(GREY_RGB))
        end
        local icon = _G[aura:GetName().."Icon"]
        if icon then icon:SetTexCoord(0.1, 0.9, 0.1, 0.9) end
    end

    local buffCount = 0
    local currentBuff = _G["TargetFrameBuff1"]
    while currentBuff and currentBuff:IsShown() and buffCount < maxAurasPerRow * maxRows do
        buffCount = buffCount + 1
        currentBuff = _G["TargetFrameBuff"..(buffCount + 1)]
    end
    for i = 1, buffCount do
        local currentBuff = _G["TargetFrameBuff"..i]
        local row = math.floor((i - 1) / maxAurasPerRow)
        local col = (i - 1) % maxAurasPerRow
        setupAuraFrame(currentBuff, row, col, false)
    end
    local debuffCount = 0
    local currentDebuff = _G["TargetFrameDebuff1"]
    while currentDebuff and currentDebuff:IsShown() and (buffCount + debuffCount) < maxAurasPerRow * maxRows do
        debuffCount = debuffCount + 1
        local totalIndex = buffCount + debuffCount
        local row = math.floor((totalIndex - 1) / maxAurasPerRow)
        local col = (totalIndex - 1) % maxAurasPerRow
        setupAuraFrame(currentDebuff, row, col, true)
        currentDebuff = _G["TargetFrameDebuff"..(debuffCount + 1)]
    end
end

hooksecurefunc("TargetFrame_Update", updateTargetAurasLayout)
hooksecurefunc("TargetFrame_UpdateAuras", updateTargetAurasLayout)

local targetAuraEvents = CreateFrame("Frame")
targetAuraEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
targetAuraEvents:RegisterEvent("PLAYER_TARGET_CHANGED")
targetAuraEvents:RegisterEvent("UNIT_AURA")
targetAuraEvents:SetScript("OnEvent", function(self, event, unit)
    if unit == "target" or not unit then
        updateTargetAurasLayout()
    end
end)
