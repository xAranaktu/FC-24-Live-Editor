function pre__TestCaseEventHandler1(i1, i2, p3)
    LOGGER:LogInfo("pre__TestCaseEventHandler1")
    local v_int = LE.MEMORY:ReadInt(p3)
    LOGGER:LogInfo(string.format("%d %d %d (0x%X)", i1, i2, v_int, p3))
    
    LE.MEMORY:WriteInt(p3, 9999)
end

function pre__TestCaseEventHandler2(i1, i2, p3)
    LOGGER:LogInfo("pre__TestCaseEventHandler2")
end

function post__TestCaseEventHandler1(i1, i2, psomeint, result)
    LOGGER:LogInfo("post__TestCaseEventHandler")
    
    local v_int = LE.MEMORY:ReadInt(result)
    LOGGER:LogInfo(string.format("%d %d result %d (0x%X)", i1, i2, v_int, result))
    
    LE.MEMORY:WriteInt(result, 16161)
end

function post__TestCaseEventHandler2(i1, i2, psomeint, result)
    LOGGER:LogInfo("post__TestCaseEventHandler")
    
    local v_int = LE.MEMORY:ReadInt(result)
    LOGGER:LogInfo(string.format("%d %d result %d (0x%X)", i1, i2, v_int, result))
    
    LE.MEMORY:WriteInt(result, 16161)
end

function post__TestCaseEventHandler3(i1, i2, psomeint, result)
    LOGGER:LogInfo("post__TestCaseEventHandler")
    
    local v_int = LE.MEMORY:ReadInt(result)
    LOGGER:LogInfo(string.format("%d %d result %d (0x%X)", i1, i2, v_int, result))
    
    LE.MEMORY:WriteInt(result, 16161)
end

-- LOGGER:LogInfo("ClearEventHandlersForEvent")
ClearEventHandlersForEvent("pre__TestCaseEvent")
ClearEventHandlersForEvent("post__TestCaseEvent")

-- LOGGER:LogInfo("AddEventHandler")
AddEventHandler("pre__TestCaseEvent", pre__TestCaseEventHandler1)
AddEventHandler("pre__TestCaseEvent", pre__TestCaseEventHandler2)
AddEventHandler("post__TestCaseEvent", post__TestCaseEventHandler1)
AddEventHandler("post__TestCaseEvent", post__TestCaseEventHandler2)
AddEventHandler("post__TestCaseEvent", post__TestCaseEventHandler3)
AddEventHandler("post__TestCaseEvent", post__TestCaseEventHandler3) -- Same func, shouldn't be added

-- LOGGER:LogInfo("GetEventHandlers")
local pre = GetEventHandlers("pre__TestCaseEvent")

assert(type(pre) == "table", string.format("GetEventHandlers pre__TestCaseEvent, %s != table", type(pre)) )
assert(#pre == 2, string.format("GetEventHandlers pre__TestCaseEvent size, %d != 2", #pre) )

local post = GetEventHandlers("post__TestCaseEvent")
assert(#post == 3, string.format("GetEventHandlers post__TestCaseEvent size, %d != 3", #post) )

RemoveEventHandler("post__TestCaseEvent", post[1].id)

post = GetEventHandlers("post__TestCaseEvent")
assert(#post == 2, string.format("RemoveEventHandler post__TestCaseEvent size, %d != 2", #post) )

ClearEventHandlersForEvent("post__TestCaseEvent")
post = GetEventHandlers("post__TestCaseEvent")
assert(#post == 0, string.format("ClearEventHandlersForEvent post__TestCaseEvent size, %d != 0", #post) )
