local MEMORY = {}

-- Writing to process memory

function MEMORY:WriteBytes(_address, _value)
	return WriteBytes(_address, _value)
end

function MEMORY:WriteShort(_address, _value)
	return WriteShort(_address, _value)
end

function MEMORY:WriteInt(_address, _value)
	return WriteInteger(_address, _value)
end

function MEMORY:WriteFloat(_address, _value)
	return WriteFloat(_address, _value)
end

function MEMORY:WriteQword(_address, _value)
    return WriteQword(_address, _value)
end

function MEMORY:WriteString(_address, _value)
	return WriteString(_address, _value)
end

-- Reading from process memory

function MEMORY:ReadBytes(addr, count)
	return ReadBytes(addr, count)
end

function MEMORY:ReadChar(addr)
	return ReadBytes(addr, 1)[1]
end

function MEMORY:ReadBool(addr)
	return ReadChar(addr) > 0
end

function MEMORY:ReadShort(addr)
	return ReadShort(addr)
end

function MEMORY:ReadInt(addr)
	return ReadInteger(addr)
end

function MEMORY:ReadFloat(addr)
	return ReadFloat(addr)
end

function MEMORY:ReadQword(addr)
	return ReadQword(addr)
end

function MEMORY:ReadPointer(addr)
    return ReadQword(addr)
end

function MEMORY:ReadString(addr, strlen)
	return ReadString(addr, strlen)
end

function MEMORY:ReadMultilevelPointer(base_addr, offsets)
    for i=1, #offsets do
        if base_addr == 0 or base_addr == nil then
            return 0
        end
        base_addr = ReadQword(base_addr+offsets[i])
    end
    return base_addr
end

function MEMORY:AOBScanGameModule(aob)
    return AOBScan(LE_GAME_MODULE_BASE, LE_GAME_MODULE_SIZE, aob)
end

function MEMORY:AOBScanRegion(module_base_addr, module_size, aob)
    return AOBScan(module_base_addr, module_size, aob)
end

function MEMORY:ResolvePtr(addr, start)
    if type(addr) ~= "number" then
        addr = tonumber(addr, 16)
    end

    local relative_offset = 0
    local n_bytes = 4
    local bytes = ReadBytes(addr+start, n_bytes)
    
    for i=n_bytes, 1, -1 do
        relative_offset = (relative_offset << 8) + bytes[i]
    end

    return relative_offset + addr + start + 4
end

return MEMORY;