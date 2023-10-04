local LOGGER = {}

function LOGGER:LogDebug(_text)
    Log(_text, 0)
end

function LOGGER:LogInfo(_text)
    Log(_text, 1)
end

function LOGGER:LogWarn(_text)
    Log(_text, 2)
end

function LOGGER:LogError(_text)
    Log(_text, 3)
end

function LOGGER:LogFatal(_text)
    Log(_text, 4)
end


return LOGGER;