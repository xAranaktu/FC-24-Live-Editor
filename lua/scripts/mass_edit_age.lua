-- This script will change:
-- Age of all players
-- By default it will make all players 16 yo

require 'imports/other/helpers'


-- All players will be 16 you
-- Feel free to change 16 to any other number you want.
local new_age = 16


-- Don't touch anything below
local current_date = GetCurrentDate()

-- Get Players Table
local players_table = LE.db:GetTable("players")
local current_record = players_table:GetFirstRecord()

local birthdate = 0
local age = 0
local normalized_birthdate = DATE:new()
while current_record > 0 do
    birthdate = players_table:GetRecordFieldValue(current_record, "birthdate")

    normalized_birthdate:FromGregorianDays(birthdate)
    normalized_birthdate.year = current_date.year - new_age
    birthdate = normalized_birthdate:ToGregorianDays()

    players_table:SetRecordFieldValue(current_record, "birthdate", birthdate)

    current_record = players_table:GetNextValidRecord()
end

MessageBox("Done", "Done")
