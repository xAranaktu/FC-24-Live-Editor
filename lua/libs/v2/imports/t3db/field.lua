MEMORY = require 'imports/core/memory'
LOGGER = require 'imports/core/logger'
local FIELD = {}

function FIELD:new()
    local o = setmetatable({}, self)

    -- lua metatable
    self.__index = self
    self.__name = "T3DB::FIELD"

    self:Init()

    return o
end

---
-- Initialize Members
function FIELD:Init()
    self.name = ""
    self.shortname = ""

    self.type = 0
    self.offset = 0
    self.sz = 0
    self.fld_desc = {}
end

function FIELD:HasNoName()
    return self.name == nil or self.name == ""
end

function FIELD:LoadShortname(addr)
    local shortname_bytes = MEMORY:ReadBytes(addr + 0x8, 4)
    for i=1, 4 do
        local ch = string.char(shortname_bytes[i])
        self.shortname = self.shortname .. ch
    end
end

function FIELD:Load(addr, fld_meta)
    self:LoadShortname(addr)

    self.fld_desc = fld_meta[self.shortname]
    self.name = self.fld_desc.name

    self.type = MEMORY:ReadInt(addr)

    local bit_offset = MEMORY:ReadInt(addr + 0x4)

    self.offset = math.floor(bit_offset / 8)
    self.startbit = math.floor(bit_offset % 8)
    self.sz = MEMORY:ReadInt(addr + 0xc)

    -- LOGGER:LogDebug(string.format(
    --     "[FIELD* 0x%X] %s (%s)",
    --     addr, self.name, self.shortname 
    -- ))
end

function FIELD:GetInt(record_addr)
    local v = MEMORY:ReadQword(record_addr + self.offset)
    local a = v >> self.startbit
    local b = (1 << self.fld_desc.depth) - 1

    return (a & b) + self.fld_desc.min
end

function FIELD:SetInt(record_addr, new_value)
    local addr = record_addr + self.offset
    local v = MEMORY:ReadQword(addr) 

    new_value = new_value - self.fld_desc.min

    local depth = self.fld_desc.depth - 1

    for i=0, depth do
        local currentbit = self.startbit + i
        local is_set = (new_value >> i) & 1

        if is_set == 1 then
            v = v | (1 << currentbit)
        else
            v = v & ~(1 << currentbit)
        end
    end
    MEMORY:WriteQword(addr, v)
    return true
end

function FIELD:GetFloat(record_addr)
   return string.unpack("f", string.pack("i4", self:GetInt(record_addr)))
end

function FIELD:SetFloat(record_addr, new_value)
    return self:SetInt(record_addr, string.unpack("i4", string.pack("f", new_value)))
end

function FIELD:GetString(record_addr)
    return MEMORY:ReadString(record_addr + self.offset)
end

function FIELD:SetString(record_addr, new_value)
    local string_max_len = math.floor(self.fld_desc.depth / 8)
    local new_val_len = string.len(new_value)
    if new_val_len > string_max_len then
        new_value = new_value:sub(1, new_val_len - string_max_len)
        new_val_len = string.len(new_value)
    end
    MEMORY:WriteString(addr, new_value)
    -- fill with null bytes
    for i=new_val_len, string_max_len-1 do
        MEMORY:WriteBytes(addr+i, 0)
    end
end

function FIELD:GetValue(record_addr)
    if self.type == 3 then
        return self:GetInt(record_addr)
    elseif self.type == 4 then
        return self:GetFloat(record_addr)
    elseif self.type == 0 then
        return self:GetString(record_addr)
    end

    return nil
end

function FIELD:SetValue(record_addr, v)
    if self.type == 3 then
        return self:SetInt(record_addr, v)
    elseif self.type == 4 then
        return self:SetFloat(record_addr, v)
    elseif self.type == 0 then
        return self:SetString(record_addr, v)
    end

    return false
end

return FIELD;
