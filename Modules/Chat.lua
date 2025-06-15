-- Hide UI elements with secure methods to achieve clean interface

local function hideElement(element)
    if element then
        element:Hide()
        element:SetScript("OnShow", element.Hide)
    end
end

local function hideChildElements(parentFrame, childNames)
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

-- Customize chat tab styling to achieve better appearance

local function customizeTab(chatFrame)
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

-- Create custom backdrop for editbox to achieve visual consistency

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

local function positionMinimizeButton(chatFrame)
    local minimizeButton = _G[chatFrame:GetName() .. "MinimizeButton"]
    if minimizeButton then
        minimizeButton:ClearAllPoints()
        minimizeButton:SetPoint("BOTTOMRIGHT", chatFrame, "TOPRIGHT", 0, 0)
    end
end

-- Apply comprehensive styling to chat frames to achieve unified appearance

local function customizeFrame(chatFrame)
    hideTextures(chatFrame)

    local elementsToHide = {
        "ButtonFrame", "EditBoxLeft", "EditBoxMid", "EditBoxRight",
        "EditBoxHeaderSuffix", "TabUpButton", "TabDownButton",
        "TabBottomButton", "TabMinimizeButton"
    }

    hideChildElements(chatFrame, elementsToHide)
    customizeTab(chatFrame)
    positionMinimizeButton(chatFrame)

    local editBox = _G[chatFrame:GetName() .. "EditBox"]
    if editBox then
        addBackdrop(editBox)
    end
end

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

-- Hook tab scroll behavior to chat frames to achieve auto-scroll

local function hookTabScroll(frameID)
    local chatTab = _G["ChatFrame" .. frameID .. "Tab"]
    if not chatTab.scrollHooked then
        chatTab:HookScript("OnClick", function() _G["ChatFrame" .. frameID]:ScrollToBottom() end)
        chatTab.scrollHooked = true
    end
end

local function updateScrollBehavior()
    for i = 1, NUM_CHAT_WINDOWS do
        hookTabScroll(i)
    end
end

-- Update all chat components to achieve complete customization

local function updateAllFrames()
    for i = 1, NUM_CHAT_WINDOWS do
        local chatFrame = _G["ChatFrame" .. i]
        customizeFrame(chatFrame)
    end

    hideElement(ChatFrameMenuButton)
    hideElement(ChatFrameChannelButton)
    if CombatLogQUIckButtonFrame_Custom then
        CombatLogQUIckButtonFrame_Custom:SetAlpha(0)
    end

    alignHeaders()
end

-- Enable class colors for chat names to achieve better readability

local function setClassColors()
    SetCVar("chatClassColorOverride", "0")

    for chatType, _ in pairs(ChatTypeGroup) do
        SetChatColorNameByClass(chatType, true)
    end

    for chatType, _ in pairs(CHAT_CONFIG_CHAT_LEFT) do
        SetChatColorNameByClass(chatType, true)
    end

    local channels = { GetChannelList() }
    for i = 1, #channels, 3 do
        local channelID = channels[i]
        if channelID then
            SetChatColorNameByClass("CHANNEL" .. channelID, true)
        end
    end
end

local function recolorWhispers(self, event, message, sender, ...)
    if event == "CHAT_MSG_WHISPER" then
        return false, PINK_LIGHT_LUA .. message .. "|r", sender, ...
    end
end

-- Handle chat frame events to achieve proper initialization

local function onFrameEvent()
    updateAllFrames()
    updateScrollBehavior()
    setClassColors()
end

-- Register events with handler to achieve automatic updates

local eventHandler = CreateFrame("Frame")
eventHandler:RegisterEvent("PLAYER_ENTERING_WORLD")
eventHandler:RegisterEvent("UPDATE_FLOATING_CHAT_WINDOWS")
eventHandler:RegisterEvent("UI_SCALE_CHANGED")
eventHandler:RegisterEvent("CHAT_MSG_WHISPER")
eventHandler:SetScript("OnEvent", onFrameEvent)

ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", recolorWhispers)

hooksecurefunc("FCF_OpenTemporaryWindow", function()
    local currentFrame = FCF_GetCurrentChatFrame()
    if currentFrame then
        customizeFrame(currentFrame)
        hookTabScroll(currentFrame:GetID())
        alignHeaders()
    end
end)

-- Handle middle mouse click on player name in chat to open whisper in new tab

local function handleMiddleClickOnPlayer(self, link, text, button)
    if button == "MiddleButton" and link and link:find("player:") then
        local player = link:match("player:([^:]+)")
        if player then
            -- Open a new whisper window/tab to the player
            FCF_OpenNewWindow(player)
            local frame = FCF_GetCurrentChatFrame()
            if frame then
                FCF_SetWindowName(frame, player)
                ChatFrame_SendTell(player, frame)
            end
        end
    end
end

-- Hook SetItemRef to handle middle mouse clicks on player links

hooksecurefunc("SetItemRef", function(link, text, button, ...)
    handleMiddleClickOnPlayer(nil, link, text, button)
end)

-- Provide function to send scan messages to Scan tab if it exists

local function getScanChatFrame()
    for i = 1, NUM_CHAT_WINDOWS do
        local name = GetChatWindowInfo(i)
        if name == "Scan" then
            return _G["ChatFrame" .. i]
        end
    end
    return nil
end

local function sendScanMessage(msg, r, g, b)
    local scanFrame = getScanChatFrame()
    if scanFrame then
        scanFrame:AddMessage(msg, r or 1, g or 1, b or 1)
    else
        DEFAULT_CHAT_FRAME:AddMessage(msg, r or 1, g or 1, b or 1)
    end
end
