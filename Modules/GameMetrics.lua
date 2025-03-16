-- HIDE DEFAULT FRAMERATE LABEL

local function enforceHideFramerateLabel()
    FramerateLabel:Hide()
end

FramerateLabel:HookScript("OnShow", enforceHideFramerateLabel)


-- SETUP FRAMERATE DISPLAY

local function framerateUpdate()
    FramerateText:ClearAllPoints()
    FramerateText:SetPoint("TOP", UIParent, "TOP", 0, -16)
    FramerateText:SetFont(FONT, 12, "OUTLINE")
end

local framerateEvents = CreateFrame("Frame")
framerateEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
framerateEvents:SetScript("OnEvent", framerateUpdate)


-- CREATE LATENCY DISPLAY

local latencyFrame = CreateFrame("Frame", "BentoLatencyFrame", UIParent)
local latencyText = latencyFrame:CreateFontString(nil, "OVERLAY")
latencyText:SetFont(FONT, 16, "OUTLINE")
latencyText:SetPoint("TOP", FramerateText, "BOTTOM", 0, -8)


-- UPDATE LATENCY INFORMATION

local function updateLatency()
    local homeLatency, worldLatency = select(3, GetNetStats())
    latencyText:SetText(homeLatency.."ms / "..worldLatency.."ms")
end

latencyFrame:SetScript("OnShow", updateLatency)


-- LINK FRAMERATE AND LATENCY VISIBILITY

local function updateLatencyFrameVisibility()
    if FramerateText:IsShown() then
        latencyFrame:Show()
    else
        latencyFrame:Hide()
    end
end

FramerateText:HookScript("OnShow", updateLatencyFrameVisibility)
FramerateText:HookScript("OnHide", updateLatencyFrameVisibility)


-- INITIALIZE ON PLAYER LOGIN

latencyFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
latencyFrame:SetScript("OnEvent", updateLatencyFrameVisibility)


-- PERIODIC LATENCY UPDATES

local updateTimer = 0
latencyFrame:SetScript("OnUpdate", function(self, elapsed)
    updateTimer = updateTimer + elapsed
    if updateTimer >= 1 then -- Update every second
        updateTimer = 0
        if latencyFrame:IsShown() then
            updateLatency()
        end
    end
end)