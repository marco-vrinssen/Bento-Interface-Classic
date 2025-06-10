-- Create raid target icon with custom backdrop

local raidIconBackdrop = CreateFrame("Frame", nil, TargetFrame, "BackdropTemplate")
raidIconBackdrop:SetPoint("BOTTOMLEFT", TargetPortraitBackdrop, "TOPRIGHT", -2, -2)
raidIconBackdrop:SetSize(28, 28)
raidIconBackdrop:SetBackdrop({
    bgFile = BG,
    edgeFile = BORD, edgeSize = 12,
    insets = {left = 3, right = 3, top = 3, bottom = 3}
})
raidIconBackdrop:SetBackdropColor(unpack(BLACK_RGB))
raidIconBackdrop:SetBackdropBorderColor(unpack(GREY_RGB))
raidIconBackdrop:Hide()

-- Update raid icon position and visibility for target

local function updateRaidIconPosition()
    if GetRaidTargetIndex("target") then
        raidIconBackdrop:Show()
        TargetFrameTextureFrameRaidTargetIcon:ClearAllPoints()
        TargetFrameTextureFrameRaidTargetIcon:SetPoint("CENTER", raidIconBackdrop, "CENTER", 0, 0)
        TargetFrameTextureFrameRaidTargetIcon:SetSize(16, 16)
    else
        raidIconBackdrop:Hide()
    end
end

local raidIconEvents = CreateFrame("Frame")
raidIconEvents:RegisterEvent("PLAYER_TARGET_CHANGED")
raidIconEvents:RegisterEvent("RAID_TARGET_UPDATE")
raidIconEvents:SetScript("OnEvent", updateRaidIconPosition)
