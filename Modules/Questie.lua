-- Configure questie nameplate positioning

local function configureQuestieSettings()
    if not IsAddOnLoaded("Questie") then
        return
    end
    Questie.db.profile.nameplateX = -28
    Questie.db.profile.nameplateY = 10
    Questie.db.profile.nameplateScale = 1.5
    Questie.db.profile.nameplateTargetFrameX = -180
    Questie.db.profile.nameplateTargetFrameY = 4
    Questie.db.profile.nameplateTargetFrameScale = 1.5
end

-- Register questie positioning events

local questieEvents = CreateFrame("Frame")
questieEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
questieEvents:SetScript("OnEvent", configureQuestieSettings)