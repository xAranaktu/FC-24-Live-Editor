function split(s, delimiter)
    local result = {};
    for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match);
    end
    return result;
end

function readCSV(filename)
    local file = io.open(filename, "r")
    if not file then
        error("Failed to open file: " .. filename)
    end

    local header = file:read()
    local headerArr = split(header, ",")
    print("length of headerArr: " .. #headerArr)
    for i, value in ipairs(headerArr) do
        print(i, value)
    end

    local data = {}

    for line in file:lines() do
        line = line:gsub("\n", ""):gsub("\r", "")
        print("line: " .. line)
        local valuesArr = split(line, ",")
        print("length of valuesArr: " .. #valuesArr)

        for i, value in ipairs(valuesArr) do
            -- print(i, value)
        end

        local entry = {}

        for i = 1, #valuesArr do
            print("headerArr[" .. i .. "]:" .. headerArr[i])
            print("valuesArr[" .. i .. "]:" .. valuesArr[i])
            -- print("headerArr[" .. i .. "] key = '" .. headerArr[i] .. "' , value = " .. valuesArr[i])
            print(string.format("headerArr[%d] key = '%s' , value = '%s'", i, headerArr[i], valuesArr[i]))
            print("-------------------------------------------------")
        end

        for key, value in pairs(entry) do
            -- print(">>> Entry[" .. key .. "]: " .. value)
        end

        -- table.insert(data, entry)
    end

    file:close()

    return data
end

-- Usage example
local filename = "./FC_24_LE_ICONS__2.csv"
local data = readCSV(filename)

-- Print the data
for i, entry in ipairs(data) do
    for header, value in pairs(entry) do
        print(header .. ": " .. value)
    end
    print("--------------------")
end
