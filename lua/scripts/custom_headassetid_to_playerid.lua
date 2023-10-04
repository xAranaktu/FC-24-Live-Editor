--- This script can add/update headmodels from your mod manager
--- You need to edit "headmodels_map" by yourself, pattern is simple:
--- [playerid] = headassetid,
--- by default it updates these faces:
--- Messi 20801
--- Ronaldo 158023
--- Which in fact will just swap Messi face with Ronaldo face to demonstrate how the script works.
require 'imports/core/common'

local headmodels_map = {
    [158023] = 20801,   -- [Messi] = Ronaldo
    [20801] = 158023    -- [Ronaldo] = Messi
}

-- Get Players Table
local players_table = LE.db:GetTable("players")
local current_record = players_table:GetFirstRecord()

local updated_players = 0
local players_count = table_count(headmodels_map)

local playerid = 0
local headassetid = nil
while current_record > 0 do
    playerid = players_table:GetRecordFieldValue(current_record, "playerid")

    headassetid = headmodels_map[playerid]
    if (headassetid) then
        players_table:SetRecordFieldValue(current_record, "hashighqualityhead", 1)
        players_table:SetRecordFieldValue(current_record, "headclasscode", 0)
        players_table:SetRecordFieldValue(current_record, "headassetid", headassetid)

        updated_players = updated_players + 1
    end

    -- Break the loop if we already updated all players
    if (updated_players == players_count) then
        break
    end

    current_record = players_table:GetNextValidRecord()
end

MessageBox("Done", string.format("Edited %d players\n", updated_players))
