require 'imports/services/enums'
FCECareerModeUserManager = require 'imports/career_mode/fcecareermodeusermanager'

-- You can change the ID if you want to apply that to other player
local cm_user_mgr = FCECareerModeUserManager:new()

local VPRO_PLAYERID = cm_user_mgr:GetPAPID()
local nationality_id = 27 -- Italy

-- Get Players Table
local players_table = LE.db:GetTable("players")
local current_record = players_table:GetFirstRecord()
local playerid = 0

while current_record > 0 do
    playerid = players_table:GetRecordFieldValue(current_record, "playerid")
    if (playerid == VPRO_PLAYERID) then
        players_table:SetRecordFieldValue(current_record, "nationality", nationality_id)

        -- Write new nationality in VProService
        if (VPRO_PLAYERID = 30999) {
            MEMORY:WriteShort(
                MEMORY:ReadPointer(GetPlugin(ENUM_djb2VProServiceVPRO_CLSS) + 0x18) + 0x343D4,
                nationality_id
            )
        }

        break
    end

    current_record = players_table:GetNextValidRecord()
end