MEMORY = require 'imports/core/memory'
LOGGER = require 'imports/core/logger'
local DB = require 'imports/t3db/db'
local GameplayAttribulatorManager = require 'imports/gameplay/gp_attribulator_manager'
local PLAYERS_MANAGER = require 'imports/core/managers/players_manager'

local LIVE_EDITOR = {}

function LIVE_EDITOR:new()
    local o = setmetatable({}, self)

    -- lua metatable
    self.__index = self
    self.__name = "LIVE_EDITOR"

    -- 
    self.version = ""
    self.data_path = ""
    self.game_base = 0
    self.game_size = 0
    self.game_name = ""

    -- DB
    self.db = DB:new()

    -- Gameplay Attribulator Manager
    self.gameplay_attribulator_manager = GameplayAttribulatorManager:new()

    -- Players Manager
    self.players_manager = PLAYERS_MANAGER:new()

    -- config.json
    self.config = {}

    self:Init()

    return o
end

function LIVE_EDITOR:Init()
    LOGGER:LogInfo("Init LIVE EDITOR LUA API V2")
    self.version = LE_VERSION
    self.data = LE_DATA_PATH
    self.game_base = LE_GAME_MODULE_BASE
    self.game_size = LE_GAME_MODULE_SIZE
    self.game_name = LE_GAME_MODULE_NAME

    self.gameplay_attribulator_manager:Init()
    self.players_manager:Init(self.db)
end

function LIVE_EDITOR:Load()
    LOGGER:LogInfo(string.format("Load LIVE EDITOR %s LUA API V2", self.version))
end

return LIVE_EDITOR;