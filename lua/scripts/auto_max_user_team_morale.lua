--- This script will keep yours players Morale at 99

require 'imports/career_mode/enums'
require 'imports/career_mode/helpers'


function MaxMorale__OnEvent(events_manager, event_id, event)
    if (
        event_id == ENUM_CM_EVENT_MSG_DAY_PASSED or                 -- Every Day
        event_id == ENUM_CM_EVENT_MSG_POST_LOAD_PREPARE             -- After save load
    ) then
        UserTeamSetPlayersMorale(99)
    end
end


AddEventHandler("post__CareerModeEvent", MaxMorale__OnEvent)

-- Insta exec if in CM
if IsInCM() then
    UserTeamSetPlayersMorale(99)
end
