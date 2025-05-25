-- HIDE AURAS ON RAID FRAMES

local function hideAllAuras(frame)
    CompactUnitFrame_HideAllBuffs(frame)
    CompactUnitFrame_HideAllDebuffs(frame)
end

hooksecurefunc("CompactUnitFrame_UpdateAuras", hideAllAuras)

-- UPDATE GROUP FRAME CONFIG

local function updateGroupConfig()
    SetCVar("useCompactPartyFrames", 1)
    SetCVar("raidFramesDisplayClassColor", 1)
    SetCVar("raidFramesDisplayBorder", 0)
end

local groupConfigEvents = CreateFrame("Frame")
groupConfigEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
groupConfigEvents:RegisterEvent("GROUP_ROSTER_UPDATE")
groupConfigEvents:SetScript("OnEvent", updateGroupConfig)

-- SET RAID FRAME HEALTH AND POWER BAR TEXTURES TO CUSTOM BAR

local function setCompactRaidFrameBarTextures(compactRaidFrame)
    if compactRaidFrame and compactRaidFrame.healthBar and compactRaidFrame.healthBar.SetStatusBarTexture then
        compactRaidFrame.healthBar:SetStatusBarTexture(BAR)
    end
    if compactRaidFrame and compactRaidFrame.powerBar and compactRaidFrame.powerBar.SetStatusBarTexture then
        compactRaidFrame.powerBar:SetStatusBarTexture(BAR)
    end
end

hooksecurefunc("CompactUnitFrame_UpdateHealth", setCompactRaidFrameBarTextures)
hooksecurefunc("CompactUnitFrame_UpdatePower", setCompactRaidFrameBarTextures)