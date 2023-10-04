-- Get Players Table
local players_table = LE.db:GetTable("players")
local current_record = players_table:GetFirstRecord()
local playerid = 0
local teamid = 0
local teamname = ""

while current_record > 0 do
    playerid = players_table:GetRecordFieldValue(current_record, "playerid")
    if (playerid < 280000) then
        teamid = GetTeamIdFromPlayerId(playerid)
        teamname = GetTeamName(teamid)
        LOGGER:LogInfo(string.format("%d;%d;%s", playerid, teamid, teamname))
    end

    current_record = players_table:GetNextValidRecord()
end

MessageBox("Done", "Done")