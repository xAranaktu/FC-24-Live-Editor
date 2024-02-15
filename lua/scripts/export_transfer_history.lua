-- This script will export current season transfer history to CSV.
-- The TRANSFER_HISTORY.csv file will be created on Desktop.
-- The game resets transfer history at the beginning of every season, so you need to run the script at the end of every season.

require 'imports/career_mode/enums'
require 'imports/career_mode/helpers'
require 'imports/other/helpers'

local desktop_path = string.format("%s\\Desktop", os.getenv('USERPROFILE'))
local current_date = GetCurrentDate()
local file_path = string.format("%s\\TRANSFER_HISTORY_%02d_%02d_%04d.csv", desktop_path, current_date.day, current_date.month, current_date.year)

-- Don't Touch
local columns = {
    "type",
    "date",
    "playerid",
    "exchangeplayerid",
    "teamfromid",
    "teamtoid",
    "playername",
    "exchangeplayername",
    "teamfromname",
    "teamtoname",
    "fee",
    "total_deal_value"
}

assert(IsInCM(), "Script must be executed in career mode")

function get_succeeded_ai_club_transfers(out, storage)
    -- size of each entry in this eastl::vector
    local obj_size = 0xB8

    -- playerid at 0x0
    -- buying_team at 0x4
    -- selling_team at 0x8
    -- seller_accepted at 0x6C
    -- buyer_accepted at 0x6D
    -- rlc_paid at 0x70

    local vec = MEMORY:ReadPointer(storage + 0x8) 
    local mBegin = MEMORY:ReadPointer(vec + 0x0) 
    local mEnd = MEMORY:ReadPointer(vec + 0x8)

    local current = mBegin
    while current < mEnd do
        local playerid =        MEMORY:ReadInt(current + 0x0)
        local buying_team =     MEMORY:ReadInt(current + 0x4)
        local selling_team =    MEMORY:ReadInt(current + 0x8)

        -- print(string.format("get_succeeded_ai_club_transfers %X %d %d %d", current, playerid, buying_team, selling_team))

        -- IsValid
        if (playerid > 0 and buying_team > 0 and selling_team > 0) then
            local seller_accepted = MEMORY:ReadBool(current + 0x6C)
            local buyer_accepted = MEMORY:ReadBool(current + 0x6D)

            -- Is Success
            if (seller_accepted or buyer_accepted) then 

                local final_fee = 0
                local exchange_value = 0
                if seller_accepted then
                    final_fee = MEMORY:ReadInt(MEMORY:ReadPointer(current + 0x28) - 0xC)
                else
                    local mLastReq = MEMORY:ReadPointer(current + 0x48)
                    final_fee = MEMORY:ReadInt(mLastReq - 0x14 + 0x0)
                    exchange_value = MEMORY:ReadInt(mLastReq - 0x14 + 0x8)
                end

                local key = string.format("T%d-%d-%d", playerid, buying_team, selling_team)
                out[key] = {
                    final_fee = final_fee,
                    exchange_value = exchange_value
                }

            end
        end

        current = current + obj_size
    end
end

function get_succeeded_user_club_transfers(out, storage)
    -- size of each entry in this eastl::vector
    local obj_size = 0xA0

    -- playerid at 0x0
    -- buying_team at 0x4
    -- selling_team at 0x8

    -- Offers at 0x18
    -- Requests at 0x38
    -- Actions at 0x58

    local vec = MEMORY:ReadPointer(storage + 0x28) 
    local mBegin = MEMORY:ReadPointer(vec + 0x0) 
    local mEnd = MEMORY:ReadPointer(vec + 0x8)

    local current = mBegin
    while current < mEnd do
        local playerid =        MEMORY:ReadInt(current + 0x0)
        local buying_team =     MEMORY:ReadInt(current + 0x4)
        local selling_team =    MEMORY:ReadInt(current + 0x8)

        -- print(string.format("get_succeeded_user_club_transfers %X %d %d %d", current, playerid, buying_team, selling_team))

        -- IsValid
        if (playerid > 0 and buying_team > 0 and selling_team > 0) then
            local mActionsBegin = MEMORY:ReadPointer(current + 0x58) 
            local mActionsEnd = MEMORY:ReadPointer(current + 0x60)

            -- Not empty
            if (mActionsBegin ~= mActionsEnd) then
                local last_action = MEMORY:ReadChar(mActionsEnd - 0xC + 0x8)
                local seller_accepted = last_action == 0
                local buyer_accepted = last_action == 4

                -- Is Success
                if (seller_accepted or buyer_accepted) then 
                    local final_fee = 0
                    local exchange_value = 0
                    local exchange_player = 0
                    if seller_accepted then
                        local mLastOff = MEMORY:ReadPointer(current + 0x20)
                        exchange_player = MEMORY:ReadInt(mLastOff - 0x30 + 0x0)
                        exchange_value = MEMORY:ReadInt(mLastOff - 0x30 + 0x4)
                        final_fee = MEMORY:ReadInt(mLastOff - 0x30 + 0xC)
                    else
                        local mLastReq = MEMORY:ReadPointer(current + 0x40)
                        exchange_player = MEMORY:ReadInt(mLastReq - 0x30 + 0x0)
                        exchange_value = MEMORY:ReadInt(mLastReq - 0x30 + 0x8)
                        final_fee = MEMORY:ReadInt(mLastReq - 0x30 + 0xC)
                    end

                    local key = string.format("T%d-%d-%d", playerid, buying_team, selling_team)
                    out[key] = {
                        final_fee = final_fee,
                        exchange_player = exchange_player,
                        exchange_value = exchange_value
                    }
                end
            end
        end

        current = current + obj_size
    end
end

function get_succeeded_ai_player_transfers(out, storage)
    -- size of each entry in this eastl::vector
    local obj_size = 0xB0

    -- playerid at 0x0
    -- buying_team at 0x4
    -- selling_team at 0x8

    -- buyer_accepted at 0xC
    -- seller_accepted at 0xF

    -- last action idx at 0x6C

    local vec = MEMORY:ReadPointer(storage + 0x10) 
    local mBegin = MEMORY:ReadPointer(vec + 0x0) 
    local mEnd = MEMORY:ReadPointer(vec + 0x8)

    local current = mBegin
    while current < mEnd do
        local playerid =        MEMORY:ReadInt(current + 0x0)
        local buying_team =     MEMORY:ReadInt(current + 0x4)
        local selling_team =    MEMORY:ReadInt(current + 0x8)

        -- print(string.format("get_succeeded_ai_player_transfers %X %d %d %d", current, playerid, buying_team, selling_team))

        -- IsValid
        if (playerid > 0 and buying_team > 0 and selling_team > 0) then
            local seller_accepted = MEMORY:ReadBool(current + 0xF)

            -- Is Success
            if (seller_accepted) then
                local last_action_idx = MEMORY:ReadInt(current + 0x6C)
                local last_action_date = MEMORY:ReadInt(current + 0x70 + (0xC * (last_action_idx - 1)))
                local key = string.format("T%d-%d-%d", playerid, buying_team, selling_team)
                out[key] = {
                    playerid = playerid,
                    buying_team = buying_team,
                    selling_team = selling_team,
                    date = last_action_date,
                    type = "transfer"
                }
            end
        end

        current = current + obj_size
    end
end

function get_succeeded_ai_player_exchanges(out, storage)
    -- size of each entry in this eastl::vector
    local obj_size = 0xB0

    -- playerid at 0x0
    -- buying_team at 0x4
    -- selling_team at 0x8

    -- buyer_accepted at 0xC
    -- seller_accepted at 0xF

    local vec = MEMORY:ReadPointer(storage + 0x10) 
    local mBegin = MEMORY:ReadPointer(vec + 0x0) 
    local mEnd = MEMORY:ReadPointer(vec + 0x8)

    local current = mBegin
    while current < mEnd do
        local playerid =        MEMORY:ReadInt(current + 0x0)
        local buying_team =     MEMORY:ReadInt(current + 0x4)
        local selling_team =    MEMORY:ReadInt(current + 0x8)

        -- print(string.format("get_succeeded_ai_player_exchanges %X %d %d %d", current, playerid, buying_team, selling_team))

        -- IsValid
        if (playerid > 0 and buying_team > 0 and selling_team > 0) then
            local seller_accepted = MEMORY:ReadBool(current + 0xF)

            -- Is Success
            if (seller_accepted) then
                local last_action_idx = MEMORY:ReadInt(current + 0x6C)
                local last_action_date = MEMORY:ReadInt(current + 0x70 + (0xC * (last_action_idx - 1)))
                local key = string.format("T%d-%d-%d", playerid, buying_team, selling_team)
                out[key] = {
                    playerid = playerid,
                    buying_team = buying_team,
                    selling_team = selling_team,
                    date = last_action_date,
                    type = "transfer"
                }
            end
        end

        current = current + obj_size
    end
end

function get_succeeded_user_player_transfers(out, storage)
    -- size of each entry in this eastl::vector
    local obj_size = 0x98

    -- playerid at 0x0
    -- buying_team at 0x4
    -- selling_team at 0x8

    -- Actions at 0x50

    local vec = MEMORY:ReadPointer(storage + 0x38) 
    local mBegin = MEMORY:ReadPointer(vec + 0x0) 
    local mEnd = MEMORY:ReadPointer(vec + 0x8)

    local current = mBegin
    while current < mEnd do
        local playerid =        MEMORY:ReadInt(current + 0x0)
        local buying_team =     MEMORY:ReadInt(current + 0x4)
        local selling_team =    MEMORY:ReadInt(current + 0x8)

        -- print(string.format("get_succeeded_user_player_transfers %X %d %d %d", current, playerid, buying_team, selling_team))

        -- IsValid
        if (playerid > 0 and buying_team > 0 and selling_team > 0) then
            local mActionsBegin = MEMORY:ReadPointer(current + 0x50) 
            local mActionsEnd = MEMORY:ReadPointer(current + 0x58)

            -- Not empty
            if (mActionsBegin ~= mActionsEnd) then
                local last_action = MEMORY:ReadChar(mActionsEnd - 0xC + 0x8)
                local seller_accepted = last_action == 0
                local buyer_accepted = last_action == 4
            
                if (seller_accepted or buyer_accepted) then
                    local last_action_date = MEMORY:ReadInt(mActionsEnd - 0xC + 0x0)
                    local key = string.format("T%d-%d-%d", playerid, buying_team, selling_team)
                    out[key] = {
                        playerid = playerid,
                        buying_team = buying_team,
                        selling_team = selling_team,
                        date = last_action_date,
                        type = "transfer"
                    }
                end
            end
        end

        current = current + obj_size
    end
end

function get_succeeded_user_player_exchanges(out, storage)
    -- size of each entry in this eastl::vector
    local obj_size = 0x98

    -- playerid at 0x0
    -- buying_team at 0x4
    -- selling_team at 0x8

    -- Actions at 0x50

    local vec = MEMORY:ReadPointer(storage + 0x48) 
    local mBegin = MEMORY:ReadPointer(vec + 0x0) 
    local mEnd = MEMORY:ReadPointer(vec + 0x8)

    local current = mBegin
    while current < mEnd do
        local playerid =        MEMORY:ReadInt(current + 0x0)
        local buying_team =     MEMORY:ReadInt(current + 0x4)
        local selling_team =    MEMORY:ReadInt(current + 0x8)

        -- IsValid
        if (playerid > 0 and buying_team > 0 and selling_team > 0) then
            local mActionsBegin = MEMORY:ReadPointer(current + 0x50) 
            local mActionsEnd = MEMORY:ReadPointer(current + 0x58)

            -- Not empty
            if (mActionsBegin ~= mActionsEnd) then
                local last_action = MEMORY:ReadChar(mActionsEnd - 0xC + 0x8)
                local seller_accepted = last_action == 0
                local buyer_accepted = last_action == 4
            
                if (seller_accepted or buyer_accepted) then
                    local last_action_date = MEMORY:ReadInt(mActionsEnd - 0xC + 0x0)
                    local key = string.format("T%d-%d-%d", playerid, buying_team, selling_team)
                    out[key] = {
                        playerid = playerid,
                        buying_team = buying_team,
                        selling_team = selling_team,
                        date = last_action_date,
                        type = "transfer"
                    }
                end
            end
        end

        current = current + obj_size
    end
end

function get_succeeded_ai_player_loans(out, storage)
    -- size of each entry in this eastl::vector
    local obj_size = 0x98

    -- playerid at 0x0
    -- buying_team at 0x4
    -- selling_team at 0x8

    -- seller_accepted at 0x50
    -- last action idx at 0x58

    local vec = MEMORY:ReadPointer(storage + 0x20) 
    local mBegin = MEMORY:ReadPointer(vec + 0x0) 
    local mEnd = MEMORY:ReadPointer(vec + 0x8)

    local current = mBegin
    while current < mEnd do
        local playerid =        MEMORY:ReadInt(current + 0x0)
        local buying_team =     MEMORY:ReadInt(current + 0x4)
        local selling_team =    MEMORY:ReadInt(current + 0x8)

        -- print(string.format("get_succeeded_ai_player_loans %X %d %d %d", current, playerid, buying_team, selling_team))

        -- IsValid
        if (playerid > 0 and buying_team > 0 and selling_team > 0) then
            local seller_accepted = MEMORY:ReadBool(current + 0x50)

            -- Is Success
            if (seller_accepted) then
                local last_action_idx = MEMORY:ReadInt(current + 0x58)
                local last_action_date = MEMORY:ReadInt(current + 0x5C + (0xC * (last_action_idx - 1)))
                local key = string.format("L%d-%d-%d", playerid, buying_team, selling_team)
                out[key] = {
                    playerid = playerid,
                    buying_team = buying_team,
                    selling_team = selling_team,
                    date = last_action_date,
                    type = "loan"
                }
            end
        end

        current = current + obj_size
    end
end

function get_succeeded_ai_club_loans(out, storage)
    -- size of each entry in this eastl::vector
    local obj_size = 0xC0

    -- playerid at 0x0
    -- buying_team at 0x4
    -- selling_team at 0x8
    -- seller_accepted at 0x78
    -- buyer_accepted at 0x79

    local vec = MEMORY:ReadPointer(storage + 0x18) 
    local mBegin = MEMORY:ReadPointer(vec + 0x0) 
    local mEnd = MEMORY:ReadPointer(vec + 0x8)

    local current = mBegin
    while current < mEnd do
        local playerid =        MEMORY:ReadInt(current + 0x0)
        local buying_team =     MEMORY:ReadInt(current + 0x4)
        local selling_team =    MEMORY:ReadInt(current + 0x8)

        -- print(string.format("get_succeeded_ai_club_loans %X %d %d %d", current, playerid, buying_team, selling_team))

        -- IsValid
        if (playerid > 0 and buying_team > 0 and selling_team > 0) then
            local seller_accepted = MEMORY:ReadBool(current + 0x78)
            local buyer_accepted = MEMORY:ReadBool(current + 0x79)

            -- Is Success
            if (seller_accepted or buyer_accepted) then 
                local key = string.format("L%d-%d-%d", playerid, buying_team, selling_team)
                out[key] = {
                    final_fee = 0
                }
            end
        end

        current = current + obj_size
    end
end

function get_succeeded_user_club_loans(out, storage)
    -- size of each entry in this eastl::vector
    local obj_size = 0xF8

    -- playerid at 0x0
    -- buying_team at 0x4
    -- selling_team at 0x8
    -- seller_accepted at 0x78
    -- buyer_accepted at 0x79

    local vec = MEMORY:ReadPointer(storage + 0x30) 
    local mBegin = MEMORY:ReadPointer(vec + 0x0) 
    local mEnd = MEMORY:ReadPointer(vec + 0x8)

    local current = mBegin
    while current < mEnd do
        local playerid =        MEMORY:ReadInt(current + 0x0)
        local buying_team =     MEMORY:ReadInt(current + 0x4)
        local selling_team =    MEMORY:ReadInt(current + 0x8)

        -- IsValid
        if (playerid > 0 and buying_team > 0 and selling_team > 0) then
            local seller_accepted = MEMORY:ReadBool(current + 0x78)
            local buyer_accepted = MEMORY:ReadBool(current + 0x79)

            -- Is Success
            if (seller_accepted or buyer_accepted) then 
                local key = string.format("L%d-%d-%d", playerid, buying_team, selling_team)
                out[key] = {
                    final_fee = 0
                }
            end
        end

        current = current + obj_size
    end
end

local transfer_mgr = GetManagerObjByTypeId(ENUM_FCEGameModesFCECareerModeTransferManager)
assert(transfer_mgr ~= 0, "Cant find FCEGameModesFCECareerModeTransferManager")

-- NegotiationsStorage at 0x1A70
local neg_storage = MEMORY:ReadPointer(transfer_mgr + 0x1A70)

local player_negos = {}
local club_negos = {}

get_succeeded_ai_player_transfers(player_negos, neg_storage)
get_succeeded_ai_player_exchanges(player_negos, neg_storage)

get_succeeded_ai_player_loans(player_negos, neg_storage)

get_succeeded_user_player_transfers(player_negos, neg_storage)
get_succeeded_user_player_exchanges(player_negos, neg_storage)

get_succeeded_ai_club_transfers(club_negos, neg_storage)
get_succeeded_ai_club_loans(club_negos, neg_storage)

get_succeeded_user_club_transfers(club_negos, neg_storage)
get_succeeded_user_club_loans(club_negos, neg_storage)

local file = io.open(file_path, "w+")
io.output(file)
io.write(table.concat(columns, ","))
io.write("\n")

for key, player_nego in pairs(player_negos) do
    local club_nego = club_negos[key] or {}

    local row = {}
    for i=1, #columns do
        local colname = columns[i]
        local v = ""

        if colname == "playername" then
            v = GetPlayerName(player_nego.playerid)
        elseif colname == "exchangeplayername" then
            if (club_nego.exchange_player and club_nego.exchange_player > 0) then
                v = GetPlayerName(club_nego.exchange_player)
            else
                v = " "
            end
        elseif colname == "exchangeplayerid" then
            v = club_nego.exchange_player or " "
        elseif colname == "teamfromid" then
            v = player_nego.selling_team
        elseif colname == "teamtoid" then
            v = player_nego.buying_team
        elseif colname == "teamfromname" then
            v = GetTeamName(player_nego.selling_team)
        elseif colname == "teamtoname" then
            v = GetTeamName(player_nego.buying_team)
        elseif colname == "fee" then
            v = club_nego.final_fee or 0
        elseif colname == "total_deal_value" then
            v = (club_nego.final_fee or 0) + (club_nego.exchange_value or 0)
        else 
            v = player_nego[colname]
        end

        table.insert(row, v)
    end
    io.write(table.concat(row, ","))
    io.write("\n")
end

io.close(file)

LOGGER:LogInfo("Done")