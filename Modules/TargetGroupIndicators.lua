-- Update target group indicators for leader icon

local function updateTargetGroupIndicators()
    TargetFrameTextureFrameLeaderIcon:ClearAllPoints()
    TargetFrameTextureFrameLeaderIcon:SetPoint("BOTTOM", TargetPortraitBackdrop, "TOP", 0, 0)
end

local targetGroupFrame = CreateFrame("Frame")
targetGroupFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
targetGroupFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
targetGroupFrame:SetScript("OnEvent", updateTargetGroupIndicators)

hooksecurefunc("TargetFrame_Update", updateTargetGroupIndicators)
