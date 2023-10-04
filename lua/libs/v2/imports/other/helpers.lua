DATE = require 'imports/core/date'
require 'imports/other/consts'

function GetPlayerPrimaryPositionName(pos_id)
    return CONST__PLAYER_PRIMARY_POS_NAME[pos_id] or "INVALID"
end

-- return FC::DATE (imports\core\date.lua)
function GetCurrentDate()
    local result = DATE:new()

    if not IsInCM() then return result end

    local career_calendar_table = LE.db:GetTable("career_calendar")
    local first_record = career_calendar_table:GetFirstRecord()
    local currdate = career_calendar_table:GetRecordFieldValue(first_record, "currdate")

    result:FromInt(currdate)

    return result
end
