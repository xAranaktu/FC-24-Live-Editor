local GameplayAttribulatorManager = {}

function GameplayAttribulatorManager:new()
    local o = setmetatable({}, self)

    -- lua metatable
    self.__index = self
    self.__name = "GameplayAttribulatorManager"

    return o
end

function GameplayAttribulatorManager:Init()
    -- LOGGER:LogInfo("Init GameplayAttribulatorManager")
end

-- Import gameplayattribdb from json file
-- By default from "C:\FC 24 Live Editor\AttribDBRuntime_gameplayattribdb.json"
function GameplayAttribulatorManager:LoadFromFile(file_path)
    GameplayAttribulatorLoadFromFile(file_path or "")
end

-- Export gameplayattribdb to json file
-- By default to "C:\FC 24 Live Editor\AttribDBRuntime_gameplayattribdb.json"
function GameplayAttribulatorManager:SaveToFile(file_path)
    GameplayAttribulatorSaveToFile(file_path or "")
end

-- Set Float value by item path
function GameplayAttribulatorManager:SetFloatValue(path, value)
    GameplayAttribulatorSetFloat(path, value)
end

-- Set Int value by item path
function GameplayAttribulatorManager:SetIntValue(path, value)
    GameplayAttribulatorSetInt(path, value)
end

-- Set Bool value by item path
function GameplayAttribulatorManager:SetBoolValue(path, value)
    local v = 0
    if (value) then 
        v = 1 
    end

    GameplayAttribulatorSetBool(path, v)
end

-- Get Float value by item path
function GameplayAttribulatorManager:GetFloatValue(path)
    return GameplayAttribulatorGetFloat(path)
end

-- Get Int value by item path
function GameplayAttribulatorManager:GetIntValue(path)
    return GameplayAttribulatorGetInt(path)
end

-- Get Bool value by item path
function GameplayAttribulatorManager:GetBoolValue(path)
    return GameplayAttribulatorGetBool(path)
end

return GameplayAttribulatorManager;
