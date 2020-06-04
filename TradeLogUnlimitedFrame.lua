local LibDBIcon = LibStub("LibDBIcon-1.0")

function TradeLogUnlimitedFrame_OnLoad(self)
    table.insert(UISpecialFrames, self:GetName()); --for esc close frame

    TradeLogUnlimited_SetHyperlink_Origin = ItemRefTooltip.SetHyperlink;
    ItemRefTooltip.SetHyperlink = function(self,link)
        if(strsub(link, 1, 8)=="TradeLogUnlimitedUnlimited") then
            HideUIPanel(self);
            return;
        end
        return TradeLogUnlimited_SetHyperlink_Origin(self,link);
    end
    hooksecurefunc("SetItemRef", TradeLogUnlimitedFrame_SetItemRef);
end

function TradeLogUnlimitedFrame_CreateMinimapButton()
    local ldb = LibStub("LibDataBroker-1.1"):NewDataObject("TradeLogUnlimitedUnlimited", {
        type = "launcher",
        text = TRADE_LIST_TITLE,
        icon = [[Interface\MINIMAP\TRACKING\Banker]],
        --iconCoords = {0.1, 1.1, -0.06, 0.94},
        OnClick = function(self, button)
            if( TradeListFrame:IsVisible() ) then
                TradeListFrame:Hide();
            else
                TradeListFrame:Show();
            end
        end,
        OnTooltipShow = function(self)
            GameTooltip:AddLine(TRADE_LIST_TITLE);
            GameTooltip:AddLine(TRADE_LIST_DESC, nil, nil, nil, true);
            GameTooltip:Show()
        end,
    })
    TradeLogUnlimited_TradesHistory.minimapPos = TradeLogUnlimited_TradesHistory.minimapPos or 338
    LibDBIcon:Register("TradeLogUnlimitedUnlimited", ldb, TradeLogUnlimited_TradesHistory);
    if ( TradeLogUnlimited_TradesHistory.hideMinimapIcon ) then LibDBIcon:Hide("TradeLogUnlimitedUnlimited") end

    SLASH_TRADELOGUNLIMITEDICON1 = "/TradeLogUnlimited";
    SlashCmdList["TradeLogUnlimitedICON"] = function(msg)
        if  ( msg~="icon" ) then
            DEFAULT_CHAT_FRAME:AddMessage("Usage: '/TradeLogUnlimited icon' to toggle minimap icon")
        else
            TradeLogUnlimited_TradesHistory.hideMinimapIcon = not TradeLogUnlimited_TradesHistory.hideMinimapIcon
            if ( TradeLogUnlimited_TradesHistory.hideMinimapIcon ) then
                LibDBIcon:Hide("TradeLogUnlimited")
                DEFAULT_CHAT_FRAME:AddMessage("TradeLogUnlimited minimap icon disabled");
            else
                LibDBIcon:Show("TradeLogUnlimited")
                DEFAULT_CHAT_FRAME:AddMessage("TradeLogUnlimited minimap icon enabled");
            end
        end
    end
end


function TradeLogUnlimitedFrame_SetItemRef(link, text, button)
    if ( strsub(link, 1, 8) == "TradeLogUnlimited" ) then
        local id = 0+gsub(gsub(strsub(link,10),"/2","|"),"/1","/");
        if(id and TradeLogUnlimited_TradesHistory) then
            for _, v in ipairs(TradeLogUnlimited_TradesHistory) do
                if(v.id==id) then
                    TradeLogUnlimitedFrame_FillDetailLog(v);
                    TradeLogUnlimitedFrame:Show();
                    return;
                end
            end
        end
    end
end;

function TradeLogUnlimitedFrame_FillDetailLog(trade)
    --DEFAULT_CHAT_FRAME:AddMessage("|CFF00B4FF|HTradeLogUnlimited:"..TEXT(trade.id).."|h[TradeLogUnlimited]|h|r");
    MoneyFrame_Update("TradeLogUnlimitedRecipientMoneyFrame", trade.targetMoney);
    MoneyFrame_Update("TradeLogUnlimitedPlayerMoneyFrame", trade.playerMoney);

    TradeLogUnlimitedFramePlayerNameText:SetText(trade.player);
    TradeLogUnlimitedFrameRecipientNameText:SetText(trade.who);
    TradeLogUnlimitedFrameWhenWhereText:SetText(trade.when.." - "..trade.where);

    for i=1,7 do
        TradeLogUnlimitedFrame_UpdateItem(getglobal("TradeLogUnlimitedPlayerItem"..i), trade.playerItems[i]);
        TradeLogUnlimitedFrame_UpdateItem(getglobal("TradeLogUnlimitedRecipientItem"..i), trade.targetItems[i]);
    end
end

function TradeLogUnlimitedFrame_UpdateItem(frame, item)
    if(item) then
        TradeLogUnlimitedFrame_UpdateItemDetail(frame, item.name, item.texture, item.numItems, item.isUsable, item.enchantment, item.itemLink);
    else
        TradeLogUnlimitedFrame_UpdateItemDetail(frame);
    end
end

function TradeLogUnlimitedFrame_UpdateItemDetail(frame, name, texture, numItems, isUsable, enchantment, itemLink)
    local frameName = frame:GetName();
    local id = frame:GetID();
    local buttonText = getglobal(frameName.."Name");

    if(itemLink) then
        local found, _, itemString = string.find(itemLink, "^|%x+|H(.+)|h%[.+%]")
        frame.itemLink = itemString;
    end

    --ChatFrame1:AddMessage(itemLink, "\124", "\124\124"))
    -- See if its the enchant slot
    if ( id == 7 ) then
        if ( name ) then
            if ( enchantment ) then
                buttonText:SetText(GREEN_FONT_COLOR_CODE..enchantment..FONT_COLOR_CODE_CLOSE);
            else
                buttonText:SetText(HIGHLIGHT_FONT_COLOR_CODE..TRADEFRAME_NOT_MODIFIED_TEXT..FONT_COLOR_CODE_CLOSE);
            end
        else
            buttonText:SetText("");
        end

    else
        buttonText:SetText(name);
    end
    buttonText:SetTextHeight(12);
    TradeLogUnlimitedRecipientMoneyFrame:SetScale(0.9);
    TradeLogUnlimitedPlayerMoneyFrame:SetScale(0.9);
    local tradeItemButton = getglobal(frameName.."ItemButton");
    local tradeItem = frame;
    SetItemButtonTexture(tradeItemButton, texture);
    SetItemButtonCount(tradeItemButton, numItems);
    if ( isUsable or not name ) then
        SetItemButtonTextureVertexColor(tradeItemButton, 1.0, 1.0, 1.0);
        SetItemButtonNameFrameVertexColor(tradeItem, 1.0, 1.0, 1.0);
        SetItemButtonSlotVertexColor(tradeItem, 1.0, 1.0, 1.0);
    else
        SetItemButtonTextureVertexColor(tradeItemButton, 0.9, 0, 0);
        SetItemButtonNameFrameVertexColor(tradeItem, 0.9, 0, 0);
        SetItemButtonSlotVertexColor(tradeItem, 1.0, 0, 0);
    end
end

function TradeListScrollFrame_Update(self)
    local line,offset,count;

    count=0;
    if(TradeListOnlyCompleteCB:GetChecked()) then
        for _, v in ipairs(TradeLogUnlimited_TradesHistory) do
            if(v.result=="complete")then count=count+1 end
        end
    else
        count = table.getn(TradeLogUnlimited_TradesHistory);
    end

    FauxScrollFrame_Update(TradeListScrollFrame,count,15,16);

    if(not FauxScrollFrame_GetOffset(TradeListScrollFrame)) then
        offset = 1;
    else
        offset=FauxScrollFrame_GetOffset(TradeListScrollFrame)+1;
        if(TradeListOnlyCompleteCB:GetChecked()) then
            for k, v in ipairs(TradeLogUnlimited_TradesHistory) do
                if(v.result=="complete")then offset = offset - 1 end;
                if(offset == 0) then
                    offset = k;
                    break;
                end
            end
        end
    end
    line=1
    while line<=15 do
        if offset<=table.getn(TradeLogUnlimited_TradesHistory) then
            local trade=TradeLogUnlimited_TradesHistory[offset];
            if(not TradeListOnlyCompleteCB:GetChecked() or trade.result=="complete") then
                local _,_,month,day,hour,min = string.find(trade.when, "(%d+)-(%d+) (%d+):(%d+)")
                getglobal("TradeListFrameButton"..line).offset = offset;

                getglobal("TradeListFrameButton"..line.."Time"):SetText(month..TRADE_LOG_MONTH_SUFFIX..day..TRADE_LOG_DAY_SUFFIX.." "..hour..":"..min);
                getglobal("TradeListFrameButton"..line.."Target"):SetText(trade.who);
                getglobal("TradeListFrameButton"..line.."Zone"):SetText(trade.where);
                getglobal("TradeListFrameButton"..line.."Result"):SetText(TRADE_LOG_RESULT_TEXT_SHORT[trade.result]);
                getglobal("TradeListFrameButton"..line):Show();

                getglobal("TradeListFrameButton"..line.."SendMoneyIcon"):Hide();
                getglobal("TradeListFrameButton"..line.."SendItemIcon"):Hide();
                getglobal("TradeListFrameButton"..line.."SendItemNum"):Hide();
                getglobal("TradeListFrameButton"..line.."ReceiveMoneyIcon"):Hide();
                getglobal("TradeListFrameButton"..line.."ReceiveItemIcon"):Hide();
                getglobal("TradeListFrameButton"..line.."ReceiveItemNum"):Hide();

                if(trade.result=="complete")then
                    if(trade.playerMoney>0)then getglobal("TradeListFrameButton"..line.."SendMoneyIcon"):Show(); end
                    local numSend = 0;
                    for i=1,6 do if(trade.playerItems[i]) then numSend = numSend + 1 end end
                    if(numSend>0)then
                        getglobal("TradeListFrameButton"..line.."SendItemIcon"):Show();
                        getglobal("TradeListFrameButton"..line.."SendItemNum"):Show();
                        getglobal("TradeListFrameButton"..line.."SendItemNum"):SetText("x".. numSend);
                    end

                    if(trade.targetMoney>0)then getglobal("TradeListFrameButton"..line.."ReceiveMoneyIcon"):Show(); end
                    local numReceive = 0;
                    for i=1,6 do if(trade.targetItems[i]) then numReceive = numReceive + 1 end end
                    if(numReceive>0)then
                        getglobal("TradeListFrameButton"..line.."ReceiveItemIcon"):Show();
                        getglobal("TradeListFrameButton"..line.."ReceiveItemNum"):Show();
                        getglobal("TradeListFrameButton"..line.."ReceiveItemNum"):SetText("x".. numReceive);
                    end

                    getglobal("TradeListFrameButton"..line.."Time"   ):SetTextColor(1.0, .82, 0.0);
                    getglobal("TradeListFrameButton"..line.."Target" ):SetTextColor(1.0, 1.0, 1.0);
                    getglobal("TradeListFrameButton"..line.."Zone"   ):SetTextColor(1.0, 1.0, 1.0);
                    getglobal("TradeListFrameButton"..line.."Result" ):SetTextColor(1.0, 1.0, 1.0);
                elseif(trade.result=="cancelled")then
                    getglobal("TradeListFrameButton"..line.."Time"   ):SetTextColor(0.7, 0.4, 0.4);
                    getglobal("TradeListFrameButton"..line.."Target" ):SetTextColor(0.7, 0.4, 0.4);
                    getglobal("TradeListFrameButton"..line.."Zone"   ):SetTextColor(0.7, 0.4, 0.4);
                    getglobal("TradeListFrameButton"..line.."Result" ):SetTextColor(0.7, 0.4, 0.4);
                else
                    getglobal("TradeListFrameButton"..line.."Time"   ):SetTextColor(0.8, 0.3, 0.3);
                    getglobal("TradeListFrameButton"..line.."Target" ):SetTextColor(0.8, 0.3, 0.3);
                    getglobal("TradeListFrameButton"..line.."Zone"   ):SetTextColor(0.8, 0.3, 0.3);
                    getglobal("TradeListFrameButton"..line.."Result" ):SetTextColor(0.8, 0.3, 0.3);
                end

                line=line+1
            end
        else
            getglobal("TradeListFrameButton"..line):Hide();
            line=line+1
        end
        offset=offset+1
    end
end

StaticPopupDialogs["TRADE_LOG_CLEAR_HISTORY"] = {preferredIndex = 3,
    text = "CLEAR TRADE HISTORY",
    button1 = ACCEPT,
    button2 = CANCEL,
    whileDead = 1,
    OnShow = function(self)
        getglobal(self:GetName().."Text"):SetText(TRADE_LIST_CLEAR_CONFIRM);
    end,
    OnAccept = function(self)
        TradeLogUnlimited_KeepOnlyToday();
    end,
    timeout = 0,
    hideOnEscape = 1
};

function TradeLogUnlimited_KeepOnlyToday()
    local today = {
        month = date("%m"),
        day = date("%d"),
    }
    for k, v in ipairs(TradeLogUnlimited_TradesHistory) do
        local _,_,month,day,hour,min = string.find(v.when, "(%d+)-(%d+) (%d+):(%d+)");
        if(month==today.month and day==today.day)then
            local tmp = {}
            for i=k, table.getn(TradeLogUnlimited_TradesHistory) do
                table.insert(tmp, TradeLogUnlimited_TradesHistory[i]);
            end
            TradeLogUnlimited_TradesHistory = nil;
            TradeLogUnlimited_TradesHistory = tmp;
            TradeListScrollFrame_Update();
            return;
        end
    end

    TradeLogUnlimited_TradesHistory = nil;
    TradeLogUnlimited_TradesHistory = {};
    TradeListScrollFrame_Update();
end

function TradeListFrame_ShowDetail(trade)
    TradeLogUnlimitedFrame:Hide();
    if(trade.result=="complete")then
        TradeLogUnlimitedFrame_FillDetailLog(trade);
        TradeLogUnlimitedFrame:Show();
    end;
end
