require 'imports/core/common'

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

