require 'imports/core/consts' 

local DATE = {}

function DATE:new()
    local o = setmetatable({}, self)

    -- lua metatable
    self.__index = self
    self.__name = "FC::DATE"

    -- From imports\core\consts.lua
    self.day = DEFAULT_DAY
    self.month = DEFAULT_MONTH
    self.year = DEFAULT_YEAR

    return o
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

-- Convert days to date
-- Used by playerjointeamdate and birthdate fields in players table
function DATE:FromGregorianDays(days)
    local a, b, c, d, e, m
    a = days + 2331205
    b = math.floor((4*a+3)/146097)
    c = math.floor((-b * 146097 / 4) + a)
    d = math.floor((4 * c + 3)/1461)
    e = math.floor(-1461 * d / 4 + c)
    m = math.floor((5*e+2)/153)
    
    self.day = math.ceil(-(153 * m + 2) / 5) + e + 1
    self.month = math.ceil(-m / 10) * 12 + m + 3
    self.year = b * 100 + d - 4800 + math.floor(m / 10)
end

function DATE:ToGregorianDays()
    local a = math.floor((14 - self.month) / 12)
    local m = self.month + 12 * a - 3;
    local y = self.year + 4800 - a;
    return self.day + math.floor((153 * m + 2) / 5) + y * 365 + math.floor(y/4) - math.floor(y/100) + math.floor(y/400) - 2331205;
end

return DATE;
