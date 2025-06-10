-- Update target backdrops and border color for classification

local function updateTargetClassification()
    if not UnitExists("target") then
        TargetFrameBackdrop:SetBackdrop({ edgeFile = BORD, edgeSize = 12 })
        TargetFrameBackdrop:SetBackdropBorderColor(unpack(GREY_RGB))
        TargetFrameBackdrop:SetSize(128, 48)
        TargetPortraitBackdrop:SetBackdrop({ edgeFile = BORD, edgeSize = 12 })
        TargetPortraitBackdrop:SetBackdropBorderColor(unpack(GREY_RGB))
        return
    end

    local classification = UnitClassification("target")
    if classification == "worldboss" then
        TargetFrameBackdrop:SetBackdrop({ edgeFile = BORD, edgeSize = 18 })
        TargetFrameBackdrop:SetBackdropBorderColor(unpack(ORANGE_RGB))
        TargetFrameBackdrop:SetSize(130, 50)
        TargetPortraitBackdrop:SetBackdrop({ edgeFile = BORD, edgeSize = 18 })
        TargetPortraitBackdrop:SetBackdropBorderColor(unpack(ORANGE_RGB))
        TargetPortraitBackdrop:SetSize(50, 50)
    elseif classification == "elite" then
        TargetFrameBackdrop:SetBackdrop({ edgeFile = BORD, edgeSize = 18 })
        TargetFrameBackdrop:SetBackdropBorderColor(unpack(YELLOW_RGB))
        TargetFrameBackdrop:SetSize(130, 50)
        TargetPortraitBackdrop:SetBackdrop({ edgeFile = BORD, edgeSize = 18 })
        TargetPortraitBackdrop:SetBackdropBorderColor(unpack(YELLOW_RGB))
        TargetPortraitBackdrop:SetSize(50, 50)
    elseif classification == "rareelite" or classification == "rare" then
        TargetFrameBackdrop:SetBackdrop({ edgeFile = BORD, edgeSize = 18 })
        TargetFrameBackdrop:SetBackdropBorderColor(unpack(WHITE_RGB))
        TargetFrameBackdrop:SetSize(130, 50)
        TargetPortraitBackdrop:SetBackdrop({ edgeFile = BORD, edgeSize = 18 })
        TargetPortraitBackdrop:SetBackdropBorderColor(unpack(WHITE_RGB))
        TargetPortraitBackdrop:SetSize(50, 50)
    else
        TargetFrameBackdrop:SetBackdrop({ edgeFile = BORD, edgeSize = 12 })
        TargetFrameBackdrop:SetBackdropBorderColor(unpack(GREY_RGB))
        TargetFrameBackdrop:SetSize(128, 48)
        TargetPortraitBackdrop:SetBackdrop({ edgeFile = BORD, edgeSize = 12 })
        TargetPortraitBackdrop:SetBackdropBorderColor(unpack(GREY_RGB))
        TargetPortraitBackdrop:SetSize(48, 48)
    end
end

local targetTypeEvents = CreateFrame("Frame")
targetTypeEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
targetTypeEvents:RegisterEvent("PLAYER_TARGET_CHANGED")
targetTypeEvents:RegisterEvent("UNIT_CLASSIFICATION_CHANGED")
targetTypeEvents:SetScript("OnEvent", function(self, event, unit)
    if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_TARGET_CHANGED" or (event == "UNIT_CLASSIFICATION_CHANGED" and unit == "target") then
        updateTargetClassification()
    end
end)
