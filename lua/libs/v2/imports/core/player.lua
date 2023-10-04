local PLAYER = {}

function PLAYER:new()
    o = o or {}
    setmetatable(o, self)

    -- lua metatable
    self.__index = self
    self.__name = "PLAYER"

    self.playerid = -1
    self.month = DEFAULT_MONTH
    self.year = DEFAULT_YEAR

    return o;
end

return PLAYER;