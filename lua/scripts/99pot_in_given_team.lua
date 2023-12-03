--- This script will set players potential on 99 in given team
require 'imports/career_mode/helpers'
require 'imports/other/helpers'

-- CHANGE TEAMID
local teamid = 0

if teamid == 0 then
    MessageBox("Change TEAMID", "You need to change TEAMID in script")
    assert(false, "Change TEAMID")
end

-- Players that will be edited
local team_playerids = GetPlayerIDSForTeam(teamid)

-- Get Players Table
local players_table = LE.db:GetTable("players")
local current_record = players_table:GetFirstRecord()
local count = 0

local playerid = 0
while current_record > 0 do
    playerid = players_table:GetRecordFieldValue(current_record, "playerid")

    if team_playerids[playerid] then
        -- 99 Potential
        players_table:SetRecordFieldValue(current_record, "potential", 99)

        count = count + 1
    end

    current_record = players_table:GetNextValidRecord()
end

MessageBox("Done", string.format("Edited %d players\n", count))
