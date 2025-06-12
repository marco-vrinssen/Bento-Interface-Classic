-- Add xpBarBackdrop to visually enhance MainMenuExpBar

local xpBarBackdrop = CreateFrame("Frame", nil, MainMenuExpBar, "BackdropTemplate")
xpBarBackdrop:SetPoint("TOPLEFT", MainMenuExpBar, "TOPLEFT", -3, 3)
xpBarBackdrop:SetPoint("BOTTOMRIGHT", MainMenuExpBar, "BOTTOMRIGHT", 3, -3)
xpBarBackdrop:SetBackdrop({edgeFile = BORD, edgeSize = 12})
xpBarBackdrop:SetBackdropBorderColor(unpack(GREY_RGB))
xpBarBackdrop:SetFrameLevel(MainMenuExpBar:GetFrameLevel() + 2)

-- Hide XP textures for cleaner appearance

local function hideXPTextureList()
    for i = 0, 3 do
        local xpTexture = _G["MainMenuXPBarTexture" .. i]
        if xpTexture then
            xpTexture:Hide()
            xpTexture:SetScript("OnShow", function(self) self:Hide() end)
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

-- Update MainMenuExpBar visuals and state

local function updateXPBarState()
    if UnitLevel("player") == MAX_PLAYER_LEVEL then
        MainMenuExpBar:Hide()
    else
        MainMenuExpBar:Show()
    end
    hideXPTextureList()
    MainMenuExpBar:SetWidth(120)
    MainMenuExpBar:SetHeight(12)
    MainMenuExpBar:ClearAllPoints()
    MainMenuExpBar:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 16, -16)
    MainMenuExpBar:SetStatusBarTexture(BAR)
    if GetXPExhaustion() and GetXPExhaustion() > 0 then
        MainMenuExpBar:SetStatusBarColor(unpack(BLUE_RGB))
    else
        MainMenuExpBar:SetStatusBarColor(unpack(VIOLET_RGB))
    end
    MainMenuExpBar:EnableMouse(true)
end

-- Register XP bar update events

local xpBarEventFrame = CreateFrame("Frame")
xpBarEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
xpBarEventFrame:RegisterEvent("PLAYER_LEVEL_UP")
xpBarEventFrame:RegisterEvent("PLAYER_XP_UPDATE")
xpBarEventFrame:RegisterEvent("UPDATE_EXHAUSTION")
xpBarEventFrame:SetScript("OnEvent", updateXPBarState)

-- Show XP tooltip on hover

local function showXPTooltip()
    local xpCurrent, xpMax = UnitXP("player"), UnitXPMax("player")
    local xpRested = GetXPExhaustion() or 0
    local xpPercent = math.floor((xpCurrent / xpMax) * 100)
    local restedPercent = math.floor((xpRested / xpMax) * 100)
    GameTooltip:SetOwner(MainMenuExpBar, "ANCHOR_BOTTOMRIGHT", 4, -4)
    if GetXPExhaustion() then
        GameTooltip:AddLine("Experience", unpack(BLUE_RGB))
    else
        GameTooltip:AddLine("Experience", unpack(VIOLET_RGB))
    end
    GameTooltip:AddDoubleLine("Progress:", xpPercent.."%")
    GameTooltip:AddDoubleLine("Rested:", restedPercent.."%")
    GameTooltip:AddDoubleLine("Current:", xpCurrent)
    GameTooltip:AddDoubleLine("Missing:", xpMax - xpCurrent)
    GameTooltip:AddDoubleLine("Total:", xpMax)
    GameTooltip:Show()
end

MainMenuExpBar:HookScript("OnEnter", showXPTooltip)
MainMenuExpBar:HookScript("OnLeave", function() GameTooltip:Hide() end)

-- Add repBackdrop to visually enhance ReputationWatchBar

local repBackdrop = CreateFrame("Frame", nil, ReputationWatchBar.StatusBar, "BackdropTemplate")
repBackdrop:SetPoint("TOPLEFT", ReputationWatchBar.StatusBar, "TOPLEFT", -3, 3)
repBackdrop:SetPoint("BOTTOMRIGHT", ReputationWatchBar.StatusBar, "BOTTOMRIGHT", 3, -3)
repBackdrop:SetBackdrop({edgeFile = BORD, edgeSize = 12})
repBackdrop:SetBackdropBorderColor(unpack(GREY_RGB))
repBackdrop:SetFrameLevel(ReputationWatchBar.StatusBar:GetFrameLevel() + 2)

-- Hide reputation textures for cleaner appearance

local function hideRepTextureList()
    local repTextureNames = {
        "XPBarTexture0", "XPBarTexture1", "XPBarTexture2", "XPBarTexture3",
        "WatchBarTexture0", "WatchBarTexture1", "WatchBarTexture2", "WatchBarTexture3"
    }
    for _, repName in ipairs(repTextureNames) do
        local repTexture = ReputationWatchBar.StatusBar[repName]
        if repTexture then
            repTexture:Hide()
            repTexture:SetScript("OnShow", function(self) self:Hide() end)
        end
    end
end

-- Update ReputationWatchBar visuals and state

local function updateRepBarState()
    if not GetWatchedFactionInfo() then
        ReputationWatchBar.StatusBar:Hide()
        return
    end
    hideRepTextureList()
    ReputationWatchBar.StatusBar:SetWidth(120)
    ReputationWatchBar.StatusBar:SetHeight(12)
    ReputationWatchBar.StatusBar:ClearAllPoints()
    ReputationWatchBar.StatusBar:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 16, -32)
    ReputationWatchBar.StatusBar:SetStatusBarTexture(BAR)
    ReputationWatchBar.StatusBar:SetStatusBarColor(unpack(ORANGE_RGB))
    ReputationWatchBar.StatusBar:EnableMouse(true)
    ReputationWatchBar.StatusBar:Show()
end

-- Register reputation bar update events

local repBarEventFrame = CreateFrame("Frame")
repBarEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
repBarEventFrame:RegisterEvent("UPDATE_FACTION")
repBarEventFrame:SetScript("OnEvent", updateRepBarState)

-- Show reputation tooltip on hover

local function showRepTooltip()
    local repName, repStanding, repMin, repMax, repValue = GetWatchedFactionInfo()
    if repName then
        local repProgress = repValue - repMin
        local repTotal = repMax - repMin
        local repPercent = math.floor((repProgress / repTotal) * 100)
        GameTooltip:SetOwner(ReputationWatchBar.StatusBar, "ANCHOR_BOTTOMRIGHT", 4, -4)
        GameTooltip:AddLine("Reputation", unpack(ORANGE_RGB))
        GameTooltip:AddDoubleLine("Faction:", repName)
        GameTooltip:AddDoubleLine("Standing:", _G["FACTION_STANDING_LABEL"..repStanding])
        GameTooltip:AddDoubleLine("Progress:", repPercent.."%")
        GameTooltip:AddDoubleLine("Current:", repProgress)
        GameTooltip:AddDoubleLine("Total:", repTotal)
        GameTooltip:Show()
    end
end

ReputationWatchBar.StatusBar:HookScript("OnEnter", showRepTooltip)
ReputationWatchBar.StatusBar:HookScript("OnLeave", function() GameTooltip:Hide() end)

-- Add exhaustion timer backdrop for visual consistency

local function addExhTimerBackdrop(timerName)
    if not _G[timerName.."CustomBackdrop"] then
        local timerBackdrop = CreateFrame("Frame", timerName.."CustomBackdrop", _G[timerName.."StatusBar"], "BackdropTemplate")
        timerBackdrop:SetPoint("TOPLEFT", _G[timerName.."StatusBar"], "TOPLEFT", -3, 3)
        timerBackdrop:SetPoint("BOTTOMRIGHT", _G[timerName.."StatusBar"], "BOTTOMRIGHT", 3, -3)
        timerBackdrop:SetBackdrop({ edgeFile = BORD, edgeSize = 12})
        timerBackdrop:SetBackdropBorderColor(unpack(GREY_RGB))
        timerBackdrop:SetFrameLevel(_G[timerName.."StatusBar"]:GetFrameLevel() + 2)
    end
end

-- Update exhaustion timer visuals and state

local function updateExhTimerState()
    for i = 1, MIRRORTIMER_NUMTIMERS do
        local timerName = "MirrorTimer"..i
        _G[timerName.."Border"]:Hide()
        _G[timerName.."StatusBar"]:SetStatusBarTexture(BAR)
        _G[timerName.."Text"]:ClearAllPoints()
        _G[timerName.."Text"]:SetPoint("CENTER", _G[timerName.."StatusBar"], "CENTER", 0, 0)
        addExhTimerBackdrop(timerName)
    end
end

-- Register exhaustion timer update events

local exhTimerEventFrame = CreateFrame("Frame")
exhTimerEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
exhTimerEventFrame:RegisterEvent("MIRROR_TIMER_START")
exhTimerEventFrame:SetScript("OnEvent", updateExhTimerState)

-- Adjust DurabilityFrame position after delay for layout consistency

local function adjustDuraFramePositionDelayed()
    if C_Timer and C_Timer.After then
        C_Timer.After(0.2, function()
            DurabilityFrame:ClearAllPoints()
            DurabilityFrame:SetPoint("TOP", UIParent, "TOP", 0, -16)
            DurabilityFrame:SetScale(0.8)
        end)
    else
        DurabilityFrame:ClearAllPoints()
        DurabilityFrame:SetPoint("TOP", UIParent, "TOP", 0, -16)
        DurabilityFrame:SetScale(0.8)
    end
end

DurabilityFrame:HookScript("OnUpdate", adjustDuraFramePositionDelayed)
hooksecurefunc(DurabilityFrame, "Show", adjustDuraFramePositionDelayed)
if DurabilityFrame:IsShown() then adjustDuraFramePositionDelayed() end