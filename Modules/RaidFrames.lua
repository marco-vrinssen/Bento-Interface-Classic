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