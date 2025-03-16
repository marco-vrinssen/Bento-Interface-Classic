-- UPDATE EXPERIENCE BAR

local xpBarBackdrop = CreateFrame("Frame", nil, MainMenuExpBar, "BackdropTemplate")
xpBarBackdrop:SetPoint("TOPLEFT", MainMenuExpBar, "TOPLEFT", -3, 3)
xpBarBackdrop:SetPoint("BOTTOMRIGHT", MainMenuExpBar, "BOTTOMRIGHT", 3, -3)
xpBarBackdrop:SetBackdrop({edgeFile = BORD, edgeSize = 12})
xpBarBackdrop:SetBackdropBorderColor(unpack(GREY))
xpBarBackdrop:SetFrameLevel(MainMenuExpBar:GetFrameLevel() + 2)

local function hideXPTextures()
    for i = 0, 3 do
        local texture = _G["MainMenuXPBarTexture" .. i]
        if texture then
            texture:Hide()
            texture:SetScript("OnShow", function(self) self:Hide() end)
        end
    end
    
    if ExhaustionLevelFillBar then
        ExhaustionLevelFillBar:Hide()
        ExhaustionLevelFillBar:SetScript("OnShow", function(self) self:Hide() end)
    end
    
    if ExhaustionTick then
        ExhaustionTick:Hide()
        ExhaustionTick:SetScript("OnShow", function(self) self:Hide() end)
        ExhaustionTick.Show = ExhaustionTick.Hide
    end
end

local function updateXPBar()
    if UnitLevel("player") == MAX_PLAYER_LEVEL then
        MainMenuExpBar:Hide()
    else
        MainMenuExpBar:Show()
    end

    hideXPTextures()

    MainMenuExpBar:SetWidth(120)
    MainMenuExpBar:SetHeight(12)
    MainMenuExpBar:ClearAllPoints()
    MainMenuExpBar:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 16, -16)
    MainMenuExpBar:SetStatusBarTexture(BAR)
    MainMenuExpBar:SetStatusBarColor(unpack(VIOLET))
    
    MainMenuExpBar:EnableMouse(true)
end


local xpBarEvents = CreateFrame("Frame")
xpBarEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
xpBarEvents:RegisterEvent("PLAYER_LEVEL_UP")
xpBarEvents:RegisterEvent("PLAYER_XP_UPDATE")
xpBarEvents:RegisterEvent("UPDATE_EXHAUSTION")
xpBarEvents:SetScript("OnEvent", updateXPBar)


-- EXPERIENCE TOOLTIP FUNCTIONALITY

local function xpTooltip()
    local currentExperience, maxExperience = UnitXP("player"), UnitXPMax("player")
    local restedExperience = GetXPExhaustion() or 0
    local progressPercent = math.floor((currentExperience / maxExperience) * 100)
    local restedPercent = math.floor((restedExperience / maxExperience) * 100)
    
    GameTooltip:SetOwner(MainMenuExpBar, "ANCHOR_BOTTOMRIGHT", 4, -4)
    GameTooltip:AddLine("Experience", unpack(VIOLET))
    GameTooltip:AddDoubleLine("Progress:", progressPercent.."%")
    GameTooltip:AddDoubleLine("Rested:", restedPercent.."%")
    GameTooltip:AddDoubleLine("Current:", currentExperience)
    GameTooltip:AddDoubleLine("Missing:", maxExperience - currentExperience)
    GameTooltip:AddDoubleLine("Total:", maxExperience)
    GameTooltip:Show()
end

MainMenuExpBar:HookScript("OnEnter", xpTooltip)
MainMenuExpBar:HookScript("OnLeave", function() GameTooltip:Hide() end)


-- REPUTATION BAR

local repBackdrop = CreateFrame("Frame", nil, ReputationWatchBar.StatusBar, "BackdropTemplate")
repBackdrop:SetPoint("TOPLEFT", ReputationWatchBar.StatusBar, "TOPLEFT", -3, 3)
repBackdrop:SetPoint("BOTTOMRIGHT", ReputationWatchBar.StatusBar, "BOTTOMRIGHT", 3, -3)
repBackdrop:SetBackdrop({edgeFile = BORD, edgeSize = 12})
repBackdrop:SetBackdropBorderColor(unpack(GREY))
repBackdrop:SetFrameLevel(ReputationWatchBar.StatusBar:GetFrameLevel() + 2)

local function hideRepTextures()
    local textureNames = {
        "XPBarTexture0", "XPBarTexture1", "XPBarTexture2", "XPBarTexture3",
        "WatchBarTexture0", "WatchBarTexture1", "WatchBarTexture2", "WatchBarTexture3"
    }
    for _, name in ipairs(textureNames) do
        local texture = ReputationWatchBar.StatusBar[name]
        if texture then
            texture:Hide()
            texture:SetScript("OnShow", function(self) self:Hide() end)
        end
    end
end


local function updateRepBar()
    if not GetWatchedFactionInfo() then
        ReputationWatchBar.StatusBar:Hide()
        return
    end

    hideRepTextures()

    ReputationWatchBar.StatusBar:SetWidth(120)
    ReputationWatchBar.StatusBar:SetHeight(12)
    ReputationWatchBar.StatusBar:ClearAllPoints()
    ReputationWatchBar.StatusBar:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 16, -32)
    ReputationWatchBar.StatusBar:SetStatusBarTexture(BAR)
    ReputationWatchBar.StatusBar:SetStatusBarColor(unpack(BLUE))
    
    ReputationWatchBar.StatusBar:EnableMouse(true)
    ReputationWatchBar.StatusBar:Show()
end

local repBarEvents = CreateFrame("Frame")
repBarEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
repBarEvents:RegisterEvent("UPDATE_FACTION")
repBarEvents:SetScript("OnEvent", updateRepBar)


-- REPUTATION TOOLTIP

local function repTooltip()
    local name, standing, min, max, value = GetWatchedFactionInfo()
    if name then
        local progress = value - min
        local total = max - min
        local progressPercent = math.floor((progress / total) * 100)

        GameTooltip:SetOwner(ReputationWatchBar.StatusBar, "ANCHOR_BOTTOMRIGHT", 4, -4)
        GameTooltip:AddLine("Reputation", unpack(BLUE))
        GameTooltip:AddDoubleLine("Faction:", name)
        GameTooltip:AddDoubleLine("Standing:", _G["FACTION_STANDING_LABEL"..standing])
        GameTooltip:AddDoubleLine("Progress:", progressPercent.."%")
        GameTooltip:AddDoubleLine("Current:", progress)
        GameTooltip:AddDoubleLine("Total:", total)
        GameTooltip:Show()
    end
end

ReputationWatchBar.StatusBar:HookScript("OnEnter", repTooltip)
ReputationWatchBar.StatusBar:HookScript("OnLeave", function() GameTooltip:Hide() end)


-- CREATE EXHAUSTION TIMER BACKDROP

local function exhTimerBackdrop(exhaustionTimer)
    
    if not _G[exhaustionTimer.."CustomBackdrop"] then
        local exhTimerBackdrop = CreateFrame("Frame", exhaustionTimer.."CustomBackdrop", _G[exhaustionTimer.."StatusBar"], "BackdropTemplate")
        exhTimerBackdrop:SetPoint("TOPLEFT", _G[exhaustionTimer.."StatusBar"], "TOPLEFT", -3, 3)
        exhTimerBackdrop:SetPoint("BOTTOMRIGHT", _G[exhaustionTimer.."StatusBar"], "BOTTOMRIGHT", 3, -3)
        exhTimerBackdrop:SetBackdrop({ edgeFile = BORD, edgeSize = 12})
        exhTimerBackdrop:SetBackdropBorderColor(unpack(GREY))
        exhTimerBackdrop:SetFrameLevel(_G[exhaustionTimer.."StatusBar"]:GetFrameLevel() + 2)
    end
end


-- UPDATE EXHAUSTION TIMERS

local function updateExhTimer()
    
    for i = 1, MIRRORTIMER_NUMTIMERS do
        local exhaustionTimer = "MirrorTimer"..i
        
        _G[exhaustionTimer.."Border"]:Hide()
        _G[exhaustionTimer.."StatusBar"]:SetStatusBarTexture(BAR)
        _G[exhaustionTimer.."Text"]:ClearAllPoints()
        _G[exhaustionTimer.."Text"]:SetPoint("CENTER", _G[exhaustionTimer.."StatusBar"], "CENTER", 0, 0)

        exhTimerBackdrop(exhaustionTimer)
    end
end


local exhTimerEvents = CreateFrame("Frame")
exhTimerEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
exhTimerEvents:RegisterEvent("MIRROR_TIMER_START")
exhTimerEvents:SetScript("OnEvent", updateExhTimer)