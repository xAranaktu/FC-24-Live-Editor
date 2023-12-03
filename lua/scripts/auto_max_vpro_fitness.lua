--- This script will keep your player fitness at 100 in player career mode

require 'imports/career_mode/enums'
require 'imports/career_mode/helpers'
FCECareerModeUserManager = require 'imports/career_mode/FCECareerModeUserManager'

function MaxVPROFitness__OnEvent(events_manager, event_id, event)
    if (
        event_id == ENUM_CM_EVENT_MSG_ABOUT_TO_ENTER_PREMATCH or    -- Before match
        event_id == ENUM_CM_EVENT_MSG_POST_LOAD_PREPARE             -- After save load
    ) then
        local cm_user_mgr = FCECareerModeUserManager:new()
        
        SetPlayerFitness(cm_user_mgr:GetPAPID(), 99)
    end
end


AddEventHandler("post__CareerModeEvent", MaxVPROFitness__OnEvent)