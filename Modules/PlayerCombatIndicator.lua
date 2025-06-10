-- Create player combat indicator with backdrop

local playerCombatBackdrop = CreateFrame("Frame", nil, PlayerFrame, "BackdropTemplate")
playerCombatBackdrop:SetPoint("BOTTOMRIGHT", PlayerPortraitBackdrop, "TOPLEFT", 2, 2)
playerCombatBackdrop:SetSize(28, 28)
playerCombatBackdrop:SetBackdrop({
    bgFile = BG,
    edgeFile = BORD, edgeSize = 12,
    insets = {left = 3, right = 3, top = 3, bottom = 3}
})
playerCombatBackdrop:SetBackdropColor(unpack(BLACK_RGB))
playerCombatBackdrop:SetBackdropBorderColor(unpack(GREY_RGB))
playerCombatBackdrop:Hide()

local playerCombatIcon = playerCombatBackdrop:CreateTexture(nil, "OVERLAY")
playerCombatIcon:SetPoint("CENTER", playerCombatBackdrop, "CENTER", 0, 0)
playerCombatIcon:SetSize(16 * 1.2, 16 * 1.2)
playerCombatIcon:SetTexture("Interface\\CharacterFrame\\UI-StateIcon")
playerCombatIcon:SetTexCoord(0.5, 1.0, 0.0, 0.5)

-- Update combat indicator visibility based on combat status

local function updatePlayerCombatStatus()
    if UnitAffectingCombat("player") then
        playerCombatBackdrop:Show()
    else
        playerCombatBackdrop:Hide()
    end
end

local playerCombatEvents = CreateFrame("Frame")
playerCombatEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
playerCombatEvents:RegisterEvent("PLAYER_REGEN_ENABLED")
playerCombatEvents:RegisterEvent("PLAYER_REGEN_DISABLED")
playerCombatEvents:SetScript("OnEvent", updatePlayerCombatStatus)
