local squad_sizes = {}

-- Get Teamplayerlinks Table
local teamplayerlinks = LE.db:GetTable("teamplayerlinks")
local current_record = teamplayerlinks:GetFirstRecord()
local teamid = 0

while current_record > 0 do
    teamid = teamplayerlinks:GetRecordFieldValue(current_record, "teamid")
    
    if squad_sizes[teamid] then
        squad_sizes[teamid] = squad_sizes[teamid] + 1
    else
        squad_sizes[teamid] = 1
    end

    current_record = teamplayerlinks:GetNextValidRecord()
end

for teamid,squadsize in pairs(squad_sizes) do
    if (squadsize <= 17) then
        print(string.format("Small Squad Size detected: Team %s ID: %d, players: %d", GetTeamName(teamid), teamid, squadsize))
    end
end

MessageBox("Done", "Done")
