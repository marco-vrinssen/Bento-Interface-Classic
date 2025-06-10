-- Update player level display with synchronization

local function updatePlayerLevelDisplay()
    C_Timer.After(0.2, function()
        local currentPlayerLevel = UnitLevel("player")
        if currentPlayerLevel == MAX_PLAYER_LEVEL then
            PlayerLevelText:Hide()
        else
            PlayerLevelText:Show()
        end
        PlayerLevelText:ClearAllPoints()
        PlayerLevelText:SetPoint("TOP", PlayerPortraitBackdrop, "BOTTOM", 0, -4)
        PlayerLevelText:SetFont(FONT, 12, "OUTLINE")
        PlayerLevelText:SetTextColor(unpack(WHITE_RGB))
    end)
end

local playerLevelEvents = CreateFrame("Frame")
playerLevelEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
playerLevelEvents:RegisterEvent("PLAYER_LEVEL_UP")
playerLevelEvents:SetScript("OnEvent", updatePlayerLevelDisplay)
