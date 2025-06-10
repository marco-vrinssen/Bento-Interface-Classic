-- Create threat indicator for aggro status

local targetThreatIcon = TargetPortraitBackdrop:CreateTexture(nil, "OVERLAY")
targetThreatIcon:SetPoint("TOPLEFT", TargetPortraitBackdrop, "TOPLEFT", 4, -4)
targetThreatIcon:SetPoint("BOTTOMRIGHT", TargetPortraitBackdrop, "BOTTOMRIGHT", -4, 4)
targetThreatIcon:SetTexCoord(0.15, 0.85, 0.15, 0.85)

-- Update aggro status to tint portrait red if tanking

local function updateAggroStatus()
    local isTanking, threatStatus = UnitDetailedThreatSituation("player", "target")
    if threatStatus and isTanking and TargetFramePortrait then
        TargetFramePortrait:SetVertexColor(unpack(RED_RGB))
    elseif TargetFramePortrait then
        TargetFramePortrait:SetVertexColor(1, 1, 1)
    end
    targetThreatIcon:Hide()
end

local targetThreatEvents = CreateFrame("Frame")
targetThreatEvents:RegisterEvent("PLAYER_TARGET_CHANGED")
targetThreatEvents:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE")
targetThreatEvents:SetScript("OnEvent", updateAggroStatus)

hooksecurefunc("TargetFrame_Update", updateAggroStatus)
