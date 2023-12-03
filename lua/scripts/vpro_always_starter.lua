require 'imports/career_mode/enums'
require 'imports/other/playstyles_enum'
FCECareerModeUserManager = require 'imports/career_mode/FCECareerModeUserManager'

-- Script that will keep your VPRO player in starting XI

function set_reputation() 
    local pap_mgr = GetManagerObjByTypeId(ENUM_FCEGameModesFCECareerModePlayAsPlayerManager)
    if (pap_mgr <= 0)   then return end
    
    local club_rep_offset = 0x1DC
    local nat_rep_offset = club_rep_offset + 0x4
    local club_role_offset = nat_rep_offset + 0x4
    local nat_role_offset = club_role_offset + 0x1
    
    MEMORY:WriteInt(pap_mgr + club_rep_offset, 300)
    MEMORY:WriteInt(pap_mgr + nat_rep_offset, 300)

    MEMORY:WriteBytes(pap_mgr + club_role_offset, { 3 })
    MEMORY:WriteBytes(pap_mgr + nat_role_offset, { 3 })
end

function handle_set_player_rep(events_manager, event_id, event)
    if (
        event_id == ENUM_CM_EVENT_MSG_USER_MATCH_COMPLETED or
        event_id == ENUM_CM_EVENT_MSG_USER_MATCH_COMPLETED_IN_TOURNAMENT or
        event_id == ENUM_CM_EVENT_MSG_USER_INTERNATIONAL_MATCH_COMPLETED or
        event_id == ENUM_CM_EVENT_MSG_ABOUT_TO_ENTER_PREMATCH or
        event_id == ENUM_CM_EVENT_MSG_ENTERED_HUB_FIRST_TIME or
        event_id == ENUM_CM_EVENT_MSG_POST_LOAD_PREPARE
    ) then
        set_reputation()
    end
end

AddEventHandler("post__CareerModeEvent", handle_set_player_rep)
