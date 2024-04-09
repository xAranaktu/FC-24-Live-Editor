--- This script will delete all generated players

-- Get Players Table
local players_table = LE.db:GetTable("players")
local current_record = players_table:GetFirstRecord()
local playerid = 0
while current_record > 0 do
    playerid = players_table:GetRecordFieldValue(current_record, "playerid") 
    if (playerid>= 280000) then
        DeletePlayer(playerid, 0)
    end

    current_record = players_table:GetNextValidRecord()
end

MessageBox("Done", "Done")
