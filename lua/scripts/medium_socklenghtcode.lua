--- This script change socks length on medium

-- Get Players Table
local players_table = LE.db:GetTable("players")
local current_record = players_table:GetFirstRecord()

while current_record > 0 do
    players_table:SetRecordFieldValue(current_record, "socklengthcode", 0)

    current_record = players_table:GetNextValidRecord()
end

MessageBox("Done", "Done")
