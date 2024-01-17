MEMORY = require 'imports/core/memory'
LOGGER = require 'imports/core/logger'

require 'imports/services/enums'

local TABLE = require 'imports/t3db/table'
local DB = {}

function DB:new()
    local o = setmetatable({}, self)

    -- lua metatable
    self.__index = self
    self.__name = "T3DB::DATABASE"

    self:Init()

    return o
end

---
-- Initialize Members
function DB:Init()
    self.meta_loaded = false
    self.db_service = 0
    self.tables_count = 0
    self.meta = {}
    self.tables = {}
end

function DB:LoadMeta()
    if self.meta_loaded == true then return end

    self.meta = GetDBMeta()
    self.meta_loaded = true
end

function DB:GetDBService()
    if self.db_service <= 0 then
        local db_service = GetPlugin(ENUM_djb2Database_CLSS) - 8    -- weakptr
        -- LOGGER:LogDebug(string.format("DBService* = 0x%X", db_service))
        self.db_service = db_service
    end

    return self.db_service
end

function DB:GetDBFromService()
    return MEMORY:ReadMultilevelPointer(self:GetDBService(), {0x20, 0x08, 0x10})
end

function DB:GetTableFromDB(cur_db)
    return MEMORY:ReadPointer(cur_db + 0x10)
end

function DB:GetNextTable(cur_tbl)
    return MEMORY:ReadPointer(cur_tbl + 0x08)
end

function DB:GetNextDB(cur_db)
    return MEMORY:ReadPointer(cur_db + 0x18)
end

function DB:GetT3DBTableName(t3db_table)
    local tbl = TABLE:new()
    tbl:LoadShortname(t3db_table)
    tbl:LoadName(self.meta)

    return tbl.name
end

function DB:AddTable(table)
    local tbl = TABLE:new()
    tbl:Load(table, self.meta)

    if tbl:HasNoName() then return end

    self.tables[tbl.name] = tbl
    self.tables_count = self.tables_count + 1
end

function DB:GetTable(table_name)
    self:LoadMeta()

    local db = self:GetDBFromService()
    local db_tbl = {}
    local tbl = nil

    while db > 0 do
        if tbl ~= nil then break end

        db_tbl = self:GetTableFromDB(db)
        while db_tbl > 0 do
            if tbl ~= nil then break end

            if self:GetT3DBTableName(db_tbl) == table_name then
                tbl = TABLE:new()
                tbl:Load(db_tbl, self.meta)
            end

            db_tbl = self:GetNextTable(db_tbl)
        end

        db = self:GetNextDB(db)
    end

    return tbl
end

function DB:Load()
    self:LoadMeta()
    local db = self:GetDBFromService()
    local db_tbl = {}

    while db > 0 do
        -- LOGGER:LogDebug(string.format("DB* = 0x%X", db))
        db_tbl = self:GetTableFromDB(db)
        while db_tbl > 0 do
            --LOGGER:LogDebug(string.format("DB::Table* = 0x%X", db_tbl))
            self:AddTable(db_tbl)
            db_tbl = self:GetNextTable(db_tbl)   
        end

        db = self:GetNextDB(db)
    end

    -- LOGGER:LogDebug("DB Init Done")
end

function DB:Reset()
    self.tables_count = 0
    self.tables = {}
    self:Load()
end

return DB;