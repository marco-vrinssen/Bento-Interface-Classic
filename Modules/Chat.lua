-- Hide interface elements
local function hideElement(element)
    if element then
        element:Hide()
        element:SetScript("OnShow", element.Hide)
    end
end

local function hideChildren(parentFrame, childNames)
    for _, childName in ipairs(childNames) do
        local childElement = _G[parentFrame:GetName() .. childName] or parentFrame[childName]
        hideElement(childElement)
    end
end

local function hideTextures(frame)
    for _, region in ipairs({frame:GetRegions()}) do
        if region:IsObjectType("Texture") then
            hideElement(region)
        end
    end
end

-- Style chat tab appearance
local function styleTab(chatFrame)
    local chatTab = _G[chatFrame:GetName() .. "Tab"]
    local tabText = _G[chatFrame:GetName() .. "TabText"]
    local tabFlash = _G[chatFrame:GetName() .. "TabFlash"]

    hideTextures(chatTab)
    
    if tabText then
        tabText:SetFont(FONT, 14)
        tabText:ClearAllPoints()
        tabText:SetPoint("LEFT", chatTab, "LEFT", 4, 0)
    end

    if tabFlash and tabText then
        tabFlash:ClearAllPoints()
        tabFlash:SetAllPoints(tabText)
        tabFlash:SetPoint("CENTER", tabText, "CENTER", 0, 0)
        tabFlash:SetWidth(tabText:GetWidth())
        tabFlash:SetHeight(tabText:GetHeight())
    end
end

-- Create editbox backdrop styling
local function addBackdrop(editBox)
    if editBox and not editBox.customBackdrop then
        local backdrop = CreateFrame("Frame", nil, editBox, "BackdropTemplate")
        backdrop:SetPoint("TOPLEFT", editBox, "TOPLEFT", 0, 0)
        backdrop:SetPoint("BOTTOMRIGHT", editBox, "BOTTOMRIGHT", 0, 0)
        backdrop:SetBackdrop({
            bgFile = BG,
            edgeFile = BORD,
            edgeSize = 12,
            insets = {left = 2, right = 2, top = 2, bottom = 2}
        })
        backdrop:SetBackdropColor(unpack(BLACK_RGB))
        backdrop:SetBackdropBorderColor(unpack(GREY_RGB))
        editBox.customBackdrop = backdrop
        backdrop:SetFrameLevel(editBox:GetFrameLevel() - 1)
    end
end

-- Position minimize button
local function positionMinimize(chatFrame)
    local minimizeButton = _G[chatFrame:GetName() .. "MinimizeButton"]
    if minimizeButton then
        minimizeButton:ClearAllPoints()
        minimizeButton:SetPoint("BOTTOMRIGHT", chatFrame, "TOPRIGHT", 0, 0)
    end
end

-- Style chat frames complete
local function styleFrame(chatFrame)
    hideTextures(chatFrame)

    local ELEMENTS_TO_HIDE = {
        "ButtonFrame", "EditBoxLeft", "EditBoxMid", "EditBoxRight",
        "EditBoxHeaderSuffix", "TabUpButton", "TabDownButton",
        "TabBottomButton", "TabMinimizeButton"
    }

    hideChildren(chatFrame, ELEMENTS_TO_HIDE)
    styleTab(chatFrame)
    positionMinimize(chatFrame)

    local editBox = _G[chatFrame:GetName() .. "EditBox"]
    if editBox then
        addBackdrop(editBox)
    end
end

-- Align editbox headers
local function alignHeaders()
    for i = 1, NUM_CHAT_WINDOWS do
        local editBox = _G["ChatFrame" .. i .. "EditBox"]
        local header = _G["ChatFrame" .. i .. "EditBoxHeader"]
        if editBox and header then
            header:ClearAllPoints()
            header:SetPoint("LEFT", editBox, "LEFT", 8, 0)
        end
    end
end

-- Hook tab click scrolling
local function hookTabScroll(frameId)
    local chatTab = _G["ChatFrame" .. frameId .. "Tab"]
    if not chatTab.scrollHooked then
        chatTab:HookScript("OnClick", function() _G["ChatFrame" .. frameId]:ScrollToBottom() end)
        chatTab.scrollHooked = true
    end
end

-- Update scroll hooks
local function updateScrolling()
    for i = 1, NUM_CHAT_WINDOWS do
        hookTabScroll(i)
    end
end

-- Update all chat frames
local function updateFrames()
    for i = 1, NUM_CHAT_WINDOWS do
        local chatFrame = _G["ChatFrame" .. i]
        styleFrame(chatFrame)
    end

    hideElement(ChatFrameMenuButton)
    hideElement(ChatFrameChannelButton)
    if CombatLogQUIckButtonFrame_Custom then
        CombatLogQUIckButtonFrame_Custom:SetAlpha(0)
    end

    alignHeaders()
end

-- Enable class name colors
local function enableClassColors()
    SetCVar("chatClassColorOverride", "0")

    for chatType, _ in pairs(ChatTypeGroup) do
        SetChatColorNameByClass(chatType, true)
    end

    for chatType, _ in pairs(CHAT_CONFIG_CHAT_LEFT) do
        SetChatColorNameByClass(chatType, true)
    end

    local channels = { GetChannelList() }
    for i = 1, #channels, 3 do
        local channelId = channels[i]
        if channelId then
            SetChatColorNameByClass("CHANNEL" .. channelId, true)
        end
    end
end

-- Recolor whisper messages
local function recolorWhispers(self, event, message, sender, ...)
    if event == "CHAT_MSG_WHISPER" then
        return false, PINK_LIGHT_LUA .. message .. "|r", sender, ...
    end
end

-- Handle frame update events
local function onFrameEvent()
    updateFrames()
    updateScrolling()
    enableClassColors()
end

-- Register event handlers
local eventHandler = CreateFrame("Frame")
eventHandler:RegisterEvent("PLAYER_ENTERING_WORLD")
eventHandler:RegisterEvent("UPDATE_FLOATING_CHAT_WINDOWS")
eventHandler:RegisterEvent("UI_SCALE_CHANGED")
eventHandler:RegisterEvent("CHAT_MSG_WHISPER")
eventHandler:SetScript("OnEvent", onFrameEvent)

ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", recolorWhispers)

-- Handle temporary window creation
hooksecurefunc("FCF_OpenTemporaryWindow", function()
    local currentFrame = FCF_GetCurrentChatFrame()
    if currentFrame then
        styleFrame(currentFrame)
        hookTabScroll(currentFrame:GetID())
        alignHeaders()
    end
end)

-- Find scan message frame
local function getScanFrame()
    for i = 1, NUM_CHAT_WINDOWS do
        local name = GetChatWindowInfo(i)
        if name == "Scan" then
            return _G["ChatFrame" .. i]
        end
    end
    return nil
end

-- Send scan message output
local function sendScanMessage(message, red, green, blue)
    local scanFrame = getScanFrame()
    if scanFrame then
        scanFrame:AddMessage(message, red or 1, green or 1, blue or 1)
    else
        DEFAULT_CHAT_FRAME:AddMessage(message, red or 1, green or 1, blue or 1)
    end
end
