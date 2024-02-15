local squad_sizes = {}
local player_position = {}

-- Get players Table
local players = LE.db:GetTable("players")
local current_record = players:GetFirstRecord()
local playerid = 0
local preferredposition1 = 0

while current_record > 0 do
    playerid = players:GetRecordFieldValue(current_record, "playerid")
    preferredposition1 = players:GetRecordFieldValue(current_record, "preferredposition1")

    player_position[playerid] = preferredposition1

    current_record = players:GetNextValidRecord()
end

-- Get Teamplayerlinks Table
local teamplayerlinks = LE.db:GetTable("teamplayerlinks")
current_record = teamplayerlinks:GetFirstRecord()

local teamid = 0
local player_preferredposition = 0

while current_record > 0 do
    playerid = teamplayerlinks:GetRecordFieldValue(current_record, "playerid")
    teamid = teamplayerlinks:GetRecordFieldValue(current_record, "teamid")

    if squad_sizes[teamid] == nil then
        squad_sizes[teamid] = {
            player_count    =   0,
            goalkeepers     =   0,
            defenders       =   0,
            midfielders     =   0,
            attackers       =   0
        }
    end

    player_preferredposition = player_position[playerid]
    squad_sizes[teamid].player_count = squad_sizes[teamid].player_count + 1

    if player_preferredposition == 0 then
        squad_sizes[teamid].goalkeepers = squad_sizes[teamid].goalkeepers + 1
    elseif player_preferredposition >= 1 and player_preferredposition <= 8 then
        squad_sizes[teamid].defenders = squad_sizes[teamid].defenders + 1
    elseif player_preferredposition >= 9 and player_preferredposition <= 19 then
        squad_sizes[teamid].midfielders = squad_sizes[teamid].midfielders + 1
    else
        squad_sizes[teamid].attackers = squad_sizes[teamid].attackers + 1
    end

    current_record = teamplayerlinks:GetNextValidRecord()
end

for teamid,squadsize in pairs(squad_sizes) do
    if squadsize.player_count <= 17 then
        print(string.format("Small Squad Size detected: Team %s ID: %d, players: %d", GetTeamName(teamid), teamid, squadsize.player_count))
    end

    if squadsize.goalkeepers == 0 then
        print(string.format("Found team without goalkeepers. %s ID: %d", GetTeamName(teamid), teamid))
    end
end

MessageBox("Done", "Done")
