-- This script will print out all kit numbers used by players in given team

-- Change the ID to team you want to check
local teamid = 1

-- Get Teamplayerlinks Table
local teamplayerlinks_table = LE.db:GetTable("teamplayerlinks")
local current_record = teamplayerlinks_table:GetFirstRecord()

local playername = ""
local number = ""

while current_record > 0 do
    if (teamid == teamplayerlinks_table:GetRecordFieldValue(current_record, "teamid")) then
        playername = GetPlayerName(teamplayerlinks_table:GetRecordFieldValue(current_record, "playerid"))
        number = teamplayerlinks_table:GetRecordFieldValue(current_record, "jerseynumber")

        LOGGER:LogInfo(string.format("Number: %d, Player: %s", number, playername))
    end

    current_record = teamplayerlinks_table:GetNextValidRecord()
end

MessageBox("Done", "Done")
