--- This script unlocks all clothes for manager

-- Get table
local wc_table = LE.db:GetTable("wardrobecloset")
local current_record = wc_table:GetFirstRecord()

while current_record > 0 do
    wc_table:SetRecordFieldValue(current_record, "isavailableincustomizationmenu", 1)
    wc_table:SetRecordFieldValue(current_record, "isavailableinmanagercustomization", 1)

    current_record = wc_table:GetNextValidRecord()
end

MessageBox("Done", "Done")