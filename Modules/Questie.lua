-- Update questie nameplate settings to integrate with BentoInterface

local function updateNameplateSettings()
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

-- Register positioning event handler for world enter

local questieEventFrame = CreateFrame("Frame")
questieEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
questieEventFrame:SetScript("OnEvent", updateNameplateSettings)