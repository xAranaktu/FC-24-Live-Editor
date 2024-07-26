-- This script will change:
-- Age of all players
-- -- This script will linearly scale the ages of players
-- -- Players aged between 16 and 46 will be scaled to be between 16 and 26
-- -- Players aged 15 or younger will not be changed
-- -- Players aged 47 or older will be set to 26 yo (If exist)

require 'imports/other/helpers'


-- Define the age range for scaling
-- Calculation method:
-- y = (x - min_old_age) * ((max_new_age - min_new_age) / (max_old_age - min_old_age)) + min_new_age
-- for example:
-- Player aged 26,
-- y = (26 - 16) * ((26 - 16) / (46 - 16)) + 16
-- Here is a simple way to understand:
--   If a player reaches the age of 16 or above, in the following years, they will only age 1 year for every 3 years that pass.
-- y = (26 - 16) * ((26 - 16) / (46 - 16)) + 16
-- y =     10    * (    10    /     30   ) + 16
-- y =                     19.3333              ≈ 19
local min_old_age = 16
local max_old_age = 46
local min_new_age = 16
local max_new_age = 26

-- Get current date
local current_date = GetCurrentDate()

-- Get Players Table
local players_table = LE.db:GetTable("players")
local current_record = players_table:GetFirstRecord()

local birthdate = 0
local age = 0
local normalized_birthdate = DATE:new()

-- Iterate through all player records
while current_record > 0 do
    -- Get the birthdate of the player
    birthdate = players_table:GetRecordFieldValue(current_record, "birthdate")

    -- Convert birthdate to age
    local normalized_birthdate = DATE:new()
    normalized_birthdate:FromGregorianDays(birthdate)
    -- Calculate the age of the player
    local age = current_date.year - normalized_birthdate.year

    if age >= min_old_age and age <= max_old_age then
        -- If the player is aged between min_old_age and max_old_age, scale the age
        age = (age - min_old_age) * ((max_new_age - min_new_age) / (max_old_age - min_old_age)) + min_new_age
        age = math.floor(age)
    elseif age >= 47 then
        -- If the player is aged 47 or older, set the age to 26
        age = max_new_age
    end

    -- Calculate the new birthdate based on the scaled age
    normalized_birthdate.year = current_date.year - age
    birthdate = normalized_birthdate:ToGregorianDays()
    -- Set the new birthdate
    players_table:SetRecordFieldValue(current_record, "birthdate", birthdate)

    current_record = players_table:GetNextValidRecord()
end

MessageBox("Done", "Done")
