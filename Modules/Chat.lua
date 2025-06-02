-- HIDE UI ELEMENTS

local function hideUIElement(element)
    if element then
        element:Hide()
        element:SetScript("OnShow", element.Hide)
    end
end

local function hideChildUIElements(parentFrame, childElementNames)
    for _, childName in ipairs(childElementNames) do
        local childElement = _G[parentFrame:GetName() .. childName] or parentFrame[childName]
        hideUIElement(childElement)
    end
end

local function hideFrameTextures(frame)
    for _, region in ipairs({frame:GetRegions()}) do
        if region:IsObjectType("Texture") then
            hideUIElement(region)
        end
    end
end

-- CUSTOMIZE CHAT TABS

local function customizeChatTab(chatFrame)
    local chatTab = _G[chatFrame:GetName() .. "Tab"]
    local chatTabText = _G[chatFrame:GetName() .. "TabText"]
    local chatTabFlash = _G[chatFrame:GetName() .. "TabFlash"]

    hideFrameTextures(chatTab)
    
    if chatTabText then
        chatTabText:SetFont(FONT, 14)
        chatTabText:ClearAllPoints()
        chatTabText:SetPoint("LEFT", chatTab, "LEFT", 4, 0)
    end

    if chatTabFlash and chatTabText then
        chatTabFlash:ClearAllPoints()
        chatTabFlash:SetAllPoints(chatTabText)
        chatTabFlash:SetPoint("CENTER", chatTabText, "CENTER", 0, 0)
        chatTabFlash:SetWidth(chatTabText:GetWidth())
        chatTabFlash:SetHeight(chatTabText:GetHeight())
    end
end

-- ADD CUSTOM EDITBOX BACKDROP

local function addCustomBackdropToEditBox(editBox)
    if editBox and not editBox.customBackdrop then
        local editBoxBackdrop = CreateFrame("Frame", nil, editBox, "BackdropTemplate")
        editBoxBackdrop:SetPoint("TOPLEFT", editBox, "TOPLEFT", 0, 0)
        editBoxBackdrop:SetPoint("BOTTOMRIGHT", editBox, "BOTTOMRIGHT", 0, 0)
        editBoxBackdrop:SetBackdrop({
            bgFile = BG,
            edgeFile = BORD,
            edgeSize = 12,
            insets = {left = 2, right = 2, top = 2, bottom = 2}
        })
        editBoxBackdrop:SetBackdropColor(unpack(BLACK_RGB))
        editBoxBackdrop:SetBackdropBorderColor(unpack(GREY_RGB))
        editBox.customBackdrop = editBoxBackdrop
        editBoxBackdrop:SetFrameLevel(editBox:GetFrameLevel() - 1)
    end
end

-- POSITION MINIMIZE BUTTONS

local function positionMinimizeButton(chatFrame)
    local minimizeButton = _G[chatFrame:GetName() .. "MinimizeButton"]
    if minimizeButton then
        minimizeButton:ClearAllPoints()
        minimizeButton:SetPoint("BOTTOMRIGHT", chatFrame, "TOPRIGHT", 0, 0)
    end
end

-- CUSTOMIZE CHAT FRAME

local function customizeChatFrame(chatFrame)
    hideFrameTextures(chatFrame)

    local hideElements = {
        "ButtonFrame", "EditBoxLeft", "EditBoxMid", "EditBoxRight",
        "EditBoxHeaderSuffix", "TabUpButton", "TabDownButton",
        "TabBottomButton", "TabMinimizeButton"
    }

    hideChildUIElements(chatFrame, hideElements)
    customizeChatTab(chatFrame)
    positionMinimizeButton(chatFrame)

    local editBox = _G[chatFrame:GetName() .. "EditBox"]
    if editBox then
        addCustomBackdropToEditBox(editBox)
    end
end

-- ALIGN EDITBOX HEADERS

local function alignEditBoxHeaders()
    for i = 1, NUM_CHAT_WINDOWS do
        local editBox = _G["ChatFrame" .. i .. "EditBox"]
        local editBoxHeader = _G["ChatFrame" .. i .. "EditBoxHeader"]
        if editBox and editBoxHeader then
            editBoxHeader:ClearAllPoints()
            editBoxHeader:SetPoint("LEFT", editBox, "LEFT", 8, 0)
        end
    end
end

-- HOOK CHAT TAB SCROLL BEHAVIOR

local function hookChatTabScroll(chatFrameID)
    local chatTab = _G["ChatFrame" .. chatFrameID .. "Tab"]
    if not chatTab.scrollHooked then
        chatTab:HookScript("OnClick", function() _G["ChatFrame" .. chatFrameID]:ScrollToBottom() end)
        chatTab.scrollHooked = true
    end
end

local function updateChatScrollBehavior()
    for i = 1, NUM_CHAT_WINDOWS do
        hookChatTabScroll(i)
    end
end

-- UPDATE ALL CHAT FRAMES

local function updateAllChatFrames()
    for i = 1, NUM_CHAT_WINDOWS do
        local chatFrame = _G["ChatFrame" .. i]
        customizeChatFrame(chatFrame)
    end

    hideUIElement(ChatFrameMenuButton)
    hideUIElement(ChatFrameChannelButton)
    if CombatLogQUIckButtonFrame_Custom then
        CombatLogQUIckButtonFrame_Custom:SetAlpha(0)
    end

    alignEditBoxHeaders()
end

-- SET CLASS COLORS FOR CHAT NAMES

local function setClassColorsForChatTypes()
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

-- RECOLOR WHISPER MESSAGES

local function recolorWhisperMessages(self, event, message, sender, ...)
    if event == "CHAT_MSG_WHISPER" then
        return false, PINK_LIGHT_LUA .. message .. "|r", sender, ...
    end
end

-- EVENT HANDLER

local function onChatFrameEvent()
    updateAllChatFrames()
    updateChatScrollBehavior()
    setClassColorsForChatTypes()
end

-- REGISTER EVENTS

local chatFrameEventHandler = CreateFrame("Frame")
chatFrameEventHandler:RegisterEvent("PLAYER_ENTERING_WORLD")
chatFrameEventHandler:RegisterEvent("UPDATE_FLOATING_CHAT_WINDOWS")
chatFrameEventHandler:RegisterEvent("UI_SCALE_CHANGED")
chatFrameEventHandler:RegisterEvent("CHAT_MSG_WHISPER")
chatFrameEventHandler:SetScript("OnEvent", onChatFrameEvent)

ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", recolorWhisperMessages)

hooksecurefunc("FCF_OpenTemporaryWindow", function()
    local currentChatFrame = FCF_GetCurrentChatFrame()
    if currentChatFrame then
        customizeChatFrame(currentChatFrame)
        hookChatTabScroll(currentChatFrame:GetID())
        alignEditBoxHeaders()
    end
end)