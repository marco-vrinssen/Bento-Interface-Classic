-- UPDATE AUCTIONATOR SCAN BUTTON POSITION

local function updateAuctionator()

    if not IsAddOnLoaded("Auctionator") then
        return
    end

    local scanButton = AuctionatorConfigFrame.ScanButton
    scanButton:SetParent(AuctionFrame)
    scanButton:ClearAllPoints()
    scanButton:SetPoint("RIGHT", AuctionFrameCloseButton, "LEFT", -20, 0)
end

-- CREATE FRAME FOR AUCTIONATOR UPDATE

local auctionatorFrame = CreateFrame("Frame")
auctionatorFrame:RegisterEvent("AUCTION_HOUSE_SHOW")
auctionatorFrame:SetScript("OnEvent", updateAuctionator)