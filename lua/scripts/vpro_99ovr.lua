require 'imports/career_mode/enums'
require 'imports/other/playstyles_enum'

-- Script that will keep your VPRO player in player career mode at 99 OVR

-- You can change the ID if you want to apply that to other player
local VPRO_PLAYERID = 30999

-- Playstyles
-- you can find "IDs" in <YOUR_LIVE_EDITOR_DIR>\lua\libs\v2\imports\other\playstyles_enum.lua

-- Playstyles1 to apply (No limit here I think?)
local playstyles1 = ENUM_PLAYSTYLE1_POWER_SHOT + ENUM_PLAYSTYLE1_POWER_HEADER + ENUM_PLAYSTYLE1_RAPID

-- Playstyles2 to apply (No limit here I think?)
local playstyles2 = ENUM_PLAYSTYLE2_GK_QUICK_REFLEXES

-- Playstyle1+ (Only 1 will work)

local iconplaystyle1 = ENUM_PLAYSTYLE1_TRIVELA

-- Playstyle2+ (Only 1 will work)
local iconplaystyle2 = 0

-- DON'T CHANGE ANYTHING BELOW

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

function set_99ovr() 
    -- Get Players Table
    local players_table = LE.db:GetTable("players")
    local current_record = players_table:GetFirstRecord()
    local playerid = 0

    while current_record > 0 do
        playerid = players_table:GetRecordFieldValue(current_record, "playerid")
        if (playerid == VPRO_PLAYERID) then
           for j=1, #fields_to_edit do
                players_table:SetRecordFieldValue(current_record, fields_to_edit[j], 99)
            end

            -- Playstyles
            players_table:SetRecordFieldValue(current_record, "trait1", playstyles1)
            players_table:SetRecordFieldValue(current_record, "trait2", playstyles2)
            players_table:SetRecordFieldValue(current_record, "icontrait1", iconplaystyle1)
            players_table:SetRecordFieldValue(current_record, "icontrait2", iconplaystyle2)

            -- Clear Player modifier to not affect his ovr
            players_table:SetRecordFieldValue(current_record, "modifier", 0)
    
            -- 99 Potential
            players_table:SetRecordFieldValue(current_record, "potential", 99)

            SaveVPRO()
            return
        end

        current_record = players_table:GetNextValidRecord()
    end
    LOGGER:LogError(string.format("Can't find player %d to apply 99ovr", VPRO_PLAYERID))
end

function handle_vpro_reset(events_manager, event_id, event)
    -- Events that reset the vpro attributes
    if (
        event_id == ENUM_CM_EVENT_MSG_USER_MATCH_COMPLETED or
        event_id == ENUM_CM_EVENT_MSG_USER_MATCH_COMPLETED_IN_TOURNAMENT or
        event_id == ENUM_CM_EVENT_MSG_USER_INTERNATIONAL_MATCH_COMPLETED or
        event_id == ENUM_CM_EVENT_MSG_POST_LOAD_PREPARE
    ) then
        set_99ovr()
    end
end

AddEventHandler("post__CareerModeEvent", handle_vpro_reset)
