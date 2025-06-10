-- Update player group indicators and hide unwanted elements

local function updatePlayerGroupElements()
    if PlayerFrameGroupIndicator then
        PlayerFrameGroupIndicator:SetAlpha(0)
        PlayerFrameGroupIndicator:Hide()
        
        if not PlayerFrameGroupIndicator.hooked then
            hooksecurefunc(PlayerFrameGroupIndicator, "Show", function(self)
                self:SetAlpha(0)
                self:Hide()
            end)
            PlayerFrameGroupIndicator.hooked = true
        end
    end

    local multiGroupFrame = _G["MultiGroupFrame"]
    if multiGroupFrame then
        multiGroupFrame:SetTexture(nil)
        multiGroupFrame:SetAlpha(0)
        multiGroupFrame:Hide()
        
        if not multiGroupFrame.hooked then
            hooksecurefunc(multiGroupFrame, "Show", function(self)
                self:SetTexture(nil)
                self:SetAlpha(0)
                self:Hide()
            end)
            multiGroupFrame.hooked = true
        end
    end
end

local playerGroupEvents = CreateFrame("Frame")
playerGroupEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
playerGroupEvents:RegisterEvent("GROUP_ROSTER_UPDATE")
playerGroupEvents:RegisterEvent("PARTY_LEADER_CHANGED")
playerGroupEvents:SetScript("OnEvent", updatePlayerGroupElements)
