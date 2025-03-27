-- UPDATE QUESTIE TRACKING ICONS

local function updateQuestieIcons()

    if not IsAddOnLoaded("Questie") then
        return
    end

    Questie.db.profile.nameplateX = -28
    Questie.db.profile.nameplateY = 10
    Questie.db.profile.nameplateScale = 1.5

    Questie.db.profile.nameplateTargetFrameX = -172
    Questie.db.profile.nameplateTargetFrameY = 4
    Questie.db.profile.nameplateTargetFrameScale = 1.5
end


-- CREATE FRAME FOR QUESTIE UPDATE

local questieSupportFrame = CreateFrame("Frame")
questieSupportFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
questieSupportFrame:SetScript("OnEvent", updateQuestieIcons)