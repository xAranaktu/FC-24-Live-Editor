require 'imports/core/common'
require 'imports/career_mode/enums'
require 'imports/career_mode/consts'

-- Get FCE Career Mode Manager object.
-- Type ID in lua\libs\v2\imports\career_mode\enums.lua (ENUM_FCEGameModes)
function GetManagerObjByTypeId(type_id)
    if type(type_id) ~= "number" then
        LOGGER:LogError("GetManagerObjByTypeId passed type_id is not a number!")
        return 0
    end

    local result = 0

    local comm_impl = GetPlugin(ENUM_djb2FeFceGMCommServiceInterface_CLSS)
    if (comm_impl <= 0)  then return 0 end
    
    local mode_managers = MEMORY:ReadMultilevelPointer(comm_impl, {0x20, 0x10})
    local mode_manager = mode_managers + (0x20 * type_id)
    
    -- Check if there is any instance
    if (MEMORY:ReadInt(mode_manager + 0x10) ~= 1) then
        return 0
    end
    
    local mode_manager_type = MEMORY:ReadPointer(mode_manager + 0x8)
    -- Check count
    if (MEMORY:ReadInt(mode_manager_type + 0x10) ~= 1) then
        return 0
    end
    
    result = MEMORY:ReadMultilevelPointer(mode_manager, {0x18, 0x0})

    return result
end

function SetSquadRole(playerid, role)
    local player_status_mgr = GetManagerObjByTypeId(ENUM_FCEGameModesFCECareerModePlayerStatusManager)

    local PLAYERROLE_STRUCT = {
        mPlayerID = 0x0,
        mRole = 0x4,

        mSize = 0x8
    }

    local vec_begin_offset = 0x18
    local vec_end_offset = vec_begin_offset + 0x8

    local _start = MEMORY:ReadPointer(player_status_mgr + vec_begin_offset)
    local _end = MEMORY:ReadPointer(player_status_mgr + vec_end_offset)
    if (not _start) or (not _end) then return end

    local _max = 55
    local current_addr = _start
    local player_found = false
    for i=1, _max do
       if current_addr >= _end then return end

       if (playerid == MEMORY:ReadInt(current_addr + PLAYERROLE_STRUCT.mPlayerID)) then
            MEMORY:WriteInt(current_addr + PLAYERROLE_STRUCT.mRole, role)
            return
       end

       current_addr = current_addr + PLAYERROLE_STRUCT.mSize
    end
end

function GetCMEventNameByID(event_id)
    return CONST_CM_EVENTS_NAMES[event_id] or string.format("EVENT_%d", event_id)
end

function GetUserTeamID()
    if not IsInCM() then return 0 end

    local career_users_table = LE.db:GetTable("career_users")
    local first_record = career_users_table:GetFirstRecord()

    return career_users_table:GetRecordFieldValue(first_record, "clubteamid")
end

function GetUserNationalTeamID()
    if not IsInCM() then return 0 end

    local career_users_table = LE.db:GetTable("career_users")
    local first_record = career_users_table:GetFirstRecord()

    return career_users_table:GetRecordFieldValue(first_record, "nationalteamid")
end

function GetUserSeniorTeamPlayerIDs()
    local result = {}
    if not IsInCM() then return result end

    local user_teamid = GetUserTeamID()

    -- From this table should be the quickest I guess
    local career_playercontract_table = LE.db:GetTable("career_playercontract")
    local current_record = career_playercontract_table:GetFirstRecord()
    while current_record > 0 do
        local teamid = career_playercontract_table:GetRecordFieldValue(current_record, "teamid")
        if teamid == user_teamid then
            local playerid = career_playercontract_table:GetRecordFieldValue(current_record, "playerid")
            result[playerid] = true
            -- Log(string.format("%d", playerid))
        end
        current_record = career_playercontract_table:GetNextValidRecord()
    end

    return result
end

function UserTeamSetPlayersForm(v)
    local bIsInCM = IsInCM()
    if not bIsInCM then return end

    local user_team_playerids = GetUserSeniorTeamPlayerIDs()
    local players_count = table_count(user_team_playerids)
    local updated_players = 0

    -- Get Players Table
    local players_table = LE.db:GetTable("players")
    local current_record = players_table:GetFirstRecord()
    
    local playerid = 0
    while current_record > 0 do
        playerid = players_table:GetRecordFieldValue(current_record, "playerid")
        if user_team_playerids[playerid] then
            SetPlayerForm(playerid, v)
            updated_players = updated_players + 1
        end

        if (updated_players == players_count) then
            return
        end

        current_record = players_table:GetNextValidRecord()
    end
end

function UserTeamSetPlayersSharpness(v)
    local bIsInCM = IsInCM()
    if not bIsInCM then return end

    local user_team_playerids = GetUserSeniorTeamPlayerIDs()
    local players_count = table_count(user_team_playerids)
    local updated_players = 0

    -- Get Players Table
    local players_table = LE.db:GetTable("players")
    local current_record = players_table:GetFirstRecord()
    
    local playerid = 0
    while current_record > 0 do
        playerid = players_table:GetRecordFieldValue(current_record, "playerid")
        if user_team_playerids[playerid] then
            SetPlayerSharpness(playerid, v)
            updated_players = updated_players + 1
        end

        if (updated_players == players_count) then
            return
        end

        current_record = players_table:GetNextValidRecord()
    end
end

function UserTeamSetPlayersMorale(v)
    local bIsInCM = IsInCM()
    if not bIsInCM then return end

    local user_team_playerids = GetUserSeniorTeamPlayerIDs()
    local players_count = table_count(user_team_playerids)
    local updated_players = 0

    -- Get Players Table
    local players_table = LE.db:GetTable("players")
    local current_record = players_table:GetFirstRecord()
    
    local playerid = 0
    while current_record > 0 do
        playerid = players_table:GetRecordFieldValue(current_record, "playerid")
        if user_team_playerids[playerid] then
            SetPlayerMorale(playerid, v)
            updated_players = updated_players + 1
        end

        if (updated_players == players_count) then
            return
        end

        current_record = players_table:GetNextValidRecord()
    end
end

function UserTeamSetPlayersFormSharpnessMorale(v_form, v_sharpness, v_morale)
    local bIsInCM = IsInCM()
    if not bIsInCM then return end

    local user_team_playerids = GetUserSeniorTeamPlayerIDs()
    local players_count = table_count(user_team_playerids)
    local updated_players = 0

    -- Get Players Table
    local players_table = LE.db:GetTable("players")
    local current_record = players_table:GetFirstRecord()
    
    local playerid = 0
    while current_record > 0 do
        playerid = players_table:GetRecordFieldValue(current_record, "playerid")
        if user_team_playerids[playerid] then
            SetPlayerForm(playerid, v_form)
            SetPlayerSharpness(playerid, v_sharpness)
            SetPlayerMorale(playerid, v_morale)
            updated_players = updated_players + 1
        end

        if (updated_players == players_count) then
            return
        end

        current_record = players_table:GetNextValidRecord()
    end
end

function UserTeamSetPlayersFitness(v_fitness)
    local bIsInCM = IsInCM()
    if not bIsInCM then return end

    local user_team_playerids = GetUserSeniorTeamPlayerIDs()
    local players_count = table_count(user_team_playerids)
    local updated_players = 0

    -- Get Players Table
    local players_table = LE.db:GetTable("players")
    local current_record = players_table:GetFirstRecord()
    
    local playerid = 0
    while current_record > 0 do
        playerid = players_table:GetRecordFieldValue(current_record, "playerid")
        if user_team_playerids[playerid] then
            SetPlayerFitness(playerid, v_fitness)
            updated_players = updated_players + 1
        end

        if (updated_players == players_count) then
            return
        end

        current_record = players_table:GetNextValidRecord()
    end
end

