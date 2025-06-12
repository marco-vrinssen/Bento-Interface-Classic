-- Initialize database if not present for BentoInterfaceClassicDB

if not BentoInterfaceClassicDB then
    BentoInterfaceClassicDB = {}
end

-- Track aura display state for raid frames

local hideRaidAuras = true

-- Hide auras function to remove all buffs and debuffs

local function hideAllAuras(frame)
    if hideRaidAuras then
        CompactUnitFrame_HideAllBuffs(frame)
        CompactUnitFrame_HideAllDebuffs(frame)
    end
end

-- Toggle raid frame auras function to switch display state

local function toggleRaidAuras()
    hideRaidAuras = not hideRaidAuras
    BentoInterfaceClassicDB.hideRaidAuras = hideRaidAuras
    
    local statusText = hideRaidAuras and "Hidden" or "Shown"
    print(YELLOW_LIGHT_LUA .. "[Raid Frame Auras]:|r " .. WHITE_LUA .. statusText .. "|r")
end

-- Load saved aura state from database on addon initialization

local function loadAuraState()
    if BentoInterfaceClassicDB.hideRaidAuras ~= nil then
        hideRaidAuras = BentoInterfaceClassicDB.hideRaidAuras
    else
        BentoInterfaceClassicDB.hideRaidAuras = hideRaidAuras
    end
end

-- Initialize aura state when player enters world

local initFrame = CreateFrame("Frame")
initFrame:RegisterEvent("ADDON_LOADED")
initFrame:SetScript("OnEvent", function(self, event, addonName)
    if addonName == "BentoInterface-Classic" then
        loadAuraState()
        initFrame:UnregisterEvent("ADDON_LOADED")
    end
end)

SLASH_RAIDFRAMEAURAS1 = "/raidframeauras"
SlashCmdList["RAIDFRAMEAURAS"] = toggleRaidAuras

hooksecurefunc("CompactUnitFrame_UpdateAuras", hideAllAuras)

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