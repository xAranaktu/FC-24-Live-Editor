
-- Test Float

-- Getter
local GC_GRAY_ZONE_WIDTH = LE.aardvark_manager:GetFloat("GC_GRAY_ZONE_WIDTH")
assert(GC_GRAY_ZONE_WIDTH == 16.0, string.format("GC_GRAY_ZONE_WIDTH %.2f != 16.0", GC_GRAY_ZONE_WIDTH))

-- Setter
LE.aardvark_manager:SetFloat("GC_GRAY_ZONE_WIDTH", 33.0)
GC_GRAY_ZONE_WIDTH = LE.aardvark_manager:GetFloat("GC_GRAY_ZONE_WIDTH")
assert(GC_GRAY_ZONE_WIDTH == 33.0, string.format("GC_GRAY_ZONE_WIDTH %.2f != 33.0", GC_GRAY_ZONE_WIDTH))

-- Test Int

-- Getter
local ENABLE_HAND = LE.aardvark_manager:GetInt("ENABLE_HAND")
assert(ENABLE_HAND == 1, string.format("ENABLE_HAND %d != 1", ENABLE_HAND))

-- Setter
LE.aardvark_manager:SetInt("ENABLE_HAND", 0)
ENABLE_HAND = LE.aardvark_manager:GetInt("ENABLE_HAND")
assert(ENABLE_HAND == 0, string.format("ENABLE_HAND %d != 0", ENABLE_HAND))

-- Test String

-- Getter
local REG_CURRENCY_TYPE = LE.aardvark_manager:GetString("REGIONALIZATION_TUR_TR/CURRENCY_TYPE")
assert(REG_CURRENCY_TYPE == "EUROS", string.format("REG_CURRENCY_TYPE %s != EUROS", REG_CURRENCY_TYPE))

-- Setter
LE.aardvark_manager:SetString("REGIONALIZATION_TUR_TR/CURRENCY_TYPE", "AAA")
REG_CURRENCY_TYPE = LE.aardvark_manager:GetString("REGIONALIZATION_TUR_TR/CURRENCY_TYPE")
assert(REG_CURRENCY_TYPE == "AAA", string.format("REG_CURRENCY_TYPE %s != AAA", REG_CURRENCY_TYPE))

LE.aardvark_manager:SetString("REGIONALIZATION_TUR_TR/CURRENCY_TYPE", "MUCHLONGERSTRINGMUCHLONGERSTRING")
REG_CURRENCY_TYPE = LE.aardvark_manager:GetString("REGIONALIZATION_TUR_TR/CURRENCY_TYPE")
assert(REG_CURRENCY_TYPE == "MUCHLONGERSTRINGMUCHLONGERSTRING", string.format("REG_CURRENCY_TYPE %s != MUCHLONGERSTRINGMUCHLONGERSTRING", REG_CURRENCY_TYPE))

-- Restore default values
LE.aardvark_manager:SetFloat("GC_GRAY_ZONE_WIDTH", 16.0)
LE.aardvark_manager:SetInt("ENABLE_HAND", 1)
LE.aardvark_manager:SetString("REGIONALIZATION_TUR_TR/CURRENCY_TYPE", "EUROS")
