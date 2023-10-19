-- Generate miniface for everyplayer with real face model in playable league.
-- THIS WILL TAKE A WHILE TO COMPLETE, like around 10h...
-- and... if the game will crash (which is very possible) you will have to start from beginning...

-- Execute only if we are in career mode
if not IsInCM() then return end

-- List of teams that cause game crashes or other problems
local BLACKLISTED_TEAMS = {
    [112264] = true         -- YOUTH ACADEMY
}

-- List of leagues that we want to skip
local BLACKLISTED_LEAGUES = {
    [78] = true,            -- International
    [2136] = true,          -- International Women
    [76] = true,            -- Rest of World
    [383] = true,           -- Create Player League
    [2028] = true           -- Youth Squad League
}

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

-- Get all rows for leagueteamlinks table
local leagueteamlinks_table = LE.db:GetTable("leagueteamlinks")
local leagueteamlinks_current_record = leagueteamlinks_table:GetFirstRecord()

local leagueid = 0
local teamid = 0
while leagueteamlinks_current_record > 0 do
    leagueid = leagueteamlinks_table:GetRecordFieldValue(leagueteamlinks_current_record, "leagueid")

    if BLACKLISTED_LEAGUES[leagueid] then
        teamid = leagueteamlinks_table:GetRecordFieldValue(leagueteamlinks_current_record, "teamid")
        BLACKLISTED_TEAMS[teamid] = true
    end

    leagueteamlinks_current_record = leagueteamlinks_table:GetNextValidRecord()
end

-- Get all rows for teamplayerlinks table
local teamplayerlinks_table = LE.db:GetTable("teamplayerlinks")
local teamplayerlinks_current_record = teamplayerlinks_table:GetFirstRecord()

local playerid = 0
local player_teams = {}
while teamplayerlinks_current_record > 0 do
    teamid = teamplayerlinks_table:GetRecordFieldValue(teamplayerlinks_current_record, "teamid")
    if not BLACKLISTED_TEAMS[teamid] then
        playerid = teamplayerlinks_table:GetRecordFieldValue(teamplayerlinks_current_record, "playerid")
        player_teams[playerid] = teamid
    end

    teamplayerlinks_current_record = teamplayerlinks_table:GetNextValidRecord()
end

-- Get all rows for players table
local players_table = LE.db:GetTable("players")
local players_current_record = players_table:GetFirstRecord()

local player_gen_count = 0
local headassetid = 0
local headclasscode = 0
while players_current_record > 0 do
    playerid = players_table:GetRecordFieldValue(players_current_record, "playerid")
    headassetid = players_table:GetRecordFieldValue(players_current_record, "headassetid")
    headclasscode = players_table:GetRecordFieldValue(players_current_record, "headclasscode")
    
    if headassetid > 0 and headclasscode == 0 then
        teamid = player_teams[playerid]
    
        if teamid then
            PlayerCaptureAddPlayer(headassetid, teamid)
        end
    end

    players_current_record = players_table:GetNextValidRecord()
end

-- Start Capturing
PlayerCaptureStart()
