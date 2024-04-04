-- Generate miniface for everyplayer in the user team
-- May take around 5 mins to complete, so be patient.

require 'imports/career_mode/helpers'
require 'imports/other/helpers'

-- Execute only if we are in career mode
if not IsInCM() then return end

-- Path is relative to the game installation directory
-- <default> means that the minifaces will be generated to your current Live Editor Mods directory (C:\FIFA 23 Live Editor\mods\root\Legacy\data\ui\imgAssets\heads if you didn't changed it')
PlayerCaptureSetOutputDirectory("<default>")

-- 0 - Head and shoulders
-- 1 - Head
-- 2 - Body
PlayerCaptureSetCamera(1)

-- 256x256
PlayerCaptureSetSize(256, 256)

-- Image Type
-- 0 - PNG
-- 1 - DDS
PlayerCaptureSetType(1)

-- We need goalkeepers to generate proper kit.
local goalkeepers = GetGoalkeepers()

local user_teamid = GetUserTeamID()

-- Get all rows for teamplayerlinks table
local teamplayerlinks_table = LE.db:GetTable("teamplayerlinks")
local teamplayerlinks_current_record = teamplayerlinks_table:GetFirstRecord()

local playerid = 0
while teamplayerlinks_current_record > 0 do
    if user_teamid == teamplayerlinks_table:GetRecordFieldValue(teamplayerlinks_current_record, "teamid") then
        playerid = teamplayerlinks_table:GetRecordFieldValue(teamplayerlinks_current_record, "playerid")
        PlayerCaptureAddPlayer(playerid, user_teamid, goalkeepers[playerid] ~= nil)
    end

    teamplayerlinks_current_record = teamplayerlinks_table:GetNextValidRecord()
end

-- Start Capturing
PlayerCaptureStart()
