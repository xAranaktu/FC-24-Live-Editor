-- LOGGER TEST (kind of)
LOGGER:LogDebug("TEST LogDebug")
LOGGER:LogInfo("TEST LogInfo")
LOGGER:LogWarn("TEST LogWarn")
LOGGER:LogError("TEST LogError")
LOGGER:LogFatal("TEST LogFatal")

-- MEMORY TEST
-- TODO: Read base addr from Process
local game_base_addr = 0x140000000
local result = 0;

-- Should be PE Header
result = MEMORY:ReadBytes(game_base_addr, 2)
assert(result[1] == 0x4D, string.format("ReadBytes Test, 0x%X != 0x4D", result[1]))
assert(result[2] == 0x5A, string.format("ReadBytes Test, 0x%X != 0x5A", result[2]))

result = MEMORY:ReadInt(game_base_addr)
assert(result == 9460301, string.format("ReadInt Test, %d != 9460301", result))

result = MEMORY:ReadQword(game_base_addr)
assert(result == 12894362189, string.format("ReadQword Test, %d != 12894362189", result))

-- AOB TEST
result = MEMORY:AOBScanGameModule("4C 8B 3D ?? ?? ?? ?? 4D 85 FF 0F 84 ?? ?? ?? ?? 0F 1F 44 00 ??")
assert(result > 0, string.format("AOB Test1, 0x%X <= 0", result))

result  = MEMORY:ResolvePtr(result, 3)
assert(result > 0, string.format("ResolvePtr Test1, 0x%X <= 0", result))
