require 'imports/career_mode/helpers'

-- This script will log the name of the career event
-- You can use this to figure out what & when is happening

-- Example screenshot from a few days of simming:
-- https://i.imgur.com/alYWoSR.png

function log_career_mode_event(events_manager, event_id, event)
    LOGGER:LogInfo(string.format("Career Mode Event %d (%s)", event_id, GetCMEventNameByID(event_id)))
end


AddEventHandler("pre__CareerModeEvent", log_career_mode_event)