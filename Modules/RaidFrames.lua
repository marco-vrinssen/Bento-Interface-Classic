-- Hide auras function to remove all buffs and debuffs
local function hideAllAuras(frame)
    CompactUnitFrame_HideAllBuffs(frame)
    CompactUnitFrame_HideAllDebuffs(frame)
end

hooksecurefunc("CompactUnitFrame_UpdateAuras", hideAllAuras)

-- Update group config function to set raid frame display settings

local function updateGroupConfig()
    SetCVar("useCompactPartyFrames", 1)
    SetCVar("raidFramesDisplayClassColor", 1)
    SetCVar("raidFramesDisplayBorder", 0)
end

local groupConfigEvents = CreateFrame("Frame")
groupConfigEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
groupConfigEvents:RegisterEvent("GROUP_ROSTER_UPDATE")
groupConfigEvents:SetScript("OnEvent", updateGroupConfig)

-- Set raid frame bar textures function to apply custom texture

local function setRaidBarTextures(raidFrame)
    if raidFrame and raidFrame.healthBar and raidFrame.healthBar.SetStatusBarTexture then
        raidFrame.healthBar:SetStatusBarTexture(BAR)
    end
    if raidFrame and raidFrame.powerBar and raidFrame.powerBar.SetStatusBarTexture then
        raidFrame.powerBar:SetStatusBarTexture(BAR)
    end
end

hooksecurefunc("CompactUnitFrame_UpdateHealth", setRaidBarTextures)
hooksecurefunc("CompactUnitFrame_UpdatePower", setRaidBarTextures)