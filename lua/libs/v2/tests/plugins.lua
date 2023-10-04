require 'imports/services/enums'

db = GetPlugin(ENUM_djb2Database_CLSS)

LOGGER:LogInfo(string.format("%X", db))
