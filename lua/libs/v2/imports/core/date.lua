require 'imports/core/consts' 

local DATE = {}

function DATE:new()
    o = o or {}
    setmetatable(o, self)

    -- lua metatable
    self.__index = self
    self.__name = "FC::DATE"

    -- From imports\core\consts.lua
    self.day = DEFAULT_DAY
    self.month = DEFAULT_MONTH
    self.year = DEFAULT_YEAR

    return o;
end

-- Convert from int date to DATE
-- for example 20230503 to:
-- self.day = 3
-- self.month = 5
-- self.year = 2023
function DATE:FromInt(int_date)
    self.day = math.floor(int_date % 100)
    self.month = math.floor((int_date % 10000) / 100)
    self.year = math.floor(int_date / 10000)
end

-- Convert from DATE to int
-- For example:
-- self.day = 3
-- self.month = 5
-- self.year = 2023
-- to: 20230503
function DATE:ToInt()
    return self.year * 10000 + self.month * 100 + self.day
end

-- Convert Date To String, by default to DD/MM/YYYY
function DATE:ToString()
    return string.format("%02d/%02d/%04d", self.day, self.month, self.year)
end


return DATE;
