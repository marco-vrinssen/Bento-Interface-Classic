local metricsFrame
local metricsText
local metricsTimer
local metricsVisible = false

-- Create performance display with backdrop styling to show metrics

local function createMetricsDisplay()
    metricsFrame = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
    metricsFrame:SetSize(280, 28)
    metricsFrame:SetPoint("TOP", UIParent, "TOP", 0, -16)
    metricsFrame:SetBackdrop({
        bgFile = BG,
        edgeFile = BORD,
        edgeSize = 12,
        insets = {left = 2, right = 2, top = 2, bottom = 2}
    })
    metricsFrame:SetBackdropColor(unpack(BLACK_RGB))
    metricsFrame:SetBackdropBorderColor(unpack(GREY_RGB))
    metricsFrame:SetFrameStrata("HIGH")
    metricsFrame:Hide()

    metricsText = metricsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    metricsText:SetPoint("CENTER", metricsFrame, "CENTER", 0, 0)
    metricsText:SetFont(FONT, 12, "OUTLINE")
    metricsText:SetTextColor(unpack(WHITE_RGB))
    metricsText:SetText("FPS: 0 | Home: 0ms World: 0ms")
end

-- Update metrics display with framerate and latency to show performance

local function updateMetricsDisplay()
    if not metricsVisible then return end
    
    local fps = GetFramerate()
    local _, _, homeLatency, worldLatency = GetNetStats()
    
    if fps and homeLatency and worldLatency then
        metricsText:SetText(string.format("FPS: %d / Latency: %dms (Home) %dms (Server)", math.floor(fps), homeLatency, worldLatency))
    end
end

-- Start metrics updates with timer to provide continuous monitoring

local function startMetricsUpdates()
    if metricsTimer then return end
    
    metricsTimer = C_Timer.NewTicker(1, updateMetricsDisplay)
end

-- Stop metrics updates with timer cleanup to save resources

local function stopMetricsUpdates()
    if metricsTimer then
        metricsTimer:Cancel()
        metricsTimer = nil
    end
end

-- Toggle metrics display with visibility state to control display

local function toggleMetricsDisplay()
    if not metricsFrame then
        createMetricsDisplay()
    end
    
    metricsVisible = not metricsVisible
    
    if metricsVisible then
        metricsFrame:Show()
        startMetricsUpdates()
        updateMetricsDisplay()
    else
        metricsFrame:Hide()
        stopMetricsUpdates()
    end
end

SLASH_PERFORMANCE1 = "/performance"
SlashCmdList["PERFORMANCE"] = toggleMetricsDisplay