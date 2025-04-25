-- HELPER FUNCTIONS FOR UI MODIFICATION

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

-- CHAT FRAME CUSTOMIZATION

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
        editBoxBackdrop:SetBackdropColor(unpack(BLACK))
        editBoxBackdrop:SetBackdropBorderColor(unpack(GREY))
        editBox.customBackdrop = editBoxBackdrop

        editBoxBackdrop:SetFrameLevel(editBox:GetFrameLevel() - 1)
    end
end

local function customizeChatFrame(chatFrame)
    hideFrameTextures(chatFrame)

    local elementsToHide = {
        "ButtonFrame", "EditBoxLeft", "EditBoxMid", "EditBoxRight",
        "EditBoxHeaderSuffix", "TabUpButton", "TabDownButton",
        "TabBottomButton", "TabMinimizeButton"
    }

    hideChildUIElements(chatFrame, elementsToHide)
    customizeChatTab(chatFrame)

    local editBox = _G[chatFrame:GetName() .. "EditBox"]
    if editBox then
        addCustomBackdropToEditBox(editBox)
    end
end

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

-- CHAT SCROLL BEHAVIOR

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

-- CHAT COLORS CONFIGURATION

local function setClassColorsForChatTypes()
    SetCVar("chatClassColorOverride", "0")

    for k, _ in pairs(ChatTypeGroup) do
        SetChatColorNameByClass(k, true)
    end

    local additionalTypes = {
        "SAY", "EMOTE", "YELL", "GREEN_CHAT", "OFFICER", "PINK_CHAT",
        "PARTY", "PARTY_LEADER", "RAID", "RAID_LEADER", "RAID_WARNING",
        "INSTANCE_CHAT", "INSTANCE_CHAT_LEADER", "VOICE_TEXT"
    }

    for _, v in ipairs(additionalTypes) do
        SetChatColorNameByClass(v, true)
    end

    for i = 1, 50 do
        SetChatColorNameByClass("CORAL_CHAT" .. i, true)
    end

    local channels = { GetChannelList() }
    for i = 1, #channels, 3 do
        SetChatColorNameByClass("CHANNEL" .. channels[i], true)
    end
end

local function setCustomChatColors()
    ChangeChatColor("SAY", unpack(CORAL_CHAT))
    ChangeChatColor("EMOTE", unpack(CORAL_CHAT))
    ChangeChatColor("YELL", unpack(CORAL_CHAT))
    ChangeChatColor("GREEN_CHAT", unpack(GREEN_CHAT))
    ChangeChatColor("OFFICER", unpack(GREEN_CHAT))
    ChangeChatColor("PINK_CHAT", unpack(PINK_CHAT))
    ChangeChatColor("WHISPER_INFORM", unpack(PINK_CHAT))
    ChangeChatColor("BN_WHISPER", unpack(PINK_CHAT))
    ChangeChatColor("BN_WHISPER_INFORM", unpack(PINK_CHAT))
    ChangeChatColor("WHISPER", unpack(PINK_CHAT))
    ChangeChatColor("BN_WHISPER", unpack(PINK_CHAT))
    ChangeChatColor("RAID", unpack(BLUE_CHAT))
    ChangeChatColor("RAID_LEADER", unpack(BLUE_CHAT))
    ChangeChatColor("RAID_WARNING", unpack(BLUE_CHAT))
    ChangeChatColor("PARTY", unpack(BLUE_CHAT))
    ChangeChatColor("PARTY_LEADER", unpack(BLUE_CHAT))
    ChangeChatColor("INSTANCE_CHAT", unpack(BLUE_CHAT))
    ChangeChatColor("INSTANCE_CHAT_LEADER", unpack(BLUE_CHAT))

    for i = 1, GetNumDisplayChannels() do
        local _, _, _, channelID = GetChannelDisplayInfo(i)
        if channelID then
            ChangeChatColor("CHANNEL"..channelID, unpack(YELLOW_CHAT))
        end
    end

    ChangeChatColor("COMBAT_XP_GAIN", unpack(WHITE_CHAT))
    ChangeChatColor("COMBAT_HONOR_GAIN", unpack(WHITE_CHAT))
    ChangeChatColor("COMBAT_FACTION_CHANGE", unpack(WHITE_CHAT))
    ChangeChatColor("SKILL", unpack(WHITE_CHAT))
    ChangeChatColor("LOOT", unpack(WHITE_CHAT))
    ChangeChatColor("MONEY", unpack(WHITE_CHAT))
    ChangeChatColor("TRADESKILLS", unpack(WHITE_CHAT))
    ChangeChatColor("OPENING", unpack(WHITE_CHAT))
    ChangeChatColor("PET_INFO", unpack(WHITE_CHAT))
    ChangeChatColor("COMBAT_MISC_INFO", unpack(WHITE_CHAT))

    ChangeChatColor("SYSTEM", unpack(WHITE_CHAT))
    ChangeChatColor("ERROR", unpack(RED_CHAT))
    ChangeChatColor("IGNORED", unpack(RED_CHAT))
    ChangeChatColor("TARGETICONS", unpack(WHITE_CHAT))
    ChangeChatColor("BN_INLINE_TOAST_ALERT", unpack(BLUE_CHAT))

    ChangeChatColor("BG_SYSTEM_ALLIANCE", unpack(ORANGE_CHAT))
    ChangeChatColor("BG_SYSTEM_HORDE", unpack(ORANGE_CHAT))
    ChangeChatColor("BG_SYSTEM_NEUTRAL", unpack(ORANGE_CHAT))

    ChangeChatColor("MONSTER_SAY", unpack(ORANGE_CHAT))
    ChangeChatColor("MONSTER_EMOTE", unpack(ORANGE_CHAT))
    ChangeChatColor("MONSTER_YELL", unpack(ORANGE_CHAT))
    ChangeChatColor("MONSTER_WHISPER", unpack(ORANGE_CHAT))
    ChangeChatColor("MONSTER_BOSS_EMOTE", unpack(ORANGE_CHAT))
    ChangeChatColor("MONSTER_BOSS_WHISPER", unpack(ORANGE_CHAT))
end

local function updateChatColors()
    setClassColorsForChatTypes()
    setCustomChatColors()
end

local function recolorWhisperMessages(self, event, message, sender, ...)
    if event == "CHAT_MSG_WHISPER" then
        return false, PINK_LIGHT_CHAT_LUA .. message .. "|r", sender, ...
    end
end

-- REPOSITION AND UPDATE CHAT FRAME

local function resetChatFrameCustomizations(chatFrame)
    chatFrame:ClearAllPoints()
    chatFrame:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 0, 0)
    chatFrame:SetWidth(400)
    chatFrame:SetHeight(200)
    chatFrame:SetUserPlaced(false)
    chatFrame:SetMovable(true)
    chatFrame:SetResizable(true)
    chatFrame:SetMinResize(200, 100)
    chatFrame:SetMaxResize(800, 600)
end

-- MAIN FUNCTIONS

local function updateAllChatFrames()
    for i = 1, NUM_CHAT_WINDOWS do
        local chatFrame = _G["ChatFrame" .. i]
        customizeChatFrame(chatFrame)

        local editBox = _G["ChatFrame" .. i .. "EditBox"]
        if editBox then
            addCustomBackdropToEditBox(editBox)
        end
    end

    hideUIElement(ChatFrameMenuButton)
    hideUIElement(ChatFrameChannelButton)
    if CombatLogQUIckButtonFrame_Custom then
        CombatLogQUIckButtonFrame_Custom:SetAlpha(0)
    end

    alignEditBoxHeaders()
end

local function onChatFrameEvent(self, event, ...)
    updateAllChatFrames()
    updateChatScrollBehavior()

    if event == "PLAYER_ENTERING_WORLD" then
        C_Timer.After(1, updateChatColors)
        C_Timer.After(15, updateChatColors)
    else
        updateChatColors()
    end
end

-- EVENT

local chatFrameEvents = CreateFrame("Frame")
chatFrameEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
chatFrameEvents:RegisterEvent("UPDATE_FLOATING_CHAT_WINDOWS")
chatFrameEvents:RegisterEvent("CHAT_MSG_WHISPER")
chatFrameEvents:RegisterEvent("UI_SCALE_CHANGED")
chatFrameEvents:RegisterEvent("CHANNEL_UI_UPDATE")
chatFrameEvents:RegisterEvent("CHANNEL_COUNT_UPDATE")
chatFrameEvents:SetScript("OnEvent", onChatFrameEvent)

ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", recolorWhisperMessages)

hooksecurefunc("FCF_OpenTemporaryWindow", function()
    local currentChatFrame = FCF_GetCurrentChatFrame()
    if currentChatFrame then
        customizeChatFrame(currentChatFrame)
        hookChatTabScroll(currentChatFrame:GetID())
        alignEditBoxHeaders()

        local editBox = _G[currentChatFrame:GetName() .. "EditBox"]
        if editBox then
            addCustomBackdropToEditBox(editBox)
        end
    end
end)