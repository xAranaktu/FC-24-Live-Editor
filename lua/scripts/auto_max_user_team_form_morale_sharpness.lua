--- This script will keep yours players Form, Sharpness and Morale at 99

require 'imports/career_mode/enums'
require 'imports/career_mode/helpers'


function MaxFormSharpnessMorale__OnEvent(events_manager, event_id, event)
    if (
        event_id == ENUM_CM_EVENT_MSG_ABOUT_TO_ENTER_PREMATCH or    -- Before match
        event_id == ENUM_CM_EVENT_MSG_POST_LOAD_PREPARE             -- After save load
    ) then
        UserTeamSetPlayersFormSharpnessMorale(
            99,     -- Form
            99,     -- Sharpness
            99      -- Morale
        )
    end
end


AddEventHandler("post__CareerModeEvent", MaxFormSharpnessMorale__OnEvent)
