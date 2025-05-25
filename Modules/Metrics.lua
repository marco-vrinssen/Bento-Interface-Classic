-- CREATE PERFORMANCE DISPLAY

local performanceFrame
local performanceText
local performanceUpdateTimer
local performanceIsVisible = false

local function createPerformanceDisplay()
    performanceFrame = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
    performanceFrame:SetSize(280, 28)
    performanceFrame:SetPoint("TOP", UIParent, "TOP", 0, -16)
    performanceFrame:SetBackdrop({
        bgFile = BG,
        edgeFile = BORD,
        edgeSize = 12,
        insets = {left = 2, right = 2, top = 2, bottom = 2}
    })
    performanceFrame:SetBackdropColor(unpack(BLACK_RGB))
    performanceFrame:SetBackdropBorderColor(unpack(GREY_RGB))
    performanceFrame:SetFrameStrata("HIGH")
    performanceFrame:Hide()

    performanceText = performanceFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    performanceText:SetPoint("CENTER", performanceFrame, "CENTER", 0, 0)
    performanceText:SetFont(FONT, 12, "OUTLINE")
    performanceText:SetTextColor(unpack(WHITE_RGB))
    performanceText:SetText("FPS: 0 | Home: 0ms World: 0ms")
end

local function updatePerformanceDisplay()
    if not performanceIsVisible then return end
    
    local fps = GetFramerate()
    local _, _, homeLatency, worldLatency = GetNetStats()
    
    if fps and homeLatency and worldLatency then
        performanceText:SetText(string.format("FPS: %d / Latency: %dms (Home) %dms (Server)", math.floor(fps), homeLatency, worldLatency))
    end
end

local function startPerformanceUpdates()
    if performanceUpdateTimer then return end
    
    performanceUpdateTimer = C_Timer.NewTicker(1, updatePerformanceDisplay)
end

local function stopPerformanceUpdates()
    if performanceUpdateTimer then
        performanceUpdateTimer:Cancel()
        performanceUpdateTimer = nil
    end
end

local function togglePerformanceDisplay()
    if not performanceFrame then
        createPerformanceDisplay()
    end
    
    performanceIsVisible = not performanceIsVisible
    
    if performanceIsVisible then
        performanceFrame:Show()
        startPerformanceUpdates()
        updatePerformanceDisplay()
    else
        performanceFrame:Hide()
        stopPerformanceUpdates()
    end
end

SLASH_PERFORMANCE1 = "/performance"
SlashCmdList["PERFORMANCE"] = togglePerformanceDisplay