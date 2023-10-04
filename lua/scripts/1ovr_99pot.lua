--- This script will set ALL players attributes on 1 and potential on 99
require 'imports/career_mode/helpers'


local user_team_playerids = {}

-- Check if we are in Career Mode
local bIsInCM = IsInCM();

if bIsInCM then
    user_team_playerids = GetUserSeniorTeamPlayerIDs()
end

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
    playerid = players_table:GetRecordFieldValue(current_record, "playerid")
    
    -- In career mode developement plans has higher prio than players table
    -- Only userteam players
    if user_team_playerids[playerid] then
        has_dev_plan = PlayerHasDevelopementPlan(playerid)
    end
    
    -- Set all attributes to 1
    for j=1, #fields_to_edit do
        players_table:SetRecordFieldValue(current_record, fields_to_edit[j], 1)

        if (has_dev_plan) then 
            PlayerSetValueInDevelopementPlan(playerid, fields_to_edit[j], 1)
        end
    end
    
    -- Clear Player modifier to not affect his ovr
    players_table:SetRecordFieldValue(current_record, "modifier", 0)
    
    -- 99 Potential
    players_table:SetRecordFieldValue(current_record, "potential", 99)

    count = count + 1
    current_record = players_table:GetNextValidRecord()
end

MessageBox("Done", string.format("Edited %d players\n", count))
