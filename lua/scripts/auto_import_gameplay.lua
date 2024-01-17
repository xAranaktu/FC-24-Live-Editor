-- Put this file in C:\FC 24 Live Editor\mods\lua_autorun and restart the game

-- This script Load Gameplay cofiguration from C:\FC 24 Live Editor\AttribDBRuntime_gameplayattribdb.json

function LEInitDone__OnEvent()
    LE.gameplay_attribulator_manager:LoadFromFile()
end

AddEventHandler("LEInitDoneEvent", LEInitDone__OnEvent)
