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

function CalculatePlayerAge(current_date, birthdate)
    local age = current_date.year - birthdate.year

    if (current_date.month < birthdate.month or (current_date.month == birthdate.month and current_date.day < birthdate.day)) then
        age = age - 1
    end
    return age
end


function GetPlayerIDSForTeam(teamid)
    local result = {}
    if teamid <= 0 then return result end

    local teamplayerlinks_table = LE.db:GetTable("teamplayerlinks")

    local current_record = teamplayerlinks_table:GetFirstRecord()
    while current_record > 0 do
        local artificialkey = teamplayerlinks_table:GetRecordFieldValue(current_record, "artificialkey")

        if artificialkey > 0 and teamid == teamplayerlinks_table:GetRecordFieldValue(current_record, "teamid") then
            local playerid = teamplayerlinks_table:GetRecordFieldValue(current_record, "playerid")
            result[playerid] = true
            -- Log(string.format("%d", playerid))
        end
        current_record = teamplayerlinks_table:GetNextValidRecord()
    end

    return result
end

