local DB = require 'imports/t3db/db'
if database == nil then
    database = DB:new()
    database:Load()
end

local table = database:GetTable("players")
local current_record = table:GetFirstRecord()

local count = 0


Log("time_start")
local time_start = os.clock()
while current_record > 0 do
    count = count + 1
    current_record = table:GetNextValidRecord()
end

LOGGER:LogInfo(string.format("%d rows in players in %.5fs", count, os.clock()-time_start))