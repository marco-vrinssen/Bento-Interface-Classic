-- Update target resource bars for custom textures

local function updateTargetResourceBars()
    TargetFrameHealthBar:SetStatusBarTexture(BAR)
    TargetFrameManaBar:SetStatusBarTexture(BAR)
end

-- Enforce custom bar textures on target frame

local function enforceTargetBarTextures()
    if TargetFrameHealthBar then
        TargetFrameHealthBar:SetStatusBarTexture(BAR)
    end
    if TargetFrameManaBar then
        TargetFrameManaBar:SetStatusBarTexture(BAR)
    end
end

hooksecurefunc("TargetFrame_Update", enforceTargetBarTextures)
hooksecurefunc("UnitFrameHealthBar_Update", function(statusbar, unit)
    if unit == "target" and statusbar then
        statusbar:SetStatusBarTexture(BAR)
    end
end)
hooksecurefunc("UnitFrameManaBar_Update", function(statusbar, unit)
    if unit == "target" and statusbar then
        statusbar:SetStatusBarTexture(BAR)
    end
end)

local targetResourceEvents = CreateFrame("Frame")
targetResourceEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
targetResourceEvents:RegisterEvent("PLAYER_TARGET_CHANGED")
targetResourceEvents:RegisterEvent("UNIT_HEALTH")
targetResourceEvents:RegisterEvent("UNIT_HEALTH_FREQUENT")
targetResourceEvents:RegisterEvent("UNIT_MAXHEALTH")
targetResourceEvents:RegisterEvent("UNIT_POWER_UPDATE")
targetResourceEvents:RegisterEvent("UNIT_POWER_FREQUENT")
targetResourceEvents:RegisterEvent("UNIT_MAXPOWER")
targetResourceEvents:RegisterEvent("PLAYER_REGEN_ENABLED")
targetResourceEvents:RegisterEvent("PLAYER_REGEN_DISABLED")
targetResourceEvents:RegisterEvent("UNIT_AURA")
targetResourceEvents:SetScript("OnEvent", function(_, event, unit)
    if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_TARGET_CHANGED" or event == "PLAYER_REGEN_ENABLED" or event == "PLAYER_REGEN_DISABLED" or unit == "target" or not unit then
        updateTargetResourceBars()
        enforceTargetBarTextures()
    end
end)
