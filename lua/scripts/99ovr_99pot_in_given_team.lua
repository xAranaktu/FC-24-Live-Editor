--- This script will set players attributes on 99 and potential on 99 in given team
require 'imports/career_mode/helpers'
require 'imports/other/helpers'

-- CHANGE TEAMID
local teamid = 0

if teamid == 0 then
    MessageBox("Change TEAMID", "You need to change TEAMID in script")
    assert(false, "Change TEAMID")
end

-- For Career Mode
local user_team_playerids = GetUserSeniorTeamPlayerIDs()

-- Players that will be edited
local team_playerids = GetPlayerIDSForTeam(teamid)

-- Fields in Players Table in database that needs to be edited
local fields_to_edit = {
    -- GK
    "gkdiving",
    "gkhandling",
    "gkkicking",
    "gkpositioning",
    "gkreflexes",

    -- ATTACK
    "crossing",
    "finishing",
    "headingaccuracy",
    "shortpassing",
    "volleys",

    -- DEFENDING
    "defensiveawareness",
    "standingtackle",
    "slidingtackle",

    -- SKILL
    "dribbling",
    "curve",
    "freekickaccuracy",
    "longpassing",
    "ballcontrol",

    -- POWER
    "shotpower",
    "jumping",
    "stamina",
    "strength",
    "longshots",

    -- MOVEMENT
    "acceleration",
    "sprintspeed",
    "agility",
    "reactions",
    "balance",

    -- MENTALITY
    "aggression",
    "composure",
    "interceptions",
    "positioning",
    "vision",
    "penalties",

    "overallrating"
}

-- Get Players Table
local players_table = LE.db:GetTable("players")
local current_record = players_table:GetFirstRecord()
local count = 0

local has_dev_plan = false
local playerid = 0
while current_record > 0 do
    has_dev_plan = false
    playerid = players_table:GetRecordFieldValue(current_record, "playerid")

    if team_playerids[playerid] then
        -- In career mode developement plans has higher prio than players table
        -- Only userteam players
        if user_team_playerids[playerid] then
            has_dev_plan = PlayerHasDevelopementPlan(playerid)
        end
    
        -- Set all attributes to 1
        for j=1, #fields_to_edit do
            players_table:SetRecordFieldValue(current_record, fields_to_edit[j], 99)

            if (has_dev_plan) then 
                PlayerSetValueInDevelopementPlan(playerid, fields_to_edit[j], 99)
            end
        end
    
        -- Clear Player modifier to not affect his ovr
        players_table:SetRecordFieldValue(current_record, "modifier", 0)
    
        -- 99 Potential
        players_table:SetRecordFieldValue(current_record, "potential", 99)

        count = count + 1
    end

    current_record = players_table:GetNextValidRecord()
end

MessageBox("Done", string.format("Edited %d players\n", count))
