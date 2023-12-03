require 'imports/career_mode/helpers'
require 'imports/other/helpers'

-- This script will automatically extend the contracts of all players, but not these in your team
-- 5 years by default

local extend_by = 5 -- 5 years

-- Don't touch anything below
-- For Career Mode
local user_team_playerids = GetUserSeniorTeamPlayerIDs()

-- Get Players Table
local players_table = LE.db:GetTable("players")
local current_record = players_table:GetFirstRecord()
local count = 0

local playerid = 0
while current_record > 0 do
    playerid = players_table:GetRecordFieldValue(current_record, "playerid")

    -- Update only players that are not in user team
    if user_team_playerids[playerid] == nil then
        local new_contractvaliduntil = players_table:GetRecordFieldValue(current_record, "contractvaliduntil")
    
        -- Can't go beyond this limit
        if new_contractvaliduntil > 2047 then 
            new_contractvaliduntil = 2047 
        end

        players_table:SetRecordFieldValue(current_record, "contractvaliduntil", new_contractvaliduntil)

        count = count + 1
    end

    current_record = players_table:GetNextValidRecord()
end

MessageBox("Done", string.format("Edited %d players\n", count))
