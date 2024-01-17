MEMORY = require 'imports/core/memory'
LOGGER = require 'imports/core/logger'

local FIELD = require 'imports/t3db/field'
local TABLE = {}

function TABLE:new(o)
    local o = setmetatable({}, self)

    -- lua metatable
    self.__index = self
    self.__name = "T3DB::TABLE"

    self:Init()

    return o
end

---
-- Initialize Members
function TABLE:Init()
    self.name = ""
    self.shortname = ""
    self.fields = nil       -- It's self.fields = {}, but why it doesn't work here?
    self.first_record = 0
    self.record_size = 0
    self.written_records = 0

    self.last_record_idx = 0
    self.current_record_idx = 1
end


function TABLE:HasNoName()
    return self.name == nil or self.name == ""

end

function TABLE:GetFieldsCount()
    local fld_count = 0
    for k,v in pairs(self.fields) do
        fld_count = fld_count + 1
    end

    return fld_count
end


function TABLE:AddField(field, fld_meta)
    local fld = FIELD:new()
    fld:Load(field, fld_meta)

    -- LOGGER:LogDebug(string.format(
    --      "[TABLE:AddField] %s %s %s",
    --      self.name, fld.name, tostring(fld)
    -- ))

    self.fields[fld.name] = fld
end

function TABLE:LoadShortname(addr)
    local shortname_bytes = MEMORY:ReadBytes(addr + 0x40, 4)
    for i=1, 4 do
        local ch = string.char(shortname_bytes[i])
        self.shortname = self.shortname .. ch
    end
end

function TABLE:LoadName(meta)
    self.name = meta.shortname_name_tables_map[self.shortname]
end


function TABLE:Load(addr, meta)
    self:LoadShortname(addr)
    self:LoadName(meta)

    if self:HasNoName() then return end

    self.first_record = MEMORY:ReadQword(addr + 0x30)
    self.record_size = MEMORY:ReadInt(addr + 0x44)
    self.written_records = MEMORY:ReadShort(addr + 0x7C)
    self.last_record_idx = self.written_records - 1

    local col_count = MEMORY:ReadChar(addr + 0x82)
    local col_addr = addr + 0x84
    
    -- LOGGER:LogDebug(string.format(
    --     "[TABLE* 0x%X] %s (%s), col_count = %d",
    --     addr, self.name, self.shortname, col_count 
    -- ))

    local fld_meta = meta.field_desc_map[self.shortname]
    if fld_meta == nil then return end
    --print("Adding Fields")
    self.fields = {}
    for i=1, col_count do
         self:AddField(col_addr, fld_meta)
         col_addr = col_addr + 0x10
    end
    -- LOGGER:LogDebug(string.format("Added Fields: %d", self:GetFieldsCount()))
end

function TABLE:IsRecordValid(record)
    local last_byte = MEMORY:ReadBytes(record + self.record_size - 1, 1)[1]
    return (last_byte & 0x80) == 0
end

function TABLE:GetFirstRecord()
    self.current_record_idx = 0

    local current_record = self.first_record + (self.record_size * self.current_record_idx)

    if not self:IsRecordValid(current_record) then
        current_record = self:GetNextValidRecord()
    end

    return current_record
end

function TABLE:GetNextRecord()
    self.current_record_idx = self.current_record_idx + 1

    return self.first_record + (self.record_size * self.current_record_idx)
end

function TABLE:GetNextValidRecord()
    local current_record = 0
    while self.current_record_idx < self.last_record_idx do
        local rec = self:GetNextRecord()

        if self:IsRecordValid(rec) then
            current_record = rec
            break
        end
    end

    return current_record
end

function TABLE:GetField(field_name)
    return self.fields[field_name]
end

function TABLE:GetRecordFieldValue(record_addr, field_name)
    -- LOGGER:LogDebug(string.format("GetRecordFieldValue 0x%X, %s", record_addr, field_name))
    local fld = self:GetField(field_name)
    if fld == nil then
        LOGGER:LogError(string.format("GetRecordFieldValue no field %s in table %s", field_name, self.name))
        return nil
    end

    return fld:GetValue(record_addr)
end

function TABLE:SetRecordFieldValue(record_addr, field_name, v)
    local fld = self:GetField(field_name)
    if fld == nil then
        LOGGER:LogError(string.format("SetRecordFieldValue no field %s in table %s", field_name, self.name))
        return false
    end

    return fld:SetValue(record_addr, v)
end


return TABLE;
