require 'imports/career_mode/enums'
require 'imports/other/playstyles_enum'
FCECareerModeUserManager = require 'imports/career_mode/fcecareermodeusermanager'

-- Script that will give your player all playstyles in player career mode (Play As Player) and will reapply them after reset

-- Playstyles
-- you can find "IDs" in <YOUR_LIVE_EDITOR_DIR>\lua\libs\v2\imports\other\playstyles_enum.lua

-- Playstyles1 to apply
local playstyles1 = 1073741823

-- Playstyles2 to apply
-- It also includes hidden traits (except Injury Prone)
local playstyles2 = 1535 -- With GK playstyles, 1520 without GK playstyles

-- DON'T CHANGE ANYTHING BELOW
function set_allplaystyles() 
    local cm_user_mgr = FCECareerModeUserManager:new()

    local PAP_PlayerID = cm_user_mgr:GetPAPID()

    -- Get Players Table
    local players_table = LE.db:GetTable("players")
    local current_record = players_table:GetFirstRecord()
    local playerid = 0

    while current_record > 0 do
        playerid = players_table:GetRecordFieldValue(current_record, "playerid")
        if (playerid == PAP_PlayerID) then
            -- Playstyles
            players_table:SetRecordFieldValue(current_record, "trait1", playstyles1)
            players_table:SetRecordFieldValue(current_record, "icontrait1", playstyles1)
            
            players_table:SetRecordFieldValue(current_record, "trait2", playstyles2)
            players_table:SetRecordFieldValue(current_record, "icontrait2", playstyles2)
            return
        end

        current_record = players_table:GetNextValidRecord()
    end
    LOGGER:LogError(string.format("Can't find player %d to apply playstyles", PAP_PlayerID))
end

function handle_playstyles_reset(events_manager, event_id, event)
    -- Events that reset playstyles
    if (
        event_id == ENUM_CM_EVENT_MSG_USER_MATCH_COMPLETED or
        event_id == ENUM_CM_EVENT_MSG_USER_MATCH_COMPLETED_IN_TOURNAMENT or
        event_id == ENUM_CM_EVENT_MSG_USER_INTERNATIONAL_MATCH_COMPLETED or
        event_id == ENUM_CM_EVENT_MSG_ENTERED_HUB_FIRST_TIME or
        event_id == ENUM_CM_EVENT_MSG_POST_LOAD_PREPARE
    ) then
        set_allplaystyles()
    end
end

AddEventHandler("post__CareerModeEvent", handle_playstyles_reset)
