--- This script unlocks all boots

-- Get playerboots table
local boot_table = LE.db:GetTable("playerboots")
local current_record = boot_table:GetFirstRecord()

while current_record > 0 do
    boot_table:SetRecordFieldValue(current_record, "isavailableinstore", 1)

    current_record = boot_table:GetNextValidRecord()
end

MessageBox("Done", "Done")