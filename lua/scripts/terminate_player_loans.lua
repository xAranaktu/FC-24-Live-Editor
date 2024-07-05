--- This script will terminate all player loans

-- Get playerloans Table
local playerloans_table = LE.db:GetTable("playerloans")
local current_record = playerloans_table:GetFirstRecord()

while current_record > 0 do
    TerminateLoan(playerloans_table:GetRecordFieldValue(current_record, "playerid"))

    current_record = playerloans_table:GetNextValidRecord()
end

MessageBox("Done", "Done")
