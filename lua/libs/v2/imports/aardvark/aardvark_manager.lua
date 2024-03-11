local AardvarkManager = {}

function AardvarkManager:new()
    local o = setmetatable({}, self)

    -- lua metatable
    self.__index = self
    self.__name = "AardvarkManager"

    return o
end

function AardvarkManager:SetInt(key, value)
    AardvarkSetInt(key, value)
end

function AardvarkManager:SetFloat(key, value)
    AardvarkSetFloat(key, value)
end

function AardvarkManager:SetString(key, value)
    AardvarkSetString(key, value)
end

function AardvarkManager:GetInt(key)
    return AardvarkGetInt(key)
end

function AardvarkManager:GetFloat(key)
    return AardvarkGetFloat(key)
end

function AardvarkManager:GetString(key)
    return AardvarkGetString(key)
end



return AardvarkManager;