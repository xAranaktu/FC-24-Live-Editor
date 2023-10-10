-- This script will automatically extend the contracts of players in your team
-- 4 years by default

require 'imports/other/helpers'

local new_contract_length = 12 * 4 -- 4 years

-- Don't Touch anything below
assert(IsInCM(), "Script must be executed in career mode")

function update_contractvaliduntil(contracts)
    local contracts_to_update = 0
    local updated_contracts = 0

    for playerid, contractvaliduntil in pairs(contracts) do
        contracts_to_update = contracts_to_update + 1
    end

    -- Get Players Table
    local players_table = LE.db:GetTable("players")
    local current_record = players_table:GetFirstRecord()

    local playerid = 0
    local contractvaliduntil = nil
    while current_record > 0 do
        if updated_contracts >= contracts_to_update then
            break
        end

        playerid = players_table:GetRecordFieldValue(current_record, "playerid")

        contractvaliduntil = contracts[playerid]
        if contractvaliduntil ~= nil then
            players_table:SetRecordFieldValue(current_record, "contractvaliduntil", contractvaliduntil)
            updated_contracts = updated_contracts + 1
        end
    
        current_record = players_table:GetNextValidRecord()
    end

    local failed_to_update = contracts_to_update - updated_contracts
    
    if failed_to_update > 0 then
        Log(string.format("Failed to update %d contracts", failed_to_update))
    end
    
    Log(string.format("Updated Contracts: %d", updated_contracts))
end

function update_contracts()
    local result = {}

    local currentdate = GetCurrentDate()
    local int_current_date = currentdate:ToInt()

    -- Get career_playercontract Table
    local career_playercontract_table = LE.db:GetTable("career_playercontract")
    local current_record = career_playercontract_table:GetFirstRecord()

    local playerid = 0
    local contract_status = 0
    local is_loaned_in = false
    local contract_date = 0
    local last_status_change_date = 0
    local contractvaliduntil = 0
    while current_record > 0 do
        contract_status = career_playercontract_table:GetRecordFieldValue(current_record, "contract_status")
        is_loaned_in = (contract_status == 1) or (contract_status == 3) or (contract_status == 5)

        -- Ignore players that are loaned in
        if not is_loaned_in then
            contract_date = career_playercontract_table:GetRecordFieldValue(current_record, "contract_date")
            last_status_change_date = career_playercontract_table:GetRecordFieldValue(current_record, "last_status_change_date")

            -- Set contract date to current date
            if contract_date < int_current_date then
                career_playercontract_table:SetRecordFieldValue(current_record, "contract_date", int_current_date)
            end

            -- last_status change date to current date
            if last_status_change_date < int_current_date then
                career_playercontract_table:SetRecordFieldValue(current_record, "last_status_change_date", int_current_date)
            end

            career_playercontract_table:SetRecordFieldValue(current_record, "duration_months", new_contract_length)

            contractvaliduntil = currentdate.year + math.floor(new_contract_length / 12)

            playerid = career_playercontract_table:GetRecordFieldValue(current_record, "playerid")
            result[playerid] = contractvaliduntil
        end

        current_record = career_playercontract_table:GetNextValidRecord()
    end

    return result
end

update_contractvaliduntil(update_contracts())
LOGGER:LogInfo("Done")