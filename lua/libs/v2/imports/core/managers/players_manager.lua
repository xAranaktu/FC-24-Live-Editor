local PLAYERS_MANAGER = {}

function PLAYERS_MANAGER:new()
    local o = setmetatable({}, self)

    -- lua metatable
    self.__index = self
    self.__name = "PLAYERS_MANAGER"

    self.db = nil

    return o
end

function PLAYERS_MANAGER:Init(db)
    self.db = db
end

function PLAYERS_MANAGER:GetPlayerName(playerid)
    return "GetPlayerName"
end


return PLAYERS_MANAGER;