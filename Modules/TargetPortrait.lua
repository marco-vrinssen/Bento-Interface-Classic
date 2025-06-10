-- Setup target portrait for custom position and styling

local function updateTargetPortrait()
    TargetFramePortrait:ClearAllPoints()
    TargetFramePortrait:SetPoint("CENTER", TargetPortraitBackdrop, "CENTER", 0, 0)
    TargetFramePortrait:SetSize(TargetPortraitBackdrop:GetHeight() - 6, TargetPortraitBackdrop:GetHeight() - 6)
end

local targetPortraitEvents = CreateFrame("Frame")
targetPortraitEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
targetPortraitEvents:RegisterEvent("PLAYER_TARGET_CHANGED")
targetPortraitEvents:SetScript("OnEvent", updateTargetPortrait)

hooksecurefunc("TargetFrame_Update", updateTargetPortrait)
hooksecurefunc("UnitFramePortrait_Update", updateTargetPortrait)

-- Update portrait texture for class or NPC

local function updatePortraitTexture(targetPortrait)
    if targetPortrait.unit == "target" and targetPortrait.portrait then
        if UnitIsPlayer(targetPortrait.unit) then
            local portraitTexture = CLASS_ICON_TCOORDS[select(2, UnitClass(targetPortrait.unit))]
            if portraitTexture then
                targetPortrait.portrait:SetTexture("Interface/GLUES/CHARACTERCREATE/UI-CHARACTERCREATE-CLASSES")
                local left, right, top, bottom = unpack(portraitTexture)
                local leftUpdate = left + (right - left) * 0.15
                local rightUpdate = right - (right - left) * 0.15
                local topUpdate = top + (bottom - top) * 0.15
                local bottomUpdate = bottom - (bottom - top) * 0.15
                targetPortrait.portrait:SetTexCoord(leftUpdate, rightUpdate, topUpdate, bottomUpdate)
                targetPortrait.portrait:SetDrawLayer("BACKGROUND", -1)
            end
        else
            targetPortrait.portrait:SetTexCoord(0.15, 0.85, 0.15, 0.85)
        end
    end
end

hooksecurefunc("UnitFramePortrait_Update", updatePortraitTexture)
