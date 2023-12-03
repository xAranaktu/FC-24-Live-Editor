-- This script will change squadrole for all players that are in your club
-- 1: Crucial
-- 2: Important
-- 3: Rotation
-- 4: Sporadic
-- 5: Prospect

local squadrole = 3 -- Rotation

-- Don't touch anything below
assert(IsInCM(), "Script must be executed in career mode")

-- Get Players Table
local career_playercontract_table = LE.db:GetTable("career_playercontract")
local current_record = career_playercontract_table:GetFirstRecord()

local playerid = 0
local contract_status = 0
local is_loaned_in = false

while current_record > 0 do
    contract_status = career_playercontract_table:GetRecordFieldValue(current_record, "contract_status")
    is_loaned_in = contract_status == 1 or contract_status == 3 or contract_status == 5
    
    -- Ignore players that are loaned in
    if not is_loaned_in then
        playerid = career_playercontract_table:GetRecordFieldValue(current_record, "playerid")

        SetSquadRole(playerid, squadrole)
        career_playercontract_table:SetRecordFieldValue(current_record, "playerrole", squadrole)
    end

    current_record = career_playercontract_table:GetNextValidRecord()
end

MessageBox("Done", "Done")