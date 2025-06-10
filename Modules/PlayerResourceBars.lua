-- Apply custom textures to player resource bars

local function updatePlayerResources()
    PlayerFrameHealthBar:SetStatusBarTexture(BAR)
    PlayerFrameManaBar:SetStatusBarTexture(BAR)
end

-- Maintain custom bar textures through frame updates

local function enforcePlayerBarTextures()
    if PlayerFrameHealthBar then
        PlayerFrameHealthBar:SetStatusBarTexture(BAR)
    end
    if PlayerFrameManaBar then
        PlayerFrameManaBar:SetStatusBarTexture(BAR)
    end
end

hooksecurefunc("PlayerFrame_Update", enforcePlayerBarTextures)
hooksecurefunc("UnitFrameHealthBar_Update", function(statusbar, unit)
    if unit == "player" and statusbar then
        statusbar:SetStatusBarTexture(BAR)
    end
end)
hooksecurefunc("UnitFrameManaBar_Update", function(statusbar, unit)
    if unit == "player" and statusbar then
        statusbar:SetStatusBarTexture(BAR)
    end
end)

local playerResourceEvents = CreateFrame("Frame")
playerResourceEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
playerResourceEvents:RegisterEvent("UNIT_HEALTH")
playerResourceEvents:RegisterEvent("UNIT_HEALTH_FREQUENT")
playerResourceEvents:RegisterEvent("UNIT_MAXHEALTH")
playerResourceEvents:RegisterEvent("UNIT_POWER_UPDATE")
playerResourceEvents:RegisterEvent("UNIT_POWER_FREQUENT")
playerResourceEvents:RegisterEvent("UNIT_MAXPOWER")
playerResourceEvents:RegisterEvent("PLAYER_REGEN_ENABLED")
playerResourceEvents:RegisterEvent("PLAYER_REGEN_DISABLED")
playerResourceEvents:RegisterEvent("UNIT_AURA")
playerResourceEvents:SetScript("OnEvent", function(_, event, unit)
    if unit == "player" or event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_REGEN_ENABLED" or event == "PLAYER_REGEN_DISABLED" or not unit then
        updatePlayerResources()
        enforcePlayerBarTextures()
    end
end)
